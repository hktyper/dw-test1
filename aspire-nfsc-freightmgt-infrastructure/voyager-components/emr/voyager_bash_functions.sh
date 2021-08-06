# This bash script contains bash functions for tasks used repeatedly throughout the voyager CI/CD
# pipline. `source ./path/voyager_bash_functions.sh` should be used to initalise/load these functions
# into your current shell session so they can be used.

IFS=$'\n'
# Setting this variable as a newline ensures that iterables with in an iterator as seperated using
# a newline rather than the default seperator

set_environment_variables() {
  source ./voyager_scripts/voyager_bash_functions.sh
  # path to master configuration file
  tfvars_path=$(ls -d ./tfvars/use_cases/$TF_VAR_environment/* | head -n 1)
  echo "$tfvars_path"
  # setting environment variables unique to the use case of interest
  set_pipeline_env "$tfvars_path"
}

install_dependencies() {
  # This package allows the pipeline to manipulate json using a cli
  # if statement required in order to cater for the two images that run during the workflow

  if [[ $(python -V | grep 'Python 3.7.9') == "Python 3.7.9" ]]; then
    sudo apt-get update -y
    sudo apt-get install -y bc
  else
    apk add py-pip python3-dev jq curl
  fi
}

set_pipeline_env() {
  # Inputs:
  #     - $1: path to voyager master configuration file

  # This function is designed to work with the master configuration file for voyager, the
  # configuration file must be a json file. The configuration file must also have pipeline_env
  # as a field at the highest level and value for pipeline_env must be a json object.

  # This function will iterate through each field in pipeline_env and set the key as the
  # environment variable name and the value as the value for that environment variable.
  for s in $(echo $values | jq .pipeline_env $1 | jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]'); do
    export $s
    done
}

write_nested_json_object() {
  # Inputs:
  #     - $1: A field within the json object in which the value is a json object e.g a or a.b.a
  #     - $2: path to a json file
  #     - $3: path you want to write the nested json object to

  # This function takes a json file, extracts a nested json object (this is specifed) and
  # writes this to a specified path.
  jq .$1 $2 > $3
}

add_json_field() {
  # Inputs:
  #     - $1: key of the json field you want to add
  #     - $2: value of the json field you want to add
  #     - $3: path to the json file you want to append a json field to

  # This function takes a json file and appends a json field to the file at the highest level.
  # The key and value of the field can be specifed by the user.
  contents="$(jq -M --arg value $2 '. + {'$1': $value}' $3)" && echo "$contents" >$3
}

create_zips() {
  # Cloning the voyager-app repository and creating voyager-app-snapshot.zip
  # TODO: Add in git clone of the voyager-app repo with specified version (Probably need to add some vars to do this)
  mkdir -p voyager-artefacts/
  git clone --single-branch --branch $repo_branch git@$repo_url
  cd voyager-app || exit
  pip3 install wheel
  # Running setup.py to package required file for EMR Lambda
  python3 setup.py package_for_emr
  cp voyager_app/etl/main.py ../voyager-artefacts/
  cp .snapshots/voyager-app-snapshot.zip ../voyager-artefacts
  cd ../voyager-artefacts
  # Packaging EMR lambda from the voyager app and preparing the zip for upload
  mkdir emr-lambda
  mkdir emr-lambda/voyager_app
  cp ../voyager-app/voyager_app/aws_lambda/create_emr_step.py emr-lambda
  cp -R ../voyager-app/voyager_app/aws_lambda emr-lambda/voyager_app/aws_lambda
  cp -R ../voyager-app/voyager_app/utils emr-lambda/voyager_app/utils
  cd emr-lambda
  zip -r9 ../lambda-emr.zip .
  cd ..
  rm -R emr-lambda
  cd ..
}

get_json_field() {
  # This retrieves values from the master tfvars files
  cat $tfvars | jq $1 | tr -d \"
}

upload_artefacts() {
  # TODO: Integrate/hook up with voyager-app component
  # This retrieves values from the master tfvars files for each usecase and creates an ETL Config file, a schema file and
  # adds regex path to map data file to etl configuration file within regex-to-config.yaml
  # Automated creation of template file
  extravars=extra_vars.json
  regex_prefix=$(get_json_field .inputs.regex_prefix[$1])
  echo "REGEX PREFIX IS $regex_prefix"
  altered_regex_prefix=$(echo "$regex_prefix" | tr / -)
  # etl configuration file
  config_path=voyager-artefacts/$project_name-$altered_regex_prefix-config.yaml
  template_contents=$(cat $extravars | jq .etl_config | jq --arg k "$regex_prefix" '.[$k]')
  echo $template_contents | yq --yaml-output . | tee $config_path
  echo INPUT_STRUCT_SCHEMA_JSON_PATH : s3://$environment-voyager-artefacts-$project_name/$project_name-$altered_regex_prefix-schema.json >>$config_path

  # schema
  cat $extravars | jq .schema | jq --arg k "$regex_prefix" '.[$k]' | tee voyager-artefacts/$project_name-$altered_regex_prefix-schema.json
  # Automate addition to regex-to-config.yaml
  transfer_bucket="s3://$environment-raw-transfer-src-$project_name/"
  data_file_regex="$transfer_bucket$regex_prefix."
  template_file="s3://$environment-voyager-artefacts-$project_name/$project_name-$altered_regex_prefix-config.yaml"
  echo $data_file_regex : $template_file >>voyager-artefacts/regex-to-config.yaml
  # dq_rules
  #echo ROBOCROP_DQ_FILE_PATH : s3://$TF_VAR_environment-voyager-artefacts-$project_name/$project_name-$altered_regex_prefix-dq_rules.json >>$config_path
  #cat $tfvars | jq .dq_rules | jq --arg k "$regex_prefix" '.[$k]' | tee voyager-artefacts/$project_name-$altered_regex_prefix-dq_rules.json
}

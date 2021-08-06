# This script creates all voyager artefacts needed and adds them to the local directory voyager-artefacts
# The terraform within main.tf will then upload these files to the voyager-artefacts s3 bucket.

# TODO Handle recreating files locally in docker to the aws s3 bucket
# as terraform doesn't checksum the file and update it
source ./voyager_bash_functions.sh

# Clean out voyager-artefacts directory to allow for rerunning
rm -rf ./voyager-artefacts

tfvarsfile=terragrunt.hcl.json
for tfvars in $tfvarsfile
do  
  toggledeployment=$(cat $tfvars | jq -r ".inputs.deploy_voyager_app")
  if [ $toggledeployment == true ]; then

    # Setup some variables
    project_name=$(get_json_field '.inputs.project_name')
    environment=$(get_json_field '.inputs.environment')
    repo_url=$(get_json_field '.inputs.voyager_app_repo')
    repo_branch=$(get_json_field '.inputs.voyager_app_branch')

    # Append some values to tfvars for spark
    cat $tfvars | jq  ".inputs.lambda_environment_variables |= . + {\"SPARK_APP_URI\": \"s3a://$environment-voyager-artefacts-$project_name/main.py\"}" < $tfvars >> temp_vars.json
    cat $tfvars | jq  ".inputs.lambda_environment_variables |= . + {\"SPARK_DEPENDANCIES_URI\": \"s3a://$environment-voyager-artefacts-$project_name/voyager-app-snapshot.zip\"}" < $tfvars >> temp_vars.json

    # Create a few zips for lambda etc
    create_zips

    # Iterate through cases in etl config
    number_of_cases=$(echo $(cat $tfvars | jq .inputs.regex_prefix | jq length)-1 | bc)
    for i in $(seq 0 $number_of_cases)
    do
      upload_artefacts $i
    done
    else
      echo "Component configured to not deploy Voyager App here"
      exit 0
    fi
done

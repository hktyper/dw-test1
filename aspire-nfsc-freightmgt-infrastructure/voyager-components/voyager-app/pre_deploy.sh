set -eo pipefail

function log () {
echo "#################################################"
echo "# $1"
echo "#################################################"
}

function load_codeartifact_envvars () {
  CODEARTIFACT_REPO=$(echo $TF_VAR_codeartifact_repo)
  CODEARTIFACT_DOMAIN=$(echo $TF_VAR_codeartifact_domain)
  CODEARTIFACT_OWNER=$(cat ../extra_vars.json | jq -r '.codeartifact_owner')
}

if [[ ${LOCAL} = true ]];then
  export AWS_PROFILE="$(jq <./terragrunt.hcl.json -r '.remote_state.config.profile')"
fi

# Setup config
BUILD_DOCKER_IMAGE=$(cat extra_vars.json | jq 'if has("build_docker_image") then .build_docker_image else true end')
BUILD_LIBRARY=$(cat extra_vars.json | jq 'if has("build_library") then .build_library else true end')
BUILD_AMI=$(cat extra_vars.json | jq 'if has("build_ami") then .build_ami else true end')

GIT_REPO=$(cat ./extra_vars.json | jq -r '.voyager_app_git_repo')
GIT_BRANCH=$(cat ./extra_vars.json | jq -r '.voyager_app_git_branch')
GEMFURY_TOKEN_PARAMETER=$(cat ./extra_vars.json | jq -r '.gemfury_token_parameter')
REGION=$(cat ./extra_vars.json | jq -r '.region')

# Get component dir to put robocrop in the right place
COMPONENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

############################
# Clone voyager-app
############################

if [[ ! -d code/ ]];then
  git clone --branch $GIT_BRANCH "git@github.com:${GIT_REPO}" code/
fi

cd code/

############################
# Get Robocrop
############################

# TODO The version is hardcoded as this is hardcoded in voyager-app. When this
# is taken from an input variable, we should change this
log "Get robocrop 1.2.0"
GEMFURY_TOKEN=$(aws ssm get-parameters --names ${GEMFURY_TOKEN_PARAMETER} --with-decryption --region ${REGION} --output text --query "Parameters[*].Value")
log "Download robocrop"
pip download robocrop==1.2.0 --extra-index-url https://${GEMFURY_TOKEN}@pypi.fury.io/sainsburys-algorithms-team/ --dest $COMPONENT_DIR/code/temporary_dependencies/
pip download data-tech-file-utilities-python==0.0.2 --extra-index-url https://${GEMFURY_TOKEN}@pypi.fury.io/sainsburys-algorithms-team/ --dest $COMPONENT_DIR/code/temporary_dependencies/
pip download data-tech-cerberus-security-extension==0.1.2 --extra-index-url https://${GEMFURY_TOKEN}@pypi.fury.io/sainsburys-algorithms-team/ --dest $COMPONENT_DIR/code/temporary_dependencies/

############################
# Library build
############################

if [[ $BUILD_LIBRARY = true ]];then
  load_codeartifact_envvars

  log "Install robocrop"
  pip install $COMPONENT_DIR/code/temporary_dependencies/robocrop-1.2.0.tar.gz

  log "Pip install local requirements"
  pip install .
  log "Pip install setup requirements"
  pip install twine wheel boto3 click pathlib

  # Required for the library build
  export AWS_DEFAULT_REGION=${REGION}

  log "Build library and push to pypi with ${CODEARTIFACT_REPO}, ${CODEARTIFACT_DOMAIN} and ${CODEARTIFACT_OWNER}"
  python setup.py write_version
  python setup.py package_wheels \
    --app-only \
    --app-as-wheel \
    --cleanup-dist publish_library \
    --aws-repo-name="${CODEARTIFACT_REPO}" \
    --aws-repo-domain="${CODEARTIFACT_DOMAIN}" \
    --aws-repo-domain-owner="${CODEARTIFACT_OWNER}"
else
  log "Skipping Library Image Build"
fi

############################
# Docker build
############################

if [[ $BUILD_DOCKER_IMAGE = true ]];then
  # TODO Pass this through as a tf var
  aws_tag=$(echo $TF_VAR_ecr_url):$(git log -1 --pretty=format:%h)

  load_codeartifact_envvars

  log "Get CodeArtifact token"
  CODEARTIFACT_TOKEN=$(aws codeartifact get-authorization-token --region "${REGION}" --domain ${CODEARTIFACT_DOMAIN} --domain-owner ${CODEARTIFACT_OWNER} --query authorizationToken --output text)

  log "Build docker image"
  docker build \
    --build-arg CODEARTIFACT_TOKEN=${CODEARTIFACT_TOKEN} \
    --build-arg CODEARTIFACT_URL="${CODEARTIFACT_DOMAIN}-${CODEARTIFACT_OWNER}.d.codeartifact.${REGION}.amazonaws.com/pypi/${CODEARTIFACT_REPO}/simple/" \
    -t $aws_tag \
    -f docker/voyager.dockerfile .
  docker push $aws_tag
  if [[ ${LOCAL} = true ]];then
    unset AWS_PROFILE
  fi
else
  log "Skipping Docker Image Build"
fi

############################
# AMI build
############################

# TODO Try and avoid these directory switches. Probably by moving this functionality to voyager-app
cd ..

# TODO Remove static profile from image.json

if [[ $BUILD_AMI = true ]];then
  log "Validating Packer Config"
  packer validate \
    -var "instance_type=$(cat extra_vars.json | jq -r '.instance_type')" \
    -var "environment=$(cat extra_vars.json | jq -r '.environment')" \
    -var "vpc_id=$(echo $TF_VAR_vpc_id)" \
    -var "subnet_id=$(echo $TF_VAR_vpc_subnet)" \
    -var "costcentre=$(cat extra_vars.json | jq -r '.costcentre')" \
    -var "owner=$(cat extra_vars.json | jq -r '.owner')" \
    -var "email=$(cat extra_vars.json | jq -r '.email')" \
    -var "python_version=$(cat extra_vars.json | jq -r '.python_version')" \
    ./ami/image.json
  log "Building AMI"
  packer build -machine-readable \
    -var "instance_type=$(cat extra_vars.json | jq -r '.instance_type')" \
    -var "environment=$(cat extra_vars.json | jq -r '.environment')" \
    -var "vpc_id=$(echo $TF_VAR_vpc_id)" \
    -var "subnet_id=$(echo $TF_VAR_vpc_subnet)" \
    -var "costcentre=$(cat extra_vars.json | jq -r '.costcentre')" \
    -var "owner=$(cat extra_vars.json | jq -r '.owner')" \
    -var "email=$(cat extra_vars.json | jq -r '.email')" \
    -var "python_version=$(cat extra_vars.json | jq -r '.python_version')" \
    ./ami/image.json | tee ./build.log
  grep 'artifact,0,id' ./build.log | cut -d, -f6 | cut -d: -f2 | tr -d '\n' > ami_id
else
  log "Skipping AMI Image Build"
fi

unset AWS_PROFILE

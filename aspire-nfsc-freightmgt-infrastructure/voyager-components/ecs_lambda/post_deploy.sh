#! /bin/bash

# Defaulting variable to false as Makefile in voyager-poc-squads sets LOCAL
# as true explicitly whereas LOCAL is not passed as an env variable to CodeBuild.
# Assumes that this script will run more frequently via CI/CD where exporting the
# AWS_PROFILE is unnecessary and running locally should be more explicit than CICD.

LOCAL=${LOCAL:-false}
set -euo pipefail

function log() {
  echo "#################################################"
  echo "# $1"
  echo "#################################################"
}

if [[ "${LOCAL}" == true ]]; then
  AWS_PROFILE="$(jq <./terragrunt.hcl.json -r '.remote_state.config.profile')"
  export AWS_PROFILE
fi

DEPLOY_LAMBDA_APP_CODE=$(jq <./extra_vars.json 'if has("deploy_lambda_app_code") then .deploy_lambda_app_code else true end')

if [[ ${DEPLOY_LAMBDA_APP_CODE} == true ]]; then
  log "Fetching Git refs from extra_vars..."
  REGION=$(cat ./extra_vars.json | jq -r '.region // "eu-west-1"')
  GIT_REPO=$(cat ./extra_vars.json | jq -r '.lambda_code_git_repo')
  GIT_BRANCH=$(cat ./extra_vars.json | jq -r '.lambda_code_git_branch')
  LAMBDA_NAME=$(cat ./extra_vars.json | jq -r '.lambda_app_name // "voyager-fargate-lambda"')
  log "Cleaning up the directory structure for the repo clone..."
  mkdir -p lambda_code/
  rm -rf lambda_code/
  log "Cloning the app code repo..."
  git clone --branch $GIT_BRANCH "git@github.com:${GIT_REPO}" lambda_code/
  cd lambda_code/
  log "Executing the deployment script..."
  python setup.py package_lambda -c upload_lambda --aws-region="${REGION}" --lambda-name="${LAMBDA_NAME}"
  cd ..
else
  log "Skipping the code deployment step"
fi

unset AWS_PROFILE

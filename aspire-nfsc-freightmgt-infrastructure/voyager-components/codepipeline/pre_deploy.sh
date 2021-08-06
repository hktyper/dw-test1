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

BUILD_DOCKER_IMAGE=$(jq <./extra_vars.json 'if has("build_docker_image") then .build_docker_image else true end')

if [[ ${BUILD_DOCKER_IMAGE} == true ]]; then
  log "Building voyager-pipeline image"
  aws_tag="${TF_VAR_ecr_url}:$(git log -1 --pretty=format:%h)"

  log "Build and push image"
  docker build -t "${aws_tag}" .

  log "Pushing voyager-pipeline image"
  docker push "${aws_tag}"

  log "Save docker tag"
  echo "${aws_tag}" >./docker_image
else
  log "Skipping Docker Image Build"
fi

unset AWS_PROFILE

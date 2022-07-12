#!/usr/bin/env bash
set -ex

DOT_ENV="./bin/.env.sh"
if [ -f "${DOT_ENV}" ]; then
  # shellcheck disable=SC1090
  . "${DOT_ENV}"
fi

function create_or_select_tf_namespace() {
  MESSAGE="$(terraform workspace new "${1}" 2>&1 || true)"
  if [[ "${MESSAGE}" == *"already exists"* ]]; then
    terraform workspace select "${1}"
  elif [[ "${MESSAGE}" != *"Created and switched to workspace"* ]]; then
    echo "Failed to create terraform namespace ${1}"
    exit 1
  fi
}

function import_tf_resource() {
  RESOURCE_NAME="${1}"
  RESOURCE_VALUE="${2}"
  VAR_FILE="${3}"
  MESSAGE=$(terraform import -var-file="${VAR_FILE}" "${RESOURCE_NAME}" "${RESOURCE_VALUE}" || true)
  if [[ "${MESSAGE}" != *"Import prepared"* ]]; then
    echo "Failed to import resource name: ${RESOURCE_NAME}, value ${RESOURCE_VALUE}"
    exit 1
  fi
}

function update_tf_resource() {
  RESOURCE_NAME="${1}"
  VAR_FILE="${2}"
  TF_PLAN=update-resource.tfplan
  terraform plan -out="${TF_PLAN}" -lock=true -target="${RESOURCE_NAME}" -var-file="${VAR_FILE}"
  terraform apply -target="${RESOURCE_NAME}" "${TF_PLAN}"
}

# shellcheck disable=SC2155
export REPOSITORY_NAME="$(basename "$(git rev-parse --show-toplevel)")"
export TF_VAR_repository_name="${REPOSITORY_NAME}"
export TF_VAR_github_token="${GITHUB_TOKEN}"
export TF_VAR_github_owner="terzey"
export TF_VAR_repository_visibility="private"

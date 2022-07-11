#!/usr/bin/env bash
set -ex

DOT_ENV="./bin/.env.sh"
if [ -f "${DOT_ENV}" ]; then
  # shellcheck disable=SC1090
  . "${DOT_ENV}"
fi

# shellcheck disable=SC2155
export REPOSITORY_NAME="$(basename "$(git rev-parse --show-toplevel)")"
export TF_VAR_repository_name="${REPOSITORY_NAME}"
export TF_VAR_github_token="${GITHUB_TOKEN}"
export TF_VAR_github_owner="terzey"
export TF_VAR_repository_visibility="private"

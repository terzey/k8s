#!/usr/bin/env bash
set -ex

. bin/.env.sh

export REPOSITORY_NAME="app-dev"
export REPOSITORY_URL="s3://k9s-helm-repository-bucket-dev/app/charts"

function create-repo() {
  helm s3 init "${REPOSITORY_URL}"
  helm repo add "${REPOSITORY_NAME}" "${REPOSITORY_URL}"
}

function push-chart() {
  local OUTPUT;
  OUTPUT="$(helm package apps/base/app/)"
  local RELEASE;
  RELEASE="$(echo "${OUTPUT}" | sed -E 's/Successfully packaged chart and saved it to: (.+)/\1/')"
  helm s3 push --relative "${RELEASE}" "${REPOSITORY_NAME}"
}

case $1 in
    "create-repo" )
      create-repo
      ;;
    "push-chart" )
      push-chart
      ;;
    *)
      cat <<EOF
Usage: bash bin/helm-app.sh CMD
CMD:
  - create-repo
  - push-chart
EOF
      ;;
esac
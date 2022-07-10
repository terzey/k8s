#!/usr/bin/env bash
set -ex

. ./bin/profile.sh

cd ./terraform
terraform init
terraform workspace new "${WORKSPACE}" || terraform workspace select "${WORKSPACE}"
terraform destroy -lock=true

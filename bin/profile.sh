#!/usr/bin/env bash
set -ex

DOT_ENV="./bin/.env.sh"
if [ -f "${DOT_ENV}" ]; then
  # shellcheck disable=SC1090
  . "${DOT_ENV}"
fi

export WORKSPACE="terzey-k9s"

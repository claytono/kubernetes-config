#!/bin/bash

set -eu -o pipefail

# shellcheck disable=SC2094
op document get 1password-credentials.json --vault Kubernetes \
  | base64 \
  >1password-credentials.json

#!/bin/bash

set -eu -o pipefail

op document get 1password-credentials.json --vault Kubernetes \
  | base64 \
  >1password-credentials.json


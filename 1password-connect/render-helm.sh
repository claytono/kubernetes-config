#!/bin/bash

set -eu -o pipefail

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$BASEDIR"

rm -rf helm
helm template connect connect \
  --version 1.15.0 \
  --repo https://1password.github.io/connect-helm-charts \
  --namespace 1password \
  --values values.yaml \
  --output-dir helm


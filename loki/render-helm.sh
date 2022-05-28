#!/bin/bash

set -eu -o pipefail

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$BASEDIR"

rm -rf helm
helm template loki loki \
  --version 2.11.1 \
  --repo https://grafana.github.io/helm-charts \
  --values values.yaml \
  --output-dir helm

yq '.data."loki.yaml" | @base64d' \
  helm/loki/templates/secret.yaml \
  > helm/loki.dist.yaml

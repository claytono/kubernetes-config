#!/bin/bash

set -eu -o pipefail

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$BASEDIR"

rm -rf helm tmp
mkdir tmp helm
helm template homepage homepage \
  --repo https://jameswynn.github.io/helm-charts \
  --version 1.2.3 \
  --values values.yaml \
  --output-dir tmp

mv tmp/*/* helm
rmdir tmp/*
rmdir tmp
rm -rf helm/tests

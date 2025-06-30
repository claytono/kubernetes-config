#!/bin/bash

set -eu -o pipefail

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$BASEDIR"

rm -rf helm tmp
mkdir tmp helm
touch values.yaml
helm template reloader reloader \
  --version v1.0.71 \
  --repo  https://stakater.github.io/stakater-charts \
  --values values.yaml \
  --output-dir tmp

mv tmp/*/* helm
rmdir tmp/*
rmdir tmp
rm -rf helm/tests

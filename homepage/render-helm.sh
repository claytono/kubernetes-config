#!/bin/bash

set -eu -o pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BASEDIR"

source "$BASEDIR/../scripts/chart-version.sh"

rm -rf helm tmp
mkdir tmp helm

# Render homepage chart
helm_template homepage homepage --include-crds --values values.yaml --output-dir tmp

mv tmp/*/* helm
rmdir tmp/*
rmdir tmp
rm -rf helm/tests

# Remove the ConfigMap template since we generate it via kustomize
rm -f helm/templates/configmap.yaml

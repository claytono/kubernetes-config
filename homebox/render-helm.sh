#!/bin/bash

set -eu -o pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BASEDIR"

source "$BASEDIR/../scripts/chart-version.sh"

rm -rf helm tmp
mkdir tmp helm

# Render homebox chart
helm_template homebox homebox --include-crds --values values.yaml --output-dir tmp

mv tmp/*/* helm
mv helm/templates helm/homebox
mv helm/charts/postgresql/templates helm/postgresql
rm -rf helm/charts
rmdir tmp/*
rmdir tmp
rm -rf helm/homebox/tests

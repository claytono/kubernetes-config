#!/bin/bash

set -eu -o pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)"
cd "$BASEDIR"

source "$BASEDIR/../scripts/chart-version.sh"

rm -rf helm tmp
mkdir tmp helm

# Template using Chart.yaml
helm_template cert-manager cert-manager \
	--create-namespace \
	--include-crds \
	--values values.yaml \
	--output-dir tmp

mv tmp/*/* helm
rmdir tmp/*
rmdir tmp
rm -rf helm/tests

# Remove the startupapicheck job (not needed for render-to-disk workflows)
rm -f helm/templates/startupapicheck-job.yaml

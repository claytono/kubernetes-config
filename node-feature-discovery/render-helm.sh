#!/bin/bash

set -eu -o pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BASEDIR"

source "$BASEDIR/../scripts/chart-version.sh"

rm -rf helm tmp
mkdir tmp helm

# Template using Chart.yaml
helm_template node-feature-discovery node-feature-discovery \
	--values values.yaml \
	--include-crds \
	--namespace node-feature-discovery \
	--output-dir tmp

mv tmp/*/* helm
rmdir tmp/*
rmdir tmp
rm -rf helm/tests
rm -f helm/templates/post-delete-job.yaml

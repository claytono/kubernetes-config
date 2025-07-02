#!/bin/bash

set -eu -o pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BASEDIR"

# Chart variables
VPA_CHART_NAME="vpa"
VPA_CHART_VERSION="1.4.0"
VPA_CHART_REPO="https://charts.fairwinds.com/stable"

rm -rf helm tmp
mkdir tmp helm
helm template "$VPA_CHART_NAME" "$VPA_CHART_NAME" \
	--repo "$VPA_CHART_REPO" \
	--include-crds \
	--version "$VPA_CHART_VERSION" \
	--values values.yaml \
	--output-dir tmp

mv tmp/*/* helm
rmdir tmp/*
rmdir tmp
rm -rf helm/tests

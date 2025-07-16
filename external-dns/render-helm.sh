#!/bin/bash

set -eu -o pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BASEDIR"

# Source the chart-version.sh helper
source "$BASEDIR/../scripts/chart-version.sh"

rm -rf helm tmp
mkdir tmp helm

helm_template external-dns external-dns \
	--include-crds \
	--values values.yaml \
	--output-dir tmp

mv tmp/*/* helm
rmdir tmp/*
rmdir tmp
rm -rf helm/tests

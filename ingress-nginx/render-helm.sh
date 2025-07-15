#!/bin/bash

set -eu -o pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BASEDIR"

# Source the chart-version.sh helper
source "$BASEDIR/../scripts/chart-version.sh"

rm -rf helm tmp
mkdir tmp

# Use helm_template helper function
helm_template ingress-nginx ingress-nginx \
	--namespace ingress-nginx \
	--values values.yaml \
	--create-namespace \
	--output-dir tmp

mv tmp/*/* helm
rmdir tmp/*
rmdir tmp

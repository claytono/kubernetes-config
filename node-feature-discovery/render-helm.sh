#!/bin/bash

set -eu -o pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BASEDIR"

rm -rf helm tmp
mkdir tmp helm
helm template node-feature-discovery \
	--version 0.14.3 \
	--repo https://kubernetes-sigs.github.io/node-feature-discovery/charts \
	--values values.yaml \
	--include-crds \
	--namespace node-feature-discovery \
	--create-namespace \
	--generate-name \
	--output-dir tmp

mv tmp/*/* helm
rmdir tmp/*
rmdir tmp
rm -rf helm/tests

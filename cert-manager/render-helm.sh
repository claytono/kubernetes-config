#!/bin/bash

set -eu -o pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BASEDIR"

rm -rf helm tmp
mkdir tmp helm
helm template cert-manager cert-manager \
	--repo https://charts.jetstack.io \
	--create-namespace \
	--include-crds \
	--version 1.11.0 \
	--values values.yaml \
	--output-dir tmp

mv tmp/*/* helm
rmdir tmp/*
rmdir tmp
rm -rf helm/tests

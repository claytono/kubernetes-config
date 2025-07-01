#!/bin/bash

set -eu -o pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BASEDIR"

rm -rf helm tmp
mkdir tmp helm
helm template external-secrets external-secrets \
	--version 0.9.13 \
	--repo https://charts.external-secrets.io \
	--namespace external-secrets \
	--values values.yaml \
	--output-dir tmp

mv tmp/*/* helm
rmdir tmp/*
rmdir tmp
rm -rf helm/tests

#!/bin/bash

set -eu -o pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BASEDIR"

REPO=https://charts.fairwinds.com/stable
NAME=goldilocks
VERSION=6.5.1

if [ ! -f values.yaml ]; then
	touch values.yaml
fi

rm -rf helm tmp
mkdir tmp helm
helm template "$NAME" "$NAME" \
	--repo "$REPO" \
	--include-crds \
	--version "$VERSION" \
	--values values.yaml \
	--output-dir tmp

mv tmp/*/* helm
rmdir tmp/*
rmdir tmp
rm -rf helm/tests

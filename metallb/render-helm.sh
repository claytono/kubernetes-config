#!/bin/bash

set -eu -o pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BASEDIR"

REPO=https://metallb.github.io/metallb
NAME=metallb
VERSION=0.13.9

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

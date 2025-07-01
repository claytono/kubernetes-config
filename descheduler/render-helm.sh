#!/bin/bash

set -eu -o pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BASEDIR"

rm -rf helm tmp
mkdir tmp helm
helm template descheduler descheduler \
	--repo https://kubernetes-sigs.github.io/descheduler/ \
	--version 0.29.0 \
	--values values.yaml \
	--output-dir tmp

mv tmp/*/* helm
rmdir tmp/*
rmdir tmp
rm -rf helm/tests

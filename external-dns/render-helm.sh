#!/bin/bash

set -eu -o pipefail

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$BASEDIR"

rm -rf helm tmp
mkdir tmp helm
helm template external-dns external-dns \
  --repo https://kubernetes-sigs.github.io/external-dns/ \
  --include-crds \
  --version 1.7.1 \
  --values values.yaml \
  --output-dir tmp

mv tmp/*/* helm
rmdir tmp/*
rmdir tmp
rm -rf helm/tests

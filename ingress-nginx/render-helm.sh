#!/bin/bash

set -eu -o pipefail

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$BASEDIR"

rm -rf helm tmp
mkdir tmp
helm template ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --version 4.1.4 \
  --namespace ingress-nginx \
  --values values.yaml \
  --create-namespace \
  --output-dir tmp

mv tmp/*/* helm
rmdir tmp/*
rmdir tmp

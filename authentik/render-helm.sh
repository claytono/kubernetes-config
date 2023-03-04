#!/bin/bash

set -eu -o pipefail

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$BASEDIR"

rm -rf helm tmp
mkdir tmp helm
helm template authentik authentik \
  --repo https://charts.goauthentik.io/ \
  --version 2023.2.2 \
  --values values.yaml \
  --output-dir tmp

mv tmp/*/* helm
rmdir tmp/*
rmdir tmp
rm -rf helm/tests

# Delete this since it's randomly generated every time and we don't use it.
rm -f postgresql/templates/secrets.yaml

for i in helm/charts/*; do
  name=$(basename "$i")
  rm -rf "$name/templates"
  mkdir -p "$name/templates"
  mv "$i"/templates/* "$name/templates/"
done

rm -rf helm/charts

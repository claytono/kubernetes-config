#!/bin/bash

set -eu -o pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BASEDIR"

rm -rf helm tmp
mkdir tmp helm
helm template nfs-subdir-external-provisioner nfs-subdir-external-provisioner \
	--repo https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner \
	--include-crds \
	--version 4.0.18 \
	--values values.yaml \
	--output-dir tmp

mv tmp/*/* helm
rmdir tmp/*
rmdir tmp
rm -rf helm/tests

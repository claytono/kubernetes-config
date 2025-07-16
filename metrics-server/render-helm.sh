#!/bin/bash

set -eu -o pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BASEDIR"

source "$BASEDIR/../scripts/chart-version.sh"

rm -rf helm tmp
mkdir tmp

# Template using Chart.yaml
helm_template metrics-server metrics-server \
	--values values.yaml \
	--output-dir tmp

mv tmp/*/* helm
rmdir tmp/*
rmdir tmp

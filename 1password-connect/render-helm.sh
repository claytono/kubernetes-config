#!/bin/bash

set -eu -o pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BASEDIR"

source "$BASEDIR/../scripts/chart-version.sh"

rm -rf helm
# Template using Chart.yaml
helm_template connect connect \
	--namespace 1password \
	--values values.yaml \
	--output-dir helm

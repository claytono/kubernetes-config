#!/bin/bash

set -eu -o pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BASEDIR"

rm -rf helm
helm template promtail promtail \
	--version 4.2.1 \
	--repo https://grafana.github.io/helm-charts \
	--values values.yaml \
	--output-dir helm

yq '.stringData."promtail.yaml"' helm/promtail/templates/secret.yaml \
	>helm/promtail.dist.yaml

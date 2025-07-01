#!/bin/bash

set -eu -o pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BASEDIR"

rm -rf helm
helm template loki loki \
	--version 2.16.0 \
	--repo https://grafana.github.io/helm-charts \
	--values values.yaml \
	--output-dir helm

# Delete the PSP since it's a deprecated resource and we don't need the warnings.
rm -f helm/loki/templates/podsecuritypolicy.yaml

yq '.data."loki.yaml" | @base64d' \
	helm/loki/templates/secret.yaml \
	>helm/loki.dist.yaml

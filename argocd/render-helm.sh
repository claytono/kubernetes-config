#!/bin/bash

set -eu -o pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BASEDIR"

# Source the chart-version.sh helper
source "$BASEDIR/../scripts/chart-version.sh"

rm -rf helm tmp
mkdir tmp helm

# Use helm_template helper function
helm_template argocd argo-cd \
	--namespace argocd \
	--include-crds \
	--values values.yaml \
	--output-dir tmp

mv tmp/*/* helm
rmdir tmp/*
rmdir tmp
rm -rf helm/tests

# Update kustomization.yaml resources to match actual helm files
sed -i '' '/# Generated helm resources/,$d' kustomization.yaml

# Add marker comment and all current helm template files
echo "# Generated helm resources - do not edit below this line" >> kustomization.yaml
find helm/templates -name "*.yaml" -type f | sort | sed 's/^/- /' >> kustomization.yaml

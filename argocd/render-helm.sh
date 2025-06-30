#!/bin/bash

set -eu -o pipefail

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$BASEDIR"

helm template argocd argo/argo-cd \
  --version 8.1.0 \
  --namespace argocd \
  --include-crds \
  --values values.yaml \
  > helm.yaml


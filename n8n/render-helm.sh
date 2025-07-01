#!/bin/bash

set -eu -o pipefail

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$BASEDIR"

rm -rf helm tmp
mkdir -p tmp helm/n8n helm/valkey helm/postgres

# Render n8n chart
helm template n8n oci://8gears.container-registry.com/library/n8n \
  --version 1.0.10 \
  --namespace n8n \
  --values values.yaml \
  --output-dir tmp

# Move n8n templates to helm/n8n/
mv tmp/n8n/templates/* helm/n8n/

# Move valkey charts to helm/valkey/
mv tmp/n8n/charts/valkey/* helm/valkey/

# Render PostgreSQL chart
helm template n8n-postgres oci://registry-1.docker.io/bitnamicharts/postgresql \
  --version 15.5.36 \
  --namespace n8n \
  --values postgres-values.yaml \
  --output-dir tmp

# Move postgres templates to helm/postgres/
mv tmp/postgresql/templates/* helm/postgres/

# Clean up
rm -rf tmp
rm -rf helm/*/tests

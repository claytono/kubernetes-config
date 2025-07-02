#!/bin/bash

set -eu -o pipefail

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$BASEDIR"

# Chart variables
N8N_CHART_NAME="oci://8gears.container-registry.com/library/n8n"
N8N_CHART_VERSION="1.0.10"
POSTGRES_CHART_NAME="oci://registry-1.docker.io/bitnamicharts/postgresql"
POSTGRES_CHART_VERSION="15.5.36"

rm -rf helm tmp
mkdir -p tmp helm/n8n helm/valkey helm/postgres

# Render n8n chart
helm template n8n "$N8N_CHART_NAME" \
  --version "$N8N_CHART_VERSION" \
  --namespace n8n \
  --values values.yaml \
  --output-dir tmp

# Move n8n templates to helm/n8n/
mv tmp/n8n/templates/* helm/n8n/

# Move valkey charts to helm/valkey/
mv tmp/n8n/charts/valkey/* helm/valkey/

# Render PostgreSQL chart
helm template n8n-postgres "$POSTGRES_CHART_NAME" \
  --version "$POSTGRES_CHART_VERSION" \
  --namespace n8n \
  --values postgres-values.yaml \
  --output-dir tmp

# Move postgres templates to helm/postgres/
mv tmp/postgresql/templates/* helm/postgres/

# Clean up
rm -rf tmp
rm -rf helm/*/tests

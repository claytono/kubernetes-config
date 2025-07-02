#!/bin/bash

set -eu -o pipefail

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$BASEDIR"

rm -rf helm tmp
mkdir -p tmp helm/n8n helm/valkey helm/postgres

# Fetch chart info from repo root YAML
N8N_CHART_NAME=$(scripts/chart-version.sh n8n name)
N8N_CHART_VERSION=$(scripts/chart-version.sh n8n version)
POSTGRES_CHART_NAME=$(scripts/chart-version.sh postgres name)
POSTGRES_CHART_VERSION=$(scripts/chart-version.sh postgres version)

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

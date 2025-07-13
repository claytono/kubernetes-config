#!/usr/bin/env bash

set -eu -o pipefail

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$BASEDIR"

source "$BASEDIR/../scripts/chart-version.sh"

rm -rf helm tmp
mkdir -p tmp helm/n8n helm/valkey helm/postgres

# Render n8n chart
helm_template n8n n8n --namespace n8n --values values.yaml --output-dir tmp

# Move n8n templates to helm/n8n/
mv tmp/n8n/templates/* helm/n8n/

# Move valkey charts to helm/valkey/
mv tmp/n8n/charts/valkey/* helm/valkey/
rm -f helm/valkey/templates/secret.yaml

# Remove checksum/secret annotation from valkey application.yaml
# Use yq to remove the specific checksum/secret annotation
yq -i 'del(.spec.template.metadata.annotations["checksum/secret"])' helm/valkey/templates/primary/application.yaml


# Render PostgreSQL chart
helm_template n8n-postgres postgresql --namespace n8n --values postgres-values.yaml --output-dir tmp

# Move postgres templates to helm/postgres/
mv tmp/postgresql/templates/* helm/postgres/

# Clean up
rm -rf tmp
rm -rf helm/*/tests

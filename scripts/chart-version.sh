#!/bin/bash

set -eu -o pipefail

# Usage: chart-version.sh <chart> <field>
# Example: chart-version.sh n8n version

CHART_VERSIONS_FILE="$(git rev-parse --show-toplevel)/chart-versions.yaml"

if [ $# -ne 2 ]; then
  echo "Usage: $0 <chart> <field>" >&2
  exit 1
fi

CHART="$1"
FIELD="$2"

if [ ! -f "$CHART_VERSIONS_FILE" ]; then
  echo "Error: $CHART_VERSIONS_FILE not found" >&2
  exit 2
fi

VALUE=$(yq ".${CHART}.${FIELD}" "$CHART_VERSIONS_FILE")

if [ "$VALUE" = "null" ] || [ -z "$VALUE" ]; then
  echo "Error: Field '$FIELD' for chart '$CHART' not found in $CHART_VERSIONS_FILE" >&2
  exit 3
fi

# Output the value
printf "%s" "$VALUE"

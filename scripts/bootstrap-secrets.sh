#!/bin/bash

set -eu -o pipefail

# Find all bootstrap-secrets.sh scripts in the repository
# Exclude the scripts directory itself and any .git directories
find . -name bootstrap-secrets.sh -not -path "*/\.*" -not -path "*/scripts/*" | while read -r script; do
    echo "Running $script..."
    (cd "$(dirname "$script")" && ./bootstrap-secrets.sh)
done 

#!/usr/bin/env bash
set -euo pipefail

filtered=()
for file in "$@"; do
  # Only check regular files
  if [[ -f "$file" ]]; then
    # Check for both apiVersion: and kind: (not commented out)
    if grep -q '^apiVersion:' "$file" && grep -q '^kind:' "$file"; then
      # Exclude Kustomization kind (case-insensitive)
      if ! grep -iq '^kind: *kustomization' "$file"; then
        filtered+=("$file")
      fi
    fi
  fi
done

if [[ ${#filtered[@]} -gt 0 ]]; then
  kubeconform --strict --summary \
    -schema-location default \
    -schema-location 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json' \
    "${filtered[@]}"
fi

#!/usr/bin/env bash

# Helper function to look up chart fields from Chart.yaml dependencies
chart_version_lookup() {
  local chart="$1"
  local field="$2"
  # Find Chart.yaml in the current working directory
  local chart_file="$PWD/Chart.yaml"
  if [[ ! -f "$chart_file" ]]; then
    echo "Error: Chart.yaml not found in $PWD" >&2
    return 2
  fi
  local value
  value=$(yq -r ".dependencies[] | select(.name == \"$chart\") | .$field" "$chart_file")
  if [ "$value" = "null" ] || [ -z "$value" ]; then
    echo "Error: Field '$field' for chart '$chart' not found in $chart_file" >&2
    return 3
  fi
  printf "%s" "$value"
}

# Function to output correct Helm CLI args for a chart key
helm_chart_args() {
  local chart="$1"
  local repo
  local version
  repo=$(chart_version_lookup "$chart" repository)
  version=$(chart_version_lookup "$chart" version)
  if [[ "$repo" == oci://* ]]; then
    # OCI chart: <repo>/<chart> --version <version>
    local oci_url="${repo}/$chart"
    printf '%s\n' "$oci_url" --version "$version"
  else
    # Standard chart: use chart name, --repo, --version
    printf '%s\n' "$chart" --repo "$repo" --version "$version"
  fi
}

# Function to call helm template with correct chart args and any extra options
helm_template() {
  local release="$1"
  local chart_key="$2"
  shift 2
  local chart_args
  # Use a more compatible approach for older shells
  chart_args=()
  while IFS= read -r line; do
    chart_args+=("$line")
  done < <(helm_chart_args "$chart_key")
  helm template "$release" "${chart_args[@]}" "$@"
}

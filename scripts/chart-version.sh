#!/usr/bin/env bash

# Helper: get the directory of this script
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)"

# Helper function to look up chart fields from Chart.yaml dependencies
chart_version_lookup() {
  local chart="$1"
  local field="$2"
  local chart_file="$BASEDIR/../Chart.yaml"

  if [ ! -f "$chart_file" ]; then
    echo "Error: $chart_file not found" >&2
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

# Convenience function to get the repository (chart repo/source)
chart_repo() {
  chart_version_lookup "$1" repository
}

# Convenience function to get the version only
chart_version() {
  chart_version_lookup "$1" version
}

# Function to output correct Helm CLI args for a chart key
helm_chart_args() {
  local chart="$1"
  local repo
  local version
  repo=$(chart_repo "$chart")
  version=$(chart_version "$chart")
  if [[ "$repo" == oci://* ]]; then
    # OCI chart: use repo as chart argument, no --repo
    printf '%q ' "$repo" --version "$version"
  else
    # Standard chart: use chart name, --repo, --version
    printf '%q ' "$chart" --repo "$repo" --version "$version"
  fi
}

# Function to output correct Helm CLI args for a chart key as a Bash array
helm_chart_args_array() {
  local chart="$1"
  local repo
  local version
  repo=$(chart_repo "$chart")
  version=$(chart_version "$chart")
  if [[ "$repo" == oci://* ]]; then
    printf '%s\n' "$repo" --version "$version"
  else
    printf '%s\n' "$chart" --repo "$repo" --version "$version"
  fi
}

# Function to call helm template with correct chart args and any extra options
helm_template() {
  local release="$1"
  local chart_key="$2"
  shift 2
  mapfile -t chart_args < <(helm_chart_args_array "$chart_key")
  helm template "$release" "${chart_args[@]}" "$@"
}

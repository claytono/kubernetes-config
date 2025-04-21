#!/usr/bin/env bash

# Script to retrieve secrets from 1Password for resticprofile
# Used by both run.sh and run-rclone.sh

# Check if op CLI is installed
if ! command -v op &> /dev/null; then
  echo "Error: 1Password CLI not installed. Please install it first." >&2
  exit 1
fi

# Check if we're signed in to 1Password
if ! op account get &> /dev/null; then
  echo "Not signed in to 1Password. Please sign in first." >&2
  exit 1
fi

# Constants
OP_VAULT="Kubernetes"
OP_RESTICPROFILE_ITEM="resticprofile"
OP_RCLONE_ITEM="resticprofile-rclone"

# Generic function to export all environment variables from a 1Password item
export_1password_item_variables() {
  local item_name="$1"
  local description="$2"

  echo "Fetching ${description} secrets from 1Password"

  # Get all fields as JSON
  local secrets_json=$(op item get "$item_name" --vault "$OP_VAULT" --format json)

  # Parse and export each field in the item
  while IFS="=" read -r key value; do
    if [[ -n "$key" && -n "$value" ]]; then
      export "$key"="$value"
      echo "Exported $key"
    fi
  done < <(echo "$secrets_json" | jq -r '.fields[] | select(.type=="CONCEALED") | .label + "=" + .value')
}

# Function to export resticprofile password and any other fields in that item
export_resticprofile_env_variables() {
  export_1password_item_variables "$OP_RESTICPROFILE_ITEM" "resticprofile"
}

# Function to export all rclone environment variables
export_rclone_env_variables() {
  export_1password_item_variables "$OP_RCLONE_ITEM" "rclone"
}

# If script is run directly, print usage
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "This script is meant to be sourced by other scripts, not executed directly."
  echo "Usage:"
  echo "  source $(basename "$0")"
  exit 1
fi

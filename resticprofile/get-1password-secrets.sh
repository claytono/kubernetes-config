#!/usr/bin/env bash

# Shared script to export 1Password secrets as environment variables
# Used by run.sh and run-rclone.sh for local development

set -euo pipefail

# Function to export resticprofile password
export_resticprofile_password() {
    echo "Fetching resticprofile password from 1Password..."
    export RESTIC_PASSWORD=$(op read "op://Kubernetes/resticprofile/RESTIC_PASSWORD")
}

# Function to export all rclone environment variables
export_rclone_env_variables() {
    echo "Fetching rclone configuration from 1Password..."

    # Retrieve all fields at once in JSON format for efficiency
    local item_json=$(op item get "resticprofile-rclone" --vault "Kubernetes" --format json)

    # Function to extract field value from JSON
    extract_field() {
        echo "$item_json" | jq -r --arg field "$1" '.fields[] | select(.label == $field) | .value // empty'
    }

    # Azure backend credentials
    export RCLONE_CONFIG_AZURE_KEY=$(extract_field "RCLONE_CONFIG_AZURE_KEY")

        # Get the shared crypt passwords from 1Password and set them directly
    local crypt_password=$(extract_field "RCLONE_CONFIG_CRYPT_PASSWORD")
    local crypt_password2=$(extract_field "RCLONE_CONFIG_CRYPT_PASSWORD2")

    # Set specific backend passwords using the shared crypt passwords (plain text)
    export RCLONE_CONFIG_AZC_PASSWORD="$crypt_password"
    export RCLONE_CONFIG_AZC_PASSWORD2="$crypt_password2"
    export RCLONE_CONFIG_B2C_PASSWORD="$crypt_password"
    export RCLONE_CONFIG_B2C_PASSWORD2="$crypt_password2"

    # B2 backend credentials
    export RCLONE_CONFIG_B2_ACCOUNT=$(extract_field "RCLONE_CONFIG_B2_ACCOUNT")
    export RCLONE_CONFIG_B2_KEY=$(extract_field "RCLONE_CONFIG_B2_KEY")
}

# Function to check if 1Password CLI is available and authenticated
check_op_auth() {
    if ! command -v op >/dev/null 2>&1; then
        echo "Error: 1Password CLI (op) is not installed or not in PATH"
        exit 1
    fi

    if ! command -v jq >/dev/null 2>&1; then
        echo "Error: jq is not installed or not in PATH"
        exit 1
    fi

    if ! op account list >/dev/null 2>&1; then
        echo "Error: Not authenticated to 1Password. Run 'op signin' first."
        exit 1
    fi
}

# Check authentication when script is sourced
check_op_auth

#!/usr/bin/env bash
set -eo pipefail

# Script to run rclone with secrets from 1Password
# For local development use only

# Directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
TEMP_RCLONE_CONFIG="/tmp/rclone.conf"
TEMPLATE_CONFIG="$SCRIPT_DIR/rclone.conf.template"

# Source the shared 1Password secrets script
source "$SCRIPT_DIR/get-1password-secrets.sh"

# Running locally, fetch secrets from 1Password
echo "Fetching secrets from 1Password"

# Get all rclone environment variables
export_rclone_env_variables

# Create a temporary rclone config
cp "$TEMPLATE_CONFIG" "$TEMP_RCLONE_CONFIG"

# Set the config file location
export RCLONE_CONFIG="$TEMP_RCLONE_CONFIG"

# Run the actual rclone command with all arguments passed to this script
echo "Running rclone with secure configuration"
exec rclone "$@"

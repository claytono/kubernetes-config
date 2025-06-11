#!/bin/bash

set -eu -o pipefail

image=$(yq .spec.jobTemplate.spec.template.spec.containers[0].image <cronjob-azure.yaml)

mkdir -p "$(pwd)/.cache"
mkdir -p "$(pwd)/.tmp"
uuidgen >"$(pwd)/.tmp/uuid"

# Source the shared 1Password secrets script
source "$(dirname "$0")/get-1password-secrets.sh"

# Get resticprofile password
export_resticprofile_password

# Get all rclone environment variables
export_rclone_env_variables

# Now run the Docker container with all the necessary environment variables
docker run -it --rm \
    -e RESTIC_PASSWORD="$RESTIC_PASSWORD" \
    -e RESTIC_PASSWORD2="$RESTIC_PASSWORD" \
    -e RESTIC_FROM_PASSWORD="$RESTIC_PASSWORD" \
    -e RCLONE_RC_NO_AUTH=true \
    -e RCLONE_CONFIG_GSUITE_CLIENT_ID \
    -e RCLONE_CONFIG_GSUITE_CLIENT_SECRET \
    -e RCLONE_CONFIG_GSUITE_TOKEN \
    -e RCLONE_CONFIG_GSC_PASSWORD \
    -e RCLONE_CONFIG_GSC_PASSWORD2 \
    -e RCLONE_CONFIG_AZURE_KEY \
    -e RCLONE_CONFIG_AZC_PASSWORD \
    -e RCLONE_CONFIG_AZC_PASSWORD2 \
    -v "$(pwd)/.cache:/cache" \
    -v "$(pwd)/.tmp:/tmp" \
    -v "$(pwd)/profiles.yaml:/resticprofile-config/profiles.yaml:ro" \
    -v "$(pwd)/rclone.conf.template:/rclone-config/rclone.conf:ro" \
    "$image" \
    -c /resticprofile-config/profiles.yaml \
    --lock-wait 6h \
    "$@"

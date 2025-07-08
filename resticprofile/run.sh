#!/bin/bash

set -eu -o pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BASEDIR"

image=$(yq -r .spec.jobTemplate.spec.template.spec.containers[0].image <cronjob-b2.yaml)

mkdir -p .cache
mkdir -p .tmp
uuidgen >.tmp/uuid

source ./get-1password-secrets.sh

# Get resticprofile password
export_resticprofile_password

# Get all rclone environment variables
export_rclone_env_variables

# Now run the Docker container with the config file and necessary environment variables
docker run --rm \
	-e RESTIC_PASSWORD="$RESTIC_PASSWORD" \
	-e RESTIC_PASSWORD2="$RESTIC_PASSWORD" \
	-e RESTIC_FROM_PASSWORD="$RESTIC_PASSWORD" \
	-e RCLONE_RC_NO_AUTH=true \
	-e RCLONE_CONFIG_B2_ACCOUNT \
	-e RCLONE_CONFIG_B2_KEY \
	-e RCLONE_CONFIG_B2C_PASSWORD \
	-e RCLONE_CONFIG_B2C_PASSWORD2 \
	-v "$BASEDIR/.cache:/cache" \
	-v "$BASEDIR/.tmp:/tmp" \
	-v "$BASEDIR/profiles.yaml:/resticprofile-config/profiles.yaml:ro" \
	-v "$BASEDIR/rclone.conf:/rclone-config/rclone.conf:ro" \
	"$image" \
	-c /resticprofile-config/profiles.yaml \
	--lock-wait 6h \
	"$@"

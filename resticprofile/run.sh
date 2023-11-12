#!/bin/bash

set -eu -o pipefail

image=$(yq .spec.jobTemplate.spec.template.spec.containers[0].image <cronjob-azure.yaml)

mkdir -p "$(pwd)/.cache"
mkdir -p "$(pwd)/.tmp"
uuidgen >"$(pwd)/.tmp/uuid"

docker run -it --rm \
    --env-file secret.txt \
    -e RCLONE_RC_NO_AUTH=true \
    -v "$(pwd)/.cache:/cache" \
    -v "$(pwd)/.tmp:/tmp" \
    -v "$(pwd)/profiles.yaml:/resticprofile-config/profiles.yaml:ro" \
    -v "$(pwd)/rclone-config-secret.txt:/rclone-config/rclone.conf:ro" \
    "$image" \
    -c /resticprofile-config/profiles.yaml \
    --lock-wait 6h \
    "$@"

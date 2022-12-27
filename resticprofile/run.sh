#!/bin/bash

set -eu -o pipefail

image=$(yq .spec.jobTemplate.spec.template.spec.containers[0].image <cronjob-synology.yaml)

mkdir -p "$(pwd)/.cache"

docker run -it --rm \
    --env-file secret.txt \
    -v "$(pwd)/.cache:/cache" \
    -v "$(pwd)/profiles.yaml:/resticprofile-config/profiles.yaml:ro" \
    -v "$(pwd)/rclone-config-secret.txt:/rclone-config/rclone.conf:ro" \
    "$image" \
    -c /resticprofile-config/profiles.yaml \
    --lock-wait 6h \
    "$@"

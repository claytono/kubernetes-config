#!/bin/bash

set -eu -o pipefail

version=1.4.4

curl -L -O "https://github.com/cert-manager/cert-manager/releases/download/v${version}/cert-manager.yaml"

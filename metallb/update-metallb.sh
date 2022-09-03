#!/bin/bash

set -eu -o pipefail

version="v0.11.0"

curl -L -O "https://raw.githubusercontent.com/metallb/metallb/${version}/manifests/metallb.yaml"

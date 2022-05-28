#!/bin/bash

set -eu -o pipefail

version="v0.10.3"

curl -L -O "https://raw.githubusercontent.com/metallb/metallb/${version}/manifests/metallb.yaml"

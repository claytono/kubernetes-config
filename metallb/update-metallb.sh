#!/bin/bash

set -eu -o pipefail

version="v0.13.5"

curl -L -O "https://raw.githubusercontent.com/metallb/metallb/${version}/config/manifests/metallb-native.yaml"

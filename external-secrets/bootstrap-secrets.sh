#!/bin/bash

set -eu -o pipefail

# Get the 1Password Connect token and write it to secrets.txt
echo -n "token=" > secrets.txt
op document get external-secrets-token --vault Kubernetes >> secrets.txt 

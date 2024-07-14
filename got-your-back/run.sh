#!/bin/bash -xve

VERSION=1.81
ARCH=$(uname -m)
URL="https://github.com/GAM-team/got-your-back/releases/download/v${VERSION}/gyb-${VERSION}-linux-${ARCH}-glibc2.31.tar.xz"

cd /tmp
apt update
apt install curl xz-utils -y

curl -L -o gyb.tar.xz $URL
tar xvf gyb.tar.xz
mv gyb/gyb /usr/local/bin
rm -rf gyb gyb.tar.xz

cd /data
EMAIL_ADDRESS=$(echo $EMAIL_ADDRESS | tr -d '\n')
cp /config-source/account.secret.json "/config/${EMAIL_ADDRESS}.cfg"

flock --verbose --wait 14400 /data/lock \
  gyb --config /config/  --email "${EMAIL_ADDRESS}" "$@"

if [ -n "$PING_URL" ]; then
  curl -fsS -m 10 --retry 5 "$PING_URL"
fi

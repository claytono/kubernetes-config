#!/bin/bash -xve

VERSION=1.81
ARCH=$(uname -m)
URL="https://github.com/GAM-team/got-your-back/releases/download/v${VERSION}/gyb-${VERSION}-linux-${ARCH}-glibc2.31.tar.xz"

cd /tmp
apt update
apt install curl xz-utils -y

curl -L -o gyb.tar.xz "$URL"
tar xvf gyb.tar.xz
mv gyb/gyb /usr/local/bin
rm -rf gyb gyb.tar.xz

cd /data

cp -aL /config-source/* /config

old_filename=$(find /config -name "*.cfg")
new_filename="${old_filename//_/@}"
mv "$old_filename" "$new_filename"

email_address=$(basename "$new_filename" .cfg | grep -oP '[^/]+$' | sed 's/\.cfg//')

echo "Email address extracted and saved: $email_address"

flock --verbose --wait 14400 /data/lock \
	gyb --config /config/ --email "$email_address" "$@"

if [ -n "$PING_URL" ]; then
	curl -fsS -m 10 --retry 5 "$PING_URL"
fi

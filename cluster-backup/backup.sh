#!/bin/sh -xveu

TIMESTAMP=$(date -u -Isec|sed -e 's/UTC/Z/'|sed -e 's/+00:00/Z/')
BACKUPDIR=/backups/$TIMESTAMP
ETCD_VERSION=3.0.17
ETCDCTL=etcd-v${ETCD_VERSION}-linux-amd64/etcdctl

apt update
apt install wget rsync -y

wget "https://github.com/etcd-io/etcd/releases/download/v${ETCD_VERSION}/etcd-v${ETCD_VERSION}-linux-amd64.tar.gz"
tar xvf etcd-v${ETCD_VERSION}-linux-amd64.tar.gz  --wildcards '*/etcdctl'

mkdir -p "$BACKUPDIR/etcd"
$ETCDCTL backup \
    --data-dir /var/lib/etcd \
    --backup-dir "$BACKUPDIR/etcd"

rsync -av --exclude tmp /etc/kubernetes/ "$BACKUPDIR/kubernetes/"

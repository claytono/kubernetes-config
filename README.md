# Kubernetes Home Lab Manifests

This repository contains the Kubernetes manifests for my bare-metal home
Kubernetes environment.  In order to deploy from a fresh reinstall `kubectl
apply -R -f .` in the top level directory should be sufficent for everything to
come up and work.

## Ingress and Load Balancer Service

Ingress and Load Balancer HA are provided using keepalived along with the
[keepalived-cloud-provider](https://github.com/munnerz/keepalived-cloud-provider).
This also provides LoadBalancer services using IPVS.

Ingress is based on the stock NGINX ingress controller.

## External DNS

External DNS for ingress and service load balancer endpoints are provided using
the [external-dns](https://github.com/kubernetes-incubator/external-dns)
project configured to populate entries in Route 53.

## TLS for Ingress

TLS is provided for all Ingress services using the
[kube-cert-manager](https://github.com/PalmStoneGames/kube-cert-manager)
project.  This will request and renew a Let's Encrypt as needed and populate
the Ingress certificate resources.

This is no longer maintained but seems to work well for now.  It would
be nice to find a replacement at some point that is maintained.

## NFS Client Provisioner

The NFS client provisioner directory is prefixed with `0-` so that when
`kubectl apply -F -f .` is run, it will be the first thing applied.  This is
necessary in order for the default storage class to be in place before PVCs are
created.

Additionally, the NFS client provisioner is build using a fork from the
mainline.  The only difference from the main line code is that the path for the
PV created from a PVC is based solely on the PV name and when a PV is deleted,
the contents of the PV are not deleted.  This would almost certainly be a bad
idea outside of a single tenant lab environment, but is useful in that sort of
environment since it means that reinstalls of Kubernetes from scratch won't
lose PV contents.

## Backup

Backup of etcd and Kubernetes certificates are done twice a day via a
[Kubernetes
Cronjob](https://github.com/claytononeill/kubernetes-config/blob/master/cluster-backup.yaml).
The backups are stored on NFS which is also backed up offsite automatically.
The backup script can be in my
[kubernetes-backup](https://github.com/claytononeill/kubernetes-backup) repo.

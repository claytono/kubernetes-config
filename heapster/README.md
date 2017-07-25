# Kubernetes Heapster

This config is based on the example configs found here:

* https://github.com/kubernetes/heapster/tree/master/deploy/kube-config/influxdb
* https://github.com/kubernetes/heapster/tree/master/deploy/kube-config/rbac

I've added an ingress and changed the storage to be backed by statically
configured NFS stores.

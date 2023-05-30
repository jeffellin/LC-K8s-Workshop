Kubernetes is a scheduler based on "Resources" Each resource in kubernetes can be operated on in a similar fashion using the `kubectl` command. In addition components can also be hierarchical.

Deployment
   |_ ReplicaSet
      |_ Pod
         |_ Containers.


Some Common Vocabulary.

* ReplicaSet - A ReplicaSet's purpose is to maintain a stable set of replica Pods running at any given time. As such, it is often used to guarantee the availability of a specified number of identical Pods.

* Pod - Pods are the smallest deployable units of computing that you can create and manage in Kubernetes. A Pod (as in a pod of whales or pea pod) is a group of one or more containers, with shared storage and network resources, and a specification for how to run the containers. A Pod's contents are always co-located and co-scheduled, and run in a shared context. A

* Deployment - A Deployment provides declarative updates for Pods and ReplicaSets.
  
* PersistentVolume A PersistentVolume (PV) is a piece of storage in the cluster that has been provisioned by an administrator or dynamically provisioned using Storage Classes. It is a resource in the cluster just like a node is a cluster resource. PVs are volume plugins like Volumes, but have a lifecycle independent of any individual Pod that uses the PV. This API object captures the details of the implementation of the storage, be that NFS, iSCSI, or a cloud-provider-specific storage system.

* PersistentVolumeClaim (PVC) is a request for storage by a user. It is similar to a Pod. Pods consume node resources and PVCs consume PV resources. Pods can request specific levels of resources (CPU and Memory). Claims can request specific size and access modes (e.g., they can be mounted ReadWriteOnce, ReadOnlyMany or ReadWriteMany, see AccessModes).

* Service - A Service is a method for exposing a network application that is running as one or more Pods in your cluster.


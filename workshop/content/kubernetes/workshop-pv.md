# Storing Application Data with PersistentVolumes

Kubernetes creates the container filesystem and it can mount multiple sources. We've seen ConfigMaps which are typically read-only mounts, now we'll use writeable [volumes](https://kubernetes.io/docs/concepts/storage/volumes/).

Storage in Kubernetes is pluggable so it supports different types - from local disks on the nodes to shared network filesystems. 

Those details are kept away from the application model using an abstraction - the [PersistentVolumeClaim](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#introduction), which an app uses to request storage.

<details>
  <summary>YAML overview</summary>


The simplest PersistentVolumeClaim (PVC) looks like this:

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: small-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

As with ConfigMaps and Secrets, you use the PVC name to reference a volume in your Pod spec. The PVC spec defines its requirements:

* `accessModes` - describes if the storage is read-only or read-write, and whether it's exclusive to one node or can be accessed by many
* `resources` - the amount of storage the PVC needs

In the Pod spec you can include a PVC volume to mount in the container filesystem:

```
volumes:
  - name: cache-volume
    persistentVolumeClaim:
      claimName: small-pvc
```

</details><br />

## Data in the container's writeable layer

Before we get to PVCs, we'll look at other options for writing application data in Kubernetes.

Every container has a writeable layer which can be used to create and update files.

The demo app for this lab is a Pi-calculating website, which is fronted by an Nginx proxy. The proxy caches responses from the website to improve performance.

Deploy and try the app:

```execute-1
kubectl apply -f ~/exercises/labs/pvc/pi
```





> Browse to http://pi.{{session_namespace}}.{{ingress_domain}}?dp=30000 you'll see it takes over a second to calculate the response and send it

📋 Refresh and the response will be instant - check the response cache in Nginx, you can see it in the `/tmp` folder.

<details>
  <summary>Not sure how?</summary>

```execute-1
kubectl exec deploy/pi-proxy -- ls /tmp
```

</details><br />

Now stop the container process, which forces a Pod restart:

```execute-1
kubectl exec deploy/pi-proxy -- kill 1
```
Repeatedly run the following query until you see a new pi proxy pod in a running state.

```execute-1
kubectl get po -l app=pi-proxy
```

Check the `/tmp` folder in the new container and you'll see it's empty. Refresh your Pi app and it will take another second to load, because the cache is empty so it gets calculated again.

> ℹ Data in the container writeable layer has the same lifecycle as the container. When the container is replaced, the data is lost.

## Pod storage in EmptyDir volumes

Volumes mount storage into the container filesystem from an outside source.The simplest type of volume is called `EmptyDir` - it creates an empty directory at the Pod level, which Pod containers can mount.

You can use it for data which is not permanent, but which you'd like to survive a restart. It's perfect for keeping a local cache of data.

The following spec uses an EmptyDir volume, mounting it to the `/tmp` directory

```editor:open-file
file: ~/exercises/labs/pvc/caching-proxy-emptydir/nginx.yaml
```

This is a change to the Pod spec, so you'll get a new Pod with a new empty directory volume:

```execute-1
kubectl apply -f ~/exercises/labs/pvc/caching-proxy-emptydir
```
```execute-1
kubectl wait --for=condition=Ready pod -l app=pi-proxy,storage=emptydir
```

Refresh your page to see the Pi calculation happen again - the result gets cached and you'll see the  `/tmp` folder filling up.

> The container sees the same filesystem structure, but now the /tmp folder is mounted from the EmptyDir volume

📋 Stop the Nginx process and the Pod will restart. Check the `tmp` folder in the new container to see if the old data is still available.

<details>
  <summary>Not sure how?</summary>

```execute-1
kubectl exec deploy/pi-proxy -- kill 1
```
```execute-1
kubectl get pods -l app=pi-proxy,storage=emptydir 
```
```execute-1
kubectl exec deploy/pi-proxy -- ls /tmp
```

</details><br />

Refresh the site with the new container and it loads instantly.

If you delete the Pod then the Deployment will create a replacement - with a new EmptyDir volume which will be empty.

> ℹ Data in EmptyDir volumes has the same lifecycle as the Pod. When the Pod is replaced, the data is lost.

## External storage with PersistentVolumeClaims

Persistent storage is about using volumes which have a separate lifecyle from the app - so the data persists when containers and Pods get replaced.

Storage in Kubernetes is pluggable, and production clusters will usually have multiple types on offer, defined as [Storage Classes](https://kubernetes.io/docs/concepts/storage/storage-classes/):

```execute-1
kubectl get storageclass
```

You'll see a single StorageClass in Docker Desktop and k3d, but in a cloud service like AKS you'd see many, each with different properties (e.g. a fast SSD that can be attached to one node, or a shared network storage location which can be used by many nodes).

You can create a PersistentVolumeClaim with a named StorageClass, or omit the class to use the default.

- `pvc.yaml`requests 1GB of storage, which a single node can mount for read-write access

```editor:open-file
file: ~/exercises/labs/pvc/caching-proxy-pvc/pvc.yaml
```

```execute-1
kubectl apply -f ~/exercises/labs/pvc/caching-proxy-pvc/pvc.yaml
```

Each StorageClass has a provisioner which can create the storage unit on-demand.


📋 List the persistent volumes and claims.

<details>
  <summary>Not sure how?</summary>

```execute-1
kubectl get pvc
```
Let's see why it is still in a pending state.

```execute-1
kubectl describe pvc pi-proxy-pvc
```

> Some provisioners create storage as soon as the PVC is created - others wait for the PVC to be claimed by a Pod

</details><br />

Update the Nginx proxy to use the PVC: 

```editor:open-file
file: ~/exercises/labs/pvc/caching-proxy-emptydir/nginx.yaml
```


```execute-1
kubectl apply -f ~/exercises/labs/pvc/caching-proxy-pvc/
```
```execute-1
kubectl wait --for=condition=Ready pod -l app=pi-proxy,storage=pvc
```
```execute-1
kubectl get pvc
```

> Now the PVC is bound and the PersistentVolume exists with the requested size and access mode in the PVC

How would you display info about the PersistentVolume that is associated with the PersistentVolumeClaim.

<details>
  <summary>Not sure how?</summary>

  ```execute-1
  kubectl get pv 
  ```
</details>


The PVC starts off empty. Refresh the app and you'll see the `/tmp` folder getting filled. 

📋 Restart and then replace the Pod and confirm the data in the PVC survives both.

<details>
  <summary>Not sure how?</summary>

```execute-1
# force the container to exit
kubectl exec deploy/pi-proxy -- kill 1
```
```execute-1
kubectl get pods -l app=pi-proxy,storage=pvc
```
```execute-1
kubectl exec deploy/pi-proxy -- ls /tmp
```

```execute-1
# force a rollout to replace the Pod
kubectl rollout restart deploy/pi-proxy
```
```execute-1
kubectl get pods -l app=pi-proxy,storage=pvc
```
```execute-1
kubectl exec deploy/pi-proxy -- ls /tmp
```

Try the app again and the new Pod still serves the response from the cache, so it will be super fast.

</details><br />

> ℹ Data in PersistentVolumes has its own lifecycle. It survives until the PV is removed.


## Cleanup

```execute-1
kubectl delete all,cm,pvc -l kubernetes.courselabs.co=persistentvolumes
```
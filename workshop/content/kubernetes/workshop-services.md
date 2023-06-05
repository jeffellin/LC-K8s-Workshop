# Networking Pods with Services

Every Pod has an IP address which other Pods in the cluster can reach, but that IP address only applies for the life of the Pod.

[Services](https://kubernetes.io/docs/concepts/services-networking/service/) provide a consistent IP address linked to a DNS name, and you'll always use Services for routing internal and external traffic into Pods.

Services and Pods are loosely-coupled: a Service finds target Pods using a [label selector](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/).

<details>
  <summary>YAML overview</summary>

Service definitions have the usual metadata. The spec needs to include the network ports and the label selector:

```
apiVersion: v1
kind: Service
metadata:
  name: whoami
spec:
  selector:
    app: whoami
  ports:
    - name: http
      port: 80
      targetPort: 80
```

The ports are where the Service listens, and the label selector can match zero to many Pods.

* `selector` - list of labels to find target Pods
* `ports` - list of ports to listen on
* `name` - port name within Kubernetes
* `port` - port the Service listens on
* `targetPort` - port on the Pod where traffic gets sent

## Pod YAML

Pods need to include matching labels to receive traffic from the Service.

Labels are specified in metadata:

```
apiVersion: v1
kind: Pod
metadata:
  name: whoami
  labels:
    app: whoami
spec:
  # ...
```

> Labels are abitrary key-value pairs. `app`, `component` and `version` are typically used for application Pods.

</details><br/>

## Run sample Pods

Start by creating some simple Pods from definitions which contain labels:

* [whoami.yaml](specs/pods/whoami.yaml) ~/exercises/labs/services/specs/pods/whoami-pod.yaml
* [sleep.yaml](specs/pods/sleep.yaml) ~/exercises/labs/services/specs/pods/sleep-pod.yaml

```execute-1
kubectl apply -f ~/exercises/labs/services/specs/pods
```

> You can work with multiple objects and deploy multiple YAML manifests with Kubectl

📋 Check the status for all Pods, printing all the IP addresses and labels.

<details>
  <summary>Not sure how?</summary>

```execute-1
kubectl get pods -o wide --show-labels
```

</details><br/>

The Pod name has no affect on networking, Pods can't find each other by name:

```
kubectl exec sleep -- nslookup whoami.{{session_namespace}}.svc.cluster.local
```

## Deploy an internal Service

Kubernetes provides different types of Service for internal and external access to Pods. 

[ClusterIP](https://kubernetes.io/docs/concepts/services-networking/connect-applications-service/) is the default and it means the Service gets an IP address which is only accessible within the cluster - its for components to communicate internally.

* [whoami-clusterip.yaml](specs/services/whoami-clusterip.yaml) defines a ClusterIP service which routes traffic to the whoami Pod

📋 Deploy the Service from `~/exercises/labs/services/specs/services/` and print its details.

<details>
  <summary>Not sure how?</summary>

```
 kubectl apply -f ~/exercises/labs/services/specs/services/
```

Print the details:

```
kubectl get service whoami

kubectl describe svc whoami
```

> The `get` and `describe` commands are the same for all objects; Services have the alias `svc`

</details><br/>

The Service has its own IP address, and that is static for the life of the Service.

## Use DNS to find the Service

Kubernetes runs a DNS server inside the cluster and every Service gets an entry, linking the IP address to the Service name.

```
kubectl exec sleep -- nslookup nslookup whoami.{{session_namespace}}.svc.cluster.local
```

> This gets the IP address of the Service from its DNS name. The first line is the IP address of the Kuberentes DNS server itself.

Now the Pods can communicate using DNS names:

```
kubectl exec sleep -- curl -s http://whoami.{{session_namespace}}.svc.cluster.local
```

📋 Recreate the whoami Pod and the replacement will have a new IP address - but service resolution with DNS still works. 

<details>
  <summary>Not sure how?</summary>

Check the current IP address then delete the Pod:

```
kubectl get pods -o wide -l app=whoami

kubectl delete pods -l app=whoami
```

> You can use label selectors in Kubectl too - labels are a powerful management tool

Create a replacement Pod and check its IP address:

```
kubectl apply -f ~/exercises/labs/services/specs/pods

kubectl get pods -o wide -l app=whoami
```

</details><br/>

The Service IP address doesn't change, so if clients cache that IP they'll still work. Now the Service routes traffic to the new Pod:

```
kubectl exec sleep -- nslookup whoami.{{session_namespace}}.svc.cluster.local

kubectl exec sleep -- curl -s http://whoami.{{session_namespace}}.svc.cluster.local
```

## Understanding external Services

There are two types of Service which can be accessed outside of the cluster: [LoadBalancer](https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/) and [NodePort](https://kubernetes.io/docs/concepts/services-networking/service/#nodeport).

They both listen for traffic coming into the cluster and route it to Pods, but they work in different ways. LoadBalancers are easier to work with, but not every Kubernetes cluster supports them.

> In this course we'll deploy services with ClusterIPs and expose them through a common IP address called an Ingress.

<details>
  <summary>ℹ What is an Ingress</summary>

An API object that manages external access to the services in a cluster, typically HTTP.

Ingress may provide load balancing, SSL termination and name-based virtual hosting.

![Ingress](../images/ingress.svg)

An Ingress may be configured to give Services externally-reachable URLs, load balance traffic, terminate SSL / TLS, and offer name-based virtual hosting. An Ingress controller is responsible for fulfilling the Ingress, usually with a load balancer, though it may also configure your edge router or additional frontends to help handle the traffic.



</details><br/>

## Deploy an external Service

There are two Service definitions to make the whoami app available outside the cluster:

```editor:open-file
file: ~/exercises/labs/services/specs/ingress/ingress.yaml
```

You can deploy with:

```
kubectl apply -f ~/exercises/labs/services/specs/ingress
```

📋 Print the details for the ingress - both have the label `app=whoami`.

<details>
  <summary>Not sure how?</summary>

```
kubectl get ing  whoami-ingress
```
</details><br/>

## Lab

Services are a networking abstraction - they're like routers which listen for incoming traffic and direct it to Pods.

Target Pods are identified with a label selector, and there could be zero or more matches.

Create new Services and whoami Pods to test these scenarios:

* zero Pods match the label spec
* multiple Pods match the label spec

What happens? How can you find the target Pods for a Service?

> Stuck? Try [hints](exercises/labs/services/solution/hints.md) or check the [solution](exercises/labs/services/solution/solution.md).

___
## Cleanup

Every YAML spec for this lab adds a label `kubernetes.courselabs.co=services` .

That makes it super easy to clean up, by deleting all those resources:

```
kubectl delete pod,svc,ing -l kubernetes.courselabs.co=services
```
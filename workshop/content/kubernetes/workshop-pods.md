# Running Containers in Pods

The [Pod](https://kubernetes.io/docs/concepts/workloads/pods/) is the basic unit of compute in Kubernetes. Pods run containers - it's their job to ensure the container keeps running.

Pod specs are very simple. The minimal YAML needs some metadata, and the name of the container image to run.

Containers within a pod share an IP address and port space, and can find each other via localhost
Containers in a Pod also share the same data volumes
Pods are considered to be ephemeral



<details>
  <summary>YAML overview</summary>

This is as simple as it gets for a Pod:

```
apiVersion: v1
kind: Pod
metadata:
  name: whoami
spec:
  containers:
    - name: app
      image: sixeyed/whoami:21.04
```

Every Kubernetes resource requires these four fields:

* `apiVersion` - resources are versioned to support backwards compatibility
* `kind` - the type of the object
* `metadata` - collection of additional object data
* `name` - the name of the object

The format of the `spec` field is different for every object type. For Pods, this is the minimum you need:

* `containers`- list of containers to run in the Pod
* `name` - the name of the container
* `image` - the Docker image to run

> Indentation is important in YAML - object fields are nested with spaces. 

</details><br/>

## Run a simple Pod

Kubectl is the tool for managing objects. You create any object from YAML using the `apply` command.


```editor:open-file
file: "~/exercises/labs/pods/whoami-pod.yaml"
```

is the Pod spec for a simple web app


Deploy the app from your local copy of the course repo:

```execute-1
kubectl apply -f ~/exercises/labs/pods/whoami-pod.yaml
```


> The output shows you what objects have changed. 

Now you can use the familiar commands to print information:

```execute-1
kubectl get pods
```
```execute-1
kubectl get po -o wide
```

> The second command uses the short name `po` and adds extra columns, including the Pod IP address

What extra information do you see in the second output, and how would you print all the Pod information in a readble format?

<details>
  <summary>Not sure how?</summary>

```
kubectl describe pod <podname>
```
</details><br/>

## Working with Pods

In a production cluster the Pod could be running on any node. You manage it using Kubectl so you don't need access to the server directly.

📋 Print the container logs.

<details>
  <summary>Not sure how?</summary>

```execute-1
kubectl logs whoami
```
</details><br/>

Connect to the container inside the Pod:

```execute-1
# this will fail:
kubectl exec -it whoami -- sh
```

> This container image doesn't have a shell installed!

Let's try another app:

```editor:open-file
file: ~/exercises/labs/pods/sleep-pod.yaml
```

runs an app which does nothing

📋 Deploy the new app from `exercises/labs/pods/sleep-pod.yaml` and check if it is running.

<details>
  <summary>Not sure how?</summary>

```execute-1
kubectl apply -f ~/exercises/labs/pods/sleep-pod.yaml
```
```execute-1
kubectl get pods
```
</details><br/>

This Pod container does have a shell, and it has some useful tools installed.

```execute-1
kubectl exec -it sleep -- sh
```

Now you're connected inside the container; you can explore the container environment:

```execute-1
hostname
```

```execute-1
whoami
```

## Connecting from one Pod to another

Exit the shell session on the sleep Pod:

```execute-1
exit
```

📋 Print the IP address of the original whoami Pod.

<details>
  <summary>Not sure how?</summary>

```execute-1
kubectl get pods -o wide whoami
```
</details><br/>

> That's the internal IP address of the Pod - any other Pod in the cluster can connect on that address

Make a request to the HTTP server in the whoami Pod from the sleep Pod:

```execute-1
kubectl exec sleep -- curl -s <whoami-pod-ip>
```

> The output is the response from the whoami server - it includes the  hostname and IP addresses

## Lab

Pods are an abstraction over containers. They monitor the container and if it exits the Pod restarts, creating a new container to keep your app running. This is the first layer of high-availability Kubernetes provides.

You can see this in action with a badly-configured app, where the container keeps exiting. Write a Pod spec to run a container from the Docker Hub image `courselabs/bad-sleep`. Deploy your spec and watch the Pod - what happens after about 30 seconds? And after a couple of minutes?

Kubernetes will keep trying to make the Pod work, so you'll want to remove it when you're done.


<details>
  <summary>Need a Hint?</summary>

Pod specs are pretty simple - you don't need any more in your YAML than we've already used in the exercises folder from this lab.

When you run your Pod it should start and go into the running state, but because the application is misconfured, it won't keep running.

After you've seen the lifecycle of the Pod, you can use Kubectl to delete it.

</details><br/>

___
## Cleanup

We'll clean up before we move on, deleting all the Pods we created:

```execute-1
kubectl delete pod sleep whoami sleep-lab
```
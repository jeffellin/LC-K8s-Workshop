## Nodes

Consists of a control plane and a group of worker nodes 

Nodes are responsible for executing the tasks assigned by the Kubernetes control plane, which manages and orchestrates the containers. The control plane determines where to schedule containers based on resource availability, application requirements, and other factors.

Nodes are where the actual workloads or applications are deployed and run. These workloads are encapsulated in containers, which are like isolated compartments holding your applications and their dependencies.

Kubernetes clusters typically have multiple nodes to distribute the workload and ensure high availability. Having multiple nodes allows for better resource utilization, load balancing, and fault tolerance. If a node becomes unavailable or experiences issues, Kubernetes can reschedule the containers on other available nodes to maintain the desired state of the applications.

## Namespaces

A namespace is a way to logically divide and isolate resources within a cluster. It is like a virtual partition or a separate area within the Kubernetes cluster where you can organize and group related objects.

Think of a namespace as a separate room or a container that holds a specific set of things. Just as you might have different rooms in your house for different purposes, Kubernetes namespaces allow you to create separate environments for different applications, teams, or projects.

Namespace helps in organizing and managing your applications or services more effectively. For example, if you have two teams working on different projects, you can create separate namespaces for each team. This way, each team can manage their resources independently without interfering with each other

**Not all objects are in a namespace**. Most Kubernetes resources (e.g. pods, services, replication controllers, and others) are in some namespaces. However namespace resources are not themselves in a namespace. And low-level resources, such as nodes and persistentVolumes, are not in any namespace.

For this workshop you are given access to namespace of your own.  You will not be able to see system wide resources. 
# What is a Container

A container is a way of creating an isolated environment to run an application.


## Why use a container

Why are containers useful?

* __Portability__ – the isolated environment that containers provide effectively means the container is decoupled from the environment in which they run. Basically, they don’t care much about the environment in which they run, which means they can be run in many different environments with different operating systems and hardware platforms.

* __Consistency__ – since the containers are decoupled from the environment in which they run, you can be sure that they operate the same, regardless of where they are deployed. The isolated environment that they provide is the same across different deployment environments.

* __Speed to deploy__ – for the same reasons as above. There is no need for considerations around how the application will operate in a production environment. If it runs in a container in one environment (say, your local machine), then it can be made to run in a container in another environment (say, in a cloud provider) very quickly

## Containers vs Virtual Machines

![VM](../images/container-vs-virtual-machine.png)

## Containers

![Containers](../images/docker-containerized-appliction-blue-border_2.webp)

Container deployments provide an additional layer of abstraction of an individual service. It helps eliminate the “compatibility matrix from hell.” What version of Java is required, which python libraries, etc.

One common misconception of containers: people sometimes describe and dismiss Docker containers as virtualization within virtualization or “doubly virtualized,” the implication being that performance suffers. This doesn’t actually mean what most people think it means. Traditional virtualization uses a hypervisor to carve out a slice of available hardware. On top of that slice, a full operating system is run. Containers assign resources to protected areas of an existing operating system. Two containers on the same host are shielded from each other by kernel name spacing but the resources running in that container have the same access to the resources on the host. Issuing the top command on a Docker host will reveal all the processes on the machine including those running inside a container.

If a container is not running an application, it does not consume any resources. When launching a container, it will start almost instantaneously as the entire operating system is not loaded. When shutting down a container, the process running inside the container is simply terminated. In contrast, a virtual machine will consume resources whenever it is running, even if it isn’t doing anything. It is conceivable to share a single docker host across multiple applications thus getting better utilization of virtual hardware.

Due to the design of containers, they each can have their own requirements, Java Version, Libraries, etc. without worrying about dependency clash. The developer can specify which versions they support and don’t have to worry about end users installing the wrong dependencies.


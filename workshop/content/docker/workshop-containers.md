## Infrastructure as Code

Modern software applications have become much more complex, In many cases, applications have many different tiers such as database, web, service, messaging, etc. The popularity of micro services has further multiplied the number of pieces within a production solution.
The idea of Infrastructure as Code attempts to tackle this problem.

Consider a typical software development scenario where the developer of a component must perform a basic level of testing before they can call their assignment complete. This testing will usually involve setting up a local development environment. In order to do a complete test it may require installation of a database, a messaging system, and/or any number of web components. When it’s time for the QA team to test the software, the whole process test setup process must be repeated. When the code goes to production, the process that the QA team and the developer setup must again be repeated exactly in order to guarantee the software works as expected.

Successful deployment requires all moving parts of the system to be deployed as built and tested. Software must be installed properly; correct versions of java, operating systems, libraries etc must be installed precisely as specified. If there is a deviation from the tested setup – from software, to third party libraries, to operating system – the software may not work as intended.
If the QA person is lucky, the developer has adequately documented the software’s requirements, such as software dependencies, order of installation, and changes made from standard configuration files. If not properly documented, well….good luck.

Infrastructure as code means that the steps required to build an environment are enumerated in a file that can be run in a repeatable fashion and can be stored and versioned in a source control repository like any other piece of code.

## Containers

Container deployments provide an additional layer of abstraction of an individual service. It helps eliminate the “compatibility matrix from hell.” What version of Java is required, which python libraries, etc.

One common misconception of containers: people sometimes describe and dismiss Docker containers as virtualization within virtualization or “doubly virtualized,” the implication being that performance suffers. This doesn’t actually mean what most people think it means. Traditional virtualization uses a hypervisor to carve out a slice of available hardware. On top of that slice, a full operating system is run. Containers assign resources to protected areas of an existing operating system. Two containers on the same host are shielded from each other by kernel name spacing but the resources running in that container have the same access to the resources on the host. Issuing the top command on a Docker host will reveal all the processes on the machine including those running inside a container.

If a container is not running an application, it does not consume any resources. When launching a container, it will start almost instantaneously as the entire operating system is not loaded. When shutting down a container, the process running inside the container is simply terminated. In contrast, a virtual machine will consume resources whenever it is running, even if it isn’t doing anything. It is conceivable to share a single docker host across multiple applications thus getting better utilization of virtual hardware.

Due to the design of containers, they each can have their own requirements, Java Version, Libraries, etc. without worrying about dependency clash. The developer can specify which versions they support and don’t have to worry about end users installing the wrong dependencies.

Containers are as easy to construct as writing a script. Consider the following Dockerfile that runs a micro service.

```
FROM java:8-jre
MAINTAINER jeff@ellin.com
WORKDIR /work
VOLUME /work
#This is the drop wizard jar.</span>
ADD server.jar /work/
ADD app-settings.yml /work/

CMD ["java", "-jar" "server.jar" ,"server", "app-settings.yml"]
```

This file defines a container image that utilizes a specific version of Java. When the container is built, the commands in the Dockerfile are executed and cached. When running the container only, the CMD line is run resulting in near instantaneous startup.

JM
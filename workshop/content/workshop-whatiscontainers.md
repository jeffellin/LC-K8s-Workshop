# What is a Container

A container is a way of creating an isolated environment to run an application.


## Why use a container

Why are containers useful?

* __Portability__ – the isolated environment that containers provide effectively means the container is decoupled from the environment in which they run. Basically, they don’t care much about the environment in which they run, which means they can be run in many different environments with different operating systems and hardware platforms.

* __Consistency__ – since the containers are decoupled from the environment in which they run, you can be sure that they operate the same, regardless of where they are deployed. The isolated environment that they provide is the same across different deployment environments.

* __Speed to deploy__ – for the same reasons as above. There is no need for considerations around how the application will operate in a production environment. If it runs in a container in one environment (say, your local machine), then it can be made to run in a container in another environment (say, in a cloud provider) very quickly
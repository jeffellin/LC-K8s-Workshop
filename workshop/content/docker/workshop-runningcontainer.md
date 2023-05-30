Let us start our journy by running our first container.

## Getting Started

```execute-1
docker run hello-world
```

This command will create a container based on the `hello-world` image.   This imsage simply outputs some text to std out.  

Let's try something more ambitious.

```execute-1
docker run -ti ubuntu
```

This command will create a container based on the `ubuntu` image.  Since we have added the `-ti` flag which stands for "terminal interactive" we are left with a prompt that we can use to interact with the container.

Lets try running some commands

```execute-1
ps
```


```execute-1
ls -la
```

and we can quit with
```execute-1
exit
```
## Daemon Processes.

While running a container that outputs to std out is a neat trick ( hint: useful for batch jobs) most commonly you will be working with applications that you would to run in the background.  For example a webserver such as NGINX.  Lets try that now.

```execute-1
docker run -d -p 8080:80 nginx
```

Here we have introduced two additional flags.

* -p 8080:80  The NGINX server configured inside the image uses port 80.  We would like to open port 8080 on the local host to port 80 inside the container.
* -d run this container as a daemon.

You can verify that the container is running as follows.

```execute-1
docker ps
```

Lets verify that the container works as desired

```execute-1
curl http://localhost:8080
```

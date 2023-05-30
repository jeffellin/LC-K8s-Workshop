## Building your first container.

Let us build a very simple container. For this we are going to use a small web server based on Python called Flask. 

The basis for a container built with Docker is a `Dockerfile`

```editor:select-matching-text
file: ~/exercises/flask-docker/Dockerfile
text: "FROM python:3.8-alpine"
before: 1
after: 1
```
This first section describes the container we will use as a basis.  It is a prebuilt container which containers python 3.8 and alpine linux.

```editor:select-matching-text
file: ~/exercises/flask-docker/Dockerfile
text: "COPY ./requirements.txt /app/requirements.txt"
before: 1
after: 1
```

This section adds our desired files into the container

```editor:select-matching-text
file: ~/exercises/flask-docker/Dockerfile
text: "RUN pip install -r requirements.txt"
before: 1
after: 1
```
This uses pip to install the required files.

```editor:select-matching-text
file: ~/exercises/flask-docker/Dockerfile
text: "COPY . /app"
before: 1
after: 1
```
This uses pip to install the required files.


```editor:select-matching-text
file: ~/exercises/flask-docker/Dockerfile
text: "CMD ["python", "app.py" ]"
CMD ["python", "app.py" ]
before: 1
after: 1
```
This uses pip to install the required files.

```execute-1
echo "Execute command."
```

```copy
echo "Text to copy."
```

```copy-and-edit
echo "Text to copy and edit."
```

```terminal:execute
command: echo "Execute command."
```

```terminal:input
text: password
```

```dashboard:open-url
url: http://localhost:80/
```

```editor:select-matching-text
file: ~/exercises/flask-docker/Dockerfile
text: "FROM python:3.8-alpine"
before: 1
after: 1
```


```execute-1
echo "Execute command."
```

```copy
echo "Text to copy."
```

```copy-and-edit
echo "Text to copy and edit."
```

```terminal:execute
command: echo "Execute command."
```

```terminal:input
text: password
```

```dashboard:open-url
url: http://localhost:80/
```

```editor:select-matching-text
file: ~/exercises/flask-docker/Dockerfile
text: "FROM python:3.8-alpine"
before: 1
after: 1
```


# Docker images can be inherited from other images. Therefore, instead of creating our own base image, 
# we’ll use the official Go image that already has all the tools and packages to compile and run a Go application. 
# You can think of this in the same way you would think about class inheritance in object oriented programming 
# or functional composition in functional programming.

FROM golang:1.19 AS build


# To make things easier when running the rest of our commands, let’s create a directory inside the image that we are building. 
# This also instructs Docker to use this directory as the default destination for all subsequent commands. 
# This way we do not have to type out full file paths but can use relative paths based on this directory.
WORKDIR /app

# In its simplest form, the COPY command takes two parameters. 
# The first parameter tells Docker what files you want to copy into the image. 
# The last parameter tells Docker where you want that file to be copied to.
# We’ll copy the go.mod and go.sum file into our project directory /app which, owing to our use of WORKDIR, 
# is the current directory (.) inside the image.
COPY go.mod ./
COPY go.sum ./


# Now that we have the module files inside the Docker image that we are building, 
# we can use the RUN command to execute the command go mod download there as well. 
# This works exactly the same as if we were running go locally on our machine, 
# but this time these Go modules will be installed into a directory inside the image.

RUN go mod download

# The next thing we need to do is to copy our source code into the image. 
# We’ll use the COPY command just like we did with our module files before.

COPY *.go ./

# Now, we would like to compile our application. To that end, we use the familiar RUN command:

RUN go build -o /docker-gs-ping

EXPOSE 8080

CMD [ "/docker-gs-ping" ]


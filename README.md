# Tricks and tips and common pitfalls when writing Dockerfiles

Recently I have been working quite a lot with Docker. When I got to believe that I know everything about writing Dockerfiles, I attended Docker conf online to learn how much more it offers. This repository illustrate my blogpost on writing good Dockerfiles. 

## Preview
![screenshot](https://github.com/aslaski/dockerfiles/raw/master/phrase-preview.png)

## How tu run
Frontend:

    docker build -f frontend/v1-naive.Dockerfile frontend/ -t frontend:naive
    docker build -f frontend/v2-multi-stage.Dockerfile frontend/ -t frontend:multi-stage
    DOCKER_BUILDKIT=1 docker build -f frontend/v3-experimental-cache.Dockerfile frontend/ -t frontend:experimental-cache
Microservice:

    docker build -f microservice/v1-naive.Dockerfile microservice/ -t microservice:naive
    docker build -f microservice/v2-multi-stage.Dockerfile microservice/ -t microservice:multi-stage
    docker build -f microservice/v3-without-ubuntu.Dockerfile microservice/ -t microservice:without-ubuntu
    DOCKER_BUILDKIT=1 docker build -f microservice/v4-experimental-cache.Dockerfile microservice/ -t microservice:experimental-cache
Docker compose:

    COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker-compose up --build


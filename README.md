# Docker by example

naive version

    docker-compose -f v1/docker-compose.yml up --build

multi stage builds to reduce build size

    docker-compose -f v2/docker-compose.yml up --build

buildkit to run stages in parallel (faster)

    COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker-compose -f v2/docker-compose.yml up --build

experimental cache to avoid downloading dependencies each time (even faster)

    COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker-compose -f v3/docker-compose.yml up --build

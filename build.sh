#!/bin/bash
set -e

./download.sh
CID=$(docker run -d -v "$(pwd)"/dist:/usr/share/nginx/html:ro nginx:alpine)
docker build \
    --build-arg WEBHOST="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$CID")" \
    -t infactum/onec_thick_client \
    thick_client/
docker stop "$CID" && docker rm "$CID"
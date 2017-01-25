#!/bin/bash
set -e

case "$@" in
    "--no-tag") VERSION="latest";;
esac

if [ -z "$VERSION" ]
then
    echo "VERSION not set"
    exit 1
fi

CID=$(docker run -d -v "$(pwd)"/dist:/usr/share/nginx/html:ro nginx:alpine)
docker build \
    --build-arg WEBHOST="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$CID")" \
    -t infactum/onec_thick_client:"$VERSION" \
    thick_client/
docker stop "$CID" && docker rm "$CID"
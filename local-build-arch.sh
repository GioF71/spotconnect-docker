#!/bin/bash

TODAY=$(date '+%Y-%m-%d')

echo "TODAY=${TODAY}"

docker buildx build . \
    --progress=plain \
    --platform linux/amd64,linux/arm64/v8,linux/arm/v7,linux/arm/v6 \
    --tag giof71/spotconnect:latest \
    --tag giof71/spotconnect:stable \
    --tag giof71/spotconnect:debian \
    --tag giof71/spotconnect:debian-${TODAY} \
    --push

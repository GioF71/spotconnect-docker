#!/bin/bash

mkdir -p /app/release
cd /app/release
wget "https://github.com/philippe44/SpotConnect/releases/download/${SPOTCONNECT_VERSION}/SpotConnect-${SPOTCONNECT_VERSION}.zip"
unzip SpotConnect*zip
rm SpotConnect*zip


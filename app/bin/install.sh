#!/bin/bash

# errors
# 1 missing binary file

set -ex

mkdir /app/release -p
mkdir /app/bin -p

ARCH=`dpkg --print-architecture`
echo "ARCH=[$ARCH]"

arch_amd64=amd64
arch_arm_v6=armel
arch_arm_v7=armhf
arch_arm_v8=arm64

prefix=("spotupnp" "spotraop")

declare -A bin_file_name
bin_file_name[$arch_amd64]="linux-x86_64"
bin_file_name[$arch_arm_v6]="linux-armv5"
bin_file_name[$arch_arm_v7]="linux-arm"
bin_file_name[$arch_arm_v8]="linux-aarch64"

mkdir -p /app/bin
mkdir -p /app/conf

for prefix in "${prefix[@]}"
do
    echo "Installing $prefix for architecture [${ARCH}] ..."
    arch_filename=${bin_file_name["${ARCH}"]}
    binary_file="$prefix-$arch_filename"
    if [ ! -f "/app/release/$binary_file" ]; then
        echo "File /app/release/$binary_file not found"
        exit 1
    fi
    binary_file_static="$binary_file-static"
    if [ ! -f "/app/release/$binary_file_static" ]; then
        echo "File /app/release/$binary_file_static not found"
        exit 1
    fi
    mv "/app/release/$binary_file" "/app/bin/$prefix-linux"
    chmod 755 "/app/bin/$prefix-linux"
    mv "/app/release/$binary_file_static" "/app/bin/$prefix-linux-static"
    chmod 755 "/app/bin/$prefix-linux-static"
    echo "Installed $prefix for architecture [${ARCH}]."
done

echo "$SPOTCONNECT_VERSION" > /app/bin/version.txt


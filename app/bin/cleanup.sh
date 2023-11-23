#!/bin/bash

rm -Rf /app/release/

apt-get remove -y wget unzip
apt-get autoremove -y

rm -rf /var/lib/apt/lists/*

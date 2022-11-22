#!/bin/bash

# Used to install rsync for deployments
apt-get update -y
apt-get -y install rsync

# Install HEXO
npm install -g hexo

# Check to ensure the /config volume is mounted
if [ ! -d "/config" ]; then
    echo "Please mount a /config directory so you blog persists upon container restarts!"
    echo "If this is your first time setting up the container make sure the /config directory is empty!"
    exit 1
fi

echo "Linking configs to blog runtime dir..."
ln -s /config /blog

if [ -z "$(ls -A /config)" ]; then
    echo "Blog not yet initialized, setting up the default files..."
    # Initilize the blog
    hexo init /blog
else
    echo "Blog already initialized, skipping..."
fi

# Copy bootstrap scrpt
cp /setup/run.sh /blog/run.sh

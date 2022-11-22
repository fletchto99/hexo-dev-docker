#!/bin/bash

# Check to ensure the /config volume is mounted
if [ ! -d "/config" ]; then
  echo "Please mount a /config directory so you blog persists upon container restarts!"
  echo "If this is your first time setting up the container make sure the /config directory is empty!"
  exit 1
fi

if [ -z "$(ls -A /config)" ]; then
  echo "Blog not yet initialized, setting up the default files..."
  # Initilize the blog
  hexo init /config
else
  echo "Blog already initialized, skipping..."
fi

# Install any required hexo plugins
if [[ -z "${HEXO_PLUGINS}" ]]; then
  echo "No additional plugins to install!"
else
  echo "Installing additional plugins \"${HEXO_PLUGINS}\""
  npm install "${HEXO_PLUGINS}"
fi

# Start the server
echo "Starting hexo server on port 8080"

# Start fresh
cd /config || exit 1
hexo clean || true
hexo server -p 8080 --debug --draft

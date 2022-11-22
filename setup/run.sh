#!/bin/bash

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
hexo clean || true
hexo server -p 8080 --debug --draft

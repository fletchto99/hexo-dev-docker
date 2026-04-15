#!/bin/bash
set -e

# Check to ensure the /config volume is mounted
if [ ! -d "/config" ]; then
  echo "Please mount a /config directory so your blog persists upon container restarts!"
  echo "If this is your first time setting up the container make sure the /config directory is empty!"
  exit 1
fi

if [ -z "$(ls -A /config)" ]; then
  echo "Blog not yet initialized, setting up the default files..."
  hexo init /config
else
  echo "Blog already initialized, skipping..."
fi

# Install any required hexo plugins
if [[ -z "${HEXO_PLUGINS}" ]]; then
  echo "No additional plugins to install!"
else
  echo "Installing additional plugins \"${HEXO_PLUGINS}\""
  # Word splitting is intentional here to pass multiple package names
  # shellcheck disable=SC2086
  npm install -C /config ${HEXO_PLUGINS}
fi

# Start the server
echo "Starting hexo server on port 8080"
hexo clean --cwd /config
exec hexo server --cwd /config -p 8080 --debug --draft

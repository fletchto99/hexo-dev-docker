#!/bin/bash

# Used to install rsync for deployments
echo "Installing rsync for deployments"
apt-get update -y
apt-get -y install rsync

# Install HEXO
echo "Installing hexo.."
npm install -g hexo

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
  npm install -C /config ${HEXO_PLUGINS}
fi

# Start the server
echo "Starting hexo server on port 8080"

echo "************************************************************"
echo "************************************************************"
echo "************************************************************"
echo ""
echo "WARNING: If you just see a generic output stating hexo [command] usage"
echo "that's because this container was updated to be more generic and requires"
echo "that you set up the blog as 'new'. To do so, point the /config volume to a"
echo "new EMPTY directory and let it init the blog. Once it's done, you can stop the"
echo "container and copy over your old blog configs."
echo ""
echo "I'm sorry for the trouble. I tried to find a better solution but I don't really"
echo "actively maintain this container anymore. If you have a better solution please"
echo "feel free to submit a PR!"
echo ""
echo "************************************************************"
echo "************************************************************"
echo "************************************************************"

# Start fresh
hexo clean --cwd /config
hexo server --cwd /config -p 8080 --debug --draft

#!/bin/sh

# Check to ensure the /config volume is mounted
if [ ! -d "/config" ]; then
  echo "Please mount the _config.yml, _posts/, themes/ and public/ to the /config directory"
  exit 1
fi

# Ensure the required directories exist
mkdir -p /config/_posts
mkdir -p /config/themes
mkdir -p /config/public

# Create a sample config
cp -n /setup/_config.yml /config/_config.yml

# Create some
if [ -z "$(ls -A /config/themes)" ]; then
   cp -R /setup/landscape /config/themes/landscape
fi

# Remove some defaults setup by hexo
rm /blog/_config.yml
rm -r /blog/source/_posts
rm -r /blog/themes

# Link all the things to make hexo work
ln -s /config/_config.yml /blog/_config.yml
ln -s /config/_posts /blog/source/
ln -s /config/themes /blog/
ln -s /config/public /blog/

# Install any required hexo plugins
if [[ -z "${HEXO_PLUGINS}" ]]; then
  echo "No additional plugins to install!"
else
  echo "Installing additional plugins \"${HEXO_PLUGINS}\""
  npm install ${HEXO_PLUGINS}
fi

# Start the server
echo "Starting hexo server on port 8080"
hexo server -p 8080 --debug

# Used to install rsync for deployments
apt-get install rsync -y

# Install HEXO
npm install -g hexo

# Initilize the blog
hexo init /blog

# Copy config files
mkdir /config
cp _config.yml /config/_config.yml

# Copy bootstrap scrpt
cp /setup/bootstrap.sh /blog/bootstrap.sh

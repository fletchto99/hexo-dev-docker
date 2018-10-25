FROM node:10

# Install NPM
RUN npm install -g hexo

# Initilize the blog
RUN hexo init /blog
WORKDIR /blog

# Setup some defaults
ADD setup/_config.yml /setup/_config.yml
ADD setup/landscape/ /setup/landscape/

# Run the server
ADD setup/bootstrap.sh /blog/bootstrap.sh
RUN chmod +x bootstrap.sh
CMD ["/bin/bash", "/blog/bootstrap.sh"]

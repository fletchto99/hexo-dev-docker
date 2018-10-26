FROM node:10

COPY setup /setup

# Install requirements
RUN (cd /setup; sh install.sh)

# Set the work directory to blog
WORKDIR /blog

# Start the server
CMD ["/bin/bash", "/blog/bootstrap.sh"]

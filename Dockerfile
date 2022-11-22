FROM node:19

COPY setup /setup

# Install requirements
RUN (cd /setup; sh bootstrap.sh)

# Set the work directory to blog
WORKDIR /blog

# Start the server
CMD ["/bin/bash", "/blog/run.sh"]

FROM node:22-bookworm-slim

# Install rsync for deployments
RUN apt-get update && \
    apt-get install -y --no-install-recommends rsync && \
    rm -rf /var/lib/apt/lists/*

# Install hexo-cli globally at a pinned version
RUN npm install -g hexo-cli@4.3.2 && \
    npm cache clean --force

COPY setup /setup

EXPOSE 8080

CMD ["/bin/bash", "/setup/run.sh"]

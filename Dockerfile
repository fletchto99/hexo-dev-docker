FROM node:25-bookworm-slim

# Install rsync for deployments
RUN apt-get update && \
    apt-get install -y --no-install-recommends rsync && \
    rm -rf /var/lib/apt/lists/*

# Install hexo-cli globally at the version pinned in package.json
COPY package.json /tmp/package.json
RUN npm install -g hexo-cli@$(node -p "require('/tmp/package.json').dependencies['hexo-cli']") && \
    rm /tmp/package.json && \
    npm cache clean --force

COPY setup /setup

EXPOSE 8080

CMD ["/bin/bash", "/setup/run.sh"]

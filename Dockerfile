FROM node:25-bookworm-slim

# Install rsync for deployments
RUN apt-get update && \
    apt-get install -y --no-install-recommends rsync && \
    rm -rf /var/lib/apt/lists/*

# Install hexo-cli at the version pinned in package-lock.json
COPY package.json package-lock.json /opt/hexo-cli/
RUN cd /opt/hexo-cli && npm ci && npm cache clean --force
ENV PATH="/opt/hexo-cli/node_modules/.bin:$PATH"

COPY setup /setup

EXPOSE 8080

CMD ["/bin/bash", "/setup/run.sh"]

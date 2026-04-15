FROM node:25-bookworm-slim

# Install runtime dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends rsync openssh-client && \
    rm -rf /var/lib/apt/lists/*

# Install hexo-cli at the version pinned in package-lock.json
COPY package.json package-lock.json /opt/hexo-cli/
WORKDIR /opt/hexo-cli
RUN npm ci && npm cache clean --force
ENV PATH="/opt/hexo-cli/node_modules/.bin:$PATH"
WORKDIR /

COPY setup /setup

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD node -e "require('http').get('http://localhost:8080/', r => r.statusCode === 200 ? process.exit(0) : process.exit(1)).on('error', () => process.exit(1))"

CMD ["/bin/bash", "/setup/run.sh"]

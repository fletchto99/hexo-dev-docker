# Hexo Dev Docker

![Build Status](https://github.com/fletchto99/hexo-dev-docker/actions/workflows/publish_release.yml/badge.svg)
![Docker Pulls](https://img.shields.io/docker/pulls/fletchto99/hexo-dev-blog)
![GitHub License](https://img.shields.io/github/license/fletchto99/hexo-dev-docker)

A Docker image for the [Hexo](https://hexo.io/) static blogging platform. Supports custom themes, plugins, and configurations. Primarily intended for local development and rapid prototyping of blog posts, but can also be used in production — the recommended approach is to use `hexo deploy` to push the generated static files to a CDN or web server.

## Supported Architectures

| Architecture | Available | Tag |
| :----: | :----: | ---- |
| x86-64 | ✅ | latest |
| arm64 | ✅ | latest |

## Images

| Registry   | Image                                |
| ---------- | ------------------------------------ |
| **GHCR**   | `ghcr.io/fletchto99/hexo-dev-docker` |
| **Docker Hub** | `fletchto99/hexo-dev-blog`       |

## Quick start

### Docker Compose (recommended)

```yaml
services:
  blog:
    image: ghcr.io/fletchto99/hexo-dev-docker
    ports:
      - "8080:8080"
    volumes:
      - ./blog:/config
    environment:
      - HEXO_PLUGINS=hexo-wordcount hexo-deploy-rsync  # optional
```

```bash
docker compose up
```

### Docker CLI

```bash
docker run -d \
  --name blog \
  -v ./blog:/config \
  -e HEXO_PLUGINS="hexo-wordcount hexo-deploy-rsync" \
  -p 8080:8080 \
  ghcr.io/fletchto99/hexo-dev-docker
```

## Configuration

### Volumes

| Mount      | Description                                  |
| ---------- | -------------------------------------------- |
| `/config`  | Blog source files, themes, and generated output |

### Environment variables

| Variable        | Required | Description |
| --------------- | -------- | ----------- |
| `HEXO_PLUGINS`  | No       | Space-separated list of [Hexo plugins](https://hexo.io/plugins/) to install at startup (e.g. `hexo-wordcount hexo-deploy-rsync`) |

### Config directory structure

On first startup, if the `/config` volume is empty, Hexo will initialize a new blog with the default scaffolding:

```
/config/
├── _config.yml     # Hexo configuration
├── source/
│   └── _posts/     # Markdown blog posts
├── themes/         # Hexo themes
└── public/         # Generated static HTML (safe to deploy)
```

## Advanced usage

### Custom themes

1. Clone the theme into your `blog/themes/<theme-name>` directory on the host.
2. Attach to the container console: `docker exec -it blog bash`
3. Navigate to `/config/themes/<theme-name>` and run any required setup commands (e.g. `npm install`).
4. Update `_config.yml` to use the new theme.

### Deploying via rsync

This container includes `rsync` for deployment. Add the `hexo-deploy-rsync` plugin via the `HEXO_PLUGINS` environment variable, then configure the deploy section in `_config.yml`:

```yaml
deploy:
  type: rsync
  host: <prod server>
  user: <user>
  root: <path/to/blog/dir>
  port: 22
  delete: true
  args: "-e ssh -i /config/deploy_key <user>@<prod server>"
  verbose: true
  ignore_errors: false
```

Place your private key at `blog/deploy_key` on the host (mounted as `/config/deploy_key` in the container), then run:

```bash
docker exec -it blog hexo deploy
```

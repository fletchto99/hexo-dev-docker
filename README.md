# Hexo Dev Blog

This container enables the static blogging platform hexo to be containerized. It allows for custom themes, plugins and configurations. A sample of this running can be seen at [blog-test.fletchto99.com](blog-test.fletchto99.com). This container is mainly intended for development use and rapid prototyping of blog posts, however it should be possible to run this in a production setting as well. The recommended route would be to setup a deployment and use `hexo deploy` via the docker console to send the static files to be served by a CDN or something similar.

## Usage

```
docker create \
  --name=blog \
  -v <path to data>:/config \
  -e PGID=<gid> -e PUID=<uid>  \
  -e HEXO_PLUGINS=<hexo plugins> \
  -p 8080:8080 \
  fletchto99/hexo-dev-blog
```

## Parameters
* `-p 8080` - The port to run the container on
* `-v /config` - Configuration files and generated blog files

_Optional paramaters:_
* `-e HEXO_PLUGINS` - Any [hexo plugins](https://hexo.io/plugins/index.html) you wish for the blog to have access to


## Setting up the config directory

The first time the container is started up, if the mounted config volume is empty the default contents will be automatically generated. In specific:

* `config/_config.yml` - The hexo config file
* `config/_posts` - The directory to save your markdown posts
* `config/themes/` - Same as the themes directory when generating a hexo blog
* `config/public` - The directory in which the static HTML files will be saved and served from (feel free to copy these to your production server to deploy)

## Advanced usage

Below we explore some more advanced use cases such as deploying via `hexo deploy` or using custom themes which require some setup.

### Custom themes

Some themes require setup which involves running commands like `npm install`. To do so follow these steps:

1. Clone the theme into the `config/themes/<my theme>` directory.
2. Attach to the docker's console and navigate to `/blog/themes/<my theme>`
3. Run the required commands within the container to generate any required files

That should allow you to use the theme now! Be sure to setup any configurations within the theme as well

### Deploying

Currently this container supports blog deployment via rsync through the `hexo-deploy-rsync` plugin. Here's an example of the deploy section of a config. Note that the `deploy_key` is a private RSA key which will be used to deploy to the production server. It is saved at `config/deploy_key` which is then shared with the container through the mounted volume.

```yaml
deploy:
  type: rsync
  host: <prod server>
  user: <user>
  root: <path / to / blog / dir>
  port: 22
  delete: true
  args: "-e ssh -i /config/deploy_key <user>@<prod server>"
  verbose: true
  ignore_errors: false
```

Now to deploy all I need to do is attach to the console and run `hexo deploy`

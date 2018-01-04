# Yttrium

Yttrium is a [Dockerized](https://www.docker.com/) [Hubot](https://github.com/hubotio/hubot) package. In other words, it's a customizable chat bot that's supported by many chat platforms and super easy to deploy.

## Getting Started

First, you'll need to install some software to run the build script. Then, you'll run the script to download, install, configure, and run the latest [Hubot](https://www.npmjs.com/package/hubot) source in a Docker container.

### Install Dependencies

Install [Docker](https://docs.docker.com/engine/installation/) and [docker-compose](https://docs.docker.com/compose/install/).

### Configure Your Bot
In [docker-compose.yml](docker-compose.yml), edit the section titled `yttrium` under `services`.

```
services:
  yttrium:
     ...stuff to customize your build...
```

You should change the value of `image` to something unique for your organization. For example, `foo/yttrium`. You should also change the values in the `args` section:
* `hubot_owner` should be whoever is going to keep your bot running
* `hubot_name` is your bot's login name
* `hubot_description` adds a description field to package.json (optional)
* `hubot_adapter` is the name of the chat platform adapter you're using (see [hubot-adapter](https://github.com/search?q=topic%3Ahubot-adapter&type=Repositories))
* `hubot_packages` are additional packages required by or providing [custom scripts](#scripts)
* `hubot_port` is your bot's web server listening port
* `http_proxy` is your organization's HTTP proxy (optional)
* `https_proxy` is your organization's HTTPS proxy (optional)

Next, add environment variables to a file called `yttrium.env`, such as session tokens, API keys, and the local timezone:

```
HUBOT_SLACK_TOKEN=xoxb-1234567890-A1aB2bC3cD4dE5eF6f
HUBOT_GIPHY_API_KEY=1a2b3c4d5f6g7h8i9j0k
TZ=America/Denver
```

### <a name="scripts"></a>Custom Scripts

You can create custom scripts to extend your bot's functionality. You can either write a new script in the `scripts` directory (like [example.coffee](scripts/example.coffee)) or create a standalone [hubot-scripts](https://github.com/hubot-scripts) module (like [hubot-pugme](https://www.npmjs.com/package/hubot-pugme)). I recommend the latter for modularity, and if you go that route, you need to add the script module to [external-scripts.json](external-scripts.json) and also the `hubot_packages` section in [docker-compose.yml]. If you choose the `scripts` directory route, you'll need to add any additional dependencies to [package.json](package.json). Either way, you need to <a href="#build">rebuild the bot</a> any time you add or update scripts.

### <a name="build"></a>Build & Run Your Bot
After you've customized `docker-compose.yml`, you can build your bot image and run it. From the directory containing [docker-compose.yml](docker-compose.yml):

```
docker-compose up --build -d
```

If all went well, you should now be able to talk to your bot in chat:

```
me: @yttrium ping
yttrium: PONG
```

### Shut Down Your Bot
From the directory containing [docker-compose.yml](docker-compose.yml):
```
docker-compose down
```

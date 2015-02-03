# Hubot Webscale

A web-sockets based [Hubot](https://github.com/github/hubot) adapter to allow Hubot to be embedded in a website **at webscale**.

## Running locally

1. `script/bootstrap`
2. `script/server`
3. Open [localhost:8080](http://localhost:8080) in your browser

## Deploying to Heroku

Follow the [standard Hubot deployment docs](https://github.com/github/hubot/blob/master/docs/deploying/heroku.md). Hubot Webscale doesn't require any special configuration.

## Wait, so this is a web-based chat room?

Not really. While it's a shared Hubot brain, each user has their own, private line directly to Hubot, and can only see their commands and what Hubot says in reply to their own commands.

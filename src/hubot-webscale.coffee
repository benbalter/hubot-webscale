fs = require 'fs'
express = require 'express'
path = require 'path'
coffee = require 'coffee-middleware'
io = require 'socket.io'
{TextMessage, EnterMessage, User, Adapter} = require 'hubot'

class Webscale extends Adapter

  send: (envelope, strings...) ->
    @robot.logger.debug "SENDING: #{strings}"
    envelope.room.emit 'message', strings

  emote: (envelope, strings...) ->
    @robot.logger.debug "EMOTING: #{strings}"
    envelope.room.emit 'message', strings

  reply: (envelope, strings...) ->
    @robot.logger.debug "REPLYING: #{strings}"
    envelope.room.emit 'message', strings

  root: ->
    @_root ||= path.resolve __dirname, "../"

  run: ->
    # Init public dir for serving static files
    public_dir = path.resolve @root(), "public"
    @robot.router.use express.static(public_dir)

    # Init coffee script middleware
    @robot.router.use coffee
      src: path.resolve(@root(),"public")
      compress: true

    # Init the websocket server
    io = io.listen(@robot.server)

    io.sockets.on 'connection', (socket) =>
      user = new User "user-#{Date.now()}", room: socket
      @receive new EnterMessage(user)

      socket.on "message", (msg) =>
        @robot.logger.debug "RECEIVED: #{msg}"

        # Pass user commands to Hubot
        @receive new TextMessage(user, msg, "message-#{Date.now()}")

    # Let Hubot know to continue the load process
    @emit 'connected'

exports.use = (robot) ->
  new Webscale robot

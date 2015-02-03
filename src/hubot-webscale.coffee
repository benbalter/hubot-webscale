fs = require 'fs'
express = require 'express'
path = require 'path'
coffee = require 'coffee-middleware'
io = require 'socket.io'
{TextMessage, Adapter} = require 'hubot'

class Webscale extends Adapter

  send: (envelope, strings...) ->
    @robot.logger.debug "SENDING: #{strings}"
    @socket.emit 'message', strings

  emote: (envelope, strings...) ->
    @robot.logger.debug "EMOTING: #{strings}"
    @socket.emit 'message', strings

  reply: (envelope, strings...) ->
    @robot.logger.debug "REPLYING: #{strings}"
    @socket.emit 'message', strings

  receive: (txt) =>
    @robot.logger.debug "RECEIVED: #{txt}"
    @robot.receive @message(txt)

  root: ->
    @_root ||= path.resolve __dirname, "../"

  user: ->
    @_user ||= @robot.brain.userForId(1)

  message: (txt) ->
    new TextMessage(@user(), txt, Date.now())

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
      @socket = socket

      # Pass user commands to Hubot
      @socket.on 'message', @receive

    # Let Hubot know to continue the load process
    @emit 'connected'

exports.use = (robot) ->
  new Webscale robot

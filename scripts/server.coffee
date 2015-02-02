fs = require 'fs'
coffee = require 'coffee-script'
express = require 'express'
path = require('path')
coffee = require('coffee-middleware');
{TextMessage} = require 'hubot'

module.exports = (robot) ->

  root = path.resolve(__dirname, "../")
  robot.router.use(express.static(path.resolve(root, "node_modules")))
  robot.router.use(express.static(path.resolve(root, "public")))
  robot.router.use coffee
    src: root + "/public",
    compress: true

  io = require('socket.io').listen(robot.server)
  io.sockets.on 'connection', (socket) ->

    # send
    robot.adapter.send = (envelope, strings...) ->
      socket.emit 'message', strings

    # recieve
    socket.on 'message', (msg) ->
      user = robot.brain.userForId(1)
      msg = new TextMessage(user, msg, "ID")
      robot.receive msg

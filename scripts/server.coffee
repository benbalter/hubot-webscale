fs = require 'fs'
coffee = require 'coffee-script'
express = require 'express'
path = require('path')
{TextMessage} = require 'hubot'

module.exports = (robot) ->

  root = path.resolve(__dirname, "../")
  robot.router.use(express.static(path.resolve(root, "node_modules")))
  robot.router.use(express.static(path.resolve(root, "public")))

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

  robot.router.get '/script.js', (req, res) ->
    fs.readFile "#{__dirname}/../public/script.coffee", 'utf8', (err, data) ->
      res.send coffee.compile data

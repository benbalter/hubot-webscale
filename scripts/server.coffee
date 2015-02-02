fs = require 'fs'
coffee = require 'coffee-script'
express = require 'express'
{TextMessage} = require 'hubot'

module.exports = (robot) ->
  robot.router.use('/node_components', express.static(__dirname + '../node_components'));

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

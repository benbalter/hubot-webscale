module.exports = (robot) ->

  robot.router.get '/script.js', (req, res) ->
    fs = require 'fs'
    coffee = require 'coffee-script'

    fs.readFile 'public/script.coffee', 'utf8', (err, data) ->
        res.send coffee.compile data

  robot.router.post '/', (req, res) ->
    {TextMessage} = require 'hubot'

    user = robot.brain.userForId(1)
    msg = new TextMessage(user, req.body["command"], "ID")

    robot.adapter.send = (envelope, strings...) ->
      for string in strings
        res.send string

    robot.receive msg

    res.send ""

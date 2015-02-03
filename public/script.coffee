class HubotWebscale

  constructor: ->
    @socket = io.connect();
    $("form").submit @send
    @socket.on 'message', @receive

    @history = []
    @history_index = -1

    $("#command").keydown @getHistory

  receive: (data) =>
    for line in data
      @log "Hubot", line

  send: (e) =>
    e.preventDefault()
    msg = $("#command").val()
    @socket.emit('message', msg)
    @log "User", msg
    @history_index = -1
    @history.unshift msg
    $("#command").val("")

  scroll: ->
    div = $("#log")
    div.scrollTop(div[0].scrollHeight)

  log: (sender, msg) ->
    log   = $("#log")
    entry = $("<div />", class: "entry", id: Date.now())
    left  = $("<div />", class: "sender #{sender.toLowerCase()}").text(sender)
    right = $("<div />", class: "message #{sender.toLowerCase()}")

    if msg.match /\.(jpg|png|gif)$/
      img = $("<img />", src: msg)
      img.load @scroll
      right.append img
    else if msg.match /\n/
      right.append $("<pre />").text(msg)
    else
      right.append $("<p />").text(msg)

    entry.append left
    entry.append right
    log.append entry
    @scroll()

  getHistory: (e) =>
    return unless e.which == 38 || e.which == 40

    switch(e.which)
      when 38 then @history_index++ unless @history_index >= @history.length - 1 #up
      when 40 then @history_index-- unless @history_index < 0 #down

    $("#command").val @history[@history_index]

new HubotWebscale()

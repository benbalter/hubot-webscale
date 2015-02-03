class HubotWebscale

  constructor: ->
    @socket = io.connect();
    $("form").submit @send
    @socket.on 'message', @receive
    $("img").load ->
      alert("loaded")

  receive: (data) =>
    for line in data
      @log "Hubot", line

  send: (e) =>
    e.preventDefault()
    msg = $("#command").val()
    @socket.emit('message', msg)
    @log "User", msg
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


new HubotWebscale()

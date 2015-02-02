class HubotWebscale

  constructor: ->
    @socket = io.connect();
    $("form").submit @send
    @socket.on 'message', @receive

  receive: (data) =>
    for line in data
      @log "Hubot", line

  send: (e) =>
    e.preventDefault()
    msg = $("#command").val()
    @log "User", msg
    @socket.emit('message', msg)
    $("#command").val("")

  log: (sender, msg) ->
    div = $("#log")
    div.append "<div class=\"entry\">"
    div.append "<div class=\"sender\">#{sender}</div>"
    div.append "<div class=\"message\">"

    if msg.match /\.(jpg|png|gif)$/
      div.append "<img src=\"#{msg}\"/>"
    else
      div.append msg.replace(/\n/g, "<br />")

    div.append "</div>"
    div.append "</div>"
    div.scrollTop(div[0].scrollHeight)

new HubotWebscale()

log = (sender, msg) ->
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

$("form").submit (e) ->
  e.preventDefault()
  command = $("#command").val()
  log "User", command
  $.post "/", command: command, (data) ->
    log "Hubot", data if data
  $("#command").val("")
  false

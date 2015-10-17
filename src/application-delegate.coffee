ipc = require 'ipc'
remote = require 'remote'
shell = require 'shell'

module.exports =
class ApplicationDelegate
  showWindow: ->
    ipc.send('call-window-method', 'show')

  focusWindow: ->
    ipc.send("call-window-method", "focus")
  
  beep: ->
    shell.beep()
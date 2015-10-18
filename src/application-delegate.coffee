ipc = require 'ipc'
remote = require 'remote'
shell = require 'shell'

module.exports =
class ApplicationDelegate
  showWindow: ->
    ipc.send('call-window-method', 'show')

  closeWindow: ->
    ipc.send("call-window-method", "close")

  focusWindow: ->
    ipc.send("call-window-method", "focus")

  maximizeWindow: ->
    ipc.send("call-window-method", "maximize")
  
  minimizeWindow: ->
    ipc.send("call-window-method", "minimize")

  beep: ->
    shell.beep()
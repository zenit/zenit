ipc = require 'ipc'
remote = require 'remote'
shell = require 'shell'
{Emitter} = require 'event-kit'

module.exports =
  emitter: new Emitter

  showWindow: ->
    ipc.send('call-window-method', 'show')

  closeWindow: ->
    ipc.send("call-window-method", "close")

  focusWindow: ->
    ipc.send("call-window-method", "focus")

  maximizeWindow: ->
    ipc.send("call-window-method", "maximize")

  isWindowMaximized: ->
    remote.getCurrentWindow().isMaximized()
  
  minimizeWindow: ->
    ipc.send("call-window-method", "minimize")

  restoreWindow: ->
    ipc.send("call-window-method", "restore")

  shell: (method, args...) ->
    shell[method](args...)

  beep: ->
    shell.beep()
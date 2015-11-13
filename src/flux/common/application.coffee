shell = require 'shell'
ipc = require 'ipc'
remote = require 'remote'
dialog = null

Common =
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

  createDialog: (opts) ->
    dialog ?= remote.require('dialog')

    dialog.showMessageBox remote.getCurrentWindow(), opts

  beep: ->
    shell.beep()

module.exports = Common
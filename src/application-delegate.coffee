ipc = require 'ipc'
remote = require 'remote'
shell = require 'shell'

module.exports =
  showWindow: ->
    ipc.send('call-window-method', 'show')

  beep: ->
    shell.beep()
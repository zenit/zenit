app = require 'app'
ApplicationWindow = require './application-window'
BrowserWindow = require 'browser-window'
Menu = require 'menu'
ipc = require 'ipc'
{EventEmitter} = require 'events'
_ = require 'underscore-plus'

module.exports =
class Application
  _.extend @prototype, EventEmitter.prototype

  mainWindow: null
  applicationMenu: null

  constructor: ->
    global.zenitApplication = this

    @handleEvents()
    
    @mainWindow = new ApplicationWindow(
      title: 'Zenit'
      width: 800
      height: 600
      'web-preferences':
        'direct-write': true
        'subpixel-font-scaling': true
    )

  render: ->
    console.log('render!!')

  handleEvents: ->
    @on 'application:quit', => app.quit()

    ipc.on 'window-command', (event, command, args...) ->
      win = BrowserWindow.fromWebContents(event.sender)
      win.emit(command, args...)

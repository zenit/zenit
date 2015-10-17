app = require 'app'
path = require 'path'
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
  resourcePath: null

  constructor: ->
    global.zenitApplication = this

    @resourcePath = path.dirname path.dirname(__dirname)

    @handleEvents()
    
    @mainWindow = new ApplicationWindow(
      show: false
      title: 'Zenit'
      width: 800
      height: 600
      'web-preferences':
        'direct-write': true
        'subpixel-font-scaling': true
    )

  handleEvents: ->
    @on 'application:quit', => app.quit()

    ipc.on 'window-command', (event, command, args...) ->
      win = BrowserWindow.fromWebContents(event.sender)
      win.emit(command, args...)

    ipc.on 'call-window-method', (event, method, args...) ->
      win = BrowserWindow.fromWebContents(event.sender)
      win[method](args...)

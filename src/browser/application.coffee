app = require 'app'
path = require 'path'
ApplicationMenu = require './application-menu'
ApplicationWindow = require './application-window'
BrowserWindow = require 'browser-window'
Menu = require 'menu'
ipc = require 'ipc'
{EventEmitter} = require 'events'
_ = require 'underscore-plus'

module.exports =
class Application
  _.extend @prototype, EventEmitter.prototype

  applicationMenu: null
  resourcePath: null
  windows: []

  constructor: ->
    global.zenitApplication = this

    @windows = []
    @resourcePath = path.dirname path.dirname(__dirname)

    @applicationMenu = new ApplicationMenu()

    @handleEvents()
    
    new ApplicationWindow(
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

    ipc.on 'update-application-menu', (event, template, keystrokesByCommand) =>
      win = BrowserWindow.fromWebContents(event.sender)
      @applicationMenu.update(win, template, keystrokesByCommand)

  addWindow: (window) ->
    @windows.push window
    @applicationMenu?.addWindow(window.browserWindow)
    
    unless window.isSpec
      focusHandler = => @lastFocusedWindow = window
      window.browserWindow.on 'focus', focusHandler
      window.browserWindow.once 'closed', =>
        @lastFocusedWindow = null if window is @lastFocusedWindow
        window.browserWindow.removeListener 'focus', focusHandler

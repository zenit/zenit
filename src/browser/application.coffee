app = require 'app'
BrowserWindow = require 'browser-window'
Menu = require 'menu'
{EventEmitter} = require 'events'

_ = require 'underscore-plus'

module.exports =
class Application
  _.extend @prototype, EventEmitter.prototype

  mainWindow: null
  applicationMenu: null

  constructor: ->
    @handleEvents()
    
    @mainWindow = new BrowserWindow(width: 800, height: 600)
    @mainWindow.loadUrl("file://#{__dirname}/../../static/index.html")

  handleEvents: ->
    @on 'application:quit', => app.quit()

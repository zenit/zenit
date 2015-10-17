app = require 'app'
BrowserWindow = require 'browser-window'
{EventEmitter} = require 'events'

_ = require 'underscore'

module.exports =
class Application
  _.extend @prototype, EventEmitter.prototype

  mainWindow: null

  ###
  Public methods
  ###
  @bootstrap: ->
    @mainWindow = new BrowserWindow(width: 800, height: 600)
    @mainWindow.loadUrl("file://#{__dirname}/../../static/index.html")

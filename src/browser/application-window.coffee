BrowserWindow = require 'browser-window'
path = require 'path'
_ = require 'underscore-plus'
{EventEmitter} = require 'events'

module.exports =
class ApplicationWindow
  _.extend @prototype, EventEmitter.prototype

  @iconPath: path.resolve(__dirname, '..', '..', 'resources', 'zenit.png')

  browserWindow: null

  constructor: (options={}) ->
    @browserWindow = new BrowserWindow options

    @handleEvents()

    @browserWindow.loadUrl("file://#{__dirname}/../../static/index.html")
    @browserWindow.once 'window:loaded', =>
      @emit 'window:loaded'
    @browserWindow.focusOnWebView()

  handleEvents: () ->
    @on 'window:loaded', =>
      console.log 'fire renderer'
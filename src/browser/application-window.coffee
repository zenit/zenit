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
    # Don't set icon on Windows so the exe's ico will be used as window and
    # taskbar's icon. See https://github.com/atom/atom/issues/4811 for more.
    if process.platform is 'linux'
      options.icon = @constructor.iconPath

    @browserWindow = new BrowserWindow options

    @handleEvents()

    # Load from a settings file
    @browserWindow.settings = {devMode: true}
    @browserWindow.loadUrl path.resolve(__dirname, '..', '..', 'static', 'index.html')
    @browserWindow.once 'window:loaded', =>
      @emit 'window:loaded'
    @browserWindow.focusOnWebView()

  handleEvents: () ->
    @on 'window:loaded', =>
      console.log 'fire renderer'
BrowserWindow = require 'browser-window'
path = require 'path'
url = require 'url'
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
    global.zenitApplication.addWindow(this)

    @handleEvents()

    # Load from a settings file
    loadSettings = 
      devMode: true
      resourcePath: global.zenitApplication.resourcePath
      windowInitializationScript: require.resolve(path.join(global.zenitApplication.resourcePath, 'src', 'window-bootstrap'))

    @browserWindow.once 'window:loaded', =>
      @emit 'window:loaded'

    @browserWindow.loadUrl url.format
      protocol: 'file'
      pathname: "#{global.zenitApplication.resourcePath}/static/index.html"
      slashes: true
      hash: encodeURIComponent(JSON.stringify(loadSettings))

    @browserWindow.focusOnWebView()

  handleEvents: () ->
    @on 'window:loaded', =>
      console.log 'fire renderer'
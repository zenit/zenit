app = require 'app'
dialog = require 'dialog'
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
  loaded: null
  sequelize: null

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
      frameless: !options.frame
      appVersion: app.getVersion()
      devMode: true
      resourcePath: global.zenitApplication.resourcePath
      windowInitializationScript: require.resolve(path.join(global.zenitApplication.resourcePath, 'src', 'window-bootstrap'))

    @browserWindow.once 'window:loaded', =>
      @emit 'window:loaded'
      @loaded = true

    @browserWindow.loadUrl url.format
      protocol: 'file'
      pathname: "#{global.zenitApplication.resourcePath}/static/index.html"
      slashes: true
      hash: encodeURIComponent(JSON.stringify(loadSettings))

    @browserWindow.focusOnWebView() if loadSettings.devMode

  sendCommand: (command, args...) ->
    unless global.zenitApplication.sendCommandToFirstResponder(command)
      switch command
        when 'window:reload' then @reload()
        when 'window:toggle-dev-tools' then @toggleDevTools()
        when 'window:close' then @close()
    if @isWebViewFocused()
      @sendCommandToBrowserWindow(command, args...)
    else
      unless global.zenitApplication.sendCommandToFirstResponder(command)
        @sendCommandToBrowserWindow(command, args...)

  sendCommandToBrowserWindow: (command, args...) ->
    action = if args[0]?.contextCommand then 'context-command' else 'command'
    @browserWindow.webContents.send action, command, args...

  handleEvents: ->
    @browserWindow.on 'closed', =>
      global.zenitApplication.removeWindow(this)

    @browserWindow.on 'unresponsive', =>
      chosen = dialog.showMessageBox @browserWindow,
        type: 'warning'
        buttons: ['Close', 'Keep Waiting']
        message: 'Editor is not responding'
        detail: 'Zenit is not responding. Would you like to force close it or just keep waiting?'
      @browserWindow.destroy() if chosen is 0
    
    @browserWindow.webContents.on 'crashed', =>
      global.atomApplication.exit(100) if @headless

      chosen = dialog.showMessageBox @browserWindow,
        type: 'warning'
        buttons: ['Close Window', 'Reload', 'Keep It Open']
        message: 'The editor has crashed'
        detail: 'Please report this issue to https://github.com/iiegor/zenit'
      switch chosen
        when 0 then @browserWindow.destroy()
        when 1 then @browserWindow.restart()

    @browserWindow.webContents.on 'will-navigate', (event, url) =>
      unless url is @browserWindow.webContents.getUrl()
        event.preventDefault()

  isFocused: -> @browserWindow.isFocused()

  isWebViewFocused: -> @browserWindow.isWebViewFocused()

  toggleDevTools: -> @browserWindow.toggleDevTools()

  reload: -> @browserWindow.restart()
  
  close: -> @browserWindow.close()
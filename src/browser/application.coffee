app = require 'app'
path = require 'path'
ApplicationMenu = require './application-menu'
ApplicationWindow = require './application-window'
ApplicationExecutor = require './application-executor'
BrowserWindow = require 'browser-window'
Menu = require 'menu'
ipc = require 'ipc'
{EventEmitter} = require 'events'
_ = require 'underscore-plus'

module.exports =
class Application
  _.extend @prototype, EventEmitter.prototype

  applicationMenu: null
  applicationExecutor: null
  resourcePath: null
  windows: []

  constructor: ->
    global.zenitApplication = this

    @windows = []
    @resourcePath = path.dirname path.dirname(__dirname)

    @applicationMenu = new ApplicationMenu()
    _.defer(-> @applicationExecutor = new ApplicationExecutor())

    @handleEvents()

    # Create a frameless window
    # See http://electron.atom.io/docs/v0.34.0/api/frameless-window/
    if process.platform is 'win32'
      frame = false
    else
      frame = true

    options =
      show: false
      title: 'Zenit'
      width: 800
      height: 600
      frame: frame
      'standard-window': frame
      'min-width': 500
      'min-height': 400
      'web-preferences':
        'direct-write': true
        'subpixel-font-scaling': true

    new ApplicationWindow options

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

  # Public: Removes the {ApplicationWindow} from the global window list.
  removeWindow: (window) ->
    if @windows.length is 1
      @applicationMenu?.enableWindowSpecificItems(false)
      if process.platform in ['win32', 'linux']
        app.quit()
        return
    @windows.splice(@windows.indexOf(window), 1)

  # Public: Adds the {ApplicationWindow} to the global window list.
  addWindow: (window) ->
    @windows.push window
    @applicationMenu?.addWindow(window.browserWindow)
    
    unless window.isSpec
      focusHandler = => @lastFocusedWindow = window
      window.browserWindow.on 'focus', focusHandler
      window.browserWindow.once 'closed', =>
        @lastFocusedWindow = null if window is @lastFocusedWindow
        window.browserWindow.removeListener 'focus', focusHandler

  # Public: Executes the given command.
  #
  # If it isn't handled globally, delegate to the currently focused window.
  #
  # command - The string representing the command.
  # args - The optional arguments to pass along.
  sendCommand: (command, args...) ->
    unless @emit(command, args...)
      focusedWindow = @focusedWindow()
      if focusedWindow?
        focusedWindow.sendCommand(command, args...)
      else
        @sendCommandToFirstResponder(command)

  # Translates the command into OS X action and sends it to application's first
  # responder.
  sendCommandToFirstResponder: (command) ->
    return false unless process.platform is 'darwin'

    switch command
      when 'core:undo' then Menu.sendActionToFirstResponder('undo:')
      when 'core:redo' then Menu.sendActionToFirstResponder('redo:')
      when 'core:copy' then Menu.sendActionToFirstResponder('copy:')
      when 'core:cut' then Menu.sendActionToFirstResponder('cut:')
      when 'core:paste' then Menu.sendActionToFirstResponder('paste:')
      when 'core:select-all' then Menu.sendActionToFirstResponder('selectAll:')
      else return false
    true

  focusedWindow: ->
    _.find @windows, (zenitWindow) -> zenitWindow.isFocused()
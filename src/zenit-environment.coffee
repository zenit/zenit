React = require 'react'
ReactDOM = require 'react-dom'

Model = require './model'
KeymapManager = require './keymap-extensions'
MenuManager = require './menu-manager'
StyleManager = require './style-manager'
ThemeManager = require './theme-manager'

{getWindowLoadSettings} = require './window-load-settings-helpers'

path = require 'path'
_ = require 'underscore-plus'

ZenitElement = require './zenit-element'

module.exports =
class ZenitEnvironment extends Model
  ###
  Section: Properties
  ###

  # {MenuManager} instance.
  menu: null

  # {ThemeManager} instance.
  themes: null

  # {StyleManager} instance.
  styles: null

  ###
  Section: Construction
  ###

  constructor: (params={}) ->
    {@applicationDelegate, @window, @document, configDirPath} = params

    @loadTime = null
    {resourcePath} = @getLoadSettings()

    @keymaps = new KeymapManager({configDirPath, resourcePath})

    @styles = new StyleManager({configDirPath})
    @themes = new ThemeManager({
      configDirPath, resourcePath,
      styleManager: @styles
    })

    @menu = new MenuManager({resourcePath, keymapManager: @keymaps})

    @themes.loadBaseStylesheets()
    @initialStyleElements = @styles.getSnapshot()
    @setBodyPlatformClass()

    @stylesElement = @styles.buildStylesElement()
    @document.head.appendChild(@stylesElement)

    @keymaps.loadBundledKeymaps()

    @renderApplication()

  displayWindow: ->
    @show()
    @focus()

  show: ->
    @applicationDelegate.showWindow()

  focus: ->
    @applicationDelegate.focusWindow()
    @window.focus()

  startWindow: ->
    @menu.update()

  # Add platform class to body.
  setBodyPlatformClass: ->
    @document.body.classList.add("platform-#{process.platform}")

  # Render application elements.
  renderApplication: ->
    document.body.appendChild(new ZenitElement().initialize({@styles}))

  # Get the load settings for the current window.
  getLoadSettings: ->
    getWindowLoadSettings()

  # Get the time taken to completely load the current window.
  getWindowLoadTime: ->
    @loadTime
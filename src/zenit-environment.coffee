React = require 'react'
ReactDOM = require 'react-dom'

Model = require './model'
StyleManager = require './style-manager'
ThemeManager = require './theme-manager'
_ = require 'underscore-plus'
{CompositeDisposable, Emitter} = require 'event-kit'

ZenitElement = require './zenit-element'

module.exports =
class ZenitEnvironment extends Model
  ###
  Section: Properties
  ###

  # {ThemeManager} instance.
  themes: null

  # {StyleManager} instance.
  styles: null

  ###
  Section: Construction
  ###

  constructor: (params={}) ->
    {@applicationDelegate, @window, @document, configDirPath} = params

    @emitter = new Emitter

    @styles = new StyleManager({configDirPath})
    @themes = new ThemeManager({
      configDirPath, 
      resourcePath: process.resourcesPath,
      styleManager: @styles
    })

    @themes.loadBaseStylesheets()
    @initialStyleElements = @styles.getSnapshot()
    @setBodyPlatformClass()

    @stylesElement = @styles.buildStylesElement()
    @document.head.appendChild(@stylesElement)

    @renderApplication()

  displayWindow: ->
    @show()
    @focus()

  show: ->
    @applicationDelegate.showWindow()

  focus: ->
    @applicationDelegate.focusWindow()
    @window.focus()

  setBodyPlatformClass: ->
    @document.body.classList.add("platform-#{process.platform}")

  renderApplication: ->
    document.body.appendChild(new ZenitElement().initialize({@styles}))
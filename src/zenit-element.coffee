React = require 'react'
ReactDOM = require 'react-dom'

{getWindowLoadSettings} = require './window-load-settings-helpers'

module.exports =
class ZenitElement extends HTMLElement
  initializeContent: ->
    {frameless} = getWindowLoadSettings()

    if frameless
      @zenitTitlebar = document.createElement('zenit-titlebar')
      @zenitTitlebar.classList.add 'zenit-titlebar'

      ReactDOM.render(
        React.createElement(require './components/titlebar'), 
        @zenitTitlebar
      )
      @appendChild(@zenitTitlebar)

    @zenitHeader = document.createElement('zenit-header')
    @zenitHeader.classList.add 'zenit-header'

    ReactDOM.render(
      React.createElement(require './components/header'), 
      @zenitHeader
    )
    @appendChild(@zenitHeader)

    @zenitSidebar = document.createElement('zenit-sidebar')
    @zenitSidebar.classList.add 'zenit-sidebar'

    ReactDOM.render(
      React.createElement(require './components/sidebar'),
      @zenitSidebar
    )
    @appendChild(@zenitSidebar)

  initialize: ({@styles}) ->
    throw new Error("Must pass a styles parameter when initializing ZenitElements") unless @styles?

    @initializeContent()

    this

  getModel: -> @model

module.exports = ZenitElement = document.registerElement 'zenit-container', prototype: ZenitElement.prototype
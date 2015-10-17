ipc = require 'ipc'

React = require 'react'
ReactDOM = require 'react-dom'

module.exports =
class ZenitElement extends HTMLElement
  globalTextEditorStyleSheet: null

  attachedCallback: ->
    @focus()

  initializeContent: ->
    @zenitHeader = document.createElement('zenit-header')
    @zenitHeader.classList.add 'zenit-header'

    ReactDOM.render(
      React.createElement(require './components/header'), 
      @zenitHeader
    )

    @zenitSidebar = document.createElement('zenit-sidebar')
    @zenitSidebar.classList.add 'zenit-sidebar'

    ReactDOM.render(
      React.createElement(require './components/sidebar'),
      @zenitSidebar
    )

    @appendChild(@zenitHeader)
    @appendChild(@zenitSidebar)

  initialize: ({@styles}) ->
    throw new Error("Must pass a styles parameter when initializing ZenitElements") unless @styles?

    @initializeContent()

    this

  getModel: -> @model

module.exports = ZenitElement = document.registerElement 'zenit-container', prototype: ZenitElement.prototype
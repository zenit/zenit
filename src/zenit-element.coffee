ipc = require 'ipc'

React = require 'react'
ReactDOM = require 'react-dom'

module.exports =
class ZenitElement extends HTMLElement
  globalTextEditorStyleSheet: null

  attachedCallback: ->
    @focus()

  initializeContent: ->
    @setAttribute 'tabindex', -1

    @zenitHeader = document.createElement('zenit-header')
    @zenitHeader.classList.add 'zenit-header'

    ReactDOM.render(
      React.createElement(require './components/header'), 
      @zenitHeader
    )

    @appendChild(@zenitHeader)

  initialize: ({@styles}) ->
    throw new Error("Must pass a styles parameter when initializing ZenitElements") unless @styles?

    @initializeContent()

    this

  getModel: -> @model

module.exports = ZenitElement = document.registerElement 'zenit-container', prototype: ZenitElement.prototype
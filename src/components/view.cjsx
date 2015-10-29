React = require 'react'
ReactDOM = require 'react-dom'
ApplicationDelegate = require '../application-delegate'

_ = require 'underscore-plus'

class View extends React.Component
  @displayName = 'View'

  constructor: (@props) ->
    @lastView = localStorage.getItem('zenit:last-view')?.split(',') || []
    @cache = []

    @state =
      stack: [
        require '../views/get-started'
      ]

  componentWillMount: ->
    @_onStackChanged(@lastView) if @lastView.length > 0

  componentDidMount: ->
    ApplicationDelegate.on 'inject-view', (view) =>
      @_onStackChanged(if typeof view is 'object' then view else [view])

  render: =>
    <div className="view-inner">
      {# Custom element, use normal class tag #}
      <zenit-axis class="vertical">
        {@_injectStackComponents()}
      </zenit-axis>
    </div>

  _injectStackComponents: =>
    return <span>There is no view in the stack</span> unless @state.stack.length > 0

    # Render
    @state.stack.map (ContentView, index) =>
      <ContentView key={"#{index}:#{ContentView.id}"} />

  _onStackChanged: (stack) =>
    tempStack = []

    stack.map (viewName) =>
      @cache[viewName] ?= require "../views/#{viewName}"

      tempStack.push @cache[viewName]

    # Save session views
    localStorage.setItem('zenit:last-view', stack.join(','))

    # Update state
    @setState stack: tempStack

module.exports = View
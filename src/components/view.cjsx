React = require 'react'
ReactDOM = require 'react-dom'
ApplicationDelegate = require '../application-delegate'

class View extends React.Component
  @displayName = 'View'

  constructor: (@props) ->
    @state =
      stack: [
        require '../views/get-started'
      ]

  componentDidMount: ->
    ApplicationDelegate.emitter.on 'inject-view', (view) =>
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

    @state.stack.map (ContentView, index) =>
      <ContentView key={"#{index}:#{ContentView.id}"} />

  _onStackChanged: (stack) =>
    @setState stack: stack

module.exports = View
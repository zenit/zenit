React = require 'react'
ReactDOM = require 'react-dom'
ApplicationDelegate = require '../application-delegate'

ApplicationStore = require '../flux/stores/application'

_ = require 'underscore-plus'

class View extends React.Component
  @displayName = 'View'

  # TODO: Unmount views when switching
  constructor: (@props) ->
    @lastView = localStorage.getItem('zenit:last-view')?.split(',') || []

    @state =
      stack: ApplicationStore.getViews()

  componentDidMount: ->
    @unsubscribe = ApplicationStore.listen(@onStateChange)

    ###
    ApplicationDelegate.on 'inject-view', (view) =>
      @_onStackChanged(if typeof view is 'object' then view else [view])
    ###

  onStateChange: =>
    @setState stack: ApplicationStore.getViews()

  renderViews: =>
    return <span>There is no view in the stack</span> unless @state.stack.length > 0

    # Render
    @state.stack.map (ContentView, index) =>
      <ContentView key={"#{index}:#{ContentView.id}"} />

  render: =>
    <div className="view-inner">
      {@renderViews()}
    </div>

module.exports = View
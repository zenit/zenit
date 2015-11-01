React = require 'react'
ReactDOM = require 'react-dom'

ApplicationStore = require '../flux/stores/application'

_ = require 'underscore-plus'

class View extends React.Component
  @displayName = 'View'

  constructor: (@props) ->
    @lastView = localStorage.getItem('zenit:last-view')?.split(',') || []

    @state =
      stack: ApplicationStore.getViews()

  componentDidMount: =>
    @unsubscribe = ApplicationStore.listen(@onStateChange)

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
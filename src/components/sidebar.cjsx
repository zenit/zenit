React = require 'react'
ReactDOM = require 'react-dom'

Application = require '../flux/common/application'
ApplicationActions = require '../flux/actions/application'

class Sidebar extends React.Component
  @displayName = 'Sidebar'

  onQuickConnect: ->
    ApplicationActions.loadView('connection')

  onDrag: (e) =>
    {clientX} = e

    sidebar = @refs.sidebar
    bottom = @refs.bottom

    {width} = document.defaultView.getComputedStyle(sidebar)
    initWidth = parseInt(width, 10)

    startDrag = (e) ->
      adj = e.clientX - clientX

      sidebar.style.width = "#{(initWidth + adj)}px"
      bottom.style.width = "#{(initWidth + adj) - 1}px"
      
    stopDrag = (e) ->
      document.documentElement.removeEventListener 'mousemove', startDrag, false
      document.documentElement.removeEventListener 'mouseup', stopDrag, false

    document.documentElement.addEventListener 'mousemove', startDrag, false
    document.documentElement.addEventListener 'mouseup', stopDrag, false

  render: =>
    <div className="sidebar-inner" ref="sidebar">
      <a className="quick-connect-link" onClick={@onQuickConnect}><span className="octicon octicon-zap"></span> Quick connect</a>

      <span className="divider"></span>

      <a className="favorites-link">Favorites</a>
      <ul className="list list-reset favorites-list">
        <li>
          <a className="favorites-list-item">
            <span className="octicon octicon-database"></span> Github Server (Live)
          </a>
        </li>

        <li>
          <a className="favorites-list-item blue">
            <span className="octicon octicon-database"></span> My website (Local)
          </a>
        </li>

        <li>
          <a className="favorites-list-item green">
            <span className="octicon octicon-database"></span> Wordpress site
          </a>
        </li>
      </ul>

      <div className="bottom-links" ref="bottom">
        <span className="octicon octicon-gear" onClick={() -> Application.shell('openExternal', process.env.ZENIT_HOME)}></span>
        <span className="octicon octicon-file-directory"></span>
        <span className="octicon octicon-plus"></span>

        <span className="octicon octicon-info" onClick={() -> ApplicationActions.loadView('about')}></span>
      </div>

      <div className="view-resize-handle" onMouseDown={@onDrag}></div>
    </div>

module.exports = Sidebar
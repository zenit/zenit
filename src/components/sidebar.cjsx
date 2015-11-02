React = require 'react'

Application = require '../flux/common/application'
ApplicationActions = require '../flux/actions/application'

class Sidebar extends React.Component
  @displayName = 'Sidebar'

  constructor: ->
    @cachedSidebarWidth = localStorage.getItem('zenit:sidebar-width') || null

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
      result = initWidth + adj

      sidebar.style.width = "#{result}px"
      bottom.style.width = "#{result - 1}px"

      # Save sidebar width
      localStorage.setItem('zenit:sidebar-width', result)
      
    stopDrag = (e) ->
      document.documentElement.removeEventListener 'mousemove', startDrag, false
      document.documentElement.removeEventListener 'mouseup', stopDrag, false

    document.documentElement.addEventListener 'mousemove', startDrag, false
    document.documentElement.addEventListener 'mouseup', stopDrag, false

  render: =>
    sidebarStyles =
      width: "#{@cachedSidebarWidth}px" if @cachedSidebarWidth

    bottomStyles =
      width: "#{@cachedSidebarWidth - 1}px" if @cachedSidebarWidth

    <div className="sidebar-inner" style={sidebarStyles} ref="sidebar">
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

      <div className="bottom-links" style={bottomStyles} ref="bottom">
        <span className="octicon octicon-gear" onClick={Application.shell.bind(null, 'openExternal', process.env.ZENIT_HOME)}></span>
        <span className="octicon octicon-file-directory"></span>
        <span className="octicon octicon-plus"></span>

        <span className="octicon octicon-info" onClick={ApplicationActions.loadView.bind(null, 'about')}></span>
      </div>

      <div className="view-resize-handle" onMouseDown={@onDrag}></div>
    </div>

module.exports = Sidebar
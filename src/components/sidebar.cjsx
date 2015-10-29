React = require 'react'
ApplicationDelegate = require '../application-delegate'

class Sidebar extends React.Component
  @displayName = 'Sidebar'

  render: =>
    <div className="sidebar-inner">
      <a className="quick-connect-link" onClick={@_handleQuickConnect}><span className="octicon octicon-zap"></span> Quick connect</a>

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

      <div className="bottom-links">
        <span className="octicon octicon-gear" onClick={() -> ApplicationDelegate.shell('openExternal', process.env.ZENIT_HOME)}></span>
        <span className="octicon octicon-file-directory"></span>
        <span className="octicon octicon-plus"></span>

        <span className="octicon octicon-info" onClick={() -> ApplicationDelegate.emit('inject-view', 'about')}></span>
      </div>

      <div className="view-resize-handle"></div>
    </div>

  _handleQuickConnect: ->
    ApplicationDelegate.emit('inject-view', 'connection')

module.exports = Sidebar
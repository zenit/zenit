React = require 'react'

class Sidebar extends React.Component
  @displayName = 'Sidebar'

  render: =>
    <div className="sidebar-inner">
      <a className="quick-connect-link"><span className="octicon octicon-zap"></span> Quick connect</a>
      <span className="divider"></span>
      <a className="favorites-link">Favorites</a>
      <ul className="list list-reset favorites-list">
        <li>
          <a className="favorites-list-item">
            <span className="octicon octicon-database"></span> Github Server (Live)
          </a>
        </li>
      </ul>
    </div>

module.exports = Sidebar
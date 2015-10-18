React = require 'react'

class Header extends React.Component
  @displayName = 'Header'

  render: =>
    <div className="header-inner">
      <ul className="list list-reset tabs-list">
        <li>
          <a className="tabs-list-item">MAMP/wordpress</a>
        </li>
      </ul>
    </div>

module.exports = Header
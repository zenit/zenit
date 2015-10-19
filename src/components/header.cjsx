React = require 'react'

class Header extends React.Component
  @displayName = 'Header'

  render: =>
    <div className="header-inner">
      {@_renderLogo()}

      <ul className="list list-reset tabs-list">
        <li className="tabs-tab active">
          <a className="tabs-item">MAMP/wordpress</a>
          <span className="octicon octicon-x"></span>
        </li>

        <li className="tabs-tab">
          <a className="tabs-item">Github Server (Live)</a>
          <span className="octicon octicon-x"></span>
        </li>

        <li className="tabs-tab new-tab">
          <span className="octicon octicon-plus"></span>
        </li>
      </ul>

      <div className="history-buttons">
        <div className="history-button left active">
          <span className="mega-octicon octicon-chevron-left"></span>
        </div>

        <div className="history-button right disabled">
          <span className="mega-octicon octicon-chevron-right"></span>
        </div>
      </div>
    </div>

  _renderLogo: ->
    if process.platform != 'win32'
      <div className="logo">
        <a className="logo-link"></a>
      </div>
    else return <div></div>

module.exports = Header
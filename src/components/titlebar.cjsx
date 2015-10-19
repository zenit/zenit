React = require 'react'
ApplicationDelegate = new (require '../application-delegate')

class Titlebar extends React.Component
  @displayName = 'Titlebar'

  # TODO: Render application menu
  render: =>
    <div className="titlebar-inner">   
      {### NOTE: Currently this is unnecessary, keeping it in case is needed.
      <ul className="list list-reset menu-list">
        <li className="menu-item">Zenit</li>
        <li className="menu-item">Developer</li>
      </ul>
      ###}

      <div className="actions-wrapper">
        <ul className="actions-list">
          <li className="actions-item" onClick={ApplicationDelegate.minimizeWindow}><div className="img min"></div></li>
          <li className="actions-item" onClick={ApplicationDelegate.maximizeWindow}><div className="img max"></div></li>
          <li className="actions-item" onClick={ApplicationDelegate.closeWindow}><div className="img close"></div></li>
        </ul>
      </div>
    </div>

module.exports = Titlebar
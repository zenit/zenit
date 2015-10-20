React = require 'react'
ApplicationDelegate = new (require '../application-delegate')

class Titlebar extends React.Component
  @displayName = 'Titlebar'

  constructor: ->
    @state =
      classList: 'max'

  # TODO: Render application menu
  render: =>
    <div className="titlebar-inner">
      <div className="actions-wrapper">
        <ul className="actions-list">
          <li className="actions-item" onClick={ApplicationDelegate.minimizeWindow}><div className="img min"></div></li>
          <li className="actions-item" onClick={=>
            if ApplicationDelegate.isWindowMaximized()
              @setState
                classList: 'max'

              ApplicationDelegate.restoreWindow()
            else
              @setState
                classList: 'max restore'

              ApplicationDelegate.maximizeWindow()
          }><div className={"img " + @state.classList}></div></li>
          <li className="actions-item" onClick={ApplicationDelegate.closeWindow}><div className="img close"></div></li>
        </ul>
      </div>
    </div>

module.exports = Titlebar
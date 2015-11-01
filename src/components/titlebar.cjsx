React = require 'react'
Application = require '../flux/common/application'

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
          <li className="actions-item" onClick={Application.minimizeWindow}><div className="img min"></div></li>
          <li className="actions-item" onClick={=>
            if Application.isWindowMaximized()
              @setState
                classList: 'max'

              Application.restoreWindow()
            else
              @setState
                classList: 'max restore'

              Application.maximizeWindow()
          }><div className={"img " + @state.classList}></div></li>
          <li className="actions-item" onClick={Application.closeWindow}><div className="img close"></div></li>
        </ul>
      </div>
    </div>

module.exports = Titlebar
React = require 'react'

ApplicationCommon = require '../flux/common/application'
ApplicationActions = require '../flux/actions/application'

class Header extends React.Component
  @displayName = 'Header'
  @propTypes:
    menuItems: React.PropTypes.array

  constructor: (@props) ->
    @state =
      menuItems: @props.menuItems

  onTab: (index) ->
    # TODO: Create only the first time
    ###
    ApplicationCommon.createDialog
      type: 'warning'
      buttons: ['Ok', 'No']
      message: 'The current connection will be closed'
      detail: 'You can enable concurrent sessions in settings.'
    ###

  onNewTab: =>
    @setState (state) ->
      state.menuItems.push(name: 'Untitled')

      menuItems: state.menuItems

    ApplicationActions.loadView('connection')

  onCloseTab: (index) =>
    @setState (state) ->
      state.menuItems.splice(index, 1)

      menuItems: state.menuItems

  renderLogo: ->
    if process.platform != 'win32'
      <div className="logo">
        <a className="logo-link"></a>
      </div>
    else return <div></div>

  renderMenuItems: =>
    @state.menuItems.map (item, index) =>
      classnames = if index is 0 then 'active' else ''

      <li className="tabs-tab #{classnames}" key={index} onClick={@onTab.bind(null, index)}>
        <a className="tabs-item">{item.name}</a>

        <span className="octicon octicon-x" onClick={@onCloseTab.bind(null, index)}></span>
      </li>

  render: =>
    <div className="header-inner">
      {@renderLogo()}

      <ul className="list list-reset tabs-list">
        {@renderMenuItems()}
        
        <li className="tabs-tab new-tab" onClick={@onNewTab}>
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

module.exports = Header
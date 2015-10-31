React = require 'react'

class Header extends React.Component
  @displayName = 'Header'
  @propTypes:
    menuItems: React.PropTypes.array

  constructor: (@props) ->
    @state =
      menuItems: @props.menuItems

  render: =>
    <div className="header-inner">
      {@_renderLogo()}

      <ul className="list list-reset tabs-list">
        {@_renderMenuItems()}
        
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

  _renderMenuItems: =>
    @state.menuItems.map (item, index) =>
      classnames = if index is 0 then 'active' else ''

      <li className="tabs-tab #{classnames}" key={index}>
        <a className="tabs-item">{item.name}</a>

        <span className="octicon octicon-x" value={index} onClick={@_handleCloseItem}></span>
      </li>

  _handleCloseItem: (e) =>
    index = parseInt(e.target.value, 10)

    @setState (state) ->
      state.menuItems.splice(index, 1)

      menuItems: state.menuItems

module.exports = Header
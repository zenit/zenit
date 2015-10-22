React = require 'react'
{getWindowLoadSettings} = require '../window-load-settings-helpers'

class AboutView extends React.Component
  @displayName = 'AboutView'
  @id = 'about'

  render: =>
    <div className="view about centered">
      <div className="logo">
        <span className="version">test</span>
      </div>
    </div>

module.exports = AboutView
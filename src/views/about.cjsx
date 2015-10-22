React = require 'react'

class AboutView extends React.Component
  @displayName = 'AboutView'
  @id = 'about'

  render: =>
    <div className="view about">
      About view content!
    </div>

module.exports = AboutView
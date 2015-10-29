React = require 'react'

class MainView extends React.Component
  @displayName = 'MainView'
  @id = 'main'

  render: =>
    <div className="view main">
      Main view content!
    </div>

module.exports = MainView
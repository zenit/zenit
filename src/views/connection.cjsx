React = require 'react'

class ConnectionView extends React.Component
  @displayName = 'ConnectionView'
  @id = 'connection'

  render: =>
    <div className="view connection">
      connection view!
    </div>

module.exports = ConnectionView
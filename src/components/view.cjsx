React = require 'react'

class View extends React.Component
  @displayName = 'View'

  render: =>
    <div className="view-inner">
      View content
    </div>

module.exports = View
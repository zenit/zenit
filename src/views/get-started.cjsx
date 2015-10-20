React = require 'react'

class GetStartedView extends React.Component
  @displayName = 'GetStartedView'
  @id = 'get-started'

  render: =>
    <div className="view get-started">
      get-started view!
    </div>

module.exports = GetStartedView
React = require 'react'

class View extends React.Component
  @displayName = 'View'

  render: =>
    <div className="view-inner">
      {# Custom element, use normal class tag #}
      <zenit-axis class="vertical">
        Content!
      </zenit-axis>
    </div>

module.exports = View
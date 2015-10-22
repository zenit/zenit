React = require 'react'

class ConnectionView extends React.Component
  @displayName = 'ConnectionView'
  @id = 'connection'

  render: =>
    <div className="view connection centered">
      <p className="title">Enter connection details below, or choose a favorite</p>

      <div className="container">
        <label>Name</label>
        <input type="text" />

        <label>Username</label>
        <input type="text" />

        <label>Password</label>
        <input type="password" />
      </div>

      <button className="btn btn-connect" onClick={@_handleConnect}>Connect</button>
    </div>

  _handleConnect: ->
    console.log 'conn..'

module.exports = ConnectionView
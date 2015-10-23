React = require 'react'
ApplicationDelegate = require '../application-delegate'

class ConnectionView extends React.Component
  @displayName = 'ConnectionView'
  @id = 'connection'

  render: =>
    <div className="view connection centered">
      <p className="title">Enter connection details below, or choose a favorite</p>

      <div className="container" onKeyDown={@_handleKeys}>
        <label>Name</label>
        <input type="text" />

        <label>Username</label>
        <input type="text" />

        <label>Password</label>
        <input type="password" />

        <label>Database</label>
        <input type="text" placeholder="my-db-name" />

        <label>Port</label>
        <input type="text" placeholder="3306" />
      </div>

      <button className="btn btn-connect" onClick={@_handleConnect}>Connect</button>
    </div>

  _handleKeys: (evt) =>
    # int(13) = Enter
    @_handleConnect() if evt.keyCode is 13

  _handleConnect: ->
    # Error sound
    ApplicationDelegate.beep()

module.exports = ConnectionView
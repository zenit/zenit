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
        <input type="text" ref={(c) => @_inputName = c} />

        <label>Hostname</label>
        <input type="text" defaultValue="127.0.0.1" ref={(c) => @_inputHost = c} />

        <label>Username</label>
        <input type="text" ref={(c) => @_inputUser = c} />

        <label>Password</label>
        <input type="password" ref={(c) => @_inputPassword = c} />

        <label>Database</label>
        <input type="text" placeholder="my-db-name" ref={(c) => @_inputDatabase = c} />

        <label>Port</label>
        <input type="text" placeholder="3306" />
      </div>

      <button className="btn btn-connect" onClick={@_handleConnect}>Connect</button>
    </div>

  _handleKeys: (evt) =>
    # int(13) = Enter
    @_handleConnect() if evt.keyCode is 13

  _handleConnect: =>
    ApplicationDelegate.connect(
      host: @_inputHost.value
      user: @_inputUser.value
      password: @_inputPassword.value
      database: @_inputDatabase.value
    ).then(->
      alert 'Connected to root@localhost'
    ).catch((err) ->
      # Play 'beep' sound
      ApplicationDelegate.beep()
    )

module.exports = ConnectionView
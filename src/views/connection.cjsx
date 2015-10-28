React = require 'react'
ApplicationDelegate = require '../application-delegate'

class ConnectionView extends React.Component
  @displayName = 'ConnectionView'
  @id = 'connection'

  render: =>
    <div className="view connection centered">
      <p className="title">Enter connection details below, or choose a favorite</p>

      <div className="container" onKeyDown={@_handleKeys}>
        <div className="form-item">
          <label>Name:</label>
          <input type="text" placeholder="My Great Website (Live)" ref={(c) => @_inputName = c} />
        </div>

        <div className="form-item">
          <label>Hostname:</label>
          <input type="text" placeholder="127.0.0.1" ref={(c) => @_inputHost = c} />
        </div>

        <div className="form-item">
          <label>Username:</label>
          <input type="text" placeholder="myuser" ref={(c) => @_inputUser = c} />
        </div>

        <div className="form-item">
          <label>Password:</label>
          <input type="password" ref={(c) => @_inputPassword = c} />
        </div>

        <div className="form-item">
          <label>Database:</label>
          <input type="text" placeholder="my-db-name" ref={(c) => @_inputDatabase = c} />
        </div>

        <div className="form-item">
          <label>Port:</label>
          <input type="text" placeholder="3306" />
        </div>
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
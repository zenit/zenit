React = require 'react'
_ = require 'underscore-plus'

ApplicationActions = require '../flux/actions/application'
DatabaseActions = require '../flux/actions/database'
DatabaseStore = require '../flux/stores/database'

class ConnectionView extends React.Component
  @displayName = 'ConnectionView'
  @id = 'connection'

  constructor: ->
    @state = _.clone(DatabaseStore.getStore())

  componentDidMount: =>
    @unsubscribe = DatabaseStore.listen(@onStateChange)

  componentWillUnmount: =>
    @unsubscribe()

  shouldComponentUpdate: =>
    # If the status of the new connection is true then load main view 
    if @state.connections.length > 0 and @state.connections[0].status is true
      ApplicationActions.loadView('main')

      false
    else true

  onStateChange: =>
    @setState DatabaseStore.getStore()

  render: =>
    classnames = "view connection centered"
    classnames += " loading" if @state.loading

    <div className={classnames}>
      <p className="title">Enter connection details below, or choose a favorite</p>

      <div className="container" onKeyDown={@_handleKeys}>
        <div className="form-item">
          <label>Name:</label>
          <input type="text" placeholder="My Great Website (Live)" ref="nameInput" />
        </div>

        <div className="form-item">
          <label>Hostname:</label>
          <input type="text" placeholder="127.0.0.1" ref="hostInput" />
        </div>

        <div className="form-item">
          <label>Username:</label>
          <input type="text" placeholder="myuser" ref="userInput" />
        </div>

        <div className="form-item">
          <label>Password:</label>
          <input type="password" ref="passwordInput" />
        </div>

        <div className="form-item">
          <label>Database:</label>
          <input type="text" placeholder="my-db-name" ref="databaseInput" />
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
    nameInput = @refs.nameInput.value

    DatabaseActions.createConnection(
      name: if nameInput.length > 0 then nameInput else 'Untitled'
      host: @refs.hostInput.value
      user: @refs.userInput.value
      password: @refs.passwordInput.value
      database: @refs.databaseInput.value
    )

    ###
    .then(=>
      @setState loading: false

      _.defer(-> ApplicationActions.loadView('main'))
    ).catch((err) =>
      @setState loading: false

      console.log err

      # Play 'beep' sound
      _.defer(ApplicationDelegate.beep)
    )
    ###

module.exports = ConnectionView
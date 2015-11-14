Reflux = require 'reflux'
Actions = require '../actions/database'
Common = require '../common/application'
Executor = new (require('remote').require('../browser/application-executor.coffee'))

cache =
  loading: false
  connections: []

Store = Reflux.createStore(
  init: ->
    @listenToMany(Actions)

  onCreateConnection: (data) ->
    cache.loading = true
    @trigger()

    Executor.createConnection(data)
      .then(=>
        cache.loading = false

        conn =
          name: data.name
          status: true
          data: data

        cache.connections.unshift conn

        @trigger()
      )
      .catch((err) =>
        cache.loading = false
        Common.beep()

        Common.createDialog
          type: 'warning'
          buttons: ['Ok']
          message: "Unable to connect to host #{data.host}"
          detail: """
            Please ensure that your MySQL host is set up to allow
            TCP/IP connections and is configured to allow connections
            from the host you are tunnelling via.

            You may also want to check the port is correct and
            that you have the necessary privileges.

            MySQL said: #{err.message}
            """

        @trigger()
      )

  query: (q) ->
    Executor.query(q)
      .then((rows) =>
        console.log rows
      )

  getStore: ->
    cache
)

module.exports = Store
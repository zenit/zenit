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
      .then((=>
        cache.loading = false

        conn =
          name: data.name
          status: true
          data: data

        cache.connections.unshift conn

        @trigger()
      ))
      .catch(=> 
        cache.loading = false
        Common.beep()

        @trigger()
      )

  getStore: ->
    cache
)

module.exports = Store
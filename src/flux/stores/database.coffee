Reflux = require 'reflux'
Actions = require '../actions/database'

cache =
  connections: []

Store = Reflux.createStore(
  init: ->
    @listenToMany(Actions)

  onCreateConnection: (conn) ->
    cache.connections.push conn
    
    @trigger()

  getStore: ->
    cache
)

module.exports = Store
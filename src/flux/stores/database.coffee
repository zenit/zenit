Reflux = require 'reflux'
Actions = require '../actions/database'
Common = require '../common/application'
Got = require 'got'

cache =
  loading: false
  connections: []

Store = Reflux.createStore(
  init: ->
    @listenToMany(Actions)

  onCreateConnection: (data) ->
    cache.loading = true
    @trigger()

    Got "http://localhost:#{process.env.ZENIT_SERVICE}/connect/#{data.host}/#{data.user}/#{data.password}/#{data.database}", (err, body) =>
      cache.loading = false

      ###
      if err or body is 'fail'
        Common.beep()
      else
        cache.connections.push connectionData
      ###

      @trigger()

  ###
  query: (sql) -> new Promise((resolve, reject) ->
    got "http://localhost:#{process.env.ZENIT_SERVICE}/query/#{encodeURIComponent(sql)}", (err, body) ->
      return reject(err) if err

      try
        resolve(JSON.parse(body))
      catch err
        reject(err)
  )
  ###

  getStore: ->
    cache
)

module.exports = Store
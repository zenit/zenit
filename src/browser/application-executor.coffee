Hapi = require 'hapi'
Mysql = require 'mysql'

module.exports =
class ApplicationExecutor
  server: null
  driver: null

  constructor: ->
    @server = new Hapi.Server()
    # TODO: Use a custom driver
    @driver = Mysql.createConnection(
      host: 'localhost'
      user: 'root'
      password: 'test'
      database: 'xat'
    )

    @server.connection({
      host: 'localhost'
      port: 9000 
    })

    @server.route(
      method: 'GET'
      path: '/query/{query}'
      handler: (request, reply) =>
        @driver.query(request.params.query, (err, rows) ->
          reply(rows)
        )
    )

    @bootstrap()

  bootstrap: ->
    @driver.connect()
    @server.start(=> console.log "Listening for new connections at @#{@server.info.uri}")
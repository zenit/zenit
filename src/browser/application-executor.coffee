Hapi = require 'hapi'
Mysql = require 'mysql'

module.exports =
class ApplicationExecutor
  server: null
  driver: null

  constructor: ->
    process.env.ZENIT_SERVICE ?= 9000

    @server = new Hapi.Server()
    @driver = {}

    @server.connection(
      host: 'localhost'
      port: process.env.ZENIT_SERVICE
    )

    @server.route(
      method: 'GET'
      path: '/connect/{data*4}'
      handler: (request, reply) =>
        dataParts = request.params.data.split('/')

        # TODO: 
        #  Use a custom driver
        #  Emit event on ECONNRESET
        @driver = Mysql.createConnection(
          host: dataParts[0]
          user: dataParts[1]
          password: dataParts[2]
          database: dataParts[3]
        )
        @driver.connect()

        # Test the connection
        @driver.query('SELECT 1', (err) ->
          return reply('fail') if err

          reply('ok')
        )
    )

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
    @server.start(=> console.log "Listening for new connections at @#{@server.info.uri}")
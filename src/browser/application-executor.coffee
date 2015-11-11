Mysql = require 'mysql'

module.exports =
class ApplicationExecutor
  driver: null

  constructor: ->
    
  createConnection: (conn) -> new Promise (resolve, reject) ->
    @driver = Mysql.createConnection(conn)

    @driver.connect (err) ->
      if err then reject(err) else resolve()

  query: (q) -> new Promise (resolve, reject) ->
    @driver.query q, (err, rows) ->
      if err then reject(err) else resolve(rows)
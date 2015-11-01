ipc = require 'ipc'
remote = require 'remote'
shell = require 'shell'
{Emitter} = require 'event-kit'
got = require 'got'
_ = require 'underscore-plus'

ApplicationDelegate =
  # Application executor methods
  query: (sql) -> new Promise((resolve, reject) ->
    got "http://localhost:#{process.env.ZENIT_SERVICE}/query/#{encodeURIComponent(sql)}", (err, body) ->
      return reject(err) if err

      try
        resolve(JSON.parse(body))
      catch err
        reject(err)
  )

module.exports = _.extend(ApplicationDelegate, new Emitter)
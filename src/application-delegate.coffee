ipc = require 'ipc'
remote = require 'remote'
shell = require 'shell'
{Emitter} = require 'event-kit'
got = require 'got'

module.exports =
  emitter: new Emitter

  showWindow: ->
    ipc.send('call-window-method', 'show')

  closeWindow: ->
    ipc.send("call-window-method", "close")

  focusWindow: ->
    ipc.send("call-window-method", "focus")

  maximizeWindow: ->
    ipc.send("call-window-method", "maximize")

  isWindowMaximized: ->
    remote.getCurrentWindow().isMaximized()
  
  minimizeWindow: ->
    ipc.send("call-window-method", "minimize")

  restoreWindow: ->
    ipc.send("call-window-method", "restore")

  shell: (method, args...) ->
    shell[method](args...)

  beep: ->
    shell.beep()

  query: (sql) -> new Promise((resolve, reject) ->
    got "http://localhost:#{process.env.ZENIT_SERVICE}/query/#{encodeURIComponent(sql)}", (err, body) ->
      return reject(err) if err

      try
        resolve(JSON.parse(body))
      catch err
        reject(err)
  )

  connect: (data) -> new Promise((resolve, reject) ->
    got "http://localhost:#{process.env.ZENIT_SERVICE}/connect/#{data.host}/#{data.user}/#{data.password}/#{data.database}", (err, body) ->
      return reject(err) if err or body is 'fail'

      resolve()
  )

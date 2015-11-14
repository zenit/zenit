global.shellStartTime = Date.now()

const app = require('app'),
  fs = require('fs'),
  path = require('path'),
  yargs = require('yargs')

function start() {
  const args = parseCommandLine()

  setupCoffeeScript()

  app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') {
      app.quit()
    }
  })

  app.on('ready', () => {
    var Application = require('./application')
    new Application(args)

    console.log(`App load time: ${Date.now() - global.shellStartTime}ms`)
  })
}

function parseCommandLine() {
  var options = yargs(process.argv.slice(1))

  options.alias('d', 'dev').boolean('d').describe('d', 'Run in development mode.')

  var args = options.argv

  return {
    devMode: args['dev']
  }
}

function setupCoffeeScript() {
  require.extensions['.coffee'] = (module, filePath) => {
    var CoffeeScript = require('coffee-script')
    var coffee = fs.readFileSync(filePath, 'utf8')

    var js = CoffeeScript.compile(coffee, { filename: filePath })

    module._compile(js, filePath)
  }
}

start()
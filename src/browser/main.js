global.shellStartTime = Date.now();

const app = require('app'),
  fs = require('fs'),
  path = require('path');

function start() {
  setupCoffeeScript();

  app.on('window-all-closed', function() {
    if (process.platform !== 'darwin') {
      app.quit();
    }
  });

  app.on('ready', function() {
    var Application = require('./application');
    new Application();

    console.log(`App load time: ${Date.now() - global.shellStartTime}ms`)
  });
}

function setupCoffeeScript() {
  require.extensions['.coffee'] = function(module, filePath) {
    var CoffeeScript = require('coffee-script');
    var coffee = fs.readFileSync(filePath, 'utf8');

    var js = CoffeeScript.compile(coffee, { filename: filePath });

    module._compile(js, filePath);
  }
}

start();
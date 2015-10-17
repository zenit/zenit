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

    Application.bootstrap();
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
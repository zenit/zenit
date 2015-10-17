(function() {
  var path = require('path')

  window.onload = function () {
    setupZenitHome()
    setupWindow()
  }

  function setupWindow() {
    // Start the crash reporter
    require('crash-reporter').start({
      productName: 'Zenit',
      // By explicitly passing the app version here, we could save the call
      // of "require('remote').require('app').getVersion()".
      extra: {_version: require('../package.json').version}
    })
    
    require('ipc').sendChannel('window-command', 'window:loaded')
  }

  function setupZenitHome () {
    if (!process.env.ZENIT_HOME) {
      var home
      if (process.platform === 'win32') {
        home = process.env.USERPROFILE
      } else {
        home = process.env.HOME
      }
      var zenitHome = path.join(home, '.atom')
      try {
        zenitHome = fs.realpathSync(zenitHome)
      } catch (error) {
        // Ignore since the path might just not exist yet.
      }
      process.env.ZENIT_HOME = zenitHome
    }
  } 

  function setupWindowBackground () {
    var backgroundColor = window.localStorage.getItem('zenit:window-background-color')
    if (!backgroundColor) {
      return
    }

    var backgroundStylesheet = document.createElement('style')
    backgroundStylesheet.type = 'text/css'
    backgroundStylesheet.innerText = 'html, body { background: ' + backgroundColor + ' !important; }'
    document.head.appendChild(backgroundStylesheet)

    // Remove once the page loads
    window.addEventListener('load', function loadWindow () {
      window.removeEventListener('load', loadWindow, false)
      setTimeout(function () {
        backgroundStylesheet.remove()
        backgroundStylesheet = null
      }, 1000)
    }, false)
  }

  setupWindowBackground()
})()
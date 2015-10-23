(function() {
  // This is to prevent React from displaying an annoying message about
  // installing their dev tools. The React dev tools put a variable on the
  // global scope. We need to do it here before React loads.
  window.__REACT_DEVTOOLS_GLOBAL_HOOK__ = {}

  var path = require('path')

  var loadSettings = null
  var loadSettingsError = null

  window.onload = function () {
    try {
      var startTime = Date.now()

      process.on('unhandledRejection', function (error, promise) {
        console.error('Unhandled promise rejection %o with error: %o', promise, error)
      })

      setupZenitHome()

      // Normalize to make sure drive letter case is consistent on Windows
      process.resourcesPath = path.normalize(process.resourcesPath)

      if (loadSettingsError) {
        throw loadSettingsError
      }

      if (loadSettings.devMode) {
        var currentWindow = require('remote').getCurrentWindow()
        currentWindow.openDevTools()
      }

      setupWindow()
      setLoadTime(Date.now() - startTime)
    } catch (error) {
      handleSetupError(error)
    }
  }

  function setLoadTime (loadTime) {
    if (global.zenit) {
      global.zenit.loadTime = loadTime
      console.log('Window load time: ' + global.zenit.getWindowLoadTime() + 'ms')
    }
  }

  function handleSetupError (error) {
    var currentWindow = require('remote').getCurrentWindow()
    currentWindow.setSize(800, 600)
    currentWindow.center()
    currentWindow.show()
    currentWindow.openDevTools()
    console.error(error.stack || error)
    console.error(error.message, error)
  }

  function setupWindow() {
    var CompileCache = require('../src/compile-cache')
    CompileCache.setZenitHomeDirectory(process.env.ZENIT_HOME)

    var ModuleCache = require('../src/module-cache')
    ModuleCache.register(loadSettings)
    ModuleCache.add(loadSettings.resourcePath)

    // Start the crash reporter
    require('crash-reporter').start({
      productName: 'Zenit',
      // By explicitly passing the app version here, we could save the call
      // of "require('remote').require('app').getVersion()".
      extra: {_version: require('../package.json').version}
    })
    
    require(loadSettings.windowInitializationScript)
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
      var zenitHome = path.join(home, '.zenit')
      try {
        zenitHome = fs.realpathSync(zenitHome)
      } catch (error) {
        // Ignore since the path might just not exist yet.
      }
      process.env.ZENIT_HOME = zenitHome
    }
  }

  function parseLoadSettings () {
    var rawLoadSettings = decodeURIComponent(window.location.hash.substr(1))
    try {
      loadSettings = JSON.parse(rawLoadSettings)
    } catch (error) {
      console.error('Failed to parse load settings: ' + rawLoadSettings)
      loadSettingsError = error
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
  
  parseLoadSettings()
  setupWindowBackground()
})()
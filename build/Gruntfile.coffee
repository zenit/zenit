path = require 'path'
packageJson = require '../package.json'

module.exports = (grunt) ->
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-less')
  grunt.loadNpmTasks('grunt-cson')
  grunt.loadNpmTasks('grunt-download-electron')
  grunt.loadNpmTasks('grunt-electron-installer')
  grunt.loadTasks('tasks')

  # This allows all subsequent paths to the relative to the root of the repo
  grunt.file.setBase(path.resolve('..'))

  appName = packageJson.productName
  appFileName = packageJson.name
  apmFileName = 'apm'
  buildDir = path.join(__dirname, 'zenit-build')
  shellAppDir = path.join(buildDir, appName)
  symbolsDir = path.join(buildDir, 'Zenit.breakpad.syms')

  if process.platform is 'win32'
    homeDir = process.env.USERPROFILE
    contentsDir = shellAppDir
    appDir = path.join(shellAppDir, 'resources', 'app')
  else if process.platform is 'darwin'
    homeDir = process.env.HOME
    contentsDir = path.join(shellAppDir, 'Contents')
    appDir = path.join(contentsDir, 'Resources', 'app')
  else
    homeDir = process.env.HOME
    contentsDir = shellAppDir
    appDir = path.join(shellAppDir, 'resources', 'app')

  electronDownloadDir = path.join(homeDir, '.zenit', 'electron')

  # Configs
  coffeeConfig =
    glob_to_multiple:
      expand: true
      src: [
        'src/**/*.coffee'
        'static/**/*.coffee'
      ]
      dest: appDir
      ext: '.js'

  lessConfig =
    options:
      paths: [
        'static/variables'
        'static'
      ]
    glob_to_multiple:
      expand: true
      src: [
        'static/**/*.less'
      ]
      dest: appDir
      ext: '.css'

  prebuildLessConfig =
    src: [
      'static/**/*.less'
    ]

  csonConfig =
    options:
      rootObject: true
      cachePath: path.join(homeDir, '.zenit', 'compile-cache', 'grunt-cson')

    glob_to_multiple:
      expand: true
      src: [
        'menus/*.cson'
        'keymaps/*.cson'
        'static/**/*.cson'
      ]
      dest: appDir
      ext: '.json'

  # Initialize grunt config
  grunt.initConfig(
    pkg: grunt.file.readJSON('package.json')
    zenit: {
      appName, appFileName,
      appDir, buildDir, contentsDir, shellAppDir, symbolsDir,
    }
    coffee: coffeeConfig
    less: lessConfig
    prebuildLess: prebuildLessConfig
    cson: csonConfig

    'download-electron':
      version: packageJson.electronVersion
      outputDir: 'electron'
      downloadDir: electronDownloadDir
      rebuild: true  # rebuild native modules after electron is updated
  )

  # Register tasks
  grunt.registerTask('compile', ['coffee', 'less', 'cson'])

  grunt.registerTask('default', ['download-electron', 'build'])
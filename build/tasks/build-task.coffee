fs = require 'fs'
path = require 'path'
_ = require 'underscore-plus'

module.exports = (grunt) ->
  {cp, isZenitPackage, mkdir, rm} = require('./task-helpers')(grunt)

  grunt.registerTask 'build', 'Build the application', ->
    shellAppDir = grunt.config.get('zenit.shellAppDir')
    buildDir = grunt.config.get('zenit.buildDir')
    appDir = grunt.config.get('zenit.appDir')

    rm shellAppDir
    rm path.join(buildDir, 'installer')
    mkdir path.dirname(buildDir)

    if process.platform is 'darwin'
      cp 'electron/Electron.app', shellAppDir, filter: /default_app/
      cp(path.join(shellAppDir, 'Contents', 'MacOS', 'Electron'),
         path.join(shellAppDir, 'Contents', 'MacOS', 'Zenit'))
      rm path.join(shellAppDir, 'Contents', 'MacOS', 'Electron')
    else if process.platform is 'win32'
      cp 'electron', shellAppDir, filter: /default_app/
      cp path.join(shellAppDir, 'electron.exe'), path.join(shellAppDir, 'zenit.exe')
      rm path.join(shellAppDir, 'electron.exe')
    else
      cp 'electron', shellAppDir, filter: /default_app/
      cp path.join(shellAppDir, 'electron'), path.join(shellAppDir, 'zenit')
      rm path.join(shellAppDir, 'electron')

    mkdir appDir

    if process.platform isnt 'win32'
      cp 'zenit.sh', path.resolve(appDir, '..', 'new-app', 'zenit.sh')

    cp 'package.json', path.join(appDir, 'package.json')

    packageNames = []
    packageDirectories = []
    nonPackageDirectories = []

    {devDependencies} = grunt.file.readJSON('package.json')
    for child in fs.readdirSync('node_modules')
      directory = path.join('node_modules', child)
      if isZenitPackage(directory)
        packageDirectories.push(directory)
        packageNames.push(child)
      else
        nonPackageDirectories.push(directory)

    # Put any paths here that shouldn't end up in the built Zenit.app
    # so that it doesn't becomes larger than it needs to be.
    ignoredPaths = [
      path.join('oniguruma', 'deps')
      path.join('node_modules', 'nan')
      path.join('node_modules', 'native-mate')
      path.join('node_modules', 'electron-prebuilt')
      path.join('node_modules', 'electron-rebuild')
      path.join('build', 'binding.Makefile')
      path.join('build', 'config.gypi')
      path.join('build', 'gyp-mac-tool')
      path.join('build', 'Makefile')
      path.join('build', 'Release', 'obj.target')
      path.join('build', 'Release', 'obj')
      path.join('build', 'Release', '.deps')
      path.join('vendor', 'zpm')

      '.DS_Store'
      '.jshintrc'
      '.npmignore'
      '.pairs'
      '.travis.yml'
      'appveyor.yml'
      '.idea'
      '.editorconfig'
      '.lint'
      '.lintignore'
      '.eslintrc'
      '.jshintignore'
      'coffeelint.json'
      '.coffeelintignore'
      '.gitattributes'
      '.gitkeep'
    ]

    packageNames.forEach (packageName) -> ignoredPaths.push(path.join(packageName, 'spec'))

    ignoredPaths = ignoredPaths.map (ignoredPath) -> _.escapeRegExp(ignoredPath)

    # Add .* to avoid matching hunspell_dictionaries.
    ignoredPaths.push "#{_.escapeRegExp(path.join('build', 'Release') + path.sep)}.*\\.pdb"

    # Ignore *.cc and *.h files from native modules
    ignoredPaths.push "#{_.escapeRegExp(path.join('ctags', 'src') + path.sep)}.*\\.(cc|h)*"
    ignoredPaths.push "#{_.escapeRegExp(path.join('git-utils', 'src') + path.sep)}.*\\.(cc|h)*"
    ignoredPaths.push "#{_.escapeRegExp(path.join('keytar', 'src') + path.sep)}.*\\.(cc|h)*"
    ignoredPaths.push "#{_.escapeRegExp(path.join('nslog', 'src') + path.sep)}.*\\.(cc|h)*"
    ignoredPaths.push "#{_.escapeRegExp(path.join('oniguruma', 'src') + path.sep)}.*\\.(cc|h)*"
    ignoredPaths.push "#{_.escapeRegExp(path.join('pathwatcher', 'src') + path.sep)}.*\\.(cc|h)*"
    ignoredPaths.push "#{_.escapeRegExp(path.join('runas', 'src') + path.sep)}.*\\.(cc|h)*"
    ignoredPaths.push "#{_.escapeRegExp(path.join('scrollbar-style', 'src') + path.sep)}.*\\.(cc|h)*"
    ignoredPaths.push "#{_.escapeRegExp(path.join('spellchecker', 'src') + path.sep)}.*\\.(cc|h)*"
    ignoredPaths.push "#{_.escapeRegExp(path.join('keyboard-layout', 'src') + path.sep)}.*\\.(cc|h|mm)*"

    # Ignore build files
    ignoredPaths.push "#{_.escapeRegExp(path.sep)}binding\\.gyp$"
    ignoredPaths.push "#{_.escapeRegExp(path.sep)}.+\\.target.mk$"
    ignoredPaths.push "#{_.escapeRegExp(path.sep)}linker\\.lock$"
    ignoredPaths.push "#{_.escapeRegExp(path.join('build', 'Release') + path.sep)}.+\\.node\\.dSYM"

    ignoredPaths = ignoredPaths.map (ignoredPath) -> "(#{ignoredPath})"

    testFolderPattern = new RegExp("#{_.escapeRegExp(path.sep)}_*te?sts?_*#{_.escapeRegExp(path.sep)}")
    exampleFolderPattern = new RegExp("#{_.escapeRegExp(path.sep)}examples?#{_.escapeRegExp(path.sep)}")

    nodeModulesFilter = new RegExp(ignoredPaths.join('|'))
    filterNodeModule = (pathToCopy) ->
      pathToCopy = path.resolve(pathToCopy)
      nodeModulesFilter.test(pathToCopy) or testFolderPattern.test(pathToCopy) or exampleFolderPattern.test(pathToCopy)

    packageFilter = new RegExp("(#{ignoredPaths.join('|')})|(.+\\.(cson|coffee)$)")
    filterPackage = (pathToCopy) ->
      pathToCopy = path.resolve(pathToCopy)
      packageFilter.test(pathToCopy) or testFolderPattern.test(pathToCopy) or exampleFolderPattern.test(pathToCopy)

    for directory in nonPackageDirectories
      cp directory, path.join(appDir, directory), filter: filterNodeModule

    for directory in packageDirectories
      cp directory, path.join(appDir, directory), filter: filterPackage

    cp 'src', path.join(appDir, 'src'), filter: /.+\.(cson|coffee|cjsx)$/
    cp 'static', path.join(appDir, 'static')

    cp path.join('zpm', 'node_modules', 'zenit-package-manager'), path.resolve(appDir, '..', 'new-app', 'zpm'), filter: filterNodeModule

    if process.platform is 'darwin'
      grunt.file.recurse path.join('resources', 'mac'), (sourcePath, rootDirectory, subDirectory='', filename) ->
        unless /.+\.plist/.test(sourcePath)
          grunt.file.copy(sourcePath, path.resolve(appDir, '..', subDirectory, filename))

    if process.platform is 'win32'
      cp path.join('resources', 'win', 'zenit.cmd'), path.join(shellAppDir, 'resources', 'cli', 'zenit.cmd')
      cp path.join('resources', 'win', 'zenit.sh'), path.join(shellAppDir, 'resources', 'cli', 'zenit.sh')
      cp path.join('resources', 'win', 'zenit.js'), path.join(shellAppDir, 'resources', 'cli', 'zenit.js')
      cp path.join('resources', 'win', 'zpm.sh'), path.join(shellAppDir, 'resources', 'cli', 'zpm.sh')

    if process.platform is 'linux'
      cp path.join('resources', 'app-icons', 'png'), path.join(buildDir, 'icons')

    dependencies = ['compile', 'generate-module-cache', 'compile-packages-slug']
    dependencies.push('set-exe-icon') if process.platform is 'win32'
    grunt.task.run(dependencies...)
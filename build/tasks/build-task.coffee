fs = require 'fs'
path = require 'path'
_ = require 'underscore-plus'

module.exports = (grunt) ->
  grunt.registerTask 'build', 'Build the application', ->
    {cp, isZenitPackage, mkdir, rm} = require('./task-helpers')(grunt)

    shellAppDir = grunt.config.get('zenit.shellAppDir')
    buildDir = grunt.config.get('zenit.buildDir')
    appDir = grunt.config.get('zenit.appDir')

    rm shellAppDir
    rm path.join(buildDir, 'installer')
    mkdir path.dirname(buildDir)

    if process.platform is 'darwin'
      cp 'electron/Electron.app', shellAppDir, filter: /default_app/
      fs.renameSync path.join(shellAppDir, 'Contents', 'MacOS', 'Electron'), path.join(shellAppDir, 'Contents', 'MacOS', 'Zenit')
      fs.renameSync path.join(shellAppDir, 'Contents', 'Frameworks', 'Electron Helper.app'), path.join(shellAppDir, 'Contents', 'Frameworks', 'Zenit Helper.app')
      fs.renameSync path.join(shellAppDir, 'Contents', 'Frameworks', 'Zenit Helper.app', 'Contents', 'MacOS', 'Electron Helper'), path.join(shellAppDir, 'Contents', 'Frameworks', 'Zenit Helper.app', 'Contents', 'MacOS', 'Zenit Helper')
    else
      cp 'electron', shellAppDir, filter: /default_app/

      if process.platform is 'win32'
        fs.renameSync path.join(shellAppDir, 'electron.exe'), path.join(shellAppDir, 'zenit.exe')
      else
        fs.renameSync path.join(shellAppDir, 'electron'), path.join(shellAppDir, 'zenit')

    mkdir appDir

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
      path.join('build', 'binding.Makefile')
      path.join('build', 'config.gypi')
      path.join('build', 'gyp-mac-tool')
      path.join('build', 'Makefile')
      path.join('build', 'Release', 'obj.target')
      path.join('build', 'Release', 'obj')
      path.join('build', 'Release', '.deps')
      path.join('vendor', 'apm')
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

    cp 'src', path.join(appDir, 'src'), filter: /.+\.(cson|coffee)$/
    cp 'static', path.join(appDir, 'static')

    cp path.join('apm', 'node_modules', 'atom-package-manager'), path.resolve(appDir, '..', 'new-app', 'apm'), filter: filterNodeModule
    if process.platform isnt 'win32'
      fs.symlinkSync(path.join('..', '..', 'bin', 'apm'), path.resolve(appDir, '..', 'new-app', 'apm', 'node_modules', '.bin', 'apm'))

    dependencies = ['compile']
    grunt.task.run(dependencies...)
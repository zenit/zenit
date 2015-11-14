path = require 'path'

module.exports = (grunt) ->
  grunt.registerTask 'set-exe-icon', 'Set icon of the exe', ->
    done = @async()

    shellAppDir = grunt.config.get('zenit.shellAppDir')
    shellExePath = path.join(shellAppDir, 'zenit.exe')
    iconPath = path.resolve('resources', 'app-icons', 'zenit.ico')

    rcedit = require('rcedit')
    rcedit(shellExePath, {'icon': iconPath}, done)
ZenitEnvironment = require './zenit-environment'
ApplicationDelegate = require './application-delegate'

window.zenit = new ZenitEnvironment({
  window, document,
  applicationDelegate: new ApplicationDelegate,
  configDirPath: process.env.ZENIT_HOME
})

zenit.displayWindow()
zenit.startWindow()
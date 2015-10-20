ZenitEnvironment = require './zenit-environment'

window.zenit = new ZenitEnvironment({
  window, document,
  configDirPath: process.env.ZENIT_HOME
})

zenit.displayWindow()
zenit.startWindow()
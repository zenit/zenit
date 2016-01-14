(() => {
  const package = require('./package.json');
  const ipc = require('electron').ipcRenderer;

  window.onload = function() {
    document.body.classList.add(process.platform);
  }
  
  function init() {
    process.app = package;

    ipc.on('blur', function() {
      document.body.classList.add('blur');
    });

    ipc.on('focus', function() {
      document.body.classList.remove('blur');
    });
  }

  init();
})();
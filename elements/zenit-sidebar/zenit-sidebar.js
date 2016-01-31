(() => {
  Polymer({
    is: 'zenit-sidebar',

    _openCreateDatabaseDialog() {
      document.querySelector('zenit-dialogs').open('create-database');
    },

    _handleDatabasePrompt() {
      // TODO: Implement new database prompt
    },

    _handleResize() {
      // TODO: Implement resize
    }
  });
})();

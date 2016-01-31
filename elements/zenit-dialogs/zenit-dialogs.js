'use strict';

(() => {
  Polymer({
    is: 'zenit-dialogs',

    open(id) {
      var dialog = this.$[id];

      if (dialog) {
        dialog.open();
      }
    }
  });
})();

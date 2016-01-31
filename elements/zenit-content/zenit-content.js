'use strict';

(() => {
  Polymer({
    is: 'zenit-content',

    properties: {
      _filteredElements: Array
    },

    ready() {
      this._filteredElements = [
        {name: 'users', description: 'lel'},
        {name: 'shop_items', description: 'lel'},
        {name: 'items_data', description: 'lel'},
      ];
    },

    _openInfoDialog() {
      document.querySelector('zenit-dialogs').open('info');
    }
  });
})();

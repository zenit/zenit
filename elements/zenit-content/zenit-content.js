(() => {
  Polymer({
    is: 'zenit-content',

    properties: {
      _filteredElements: Array
    },

    ready() {
      this._filteredElements = [
        {name: 'id', description: 'lel'},
        {name: 'username', description: 'lel'}
      ];
    }
  });
})();

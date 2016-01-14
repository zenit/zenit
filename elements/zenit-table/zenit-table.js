(() => {
  Polymer({
    is: 'zenit-table',

    properties: {
      elements: {
        type: Array,
        observer: '_elementsChanged'
      },
      narrowViewport: {
        type: Boolean,
        reflectToAttribute: true
      }
    },

    listeners: {
      'tap': '_tap',
      'mouseover': '_mouseOver',
      'mouseleave': '_mouseLeave'
    },

    _currentRowIndex: -1,
    _sharedActionMenu: null,

    _findAncestor(node, fn) {
      while (node && fn.call(this, node)) {
        node = node.parentNode;
      }
      return node;
    },

    _tap(e) {
      var sourceEvent = e.detail.sourceEvent;
      var A = this._findAncestor(e.target, function(node) {
        return node !== this && node.tagName !== 'A';
      });

      if (A && A.tagName === 'A' && A.href.indexOf(location.host) > 0) {
        if (sourceEvent.ctrlKey || sourceEvent.metaKey) {
          window.open(A.href);
        } else {
          this.fire('nav', {url: A.href});
        }
        e.preventDefault();
      }
    },

    _mouseOver(e) {
      var row = this._findAncestor(e.target, function(node) {
        return node !== this && !node.classList.contains('row') && node.id !== 'actions';
      });
      if (row && row.classList.contains('row')) {
        if (this._currentRowIndex !== row.dataset.index) {
          this._hideActions();
          this._showActions(row, row.dataset.index);
        }
      } else if (row.id !== 'actions') {
        this._hideActions();
      }
    },

    _mouseLeave() {
      this._hideActions();
    },

    _showActions(row, index) {
      var sharedActionMenu = this._sharedActionMenu;
      var rowOffsetTop = row.offsetTop;
      if (!sharedActionMenu) {
        this._sharedActionMenu = document.createElement('element-action-menu');
        this._sharedActionMenu.classList.add('hidden');
        Polymer.dom(this.$.actions).appendChild(this._sharedActionMenu);
        sharedActionMenu = this._sharedActionMenu;
      }
      sharedActionMenu.iconsOnly = true;
      sharedActionMenu.element = this.elements[index].name;
      sharedActionMenu.style.top = rowOffsetTop + 'px';
      this._layoutIfNeeded(sharedActionMenu);
      sharedActionMenu.classList.remove('hidden');
      row.classList.add('hover');
      this._currentRowIndex = index;
      this._currentRow = row;
    },

    _hideActions() {
      var row = this._currentRow;
      var sharedActionMenu = this._sharedActionMenu;
      if (row) {
        if (sharedActionMenu) {
          sharedActionMenu.classList.add('hidden');
        }
        row.classList.remove('hover');
        this._currentRowIndex = -1;
        this._currentRow = null;
      }
    },

    _elementLink(name) {
      return '/elements/' + name;
    },

    _elementsChanged() {
      this.classList.add('hidden');
      this.async(function() {
        this.classList.remove('hidden');
      }, 1);
    },
    
    _layoutIfNeeded(el) {
      return el.offsetTop;
    }
  });
})();

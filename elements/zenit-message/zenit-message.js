(() => {
  Polymer({
    is: 'zenit-message',

    properties: {
      icon: {
        type: String,
        value: 'warning'
      },
      title: {
        type: String,
        value: process.app.productName
      },
      text: String
    }
  });
})();

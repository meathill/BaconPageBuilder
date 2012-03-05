jQuery.namespace('com.meathill.bacon');
com.meathill.bacon.Elements = Backbone.View.extend({
  buttons: null,
  page: null,
  events: {
    "click .add-navi-button": "addNaviButton_clickHandler",
    "click .add-row-button": "addRowButton_clickHandler",
  },
  initialize: function () {
    this.buttons = $('#' + this.options.buttons);
    this.setPage(this.options.page);
    this.setElement($('#' + this.options.list));
    this.render();
  },
  render: function () {
    // ÍÏ¶¯
    this.$el
      .tabs()
      .find('img')
        .draggable({
          opacity: 0.7,
          appendTo: "body",
          helper: 'clone',
          cursor: 'move',
          connectToSortable: '#page-container dd'
        });
    this.buttons.find(".add-row-button").button();
    this.buttons.find(".add-navi-button").button();
  },
  setPage: function (page) {
    this.page = page;
    this.page.on(this.page.ADD_ITEM, this.refreshDraggable, this);
  },
  refreshDraggable: function () {
    this.$el.find('img')
      .draggable("option", "connectToSortable", '#page-container dd');
  },
  addNaviButton_clickHandler: function (event) {
    this.page.createNavi();
  },
  addRowButton_clickHandler: function (event) {
    var colsNum = $(event.currentTarget).attr('class').match(/column-(\d)/)[1];
    var isTitled = $(event.currentTarget).hasClass('no-title') ? ' no-title' : '';
    this.page.createNewRow(colsNum, isTitled);
  },
});

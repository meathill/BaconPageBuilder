jQuery.namespace('com.meathill.bacon');
com.meathill.bacon.ElementsSource = Backbone.View.extend({
  buttons: null,
  page: null,
  events: {
    "click .add-navi-button": "addNaviButton_clickHandler",
    "click .add-row-button": "addRowButton_clickHandler"
  },
  initialize: function () {
    this.setPage(this.options.page);
    this.setElement($('#' + this.options.list).add('#' + this.options.buttons));
    this.render();
  },
  render: function () {
    // ÍÏ¶¯
    this.$el.last()
      .tabs()
      .find('img')
        .draggable({
          opacity: 0.7,
          appendTo: "body",
          helper: 'clone',
          cursor: 'move'
        });
    this.$el.find(".add-row-button").button();
    this.$el.find(".add-navi-button").button();
  },
  setPage: function (page) {
    this.page = page;
    this.page.on(this.page.ADD_ROW, this.refreshDraggable, this);
  },
  refreshDraggable: function () {
    this.$el.find('img')
      .each(function (index) {
        $(this).draggable("option", "connectToSortable", '#page-container .' + $(this).attr('class').match(/column-\d/) + ' dd');
      });
  },
  addNaviButton_clickHandler: function (event) {
    this.page.createNavi();
  },
  addRowButton_clickHandler: function (event) {
    var colsNum = $(event.currentTarget).attr('class').match(/column-(\d)/)[1];
    var isTitled = $(event.currentTarget).hasClass('no-title') ? 'no-title' : '';
    this.page.createNewRow(colsNum, isTitled);
  }
});

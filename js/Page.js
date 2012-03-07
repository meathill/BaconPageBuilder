/**
 * Ò³ÃæÀà
 * @author Meathill
 * @version 0.1(2011-12-17)
 */
jQuery.namespace('com.meathill.bacon');
com.meathill.bacon.Page = Backbone.View.extend({
  ADD_ROW: 'addRow',
  ADD_ITEM: 'addItem',
  header: null,
  navi: null,
  initialize: function () {
    this.setElement($('#' + this.attributes.id));
    this.header = new com.meathill.bacon.BannerMaker();
  },
  createNavi: function () {
    if (this.navi == null) {
      this.navi = new com.meathill.bacon.Navi({editor: com.meathill.bacon.linkEditor});
      this.navi.addChild('Ê×Ò³');
      this.navi.$el.insertAfter(this.header.el);
    }
  },
  createNewRow: function (colsNum, isTitled) {
    colsNum = colsNum || 1;
    var row = new com.meathill.bacon.RowItem({
      colsNum: colsNum,
      isTitled: isTitled
    });
    this.$el.append(row.el);
    row.$el.find('dd').sortable({
      placeholder: "ui-state-highlight",
      connectWith: "#" + this.attributes.id + " .column-" + colsNum + " dd"
    }).disableSelection();
    this.trigger(this.ADD_ROW);
  },
});

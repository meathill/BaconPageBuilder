/**
 * “≥√Ê¿‡
 * @author Meathill
 * @version 0.1(2011-12-17)
 */
jQuery.namespace('com.meathill.bacon');
com.meathill.bacon.Page = Backbone.View.extend({
  initialize: function (option) {
    this.setElement(option.body);
  },
  createNewRow: function (colsNum, isTitled) {
    colsNum = colsNum || 1;
    var row = new com.meathill.bacon.RowItem(colsNum, isTitled);
    this.$el.append(row);
  },
  clearAll: function (bl) {
    this.$el.find('img').unbind('click', start);
    this.$el.find('div').remove();
  }
});

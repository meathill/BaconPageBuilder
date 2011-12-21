/**
 * 页面类
 * @author Meathill
 * @version 0.1(2011-12-17)
 */
jQuery.namespace('com.meathill.bacon');
com.meathill.pork.Page = function (target) {
  /**
   * Variables
   */
  var body = null;
  var self = this;
  /**
   * 构造函数
   * @constructor
   */
  body = $(target);
  /**
   * Properties
   */
  /**
   * Public Methods
   */
  this.createNewRow = function (event) {
    var row = new com.meathill.bacon.RowItem();
    row.appendTo(body);
    row.body.bind(row.MOVE_UP, self.moveItem);
    row.body.bind(row.MOVE_DOWN, self.moveItem);
  }
  this.clearAll = function (bl) {
    body.find('img').unbind('click', start);
    body.find('div').remove();
  }
  this.moveItem = function (event) {
    var row = $(event.target);
    if (event.type == 'moveUp') {
      row.insertBefore(row.prev());
    } else if (event.type == 'moveDown') {
      row.insertAfter(row.next());
    }
  }
}

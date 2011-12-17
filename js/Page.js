/**
 * 页面类
 * @author Meathill
 * @version 0.1(2011-12-17)
 */
jQuery.namespace('com.meathill.pork');
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
  this.items = [];
  /**
   * Public Methods
   */
  this.createNewRow = function (event) {
    var row = new RowItem();
    row.appendTo(body);
    self.items.push(row);
  }
  this.clearAll = function (bl) {
    body.find('img').unbind('click', start);
    body.find('div').remove();
  }
}

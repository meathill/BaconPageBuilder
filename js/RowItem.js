jQuery.namespace('com.meathill.bacon');
com.meathill.bacon.RowItem = function (colsNum) {
  /**
   * Public Methods
   */
  this.appendTo = function (parent) {
    $(parent).append(this.body);
  }
  /**
   * 编辑通栏标题
   * @param {Object} event
   * @private
   */
  this.editTitle = function (event) {
    var dt = $(this).parent();
    var input = $('<input>', {
      val: $(this).text(),
      'title': self.saveText,
      'class': self.inputClass,
      click: function (event) {
        event.stopPropagation();
      },
      focusout: self.submitTitle,
      keydown: self.submitTitle
    });
    $(this).remove()
    dt.append(input);
    input.focus();
  }
  /**
   * 保存编辑的标题
   * @param {Object} event
   * @private
   */
  this.submitTitle = function (event) {
    if (event.type == 'focusout' || (event.type == 'keydown' && event.which == 13)){
      var dt = $(this).parent();
      var input = $(this).remove();
      var h3 = $('<h3>', {
        text: input.val(),
        click: self.editTitle
      })
      dt.append(h3)
        .attr('title', self.editText);
    }
  }
  this.moveUp = function (event) {
    self.body.trigger(self.MOVE_UP);
  }
  this.moveDown = function (event) {
    self.body.trigger(self.MOVE_DOWN);
  }
  /**
 * 删除通栏
 * @param {Object} event
 */ 
  this.remove = function (event) {
    self.body.remove();
  }
  /**
   * Private Functions
   */
  function createBody(colsNum){
    var result = $('<div>', {
      'class' : 'rows column-' + colsNum
    });
    for (var i = 0; i < colsNum ; i++) {
      result.append(createDL());
    }
    if (colsNum > 1) {
      result.find('dl').last().addClass('last-column');
    }
    return result;
  }
  function createDL() {
    var h3 = $('<h3>', {
      text: self.defaultTitle,
      click: self.editTitle
    });
    var result = $('<dl>', {
      'class': self.itemClass
    })
      .append($('<dt>', {
          'title': self.editText
        }).append(h3))
      .append($('<dd>', {
        text: '&nbsp;'
      }));
    return result;
  }
  function createButtons(container) {
    var upButton = $('<button>', {
      'class': 'operationButtons v1',
      'click': self.moveUp,
      'title': '将整个通栏上移',
      val: '上移'
    }).button({
      icons: {
        primary: "ui-icon-arrowthick-1-n"
      },
      text: false
    });
    var downButton = $('<button>', {
      'class': 'operationButtons v3',
      'click': self.moveDown,
      'title': '将整个通栏下移',
      val: '下移'
    }).button({
      icons: {
        primary: "ui-icon-arrowthick-1-s"
      },
      text: false
    });
    var removeButton = $('<button>', {
      'class': 'operationButtons v2',
      'click': self.remove,
      'title': '删除通栏',
      val: '删除'
    }).button({
      icons: {
        primary: "ui-icon-close"
      },
      text: false
    });
    container
      .append(upButton)
      .append(downButton)
      .append(removeButton);
  }
  /**
   * 构造函数部分
   */
  var self = this;
  var index = 0;
  colsNum = colsNum == undefined ? 1 : colsNum;
  this.body = createBody(colsNum);
  createButtons(this.body);
}
RowItem.prototype.editText = '点击编辑标题';
RowItem.prototype.saveText = '回车或单击空白处确认修改';
RowItem.prototype.itemClass = 'row-item';
RowItem.prototype.inputClass = 'row-title';
RowItem.prototype.defaultTitle = '标题';
RowItem.prototype.MOVE_UP = 'moveUp';
RowItem.prototype.MOVE_DOWN = 'moveDown';

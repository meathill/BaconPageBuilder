/***************************************
 *  横通类
 * @author Meathill
 * @version 0.1(2011-12-22)
 * ************************************/
jQuery.namespace('com.meathill.bacon');
com.meathill.bacon.RowItem = function (colsNum, isTitled) {
  /**
   * 添加通栏到页面
   */
  this.appendTo = function (parent) {
    $(parent).append(body);
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
  /**
   * 上移通栏
   * @param {Object} event
   * @private
   */
  this.moveUp = function (event) {
    body.insertBefore(body.prev());
  }
  /**
   * 下移通栏
   * @param {Object} event
   * @private
   */
  this.moveDown = function (event) {
    body.insertAfter(body.next());
  }
  /**
 * 删除通栏
 * @param {Object} event
 * @private
 */ 
  this.remove = function (event) {
    body.remove();
  }
  /**
   * 创建dom
   * @param {Number} colsNum
   * @private
   */
  function createBody(colsNum, isTitled){
    isTitled = isTitled || '';
    var result = $('<div>', {
      'class' : 'rows' + isTitled
    });
    for (var i = 0; i < colsNum ; i++) {
      result.append(createDL(colsNum));
    }
    if (colsNum > 1) {
      result.find('dl').last().addClass('last-column');
    }
    return result;
  }
  /**
   * 创建dl，dl是基础结构
   * @private
   */
  function createDL(colsNum) {
    var h3 = $('<h3>', {
      text: self.defaultTitle,
      click: self.editTitle
    });
    var result = $('<dl>', {
      'class': self.itemClass + ' column-' + colsNum
    })
      .append($('<dt>', {
          'title': self.editText
        }).append(h3))
      .append($('<dd>', {
        text: self.dragHere
      }));
    return result;
  }
  /**
   * 创建功能按钮
   * @param {jQuery Object} container
   * @private
   */
  function createButtons(container) {
    var upButton = $('<button>', {
      'class': 'operationButtons up',
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
      'class': 'operationButtons down',
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
      'class': 'operationButtons remove',
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
   * 初始化放置图片的功能
   * @param {jQuery Object} body
   * @private
   */
  function initDroppable(body) {
    body.find('dd').droppable({
      scope: "element",
      hoverClass: "row-drag-hover",
      drop: function (event, ui) {
        var item = ui.draggable.clone()
                    .removeClass('ui-draggable')
                    .addClass('elementItem');
        if ($(this).html() == self.dragHere) {
          $(this).html('');
        }
        $(this).append(item);
        $('#pageContainer dd').sortable({
          placeholder: "placeholder",
          connectWith: "#pageContainer dd"
        }).disableSelection();
      }
    })
  }
  /**
   * 构造函数部分
   */
  var self = this;
  var index = 0;
  colsNum = colsNum == undefined ? 1 : colsNum;
  var body = createBody(colsNum, isTitled);
  createButtons(body);
  initDroppable(body);
}
com.meathill.bacon.RowItem.prototype.editText = '点击编辑标题';
com.meathill.bacon.RowItem.prototype.saveText = '回车或单击空白处确认修改';
com.meathill.bacon.RowItem.prototype.dragHere = '请将右侧的模块拖放至此';
com.meathill.bacon.RowItem.prototype.itemClass = 'row-item';
com.meathill.bacon.RowItem.prototype.inputClass = 'row-title';
com.meathill.bacon.RowItem.prototype.defaultTitle = '标题';

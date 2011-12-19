function addRow(evt ,_type) {
  if (evt != null) {
    _type = Number($(this).attr('name'));
  }
  var _class = '';
  if (0 == _type){
    _class = 'z1';
  } else {
    _class = 'z'+_type;
  }
  var _row = $('<div></div>', {'class':'banners', 'type': _type}).appendTo("#mains");
  _row.addClass(_class);
  _row.html(_frame_arr[_type]);
  // 通栏的标题可以点击后编辑
  _row.find('dt').attr('title', '点击编辑标题');
  _row.find('dt').bind('click', editRowTitle);
  // 添加删除按钮
  $('<div></div>').prependTo(_row);
  _down_btn.clone(true).prependTo(_row);
  _up_btn.clone(true).prependTo(_row);
  _remove_btn.clone(true).prependTo(_row);
  return _row;
}
/**
 * 删除通栏
 * @param {Object} e
 */ 
function removeRow(evt){
  $(this).parent().remove();
  setAddressContent(false);
}
function moveRow(evt) {
  if($(this).attr('name') == 'up' && $(this).parent().prev('div').length > 0) {
    $(this).parent().insertBefore($(this).parent().prev('div'));
  } else if ($(this).attr('name') == 'down' && $(this).parent().next('div').length > 0) {
    $(this).parent().insertAfter($(this).parent().next('div'));
  }
  setAddressContent(false);
}

function RowItem(colsNum) {
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
    if (event.type == 'focusout' || (event.type == 'keydown' && event.keyCode == 13)){
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
   * Private Functions
   */
  function createBody(colsNum){
    var result;
    if (colsNum > 1) {
      result = $('<div>', {
        'class' : 'column-' + colsNum
      });
      for (var i = 0; i < colsNum ; i++) {
        result.append(createDL());
      }
      result.find('dl').last().addClass('last-column');
    } else {
      result = createDL();
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
  /**
   * 构造函数部分
   */
  var self = this;
  var index = 0;
  colsNum = colsNum == undefined ? 1 : colsNum;
  this.body = createBody(colsNum);
}
RowItem.prototype.editText = '点击编辑标题';
RowItem.prototype.saveText = '回车或单击空白处确认修改';
RowItem.prototype.itemClass = 'row-item';
RowItem.prototype.inputClass = 'row-title';
RowItem.prototype.defaultTitle = '标题';

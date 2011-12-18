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
    var input = $('<input>', {
      val: $(this).text(),
      'title': '回车或单击空白处确认修改',
      change : self.submitTitle,
      focusout: self.submitTitle
    });
    input.focus();
    $(this).html('').append(input);
  }
  /**
   * 保存编辑的标题
   * @param {Object} event
   * @private
   */
  this.submitTitle = function (event) {
    if (event.type == 'click' || event.type == 'focusout' || (evt.type == 'keydown' && evt.keyCode == 13)){
      var input, dt;
      if (event.target.tagName == 'dt') {
        dt = $(this);
        input = dt.find('input');
      } else {
        dt = $(this).parent();
        input = $(this);
      }
      dt.html(input.val())
        .attr('title', '点击编辑标题');
      input.remove();
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
    var result = $('<dl>', {
      'class' : 'row-item'
    }).append($('<dt>', {
      text: '标题'
      }).toggle(self.editTitle, self.submitTitle)
    ).append($('<dd>', {
      text: ' '
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

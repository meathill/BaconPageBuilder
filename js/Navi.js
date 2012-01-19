jQuery.namespace('com.meathill.bacon');
com.meathill.bacon.Navi = function (editable, css) {
  this.appendTo = function (parent) {
    $(parent).append(body);
  }
  this.addChild = function (label, link, target) {
    if (link) {
      var init = {"title": label, text: label, "href": link};
      if (target) {
        init.target = target;
      }
      var child = $('<li>').append($('<a>', init));
    } else {
      var child = $('<li>', {text: label});
    }
    if (editable) {
      child.insertBefore(addButton); 
      child.click(self.child_clickHandler);
    } else {
      body.append(child)
    }
    var nextLevel = new com.meathill.bacon.Navi(editable, self.subClass);
    if (body.hasClass(self.subClass)) {
      nextLevel.moveTo(child.width(), 0);
    }
    nextLevel.appendTo(child);
    items.push(nextLevel);
  }
  this.getChildAt = function (index) {
    return items[index];
  }
  this.removeChildAt = function (index) {
    items.splice(index, 1);
  }
  this.moveTo = function (x, y) {
    body
      .css('left', x + 'px')
      .css('top', y + 'px');
  }
  this.child_clickHandler = function (event) {
    count = 0;
    var child = $(this).children().not('ul');
    var inputs = com.meathill.bacon.LinkEditorWindow.find('input');
    inputs.first().val(child.attr('href'));
    inputs.last().val(child.text());
    com.meathill.bacon.LinkEditorWindow
      .addClass('edit')
      .addClass('target' + $(this).parent().children().index($(this)))
      .submit(self.editor_submitHandler)
      .on('close', self.editor_closeHandler)
      .dialog({title: "编辑 " + child.text()})
      .dialog("open")
      .find('select').val(child.attr('target'));
    return false;
  }
  this.addButton_clickHandler = function (event) {
    count = 0;
    com.meathill.bacon.LinkEditorWindow
      .addClass('add')
      .submit(self.editor_submitHandler)
      .on('close', self.editor_closeHandler)
      .dialog({title: "添加新菜单项"})
      .dialog("open")
      .find('input, select').val('');
    event.stopPropagation();
  }
  this.editor_submitHandler = function (event) {
    var inputs = $(this).find('input');
    var label = inputs.last().val();
    var link = inputs.first().val();
    var target = $(this).find('select').val();
    if ($(this).hasClass('add')) {
      $(this).removeClass('add');
      self.addChild(label, link, target);
    } else {
      $(this).removeClass('edit');
      var classes = $(this).attr('class');
      var index = classes.match(/target(\d)/)[1];
      var target = body.children().eq(index);
      if (link) {
        var init = {"title": label, text: label, "href": link};
        if (target) {
          init.target = target;
        }
        var a = $('<a>', init);
        target.empty().append(a);
      } else {
        target.text(label);
      }
      $(this).removeClass('target' + index);
    }
    com.meathill.bacon.LinkEditorWindow.off();
  }
  this.editor_closeHandler = function (event) {
    com.meathill.bacon.LinkEditorWindow.off();
  }
  function createBody() {
    var init = {
      "class": self.mainClass
    }
    var result = $('<ul>', init);
    if (editable) {
      init = {
        "class": "add-button",
        html: "<span>add</span>",
        "title": "Add"
      }
      addButton = $('<li>', init);
      addButton
        .append($('<span>', {"class": "add-icon"}))
        .appendTo(result);
      $('.add-button', result).on("click", self.addButton_clickHandler);
    }
    return result;
  }
  var editable = editable;
  var addButton;
  var self = this;
  var items = [];
  var count = 0;
  this.mainClass = css || this.mainClass;
  var body = createBody();
}
com.meathill.bacon.Navi.prototype.mainClass = 'meat-navi';
com.meathill.bacon.Navi.prototype.subClass = 'sub-meat-navi';
com.meathill.bacon.LinkEditorWindow = $('<div>', {"class": "link-editor-window"})
  .append($('<label>', {"for": "link-editor-window-link", text: '链接'}))
  .append($('<input>', {"id": "link-editor-window-link"}))
  .append('<br>')
  .append($('<label>', {"for": "link-editor-window-title", text: '标题'}))
  .append($('<input>', {"id": "link-editor-window-title"}))
  .append('<br>')
  .append($('<label>', {"for": "link-editor-window-type", text: '打开方式'}))
  .append(
    $('<select>', {"id": 'link-editor-window-type'})
      .append($('<option>', {val: "", text: "（空）"}))
      .append($('<option>', {val: "_blank", text: "_blank"}))
      .append($('<option>', {val: "_self", text: "_self"}))
      .append($('<option>', {val: "_top", text: "_top"})));
// statrup
$(function () {
  com.meathill.bacon.LinkEditorWindow.dialog({
    autoOpen: false,
    modal: true,
    resizable: false,
    buttons: {
      "确定": function () {
        $(this).dialog("close");
        $(this).submit();
      },
      "取消": function () {
        $(this).dialog("close");
        $(this).trigger('close');
      }
    }
  });
});      
  

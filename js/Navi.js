jQuery.namespace('com.meathill.bacon');
com.meathill.bacon.Navi = function (editable, css) {
  this.appendTo = function (parent) {
    $(parent).append(body);
  }
  this.addChild = function (name) {
    var child = $('<li>', {text: name});
    if (editable) {
      child.insertBefore(addButton); 
    } else {
      body.append(child)
    }
    var nextLevel = new com.meathill.bacon.Navi(editable, self.subClass);
    nextLevel.appendTo(child);
    items.push(nextLevel);
  }
  this.getChildAt = function (index) {
    return items[index];
  }
  this.removeChildAt = function (index) {
    items.splice(index, 1);
  }
  this.addButton_clickHandler = function (event) {
    com.meathill.bacon.LinkEditorWindow.dialog("open");
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
  this.mainClass = css || this.mainClass;
  var body = createBody();
}
com.meathill.bacon.Navi.prototype.mainClass = 'meat-navi';
com.meathill.bacon.Navi.prototype.subClass = 'sub-meat-navi';
com.meathill.bacon.LinkEditorWindow = $('<div>')
  .append($('<label>', {"for": "link-editor-window-link", text: '链接'}))
  .append($('<input>', {"id": "link-editor-window-link"}))
  .append($('<label>', {"for": "link-editor-window-title", text: '标题'}))
  .append($('<input>', {"id": "link-editor-window-title"}))
  .append($('<label>', {"for": "link-editor-window-type", text: '打开方式'}))
  .append(
    $('<select>', {"id": 'link-editor-window-type'})
      .append($('<option>', {val: "_blank", text: "_blank"}))
      .append($('<option>', {val: "_self", text: "_self"}))
      .append($('<option>', {val: "_top", text: "_top"}))
  );

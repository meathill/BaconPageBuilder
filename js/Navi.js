jQuery.namespace('com.meathill.bacon');
com.meathill.bacon.Navi = function (editable) {
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
  }
  this.addButton_clickHandler = function (event) {
    
  }
  function createBody() {
    var init = {
      "class": self.containerClass
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
  var body = createBody();
  body.find
}
com.meathill.bacon.Navi.prototype.containerClass = 'meat-navi';

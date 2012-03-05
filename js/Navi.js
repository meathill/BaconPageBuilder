jQuery.namespace('com.meathill.bacon');
com.meathill.bacon.Navi = Backbone.View.extend({
  tagName: "ul",
  className: 'navi',
  subClass: 'sub-navi',
  editable: false,
  editor: null,
  addItemButton: null,
  items: [],
  events: {
    "click .add-item-button": "addButton_clickHandler",
    "click li": "child_clickHandler"
  },
  initialize: function () {
    if (this.options != null) {
      this.editable = this.options.editor !== null;
      this.editor = this.options.editor;
      this.className = this.options.className || this.className;
    }
    this.render();
  },
  render: function () {
    this.make();
    if (this.editable) {
      this.addItemButton = this.createAddItemButton();
      this.$el.append(this.addItemButton);
    }
  },
  createAddItemButton: function () {
    var init = {
      "class": "add-item-button",
      html: "<span>add</span>",
      "title": "Add"
    }
    var button = $('<li>', init)
                   .append($('<span>', {"class": "add-icon"}));
    return button;
  },
  addChild: function (label, link, target) {
    var child;
    if (link) {
      var init = {"title": label, text: label, "href": link};
      if (target) {
        init.target = target;
      }
      child = $('<li>').append($('<a>', init));
    } else {
      child = $('<li>', {text: label});
    }
    if (this.editable) {
      child.insertBefore(this.addItemButton);
      var nextLevel = new com.meathill.bacon.Navi({
        editable: this.editable,
        editor: this.editor,
        className: this.subClass
      });
      if (this.$el.hasClass(self.subClass)) {
        nextLevel.moveTo(child.width(), 0);
      }
      nextLevel.$el.appendTo(child);
    } else {
      this.$el.append(child)
    }
    this.items.push(child);
  },
  getChildAt: function (index) {
    return this.items[index];
  },
  removeChildAt: function (index) {
    this.$(this.items[index]).remove();
    this.items.splice(index, 1);
  },
  moveTo: function (x, y) {
    this.$el
      .css('left', x + 'px')
      .css('top', y + 'px');
  },
  child_clickHandler: function (event) {
    if (!this.editable) {
      return true;
    }
    this.editor.edit(event.currentTarget);
    this.editor.on('submit', this.editor_submitHandler, this);
    return false;
  },
  addButton_clickHandler: function (event) {
    this.editor.newItem();
    this.editor.on('submit', this.editor_submitHandler, this);
    event.stopImmediatePropagation();
  },
  editor_submitHandler: function (target) {
    this.editor.off();
    if (target === null) {
      this.addChild(this.editor.model.get('title'), this.editor.model.get('link'), this.editor.model.get('target'));
    } else {
      var subMenu = target.find('ul').remove();
      if (this.editor.model.get('link') !== '') {
        if (target.find('a').length > 0) {
          target.find('a').attr('href', this.editor.model.get('link'));
        } else {
          target.html('<a href="' + this.editor.model.get('link') + '"></a>');
        }
        if (this.editor.model.get('target') != '') {
          target.find('a').attr('target', this.editor.model.get('target'));
        }
        target.find('a').text(this.editor.model.get('title'));
      } else {
        target.text(this.editor.model.get('title'));
      }
      target.append(subMenu);
    }
  },
});
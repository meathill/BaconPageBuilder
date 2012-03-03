jQuery.namespace('com.meathill.bacon');
com.meathill.bacon.LinkEditorWindow = Backbone.View.extend({
  target: null,
  events: {
    'change input,select': 'onChange',
    'submit div': 'onSubmit'
  },
  initialize: function () {
    var self = this;
    this.model = new Backbone.Model({
      link: '',
      title: '',
      target: ''
    });
    this.render();
    _.extend(this.el, Backbone.Events);
    this.el.on('submit', this.onSubmit, this);
    $(function () {
      self.addToStage();
    });
  },
  render: function () {
    var content = $('<div>', {"class": "link-editor-window"})
      .append('\
        <label for="link-editor-window-title">标题</label>\
        <input id="link-editor-window-title" name="title" /><br>\
        <label for="link-editor-window-link">链接</label>\
        <input id="link-editor-window-link" name="link" /><br>\
        <label for="link-editor-window-type">打开方式</label>\
        <select id="link-editor-window-type" name="target">\
          <option value="">（空）</option>\
          <option value="_blank">_blank</option>\
          <option value="_self">_self</option>\
          <option value="_top">_top</option>\
        </select>');
    this.setElement(content);
  },
  addToStage: function () {
    this.$el.appendTo($('body'));
    this.$el.dialog({
      autoOpen: false,
      modal: true,
      resizable: false,
      buttons: {
        "确定": function () {
          $(this).dialog("close");
          this.trigger('submit');
        },
        "取消": function () {
          $(this).dialog("close");
        }
      }
    });
  },
  edit: function (target) {
    this.target = $(target);
    var currentNode = this.target.clone();
    currentNode.find('ul').remove();
    this.$el
      .dialog({title: "编辑 " + this.target.text()})
      .dialog("open")
      .find('#link-editor-window-title')
        .val(currentNode.text())
      .end()
      .find('#link-editor-window-link')
        .val(currentNode.find('a').attr('href'))
      .end()
      .find('select')
        .val(currentNode.find('a').attr('target'));
    this.model.set('title', currentNode.text());
    this.model.set('link', currentNode.find('a').attr('href'));
    this.model.set('target', currentNode.find('a').attr('target'));
  },
  newItem: function () {
    this.$el
      .dialog({title: "添加新菜单项"})
      .dialog("open")
      .find('input, select')
        .val('');
  },
  onChange: function (event) {
    this.model.set($(event.target).attr('name'), $(event.target).val());
  },
  onSubmit: function (event) {
    this.trigger('submit', this.target);
  }
});
com.meathill.bacon.linkEditor = new com.meathill.bacon.LinkEditorWindow();
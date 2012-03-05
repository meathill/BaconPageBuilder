jQuery.namespace('com.meathill.bacon');
jQuery.namespace('com.meathill.bacon.LangBundle');
com.meathill.bacon.LangBundle.LinkEditorWindow = {
  title: '标题',
  link: '链接',
  target: '打开方式',
  empty: '（空）',
  ok: '确定',
  cancel: '取消',
  edit: '编辑',
  add: '添加新菜单项'
}
com.meathill.bacon.LinkEditorWindow = Backbone.View.extend({
  target: null,
  langBundle: com.meathill.bacon.LangBundle.LinkEditorWindow,
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
        <label for="link-editor-window-title">' + this.langBundle.title + '</label>\
        <input id="link-editor-window-title" name="title" /><br>\
        <label for="link-editor-window-link">' + this.langBundle.link + '</label>\
        <input id="link-editor-window-link" name="link" /><br>\
        <label for="link-editor-window-type">' + this.langBundle.target + '</label>\
        <select id="link-editor-window-type" name="target">\
          <option value="">' + this.langBundle.empty + '</option>\
          <option value="_blank">_blank</option>\
          <option value="_self">_self</option>\
          <option value="_top">_top</option>\
        </select>');
    this.setElement(content);
  },
  addToStage: function () {
    this.$el.appendTo($('body'));
    var buttonHandler = {};
    buttonHandler[this.langBundle.ok] = function () {
      $(this).dialog("close");
      this.trigger('submit');
    }
    buttonHandler[this.langBundle.cancel] = function () {
      $(this).dialog("close");
    }
    this.$el.dialog({
      autoOpen: false,
      modal: true,
      resizable: false,
      buttons: buttonHandler
    });
  },
  edit: function (target) {
    this.target = $(target);
    var currentNode = this.target.clone();
    currentNode.find('ul').remove();
    this.$el
      .dialog({title: this.langBundle.edit + ' ' + this.target.text()})
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
      .dialog({title: this.langBundle.edit})
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
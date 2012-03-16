/**
 * 页面类
 * @author Meathill
 * @version 0.1(2011-12-17)
 */
jQuery.namespace('com.meathill.bacon');

com.meathill.bacon.ElementModel = Backbone.Model.extend({
  defaults: {
    'template': ''
  },
  url: function () {
    return this.urlRoot + this.get('template') + '.html'
  },
  urlRoot: 'element/',
  fetch: function () {
    $.ajax({
      url: this.url(),
      dataType: 'text',
      context: this,
      success: this.parse
    });
  },
  parse: function (response) {
    this.set('template', response);
  }
});

com.meathill.bacon.ElementsCollection = Backbone.Collection.extend({
  model: com.meathill.bacon.ElementModel
});

com.meathill.bacon.Element = Backbone.View.extend({
  initialize: function () {
    this.model.on('change', this.render, this);
    this.model.fetch();
  },
  render: function () {
    this.options.placeholder.replaceWith(String(this.model.get('template')));
    delete this.options.placeholder;
  }
});

com.meathill.bacon.Page = Backbone.View.extend({
  ADD_ROW: 'addRow',
  ADD_ITEM: 'addItem',
  header: null,
  navi: null,
  events: {
    "sortstop img": "sortStopHandler"
  },
  collection: new com.meathill.bacon.ElementsCollection(),
  initialize: function () {
    this.setElement($('#' + this.attributes.id));
    this.header = new com.meathill.bacon.BannerMaker();
  },
  createNavi: function () {
    if (this.navi == null) {
      this.navi = new com.meathill.bacon.Navi({editor: com.meathill.bacon.linkEditor});
      this.navi.addChild('首页', '#');
      this.navi.$el.insertAfter(this.header.el);
    }
  },
  createNewRow: function (colsNum, isTitled) {
    colsNum = colsNum || 1;
    var row = new com.meathill.bacon.RowItem({
      colsNum: colsNum,
      isTitled: isTitled
    });
    this.$el.append(row.el);
    row.$el.find('dd').sortable({
      placeholder: "ui-state-highlight",
      connectWith: "#" + this.attributes.id + " .column-" + colsNum + " dd"
    }).disableSelection();
    this.trigger(this.ADD_ROW);
  },
  sortStopHandler: function (event, ui) {
    var url = ui.item.attr('src');
    var model = new com.meathill.bacon.ElementModel({
      template: url.substring(url.lastIndexOf('/') + 1, url.lastIndexOf('.'))
    });
    var element = new com.meathill.bacon.Element({
      model: model,
      placeholder: ui.item
    });
    this.collection.add(model);
  }
});
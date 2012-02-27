/**
 * @fileOverview 所有关于样式的控制在此文件进行，所有对样式的改变都落实到对StyleModel的修改上，然后通过StyleModel的change方法广播到具体视图类去展现
 * @author Meathill
 * @version 0.2 (2012-02-2)
 * @@requires swfobject(v2.0)及以上
 */
jQuery.namespace('com.meathill.bacon');
/**
 * @description 样式控制器Model。模拟Mediator模式，在几个控制器之间同步样式，直接声明实例，算某种意义上的internal吧
 * @author Meathill
 * @event change
 */
com.meathill.bacon.StyleModel = Backbone.Model.extend({
  defaults: {
    "headPicUrl": '', // 大头图片url
    "saveURL": '',
    "styleIndex": -1,
    "domID": "banner-maker",
    "body": "header"
  }
});
var style = new com.meathill.bacon.StyleModel();

/**
 * @description 大头生成器，用于嵌入swf，并与其交互
 * @author Meathill
 */
com.meathill.bacon.BannerMaker = Backbone.View.extend({
  model: style,
  initialize: function () {
    this.setElement($('#' + this.model.get('body')));
    this.model.on('change:styleIndex', this.model_changeHandler, this);
  },
  install: function (so) {
    var param = {
      allowScriptAccess: 'always',
      wmode: 'window'
    };
    var flashvars = {
      
    };
    var width = 960;
    var height = 220;
    var src = "BannerProducer.swf";
    var express = "swf/expressInstall.swf";
    var version = '11';
    so.embedSWF(src, this.model.get('domID'), width, height, version, express, flashvars, param);
    this.setHeight(height);
  },
  setHeadPic: function (src) {
    this.model.set({'headPicUrl': url});
  },
  setHeight: function (height) {
    console.log('set height: ', height, this.$el);
    this.$el.height(height);
    this.$el.find('#' + this.model.get('domID')).height(height);
  },
  setStyle: function (index) {
    console.log('banner change css : ', this.model.get('styleIndex'), 'to', index);
    this.model.set({'styleIndex': index});
  },
  model_changeHandler: function (event) {
    console.log("banner handler :", event.attributes);
    this.getSelf().changeTemplate(event.attributes.styleIndex);
  },
  getSelf: function () {
    var movieName = this.model.get('domID');
    if ($.browser.msie) {
      return window[movieName];
    } else {
      return document[movieName];
    }
  }
});
/**
 * @description 样式缩略图列表
 * @author Meathil
 */
com.meathill.bacon.StyleThumbList = Backbone.View.extend({
  model: style,
  currentItem: null,
  cssLink: null,
  initialize: function () {
    this.setElement($('#css-list'));
    this.model.on('change:styleIndex', this.model_changeHandler, this);
  },
  events: {
    "click li": "clickHandler"
  },
  model_changeHandler: function (event) {
    console.log("thumb handler :", event.attributes);
    this.changeCss(event.attributes.styleIndex);
  },
  clickHandler: function (event) {
    var index = $(event.currentTarget).index() + 1;
    console.log('thumb change css : ', this.model.get('styleIndex'), 'to', index);
    this.changeCss(index);
    this.model.set({'styleIndex': index});
  },
  changeCss: function (index) {
    if (index == 0) {
      return;
    }
    if (this.currentItem != null && this.currentItem.index() == index - 1) {
      return;
    }
    this.currentItem = this.$el.find('li').eq(index - 1);
    var css = "css/" + this.currentItem.attr('class') + ".css";
    if (this.cssLink == null) {
      var init = {
        href : css,
        id : 'custom-style',
        rel : 'stylesheet'
      }
      this.cssLink = $('<link>', init);
      this.cssLink.appendTo($('head'));
    } else {
      this.cssLink.attr('href', css);
    }
    this.$el.find('.activated').removeClass('activated');
    this.currentItem.addClass('activated');
  }
});

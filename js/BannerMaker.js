/**
 * 大头生成器JS
 * @author Meathill
 * @version 0.1 (2011-11-18)
 */
jQuery.namespace('com.meathill.bacon');
com.meathill.bacon.BannerModel = Backbone.Model.extend({
  defaults: {
    "headPicUrl": '', // 大头图片url
    "callback": null,
    "saveURL": '',
    "styleIndex": -1,
    "domID": "banner-maker",
    "body": "header"
  }
});
com.meathill.bacon.BannerMaker = Backbone.View.extend({
  model: new com.meathill.bacon.BannerModel(),
  tagName: 'div',
  initialize: function () {
    
  },
  render: function () {
    
  },
  install: function () {
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
    swfobject.embedSWF(src, this.model.get('domID'), width, height, version, express, flashvars, param);
    this.setHeight(height);
  },
  setHeadPic: function (src) {
    this.model.set('headPicUrl', url);
    if (this.get('callback') != null) {
      this.get('callback')();
    }
  },
  setHeight: function (height) {
    this.$('#' + this.model.get('domID')).height(height);
    this.$('#' + this.model.get('body')).height(height);
  },
  setStyle: function (index) {
    this.model.set('styleIndex', index);
    console.log('change css to : ', index);
  }
});
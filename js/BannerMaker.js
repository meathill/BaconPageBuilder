/**
 * 大头生成器JS
 * @author Meathill
 * @version 0.1 (2011-11-18)
 */
jQuery.namespace('com.meathill.bacon');
com.meathill.bacon.BannerModel = Backbone.Model.extend({
  default: {
    "headPicUrl": '', // 大头图片url
    "callback": null,
    "saveURL": '',
    "styleIndex": -1,
    "domID": "banner-maker",
    "body": "header"
  }
});
com.meathill.bacon.BannerMaker = function () {
  var headPicUrl = ''; // 大头图片url
  var callback = null;
  var saveURL = '';
  var styleIndex = -1;
  var domID = "banner-maker";
  var body = "header";
  /**
   * @constructor
   */
  var self = this;
  /**
   * Public Methods 
   */
  this.install = function (so, domid) {
    domid = domid || domID;
    var param = {
      allowScriptAccess: 'always',
      wmode:'window'
    };
    var flashvars = {
      
    };
    var width = 960;
    var height = 220;
    var src = "BannerProducer.swf";
    var express = "swf/expressInstall.swf";
    var version = '11';
    so.embedSWF(src, domid, width, height, version, express, flashvars, param);
    $('#' + body).height(height);
  }
  /**
   * 将大头图片替换在页面代码内
   * @param {Object} id 大头图片id
   * @private
   */
  this.setHeadPic = function (url) {
    headPicUrl = url;
    if (this.callback != null) {
      callback();
    }
  }
  /**
   * 切换模板后改变大头尺寸
   * @param {Object} height
   * @private
   */
  this.setHeight = function (height){
    $('#' + domID).height(height);
    $('#' + body).height(height);
  }
  this.setStyle = function (index) {
    styleIndex = index;
    console.log('change css to : ', index);
  }
}
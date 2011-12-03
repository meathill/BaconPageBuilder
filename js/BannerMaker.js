/**
 * 大头生成器JS
 * @author Meathill
 * @version 0.1 (2011-11-18)
 */
var BannerMaker = {
  headPicUrl : '', // 大头
  callback : null,
  isChanged : false,
  saveURL : '',
  /**
   * 将大头图片替换在页面代码内
   * @param {Object} id 大头图片id
   */
  setHeadPic : function (url) {
    this.headPicUrl = url;
    if (this.callback != null) {
      callback();
    }
  },
  /**
   * 切换模板后改变大头尺寸
   * @param {Object} height
   */
  setBannerHeight : function (height){
    $('#bannerMaker').height(height);
  },
  setBannerChanged : function (bl) {
    this.isChanged = bl;
  },
  install : function () {
    var param = {
      allowScriptAccess: 'always',
      wmode:'window'
    };
    var flashvars = {};
    var width = 960;
    var height = 220;
    var src = "swf/bannerProducer.swf";
    var express = "swf/expressInstall.swf";
    var version = '11';
    swfobject.embedSWF(src, "bannerMaker", width, height, version, express, flashvars, param);
  }
}
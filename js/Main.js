$(function (evt) {
  var page = new com.meathill.bacon.Page({
    attributes: {
      id: 'page-container'
    }
  });
  GUI= new com.meathill.bacon.GUI({
    page: page
  });
  GUI.page.header.install(swfobject);
});
var GUI;
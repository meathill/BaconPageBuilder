$(function (evt) {
  BannerMaker.install();
  Page.init('#pageContainer');
  GUI.init();
  // 调用方法构建模板
  GUI.addressChangeHandler();
  SWFAddress.addEventListener(SWFAddressEvent.CHANGE, GUI.addressChangeHandler);
});
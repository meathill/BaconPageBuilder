$(function (evt) {
  BannerMaker.install();
  GUI.init();
  // 调用方法构建模板
  GUI.addressChangeHandler();
  SWFAddress.addEventListener(SWFAddressEvent.CHANGE, GUI.addressChangeHandler);
});
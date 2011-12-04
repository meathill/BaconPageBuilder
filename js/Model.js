var model = {
  setTemplateName : function (name) {
    $('#templateName').val(name);
  },
  refreshHTML : function () {
    if (_title_txt.parent().length > 0 && _title_txt.parent().attr('id') != 'timg') {
      _title_txt.parent().click();
    }
    var str =$("#templateContainer").html().toLowerCase();
    // 移除input标签和空白div，还有多余的编辑标题
    str = str.replace(/<input[^>]*>/gim,"");
    str = str.replace(/<div[^>]*><\/div>/gim,'');
    str = str.replace(/\stitle=([^\s|^>]+)/gim, '');
    var mts = str.match(/<img.*?>/gim);
    for(var i=0;i<mts.length;i++){str=str.replace(mts[i],divs[mts[i].match(/.*\/(.*?).[gif|jpg]/)[1]]);}
    str = str.replace('<!-- link css -->','<link href="http://icon.zol.com.cn/article/templateDIY/css/' + $('#cssSelector').val() + '.css" type="text/css" rel="stylesheet" />');;
    str += '</div><!--页尾 end--><norunscript>topicDIY.init();</norunscript></body></html>';
    // 是否使用模板大头
    if (BannerMaker.headPic != '') {
      str = str.replace('http://icon.zol.com.cn/article/templateDIY/images/head.jpg', BannerMaker.headPic);
    }
    $("#texts").val(str);
  },
  submit : function () {
    this.refreshHTML();
    $('#htmlCodeForm').submit();
  }
}

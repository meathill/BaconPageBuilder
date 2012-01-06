var _is_refill = false;
/*****************************************
 * 这个直接实例化的东西控制所有面板上的操作
 * 因为和页面耦合度极高，所以就不单独写成类了
 * 当成开始就有的东西，其它需要全局使用的东西也从这个对象里面取
 * 
 * @author Meathill
 * @version 0.2(2011-12-27)
 ****************************************/
var GUI = {
  token : null,
  banner : null,
  page : null,
  init : function () {
    // 显示所有内容
    $('#preloader').remove();
    $('.hidden').fadeIn();
    this.token = $('#token').remove();
    
    // 按钮事件绑定
    $('#togglePanelButton')
      .button({
        icons: {
          primary: "ui-icon-circle-triangle-e"
        },
        text: false
      })
      .click(this.togglePanel);
    $("#submitButton")
      .button()
      .click(this.uploadTemplate);
    $(".addRowBtn").click(this.insertRow);
    $('#configButton').button({
      icons: {
        primary: 'ui-icon-wrench'
      },
      text: false
    });
    $('#helpButton').button({
      icons: {
        primary: 'ui-icon-help'
      },
      text: false
    })
    
    // 拖动
    $("#modules")
      .tabs()
      .find('img')
        .draggable({
          opacity: 0.7,
          helper: 'clone',
          scope: 'element'
        });
        
    // 样式切换
    $('#cssSelector').change(this.changeCss);
    // 模版名称
    $('#templateName').change(function() {
      Model.setTemplateName($(this).val())
    });
    
    // 调整功能面板大小
    this.onResize();
    $(window).resize(this.onResize);
  },
  togglePanel : function (event) {
    var icon = $(this).children().first();
    if ($('#sidebar').hasClass('outside')) {
      $('#sidebar').animate({"right": 0}, 600, function () {
        $(this).removeClass('outside')
      });
      icon
        .removeClass('ui-icon-circle-triangle-w')
        .addClass('ui-icon-circle-triangle-e');
    } else {
      $('#sidebar').animate({"right": -20 - $('#sidebar').width()}, 600, function () {
        $(this).addClass('outside');
      });
      icon
        .removeClass('ui-icon-circle-triangle-e')
        .addClass('ui-icon-circle-triangle-w');
    }
  },
  insertRow : function (event) {
    var colsNum = $(this).attr('class').match(/column-(\d)/)[1];
    var isTitled = $(this).hasClass('no-title') ? ' no-title' : '';
    console.log(isTitled);
    GUI.page.createNewRow(colsNum, isTitled);
  },
  //更新输入框 
  uploadTemplate : function (){
    $('#submitButton').prop('disabled', true);
    if (BannerMaker.isChanged) {
      if (window.confirm('您在大头生成器里进行的操作还未保存，现在提交模板的话那些操作不会生效，确定么？')) {
        Model.submit();
      } else{
        alert('请点击大头生成器中的“保存”按钮，保存大头，然后再点“上传模板”');
      }
    } else {
      Model.submit();
    }
  },
  log : function (str, isReset){
    if (isReset) {
      $('#output').html(str);
    } else {
      $('#output').append(str); 
    }
  },
  changeCss : function (evt, isSetURL){
    isSetURL = isSetURL == undefined ? true : isSetURL;
    var css = "css/" + $('#cssSelector').val() + ".css";
    if ($('#customStyle').length > 0) {
      $('#customStyle').attr('href', css);
    } else {
      var init = {
        href : css,
        id : 'customStyle',
        rel : 'stylesheet'
      }
      $('<link>', init).appendTo($('head'));
    }
    if (isSetURL) {
      GUI.setAddressContent(false);
    }
  },
  onResize : function (evt) {
    var screenHeight = $(window).height();
    $('.moduleThumbs').height(screenHeight - 286);
    $('#cover').height(screenHeight - 20);
  },
  /**
   * 设置地址栏
   * 只保留有内容的通栏
   */
  setAddressContent : function (bl) {
    var _result = '/' + $('#cssSelector').val() + '/';
    var _is_cols = false;
    bl = bl == undefined ? true : bl;
    $("#refreshHTML div").each(function(i) {
      if ($(this).find('img').length > 0) {
        _result += $(this).attr('type') + '-';
        if ($(this).children('dl').length > 1) {
          _is_cols = true;
        }
        $(this).find('img').each(function(j){
          var _src = $(this).attr('src');
          var _at = '';
          if (_is_cols) {
            // 取左边还是右边
            _at = '@' + $('#refreshHTML div:eq(' + i + ') dd').index($(this).parent());
          }
          _result += _src.substr(_src.lastIndexOf('/') + 1) + _at + ',';
        });
        _result = _result.slice(0, -1);
        _result += '|';
        _is_cols = false;
      }
    });
    _result = _result.slice(0, -1);
    _result +=  '/';
    _is_refill = bl;
    SWFAddress.setValue(_result);
  },
  // 使用地址栏里的地址来生成模板
  addressChangeHandler : function (evt) {
    var _param_num = SWFAddress.getPathNames().length;
    if (_is_refill && _param_num > 0) {
      if (SWFAddress.getPathNames()[0] != $('#cssSelector').val()) {
        $('#cssSelector').val(SWFAddress.getPathNames()[0]);
        changeCss(null, false);
      }
      if (_param_num > 1) {
        var _arr = decodeURIComponent(SWFAddress.getPathNames()[1]).split('|');
        clearHandler();
        for (var i = 0, len = _arr.length; i < len; i++) {
          var _type = Number(_arr[i].substr(0, 1));
          var _img_arr = _arr[i].substr(2).split(',');
          var _row = addRow(null, _type);
          _row.find('dd').html('');
          _row.appendTo($('#refreshHTML'));
          for (var j = 0, jlen = _img_arr.length; j < jlen; j++) {
            var _img = $('<img></img>', {'class':'dimg'});
            var _at = 0;
            if (_img_arr[j].indexOf('@') != -1) {
              _at = Number(_img_arr[j].substr(_img_arr[j].indexOf('@') + 1));
              _img_arr[j] = _img_arr[j].substring(0, _img_arr[j].indexOf('@'));
            }
            _img.attr('src', './images/' + _img_arr[j]);
            _img.bind('click', start);
            _img.appendTo(_row.find('dd').eq(_at));
          }
        }
      }
    }
  }
}
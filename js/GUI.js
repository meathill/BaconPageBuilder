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
  banner : null,
  page : null,
  currentCSS: '',
  isAnimating : false,
  init : function () {
    // 显示所有内容
    $('#preloader').remove();
    $('.hidden').fadeIn();
    
    // 按钮事件绑定
    $('#toggle-panel-button')
      .button({
        icons: {
          primary: "ui-icon-circle-triangle-e"
        },
        text: false
      })
      .click(this.togglePanel);
    $("#submit-button")
      .button({
        icons: {
          primary: 'ui-icon-upload'
        }
      })
      .click(this.uploadTemplate);
    $("#save_button")
      .button({
        icons: {
          primary: 'ui-icon-disk'
        }
      })
      .click(this.saveTemplate);
    $(".add-row-button").click(this.insertRow);
    $('#config-button')
      .button({
        icons: {
          primary: 'ui-icon-wrench'
        },
        text: false
      })
      .click(function (event) {
        $('#settings').dialog('open');
      });
    $('#help-button').button({
      icons: {
        primary: 'ui-icon-help'
      },
      text: false
    }).click(function (event) {
      $('#help-panel').dialog('open');
    });
    $('.step-button')
      .click(this.switchStepContent)
      //.eq(1)
      //.click()
      .parent()
      .buttonset();
    
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
    $('#css-list').find('li').click(this.changeCss);
    
    // 设置
    $('#settings').dialog({
      autoOpen: false,
      width: 400,
      height: 400,
      modal: true,
      title: '设置'
    });
    $('#help-panel').dialog({
      autoOpen: false
    })
  },
  togglePanel : function (event) {
    var icon = $(this).children().first();
    if ($('#sidebar').hasClass('outside')) {
      $('#sidebar').animate({"right": 0}, 400, function () {
        $(this).removeClass('outside')
      });
      icon
        .removeClass('ui-icon-circle-triangle-w')
        .addClass('ui-icon-circle-triangle-e');
    } else {
      $('#sidebar').animate({"right": -20 - $('#sidebar').width()}, 400, function () {
        $(this).addClass('outside');
      });
      icon
        .removeClass('ui-icon-circle-triangle-e')
        .addClass('ui-icon-circle-triangle-w');
    }
  },
  switchStepContent : function (event) {
    if (GUI.isAnimating) {
      event.stopPropagation();
      return;
    }
    GUI.isAnimating = true;
    var index = $('.step-button').index($(this));
    $('#step-contents').animate({scrollLeft: index * ($('#step-contents').width() + 10)}, 400, function () { GUI.isAnimating = false});
  },
  insertRow : function (event) {
    var colsNum = $(this).attr('class').match(/column-(\d)/)[1];
    var isTitled = $(this).hasClass('no-title') ? ' no-title' : '';
    console.log(isTitled);
    GUI.page.createNewRow(colsNum, isTitled);
  },
  //更新输入框 
  uploadTemplate : function (event){
    $('#submit-button').prop('disabled', true);
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
  saveTemplate : function (event) {
    
  },
  log : function (str, isReset){
    if (isReset) {
      $('#output').html(str);
    } else {
      $('#output').append(str); 
    }
  },
  changeCss : function (event, isSetURL){
    isSetURL = isSetURL == undefined ? true : isSetURL;
    var css = "css/" + $(this).attr('class') + ".css";
    if ($('#custom-style').length > 0) {
      $('#custom-style').attr('href', css);
    } else {
      var init = {
        href : css,
        id : 'custom-style',
        rel : 'stylesheet'
      }
      $('<link>', init).appendTo($('head'));
    }
    
    GUI.currentCSS = $(this).attr('class');
    $('#css-list .activated').removeClass('activated');
    $(this).addClass('activated');
    
    if (isSetURL) {
      GUI.setAddressContent(false);
    }
  },
  onResize : function (event) {
    var screenHeight = $(window).height();
    $('.module-thumbs').height(screenHeight - 292);
    $('.step-content').height(screenHeight - 209)
    $('#cover').height(screenHeight - 20);
  }
}
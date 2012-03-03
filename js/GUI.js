/*****************************************
 * 控制所有面板上的操作
 * 作为全局变量GUI，其它需要全局使用的东西也从这个对象里面取
 * 
 * @author Meathill
 * @version 0.3(2012-02-25)
 ****************************************/
jQuery.namespace("com.meathill.bacon.GUI");
com.meathill.bacon.GUI = Backbone.View.extend({
  body: {
    banner: null,
    navi: null,
    page: null,
  },
  styleList: null,
  sidebar: null,
  isAnimating: false,
  events: {
    "click #toggle-panel-button": "togglePanel",
    "click #submit-button": "uploadTemplate",
    "click #save_button": "saveTemplate",
    "click .add-navi-button": "addNavi",
    "click .add-row-button": "addRow",
    "click #config-button": "showConfig",
    "click #help-button": "showHelp",
    "click .step-button": "switchStepContent"
  },
  initialize: function () {
    this.setElement($("body"));
    this.styleList = new com.meathill.bacon.StyleThumbList();
    this.body.banner = new com.meathill.bacon.BannerMaker();
    this.body.page = new com.meathill.bacon.Page('#page-container');
    this.sidebar = $('#sidebar');
    this.render();
    $(window).resize(this.resizeHandler);
  },
  render: function () {
    this.addButtonFaces();
    
    // 拖动
    $("#modules")
      .tabs()
      .find('img')
        .draggable({
          opacity: 0.7,
          helper: 'clone',
          scope: 'element'
        });
    
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
    });
    
    this.removeLoading();
    this.resizeHandler();
  },
  removeLoading: function () {
    $('#preloader').remove();
    $('.hidden').fadeIn();
  },
  addButtonFaces: function () {
    $('#toggle-panel-button')
      .button({
        icons: {
          primary: "ui-icon-circle-triangle-e"
        },
        text: false
      });
    $("#submit-button")
      .button({
        icons: {
          primary: 'ui-icon-upload'
        }
      });
    $("#save_button")
      .button({
        icons: {
          primary: 'ui-icon-disk'
        }
      });
    $(".add-row-button")
      .button();
    $(".add-navi-button")
      .button();
    $('#config-button')
      .button({
        icons: {
          primary: 'ui-icon-wrench'
        },
        text: false
      });
    $('#help-button')
      .button({
        icons: {
          primary: 'ui-icon-help'
        },
        text: false
      });
    $('#steps')
      .buttonset();
  },
  togglePanel: function (event) {
    $(event.target)
      .toggleClass('ui-icon-circle-triangle-w ui-icon-circle-triangle-e');
    var targetPosition = !this.sidebar.hasClass('outside') ? -20 - this.sidebar.width() : 0;
    this.sidebar.animate({"right": targetPosition}, 400, function () {
      $(this).toggleClass('outside')
    });
  },
  switchStepContent: function (event) {
    if (this.isAnimating) {
      event.stopPropagation();
      return;
    }
    this.isAnimating = true;
    var self = this;
    var index = $(event.currentTarget).index() >> 1;
    $('#step-contents').animate({scrollLeft: index * ($('#step-contents').width() + 10)}, 400, function () { self.isAnimating = false});
  },
  addNavi: function (event) {
    if (this.body.navi == null) {
      this.body.navi = new com.meathill.bacon.Navi({editable: true});
      this.body.navi.addChild('首页');
      this.body.navi.$el.insertAfter(this.body.banner.el);
    }
  },
  addRow: function (event) {
    console.log(event);
    var colsNum = $(event.currentTarget).attr('class').match(/column-(\d)/)[1];
    var isTitled = $(event.currentTarget).hasClass('no-title') ? ' no-title' : '';
    this.body.page.createNewRow(colsNum, isTitled);
  },
  uploadTemplate: function (event){
    $('#submit-button').prop('disabled', true);
    if (this.banner.isChanged) {
      if (window.confirm('您在大头生成器里进行的操作还未保存，现在提交模板的话那些操作不会生效，确定么？')) {
        Model.submit();
      } else{
        alert('请点击大头生成器中的“保存”按钮，保存大头，然后再点“上传模板”');
      }
    } else {
      Model.submit();
    }
  },
  saveTemplate: function (event) {
    
  },
  showConfig: function (event) {
    $('#settings').dialog('open');
  },
  showHelp: function (event) {
    $('#help-panel').dialog('open');
  },
  log: function (str, isReset){
    if (isReset) {
      $('#output').html(str);
    } else {
      $('#output').append(str); 
    }
  },
  resizeHandler : function (event) {
    var screenHeight = $(window).height();
    $('.module-thumbs').height(screenHeight - 292);
    $('.step-content').height(screenHeight - 209)
    $('#cover').height(screenHeight - 20);
  }
});
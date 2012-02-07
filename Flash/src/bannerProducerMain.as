package src {
  import com.meathill.bannerFactory.events.TemplateEvent;
  import com.meathill.bannerFactory.events.ToolbarEvent;
  import com.meathill.bannerFactory.model.TemplateDataModel;
  import com.meathill.bannerFactory.view.TemplateContainer;
  import com.meathill.bannerFactory.view.TemplateThumbList;
  import com.meathill.bannerFactory.view.ToolBar;
  import com.meathill.BasicMain;
  import com.meathill.MeatVersion;
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.events.ProgressEvent;
  import lib.component.event.picUploaderEvent;
  import lib.component.tips.tipsBasicView;
	
	/**
	 * 专题模板自主搭建系统
	 * 大头生成器
	 * 根据模板，填写文字生成图片
	 * image上设置php接收程序来进行接收储存
	 * @author	Meathill
	 * @version	0.2(2010-10-08)
	 */
	public class BannerProducerMain extends BasicMain	{
		private var data:TemplateDataModel;
		private var buttonSet:ToolBar;
		private var templateContainer:TemplateContainer;
		private var templateThumbsList:TemplateThumbList;
		//=========================================================================
    //  Private Functions
    //=========================================================================
		override protected function init(event:Event = null):void {
			super.init(event);
			
			MeatVersion.createVersion(this);
			
			dataInit();
			displayInit();
		}
		override protected function dataInit(event:Event = null):void {
			data = new TemplateDataModel();
			data.addEventListener(Event.COMPLETE, data_completeHandler);
			data.addEventListener(IOErrorEvent.IO_ERROR, data_errorHandler);
			data.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			data.addEventListener(picUploaderEvent.ENCODE_COMPLETE, data_encodeCompleteHandler);
			data.addEventListener(picUploaderEvent.UPLOAD_COMPLETE, data_uploadCompleteHandler);
			data.load();
		}
		override protected function displayInit(event:Event = null):void {
			tipsBasicView.init(stage);
			
			buttonSet = new ToolBar();
			buttonSet.addEventListener(ToolbarEvent.SHOW_LIST, buttonSet_showListHandler);
			buttonSet.addEventListener(ToolbarEvent.SUBMIT, buttonSet_submitHandler);
			buttonSet.addEventListener(ToolbarEvent.LOCAL_UPLOAD, buttonSet_localUploadHandler);
			buttonSet.addEventListener(ToolbarEvent.PREV_TEMPLATE, buttonSet_changeTemplateHandler);
			buttonSet.addEventListener(ToolbarEvent.NEXT_TEMPLATE, buttonSet_changeTemplateHandler);
			buttonSet.enabled = false;
			
			templateContainer = new TemplateContainer(data.getDefaultHead(loaderInfo.parameters));
			templateContainer.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			templateContainer.addEventListener(TemplateEvent.TEMPLATE_LOAD_COMPLETE, templateLoadCompleteHandler);
			templateContainer.addEventListener(TemplateEvent.TEMPLATE_LOAD_FAILED, templateLoadFailedHandler);
			templateContainer.addEventListener(Event.CHANGE, templateChangedHandler);
			addChildAt(templateContainer, 0);
		}
    //=========================================================================
    //  Event Handlers
    //=========================================================================
		private function progressHandler(event:ProgressEvent):void {
			buttonSet.showProgress(event.bytesLoaded / event.bytesTotal);
		}
    //---------------------------------
    //  data
    //---------------------------------
		private function data_completeHandler(event:Event):void {
			buttonSet.text = '配置加载完毕，您可以点击按钮切换模板';
			
			buttonSet.removeEventListener(Event.COMPLETE, data_completeHandler);
			
			// 加载默认模板
			templateContainer.templateDataModel = data;
			templateContainer.loadTemplate();
		}
		private function data_errorHandler(event:IOErrorEvent):void {
			buttonSet.text = '加载失败，请联系翟路，看看是啥问题。本专题将采用默认大头。';
		}
		private function data_encodeCompleteHandler(event:picUploaderEvent):void {
			buttonSet.text = '生成完毕，开始上传';
		}
		private function data_uploadCompleteHandler(event:picUploaderEvent):void {
			data.isEdited = false;
			buttonSet.enabled = true;
			buttonSet.text = '上传完毕，大头地址已经更换到模板内';
		}
    //---------------------------------
    //  buttonSet
    //---------------------------------
		private function buttonSet_showListHandler(event:ToolbarEvent):void {
			if (null != templateThumbsList && contains(templateThumbsList)) {
				removeChild(templateThumbsList);
			} else {
				if (null == templateThumbsList) {
					templateThumbsList = new TemplateThumbList(this, 10, 55);
					templateThumbsList.templateDataModel = data;
					templateThumbsList.showThumbList();
					templateThumbsList.addEventListener(ToolbarEvent.CHANGE_TEMPLATE, changeTemplate);
				}
				addChild(templateThumbsList);
			}
		}
		private function buttonSet_submitHandler(event:ToolbarEvent):void {
			buttonSet.text = '上传图片，会先生成jpg图片再上传，请稍后';
			buttonSet.enabled = false;
			data.uploadPic(templateContainer.templateContent);
		}
    private function buttonSet_localUploadHandler(event:ToolbarEvent):void {
      data.browse();
    }
    private function buttonSet_changeTemplateHandler(event:ToolbarEvent):void {
      if (event.type == ToolbarEvent.PREV_TEMPLATE) {
        templateContainer.changeTemplate(templateContainer.currTemplateIndex - 1);
      } else {
        templateContainer.changeTemplate(templateContainer.currTemplateIndex + 1);
      }
    }
    //---------------------------------
    //  template
    //---------------------------------
		private function templateLoadCompleteHandler(event:TemplateEvent):void {
			if (event.index != -1) {
				if (data.hasMSYH) {
					buttonSet.text = '模板加载成功，点击标题文字开始编辑';
				} else {
					buttonSet.htmlText = '您的电脑中没有雅黑字体，请先 <a href="event:download">下载</a> 并复制到Windows/Font/目录下，再刷新';
				}
				buttonSet.submitable = true;
				buttonSet.uploadable = false;
			} else {
				buttonSet.text = '当前是默认大头，不能编辑。您可以上传自制大头以替换之。';
				
				buttonSet.enabled = true;
				buttonSet.uploadable = true;
				buttonSet.submitable = templateContainer.isUploaded;
			}
			data.setStageHeight(templateContainer.height);
		}
		private function templateLoadFailedHandler(event:TemplateEvent):void {
			buttonSet.text = event.msg;
		}
		private function changeTemplate(event:ToolbarEvent):void {
			templateContainer.changeTemplate(event.index);
		}
		private function templateChangedHandler(event:Event):void {
			data.isEdited = true;
		}
	}
}
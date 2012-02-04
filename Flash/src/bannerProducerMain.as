package {
  import com.meathill.bannerFactory.model.TemplateDataModel;
  import com.meathill.BasicMain;
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.events.ProgressEvent;
  import lib.component.event.picUploaderEvent;
  import lib.component.tips.tipsBasicView;
  import src.event.templateEvent;
  import src.event.toolbarEvent;
  import src.view.templateContainerView;
  import src.view.templateThumbListView;
  import src.view.toolBarView;
	
	/**
	 * 专题模板自主搭建系统
	 * 大头生成器
	 * 根据模板，填写文字生成图片
	 * image上设置php接收程序来进行接收储存
	 * @author	Meathill
	 * @version	0.2(2010-10-08)
	 */
  [Embeded(
	public class BannerProducerMain extends BasicMain	{
		private var data:TemplateDataModel;
		private var buttonSet:toolBarView;
		private var templatesContainer:templateContainerView;
		private var templateThumbsList:templateThumbListView;
		/**************
		 * functions
		 * ***********/
		override protected function init(event:Event = null):void {
			super.init(event);
			
			_menu.version = [Version.Major, Version.Minor, Version.Build, Version.Revision].join('.');
			
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
			
			buttonSet = toolBarView(getChildAt(0));
			buttonSet.addEventListener(toolbarEvent.SHOW_LIST, showList);
			buttonSet.addEventListener(toolbarEvent.SUBMIT, submitHandler);
			buttonSet.addEventListener(toolbarEvent.LOCAL_UPLOAD, data.browse);
			buttonSet.enabled = false;
			
			templatesContainer = new templateContainerView(data.getDefaultHead(loaderInfo.parameters));
			templatesContainer.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			templatesContainer.addEventListener(templateEvent.TEMPLATE_LOAD_COMPLETE, templateLoadComplete);
			templatesContainer.addEventListener(templateEvent.TEMPLATE_LOAD_FAILED, templateLoadFailed);
			templatesContainer.addEventListener(Event.CHANGE, templateChanged);
			addChildAt(templatesContainer, 0);
			
			buttonSet.addEventListener(toolbarEvent.PREV_TEMPLATE, templatesContainer.changeTemplate);
			buttonSet.addEventListener(toolbarEvent.NEXT_TEMPLATE, templatesContainer.changeTemplate);
		}
		private function progressHandler(event:ProgressEvent):void {
			buttonSet.showProgress(event.bytesLoaded / event.bytesTotal);
		}
		private function dataLoadComplete(event:Event):void {
			buttonSet.text = '配置加载完毕，您可以点击按钮切换模板';
			
			buttonSet.removeEventListener(Event.COMPLETE, dataLoadComplete);
			
			// 加载默认模板
			templatesContainer.data = data;
			templatesContainer.loadTemplate();
		}
		private function dataLoadFailed(event:IOErrorEvent):void {
			buttonSet.text = '加载失败，请联系翟路，看看是啥问题。本专题将采用默认大头。';
		}
		private function templateLoadComplete(event:templateEvent):void {
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
				buttonSet.submitable = templatesContainer.uploaded;
			}
			data.setStageHeight(templatesContainer.height);
		}
		private function templateLoadFailed(event:templateEvent):void {
			buttonSet.text = event.msg;
		}
		private function submitHandler(event:toolbarEvent):void {
			buttonSet.text = '上传图片，会先生成jpg图片再上传，请稍后';
			buttonSet.enabled = false;
			data.uploadPic(templatesContainer.template);
		}
		private function encodeCompleteHandler(event:picUploaderEvent):void {
			buttonSet.text = '生成完毕，开始上传';
		}
		private function uploadCompleteHandler(event:picUploaderEvent):void {
			data.edited = false;
			buttonSet.enabled = true;
			buttonSet.text = '上传完毕，大头地址已经更换到模板内';
		}
		private function showList(event:toolbarEvent):void {
			if (null != templateThumbsList && contains(templateThumbsList)) {
				removeChild(templateThumbsList);
			} else {
				if (null == templateThumbsList) {
					templateThumbsList = new templateThumbListView(this, 10, 55);
					templateThumbsList.data = data;
					templateThumbsList.showThumbList();
					templateThumbsList.addEventListener(toolbarEvent.CHANGE_TEMPLATE, changeTemplate);
				}
				addChild(templateThumbsList);
			}
		}
		private function changeTemplate(event:toolbarEvent):void {
			templatesContainer.changeTemplate(null, event.index);
		}
		private function templateChanged(event:Event):void {
			data.edited = true;
		}
	}
}
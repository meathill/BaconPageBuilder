package src 
{
	import com.zol.basicMain;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import lib.component.event.picUploaderEvent;
	import lib.component.tips.tipsBasicView;
	import src.event.templateEvent;
	import src.event.toolbarEvent;
	import src.model.templateDataModel;
	import src.view.templateContainerView;
	import src.view.templateThumbListView;
	import src.view.toolBarView;
	
	/**
	 * 专题模板自主搭建系统
	 * 大头生成器
	 * 使用已有的大头模板，让编辑填写文字生成所需大头
	 * image上设置php接收程序来进行接收储存
	 * @author	Meathill
	 * @version	0.2(2010-10-08)
	 */
	public class bannerProducerMain extends basicMain
	{
		private var _data:templateDataModel;
		private var _toolbar:toolBarView;
		private var _template_con:templateContainerView;
		private var _tlist:templateThumbListView;
		
		public function bannerProducerMain() 
		{
			super();
		}
		
		/**************
		 * functions
		 * ***********/
		override protected function init(evt:Event = null):void {
			super.init(evt);
			
			_menu.version = '0.2';
			
			dataInit();
			displayInit();
		}
		override protected function dataInit(evt:Event = null):void {
			_data = new templateDataModel();
			_data.addEventListener(Event.COMPLETE, dataLoadComplete);
			_data.addEventListener(IOErrorEvent.IO_ERROR, dataLoadFailed);
			_data.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			_data.addEventListener(picUploaderEvent.ENCODE_COMPLETE, encodeCompleteHandler);
			_data.addEventListener(picUploaderEvent.UPLOAD_COMPLETE, uploadCompleteHandler);
			_data.load();
		}
		override protected function displayInit(evt:Event = null):void {
			tipsBasicView.init(stage);
			
			_toolbar = toolBarView(getChildAt(0));
			_toolbar.addEventListener(toolbarEvent.SHOW_LIST, showList);
			_toolbar.addEventListener(toolbarEvent.SUBMIT, submitHandler);
			_toolbar.addEventListener(toolbarEvent.LOCAL_UPLOAD, _data.browse);
			_toolbar.enabled = false;
			
			_template_con = new templateContainerView(_data.getDefaultHead(loaderInfo.parameters));
			_template_con.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			_template_con.addEventListener(templateEvent.TEMPLATE_LOAD_COMPLETE, templateLoadComplete);
			_template_con.addEventListener(templateEvent.TEMPLATE_LOAD_FAILED, templateLoadFailed);
			_template_con.addEventListener(Event.CHANGE, templateChanged);
			addChildAt(_template_con, 0);
			
			_toolbar.addEventListener(toolbarEvent.PREV_TEMPLATE, _template_con.changeTemplate);
			_toolbar.addEventListener(toolbarEvent.NEXT_TEMPLATE, _template_con.changeTemplate);
		}
		private function progressHandler(evt:ProgressEvent):void {
			_toolbar.showProgress(evt.bytesLoaded / evt.bytesTotal);
		}
		private function dataLoadComplete(evt:Event):void {
			_toolbar.text = '配置加载完毕，您可以点击按钮切换模板';
			
			_toolbar.removeEventListener(Event.COMPLETE, dataLoadComplete);
			
			// 加载默认模板
			_template_con.data = _data;
			_template_con.loadTemplate();
		}
		private function dataLoadFailed(evt:IOErrorEvent):void {
			_toolbar.text = '加载失败，请联系翟路，看看是啥问题。本专题将采用默认大头。';
		}
		private function templateLoadComplete(evt:templateEvent):void {
			if (evt.index != -1) {
				if (_data.hasMSYH) {
					_toolbar.text = '模板加载成功，点击标题文字开始编辑';
				} else {
					_toolbar.htmlText = '您的电脑中没有雅黑字体，请先 <a href="event:download">下载</a> 并复制到Windows/Font/目录下，再刷新';
				}
				_toolbar.submitable = true;
				_toolbar.uploadable = false;
			} else {
				_toolbar.text = '当前是默认大头，不能编辑。您可以上传自制大头以替换之。';
				
				_toolbar.enabled = true;
				_toolbar.uploadable = true;
				_toolbar.submitable = _template_con.uploaded;
			}
			_data.setStageHeight(_template_con.height);
		}
		private function templateLoadFailed(evt:templateEvent):void {
			_toolbar.text = evt.msg;
		}
		private function submitHandler(evt:toolbarEvent):void {
			_toolbar.text = '上传图片，会先生成jpg图片再上传，请稍后';
			_toolbar.enabled = false;
			_data.uploadPic(_template_con.template);
		}
		private function encodeCompleteHandler(evt:picUploaderEvent):void {
			_toolbar.text = '生成完毕，开始上传';
		}
		private function uploadCompleteHandler(evt:picUploaderEvent):void {
			_data.edited = false;
			_toolbar.enabled = true;
			_toolbar.text = '上传完毕，大头地址已经更换到模板内';
		}
		private function showList(evt:toolbarEvent):void {
			if (null != _tlist && contains(_tlist)) {
				removeChild(_tlist);
			} else {
				if (null == _tlist) {
					_tlist = new templateThumbListView(this, 10, 55);
					_tlist.data = _data;
					_tlist.showThumbList();
					_tlist.addEventListener(toolbarEvent.CHANGE_TEMPLATE, changeTemplate);
				}
				addChild(_tlist);
			}
		}
		private function changeTemplate(evt:toolbarEvent):void {
			_template_con.changeTemplate(null, evt.index);
		}
		private function templateChanged(evt:Event):void {
			_data.edited = true;
		}
	}
}
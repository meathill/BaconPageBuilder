package src.model 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.external.ExternalInterface;
	import flash.text.Font;
	import lib.component.data.dataBasicModel;
	import lib.component.data.dataModelType;
	import lib.component.data.localPicLoader;
	import lib.component.data.picUploader;
	import lib.component.event.picUploaderEvent;
	import src.view.template.ITemplate;
	
	/**
	 * ...
	 * @author Meathill
	 */
	public class templateDataModel extends dataBasicModel
	{
		private const _URL:String = 'http://article.zol.com.cn/zt/templateDIY/template_list.xml';
		private const _UPLOAD_URL:String = 'http://image.zol.com.cn/article/templateDIY/upload.php';
		private const _HEAD_FUNC:String = "BannerMaker.setHeadPic";
		private const _RESIZE_FUNC:String = "BannerMaker.setBannerHeight";
		private const _CHANGED:String = "BannerMaker.setBannerChanged";
		private const _FONT_NAME:String = '微软雅黑';
		
		private var _total:int = 0;
		private var _picid:int = 0;
		private var _height:int = 0;
		private var _is_MSYH_bl:Boolean = false;
		private var _is_edited_bl:Boolean = false;
		private var _uploader:picUploader;
		private var _localpic:localPicLoader;
		private var _local_bmp:Bitmap;
		
		public function templateDataModel() 
		{
			super(_URL);
			
			init();
		}
		
		/**************
		 * properties
		 * ***********/
		public function get total():int {
			return _total;
		}
		public function get hasMSYH():Boolean {
			return _is_MSYH_bl;
		}
		public function get height():int {
			return _height;
		}
		public function set edited(bl:Boolean):void {
			_is_edited_bl = bl;
			trace(bl);
			ExternalInterface.call(_CHANGED, _is_edited_bl);
		}
		public function get bmp():Bitmap {
			return _local_bmp;
		}
		
		/**************
		 * functions
		 * ***********/
		private function init():void {
			_type = dataModelType.XML;
			
			_uploader = new picUploader(_UPLOAD_URL);
			_uploader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			_uploader.addEventListener(picUploaderEvent.ENCODE_COMPLETE, encodeComplete);
			_uploader.addEventListener(picUploaderEvent.UPLOAD_COMPLETE, picUploadComplete);
			
			// 检查是否有微软雅黑字体
			var _arr:Array = Font.enumerateFonts(true);
			for each (var _obj:Object in _arr) {
				//trace(_obj.fontName, _obj.fontStyle, _obj.fontType);
				if (_FONT_NAME == _obj.fontName) {
					_is_MSYH_bl = true;
					break;
				}
			}
			
			_localpic = new localPicLoader();
			_localpic.addEventListener(Event.COMPLETE, loadLocalPicComplete);
		}
		override protected function loadComplete(evt:Event):void {
			super.loadComplete(evt);
			_total = _data_xml.children().length();
		}
		private function setBannerPic():void {
			ExternalInterface.call(_HEAD_FUNC, _picid);
		}
		private function encodeComplete(evt:picUploaderEvent):void {
			dispatchEvent(evt);
		}
		private function picUploadComplete(evt:picUploaderEvent):void {
			_picid = int(evt.data);
			setBannerPic();
			
			dispatchEvent(evt);
		}
		private function loadLocalPicComplete(evt:Event):void {
			_local_bmp = _localpic.bmp;
			
			var _evt:Event = new Event(Event.COMPLETE);
			dispatchEvent(_evt);
		}
		
		/**************
		 * methods
		 * ***********/
		public function uploadPic(obj:DisplayObject):void {
			if (_picid) {
				_uploader.url = _UPLOAD_URL + '?id=' + _picid;
			}
			_uploader.width = obj.width;
			_uploader.height = obj.height;
			_uploader.encode(obj);
			_uploader.upload();
		}
		public function getTempalteName(i:int):String {
			return _data_xml.template[i].@name;
		}
		public function getTemplateSrc(i:int):String {
			return _data_xml.template[i].@src;
		}
		public function getTemplateId(i:int):String {
			return _data_xml.template[i].@id;
		}
		public function getTemplateThumb(i:int):String {
			return _data_xml.template[i].@thumb;
		}
		public function setStageHeight(h:int):void {
			_height = h;
			ExternalInterface.call(_RESIZE_FUNC, h);
		}
		public function browse(evt:Event):void {
			_localpic.selectFile();
		}
		public function getDefaultHead(obj:Object):String {
			//obj.src = 'http://img2.zol-img.com.cn/article/templateDIY/banner/1/165.jpg';
			var _result:String = '';
			if (obj != null && obj.hasOwnProperty('src')) {
				_result = obj.src;
			}
			return _result;
		}
	}
}
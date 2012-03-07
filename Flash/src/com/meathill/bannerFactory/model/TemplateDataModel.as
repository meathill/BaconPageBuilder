package com.meathill.bannerFactory.model {
  import com.meathill.bannerFactory.events.ToolbarEvent;
  import com.meathill.image.events.LocalPicLoaderEvent;
  import com.meathill.image.events.PicUploaderEvent;
  import com.meathill.image.LocalPicLoader;
  import com.meathill.image.PicUploader;
  import flash.display.Bitmap;
  import flash.display.DisplayObject;
  import flash.events.Event;
  import flash.events.ProgressEvent;
  import flash.external.ExternalInterface;
  import flash.text.Font;
  import lib.component.data.DataBasicModel;
  import lib.component.data.DataModelType;
	
	/**
	 * 加载xml数据
   * 这次重构后
	 * @author Meathill
	 */
  [Event(name="changeTemplate", type="com.meathill.bannerFactory.events.ToolbarEvent")]
	public class TemplateDataModel extends DataBasicModel {
    //=========================================================================
    //  Class Constants
    //=========================================================================
		public static const URL:String = 'template/template_list.xml';
		public static const UPLOAD_URL:String = 'http://image.zol.com.cn/article/templateDIY/upload.php';
		public static const HEAD_FUNC:String = "GUI.page.header.setHeadPic";
		public static const SET_HEIGHT:String = "GUI.page.header.setHeight";
		public static const SET_STYLE:String = "GUI.page.header.setStyle";
		public static const FONT_NAME:String = '微软雅黑';
		public static const DEFAULT_HEAD:String = 'images/head.jpg';
    //=========================================================================
    //  Constructor
    //=========================================================================
		public function TemplateDataModel(parameters:Object) {
			super(URL);
			
			init(parameters);
		}
		//=========================================================================
    //  Properties
    //=========================================================================
		private var uploader:PicUploader;
		private var localpic:LocalPicLoader;
    private var msg:String;
		public function get bmp():Bitmap {
			return localpic.bmp;
		}
    //---------------------------------
    //  height
    //---------------------------------
		private var _height:int = 0;
		public function get height():int {
			return _height;
		}
    //---------------------------------
    //  isEdited
    //---------------------------------
		private var _isEdited:Boolean = false;
		public function set isEdited(bl:Boolean):void {
			_isEdited = bl;
		}
    //---------------------------------
    //  hasMSYH
    //---------------------------------
		private var _hasMSYH:Boolean = false;
    public function get hasMSYH():Boolean {
      return _hasMSYH;
    }
		//=========================================================================
    //  Public Methods
    //=========================================================================
		public function uploadPic(obj:DisplayObject):void {
			uploader.encode(obj);
			uploader.upload();
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
		public function browse():void {
			localpic.selectFile();
		}
		public function getDefaultHead(obj:Object):String {
			//obj.src = 'http://img2.zol-img.com.cn/article/templateDIY/banner/1/165.jpg';
			var _result:String = '';
			if (obj != null && obj.hasOwnProperty('src')) {
				_result = obj.src;
			}
			return _result;
		}
		public function setStageHeight(h:int):void {
      trace('call js : ' + SET_HEIGHT, 'param : ' + h);
			_height = h;
      if (ExternalInterface.available) {
        ExternalInterface.call(SET_HEIGHT, h);
      }
		}
    public function setStyle(currTemplateIndex:int):void {
      trace('call js : ' + SET_STYLE, 'param : ' + currTemplateIndex);
      if (ExternalInterface.available) {
        ExternalInterface.call(SET_STYLE, currTemplateIndex);
      }
    }
		//=========================================================================
    //  Private Functions
    //=========================================================================
		private function init(parameters:Object):void {
			_type = DataModelType.XML;
			
			uploader = new PicUploader(UPLOAD_URL);
			uploader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			uploader.addEventListener(PicUploaderEvent.ENCODE_COMPLETE, uploader_encodeCompleteHandler);
			uploader.addEventListener(PicUploaderEvent.UPLOAD_COMPLETE, uploader_uploadCompleteHandler);
			
			// 检查是否有微软雅黑字体
			var arr:Array = Font.enumerateFonts(true);
			for each (var obj:Object in arr) {
				if (FONT_NAME == obj.fontName) {
					_hasMSYH = true;
					break;
				}
			}
			
			localpic = new LocalPicLoader();
			localpic.addEventListener(LocalPicLoaderEvent.LOAD_PIC_COMPLETE, local_loadPicCompleteHandler);
      
      if (ExternalInterface.available) {
        ExternalInterface.addCallback("changeTemplate", changeTemplateCallback);
      }
		}
		private function setBannerPic(msg:String):void {
			ExternalInterface.call(HEAD_FUNC, msg);
		}
    private function changeTemplateCallback(index:int):void {
      dispatchEvent(new ToolbarEvent(ToolbarEvent.CHANGE_TEMPLATE, index));
    }
		//=========================================================================
    //  Event Handlers
    //=========================================================================
		private function uploader_encodeCompleteHandler(event:PicUploaderEvent):void {
			dispatchEvent(event);
		}
		private function uploader_uploadCompleteHandler(event:PicUploaderEvent):void {
			setBannerPic(event.msg);
			dispatchEvent(event);
		}
		private function local_loadPicCompleteHandler(event:LocalPicLoaderEvent):void {
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}
package src.view 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import src.event.templateEvent;
	import src.event.toolbarEvent;
	import src.model.templateDataModel;
	import src.view.template.ITemplate;
	
	/**
	 * 存放模板的层
	 * @author Meathill
	 */
	public class templateContainerView extends Sprite
	{
		private const _CONTEXT:LoaderContext = new LoaderContext(true);
		private const _BASE_POINT:Point = new Point(0, 0);
		
		private var _DEFAULT_HEAD:String = 'http://icon.zol.com.cn/article/templateDIY/images/head.jpg';
		private var _head_arr:Array;
		private var _loader:Loader;
		private var _template:ITemplate;
		private var _editor1:textEditorView;
		private var _editor2:textEditorView;
		private var _default_head_bmp:Bitmap;
		private var _data:templateDataModel;
		private var _loaded_head_arr:Array;
		private var _is_uploaded_bl:Boolean = false;
		private var _cur_template_index:int = -1;
		
		public function templateContainerView(head_src:String = '') 
		{
			init(head_src);
		}
		
		/************
		 * properties
		 * *********/
		public function get template():DisplayObject {
			if ( -1 == _cur_template_index) {
				return _default_head_bmp;
			} else {
				return _template.self;
			}
		}
		public function get index():int {
			return _cur_template_index;
		}
		public function set data(obj:templateDataModel):void {
			_data = obj;
			_data.addEventListener(Event.COMPLETE, loadLocalPicComplete);
		}
		public function get uploaded():Boolean {
			return _is_uploaded_bl;
		}
		
		/************
		 * functions
		 * *********/
		private function init(str:String = ''):void {
			if (str != '') {
				if (str.indexOf('###') != -1) {
					_head_arr = str.split('###');
				} else {
					_DEFAULT_HEAD = str;
				}
			}
			
			_editor1 = new textEditorView();
			_editor2 = new textEditorView();
			
			_loaded_head_arr = [];
		}
		private function loadTemplateComplete(evt:Event):void {
			if ( -1 != _cur_template_index) {
				_template = ITemplate(_loader.content);
				addItem(_template, _cur_template_index);
				
				_editor1.init(_template.getTextField(1));
				addChild(_editor1);
				_editor2.init(_template.getTextField(2));
				addChild(_editor2);
				
				addChildAt(_loader.content, 0);
			} else {
				if (null == _default_head_bmp) {
					_default_head_bmp = Bitmap(_loader.content);
				} else {
					// 将新加载的内容合并到头图上
					var _bmpd:BitmapData = new BitmapData(_default_head_bmp.width, _default_head_bmp.height + _loader.height);
					_bmpd.copyPixels(_default_head_bmp.bitmapData, new Rectangle(0, 0, _default_head_bmp.width, _default_head_bmp.height), _BASE_POINT);
					_bmpd.copyPixels(Bitmap(_loader.content).bitmapData, new Rectangle(0, 0, _loader.width, _loader.height), new Point(0, _default_head_bmp.height));
					Bitmap(_loader.content).bitmapData.dispose();
					_default_head_bmp.bitmapData.dispose();
					_default_head_bmp.bitmapData = _bmpd;
				}
				
				addChildAt(_default_head_bmp, 0);
			}
			
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadTemplateComplete);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadTemplateFailed);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			_loader = null;
			
			if (_head_arr == null || _head_arr.length == 0) {
				dispatchComplete();
			} else {
				makeLoader();
				_loader.load(new URLRequest(_head_arr.shift()), _CONTEXT);
			}
		}
		private function progressHandler(evt:ProgressEvent):void {
			dispatchEvent(evt);
		}
		private function loadTemplateFailed(evt:IOErrorEvent):void {
			var _evt:templateEvent = new templateEvent(templateEvent.TEMPLATE_LOAD_COMPLETE);
			_evt.msg = '加载模板失败';
			dispatchEvent(_evt);
		}
		private function makeLoader():void {
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadTemplateComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadTemplateFailed);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		}
		private function addItem(obj:ITemplate,i:int):void {
			_loaded_head_arr[i] = obj;
		}
		private function getItem(i:int):ITemplate {
			return _loaded_head_arr[i];
		}
		private function hasItem(i:int):Boolean {
			return undefined != _loaded_head_arr[i];
		}
		private function dispatchComplete():void {
			var _evt:templateEvent = new templateEvent(templateEvent.TEMPLATE_LOAD_COMPLETE);
			_evt.index = _cur_template_index;
			dispatchEvent(_evt);
		}
		private function loadLocalPicComplete(evt:Event):void {
			removeChild(_default_head_bmp);
			
			_default_head_bmp = _data.bmp;
			_is_uploaded_bl = true;
			loadTemplate();
		}
		private function templateChanged(evt:Event = null):void {
			if (null == evt) {
				evt = new Event(Event.CHANGE);
			}
			dispatchEvent(evt);
		}
		
		/************
		 * methods
		 * *********/
		public function loadTemplate(i:int = -1, url:String = ''):void {
			if (_loader != null) { 
				_loader.close();
			}
			// 如果已有别的模板，则移除
			if (_template != null && contains(_template.self)) {
				removeChild(_template.self);
			}
			// 如果加载了默认模板，也移除
			if (_default_head_bmp != null && contains(_default_head_bmp)) { 
				removeChild(_default_head_bmp);
			}
			
			_cur_template_index = i;
			if ( -1 == i) {
				// 加载默认模班
				if (_default_head_bmp != null) {
					addChildAt(_default_head_bmp, 0);
					
					dispatchComplete();
				} else {
					makeLoader();
					if (_head_arr != null) {
						_loader.load(new URLRequest(_head_arr.shift()), _CONTEXT);
					} else {
						_loader.load(new URLRequest(_DEFAULT_HEAD), _CONTEXT);
					}
				}
			} else {
				if (hasItem(i)) {
					_template = getItem(i);
					
					_editor1.init(_template.getTextField(1));
					addChild(_editor1);
					_editor2.init(_template.getTextField(2));
					addChild(_editor2);
					
					addChildAt(_template.self, 0);
					
					dispatchComplete();
				} else {
					makeLoader();
					_loader.load(new URLRequest(url), _CONTEXT);
				}
			}
			
			if ( -1 != _cur_template_index) {
				templateChanged();
			}
		}
		/**
		 * 变换模板
		 * @param	evt
		 */
		public function changeTemplate(evt:Event = null, _tar:int = 0):void {
			if (evt is toolbarEvent) {
				if (evt.type == toolbarEvent.PREV_TEMPLATE) {
					_tar = _cur_template_index - 1;
					if ( -2 == _tar) {
						_tar = _data.total - 1;
					}
				} else if (evt.type == toolbarEvent.NEXT_TEMPLATE) {
					_tar = _cur_template_index + 1;
					if (_data.total == _tar) {
						_tar = -1;
					}
				}
			}
			loadTemplate(_tar, _data.getTemplateSrc(_tar));
		}
	}
}
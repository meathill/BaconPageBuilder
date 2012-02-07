package com.meathill.bannerFactory.view {
  import com.meathill.bannerFactory.events.TemplateEvent;
  import com.meathill.bannerFactory.model.TemplateDataModel;
  import com.meathill.bannerFactory.view.template.ITemplate;
  import com.meathill.image.events.LocalPicLoaderEvent;
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.DisplayObject;
  import flash.display.Loader;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.events.ProgressEvent;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.net.URLRequest;
  import flash.system.LoaderContext;
	
	/**
	 * 存放模板的层
	 * @author Meathill
	 */
	public class TemplateContainer extends Sprite	{
    //=========================================================================
    //  Class Constants
    //=========================================================================
		public static const BASE_POINT:Point = new Point(0, 0);
		public static const DEFAULT_HEAD:String = 'images/head.jpg';
		//=========================================================================
    //  Constructor
    //=========================================================================
		public function TemplateContainer(headSrc:String = '') {
			build(headSrc);
		}
		//=========================================================================
    //  Properties
    //=========================================================================
		private var heads:Array;
		private var loader:Loader;
		private var template:ITemplate;
		private var editor1:TextEditor;
		private var editor2:TextEditor;
		private var defaultHead:Bitmap;
		private var loadedHeads:Array;
		public function get templateContent():DisplayObject {
			if (-1 == currTemplateIndex) {
				return defaultHead;
			} else {
				return template.self;
			}
		}
    //---------------------------------
    //  currTemplateIndex
    //---------------------------------
		private var _currTemplateIndex:int = -1;
		public function get currTemplateIndex():int {
			return _currTemplateIndex;
		}
    //---------------------------------
    //  templateDataModel
    //---------------------------------
		private var _templateDataModel:TemplateDataModel;
		public function set templateDataModel(value:TemplateDataModel):void {
			_templateDataModel = value;
			_templateDataModel.addEventListener(LocalPicLoaderEvent.LOAD_PIC_COMPLETE, templateDataModel_loadPicComplateHandler);
		}
    //---------------------------------
    //  isUploaded
    //---------------------------------
		private var _isUploaded:Boolean = false;
		public function get isUploaded():Boolean {
			return _isUploaded;
		}
		//=========================================================================
    //  Public Methods
    //=========================================================================
		public function loadTemplate(index:int = -1, url:String = ''):void {
      if (index == _currTemplateIndex) {
        return;
      }
			if (loader != null) { 
				loader.close();
			}
			// 如果已有别的模板，则移除
			if (template != null && contains(template.self)) {
				removeChild(template.self);
			}
			// 如果加载了默认模板，也移除
			if (defaultHead != null && contains(defaultHead)) { 
				removeChild(defaultHead);
			}
			
			if ( -1 == index) {
				// 加载默认模班
				if (defaultHead != null) {
					addChildAt(defaultHead, 0);
					
					dispatchComplete();
				} else {
					loader = createLoader();
					if (heads != null) {
						loader.load(new URLRequest(heads.shift()), new LoaderContext(true));
					} else {
						loader.load(new URLRequest(DEFAULT_HEAD), new LoaderContext(true));
					}
				}
			} else {
				if (hasItem(index)) {
					template = getItem(index);
					
					editor1.init(template.getTextField(1));
					addChild(editor1);
					editor2.init(template.getTextField(2));
					addChild(editor2);
					
					addChildAt(template.self, 0);
					
					dispatchComplete();
				} else {
					loader = createLoader();
					loader.load(new URLRequest(url), new LoaderContext(true));
				}
			}
			
			if ( -1 != _currTemplateIndex && index != _currTemplateIndex) {
        _currTemplateIndex = index;
        dispatchEvent(new Event(Event.CHANGE));
			}
		}
		/**
		 * 变换模板
		 * @param	event
		 */
		public function changeTemplate(toTemplateIndex:int = 0):void {
			loadTemplate(toTemplateIndex, _templateDataModel.getTemplateSrc(toTemplateIndex));
		}
    //=========================================================================
    //  Private Functions
    //=========================================================================
		private function build(str:String = ''):void {
      if (str != '') {
        heads = str.split('###');
      }
			
			editor1 = new TextEditor();
			editor2 = new TextEditor();
			
			loadedHeads = [];
		}
		private function createLoader():Loader {
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_completeHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loader_progressHandler);
      return loader;
		}
		private function addItem(template:ITemplate,index:int):void {
			loadedHeads[index] = template;
		}
		private function getItem(index:int):ITemplate {
			return loadedHeads[index];
		}
		private function hasItem(index:int):Boolean {
			return undefined != loadedHeads[index];
		}
		private function dispatchComplete():void {
			dispatchEvent(new TemplateEvent(TemplateEvent.TEMPLATE_LOAD_COMPLETE, _currTemplateIndex));
		}
    //=========================================================================
    //  Event Handlers
    //=========================================================================
		private function loader_completeHandler(event:Event):void {
			if ( -1 != _currTemplateIndex) {
				template = ITemplate(loader.content);
				addItem(template, _currTemplateIndex);
				
				editor1.init(template.getTextField(1));
				addChild(editor1);
				editor2.init(template.getTextField(2));
				addChild(editor2);
				
				addChildAt(loader.content, 0);
			} else {
				if (null == defaultHead) {
					defaultHead = Bitmap(loader.content);
				} else {
					// 将新加载的内容合并到头图上
					var bmpd:BitmapData = new BitmapData(defaultHead.width, defaultHead.height + loader.height);
					bmpd.copyPixels(defaultHead.bitmapData, new Rectangle(0, 0, defaultHead.width, defaultHead.height), BASE_POINT);
					bmpd.copyPixels(Bitmap(loader.content).bitmapData, new Rectangle(0, 0, loader.width, loader.height), new Point(0, defaultHead.height));
					Bitmap(loader.content).bitmapData.dispose();
					defaultHead.bitmapData.dispose();
					defaultHead.bitmapData = bmpd;
				}
				
				addChildAt(defaultHead, 0);
			}
			
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loader_completeHandler);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loader_progressHandler);
			loader = null;
			
			if (heads == null || heads.length == 0) {
				dispatchComplete();
			} else {
				createLoader();
				loader.load(new URLRequest(heads.shift()), new LoaderContext(true));
			}
		}
		private function loader_progressHandler(event:ProgressEvent):void {
			dispatchEvent(event);
		}
		private function loader_errorHandler(event:IOErrorEvent):void {
			dispatchEvent(new TemplateEvent(TemplateEvent.TEMPLATE_LOAD_COMPLETE, _currTemplateIndex,  '加载模板失败'));
		}
		private function templateDataModel_loadPicComplateHandler(event:LocalPicLoaderEvent):void {
			removeChild(defaultHead);
			
			defaultHead = _templateDataModel.bmp;
			_isUploaded = true;
			loadTemplate();
		}
	}
}
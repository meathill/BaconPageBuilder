package com.meathill.bannerFactory.view {
  import com.meathill.bannerFactory.events.TemplateEvent;
  import com.meathill.bannerFactory.model.TemplateDataModel;
  import com.meathill.bannerFactory.view.template.ITemplate;
  import com.meathill.image.events.LocalPicLoaderEvent;
  import flash.display.Bitmap;
  import flash.display.DisplayObject;
  import flash.display.Loader;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.events.ProgressEvent;
  import flash.geom.Point;
  import flash.net.URLRequest;
  import flash.system.ApplicationDomain;
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
		//=========================================================================
    //  Constructor
    //=========================================================================
		public function TemplateContainer() {
			build();
		}
		//=========================================================================
    //  Properties
    //=========================================================================
		private var loader:Loader;
		private var template:ITemplate;
		private var editor1:TextEditor;
		private var editor2:TextEditor;
		private var defaultHead:Bitmap;
		private var loadedHeads:Array;
		public function get templateContent():DisplayObject {
			return getChildAt(0);
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
      
      if (loadedHeads[index] is DisplayObject) {
        if (loadedHeads[index] is ITemplate) {
          showTemplate(loadedHeads[index]);
        } else {
          showDefaultHead();
        }
        
        dispatchComplete();
      } else {
        loader = createLoader();
        loader.load(new URLRequest(url), new LoaderContext(false, ApplicationDomain.currentDomain));
      }
      _currTemplateIndex = index;
      dispatchEvent(new Event(Event.CHANGE));
		}
		/**
		 * 变换模板
		 * @param	event
		 */
		public function changeTemplate(to:int = 0):void {
      if (to < 0) {
        to = _templateDataModel.length;
      } else if (to > _templateDataModel.length) {
        to = 0;
      }
      if (to == 0) {
        loadDefaultTemplate();
      } else {
        loadTemplate(to, _templateDataModel.getTemplateSrc(to - 1));
      }
		}
    public function loadDefaultTemplate():void {
      loadTemplate(0, TemplateDataModel.DEFAULT_HEAD);
    }
    //=========================================================================
    //  Private Functions
    //=========================================================================
		private function build():void {
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
    private function showTemplate(content:ITemplate):void {
      template = content;
      editor1.init(template.getTextField(1));
      addChild(editor1);
      editor2.init(template.getTextField(2));
      addChild(editor2);
      addChildAt(template.self, 0);
    }
    private function showDefaultHead(content:Bitmap = null):void {
      defaultHead = defaultHead || content;
      if (contains(editor1)) {
        removeChild(editor1);
      }
      if (contains(editor2)) {
        removeChild(editor2);
      }
      addChildAt(defaultHead, 0);
    }
		private function dispatchComplete():void {
			dispatchEvent(new TemplateEvent(TemplateEvent.TEMPLATE_LOAD_COMPLETE, _currTemplateIndex));
		}
    //=========================================================================
    //  Event Handlers
    //=========================================================================
		private function loader_completeHandler(event:Event):void {
      if (loader.content is ITemplate) {
        showTemplate(ITemplate(loader.content));
      } else {
        showDefaultHead(Bitmap(loader.content));
      }
      loadedHeads[_currTemplateIndex] = loader.content;
			
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loader_completeHandler);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loader_progressHandler);
			loader = null;
			
			dispatchComplete();
		}
		private function loader_progressHandler(event:ProgressEvent):void {
			dispatchEvent(event);
		}
		private function loader_errorHandler(event:IOErrorEvent):void {
      trace('load template error');
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
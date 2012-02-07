package com.meathill.bannerFactory.view {
  import com.greensock.TweenLite;
  import flash.display.Bitmap;
  import flash.display.Loader;
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.events.MouseEvent;
  import flash.events.ProgressEvent;
  import flash.net.URLRequest;
  import flash.text.TextField;
  import flash.text.TextFormat;
  import flash.text.TextFormatAlign;
	
	/**
	 * 模板缩略图
	 * @author Meathill
	 */
	public class TemplateThumb extends Sprite	{
    //=========================================================================
    //  Class Constants
    //=========================================================================
		public static const WIDTH:int = 160;
		public static const HEIGHT:int = 60;
		//=========================================================================
    //  Constructor
    //=========================================================================
		public function TemplateThumb(src:String, n:String) {
      build(src, n);
		}
    //=========================================================================
    //  Properties
    //=========================================================================
		private var loader:Loader;
		private var bg:Shape;
		private var label:TextField;
		private var url:URLRequest;
		private var templateName:String;
    //=========================================================================
    //  Public Methods
    //=========================================================================
		public function load():void {
			loader.load(url);
		}
    //=========================================================================
    //  Private Functions
    //=========================================================================
    private function build(src:String, n:String):void {
      bg = createBG();
			
			label = createLabel();
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_completeHandler);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loader_progressHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
			
			url = new URLRequest(src);
			templateName = n;
      
			buttonMode = true;
			mouseChildren = false;
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
    }
    private function createBG():Shape {
      var shape:Shape = new Shape();
      shape.graphics.beginFill(0xCCCCCC);
      shape.graphics.drawRect(0, 0, WIDTH, HEIGHT);
      shape.graphics.endFill();
      addChild(shape);
      return shape;
    }
    private function createLabel():TextField {
      var tf:TextFormat = new TextFormat(null, 12, 0x000000, null, null, null, null, null, TextFormatAlign.CENTER);
      var txt:TextField = new TextField();
      txt.y = 9;
      txt.width = WIDTH;
      txt.defaultTextFormat = tf;
      txt.text = '等待加载图片';
      addChild(txt);
      return txt;
    }
		private function addPic():void {
			var bmp:Bitmap = Bitmap(loader.content);
			bmp.alpha = 0;
			addChildAt(bmp, 1);
			label.text = templateName;
			TweenLite.to(bmp, .3, { alpha:1 } );
			TweenLite.to(label, .3, { y:bmp.height + 2 } );
			
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loader_completeHandler);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loader_progressHandler);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
			loader = null;
		}
    //=========================================================================
    //  Event Handlers
    //=========================================================================
		private function loader_completeHandler(event:Event):void {
			TweenLite.to(bg, .3, { height:loader.height, onComplete:addPic } );
			
			dispatchEvent(event);
		}
		private function loader_progressHandler(event:ProgressEvent):void {
			label.text = Math.round(event.bytesLoaded / event.bytesTotal * 100).toString() + '% 已加载';
		}
		private function loader_errorHandler(event:IOErrorEvent):void {
			label.text = '加载图片失败';
		}
		private function rollOverHandler(event:MouseEvent):void {
			graphics.clear();
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect( -2, -2, WIDTH + 4, HEIGHT + 4);
			graphics.endFill();
		}
		private function rollOutHandler(event:MouseEvent):void {
			graphics.clear();
		}
	}
}
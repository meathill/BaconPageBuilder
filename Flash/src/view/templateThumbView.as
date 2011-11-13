package src.view 
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	/**
	 * 模板列表
	 * @author Meathill
	 */
	public class templateThumbView extends Sprite
	{
		private static const _WIDTH:int = 160;
		private static const _HEIGHT:int = 60;
		
		private var _loader:Loader;
		private var _bg:Shape;
		private var _txt:TextField;
		private var _url:URLRequest;
		private var _name:String;
		
		public function templateThumbView(str:String, n:String) 
		{
			_bg = getChildAt(0) as Shape;
			
			_txt = getChildAt(1) as TextField;
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadFailed);
			
			_url = new URLRequest(str);
			_name = n;
			buttonMode = true;
			mouseChildren = false;
			
			addEventListener(MouseEvent.ROLL_OVER, mouseOnHandler);
			addEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
		}
		
		/************
		 * functions
		 * *********/
		private function loadComplete(evt:Event):void {
			TweenLite.to(_bg, .3, { height:_loader.height, onComplete:addPic } );
			
			dispatchEvent(evt);
		}
		private function progressHandler(evt:ProgressEvent):void {
			_txt.text = Math.round(evt.bytesLoaded / evt.bytesTotal * 100).toString() + '%';
		}
		private function loadFailed(evt:IOErrorEvent):void {
			_txt.text = '加载图片失败';
		}
		private function addPic():void {
			var _bmp:Bitmap = Bitmap(_loader.content);
			_bmp.alpha = 0;
			addChildAt(_bmp, 1);
			_txt.text = _name;
			TweenLite.to(_bmp, .3, { alpha:1 } );
			TweenLite.to(_txt, .3, { y:40 } );
			
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComplete);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadFailed);
			_loader = null;
		}
		private function mouseOnHandler(evt:MouseEvent):void {
			graphics.clear();
			graphics.beginFill(0xcccccc);
			graphics.drawRect( -2, -2, _WIDTH + 4, _HEIGHT + 4);
			graphics.endFill();
		}
		private function mouseOutHandler(evt:MouseEvent):void {
			graphics.clear();
		}
		
		/************
		 * methods
		 * *********/
		public function load():void {
			_loader.load(_url);
		}
	}
}
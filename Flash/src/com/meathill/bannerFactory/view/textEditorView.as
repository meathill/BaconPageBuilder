package src.view 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	/**
	 * 控制文本框
	 * 装饰器模式
	 * @author Meathill
	 */
	public class textEditorView extends Sprite
	{
		private var _frame:Shape;
		private var _txt:TextField;
		private var _rec:String = '';
		
		public function textEditorView(txt:TextField = null) 
		{
			_frame = new Shape();
			
			if (txt != null) {
				init(txt);
			}
		}
		
		/*************
		 * properties
		 * **********/
		public function get text():String {
			return _txt.text;
		}
		
		/*************
		 * functions
		 * **********/
		private function textChangeHandler(evt:Event):void {
			_rec = _txt.text;
			
			var _evt:Event = new Event(Event.CHANGE);
			dispatchEvent(_evt);
		}
		private function mouseOnHandler(evt:MouseEvent):void {
			addChild(_frame);
		}
		private function mouseOutHandler(evt:MouseEvent):void {
			removeChild(_frame);
		}
		
		/*************
		 * methods
		 * **********/
		public function init(txt:TextField):void {
			if (_txt != null) {
				_txt.removeEventListener(Event.CHANGE, textChangeHandler);
				_txt.removeEventListener(MouseEvent.ROLL_OVER, mouseOnHandler);
				_txt.removeEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
			}
			
			x = txt.x;
			y = txt.y;
			_txt = txt;
			_txt.addEventListener(Event.CHANGE, textChangeHandler);
			_txt.addEventListener(MouseEvent.ROLL_OVER, mouseOnHandler);
			_txt.addEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
			//_txt.addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
			
			//画一个框把输入文本框框起来
			_frame.graphics.clear();
			_frame.graphics.lineStyle(2, 0xcc0000);
			_frame.graphics.drawRect( -2, 0, txt.width + 4, txt.height);
			
			// 将文本框设置为可写
			txt.type = TextFieldType.INPUT;
			
			// 如果修改过文字，则把文字赋给新文本框
			if (_rec) {
				_txt.text = _rec;
			}
		}
	}
}
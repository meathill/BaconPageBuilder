package com.meathill.bannerFactory.view {
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.text.TextField;
  import flash.text.TextFieldType;
	
	/**
	 * 控制文本框
	 * @author Meathill
	 */
	public class TextEditor extends Sprite {
		//=========================================================================
    //  Constructor
    //=========================================================================
		public function TextEditor() {
			frame = new Shape();
		}
		//=========================================================================
    //  Properties
    //=========================================================================
		private var frame:Shape;
		private var record:String = '';
		private var textField:TextField;
		public function get text():String {
			return textField.text;
		}
		//=========================================================================
    //  Public Methods
    //=========================================================================
		public function init(txt:TextField):void {
			if (textField != null) {
				textField.removeEventListener(Event.CHANGE, changeHandler);
				textField.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
				textField.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			}
			
			x = txt.x;
			y = txt.y;
			textField = txt;
			textField.addEventListener(Event.CHANGE, changeHandler);
			textField.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			textField.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			
			//画一个框把输入文本框框起来
			frame.graphics.clear();
			frame.graphics.lineStyle(2, 0xcc0000);
			frame.graphics.drawRect( -2, 0, textField.width + 4, textField.height);
			
			// 将文本框设置为可写
			textField.type = TextFieldType.INPUT;
			
			// 如果修改过文字，则把文字赋给新文本框
			if (record != '') {
				textField.text = record;
			}
		}
		//=========================================================================
    //  Event Handlers
    //=========================================================================
		private function changeHandler(event:Event):void {
			record = textField.text;
		}
		private function rollOverHandler(event:MouseEvent):void {
			addChild(frame);
		}
		private function rollOutHandler(event:MouseEvent):void {
			removeChild(frame);
		}
	}
}
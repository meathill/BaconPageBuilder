package src.view.template 
{
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.text.TextField;
	
	/**
	 * 模板接口
	 * @author Meathill
	 */
	public interface ITemplate extends IEventDispatcher
	{
		function set title1(str:String):void;
		function set title2(str:String):void;
		function get h():int;
		function get self():Sprite;
		function getTextField(num:int):TextField;
	}
	
}
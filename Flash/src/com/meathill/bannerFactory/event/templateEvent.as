package src.event 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Meathill
	 */
	public class templateEvent extends Event 
	{
		public static const TEMPLATE_LOAD_COMPLETE:String = 'template_load_complete';
		public static const TEMPLATE_LOAD_FAILED:String = 'template_load_failed';
		
		private var _index:int = -1;
		private var _msg:String = '';
		
		public function templateEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		/***********
		 * propeties
		 * ********/
		public function set index(num:int):void {
			_index = num;
		}
		public function get index():int {
			return _index;
		}
		public function set msg(str:String):void {
			_msg = str;
		}
		public function get msg():String {
			return _msg;
		}
		
		public override function clone():Event 
		{ 
			return new templateEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("templateEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}
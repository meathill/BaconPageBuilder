package src.event 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Meathill
	 */
	public class toolbarEvent extends Event 
	{
		public static const PREV_TEMPLATE:String = "prev_template";
		public static const NEXT_TEMPLATE:String = "next_template";
		public static const CHANGE_TEMPLATE:String = "change_template";
		public static const SUBMIT:String = "submit";
		public static const SHOW_LIST:String = "show_list";
		public static const LOCAL_UPLOAD:String = 'local_upload';
		
		private var _index:int = 0;
		
		public function toolbarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		/************
		 * properties
		 * *********/
		public function set index(num:int):void {
			_index = num;
		}
		public function get index():int {
			return _index;
		}
		
		/************
		 * methods
		 * *********/
		public override function clone():Event { 
			var _evt:toolbarEvent = new toolbarEvent(type, bubbles, cancelable);
			_evt.index = _index;
			return _evt;
		}
		public override function toString():String { 
			return formatToString("toolbarEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	}
}
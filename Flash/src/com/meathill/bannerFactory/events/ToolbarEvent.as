package com.meathill.bannerFactory.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Meathill
	 */
	public class ToolbarEvent extends Event {
    //=========================================================================
    //  Class Constants
    //=========================================================================
		public static const PREV_TEMPLATE:String = "prevTemplate";
		public static const NEXT_TEMPLATE:String = "nextTemplate";
		public static const CHANGE_TEMPLATE:String = "changeTemplate";
		public static const SUBMIT:String = "submit";
		public static const SHOW_LIST:String = "showList";
		public static const LOCAL_UPLOAD:String = 'localUpload';
		//=========================================================================
    //  Constructor
    //=========================================================================
		public function ToolbarEvent(type:String, index:int = -1) { 
      _index = index;
			super(type);
		} 
		//=========================================================================
    //  Properties
    //=========================================================================
		private var _index:int = 0;
		public function get index():int {
			return _index;
		}
	}
}
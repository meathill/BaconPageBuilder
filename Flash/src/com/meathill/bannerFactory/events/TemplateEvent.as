package com.meathill.bannerFactory.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Meathill
	 */
	public class TemplateEvent extends Event {
		public static const TEMPLATE_LOAD_COMPLETE:String = 'templateLoadComplete';
		public static const TEMPLATE_LOAD_FAILED:String = 'templateLoadFailed';
		//=========================================================================
    //  Constructor
    //=========================================================================
		public function TemplateEvent(type:String, index:int = -1, msg:String = '') { 
      _index = index;
      _msg = msg;
			super(type);
		} 
		//=========================================================================
    //  Propeties
    //=========================================================================
    //---------------------------------
    //  index
    //---------------------------------
		private var _index:int = -1;
		public function get index():int {
			return _index;
		}
    //---------------------------------
    //  msg
    //---------------------------------
		private var _msg:String = '';
		public function get msg():String {
			return _msg;
		}
	}
}
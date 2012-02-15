package com.meathill.bannerFactory.view.template {
  import flash.display.Bitmap;
  import flash.display.Sprite;
  import flash.system.ApplicationDomain;
  import flash.system.Security;
  import flash.text.TextField;
	
	/**
	 * 大头模板类
	 * @author Meathill
	 */
	public class AbstractTemplate extends Sprite implements ITemplate	{
		
		public function AbstractTemplate() {
			
		}
		
		/***************
		 * properties
		 * ************/
		public function set title1(str:String):void { 
			TextField(getChildAt(2)).text = str;
		}
		public function set title2(str:String):void {
			TextField(getChildAt(1)).text = str;
		}
		public function get h():int {
			return getChildAt(0).height;
		}
		public function get self():Sprite {
			return this;
		}
		
		/**************
		 * methods
		 * ***********/
		public function getTextField(num:int):TextField {
			return TextField(getChildAt(num));
		}
	}

}
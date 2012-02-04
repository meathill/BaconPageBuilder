package src.view 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import lib.component.grid.gridBasicView;
	import src.event.toolbarEvent;
	import src.model.templateDataModel;
	
	/**
	 * ...
	 * @author Meathill
	 */
	public class templateThumbListView extends gridBasicView
	{
		private var _data:templateDataModel;
		
		public function templateThumbListView(container:DisplayObjectContainer, _x:int, _y:int) 
		{
			super(container, _x, _y);
		}
		
		/*************
		 * properties
		 * **********/
		public function set data(obj:templateDataModel):void {
			_data = obj;
			
			setSize(940, _data.height - 65);
			col = 5;
			space = 5;
			bgAlpha = .5;
			itemWidth = 160;
			itemHeight = 60;
		}
		
		/*************
		 * functions
		 * **********/
		private function loadThumb(evt:Event):void {
			var _thumb:templateThumbView = templateThumbView(evt.target);
			_thumb.removeEventListener(Event.COMPLETE, loadThumb);
			var _index:int = getItemIndex(_thumb);
			if (_index < length - 1) {
				templateThumbView(getItemAt(_index + 1)).load();
			}
		}
		
		/**************
		 * methods
		 * ***********/
		public function showThumbList():void {
			for (var i:int = 0, len:int = _data.length; i < len; i += 1) {
				var _thumb:templateThumbView = new templateThumbView(_data.getTemplateThumb(i), _data.getTempalteName(i));
				_thumb.addEventListener(Event.COMPLETE, loadThumb);
				_thumb.addEventListener(MouseEvent.CLICK, changeTemplate);
				addItem(_thumb);
			}
			templateThumbView(getItemAt(0)).load();
		}
		public function changeTemplate(evt:MouseEvent):void {
			var _evt:toolbarEvent = new toolbarEvent(toolbarEvent.CHANGE_TEMPLATE);
			_evt.index = getItemIndex(templateThumbView(evt.target));
			dispatchEvent(_evt);
		}
	}
}
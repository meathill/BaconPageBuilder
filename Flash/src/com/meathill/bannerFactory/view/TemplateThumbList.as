package com.meathill.bannerFactory.view {
  import com.meathill.bannerFactory.events.ToolbarEvent;
  import com.meathill.bannerFactory.model.TemplateDataModel;
  import flash.display.DisplayObjectContainer;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import lib.component.grid.gridBasicView;
	
	/**
	 * ...
	 * @author Meathill
	 */
	public class TemplateThumbList extends gridBasicView {
		//=========================================================================
    //  Constructor
    //=========================================================================
		public function TemplateThumbList(container:DisplayObjectContainer, _x:int, _y:int) {
			super(container, _x, _y);
		}
		//=========================================================================
    //  Properties
    //=========================================================================
		//---------------------------------
    //  templateDataModel
    //---------------------------------
		private var _templateDataModel:TemplateDataModel;
		public function set templateDataModel(value:TemplateDataModel):void {
			_templateDataModel = value;
			
			setSize(940, _data.height - 65);
			col = 5;
			space = 5;
			bgAlpha = .5;
			itemWidth = 160;
			itemHeight = 60;
		}
		//=========================================================================
    //  Public Methods
    //=========================================================================
		public function showThumbList():void {
			for (var i:int = 0, len:int = _templateDataModel.length; i < len; i += 1) {
				var _thumb:TemplateThumb = new TemplateThumb(_templateDataModel.getTemplateThumb(i), _templateDataModel.getTempalteName(i));
				_thumb.addEventListener(Event.COMPLETE, thumb_complateHandler);
				_thumb.addEventListener(MouseEvent.CLICK, thumb_clickHandler);
				addItem(_thumb);
			}
			TemplateThumb(getItemAt(0)).load();
		}
    //=========================================================================
    //  Private Functions
    //=========================================================================
		//=========================================================================
    //  Event Handlers
    //=========================================================================
		private function thumb_complateHandler(event:Event):void {
			var _thumb:TemplateThumb = TemplateThumb(event.target);
			_thumb.removeEventListener(Event.COMPLETE, thumb_complateHandler);
			var _index:int = getItemIndex(_thumb);
			if (_index < length - 1) {
				TemplateThumb(getItemAt(_index + 1)).load();
			}
		}
		public function thumb_clickHandler(event:MouseEvent):void {
			dispatchEvent(new ToolbarEvent(ToolbarEvent.CHANGE_TEMPLATE, getItemIndex(TemplateThumb(event.target))));
		}
	}
}
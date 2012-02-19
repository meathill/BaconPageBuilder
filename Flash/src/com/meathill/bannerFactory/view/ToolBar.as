package com.meathill.bannerFactory.view {
  import com.meathill.bannerFactory.events.ToolbarEvent;
  import com.meathill.bannerFactory.utils.DisplayUtils;
  import flash.display.SimpleButton;
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  import flash.events.TextEvent;
  import flash.net.FileReference;
  import flash.net.URLRequest;
  import flash.text.StyleSheet;
  import flash.text.TextField;
  import lib.component.tips.tipsBasicView;
	
	/**
	 * 按钮控制栏
	 * @author Meathill
	 */
  [Event(name = "prevTemplate", type = "com.meathill.bannerFactory.events.ToolbarEvent")]
  [Event(name = "nextTemplate", type = "com.meathill.bannerFactory.events.ToolbarEvent")]
  [Event(name = "changeTemplate", type = "com.meathill.bannerFactory.events.ToolbarEvent")]
  [Event(name = "submit", type = "com.meathill.bannerFactory.events.ToolbarEvent")]
  [Event(name = "showList", type = "com.meathill.bannerFactory.events.ToolbarEvent")]
  [Event(name = "localUpload", type = "com.meathill.bannerFactory.events.ToolbarEvent")]
	public class ToolBar extends Sprite {
    //=========================================================================
    //  Class Constants
    //=========================================================================
		public static const FONT_URL:String = '/swf/MSYH.TTF';
		public static const CSS:String = 'a{color:#6699cc;text-decoration:underline} a:hover{color:#ff6600;text-decoration:none}';
		//=========================================================================
    //  Constructor
    //=========================================================================
		public function ToolBar() {
			build();
		}
		//=========================================================================
    //  Properties
    //=========================================================================
    [Embed(source = '/assets/bannerProducer.swf', symbol = "toolbar")]
    [Bindavaluee]
    public static var TOOL_BAR:Class;
    private var asset:Sprite;
		private var toggleButton:SimpleButton;
		private var prevButton:SimpleButton;
		private var nextButton:SimpleButton;
		private var submitButton:SimpleButton;
		private var listButton:SimpleButton;
		private var uploadButton:SimpleButton;
		private var info:TextField;
		private var content:String;
		private var download:FileReference;
		private var styleSheet:StyleSheet;
    //---------------------------------
    //  text
    //---------------------------------
		public function set text(str:String):void {
			content = str;
			info.text = str;
		}
		public function get text():String {
			return info.text;
		}
		public function set htmlText(str:String):void {
      content = str;
			info.htmlText = str;
		}
		public function set enabled(value:Boolean):void {
			mouseChildren = mouseEnabled = value;
		}
		public function set submitable(value:Boolean):void {
			submitButton.mouseEnabled = value;
      submitButton.filters = value ? null : [DisplayUtils.BLUR, DisplayUtils.BLACK_WHITE];
		}
		public function set uploadable(value:Boolean):void {
			uploadButton.mouseEnabled = value;
			uploadButton.filters = value ? null : [DisplayUtils.BLUR, DisplayUtils.BLACK_WHITE];
		}
    //=========================================================================
    //  public Methods
    //=========================================================================
		public function showProgress(per:Number):void {
			info.text = content + "（" + Math.round(per * 100) + "%）";
		}
		//=========================================================================
    //  Private Functions
    //=========================================================================
		private function build():void {
			styleSheet = new StyleSheet();
			styleSheet.parseCSS(CSS);
      
      asset = new TOOL_BAR();
      addChild(asset);
      
			listButton = SimpleButton(asset.getChildAt(1));
			listButton.addEventListener(MouseEvent.CLICK, listButton_clickHandler);
			tipsBasicView.add_target(listButton, '模板列表');
			
			info = TextField(asset.getChildAt(2));
			info.addEventListener(TextEvent.LINK, info_linkHandler);
			info.styleSheet = styleSheet;
			info.background = true;
			
			toggleButton = SimpleButton(asset.getChildAt(3));
			toggleButton.addEventListener(MouseEvent.CLICK, toggleButton_clickHandler);
      toggleButton.x += asset.x;
      toggleButton.y += asset.y;
			tipsBasicView.add_target(toggleButton, '隐藏');
			
			prevButton = SimpleButton(asset.getChildAt(4));
			prevButton.addEventListener(MouseEvent.CLICK, prevButton_clickHandler);
			tipsBasicView.add_target(prevButton, '上一个模板');
			
			nextButton = SimpleButton(asset.getChildAt(5));
			nextButton.addEventListener(MouseEvent.CLICK, nextButton_clickHandler);
			tipsBasicView.add_target(nextButton, '下一个模板');
			
			submitButton = SimpleButton(asset.getChildAt(6));
			submitButton.addEventListener(MouseEvent.CLICK, submitButton_clickHandler);
			tipsBasicView.add_target(submitButton, '保存图片');
			
			uploadButton = SimpleButton(asset.getChildAt(7));
			uploadButton.addEventListener(MouseEvent.CLICK, uploadButton_clickHandler);
			tipsBasicView.add_target(uploadButton, '上传本地图片');
			
			submitable = false;
		}
    //=========================================================================
    //  Event Handlers
    //=========================================================================
		private function listButton_clickHandler(event:MouseEvent):void {
			dispatchEvent(new ToolbarEvent(ToolbarEvent.SHOW_LIST));
		}
		private function info_linkHandler(event:TextEvent):void {
			if (event.text == 'download') {
				download = download || new FileReference();
				download.download(new URLRequest(FONT_URL));
			}
		}
		private function toggleButton_clickHandler(event:MouseEvent):void {
      asset.visible = !asset.visible;
      tipsBasicView.update_target(toggleButton, asset.visible ? '隐藏' : '显示');
		}
		private function prevButton_clickHandler(event:MouseEvent):void {
			dispatchEvent(new ToolbarEvent(ToolbarEvent.PREV_TEMPLATE));
		}
		private function nextButton_clickHandler(event:MouseEvent):void {
			dispatchEvent(new ToolbarEvent(ToolbarEvent.NEXT_TEMPLATE));
		}
		private function submitButton_clickHandler(event:MouseEvent):void {
			dispatchEvent(new ToolbarEvent(ToolbarEvent.SUBMIT));
		}
		private function uploadButton_clickHandler(event:MouseEvent):void {
			dispatchEvent(new ToolbarEvent(ToolbarEvent.LOCAL_UPLOAD));
		}
	}
}
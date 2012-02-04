package src.view 
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import lib.component.tips.tipsBasicView;
	import src.event.toolbarEvent;
	
	/**
	 * ...
	 * @author Meathill
	 */
	public class toolBarView extends Sprite
	{
		private const _FONT_URL:String = 'http://img2.zol-img.com.cn/article/templateDIY/images/MSYH.TTF';
		private const _CSS:String = 'a{color:#6699cc;text-decoration:underline} a:hover{color:#ff6600;text-decoration:none}';
		private const _BLUR:BlurFilter = new BlurFilter(2, 2);
		private const _BW_COLOR:ColorMatrixFilter = new ColorMatrixFilter([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0]);
		
		private var _drag_btn:SimpleButton;
		private var _prev_btn:SimpleButton;
		private var _next_btn:SimpleButton;
		private var _submit_btn:SimpleButton;
		private var _reset_btn:SimpleButton;
		private var _list_btn:SimpleButton;
		private var _upload_btn:SimpleButton;
		private var _info_txt:TextField;
		private var _info_str:String;
		private var _download:FileReference;
		private var _style:StyleSheet;
		
		public function toolBarView() 
		{
			init();
		}
		
		/*************
		 * properties
		 * **********/
		public function set text(str:String):void {
			_info_str = str;
			_info_txt.text = str;
		}
		public function get text():String {
			return _info_txt.text;
		}
		public function set htmlText(str:String):void {
			_info_txt.htmlText = str;
		}
		public function set enabled(bl:Boolean):void {
			_prev_btn.enabled = bl;
			_prev_btn.mouseEnabled = bl;
			_next_btn.enabled = bl;
			_prev_btn.mouseEnabled = bl;
			_submit_btn.enabled = bl;
			_submit_btn.mouseEnabled = bl;
			_upload_btn.enabled = bl;
			_upload_btn.mouseEnabled = bl;
		}
		public function set submitable(bl:Boolean):void {
			_submit_btn.enabled = bl;
			_submit_btn.mouseEnabled = bl;
			if (bl) {
				_submit_btn.filters = null;
			} else {
				_submit_btn.filters = [_BLUR, _BW_COLOR];
			}
		}
		public function set uploadable(bl:Boolean):void {
			_upload_btn.enabled = bl;
			_upload_btn.mouseEnabled = bl;
			if (bl) {
				_upload_btn.filters = null;
			} else {
				_upload_btn.filters = [_BLUR, _BW_COLOR];
			}
		}
		
		/*************
		 * functions
		 * **********/
		private function init():void {
			_list_btn = SimpleButton(getChildAt(1));
			_list_btn.addEventListener(MouseEvent.CLICK, showList);
			tipsBasicView.add_target(_list_btn, '模板列表');
			
			_style = new StyleSheet();
			_style.parseCSS(_CSS);
			_info_txt = TextField(getChildAt(2));
			_info_txt.addEventListener(TextEvent.LINK, downloadFont);
			_info_txt.styleSheet = _style;
			_info_txt.background = true;
			
			_drag_btn = SimpleButton(getChildAt(3));
			_drag_btn.addEventListener(MouseEvent.MOUSE_DOWN, hideHandler);
			tipsBasicView.add_target(_drag_btn, '隐藏');
			
			_prev_btn = SimpleButton(getChildAt(4));
			_prev_btn.addEventListener(MouseEvent.CLICK, prevTemplate);
			tipsBasicView.add_target(_prev_btn, '上一个模板');
			
			_next_btn = SimpleButton(getChildAt(5));
			_next_btn.addEventListener(MouseEvent.CLICK, nextTemplate);
			tipsBasicView.add_target(_next_btn, '下一个模板');
			
			_submit_btn = SimpleButton(getChildAt(6));
			_submit_btn.addEventListener(MouseEvent.CLICK, submitHandler);
			tipsBasicView.add_target(_submit_btn, '保存图片');
			
			_upload_btn = SimpleButton(getChildAt(7));
			_upload_btn.addEventListener(MouseEvent.CLICK, uploadHandler);
			tipsBasicView.add_target(_upload_btn, '上传本地图片');
			
			submitable = false;
		}
		private function hideHandler(evt:MouseEvent):void {
			if ('显示' != tipsBasicView.getTips(_drag_btn)) {
				for (var i:int = 0; i < numChildren; i += 1) {
					if (getChildAt(i) != _drag_btn) {
						getChildAt(i).visible = false;
					}
				}
				tipsBasicView.update_target(_drag_btn, '显示');
			} else {
				for (var i:int = 0; i < numChildren; i += 1) {
					getChildAt(i).visible = true;
				}
				tipsBasicView.update_target(_drag_btn, '隐藏');
			}
		}
		private function prevTemplate(evt:MouseEvent):void {
			var _evt:toolbarEvent = new toolbarEvent(toolbarEvent.PREV_TEMPLATE);
			dispatchEvent(_evt);
		}
		private function nextTemplate(evt:MouseEvent):void {
			var _evt:toolbarEvent = new toolbarEvent(toolbarEvent.NEXT_TEMPLATE);
			dispatchEvent(_evt);
		}
		private function submitHandler(evt:MouseEvent):void {
			var _evt:toolbarEvent = new toolbarEvent(toolbarEvent.SUBMIT);
			dispatchEvent(_evt);
		}
		private function downloadFont(evt:TextEvent):void {
			if (evt.text == 'download') {
				if (_download == null) {
					_download = new FileReference();
				}
				_download.download(new URLRequest(_FONT_URL));
			}
		}
		private function showList(evt:MouseEvent):void {
			var _evt:toolbarEvent = new toolbarEvent(toolbarEvent.SHOW_LIST);
			dispatchEvent(_evt);
		}
		private function uploadHandler(evt:MouseEvent):void {
			var _evt:toolbarEvent = new toolbarEvent(toolbarEvent.LOCAL_UPLOAD);
			dispatchEvent(_evt);
		}
		
		/*************
		 * methods
		 * **********/
		public function showProgress(per:Number):void {
			_info_txt.text = _info_str + "（" + Math.round(per * 100) + "%）";
		}
	}
}
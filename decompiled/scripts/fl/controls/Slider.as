package fl.controls
{
   import fl.core.*;
   import fl.events.*;
   import fl.managers.*;
   import flash.display.*;
   import flash.events.*;
   import flash.ui.*;
   
   public class Slider extends UIComponent implements IFocusManagerComponent
   {
      
      protected static var defaultStyles:Object = {
         "thumbUpSkin":"SliderThumb_upSkin",
         "thumbOverSkin":"SliderThumb_overSkin",
         "thumbDownSkin":"SliderThumb_downSkin",
         "thumbDisabledSkin":"SliderThumb_disabledSkin",
         "sliderTrackSkin":"SliderTrack_skin",
         "sliderTrackDisabledSkin":"SliderTrack_disabledSkin",
         "tickSkin":"SliderTick_skin",
         "focusRectSkin":null,
         "focusRectPadding":null
      };
      
      protected static const TRACK_STYLES:Object = {
         "upSkin":"sliderTrackSkin",
         "overSkin":"sliderTrackSkin",
         "downSkin":"sliderTrackSkin",
         "disabledSkin":"sliderTrackDisabledSkin"
      };
      
      protected static const THUMB_STYLES:Object = {
         "upSkin":"thumbUpSkin",
         "overSkin":"thumbOverSkin",
         "downSkin":"thumbDownSkin",
         "disabledSkin":"thumbDisabledSkin"
      };
      
      protected static const TICK_STYLES:Object = {"upSkin":"tickSkin"};
      
      protected var _direction:String = SliderDirection.HORIZONTAL;
      
      protected var _minimum:Number = 0;
      
      protected var _maximum:Number = 10;
      
      protected var _value:Number = 0;
      
      protected var _tickInterval:Number = 0;
      
      protected var _snapInterval:Number = 0;
      
      protected var _liveDragging:Boolean = false;
      
      protected var tickContainer:Sprite;
      
      protected var thumb:BaseButton;
      
      protected var track:BaseButton;
      
      public function Slider()
      {
         super();
         this.setStyles();
      }
      
      public static function getStyleDefinition() : Object
      {
         return defaultStyles;
      }
      
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function set direction(param1:String) : void
      {
         this._direction = param1;
         var _loc2_:Boolean = this._direction == SliderDirection.VERTICAL;
         if(isLivePreview)
         {
            if(_loc2_)
            {
               setScaleY(-1);
               y = this.track.height;
            }
            else
            {
               setScaleY(1);
               y = 0;
            }
            this.positionThumb();
            return;
         }
         if(_loc2_ && componentInspectorSetting)
         {
            if(rotation % 90 == 0)
            {
               setScaleY(-1);
            }
         }
         if(!componentInspectorSetting)
         {
            rotation = _loc2_ ? 90 : 0;
         }
      }
      
      public function get minimum() : Number
      {
         return this._minimum;
      }
      
      public function set minimum(param1:Number) : void
      {
         this._minimum = param1;
         this.value = Math.max(param1,this.value);
         invalidate(InvalidationType.DATA);
      }
      
      public function get maximum() : Number
      {
         return this._maximum;
      }
      
      public function set maximum(param1:Number) : void
      {
         this._maximum = param1;
         this.value = Math.min(param1,this.value);
         invalidate(InvalidationType.DATA);
      }
      
      public function get tickInterval() : Number
      {
         return this._tickInterval;
      }
      
      public function set tickInterval(param1:Number) : void
      {
         this._tickInterval = param1;
         invalidate(InvalidationType.SIZE);
      }
      
      public function get snapInterval() : Number
      {
         return this._snapInterval;
      }
      
      public function set snapInterval(param1:Number) : void
      {
         this._snapInterval = param1;
      }
      
      public function set liveDragging(param1:Boolean) : void
      {
         this._liveDragging = param1;
      }
      
      public function get liveDragging() : Boolean
      {
         return this._liveDragging;
      }
      
      override public function get enabled() : Boolean
      {
         return super.enabled;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         if(this.enabled == param1)
         {
            return;
         }
         super.enabled = param1;
         this.track.enabled = this.thumb.enabled = param1;
      }
      
      override public function setSize(param1:Number, param2:Number) : void
      {
         if(this._direction == SliderDirection.VERTICAL && !isLivePreview)
         {
            super.setSize(param2,param1);
         }
         else
         {
            super.setSize(param1,param2);
         }
         invalidate(InvalidationType.SIZE);
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      public function set value(param1:Number) : void
      {
         this.doSetValue(param1);
      }
      
      protected function doSetValue(param1:Number, param2:String = null, param3:String = null, param4:int = undefined) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = this._value;
         if(this._snapInterval != 0 && this._snapInterval != 1)
         {
            _loc5_ = Math.pow(10,this.getPrecision(this.snapInterval));
            _loc6_ = this._snapInterval * _loc5_;
            _loc7_ = Math.round(param1 * _loc5_);
            _loc8_ = Math.round(_loc7_ / _loc6_) * _loc6_;
            param1 = _loc8_ / _loc5_;
            this._value = Math.max(this.minimum,Math.min(this.maximum,param1));
         }
         else
         {
            this._value = Math.max(this.minimum,Math.min(this.maximum,Math.round(param1)));
         }
         if(_loc9_ != this._value && (this.liveDragging && param3 != null || param2 == InteractionInputType.KEYBOARD))
         {
            dispatchEvent(new SliderEvent(SliderEvent.CHANGE,this.value,param3,param2,param4));
         }
         this.positionThumb();
      }
      
      protected function setStyles() : void
      {
         copyStylesToChild(this.thumb,THUMB_STYLES);
         copyStylesToChild(this.track,TRACK_STYLES);
      }
      
      override protected function draw() : void
      {
         if(isInvalid(InvalidationType.STYLES))
         {
            this.setStyles();
            invalidate(InvalidationType.SIZE,false);
         }
         if(isInvalid(InvalidationType.SIZE))
         {
            this.track.setSize(_width,this.track.height);
            this.track.drawNow();
            this.thumb.drawNow();
         }
         if(this.tickInterval > 0)
         {
            this.drawTicks();
         }
         else
         {
            this.clearTicks();
         }
         this.positionThumb();
         super.draw();
      }
      
      protected function positionThumb() : void
      {
         this.thumb.x = (this._direction == SliderDirection.VERTICAL ? this.maximum - this.value : this.value - this.minimum) / (this.maximum - this.minimum) * _width;
      }
      
      protected function drawTicks() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc5_:uint = 0;
         this.clearTicks();
         this.tickContainer = new Sprite();
         var _loc2_:Number = this.maximum < 1 ? this.tickInterval / 100 : this.tickInterval;
         var _loc3_:Number = (this.maximum - this.minimum) / _loc2_;
         var _loc4_:Number = _width / _loc3_;
         while(_loc5_ <= _loc3_)
         {
            _loc1_ = getDisplayObjectInstance(getStyleValue("tickSkin"));
            _loc1_.x = _loc4_ * _loc5_;
            _loc1_.y = this.track.y - _loc1_.height - 2;
            this.tickContainer.addChild(_loc1_);
            _loc5_++;
         }
         addChild(this.tickContainer);
      }
      
      protected function clearTicks() : void
      {
         if(!this.tickContainer || !this.tickContainer.parent)
         {
            return;
         }
         removeChild(this.tickContainer);
      }
      
      protected function calculateValue(param1:Number, param2:String, param3:String, param4:int = undefined) : void
      {
         var _loc5_:Number = param1 / _width * (this.maximum - this.minimum);
         if(this._direction == SliderDirection.VERTICAL)
         {
            _loc5_ = this.maximum - _loc5_;
         }
         else
         {
            _loc5_ = this.minimum + _loc5_;
         }
         this.doSetValue(_loc5_,param2,param3,param4);
      }
      
      protected function doDrag(param1:MouseEvent) : void
      {
         var _loc2_:Number = _width / this.snapInterval;
         var _loc3_:Number = this.track.mouseX;
         this.calculateValue(_loc3_,InteractionInputType.MOUSE,SliderEventClickTarget.THUMB);
         dispatchEvent(new SliderEvent(SliderEvent.THUMB_DRAG,this.value,SliderEventClickTarget.THUMB,InteractionInputType.MOUSE));
      }
      
      protected function thumbPressHandler(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObjectContainer = focusManager.form;
         _loc2_.addEventListener(MouseEvent.MOUSE_MOVE,this.doDrag,false,0,true);
         _loc2_.addEventListener(MouseEvent.MOUSE_UP,this.thumbReleaseHandler,false,0,true);
         dispatchEvent(new SliderEvent(SliderEvent.THUMB_PRESS,this.value,SliderEventClickTarget.THUMB,InteractionInputType.MOUSE));
      }
      
      protected function thumbReleaseHandler(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObjectContainer = focusManager.form;
         _loc2_.removeEventListener(MouseEvent.MOUSE_MOVE,this.doDrag);
         _loc2_.removeEventListener(MouseEvent.MOUSE_UP,this.thumbReleaseHandler);
         dispatchEvent(new SliderEvent(SliderEvent.THUMB_RELEASE,this.value,SliderEventClickTarget.THUMB,InteractionInputType.MOUSE));
         dispatchEvent(new SliderEvent(SliderEvent.CHANGE,this.value,SliderEventClickTarget.THUMB,InteractionInputType.MOUSE));
      }
      
      protected function onTrackClick(param1:MouseEvent) : void
      {
         this.calculateValue(this.track.mouseX,InteractionInputType.MOUSE,SliderEventClickTarget.TRACK);
         if(!this.liveDragging)
         {
            dispatchEvent(new SliderEvent(SliderEvent.CHANGE,this.value,SliderEventClickTarget.TRACK,InteractionInputType.MOUSE));
         }
      }
      
      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:Number = NaN;
         if(!this.enabled)
         {
            return;
         }
         var _loc3_:Number = this.snapInterval > 0 ? this.snapInterval : 1;
         var _loc4_:Boolean = this.direction == SliderDirection.HORIZONTAL;
         if(param1.keyCode == Keyboard.DOWN && !_loc4_ || param1.keyCode == Keyboard.LEFT && _loc4_)
         {
            _loc2_ = this.value - _loc3_;
         }
         else if(param1.keyCode == Keyboard.UP && !_loc4_ || param1.keyCode == Keyboard.RIGHT && _loc4_)
         {
            _loc2_ = this.value + _loc3_;
         }
         else if(param1.keyCode == Keyboard.PAGE_DOWN && !_loc4_ || param1.keyCode == Keyboard.HOME && _loc4_)
         {
            _loc2_ = this.minimum;
         }
         else if(param1.keyCode == Keyboard.PAGE_UP && !_loc4_ || param1.keyCode == Keyboard.END && _loc4_)
         {
            _loc2_ = this.maximum;
         }
         if(!isNaN(_loc2_))
         {
            param1.stopPropagation();
            this.doSetValue(_loc2_,InteractionInputType.KEYBOARD,null,param1.keyCode);
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.thumb = new BaseButton();
         this.thumb.setSize(13,13);
         this.thumb.autoRepeat = false;
         addChild(this.thumb);
         this.thumb.addEventListener(MouseEvent.MOUSE_DOWN,this.thumbPressHandler,false,0,true);
         this.track = new BaseButton();
         this.track.move(0,0);
         this.track.setSize(80,4);
         this.track.autoRepeat = false;
         this.track.useHandCursor = false;
         this.track.addEventListener(MouseEvent.CLICK,this.onTrackClick,false,0,true);
         addChildAt(this.track,0);
      }
      
      protected function getPrecision(param1:Number) : Number
      {
         var _loc2_:String = param1.toString();
         if(_loc2_.indexOf(".") == -1)
         {
            return 0;
         }
         return _loc2_.split(".").pop().length;
      }
   }
}


package fl.events
{
   import flash.events.Event;
   
   public class SliderEvent extends Event
   {
      
      public static const CHANGE:String = "change";
      
      public static const THUMB_DRAG:String = "thumbDrag";
      
      public static const THUMB_PRESS:String = "thumbPress";
      
      public static const THUMB_RELEASE:String = "thumbRelease";
      
      protected var _triggerEvent:String;
      
      protected var _value:Number;
      
      protected var _keyCode:Number;
      
      protected var _clickTarget:String;
      
      public function SliderEvent(param1:String, param2:Number, param3:String, param4:String, param5:int = 0)
      {
         this._value = param2;
         this._keyCode = param5;
         this._triggerEvent = param4;
         this._clickTarget = param3;
         super(param1);
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      public function get keyCode() : Number
      {
         return this._keyCode;
      }
      
      public function get triggerEvent() : String
      {
         return this._triggerEvent;
      }
      
      public function get clickTarget() : String
      {
         return this._clickTarget;
      }
      
      override public function toString() : String
      {
         return formatToString("SliderEvent","type","value","bubbles","cancelable","keyCode","triggerEvent","clickTarget");
      }
      
      override public function clone() : Event
      {
         return new SliderEvent(type,this._value,this._clickTarget,this._triggerEvent,this._keyCode);
      }
   }
}


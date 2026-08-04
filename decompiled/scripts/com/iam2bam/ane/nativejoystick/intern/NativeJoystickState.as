package com.iam2bam.ane.nativejoystick.intern
{
   public class NativeJoystickState
   {
      
      public var plugged:Boolean;
      
      public var axesRaw:Vector.<uint>;
      
      public var axes:Vector.<Number>;
      
      public var buttons:uint;
      
      public var povAngle:Number;
      
      public var povPressed:Number;
      
      public function NativeJoystickState()
      {
         super();
         var _loc1_:uint = 8;
         this.axesRaw = new Vector.<uint>(_loc1_,true);
         this.axes = new Vector.<Number>(_loc1_,true);
         this.reset(null,false);
      }
      
      public function reset(param1:NativeJoystickCaps, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc4_:uint = 8;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.axesRaw[_loc3_] = param1 == null ? 0 : uint(param1.axesRange[_loc3_] / 2);
            this.axes[_loc3_] = 0;
            _loc3_++;
         }
         this.povAngle = 0;
         this.buttons = 0;
         this.plugged = param2;
      }
   }
}


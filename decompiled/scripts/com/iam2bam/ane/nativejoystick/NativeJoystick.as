package com.iam2bam.ane.nativejoystick
{
   import com.iam2bam.ane.nativejoystick.intern.*;
   
   public class NativeJoystick
   {
      
      public static const AXIS_X:uint = 0;
      
      public static const AXIS_Y:uint = 1;
      
      public static const AXIS_Z:uint = 2;
      
      public static const AXIS_R:uint = 3;
      
      public static const AXIS_U:uint = 4;
      
      public static const AXIS_V:uint = 5;
      
      public static const AXIS_POVX:uint = 6;
      
      public static const AXIS_POVY:uint = 7;
      
      public static const AXIS_MAX:uint = 8;
      
      public static const AXIS_NAMES:Array = ["X","Y","Z","R","U","V","POVX","POVY"];
      
      public var data:NativeJoystickData;
      
      public function NativeJoystick(param1:uint)
      {
         super();
         this.data = manager.getData(param1);
      }
      
      public static function get maxJoysticks() : uint
      {
         return manager.maxJoysticks;
      }
      
      public static function isPlugged(param1:uint) : Boolean
      {
         return manager.isPlugged(param1);
      }
      
      public static function get manager() : NativeJoystickMgr
      {
         return NativeJoystickMgr.instance();
      }
      
      public function get capabilities() : NativeJoystickCaps
      {
         return this.data.caps;
      }
      
      public function get index() : uint
      {
         return this.data.index;
      }
      
      public function get numButtons() : int
      {
         return this.data.caps.numButtons;
      }
      
      public function get plugged() : Boolean
      {
         return this.data.curr.plugged;
      }
      
      public function get justPlugged() : Boolean
      {
         return this.data.curr.plugged && !this.data.prev.plugged;
      }
      
      public function get justUnplugged() : Boolean
      {
         return !this.data.curr.plugged && this.data.prev.plugged;
      }
      
      public function pressed(param1:int) : Boolean
      {
         return (this.data.curr.buttons & 1 << param1) != 0;
      }
      
      public function justPressed(param1:int) : Boolean
      {
         return (this.data.buttonsJP & 1 << param1) != 0;
      }
      
      public function justReleased(param1:int) : Boolean
      {
         return (this.data.buttonsJR & 1 << param1) != 0;
      }
      
      public function anyPressed() : Boolean
      {
         return this.data.curr.buttons != 0;
      }
      
      public function anyJustPressed() : Boolean
      {
         return this.data.buttonsJP != 0;
      }
      
      public function anyJustReleased() : Boolean
      {
         return this.data.buttonsJR != 0;
      }
      
      public function axis(param1:int) : Number
      {
         return this.data.curr.axes[param1];
      }
      
      public function axisDelta(param1:int) : Number
      {
         return this.data.curr.axes[param1] - this.data.prev.axes[param1];
      }
      
      public function hasAxis(param1:int) : Boolean
      {
         return this.data.caps.hasAxis[param1];
      }
      
      public function get povAngle() : Number
      {
         return this.data.curr.povAngle;
      }
      
      public function get povPressed() : Number
      {
         return this.data.curr.povPressed;
      }
      
      public function get x() : Number
      {
         return this.axis(0);
      }
      
      public function get y() : Number
      {
         return this.axis(1);
      }
      
      public function get z() : Number
      {
         return this.axis(2);
      }
      
      public function get r() : Number
      {
         return this.axis(3);
      }
      
      public function get u() : Number
      {
         return this.axis(4);
      }
      
      public function get v() : Number
      {
         return this.axis(5);
      }
      
      public function get povX() : Number
      {
         return this.axis(6);
      }
      
      public function get povY() : Number
      {
         return this.axis(7);
      }
   }
}


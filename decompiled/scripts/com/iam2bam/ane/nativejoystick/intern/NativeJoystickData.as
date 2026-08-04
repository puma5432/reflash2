package com.iam2bam.ane.nativejoystick.intern
{
   import com.iam2bam.ane.nativejoystick.NativeJoystick;
   
   public class NativeJoystickData
   {
      
      public var curr:NativeJoystickState;
      
      public var prev:NativeJoystickState;
      
      public var caps:NativeJoystickCaps;
      
      public var index:uint;
      
      public var detected:Boolean;
      
      public var joystick:NativeJoystick;
      
      public var buttonsJP:uint;
      
      public var buttonsJR:uint;
      
      public function NativeJoystickData(param1:uint)
      {
         super();
         this.index = param1;
         this.curr = new NativeJoystickState();
         this.prev = new NativeJoystickState();
         this.caps = new NativeJoystickCaps();
      }
   }
}


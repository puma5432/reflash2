package com.iam2bam.ane.nativejoystick.event
{
   import com.iam2bam.ane.nativejoystick.NativeJoystick;
   import flash.events.Event;
   
   public class NativeJoystickEvent extends Event
   {
      
      public static const AXIS_MOVE:String = "NJOYAxisMove";
      
      public static const BUTTON_DOWN:String = "NJOYButtonDown";
      
      public static const BUTTON_UP:String = "NJOYButtonUp";
      
      public static const JOY_PLUGGED:String = "NJOYPlugged";
      
      public static const JOY_UNPLUGGED:String = "NJOYUnplugged";
      
      public var index:int = -1;
      
      public var joystick:NativeJoystick;
      
      public var axisIndex:int = -1;
      
      public var axisValue:Number = 0;
      
      public var axisDelta:Number = 0;
      
      public var buttonIndex:int = -1;
      
      public function NativeJoystickEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}


package com.mcleodgaming.ssf2.events
{
   import com.mcleodgaming.ssf2.input.Gamepad;
   import flash.events.Event;
   
   public class GamepadEvent extends Event
   {
      
      public static var AXIS_CHANGED:String = "axisChanged";
      
      public static var BUTTON_DOWN:String = "buttonDown";
      
      public static var BUTTON_UP:String = "buttonUp";
      
      public var gamepad:Gamepad;
      
      public var controlState:Object;
      
      public function GamepadEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}


package com.mcleodgaming.ssf2.enums
{
   public class SpecialMode
   {
      
      private static var statesArr:Array;
      
      public static const MINI:uint = 1 << 0;
      
      public static const MEGA:uint = 1 << 1;
      
      public static const SLOW:uint = 1 << 2;
      
      public static const LIGHTNING:uint = 1 << 3;
      
      public static const VAMPIRE:uint = 1 << 4;
      
      public static const VENGEANCE:uint = 1 << 5;
      
      public static const FREEZE:uint = 1 << 6;
      
      public static const EGG:uint = 1 << 7;
      
      public static const DRAMATIC:uint = 1 << 8;
      
      public static const TURBO:uint = 1 << 9;
      
      public static const INVISIBLE:uint = 1 << 10;
      
      public static const METAL:uint = 1 << 11;
      
      public static const LIGHT:uint = 1 << 12;
      
      public static const HEAVY:uint = 1 << 13;
      
      public static const SSF1:uint = 1 << 14;
      
      public function SpecialMode()
      {
         super();
      }
      
      public static function init() : void
      {
         trace("Initialized SpecialMode class");
      }
      
      public static function modeEnabled(param1:uint, param2:uint) : Boolean
      {
         return Boolean((param1 & param2) > 0);
      }
      
      public static function setModeEnabled(param1:uint, param2:uint, param3:Boolean) : uint
      {
         return param3 ? uint(param1 | param2) : uint(param1 & ~param2);
      }
   }
}


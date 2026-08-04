package com.mcleodgaming.ssf2.enums
{
   public class CFreeState
   {
      
      public static const ATTACKING:uint = 1 << 0;
      
      public static const GRABBING:uint = 1 << 1;
      
      public static const SWALLOWING:uint = 1 << 2;
      
      public static const SHIELDING:uint = 1 << 3;
      
      public static const INJURED:uint = 1 << 4;
      
      public static const DISABLED:uint = 1 << 5;
      
      public static const DODGING:uint = 1 << 6;
      
      public static const GLIDING:uint = 1 << 7;
      
      public static const TURNING:uint = 1 << 8;
      
      public static const JUMP_CHAMBER:uint = 1 << 9;
      
      public static const SKIDDING:uint = 1 << 10;
      
      public static const TOSSING:uint = 1 << 11;
      
      public static const NON_IASA:uint = 1 << 12;
      
      public static const TRANSFORMING_FS:uint = 1 << 13;
      
      public static const USING_FS:uint = 1 << 14;
      
      public function CFreeState()
      {
         super();
      }
   }
}


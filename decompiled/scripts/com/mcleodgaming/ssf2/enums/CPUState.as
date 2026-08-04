package com.mcleodgaming.ssf2.enums
{
   public class CPUState
   {
      
      public static const NULL:int = -1;
      
      public static const IDLE:int = 0;
      
      public static const CHASE:int = 1;
      
      public static const EVADE:int = 2;
      
      public static const RECOVERY:int = 3;
      
      public static const INIT_ATTACK:int = 4;
      
      public static const ATTACK:int = 5;
      
      public static const INIT_SHIELD:int = 6;
      
      public static const SHIELD:int = 7;
      
      public static const INIT_GRAB:int = 8;
      
      public static const GRAB:int = 9;
      
      public static const FORCE_JUMP:int = 10;
      
      public static const FORCE_WALK:int = 11;
      
      public static const FORCE_RUN:int = 12;
      
      public static const FORCE_DO_NOTHING:int = 13;
      
      private static var statesArr:Array = new Array();
      
      statesArr.push("IDLE");
      statesArr.push("CHASE");
      statesArr.push("EVADE");
      statesArr.push("RECOVERY");
      statesArr.push("INIT_ATTACK");
      statesArr.push("ATTACK");
      statesArr.push("INIT_SHIELD");
      statesArr.push("SHIELD");
      statesArr.push("INIT_GRAB");
      statesArr.push("GRAB");
      statesArr.push("FORCE_JUMP");
      statesArr.push("FORCE_WALK");
      statesArr.push("FORCE_RUN");
      statesArr.push("FORCE_DO_NOTHING");
      
      public function CPUState()
      {
         super();
      }
      
      public static function toString(param1:int) : String
      {
         return param1 >= 0 && param1 < statesArr.length ? statesArr[param1] : "null";
      }
   }
}


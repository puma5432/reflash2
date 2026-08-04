package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.engine.Beacon;
   
   public class SSF2Beacon extends SSF2GameObject
   {
      
      protected var _ownerCasted:Beacon;
      
      public function SSF2Beacon(param1:Class, param2:Beacon)
      {
         super(param1,param2);
         this._ownerCasted = param2;
      }
   }
}


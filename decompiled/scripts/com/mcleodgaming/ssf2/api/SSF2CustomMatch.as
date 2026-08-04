package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.CustomMatch;
   
   public class SSF2CustomMatch extends SSF2BaseAPIObject
   {
      
      protected var _ownerCasted:CustomMatch;
      
      public function SSF2CustomMatch(param1:Class, param2:CustomMatch)
      {
         super(param1,param2);
         this._ownerCasted = param2;
      }
      
      public function getGameSettings() : Object
      {
         var _loc1_:Game = this._ownerCasted.getGameSettings();
         if(_loc1_)
         {
            return _loc1_.exportSettings();
         }
         return null;
      }
      
      public function matchSetup(param1:Game) : Game
      {
         var _loc2_:Object = _api.matchSetup(param1.exportSettings());
         var _loc3_:Game = new Game();
         _loc3_.GameMode = param1.GameMode;
         _loc3_.importSettings(_loc2_);
         return _loc3_;
      }
   }
}


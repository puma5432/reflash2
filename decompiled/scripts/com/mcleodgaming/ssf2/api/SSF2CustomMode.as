package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.modes.CustomMode;
   
   public class SSF2CustomMode extends SSF2BaseAPIObject
   {
      
      protected var _ownerCasted:CustomMode;
      
      public function SSF2CustomMode(param1:Class, param2:CustomMode)
      {
         super(param1,param2);
         this._ownerCasted = param2;
      }
      
      public function getInitialGameSettings() : *
      {
         return JSON.parse(JSON.stringify(this._ownerCasted.InitialGameSettings.exportSettings()));
      }
      
      public function getModeSettings() : Object
      {
         return JSON.parse(JSON.stringify(this._ownerCasted.ModeSettings));
      }
      
      final public function startMatch(param1:*) : void
      {
         this._ownerCasted.startMatch(CustomMatch(param1.$ext.getAPI().owner));
      }
      
      public function handleMatchComplete() : void
      {
         _api.handleMatchComplete();
      }
      
      public function getSummary() : String
      {
         if("getSummary" in _api)
         {
            return _api.getSummary();
         }
         return "Custom Mode";
      }
      
      final public function endMode(param1:Object) : void
      {
         this._ownerCasted.endMode(param1);
      }
      
      final public function saveModeData(param1:Object) : Boolean
      {
         return this._ownerCasted.saveModeData(param1);
      }
   }
}


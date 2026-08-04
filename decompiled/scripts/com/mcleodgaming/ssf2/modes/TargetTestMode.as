package com.mcleodgaming.ssf2.modes
{
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.util.*;
   
   public class TargetTestMode extends CustomMode
   {
      
      public function TargetTestMode(param1:Game, param2:Object, param3:Object = null, param4:Boolean = false)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function saveModeData(param1:Object) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Array = null;
         var _loc7_:Boolean = false;
         var _loc8_:Object = null;
         if(GameInstance.ReplayDataObj)
         {
            return false;
         }
         if(param1)
         {
            if(param1.type !== "targetTest")
            {
               throw new Error("Error, expected type to equal \'targetTest\'");
            }
            if(!param1.matchData)
            {
               throw new Error("Error, matchData was not provided to endMode() for target test match");
            }
            if(!param1.matchData.targetMatchID)
            {
               throw new Error("Error, target test match was missing targetMatchID value");
            }
            if(!param1.matchData.fps)
            {
               throw new Error("Error, target test match was missing fps value");
            }
            if(!param1.matchData.time)
            {
               throw new Error("Error, target test match time value is required");
            }
            if(!param1.matchData.character)
            {
               throw new Error("Error, target test match character value is required");
            }
            _loc3_ = null;
            _loc6_ = ResourceManager.getResourceByID("targets_mode").getProp("targetStageList");
            _loc2_ = 0;
            while(_loc2_ < _loc6_.length)
            {
               if(_loc6_[_loc2_].id === param1.matchData.targetMatchID)
               {
                  _loc3_ = _loc6_[_loc2_].id;
               }
               _loc2_++;
            }
            if(!_loc3_)
            {
               throw new Error("Error, target test match was missing an ID");
            }
            _loc8_ = SaveData.getTargetTestData(param1.matchData.targetMatchID,param1.matchData.character);
            _loc4_ = int(param1.matchData.time);
            _loc5_ = Number(param1.matchData.fps);
            if(!_loc8_ || _loc4_ < _loc8_.score)
            {
               _loc7_ = true;
               SaveData.setTargetTestData(param1.matchData.targetMatchID,param1.matchData.character,{
                  "score":_loc4_,
                  "score_fps":_loc5_
               });
            }
         }
         SaveData.saveGame();
         return _loc7_;
      }
   }
}


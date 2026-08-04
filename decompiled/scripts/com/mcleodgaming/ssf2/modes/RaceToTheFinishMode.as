package com.mcleodgaming.ssf2.modes
{
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.util.*;
   
   public class RaceToTheFinishMode extends CustomMode
   {
      
      public function RaceToTheFinishMode(param1:Game, param2:Object, param3:Object = null, param4:Boolean = false)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function saveModeData(param1:Object) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Boolean = false;
         var _loc6_:Object = null;
         if(GameInstance.ReplayDataObj)
         {
            return false;
         }
         if(param1)
         {
            if(param1.type !== "racetothefinish")
            {
               throw new Error("Error, expected type to equal \'racetothefinish\'");
            }
            if(!param1.matchData)
            {
               throw new Error("Error, matchData was not provided to endMode() for race to the finish match");
            }
            if(!param1.matchData.fps)
            {
               throw new Error("Error, race to the finish match was missing fps value");
            }
            if(!param1.matchData.time)
            {
               throw new Error("Error, race to the finish match time value is required");
            }
            if(!param1.matchData.character)
            {
               throw new Error("Error, race to the finish match character value is required");
            }
            _loc6_ = SaveData.getRaceToTheFinishData("level0",param1.matchData.character);
            _loc3_ = int(param1.matchData.time);
            _loc4_ = Number(param1.matchData.fps);
            if(!_loc6_ || _loc3_ < _loc6_.score)
            {
               _loc5_ = true;
               SaveData.setRaceToTheFinishData("level0",param1.matchData.character,{
                  "score":_loc3_,
                  "score_fps":_loc4_
               });
            }
         }
         SaveData.saveGame();
         return _loc5_;
      }
   }
}


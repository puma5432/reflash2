package com.mcleodgaming.ssf2.modes
{
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.util.*;
   
   public class AllStarMode extends CustomMode
   {
      
      public function AllStarMode(param1:Game, param2:Object, param3:Object = null, param4:Boolean = false)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function saveModeData(param1:Object) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:CustomMode = null;
         var _loc8_:Boolean = false;
         var _loc9_:Object = null;
         if(GameInstance.ReplayDataObj)
         {
            return false;
         }
         if(param1)
         {
            if(param1.type !== "allstarMode")
            {
               throw new Error("Error, expected type to equal \'allstarMode\'");
            }
            if(!param1.matchData)
            {
               throw new Error("Error, matchData was not provided to saveModeData() for all-star mode");
            }
            if(typeof param1.matchData.score === "undefined")
            {
               throw new Error("Error, all-star mode was missing score value");
            }
            if(typeof param1.matchData.success === "undefined")
            {
               throw new Error("Error, all-star mode was missing success value");
            }
            _loc4_ = int(param1.matchData.score);
            _loc5_ = Boolean(param1.matchData.success);
            _loc6_ = int(param1.matchData.time);
            _loc9_ = SaveData.getAllStarModeData(m_initialGameSettings.PlayerSettings[0].character);
            if(!_loc9_ || _loc4_ > _loc9_.score)
            {
               _loc8_ = true;
               SaveData.setAllStarModeData(m_initialGameSettings.PlayerSettings[0].character,{
                  "score":_loc4_,
                  "success":_loc5_,
                  "time":_loc6_
               });
            }
         }
         SaveData.saveGame();
         return _loc8_;
      }
   }
}


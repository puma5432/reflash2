package com.mcleodgaming.ssf2.modes
{
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.util.*;
   
   public class HomeRunContestMode extends CustomMode
   {
      
      public function HomeRunContestMode(param1:Game, param2:Object, param3:Object = null, param4:Boolean = false)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function saveModeData(param1:Object) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:Number = NaN;
         var _loc5_:Boolean = false;
         var _loc6_:Object = null;
         if(GameInstance.ReplayDataObj)
         {
            return false;
         }
         if(param1)
         {
            if(param1.type !== "hrc")
            {
               throw new Error("Error, expected type to equal \'hrc\'");
            }
            if(!param1.matchData)
            {
               throw new Error("Error, matchData was not provided to saveModeData() for home run contest mode");
            }
            if(typeof param1.matchData.score === "undefined")
            {
               throw new Error("Error, home run contest mode was missing score value");
            }
            if(!param1.matchData.hrcMatchID)
            {
               throw new Error("Error, home run contest match was missing hrcMatchID value");
            }
            _loc3_ = param1.matchData.hrcMatchID;
            _loc4_ = Number(param1.matchData.score);
            _loc6_ = SaveData.getHRCModeData(_loc3_,m_initialGameSettings.PlayerSettings[0].character);
            if(!_loc6_ || _loc4_ > _loc6_.score)
            {
               if(_loc4_ > 0)
               {
                  _loc5_ = true;
               }
               SaveData.setHRCModeData(_loc3_,m_initialGameSettings.PlayerSettings[0].character,{"score":_loc4_});
            }
         }
         SaveData.saveGame();
         return _loc5_;
      }
   }
}


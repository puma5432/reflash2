package com.mcleodgaming.ssf2.modes
{
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.menus.*;
   import com.mcleodgaming.ssf2.util.*;
   
   public class MultiManMode extends CustomMode
   {
      
      public function MultiManMode(param1:Game, param2:Object, param3:Object = null, param4:Boolean = false)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function saveModeData(param1:Object) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:Boolean = false;
         var _loc7_:Object = null;
         if(GameInstance.ReplayDataObj)
         {
            return false;
         }
         if(param1)
         {
            if(param1.type !== "multiman")
            {
               throw new Error("Error, expected type to equal \'multiman\'");
            }
            if(!param1.matchData)
            {
               throw new Error("Error, matchData was not provided to saveModeData() for multi-man mode");
            }
            if(typeof param1.matchData.score === "undefined")
            {
               throw new Error("Error, multi-man mode was missing score value");
            }
            if(typeof param1.matchData.scoreType === "undefined")
            {
               throw new Error("Error, multi-man match was missing scoreType value");
            }
            if(!param1.matchData.scoreType.match(/^(time|kos)$/))
            {
               throw new Error("Error, multi-man match scoreType value must be \'time\' or \'kos\'");
            }
            _loc4_ = int(param1.matchData.score);
            _loc5_ = param1.matchData.scoreType;
            _loc7_ = SaveData.getMultiManModeData(MultiManMenu.SELECTED_MULTI_MAN_MODE,m_initialGameSettings.PlayerSettings[0].character);
            if(!_loc7_)
            {
               _loc6_ = true;
               SaveData.setMultiManModeData(MultiManMenu.SELECTED_MULTI_MAN_MODE,m_initialGameSettings.PlayerSettings[0].character,{
                  "score":_loc4_,
                  "scoreType":_loc5_
               });
            }
            else
            {
               switch(_loc5_)
               {
                  case "kos":
                     if(_loc7_.scoreType !== "time" && _loc4_ > _loc7_.score)
                     {
                        _loc6_ = true;
                        SaveData.setMultiManModeData(MultiManMenu.SELECTED_MULTI_MAN_MODE,m_initialGameSettings.PlayerSettings[0].character,{
                           "score":_loc4_,
                           "scoreType":_loc5_
                        });
                     }
                     break;
                  case "time":
                     if(_loc7_.scoreType === "kos" || _loc4_ < _loc7_.score)
                     {
                        _loc6_ = true;
                        SaveData.setMultiManModeData(MultiManMenu.SELECTED_MULTI_MAN_MODE,m_initialGameSettings.PlayerSettings[0].character,{
                           "score":_loc4_,
                           "scoreType":_loc5_
                        });
                     }
               }
            }
         }
         SaveData.saveGame();
         return _loc6_;
      }
   }
}


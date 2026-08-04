package com.mcleodgaming.ssf2.modes
{
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.util.*;
   
   public class ClassicMode extends CustomMode
   {
      
      public function ClassicMode(param1:Game, param2:Object, param3:Object = null, param4:Boolean = false)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function saveModeData(param1:Object) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:CustomMode = null;
         var _loc6_:Boolean = false;
         var _loc7_:Object = null;
         if(GameInstance.ReplayDataObj)
         {
            return false;
         }
         if(param1)
         {
            if(param1.type === "targetTest")
            {
               _loc5_ = new TargetTestMode(m_initialGameSettings,m_modeSettings,m_stats,true);
               _loc6_ = _loc5_.saveModeData(param1);
               _loc5_.APIInstance.dispose();
               return _loc6_;
            }
            if(param1.type === "crystalSmash")
            {
               _loc5_ = new CrystalSmashMode(m_initialGameSettings,m_modeSettings,m_stats,true);
               _loc6_ = _loc5_.saveModeData(param1);
               _loc5_.APIInstance.dispose();
               return _loc6_;
            }
            if(param1.type !== "classicMode")
            {
               throw new Error("Error, expected type to equal \'classicMode\'");
            }
            if(!param1.matchData)
            {
               throw new Error("Error, matchData was not provided to saveModeData() for classic mode");
            }
            if(typeof param1.matchData.score === "undefined")
            {
               throw new Error("Error, classic mode was missing score value");
            }
            if(typeof param1.matchData.continues === "undefined")
            {
               throw new Error("Error, classic mode was missing continues value");
            }
            _loc4_ = int(param1.matchData.score);
            _loc7_ = SaveData.getClassicModeData(m_initialGameSettings.PlayerSettings[0].character);
            if(!_loc7_ || _loc4_ > _loc7_.score)
            {
               _loc6_ = true;
               SaveData.setClassicModeData(m_initialGameSettings.PlayerSettings[0].character,{"score":_loc4_});
            }
            if(m_initialGameSettings.PlayerSettings[0].character === "goku" && m_initialGameSettings.LevelData.difficulty >= Difficulty.HARD && param1.matchData.continues === 0)
            {
               UnlockController.getUnlockableByID(Unlockable.WORLD_TOURNAMENT).TriggerUnlock = true;
            }
            if(Boolean(m_initialGameSettings.PlayerSettings[0].character.match(/link|zelda|sheik/)) && Boolean(m_initialGameSettings.LevelData.difficulty >= Difficulty.NORMAL) && param1.matchData.continues === 0)
            {
               SaveData.Unlocks.zeldaHyrule64Condition = true;
               SaveData.Unlocks.linkHyrule64Condition = true;
            }
            if(m_initialGameSettings.LevelData.difficulty >= Difficulty.HARD && param1.matchData.continues === 0)
            {
               UnlockController.getUnlockableByID(Unlockable.METAL_CAVERN).TriggerUnlock = true;
            }
            if(SaveData.Unlocks.mk64Condition)
            {
               UnlockController.getUnlockableByID(Unlockable.MUSHROOM_KINGDOM_64).TriggerUnlock = true;
            }
            if(_loc4_ >= 550000)
            {
               UnlockController.getUnlockableByID(Unlockable.URBAN_CHAMPION).TriggerUnlock = true;
            }
         }
         SaveData.saveGame();
         return _loc6_;
      }
   }
}


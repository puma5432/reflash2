package com.mcleodgaming.ssf2.controllers
{
   import com.mcleodgaming.ssf2.util.*;
   
   public class UnlockController
   {
      
      public static var unlockList:Vector.<Unlockable>;
      
      public static var pendingUnlockFights:Vector.<Unlockable>;
      
      public static var pendingUnlockScreens:Vector.<Unlockable>;
      
      public static var nextMenuFunc:Function = null;
      
      public function UnlockController()
      {
         super();
      }
      
      public static function init() : void
      {
         UnlockController.nextMenuFunc = null;
         UnlockController.unlockList = new Vector.<Unlockable>();
         UnlockController.pendingUnlockFights = new Vector.<Unlockable>();
         UnlockController.pendingUnlockScreens = new Vector.<Unlockable>();
         UnlockController.unlockList.push(new Unlockable(Unlockable.FINAL_VALLEY));
         UnlockController.unlockList.push(new Unlockable(Unlockable.WORLD_TOURNAMENT));
         UnlockController.unlockList.push(new Unlockable(Unlockable.STEEL_DIVER));
         UnlockController.unlockList.push(new Unlockable(Unlockable.SAFFRON_CITY));
         UnlockController.unlockList.push(new Unlockable(Unlockable.HYRULE_CASTLE_64));
         UnlockController.unlockList.push(new Unlockable(Unlockable.DEVILS_MACHINE));
         UnlockController.unlockList.push(new Unlockable(Unlockable.METAL_CAVERN));
         UnlockController.unlockList.push(new Unlockable(Unlockable.MUSHROOM_KINGDOM_64));
         UnlockController.unlockList.push(new Unlockable(Unlockable.WAITING_ROOM));
         UnlockController.unlockList.push(new Unlockable(Unlockable.THE_WORLD_THAT_NEVER_WAS));
         UnlockController.unlockList.push(new Unlockable(Unlockable.SKY_PILLAR));
         UnlockController.unlockList.push(new Unlockable(Unlockable.KRAZOA_PALACE));
         UnlockController.unlockList.push(new Unlockable(Unlockable.URBAN_CHAMPION));
         UnlockController.unlockList.push(new Unlockable(Unlockable.ALTERNATE_TRACKS));
         UnlockController.unlockList.push(new Unlockable(Unlockable.EVENT_ALL_STAR_01));
         UnlockController.unlockList.push(new Unlockable(Unlockable.EVENTS_11_20));
         UnlockController.unlockList.push(new Unlockable(Unlockable.EVENT_ALL_STAR_06));
         UnlockController.unlockList.push(new Unlockable(Unlockable.EVENTS_21_30));
         UnlockController.unlockList.push(new Unlockable(Unlockable.EVENT_ALL_STAR_07));
         UnlockController.unlockList.push(new Unlockable(Unlockable.EVENTS_31_36));
         UnlockController.unlockList.push(new Unlockable(Unlockable.EVENT_ALL_STAR_08));
         UnlockController.unlockList.push(new Unlockable(Unlockable.EVENTS_37_44));
         UnlockController.unlockList.push(new Unlockable(Unlockable.EVENT_ALL_STAR_09));
         UnlockController.unlockList.push(new Unlockable(Unlockable.EVENTS_45_50));
         UnlockController.unlockList.push(new Unlockable(Unlockable.EVENT_ALL_STAR_BETA));
         UnlockController.unlockList.push(new Unlockable(Unlockable.EVENTS_51));
         UnlockController.unlockList.push(new Unlockable(Unlockable.EVENT_ARANK));
         UnlockController.unlockList.push(new Unlockable(Unlockable.EVENT_SRANK));
         trace("UnlockController class initialized");
      }
      
      public static function getUnlockableByID(param1:String) : Unlockable
      {
         var _loc2_:int = 0;
         while(_loc2_ < UnlockController.unlockList.length)
         {
            if(UnlockController.unlockList[_loc2_].ID === param1)
            {
               return UnlockController.unlockList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public static function checkUnlocked(param1:Unlockable) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:Boolean = true;
         if(param1.ID == Unlockable.FINAL_VALLEY)
         {
            if(Boolean(SaveData.Records.events.wins["ShadowCloneShowdown"]) && !SaveData.Unlocks[Unlockable.FINAL_VALLEY])
            {
               return true;
            }
         }
         else if(param1.ID == Unlockable.WORLD_TOURNAMENT)
         {
            if((param1.TriggerUnlock || SaveData.Records.vs.ffaMatchTotal >= 15) && !SaveData.Unlocks[Unlockable.WORLD_TOURNAMENT])
            {
               return true;
            }
         }
         else if(param1.ID == Unlockable.STEEL_DIVER)
         {
            if(SaveData.Unlocks.waterKOs >= 20 && !SaveData.Unlocks[Unlockable.STEEL_DIVER])
            {
               return true;
            }
         }
         else if(param1.ID == Unlockable.SAFFRON_CITY)
         {
            if(Boolean(SaveData.Records.classic.wins.jigglypuff) && !SaveData.Unlocks[Unlockable.SAFFRON_CITY])
            {
               return true;
            }
         }
         else if(param1.ID == Unlockable.HYRULE_CASTLE_64)
         {
            if(Boolean(SaveData.Unlocks.linkHyrule64Condition) && Boolean(SaveData.Unlocks.zeldaHyrule64Condition) && !SaveData.Unlocks[Unlockable.HYRULE_CASTLE_64])
            {
               return true;
            }
         }
         else if(param1.ID == Unlockable.DEVILS_MACHINE)
         {
            if(SaveData.Unlocks.ghostNessSDs >= 3 && !SaveData.Unlocks[Unlockable.DEVILS_MACHINE])
            {
               return true;
            }
         }
         else if(param1.ID == Unlockable.METAL_CAVERN)
         {
            if(param1.TriggerUnlock && !SaveData.Unlocks[Unlockable.METAL_CAVERN])
            {
               return true;
            }
         }
         else if(param1.ID == Unlockable.MUSHROOM_KINGDOM_64)
         {
            if(param1.TriggerUnlock && !SaveData.Unlocks[Unlockable.MUSHROOM_KINGDOM_64])
            {
               return true;
            }
         }
         else if(param1.ID == Unlockable.WAITING_ROOM)
         {
            if(Boolean(SaveData.Records.vs.matches.sandbag) && !SaveData.Unlocks[Unlockable.WAITING_ROOM])
            {
               return true;
            }
         }
         else if(param1.ID == Unlockable.THE_WORLD_THAT_NEVER_WAS)
         {
            if(param1.TriggerUnlock && !SaveData.Unlocks[Unlockable.THE_WORLD_THAT_NEVER_WAS])
            {
               return true;
            }
         }
         else if(param1.ID == Unlockable.SKY_PILLAR)
         {
            if(param1.TriggerUnlock && !SaveData.Unlocks[Unlockable.SKY_PILLAR])
            {
               return true;
            }
         }
         else if(param1.ID == Unlockable.KRAZOA_PALACE)
         {
            if(param1.TriggerUnlock && !SaveData.Unlocks[Unlockable.KRAZOA_PALACE])
            {
               return true;
            }
         }
         else if(param1.ID == Unlockable.URBAN_CHAMPION)
         {
            if(param1.TriggerUnlock && !SaveData.Unlocks[Unlockable.URBAN_CHAMPION])
            {
               return true;
            }
         }
         else if(param1.ID === Unlockable.ALTERNATE_TRACKS)
         {
            if(SaveData.PowerCount >= 10 && !SaveData.Unlocks[Unlockable.ALTERNATE_TRACKS])
            {
               return true;
            }
         }
         else if(param1.ID === Unlockable.EVENT_ALL_STAR_01)
         {
            if(param1.TriggerUnlock && !SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_01])
            {
               return true;
            }
         }
         else if(param1.ID === Unlockable.EVENTS_11_20)
         {
            if(param1.TriggerUnlock && !SaveData.Unlocks[Unlockable.EVENTS_11_20])
            {
               return true;
            }
         }
         else if(param1.ID === Unlockable.EVENT_ALL_STAR_06)
         {
            if(param1.TriggerUnlock && !SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_06])
            {
               return true;
            }
         }
         else if(param1.ID === Unlockable.EVENTS_21_30)
         {
            if(param1.TriggerUnlock && !SaveData.Unlocks[Unlockable.EVENTS_21_30])
            {
               return true;
            }
         }
         else if(param1.ID === Unlockable.EVENT_ALL_STAR_07)
         {
            if(param1.TriggerUnlock && !SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_07])
            {
               return true;
            }
         }
         else if(param1.ID === Unlockable.EVENTS_31_36)
         {
            if(param1.TriggerUnlock && !SaveData.Unlocks[Unlockable.EVENTS_31_36])
            {
               return true;
            }
         }
         else if(param1.ID === Unlockable.EVENT_ALL_STAR_08)
         {
            if(param1.TriggerUnlock && !SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_08])
            {
               return true;
            }
         }
         else if(param1.ID === Unlockable.EVENTS_37_44)
         {
            if(param1.TriggerUnlock && !SaveData.Unlocks[Unlockable.EVENTS_37_44])
            {
               return true;
            }
         }
         else if(param1.ID === Unlockable.EVENT_ALL_STAR_09)
         {
            if(param1.TriggerUnlock && !SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_09])
            {
               return true;
            }
         }
         else if(param1.ID === Unlockable.EVENTS_45_50)
         {
            if(param1.TriggerUnlock && !SaveData.Unlocks[Unlockable.EVENTS_45_50])
            {
               return true;
            }
         }
         else if(param1.ID === Unlockable.EVENT_ALL_STAR_BETA)
         {
            if(param1.TriggerUnlock && !SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_BETA])
            {
               return true;
            }
         }
         else if(param1.ID === Unlockable.EVENTS_51)
         {
            if(param1.TriggerUnlock && !SaveData.Unlocks[Unlockable.EVENTS_51])
            {
               return true;
            }
         }
         else if(param1.ID === Unlockable.EVENT_ARANK)
         {
            if(param1.TriggerUnlock && !SaveData.Unlocks[Unlockable.EVENT_ARANK])
            {
               return true;
            }
         }
         else if(param1.ID === Unlockable.EVENT_SRANK)
         {
            if(param1.TriggerUnlock && !SaveData.Unlocks[Unlockable.EVENT_SRANK])
            {
               return true;
            }
         }
         return false;
      }
      
      public static function matchSetup(param1:Unlockable) : Game
      {
         var _loc2_:Game = null;
         if(_loc2_)
         {
            _loc2_.LevelData.randSeed = Math.round(Math.random() * 1000000 + 1);
         }
         return _loc2_;
      }
      
      public static function checkUnlocks() : void
      {
         var _loc1_:int = 0;
         while(UnlockController.pendingUnlockFights.length > 0)
         {
            UnlockController.pendingUnlockFights.splice(0,1);
         }
         while(UnlockController.pendingUnlockScreens.length > 0)
         {
            UnlockController.pendingUnlockScreens.splice(0,1);
         }
         while(_loc1_ < UnlockController.unlockList.length)
         {
            if(UnlockController.checkUnlocked(UnlockController.unlockList[_loc1_]))
            {
               if(UnlockController.matchSetup(UnlockController.unlockList[_loc1_]))
               {
                  UnlockController.pendingUnlockFights.push(UnlockController.unlockList[_loc1_]);
               }
               else
               {
                  UnlockController.pendingUnlockScreens.push(UnlockController.unlockList[_loc1_]);
               }
            }
            _loc1_++;
         }
      }
   }
}


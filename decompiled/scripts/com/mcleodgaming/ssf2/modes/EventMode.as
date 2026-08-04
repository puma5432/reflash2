package com.mcleodgaming.ssf2.modes
{
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.util.*;
   
   public class EventMode extends CustomMode
   {
      
      private const rankings:Array = ["S","A","B","C","D","E","F"];
      
      public function EventMode(param1:Game, param2:Object, param3:Object = null, param4:Boolean = false)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function saveModeData(param1:Object) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Number = NaN;
         var _loc8_:Array = null;
         var _loc9_:Boolean = false;
         var _loc10_:Object = null;
         if(param1)
         {
            if(param1.type !== "eventMatch")
            {
               throw new Error("Error, expected type to equal \'eventMatch\'");
            }
            if(!param1.matchData)
            {
               throw new Error("Error, matchData was not provided to saveModeData() for event match");
            }
            if(!param1.eventMatchID)
            {
               throw new Error("Error, eventMatchID was not provided to saveModeData() for event match");
            }
            if(!param1.matchData.fps)
            {
               throw new Error("Error, event match was missing fps value");
            }
            if(!param1.matchData.rank)
            {
               throw new Error("Error, event match rank value was undefined and is required");
            }
            if(!param1.matchData.rank.match(/^(s|a|b|c|d|e|f)$/i))
            {
               throw new Error("Error, invalid match ranking, should be valued S, A, B, C, D, E, or F");
            }
            if(typeof param1.matchData.score === "undefined")
            {
               throw new Error("Error, event match was missing score value");
            }
            if(typeof param1.matchData.scoreType === "undefined")
            {
               throw new Error("Error, event match was missing scoreType value");
            }
            if(!param1.matchData.scoreType.match(/^(time|points|damage|stamina|kos)$/))
            {
               throw new Error("Error, event match scoreType value must be \'time\', \'points\', \'damage\', \'stamina\', or \'kos\'");
            }
            _loc3_ = null;
            _loc8_ = ResourceManager.getResourceByID("event_mode").getProp("eventList");
            _loc2_ = 0;
            while(_loc2_ < _loc8_.length)
            {
               if(_loc8_[_loc2_].id === param1.eventMatchID)
               {
                  _loc3_ = _loc8_[_loc2_].id;
               }
               _loc2_++;
            }
            if(!_loc3_)
            {
               throw new Error("Error, event match ID not found");
            }
            _loc6_ = param1.matchData.rank.toUpperCase();
            _loc4_ = int(param1.matchData.score);
            _loc5_ = param1.matchData.scoreType;
            _loc7_ = Number(param1.matchData.fps);
            if(!SaveData.Records.events.wins[_loc3_])
            {
               SaveData.Records.events.wins[_loc3_] = new Object();
               SaveData.Records.events.wins[_loc3_].rank = _loc6_;
               SaveData.Records.events.wins[_loc3_].score = _loc4_;
               SaveData.Records.events.wins[_loc3_].scoreType = _loc5_;
               SaveData.Records.events.wins[_loc3_].fps = _loc7_;
               _loc9_ = true;
            }
            else if(this.rankings.indexOf(_loc6_) < this.rankings.indexOf(SaveData.Records.events.wins[_loc3_].rank) || Boolean(_loc6_ === SaveData.Records.events.wins[_loc3_].rank) && (Boolean(_loc5_.match(/points|stamina|kos/) && _loc4_ > SaveData.Records.events.wins[_loc3_].score || _loc5_.match(/time|damage/) && _loc4_ < SaveData.Records.events.wins[_loc3_].score)))
            {
               SaveData.Records.events.wins[_loc3_].rank = _loc6_;
               SaveData.Records.events.wins[_loc3_].score = _loc4_;
               SaveData.Records.events.wins[_loc3_].scoreType = _loc5_;
               SaveData.Records.events.wins[_loc3_].fps = _loc7_;
               _loc9_ = true;
            }
            if(this.verifyMatchesBefore(true,1,"F"))
            {
               UnlockController.getUnlockableByID(Unlockable.EVENT_ALL_STAR_01).TriggerUnlock = true;
            }
            if(this.verifyMatchesBefore(true,2,"F"))
            {
               UnlockController.getUnlockableByID(Unlockable.EVENT_ALL_STAR_06).TriggerUnlock = true;
            }
            if(this.verifyMatchesBefore(true,3,"F"))
            {
               UnlockController.getUnlockableByID(Unlockable.EVENT_ALL_STAR_07).TriggerUnlock = true;
            }
            if(this.verifyMatchesBefore(true,4,"F"))
            {
               UnlockController.getUnlockableByID(Unlockable.EVENT_ALL_STAR_08).TriggerUnlock = true;
            }
            if(this.verifyMatchesBefore(true,5,"F"))
            {
               UnlockController.getUnlockableByID(Unlockable.EVENT_ALL_STAR_09).TriggerUnlock = true;
            }
            if(this.verifyMatchesBefore(true,6,"F"))
            {
               UnlockController.getUnlockableByID(Unlockable.EVENT_ALL_STAR_BETA).TriggerUnlock = true;
            }
            if(this.verifyMatchesBefore(false,11,"F"))
            {
               UnlockController.getUnlockableByID(Unlockable.EVENTS_11_20).TriggerUnlock = true;
            }
            if(this.verifyMatchesBefore(false,21,"F"))
            {
               UnlockController.getUnlockableByID(Unlockable.EVENTS_21_30).TriggerUnlock = true;
            }
            if(this.verifyMatchesBefore(false,31,"F"))
            {
               UnlockController.getUnlockableByID(Unlockable.EVENTS_31_36).TriggerUnlock = true;
            }
            if(this.verifyMatchesBefore(false,37,"F"))
            {
               UnlockController.getUnlockableByID(Unlockable.EVENTS_37_44).TriggerUnlock = true;
            }
            if(this.verifyMatchesBefore(false,45,"F"))
            {
               UnlockController.getUnlockableByID(Unlockable.EVENTS_45_50).TriggerUnlock = true;
            }
            if(this.verifyMatchesBefore(false,51,"A"))
            {
               UnlockController.getUnlockableByID(Unlockable.EVENT_ARANK).TriggerUnlock = true;
               UnlockController.getUnlockableByID(Unlockable.EVENTS_51).TriggerUnlock = true;
            }
            if(this.verifyMatchesBefore(false,52,"S"))
            {
               UnlockController.getUnlockableByID(Unlockable.EVENT_SRANK).TriggerUnlock = true;
            }
         }
         SaveData.saveGame();
         return _loc9_;
      }
      
      protected function verifyMatchesBefore(param1:Boolean, param2:int, param3:String) : Boolean
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         param3 = param3.toUpperCase();
         var _loc4_:Array = ResourceManager.getResourceByID("event_mode").getProp("eventList");
         while(_loc7_ < _loc4_.length)
         {
            if(_loc4_[_loc7_].allStar)
            {
               _loc5_++;
               if(param1 && param2 === _loc5_)
               {
                  return true;
               }
               if(!SaveData.Records.events.wins[_loc4_[_loc7_].id] || this.rankings.indexOf(SaveData.Records.events.wins[_loc4_[_loc7_].id].rank) > this.rankings.indexOf(param3))
               {
                  return false;
               }
            }
            else
            {
               _loc6_++;
               if(!param1 && param2 === _loc6_)
               {
                  return true;
               }
               if(!SaveData.Records.events.wins[_loc4_[_loc7_].id] || this.rankings.indexOf(SaveData.Records.events.wins[_loc4_[_loc7_].id].rank) > this.rankings.indexOf(param3))
               {
                  return false;
               }
            }
            _loc7_++;
         }
         return true;
      }
   }
}


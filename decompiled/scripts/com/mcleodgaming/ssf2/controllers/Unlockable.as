package com.mcleodgaming.ssf2.controllers
{
   import com.mcleodgaming.ssf2.util.*;
   
   public class Unlockable
   {
      
      public static const FINAL_VALLEY:String = "finalvalley";
      
      public static const WORLD_TOURNAMENT:String = "worldtournament";
      
      public static const STEEL_DIVER:String = "steeldiver";
      
      public static const SAFFRON_CITY:String = "saffroncity";
      
      public static const HYRULE_CASTLE_64:String = "hyrulecastle64";
      
      public static const DEVILS_MACHINE:String = "devilsmachine";
      
      public static const METAL_CAVERN:String = "metalcavern";
      
      public static const MUSHROOM_KINGDOM_64:String = "kingdom1";
      
      public static const WAITING_ROOM:String = "waitingroom";
      
      public static const THE_WORLD_THAT_NEVER_WAS:String = "theworldthatneverwas";
      
      public static const SKY_PILLAR:String = "skypillar";
      
      public static const KRAZOA_PALACE:String = "krazoapalace";
      
      public static const URBAN_CHAMPION:String = "urbanchampion";
      
      public static const ALTERNATE_TRACKS:String = "alternate_tracks";
      
      public static const EVENT_ALL_STAR_01:String = "eventAllStar01";
      
      public static const EVENTS_11_20:String = "events11_20";
      
      public static const EVENT_ALL_STAR_06:String = "eventAllStar06";
      
      public static const EVENTS_21_30:String = "events21_30";
      
      public static const EVENT_ALL_STAR_07:String = "eventAllStar07";
      
      public static const EVENTS_31_36:String = "events31_33";
      
      public static const EVENT_ALL_STAR_08:String = "eventAllStar08";
      
      public static const EVENTS_37_44:String = "events34_40";
      
      public static const EVENT_ALL_STAR_09:String = "eventAllStar09";
      
      public static const EVENTS_45_50:String = "events41_46";
      
      public static const EVENT_ALL_STAR_BETA:String = "eventAllStarBeta";
      
      public static const EVENTS_51:String = "events47_51";
      
      public static const EVENT_ARANK:String = "eventsARank";
      
      public static const EVENT_SRANK:String = "eventsSRank";
      
      private var m_id:String;
      
      private var m_filesArray:Array;
      
      private var m_triggerUnlock:Boolean;
      
      public function Unlockable(param1:String, param2:Array = null, param3:Boolean = false)
      {
         super();
         this.m_id = param1;
         this.m_filesArray = param2;
         this.m_triggerUnlock = false;
      }
      
      public function get ID() : String
      {
         return this.m_id;
      }
      
      public function get FilesArray() : Array
      {
         return this.m_filesArray;
      }
      
      public function get TriggerUnlock() : Boolean
      {
         return this.m_triggerUnlock;
      }
      
      public function set TriggerUnlock(param1:Boolean) : void
      {
         this.m_triggerUnlock = param1;
      }
      
      public function unlock() : void
      {
         SaveData.Unlocks[this.m_id] = true;
         SaveData.saveGame();
      }
   }
}


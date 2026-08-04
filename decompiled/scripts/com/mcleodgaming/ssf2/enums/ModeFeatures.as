package com.mcleodgaming.ssf2.enums
{
   public class ModeFeatures
   {
      
      public static const MULTIPLAYER_MANAGER:uint = 0;
      
      public static const FILL_PLAYER_SLOTS:uint = 1;
      
      public static const INVERTED_TIMER:uint = 3;
      
      public static const EXTENDED_ENDTIMER:uint = 4;
      
      public static const FORCE_NO_ITEM_AUTO_SPAWN:uint = 5;
      
      public static const ALLOW_STOCK_STEAL:uint = 6;
      
      public static const ALLOW_SUDDEN_DEATH:uint = 7;
      
      public static const REMOVE_TIMER:uint = 9;
      
      public static const CHECK_UNLOCKS:uint = 12;
      
      public static const IGNORE_TEAM_COSTUME:uint = 14;
      
      public static const IGNORE_STALE_DECAY:uint = 15;
      
      public static const FORCE_ITEM_AVAILABILITY:uint = 17;
      
      public static const ALLOW_SAVE_VS_OPTIONS:uint = 18;
      
      public static const FORCE_NO_TEAM_DAMAGE:uint = 19;
      
      public static const ALLOW_FFA_TEAM_TOGGLE:uint = 20;
      
      public static const FORCE_SINGLE_PLAYER:uint = 21;
      
      public static const HAS_HOME_BUTTON:uint = 22;
      
      public static const ALLOW_CONROL_TYPE:uint = 23;
      
      public static const ALLOW_SINGLE_PLAYER:uint = 24;
      
      public static const ALLOW_PAUSE:uint = 25;
      
      public static const ALLOW_CROWD_CHANTS:uint = 26;
      
      public static const ALLOW_NARRATOR_GAME:uint = 27;
      
      public static const ALLOW_NARRATOR_CPU_DEFEATED:uint = 28;
      
      public static const ALLOW_REPLAY_RECORD:uint = 29;
      
      public static const SAVE_RECORDS:uint = 30;
      
      public static const OFFSCREEN_DAMAGE:uint = 31;
      
      public static const OFFSCREEN_BUBBLE:uint = 32;
      
      public static const FORCE_TWO_PLAYER:uint = 33;
      
      public static const ALLOW_TEAM_TOGGLE:uint = 34;
      
      public static const IS_CUSTOM:uint = 35;
      
      public static const HAS_RETRY_BUTTON:uint = 36;
      
      public function ModeFeatures()
      {
         super();
      }
      
      public static function hasFeature(param1:uint, param2:uint) : Boolean
      {
         if(param1 == MULTIPLAYER_MANAGER)
         {
            return param2 == Mode.ONLINE || param2 == Mode.ONLINE_ARENA;
         }
         if(param1 == FILL_PLAYER_SLOTS)
         {
            return param2 == Mode.TRAINING;
         }
         if(param1 == INVERTED_TIMER)
         {
            return param2 == Mode.TARGET_TEST || param2 == Mode.CRYSTAL_SMASH || param2 == Mode.RACE_TO_THE_FINISH;
         }
         if(param1 == EXTENDED_ENDTIMER)
         {
            return param2 == Mode.TARGET_TEST || param2 == Mode.CRYSTAL_SMASH || param2 == Mode.RACE_TO_THE_FINISH;
         }
         if(param1 == FORCE_NO_ITEM_AUTO_SPAWN)
         {
            return param2 == Mode.TRAINING || param2 == Mode.TARGET_TEST || param2 === Mode.ONLINE_WAITING_ROOM || param2 === Mode.ARENA || param2 == Mode.CRYSTAL_SMASH || param2 == Mode.ONLINE_ARENA || param2 == Mode.RACE_TO_THE_FINISH;
         }
         if(param1 == ALLOW_SUDDEN_DEATH)
         {
            return param2 == Mode.VS || param2 == Mode.VS_UNLOCK || param2 == Mode.ONLINE;
         }
         if(param1 == REMOVE_TIMER)
         {
            return param2 == Mode.VS || param2 == Mode.VS_UNLOCK || param2 == Mode.ONLINE || param2 === Mode.ONLINE_WAITING_ROOM || param2 === Mode.ARENA || param2 == Mode.ONLINE_ARENA;
         }
         if(param1 == CHECK_UNLOCKS)
         {
            return param2 == Mode.VS || param2 == Mode.TARGET_TEST || param2 == Mode.CRYSTAL_SMASH || param2 == Mode.RACE_TO_THE_FINISH;
         }
         if(param1 == IGNORE_TEAM_COSTUME)
         {
            return param2 == Mode.TRAINING || param2 == Mode.CLASSIC || param2 == Mode.EVENT;
         }
         if(param1 == IGNORE_STALE_DECAY)
         {
            return param2 == Mode.TRAINING;
         }
         if(param1 == ALLOW_STOCK_STEAL)
         {
            return param2 == Mode.VS || param2 == Mode.VS_UNLOCK || param2 == Mode.ONLINE || param2 == Mode.CLASSIC;
         }
         if(param1 == FORCE_ITEM_AVAILABILITY)
         {
            return param2 == Mode.TRAINING || param2 == Mode.TARGET_TEST;
         }
         if(param1 == ALLOW_SAVE_VS_OPTIONS)
         {
            return param2 == Mode.VS;
         }
         if(param1 == FORCE_NO_TEAM_DAMAGE)
         {
            return param2 == Mode.TRAINING || param2 == Mode.CLASSIC || param2 == Mode.ALL_STAR;
         }
         if(param1 == ALLOW_FFA_TEAM_TOGGLE)
         {
            return param2 == Mode.VS || param2 == Mode.ONLINE;
         }
         if(param1 == FORCE_SINGLE_PLAYER)
         {
            return param2 == Mode.TARGET_TEST || param2 == Mode.CLASSIC || param2 === Mode.ONLINE_WAITING_ROOM || param2 == Mode.CRYSTAL_SMASH || param2 == Mode.ALL_STAR || param2 == Mode.RACE_TO_THE_FINISH;
         }
         if(param1 == HAS_HOME_BUTTON)
         {
            return param2 == Mode.TARGET_TEST || param2 == Mode.TRAINING || param2 == Mode.CLASSIC || param2 == Mode.CRYSTAL_SMASH || param2 == Mode.ALL_STAR;
         }
         if(param1 == ALLOW_CONROL_TYPE)
         {
            return param2 == Mode.VS || param2 == Mode.ARENA;
         }
         if(param1 == ALLOW_SINGLE_PLAYER)
         {
            return param2 == Mode.ONLINE || param2 === Mode.ONLINE_WAITING_ROOM || param2 == Mode.TARGET_TEST || param2 == Mode.CLASSIC || param2 == Mode.EVENT || param2 == Mode.HOME_RUN_CONTEST || param2 == Mode.MULTIMAN || param2 == Mode.CUSTOM || param2 == Mode.CRYSTAL_SMASH || param2 == Mode.ONLINE_ARENA || param2 == Mode.ALL_STAR || param2 == Mode.RACE_TO_THE_FINISH;
         }
         if(param1 == ALLOW_PAUSE)
         {
            return param2 == Mode.VS || param2 == Mode.VS_UNLOCK || param2 == Mode.TRAINING || param2 == Mode.TARGET_TEST || param2 == Mode.CLASSIC || param2 == Mode.EVENT || param2 == Mode.HOME_RUN_CONTEST || param2 == Mode.MULTIMAN || param2 == Mode.ARENA || param2 == Mode.CUSTOM || param2 == Mode.CRYSTAL_SMASH || param2 == Mode.ALL_STAR || param2 == Mode.RACE_TO_THE_FINISH;
         }
         if(param1 == ALLOW_CROWD_CHANTS)
         {
            return param2 == Mode.VS || param2 === Mode.ONLINE;
         }
         if(param1 == ALLOW_NARRATOR_GAME)
         {
            return param2 == Mode.VS || param2 == Mode.VS_UNLOCK || param2 == Mode.CLASSIC || param2 == Mode.TARGET_TEST || param2 == Mode.CLASSIC || param2 == Mode.EVENT || param2 == Mode.HOME_RUN_CONTEST || param2 == Mode.MULTIMAN || param2 == Mode.CUSTOM || param2 == Mode.CRYSTAL_SMASH || param2 == Mode.ALL_STAR || param2 == Mode.RACE_TO_THE_FINISH;
         }
         if(param1 == ALLOW_NARRATOR_CPU_DEFEATED)
         {
            return param2 == Mode.VS || param2 == Mode.VS_UNLOCK || param2 == Mode.CLASSIC || param2 == Mode.ALL_STAR;
         }
         if(param1 == ALLOW_REPLAY_RECORD)
         {
            return param2 == Mode.VS || param2 == Mode.ONLINE || param2 == Mode.ONLINE_ARENA || param2 == Mode.ARENA || param2 == Mode.TARGET_TEST || param2 == Mode.HOME_RUN_CONTEST || param2 == Mode.MULTIMAN || param2 == Mode.CRYSTAL_SMASH || param2 == Mode.RACE_TO_THE_FINISH;
         }
         if(param1 == SAVE_RECORDS)
         {
            return param2 == Mode.VS || param2 == Mode.ONLINE || param2 == Mode.ONLINE_ARENA;
         }
         if(param1 == OFFSCREEN_DAMAGE)
         {
            return param2 == Mode.VS || param2 == Mode.VS_UNLOCK || param2 == Mode.ONLINE || param2 === Mode.ONLINE_WAITING_ROOM;
         }
         if(param1 == OFFSCREEN_BUBBLE)
         {
            return param2 == Mode.VS || param2 == Mode.VS_UNLOCK || param2 == Mode.ONLINE || param2 === Mode.ONLINE_WAITING_ROOM || param2 === Mode.TRAINING || param2 === Mode.TARGET_TEST || param2 === Mode.EVENT;
         }
         if(param1 == FORCE_TWO_PLAYER)
         {
            return false;
         }
         if(param1 == IS_CUSTOM)
         {
            return param2 == Mode.TARGET_TEST || param2 == Mode.CLASSIC || param2 == Mode.EVENT || param2 == Mode.HOME_RUN_CONTEST || param2 == Mode.ARENA || param2 == Mode.MULTIMAN || param2 == Mode.CUSTOM || param2 == Mode.CRYSTAL_SMASH || param2 == Mode.ONLINE_ARENA || param2 == Mode.ALL_STAR || param2 == Mode.RACE_TO_THE_FINISH;
         }
         if(param1 == HAS_RETRY_BUTTON)
         {
            return param2 == Mode.TARGET_TEST || param2 == Mode.EVENT || param2 == Mode.HOME_RUN_CONTEST || param2 == Mode.MULTIMAN || param2 == Mode.CRYSTAL_SMASH || param2 == Mode.RACE_TO_THE_FINISH;
         }
         if(param1 == ALLOW_TEAM_TOGGLE)
         {
            return param2 == Mode.VS || param2 == Mode.ONLINE || param2 === Mode.ARENA || param2 === Mode.ONLINE_ARENA;
         }
         return false;
      }
   }
}


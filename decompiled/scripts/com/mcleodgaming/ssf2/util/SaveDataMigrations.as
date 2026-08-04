package com.mcleodgaming.ssf2.util
{
   import com.mcleodgaming.mgn.net.*;
   import com.mcleodgaming.ssf2.*;
   import flash.display.*;
   
   public class SaveDataMigrations
   {
      
      public static var postLoadMigrations:Vector.<Function> = new Vector.<Function>();
      
      public function SaveDataMigrations()
      {
         super();
      }
      
      public static function getInitialData() : Object
      {
         return {
            "migration":"44_rttf",
            "exists":true,
            "version":Version.getVersion(),
            "records":{
               "vs":{
                  "playTime":0,
                  "playContestants":0,
                  "timeMatchTotal":0,
                  "stockMatchTotal":0,
                  "matchResets":0,
                  "teamMatchTotal":0,
                  "ffaMatchTotal":0,
                  "matchTotal":0,
                  "wins":{},
                  "matches":{},
                  "stages":{}
               },
               "targets":{
                  "playTime":0,
                  "wins":{}
               },
               "crystals":{
                  "playTime":0,
                  "wins":{}
               },
               "racetothefinish":{
                  "playTime":0,
                  "wins":{}
               },
               "events":{
                  "playTime":0,
                  "wins":{}
               },
               "misc":{
                  "powerCount":1,
                  "powerTime":0,
                  "playTime":0
               },
               "classic":{
                  "playTime":0,
                  "wins":{}
               },
               "allstar":{
                  "playTime":0,
                  "wins":{}
               },
               "multiman":{
                  "playTime":0,
                  "modes":{}
               },
               "arena":{
                  "playTime":0,
                  "stages":{}
               },
               "hrc":{
                  "playTime":0,
                  "wins":{}
               }
            },
            "options":{
               "arenaScore":5,
               "rememberMe":null,
               "hazards":true,
               "airDodge":"brawl",
               "teamDamage":false,
               "SEvolumeLevel":0.7,
               "VAvolumeLevel":0.7,
               "BGvolumeLevel":0.7,
               "finalFormMusic":false,
               "characterQueueSize":8,
               "stageQueueSize":8,
               "VS_Time":2,
               "VS_Lives":3,
               "VS_DamageRatio":1,
               "VS_ItemFreq":5,
               "VS_StartDamage":0,
               "VS_DisplayPlayer":false,
               "VS_UsingLives":false,
               "VS_UsingTime":true,
               "VS_CPULevel1":1,
               "VS_CPULevel2":1,
               "VS_CPULevel3":1,
               "VS_CPULevel4":1,
               "VS_UsingStamina":false,
               "VS_StartStamina":150,
               "VS_FinalSmashMeter":false,
               "VS_ScoreDisplay":false,
               "VS_HudDisplay":true,
               "VS_PauseEnabled":true,
               "VS_Items":{},
               "VS_Stages":{},
               "names":{},
               "tcpIP":ProtocolSetting.tcpIP,
               "tcpPort":ProtocolSetting.tcpPort,
               "udpIP":ProtocolSetting.udpIP,
               "udpPort":ProtocolSetting.udpPort,
               "replayAutoSave":false
            },
            "unlocks":{
               "finalvalley":false,
               "worldtournament":false,
               "steeldiver":false,
               "saffroncity":false,
               "hyrulecastle64":false,
               "devilsmachine":false,
               "metalcavern":false,
               "kingdom1":false,
               "waitingroom":false,
               "theworldthatneverwas":false,
               "skypillar":false,
               "krazoapalace":false,
               "urbanchampion":false,
               "alternate_tracks":false,
               "waterKOs":0,
               "linkHyrule64Condition":false,
               "zeldaHyrule64Condition":false,
               "ghostNessSDs":0,
               "mk64Condition":false,
               "beatDevOnline":false,
               "eventAllStar01":false,
               "events11_20":false,
               "eventAllStar06":false,
               "events21_30":false,
               "eventAllStar07":false,
               "events31_33":false,
               "eventAllStar08":false,
               "events34_40":false,
               "eventAllStar09":false,
               "events41_46":false,
               "eventAllStarBeta":false,
               "events47_51":false,
               "eventsARank":false,
               "eventsSRank":false
            },
            "gamepads":{},
            "controlSettings":{},
            "quality":{
               "stage_effects":"enabled",
               "fullscreen_quality":1,
               "global_effects":1,
               "hit_effects":1,
               "hud_alpha":1,
               "knockback_smoke":1,
               "screen_flash":1,
               "shadows":1,
               "display_quality":StageQuality.BEST,
               "weather":1,
               "ambient_lighting":1,
               "menu_bg":1
            },
            "portInputs":{},
            "once":{
               "firstLaunchShown":false,
               "newsRead":{}
            }
         };
      }
      
      public static function migrate(param1:Object) : Object
      {
         var i:* = undefined;
         var tmp:* = undefined;
         var data:Object = param1;
         i = undefined;
         tmp = undefined;
         trace("Migrations Started");
         if(!data || !data.migration || !(data.migration is String))
         {
            data.migration = "00_init_migration";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "00_init_migration")
         {
            if(data.migrations)
            {
               delete data.migrations;
            }
            data.migration = "01_clean_old_migrations";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "01_clean_old_migrations")
         {
            data.gamepads = {};
            data.migration = "02_create_gamepad";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "02_create_gamepad")
         {
            data.quality = {
               "bg_animations":"enabled",
               "fullscreen_quality":data.options.fullscreen_quality,
               "global_effects":1,
               "hit_effects":1,
               "hud_alpha":1,
               "knockback_smoke":1,
               "screen_flash":1,
               "shadows":1,
               "stage_quality":data.options.quality,
               "weather":0
            };
            delete data.options.quality;
            delete data.options.fullscreen_quality;
            data.migration = "03_quality_settings_support_01";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "03_quality_settings_support_01")
         {
            data.quality.stage_effects = data.quality.bg_animations;
            delete data.quality.bg_animations;
            data.quality.display_quality = data.quality.stage_quality;
            delete data.quality.stage_quality;
            data.quality.ambient_lighting = true;
            data.migration = "04_quality_settings_support_02";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "04_quality_settings_support_02")
         {
            data.quality.menu_bg = true;
            data.migration = "05_menu_bg_quality_settings";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "05_menu_bg_quality_settings")
         {
            data.quality.global_effects = data.quality.global_effects ? 1 : 0;
            data.quality.hit_effects = data.quality.hit_effects ? 1 : 0;
            data.quality.hud_alpha = data.quality.hud_alpha ? 1 : 0;
            data.quality.knockback_smoke = data.quality.knockback_smoke ? 1 : 0;
            data.quality.screen_flash = data.quality.screen_flash ? 1 : 0;
            data.quality.shadows = data.quality.shadows ? 1 : 0;
            data.quality.weather = data.quality.weather ? 1 : 0;
            data.migration = "06_quality_settings_booleans";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "06_quality_settings_booleans")
         {
            delete data.quality.ambient_lighting;
            data.quality.ambient_lighting = 1;
            data.migration = "06_ambient_lighting_fix";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "06_ambient_lighting_fix" || data.migration === "07_gamepad_names_and_ports_map")
         {
            data.gamepads = {};
            data.migration = "07_gamepad_native_ane_bug";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "07_gamepad_native_ane_bug")
         {
            data.gamepads = {};
            data.migration = "08_gamepad_dead_zones_save_data";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "08_gamepad_dead_zones_save_data")
         {
            data.unlocks = {};
            data.migration = "09_reset_unlocks";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "09_reset_unlocks")
         {
            data.options.VS_Items = {};
            data.options.VS_Stages = {};
            data.migration = "10_remove_item_and_stage_switch";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "10_remove_item_and_stage_switch")
         {
            data.portInputs = {};
            data.migration = "11_save_input_devices";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "11_save_input_devices")
         {
            data.records.events = {};
            data.migration = "12_reset_event_records";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "12_reset_event_records")
         {
            data.once = {};
            data.once.firstLaunchShown = false;
            data.migration = "13_once_field_first_launch";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "13_once_field_first_launch")
         {
            data.records.events = {};
            data.migration = "13_reset_event_records_rankings";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "13_reset_event_records_rankings")
         {
            data.records.events = {};
            data.migration = "14_add_score_event_rankings";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "14_add_score_event_rankings")
         {
            data.records.events = {};
            data.migration = "15_add_new_event_scoretypes";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "15_add_new_event_scoretypes")
         {
            data.records.events = {};
            data.migration = "16_fix_event_kos_score";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "16_fix_event_kos_score")
         {
            data.records = getInitialData().records;
            data.unlocks = getInitialData().unlocks;
            data.migration = "17_beta_unlockables_struct";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "17_beta_unlockables_struct")
         {
            data.unlocks.mk64Condition = false;
            data.migration = "18_mk64_unlock";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "18_mk64_unlock")
         {
            data.records = getInitialData().records;
            data.unlocks = getInitialData().unlocks;
            data.migration = "19_beta_unlockables_reset";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "19_beta_unlockables_reset")
         {
            data.controlSettings = SaveData.RawLocalObject.controlSettings;
            delete SaveData.RawLocalObject.controlSettings;
            data.migration = "20_move_control_settings";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "20_move_control_settings")
         {
            data.records.hrc = getInitialData().records.hrc;
            data.migration = "21_hrc_barrier_stages";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "21_hrc_barrier_stages")
         {
            data.unlocks.beatDevOnline = false;
            data.migration = "22_sandbag_online_unlock";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "22_sandbag_online_unlock")
         {
            data.options.arenaScore = 5;
            data.migration = "23_arena_score";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "23_arena_score")
         {
            data.unlocks.eventsARank = false;
            data.unlocks.eventsSRank = false;
            data.migration = "24_final_events";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "24_final_events")
         {
            data.records.events = getInitialData().records.events;
            data.unlocks = getInitialData().unlocks;
            data.migration = "25_event_score_clear";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "25_event_score_clear")
         {
            SaveDataMigrations.postLoadMigrations.push(function():void
            {
               tmp = ResourceManager.getResourceByID("event_mode").getProp("eventList");
               i = 22;
               while(i < tmp.length)
               {
                  delete SaveData.Records.events.wins[tmp[i].id];
                  ++i;
               }
            });
            data.unlocks.eventAllStar07 = false;
            data.unlocks.events31_33 = false;
            data.unlocks.eventAllStar08 = false;
            data.unlocks.events34_40 = false;
            data.unlocks.eventAllStar09 = false;
            data.unlocks.events41_46 = false;
            data.unlocks.eventAllStarBeta = false;
            data.unlocks.events47_51 = false;
            data.unlocks.eventsARank = false;
            data.unlocks.eventsSRank = false;
            data.migration = "26_clear_events_21";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "26_clear_events_21")
         {
            data.records.multiman = getInitialData().records.multiman;
            data.migration = "27_reset_multiman";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "27_reset_multiman")
         {
            delete data.unlocks.desk;
            data.migration = "28_desk_unlockable";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "28_desk_unlockable")
         {
            delete data.records.events.wins["RoleReversal"];
            delete data.records.events.wins["ACelebration"];
            data.migration = "29_fix_events";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "29_fix_events")
         {
            data.records.crystals = getInitialData().records.crystals;
            data.migration = "30_crystal_smash_records";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "30_crystal_smash_records")
         {
            data.unlocks.pichu = false;
            data.migration = "31_pichu_unlock";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "31_pichu_unlock")
         {
            data.options.tcpIP = ProtocolSetting.tcpIP;
            data.options.tcpPort = ProtocolSetting.tcpPort;
            data.options.udpIP = ProtocolSetting.udpIP;
            data.options.udpPort = ProtocolSetting.udpPort;
            data.migration = "32_p2p_config";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "32_p2p_config")
         {
            delete data.options.meleeAirDodge;
            data.options.airDodge = "brawl";
            data.migration = "33_ad_tweak";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "33_ad_tweak")
         {
            delete data.unlocks.sandbag;
            delete data.unlocks.pichu;
            delete data.unlocks.masterball;
            data.migration = "34_psclean";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "34_psclean")
         {
            data.unlocks.theworldthatneverwas = false;
            data.unlocks.skypillar = false;
            data.unlocks.krazoapalace = false;
            data.migration = "35_tsk";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "35_tsk")
         {
            for(tmp in data.gamepads)
            {
               data.gamepads[tmp].names = {};
            }
            data.migration = "36_gp_reset";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "36_gp_reset")
         {
            data.options.VS_UsingStamina = false;
            data.options.VS_StartStamina = 150;
            data.migration = "37_stamina";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "37_stamina")
         {
            data.once.newsRead = {};
            data.migration = "38_news";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "38_news")
         {
            data.records.allstar = getInitialData().records.allstar;
            data.migration = "39_allstar";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "39_allstar")
         {
            data.unlocks.urbanchampion = false;
            data.migration = "40_uc";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "40_uc")
         {
            data.options.replayAutoSave = false;
            data.migration = "41_ras";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "41_ras")
         {
            data.options.VS_FinalSmashMeter = false;
            data.migration = "42_fsm";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "42_fsm")
         {
            data.options.VS_ScoreDisplay = false;
            data.options.VS_HudDisplay = true;
            data.options.VS_PauseEnabled = true;
            data.migration = "43_sdhdpe";
            trace("Migrated to " + data.migration);
         }
         if(data.migration === "43_sdhdpe")
         {
            data.records.racetothefinish = {
               "playTime":0,
               "wins":{}
            };
            data.migration = "44_rttf";
            trace("Migrated to " + data.migration);
         }
         applyFixes(data);
         trace("Migrations Complete");
         return data;
      }
      
      public static function applyFixes(param1:Object) : void
      {
         var i:int = 0;
         var inputTotal:int = 0;
         var namesToDelete:Vector.<String> = null;
         var deviceObj:Object = null;
         var tagSettings:Object = null;
         var data:Object = param1;
         var deviceKey:* = undefined;
         var tagKey:* = undefined;
         var inputKey:* = undefined;
         trace("Applying save data fixes...");
         trace("Clearing out empty gamepad settings for player tags...");
         try
         {
            i = 0;
            inputTotal = 0;
            namesToDelete = new Vector.<String>();
            for(deviceKey in data.gamepads)
            {
               deviceObj = data.gamepads[deviceKey];
               for(tagKey in deviceObj.names)
               {
                  tagSettings = deviceObj.names[tagKey];
                  inputTotal = 0;
                  for(inputKey in tagSettings)
                  {
                     if(typeof tagSettings[inputKey] === "object")
                     {
                        if(tagSettings[inputKey].inputs)
                        {
                           inputTotal += tagSettings[inputKey].inputs.length;
                        }
                        if(tagSettings[inputKey].inputsInverse)
                        {
                           inputTotal += tagSettings[inputKey].inputsInverse.length;
                        }
                     }
                  }
                  if(inputTotal <= 0)
                  {
                     namesToDelete.push(tagKey);
                  }
               }
               i = 0;
               while(i < namesToDelete.length)
               {
                  trace("Deleting empty game tag settings for tag: " + namesToDelete[i]);
                  delete deviceObj.names[namesToDelete[i]];
                  i += 1;
               }
            }
         }
         catch(e:Error)
         {
            trace(e.message);
         }
         trace("Save data fixes completed");
      }
   }
}


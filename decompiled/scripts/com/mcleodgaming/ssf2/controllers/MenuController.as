package com.mcleodgaming.ssf2.controllers
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.menus.*;
   import com.mcleodgaming.ssf2.util.*;
   import com.sbxmod.paletteMaker.*;
   
   public class MenuController
   {
      
      private static var m_debugConsole:DebugConsole;
      
      private static var m_blockedMenu:BlockedMenu;
      
      private static var m_introMenu:IntroMenu;
      
      private static var m_intro2Menu:Intro2Menu;
      
      private static var m_intro3Menu:Intro3Menu;
      
      private static var m_titleMenu:TitleMenu;
      
      private static var m_disclaimerMenu:DisclaimerMenu;
      
      private static var m_devAuthMenu:Menu;
      
      private static var m_devWarningMenu:DevWarningMenu;
      
      private static var m_creditsMenu:CreditsMenu;
      
      private static var m_loadingMenu:LoadingMenu;
      
      private static var m_mainMenu:MainMenu;
      
      private static var m_dataMenu:DataMenu;
      
      private static var m_groupMenu:GroupMenu;
      
      private static var m_arenaMenu:ArenaModeMenu;
      
      private static var m_onlineMenu:OnlineMenu;
      
      private static var m_onlineGroupMenu:OnlineGroupMenu;
      
      private static var m_onlinePromptMenu:OnlinePromptMenu;
      
      private static var m_optionsMenu:OptionsMenu;
      
      private static var m_qualityMenu:QualityMenu;
      
      private static var m_soloMenu:SoloMenu;
      
      private static var m_soundMenu:SoundMenu;
      
      private static var m_stadiumMenu:StadiumMenu;
      
      private static var m_stageSelectMenu:StageSelectMenu;
      
      private static var m_vaultMenu:VaultMenu;
      
      private static var m_newsMenu:NewsMenu;
      
      private static var m_newsArticleMenu:NewsArticleMenu;
      
      private static var m_vsMenu:VSMenu;
      
      private static var m_classicMenu:ClassicModeMenu;
      
      private static var m_allstarMenu:AllStarModeMenu;
      
      private static var m_eventMenu:EventMenu;
      
      private static var m_eventMatchCharacterMenu:EventMatchCharacterMenu;
      
      private static var m_onlineCharacterMenu:OnlineCharacterMenu;
      
      private static var m_trainingMenu:TrainingMenu;
      
      private static var m_targetTestMenu:TargetTestMenu;
      
      private static var m_homeRunContestMenu:HomeRunContestMenu;
      
      private static var m_arenaCharacterSelectMenu:ArenaCharacterSelectMenu;
      
      private static var m_multimanCharacterSelectMenu:MultiManCharacterSelectMenu;
      
      private static var m_crystalSmashCharacterMenu:CrystalSmashCharacterMenu;
      
      private static var m_raceToTheFinishCharacterMenu:RaceToTheFinishCharacterMenu;
      
      private static var m_multimanMenu:MultiManMenu;
      
      private static var m_rulesMenu:RulesMenu;
      
      private static var m_specialModeMenu:SpecialModeMenu;
      
      private static var m_controlsMenu:ControlsMenu;
      
      private static var m_gamepadMenu:GamepadMenu;
      
      private static var m_itemSwitchMenu:ItemSwitchMenu;
      
      private static var m_stageSwitchMenu:StageSwitchMenu;
      
      private static var m_matchResultsMenu:MatchResultsMenu;
      
      private static var m_preUnlockMenu:PreUnlockMenu;
      
      private static var m_postUnlockMenu:PostUnlockMenu;
      
      private static var m_pleaseWaitMenu:PleaseWaitMenu;
      
      private static var m_muteMenu:MuteMenu;
      
      private static var m_hitBoxTestMenu:HitBoxTestMenu;
      
      private static var m_currentCharacterSelectMenu:CharacterSelectMenu;
      
      private static var m_paletteMakerMenu:PaletteMakerMenu;
      
      private static var m_costumeSelectorDisplay:CostumeSelectorDisplay;
      
      public static var m_time:Date;
      
      public static var m_RealTime:String;
      
      private static var m_customMenus:Vector.<CustomAPIMenu> = new Vector.<CustomAPIMenu>();
      
      public function MenuController()
      {
         super();
      }
      
      public static function init() : void
      {
         if(Main.DEBUG)
         {
            m_debugConsole = new DebugConsole();
         }
         m_currentCharacterSelectMenu = null;
         trace("MenuController class initialized");
         PaletteMakerUtils.init();
         m_time = new Date();
         m_RealTime = String(m_time.time).slice(0,-3);
      }
      
      public static function getCurrentTimestamp() : uint
      {
         return uint(new Date().time / 1000);
      }
      
      public static function updateDiscordPresence(param1:String, param2:String, param3:uint, param4:uint, param5:String, param6:String, param7:String, param8:String, param9:String, param10:uint, param11:uint, param12:String, param13:String) : void
      {
         var _loc14_:Object = null;
         if(Boolean(Main.m_sdk) && Boolean(Config.rich_presence))
         {
            _loc14_ = {};
            if(param1)
            {
               _loc14_["state"] = param1;
            }
            if(param2)
            {
               _loc14_["details"] = param2;
            }
            if(param3 > 0)
            {
               _loc14_["timestampStart"] = param3.toString();
            }
            if(param4 > 0)
            {
               _loc14_["timestampEnd"] = param4.toString();
            }
            if(param5)
            {
               _loc14_["largeImage"] = param5;
            }
            if(param6)
            {
               _loc14_["largeText"] = param6;
            }
            if(param7)
            {
               _loc14_["smallImage"] = param7;
            }
            if(param8)
            {
               _loc14_["smallText"] = param8;
            }
            if(param9)
            {
               _loc14_["partyID"] = param9;
            }
            if(param10 > 0)
            {
               _loc14_["partyCurrentSize"] = param10;
            }
            if(param11 > 0)
            {
               _loc14_["partyMaxSize"] = param11;
            }
            if(param12)
            {
               _loc14_["matchSecret"] = param12;
            }
            if(param13)
            {
               _loc14_["joinSecret"] = param13;
            }
            _loc14_["instance"] = true;
            trace("[Discord Activity] SENDING TO SDK");
            trace("[Discord Activity]   - state: " + param1);
            trace("[Discord Activity]   - details: " + param2);
            trace("[Discord Activity]   - partyId: " + param9);
            trace("[Discord Activity]   - partySize: " + param10 + "/" + param11);
            trace("[Discord Activity]   - matchSecret: " + param12);
            trace("[Discord Activity]   - joinSecret: " + param13);
            Main.m_sdk.updateActivity(_loc14_);
         }
      }
      
      public static function buildDiscordJoinSecret(param1:String, param2:String, param3:String = "", param4:int = 0) : String
      {
         if(!param1 || !param2)
         {
            trace("[Discord JoinSecret] WARNING: Cannot build join secret - roomKey: " + param1 + ", roomCode: " + param2);
            return null;
         }
         var _loc5_:Object = {
            "k":param1,
            "c":param2,
            "p":param3 || "",
            "m":param4
         };
         var _loc6_:String = JSON.stringify(_loc5_);
         trace("[Discord JoinSecret] BUILT: " + _loc6_);
         trace("[Discord JoinSecret]   - roomKey: " + param1);
         trace("[Discord JoinSecret]   - roomCode: " + param2);
         trace("[Discord JoinSecret]   - roomPassword: " + (Boolean(param3) && param3 !== "" ? "***" : "(none)"));
         trace("[Discord JoinSecret]   - roomCapacity: " + param4);
         return _loc6_;
      }
      
      public static function getStageDisplayName(param1:String) : String
      {
         var mappingsResource:* = undefined;
         var metadata:Object = null;
         var stageInfo:Object = null;
         var fallbackName:String = null;
         var stageName:String = null;
         var stageID:String = param1;
         trace("[Discord] Getting display name for stage ID: " + stageID);
         if(stageID == null || stageID == "")
         {
            trace("[Discord] Stage ID is null or empty");
            return "Unknown Stage";
         }
         if(stageID === "xpstage")
         {
            trace("[Discord] XP Stage detected");
            return "Expansion Stage";
         }
         if(stageID === "random")
         {
            trace("[Discord] Random stage detected");
            return "Random";
         }
         try
         {
            mappingsResource = ResourceManager.getResourceByID("mappings");
            if(!mappingsResource)
            {
               trace("[Discord] Mappings resource not found");
               fallbackName = stageID.charAt(0).toUpperCase() + stageID.substr(1);
               trace("[Discord] Using fallback name: " + fallbackName);
               return fallbackName;
            }
            metadata = mappingsResource.getProp("metadata");
            if(!metadata)
            {
               trace("[Discord] Metadata not found in mappings");
               fallbackName = stageID.charAt(0).toUpperCase() + stageID.substr(1);
               trace("[Discord] Using fallback name: " + fallbackName);
               return fallbackName;
            }
            stageInfo = metadata.stage;
            trace("[Discord] Stage info object retrieved: " + (stageInfo != null));
            if(Boolean(stageInfo) && Boolean(stageInfo[stageID]))
            {
               stageName = stageInfo[stageID].name;
               trace("[Discord] Found stage name: " + stageName);
               if(Boolean(stageName) && stageName != "")
               {
                  return stageName;
               }
            }
            else
            {
               trace("[Discord] Stage ID not found in mappings: " + stageID);
            }
         }
         catch(e:Error)
         {
            trace("[Discord] Error getting stage name: " + e.message);
         }
         fallbackName = stageID.charAt(0).toUpperCase() + stageID.substr(1);
         trace("[Discord] Using fallback name: " + fallbackName);
         return fallbackName;
      }
      
      public static function getTimerEndTimestamp(param1:*) : uint
      {
         var timer:* = undefined;
         var remainingSeconds:Number = NaN;
         var stageData:* = param1;
         try
         {
            if(Boolean(stageData) && Boolean(stageData.TimerRef))
            {
               timer = stageData.TimerRef;
               if(Boolean(timer.CountDown) && timer.CurrentTime > 0)
               {
                  remainingSeconds = timer.CurrentTime / 30;
                  return getCurrentTimestamp() + uint(remainingSeconds);
               }
            }
         }
         catch(e:Error)
         {
            trace("[Discord] Error calculating timer end: " + e.message);
         }
         return 0;
      }
      
      private static function testMenus() : void
      {
         m_blockedMenu = new BlockedMenu();
         m_introMenu = null;
         m_intro2Menu = null;
         m_intro3Menu = new Intro3Menu();
         m_titleMenu = new TitleMenu();
         m_disclaimerMenu = new DisclaimerMenu();
         m_devWarningMenu = new DevWarningMenu();
         m_creditsMenu = new CreditsMenu();
         m_loadingMenu = new LoadingMenu();
         m_mainMenu = new MainMenu();
         m_dataMenu = new DataMenu();
         m_groupMenu = new GroupMenu();
         m_arenaMenu = new ArenaModeMenu();
         m_onlineMenu = new OnlineMenu();
         m_onlineGroupMenu = new OnlineGroupMenu();
         m_onlinePromptMenu = new OnlinePromptMenu();
         m_optionsMenu = new OptionsMenu();
         m_qualityMenu = new QualityMenu();
         m_soloMenu = new SoloMenu();
         m_soundMenu = new SoundMenu();
         m_stadiumMenu = new StadiumMenu();
         m_stageSelectMenu = new StageSelectMenu();
         m_vaultMenu = new VaultMenu();
         m_newsMenu = new NewsMenu();
         m_newsArticleMenu = new NewsArticleMenu();
         m_eventMenu = new EventMenu();
         m_eventMatchCharacterMenu = new EventMatchCharacterMenu("menu_charselect_event");
         m_onlineCharacterMenu = new OnlineCharacterMenu("menu_charselect_online");
         m_vsMenu = new VSMenu("menu_charselect_vs");
         m_classicMenu = new ClassicModeMenu("menu_charselect_classic");
         m_allstarMenu = new AllStarModeMenu("menu_charselect_allstar");
         m_trainingMenu = new TrainingMenu("menu_charselect_training");
         m_targetTestMenu = new TargetTestMenu("menu_charselect_targettest");
         m_homeRunContestMenu = new HomeRunContestMenu("menu_charselect_hrc");
         m_arenaCharacterSelectMenu = new ArenaCharacterSelectMenu("menu_charselect_arena");
         m_multimanCharacterSelectMenu = new MultiManCharacterSelectMenu("menu_charselect_multiman");
         m_crystalSmashCharacterMenu = new CrystalSmashCharacterMenu("menu_charselect_crystal");
         m_raceToTheFinishCharacterMenu = new RaceToTheFinishCharacterMenu("menu_charselect_rttf");
         m_multimanMenu = new MultiManMenu();
         m_rulesMenu = new RulesMenu();
         m_specialModeMenu = new SpecialModeMenu();
         m_controlsMenu = new ControlsMenu();
         m_gamepadMenu = new GamepadMenu();
         m_itemSwitchMenu = new ItemSwitchMenu();
         m_stageSwitchMenu = new StageSwitchMenu();
         m_matchResultsMenu = null;
         m_preUnlockMenu = new PreUnlockMenu();
         m_postUnlockMenu = new PostUnlockMenu();
         m_pleaseWaitMenu = new PleaseWaitMenu();
         m_customMenus = new Vector.<CustomAPIMenu>();
         m_muteMenu = new MuteMenu();
         m_hitBoxTestMenu = new HitBoxTestMenu();
         m_debugConsole = new DebugConsole();
      }
      
      public static function disposeAllMenus(param1:Boolean = false) : void
      {
         removeAllMenus();
         m_blockedMenu = null;
         m_introMenu = null;
         m_intro2Menu = null;
         m_intro3Menu = null;
         m_titleMenu = null;
         m_disclaimerMenu = null;
         m_devAuthMenu = null;
         m_devWarningMenu = null;
         m_creditsMenu = null;
         m_loadingMenu = null;
         m_mainMenu = null;
         m_dataMenu = null;
         m_groupMenu = null;
         m_onlineMenu = null;
         m_onlineGroupMenu = null;
         m_onlinePromptMenu = null;
         m_optionsMenu = null;
         m_qualityMenu = null;
         m_soloMenu = null;
         m_soundMenu = null;
         m_stadiumMenu = null;
         m_stageSelectMenu = null;
         m_vaultMenu = null;
         m_newsMenu = null;
         m_newsArticleMenu = null;
         if(param1)
         {
            m_eventMenu = null;
         }
         m_multimanMenu = null;
         m_rulesMenu = null;
         m_specialModeMenu = null;
         m_controlsMenu = null;
         m_gamepadMenu = null;
         m_itemSwitchMenu = null;
         m_stageSwitchMenu = null;
         m_matchResultsMenu = null;
         m_preUnlockMenu = null;
         m_postUnlockMenu = null;
         m_pleaseWaitMenu = null;
         m_muteMenu = null;
         m_hitBoxTestMenu = null;
         if(param1)
         {
            m_vsMenu = null;
            m_classicMenu = null;
            m_allstarMenu = null;
            m_eventMatchCharacterMenu = null;
            m_onlineMenu = null;
            m_onlineGroupMenu = null;
            m_trainingMenu = null;
            m_targetTestMenu = null;
            m_homeRunContestMenu = null;
            m_arenaCharacterSelectMenu = null;
            m_arenaMenu = null;
            m_multimanCharacterSelectMenu = null;
            m_crystalSmashCharacterMenu = null;
            m_raceToTheFinishCharacterMenu = null;
            m_currentCharacterSelectMenu = null;
         }
      }
      
      public static function removeAllMenus() : void
      {
         if(m_blockedMenu)
         {
            m_blockedMenu.removeSelf();
         }
         if(m_introMenu)
         {
            m_introMenu.removeSelf();
         }
         if(m_intro2Menu)
         {
            m_intro2Menu.removeSelf();
         }
         if(m_intro3Menu)
         {
            m_intro3Menu.removeSelf();
         }
         if(m_titleMenu)
         {
            m_titleMenu.removeSelf();
         }
         if(m_disclaimerMenu)
         {
            m_disclaimerMenu.removeSelf();
         }
         if(m_devAuthMenu)
         {
            m_devAuthMenu.removeSelf();
         }
         if(m_devWarningMenu)
         {
            m_devWarningMenu.removeSelf();
         }
         if(m_creditsMenu)
         {
            m_creditsMenu.removeSelf();
         }
         if(m_loadingMenu)
         {
            m_loadingMenu.removeSelf();
         }
         if(m_mainMenu)
         {
            m_mainMenu.removeSelf();
         }
         if(m_dataMenu)
         {
            m_dataMenu.removeSelf();
         }
         if(m_groupMenu)
         {
            m_groupMenu.removeSelf();
         }
         if(m_arenaMenu)
         {
            m_arenaMenu.removeSelf();
         }
         if(m_onlineMenu)
         {
            m_onlineMenu.removeSelf();
         }
         if(m_onlineGroupMenu)
         {
            m_onlineGroupMenu.removeSelf();
         }
         if(m_onlinePromptMenu)
         {
            m_onlinePromptMenu.removeSelf();
         }
         if(m_optionsMenu)
         {
            m_optionsMenu.removeSelf();
         }
         if(m_qualityMenu)
         {
            m_qualityMenu.removeSelf();
         }
         if(m_soloMenu)
         {
            m_soloMenu.removeSelf();
         }
         if(m_soundMenu)
         {
            m_soundMenu.removeSelf();
         }
         if(m_stadiumMenu)
         {
            m_stadiumMenu.removeSelf();
         }
         if(m_stageSelectMenu)
         {
            m_stageSelectMenu.removeSelf();
         }
         if(m_vaultMenu)
         {
            m_vaultMenu.removeSelf();
         }
         if(m_newsMenu)
         {
            m_newsMenu.removeSelf();
         }
         if(m_newsArticleMenu)
         {
            m_newsArticleMenu.removeSelf();
         }
         if(m_rulesMenu)
         {
            m_rulesMenu.removeSelf();
         }
         if(m_specialModeMenu)
         {
            m_specialModeMenu.removeSelf();
         }
         if(m_controlsMenu)
         {
            m_controlsMenu.removeSelf();
         }
         if(m_gamepadMenu)
         {
            m_gamepadMenu.removeSelf();
         }
         if(m_itemSwitchMenu)
         {
            m_itemSwitchMenu.removeSelf();
         }
         if(m_stageSwitchMenu)
         {
            m_stageSwitchMenu.removeSelf();
         }
         if(m_preUnlockMenu)
         {
            m_preUnlockMenu.removeSelf();
         }
         if(m_postUnlockMenu)
         {
            m_postUnlockMenu.removeSelf();
         }
         if(m_pleaseWaitMenu)
         {
            m_pleaseWaitMenu.removeSelf();
         }
         if(m_muteMenu)
         {
            m_muteMenu.removeSelf();
         }
         if(m_hitBoxTestMenu)
         {
            m_hitBoxTestMenu.removeSelf();
         }
         if(m_matchResultsMenu)
         {
            m_matchResultsMenu.removeSelf();
         }
         if(m_vsMenu)
         {
            m_vsMenu.removeSelf();
         }
         if(m_classicMenu)
         {
            m_classicMenu.removeSelf();
         }
         if(m_allstarMenu)
         {
            m_allstarMenu.removeSelf();
         }
         if(m_eventMatchCharacterMenu)
         {
            m_eventMatchCharacterMenu.removeSelf();
         }
         if(m_trainingMenu)
         {
            m_trainingMenu.removeSelf();
         }
         if(m_targetTestMenu)
         {
            m_targetTestMenu.removeSelf();
         }
         if(m_homeRunContestMenu)
         {
            m_homeRunContestMenu.removeSelf();
         }
         if(m_arenaCharacterSelectMenu)
         {
            m_arenaCharacterSelectMenu.removeSelf();
         }
         if(m_multimanCharacterSelectMenu)
         {
            m_multimanCharacterSelectMenu.removeSelf();
         }
         if(m_crystalSmashCharacterMenu)
         {
            m_crystalSmashCharacterMenu.removeSelf();
         }
         if(m_raceToTheFinishCharacterMenu)
         {
            m_raceToTheFinishCharacterMenu.removeSelf();
         }
         if(m_arenaCharacterSelectMenu)
         {
            m_arenaCharacterSelectMenu.removeSelf();
         }
         if(m_arenaCharacterSelectMenu)
         {
            m_arenaCharacterSelectMenu.removeSelf();
         }
         if(m_currentCharacterSelectMenu)
         {
            m_currentCharacterSelectMenu.removeSelf();
         }
         while(m_customMenus.length > 0)
         {
            m_customMenus[0].removeSelf();
            m_customMenus.splice(0,1);
         }
         if(m_paletteMakerMenu)
         {
            m_paletteMakerMenu.removeSelf();
         }
         if(m_costumeSelectorDisplay)
         {
            m_costumeSelectorDisplay.removeSelf();
         }
      }
      
      public static function get debugConsole() : DebugConsole
      {
         return m_debugConsole;
      }
      
      public static function get blockedMenu() : Menu
      {
         if(!m_blockedMenu)
         {
            m_blockedMenu = new BlockedMenu();
         }
         return m_blockedMenu;
      }
      
      public static function get introMenu() : IntroMenu
      {
         return m_introMenu;
      }
      
      public static function set introMenu(param1:IntroMenu) : void
      {
         m_introMenu = param1;
      }
      
      public static function get intro2Menu() : Intro2Menu
      {
         return m_intro2Menu;
      }
      
      public static function set intro2Menu(param1:Intro2Menu) : void
      {
         m_intro2Menu = param1;
      }
      
      public static function get intro3Menu() : Intro3Menu
      {
         if(!m_intro3Menu)
         {
            m_intro3Menu = new Intro3Menu();
         }
         return m_intro3Menu;
      }
      
      public static function set intro3Menu(param1:Intro3Menu) : void
      {
         m_intro3Menu = param1;
      }
      
      public static function get titleMenu() : TitleMenu
      {
         if(!m_titleMenu)
         {
            m_titleMenu = new TitleMenu();
         }
         updateDiscordPresence(null,"In menus",getCurrentTimestamp(),0,"ssf2","Super Smash Flash 2",null,null,null,0,0,null,null);
         return m_titleMenu;
      }
      
      public static function get disclaimerMenu() : DisclaimerMenu
      {
         if(!m_disclaimerMenu)
         {
            m_disclaimerMenu = new DisclaimerMenu();
         }
         return m_disclaimerMenu;
      }
      
      public static function get devWarningMenu() : Menu
      {
         if(!m_devWarningMenu)
         {
            m_devWarningMenu = new DevWarningMenu();
         }
         return m_devWarningMenu;
      }
      
      public static function get creditsMenu() : CreditsMenu
      {
         if(!m_creditsMenu)
         {
            m_creditsMenu = new CreditsMenu();
         }
         return m_creditsMenu;
      }
      
      public static function get loadingMenu() : LoadingMenu
      {
         if(!m_loadingMenu)
         {
            m_loadingMenu = new LoadingMenu();
         }
         return m_loadingMenu;
      }
      
      public static function get mainMenu() : MainMenu
      {
         if(!m_mainMenu)
         {
            m_mainMenu = new MainMenu();
         }
         updateDiscordPresence("Main Menu","In menus",getCurrentTimestamp(),0,"ssf2","Super Smash Flash 2",null,null,null,0,0,null,null);
         return m_mainMenu;
      }
      
      public static function get dataMenu() : DataMenu
      {
         if(!m_dataMenu)
         {
            m_dataMenu = new DataMenu();
         }
         updateDiscordPresence("Data","In menus",getCurrentTimestamp(),0,"ssf2","Super Smash Flash 2","data",null,null,0,0,null,null);
         return m_dataMenu;
      }
      
      public static function get groupMenu() : GroupMenu
      {
         if(!m_groupMenu)
         {
            m_groupMenu = new GroupMenu();
         }
         updateDiscordPresence("Group","In menus",getCurrentTimestamp(),0,"ssf2","Super Smash Flash 2","smash",null,null,0,0,null,null);
         return m_groupMenu;
      }
      
      public static function get arenaMenu() : ArenaModeMenu
      {
         if(!m_arenaMenu)
         {
            m_arenaMenu = new ArenaModeMenu();
         }
         updateDiscordPresence("Data","In menus",getCurrentTimestamp(),0,"ssf2","Super Smash Flash 2","arena",null,null,0,0,null,null);
         return m_arenaMenu;
      }
      
      public static function get onlineMenu() : OnlineMenu
      {
         if(!m_onlineMenu)
         {
            m_onlineMenu = new OnlineMenu();
         }
         updateDiscordPresence("Online","In menus",getCurrentTimestamp(),0,"ssf2","Super Smash Flash 2","online",null,null,0,0,null,null);
         return m_onlineMenu;
      }
      
      public static function get onlineGroupMenu() : OnlineGroupMenu
      {
         if(!m_onlineGroupMenu)
         {
            m_onlineGroupMenu = new OnlineGroupMenu();
         }
         return m_onlineGroupMenu;
      }
      
      public static function get onlinePromptMenu() : OnlinePromptMenu
      {
         if(!m_onlinePromptMenu)
         {
            m_onlinePromptMenu = new OnlinePromptMenu();
         }
         return m_onlinePromptMenu;
      }
      
      public static function get optionsMenu() : OptionsMenu
      {
         if(!m_optionsMenu)
         {
            m_optionsMenu = new OptionsMenu();
         }
         updateDiscordPresence("Options","In menus",getCurrentTimestamp(),0,"ssf2","Super Smash Flash 2","option",null,null,0,0,null,null);
         return m_optionsMenu;
      }
      
      public static function get qualityMenu() : QualityMenu
      {
         if(!m_qualityMenu)
         {
            m_qualityMenu = new QualityMenu();
         }
         updateDiscordPresence("Options","In menus",getCurrentTimestamp(),0,"ssf2","Super Smash Flash 2","option",null,null,0,0,null,null);
         return m_qualityMenu;
      }
      
      public static function get soloMenu() : SoloMenu
      {
         if(!m_soloMenu)
         {
            m_soloMenu = new SoloMenu();
         }
         updateDiscordPresence("Solo","In menus",getCurrentTimestamp(),0,"ssf2","Super Smash Flash 2","solo",null,null,0,0,null,null);
         return m_soloMenu;
      }
      
      public static function get soundMenu() : SoundMenu
      {
         if(!m_soundMenu)
         {
            m_soundMenu = new SoundMenu();
         }
         updateDiscordPresence("Options","In menus",getCurrentTimestamp(),0,"ssf2","Super Smash Flash 2","option",null,null,0,0,null,null);
         return m_soundMenu;
      }
      
      public static function get stadiumMenu() : StadiumMenu
      {
         if(!m_stadiumMenu)
         {
            m_stadiumMenu = new StadiumMenu();
         }
         updateDiscordPresence("Stadium","In menus",getCurrentTimestamp(),0,"ssf2","Super Smash Flash 2","stadium",null,null,0,0,null,null);
         return m_stadiumMenu;
      }
      
      public static function get stageSelectMenu() : StageSelectMenu
      {
         if(!m_stageSelectMenu)
         {
            m_stageSelectMenu = new StageSelectMenu();
         }
         return m_stageSelectMenu;
      }
      
      public static function get vaultMenu() : VaultMenu
      {
         if(!m_vaultMenu)
         {
            m_vaultMenu = new VaultMenu();
         }
         updateDiscordPresence("Vault","In menus",getCurrentTimestamp(),0,"ssf2","Super Smash Flash 2","vault",null,null,0,0,null,null);
         return m_vaultMenu;
      }
      
      public static function get newsMenu() : NewsMenu
      {
         if(!m_newsMenu)
         {
            m_newsMenu = new NewsMenu();
         }
         updateDiscordPresence("Reading the news","In menus",getCurrentTimestamp(),0,"ssf2","Super Smash Flash 2","news",null,null,0,0,null,null);
         return m_newsMenu;
      }
      
      public static function get newsArticleMenu() : NewsArticleMenu
      {
         if(!m_newsArticleMenu)
         {
            m_newsArticleMenu = new NewsArticleMenu();
         }
         updateDiscordPresence("Reading the news","In menus",getCurrentTimestamp(),0,"ssf2","Super Smash Flash 2","news",null,null,0,0,null,null);
         return m_newsArticleMenu;
      }
      
      public static function get vsMenu() : VSMenu
      {
         if(!m_vsMenu)
         {
            m_vsMenu = new VSMenu("menu_charselect_vs");
            m_currentCharacterSelectMenu = m_vsMenu;
         }
         updateDiscordPresence("Choosing a character","Group",getCurrentTimestamp(),0,"ssf2","Super Smash Flash 2","smash",null,null,0,0,null,null);
         return m_vsMenu;
      }
      
      public static function get classicMenu() : ClassicModeMenu
      {
         if(!m_classicMenu)
         {
            m_classicMenu = new ClassicModeMenu("menu_charselect_classic");
            m_currentCharacterSelectMenu = m_classicMenu;
         }
         updateDiscordPresence("Choosing a character","Classic Mode",getCurrentTimestamp(),0,"ssf2","Super Smash Flash 2","classic",null,null,0,0,null,null);
         return m_classicMenu;
      }
      
      public static function get allstarMenu() : AllStarModeMenu
      {
         if(!m_allstarMenu)
         {
            m_allstarMenu = new AllStarModeMenu("menu_charselect_allstar");
            m_currentCharacterSelectMenu = m_allstarMenu;
         }
         updateDiscordPresence("Choosing a character","All-Star Mode",getCurrentTimestamp(),0,"ssf2","Super Smash Flash 2","stars",null,null,0,0,null,null);
         return m_allstarMenu;
      }
      
      public static function get eventMenu() : EventMenu
      {
         if(!m_eventMenu)
         {
            m_eventMenu = new EventMenu();
         }
         updateDiscordPresence("Event Mode","In menus",getCurrentTimestamp(),0,"ssf2","Super Smash Flash 2","event",null,null,0,0,null,null);
         return m_eventMenu;
      }
      
      public static function get eventMatchCharacterMenu() : EventMatchCharacterMenu
      {
         if(!m_eventMatchCharacterMenu)
         {
            m_eventMatchCharacterMenu = new EventMatchCharacterMenu("menu_charselect_event");
            m_currentCharacterSelectMenu = m_eventMatchCharacterMenu;
         }
         updateDiscordPresence("Choosing a character","Event Mode",getCurrentTimestamp(),0,"ssf2","Super Smash Flash 2","event",null,null,0,0,null,null);
         return m_eventMatchCharacterMenu;
      }
      
      public static function get onlineCharacterMenu() : OnlineCharacterMenu
      {
         if(!m_onlineCharacterMenu)
         {
            m_onlineCharacterMenu = new OnlineCharacterMenu("menu_charselect_online");
            m_currentCharacterSelectMenu = m_onlineCharacterMenu;
         }
         return m_onlineCharacterMenu;
      }
      
      public static function get trainingMenu() : TrainingMenu
      {
         if(!m_trainingMenu)
         {
            m_trainingMenu = new TrainingMenu("menu_charselect_training");
            m_currentCharacterSelectMenu = m_trainingMenu;
         }
         updateDiscordPresence("Choosing a character","Training",getCurrentTimestamp(),0,"ssf2","Super Smash Flash 2","train",null,null,0,0,null,null);
         return m_trainingMenu;
      }
      
      public static function get targetTestMenu() : TargetTestMenu
      {
         if(!m_targetTestMenu)
         {
            m_targetTestMenu = new TargetTestMenu("menu_charselect_targettest");
            m_currentCharacterSelectMenu = m_targetTestMenu;
         }
         updateDiscordPresence("Choosing a character","Break the Targets",getCurrentTimestamp(),0,"ssf2","Super Smash Flash 2","stadium",null,null,0,0,null,null);
         return m_targetTestMenu;
      }
      
      public static function get homeRunContestMenu() : HomeRunContestMenu
      {
         if(!m_homeRunContestMenu)
         {
            m_homeRunContestMenu = new HomeRunContestMenu("menu_charselect_hrc");
            m_currentCharacterSelectMenu = m_homeRunContestMenu;
         }
         updateDiscordPresence("Choosing a character","Home-Run Contest",getCurrentTimestamp(),0,"ssf2","Super Smash Flash 2","stadium",null,null,0,0,null,null);
         return m_homeRunContestMenu;
      }
      
      public static function get arenaCharacterSelectMenu() : ArenaCharacterSelectMenu
      {
         if(!m_arenaCharacterSelectMenu)
         {
            m_arenaCharacterSelectMenu = new ArenaCharacterSelectMenu("menu_charselect_arena");
            m_currentCharacterSelectMenu = m_arenaCharacterSelectMenu;
         }
         updateDiscordPresence("Choosing a character","Arena",getCurrentTimestamp(),0,"ssf2","Super Smash Flash 2","arena",null,null,0,0,null,null);
         return m_arenaCharacterSelectMenu;
      }
      
      public static function get multimanCharacterSelectMenu() : MultiManCharacterSelectMenu
      {
         if(!m_multimanCharacterSelectMenu)
         {
            m_multimanCharacterSelectMenu = new MultiManCharacterSelectMenu("menu_charselect_multiman");
            m_currentCharacterSelectMenu = m_multimanCharacterSelectMenu;
         }
         updateDiscordPresence("Choosing a character","Multi-Man Smash",getCurrentTimestamp(),0,"ssf2","Super Smash Flash 2","stadium",null,null,0,0,null,null);
         return m_multimanCharacterSelectMenu;
      }
      
      public static function get multimanMenu() : MultiManMenu
      {
         if(!m_multimanMenu)
         {
            m_multimanMenu = new MultiManMenu();
         }
         updateDiscordPresence("Multi-Man Smash","In menus",getCurrentTimestamp(),0,"ssf2","Super Smash Flash 2","stadium",null,null,0,0,null,null);
         return m_multimanMenu;
      }
      
      public static function get crystalSmashCharacterMenu() : CrystalSmashCharacterMenu
      {
         if(!m_crystalSmashCharacterMenu)
         {
            m_crystalSmashCharacterMenu = new CrystalSmashCharacterMenu("menu_charselect_crystal");
            m_currentCharacterSelectMenu = m_crystalSmashCharacterMenu;
         }
         updateDiscordPresence("Choosing a character","Crystal Smash",getCurrentTimestamp(),0,"ssf2","Super Smash Flash 2","stadium",null,null,0,0,null,null);
         return m_crystalSmashCharacterMenu;
      }
      
      public static function get raceToTheFinishCharacterMenu() : RaceToTheFinishCharacterMenu
      {
         if(!m_raceToTheFinishCharacterMenu)
         {
            m_raceToTheFinishCharacterMenu = new RaceToTheFinishCharacterMenu("menu_charselect_rttf");
            m_currentCharacterSelectMenu = m_raceToTheFinishCharacterMenu;
         }
         updateDiscordPresence("Choosing a character","Race to the Finish",getCurrentTimestamp(),0,"ssf2","Super Smash Flash 2","stadium",null,null,0,0,null,null);
         return m_raceToTheFinishCharacterMenu;
      }
      
      public static function get rulesMenu() : RulesMenu
      {
         if(!m_rulesMenu)
         {
            m_rulesMenu = new RulesMenu();
         }
         return m_rulesMenu;
      }
      
      public static function get specialModeMenu() : SpecialModeMenu
      {
         if(!m_specialModeMenu)
         {
            m_specialModeMenu = new SpecialModeMenu();
         }
         return m_specialModeMenu;
      }
      
      public static function get controlsMenu() : ControlsMenu
      {
         if(!m_controlsMenu)
         {
            m_controlsMenu = new ControlsMenu();
         }
         return m_controlsMenu;
      }
      
      public static function get gamepadMenu() : GamepadMenu
      {
         if(!m_gamepadMenu)
         {
            m_gamepadMenu = new GamepadMenu();
         }
         return m_gamepadMenu;
      }
      
      public static function get itemSwitchMenu() : ItemSwitchMenu
      {
         if(!m_itemSwitchMenu)
         {
            m_itemSwitchMenu = new ItemSwitchMenu();
         }
         return m_itemSwitchMenu;
      }
      
      public static function get stageSwitchMenu() : StageSwitchMenu
      {
         if(!m_stageSwitchMenu)
         {
            m_stageSwitchMenu = new StageSwitchMenu();
         }
         return m_stageSwitchMenu;
      }
      
      public static function get matchResultsMenu() : MatchResultsMenu
      {
         return m_matchResultsMenu;
      }
      
      public static function set matchResultsMenu(param1:MatchResultsMenu) : void
      {
         m_matchResultsMenu = param1;
      }
      
      public static function get preUnlockMenu() : PreUnlockMenu
      {
         if(!m_preUnlockMenu)
         {
            m_preUnlockMenu = new PreUnlockMenu();
         }
         return m_preUnlockMenu;
      }
      
      public static function get postUnlockMenu() : PostUnlockMenu
      {
         if(!m_postUnlockMenu)
         {
            m_postUnlockMenu = new PostUnlockMenu();
         }
         return m_postUnlockMenu;
      }
      
      public static function get pleaseWaitMenu() : PleaseWaitMenu
      {
         if(!m_pleaseWaitMenu)
         {
            m_pleaseWaitMenu = new PleaseWaitMenu();
         }
         return m_pleaseWaitMenu;
      }
      
      public static function get muteMenu() : MuteMenu
      {
         if(!m_muteMenu)
         {
            m_muteMenu = new MuteMenu();
         }
         return m_muteMenu;
      }
      
      public static function get customMenus() : Vector.<CustomAPIMenu>
      {
         return m_customMenus;
      }
      
      public static function get CurrentCharacterSelectMenu() : CharacterSelectMenu
      {
         return m_currentCharacterSelectMenu;
      }
      
      public static function set CurrentCharacterSelectMenu(param1:CharacterSelectMenu) : void
      {
         m_currentCharacterSelectMenu = param1;
      }
      
      public static function showInitialMenu() : void
      {
         MenuController.disclaimerMenu.show();
      }
      
      public static function hasControlsMenu() : Boolean
      {
         return m_controlsMenu !== null;
      }
      
      public static function hasItemSwitchMenu() : Boolean
      {
         return m_itemSwitchMenu !== null;
      }
      
      public static function hasStageSwitchMenu() : Boolean
      {
         return m_stageSwitchMenu !== null;
      }
      
      public static function get hitBoxTestMenu() : HitBoxTestMenu
      {
         if(!m_hitBoxTestMenu)
         {
            m_hitBoxTestMenu = new HitBoxTestMenu();
         }
         return m_hitBoxTestMenu;
      }
      
      public static function get paletteMakerMenu() : PaletteMakerMenu
      {
         if(!m_paletteMakerMenu)
         {
            m_paletteMakerMenu = new PaletteMakerMenu();
         }
         return m_paletteMakerMenu;
      }
      
      public static function get costumeSelectorDisplay() : CostumeSelectorDisplay
      {
         if(!m_costumeSelectorDisplay)
         {
            m_costumeSelectorDisplay = new CostumeSelectorDisplay();
         }
         return m_costumeSelectorDisplay;
      }
   }
}


package com.mcleodgaming.ssf2.controllers
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.items.*;
   import com.mcleodgaming.ssf2.menus.*;
   import com.mcleodgaming.ssf2.net.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.events.*;
   import flash.system.*;
   
   public class GameController
   {
      
      public static var stageData:StageData;
      
      public static var tmpStageData:StageData;
      
      public static var currentGame:Game;
      
      public static var onlineModeMatchSettings:Object;
      
      public static var tmpGame:Game;
      
      public static var weather:MovieClip;
      
      public static var cutscene:MovieClip;
      
      public static var tags:MovieClip;
      
      public static var hud:HudMenu;
      
      public static var constantDebugger:ConstantDebuggerMenu;
      
      public static var stage:MovieClip;
      
      public static var background:MovieClip;
      
      public static var stageMusic:String;
      
      public static var loopLoc:Number;
      
      public static var cameraParameters:VcamSettings;
      
      public static var isStarted:Boolean;
      
      private static var matchStarted:Boolean;
      
      private static var m_prepped:Boolean = false;
      
      init();
      
      public function GameController()
      {
         super();
      }
      
      public static function init() : void
      {
         weather = null;
         cutscene = null;
         tags = null;
         hud = null;
         constantDebugger = null;
         stage = null;
         background = null;
         stageMusic = null;
         loopLoc = 0;
         cameraParameters = null;
         matchStarted = false;
      }
      
      private static function getStatsNameForPlayer(param1:int, param2:Vector.<PlayerSetting>) : String
      {
         var _loc3_:* = 0;
         var _loc4_:String = param2[param1].character;
         if(!_loc4_)
         {
            _loc3_ = int(param1 - 1);
            while(_loc3_ >= 0)
            {
               if(param2[_loc3_].character)
               {
                  _loc4_ = param2[_loc3_].character === "random" ? Main.RandCharList[_loc3_].StatsName : param2[_loc3_].character;
                  break;
               }
               _loc3_--;
            }
         }
         else if(_loc4_ === "random")
         {
            _loc4_ = Main.RandCharList[param1].StatsName;
         }
         return _loc4_;
      }
      
      private static function setupRandomCostumes() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Array = null;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         while(_loc8_ < currentGame.PlayerSettings.length)
         {
            if(!currentGame.SuddenDeath && !currentGame.LevelData.teams && (currentGame.PlayerSettings[_loc8_].character == "random" || currentGame.PlayerSettings[_loc8_].isRandom) || currentGame.GameMode == Mode.TRAINING && !currentGame.PlayerSettings[_loc8_].character)
            {
               _loc1_ = 0;
               _loc2_ = new Array();
               _loc3_ = false;
               _loc4_ = 0;
               _loc5_ = 0;
               _loc6_ = GameController.getStatsNameForPlayer(_loc8_,currentGame.PlayerSettings);
               _loc4_ = 0;
               while(_loc4_ < currentGame.PlayerSettings.length)
               {
                  if(Boolean(currentGame.PlayerSettings[_loc4_].exist && currentGame.PlayerSettings[_loc4_].character) && Boolean(currentGame.PlayerSettings[_loc4_].costume == -1) && _loc4_ != _loc8_)
                  {
                     _loc3_ = true;
                  }
                  _loc4_++;
               }
               if(!_loc3_)
               {
                  _loc2_.push(-1);
               }
               while(_loc1_ < ResourceManager.getCostumeCount(_loc6_) - 2)
               {
                  _loc3_ = false;
                  _loc4_ = 0;
                  while(_loc4_ < currentGame.PlayerSettings.length)
                  {
                     _loc7_ = GameController.getStatsNameForPlayer(_loc4_,currentGame.PlayerSettings);
                     if(Boolean(currentGame.PlayerSettings[_loc4_].exist && _loc7_) && Boolean(currentGame.PlayerSettings[_loc4_].costume == _loc1_) && _loc4_ != _loc8_)
                     {
                        _loc3_ = true;
                     }
                     _loc4_++;
                  }
                  if(!_loc3_)
                  {
                     _loc2_.push(_loc1_);
                  }
                  _loc1_++;
               }
               currentGame.PlayerSettings[_loc8_].costume = _loc2_[Utils.randomInteger(0,_loc2_.length - 1)];
            }
            else
            {
               Utils.random();
            }
            _loc8_++;
         }
      }
      
      public static function startMatch(param1:Game = null) : void
      {
         var _loc2_:Resource = null;
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         var _loc5_:Resource = null;
         var _loc6_:* = undefined;
         if(param1)
         {
            GameController.currentGame = param1;
         }
         if(!matchStarted)
         {
            if(Boolean(ModeFeatures.hasFeature(ModeFeatures.MULTIPLAYER_MANAGER,GameController.currentGame.GameMode)) && !GameController.currentGame.SuddenDeath)
            {
               if(MultiplayerManager.RoomData.matchSettings.gameMode === Mode.ONLINE_ARENA)
               {
                  GameController.currentGame.CustomModeObj.PreviousMenu = MultiplayerManager.IsHost ? MenuController.arenaCharacterSelectMenu : MenuController.onlineCharacterMenu;
               }
            }
            Main.Root.visible = false;
            matchStarted = true;
            weather = new MovieClip();
            cutscene = new MovieClip();
            tags = new MovieClip();
            background = new MovieClip();
            hud = new HudMenu();
            constantDebugger = new ConstantDebuggerMenu();
            if(Main.DEBUG)
            {
               hud.Container.addChild(constantDebugger.Container);
            }
            stage = ResourceManager.getLibraryMC(GameController.currentGame.LevelData.stage == "xpstage" ? "xpstage" : "stage_" + GameController.currentGame.LevelData.stage);
            stage.name = "stageMC";
            Main.Root.addChild(background);
            Main.Root.addChild(stage);
            Main.Root.addChild(tags);
            Main.Root.addChild(weather);
            Main.Root.addChild(cutscene);
            Main.Root.addChild(hud.Container);
            _loc2_ = ResourceManager.getResourceByID(GameController.currentGame.LevelData.stage);
            _loc3_ = GameController.currentGame.LevelData.musicOverride ? true : Boolean(_loc2_.getProp("music")) && Boolean(_loc2_.getProp("music").length);
            _loc4_ = _loc3_ ? GameController.currentGame.LevelData.musicOverride || _loc2_.getProp("music")[Main.RandMusicIndex].id : null;
            _loc5_ = _loc4_ ? ResourceManager.getResourceByID(_loc4_) : null;
            if(Boolean(_loc3_) && Boolean(_loc5_) && Boolean(_loc5_.getProp("id3")))
            {
               _loc6_ = _loc5_.getProp("id3");
               if(_loc6_.songName)
               {
                  hud.displayMusicInfo(_loc6_.songName);
               }
            }
            stageMusic = null;
            loopLoc = 0;
            if(_loc5_)
            {
               stageMusic = _loc5_.getProp("music") || null;
               loopLoc = Number(_loc5_.getProp("musicLoop")) || 0;
            }
            cameraParameters = new VcamSettings(_loc2_.getProp("camera"));
            prepOtherHitBoxStuff();
            Main.Root.stage.addEventListener(Event.ENTER_FRAME,actuallyStartMatch);
         }
      }
      
      public static function prepOtherHitBoxStuff() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         if(m_prepped)
         {
            return;
         }
         m_prepped = true;
         var _loc4_:Vector.<String> = new Vector.<String>();
         _loc1_ = 0;
         while(_loc1_ < ItemsListData.DATA.length)
         {
            _loc4_.push(ItemsListData.DATA[_loc1_].linkage_id);
            _loc1_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc4_.length)
         {
            if(!HitBoxManager.HitBoxManageList[_loc4_[_loc2_]])
            {
               _loc3_ = ResourceManager.getLibraryMC(_loc4_[_loc2_]);
               if(_loc3_)
               {
                  _loc1_ = 0;
                  while(_loc1_ < _loc3_.totalFrames)
                  {
                     _loc3_.gotoAndStop(_loc1_ + 1);
                     if(_loc3_.stance)
                     {
                        Utils.removeActionScript(_loc3_.stance);
                        HitBoxAnimation.createHitBoxAnimation(_loc4_[_loc2_] + "_" + _loc3_.currentLabel,_loc3_.stance,_loc3_);
                     }
                     _loc1_++;
                  }
                  _loc3_ = null;
               }
            }
            _loc2_++;
         }
      }
      
      private static function actuallyStartMatch(param1:Event) : void
      {
         var _loc2_:Class = null;
         var _loc4_:int = 0;
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,actuallyStartMatch);
         SaveData.Unlocks.ghostNessSDs = 0;
         var _loc3_:Resource = ResourceManager.getResourceByID(GameController.currentGame.LevelData.stage);
         if(_loc3_)
         {
            _loc2_ = _loc3_.getProp("stage") || _loc3_.MetaData.BASE_CLASSES.SSF2Stage || null;
         }
         Utils.setRandSeed(currentGame.LevelData.randSeed);
         Utils.shuffleRandom();
         Main.prepRandomCharacters(currentGame.PlayerSettings.length);
         if(GameController.currentGame.GameMode === Mode.ONLINE_WAITING_ROOM && GameController.currentGame.PlayerSettings[0].character == "random")
         {
            Main.RandCharList[0] = Main.RandCharList[MultiplayerManager.PlayerID - 1];
         }
         GameController.setupRandomCostumes();
         if(ModeFeatures.hasFeature(ModeFeatures.MULTIPLAYER_MANAGER,GameController.currentGame.GameMode))
         {
            GameController.currentGame.fixDuplicateCostumes();
         }
         var _loc5_:Vector.<Controller> = ModeFeatures.hasFeature(ModeFeatures.MULTIPLAYER_MANAGER,GameController.currentGame.GameMode) ? MultiplayerManager.Controllers : SaveData.Controllers;
         GameController.stageData = new StageData(_loc5_,Main.Root,_loc2_,stage,hud,cameraParameters,GameController.currentGame,SoundQueue.instance,stageMusic,loopLoc);
         constantDebugger.makeEvents();
         GameController.stageData.startGame();
      }
      
      public static function endMatch() : void
      {
         if(matchStarted)
         {
            GameController.stageData.CamRef.die();
            weather.parent.removeChild(weather);
            cutscene.parent.removeChild(cutscene);
            tags.parent.removeChild(tags);
            stage.parent.removeChild(stage);
            background.parent.removeChild(background);
            hud.removeSelf();
            constantDebugger.killEvents();
            init();
            trace("Game graphics and stage data disposed");
         }
      }
      
      public static function destroyStageData() : void
      {
         if(GameController.stageData)
         {
            GameController.stageData.dispose();
         }
         GameController.stage = null;
         GameController.stageData = null;
         GameController.tmpStageData = null;
         GameController.tmpGame = null;
         Main.clearRandomCharacterPrep();
         SoundQueue.instance.setLoopFunction(SoundQueue.instance.loopMusic);
         System.gc();
      }
   }
}


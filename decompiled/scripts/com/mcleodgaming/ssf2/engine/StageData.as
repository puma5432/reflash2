package com.mcleodgaming.ssf2.engine
{
   import com.adobe.images.*;
   import com.mcleodgaming.mgn.events.*;
   import com.mcleodgaming.mgn.net.*;
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.api.*;
   import com.mcleodgaming.ssf2.assists.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.enemies.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.events.*;
   import com.mcleodgaming.ssf2.input.*;
   import com.mcleodgaming.ssf2.items.*;
   import com.mcleodgaming.ssf2.menus.*;
   import com.mcleodgaming.ssf2.modapi.*;
   import com.mcleodgaming.ssf2.net.*;
   import com.mcleodgaming.ssf2.platforms.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filesystem.*;
   import flash.geom.*;
   import flash.media.Sound;
   import flash.utils.*;
   
   public class StageData
   {
      
      private var m_apiInstance:SSF2Stage;
      
      private var EFFECT_LIMIT:int = 60;
      
      private var EFFECT_LIMIT_SECONDARY:int = 10;
      
      private var ROOT:MovieClip;
      
      private var STAGE:MovieClip;
      
      private var STAGEPARENT:MovieClip;
      
      private var STAGEBACKGROUND:MovieClip;
      
      private var STAGEFOREGROUND:MovieClip;
      
      private var STAGEEFFECTS:MovieClip;
      
      private var WEATHER:MovieClip;
      
      private var WEATHERMASK:MovieClip;
      
      private var TAGS:MovieClip;
      
      private var REFLECTIONS:MovieClip;
      
      private var REFLECTIONSMASK:MovieClip;
      
      private var SHADOWS:MovieClip;
      
      private var SHADOWMASK:MovieClip;
      
      private var LIGHTSOURCE:MovieClip;
      
      private var CUTSCENE:MovieClip;
      
      private var HUD:HudMenu;
      
      private var HUDFOREGROUND:MovieClip;
      
      private var HUDOVERLAY:MovieClip;
      
      private var HUDTEXT:MovieClip;
      
      private var CAM:Vcam;
      
      private var ITEMS:ItemGenerator;
      
      private var GAME:Game;
      
      private var SOUNDQUEUE:SoundQueue;
      
      private var TIMER:GameTimer;
      
      private var CONTROLLERS:Vector.<Controller>;
      
      private var CAMBOUNDS:MovieClip;
      
      private var SMASHBALLBOUNDS:MovieClip;
      
      private var DEATHBOUNDS:MovieClip;
      
      private var TERRAINS:Vector.<Platform>;
      
      private var PLATFORMS:Vector.<Platform>;
      
      private var COLLISION_BOUNDARIES:Vector.<BitmapCollisionBoundary>;
      
      private var MOVINGPLATFORMS:Vector.<MovingPlatform>;
      
      private var TARGETS:Vector.<TargetTestTarget>;
      
      private var ITEMGENS:Vector.<MovieClip>;
      
      private var WARNINGBOUNDS_UL:Vector.<BitmapCollisionBoundary>;
      
      private var WARNINGBOUNDS_UR:Vector.<BitmapCollisionBoundary>;
      
      private var WARNINGBOUNDS_LL:Vector.<BitmapCollisionBoundary>;
      
      private var WARNINGBOUNDS_LR:Vector.<BitmapCollisionBoundary>;
      
      private var LEDGES_L:Vector.<MovieClip>;
      
      private var LEDGES_R:Vector.<MovieClip>;
      
      private var START_POSITIONS:Vector.<MovieClip>;
      
      private var SPAWN_POSITIONS:Vector.<MovieClip>;
      
      private var WALLS:Vector.<BitmapCollisionBoundary>;
      
      private var BEACONS:Vector.<Beacon>;
      
      private var ADJMATRIX:Array;
      
      private var m_eventManager:EventManager;
      
      private var READY:Boolean;
      
      private var ONLINEMODE:Boolean;
      
      private var REPLAYMODE:Boolean;
      
      private var m_apiDisposeList:Array;
      
      private var m_hitBoxProcessor:HitBoxProcessor;
      
      private var m_countdownTimer:MovieClip;
      
      private var m_onlineFrameBuffer:FrameTimer;
      
      private var m_onlineMatchDowngradeTimeout:Timer;
      
      private var m_onlineMatchStartTimeout:Timer;
      
      private var m_onlineMatchEndTimeout:Timer;
      
      private var m_onlineLockPending:Boolean;
      
      private var m_onlineModeLastPing:Number;
      
      private var m_onlineMatchControlsTimer:Timer;
      
      private var m_activeScripts:Boolean;
      
      private var m_fpsTimer:Debug_fps;
      
      private var m_noContest:Boolean;
      
      private var m_retryMatch:Boolean;
      
      private var m_pokemonCount:int;
      
      private var m_assistCount:int;
      
      private var m_cuccoCount:int;
      
      private var m_entranceZoomTimer:FrameTimer;
      
      private var m_entranceZoomMode:int;
      
      private var m_currentEntrance:int;
      
      private var m_airDodge:String;
      
      private var m_paused:Boolean;
      
      private var m_pausedLetGo:Boolean;
      
      private var m_pauseCamHeight:Number;
      
      private var m_replayFrameStep:Boolean;
      
      private var m_zLetGo:Boolean;
      
      private var m_paused_id:int;
      
      private var m_fsCutscene:MovieClip;
      
      private var m_fsCutins:int;
      
      private var m_hazardsOn:Boolean;
      
      private var m_justPaused:Boolean;
      
      private var m_event:Boolean;
      
      private var m_music:String;
      
      private var m_loopLoc:Number;
      
      private var PLAYERS:Vector.<Character>;
      
      private var CHARACTERS:Vector.<Character>;
      
      private var ENEMY:Vector.<Enemy>;
      
      private var PROJECTILES:Vector.<Projectile>;
      
      private var m_effectList:Vector.<MovieClip>;
      
      private var m_effectIndex:int;
      
      private var m_effectOverlayList:Vector.<MovieClip>;
      
      private var m_effectOverlayIndex:int;
      
      private var m_effectHUDList:Vector.<MovieClip>;
      
      private var m_effectHUDIndex:int;
      
      private var m_effectHUDOverlayList:Vector.<MovieClip>;
      
      private var m_effectHUDOverlayIndex:int;
      
      private var m_effectBGList:Vector.<MovieClip>;
      
      private var m_effectBGIndex:int;
      
      private var m_effectWeatherList:Vector.<MovieClip>;
      
      private var m_effectWeatherIndex:int;
      
      private var m_wasReset:Boolean;
      
      private var m_gravityMultiplier:Number;
      
      private var m_disableCeilingDeath:Boolean;
      
      private var m_disableFallDeath:Boolean;
      
      private var m_freezeKeys:Boolean;
      
      private var m_endGameTimer:FrameTimer;
      
      private var m_canSuddenDeath:Boolean;
      
      private var m_suddenDeath:Boolean;
      
      private var m_suddenDeathIDs:Array;
      
      private var m_gameEnded:Boolean;
      
      private var m_gameEndedExit:Boolean;
      
      private var m_slowFrameRate:Boolean;
      
      private var m_endTrigger:Boolean;
      
      private var m_endGameOptions:Object;
      
      private var m_nullPlayers:Array;
      
      private var m_crowdChantDelay:FrameTimer;
      
      private var m_crowdChantTimer:FrameTimer;
      
      private var m_crowdChantID:int;
      
      private var m_crowdChantSound:SoundObject;
      
      protected var m_pokemon:Vector.<Class>;
      
      protected var m_assists:Vector.<Class>;
      
      protected var m_pokemonRare:Vector.<Class>;
      
      protected var m_assistsRare:Vector.<Class>;
      
      protected var m_narratorSpeech:SoundObject;
      
      private var m_startDelayTimer:FrameTimer;
      
      private var m_startTime:int;
      
      private var m_endTime:int;
      
      private var m_elapsedFrames:int;
      
      private var m_elapsedPlayableFrames:int;
      
      private var m_pausedTimestamp:int;
      
      private var m_totalPausedTime:int;
      
      private var m_soundMemory:com.mcleodgaming.ssf2.util.Dictionary;
      
      private var m_qualitySettings:Object;
      
      private var m_replayData:ReplayData;
      
      private var m_replayFrameRateMultiplier:Number;
      
      private var m_queuedAutoSave:Boolean;
      
      private var m_timers:Vector.<IntervalTimer>;
      
      private var m_playerStartIndices:Array;
      
      private var m_starKOEnabled:Boolean;
      
      private var m_screenKOEnabled:Boolean;
      
      private var m_logText:String;
      
      private var m_collisionsEnabled:Boolean;
      
      private var m_timestop:Boolean;
      
      private var m_timestopStateTimer:Object;
      
      public function StageData(param1:Vector.<Controller>, param2:MovieClip, param3:Class, param4:MovieClip, param5:HudMenu, param6:VcamSettings, param7:Game, param8:SoundQueue, param9:String, param10:Number)
      {
         var _loc11_:* = undefined;
         var _loc12_:int = 0;
         var _loc13_:String = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:Object = null;
         var _loc17_:int = 0;
         super();
         SSF2API.init(this);
         ModAPI.init(this);
         this.m_apiInstance = param3 ? new SSF2Stage(param3,this) : null;
         Utils.resetUID();
         this.m_wasReset = false;
         this.m_startDelayTimer = new FrameTimer(2);
         this.GAME = param7;
         this.m_qualitySettings = {
            "stage_effects":SaveData.Quality.stage_effects,
            "fullscreen_quality":SaveData.Quality.fullscreen_quality,
            "global_effects":(SaveData.Quality.global_effects ? true : false),
            "hit_effects":(SaveData.Quality.hit_effects ? true : false),
            "hud_alpha":(SaveData.Quality.hud_alpha ? true : false),
            "knockback_smoke":(SaveData.Quality.knockback_smoke ? true : false),
            "screen_flash":(SaveData.Quality.screen_flash ? true : false),
            "shadows":(SaveData.Quality.shadows ? true : false),
            "display_quality":SaveData.Quality.display_quality,
            "weather":(SaveData.Quality.weather ? true : false),
            "ambient_lighting":(SaveData.Quality.ambient_lighting ? true : false),
            "menu_bg":(SaveData.Quality.menu_bg ? true : false)
         };
         this.m_canSuddenDeath = !this.GAME.SuddenDeath;
         this.m_collisionsEnabled = true;
         this.m_suddenDeath = false;
         this.m_suddenDeathIDs = null;
         this.ONLINEMODE = ModeFeatures.hasFeature(ModeFeatures.MULTIPLAYER_MANAGER,this.GAME.GameMode);
         this.m_onlineFrameBuffer = new FrameTimer(MultiplayerManager.INPUT_BUFFER);
         if(SpecialMode.modeEnabled(this.GAME.LevelData.specialModes,SpecialMode.SLOW))
         {
            MultiplayerManager.NORMAL_FPS = Main.FRAMERATE / 2;
            MultiplayerManager.MAX_FPS = 20;
         }
         else if(SpecialMode.modeEnabled(this.GAME.LevelData.specialModes,SpecialMode.LIGHTNING))
         {
            MultiplayerManager.NORMAL_FPS = Main.FRAMERATE * 2;
            MultiplayerManager.MAX_FPS = 70;
         }
         else
         {
            MultiplayerManager.NORMAL_FPS = Main.FRAMERATE;
            MultiplayerManager.MAX_FPS = 35;
         }
         this.m_onlineMatchDowngradeTimeout = new Timer(15000,1);
         this.m_onlineMatchDowngradeTimeout.addEventListener(TimerEvent.TIMER_COMPLETE,this.onlineModeMatchDowngradeTimeout);
         this.m_onlineMatchStartTimeout = new Timer(30000,1);
         this.m_onlineMatchStartTimeout.addEventListener(TimerEvent.TIMER_COMPLETE,this.onlineModeMatchStartTimeout);
         this.m_onlineMatchEndTimeout = new Timer(10000,1);
         this.m_onlineMatchEndTimeout.addEventListener(TimerEvent.TIMER_COMPLETE,this.onlineModeMatchEndTimeout);
         this.m_onlineLockPending = false;
         this.m_onlineModeLastPing = new Date().getTime();
         this.m_onlineMatchControlsTimer = new Timer(Math.floor(1000 / MultiplayerManager.NORMAL_FPS));
         this.m_onlineMatchControlsTimer.addEventListener(TimerEvent.TIMER,this.onlineModeSendControls);
         this.m_effectList = new Vector.<MovieClip>();
         this.m_effectOverlayList = new Vector.<MovieClip>();
         this.m_effectHUDList = new Vector.<MovieClip>();
         this.m_effectHUDOverlayList = new Vector.<MovieClip>();
         this.m_effectBGList = new Vector.<MovieClip>();
         this.m_effectWeatherList = new Vector.<MovieClip>();
         _loc17_ = 0;
         while(_loc17_ < this.EFFECT_LIMIT)
         {
            this.m_effectList.push(null);
            this.m_effectOverlayList.push(null);
            this.m_effectHUDList.push(null);
            this.m_effectHUDOverlayList.push(null);
            this.m_effectBGList.push(null);
            this.m_effectWeatherList.push(null);
            _loc17_++;
         }
         this.m_effectIndex = 0;
         this.m_effectOverlayIndex = 0;
         this.m_effectHUDIndex = 0;
         this.m_effectHUDIndex = 0;
         this.m_effectBGIndex = 0;
         this.m_effectWeatherIndex = 0;
         this.m_apiDisposeList = new Array();
         this.m_hitBoxProcessor = new HitBoxProcessor();
         this.m_soundMemory = new Dictionary(String);
         this.m_timers = new Vector.<IntervalTimer>();
         this.m_replayData = new ReplayData(this.GAME.PlayerSettings.length);
         this.m_replayFrameRateMultiplier = 1;
         this.m_queuedAutoSave = false;
         if(!this.GAME.ReplayDataObj && Boolean(ModeFeatures.hasFeature(ModeFeatures.ALLOW_REPLAY_RECORD,this.GAME.GameMode)))
         {
            this.REPLAYMODE = false;
            if(this.GAME.SuddenDeath)
            {
               this.m_replayData = GameController.tmpStageData.ReplayDataObj;
            }
            else
            {
               this.m_replayData.MatchSettings = this.GAME.LevelData.exportSettings();
               this.m_replayData.ItemSettingsObj = this.GAME.Items.exportSettings();
               this.m_replayData.GameMode = this.GAME.GameMode;
               _loc12_ = 0;
               while(_loc12_ < this.GAME.PlayerSettings.length)
               {
                  this.m_replayData.PlayerData[_loc12_] = this.GAME.PlayerSettings[_loc12_].exportSettings();
                  if(this.GAME.PlayerSettings[_loc12_].character == "random")
                  {
                  }
                  _loc12_++;
               }
            }
         }
         else if(Boolean(this.GAME.ReplayDataObj) && Boolean(ModeFeatures.hasFeature(ModeFeatures.ALLOW_REPLAY_RECORD,this.GAME.GameMode)))
         {
            this.REPLAYMODE = true;
            if(this.GAME.SuddenDeath)
            {
               this.m_replayData = GameController.tmpStageData.ReplayDataObj;
            }
            else
            {
               this.m_replayData.importReplay(this.GAME.ReplayDataObj.exportReplay());
               this.m_replayData.resetPointers();
            }
         }
         if(this.GAME.SuddenDeath)
         {
            Utils.shuffleRandom();
         }
         if(ModeFeatures.hasFeature(ModeFeatures.FORCE_NO_TEAM_DAMAGE,this.GAME.GameMode))
         {
            this.GAME.LevelData.teamDamage = false;
         }
         if(Config.enable_hazards)
         {
            this.m_hazardsOn = this.GAME.LevelData.hazards;
         }
         else
         {
            this.m_hazardsOn = false;
         }
         this.READY = false;
         this.ROOT = param2;
         this.STAGEPARENT = param4;
         this.STAGE = param4.terrain;
         this.HUD = param5;
         this.HUDFOREGROUND = param5.SubMenu.foreground;
         this.HUDOVERLAY = new MovieClip();
         this.HUDTEXT = new MovieClip();
         param5.SubMenu.addChild(this.HUDOVERLAY);
         param5.SubMenu.addChild(this.HUDTEXT);
         this.WEATHER = GameController.weather;
         this.CUTSCENE = GameController.cutscene;
         this.WEATHERMASK = this.STAGEPARENT.weatherMask ? this.STAGEPARENT.weatherMask : null;
         if(this.WEATHERMASK)
         {
            this.WEATHER.mask = this.WEATHERMASK;
         }
         this.TAGS = GameController.tags;
         this.REFLECTIONS = new MovieClip();
         this.REFLECTIONS.x = this.STAGE.x;
         this.REFLECTIONS.y = this.STAGE.y;
         this.STAGEPARENT.addChildAt(this.REFLECTIONS,this.STAGEPARENT.getChildIndex(this.STAGE));
         this.REFLECTIONSMASK = this.STAGEPARENT["reflectionMask"];
         if(this.REFLECTIONSMASK)
         {
            this.REFLECTIONS.mask = this.REFLECTIONSMASK;
            this.REFLECTIONSMASK.visible = false;
         }
         this.SHADOWS = new MovieClip();
         this.SHADOWS.x = this.STAGE.x;
         this.SHADOWS.y = this.STAGE.y;
         this.STAGEPARENT.addChildAt(this.SHADOWS,this.STAGEPARENT.getChildIndex(this.STAGE));
         this.SHADOWMASK = this.STAGEPARENT["shadowMask"];
         if(this.SHADOWMASK)
         {
            this.SHADOWS.mask = this.SHADOWMASK;
            this.SHADOWMASK.visible = false;
         }
         this.STAGEEFFECTS = MovieClip(this.STAGEPARENT.addChild(new MovieClip()));
         this.LIGHTSOURCE = null;
         this.SOUNDQUEUE = param8;
         this.CONTROLLERS = param1;
         this.CAMBOUNDS = this.STAGE["camBoundary"];
         this.SMASHBALLBOUNDS = this.STAGE["smashBallBoundary"];
         this.DEATHBOUNDS = this.STAGE["deathBoundary"];
         param6.mainTerrain = this.CAMBOUNDS;
         this.CAM = new Vcam(param6,this.STAGE,Main.Root);
         this.TIMER = new GameTimer({
            "instanceName":"clock",
            "countdown":this.GAME.CountDown,
            "startAt":this.GAME.Time
         },this);
         if(ModeFeatures.hasFeature(ModeFeatures.INVERTED_TIMER,this.GAME.GameMode))
         {
            this.TIMER.CountDown = false;
            this.TIMER.setCurrentTime(0);
         }
         this.TIMER.TimeMC.visible = false;
         this.TERRAINS = new Vector.<Platform>();
         this.PLATFORMS = new Vector.<Platform>();
         this.COLLISION_BOUNDARIES = new Vector.<BitmapCollisionBoundary>();
         this.MOVINGPLATFORMS = new Vector.<MovingPlatform>();
         this.TARGETS = new Vector.<TargetTestTarget>();
         this.WARNINGBOUNDS_UL = new Vector.<BitmapCollisionBoundary>();
         this.WARNINGBOUNDS_UR = new Vector.<BitmapCollisionBoundary>();
         this.WARNINGBOUNDS_LL = new Vector.<BitmapCollisionBoundary>();
         this.WARNINGBOUNDS_LR = new Vector.<BitmapCollisionBoundary>();
         this.LEDGES_L = new Vector.<MovieClip>();
         this.LEDGES_R = new Vector.<MovieClip>();
         this.START_POSITIONS = new Vector.<MovieClip>();
         this.SPAWN_POSITIONS = new Vector.<MovieClip>();
         this.WALLS = new Vector.<BitmapCollisionBoundary>();
         this.BEACONS = new Vector.<Beacon>();
         this.PLAYERS = new Vector.<Character>();
         this.CHARACTERS = new Vector.<Character>();
         this.ENEMY = new Vector.<Enemy>();
         this.PROJECTILES = new Vector.<Projectile>();
         this.m_activeScripts = false;
         this.m_eventManager = new EventManager();
         this.m_entranceZoomTimer = new FrameTimer(15 * this.GAME.PlayerSettings.length);
         this.m_entranceZoomMode = Utils.random() > 0.5 ? 1 : 2;
         this.m_currentEntrance = 0;
         this.m_airDodge = SaveData.AirDodge;
         this.m_narratorSpeech = null;
         this.m_endGameTimer = new FrameTimer(ModeFeatures.hasFeature(ModeFeatures.EXTENDED_ENDTIMER,this.GAME.GameMode) ? int(32 * 4) : 32);
         this.m_gameEnded = false;
         this.m_gameEndedExit = true;
         this.m_slowFrameRate = false;
         this.m_endTrigger = false;
         this.m_endGameOptions = null;
         this.m_music = param9;
         this.m_loopLoc = param10;
         this.m_noContest = false;
         this.m_retryMatch = false;
         this.m_freezeKeys = false;
         this.m_pokemonCount = 0;
         this.m_assistCount = 0;
         this.m_cuccoCount = 0;
         this.m_startTime = getTimer();
         this.m_endTime = this.m_startTime;
         this.m_elapsedFrames = 0;
         this.m_elapsedPlayableFrames = 0;
         this.m_pausedTimestamp = 0;
         this.m_totalPausedTime = 0;
         this.m_starKOEnabled = true;
         this.m_screenKOEnabled = true;
         this.ITEMGENS = new Vector.<MovieClip>();
         this.m_nullPlayers = new Array();
         if(ModeFeatures.hasFeature(ModeFeatures.FILL_PLAYER_SLOTS,this.GAME.GameMode))
         {
            _loc13_ = null;
            _loc14_ = -1;
            _loc15_ = -1;
            _loc17_ = 2;
            while(_loc17_ <= this.GAME.PlayerSettings.length)
            {
               if(this.GAME.PlayerSettings[_loc17_ - 1].character != null)
               {
                  _loc13_ = this.GAME.PlayerSettings[_loc17_ - 1].character;
                  _loc14_ = _loc17_;
                  _loc15_ = int(this.GAME.PlayerSettings[_loc17_ - 1].expansion);
                  break;
               }
               _loc17_++;
            }
            _loc17_ = 2;
            while(_loc17_ <= this.GAME.PlayerSettings.length)
            {
               if(this.GAME.PlayerSettings[_loc17_ - 1].character == null)
               {
                  this.GAME.PlayerSettings[_loc17_ - 1].character = _loc13_;
                  this.GAME.PlayerSettings[_loc17_ - 1].expansion = _loc15_;
                  Main.RandCharList[_loc17_ - 1] = Main.RandCharList[_loc14_ - 1];
                  this.m_nullPlayers.push(_loc17_ - 1);
               }
               _loc17_++;
            }
         }
         var _loc18_:Array = new Array();
         _loc17_ = 0;
         _loc11_ = 0;
         while(_loc17_ < this.GAME.PlayerSettings.length)
         {
            if(Boolean(this.GAME.PlayerSettings[_loc17_].exist) && Boolean(this.GAME.PlayerSettings[_loc17_].character))
            {
               _loc18_.push(_loc11_++);
            }
            _loc17_++;
         }
         if(_loc11_ > 2)
         {
            Utils.randomizeArray(_loc18_);
         }
         this.m_playerStartIndices = new Array();
         _loc17_ = 0;
         _loc11_ = 0;
         while(_loc17_ < this.GAME.PlayerSettings.length)
         {
            if(Boolean(this.GAME.PlayerSettings[_loc17_].exist) && Boolean(this.GAME.PlayerSettings[_loc17_].character))
            {
               this.m_playerStartIndices.push(_loc18_.splice(0,1)[0]);
            }
            else
            {
               this.m_playerStartIndices.push(null);
            }
            _loc17_++;
         }
         this.findObjects(this.STAGE);
         if(this.STAGEPARENT.foreground)
         {
            this.STAGEFOREGROUND = this.STAGEPARENT.foreground;
            this.findObjects(this.STAGEPARENT.foreground);
         }
         else
         {
            this.STAGEFOREGROUND = new MovieClip();
            this.STAGEPARENT.addChild(this.STAGEFOREGROUND);
         }
         if(this.STAGEPARENT.background)
         {
            this.STAGEBACKGROUND = this.STAGEPARENT.background;
            this.findObjects(this.STAGEPARENT.background);
         }
         else
         {
            this.STAGEBACKGROUND = new MovieClip();
            this.STAGEPARENT.addChildAt(this.STAGEBACKGROUND,0);
         }
         this.createBeaconData();
         _loc17_ = 0;
         while(_loc17_ < this.MOVINGPLATFORMS.length)
         {
            this.MOVINGPLATFORMS[_loc17_].findForegroundPieces();
            this.MOVINGPLATFORMS[_loc17_].findLedges();
            _loc17_++;
         }
         this.ITEMS = new ItemGenerator({
            "sizeRatio":this.GAME.SizeRatio,
            "frequency":(this.GAME.SuddenDeath ? 0 : this.GAME.Items.frequency),
            "itemData":this.GAME.Items.items
         },this);
         _loc17_ = 0;
         while(_loc17_ < this.GameRef.PlayerSettings.length)
         {
            this.PLAYERS.push(null);
            _loc17_++;
         }
         this.m_pausedLetGo = true;
         this.m_pauseCamHeight = 0;
         this.m_replayFrameStep = false;
         this.m_zLetGo = true;
         this.m_paused = false;
         this.m_paused_id = 0;
         this.m_fsCutscene = null;
         this.m_fsCutins = 0;
         this.m_justPaused = false;
         this.m_event = true;
         if(ModeFeatures.hasFeature(ModeFeatures.FORCE_NO_ITEM_AUTO_SPAWN,this.GAME.GameMode))
         {
            this.ItemsRef.Frequency = ItemSettings.FREQUENCY_OFF;
         }
         this.m_pokemon = new Vector.<Class>();
         for each(_loc11_ in ResourceManager.getPokemonStatsData().common)
         {
            this.m_pokemon.push(_loc11_);
         }
         this.m_pokemonRare = new Vector.<Class>();
         for each(_loc11_ in ResourceManager.getPokemonStatsData().rare)
         {
            this.m_pokemonRare.push(_loc11_);
         }
         this.m_assists = new Vector.<Class>();
         for each(_loc11_ in ResourceManager.getAssistStatsData().common)
         {
            this.m_assists.push(_loc11_);
         }
         this.m_assistsRare = new Vector.<Class>();
         for each(_loc11_ in ResourceManager.getAssistStatsData().rare)
         {
            this.m_assistsRare.push(_loc11_);
         }
         this.m_disableCeilingDeath = false;
         this.m_disableFallDeath = false;
         this.m_gravityMultiplier = 1;
         this.m_crowdChantDelay = new FrameTimer(30 * 20);
         this.m_crowdChantTimer = new FrameTimer(30 * 20);
         this.m_crowdChantID = -1;
         this.m_crowdChantSound = null;
         this.m_crowdChantTimer.finish();
         this.m_logText = "";
         if(this.GAME.GameMode === Mode.ONLINE_WAITING_ROOM)
         {
            Main.Root.stage.addEventListener(Event.ENTER_FRAME,this.waitForPlayers);
            if(!MultiplayerManager.IsHost)
            {
               _loc16_ = Utils.cloneObject(GameController.onlineModeMatchSettings.playerSettings[0]);
               if(_loc16_.character === "random")
               {
                  _loc16_.character = this.PLAYERS[0].StatsName;
               }
               MultiplayerManager.sendMatchReadySignal({"playerSettings":_loc16_});
            }
         }
         this.m_timestop = false;
         this.m_timestopStateTimer = new Object();
         _loc17_ = 1;
         while(_loc17_ <= this.GAME.PlayerSettings.length)
         {
            if(this.GAME.PlayerSettings[_loc17_ - 1].character != null)
            {
               this.makePlayer(_loc17_);
            }
            _loc17_++;
         }
      }
      
      public function get BASE_CLASSES() : Object
      {
         return ResourceManager.getResourceByID(this.GAME.LevelData.stage).MetaData.BASE_CLASSES;
      }
      
      private function findObjects(param1:MovieClip) : void
      {
         var tmpPlayerSetting:PlayerSetting = null;
         var curObject:MovieClip = null;
         var tmpX:Number = NaN;
         var tmpY:Number = NaN;
         var tmpClass:Class = null;
         var enemyStats:EnemyStats = null;
         var playerStartIndex:int = 0;
         var playerSpawnIndex:int = 0;
         var teamStartColor:String = null;
         var teamPlayerStartIndex:int = 0;
         var teamSpawnColor:String = null;
         var teamPlayerRespawnIndex:int = 0;
         var e:int = 0;
         var mc:MovieClip = param1;
         var list:Vector.<*> = new Vector.<*>();
         var teamMap:Object = {
            "red":1,
            "green":2,
            "blue":3,
            "yellow":4
         };
         e = 0;
         while(e < mc.numChildren)
         {
            list.push(mc.getChildAt(e));
            e += 1;
         }
         e = 0;
         for(; e < list.length; e += 1)
         {
            if(list[e] is MovieClip)
            {
               curObject = MovieClip(list[e]);
               try
               {
                  if(!curObject.type)
                  {
                     continue;
                  }
               }
               catch(error:*)
               {
                  continue;
               }
               if(curObject.type == "enemy")
               {
                  tmpX = curObject.x;
                  tmpY = curObject.y;
                  if(Boolean(curObject.className) && Boolean(Main.getClassByName(curObject.className)))
                  {
                     tmpClass = curObject.className is Class ? curObject.className : Main.getClassByName(curObject.className);
                     curObject.parent.removeChild(curObject);
                     this.ENEMY.unshift(new tmpClass(this,tmpX,tmpY,-1));
                  }
                  else if(curObject.classAPI)
                  {
                     enemyStats = new EnemyStats();
                     enemyStats.importData({"classAPI":curObject.classAPI});
                     this.ENEMY.unshift(new Enemy(enemyStats,this,tmpX,tmpY,-1,curObject));
                  }
               }
               else if(curObject.type == "terrain")
               {
                  if(Boolean(curObject.className) && Boolean(Main.getClassByName(curObject.className)) || Boolean(curObject.classAPI))
                  {
                     if(curObject.classAPI)
                     {
                        this.MOVINGPLATFORMS.unshift(new MovingPlatform(curObject,this,"ground",{"classAPI":curObject.classAPI}));
                     }
                     else if(curObject.className is Class)
                     {
                        this.MOVINGPLATFORMS.unshift(new (curObject.className as Class)(curObject,this));
                     }
                     else
                     {
                        this.MOVINGPLATFORMS.unshift(new (Main.getClassByName(curObject.className))(curObject,this));
                     }
                     this.TERRAINS.unshift(this.MOVINGPLATFORMS[0]);
                  }
                  else
                  {
                     this.TERRAINS.unshift(new MovingPlatform(curObject,this));
                  }
                  this.TERRAINS[0].BMPData.rotation = 80;
               }
               else if(curObject.type == "platform")
               {
                  if(Boolean(curObject.ground) && Boolean(curObject.noDropThrough))
                  {
                     curObject.ground.noDropThrough = true;
                  }
                  if(Boolean(curObject.className) && Boolean(Main.getClassByName(curObject.className)) || Boolean(curObject.classAPI))
                  {
                     if(curObject.classAPI)
                     {
                        this.MOVINGPLATFORMS.unshift(new MovingPlatform(curObject,this,"ground",{"classAPI":curObject.classAPI}));
                     }
                     else if(curObject.className is Class)
                     {
                        this.MOVINGPLATFORMS.unshift(new (curObject.className as Class)(curObject,this));
                     }
                     else
                     {
                        this.MOVINGPLATFORMS.unshift(new (Main.getClassByName(curObject.className))(curObject,this));
                     }
                     this.PLATFORMS.unshift(this.MOVINGPLATFORMS[0]);
                  }
                  else
                  {
                     this.PLATFORMS.unshift(new MovingPlatform(curObject,this));
                  }
               }
               else if(curObject.type == "collision")
               {
                  if(Boolean(curObject.className) && Boolean(Main.getClassByName(curObject.className)) || Boolean(curObject.classAPI))
                  {
                     if(curObject.classAPI)
                     {
                        this.COLLISION_BOUNDARIES.unshift(new BitmapCollisionBoundary(curObject,this,"ground",false,{"classAPI":curObject.classAPI}));
                     }
                     else if(curObject.className is Class)
                     {
                        this.COLLISION_BOUNDARIES.unshift(new (curObject.className as Class)(curObject,this));
                     }
                     else
                     {
                        this.COLLISION_BOUNDARIES.unshift(new (Main.getClassByName(curObject.className))(curObject,this));
                     }
                  }
                  else
                  {
                     this.COLLISION_BOUNDARIES.unshift(new BitmapCollisionBoundary(curObject,this));
                  }
               }
               else if(curObject.type == "itemGen")
               {
                  this.ITEMGENS.push(curObject);
               }
               else if(curObject.type == "l_bound_upper")
               {
                  this.WARNINGBOUNDS_UL.push(new BitmapCollisionBoundary(curObject,this,"ground",true));
                  this.COLLISION_BOUNDARIES.push(this.WARNINGBOUNDS_UL[this.WARNINGBOUNDS_UL.length - 1]);
               }
               else if(curObject.type == "r_bound_upper")
               {
                  this.WARNINGBOUNDS_UR.push(new BitmapCollisionBoundary(curObject,this,"ground",true));
                  this.COLLISION_BOUNDARIES.push(this.WARNINGBOUNDS_UR[this.WARNINGBOUNDS_UR.length - 1]);
               }
               else if(curObject.type == "l_bound_lower")
               {
                  this.WARNINGBOUNDS_LL.push(new BitmapCollisionBoundary(curObject,this,"ground",true));
                  this.COLLISION_BOUNDARIES.push(this.WARNINGBOUNDS_LL[this.WARNINGBOUNDS_LL.length - 1]);
               }
               else if(curObject.type == "r_bound_lower")
               {
                  this.WARNINGBOUNDS_LR.push(new BitmapCollisionBoundary(curObject,this,"ground",true));
                  this.COLLISION_BOUNDARIES.push(this.WARNINGBOUNDS_LR[this.WARNINGBOUNDS_LR.length - 1]);
               }
               else if(curObject.type == "l_ledge")
               {
                  this.LEDGES_L.push(curObject);
                  if(HitBoxAnimation.AnimationsList["_ledge_"])
                  {
                     curObject.hitBoxAnim = HitBoxAnimation.AnimationsList["_ledge_"];
                  }
                  else
                  {
                     curObject.hitBoxAnim = new HitBoxAnimation("_ledge_");
                     HitBoxAnimation(curObject.hitBoxAnim).addHitBox(1,new HitBoxSprite(HitBoxSprite.LEDGE,curObject.getBounds(curObject)));
                  }
               }
               else if(curObject.type == "r_ledge")
               {
                  this.LEDGES_R.push(curObject);
                  if(HitBoxAnimation.AnimationsList["_ledge_"])
                  {
                     curObject.hitBoxAnim = HitBoxAnimation.AnimationsList["_ledge_"];
                  }
                  else
                  {
                     curObject.hitBoxAnim = new HitBoxAnimation("_ledge_");
                     HitBoxAnimation(curObject.hitBoxAnim).addHitBox(1,new HitBoxSprite(HitBoxSprite.LEDGE,curObject.getBounds(curObject)));
                  }
               }
               else if(curObject.type == "beacon")
               {
                  this.BEACONS.push(new Beacon(curObject,this,this.BEACONS.length));
               }
               else if(curObject.type == "wallstick")
               {
                  this.WALLS.push(new BitmapCollisionBoundary(curObject,this));
               }
               else if(curObject.type == "target")
               {
                  if(curObject.classAPI)
                  {
                     this.TARGETS.unshift(new TargetTestTarget(curObject,this,{"classAPI":curObject.classAPI}));
                  }
                  else
                  {
                     this.TARGETS.unshift(new TargetTestTarget(curObject,this));
                  }
               }
               else if(Boolean(curObject.type) && curObject.type.match(/^p(\d+)_start$/) != null)
               {
                  this.START_POSITIONS.push(curObject);
                  playerStartIndex = parseInt(curObject.type.match(/p(\d+)_start/)[1]) - 1;
                  if(this.m_playerStartIndices.indexOf(playerStartIndex) >= 0)
                  {
                     this.GAME.PlayerSettings[this.m_playerStartIndices.indexOf(playerStartIndex)].x_start = curObject.x;
                     this.GAME.PlayerSettings[this.m_playerStartIndices.indexOf(playerStartIndex)].y_start = curObject.y;
                     this.GAME.PlayerSettings[this.m_playerStartIndices.indexOf(playerStartIndex)].facingRight = curObject.transform.matrix.a >= 0;
                  }
               }
               else if(Boolean(curObject.type) && curObject.type.match(/^p(\d+)_spawn$/) != null)
               {
                  this.SPAWN_POSITIONS.push(curObject);
                  playerSpawnIndex = parseInt(curObject.type.match(/^p(\d+)_spawn$/)[1]) - 1;
                  if(this.m_playerStartIndices.indexOf(playerSpawnIndex) >= 0)
                  {
                     this.GAME.PlayerSettings[this.m_playerStartIndices.indexOf(playerSpawnIndex)].x_respawn = curObject.x;
                     this.GAME.PlayerSettings[this.m_playerStartIndices.indexOf(playerSpawnIndex)].y_respawn = curObject.y;
                  }
               }
               else if(Boolean(curObject.type) && curObject.type.match(/^(red|blue|green|yellow)(\d+)_start$/) != null)
               {
                  this.START_POSITIONS.push(curObject);
                  teamStartColor = curObject.type.match(/(red|blue|green|yellow)(\d+)_start/)[1];
                  teamPlayerStartIndex = int(parseInt(curObject.type.match(/(red|blue|green|yellow)(\d+)_start/)[2]));
                  tmpPlayerSetting = this.getNthPlayerOfTeam(teamPlayerStartIndex,teamMap[teamStartColor]);
                  if(tmpPlayerSetting)
                  {
                     tmpPlayerSetting.x_start = curObject.x;
                     tmpPlayerSetting.y_start = curObject.y;
                     tmpPlayerSetting.facingRight = curObject.transform.matrix.a >= 0;
                  }
               }
               else if(Boolean(curObject.type) && curObject.type.match(/^(red|blue|green|yellow)(\d+)_spawn$/) != null)
               {
                  this.SPAWN_POSITIONS.push(curObject);
                  teamSpawnColor = curObject.type.match(/(red|blue|green|yellow)(\d+)_spawn$/)[1];
                  teamPlayerRespawnIndex = int(parseInt(curObject.type.match(/(red|blue|green|yellow)(\d+)_spawn$/)[2]));
                  tmpPlayerSetting = this.getNthPlayerOfTeam(teamPlayerRespawnIndex,teamMap[teamStartColor]);
                  if(tmpPlayerSetting)
                  {
                     tmpPlayerSetting.x_respawn = curObject.x;
                     tmpPlayerSetting.y_respawn = curObject.y;
                  }
               }
               else if(curObject.type == "light_source")
               {
                  this.LIGHTSOURCE = curObject;
               }
            }
         }
      }
      
      public function getNthPlayerOfTeam(param1:int, param2:int) : PlayerSetting
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < this.GAME.PlayerSettings.length)
         {
            if(Boolean(this.GAME.PlayerSettings[_loc4_]) && Boolean(this.GAME.PlayerSettings[_loc4_].exist) && this.GAME.PlayerSettings[_loc4_].team === param2)
            {
               _loc3_++;
               if(param1 === _loc3_)
               {
                  return this.GAME.PlayerSettings[_loc4_];
               }
            }
            _loc4_++;
         }
         return null;
      }
      
      private function createBeaconData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.BEACONS.length <= 0)
         {
            return;
         }
         this.ADJMATRIX = this.newAdjacencyMatrix(this.BEACONS.length);
         this.populateAdjMatrix(this.BEACONS);
         _loc1_ = 0;
         while(_loc1_ < this.BEACONS.length)
         {
            _loc2_ = 0;
            while(_loc2_ < this.BEACONS[_loc1_].Neighbors.length)
            {
               _loc3_ = 0;
               while(_loc3_ < this.BEACONS[_loc1_].Neighbors[_loc2_].Neighbors.length)
               {
                  if(this.BEACONS[_loc1_] != this.BEACONS[_loc1_].Neighbors[_loc2_].Neighbors[_loc3_])
                  {
                     _loc4_ = 0;
                     while(_loc4_ < this.BEACONS[_loc1_].Neighbors.length)
                     {
                        if(this.BEACONS[_loc1_].Neighbors[_loc2_] != this.BEACONS[_loc1_].Neighbors[_loc4_])
                        {
                           if(this.BEACONS[_loc1_].Neighbors[_loc4_] == this.BEACONS[_loc1_].Neighbors[_loc2_].Neighbors[_loc3_])
                           {
                              if(this.ADJMATRIX[_loc1_][this.BEACONS[_loc1_].Neighbors[_loc4_].BID] > this.ADJMATRIX[this.BEACONS[_loc1_].Neighbors[_loc2_].BID][this.BEACONS[_loc1_].Neighbors[_loc4_].BID])
                              {
                                 this.ADJMATRIX[_loc1_][this.BEACONS[_loc1_].Neighbors[_loc4_].BID] = int.MAX_VALUE;
                              }
                           }
                        }
                        _loc4_++;
                     }
                  }
                  _loc3_++;
               }
               _loc2_++;
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.ADJMATRIX.length)
         {
            _loc2_ = 0;
            while(_loc2_ < this.ADJMATRIX[_loc1_].length)
            {
               if(this.ADJMATRIX[_loc1_][_loc2_] != int.MAX_VALUE)
               {
                  this.ADJMATRIX[_loc2_][_loc1_] = this.ADJMATRIX[_loc1_][_loc2_];
               }
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      private function newAdjacencyMatrix(param1:Number) : Array
      {
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         var _loc3_:Array = new Array(param1);
         while(_loc4_ < param1)
         {
            _loc3_[_loc4_] = new Array(param1);
            _loc2_ = 0;
            while(_loc2_ < param1)
            {
               _loc3_[_loc4_][_loc2_] = int.MAX_VALUE;
               _loc2_++;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function populateAdjMatrix(param1:Vector.<Beacon>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               if(_loc3_ != _loc2_ && param1[_loc3_].addPotentialNeighbor(param1[_loc2_]))
               {
                  this.ADJMATRIX[_loc3_][_loc2_] = Utils.getDistanceFrom(param1[_loc3_],param1[_loc2_]);
               }
               _loc2_++;
            }
            _loc3_++;
         }
      }
      
      public function beaconNeighborCount(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < this.ADJMATRIX[param1].length)
         {
            if(this.ADJMATRIX[param1][_loc3_] != int.MAX_VALUE)
            {
               _loc2_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function markBeaconsUnvisited() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.BEACONS.length)
         {
            this.BEACONS[_loc1_].Visited = false;
            _loc1_++;
         }
      }
      
      public function touchingLowerWarningBounds(param1:int, param2:int) : Boolean
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < this.WARNINGBOUNDS_LL.length)
         {
            if(this.WARNINGBOUNDS_LL[_loc3_].hitTestPoint(param1,param2,true))
            {
               return true;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.WARNINGBOUNDS_LR.length)
         {
            if(this.WARNINGBOUNDS_LR[_loc3_].hitTestPoint(param1,param2,true))
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function touchingUpperWarningBounds(param1:int, param2:int) : Boolean
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < this.WARNINGBOUNDS_UL.length)
         {
            if(this.WARNINGBOUNDS_UL[_loc3_].hitTestPoint(param1,param2,true))
            {
               return true;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.WARNINGBOUNDS_UR.length)
         {
            if(this.WARNINGBOUNDS_UR[_loc3_].hitTestPoint(param1,param2,true))
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function lightFlash(param1:Boolean = true) : void
      {
         var _loc2_:MovieClip = null;
         if(this.getQualitySettings().screen_flash)
         {
            _loc2_ = this.attachUniqueMovieHUD(param1 ? "flashOfLight" : "flashOfLightQuick");
         }
      }
      
      public function darkenCamera() : void
      {
         this.HUD.darkenCamera();
      }
      
      private function killCameraDarkener() : void
      {
         this.HUD.darkenCamera();
      }
      
      public function getSnapshot(param1:Object = null) : BitmapData
      {
         return Utils.getSnapshot(Main.Root);
      }
      
      public function checkLinearPathBetweenPoints(param1:Point, param2:Point, param3:Object = null) : Platform
      {
         param3 ||= {};
         param3.terrain = typeof param3.terrain !== "undefined" ? param3.terrain : true;
         param3.platforms = typeof param3.platforms !== "undefined" ? param3.platforms : true;
         param3.ignoreFallthrough = typeof param3.ignoreFallthrough !== "undefined" ? param3.ignoreFallthrough : true;
         param3.ignoreList = param3.ignoreList || [];
         return this.getPlatformBetweenPoints(param1,param2,param3);
      }
      
      public function getPlatformBetweenPoints(param1:Point, param2:Point, param3:Object = null) : Platform
      {
         var _loc9_:Platform = null;
         var _loc10_:int = 0;
         var _loc4_:Number = param1.x;
         var _loc5_:Number = param1.y;
         var _loc6_:Number = param2.x - param1.x;
         var _loc7_:Number = param2.y - param1.y;
         var _loc8_:Number = (Math.abs(_loc6_) + Math.abs(_loc7_)) / 10;
         if(_loc8_ < 1)
         {
            _loc8_ = 1;
         }
         while(_loc10_ < Math.floor(_loc8_))
         {
            _loc9_ = this.testGroundWithCoord(_loc4_ + _loc6_ / _loc8_,_loc5_ + _loc7_ / _loc8_,param3);
            if(_loc9_ !== null)
            {
               return _loc9_;
            }
            _loc4_ += _loc6_ / _loc8_;
            _loc5_ += _loc7_ / _loc8_;
            _loc10_++;
         }
         return null;
      }
      
      public function getPlatformBetweenPointsAsPoint(param1:Point, param2:Point, param3:Object = null) : Point
      {
         var _loc9_:Platform = null;
         var _loc10_:int = 0;
         var _loc4_:Number = param1.x;
         var _loc5_:Number = param1.y;
         var _loc6_:Number = param2.x - param1.x;
         var _loc7_:Number = param2.y - param1.y;
         var _loc8_:Number = (Math.abs(_loc6_) + Math.abs(_loc7_)) / 10;
         if(_loc8_ < 1)
         {
            _loc8_ = 1;
         }
         while(_loc10_ < Math.floor(_loc8_))
         {
            _loc9_ = this.testGroundWithCoord(_loc4_ + _loc6_ / _loc8_,_loc5_ + _loc7_ / _loc8_,param3);
            if(_loc9_ !== null)
            {
               return new Point(_loc4_ + _loc6_ / _loc8_,_loc5_ + _loc7_ / _loc8_);
            }
            _loc4_ += _loc6_ / _loc8_;
            _loc5_ += _loc7_ / _loc8_;
            _loc10_++;
         }
         return null;
      }
      
      public function testTerrainWithCoord(param1:Number, param2:Number) : Platform
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < this.TERRAINS.length && (!this.TERRAINS[_loc3_].hitTestPoint(param1,param2,true) || this.TERRAINS[_loc3_].fallthrough == true))
         {
            _loc3_++;
         }
         if(_loc3_ < this.TERRAINS.length && Boolean(this.TERRAINS[_loc3_].hitTestPoint(param1,param2,true)))
         {
            return this.TERRAINS[_loc3_];
         }
         return null;
      }
      
      public function testGroundWithCoord(param1:Number, param2:Number, param3:Object = null) : Platform
      {
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         param3 ||= {};
         param3.terrain = typeof param3.terrain !== "undefined" ? param3.terrain : true;
         param3.platforms = typeof param3.platforms !== "undefined" ? param3.platforms : true;
         param3.ignoreFallthrough = typeof param3.ignoreFallthrough !== "undefined" ? param3.ignoreFallthrough : true;
         param3.ignoreList = param3.ignoreList || [];
         _loc4_ = 0;
         while(true)
         {
            _loc5_ = Boolean(this.TERRAINS[_loc4_].hitTestPoint(param1,param2,true));
            if(!(Boolean(param3.terrain) && Boolean(_loc4_ < this.TERRAINS.length) && (!_loc5_ || this.TERRAINS[_loc4_].fallthrough == true && !param3.ignoreFallthrough || param3.ignoreList.indexOf(this.TERRAINS[_loc4_]) >= 0)))
            {
               break;
            }
            _loc4_++;
         }
         if(_loc4_ < this.TERRAINS.length && _loc5_)
         {
            return this.TERRAINS[_loc4_];
         }
         if(param3.platforms)
         {
            _loc4_ = 0;
            while(true)
            {
               _loc5_ = Boolean(this.PLATFORMS[_loc4_].hitTestPoint(param1,param2,true));
               if(!(_loc4_ < this.PLATFORMS.length && (!_loc5_ || this.PLATFORMS[_loc4_].fallthrough == true && !param3.ignoreFallthrough || param3.ignoreList.indexOf(this.PLATFORMS[_loc4_]) >= 0)))
               {
                  break;
               }
               _loc4_++;
            }
            if(_loc4_ < this.PLATFORMS.length && _loc5_)
            {
               return this.PLATFORMS[_loc4_];
            }
            return null;
         }
         return null;
      }
      
      public function shakeCamera(param1:int) : void
      {
         this.CAM.shake(param1);
      }
      
      public function brightenCamera() : void
      {
         this.HUD.brightenCamera();
      }
      
      private function makePlayer(param1:int) : void
      {
         var _loc2_:CharacterData = null;
         var _loc3_:PlayerSetting = this.GAME.PlayerSettings[param1 - 1];
         if(_loc3_.character == "random")
         {
            _loc2_ = Stats.getStats(Main.RandCharList[param1 - 1].StatsName);
         }
         else
         {
            _loc2_ = Stats.getStats(_loc3_.character,_loc3_.expansion);
         }
         _loc2_.importData({
            "player_id":param1,
            "shieldType":(!_loc3_.human ? "shieldcpu" : "shield" + Utils.convertTeamToColor(param1,this.GAME.GameMode == Mode.TRAINING ? -1 : int(_loc3_.team))),
            "stamina":(this.GAME.LevelData.usingStamina ? this.GAME.LevelData.startStamina : 0)
         });
         this.deactivateCharacters();
         if(Boolean(this.ONLINEMODE) && Boolean(_loc3_.name))
         {
            _loc3_.name = ProfanityFilter.instance.clean(_loc3_.name);
         }
         var _loc4_:Character = new Character(_loc2_,this.GAME.PlayerSettings[param1 - 1],this);
         this.activateCharacters();
         _loc4_.attachHealthBox(_loc3_.name ? _loc3_.name : _loc2_.DisplayName.toUpperCase(),_loc2_.Thumbnail,_loc2_.SeriesIcon,_loc4_.Team,_loc4_.CostumeName,_loc4_.CostumeID);
      }
      
      public function activateCharacters() : void
      {
         this.m_activeScripts = true;
      }
      
      public function deactivateCharacters() : void
      {
         this.m_activeScripts = false;
      }
      
      public function startGame() : void
      {
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,this.startGame2);
      }
      
      private function startGame2(param1:Event) : void
      {
         var _loc2_:* = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc11_:String = null;
         var _loc12_:uint = 0;
         var _loc13_:String = null;
         var _loc14_:uint = 0;
         var _loc15_:String = null;
         var _loc16_:String = null;
         var _loc17_:String = null;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:String = null;
         var _loc21_:String = null;
         var _loc22_:String = null;
         var _loc23_:String = null;
         var _loc24_:String = null;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:String = null;
         var _loc28_:uint = 0;
         var _loc29_:String = null;
         var _loc30_:String = null;
         var _loc31_:uint = 0;
         var _loc32_:String = null;
         var _loc33_:String = null;
         var _loc34_:String = null;
         var _loc35_:uint = 0;
         var _loc36_:String = null;
         var _loc37_:uint = 0;
         var _loc3_:Date = new Date();
         var _loc4_:int = int(parseInt(String(_loc3_.time).slice(0,-3)));
         this.m_startDelayTimer.tick();
         if(!this.m_startDelayTimer.IsComplete)
         {
            return;
         }
         this.ROOT.stage.removeEventListener(Event.ENTER_FRAME,this.startGame2);
         this.SOUNDQUEUE.playMusic(this.m_music,this.m_loopLoc);
         this.STAGEPARENT.stage.focus = this.STAGEPARENT;
         this.activateCharacters();
         this.m_countdownTimer = ResourceManager.getLibraryMC("countdownTimer");
         this.m_countdownTimer.stop();
         this.HUDTEXT.addChild(this.m_countdownTimer);
         this.ROOT.addEventListener(Event.RENDER,this.renderComplete);
         this.ROOT.addEventListener(Event.ENTER_FRAME,this.performAllEvents);
         _loc5_ = "In a match";
         if(this.REPLAYMODE)
         {
            _loc5_ = "Watching a replay";
         }
         if(this.GAME.GameMode == Mode.ARENA)
         {
            _loc11_ = MenuController.getStageDisplayName(this.GAME.LevelData.stage);
            _loc12_ = uint(MenuController.getTimerEndTimestamp(this));
            MenuController.updateDiscordPresence("Arena",_loc5_,_loc4_,_loc12_,this.GAME.PlayerSettings[0].character,"Player 1","stage",_loc11_,null,null,null,null,null);
         }
         else if(this.GAME.GameMode == Mode.CUSTOM)
         {
            _loc13_ = MenuController.getStageDisplayName(this.GAME.LevelData.stage);
            _loc14_ = uint(MenuController.getTimerEndTimestamp(this));
            MenuController.updateDiscordPresence("???",_loc5_,_loc4_,_loc14_,this.GAME.PlayerSettings[0].character,"Player 1","stage",_loc13_,null,null,null,null,null);
         }
         else if(this.GAME.GameMode == Mode.ONLINE_WAITING_ROOM)
         {
            Main.m_onlineChar = this.GAME.PlayerSettings[0].character;
            Main.m_onlineName = this.GAME.PlayerSettings[0].name;
            if(MultiplayerManager.Connected)
            {
               _loc15_ = MultiplayerManager.RoomKey;
               _loc16_ = MultiplayerManager.RoomCode;
               _loc17_ = MultiplayerManager.RoomPassword;
               _loc18_ = int(MultiplayerManager.Players.length);
               _loc19_ = MultiplayerManager.ROOM_CAPACITY;
               _loc20_ = MenuController.getStageDisplayName(this.GAME.LevelData.stage);
               _loc21_ = MenuController.buildDiscordJoinSecret(_loc15_,_loc16_,_loc17_,_loc19_);
               _loc22_ = MultiplayerManager.DiscordPartyID;
               MenuController.updateDiscordPresence("In Waiting Room","Playing Online",_loc4_,0,Main.m_onlineChar,Main.m_onlineName,"stage",_loc20_,_loc22_,_loc18_,_loc19_,_loc15_,_loc21_);
            }
            else
            {
               _loc23_ = MenuController.getStageDisplayName(this.GAME.LevelData.stage);
               MenuController.updateDiscordPresence("In Waiting Room","Playing Online",_loc4_,0,Main.m_onlineChar,Main.m_onlineName,"stage",_loc23_,null,null,null,null,null);
            }
         }
         else if(this.GAME.GameMode == Mode.ONLINE)
         {
            if(MultiplayerManager.Connected)
            {
               _loc24_ = MultiplayerManager.RoomKey;
               _loc25_ = int(MultiplayerManager.Players.length);
               _loc26_ = MultiplayerManager.ROOM_CAPACITY;
               _loc27_ = MenuController.getStageDisplayName(this.GAME.LevelData.stage);
               _loc28_ = uint(MenuController.getTimerEndTimestamp(this));
               _loc29_ = MultiplayerManager.DiscordPartyID;
               MenuController.updateDiscordPresence("Online Match",_loc5_,_loc4_,_loc28_,Main.m_onlineChar,Main.m_onlineName,"stage",_loc27_,_loc29_,_loc25_,_loc26_,null,null);
            }
            else
            {
               _loc30_ = MenuController.getStageDisplayName(this.GAME.LevelData.stage);
               _loc31_ = uint(MenuController.getTimerEndTimestamp(this));
               MenuController.updateDiscordPresence("Online",_loc5_,_loc4_,_loc31_,Main.m_onlineChar,Main.m_onlineName,"stage",_loc30_,null,null,null,null,null);
            }
         }
         else if(this.GAME.GameMode == Mode.EVENT)
         {
            MenuController.updateDiscordPresence(MenuController.eventMenu.CurrentEvent.name,"Event Mode",_loc4_,0,this.GAME.PlayerSettings[0].character,null,"event",null,null,null,null,null,null);
         }
         else if(this.GAME.GameMode == Mode.NULL)
         {
            _loc32_ = MenuController.getStageDisplayName(this.GAME.LevelData.stage);
            MenuController.updateDiscordPresence("Trapped in Null Space",_loc5_,_loc4_,0,this.GAME.PlayerSettings[0].character,"Player 1","stage",_loc32_,null,null,null,null,null);
         }
         else if(this.GAME.GameMode == Mode.TRAINING)
         {
            _loc33_ = MenuController.getStageDisplayName(this.GAME.LevelData.stage);
            MenuController.updateDiscordPresence("Training",_loc5_,_loc4_,0,this.GAME.PlayerSettings[0].character,"Player 1","stage",_loc33_,null,null,null,null,null);
         }
         else if(this.GAME.GameMode == Mode.VS)
         {
            _loc34_ = MenuController.getStageDisplayName(this.GAME.LevelData.stage);
            _loc35_ = uint(MenuController.getTimerEndTimestamp(this));
            MenuController.updateDiscordPresence("VS",_loc5_,_loc4_,_loc35_,this.GAME.PlayerSettings[0].character,"Player 1","stage",_loc34_,null,null,null,null,null);
         }
         else if(this.GAME.GameMode == Mode.VS_UNLOCK)
         {
            _loc36_ = MenuController.getStageDisplayName(this.GAME.LevelData.stage);
            _loc37_ = uint(MenuController.getTimerEndTimestamp(this));
            MenuController.updateDiscordPresence("Unlocking something",_loc5_,_loc4_,_loc37_,this.GAME.PlayerSettings[0].character,"Player 1","stage",_loc36_,null,null,null,null,null);
         }
         if(Boolean(ModeFeatures.hasFeature(ModeFeatures.ALLOW_SUDDEN_DEATH,this.GAME.GameMode)) && Boolean(this.GAME.SuddenDeath))
         {
            if(this.GAME.SuddenDeath)
            {
               this.m_countdownTimer.gotoAndStop("suddendeath");
               this.playSpecificVoice("narrator_suddendeath");
               this.playSpecificVoice("crowd_suddendeath");
            }
         }
         else if(!this.GAME.LevelData.showEntrances)
         {
            if(this.GAME.LevelData.showCountdown)
            {
               this.m_countdownTimer.showCountdownType = this.GAME.LevelData.showCountdownType;
               if(this.GAME.LevelData.showCountdownType === 1 || this.GAME.LevelData.showCountdownType === 3)
               {
                  this.m_countdownTimer.gotoAndStop("ready");
               }
               else
               {
                  this.m_countdownTimer.gotoAndStop("go");
               }
            }
            else
            {
               this.m_event = false;
               if(this.GAME.UsingTime)
               {
                  this.TIMER.Restart();
                  this.TIMER.Start();
                  this.TIMER.TimeMC.visible = true;
               }
               this.m_countdownTimer.stop();
               if(this.m_countdownTimer.parent)
               {
                  this.m_countdownTimer.parent.removeChild(this.m_countdownTimer);
               }
            }
         }
         else
         {
            this.m_countdownTimer.gotoAndStop(2);
         }
         if(Boolean(Main.DEBUG) && !Main.LAZYDEBUG)
         {
            this.m_fpsTimer = new Debug_fps(this.STAGE.stage,new Point());
         }
         if(SpecialMode.modeEnabled(this.GAME.LevelData.specialModes,SpecialMode.SLOW))
         {
            Main.Root.stage.frameRate = Main.FRAMERATE / 2;
         }
         else if(SpecialMode.modeEnabled(this.GAME.LevelData.specialModes,SpecialMode.LIGHTNING))
         {
            Main.Root.stage.frameRate = Main.FRAMERATE * 2;
         }
         this.CAM.forceTarget();
         this.CAM.PERFORMALL();
         _loc2_ = int(this.MOVINGPLATFORMS.length - 1);
         while(_loc2_ >= 0)
         {
            if(this.MOVINGPLATFORMS[_loc2_].APIInstance)
            {
               this.MOVINGPLATFORMS[_loc2_].APIInstance.initialize();
            }
            _loc2_--;
         }
         _loc2_ = int(this.COLLISION_BOUNDARIES.length - 1);
         while(_loc2_ >= 0)
         {
            if(this.COLLISION_BOUNDARIES[_loc2_].APIInstance)
            {
               this.COLLISION_BOUNDARIES[_loc2_].APIInstance.initialize();
            }
            _loc2_--;
         }
         _loc2_ = int(this.ENEMY.length - 1);
         while(_loc2_ >= 0)
         {
            if(this.ENEMY[_loc2_].APIInstance)
            {
               this.ENEMY[_loc2_].APIInstance.initialize();
            }
            _loc2_--;
         }
         _loc2_ = 1;
         while(_loc2_ <= this.GAME.PlayerSettings.length)
         {
            if(this.GAME.PlayerSettings[_loc2_ - 1].character != null)
            {
               this.getPlayerByID(_loc2_).APIInstance.initialize();
               if(Boolean(this.GAME.LevelData.showEntrances) && !SpecialMode.modeEnabled(this.GAME.LevelData.specialModes,SpecialMode.SSF1))
               {
                  this.getPlayerByID(_loc2_).setState(CState.ENTRANCE);
               }
               else
               {
                  this.deactivateCharacters();
                  this.getPlayerByID(_loc2_).setState(CState.ENTRANCE);
                  this.activateCharacters();
                  this.getPlayerByID(_loc2_).setState(CState.IDLE);
               }
            }
            _loc2_++;
         }
         if(this.GAME.GameMode == Mode.TRAINING)
         {
            _loc2_ = 1;
            while(_loc2_ <= this.PLAYERS.length)
            {
               if(this.getPlayerByID(_loc2_))
               {
                  if(_loc2_ == 1)
                  {
                     this.getPlayerByID(_loc2_).Team = 1;
                  }
                  else if(_loc2_ == 2)
                  {
                     this.getPlayerByID(_loc2_).StandBy = false;
                     this.getPlayerByID(_loc2_).Team = 2;
                  }
                  else
                  {
                     this.getPlayerByID(_loc2_).StandBy = true;
                     this.getPlayerByID(_loc2_).Team = 2;
                  }
               }
               _loc2_++;
            }
         }
         this.HUD.makeEvents();
         var _loc8_:Vector.<MovieClip> = new Vector.<MovieClip>();
         var _loc9_:Number = 0;
         while(_loc9_ < this.PLAYERS.length)
         {
            if(this.PLAYERS[_loc9_] != null && this.PLAYERS[_loc9_].MC != null && !this.PLAYERS[_loc9_].StandBy)
            {
               _loc8_.push(MovieClip(this.PLAYERS[_loc9_].MC));
            }
            _loc9_++;
         }
         this.CAM.addTargets(_loc8_);
         this.CAM.forceTarget();
         _loc2_ = 0;
         while(_loc2_ < this.PLAYERS.length)
         {
            if(this.PLAYERS[_loc2_])
            {
               this.PLAYERS[_loc2_].forceOnGround();
            }
            _loc2_++;
         }
         this.m_currentEntrance = 0;
         var _loc10_:Boolean = true;
         if(this.GAME.LevelData.showEntrances)
         {
            _loc2_ = 0;
            while(_loc2_ < this.PLAYERS.length)
            {
               if(this.PLAYERS[_loc2_])
               {
                  if(_loc10_)
                  {
                     this.CAM.addZoomFocus(this.PLAYERS[_loc2_].MC,20);
                     _loc10_ = false;
                  }
                  else
                  {
                     this.PLAYERS[_loc2_].FreezePlayback = true;
                     this.PLAYERS[_loc2_].setVisibility(false);
                  }
               }
               _loc2_++;
            }
         }
         Main.Root.visible = true;
         if(this.GAME.HudDisplay)
         {
            this.HUD.toggleMainDisplay(true);
         }
         if(this.m_apiInstance)
         {
            this.m_apiInstance.initialize();
         }
         if(ModeFeatures.hasFeature(ModeFeatures.IS_CUSTOM,this.GAME.GameMode))
         {
            this.GAME.CustomMatchObj.APIInstance.initialize();
         }
         this.stopAllStageFrames();
         this.PERFORMALL();
         if(Boolean(this.ONLINEMODE) && MultiplayerManager.INPUT_BUFFER === 0)
         {
            this.m_onlineMatchControlsTimer.start();
         }
      }
      
      public function prepareEndGameCharacter(param1:Boolean = false) : void
      {
         this.m_slowFrameRate = param1;
         this.m_endTrigger = true;
      }
      
      public function getEndGameDefaults(param1:Object = null) : Object
      {
         param1 ||= {};
         param1.exit = param1.exit === undefined ? true : param1.exit;
         param1.slowMo = param1.slowMo === undefined ? false : param1.slowMo;
         param1.immediate = param1.immediate === undefined ? true : param1.immediate;
         param1.silent = param1.silent === undefined ? false : param1.silent;
         param1.matchResults = param1.matchResults === undefined ? false : param1.matchResults;
         param1.forceNoContest = param1.forceNoContest === undefined ? false : param1.forceNoContest;
         param1.replaySave = param1.replaySave === undefined ? false : param1.replaySave;
         return param1;
      }
      
      private function setupRetryButtons(param1:MovieClip) : void
      {
         if(Boolean(param1) && Boolean(param1.stadiumMenuBar))
         {
            param1.stadiumMenuBar.visible = false;
            if(!this.REPLAYMODE && Boolean(ModeFeatures.hasFeature(ModeFeatures.ALLOW_REPLAY_RECORD,this.GAME.GameMode)))
            {
               param1.stadiumMenuBar.visible = true;
               param1.stadiumMenuBar.replaySave_btn.addEventListener(MouseEvent.CLICK,this.onReplaySaveClicked);
            }
            else
            {
               param1.stadiumMenuBar.replaySave_btn.visible = false;
            }
            if(!this.REPLAYMODE && Boolean(ModeFeatures.hasFeature(ModeFeatures.HAS_RETRY_BUTTON,this.GAME.GameMode)))
            {
               param1.stadiumMenuBar.visible = true;
               if(SaveData.Controllers[0].GamepadInstance)
               {
                  param1.stadiumMenuBar.key_back.text = ControlsMenu.getGamepadInputName(1,SaveData.Controllers[0]._BUTTON1);
                  param1.stadiumMenuBar.key_retry.text = ControlsMenu.getGamepadInputName(1,SaveData.Controllers[0]._GRAB);
               }
               else
               {
                  param1.stadiumMenuBar.key_back.text = Utils.KEY_ARR_SHORT[SaveData.Controllers[0].KeyboardInstance.ControlsMap[SaveData.Controllers[0]._BUTTON1]];
                  param1.stadiumMenuBar.key_retry.text = Utils.KEY_ARR_SHORT[SaveData.Controllers[0].KeyboardInstance.ControlsMap[SaveData.Controllers[0]._GRAB]];
               }
            }
         }
      }
      
      public function prepareEndGameCustom(param1:Object = null) : void
      {
         if(!this.m_endTrigger)
         {
            this.m_endGameOptions = this.getEndGameDefaults(param1);
            this.m_endTrigger = true;
         }
      }
      
      public function prepareEndGame(param1:Object = null) : void
      {
         var _loc2_:String = null;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         SoundQueue.instance.stopMusic();
         param1 = this.getEndGameDefaults(param1);
         this.m_gameEndedExit = param1.exit;
         if(!this.m_gameEnded || Boolean(this.m_gameEndedExit) && (Boolean(param1.immediate || param1.replaySave)))
         {
            if(!this.m_gameEnded)
            {
               this.m_gameEnded = true;
               this.m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.GAME_ENDED,{}));
            }
            if(Boolean(param1.immediate) && Boolean(this.m_gameEndedExit))
            {
               this.endGame(param1.forceNoContest);
               return;
            }
            this.updateEndTimer();
            if(ModeFeatures.hasFeature(ModeFeatures.IS_CUSTOM,this.GAME.GameMode))
            {
               if(param1.success === true)
               {
                  this.m_countdownTimer.stop();
                  this.m_countdownTimer.visible = false;
                  this.m_endGameTimer.MaxTime = 32;
                  _loc2_ = "success_mc";
                  if(!param1.silent)
                  {
                     if(param1.record === true)
                     {
                        this.playSpecificVoice("narrator_record");
                        _loc2_ = "newrecord_mc";
                     }
                     else
                     {
                        this.playSpecificVoice("narrator_success");
                     }
                  }
                  _loc3_ = this.attachUniqueMovieHUD(_loc2_);
                  this.HUDTEXT.addChild(_loc3_);
                  this.setupRetryButtons(_loc3_);
                  if(!this.REPLAYMODE && Boolean(ModeFeatures.hasFeature(ModeFeatures.ALLOW_REPLAY_RECORD,this.GAME.GameMode)))
                  {
                     this.m_queuedAutoSave = true;
                  }
               }
               else if(param1.success === false)
               {
                  this.m_countdownTimer.stop();
                  this.m_countdownTimer.visible = false;
                  if(!param1.silent)
                  {
                     this.playSpecificVoice("narrator_failure");
                     this.playSpecificVoice("crowd_dissapoint");
                  }
                  _loc4_ = this.attachUniqueMovieHUD("failure_mc");
                  this.HUDTEXT.addChild(_loc4_);
                  this.setupRetryButtons(_loc4_);
                  if(!this.REPLAYMODE && Boolean(ModeFeatures.hasFeature(ModeFeatures.ALLOW_REPLAY_RECORD,this.GAME.GameMode)))
                  {
                     this.m_queuedAutoSave = true;
                  }
               }
               else if(!param1.silent)
               {
                  this.m_countdownTimer.gotoAndStop(!this.GAME.UsingTime || this.TIMER.CurrentTime > 0 ? "game" : "time");
                  this.playSpecificVoice(!this.GAME.UsingTime || this.TIMER.CurrentTime > 0 ? "narrator_game" : "narrator_time");
                  this.HUDTEXT.addChild(this.m_countdownTimer);
               }
            }
            else
            {
               this.m_countdownTimer.gotoAndStop(!this.GAME.UsingTime || this.TIMER.CurrentTime > 0 ? "game" : "time");
               this.HUDTEXT.addChild(this.m_countdownTimer);
               if(!this.REPLAYMODE && Boolean(ModeFeatures.hasFeature(ModeFeatures.ALLOW_REPLAY_RECORD,this.GAME.GameMode)))
               {
                  this.m_queuedAutoSave = true;
               }
            }
            if(!param1.slowMo)
            {
               this.m_endGameTimer.MaxTime = Main.FRAMERATE * 3;
            }
            if(param1.slowMo)
            {
               Main.Root.stage.frameRate = 8;
            }
            this.TIMER.Stop();
            if(ModeFeatures.hasFeature(ModeFeatures.REMOVE_TIMER,this.GAME.GameMode))
            {
               if(this.TIMER.TimeMC.parent)
               {
                  this.TIMER.TimeMC.parent.removeChild(this.TIMER.TimeMC);
               }
            }
         }
      }
      
      public function autoSaveReplay(param1:int = -1, param2:String = null) : void
      {
         var replaysFolder:File = null;
         var versionFolderName:String = null;
         var versionFolder:File = null;
         var replayData:ByteArray = null;
         var duplicateNum:int = 0;
         var replayFile:File = null;
         var fileWriter:FileStream = null;
         var modeOverride:int = param1;
         var customFileName:String = param2;
         if(Boolean(ModeFeatures.hasFeature(ModeFeatures.ALLOW_REPLAY_RECORD,this.GAME.GameMode)) && !this.REPLAYMODE && Boolean(SaveData.ReplayAutoSave))
         {
            try
            {
               replaysFolder = File.userDirectory.resolvePath("SSF2Replays");
               if(!replaysFolder.exists)
               {
                  replaysFolder.createDirectory();
               }
               if(replaysFolder.isDirectory)
               {
                  versionFolderName = Version.getVersion();
                  versionFolder = replaysFolder.resolvePath(versionFolderName);
                  if(!versionFolder.exists)
                  {
                     versionFolder.createDirectory();
                  }
                  if(versionFolder.isDirectory)
                  {
                     this.m_replayData.Name = customFileName ? customFileName : Utils.generateReplaySaveFileName(this);
                     if(modeOverride >= 0)
                     {
                        this.m_replayData.GameMode = modeOverride;
                     }
                     replayData = new ByteArray();
                     replayData.writeUTF(this.m_replayData.exportReplay());
                     replayData.compress();
                     duplicateNum = 1;
                     replayFile = versionFolder.resolvePath(this.m_replayData.Name + ".ssfrec");
                     while(replayFile.exists)
                     {
                        duplicateNum += 1;
                        replayFile = versionFolder.resolvePath(this.m_replayData.Name + " (" + duplicateNum + ").ssfrec");
                     }
                     fileWriter = new FileStream();
                     fileWriter.open(replayFile,FileMode.WRITE);
                     fileWriter.writeBytes(replayData);
                     fileWriter.close();
                  }
               }
            }
            catch(e:*)
            {
               trace("An error occured while attempting replay auto-save: " + e);
            }
         }
      }
      
      public function onReplaySaveClicked(param1:MouseEvent) : void
      {
         this.saveReplay();
      }
      
      public function saveReplay(param1:int = -1, param2:String = null) : void
      {
         this.m_replayData.Name = param2 ? param2 : Utils.generateReplaySaveFileName(this);
         if(param1 >= 0)
         {
            this.m_replayData.GameMode = param1;
         }
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeUTF(this.m_replayData.exportReplay());
         _loc3_.compress();
         Utils.saveFile(_loc3_,GameController.stageData.ReplayDataObj.Name + ".ssfrec");
      }
      
      public function updateEndTimer() : void
      {
         this.m_endTime = getTimer();
      }
      
      public function startCountdown() : void
      {
         this.m_countdownTimer.gotoAndStop("countdown");
         this.HUDTEXT.addChild(this.m_countdownTimer);
      }
      
      public function startCrowdChant(param1:int) : void
      {
         var _loc2_:Sound = null;
         var _loc3_:int = 0;
      }
      
      public function stopCrowdChant() : void
      {
         if(this.m_crowdChantSound)
         {
            this.m_crowdChantSound.Channel.removeEventListener(Event.SOUND_COMPLETE,this.m_crowdChantSound.LoopFunction);
            this.m_crowdChantSound.stop();
            this.m_crowdChantSound.LoopFunction = null;
            this.m_crowdChantSound = null;
         }
         this.m_crowdChantID = -1;
         this.m_crowdChantTimer.reset();
         this.m_crowdChantDelay.reset();
      }
      
      public function endGame(param1:Boolean = false) : void
      {
         var topRank:Array = null;
         var already:Boolean = false;
         var i:int = 0;
         var j:int = 0;
         var goBack:Boolean = false;
         var noContest:Boolean = param1;
         InteractiveSprite.SHOW_HITBOXES = false;
         if(Boolean(this.ONLINEMODE) && MultiplayerManager.INPUT_BUFFER === 0)
         {
            this.m_onlineMatchControlsTimer.stop();
         }
         if(!this.SOUNDQUEUE.MusicIsMuted)
         {
            this.SOUNDQUEUE.setMusicVolume(SaveData.BGVolumeLevel);
         }
         this.m_endGameOptions = this.m_endGameOptions || this.getEndGameDefaults();
         if(this.GAME.GameMode === Mode.ONLINE_WAITING_ROOM)
         {
            MGNEventManager.dispatcher.removeEventListener(MGNEvent.MATCH_END,this.prematureMatchEnd);
            MGNEventManager.dispatcher.removeEventListener(MGNEvent.ROOM_DATA,this.onRoomDataSet);
            MGNEventManager.dispatcher.removeEventListener(MGNEvent.ERROR_ROOM_DATA,this.onRoomDataSet);
         }
         if(this.GAME.GameMode === Mode.TARGET_TEST)
         {
            SaveData.Records.targets.playTime += this.m_elapsedPlayableFrames;
         }
         else if(this.GAME.GameMode === Mode.TARGET_TEST)
         {
            SaveData.Records.targets.playTime += this.m_elapsedPlayableFrames;
         }
         else if(this.GAME.GameMode === Mode.CRYSTAL_SMASH)
         {
            SaveData.Records.crystals.playTime += this.m_elapsedPlayableFrames;
         }
         else if(this.GAME.GameMode === Mode.CLASSIC)
         {
            SaveData.Records.classic.playTime += this.m_elapsedPlayableFrames;
            if(Boolean(this.GAME.UsingTime) && Boolean(Utils.framesToSecondsString(this.TIMER.CurrentTime).match(/(1|3|6)$/)))
            {
               SaveData.Unlocks.mk64Condition = true;
            }
            if(this.TARGETS.length > 0)
            {
               SaveData.Records.targets.playTime += this.m_elapsedPlayableFrames;
            }
         }
         else if(this.GAME.GameMode === Mode.ARENA || this.GAME.GameMode === Mode.ONLINE_ARENA)
         {
            SaveData.Records.arena.playTime += this.m_elapsedPlayableFrames;
            SaveData.Records.arena.stages[this.GAME.LevelData.stage] = SaveData.Records.arena.stages[this.GAME.LevelData.stage] || 0;
            ++SaveData.Records.arena.stages[this.GAME.LevelData.stage];
         }
         else if(this.GAME.GameMode === Mode.MULTIMAN)
         {
            SaveData.Records.multiman.playTime += this.m_elapsedPlayableFrames;
         }
         else if(this.GAME.GameMode === Mode.HOME_RUN_CONTEST)
         {
            SaveData.Records.hrc.playTime += this.m_elapsedPlayableFrames;
         }
         SaveData.PlayTime += this.m_elapsedPlayableFrames;
         SoundQueue.instance.stopMusic();
         if(this.m_onlineMatchDowngradeTimeout.running)
         {
            this.m_onlineMatchDowngradeTimeout.reset();
         }
         if(this.m_onlineMatchStartTimeout.running)
         {
            this.m_onlineMatchStartTimeout.reset();
         }
         if(this.m_onlineMatchEndTimeout.running)
         {
            this.m_onlineMatchEndTimeout.reset();
         }
         i = 0;
         while(i < this.CHARACTERS.length)
         {
            if(this.CHARACTERS[i])
            {
               this.CHARACTERS[i].flushTimers(true);
               this.CHARACTERS[i].EventManagerObj.removeAllEvents();
            }
            i += 1;
         }
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,this.waitForPlayers);
         this.deactivateCharacters();
         SSF2API.deinit();
         ModAPI.deinit();
         this.stopCrowdChant();
         this.m_gameEnded = true;
         this.m_gameEndedExit = true;
         if(this.m_fpsTimer)
         {
            this.m_fpsTimer.kill();
         }
         i = 0;
         while(i < this.PLAYERS.length)
         {
            if(this.PLAYERS[i] != null)
            {
               this.PLAYERS[i].resetDroughtTimer();
            }
            i += 1;
         }
         if(ModeFeatures.hasFeature(ModeFeatures.ALLOW_SUDDEN_DEATH,this.GAME.GameMode))
         {
            topRank = new Array();
            this.updateRanks(true);
            i = 0;
            while(i < this.PLAYERS.length && !noContest && Boolean(this.m_canSuddenDeath))
            {
               if(this.PLAYERS[i] != null && this.PLAYERS[i].getMatchResults().Rank == 1)
               {
                  already = false;
                  j = 0;
                  while(j < topRank.length)
                  {
                     if(this.getPlayerByID(topRank[j]).getMatchResults().Rank == this.PLAYERS[i].getMatchResults().Rank && this.PLAYERS[i].Team == this.getPlayerByID(topRank[j]).Team && this.getPlayerByID(topRank[j]).Team > 0)
                     {
                        already = true;
                     }
                     j += 1;
                  }
                  if(!already)
                  {
                     topRank.push(this.PLAYERS[i].ID);
                  }
               }
               i += 1;
            }
            if(topRank.length > 1)
            {
               topRank = new Array();
               this.m_suddenDeath = true;
               i = 0;
               while(i < this.PLAYERS.length)
               {
                  if(this.PLAYERS[i] != null && this.PLAYERS[i].getMatchResults().Rank == 1)
                  {
                     topRank.push(this.PLAYERS[i].ID);
                  }
                  i += 1;
               }
               this.m_suddenDeathIDs = topRank;
            }
         }
         if(Boolean(this.ONLINEMODE) && Boolean(MultiplayerManager.Connected) && !this.m_suddenDeath)
         {
            MultiplayerManager.sendMatchEndSignal();
            if(MultiplayerManager.DowngradedConnection)
            {
               MultiplayerManager.Protocol = ProtocolSetting.CLIENT_SERVER_TCP;
            }
         }
         this.m_noContest = noContest;
         if(!this.m_noContest && !this.m_suddenDeath && Boolean(this.m_queuedAutoSave))
         {
            this.autoSaveReplay();
         }
         if(ModeFeatures.hasFeature(ModeFeatures.REMOVE_TIMER,this.GAME.GameMode))
         {
            this.TIMER.TimeMC.visible = false;
            this.HUD.SubMenu.visible = false;
         }
         this.HUD.killCameraDarkener();
         this.m_wasReset = true;
         Main.Root.stage.frameRate = Main.FRAMERATE;
         i = 2;
         while(i <= this.GAME.PlayerSettings.length)
         {
            if(this.m_nullPlayers.indexOf(i - 1) >= 0)
            {
               this.GAME.PlayerSettings[i - 1].character = null;
            }
            i += 1;
         }
         j = 0;
         while(j < this.m_effectHUDList.length)
         {
            if(Boolean(this.m_effectHUDList[j]) && this.m_effectHUDList[j].parent != null)
            {
               this.m_effectHUDList[j].parent.removeChild(this.m_effectHUDList[j]);
            }
            j += 1;
         }
         this.SOUNDQUEUE.stopAllSounds();
         this.HUD.forceHitBoxVisiblity(false);
         if(MultiplayerManager.Connected)
         {
            MultiplayerManager.Active = false;
         }
         this.STAGE = null;
         this.STAGEPARENT = null;
         GameController.endMatch();
         this.ROOT.removeEventListener(Event.RENDER,this.renderComplete);
         this.ROOT.removeEventListener(Event.ENTER_FRAME,this.performAllEvents);
         if(Boolean(this.ONLINEMODE) && this.GAME.GameMode === Mode.ONLINE && !SaveData.Unlocks.beatDevOnline && !this.m_noContest)
         {
            if(this.getPlayerByID(MultiplayerManager.PlayerID).getMatchResults().Rank === 1)
            {
               i = 0;
               while(i < this.PLAYERS.length)
               {
                  if(Boolean(this.PLAYERS[i] && this.PLAYERS[i].ID !== MultiplayerManager.PlayerID) && Boolean(this.PLAYERS[i].getMatchResults().Rank > 1) && Boolean(this.PLAYERS[i].getPlayerSettings().name))
                  {
                     if(Boolean(this.PLAYERS[i].getPlayerSettings().beatDevOnline) || this.PLAYERS[i].ID - 1 < MultiplayerManager.Players.length && Boolean(MultiplayerManager.Players[this.PLAYERS[i].ID - 1].is_dev))
                     {
                        SaveData.Unlocks.beatDevOnline = true;
                     }
                  }
                  i += 1;
               }
            }
         }
         if(this.GAME.GameMode === Mode.ONLINE)
         {
            UnlockController.checkUnlocks();
         }
         if(this.GAME.GameMode == Mode.TRAINING)
         {
            UnlockController.nextMenuFunc = function():void
            {
               GameController.destroyStageData();
               MenuController.trainingMenu.show();
            };
         }
         else if(ModeFeatures.hasFeature(ModeFeatures.IS_CUSTOM,this.GAME.GameMode))
         {
            UnlockController.nextMenuFunc = function():void
            {
               if(GAME.CustomModeObj)
               {
                  if(m_noContest)
                  {
                     if(m_retryMatch)
                     {
                        if(m_queuedAutoSave)
                        {
                           autoSaveReplay();
                        }
                        GameController.destroyStageData();
                        GAME.CustomModeObj.retry();
                     }
                     else if(m_endGameOptions.matchResults)
                     {
                        showMatchResults();
                     }
                     else
                     {
                        GAME.CustomModeObj.endMode(null);
                        GameController.destroyStageData();
                     }
                  }
                  else if(m_endGameOptions.matchResults)
                  {
                     showMatchResults();
                  }
                  else
                  {
                     GAME.CustomModeObj.APIInstance.handleMatchComplete();
                  }
                  return;
               }
               throw new Error("CustomMode object is undefined");
            };
         }
         else if(this.GAME.GameMode != Mode.VS_UNLOCK)
         {
            if(this.GAME.GameMode == Mode.ONLINE_WAITING_ROOM)
            {
               if(this.m_noContest)
               {
                  if(!MultiplayerManager.Connected)
                  {
                     UnlockController.nextMenuFunc = function():void
                     {
                        GameController.destroyStageData();
                        MenuController.mainMenu.show();
                     };
                  }
                  else
                  {
                     GameController.destroyStageData();
                     UnlockController.nextMenuFunc = function():void
                     {
                        MultiplayerManager.resetMasterFrame();
                        MultiplayerManager.restoreOriginalGameSettings(MenuController.CurrentCharacterSelectMenu.GameObj);
                        if(MultiplayerManager.RoomKey)
                        {
                           MenuController.onlineCharacterMenu.show();
                        }
                        else
                        {
                           MenuController.onlineMenu.show();
                        }
                     };
                  }
               }
               else
               {
                  UnlockController.nextMenuFunc = null;
               }
            }
            else
            {
               UnlockController.nextMenuFunc = this.showMatchResults;
            }
         }
         if(this.GAME.GameMode == Mode.VS_UNLOCK)
         {
            if(!this.m_noContest && this.getFirstWinner().ID == 1)
            {
               UnlockController.pendingUnlockScreens.unshift(UnlockController.pendingUnlockFights[0]);
               UnlockController.pendingUnlockFights.shift();
               MenuController.postUnlockMenu.show();
               GameController.currentGame = null;
               GameController.currentGame = GameController.tmpGame;
            }
            else
            {
               GameController.currentGame = null;
               GameController.currentGame = GameController.tmpGame;
               UnlockController.pendingUnlockFights.shift();
               if(UnlockController.pendingUnlockFights.length > 0)
               {
                  MenuController.preUnlockMenu.show();
               }
               else if(UnlockController.pendingUnlockScreens.length > 0)
               {
                  MenuController.postUnlockMenu.show();
               }
               else
               {
                  goBack = true;
               }
            }
         }
         else if(this.checkSuddenDeath())
         {
            GameController.startMatch();
         }
         else
         {
            GameController.tmpStageData = null;
            GameController.tmpGame = null;
            if(Boolean(ModeFeatures.hasFeature(ModeFeatures.IS_CUSTOM,this.GAME.GameMode)) && UnlockController.pendingUnlockFights.length > 0)
            {
               MenuController.preUnlockMenu.show();
            }
            else if(Boolean(ModeFeatures.hasFeature(ModeFeatures.IS_CUSTOM,this.GAME.GameMode)) && UnlockController.pendingUnlockScreens.length > 0)
            {
               MenuController.postUnlockMenu.show();
            }
            else
            {
               goBack = true;
            }
         }
         if(goBack)
         {
            if(this.GAME.GameMode === Mode.ONLINE && UnlockController.pendingUnlockScreens.length > 0)
            {
               MenuController.postUnlockMenu.show();
            }
            else if(UnlockController.nextMenuFunc != null)
            {
               UnlockController.nextMenuFunc();
            }
         }
      }
      
      private function showMatchResults() : void
      {
         if(MenuController.matchResultsMenu)
         {
            MenuController.matchResultsMenu.removeSelf();
         }
         MenuController.matchResultsMenu = new MatchResultsMenu();
         MenuController.matchResultsMenu.show();
      }
      
      private function checkSuddenDeath() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(!ModeFeatures.hasFeature(ModeFeatures.ALLOW_SUDDEN_DEATH,this.GAME.GameMode))
         {
            return false;
         }
         if(!GameController.stageData.SuddenDeath)
         {
            if(GameController.currentGame.SuddenDeath)
            {
               _loc1_ = 1;
               while(_loc1_ <= this.PLAYERS.length)
               {
                  if(GameController.stageData.getPlayerByID(_loc1_) != null)
                  {
                     if(GameController.stageData.getPlayerByID(_loc1_).getMatchResults().Rank != 1)
                     {
                        ++GameController.tmpStageData.getPlayerByID(_loc1_).getMatchResults().Rank;
                     }
                  }
                  else if(GameController.tmpStageData.getPlayerByID(_loc1_) != null)
                  {
                     ++GameController.tmpStageData.getPlayerByID(_loc1_).getMatchResults().Rank;
                  }
                  _loc1_++;
               }
               GameController.currentGame = GameController.tmpGame;
               GameController.stageData = GameController.tmpStageData;
               GameController.tmpStageData = null;
               GameController.tmpGame = null;
               if(this.m_noContest)
               {
                  GameController.stageData.NoContest = true;
               }
            }
            return false;
         }
         GameController.tmpStageData = GameController.stageData;
         GameController.tmpGame = GameController.currentGame;
         GameController.currentGame = new Game(GameController.tmpGame.PlayerSettings.length,GameController.tmpGame.GameMode);
         GameController.currentGame.LevelData.randSeed = GameController.tmpGame.LevelData.randSeed;
         if(this.REPLAYMODE)
         {
            GameController.currentGame.ReplayDataObj = GameController.tmpStageData.ReplayDataObj;
         }
         _loc2_ = 0;
         while(_loc2_ < GameController.stageData.SuddenDeathIDs.length)
         {
            _loc3_ = int(GameController.stageData.SuddenDeathIDs[_loc2_]);
            GameController.currentGame.PlayerSettings[_loc3_ - 1].character = GameController.tmpGame.PlayerSettings[_loc3_ - 1].character == "xp" ? "xp" : GameController.stageData.getPlayerByID(_loc3_).StatsName;
            GameController.currentGame.PlayerSettings[_loc3_ - 1].damageRatio = 1;
            GameController.currentGame.PlayerSettings[_loc3_ - 1].finalSmashMeter = false;
            GameController.currentGame.PlayerSettings[_loc3_ - 1].lives = 1;
            GameController.currentGame.PlayerSettings[_loc3_ - 1].startDamage = 300;
            GameController.currentGame.PlayerSettings[_loc3_ - 1].human = GameController.tmpGame.PlayerSettings[_loc3_ - 1].human;
            GameController.currentGame.PlayerSettings[_loc3_ - 1].team = GameController.tmpGame.PlayerSettings[_loc3_ - 1].team;
            GameController.currentGame.PlayerSettings[_loc3_ - 1].costume = GameController.tmpGame.PlayerSettings[_loc3_ - 1].costume;
            GameController.currentGame.PlayerSettings[_loc3_ - 1].level = GameController.tmpGame.PlayerSettings[_loc3_ - 1].level;
            GameController.currentGame.PlayerSettings[_loc3_ - 1].expansion = GameController.tmpGame.PlayerSettings[_loc3_ - 1].expansion;
            GameController.currentGame.PlayerSettings[_loc3_ - 1].exist = GameController.stageData.SuddenDeathIDs.indexOf(_loc3_) >= 0;
            _loc2_++;
         }
         GameController.currentGame.LevelData.showPlayerID = GameController.tmpGame.LevelData.showPlayerID;
         GameController.currentGame.LevelData.startDamage = 300;
         GameController.currentGame.LevelData.usingLives = true;
         GameController.currentGame.LevelData.usingTime = false;
         GameController.currentGame.LevelData.usingStamina = false;
         GameController.currentGame.LevelData.lives = 1;
         GameController.currentGame.LevelData.specialModes = GameController.tmpGame.LevelData.specialModes;
         GameController.currentGame.SuddenDeath = true;
         GameController.currentGame.LevelData.stage = GameController.tmpGame.LevelData.stage;
         GameController.currentGame.Items.frequency = 0;
         SoundQueue.instance.stopMusic();
         SoundQueue.instance.stopAllSounds();
         SoundQueue.instance.setLoopFunction(SoundQueue.instance.loopMusic);
         return true;
      }
      
      private function performAllEvents(param1:Event) : void
      {
         this.ROOT.stage.invalidate();
      }
      
      private function renderComplete(param1:Event) : void
      {
         this.PERFORMALL();
      }
      
      private function onRoomDataSet(param1:MGNEvent) : void
      {
         MGNEventManager.dispatcher.removeEventListener(MGNEvent.ROOM_DATA,this.onRoomDataSet);
         MGNEventManager.dispatcher.removeEventListener(MGNEvent.ERROR_ROOM_DATA,this.onRoomDataSet);
         if(param1.type === MGNEvent.ROOM_DATA)
         {
            MultiplayerManager.lockRoom();
         }
         else if(param1.type === MGNEvent.ERROR_ROOM_DATA)
         {
            MultiplayerManager.notify("Error setting room data, server may be unavailable at this time");
         }
      }
      
      public function startOnlineMatch() : Boolean
      {
         var _loc1_:Object = null;
         if(this.m_onlineLockPending)
         {
            return false;
         }
         if(MultiplayerManager.Players.length <= 1)
         {
            SoundQueue.instance.playSoundEffect("menu_error");
            MultiplayerManager.notify("Host player must allow other players to join before proceeding.");
            return false;
         }
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         this.m_onlineLockPending = true;
         MGNEventManager.dispatcher.addEventListener(MGNEvent.ROOM_DATA,this.onRoomDataSet);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.ERROR_ROOM_DATA,this.onRoomDataSet);
         _loc1_ = Utils.cloneObject(GameController.onlineModeMatchSettings.playerSettings[0]);
         if(_loc1_.character === "random")
         {
            _loc1_.character = this.PLAYERS[0].StatsName;
         }
         MultiplayerManager.sendMatchReadySignal({"playerSettings":_loc1_});
         MultiplayerManager.sendMatchSettings({
            "version":Version.getVersion(),
            "protocol":MultiplayerManager.Protocol,
            "matchSettings":GameController.onlineModeMatchSettings
         });
         return true;
      }
      
      private function waitForPlayers(param1:Event) : void
      {
         var _loc2_:Object = this.PLAYERS[0].getControls(false);
         if(Boolean(MultiplayerManager.IsHost) && !this.m_onlineLockPending && !MultiplayerManager.RoomLocked)
         {
            if(!this.HUD.SubMenu.onlineStartButton.visible)
            {
               this.HUD.SubMenu.onlineStartButton.visible = true;
               this.HUD.SubMenu.onlineStartButton.play();
               MultiplayerManager.resetMasterFrame();
            }
            if(this.PLAYERS[0].getControls(true)["START"])
            {
               if((Boolean(_loc2_["BUTTON1"]) || Boolean(_loc2_["SHIELD"]) && Boolean(_loc2_["SHIELD2"])) && Boolean(_loc2_["BUTTON2"]))
               {
                  this.endGame(true);
               }
               else
               {
                  this.HUD.SubMenu.onlineQuitButtons.visible = false;
                  this.HUD.SubMenu.onlineStartButton.visible = false;
                  this.HUD.SubMenu.onlineStartButton.stop();
                  this.startOnlineMatch();
               }
            }
         }
         else if(Boolean(!MultiplayerManager.IsHost) && Boolean(this.PLAYERS[0].getControls(true)["START"]) && (Boolean(_loc2_["BUTTON1"]) || Boolean(_loc2_["SHIELD"]) && Boolean(_loc2_["SHIELD2"])) && Boolean(_loc2_["BUTTON2"]))
         {
            MultiplayerManager.leaveRoom();
         }
         else if(!(Boolean(MultiplayerManager.IsHost) && Boolean(this.m_onlineLockPending) && !MultiplayerManager.RoomLocked))
         {
            this.m_onlineLockPending = false;
            if(!MultiplayerManager.RoomKey && !MultiplayerManager.IsHost)
            {
               this.endGame(true);
               return;
            }
            if(MultiplayerManager.MatchReady)
            {
               if(MultiplayerManager.MasterFrame < 4 && !this.m_onlineMatchStartTimeout.running && !this.m_gameEnded)
               {
                  this.m_onlineMatchStartTimeout.start();
                  if(Boolean(MultiplayerManager.IsHost) && Boolean(MultiplayerManager.Protocol))
                  {
                     this.m_onlineMatchDowngradeTimeout.start();
                  }
                  MGNEventManager.dispatcher.addEventListener(MGNEvent.MATCH_END,this.prematureMatchEnd);
               }
               MultiplayerManager.Active = true;
               if(MultiplayerManager.MasterFrame < 4)
               {
                  MultiplayerManager.sendMyDataFrame(MultiplayerManager.MasterFrame,{"controls":SaveData.Controllers[0].getControlStatus().controls});
                  ++MultiplayerManager.MasterFrame;
               }
               MultiplayerManager.PromotionTimer.reset();
               MultiplayerManager.PERFORMALL();
               if(MultiplayerManager.PlayerSyncStream.Pointer > 2)
               {
                  Main.Root.stage.removeEventListener(Event.ENTER_FRAME,this.waitForPlayers);
                  if(!this.m_gameEnded)
                  {
                     this.endGame(false);
                  }
                  GameController.startMatch(MultiplayerManager.GameInstance);
               }
            }
            else
            {
               if(this.m_onlineMatchStartTimeout.running)
               {
                  this.m_onlineMatchStartTimeout.reset();
               }
               if(this.m_onlineMatchDowngradeTimeout.running)
               {
                  this.m_onlineMatchDowngradeTimeout.reset();
               }
            }
         }
      }
      
      private function waitForPlayersSuddenDeath(param1:Event) : void
      {
         var _loc2_:Object = null;
         if(!MultiplayerManager.MatchReady)
         {
            MultiplayerManager.resetMasterFrame();
            this.m_onlineLockPending = true;
            Main.Root.stage.removeEventListener(Event.ENTER_FRAME,this.waitForPlayersSuddenDeath);
            Main.Root.stage.addEventListener(Event.ENTER_FRAME,this.waitForPlayers);
            _loc2_ = Utils.cloneObject(GameController.onlineModeMatchSettings.playerSettings[0]);
            if(_loc2_.character === "random")
            {
               _loc2_.character = this.PLAYERS[MultiplayerManager.PlayerID - 1].StatsName;
            }
            MultiplayerManager.sendMatchReadySignal({"playerSettings":_loc2_});
         }
      }
      
      private function onlineModeMatchEndTimeout(param1:TimerEvent) : void
      {
         MultiplayerManager.notify("Error, match was desynced. Please reconnect");
         MultiplayerManager.disconnect();
         this.endGame(true);
      }
      
      private function onlineModeMatchStartTimeout(param1:TimerEvent) : void
      {
         var e:TimerEvent = param1;
         var code:String = "001";
         try
         {
            if(MultiplayerManager.PlayerID <= 0)
            {
               code = "002";
            }
            else if(MultiplayerManager.Players.length <= 1)
            {
               code = "003-" + MultiplayerManager.Players.length;
            }
            else if(MultiplayerManager.Players[MultiplayerManager.PlayerID - 1].username !== MultiplayerManager.Username)
            {
               code = "004-" + MultiplayerManager.Players[MultiplayerManager.PlayerID - 1].username + "->" + MultiplayerManager.Username;
            }
            else if(MultiplayerManager.Players[MultiplayerManager.PlayerID - 1].socket_id !== MultiplayerManager.SocketID)
            {
               code = "005";
            }
            else if(!MultiplayerManager.PlayerSyncStream.getDataFrameGroup(1).getDataFrameFor(MultiplayerManager.PlayerID - 1).isReady())
            {
               code = "006";
            }
            else if(!MultiplayerManager.PlayerSyncStream.getDataFrameGroup(1).Complete && (Boolean(MultiplayerManager.PlayerSyncStream.getDataFrameGroup(2).Complete) || Boolean(MultiplayerManager.PlayerSyncStream.getDataFrameGroup(3).Complete)))
            {
               code = "007";
            }
            else if(Boolean(MultiplayerManager.PlayerSyncStream.getDataFrameGroup(1).Complete) && !MultiplayerManager.PlayerSyncStream.getDataFrameGroup(2).Complete && Boolean(MultiplayerManager.PlayerSyncStream.getDataFrameGroup(3).Complete))
            {
               code = "008";
            }
            else if(!MultiplayerManager.PlayerSyncStream.getDataFrameGroup(1).Complete && !MultiplayerManager.PlayerSyncStream.getDataFrameGroup(2).Complete && !MultiplayerManager.PlayerSyncStream.getDataFrameGroup(3).Complete)
            {
               code = "009";
            }
         }
         catch(e:*)
         {
            code = "000";
         }
         MultiplayerManager.notify("Error starting match. ERR CODE: " + code);
         this.endGame(true);
      }
      
      private function onlineModeMatchDowngradeTimeout(param1:TimerEvent) : void
      {
         if(MultiplayerManager.IsHost)
         {
            MultiplayerManager.notify("P2P Connection failed. Falling back to server-server communication...");
            MultiplayerManager.downgradeP2P();
         }
      }
      
      private function prematureMatchEnd(param1:MGNEvent) : void
      {
         if(MultiplayerManager.IsHost)
         {
            MultiplayerManager.unlockRoom();
         }
         MultiplayerManager.notify("Error, match was forced to end by host.");
         this.endGame(true);
      }
      
      private function checkOnlineSync() : void
      {
         var _loc1_:int = 0;
         if(this.ONLINEMODE)
         {
            MultiplayerManager.Active = true;
            if(Boolean(MultiplayerManager.IsHost) && new Date().getTime() - this.m_onlineModeLastPing > 30000)
            {
               MultiplayerManager.notify("Error, match timed out.");
               this.endGame(true);
               return;
            }
            if(Boolean(MultiplayerManager.MatchEnded) && !this.m_onlineMatchEndTimeout.running)
            {
               this.m_onlineMatchEndTimeout.start();
            }
            if(MultiplayerManager.MasterFrame < 4 && !this.m_onlineMatchStartTimeout.running)
            {
               this.m_onlineMatchStartTimeout.start();
            }
            else if(MultiplayerManager.MasterFrame >= 4 && Boolean(this.m_onlineMatchStartTimeout.running))
            {
               this.m_onlineMatchStartTimeout.reset();
            }
            if(MultiplayerManager.Controllers[0].ControlsQueue.length > 0)
            {
               this.READY = true;
               --this.m_onlineFrameBuffer.CurrentTime;
               this.m_onlineModeLastPing = new Date().getTime();
               _loc1_ = 0;
               while(_loc1_ < this.PLAYERS.length)
               {
                  if(this.PLAYERS[_loc1_] != null && Boolean(this.PLAYERS[_loc1_].ControlSettings))
                  {
                     this.PLAYERS[_loc1_].ControlSettings.setControlsObject(new ControlsObject(MultiplayerManager.Controllers[this.PLAYERS[_loc1_].ID - 1].nextControlBits()));
                  }
                  _loc1_++;
               }
            }
            else
            {
               this.READY = false;
            }
            if(MultiplayerManager.Players.length !== this.GAME.PlayerSettings.length)
            {
               this.endGame(true);
            }
         }
         else if(this.m_event)
         {
            this.READY = true;
            MultiplayerManager.Active = false;
         }
         else
         {
            this.READY = true;
         }
      }
      
      private function runOnlineLog() : void
      {
         if(Boolean(Main.DEBUG) && Boolean(MenuController.debugConsole) && Boolean(MenuController.debugConsole.OnlineCapture))
         {
            this.m_logText += "Frame#: " + this.m_elapsedFrames + "\n";
            this.m_logText += "Cam State: {" + "x: " + this.CAM.X + ", y: " + this.CAM.Y + ", w: " + this.CAM.Width + ", h" + this.CAM.Height + "}\n";
            this.m_logText += "Rand: " + Utils.LastRandom + "\n";
            if(this.getPlayerByID(1))
            {
               this.m_logText += "P1: " + this.getPlayerByID(1).getStateInfo() + "\n";
            }
            if(this.getPlayerByID(2))
            {
               this.m_logText += "P2: " + this.getPlayerByID(2).getStateInfo() + "\n";
            }
            if(this.getPlayerByID(3))
            {
               this.m_logText += "P3: " + this.getPlayerByID(3).getStateInfo() + "\n";
            }
            if(this.getPlayerByID(4))
            {
               this.m_logText += "P4: " + this.getPlayerByID(4).getStateInfo() + "\n";
            }
            this.m_logText += "\n\n";
         }
      }
      
      private function entranceCheck() : void
      {
         if(!this.m_entranceZoomTimer.IsComplete && Boolean(this.GAME.LevelData.showEntrances))
         {
            this.m_entranceZoomTimer.tick();
            if(this.m_entranceZoomTimer.CurrentTime % 15 === 0)
            {
               if(this.m_entranceZoomMode == 1)
               {
                  this.CAM.removeAllZoomFocus();
               }
               ++this.m_currentEntrance;
               while(this.m_currentEntrance < this.PLAYERS.length && !this.PLAYERS[this.m_currentEntrance])
               {
                  ++this.m_currentEntrance;
               }
               if(this.m_currentEntrance < this.PLAYERS.length)
               {
                  this.PLAYERS[this.m_currentEntrance].FreezePlayback = false;
                  this.PLAYERS[this.m_currentEntrance].setVisibility(true);
                  this.CAM.addZoomFocus(this.PLAYERS[this.m_currentEntrance].MC,999);
                  if(this.m_currentEntrance + 1 >= this.PLAYERS.length)
                  {
                     this.CAM.removeAllZoomFocus();
                  }
               }
            }
            if(this.m_entranceZoomTimer.IsComplete)
            {
               this.CAM.removeAllZoomFocus();
            }
         }
      }
      
      private function pauseCheck() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(!this.m_gameEnded && !this.m_event && Boolean(ModeFeatures.hasFeature(ModeFeatures.ALLOW_PAUSE,this.GAME.GameMode)) && (Boolean(this.GAME.LevelData.pauseEnabled) || Boolean(this.REPLAYMODE)))
         {
            _loc1_ = false;
            _loc6_ = 1;
            while(_loc6_ <= this.PLAYERS.length)
            {
               if(Boolean(this.getPlayerByID(_loc6_)) && Boolean(this.getPlayerByID(_loc6_).IsHuman) && !this.getPlayerByID(_loc6_).Dead)
               {
                  _loc1_ = true;
               }
               _loc6_++;
            }
            if(this.Paused)
            {
               _loc2_ = Boolean(this.getPlayerByID(this.PausedID)) && this.getPlayerByID(this.PausedID).IsHuman;
               _loc3_ = _loc2_ ? this.PausedID : 1;
               _loc4_ = _loc2_ ? this.getPlayerByID(_loc3_).PauseLetGo : Boolean(this.m_pausedLetGo);
               _loc5_ = _loc2_ ? this.getPlayerByID(_loc3_).ZLetGo : Boolean(this.m_zLetGo);
               if(!_loc2_ && !this.getControllerNum(_loc3_).IsDown(this.getControllerNum(_loc3_)._START))
               {
                  this.m_pausedLetGo = true;
               }
               if(this.getControllerNum(_loc3_).IsDown(this.getControllerNum(_loc3_)._GRAB) && _loc5_ && Boolean(ModeFeatures.hasFeature(ModeFeatures.HAS_RETRY_BUTTON,this.GAME.GameMode)))
               {
                  this.m_retryMatch = true;
                  this.endGame(true);
               }
               else if((this.getControllerNum(_loc3_).IsDown(this.getControllerNum(_loc3_)._BUTTON1) || this.getControllerNum(_loc3_).IsDown(this.getControllerNum(_loc3_)._SHIELD) && this.getControllerNum(_loc3_).IsDown(this.getControllerNum(_loc3_)._SHIELD2)) && this.getControllerNum(_loc3_).IsDown(this.getControllerNum(_loc3_)._BUTTON2) && this.getControllerNum(_loc3_).IsDown(this.getControllerNum(_loc3_)._START) && _loc4_)
               {
                  if(this.GAME.GameMode == Mode.ONLINE_WAITING_ROOM)
                  {
                     MultiplayerManager.notify("You have disconnected.");
                     MultiplayerManager.disconnect();
                  }
                  this.endGame(true);
               }
               else if(_loc4_ && this.getControllerNum(_loc3_).IsDown(this.getControllerNum(_loc3_)._START))
               {
                  if(_loc2_)
                  {
                     this.getPlayerByID(_loc3_).PauseLetGo = false;
                  }
                  else
                  {
                     this.m_pausedLetGo = false;
                  }
                  this.Paused = false;
                  if(this.GAME.GameMode != Mode.TRAINING)
                  {
                     Main.Root.stage.frameRate = Main.FRAMERATE;
                     if(SpecialMode.modeEnabled(this.GAME.LevelData.specialModes,SpecialMode.SLOW))
                     {
                        Main.Root.stage.frameRate = Main.FRAMERATE / 2;
                     }
                     else if(SpecialMode.modeEnabled(this.GAME.LevelData.specialModes,SpecialMode.LIGHTNING))
                     {
                        Main.Root.stage.frameRate = Main.FRAMERATE * 2;
                     }
                  }
                  if(this.GAME.GameMode != Mode.TRAINING)
                  {
                     _loc7_ = 1;
                     while(_loc7_ <= this.PLAYERS.length)
                     {
                        if(this.getPlayerByID(_loc7_) != null)
                        {
                           this.getPlayerByID(_loc7_).playAllEffects();
                        }
                        _loc7_++;
                     }
                  }
               }
            }
            else
            {
               if(!this.getControllerNum(1).IsDown(this.getControllerNum(1)._START))
               {
                  this.m_pausedLetGo = true;
               }
               if(!this.getControllerNum(1).IsDown(this.getControllerNum(1)._GRAB))
               {
                  _loc5_ = true;
               }
               _loc6_ = 1;
               while(_loc6_ <= this.PLAYERS.length && !this.m_wasReset && Boolean(this.READY))
               {
                  if(this.getPlayerByID(_loc6_) != null && !(this.getPlayerByID(_loc6_).inState(CState.DEAD) && this.getPlayerByID(_loc6_).IsHuman && _loc1_))
                  {
                     if(this.getPlayerByID(_loc6_).IsHuman && this.getPlayerByID(_loc6_).PauseLetGo && this.getPlayerByID(_loc6_).ControlSettings.IsDown(this.getPlayerByID(_loc6_).ControlSettings._START) || !this.getPlayerByID(_loc6_).IsHuman && Boolean(this.m_pausedLetGo) && this.getControllerNum(1).IsDown(this.getControllerNum(1)._START))
                     {
                        this.m_pausedLetGo = false;
                        this.m_paused = false;
                        this.getPlayerByID(_loc6_).PauseLetGo = false;
                        this.Paused = true;
                        if(this.GAME.GameMode != Mode.TRAINING)
                        {
                           Main.Root.stage.frameRate = Main.FRAMERATE;
                        }
                        this.PausedID = this.getPlayerByID(_loc6_).ID;
                        if(this.GAME.GameMode != Mode.TRAINING)
                        {
                           _loc7_ = 0;
                           while(_loc7_ < this.CHARACTERS.length)
                           {
                              if(this.CHARACTERS[_loc7_] != null)
                              {
                                 this.CHARACTERS[_loc7_].pauseAllEffects();
                              }
                              _loc7_++;
                           }
                        }
                        if(this.GAME.GameMode === Mode.TARGET_TEST || this.GAME.GameMode === Mode.CRYSTAL_SMASH)
                        {
                           this.CAM.maxZoomOut();
                           this.CAM.forceTarget();
                           this.CAM.forceInBounds();
                           this.CAM.camControl();
                        }
                        break;
                     }
                  }
                  _loc6_++;
               }
            }
         }
      }
      
      private function advanceAllStageFrames() : void
      {
         if(Boolean(this.m_fsCutscene) || Boolean(this.m_fsCutins > 0) || Boolean(this.m_timestop))
         {
            return;
         }
         if(this.STAGE.root != null)
         {
            Utils.advanceFrame(this.STAGE);
         }
         if(Boolean(this.StageFG) && this.StageFG.root != null)
         {
            Utils.advanceFrame(this.StageFG);
            Utils.recursiveMovieClipPlay(this.StageFG,true);
         }
         if(Boolean(this.StageBG) && this.StageBG.root != null)
         {
            Utils.advanceFrame(this.StageBG);
            Utils.recursiveMovieClipPlay(this.StageBG,true);
         }
         if(Boolean(this.ShadowMaskRef) && this.ShadowMaskRef.root != null)
         {
            Utils.advanceFrame(this.ShadowMaskRef);
         }
         if(Boolean(this.ReflectionsMaskRef) && this.ReflectionsMaskRef.root != null)
         {
            Utils.advanceFrame(this.ReflectionsMaskRef);
         }
         this.CAM.nextFrameBG();
      }
      
      private function stopAllStageFrames() : void
      {
         if(this.STAGE.root)
         {
            this.STAGE.stop();
         }
         if(Boolean(this.StageFG) && this.StageFG.root != null)
         {
            this.StageFG.stop();
            Utils.recursiveMovieClipPlay(this.StageFG,false);
         }
         if(Boolean(this.StageBG) && this.StageBG.root != null)
         {
            this.StageBG.stop();
            Utils.recursiveMovieClipPlay(this.StageBG,false);
         }
         if(Boolean(this.ShadowMaskRef) && this.ShadowMaskRef.root != null)
         {
            this.ShadowMaskRef.stop();
         }
         if(Boolean(this.ReflectionsMaskRef) && this.ReflectionsMaskRef.root != null)
         {
            this.ReflectionsMaskRef.stop();
         }
         this.CAM.pauseBG();
      }
      
      public function setCollisionsEnabled(param1:Boolean) : void
      {
         this.m_collisionsEnabled = param1;
      }
      
      private function flushDisposeBuffer() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.m_apiDisposeList.length)
         {
            this.m_apiDisposeList[_loc1_].dispose();
            _loc1_++;
         }
         if(this.m_apiDisposeList.length > 0)
         {
            this.m_apiDisposeList.splice(0,this.m_apiDisposeList.length);
         }
      }
      
      private function disposeObjects(param1:*) : void
      {
         var _loc2_:* = int(param1.length - 1);
         while(_loc2_ < param1.length && _loc2_ >= 0)
         {
            if(Boolean(param1.length) && Boolean(param1[_loc2_]))
            {
               param1[_loc2_].dispose();
            }
            _loc2_--;
         }
      }
      
      private function tickObjects(param1:*) : void
      {
         var _loc2_:* = int(param1.length - 1);
         while(_loc2_ < param1.length && _loc2_ >= 0)
         {
            if(Boolean(param1.length) && Boolean(param1[_loc2_]))
            {
               param1[_loc2_].PERFORMALL();
            }
            _loc2_--;
         }
      }
      
      private function runAttackCollisionTests(param1:*) : void
      {
         var _loc2_:* = int(param1.length - 1);
         while(_loc2_ < param1.length && _loc2_ >= 0)
         {
            if(Boolean(param1.length) && Boolean(param1[_loc2_]))
            {
               param1[_loc2_].attackCollisionTest();
            }
            _loc2_--;
         }
      }
      
      private function cleanupAttackCollisionTests(param1:*) : void
      {
         var _loc2_:* = int(param1.length - 1);
         while(_loc2_ < param1.length && _loc2_ >= 0)
         {
            if(Boolean(param1.length) && Boolean(param1[_loc2_]))
            {
               param1[_loc2_].attackCollisionTestsCompleted();
            }
            _loc2_--;
         }
      }
      
      private function updateCharacterMatchResults() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.CHARACTERS.length)
         {
            this.CHARACTERS[_loc1_].updateMatchResults();
            _loc1_++;
         }
      }
      
      private function PERFORMALL() : void
      {
         var _loc1_:ControlsObject = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Enemy = null;
         var _loc6_:Projectile = null;
         this.checkOnlineSync();
         this.pauseCheck();
         if(Boolean(this.REPLAYMODE) && !this.Paused)
         {
            if(SaveData.Controllers[0].IsDown(SaveData.Controllers[0]._BUTTON1))
            {
               if(SaveData.Controllers[0].IsDown(SaveData.Controllers[0]._GRAB))
               {
                  if(this.m_replayFrameStep)
                  {
                     return;
                  }
                  this.m_replayFrameStep = true;
               }
               else
               {
                  this.m_replayFrameStep = false;
               }
               if(!this.m_replayFrameStep && !(Boolean(SaveData.Controllers[0].IsDown(SaveData.Controllers[0]._SHIELD)) || Boolean(SaveData.Controllers[0].IsDown(SaveData.Controllers[0]._SHIELD2))))
               {
                  return;
               }
            }
         }
         if(!this.m_wasReset && Boolean(this.READY))
         {
            if(this.Paused)
            {
               _loc2_ = 0;
               while(_loc2_ < this.CHARACTERS.length)
               {
                  this.CHARACTERS[_loc2_].pauseControlChecks();
                  _loc2_++;
               }
            }
            else if(Boolean(this.m_gameEnded) && !this.m_slowFrameRate && Boolean(this.m_gameEndedExit))
            {
               Utils.recursiveMovieClipPlay(this.HUDTEXT,true);
               this.m_endGameTimer.tick();
               if(this.m_endGameTimer.IsComplete)
               {
                  _loc1_ = null;
                  if(!this.ReplayMode && Boolean(ModeFeatures.hasFeature(ModeFeatures.HAS_RETRY_BUTTON,this.GAME.GameMode)))
                  {
                     _loc1_ = SaveData.Controllers[0].getControlStatus();
                     if(_loc1_.GRAB)
                     {
                        this.m_retryMatch = true;
                        this.endGame(true);
                     }
                     else if(_loc1_.BUTTON1 || _loc1_.BUTTON2 || _loc1_.START)
                     {
                        this.playSpecificSound("menu_select");
                        this.endGame();
                     }
                  }
                  else
                  {
                     this.endGame();
                  }
                  return;
               }
               if(Boolean(!this.ReplayMode && this.m_endGameOptions) && Boolean(this.m_endGameOptions.success === false) && Boolean(ModeFeatures.hasFeature(ModeFeatures.HAS_RETRY_BUTTON,this.GAME.GameMode)))
               {
                  _loc1_ = SaveData.Controllers[0].getControlStatus();
                  if(_loc1_.GRAB)
                  {
                     this.m_retryMatch = true;
                     this.endGame(true);
                  }
               }
            }
            else
            {
               ++this.m_elapsedFrames;
               if(!this.m_event && !this.m_fsCutscene && this.m_fsCutins <= 0 && !this.m_timestop)
               {
                  ++this.m_elapsedPlayableFrames;
               }
               if(!this.REPLAYMODE)
               {
                  ++this.m_replayData.FrameCount;
               }
               this.runOnlineLog();
               _loc2_ = 0;
               _loc3_ = 0;
               _loc4_ = 0;
               if(this.REPLAYMODE)
               {
                  if(SaveData.Controllers[0].IsDown(SaveData.Controllers[0]._LEFT) !== SaveData.Controllers[0].IsDown(SaveData.Controllers[0]._RIGHT))
                  {
                     if(Boolean(SaveData.Controllers[0].IsDown(SaveData.Controllers[0]._LEFT)) && this.m_replayFrameRateMultiplier !== 0.5)
                     {
                        this.m_replayFrameRateMultiplier = 0.5;
                        if(SpecialMode.modeEnabled(this.GAME.LevelData.specialModes,SpecialMode.SLOW))
                        {
                           Main.Root.stage.frameRate = Main.FRAMERATE / 2 * this.m_replayFrameRateMultiplier;
                        }
                        else if(SpecialMode.modeEnabled(this.GAME.LevelData.specialModes,SpecialMode.LIGHTNING))
                        {
                           Main.Root.stage.frameRate = Main.FRAMERATE * 2 * this.m_replayFrameRateMultiplier;
                        }
                        else
                        {
                           Main.Root.stage.frameRate = Main.FRAMERATE * this.m_replayFrameRateMultiplier;
                        }
                     }
                     else if(Boolean(SaveData.Controllers[0].IsDown(SaveData.Controllers[0]._RIGHT)) && this.m_replayFrameRateMultiplier !== 2)
                     {
                        this.m_replayFrameRateMultiplier = 2;
                        if(SpecialMode.modeEnabled(this.GAME.LevelData.specialModes,SpecialMode.SLOW))
                        {
                           Main.Root.stage.frameRate = Main.FRAMERATE / 2 * this.m_replayFrameRateMultiplier;
                        }
                        else if(SpecialMode.modeEnabled(this.GAME.LevelData.specialModes,SpecialMode.LIGHTNING))
                        {
                           Main.Root.stage.frameRate = Main.FRAMERATE * this.m_replayFrameRateMultiplier;
                        }
                        else
                        {
                           Main.Root.stage.frameRate = Main.FRAMERATE * this.m_replayFrameRateMultiplier;
                        }
                     }
                  }
                  else if(this.m_replayFrameRateMultiplier !== 1)
                  {
                     this.m_replayFrameRateMultiplier = 1;
                     if(SpecialMode.modeEnabled(this.GAME.LevelData.specialModes,SpecialMode.SLOW))
                     {
                        Main.Root.stage.frameRate = Main.FRAMERATE / 2 * this.m_replayFrameRateMultiplier;
                     }
                     else if(SpecialMode.modeEnabled(this.GAME.LevelData.specialModes,SpecialMode.LIGHTNING))
                     {
                        Main.Root.stage.frameRate = Main.FRAMERATE * 2 * this.m_replayFrameRateMultiplier;
                     }
                     else
                     {
                        Main.Root.stage.frameRate = Main.FRAMERATE * this.m_replayFrameRateMultiplier;
                     }
                  }
                  _loc2_ = 0;
                  while(_loc2_ < this.PLAYERS.length)
                  {
                     if(this.PLAYERS[_loc2_] != null && Boolean(this.PLAYERS[_loc2_].IsHuman))
                     {
                        this.PLAYERS[_loc2_].ControlSettings.setControlsObject(new ControlsObject(this.m_replayData.retrieveControls(_loc2_ + 1)));
                     }
                     _loc2_++;
                  }
                  this.m_replayData.nextControls();
               }
               this.m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.GAME_TICK_START,{}));
               this.entranceCheck();
               if(Boolean(this.GAME.UsingTime) && !this.m_event && !this.m_fsCutscene && this.m_fsCutins <= 0 && !this.m_timestop)
               {
                  this.TIMER.PERFORMALL();
               }
               if(!this.m_fsCutscene && this.m_fsCutins <= 0)
               {
                  this.tickTime();
               }
               this.HUD.updateHealthBoxVisibility();
               this.HUD.updateCPUDamage();
               this.m_crowdChantTimer.tick();
               if(Boolean(this.m_crowdChantTimer.IsComplete) && this.m_crowdChantID > 0)
               {
                  this.stopCrowdChant();
                  this.playSpecificVoice(["crowd_clap_s","crowd_clap_m","crowd_clap_l"][Utils.safeRandomInteger(0,2)]);
               }
               if(this.m_crowdChantID < 0)
               {
                  this.m_crowdChantDelay.tick();
               }
               if(!this.m_fsCutscene && this.m_fsCutins <= 0 && !this.m_timestop)
               {
                  this.tickObjects(this.TARGETS);
               }
               if(!this.m_fsCutscene && this.m_fsCutins <= 0 && !this.m_timestop)
               {
                  this.tickObjects(this.MOVINGPLATFORMS);
               }
               if(!this.m_fsCutscene && this.m_fsCutins <= 0 && !this.m_timestop)
               {
                  this.tickObjects(this.COLLISION_BOUNDARIES);
               }
               if(Boolean(this.m_apiInstance && !this.m_fsCutscene) && Boolean(this.m_fsCutins <= 0) && !this.m_timestop)
               {
                  this.m_apiInstance.update();
               }
               this.tickObjects(this.CHARACTERS);
               this.nextFrameAllEffects();
               this.advanceAllStageFrames();
               Utils.recursiveMovieClipPlay(this.CUTSCENE,true);
               this.tickObjects(this.ENEMY);
               this.tickObjects(this.PROJECTILES);
               this.ITEMS.PERFORMALL();
               this.tickObjects(this.ITEMS.ItemsInUse);
               if(this.m_collisionsEnabled)
               {
                  this.runAttackCollisionTests(this.CHARACTERS);
                  this.runAttackCollisionTests(this.ENEMY);
                  this.runAttackCollisionTests(this.PROJECTILES);
                  this.runAttackCollisionTests(this.ITEMS.ItemsInUse);
                  this.m_hitBoxProcessor.process();
                  this.cleanupAttackCollisionTests(this.CHARACTERS);
                  this.cleanupAttackCollisionTests(this.ENEMY);
                  this.cleanupAttackCollisionTests(this.PROJECTILES);
                  this.cleanupAttackCollisionTests(this.ITEMS.ItemsInUse);
               }
               if(!this.m_fsCutscene && this.m_fsCutins <= 0 && !this.m_timestop)
               {
                  this.tickTimers();
               }
               this.CAM.PERFORMALL();
               if(this.GAME.GameMode == Mode.TRAINING)
               {
                  this.HUD.updateHelpMenu();
               }
               if(ModeFeatures.hasFeature(ModeFeatures.IS_CUSTOM,this.GAME.GameMode))
               {
                  this.GAME.CustomMatchObj.update();
               }
               this.m_soundMemory.clear();
               this.updateCharacterMatchResults();
               this.m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.GAME_TICK_END,{}));
               if(Boolean(this.m_gameEnded) && Boolean(this.m_gameEndedExit))
               {
                  this.m_endGameTimer.tick();
                  if(this.m_endGameTimer.IsComplete)
                  {
                     this.endGame();
                     return;
                  }
               }
               this.m_justPaused = false;
               if(this.m_endTrigger)
               {
                  this.m_endTrigger = false;
                  this.prepareEndGame(this.m_endGameOptions || {
                     "slowMo":this.m_slowFrameRate,
                     "immediate":false
                  });
               }
               if(Boolean(this.REPLAYMODE) && this.m_elapsedFrames > this.m_replayData.FrameCount && (this.GAME.GameMode === Mode.VS || this.GAME.GameMode === Mode.ONLINE || this.GAME.GameMode === Mode.ARENA || this.GAME.GameMode === Mode.ONLINE_ARENA))
               {
                  this.prepareEndGame({"forceNoContest":true});
               }
               this.flushDisposeBuffer();
            }
         }
         if(!this.m_wasReset && Boolean(this.ONLINEMODE))
         {
            if(MultiplayerManager.INPUT_BUFFER != 0)
            {
               if(!this.m_onlineFrameBuffer.IsComplete)
               {
                  this.onlineModeSendControls();
                  this.m_onlineFrameBuffer.tick();
                  this.m_onlineFrameBuffer.MaxTime = MultiplayerManager.INPUT_BUFFER;
               }
            }
            MultiplayerManager.PERFORMALL();
         }
      }
      
      private function onlineModeSendControls(param1:TimerEvent = null) : void
      {
         MultiplayerManager.sendMyDataFrame(MultiplayerManager.MasterFrame,{"controls":SaveData.Controllers[0].getControlStatus().controls});
         ++MultiplayerManager.MasterFrame;
      }
      
      public function createTimer(param1:int, param2:int, param3:Function, param4:Object = null) : void
      {
         this.m_timers.push(new IntervalTimer(param1,param2,param3,param4));
      }
      
      public function flushTimers() : void
      {
         this.m_timers.splice(0,this.m_timers.length);
      }
      
      private function tickTimers() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Vector.<IntervalTimer> = null;
         var _loc3_:int = 0;
         if(this.m_timers.length)
         {
            _loc2_ = new Vector.<IntervalTimer>();
            _loc1_ = 0;
            while(_loc1_ < this.m_timers.length)
            {
               this.m_timers[_loc1_].tick();
               if(this.m_timers[_loc1_].ReadyToProcess)
               {
                  _loc2_.push(this.m_timers[_loc1_]);
               }
               _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < _loc2_.length)
            {
               _loc2_[_loc1_].process();
               if(!_loc2_[_loc1_].Active)
               {
                  _loc3_ = int(this.m_timers.indexOf(_loc2_[_loc1_]));
                  if(_loc3_ >= 0)
                  {
                     this.m_timers.splice(_loc3_,1);
                  }
               }
               _loc1_++;
            }
         }
      }
      
      public function destroyTimer(param1:Function) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.m_timers.length)
         {
            if(this.m_timers[_loc2_].Callback == param1)
            {
               this.m_timers.splice(_loc2_--,1);
            }
            _loc2_++;
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Object = null) : void
      {
         this.m_eventManager.addEventListener(param1,param2);
      }
      
      public function hasEventListener(param1:String, param2:Function = null) : Boolean
      {
         return this.m_eventManager.hasEvent(param1,param2);
      }
      
      public function removeEventListener(param1:String, param2:Function) : void
      {
         this.m_eventManager.removeEventListener(param1,param2);
      }
      
      public function getGameObjectByUID(param1:int) : InteractiveSprite
      {
         var _loc2_:InteractiveSprite = null;
         _loc2_ = this.getCharacterByUID(param1);
         if(!_loc2_)
         {
            _loc2_ = this.getProjectile(param1);
         }
         if(!_loc2_)
         {
            _loc2_ = this.getEnemy(param1);
         }
         return _loc2_;
      }
      
      public function getPlayerByID(param1:int) : Character
      {
         if(param1 <= 0 || param1 > this.PLAYERS.length || this.PLAYERS[param1 - 1] == null)
         {
            return null;
         }
         return this.PLAYERS[param1 - 1] as Character;
      }
      
      public function getPlayerByMC(param1:MovieClip) : Character
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.PLAYERS.length)
         {
            if(Boolean(this.PLAYERS[_loc2_]) && (this.PLAYERS[_loc2_].MC == param1 || this.PLAYERS[_loc2_].Stance != null && this.PLAYERS[_loc2_].Stance == param1))
            {
               return this.PLAYERS[_loc2_];
            }
            if(Boolean(this.PLAYERS[_loc2_]) && (Boolean(param1.player_id && param1.player_id > 0) && Boolean(this.PLAYERS[_loc2_].ID === param1.player_id) || Boolean(param1.parent && MovieClip(param1.parent).player_id && MovieClip(param1.parent).player_id > 0) && Boolean(this.PLAYERS[_loc2_].ID === MovieClip(param1.parent).player_id)))
            {
               return this.PLAYERS[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getCharacterByUID(param1:int) : Character
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.CHARACTERS.length)
         {
            if(Boolean(this.CHARACTERS[_loc2_]) && this.CHARACTERS[_loc2_].UID == param1)
            {
               return this.CHARACTERS[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getCharacterByMC(param1:MovieClip) : Character
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.CHARACTERS.length)
         {
            if(this.CHARACTERS[_loc2_].MC == param1 || this.CHARACTERS[_loc2_].Stance != null && this.CHARACTERS[_loc2_].Stance == param1)
            {
               return this.CHARACTERS[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function hasEnemy(param1:Class) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.ENEMY.length)
         {
            if(this.ENEMY[_loc2_] is param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function getEnemy(param1:int) : Enemy
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.ENEMY.length)
         {
            if(Boolean(this.ENEMY[_loc2_]) && this.ENEMY[_loc2_].UID == param1)
            {
               return this.ENEMY[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getEnemyByInstanceName(param1:String) : Enemy
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.ENEMY.length)
         {
            if(Boolean(this.ENEMY[_loc2_]) && this.ENEMY[_loc2_].getMC().name === param1)
            {
               return this.ENEMY[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getCollisionBoundaryByInstanceName(param1:String) : BitmapCollisionBoundary
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.COLLISION_BOUNDARIES.length)
         {
            if(this.COLLISION_BOUNDARIES[_loc2_].Container.name === param1)
            {
               return this.COLLISION_BOUNDARIES[_loc2_];
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.COLLISION_BOUNDARIES.length)
         {
            if(this.COLLISION_BOUNDARIES[_loc2_].Container.name === param1)
            {
               return this.COLLISION_BOUNDARIES[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getCollisionBoundaryByMC(param1:MovieClip) : BitmapCollisionBoundary
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.COLLISION_BOUNDARIES.length)
         {
            if(this.COLLISION_BOUNDARIES[_loc2_].Container === param1 || this.COLLISION_BOUNDARIES[_loc2_].CollisionClip === param1)
            {
               return this.COLLISION_BOUNDARIES[_loc2_];
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.COLLISION_BOUNDARIES.length)
         {
            if(this.COLLISION_BOUNDARIES[_loc2_].Container === param1 || this.COLLISION_BOUNDARIES[_loc2_].CollisionClip === param1)
            {
               return this.PLATFORMS[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getPlatformByInstanceName(param1:String) : Platform
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.TERRAINS.length)
         {
            if(this.TERRAINS[_loc2_].Container.name === param1)
            {
               return this.TERRAINS[_loc2_];
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.PLATFORMS.length)
         {
            if(this.PLATFORMS[_loc2_].Container.name === param1)
            {
               return this.PLATFORMS[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getPlatformByMC(param1:MovieClip) : Platform
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.TERRAINS.length)
         {
            if(this.TERRAINS[_loc2_].Container === param1 || this.TERRAINS[_loc2_].CollisionClip === param1)
            {
               return this.TERRAINS[_loc2_];
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.PLATFORMS.length)
         {
            if(this.PLATFORMS[_loc2_].Container === param1 || this.PLATFORMS[_loc2_].CollisionClip === param1)
            {
               return this.PLATFORMS[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getEnemyByMC(param1:MovieClip) : Enemy
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.ENEMY.length)
         {
            if(Boolean(this.ENEMY[_loc2_]) && (this.ENEMY[_loc2_].MC == param1 || this.ENEMY[_loc2_].Stance != null && this.ENEMY[_loc2_].Stance == param1))
            {
               return this.ENEMY[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getControllerNum(param1:int) : Controller
      {
         if(param1 > this.CONTROLLERS.length || param1 - 1 < 0 || this.CONTROLLERS[param1 - 1] == null)
         {
            return null;
         }
         return this.CONTROLLERS[param1 - 1] as Controller;
      }
      
      public function getPlayerArray() : Array
      {
         var _loc1_:* = undefined;
         var _loc2_:Array = new Array();
         for(_loc1_ in this.PLAYERS)
         {
            if(this.PLAYERS[_loc1_] != null)
            {
               _loc2_.push(this.PLAYERS[_loc1_]);
            }
         }
         return _loc2_;
      }
      
      public function getEnemyArray() : Array
      {
         var _loc1_:* = undefined;
         var _loc2_:Array = new Array();
         for(_loc1_ in this.ENEMY)
         {
            if(this.ENEMY[_loc1_] != null)
            {
               _loc2_.push(this.ENEMY[_loc1_]);
            }
         }
         return _loc2_;
      }
      
      public function getWalls() : Vector.<BitmapCollisionBoundary>
      {
         return this.WALLS;
      }
      
      public function getWarningBounds_UL() : Vector.<BitmapCollisionBoundary>
      {
         return this.WARNINGBOUNDS_UL;
      }
      
      public function getWarningBounds_UR() : Vector.<BitmapCollisionBoundary>
      {
         return this.WARNINGBOUNDS_UR;
      }
      
      public function getWarningBounds_LL() : Vector.<BitmapCollisionBoundary>
      {
         return this.WARNINGBOUNDS_LL;
      }
      
      public function getWarningBounds_LR() : Vector.<BitmapCollisionBoundary>
      {
         return this.WARNINGBOUNDS_LR;
      }
      
      public function getLedges_L() : Vector.<MovieClip>
      {
         return this.LEDGES_L;
      }
      
      public function getLedges_R() : Vector.<MovieClip>
      {
         return this.LEDGES_R;
      }
      
      public function getLedgesAPI() : Array
      {
         var _loc4_:int = 0;
         var _loc1_:Array = [];
         var _loc2_:Vector.<MovieClip> = this.getLedges_L();
         var _loc3_:Vector.<MovieClip> = this.getLedges_R();
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc1_.push(_loc2_[_loc4_]);
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc1_.push(_loc3_[_loc4_]);
            _loc4_++;
         }
         return _loc1_;
      }
      
      public function getBeacons() : Vector.<Beacon>
      {
         return this.BEACONS;
      }
      
      public function getAdjMatrix() : Array
      {
         return this.ADJMATRIX;
      }
      
      public function getRandomPokemon() : Class
      {
         var _loc1_:Class = null;
         if(this.ITEMS.PokemonClass)
         {
            _loc1_ = this.ITEMS.PokemonClass;
            this.ITEMS.PokemonClass = null;
            return _loc1_;
         }
         return Utils.random() < 0.025 && this.m_pokemonRare.length > 0 ? this.m_pokemonRare[Utils.randomInteger(0,this.m_pokemonRare.length - 1)] : this.m_pokemon[Utils.randomInteger(0,this.m_pokemon.length - 1)];
      }
      
      public function getRandomAssist() : Class
      {
         var _loc1_:Class = null;
         if(this.ITEMS.AssistClass)
         {
            _loc1_ = this.ITEMS.AssistClass;
            this.ITEMS.AssistClass = null;
            return _loc1_;
         }
         return Utils.random() < 0.025 && this.m_assistsRare.length > 0 ? this.m_assistsRare[Utils.randomInteger(0,this.m_assistsRare.length - 1)] : this.m_assists[Utils.randomInteger(0,this.m_assists.length - 1)];
      }
      
      public function getItem(param1:int) : Item
      {
         return this.ITEMS.getItemByUID(param1);
      }
      
      public function getItemByMC(param1:MovieClip) : Item
      {
         return this.ITEMS.getItemByMC(param1);
      }
      
      public function getItemGens() : Vector.<MovieClip>
      {
         return this.ITEMGENS;
      }
      
      public function getTargetByUID(param1:int) : TargetTestTarget
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.TARGETS.length)
         {
            if(Boolean(this.TARGETS[_loc2_]) && this.TARGETS[_loc2_].UID == param1)
            {
               return this.TARGETS[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getTargetByMC(param1:MovieClip) : TargetTestTarget
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.TARGETS.length)
         {
            if(Boolean(this.TARGETS[_loc2_]) && (this.TARGETS[_loc2_].MC == param1 || this.TARGETS[_loc2_].Stance != null && this.TARGETS[_loc2_].Stance == param1))
            {
               return this.TARGETS[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function spawnAssistAPI(param1:Class, param2:InteractiveSprite = null) : Enemy
      {
         if(this.ITEMS.AssistClass)
         {
            param1 = this.ITEMS.AssistClass;
            this.ITEMS.AssistClass = null;
         }
         return this.spawnEnemyAPI(param1,0,0,-1,null,param2);
      }
      
      public function spawnPokemonAPI(param1:Class, param2:InteractiveSprite = null) : Enemy
      {
         if(this.ITEMS.PokemonClass)
         {
            param1 = this.ITEMS.PokemonClass;
            this.ITEMS.PokemonClass = null;
         }
         return this.spawnEnemyAPI(param1,0,0,-1,null,param2);
      }
      
      public function spawnAssist(param1:Class, param2:Number, param3:Number, param4:int = -1) : AssistTrophy
      {
         var _loc5_:Enemy = this.spawnEnemy(param1,param2,param3,param4);
         if(_loc5_ == null)
         {
            return null;
         }
         return _loc5_ as AssistTrophy;
      }
      
      public function spawnEnemy(param1:Class, param2:Number, param3:Number, param4:int = -1) : Enemy
      {
         var _loc5_:Enemy = new param1(this,param2,param3,param4);
         _loc5_.APIInstance.initialize();
         return _loc5_;
      }
      
      public function spawnEnemyAPI(param1:Class, param2:Number = 0, param3:Number = 0, param4:int = -1, param5:MovieClip = null, param6:InteractiveSprite = null) : Enemy
      {
         var _loc7_:EnemyStats = new EnemyStats();
         _loc7_.importData({"classAPI":param1});
         var _loc8_:Enemy = new Enemy(_loc7_,this,param2,param3,param4,param5,param6);
         _loc8_.APIInstance.initialize();
         return _loc8_;
      }
      
      public function spawnCharacterAPI(param1:Class) : Character
      {
         var _loc7_:Object = null;
         var _loc2_:CharacterData = new CharacterData();
         _loc2_.importData({"classAPI":param1});
         var _loc3_:PlayerSetting = new PlayerSetting();
         this.deactivateCharacters();
         var _loc4_:Character = new Character(_loc2_,_loc3_,this);
         _loc4_.setState(CState.ENTRANCE);
         this.activateCharacters();
         _loc4_.setState(CState.IDLE);
         _loc4_.APIInstance.initialize();
         var _loc5_:int = this.getHighestTimestopPriority();
         var _loc6_:int = int.MAX_VALUE;
         for each(_loc7_ in this.m_timestopStateTimer)
         {
            if(Boolean(_loc7_) && _loc7_.priority <= _loc5_)
            {
               if(_loc7_.characterLength <= -1)
               {
                  _loc6_ = int(_loc7_.characterLength);
                  break;
               }
               if(_loc7_.characterLength >= 0)
               {
                  _loc6_ = Math.min(_loc6_,_loc7_.characterLength);
               }
            }
         }
         if(_loc6_ != int.MAX_VALUE)
         {
            _loc4_.applyTimeFreeze(_loc6_);
         }
         return _loc4_;
      }
      
      public function spawnItemAPI(param1:Class) : Item
      {
         var _loc2_:ItemData = new ItemData();
         _loc2_.importData({"classAPI":param1});
         return this.ITEMS.generateItemObj(_loc2_,1337,1337,true);
      }
      
      public function spawnProjectileAPI(param1:Class, param2:InteractiveSprite = null) : Projectile
      {
         var _loc3_:ProjectileAttack = new ProjectileAttack();
         _loc3_.importData({"classAPI":param1});
         var _loc4_:Object = {
            "owner":param2,
            "player_id":(param2 ? param2.ID : -1),
            "x_start":(param2 ? param2.X : 0),
            "y_start":(param2 ? param2.Y : 0),
            "sizeRatio":(param2 ? param2.SizeRatio : 1),
            "facingForward":(param2 ? param2.FacingForward : true),
            "chargetime":(param2 ? param2.AttackStateData.ChargeTime : 0),
            "chargetime_max":(param2 ? param2.AttackStateData.ChargeTimeMax : 0),
            "frame":"todo",
            "staleMultiplier":(Boolean(param2) && param2 is Character ? Character(param2).totalMoveDecay("todo") : 1),
            "sizeStatus":(Boolean(param2) && param2 is Character ? Character(param2).SizeStatus : 0),
            "terrains":this.TERRAINS,
            "platforms":this.PLATFORMS,
            "team_id":(param2 ? param2.Team : -1),
            "volume_sfx":(Boolean(param2) && param2 is Character ? Character(param2).getCharacterStat("volume_sfx") : 1),
            "volume_vfx":(Boolean(param2) && param2 is Character ? Character(param2).getCharacterStat("volume_vfx") : 1)
         };
         var _loc5_:Projectile = new Projectile(_loc4_,_loc3_,this);
         _loc5_.X += _loc4_.facingForward ? _loc5_.getProjectileStat("xoffset") * _loc4_.sizeRatio : -_loc5_.getProjectileStat("xoffset") * _loc4_.sizeRatio;
         _loc5_.Y += _loc5_.getProjectileStat("yoffset") * _loc4_.sizeRatio;
         return _loc5_;
      }
      
      public function spawnCollisionBoundaryAPI(param1:Class) : BitmapCollisionBoundary
      {
         var _loc2_:BitmapCollisionBoundary = new BitmapCollisionBoundary(null,this,"ground",false,{"classAPI":param1});
         this.COLLISION_BOUNDARIES.unshift(_loc2_);
         return _loc2_;
      }
      
      public function spawnPlatformAPI(param1:Class, param2:Boolean = true) : Platform
      {
         var _loc3_:MovingPlatform = new MovingPlatform(null,this,"ground",{"classAPI":param1});
         this.MOVINGPLATFORMS.unshift(_loc3_);
         if(param2)
         {
            this.TERRAINS.unshift(_loc3_);
         }
         else
         {
            this.PLATFORMS.unshift(_loc3_);
         }
         _loc3_.APIInstance.initialize();
         return _loc3_;
      }
      
      public function addPlayer(param1:int, param2:Character) : Character
      {
         if(this.PLAYERS[param1 - 1])
         {
            throw new Error("Attempted to overwrite player slot!");
         }
         this.PLAYERS[param1 - 1] = param2;
         return param2;
      }
      
      public function addCharacter(param1:Character) : Character
      {
         this.CHARACTERS.unshift(param1);
         return param1;
      }
      
      public function addEnemy(param1:Enemy) : Enemy
      {
         this.ENEMY.unshift(param1);
         return param1;
      }
      
      public function addProjectile(param1:Projectile) : Projectile
      {
         this.PROJECTILES.unshift(param1);
         return param1;
      }
      
      public function getProjectile(param1:int) : Projectile
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.PROJECTILES.length)
         {
            if(this.PROJECTILES[_loc2_].UID == param1)
            {
               return this.PROJECTILES[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getProjectiles() : Vector.<Projectile>
      {
         return this.PROJECTILES;
      }
      
      public function generateItemAPI(param1:String, param2:Number, param3:Number, param4:Boolean = false) : *
      {
         var _loc5_:Item = null;
         if(param1 === "random")
         {
            _loc5_ = this.ITEMS.makeItem(param2,param3,!param4,false);
         }
         else
         {
            _loc5_ = this.ITEMS.generateItemObj(this.ITEMS.getItemByLinkage(param1,!param4),param2,param3,false,false);
         }
         return _loc5_ ? _loc5_.APIInstance.instance : null;
      }
      
      public function getProjectileByMC(param1:MovieClip) : Projectile
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.PROJECTILES.length)
         {
            if(Boolean(this.PROJECTILES[_loc2_]) && (this.PROJECTILES[_loc2_].MC == param1 || this.PROJECTILES[_loc2_].Stance != null && this.PROJECTILES[_loc2_].Stance == param1))
            {
               return this.PROJECTILES[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function removeEnemy(param1:Enemy) : void
      {
         this.m_apiDisposeList.push(param1);
         var _loc2_:int = int(this.ENEMY.indexOf(param1));
         if(_loc2_ >= 0)
         {
            this.ENEMY.splice(_loc2_,1);
         }
      }
      
      public function removeProjectile(param1:Projectile) : void
      {
         this.m_apiDisposeList.push(param1);
         var _loc2_:int = int(this.PROJECTILES.indexOf(param1));
         if(_loc2_ >= 0)
         {
            this.PROJECTILES.splice(_loc2_,1);
         }
      }
      
      public function removeCharacter(param1:Character) : void
      {
         if(this.m_timestopStateTimer[param1.UID])
         {
            this.removeAndUpdateTimeFreeze(param1.UID);
         }
         this.m_apiDisposeList.push(param1);
         var _loc2_:int = int(this.CHARACTERS.indexOf(param1));
         if(_loc2_ >= 0)
         {
            this.CHARACTERS.splice(_loc2_,1);
         }
         _loc2_ = int(this.PLAYERS.indexOf(param1));
         if(_loc2_ >= 0)
         {
            this.PLAYERS[_loc2_] = null;
         }
      }
      
      public function removeTarget(param1:TargetTestTarget) : void
      {
         this.m_apiDisposeList.push(param1);
         var _loc2_:int = int(this.TARGETS.indexOf(param1));
         if(_loc2_ >= 0)
         {
            this.TARGETS.splice(_loc2_,1);
         }
      }
      
      public function removeCollisionBoundary(param1:BitmapCollisionBoundary) : void
      {
         this.m_apiDisposeList.push(param1);
         var _loc2_:int = int(this.COLLISION_BOUNDARIES.indexOf(param1));
         if(_loc2_ >= 0)
         {
            this.COLLISION_BOUNDARIES.splice(_loc2_,1);
         }
      }
      
      public function removePlatform(param1:Platform) : void
      {
         this.m_apiDisposeList.push(param1);
         var _loc2_:int = int(this.MOVINGPLATFORMS.indexOf(param1 as MovingPlatform));
         if(_loc2_ >= 0)
         {
            this.MOVINGPLATFORMS.splice(_loc2_,1);
         }
         _loc2_ = int(this.TERRAINS.indexOf(param1));
         if(_loc2_ >= 0)
         {
            this.TERRAINS.splice(_loc2_,1);
         }
         else
         {
            _loc2_ = int(this.PLATFORMS.indexOf(param1));
            if(_loc2_ >= 0)
            {
               this.PLATFORMS.splice(_loc2_,1);
            }
         }
      }
      
      public function getQualitySettings() : Object
      {
         return this.m_qualitySettings;
      }
      
      public function getTeams() : Array
      {
         var _loc2_:int = 0;
         var _loc1_:Array = new Array();
         while(_loc2_ < this.PLAYERS.length)
         {
            if(this.PLAYERS[_loc2_] != null && _loc1_.indexOf(this.PLAYERS[_loc2_].Team) < 0)
            {
               _loc1_.push(this.PLAYERS[_loc2_].Team);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function setTeamRanks(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < this.PLAYERS.length)
         {
            if(this.PLAYERS[_loc3_] != null && this.PLAYERS[_loc3_].Team == param1)
            {
               this.PLAYERS[_loc3_].getMatchResults().Rank = param2;
            }
            _loc3_++;
         }
      }
      
      public function updateRanks(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         if(ModeFeatures.hasFeature(ModeFeatures.IS_CUSTOM,this.GAME.GameMode))
         {
            return;
         }
         if(!param1 && Boolean(this.m_gameEnded))
         {
            return;
         }
         var _loc3_:int = 1;
         var _loc4_:Vector.<MatchResults> = new Vector.<MatchResults>();
         var _loc5_:Array = this.getTeams();
         if(_loc5_.length > 1)
         {
            if(this.GAME.UsingLives)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc5_.length)
               {
                  _loc4_.push(new MatchResults(_loc5_[_loc2_]));
                  _loc2_++;
               }
               _loc2_ = 0;
               while(_loc2_ < this.PLAYERS.length)
               {
                  if(this.PLAYERS[_loc2_] != null)
                  {
                     _loc4_[_loc5_.indexOf(this.PLAYERS[_loc2_].Team)].StockRemaining = _loc4_[_loc5_.indexOf(this.PLAYERS[_loc2_].Team)].StockRemaining + this.PLAYERS[_loc2_].getMatchResults().StockRemaining;
                     _loc4_[_loc5_.indexOf(this.PLAYERS[_loc2_].Team)].SurvivalTime = _loc4_[_loc5_.indexOf(this.PLAYERS[_loc2_].Team)].SurvivalTime + this.PLAYERS[_loc2_].getMatchResults().SurvivalTime;
                  }
                  _loc2_++;
               }
               _loc4_.sort(this.compareMatchResultsForStock);
               _loc2_ = 0;
               while(_loc2_ < _loc4_.length)
               {
                  this.setTeamRanks(_loc4_[_loc2_].Owner,_loc3_);
                  while(true)
                  {
                     if(_loc2_ >= _loc4_.length)
                     {
                        break;
                     }
                     if(_loc2_ + 1 >= _loc4_.length)
                     {
                        break;
                     }
                     if(_loc4_[_loc2_ + 1].StockRemaining != _loc4_[_loc2_].StockRemaining)
                     {
                        break;
                     }
                     if(_loc4_[_loc2_].StockRemaining <= 0)
                     {
                        if(!(Boolean(this.GAME.UsingTime) && _loc4_[_loc2_ + 1].SurvivalTime == _loc4_[_loc2_].SurvivalTime))
                        {
                           break;
                        }
                        this.setTeamRanks(_loc4_[++_loc2_].Owner,_loc3_);
                     }
                     else
                     {
                        if(_loc4_[_loc2_ + 1].DamageRemaining != _loc4_[_loc2_].DamageRemaining)
                        {
                           break;
                        }
                        this.setTeamRanks(_loc4_[++_loc2_].Owner,_loc3_);
                     }
                     _loc2_++;
                  }
                  _loc2_++;
                  _loc3_++;
               }
            }
            else
            {
               _loc2_ = 0;
               while(_loc2_ < _loc5_.length)
               {
                  _loc4_.push(new MatchResults(_loc5_[_loc2_]));
                  _loc2_++;
               }
               _loc2_ = 0;
               while(_loc2_ < this.PLAYERS.length)
               {
                  if(this.PLAYERS[_loc2_] != null)
                  {
                     _loc4_[_loc5_.indexOf(this.PLAYERS[_loc2_].Team)].Score = _loc4_[_loc5_.indexOf(this.PLAYERS[_loc2_].Team)].Score + this.PLAYERS[_loc2_].getMatchResults().Score;
                  }
                  _loc2_++;
               }
               _loc4_.sort(this.compareMatchResultsForTime);
               _loc2_ = 0;
               while(_loc2_ < _loc4_.length)
               {
                  this.setTeamRanks(_loc4_[_loc2_].Owner,_loc3_);
                  while(_loc2_ < _loc4_.length)
                  {
                     if(!(_loc2_ + 1 < _loc4_.length && _loc4_[_loc2_ + 1].Score == _loc4_[_loc2_].Score))
                     {
                        break;
                     }
                     this.setTeamRanks(_loc4_[++_loc2_].Owner,_loc3_);
                  }
                  _loc2_++;
                  _loc3_++;
               }
            }
         }
         else if(this.GAME.UsingLives)
         {
            _loc2_ = 0;
            while(_loc2_ < this.PLAYERS.length)
            {
               if(this.PLAYERS[_loc2_] != null)
               {
                  _loc4_.push(this.PLAYERS[_loc2_].getMatchResults());
               }
               _loc2_++;
            }
            _loc4_.sort(this.compareMatchResultsForStock);
            _loc2_ = 0;
            while(_loc2_ < _loc4_.length)
            {
               this.getPlayerByID(_loc4_[_loc2_].Owner).getMatchResults().Rank = _loc3_;
               while(true)
               {
                  if(_loc2_ >= _loc4_.length)
                  {
                     break;
                  }
                  if(_loc2_ + 1 >= _loc4_.length)
                  {
                     break;
                  }
                  if(_loc4_[_loc2_ + 1].StockRemaining != _loc4_[_loc2_].StockRemaining)
                  {
                     break;
                  }
                  if(_loc4_[_loc2_].StockRemaining == 0)
                  {
                     if(!(Boolean(this.GAME.UsingTime) && _loc4_[_loc2_ + 1].SurvivalTime == _loc4_[_loc2_].SurvivalTime))
                     {
                        break;
                     }
                     this.getPlayerByID(_loc4_[_loc2_ + 1].Owner).getMatchResults().Rank = _loc3_;
                  }
                  else
                  {
                     if(_loc4_[_loc2_ + 1].DamageRemaining != _loc4_[_loc2_].DamageRemaining)
                     {
                        break;
                     }
                     this.getPlayerByID(_loc4_[_loc2_ + 1].Owner).getMatchResults().Rank = _loc3_;
                  }
                  _loc2_++;
               }
               _loc2_++;
               _loc3_++;
            }
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < this.PLAYERS.length)
            {
               if(this.PLAYERS[_loc2_] != null)
               {
                  _loc4_.push(this.PLAYERS[_loc2_].getMatchResults());
               }
               _loc2_++;
            }
            _loc4_.sort(this.compareMatchResultsForTime);
            _loc2_ = 0;
            while(_loc2_ < _loc4_.length)
            {
               this.getPlayerByID(_loc4_[_loc2_].Owner).getMatchResults().Rank = _loc3_;
               while(_loc2_ < _loc4_.length)
               {
                  if(!(_loc2_ + 1 < _loc4_.length && _loc4_[_loc2_ + 1].Score == _loc4_[_loc2_].Score))
                  {
                     break;
                  }
                  this.getPlayerByID(_loc4_[++_loc2_].Owner).getMatchResults().Rank = _loc3_;
               }
               _loc2_++;
               _loc3_++;
            }
         }
      }
      
      public function getFirstWinner() : Character
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.PLAYERS.length)
         {
            if(this.PLAYERS[_loc1_] != null && this.PLAYERS[_loc1_].getMatchResults().Rank == 1)
            {
               return this.PLAYERS[_loc1_];
            }
            _loc1_++;
         }
         return null;
      }
      
      public function getWinners() : Array
      {
         var _loc2_:int = 0;
         this.updateRanks();
         var _loc1_:Array = [];
         while(Boolean(this.PLAYERS) && _loc2_ < this.PLAYERS.length)
         {
            if(this.PLAYERS[_loc2_] != null && this.PLAYERS[_loc2_].getMatchResults().Rank == 1)
            {
               _loc1_.push(this.PLAYERS[_loc2_]);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getLosers() : Array
      {
         var _loc2_:int = 0;
         this.updateRanks();
         var _loc1_:Array = [];
         while(Boolean(this.PLAYERS) && _loc2_ < this.PLAYERS.length)
         {
            if(this.PLAYERS[_loc2_] != null && this.PLAYERS[_loc2_].getMatchResults().Rank !== 1)
            {
               _loc1_.push(this.PLAYERS[_loc2_]);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function compareMatchResultsForTime(param1:MatchResults, param2:MatchResults) : Number
      {
         return param2.Score - param1.Score;
      }
      
      private function compareMatchResultsForStock(param1:MatchResults, param2:MatchResults) : Number
      {
         if(param1.StockRemaining == param2.StockRemaining)
         {
            if(param1.StockRemaining <= 0)
            {
               return param2.SurvivalTime - param1.SurvivalTime;
            }
            if(param1.DamageRemaining == param2.DamageRemaining)
            {
               return 0;
            }
            return this.GAME.UsingStamina ? param2.DamageRemaining - param1.DamageRemaining : param1.DamageRemaining - param2.DamageRemaining;
         }
         return param2.StockRemaining - param1.StockRemaining;
      }
      
      public function getFPS() : Number
      {
         return Math.round(this.m_elapsedFrames / (getTimer() - (this.m_startTime + this.m_totalPausedTime)) * 10000) / 10;
      }
      
      public function restartMusic() : void
      {
         this.SOUNDQUEUE.playMusic(this.m_music,this.m_loopLoc);
      }
      
      public function dispose() : void
      {
         this.flushDisposeBuffer();
         this.disposeObjects(this.WARNINGBOUNDS_LL);
         this.disposeObjects(this.WARNINGBOUNDS_LR);
         this.disposeObjects(this.WARNINGBOUNDS_UL);
         this.disposeObjects(this.WARNINGBOUNDS_UR);
         this.disposeObjects(this.WALLS);
         this.disposeObjects(this.TARGETS);
         this.disposeObjects(this.MOVINGPLATFORMS);
         this.disposeObjects(this.COLLISION_BOUNDARIES);
         this.disposeObjects(this.CHARACTERS);
         this.disposeObjects(this.ENEMY);
         this.disposeObjects(this.PROJECTILES);
         this.disposeObjects(this.ITEMS.ItemsInUse);
         this.m_eventManager.removeAllEvents();
         this.flushTimers();
      }
      
      public function get APIInstance() : SSF2Stage
      {
         return this.m_apiInstance;
      }
      
      public function get StarKOEnabled() : Boolean
      {
         return this.m_starKOEnabled;
      }
      
      public function set StarKOEnabled(param1:Boolean) : void
      {
         this.m_starKOEnabled = param1;
      }
      
      public function get ScreenKOEnabled() : Boolean
      {
         return this.m_screenKOEnabled;
      }
      
      public function set ScreenKOEnabled(param1:Boolean) : void
      {
         this.m_screenKOEnabled = param1;
      }
      
      public function get HitBoxProcessorInstance() : HitBoxProcessor
      {
         return this.m_hitBoxProcessor;
      }
      
      public function get FPSTimer() : Debug_fps
      {
         return this.m_fpsTimer;
      }
      
      public function createFPSTimer() : void
      {
         if(this.m_fpsTimer == null)
         {
            this.m_fpsTimer = new Debug_fps(this.STAGE.stage,new Point());
         }
      }
      
      public function setFPSTimerVisible(param1:Boolean) : void
      {
         if(this.m_fpsTimer != null)
         {
            this.m_fpsTimer.setVisible(param1);
         }
      }
      
      public function get EndGameOptions() : Object
      {
         return this.m_endGameOptions;
      }
      
      public function get ElapsedFrames() : int
      {
         return this.m_elapsedFrames;
      }
      
      public function get ElapsedPlayableFrames() : int
      {
         return this.m_elapsedPlayableFrames;
      }
      
      public function get ActiveScripts() : Boolean
      {
         return this.m_activeScripts;
      }
      
      public function get CrowdChantID() : int
      {
         return this.m_crowdChantID;
      }
      
      public function get ReplayDataObj() : ReplayData
      {
         return this.m_replayData;
      }
      
      public function get HazardsOn() : Boolean
      {
         return this.m_hazardsOn;
      }
      
      public function get AirDodge() : String
      {
         return this.m_airDodge;
      }
      
      public function set AirDodge(param1:String) : void
      {
         this.m_airDodge = param1;
      }
      
      public function get GravityMultiplier() : Number
      {
         return this.m_gravityMultiplier;
      }
      
      public function get DisableCeilingDeath() : Boolean
      {
         return this.m_disableCeilingDeath;
      }
      
      public function set DisableCeilingDeath(param1:Boolean) : void
      {
         this.m_disableCeilingDeath = param1;
      }
      
      public function get DisableFallDeath() : Boolean
      {
         return this.m_disableFallDeath;
      }
      
      public function set DisableFallDeath(param1:Boolean) : void
      {
         this.m_disableFallDeath = param1;
      }
      
      public function get MatchMilliseconds() : Number
      {
         return this.m_endTime - this.m_startTime;
      }
      
      public function get Terrains() : Vector.<Platform>
      {
         return this.TERRAINS;
      }
      
      public function get Platforms() : Vector.<Platform>
      {
         return this.PLATFORMS;
      }
      
      public function get MovingPlatforms() : Vector.<MovingPlatform>
      {
         return this.MOVINGPLATFORMS;
      }
      
      public function get LogText() : String
      {
         return this.m_logText;
      }
      
      public function set LogText(param1:String) : void
      {
         this.m_logText = param1;
      }
      
      public function get Ready() : Boolean
      {
         return this.READY;
      }
      
      public function get OnlineMode() : Boolean
      {
         return this.ONLINEMODE;
      }
      
      public function set OnlineMode(param1:Boolean) : void
      {
         this.ONLINEMODE = param1;
      }
      
      public function get ReplayMode() : Boolean
      {
         return this.REPLAYMODE;
      }
      
      public function set ReplayMode(param1:Boolean) : void
      {
         this.REPLAYMODE = param1;
      }
      
      public function get NoContest() : Boolean
      {
         return this.m_noContest;
      }
      
      public function set NoContest(param1:Boolean) : void
      {
         this.m_noContest = param1;
      }
      
      public function get NoHumans() : Boolean
      {
         var _loc2_:int = 0;
         var _loc1_:Boolean = true;
         while(_loc2_ < this.PLAYERS.length)
         {
            if(this.PLAYERS[_loc2_] != null && Boolean(this.PLAYERS[_loc2_].IsHuman))
            {
               _loc1_ = false;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function get StageEvent() : Boolean
      {
         return this.m_event;
      }
      
      public function get EventManagerObj() : EventManager
      {
         return this.m_eventManager;
      }
      
      public function get RootRef() : MovieClip
      {
         return this.ROOT;
      }
      
      public function get LightSource() : MovieClip
      {
         return this.LIGHTSOURCE;
      }
      
      public function get StageRef() : MovieClip
      {
         return this.STAGE;
      }
      
      public function get StageParentRef() : MovieClip
      {
         return this.STAGEPARENT;
      }
      
      public function get StageEffectsRef() : MovieClip
      {
         return this.STAGEEFFECTS;
      }
      
      public function get HudRef() : HudMenu
      {
         return this.HUD;
      }
      
      public function get HudForegroundRef() : MovieClip
      {
         return this.HUDFOREGROUND;
      }
      
      public function get HudOverlayRef() : MovieClip
      {
         return this.HUDOVERLAY;
      }
      
      public function get CamRef() : Vcam
      {
         return this.CAM;
      }
      
      public function get CamBounds() : MovieClip
      {
         return this.CAMBOUNDS;
      }
      
      public function get SmashBallBounds() : MovieClip
      {
         return this.SMASHBALLBOUNDS;
      }
      
      public function get DeathBounds() : MovieClip
      {
         return this.DEATHBOUNDS;
      }
      
      public function get ItemsRef() : ItemGenerator
      {
         return this.ITEMS;
      }
      
      public function get GameRef() : Game
      {
         return this.GAME;
      }
      
      public function get SoundQueueRef() : SoundQueue
      {
         return this.SOUNDQUEUE;
      }
      
      public function get TimerRef() : GameTimer
      {
         return this.TIMER;
      }
      
      public function get FSCutscene() : MovieClip
      {
         return this.m_fsCutscene;
      }
      
      public function set FSCutscene(param1:MovieClip) : void
      {
         this.m_fsCutscene = param1;
         if(this.GAME.HudDisplay)
         {
            this.HUD.toggleMainDisplay(param1 ? false : true);
         }
      }
      
      public function get FSCutins() : int
      {
         return this.m_fsCutins;
      }
      
      public function set FSCutins(param1:int) : void
      {
         this.m_fsCutins = param1;
         if(this.m_fsCutins < 0)
         {
            this.m_fsCutins = 0;
         }
      }
      
      public function get PauseCamHeight() : Number
      {
         return this.m_pauseCamHeight;
      }
      
      public function get JustPaused() : Boolean
      {
         return this.m_justPaused;
      }
      
      public function get Paused() : Boolean
      {
         return this.m_paused;
      }
      
      public function set Paused(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<MovieClip> = null;
         var _loc4_:int = 0;
         var _loc5_:Vector.<MovieClip> = null;
         var _loc6_:int = 0;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:int = 0;
         this.m_justPaused = true;
         if(this.GAME.GameMode == Mode.TRAINING)
         {
            this.m_freezeKeys = !this.m_freezeKeys;
            if(this.m_freezeKeys)
            {
               this.HUD.showTrainingDisplay();
               _loc3_ = new Vector.<MovieClip>();
               _loc4_ = 0;
               while(_loc4_ < this.PLAYERS.length)
               {
                  if(this.PLAYERS[_loc4_] != null && !this.PLAYERS[_loc4_].StandBy)
                  {
                     _loc3_.push(this.PLAYERS[_loc4_].MC);
                  }
                  _loc4_++;
               }
               if(this.ItemsRef.CurrentSmashBall != null)
               {
                  _loc3_.push(this.ItemsRef.CurrentSmashBall.ItemInstance);
               }
               this.CAM.deleteTargets(_loc3_);
               _loc3_ = _loc3_.slice(0,1);
               this.CAM.addTargets(_loc3_);
               SoundQueue.instance.playSoundEffect("menu_pause");
            }
            else
            {
               SoundQueue.instance.playSoundEffect("menu_back");
               this.HUD.hideTrainingDisplay();
               _loc2_ = 1;
               while(_loc2_ < this.PLAYERS.length)
               {
                  if(this.PLAYERS[_loc2_] != null)
                  {
                     this.PLAYERS[_loc2_].setDamage(this.HUD.CpuDamage);
                  }
                  _loc2_++;
               }
               _loc5_ = new Vector.<MovieClip>();
               _loc6_ = 0;
               while(_loc6_ < this.PLAYERS.length)
               {
                  if(this.PLAYERS[_loc6_] != null && !this.PLAYERS[_loc6_].StandBy)
                  {
                     _loc5_.push(this.PLAYERS[_loc6_].MC);
                  }
                  _loc6_++;
               }
               _loc5_.splice(0,1);
               if(this.ItemsRef.CurrentSmashBall != null && this.CAM.Mode != Vcam.ZOOM_MODE)
               {
                  _loc5_.push(this.ItemsRef.CurrentSmashBall.ItemInstance);
               }
               if(_loc5_.length > 0 && this.CAM.Mode != Vcam.ZOOM_MODE)
               {
                  this.CAM.addTargets(_loc5_);
               }
            }
         }
         else
         {
            this.m_paused = param1;
            if(!this.m_paused)
            {
               if(!this.SOUNDQUEUE.MusicIsMuted)
               {
                  this.SOUNDQUEUE.setMusicVolume(SaveData.BGVolumeLevel);
               }
               this.HUDFOREGROUND.visible = true;
               this.HUDTEXT.visible = true;
               this.HUD.togglePauseIcons(false);
               if(!this.m_fsCutscene && Boolean(this.GAME.HudDisplay))
               {
                  this.HUD.toggleMainDisplay(true);
               }
               for(_loc7_ in this.ENEMY)
               {
                  if(this.ENEMY[_loc7_] != null && !this.ENEMY[_loc7_].Dead)
                  {
                     this.ENEMY[_loc7_].unpause();
                  }
               }
               if(this.GAME.UsingTime)
               {
                  this.TIMER.TimeMC.visible = true;
               }
               this.SOUNDQUEUE.unpauseAllSounds();
               SoundQueue.instance.playSoundEffect("menu_back");
               this.m_totalPausedTime += getTimer() - this.m_pausedTimestamp;
               this.m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.GAME_UNPAUSED,{}));
            }
            else
            {
               if(!this.SOUNDQUEUE.MusicIsMuted)
               {
                  this.SOUNDQUEUE.setMusicVolume(SaveData.BGVolumeLevel / 2);
               }
               this.HUDFOREGROUND.visible = false;
               this.HUDTEXT.visible = false;
               this.HUD.togglePauseIcons(true);
               if(this.GAME.HudDisplay)
               {
                  this.HUD.toggleMainDisplay(false);
               }
               for(_loc8_ in this.CHARACTERS)
               {
                  if(this.CHARACTERS[_loc8_] != null)
                  {
                     Utils.recursiveMovieClipPlay(this.CHARACTERS[_loc8_].MC.stance,false);
                  }
               }
               for(_loc9_ in this.ENEMY)
               {
                  if(this.ENEMY[_loc9_] != null && !this.ENEMY[_loc9_].Dead)
                  {
                     this.ENEMY[_loc9_].pause();
                  }
               }
               this.TIMER.TimeMC.visible = false;
               this.SOUNDQUEUE.pauseAllSounds();
               _loc10_ = 1;
               while(_loc10_ <= 4)
               {
                  Gamepad.rumbleForPlayer(_loc10_,0,0,0);
                  _loc10_++;
               }
               SoundQueue.instance.playSoundEffect("menu_pause");
               this.m_pausedTimestamp = getTimer();
               this.m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.GAME_PAUSED,{}));
            }
         }
      }
      
      public function get PausedID() : int
      {
         return this.m_paused_id;
      }
      
      public function set PausedID(param1:int) : void
      {
         this.m_paused_id = param1;
         if(Boolean(this.m_paused) && this.GAME.GameMode != Mode.TRAINING)
         {
            this.HUD.updatePauseKeyboardDisplay(this.getControllerNum(this.m_paused_id));
            this.CAM.CamMC.width = this.CAM.OriginalWidth / 3;
            this.CAM.CamMC.height = this.CAM.OriginalHeight / 3;
            if(this.getPlayerByID(this.m_paused_id) != null && this.getPlayerByID(this.m_paused_id).Dead)
            {
               this.CAM.CamMC.height = this.CAM.MainTerrain.height;
               this.CAM.CamMC.width = this.CAM.MainTerrain.height * (Main.Width / Main.Height);
               this.CAM.forceInBounds();
            }
            else if(this.getPlayerByID(this.m_paused_id) != null)
            {
               this.CAM.CamMC.x = this.getPlayerByID(this.m_paused_id).OverlayX;
               this.CAM.CamMC.y = this.getPlayerByID(this.m_paused_id).OverlayY;
               this.CAM.syncPositions();
               this.CAM.camControl();
            }
            this.CAM.forceInBounds();
            this.CAM.camControl();
            this.m_pauseCamHeight = this.CAM.Height;
         }
      }
      
      public function set StageEvent(param1:Boolean) : void
      {
         if(Boolean(this.ONLINEMODE) && !param1)
         {
            this.STAGE.stage.frameRate = 30;
         }
         this.m_event = param1;
      }
      
      public function set RootRef(param1:MovieClip) : void
      {
         this.ROOT = param1;
      }
      
      public function set StageRef(param1:MovieClip) : void
      {
         this.STAGE = param1;
      }
      
      public function set StageParentRef(param1:MovieClip) : void
      {
         this.STAGEPARENT = param1;
      }
      
      public function set CamRef(param1:Vcam) : void
      {
         this.CAM = param1;
      }
      
      public function set ItemsRef(param1:ItemGenerator) : void
      {
         this.ITEMS = param1;
      }
      
      public function set GameRef(param1:Game) : void
      {
         this.GAME = param1;
      }
      
      public function set SoundQueueRef(param1:SoundQueue) : void
      {
         this.SOUNDQUEUE = param1;
      }
      
      public function set TimerRef(param1:GameTimer) : void
      {
         this.TIMER = param1;
      }
      
      public function get Targets() : Vector.<TargetTestTarget>
      {
         return this.TARGETS;
      }
      
      public function get FreezeKeys() : Boolean
      {
         return this.m_freezeKeys;
      }
      
      public function set FreezeKeys(param1:Boolean) : void
      {
         this.m_freezeKeys = param1;
      }
      
      public function get PokemonCount() : int
      {
         return this.m_pokemonCount;
      }
      
      public function set PokemonCount(param1:int) : void
      {
         this.m_pokemonCount = param1;
      }
      
      public function get Pokemons() : Vector.<Class>
      {
         return this.m_pokemon;
      }
      
      public function get PokemonsRare() : Vector.<Class>
      {
         return this.m_pokemonRare;
      }
      
      public function get AssistCount() : int
      {
         return this.m_assistCount;
      }
      
      public function set AssistCount(param1:int) : void
      {
         this.m_assistCount = param1;
      }
      
      public function get Assists() : Vector.<Class>
      {
         return this.m_assists;
      }
      
      public function get AssistsRare() : Vector.<Class>
      {
         return this.m_assistsRare;
      }
      
      public function get CuccoCount() : int
      {
         return this.m_cuccoCount;
      }
      
      public function set CuccoCount(param1:int) : void
      {
         this.m_cuccoCount = param1;
      }
      
      public function get EndTrigger() : Boolean
      {
         return this.m_endTrigger;
      }
      
      public function get GameEndedExit() : Boolean
      {
         return this.m_gameEndedExit;
      }
      
      public function set GameEndedExit(param1:Boolean) : void
      {
         this.m_gameEndedExit = param1;
      }
      
      public function get GameEnded() : Boolean
      {
         return this.m_gameEnded;
      }
      
      public function get WasReset() : Boolean
      {
         return this.m_wasReset;
      }
      
      public function set GameEnded(param1:Boolean) : void
      {
         this.m_gameEnded = param1;
      }
      
      public function get SizeRatio() : Number
      {
         return this.GAME.SizeRatio;
      }
      
      public function get Projectiles() : Vector.<Projectile>
      {
         return this.PROJECTILES;
      }
      
      public function get Enemies() : Vector.<Enemy>
      {
         return this.ENEMY;
      }
      
      public function get Players() : Vector.<Character>
      {
         return this.PLAYERS;
      }
      
      public function get Characters() : Vector.<Character>
      {
         return this.CHARACTERS;
      }
      
      public function get StageBG() : MovieClip
      {
         return this.STAGEBACKGROUND;
      }
      
      public function get StageFG() : MovieClip
      {
         return this.STAGEFOREGROUND;
      }
      
      public function get WeatherRef() : MovieClip
      {
         return this.WEATHER;
      }
      
      public function get WeatherMaskRef() : MovieClip
      {
         return this.WEATHERMASK;
      }
      
      public function get CutsceneRef() : MovieClip
      {
         return this.CUTSCENE;
      }
      
      public function get TagsRef() : MovieClip
      {
         return this.TAGS;
      }
      
      public function get ShadowsRef() : MovieClip
      {
         return this.SHADOWS;
      }
      
      public function get ShadowMaskRef() : MovieClip
      {
         return this.SHADOWMASK;
      }
      
      public function get ReflectionsRef() : MovieClip
      {
         return this.REFLECTIONS;
      }
      
      public function get ReflectionsMaskRef() : MovieClip
      {
         return this.REFLECTIONSMASK;
      }
      
      public function get TeamDamage() : Boolean
      {
         return this.GAME.LevelData.teamDamage;
      }
      
      public function get CanSuddenDeath() : Boolean
      {
         return this.m_canSuddenDeath;
      }
      
      public function set CanSuddenDeath(param1:Boolean) : void
      {
         this.m_canSuddenDeath = param1;
      }
      
      public function get SuddenDeath() : Boolean
      {
         return this.m_suddenDeath;
      }
      
      public function get SuddenDeathIDs() : Array
      {
         return this.m_suddenDeathIDs;
      }
      
      public function getTimestamp() : Date
      {
         return this.m_replayData.Timestamp;
      }
      
      public function get StartPositionMCs() : Vector.<MovieClip>
      {
         return this.START_POSITIONS;
      }
      
      public function get SpawnPositionMCs() : Vector.<MovieClip>
      {
         return this.SPAWN_POSITIONS;
      }
      
      public function fixBG() : void
      {
         this.CAM.fixBG();
      }
      
      public function playNarratorSpeech(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1 != null && param1.length > 0 && !(Boolean(this.GAME.UsingTime) && this.TIMER.CurrentTime < Main.FRAMERATE * 5) && (this.m_narratorSpeech == null || this.m_narratorSpeech.IsFinished))
         {
            this.m_narratorSpeech = null;
            _loc2_ = int(this.SOUNDQUEUE.playVoiceEffect(param1[_loc3_]));
            if(_loc2_ >= 0)
            {
               this.m_narratorSpeech = this.SOUNDQUEUE.getSoundObject(_loc2_);
               _loc3_ = 1;
               while(_loc3_ < param1.length)
               {
                  this.m_narratorSpeech.queueSound(ResourceManager.getLibrarySound(param1[_loc3_]),SaveData.VAVolumeLevel,param1[_loc3_]);
                  _loc3_++;
               }
            }
         }
      }
      
      public function stopNarratorSpeech() : void
      {
         if(this.m_narratorSpeech != null)
         {
            this.m_narratorSpeech.stop();
         }
         this.m_narratorSpeech = null;
      }
      
      public function playSpecificSound(param1:String, param2:Number = 1) : int
      {
         if(this.m_soundMemory.containsKey(param1))
         {
            return -1;
         }
         this.m_soundMemory.setKey(param1,true);
         return this.SOUNDQUEUE.playSoundEffect(param1,param2);
      }
      
      public function playSpecificVoice(param1:String, param2:Number = 1) : int
      {
         if(this.m_soundMemory.containsKey(param1))
         {
            return -1;
         }
         this.m_soundMemory.setKey(param1,true);
         return this.SOUNDQUEUE.playVoiceEffect(param1,param2);
      }
      
      public function stopSound(param1:int) : void
      {
         this.SOUNDQUEUE.stopSound(param1);
      }
      
      public function setCamStageFocus(param1:int) : void
      {
         this.CAM.setStageFocus(param1);
      }
      
      public function removeCamStageFocus() : void
      {
         this.CAM.removeStageFocus();
      }
      
      public function getCamBounds() : MovieClip
      {
         return this.CAMBOUNDS;
      }
      
      public function getDeathBounds() : MovieClip
      {
         return this.DEATHBOUNDS;
      }
      
      public function calculateChargeDamage(param1:Object) : Number
      {
         var _loc2_:AttackDamage = new AttackDamage(0);
         _loc2_.importAttackDamageData(param1);
         return Utils.calculateChargeDamage(_loc2_);
      }
      
      public function attachEffect(param1:*, param2:Object = null) : MovieClip
      {
         var _loc8_:Boolean = false;
         var _loc9_:MovieClip = null;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = 1;
         var _loc6_:Number = 1;
         var _loc7_:Number = 0;
         if(param2 != null)
         {
            _loc3_ = param2.x !== undefined ? Number(param2.x) : _loc3_;
            _loc4_ = param2.y !== undefined ? Number(param2.y) : _loc4_;
            _loc5_ = param2.scaleX !== undefined ? Number(param2.scaleX) : _loc5_;
            _loc6_ = param2.scaleY !== undefined ? Number(param2.scaleY) : _loc6_;
            _loc7_ = param2.rotation !== undefined ? Number(param2.rotation) : 0;
            _loc8_ = param2.force !== undefined ? Boolean(param2.force) : _loc8_;
         }
         if(Boolean(param1 is String && param1.match(/^global_/)) && Boolean(!this.getQualitySettings().global_effects) && !_loc8_)
         {
            return new MovieClip();
         }
         if(param1 != null)
         {
            _loc9_ = this.attachUniqueMovie(param1);
            if(_loc9_ != null)
            {
               _loc9_.stop();
               Utils.recursiveMovieClipPlay(_loc9_,false);
               _loc9_.x = _loc3_;
               _loc9_.y = _loc4_;
               _loc9_.scaleX *= _loc5_;
               _loc9_.scaleY *= _loc6_;
               _loc9_.rotation = _loc7_;
            }
         }
         return _loc9_;
      }
      
      public function attachEffectOverlay(param1:*, param2:Object = null) : MovieClip
      {
         var _loc8_:Boolean = false;
         var _loc9_:MovieClip = null;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = 1;
         var _loc6_:Number = 1;
         var _loc7_:Number = 0;
         if(param2 != null)
         {
            _loc3_ = param2.x !== undefined ? Number(param2.x) : _loc3_;
            _loc4_ = param2.y !== undefined ? Number(param2.y) : _loc4_;
            _loc5_ = param2.scaleX !== undefined ? Number(param2.scaleX) : _loc5_;
            _loc6_ = param2.scaleY !== undefined ? Number(param2.scaleY) : _loc6_;
            _loc7_ = param2.rotation !== undefined ? Number(param2.rotation) : 0;
            _loc8_ = param2.force !== undefined ? Boolean(param2.force) : _loc8_;
         }
         if(Boolean(param1 is String && param1.match(/^global_/)) && Boolean(!this.getQualitySettings().global_effects) && !_loc8_)
         {
            return new MovieClip();
         }
         if(param1 != null)
         {
            _loc9_ = this.attachUniqueMovieOverlay(param1);
            if(_loc9_ != null)
            {
               _loc9_.stop();
               Utils.recursiveMovieClipPlay(_loc9_,false);
               _loc9_.x = _loc3_;
               _loc9_.y = _loc4_;
               _loc9_.scaleX *= _loc5_;
               _loc9_.scaleY *= _loc6_;
               _loc9_.rotation = _loc7_;
            }
         }
         return _loc9_;
      }
      
      private function attachUniqueMovie(param1:*) : MovieClip
      {
         if(Boolean(param1 is String) && Boolean(param1.match(/^global_/)) && !this.getQualitySettings().global_effects)
         {
            return new MovieClip();
         }
         var _loc2_:MovieClip = param1 is Class ? new param1() : ResourceManager.getLibraryMC(param1);
         if(_loc2_ != null)
         {
            _loc2_.stop();
            Utils.recursiveMovieClipPlay(_loc2_,false);
            this.STAGE.addChild(_loc2_);
            if(this.m_effectIndex >= this.EFFECT_LIMIT)
            {
               this.m_effectIndex = 0;
            }
            if(this.m_effectList[this.m_effectIndex] != null && Boolean(this.m_effectList[this.m_effectIndex].parent))
            {
               this.m_effectList[this.m_effectIndex].parent.removeChild(this.m_effectList[this.m_effectIndex]);
               this.m_effectList[this.m_effectIndex] = null;
            }
            this.m_effectList[this.m_effectIndex] = _loc2_;
            ++this.m_effectIndex;
         }
         return _loc2_;
      }
      
      private function attachUniqueMovieOverlay(param1:*) : MovieClip
      {
         if(Boolean(param1 is String) && Boolean(param1.match(/^global_/)) && !this.getQualitySettings().global_effects)
         {
            return new MovieClip();
         }
         var _loc2_:MovieClip = param1 is Class ? new param1() : ResourceManager.getLibraryMC(param1);
         if(_loc2_ != null)
         {
            _loc2_.stop();
            Utils.recursiveMovieClipPlay(_loc2_,false);
            this.STAGEEFFECTS.addChild(_loc2_);
            if(this.m_effectOverlayIndex >= this.EFFECT_LIMIT)
            {
               this.m_effectOverlayIndex = 0;
            }
            if(this.m_effectOverlayList[this.m_effectOverlayIndex] != null && Boolean(this.m_effectOverlayList[this.m_effectOverlayIndex].parent))
            {
               this.m_effectOverlayList[this.m_effectOverlayIndex].parent.removeChild(this.m_effectOverlayList[this.m_effectOverlayIndex]);
               this.m_effectOverlayList[this.m_effectOverlayIndex] = null;
            }
            this.m_effectOverlayList[this.m_effectOverlayIndex] = _loc2_;
            ++this.m_effectOverlayIndex;
         }
         return _loc2_;
      }
      
      public function attachUniqueMovieHUD(param1:*) : MovieClip
      {
         if(Boolean(param1 is String) && Boolean(param1.match(/^global_/)) && !this.getQualitySettings().global_effects)
         {
            return new MovieClip();
         }
         var _loc2_:MovieClip = param1 is Class ? new param1() : ResourceManager.getLibraryMC(param1);
         if(_loc2_ != null)
         {
            _loc2_.stop();
            Utils.recursiveMovieClipPlay(_loc2_,false);
            this.HUDFOREGROUND.addChild(_loc2_);
            if(this.m_effectHUDIndex >= this.EFFECT_LIMIT_SECONDARY)
            {
               this.m_effectHUDIndex = 0;
            }
            if(this.m_effectHUDList[this.m_effectHUDIndex] != null && Boolean(this.m_effectHUDList[this.m_effectHUDIndex].parent))
            {
               this.m_effectHUDList[this.m_effectHUDIndex].parent.removeChild(this.m_effectHUDList[this.m_effectHUDIndex]);
               this.m_effectHUDList[this.m_effectHUDIndex] = null;
            }
            this.m_effectHUDList[this.m_effectHUDIndex] = _loc2_;
            ++this.m_effectHUDIndex;
         }
         return _loc2_;
      }
      
      public function attachUniqueMovieHUDOverlay(param1:*) : MovieClip
      {
         if(Boolean(param1 is String) && Boolean(param1.match(/^global_/)) && !this.getQualitySettings().global_effects)
         {
            return new MovieClip();
         }
         var _loc2_:MovieClip = param1 is Class ? new param1() : ResourceManager.getLibraryMC(param1);
         if(_loc2_ != null)
         {
            _loc2_.stop();
            Utils.recursiveMovieClipPlay(_loc2_,false);
            this.HUDOVERLAY.addChild(_loc2_);
            if(this.m_effectHUDOverlayIndex >= this.EFFECT_LIMIT_SECONDARY)
            {
               this.m_effectHUDOverlayIndex = 0;
            }
            if(this.m_effectHUDOverlayList[this.m_effectHUDOverlayIndex] != null && Boolean(this.m_effectHUDOverlayList[this.m_effectHUDOverlayIndex].parent))
            {
               this.m_effectHUDOverlayList[this.m_effectHUDOverlayIndex].parent.removeChild(this.m_effectHUDOverlayList[this.m_effectHUDOverlayIndex]);
               this.m_effectHUDOverlayList[this.m_effectHUDOverlayIndex] = null;
            }
            this.m_effectHUDOverlayList[this.m_effectHUDOverlayIndex] = _loc2_;
            ++this.m_effectHUDOverlayIndex;
         }
         return _loc2_;
      }
      
      public function attachUniqueMovieBG(param1:*) : MovieClip
      {
         if(Boolean(param1 is String) && Boolean(param1.match(/^global_/)) && !this.getQualitySettings().global_effects)
         {
            return new MovieClip();
         }
         var _loc2_:MovieClip = param1 is Class ? new param1() : ResourceManager.getLibraryMC(param1);
         if(_loc2_ != null)
         {
            _loc2_.stop();
            Utils.recursiveMovieClipPlay(_loc2_,false);
            this.STAGEBACKGROUND.addChild(_loc2_);
            if(this.m_effectBGIndex >= this.EFFECT_LIMIT_SECONDARY)
            {
               this.m_effectBGIndex = 0;
            }
            if(this.m_effectBGList[this.m_effectBGIndex] != null && Boolean(this.m_effectBGList[this.m_effectBGIndex].parent))
            {
               this.m_effectBGList[this.m_effectBGIndex].parent.removeChild(this.m_effectBGList[this.m_effectBGIndex]);
               this.m_effectBGList[this.m_effectBGIndex] = null;
            }
            this.m_effectBGList[this.m_effectBGIndex] = _loc2_;
            ++this.m_effectBGIndex;
         }
         return _loc2_;
      }
      
      public function attachUniqueMovieWeather(param1:*) : MovieClip
      {
         if(Boolean(param1 is String) && Boolean(param1.match(/^global_/)) && !this.getQualitySettings().global_effects)
         {
            return new MovieClip();
         }
         var _loc2_:MovieClip = param1 is Class ? new param1() : ResourceManager.getLibraryMC(param1);
         if(_loc2_ != null && this.WEATHER != null)
         {
            _loc2_.stop();
            Utils.recursiveMovieClipPlay(_loc2_,false);
            this.WEATHER.addChild(_loc2_);
            if(this.m_effectWeatherIndex >= this.EFFECT_LIMIT_SECONDARY)
            {
               this.m_effectWeatherIndex = 0;
            }
            if(this.m_effectWeatherList[this.m_effectWeatherIndex] != null && Boolean(this.m_effectWeatherList[this.m_effectWeatherIndex].parent))
            {
               this.m_effectWeatherList[this.m_effectWeatherIndex].parent.removeChild(this.m_effectWeatherList[this.m_effectWeatherIndex]);
               this.m_effectWeatherList[this.m_effectWeatherIndex] = null;
            }
            this.m_effectWeatherList[this.m_effectWeatherIndex] = _loc2_;
            ++this.m_effectWeatherIndex;
         }
         return _loc2_;
      }
      
      private function nextFrameAllEffects() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = undefined;
         if(!this.m_fsCutscene)
         {
            _loc1_ = 0;
            _loc1_ = 0;
            while(_loc1_ < this.m_effectList.length)
            {
               if(Boolean(this.m_effectList[_loc1_]) && (Boolean(!this.m_effectList[_loc1_].uid) || Boolean(this.getCharacterByUID(this.m_effectList[_loc1_].uid) && !this.getCharacterByUID(this.m_effectList[_loc1_].uid).IsFrozenInTime)))
               {
                  Utils.advanceFrame(this.m_effectList[_loc1_]);
                  Utils.recursiveMovieClipPlay(this.m_effectList[_loc1_],true);
                  if(!this.m_effectList[_loc1_].parent)
                  {
                     _loc2_ = _loc1_--;
                     this.m_effectList[_loc2_] = null;
                  }
               }
               _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < this.m_effectBGList.length)
            {
               if(Boolean(this.m_effectBGList[_loc1_]) && (Boolean(!this.m_effectBGList[_loc1_].uid) || Boolean(this.getCharacterByUID(this.m_effectList[_loc1_].uid) && !this.getCharacterByUID(this.m_effectList[_loc1_].uid).IsFrozenInTime)))
               {
                  Utils.advanceFrame(this.m_effectBGList[_loc1_]);
                  Utils.recursiveMovieClipPlay(this.m_effectBGList[_loc1_],true);
                  if(!this.m_effectBGList[_loc1_].parent)
                  {
                     _loc2_ = _loc1_--;
                     this.m_effectBGList[_loc2_] = null;
                  }
               }
               _loc1_++;
            }
            Utils.recursiveMovieClipPlay(this.STAGEEFFECTS,true);
            Utils.recursiveMovieClipPlay(this.WEATHER,true);
         }
         Utils.recursiveMovieClipPlay(this.HUDFOREGROUND,true);
         Utils.recursiveMovieClipPlay(this.HUDTEXT,true);
         Utils.recursiveMovieClipPlay(this.HUDOVERLAY,true);
      }
      
      public function get InTimeStop() : Boolean
      {
         return this.m_timestop;
      }
      
      public function getHighestTimestopPriority() : int
      {
         var _loc2_:Object = null;
         var _loc1_:int = int.MAX_VALUE;
         for each(_loc2_ in this.m_timestopStateTimer)
         {
            if(_loc2_)
            {
               _loc1_ = Math.min(_loc1_,_loc2_.priority);
            }
         }
         return _loc1_;
      }
      
      public function getTimestopBuffer() : int
      {
         var _loc3_:Object = null;
         var _loc1_:int = -1;
         var _loc2_:int = this.getHighestTimestopPriority();
         for each(_loc3_ in this.m_timestopStateTimer)
         {
            if(Boolean(_loc3_) && _loc3_.priority <= _loc2_)
            {
               _loc1_ = Math.max(_loc1_,_loc3_.buffer);
            }
         }
         return _loc1_;
      }
      
      public function addCharacterTimeStopper(param1:int, param2:int, param3:int, param4:int, param5:Object) : void
      {
         this.m_timestopStateTimer[param1] = {
            "buffer":param3,
            "characterLength":param2,
            "priority":param4,
            "bypassOptions":param5
         };
      }
      
      public function getCharacterTimeStopperBypassOptions(param1:int) : Object
      {
         if(!this.m_timestopStateTimer[param1])
         {
            return null;
         }
         return this.m_timestopStateTimer[param1].bypassOptions;
      }
      
      public function removeCharacterTimeStopper(param1:int) : void
      {
         this.removeAndUpdateTimeFreeze(param1);
      }
      
      public function tickTime() : void
      {
         var _loc1_:Object = null;
         var _loc3_:String = null;
         var _loc2_:int = this.getHighestTimestopPriority();
         this.m_timestop = _loc2_ != int.MAX_VALUE;
         for(_loc3_ in this.m_timestopStateTimer)
         {
            _loc1_ = this.m_timestopStateTimer[_loc3_];
            if(_loc1_)
            {
               if(_loc1_.buffer >= 0)
               {
                  --_loc1_.buffer;
                  if(_loc1_.buffer < 0)
                  {
                     if(_loc1_.priority <= _loc2_)
                     {
                        this.triggerTimeFreezeOnOther(parseInt(_loc3_));
                     }
                     else if(this.getCharacterByUID(parseInt(_loc3_)))
                     {
                        this.getCharacterByUID(parseInt(_loc3_)).applyTimeFreeze(-1);
                     }
                  }
               }
               else if(_loc1_.priority <= _loc2_)
               {
                  if(_loc1_.characterLength >= 0)
                  {
                     --_loc1_.characterLength;
                     if(_loc1_.characterLength < 0)
                     {
                        this.removeAndUpdateTimeFreeze(parseInt(_loc3_));
                     }
                  }
               }
            }
         }
      }
      
      private function removeAndUpdateTimeFreeze(param1:int) : void
      {
         var _loc2_:Character = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         this.m_timestopStateTimer[param1] = null;
         for each(_loc2_ in this.CHARACTERS)
         {
            _loc2_.removeTimeFreeze();
         }
         _loc3_ = this.getHighestTimestopPriority();
         this.m_timestop = _loc3_ != int.MAX_VALUE;
         for(_loc5_ in this.m_timestopStateTimer)
         {
            _loc4_ = this.m_timestopStateTimer[_loc5_];
            if(_loc4_)
            {
               if(_loc4_.buffer < 0 && _loc4_.priority <= _loc3_)
               {
                  this.triggerTimeFreezeOnOther(parseInt(_loc5_));
               }
            }
         }
      }
      
      private function triggerTimeFreezeOnOther(param1:int) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Character = null;
         for each(_loc4_ in this.CHARACTERS)
         {
            if(_loc4_.UID != param1)
            {
               _loc2_ = !this.m_timestopStateTimer[_loc4_.UID];
               _loc3_ = Boolean(this.m_timestopStateTimer[_loc4_.UID]) && this.m_timestopStateTimer[_loc4_.UID].priority > this.m_timestopStateTimer[param1].priority;
               if(_loc2_ || _loc3_)
               {
                  _loc4_.applyTimeFreeze(this.m_timestopStateTimer[param1].characterLength);
               }
               else
               {
                  _loc4_.removeTimeFreeze();
               }
            }
         }
      }
   }
}


package com.mcleodgaming.ssf2
{
   import com.adobe.images.*;
   import com.jotard.ane.*;
   import com.mcleodgaming.mgn.net.*;
   import com.mcleodgaming.ssf2.assists.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.enemies.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.input.*;
   import com.mcleodgaming.ssf2.items.*;
   import com.mcleodgaming.ssf2.menus.*;
   import com.mcleodgaming.ssf2.modapi.ModAPI;
   import com.mcleodgaming.ssf2.net.*;
   import com.mcleodgaming.ssf2.platforms.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.events.*;
   import flash.events.NativeWindowDisplayStateEvent;
   import flash.external.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import mx.utils.*;

   public dynamic class Main extends MovieClip
   {

      private static var ROOT:Main;

      private static var m_randCharList:Vector.<CharacterData>;

      private static var m_randMusicIndex:int;

      public static var m_debugField:TextField;

      public static var preloader:MovieClip;

      public static var m_sdk:DiscordGameSDK;

      public static var m_sdkTimer:Timer;

      public static var m_onlineChar:String;

      public static var m_onlineName:String;

      private static var m_classRefs:Array = new Array(menu_preloader);

      private static var m_guidID:Number = 0;

      private static var m_width:Number = 640;

      private static var m_height:Number = 360;

      public static const MAXPLAYERS:int = 4;

      public static const SHOWMASK:Boolean = true;

      public static const ENCRYPTED:Boolean = Config.encrypt_files;

      private static const DEBUGCONST:Boolean = true;

      private static var m_lazyDebug:Boolean = true;

      public static var FORCEDEBUGOFF:Boolean = false;

      public static var DEBUGAUTHED:Boolean = true;

      public static var LOCALHOST:Boolean = true;

      public static var DOMAIN:String = "localhost";

      public static var AUTHORIZED:Boolean = false;

      public static const FRAMERATE:int = 30;

      private static var m_pendingDiscordJoin:Object = null;

      public function Main()
      {
         var myMenu:ContextMenu;
         super();
         Security.loadPolicyFile(MGNClient.POLICY_FILE);
         Utils.initializeUtilsClass();
         ROOT = this;
         try
         {
            SaveData.initializeSaveData();
         }
         catch(e:*)
         {
            SaveData.corrupted = true;
            SaveData.eraseGame();
         }
         GamepadManager.init();
         preloader = MovieClip(ROOT.addChild(ResourceManager.getLibraryMC("menu_preloader")));
         preloader.x = Main.Width / 2;
         preloader.y = Main.Height / 2;
         m_debugField = new TextField();
         stage.scaleMode = StageScaleMode.SHOW_ALL;
         stage.showDefaultContextMenu = false;
         stage.stageFocusRect = false;
         myMenu = new ContextMenu();
         myMenu.hideBuiltInItems();
         this.contextMenu = myMenu;
         makeClassStringArr();
         ResourceManager.init();
         MouseTracker.initializeMouseClass();
         MouseTracker.setAutoHide(ROOT.stage,true);
         Key.initializeKeyClass();
         Key.beginCapture(ROOT.stage);
         SpecialMode.init();
         MultiplayerManager.init();
         trace("Main Method started");
         stage.addEventListener(Event.RESIZE,this.resizeListener);
         Main.initResources();
         m_randCharList = new Vector.<CharacterData>();
         m_randMusicIndex = 0;
         this.stage.quality = SaveData.Quality.display_quality;
         wideScreenScrollRect();
         setFullScreenMode(SaveData.Quality.fullscreen_quality);
         ROOT.stage.addEventListener(Event.FULLSCREEN,fixMenu);
         ROOT.loaderInfo.addEventListener(ProgressEvent.PROGRESS,ROOT.onRootLoadProgress);
         ROOT.loaderInfo.addEventListener(Event.COMPLETE,ROOT.onRootLoadComplete);
         ROOT.stage.addEventListener(KeyboardEvent.KEY_DOWN,handleGlobalKeypress);
         ROOT.stage.nativeWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE,windowStateChanged);
         setTimeout(function():void
         {
            var _loc1_:* = undefined;
            var _loc2_:int = 0;
            var _loc3_:int = 0;
            var _loc4_:Vector.<Gamepad> = GamepadManager.getGamepads();
            for(_loc1_ in SaveData.PortInputs)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc4_.length)
               {
                  if(SaveData.PortInputs[_loc1_] === _loc4_[_loc2_].Name + " " + _loc4_[_loc2_].Port && Boolean(SaveData.Gamepads[_loc4_[_loc2_].Name]))
                  {
                     _loc3_ = int(parseInt(_loc1_));
                     SaveData.Controllers[_loc3_ - 1].GamepadInstance = _loc4_[_loc2_];
                     _loc4_[_loc2_].importControls(SaveData.Gamepads[_loc4_[_loc2_].Name].ports["port" + _loc4_[_loc2_].Port]);
                  }
                  _loc2_++;
               }
            }
         },1000);
      }

      public static function get isFullscreen() : Boolean
      {
         return ROOT.stage.displayState === StageDisplayState.FULL_SCREEN_INTERACTIVE;
      }

      public static function windowStateChanged(param1:NativeWindowDisplayStateEvent) : void
      {
         var e:NativeWindowDisplayStateEvent = param1;
         if(e.beforeDisplayState === NativeWindowDisplayState.NORMAL && e.afterDisplayState === NativeWindowDisplayState.MAXIMIZED)
         {
            ROOT.stage.nativeWindow.restore();
            setTimeout(function():void
            {
               toggleFullScreen(true);
            },1);
         }
      }

      private static function handleGlobalKeypress(param1:KeyboardEvent) : void
      {
         if(param1.ctrlKey && param1.keyCode === 70)
         {
            toggleFullScreen(!Main.isFullscreen);
         }
         if(param1.ctrlKey && param1.shiftKey && param1.keyCode === Key.M && !Main.preloader)
         {
            SoundQueue.instance.MusicIsMuted = !SoundQueue.instance.MusicIsMuted;
            if(SoundQueue.instance.MusicIsMuted)
            {
               MenuController.muteMenu.SubMenu.gotoAndStop("muted");
            }
            else
            {
               MenuController.muteMenu.SubMenu.gotoAndStop("unmuted");
            }
            MenuController.muteMenu.removeSelf();
            MenuController.muteMenu.show();
         }
         if(param1.keyCode === 116)
         {
            m_lazyDebug = !m_lazyDebug;
            MultiplayerManager.notify("Lazy Debug toggled: " + m_lazyDebug);
            if(GameController.constantDebugger != null)
            {
               GameController.constantDebugger.updateVisibility();
            }
            if(GameController.stageData != null)
            {
               if(!m_lazyDebug)
               {
                  GameController.stageData.createFPSTimer();
               }
               GameController.stageData.setFPSTimerVisible(!m_lazyDebug);
            }
         }
      }

      public static function toggleFullScreen(param1:Boolean) : void
      {
         if(!Main.isFullscreen)
         {
            Main.Root.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
         }
         else
         {
            Main.Root.stage.displayState = StageDisplayState.NORMAL;
         }
      }

      public static function setFullScreenMode(param1:int) : void
      {
         if(param1 == 0)
         {
            Main.Root.stage.fullScreenSourceRect = new Rectangle(0,0,Main.Width,Main.Height);
         }
         else if(param1 == 1)
         {
            Main.Root.stage.fullScreenSourceRect = null;
         }
      }

      public static function setFocus(param1:InteractiveObject) : void
      {
         Main.Root.stage.focus = param1;
      }

      public static function fixFocus() : void
      {
         Main.Root.stage.focus = Main.Root.stage;
      }

      public static function fixMenu(param1:Event) : void
      {
         ROOT.stage.showDefaultContextMenu = false;
      }

      public static function resetScrollRect() : void
      {
         Main.Root.scrollRect = null;
      }

      public static function wideScreenScrollRect() : void
      {
      }

      private static function makeClassStringArr() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         while(_loc3_ < m_classRefs.length)
         {
            _loc1_ = getQualifiedClassName(m_classRefs[_loc3_]);
            _loc2_ = _loc1_.substr(_loc1_.indexOf("::") + 2);
            registerClassAlias(_loc2_,m_classRefs[_loc3_]);
            _loc3_++;
         }
      }

      private static function randomTest() : void
      {
         var _loc2_:int = 0;
         var _loc1_:Number = 0;
         while(_loc2_ < 1000000)
         {
            _loc1_ += Utils.random();
            _loc2_++;
         }
         trace("[Random test complete: Average rand value is " + _loc1_ / 1000000 + "]");
      }

      private static function initResources() : void
      {
         var _loc1_:LocalConnection = new LocalConnection();
         var _loc2_:String = _loc1_.domain;
         if(_loc2_ == "localhost" || _loc2_ == "127.0.0.1" || Boolean(_loc2_.match(/^app#com\.mcleodgaming\.ssf2(?:2|3|4)?$/)))
         {
            Main.AUTHORIZED = true;
         }
         else if(Boolean(_loc2_.match(/mcleodgaming\.com$/)) || Boolean(_loc2_.match(/ssf2\.com$/)) || Boolean(_loc2_.match(/supersmashflash\.com$/)))
         {
            Main.DOMAIN = _loc2_;
            Main.LOCALHOST = false;
            Main.AUTHORIZED = true;
         }
      }

      public static function prepRandomCharacters(param1:Number) : void
      {
         m_randCharList = new Vector.<CharacterData>();
         while(m_randCharList.length < param1)
         {
            m_randCharList.push(Stats.getRandomCharacter());
         }
      }

      public static function clearRandomCharacterPrep() : void
      {
         m_randCharList.splice(0,m_randCharList.length);
      }

      public static function prepRandomMusic(param1:Number) : void
      {
         if(Boolean(Main.DEBUG) || Boolean(SaveData.Unlocks.alternate_tracks) || Boolean(ResourceManager.FORCE_ENABLE_ALT_TRACKS))
         {
            ResourceManager.FORCE_ENABLE_ALT_TRACKS = false;
            m_randMusicIndex = param1;
         }
         else
         {
            m_randMusicIndex = 0;
         }
      }

      public static function getURL(param1:*, param2:String = "_self") : void
      {
         var _loc3_:String = null;
         var _loc4_:URLRequest = param1 is String ? new URLRequest(param1) : param1;
         if(!ExternalInterface.available)
         {
            navigateToURL(_loc4_,param2);
         }
         else
         {
            _loc3_ = String(ExternalInterface.call("function() {return navigator.userAgent;}")).toLowerCase();
            if(_loc3_.indexOf("firefox") != -1 || _loc3_.indexOf("msie") != -1 && uint(_loc3_.substr(_loc3_.indexOf("msie") + 5,3)) >= 7)
            {
               ExternalInterface.call("window.open",_loc4_.url,param2);
            }
            else
            {
               navigateToURL(_loc4_,param2);
            }
         }
      }

      private static function resourceLoadProgress(param1:Number) : void
      {
         Main.preloader.pCent.text = "" + Math.floor(100 * (1 / 20) + 19 / 20 * param1);
         Main.preloader.progressBar.scaleX = Math.floor(100 * (1 / 20) + 19 / 20 * param1);
      }

      private static function initGame() : void
      {
         var _local_2:* = undefined;
         var unixTimestamp:uint = 0;
         try
         {
            while(SaveDataMigrations.postLoadMigrations.length > 0)
            {
               _local_2 = SaveDataMigrations.postLoadMigrations;
               _local_2[0]();
               SaveDataMigrations.postLoadMigrations.splice(0,1);
            }
         }
         catch(e:*)
         {
            SaveData.corrupted = true;
         }
         Stats.init();
         ItemsListData.init();
         MenuController.init();
         UnlockController.init();
         ROOT.loaderInfo.removeEventListener(Event.COMPLETE,ROOT.onRootLoadComplete);
         if(Main.preloader.parent)
         {
            Main.preloader.parent.removeChild(Main.preloader);
            Main.preloader = null;
         }
         if(Main.AUTHORIZED)
         {
            MenuController.showInitialMenu();
            ModAPI.rlAutoStartCheck();
         }
         else
         {
            MenuController.blockedMenu.show();
         }
         if(SaveData.corrupted)
         {
            MultiplayerManager.makeNotifier();
            MultiplayerManager.notify("Warning, save data has been corrupted and could not be recovered. Initializing with clean save file.");
            SaveData.corrupted = false;
         }
         ResourceManager.appendExpansionCostumes();
         try
         {
            trace("[Main] Step 1: Creating DiscordGameSDK instance...");
            m_sdk = new DiscordGameSDK();
            trace("[Main] Step 2: DiscordGameSDK instance created: " + (m_sdk != null));
            if(m_sdk)
            {
               trace("[Main] Step 3: Calling initialize with appID 1377619298104901703...");
               m_sdk.initialize("1377619298104901703",{});
               trace("[Main] Step 4: Initialize completed successfully");
               trace("[Main] Step 5: Registering event listeners...");
               try
               {
                  m_sdk.addEventListener("ON_ACTIVITY_JOIN_REQUEST",Main.handleDiscordJoinRequest);
                  trace("[Main] Step 6: ON_ACTIVITY_JOIN_REQUEST registered");
               }
               catch(e:Error)
               {
                  trace("[Main] Warning - could not register ON_ACTIVITY_JOIN_REQUEST: " + e.message);
               }
               try
               {
                  m_sdk.addEventListener("ON_ACTIVITY_INVITE",Main.handleDiscordInvite);
                  trace("[Main] Step 7: ON_ACTIVITY_INVITE registered");
               }
               catch(e:Error)
               {
                  trace("[Main] Warning - could not register ON_ACTIVITY_INVITE: " + e.message);
               }
               try
               {
                  m_sdk.addEventListener("ON_ACTIVITY_JOIN",Main.handleDiscordJoin);
                  trace("[Main] Step 8: ON_ACTIVITY_JOIN registered");
               }
               catch(e:Error)
               {
                  trace("[Main] Warning - could not register ON_ACTIVITY_JOIN: " + e.message);
               }
               trace("[Main] Step 8: Event listener setup complete");
               trace("[Main] Step 9: Creating Timer...");
               m_sdkTimer = new Timer(1000);
               m_sdkTimer.addEventListener(TimerEvent.TIMER,Main.updateDiscordSDK);
               m_sdkTimer.start();
               trace("[Main] Step 10: Timer started");
               trace("[Main] Step 11: Updating initial activity...");
               unixTimestamp = uint(new Date().time / 1000);
               m_sdk.updateActivity({
                  "details":"Starting up",
                  "partyCurrentSize":0,
                  "partyMaxSize":0,
                  "timestampStart":unixTimestamp.toString()
               });
               trace("[Main] Step 12: Initial activity updated");
               trace("[Main] Discord SDK initialized successfully");
            }
            else
            {
               trace("[Main] ERROR: m_sdk is null after creation");
            }
         }
         catch(e:Error)
         {
            trace("[Main] Discord SDK initialization failed: " + e.message);
            trace("[Main] Error name: " + e.name);
            trace("[Main] Error ID: " + e.errorID);
            trace("[Main] Stack trace: " + e.getStackTrace());
         }
      }

      public static function get Root() : Main
      {
         return ROOT;
      }

      public static function getClassByName(param1:String) : Class
      {
         var _loc2_:Class = null;
         try
         {
            return getClassByAlias(param1);
         }
         catch(e:*)
         {
         }
         return _loc2_;
      }

      public static function getClassName(param1:*) : String
      {
         return getQualifiedClassName(param1);
      }

      public static function get DebugField() : TextField
      {
         return m_debugField;
      }

      public static function get Width() : Number
      {
         return m_width;
      }

      public static function get Height() : Number
      {
         return m_height;
      }

      public static function get DEBUG() : Boolean
      {
         return (Boolean(DEBUGCONST) || Boolean(m_lazyDebug)) && !FORCEDEBUGOFF;
      }

      public static function get LAZYDEBUG() : Boolean
      {
         return m_lazyDebug;
      }

      public static function get RandCharList() : Vector.<CharacterData>
      {
         return m_randCharList;
      }

      public static function get RandMusicIndex() : int
      {
         return m_randMusicIndex;
      }

      public static function turnOffDebug() : void
      {
         FORCEDEBUGOFF = true;
      }

      private static function updateDiscordSDK(param1:TimerEvent) : void
      {
         if(m_sdk)
         {
            m_sdk.runCallbacks();
         }
      }

      public static function handleDiscordJoin(param1:DiscordEvent) : void
      {
         var joinSecret:String;
         var joinData:Object = null;
         var e:DiscordEvent = param1;
         trace("[Main] handleDiscordJoin called");
         joinSecret = e.data as String;
         if(!joinSecret || joinSecret.length == 0)
         {
            MultiplayerManager.notify("Invalid Discord invite data");
            return;
         }
         try
         {
            joinData = JSON.parse(joinSecret);
            m_pendingDiscordJoin = {
               "room_key":joinData.k,
               "room_code":joinData.c,
               "room_password":joinData.p || "",
               "room_capacity":joinData.m || 4,
               "timestamp":new Date().time
            };
            MultiplayerManager.notify("Discord invite received! Preparing to join room...");
            if(!MultiplayerManager.Connected)
            {
               if(!MenuController.onlineMenu.isOnscreen())
               {
                  MenuController.disposeAllMenus();
                  MenuController.onlineMenu.show();
               }
            }
            else
            {
               processDiscordJoin();
            }
         }
         catch(error:Error)
         {
            MultiplayerManager.notify("Invalid Discord invite format: " + error.message);
            trace("[Main] Error parsing Discord join secret: " + error.message);
         }
      }

      public static function handleDiscordJoinRequest(param1:DiscordEvent) : void
      {
         var data:Object = null;
         var uhm:OnlinePromptMenu = null;
         var evt:DiscordEvent = param1;
         trace("[Main] handleDiscordJoinRequest called");
         try
         {
            data = JSON.parse(evt.data as String);
            uhm = MenuController.onlinePromptMenu;
            uhm.message = StringUtil.substitute("{0} from Discord wants to join your online lobby.\nAccept?",data.username);
            uhm.onAccept = Main.acceptDiscordJoinRequest;
            uhm.onDismiss = Main.rejectDiscordJoinRequest;
            uhm.data = Utils.cloneObject(data);
            if(!uhm.isOnscreen())
            {
               uhm.show();
            }
         }
         catch(error:Error)
         {
            trace("[Main] Error handling Discord join request: " + error.message);
         }
      }

      public static function handleDiscordInvite(param1:DiscordEvent) : void
      {
         trace("[Main] handleDiscordInvite called");
         MultiplayerManager.notify("Discord invite sent!");
      }

      private static function acceptDiscordJoinRequest() : void
      {
         trace("[Main] acceptDiscordJoinRequest called");
         var _loc1_:OnlinePromptMenu = MenuController.onlinePromptMenu;
         if(Boolean(m_sdk) && Boolean(_loc1_.data) && Boolean(_loc1_.data.id))
         {
            m_sdk.sendRequestReply(_loc1_.data.id,1);
         }
         _loc1_.removeSelf();
      }

      private static function rejectDiscordJoinRequest() : void
      {
         trace("[Main] rejectDiscordJoinRequest called");
         var _loc1_:OnlinePromptMenu = MenuController.onlinePromptMenu;
         if(Boolean(m_sdk) && Boolean(_loc1_.data) && Boolean(_loc1_.data.id))
         {
            m_sdk.sendRequestReply(_loc1_.data.id,0);
         }
         _loc1_.removeSelf();
      }

      public static function processDiscordJoin() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:Object = null;
         trace("[Main] processDiscordJoin called");
         if(Boolean(m_pendingDiscordJoin) && Boolean(MultiplayerManager.Connected))
         {
            _loc1_ = m_pendingDiscordJoin.room_key;
            _loc2_ = m_pendingDiscordJoin.room_password || "";
            _loc3_ = m_pendingDiscordJoin;
            m_pendingDiscordJoin = null;
            if(MenuController.pleaseWaitMenu)
            {
               MenuController.pleaseWaitMenu.show();
            }
            MultiplayerManager.notify("Requesting to join room from Discord invite...");
            MultiplayerManager.requestToJoinRoom(_loc1_,_loc2_);
         }
         else
         {
            trace("[Main] No pending Discord join or not connected");
         }
      }

      public static function get hasPendingDiscordJoin() : Boolean
      {
         return m_pendingDiscordJoin != null;
      }

      public static function clearPendingDiscordJoin() : void
      {
         m_pendingDiscordJoin = null;
      }

      private function onRootLoadProgress(param1:ProgressEvent) : void
      {
         var _loc2_:int = param1.bytesTotal == 0 ? 706780 : int(param1.bytesTotal);
         var _loc3_:Number = param1.bytesLoaded / _loc2_ * 100;
         if(_loc3_ > 100 || Boolean(isNaN(_loc3_)))
         {
            _loc3_ = 0;
         }
         Main.preloader.percentage = _loc3_;
         Main.preloader.pCent.text = Math.floor(_loc3_ * (1 / 20));
         Main.preloader.progressBar.scaleX = _loc3_ / 100 * (1 / 20);
      }

      protected function onRootLoadComplete(param1:Event) : void
      {
         ROOT.loaderInfo.removeEventListener(ProgressEvent.PROGRESS,ROOT.onRootLoadProgress);
         ROOT.loaderInfo.removeEventListener(Event.COMPLETE,ROOT.onRootLoadComplete);
         ResourceManager.queueRequiredResources();
         ResourceManager.load({
            "onprogress":resourceLoadProgress,
            "oncomplete":initGame
         });
      }

      private function resizeListener(param1:Event) : void
      {
         trace("resized");
      }
   }
}


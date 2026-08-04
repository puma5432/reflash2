package com.mcleodgaming.ssf2.net
{
   import com.mcleodgaming.mgn.events.*;
   import com.mcleodgaming.mgn.net.*;
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.menus.*;
   import com.mcleodgaming.ssf2.modes.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   import flash.net.*;
   import flash.text.TextField;
   import flash.utils.*;
   
   public class MultiplayerManager
   {
      
      private static var m_controllers:Vector.<Controller>;
      
      private static var m_notifier:MovieClip;
      
      private static var m_notifierText:TextField;
      
      private static var m_permanentBox:Boolean;
      
      private static var m_frameRateTimer:FrameTimer;
      
      private static var m_lastUpdate:Date;
      
      private static var m_pingCount:Number;
      
      private static var m_pingTotal:Number;
      
      private static var m_averagePing:Number;
      
      private static var m_frameRateIncremented:Boolean;
      
      private static var m_randomSeed:Number;
      
      private static var m_matchReady:Boolean;
      
      private static var m_matchEnded:Boolean;
      
      private static var m_roomData:Object;
      
      private static var m_roomPassword:String;
      
      private static var m_promotionTimer:FrameTimer;
      
      private static var m_readyToLock:Boolean;
      
      private static var m_game:Game;
      
      private static var m_onlineInterface:MGNClient;
      
      private static const FPS_THRESHOLD:int = 5;
      
      private static const FRAME_RATE_ADJUSTER:Boolean = false;
      
      public static var NORMAL_FPS:int = 30;
      
      public static var MAX_FPS:int = 35;
      
      public static var INPUT_BUFFER:int = 3;
      
      public static var joinRequestPlayerInfoQueue:Vector.<PlayerConnectionInfo> = new Vector.<PlayerConnectionInfo>();
      
      public static var ROOM_CAPACITY:int = 4;
      
      public function MultiplayerManager()
      {
         super();
      }
      
      public static function init() : void
      {
         MGNEventManager.dispatcher.addEventListener(MGNEvent.NOTIFY,handlemgn_NOTIFY);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.PLAYER_JOINED,handlemgn_PLAYER_JOINED);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.PLAYER_LEFT,handlemgn_PLAYER_LEFT);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.DATA,handlemgn_DATA);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.MATCH_READY_STATUS,onMatchReadyStatus);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.MATCH_START,handlemgn_MATCH_START);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.MATCH_FINISHED,handlemgn_MATCH_FINISHED);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.MATCH_END,handlemgn_MATCH_END);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.DISCONNECT,handlemgn_DISCONNECT);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.ROOM_JOIN_REQUEST,onRoomJoinRequestReceived);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.ROOM_DATA,roomDataSet);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.ERROR_ROOM_DATA,roomDataSetError);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.LOCK_ROOM,onRoomLocked);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.ERROR_LOCK_ROOM,onRoomLockedError);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.UNLOCK_ROOM,onRoomUnlocked);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.ERROR_UNLOCK_ROOM,onRoomUnlockedError);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.ERROR_PING,onPingError);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.LEAVE_ROOM,onLeaveRoom);
         initializeMultiplayerManager();
         trace("MultiplayerManager initialized");
      }
      
      private static function initializeMultiplayerManager() : void
      {
         var _loc1_:int = 0;
         m_matchReady = false;
         m_matchEnded = false;
         m_roomData = null;
         m_permanentBox = false;
         m_controllers = new Vector.<Controller>();
         while(_loc1_ < Main.MAXPLAYERS)
         {
            m_controllers.push(new Controller(_loc1_ + 1,SaveData.Controllers[_loc1_].getControls()));
            _loc1_++;
         }
         m_notifier = null;
         m_notifierText = null;
         m_onlineInterface = new MGNClient(Main.MAXPLAYERS);
         m_frameRateTimer = new FrameTimer(30);
         m_promotionTimer = new FrameTimer(30 * 5);
         m_lastUpdate = null;
         m_pingCount = 0;
         m_pingTotal = 0;
         m_averagePing = 0;
         m_frameRateIncremented = true;
         m_randomSeed = 0;
         m_readyToLock = false;
         m_roomPassword = null;
         resetMasterFrame();
      }
      
      public static function get CurrentHostID() : String
      {
         return m_onlineInterface.CurrentHostID;
      }
      
      public static function get Username() : String
      {
         return m_onlineInterface.Username;
      }
      
      public static function get SocketID() : String
      {
         return m_onlineInterface.SocketID;
      }
      
      public static function get RoomList() : Array
      {
         return m_onlineInterface.RoomList;
      }
      
      public static function get MatchReady() : Boolean
      {
         return m_matchReady;
      }
      
      public static function get MatchEnded() : Boolean
      {
         return m_matchEnded;
      }
      
      public static function get RoomKey() : String
      {
         return m_onlineInterface.RoomKey;
      }
      
      public static function get RoomCode() : String
      {
         return m_onlineInterface.RoomName;
      }
      
      public static function get RoomPassword() : String
      {
         return m_roomPassword;
      }
      
      public static function get RoomData() : Object
      {
         return m_roomData;
      }
      
      public static function get GameInstance() : Game
      {
         return m_game;
      }
      
      public static function get Controllers() : Vector.<Controller>
      {
         return m_controllers;
      }
      
      public static function get Ping() : Number
      {
         return Math.round(m_averagePing);
      }
      
      public static function get Connected() : Boolean
      {
         return m_onlineInterface.Connected;
      }
      
      public static function get Active() : Boolean
      {
         return m_onlineInterface.Active;
      }
      
      public static function set Active(param1:Boolean) : void
      {
         m_onlineInterface.Active = param1;
      }
      
      public static function get MasterFrame() : int
      {
         return m_onlineInterface.MasterFrame;
      }
      
      public static function set MasterFrame(param1:int) : void
      {
         m_onlineInterface.MasterFrame = param1;
      }
      
      public static function get PlayerID() : int
      {
         return m_onlineInterface.PlayerID;
      }
      
      public static function get RoomLocked() : Boolean
      {
         return m_onlineInterface.RoomLocked;
      }
      
      public static function get IsHost() : Boolean
      {
         return m_onlineInterface.IsHost;
      }
      
      public static function get Protocol() : String
      {
         return m_onlineInterface.Protocol;
      }
      
      public static function set Protocol(param1:String) : void
      {
         m_onlineInterface.Protocol = param1;
      }
      
      public static function get DowngradedConnection() : Boolean
      {
         return m_onlineInterface.DowngradedConnection;
      }
      
      public static function downgradeP2P() : void
      {
         m_onlineInterface.downgradeP2P();
      }
      
      public static function get PromotionTimer() : FrameTimer
      {
         return m_promotionTimer;
      }
      
      public static function get Players() : Vector.<PlayerConnectionInfo>
      {
         return m_onlineInterface.Players;
      }
      
      public static function get DiscordPartyID() : String
      {
         return m_onlineInterface.CurrentPartyID;
      }
      
      public static function get PlayerSyncStream() : PlayerDataSyncStream
      {
         return m_onlineInterface.PlayerSyncStream;
      }
      
      public static function reset() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         if(Main.m_sdk)
         {
            _loc1_ = Math.random().toString();
            _loc2_ = JSON.stringify({"invalid":Math.random().toString()});
            trace("[Discord] RESET - Invalidating old invites");
            trace("[Discord] RESET - Randomized partyID: " + _loc1_);
            trace("[Discord] RESET - Randomized joinSecret: " + _loc2_);
            Main.m_sdk.updateActivity({
               "state":null,
               "details":"In menus",
               "partyID":_loc1_,
               "partyCurrentSize":0,
               "partyMaxSize":0,
               "matchSecret":_loc1_,
               "joinSecret":_loc2_,
               "instance":true
            });
         }
         m_roomData = null;
         m_matchReady = false;
         m_matchEnded = false;
         joinRequestPlayerInfoQueue.splice(0,joinRequestPlayerInfoQueue.length);
         m_onlineInterface.disconnect();
         initializeMultiplayerManager();
      }
      
      public static function resetMasterFrame() : void
      {
         var _loc1_:int = 0;
         m_onlineInterface.resetMasterFrame();
         while(_loc1_ < m_onlineInterface.Players.length)
         {
            m_controllers[_loc1_].flushControlBits();
            _loc1_++;
         }
      }
      
      public static function restoreOriginalGameSettings(param1:Game) : void
      {
         var _loc3_:int = 0;
         param1.importSettings(GameController.onlineModeMatchSettings);
         param1.GameMode = GameController.onlineModeMatchSettings.gameMode;
         var _loc2_:Boolean = param1.PlayerSettings[0].isRandom;
         while(_loc3_ < param1.PlayerSettings.length)
         {
            param1.PlayerSettings[_loc3_].isRandom = false;
            _loc3_++;
         }
         if(_loc2_)
         {
            param1.PlayerSettings[0].character = "random";
         }
      }
      
      public static function resetSeed() : void
      {
         m_randomSeed = Utils.random();
      }
      
      public static function setSeed(param1:Number) : void
      {
         m_randomSeed = param1;
      }
      
      public static function notify(param1:String, param2:Boolean = false) : void
      {
         MultiplayerManager.makeNotifier();
         if(m_notifier != null)
         {
            if(m_notifier.currentFrame === 1)
            {
               m_notifierText.text = "";
            }
            m_notifierText.appendText(" > " + param1 + "\n");
            m_notifierText.scrollV = m_notifierText.numLines;
            m_notifier.gotoAndPlay("showmsg");
            if(Boolean(m_permanentBox) || param2)
            {
               m_permanentBox = true;
               m_notifier.stop();
            }
         }
         trace("[Notify] " + param1);
      }
      
      public static function makeNotifier() : void
      {
         if(m_notifier == null)
         {
            m_notifier = ResourceManager.getLibraryMC("onlineplay_notify");
            m_notifierText = m_notifier.txt_mc.txtbox;
            Main.Root.stage.addChild(m_notifier);
            m_notifier.x = Main.Width / 2;
            m_notifier.y = Main.Height;
         }
      }
      
      public static function connect(param1:String, param2:String, param3:String) : void
      {
         m_onlineInterface.connect(param1,param2,param3);
         MultiplayerManager.makeNotifier();
      }
      
      public static function disconnect() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         if(Main.m_sdk)
         {
            _loc1_ = Math.random().toString();
            _loc2_ = JSON.stringify({"invalid":Math.random().toString()});
            trace("[Discord] DISCONNECT - Invalidating old invites");
            trace("[Discord] DISCONNECT - Randomized partyID: " + _loc1_);
            trace("[Discord] DISCONNECT - Randomized joinSecret: " + _loc2_);
            Main.m_sdk.updateActivity({
               "state":null,
               "details":"In menus",
               "partyID":_loc1_,
               "partyCurrentSize":0,
               "partyMaxSize":0,
               "matchSecret":_loc1_,
               "joinSecret":_loc2_,
               "instance":true
            });
         }
         m_onlineInterface.disconnect();
      }
      
      public static function ping() : void
      {
         m_onlineInterface.ping();
      }
      
      public static function createRoom(param1:String, param2:String, param3:int, param4:Object) : void
      {
         ROOM_CAPACITY = param3;
         m_roomPassword = param2;
         m_onlineInterface.createRoom(param1,param2,param3,param4);
      }
      
      public static function requestToJoinRoom(param1:String, param2:String) : void
      {
         m_roomPassword = param2;
         trace("[Online] Sending requestToJoinRoom for key: " + param1 + (Boolean(param2) && param2 != "" ? " (with password)" : ""));
         m_onlineInterface.requestToJoinRoom(param1,param2);
      }
      
      public static function createJoinRoom(param1:String, param2:String, param3:int, param4:Object) : void
      {
         ROOM_CAPACITY = param3;
         m_roomPassword = param2;
         m_onlineInterface.createJoinRoom(param1,param2,param3,param4);
      }
      
      public static function lockRoom() : void
      {
         m_onlineInterface.lockRoom();
      }
      
      public static function unlockRoom() : void
      {
         m_onlineInterface.unlockRoom();
      }
      
      public static function leaveRoom() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:Object = null;
         trace("[Discord] LEAVE_ROOM - Invalidating join invite by randomizing secrets");
         if(Main.m_sdk)
         {
            _loc1_ = Math.random().toString();
            _loc2_ = JSON.stringify({"invalid":Math.random().toString()});
            _loc3_ = {
               "state":null,
               "details":"In Online Lobby",
               "partyID":_loc1_,
               "partyCurrentSize":0,
               "partyMaxSize":0,
               "matchSecret":_loc1_,
               "joinSecret":_loc2_,
               "instance":true
            };
            trace("[Discord] LEAVE_ROOM - Randomized partyID: " + _loc1_);
            trace("[Discord] LEAVE_ROOM - Randomized joinSecret: " + _loc2_);
            trace("[Discord] LEAVE_ROOM - Old invites will now show as invalid/ended");
            Main.m_sdk.updateActivity(_loc3_);
         }
         m_onlineInterface.leaveRoom();
      }
      
      private static function roomDataSet(param1:MGNEvent) : void
      {
         trace("Room data updated");
      }
      
      private static function roomDataSetError(param1:MGNEvent) : void
      {
         trace("Error, problem updating room data");
      }
      
      private static function onRoomLocked(param1:MGNEvent) : void
      {
         trace("Room locked successfully.");
         m_readyToLock = false;
      }
      
      private static function onRoomLockedError(param1:MGNEvent) : void
      {
         MultiplayerManager.notify("There was a problem locking the room.");
         m_readyToLock = false;
      }
      
      private static function onRoomUnlocked(param1:MGNEvent) : void
      {
         trace("Room unlocked successfully.");
         m_readyToLock = false;
      }
      
      private static function onRoomUnlockedError(param1:MGNEvent) : void
      {
         MultiplayerManager.notify("There was a problem unlocking the room.");
         m_readyToLock = false;
      }
      
      private static function onPingError(param1:MGNEvent) : void
      {
         reset();
         MenuController.removeAllMenus();
         MenuController.onlineMenu.show();
         SoundQueue.instance.playMusic("menumusic",0);
      }
      
      private static function onLeaveRoom(param1:MGNEvent) : void
      {
         m_roomData = null;
         m_matchReady = false;
         m_matchEnded = false;
         m_roomPassword = null;
      }
      
      public static function refreshRoomList(param1:Boolean = false) : void
      {
         m_onlineInterface.refreshRoomList(param1);
      }
      
      public static function sendMyDataFrame(param1:int, param2:Object) : void
      {
         m_onlineInterface.sendMyDataFrame(param1,param2);
      }
      
      public static function sendMatchReadySignal(param1:Object) : void
      {
         m_onlineInterface.sendMatchReadySignal(param1);
      }
      
      public static function sendMatchFinishedSignal(param1:Object) : void
      {
         m_onlineInterface.sendMatchFinishedSignal(param1);
      }
      
      public static function sendMatchEndSignal() : void
      {
         m_onlineInterface.sendMatchEndSignal();
      }
      
      public static function sendMatchSettings(param1:Object) : void
      {
         m_onlineInterface.sendMatchSettings(param1);
      }
      
      public static function onRoomJoinRequestReceived(param1:MGNEvent) : void
      {
         MultiplayerManager.handleRoomJoinRequest(param1.data.playerConnectionInfo);
      }
      
      public static function handleRoomJoinRequest(param1:PlayerConnectionInfo) : void
      {
         var _loc2_:String = null;
         if(RoomLocked || m_onlineInterface.Players.length >= MultiplayerManager.ROOM_CAPACITY)
         {
            m_onlineInterface.declineRoomJoinRequest(param1);
         }
         else if(MenuController.onlinePromptMenu.isOnscreen())
         {
            MultiplayerManager.joinRequestPlayerInfoQueue.push(param1);
         }
         else
         {
            SoundQueue.instance.playSoundEffect("menu_unlock");
            _loc2_ = param1.is_dev ? "+ " + param1.username : param1.username;
            MenuController.onlinePromptMenu.message = _loc2_ + "\n" + "wants to join the match.\n\n" + "Accept?";
            MenuController.onlinePromptMenu.data = param1;
            MenuController.onlinePromptMenu.onAccept = acceptRoomJoinRequest;
            MenuController.onlinePromptMenu.onDismiss = declineRoomJoinRequest;
            MenuController.onlinePromptMenu.show();
         }
      }
      
      public static function acceptRoomJoinRequest() : void
      {
         m_onlineInterface.acceptRoomJoinRequest(MenuController.onlinePromptMenu.data as PlayerConnectionInfo);
         MenuController.onlinePromptMenu.removeSelf();
         if(MultiplayerManager.joinRequestPlayerInfoQueue.length > 0)
         {
            setTimeout(function():void
            {
               MultiplayerManager.handleRoomJoinRequest(MultiplayerManager.joinRequestPlayerInfoQueue.splice(0,1)[0]);
            },2000);
         }
      }
      
      public static function declineRoomJoinRequest() : void
      {
         m_onlineInterface.declineRoomJoinRequest(MenuController.onlinePromptMenu.data as PlayerConnectionInfo);
         MenuController.onlinePromptMenu.removeSelf();
         if(MultiplayerManager.joinRequestPlayerInfoQueue.length > 0)
         {
            setTimeout(function():void
            {
               MultiplayerManager.handleRoomJoinRequest(MultiplayerManager.joinRequestPlayerInfoQueue.splice(0,1)[0]);
            },2000);
         }
      }
      
      private static function updateControls() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         var _loc3_:Date = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(Boolean(m_onlineInterface.Active) && Boolean(m_onlineInterface.Connected))
         {
            _loc1_ = false;
            while(m_onlineInterface.ControlBits[0].length > 0)
            {
               _loc1_ = true;
               _loc2_ = 0;
               while(_loc2_ < m_onlineInterface.Players.length)
               {
                  m_controllers[_loc2_].queueControlBits(m_onlineInterface.ControlBits[_loc2_][0]);
                  m_onlineInterface.ControlBits[_loc2_].splice(0,1);
                  _loc2_++;
               }
            }
            m_frameRateTimer.tick();
            m_promotionTimer.tick();
            if(_loc1_)
            {
               if(MultiplayerManager.INPUT_BUFFER === 0)
               {
                  if(MultiplayerManager.IsHost)
                  {
                     if(Main.Root.stage.frameRate != 60)
                     {
                        Main.Root.stage.frameRate = 60;
                     }
                  }
                  else if(Main.Root.stage.frameRate != 60)
                  {
                     Main.Root.stage.frameRate = 60;
                  }
               }
               if(!m_lastUpdate)
               {
                  m_lastUpdate = new Date();
                  m_averagePing = 1000 / MultiplayerManager.NORMAL_FPS;
                  m_pingTotal = m_averagePing;
                  m_pingCount = 1;
               }
               else
               {
                  _loc3_ = new Date();
                  _loc4_ = _loc3_.time - m_lastUpdate.time;
                  m_lastUpdate.setTime(_loc3_.getTime());
                  ++m_pingCount;
                  m_pingTotal += _loc4_;
                  if(m_frameRateTimer.IsComplete)
                  {
                     m_frameRateTimer.reset();
                     _loc5_ = m_pingTotal / m_pingCount;
                     if(MultiplayerManager.FRAME_RATE_ADJUSTER)
                     {
                        if(_loc5_ > 1000 / MultiplayerManager.NORMAL_FPS)
                        {
                           if(_loc5_ < 1000 / (MultiplayerManager.NORMAL_FPS + MultiplayerManager.FPS_THRESHOLD) && Main.Root.stage.frameRate > MultiplayerManager.NORMAL_FPS)
                           {
                              m_frameRateIncremented = false;
                              --Main.Root.stage.frameRate;
                           }
                           else if(_loc5_ < m_averagePing + 2)
                           {
                              if(Boolean(m_frameRateIncremented) && Main.Root.stage.frameRate < MultiplayerManager.MAX_FPS)
                              {
                                 ++Main.Root.stage.frameRate;
                              }
                              else if(!m_frameRateIncremented && Main.Root.stage.frameRate > MultiplayerManager.NORMAL_FPS)
                              {
                                 --Main.Root.stage.frameRate;
                              }
                           }
                           else
                           {
                              m_frameRateIncremented = !m_frameRateIncremented;
                              if(Boolean(m_frameRateIncremented) && Main.Root.stage.frameRate < MultiplayerManager.MAX_FPS)
                              {
                                 ++Main.Root.stage.frameRate;
                              }
                              else if(!m_frameRateIncremented && Main.Root.stage.frameRate > MultiplayerManager.NORMAL_FPS)
                              {
                                 --Main.Root.stage.frameRate;
                              }
                           }
                        }
                     }
                     if(Boolean(Main.DEBUG) && Boolean(MenuController.debugConsole) && Boolean(MenuController.debugConsole.PingCapture))
                     {
                        MultiplayerManager.notify(Ping + " ms (" + m_onlineInterface.getFrameDelay() + ")");
                     }
                     m_averagePing = _loc5_;
                     m_pingCount = 0;
                     m_pingTotal = 0;
                  }
               }
            }
         }
      }
      
      private static function handlemgn_PLAYER_JOINED(param1:MGNEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_unlock");
         if(param1.data.is_dev)
         {
            MultiplayerManager.notify("+ " + param1.data.username + " has joined the match.");
         }
         else
         {
            MultiplayerManager.notify(param1.data.username + " has joined the match.");
         }
         m_onlineInterface.updateDiscordActivity();
      }
      
      private static function handlemgn_PLAYER_LEFT(param1:MGNEvent) : void
      {
         if(param1.data.is_dev)
         {
            MultiplayerManager.notify("+ " + param1.data.username + " has disconnected.");
         }
         else
         {
            MultiplayerManager.notify(param1.data.username + " has disconnected.");
         }
         m_matchReady = false;
         m_onlineInterface.updateDiscordActivity();
         if(param1.data.host)
         {
            MultiplayerManager.leaveRoom();
         }
         else if(Boolean(MultiplayerManager.RoomLocked) && Boolean(m_onlineInterface.IsHost))
         {
            MultiplayerManager.unlockRoom();
         }
      }
      
      private static function handlemgn_NOTIFY(param1:MGNEvent) : void
      {
         MultiplayerManager.notify(param1.data.message);
      }
      
      private static function handlemgn_DATA(param1:MGNEvent) : void
      {
      }
      
      private static function onMatchReadyStatus(param1:MGNEvent) : void
      {
      }
      
      private static function handlemgn_MATCH_START(param1:MGNEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         m_matchEnded = false;
         if(Boolean(GameController.currentGame) && Boolean(GameController.currentGame.SuddenDeath))
         {
            m_matchReady = true;
            return;
         }
         m_roomData = {};
         m_roomData.matchSettings = param1.data.room_data.matchSettings;
         m_roomData.matchSettings.playerSettings = [];
         var _loc9_:Array = m_roomData.matchSettings.playerSettings;
         MultiplayerManager.INPUT_BUFFER = m_roomData.matchSettings.levelData.inputBuffer;
         if(MultiplayerManager.INPUT_BUFFER === 0)
         {
            MultiplayerManager.notify("Automated input buffer enabled.");
         }
         m_onlineInterface.PlayerID = 0;
         var _loc10_:Array = param1.data.player_data;
         _loc6_ = 0;
         while(_loc6_ < _loc10_.length)
         {
            _loc9_.push(_loc10_[_loc6_].data.playerSettings);
            if(_loc10_[_loc6_].data.playerSettings.socket_id === m_onlineInterface.SocketID)
            {
               m_onlineInterface.PlayerID = _loc6_ + 1;
            }
            _loc6_++;
         }
         if(m_roomData.matchSettings.levelData.unlocks.alternate_tracks)
         {
            ResourceManager.FORCE_ENABLE_ALT_TRACKS = true;
         }
         Utils.setRandSeed(m_roomData.matchSettings.levelData.randSeed);
         Utils.shuffleRandom();
         Main.prepRandomCharacters(_loc9_.length);
         ResourceManager.queueResources([m_roomData.matchSettings.levelData.stage]);
         if(m_roomData.matchSettings.levelData.teams)
         {
            _loc2_ = -1;
            _loc3_ = new Array();
            _loc4_ = 0;
            _loc5_ = m_roomData.matchSettings.gameMode === Mode.ONLINE_ARENA ? [1,3] : [1,2,3];
            _loc6_ = 0;
            while(_loc6_ < _loc9_.length)
            {
               if(_loc5_.indexOf(_loc9_[_loc6_].team) < 0)
               {
                  if(_loc2_ < 0)
                  {
                     _loc9_[_loc6_].team = 1;
                     _loc2_ = 1;
                     _loc3_[_loc2_] = true;
                     _loc4_++;
                  }
                  else
                  {
                     _loc9_[_loc6_].team = _loc2_;
                     if(!_loc3_[_loc2_])
                     {
                        _loc4_++;
                     }
                     _loc3_[_loc2_] = true;
                  }
               }
               else
               {
                  if(!_loc3_[_loc9_[_loc6_].team])
                  {
                     _loc4_++;
                  }
                  _loc2_ = int(_loc9_[_loc6_].team);
                  _loc3_[_loc2_] = true;
               }
               _loc6_++;
            }
            if(_loc4_ <= 1)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc9_.length)
               {
                  if(_loc5_.indexOf(_loc9_[_loc6_].team) >= 0)
                  {
                     _loc5_.splice(_loc5_.indexOf(_loc9_[_loc6_].team),1);
                  }
                  if(_loc6_ == _loc9_.length - 1)
                  {
                     _loc9_[_loc6_].team = _loc5_[0];
                  }
                  _loc6_++;
               }
            }
         }
         _loc6_ = 0;
         while(_loc6_ < _loc9_.length)
         {
            _loc9_[_loc6_].lives = m_roomData.matchSettings.levelData.lives;
            _loc9_[_loc6_].damageRatio = m_roomData.matchSettings.levelData.damageRatio;
            _loc9_[_loc6_].finalSmashMeter = m_roomData.matchSettings.levelData.finalSmashMeter;
            _loc9_[_loc6_].startDamage = m_roomData.matchSettings.levelData.startDamage;
            if(_loc9_[_loc6_].character != null && _loc9_[_loc6_].character != "xp")
            {
               ResourceManager.queueResources([_loc9_[_loc6_].character == "random" ? Main.RandCharList[_loc6_].StatsName : _loc9_[_loc6_].character]);
            }
            _loc6_++;
         }
         MultiplayerManager.m_game = new Game();
         MultiplayerManager.GameInstance.GameMode = Mode.ONLINE;
         MultiplayerManager.GameInstance.importSettings(MultiplayerManager.RoomData.matchSettings);
         if(m_roomData.matchSettings.gameMode === Mode.ONLINE_ARENA)
         {
            MultiplayerManager.GameInstance.GameMode = Mode.ONLINE_ARENA;
            MultiplayerManager.GameInstance.CustomModeObj = new ArenaMode(MultiplayerManager.GameInstance,{"arenaModeID":m_roomData.matchSettings.arenaModeID},{"classAPI":ResourceManager.getResourceByID("arena_mode").getProp("mode")});
            MultiplayerManager.m_game = MultiplayerManager.GameInstance.CustomModeObj.GameInstance;
            ResourceManager.queueResources([MultiplayerManager.GameInstance.LevelData.stage]);
         }
         if(m_roomData.matchSettings.levelData.musicOverride)
         {
            ResourceManager.queueResources([m_roomData.matchSettings.levelData.musicOverride]);
         }
         ResourceManager.load({"oncomplete":onMatchReady});
      }
      
      private static function onMatchReady() : void
      {
         m_matchReady = true;
      }
      
      private static function handlemgn_MATCH_END(param1:MGNEvent) : void
      {
         m_matchEnded = true;
      }
      
      private static function handlemgn_DISCONNECT(param1:MGNEvent) : void
      {
         reset();
      }
      
      private static function handlemgn_MATCH_FINISHED(param1:MGNEvent) : void
      {
         m_matchReady = false;
         trace("Match end signal received from other player.");
      }
      
      public static function toWaitingRoom(param1:Game, param2:Function) : void
      {
         param1.LevelData.randSeed = Math.round(Math.random() * 1000000 + 1);
         param1.PlayerSettings[0].socket_id = m_onlineInterface.SocketID;
         GameController.onlineModeMatchSettings = param1.exportSettings();
         GameController.onlineModeMatchSettings.gameMode = param1.GameMode;
         GameController.onlineModeMatchSettings.arenaModeID = ArenaModeMenu.SELECTED_ARENA_MODE;
         param1.GameMode = Mode.ONLINE_WAITING_ROOM;
         param1.LevelData.stage = "waitingroom";
         param1.LevelData.usingLives = false;
         param1.LevelData.usingTime = false;
         param1.LevelData.usingStamina = false;
         param1.LevelData.teams = false;
         param1.LevelData.showEntrances = false;
         param1.PlayerSettings.push(new PlayerSetting());
         param1.PlayerSettings[1].exist = true;
         param1.PlayerSettings[1].character = "sandbag";
         param1.PlayerSettings[0].team = -1;
         param1.PlayerSettings[1].team = -1;
         Utils.setRandSeed(param1.LevelData.randSeed);
         Utils.shuffleRandom();
         Main.prepRandomCharacters(param1.PlayerSettings.length);
         if(param1.PlayerSettings[0].character == "random")
         {
            GameController.onlineModeMatchSettings.playerSettings[0].character = Main.RandCharList[0].StatsName;
            param1.PlayerSettings[0].character = GameController.onlineModeMatchSettings.playerSettings[0].character;
            param1.PlayerSettings[0].isRandom = true;
            GameController.onlineModeMatchSettings.playerSettings[0].isRandom = true;
         }
         ResourceManager.queueResources([param1.LevelData.stage]);
         ResourceManager.queueResources(["sandbag"]);
         var _loc3_:int = 1;
         while(_loc3_ <= param1.PlayerSettings.length)
         {
            if(Boolean(param1.PlayerSettings[_loc3_ - 1] && param1.PlayerSettings[_loc3_ - 1].exist) && Boolean(param1.PlayerSettings[_loc3_ - 1].character != null) && param1.PlayerSettings[_loc3_ - 1].character != "xp")
            {
               ResourceManager.queueResources([param1.PlayerSettings[_loc3_ - 1].character == "random" ? Main.RandCharList[_loc3_ - 1].StatsName : param1.PlayerSettings[_loc3_ - 1].character]);
            }
            _loc3_++;
         }
         ResourceManager.load({"oncomplete":param2});
      }
      
      public static function PERFORMALL() : void
      {
         if(Active)
         {
            m_onlineInterface.PERFORMALL();
            updateControls();
         }
      }
   }
}


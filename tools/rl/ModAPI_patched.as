package com.mcleodgaming.ssf2.modapi
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.api.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.AI;
   import com.mcleodgaming.ssf2.engine.Character;
   import com.mcleodgaming.ssf2.engine.GameTimer;
   import com.mcleodgaming.ssf2.engine.Projectile;
   import com.mcleodgaming.ssf2.engine.StageData;
   import com.mcleodgaming.ssf2.enums.Mode;
   import com.mcleodgaming.ssf2.input.*;
   import com.mcleodgaming.ssf2.items.Item;
   import com.mcleodgaming.ssf2.platforms.Platform;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.ServerSocketConnectEvent;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.net.ServerSocket;
   import flash.net.Socket;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.ByteArray;
   import flash.utils.Endian;

   /**
    * ModAPI + RL research bridge.
    *
    * RL additions (research fork only):
    * - A localhost TCP server (default port 4567) that streams one JSON state
    *   snapshot per game frame (newline-delimited JSON).
    * - Accepts JSON commands to inject inputs into CPU-controlled characters
    *   via the engine's built-in AI control-override queue (the same mechanism
    *   used by the replay/confusion systems), or to take over any player slot.
    *
    * Protocol (newline-delimited JSON):
    *   game -> client: {"type":"hello",...}
    *   game -> client: {"type":"state","frame":N,"paused":0,"ended":0,"chars":[...]}
    *   client -> game: {"type":"input","player":2,"bits":1234}
    *   client -> game: {"type":"takeover","player":1}   (convert slot to CPU + control it)
    *   client -> game: {"type":"ping"}  -> {"type":"pong"}
   *   client -> game: {"type":"state"} -> immediate extra snapshot
   *   client -> game: {"type":"pause","request":N} -> acknowledged paused snapshot
   *   client -> game: {"type":"step","request":N} -> one tick, then paused step_complete
   *   client -> game: {"type":"step_sync","request":N} -> immediately pump one tick
   *   client -> game: {"type":"resume","request":N} -> acknowledged normal simulation
   *   client -> game: {"type":"restart_match","request":N,"config":{}}
   *       -> {"type":"restart_accepted","request":N,"generation":G}
   *       -> {"type":"match_ready","request":N,"generation":G,"state":{...}}
    */
   public class ModAPI
   {

      private static var _api:StageData;

      public static const VERSION_MAJOR:int = 0;

      public static const VERSION_MINOR:int = 3;

      public static const VERSION_REVISION:int = 0;

      private static var _isInitialized:Boolean = false;

      // ========== RL BRIDGE STATE ==========
      private static var _rlServer:ServerSocket = null;

      private static var _rlClient:Socket = null;

      private static var _rlPort:int = 4567;

      private static var _rlRecvBuffer:String = "";

      private static var _rlStateCount:int = 0;

      private static var _rlStateTransport:String = "json";

      private static var _rlBinaryBuffer:ByteArray = new ByteArray();

      // Controls overlay: shows the held control bits for one player slot.
      // _rlOverlayPlayer == 0 means disabled.
      private static var _rlOverlay:TextField = null;

      private static var _rlOverlayPlayer:int = 0;

      // Bit names matching python/ssf2_rl/controls.py (index i = bit 1<<i).
      private static const RL_BIT_NAMES:Array = [
         "TAP_JUMP","SHIELD","TAUNT","START","GRAB","ATTACK","SPECIAL","JUMP",
         "RIGHT","LEFT","DOWN","UP","DT_DASH","AUTO_DASH","DASH",
         "C_RIGHT","C_LEFT","C_DOWN","C_UP","JUMP2","SHIELD2","JUMP3"
      ];

      // Lockstep is opt-in for an external client. While enabled, pause and
      // step commands use StageData's silent research pause, never the normal
      // user pause lifecycle. A pending step is completed in rlOnTick(),
      // which re-pauses before the post-step snapshot is built.
      private static var _rlLockstep:Boolean = false;

      private static var _rlPauseAfterTick:Boolean = false;

      private static var _rlStepRequest:int = -1;

      private static var _rlMatchGeneration:int = 0;

      private static var _rlRestartPending:Boolean = false;

      private static var _rlRestartRequest:int = -1;

      private static var _rlRestartConfig:Object = null;

      public function ModAPI()
      {
         super();
      }

      public static function init(param1:StageData) : void
      {
         trace("[ENGINE ModAPI] init() called with api=" + param1);
         _api = param1;
         _isInitialized = true;
         _rlMatchGeneration++;
         trace("[ENGINE ModAPI] init() - _api assigned, _isInitialized = true");
         trace("SSF2 Mod API Version " + VERSION_MAJOR + "." + VERSION_MINOR + "." + VERSION_REVISION + " initialized.");
         rlAttach();
      }

      public static function deinit() : void
      {
         trace("[ENGINE ModAPI] deinit() called");
         if(Boolean(_api) && Boolean(_api.ResearchPaused))
         {
            _api.setResearchPaused(false);
         }
         _rlLockstep = false;
         _rlPauseAfterTick = false;
         _rlStepRequest = -1;
         rlDetach();
         _api = null;
         _isInitialized = false;
         trace("[ENGINE ModAPI] deinit() - _api cleared, _isInitialized = false");
         trace("ModAPI deactivated.");
      }

      public static function getAPIVersion() : String
      {
         return VERSION_MAJOR + "." + VERSION_MINOR + "." + VERSION_REVISION;
      }

      public static function isReady() : Boolean
      {
         return Boolean(_api) && Boolean(_isInitialized) && Boolean(_api.ActiveScripts);
      }

      public static function print(param1:String) : void
      {
         if(Boolean(Main.DEBUG) && Boolean(MenuController.debugConsole))
         {
            MenuController.debugConsole.writeTextData("[ModAPI] " + param1);
         }
      }

      public static function getEngineAPI() : StageData
      {
         if(!isReady())
         {
            print("Warning: Attempted to access engine API while ModAPI not initialized");
            return null;
         }
         return _api;
      }

      public static function getSSF2API() : Class
      {
         return SSF2API;
      }

      public static function playMusicWithFadeOut(param1:String, param2:Number, param3:Number = 2000) : void
      {
         if(!isReady())
         {
            print("Error: Cannot play music with fade-out - ModAPI not ready");
            return;
         }
         SoundQueue.instance.playMusicWithFadeOut(param1,param2,param3);
      }

      public static function startImmediateFadeOut(param1:Number = 2000) : void
      {
         if(!isReady())
         {
            return;
         }
         SoundQueue.instance.startImmediateFadeOut(param1);
      }

      public static function isMusicFadingOut() : Boolean
      {
         if(!isReady())
         {
            return false;
         }
         return SoundQueue.instance.isFadeOutEnabled();
      }

      public static function playPitchShiftedEffect(param1:String, param2:Number = 1, param3:Number = 1) : Boolean
      {
         if(!isReady())
         {
            print("Error: Cannot play pitch-shifted effect - ModAPI not ready");
            return false;
         }
         return SoundQueue.instance.playPitchShiftedEffect(param1,param2,param3);
      }

      public static function updatePitchShift(param1:Number) : void
      {
         if(!isReady())
         {
            return;
         }
         SoundQueue.instance.updatePitchShift(param1);
      }

      public static function updatePitchShiftVolume(param1:Number) : void
      {
         if(!isReady())
         {
            return;
         }
         SoundQueue.instance.updatePitchShiftVolume(param1);
      }

      public static function stopPitchShiftedEffect() : void
      {
         if(!isReady())
         {
            return;
         }
         SoundQueue.instance.stopPitchShiftedEffect();
      }

      public static function isPitchShiftedEffectPlaying() : Boolean
      {
         if(!isReady())
         {
            return false;
         }
         return SoundQueue.instance.isPitchShiftedEffectPlaying();
      }

      public static function rumbleController(param1:*, param2:Number, param3:Number, param4:int) : void
      {
         var _loc5_:int = 0;
         var _loc8_:MovieClip = null;
         if(!isReady())
         {
            return;
         }
         if(param1 is SSF2Character)
         {
            _loc5_ = int(SSF2Character(param1).getUID());
         }
         else if(param1 is MovieClip)
         {
            _loc8_ = MovieClip(param1);
            if(_loc8_.uid != undefined)
            {
               _loc5_ = int(_loc8_.uid);
            }
            else
            {
               if(!(Boolean(_loc8_.parent) && _loc8_.parent.uid != undefined))
               {
                  print("Warning: Cannot resolve UID from MovieClip " + _loc8_);
                  return;
               }
               _loc5_ = int(_loc8_.parent.uid);
            }
         }
         else
         {
            _loc5_ = int(param1);
         }
         var _loc6_:Character = _api.getCharacterByUID(_loc5_);
         if(!_loc6_)
         {
            print("Warning: Character with UID " + _loc5_ + " not found for rumble");
            return;
         }
         var _loc7_:int = _loc6_.ID;
         if(_loc7_ <= 0)
         {
            return;
         }
         Gamepad.rumbleForPlayer(_loc7_,param2,param3,param4);
      }

      public static function stopRumble(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc4_:MovieClip = null;
         if(!isReady())
         {
            return;
         }
         if(param1 is SSF2Character)
         {
            _loc2_ = int(SSF2Character(param1).getUID());
         }
         else if(param1 is MovieClip)
         {
            _loc4_ = MovieClip(param1);
            if(_loc4_.uid != undefined)
            {
               _loc2_ = int(_loc4_.uid);
            }
            else
            {
               if(!(Boolean(_loc4_.parent) && _loc4_.parent.uid != undefined))
               {
                  print("Warning: Cannot resolve UID from MovieClip " + _loc4_);
                  return;
               }
               _loc2_ = int(_loc4_.parent.uid);
            }
         }
         else
         {
            _loc2_ = int(param1);
         }
         var _loc3_:Character = _api.getCharacterByUID(_loc2_);
         if(!_loc3_ || _loc3_.ID <= 0)
         {
            return;
         }
         Gamepad.rumbleForPlayer(_loc3_.ID,0,0,0);
      }

      public static function supportsRumble(param1:*) : Boolean
      {
         var _loc2_:int = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:int = 0;
         var _loc6_:Gamepad = null;
         if(!isReady())
         {
            return false;
         }
         if(param1 is SSF2Character)
         {
            _loc2_ = int(SSF2Character(param1).getUID());
         }
         else if(param1 is MovieClip)
         {
            _loc4_ = MovieClip(param1);
            if(_loc4_.uid != undefined)
            {
               _loc2_ = int(_loc4_.uid);
            }
            else
            {
               if(!(Boolean(_loc4_.parent) && _loc4_.parent.uid != undefined))
               {
                  print("Warning: Cannot resolve UID from MovieClip " + _loc4_);
                  return false;
               }
               _loc2_ = int(_loc4_.parent.uid);
            }
         }
         else
         {
            _loc2_ = int(param1);
         }
         var _loc3_:Character = _api.getCharacterByUID(_loc2_);
         if(!_loc3_ || _loc3_.ID <= 0)
         {
            return false;
         }
         try
         {
            _loc5_ = _loc3_.ID - 1;
            if(Boolean(SaveData.Controllers && _loc5_ >= 0) && Boolean(_loc5_ < SaveData.Controllers.length) && Boolean(SaveData.Controllers[_loc5_]))
            {
               _loc6_ = SaveData.Controllers[_loc5_].GamepadInstance;
               if(_loc6_ != null)
               {
                  return _loc6_.supportsRumble();
               }
            }
         }
         catch(e:Error)
         {
         }
         return false;
      }

      public static function isRumbleEnabled() : Boolean
      {
         if(!isReady())
         {
            return false;
         }
         return Gamepad.getGlobalRumbleEnabled();
      }

      public static function stopTime(param1:*, param2:int = -1, param3:int = 0, param4:int = 2147483646, param5:Object = null) : void
      {
         var _loc6_:int = 0;
         var _loc8_:MovieClip = null;
         if(!isReady())
         {
            return;
         }
         if(param1 is SSF2Character)
         {
            _loc6_ = int(SSF2Character(param1).getUID());
         }
         else if(param1 is MovieClip)
         {
            _loc8_ = MovieClip(param1);
            if(_loc8_.uid != undefined)
            {
               _loc6_ = int(_loc8_.uid);
            }
            else
            {
               if(!(Boolean(_loc8_.parent) && _loc8_.parent.uid != undefined))
               {
                  print("Warning: Cannot resolve UID from MovieClip " + _loc8_);
                  return;
               }
               _loc6_ = int(_loc8_.parent.uid);
            }
         }
         else
         {
            _loc6_ = int(param1);
         }
         var _loc7_:Character = _api.getCharacterByUID(_loc6_);
         if(!_loc7_)
         {
            return;
         }
         if(param3 < 0)
         {
            return;
         }
         if(param4 >= int.MAX_VALUE)
         {
            return;
         }
         _loc7_.stopTime(param2,param3,param4,param5);
      }

      public static function resumeTime(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc4_:MovieClip = null;
         if(!isReady())
         {
            return;
         }
         if(param1 is SSF2Character)
         {
            _loc2_ = int(SSF2Character(param1).getUID());
         }
         else if(param1 is MovieClip)
         {
            _loc4_ = MovieClip(param1);
            if(_loc4_.uid != undefined)
            {
               _loc2_ = int(_loc4_.uid);
            }
            else
            {
               if(!(Boolean(_loc4_.parent) && _loc4_.parent.uid != undefined))
               {
                  print("Warning: Cannot resolve UID from MovieClip " + _loc4_);
                  return;
               }
               _loc2_ = int(_loc4_.parent.uid);
            }
         }
         else
         {
            _loc2_ = int(param1);
         }
         var _loc3_:Character = _api.getCharacterByUID(_loc2_);
         if(!_loc3_)
         {
            return;
         }
         _loc3_.resumeTime();
      }

      public static function applyTimeFreeze(param1:*, param2:int = -1) : void
      {
         var _loc3_:int = 0;
         var _loc5_:MovieClip = null;
         if(!isReady())
         {
            return;
         }
         if(param1 is SSF2Character)
         {
            _loc3_ = int(SSF2Character(param1).getUID());
         }
         else if(param1 is MovieClip)
         {
            _loc5_ = MovieClip(param1);
            if(_loc5_.uid != undefined)
            {
               _loc3_ = int(_loc5_.uid);
            }
            else
            {
               if(!(Boolean(_loc5_.parent) && _loc5_.parent.uid != undefined))
               {
                  print("Warning: Cannot resolve UID from MovieClip " + _loc5_);
                  return;
               }
               _loc3_ = int(_loc5_.parent.uid);
            }
         }
         else
         {
            _loc3_ = int(param1);
         }
         var _loc4_:Character = _api.getCharacterByUID(_loc3_);
         if(!_loc4_)
         {
            return;
         }
         if(_api.InTimeStop)
         {
            return;
         }
         _loc4_.applyTimeFreeze(param2);
      }

      public static function removeTimeFreeze(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc4_:MovieClip = null;
         if(!isReady())
         {
            return;
         }
         if(param1 is SSF2Character)
         {
            _loc2_ = int(SSF2Character(param1).getUID());
         }
         else if(param1 is MovieClip)
         {
            _loc4_ = MovieClip(param1);
            if(_loc4_.uid != undefined)
            {
               _loc2_ = int(_loc4_.uid);
            }
            else
            {
               if(!(Boolean(_loc4_.parent) && _loc4_.parent.uid != undefined))
               {
                  print("Warning: Cannot resolve UID from MovieClip " + _loc4_);
                  return;
               }
               _loc2_ = int(_loc4_.parent.uid);
            }
         }
         else
         {
            _loc2_ = int(param1);
         }
         var _loc3_:Character = _api.getCharacterByUID(_loc2_);
         if(!_loc3_)
         {
            return;
         }
         if(_api.InTimeStop)
         {
            return;
         }
         _loc3_.removeTimeFreeze();
      }

      public static function triggerMenuRumble(param1:int) : void
      {
         var _loc2_:Gamepad = null;
         if(Boolean(Gamepad.getGlobalRumbleEnabled()) && Boolean(SaveData.getRumbleEnabled(param1 + 1)))
         {
            _loc2_ = SaveData.Controllers[param1].GamepadInstance;
            if(_loc2_ != null)
            {
               _loc2_.setRumble(0.4,0.4,100);
            }
         }
      }

      public static function stopMenuRumble() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < SaveData.Controllers.length)
         {
            if(Boolean(SaveData.Controllers[_loc1_]) && Boolean(SaveData.Controllers[_loc1_].GamepadInstance))
            {
               SaveData.Controllers[_loc1_].GamepadInstance.setRumble(0,0,1);
            }
            _loc1_++;
         }
      }

      // ========== RL RESEARCH BRIDGE ==========

      /**
       * Set the TCP port used by the RL bridge (only takes effect before the
       * first match starts / before the server is bound).
       */
      public static function setRLPort(param1:int) : void
      {
         if(_rlServer == null)
         {
            _rlPort = param1;
         }
      }

      public static function getRLPort() : int
      {
         return _rlPort;
      }

      /** Start the loopback bridge before a StageData instance exists. */
      public static function rlBootstrapBridge() : void
      {
         if(_rlServer != null)
         {
            return;
         }
         rlStartServer();
         if(_rlServer == null && Boolean(Main.Root) && Boolean(Main.Root.stage))
         {
            Main.Root.stage.addEventListener(Event.ENTER_FRAME,rlEnsureServerStarted);
         }
      }

      private static function rlEnsureServerStarted(param1:Event) : void
      {
         if(_rlServer == null)
         {
            rlStartServer();
         }
         if(_rlServer != null && Boolean(Main.Root) && Boolean(Main.Root.stage))
         {
            Main.Root.stage.removeEventListener(Event.ENTER_FRAME,rlEnsureServerStarted);
         }
      }

      /**
       * Attach the RL bridge to the current match: lazily start the TCP server
       * and subscribe to per-frame tick events. Called from init().
       *
       * NOTE: ModAPI.init() runs early in the StageData constructor, before
       * m_eventManager exists, so tick subscription is deferred to the first
       * ENTER_FRAME via rlEnsureAttached().
       */
      private static function rlAttach() : void
      {
         rlBootstrapBridge();
         if(Boolean(Main.Root) && Boolean(Main.Root.stage))
         {
            // Adding the same listener twice is a no-op in Flash, so no guard needed.
            Main.Root.stage.addEventListener(Event.ENTER_FRAME,rlEnsureAttached);
         }
      }

      private static function rlEnsureAttached(param1:Event) : void
      {
         if(!Boolean(_api) || !Boolean(_api.EventManagerObj))
         {
            return;
         }
         // Retry the server bind until it succeeds (it can fail transiently at
         // startup). Only stop listening once the server is actually up.
         if(_rlServer == null)
         {
            rlStartServer();
            if(_rlServer == null)
            {
               return;
            }
         }
         if(Boolean(Main.Root) && Boolean(Main.Root.stage))
         {
            Main.Root.stage.removeEventListener(Event.ENTER_FRAME,rlEnsureAttached);
            Main.Root.stage.removeEventListener(Event.ENTER_FRAME,rlEnsureServerStarted);
         }
         if(!_api.EventManagerObj.hasEvent(SSF2Event.GAME_TICK_END,rlOnTick))
         {
            _api.EventManagerObj.addEventListener(SSF2Event.GAME_TICK_END,rlOnTick);
            _api.EventManagerObj.addEventListener(SSF2Event.GAME_ENDED,rlOnGameEnded);
            trace("[ModAPI RL] Attached to match tick events.");
         }
      }

      /** Retry the menu-time server bind until it succeeds. */
      private static function rlEnsureBootstrap(param1:Event) : void
      {
         if(_rlServer == null)
         {
            rlStartServer();
         }
         if(_rlServer != null && Boolean(Main.Root) && Boolean(Main.Root.stage))
         {
            Main.Root.stage.removeEventListener(Event.ENTER_FRAME,rlEnsureBootstrap);
         }
      }

      /**
       * Detach tick listeners for the current match (socket stays open so the
       * external agent can wait across matches). Called from deinit().
       */
      private static function rlDetach() : void
      {
         if(Boolean(Main.Root) && Boolean(Main.Root.stage))
         {
            Main.Root.stage.removeEventListener(Event.ENTER_FRAME,rlEnsureAttached);
         }
         if(Boolean(_api) && Boolean(_api.EventManagerObj) && _api.EventManagerObj.hasEvent(SSF2Event.GAME_TICK_END,rlOnTick))
         {
            _api.EventManagerObj.removeEventListener(SSF2Event.GAME_TICK_END,rlOnTick);
            _api.EventManagerObj.removeEventListener(SSF2Event.GAME_ENDED,rlOnGameEnded);
            trace("[ModAPI RL] Detached from match tick events.");
         }
         rlSend({"type":"match_end"});
      }

      private static function rlStartServer() : void
      {
         try
         {
            _rlServer = new ServerSocket();
            _rlServer.addEventListener(ServerSocketConnectEvent.CONNECT,rlOnConnect);
            _rlServer.addEventListener(IOErrorEvent.IO_ERROR,rlOnServerError);
            _rlServer.addEventListener(SecurityErrorEvent.SECURITY_ERROR,rlOnServerError);
            _rlServer.bind(_rlPort,"127.0.0.1");
            _rlServer.listen();
            trace("[ModAPI RL] RL bridge listening on 127.0.0.1:" + _rlPort);
         }
         catch(e:Error)
         {
            // Transient bind failures (e.g. socket not ready yet at startup).
            // Null it out so rlEnsureAttached() retries on a later frame.
            trace("[ModAPI RL] Failed to start RL server: " + e.message + " - will retry.");
            _rlServer = null;
         }
      }

      private static function rlOnServerError(param1:Event) : void
      {
         trace("[ModAPI RL] Server socket error: " + param1.toString());
      }

      private static function rlOnConnect(param1:ServerSocketConnectEvent) : void
      {
         var _loc2_:Socket = _rlClient;
         if(_loc2_ != null)
         {
            _loc2_.removeEventListener(ProgressEvent.SOCKET_DATA,rlOnData);
            _loc2_.removeEventListener(Event.CLOSE,rlOnClientClose);
            _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,rlOnClientError);
            try
            {
               _loc2_.close();
            }
            catch(e:Error)
            {
            }
         }
         _rlClient = param1.socket;
         _rlRecvBuffer = "";
         _rlStateCount = 0;
         _rlStateTransport = "json";
         _rlClient.addEventListener(ProgressEvent.SOCKET_DATA,rlOnData);
         _rlClient.addEventListener(Event.CLOSE,rlOnClientClose);
         _rlClient.addEventListener(IOErrorEvent.IO_ERROR,rlOnClientError);
         trace("[ModAPI RL] External agent connected.");
         // Poll the socket on ENTER_FRAME: SOCKET_DATA is frame-gated, and
         // rlOnTick only fires during unpaused game ticks. Without this,
         // a silently-paused game can't see step commands for ~10-15ms.
         if(Boolean(Main.Root) && Boolean(Main.Root.stage))
         {
            Main.Root.stage.addEventListener(Event.ENTER_FRAME,rlPollSocket);
         }
         rlSend({"type":"hello","api":getAPIVersion(),"port":_rlPort,"framerate":Main.FRAMERATE,"stateTransports":["json","binary-v3"]});
      }

      /** Read pending socket data on every render frame (even when paused). */
      private static function rlPollSocket(param1:Event) : void
      {
         if(_rlClient == null || !_rlClient.connected)
         {
            rlRemoveSocketPoll();
            return;
         }
         if(_rlClient.bytesAvailable > 0)
         {
            rlOnData(null);
         }
      }

      /** Detach the ENTER_FRAME socket poll (called on client close/error). */
      private static function rlRemoveSocketPoll() : void
      {
         if(Boolean(Main.Root) && Boolean(Main.Root.stage))
         {
            Main.Root.stage.removeEventListener(Event.ENTER_FRAME,rlPollSocket);
         }
      }

      private static function rlOnClientClose(param1:Event) : void
      {
         if(param1.currentTarget !== _rlClient)
         {
            return;
         }
         trace("[ModAPI RL] External agent disconnected.");
         rlRemoveSocketPoll();
         if(isReady() && _rlLockstep && _api.ResearchPaused)
         {
            _api.setResearchPaused(false);
         }
         _rlLockstep = false;
         _rlPauseAfterTick = false;
         _rlStepRequest = -1;
         _rlClient = null;
      }

      private static function rlOnClientError(param1:Event) : void
      {
         if(param1.currentTarget !== _rlClient)
         {
            return;
         }
         trace("[ModAPI RL] Client socket error: " + param1.toString());
         rlRemoveSocketPoll();
         if(isReady() && _rlLockstep && _api.ResearchPaused)
         {
            _api.setResearchPaused(false);
         }
         _rlLockstep = false;
         _rlPauseAfterTick = false;
         _rlStepRequest = -1;
         _rlClient = null;
      }

      private static function rlSend(param1:Object) : void
      {
         var _loc2_:Socket = _rlClient;
         if(_loc2_ == null || !_loc2_.connected)
         {
            return;
         }
         try
         {
            _loc2_.writeUTFBytes(JSON.stringify(param1) + "\n");
            _loc2_.flush();
         }
         catch(e:Error)
         {
            if(_rlClient === _loc2_)
            {
               _rlClient = null;
            }
         }
      }

      /** Write one fixed-width schema-3 state without allocating JSON objects. */
      private static function rlSendBinaryState(param1:int, param2:int) : void
      {
         var _loc3_:Socket = _rlClient;
         if(_loc3_ == null || !_loc3_.connected || !isReady())
         {
            return;
         }
         var _loc4_:ByteArray = _rlBinaryBuffer;
         _loc4_.clear();
         _loc4_.endian = Endian.BIG_ENDIAN;
         _loc4_.writeUnsignedInt(0x524C4233);
         _loc4_.writeByte(param1);
         _loc4_.writeByte(3);
         _loc4_.writeShort(0);
         _loc4_.writeUnsignedInt(0);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(_rlMatchGeneration);
         _loc4_.writeInt(_api.ElapsedFrames);
         _loc4_.writeByte(_api.Paused ? 1 : 0);
         _loc4_.writeByte(_api.GameEnded ? 1 : 0);
         var _loc5_:* = _api.Characters;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_.length)
         {
            if(_loc5_[_loc7_])
            {
               _loc6_++;
            }
            _loc7_++;
         }
         _loc4_.writeByte(_loc6_);
         _loc4_.writeByte(0);
         _loc7_ = 0;
         while(_loc7_ < _loc5_.length)
         {
            var _loc8_:Character = _loc5_[_loc7_];
            if(_loc8_)
            {
               var _loc9_:String = _loc8_.getCurrentAttackFrame();
               var _loc10_:int = 0;
               _loc10_ |= _loc8_.Shielding ? 1 : 0;
               _loc10_ |= _loc8_.isHitStunOrParalysis() ? 2 : 0;
               _loc10_ |= _loc9_ != null ? 4 : 0;
               _loc10_ |= _loc8_.Hanging ? 8 : 0;
               _loc10_ |= _loc8_.Dead ? 16 : 0;
               _loc4_.writeInt(_loc8_.ID);
               _loc4_.writeFloat(_loc8_.X);
               _loc4_.writeFloat(_loc8_.Y);
               _loc4_.writeFloat(_loc8_.netXSpeed());
               _loc4_.writeFloat(_loc8_.netYSpeed());
               _loc4_.writeByte(_loc8_.FacingRight ? 1 : 0);
               _loc4_.writeFloat(_loc8_.getDamage());
               _loc4_.writeShort(Boolean(_loc8_.getMatchResults()) ? int(_loc8_.getMatchResults().StockRemaining) : int(_loc8_.getLives()));
               _loc4_.writeByte(Boolean(_loc8_.CollisionObj) && Boolean(_loc8_.CollisionObj.ground) ? 1 : 0);
               _loc4_.writeShort(_loc8_.JumpCount);
               _loc4_.writeFloat(_loc8_.ShieldPower);
               _loc4_.writeShort(_loc10_);
               _loc4_.writeFloat(_loc9_ != null ? _loc8_.getExecTime() : 0);
               _loc4_.writeInt(_loc8_.getControlBitsAPI(false));
            }
            _loc7_++;
         }
         var _loc11_:uint = _loc4_.length - 12;
         _loc4_.position = 8;
         _loc4_.writeUnsignedInt(_loc11_);
         _loc4_.position = 0;
         try
         {
            _loc3_.writeBytes(_loc4_);
            _loc3_.flush();
         }
         catch(e:Error)
         {
            if(_rlClient === _loc3_)
            {
               _rlClient = null;
            }
         }
      }

      private static function rlOnData(param1:ProgressEvent) : void
      {
         if(_rlClient == null || (param1 != null && param1.currentTarget !== _rlClient))
         {
            return;
         }
         try
         {
            _rlRecvBuffer = _rlRecvBuffer + _rlClient.readUTFBytes(_rlClient.bytesAvailable);
         }
         catch(e:Error)
         {
            return;
         }
         var _loc2_:int = _rlRecvBuffer.indexOf("\n");
         while(_loc2_ >= 0)
         {
            var _loc3_:String = _rlRecvBuffer.substring(0,_loc2_);
            _rlRecvBuffer = _rlRecvBuffer.substring(_loc2_ + 1);
            if(_loc3_.length > 0)
            {
               rlHandleLine(_loc3_);
            }
            _loc2_ = _rlRecvBuffer.indexOf("\n");
         }
      }

      private static function rlHandleLine(param1:String) : void
      {
         var _loc2_:Object = null;
         try
         {
            _loc2_ = JSON.parse(param1);
         }
         catch(e:Error)
         {
            trace("[ModAPI RL] Bad JSON from agent: " + param1);
            return;
         }
         if(!_loc2_ || _loc2_.type == undefined)
         {
            return;
         }
         var _loc3_:String = String(_loc2_.type);
         if(_loc3_ == "input")
         {
            rlInjectInput(int(_loc2_.player),int(_loc2_.bits));
         }
         else if(_loc3_ == "takeover")
         {
            rlTakeOver(int(_loc2_.player));
         }
         else if(_loc3_ == "ping")
         {
            rlSend({"type":"pong"});
         }
         else if(_loc3_ == "overlay")
         {
            rlSetOverlay(int(_loc2_.player));
         }
         else if(_loc3_ == "state")
         {
            if(isReady())
            {
               rlSend(rlBuildMinimalState());
            }
         }
         else if(_loc3_ == "state_full")
         {
            if(isReady())
            {
               rlSend({"type":"full_state","request":int(_loc2_.request),"state":rlBuildFullState()});
            }
         }
         else if(_loc3_ == "configure_transport")
         {
            var _loc4_:String = String(_loc2_.transport);
            if(_loc4_ != "json" && _loc4_ != "binary-v3")
            {
               rlSend({"type":"error","request":int(_loc2_.request),"command":"configure_transport","message":"unsupported state transport"});
            }
            else
            {
               rlSend({"type":"ack","request":int(_loc2_.request),"command":"configure_transport","transport":_loc4_});
               _rlStateTransport = _loc4_;
            }
         }
         else if(_loc3_ == "restart_match")
         {
            rlRestartMatch(_loc2_.config is Object ? _loc2_.config : null,int(_loc2_.request));
         }
         else if(_loc3_ == "pause")
         {
            rlPause(int(_loc2_.request));
         }
         else if(_loc3_ == "step")
         {
            rlStep(int(_loc2_.request));
         }
         else if(_loc3_ == "step_sync")
         {
            rlStepSync(int(_loc2_.request));
         }
         else if(_loc3_ == "resume")
         {
            rlResume(int(_loc2_.request));
         }
      }

      /** Silently pause simulation and return an acknowledged paused snapshot. */
      private static function rlPause(param1:int) : void
      {
         if(!isReady())
         {
            rlSend({"type":"error","request":param1,"command":"pause","message":"game is not ready"});
            return;
         }
         if(_api.Paused && !_api.ResearchPaused)
         {
            rlSend({"type":"error","request":param1,"command":"pause","message":"normal user pause is active"});
            return;
         }
         _rlLockstep = true;
         _rlPauseAfterTick = false;
         _rlStepRequest = -1;
         if(!_api.ResearchPaused)
         {
            _api.setResearchPaused(true);
         }
         rlSend({"type":"ack","request":param1,"command":"pause","state":rlBuildMinimalState()});
      }

      /** Permit exactly one game tick; rlOnTick() re-pauses and completes it. */
      private static function rlStep(param1:int) : void
      {
         if(!isReady() || !_rlLockstep || !_api.ResearchPaused || _rlPauseAfterTick)
         {
            rlSend({"type":"error","request":param1,"command":"step","message":"step requires an idle lockstep pause"});
            return;
         }
         _rlStepRequest = param1;
         _rlPauseAfterTick = true;
         _api.setResearchPaused(false);
      }

      /** Pump one simulation frame immediately instead of waiting for render. */
      private static function rlStepSync(param1:int) : void
      {
         if(!isReady() || !_rlLockstep || !_api.ResearchPaused || _rlPauseAfterTick)
         {
            rlSend({"type":"error","request":param1,"command":"step_sync","message":"step requires an idle lockstep pause"});
            return;
         }
         _rlStepRequest = param1;
         _rlPauseAfterTick = true;
         if(!_api.stepResearchFrame())
         {
            _rlPauseAfterTick = false;
            _rlStepRequest = -1;
            _api.setResearchPaused(true);
            rlSend({"type":"error","request":param1,"command":"step_sync","message":"research frame could not run"});
            return;
         }
         if(_rlPauseAfterTick)
         {
            _rlPauseAfterTick = false;
            _rlStepRequest = -1;
            _api.setResearchPaused(true);
            rlSend({"type":"error","request":param1,"command":"step_sync","message":"research frame completed without a tick event"});
         }
      }

      /** Leave lockstep mode and resume normal simulation. */
      private static function rlResume(param1:int) : void
      {
         if(!isReady())
         {
            rlSend({"type":"error","request":param1,"command":"resume","message":"game is not ready"});
            return;
         }
         _rlPauseAfterTick = false;
         _rlStepRequest = -1;
         _rlLockstep = false;
         if(_api.ResearchPaused)
         {
            _api.setResearchPaused(false);
         }
         rlSend({"type":"ack","request":param1,"command":"resume","state":rlBuildMinimalState()});
      }

      /**
       * Per-frame tick handler: stream a state snapshot to the connected agent.
       */
      private static function rlOnTick(param1:Event) : void
      {
         if(_rlClient == null || !_rlClient.connected)
         {
            return;
         }
         // Poll the socket directly: AIR's ProgressEvent.SOCKET_DATA is
         // frame-gated and adds ~13ms per round-trip. Reading here lets us
         // process commands immediately on the sim tick.
         if(_rlClient.bytesAvailable > 0)
         {
            rlOnData(null);
         }
         rlUpdateOverlay();
         _rlStateCount++;
         if(_rlPauseAfterTick)
         {
            var _loc2_:int = _rlStepRequest;
            _rlPauseAfterTick = false;
            _rlStepRequest = -1;
            _api.setResearchPaused(true);
            if(_rlStateTransport == "binary-v3")
            {
               rlSendBinaryState(2,_loc2_);
            }
            else
            {
               var _loc3_:Object = rlBuildMinimalState();
               rlSend({"type":"step_complete","request":_loc2_,"state":_loc3_});
            }
            return;
         }
         var _loc4_:Object = null;
         if(_rlStateTransport == "binary-v3")
         {
            rlSendBinaryState(1,-1);
         }
         else
         {
            _loc4_ = rlBuildMinimalState();
            rlSend(_loc4_);
         }
         if(_rlRestartPending)
         {
            if(_loc4_ == null)
            {
               _loc4_ = rlBuildMinimalState();
            }
            rlSend({"type":"match_ready","request":_rlRestartRequest,"generation":_rlMatchGeneration,"config":_rlRestartConfig,"metadata":rlBuildMatchMetadata(),"state":_loc4_});
            _rlRestartPending = false;
            _rlRestartRequest = -1;
            _rlRestartConfig = null;
         }
      }

      /** Build only fields consumed by policies, rewards, and termination. */
      private static function rlBuildMinimalState() : Object
      {
         var _loc1_:Array = [];
         var _loc2_:* = _api.Characters;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            var _loc4_:Character = _loc2_[_loc3_];
            if(_loc4_)
            {
               var _loc5_:String = _loc4_.getCurrentAttackFrame();
               _loc1_.push({
                  "id":_loc4_.ID,
                  "name":_loc4_.DisplayName,
                  "x":_loc4_.X,
                  "y":_loc4_.Y,
                  "nxs":_loc4_.netXSpeed(),
                  "nys":_loc4_.netYSpeed(),
                  "facing":_loc4_.FacingRight ? 1 : 0,
                  "damage":_loc4_.getDamage(),
                  "stocks":Boolean(_loc4_.getMatchResults()) ? int(_loc4_.getMatchResults().StockRemaining) : int(_loc4_.getLives()),
                  "ground":Boolean(_loc4_.CollisionObj) && Boolean(_loc4_.CollisionObj.ground) ? 1 : 0,
                  "jumpCount":_loc4_.JumpCount,
                  "shieldPower":_loc4_.ShieldPower,
                  "shielding":_loc4_.Shielding ? 1 : 0,
                  "hitstun":_loc4_.isHitStunOrParalysis() ? 1 : 0,
                  "atkFrame":_loc5_ != null ? 1 : 0,
                  "atkExec":_loc5_ != null ? _loc4_.getExecTime() : 0,
                  "hanging":_loc4_.Hanging ? 1 : 0,
                  "dead":_loc4_.Dead ? 1 : 0,
                  "controls":_loc4_.getControlBitsAPI(false)
               });
            }
            _loc3_++;
         }
         return {
            "type":"state",
            "schema":3,
            "frame":_api.ElapsedFrames,
            "paused":_api.Paused ? 1 : 0,
            "ended":_api.GameEnded ? 1 : 0,
            "chars":_loc1_
         };
      }

      /** Build match-static identity and collision geometry once per reset. */
      private static function rlBuildMatchMetadata() : Object
      {
         var _loc1_:Array = [];
         var _loc2_:* = _api.Characters;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            var _loc4_:Character = _loc2_[_loc3_];
            if(_loc4_)
            {
               _loc1_.push({"id":_loc4_.ID,"name":_loc4_.DisplayName});
            }
            _loc3_++;
         }
         var _loc5_:Array = [];
         var _loc6_:* = _api.Platforms;
         _loc3_ = 0;
         while(_loc3_ < _loc6_.length)
         {
            var _loc7_:Platform = _loc6_[_loc3_];
            if(_loc7_)
            {
               _loc5_.push({"x":_loc7_.X,"y":_loc7_.Y,"w":_loc7_.Width,"h":_loc7_.Height,"fall":_loc7_.fallthrough ? 1 : 0,"nodrop":_loc7_.noDropThrough ? 1 : 0});
            }
            _loc3_++;
         }
         var _loc8_:Array = [];
         var _loc9_:* = _api.Terrains;
         _loc3_ = 0;
         while(_loc3_ < _loc9_.length)
         {
            var _loc10_:Platform = _loc9_[_loc3_];
            if(_loc10_)
            {
               _loc8_.push({"x":_loc10_.X,"y":_loc10_.Y,"w":_loc10_.Width,"h":_loc10_.Height,"fall":_loc10_.fallthrough ? 1 : 0});
            }
            _loc3_++;
         }
         return {"config":_rlRestartConfig,"characters":_loc1_,"platforms":_loc5_,"terrains":_loc8_};
      }

      private static function rlOnGameEnded(param1:Event) : void
      {
         rlSend({"type":"game_ended"});
      }

      /**
       * Serialize the current match state to a plain object.
       *
       * Schema v2 additions over v1:
       * - per-char: net velocity (speed+knockback), attack frame/exec/air/IASA/throw,
       *   hitstun, invincibility/intangibility, held item name, control bits,
       *   opponent-relative dx/dy/dist, team
       * - stage: platforms/terrains (x,y,w,h,fallthrough,noDropThrough)
       * - items: live items (x,y,xs,ys,name,ground)
       * - projectiles: live projectiles (x,y,xs,ys,name,ownerId,team)
       * - match: timer, schema version
       */
      private static function rlBuildFullState() : Object
      {
         var i:int = 0;
         var j:int = 0;
         var ch:Character = null;
         var other:Character = null;
         var obj:Object = null;
         var dx:Number = 0;
         var dy:Number = 0;
         var d:Number = 0;
         var chars:Array = [];
         var charList:* = _api.Characters;

         // ---- characters ----
         i = 0;
         while(i < charList.length)
         {
            ch = charList[i];
            if(ch)
            {
               obj = new Object();
               obj.id = ch.ID;
               obj.uid = ch.UID;
               obj.name = ch.DisplayName;
               obj.team = ch.Team;
               obj.x = ch.X;
               obj.y = ch.Y;
               obj.xs = ch.XSpeed;
               obj.ys = ch.YSpeed;
               // Net velocity = movement speed + knockback (what actually moves the char)
               obj.nxs = ch.netXSpeed();
               obj.nys = ch.netYSpeed();
               obj.facing = ch.FacingRight ? 1 : 0;
               obj.state = ch.State;
               obj.damage = ch.getDamage();
               obj.lives = ch.getLives();
               obj.ground = Boolean(ch.CollisionObj) && Boolean(ch.CollisionObj.ground) ? 1 : 0;
               obj.dead = ch.Dead ? 1 : 0;
               obj.cpu = ch.CpuAI ? 1 : 0;
               obj.jumpCount = ch.JumpCount;
               obj.maxJump = ch.MaxJump;
               obj.shieldPower = ch.ShieldPower;
               obj.shielding = ch.Shielding ? 1 : 0;
               obj.hanging = ch.Hanging ? 1 : 0;
               obj.frameNum = ch.CurrentFrameNum;
               obj.hitLag = ch.HitLag;
               obj.stocks = Boolean(ch.getMatchResults()) ? int(ch.getMatchResults().StockRemaining) : int(ch.getLives());
               // --- attack state (only meaningful while actually attacking) ---
               var atkFrame:String = ch.getCurrentAttackFrame();
               obj.atkFrame = atkFrame;
               if(atkFrame != null)
               {
                  obj.atkExec = ch.getExecTime();
                  obj.atkAir = Boolean(ch.AttackStateData) && ch.AttackStateData.IsAirAttack ? 1 : 0;
                  obj.atkIASA = Boolean(ch.AttackStateData) && ch.AttackStateData.IASA ? 1 : 0;
                  obj.atkThrow = Boolean(ch.AttackStateData) && ch.AttackStateData.IsThrow ? 1 : 0;
               }
               else
               {
                  obj.atkExec = 0;
                  obj.atkAir = 0;
                  obj.atkIASA = 0;
                  obj.atkThrow = 0;
               }
               // --- status flags ---
               obj.hitstun = ch.isHitStunOrParalysis() ? 1 : 0;
               obj.invincible = ch.isInvincible() ? 1 : 0;
               obj.intangible = ch.isIntangible() ? 1 : 0;
               obj.controls = ch.getControlBitsAPI(false);
               // --- held item ---
               obj.item = ch.HoldingItem && Boolean(ch.ItemObj) ? ch.ItemObj.LinkageID : null;
               // --- opponent-relative features (nearest living opponent) ---
               obj.oppDx = 0;
               obj.oppDy = 0;
               obj.oppDist = -1;
               obj.oppId = -1;
               obj.oppDamage = 0;
               obj.oppState = 0;
               j = 0;
               while(j < charList.length)
               {
                  other = charList[j];
                  if(Boolean(other) && other !== ch && !other.Dead && !(other.Team == ch.Team && ch.Team > 0))
                  {
                     dx = other.X - ch.X;
                     dy = other.Y - ch.Y;
                     d = Math.sqrt(dx * dx + dy * dy);
                     if(obj.oppDist < 0 || d < obj.oppDist)
                     {
                        obj.oppDist = d;
                        obj.oppDx = dx;
                        obj.oppDy = dy;
                        obj.oppId = other.ID;
                        obj.oppDamage = other.getDamage();
                        obj.oppState = other.State;
                     }
                  }
                  j++;
               }
               chars.push(obj);
            }
            i++;
         }

         // ---- stage geometry ----
         var platforms:Array = [];
         var platList:* = _api.Platforms;
         i = 0;
         while(i < platList.length)
         {
            var p:Platform = platList[i];
            if(p)
            {
               platforms.push({
                  "x":p.X,
                  "y":p.Y,
                  "w":p.Width,
                  "h":p.Height,
                  "fall":p.fallthrough ? 1 : 0,
                  "nodrop":p.noDropThrough ? 1 : 0
               });
            }
            i++;
         }
         var terrains:Array = [];
         var terrList:* = _api.Terrains;
         i = 0;
         while(i < terrList.length)
         {
            var t:Platform = terrList[i];
            if(t)
            {
               terrains.push({
                  "x":t.X,
                  "y":t.Y,
                  "w":t.Width,
                  "h":t.Height,
                  "fall":t.fallthrough ? 1 : 0
               });
            }
            i++;
         }

         // ---- items ----
         var items:Array = [];
         if(Boolean(_api.ItemsRef))
         {
            var itemList:* = _api.ItemsRef.ItemsInUse;
            i = 0;
            while(i < itemList.length)
            {
               var it:Item = itemList[i];
               if(Boolean(it) && !it.Dead && !it.PickedUp)
               {
                  items.push({
                     "name":it.LinkageID,
                     "x":it.X,
                     "y":it.Y,
                     "xs":it.XSpeed,
                     "ys":it.YSpeed,
                     "ground":it.Ground ? 1 : 0
                  });
               }
               i++;
            }
         }

         // ---- projectiles ----
         var projs:Array = [];
         var projList:* = _api.Projectiles;
         i = 0;
         while(i < projList.length)
         {
            var pr:Projectile = projList[i];
            if(Boolean(pr) && !pr.Dead && pr.Visible)
            {
               var ownerId:int = -1;
               if(Boolean(pr.getOwner()) && pr.getOwner() is Character)
               {
                  ownerId = Character(pr.getOwner()).ID;
               }
               projs.push({
                  "name":pr.LinkageID,
                  "x":pr.X,
                  "y":pr.Y,
                  "xs":pr.XSpeed,
                  "ys":pr.YSpeed,
                  "owner":ownerId,
                  "team":pr.TeamID
               });
            }
            i++;
         }

         // ---- match-level ----
         var timerVal:int = -1;
         var timer:GameTimer = _api.TimerRef;
         if(Boolean(timer))
         {
            timerVal = timer.CurrentTime;
         }

         var state:Object = new Object();
         state.type = "state";
         state.schema = 2;
         state.frame = _api.ElapsedFrames;
         state.paused = _api.Paused ? 1 : 0;
         state.ended = _api.GameEnded ? 1 : 0;
         state.timer = timerVal;
         state.chars = chars;
         state.platforms = platforms;
         state.terrains = terrains;
         state.items = items;
         state.projs = projs;
         return state;
      }

      /**
         * Hold an input mask (ControlsObject bitfield) in the given player's AI
         * control-override queue until a later command replaces it. The character
         * must be CPU-controlled (use rlTakeOver first); the latest command wins.
       */
      public static function rlInjectInput(param1:int, param2:int) : void
      {
         if(!isReady())
         {
            return;
         }
         var _loc3_:* = _api.Characters;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            var _loc5_:Character = _loc3_[_loc4_];
            if(Boolean(_loc5_) && _loc5_.ID == param1 && Boolean(_loc5_.CpuAI))
            {
               // Latest-wins held input. A practical match cannot exhaust the
               // sentinel before Python replaces it or match teardown resets AI.
               _loc5_.CpuAI.resetControlOverrides();
               _loc5_.CpuAI.importControlOverrides([param2,int.MAX_VALUE]);
               return;
            }
            _loc4_++;
         }
      }

      /**
       * Convert a player slot to CPU control so the RL bridge can drive it.
       * (Creates the AI instance that receives control overrides.)
       */
      public static function rlTakeOver(param1:int) : void
      {
         if(!isReady())
         {
            return;
         }
         var _loc2_:* = _api.Characters;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            var _loc4_:Character = _loc2_[_loc3_];
            if(Boolean(_loc4_) && _loc4_.ID == param1)
            {
               if(!_loc4_.CpuAI)
               {
                  _loc4_.setHumanControl(false,9);
                  trace("[ModAPI RL] Took over player slot " + param1);
               }
               return;
            }
            _loc3_++;
         }
      }

      // ========== CONTROLS OVERLAY ==========

      /** Show/hide the controls overlay for a player slot (0 = disabled). */
      public static function rlSetOverlay(param1:int) : void
      {
         _rlOverlayPlayer = param1;
         if(param1 <= 0)
         {
            if(_rlOverlay != null)
            {
               _rlOverlay.visible = false;
            }
            return;
         }
         if(_rlOverlay == null && Boolean(Main.Root) && Boolean(Main.Root.stage))
         {
            var _loc2_:TextFormat = new TextFormat("_typewriter",14,0xFFFFFF);
            _rlOverlay = new TextField();
            _rlOverlay.defaultTextFormat = _loc2_;
            _rlOverlay.autoSize = TextFieldAutoSize.LEFT;
            _rlOverlay.background = true;
            _rlOverlay.backgroundColor = 0x000000;
            _rlOverlay.alpha = 0.8;
            _rlOverlay.selectable = false;
            _rlOverlay.x = 10;
            _rlOverlay.y = Main.Root.stage.stageHeight - 30;
            Main.Root.stage.addChild(_rlOverlay);
         }
         if(_rlOverlay != null)
         {
            _rlOverlay.visible = true;
            rlUpdateOverlay();
         }
      }

      /** Refresh the overlay text from the target player's held controls. */
      private static function rlUpdateOverlay() : void
      {
         if(_rlOverlay == null || !_rlOverlay.visible || _rlOverlayPlayer <= 0)
         {
            return;
         }
         if(!isReady())
         {
            _rlOverlay.text = "P" + _rlOverlayPlayer + ": -";
            return;
         }
         var _loc1_:Character = _api.getPlayerByID(_rlOverlayPlayer);
         if(!_loc1_)
         {
            _rlOverlay.text = "P" + _rlOverlayPlayer + ": -";
            return;
         }
         var _loc2_:int = _loc1_.getControlBitsAPI(false);
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < 22)
         {
            if(_loc2_ & (1 << _loc4_))
            {
               _loc3_.push(RL_BIT_NAMES[_loc4_]);
            }
            _loc4_++;
         }
         _rlOverlay.text = "P" + _rlOverlayPlayer + ": " + (_loc3_.length > 0 ? _loc3_.join(" ") : "-");
      }

      // ========== AUTO-START (launch straight into a local VS match) ==========

      private static var _rlAutoStartDone:Boolean = false;

      /**
       * Called once from Main after the initial menu is shown. If an
       * autostart.json config is present in the application directory and
       * enabled, immediately launch a local VS match with the configured
       * stage/characters so the RL bridge comes online without manual menu
       * navigation.
       */
      public static function rlAutoStartCheck() : void
      {
         if(_rlAutoStartDone)
         {
            return;
         }
         var cfg:Object = rlReadAutoStartConfig();
         if(!cfg || cfg.enabled !== true)
         {
            return;
         }
         _rlAutoStartDone = true;
         trace("[ModAPI RL] autostart.json found - launching VS match.");
         rlStartVSMatch(cfg);
      }

      /**
       * Read autostart.json from the application directory. Returns null if the
       * file is missing or unparseable.
       */
      private static function rlReadAutoStartConfig() : Object
      {
         try
         {
            var f:File = File.applicationDirectory.resolvePath("autostart.json");
            if(!f.exists)
            {
               return null;
            }
            var fs:FileStream = new FileStream();
            fs.open(f,FileMode.READ);
            var txt:String = fs.readUTFBytes(fs.bytesAvailable);
            fs.close();
            return JSON.parse(txt);
         }
         catch(e:Error)
         {
            trace("[ModAPI RL] Failed to read autostart.json: " + e.message);
         }
         return null;
      }

      /**
       * Build a VS Game object and start the match, replicating the normal
       * VSMenu -> StageSelect -> startMatch flow.
       *
       * cfg fields (all optional):
       *   stage:      stage id (default "finaldestination")
       *   characters: array of character ids per slot (default ["marth","sandbag"])
       *   lives:      stock count (default 99)
       *   cpuLevel:   CPU level for non-human slots (default 9)
       *   usingTime:  enable match timer (default false)
       *   time:       timer minutes when usingTime (default 99)
       */
      public static function rlStartVSMatch(cfg:Object) : void
      {
         if(!cfg)
         {
            cfg = {};
         }
         if(GameController.isStarted)
         {
            trace("[ModAPI RL] startVSMatch skipped - a match is already starting.");
            return;
         }
         try
         {
            var stageID:String = cfg.stage || "finaldestination";
            var chars:Array = cfg.characters is Array && cfg.characters.length >= 2 ? cfg.characters : ["marth","sandbag"];
            var lives:int = cfg.lives is Number ? int(cfg.lives) : 99;
            var cpuLevel:int = cfg.cpuLevel is Number ? int(cfg.cpuLevel) : 9;

            var game:Game = new Game(chars.length,Mode.VS);
            game.LevelData.stage = stageID;
            game.UsingLives = true;
            game.Lives = lives;
            game.UsingTime = cfg.usingTime === true;
            if(cfg.usingTime === true)
            {
               game.Time = cfg.time is Number ? int(cfg.time) : 99;
            }
            game.HudDisplay = true;
            game.PauseEnabled = true;
            game.ShowPlayerID = true;
            // RL build: items off by default. The stock game's item timelines
            // (e.g. exploding tag) throw Error #1010 when spawned, and items
            // add nondeterminism that hurts RL reproducibility.
            game.Items.setAllItemStatuses(false);
            game.Items.frequency = 0;

            var i:int = 0;
            while(i < game.PlayerSettings.length)
            {
               var ps:PlayerSetting = game.PlayerSettings[i];
               ps.exist = true;
               ps.character = String(chars[i]);
               ps.lives = lives;
               if(i > 0)
               {
                  ps.human = false;
                  ps.level = cpuLevel;
               }
               i++;
            }

            GameController.isStarted = true;
            game.LevelData.randSeed = Utils.randomInteger(1,1000);
            Utils.setRandSeed(game.LevelData.randSeed);
            Utils.shuffleRandom();
            Main.prepRandomCharacters(game.PlayerSettings.length);
            ResourceManager.queueResources([game.LevelData.stage]);
            i = 0;
            while(i < game.PlayerSettings.length)
            {
               if(Boolean(game.PlayerSettings[i]) && Boolean(game.PlayerSettings[i].exist) && Boolean(game.PlayerSettings[i].character != null) && game.PlayerSettings[i].character != "xp")
               {
                  ResourceManager.queueResources([game.PlayerSettings[i].character == "random" ? Main.RandCharList[i].StatsName : game.PlayerSettings[i].character]);
               }
               i++;
            }
            ResourceManager.load({"oncomplete":function(...args):void
            {
               MenuController.disposeAllMenus();
               GameController.startMatch(game);
            }});
            trace("[ModAPI RL] VS match start queued (stage=" + stageID + ", chars=" + chars.join(",") + ").");
         }
         catch(e:Error)
         {
            trace("[ModAPI RL] startVSMatch failed: " + e.message);
         }
      }

      /**
       * Tear down the current match and start a fresh one with the given
       * config (or the defaults). Used by the Gym env's reset().
       *
       * We must run the old StageData's endGame() so it removes its
       * RENDER/ENTER_FRAME tick listeners; otherwise the disposed old match
       * keeps ticking and throws null-reference errors.
       */
      public static function rlRestartMatch(param1:Object, param2:int = -1) : void
      {
         try
         {
            if(_rlRestartPending)
            {
               rlSend({"type":"error","request":param2,"command":"restart_match","message":"restart already pending"});
               return;
            }
            // If the client supplied no configuration, reuse autostart.json.
            if(!param1)
            {
               param1 = rlReadAutoStartConfig();
            }
            _rlRestartPending = true;
            _rlRestartRequest = param2;
            _rlRestartConfig = param1;
            _rlPauseAfterTick = false;
            _rlStepRequest = -1;
            _rlLockstep = false;
            if(Boolean(_api) && Boolean(_api.ResearchPaused))
            {
               _api.setResearchPaused(false);
            }
            rlSend({"type":"ack","request":param2,"command":"restart_match","generation":_rlMatchGeneration + 1});
            if(Boolean(GameController.stageData))
            {
               GameController.stageData.endGame(true);
            }
            else
            {
               GameController.endMatch();
            }
            GameController.destroyStageData();
            GameController.isStarted = false;
            rlStartVSMatch(param1);
         }
         catch(e:Error)
         {
            _rlRestartPending = false;
            _rlRestartRequest = -1;
            _rlRestartConfig = null;
            rlSend({"type":"error","request":param2,"command":"restart_match","message":e.message});
            trace("[ModAPI RL] restartMatch failed: " + e.message);
         }
      }
   }
}

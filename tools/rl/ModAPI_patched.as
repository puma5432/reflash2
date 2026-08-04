package com.mcleodgaming.ssf2.modapi
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.api.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.AI;
   import com.mcleodgaming.ssf2.engine.Character;
   import com.mcleodgaming.ssf2.engine.StageData;
   import com.mcleodgaming.ssf2.input.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.ServerSocketConnectEvent;
   import flash.net.ServerSocket;
   import flash.net.Socket;

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

      public function ModAPI()
      {
         super();
      }

      public static function init(param1:StageData) : void
      {
         trace("[ENGINE ModAPI] init() called with api=" + param1);
         _api = param1;
         _isInitialized = true;
         trace("[ENGINE ModAPI] init() - _api assigned, _isInitialized = true");
         trace("SSF2 Mod API Version " + VERSION_MAJOR + "." + VERSION_MINOR + "." + VERSION_REVISION + " initialized.");
         rlAttach();
      }

      public static function deinit() : void
      {
         trace("[ENGINE ModAPI] deinit() called");
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
         if(_rlServer == null)
         {
            try
            {
               rlStartServer();
            }
            catch(e:Error)
            {
               trace("[ModAPI RL] Failed to start RL server: " + e.message);
            }
         }
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
         if(Boolean(Main.Root) && Boolean(Main.Root.stage))
         {
            Main.Root.stage.removeEventListener(Event.ENTER_FRAME,rlEnsureAttached);
         }
         if(!_api.EventManagerObj.hasEvent(SSF2Event.GAME_TICK_END,rlOnTick))
         {
            _api.EventManagerObj.addEventListener(SSF2Event.GAME_TICK_END,rlOnTick);
            _api.EventManagerObj.addEventListener(SSF2Event.GAME_ENDED,rlOnGameEnded);
            trace("[ModAPI RL] Attached to match tick events.");
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
         _rlServer = new ServerSocket();
         _rlServer.addEventListener(ServerSocketConnectEvent.CONNECT,rlOnConnect);
         _rlServer.addEventListener(IOErrorEvent.IO_ERROR,rlOnServerError);
         _rlServer.addEventListener(SecurityErrorEvent.SECURITY_ERROR,rlOnServerError);
         _rlServer.bind(_rlPort,"127.0.0.1");
         _rlServer.listen();
         trace("[ModAPI RL] RL bridge listening on 127.0.0.1:" + _rlPort);
      }

      private static function rlOnServerError(param1:Event) : void
      {
         trace("[ModAPI RL] Server socket error: " + param1.toString());
      }

      private static function rlOnConnect(param1:ServerSocketConnectEvent) : void
      {
         if(_rlClient != null)
         {
            try
            {
               _rlClient.close();
            }
            catch(e:Error)
            {
            }
         }
         _rlClient = param1.socket;
         _rlRecvBuffer = "";
         _rlStateCount = 0;
         _rlClient.addEventListener(ProgressEvent.SOCKET_DATA,rlOnData);
         _rlClient.addEventListener(Event.CLOSE,rlOnClientClose);
         _rlClient.addEventListener(IOErrorEvent.IO_ERROR,rlOnClientError);
         trace("[ModAPI RL] External agent connected.");
         rlSend({"type":"hello","api":getAPIVersion(),"port":_rlPort,"framerate":Main.FRAMERATE});
      }

      private static function rlOnClientClose(param1:Event) : void
      {
         trace("[ModAPI RL] External agent disconnected.");
         _rlClient = null;
      }

      private static function rlOnClientError(param1:Event) : void
      {
         trace("[ModAPI RL] Client socket error: " + param1.toString());
         _rlClient = null;
      }

      private static function rlSend(param1:Object) : void
      {
         if(_rlClient == null || !_rlClient.connected)
         {
            return;
         }
         try
         {
            _rlClient.writeUTFBytes(JSON.stringify(param1) + "\n");
            _rlClient.flush();
         }
         catch(e:Error)
         {
            _rlClient = null;
         }
      }

      private static function rlOnData(param1:ProgressEvent) : void
      {
         if(_rlClient == null)
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
         else if(_loc3_ == "state")
         {
            if(isReady())
            {
               rlSend(rlBuildState());
            }
         }
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
         _rlStateCount++;
         rlSend(rlBuildState());
      }

      private static function rlOnGameEnded(param1:Event) : void
      {
         rlSend({"type":"game_ended"});
      }

      /**
       * Serialize the current match state to a plain object.
       */
      private static function rlBuildState() : Object
      {
         var _loc1_:Array = [];
         var _loc2_:* = _api.Characters;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            var _loc4_:Character = _loc2_[_loc3_];
            if(_loc4_)
            {
               var _loc5_:Object = new Object();
               _loc5_.id = _loc4_.ID;
               _loc5_.uid = _loc4_.UID;
               _loc5_.name = _loc4_.DisplayName;
               _loc5_.x = _loc4_.X;
               _loc5_.y = _loc4_.Y;
               _loc5_.xs = _loc4_.XSpeed;
               _loc5_.ys = _loc4_.YSpeed;
               _loc5_.facing = _loc4_.FacingRight ? 1 : 0;
               _loc5_.state = _loc4_.State;
               _loc5_.damage = _loc4_.getDamage();
               _loc5_.lives = _loc4_.getLives();
               _loc5_.ground = Boolean(_loc4_.CollisionObj) && Boolean(_loc4_.CollisionObj.ground) ? 1 : 0;
               _loc5_.dead = _loc4_.Dead ? 1 : 0;
               _loc5_.cpu = _loc4_.CpuAI ? 1 : 0;
               _loc5_.jumpCount = _loc4_.JumpCount;
               _loc5_.maxJump = _loc4_.MaxJump;
               _loc5_.shieldPower = _loc4_.ShieldPower;
               _loc5_.shielding = _loc4_.Shielding ? 1 : 0;
               _loc5_.hanging = _loc4_.Hanging ? 1 : 0;
               _loc5_.frameNum = _loc4_.CurrentFrameNum;
               _loc5_.hitLag = _loc4_.HitLag;
               _loc5_.stocks = Boolean(_loc4_.getMatchResults()) ? int(_loc4_.getMatchResults().StockRemaining) : int(_loc4_.getLives());
               _loc1_.push(_loc5_);
            }
            _loc3_++;
         }
         var _loc6_:Object = new Object();
         _loc6_.type = "state";
         _loc6_.frame = _api.ElapsedFrames;
         _loc6_.paused = _api.Paused ? 1 : 0;
         _loc6_.ended = _api.GameEnded ? 1 : 0;
         _loc6_.chars = _loc1_;
         return _loc6_;
      }

      /**
       * Inject one frame of input (ControlsObject bitfield) into the given
       * player's AI control-override queue. The character must be CPU-controlled
       * (use rlTakeOver first for human slots). The override is consumed on the
       * next game frame and fully replaces the CPU's own decision for that frame.
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
               // Latest-wins: drop any stale queued overrides so a slow agent
               // never replays outdated inputs, then queue exactly one frame.
               _loc5_.CpuAI.resetControlOverrides();
               _loc5_.CpuAI.importControlOverrides([param2,1]);
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
   }
}

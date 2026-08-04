package com.mcleodgaming.ssf2.input
{
   import com.masterwex.ane.rumble.*;
   import com.mcleodgaming.ssf2.api.*;
   import com.mcleodgaming.ssf2.events.*;
   import com.mcleodgaming.ssf2.net.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.EventDispatcher;
   import flash.utils.*;
   
   public class Gamepad extends EventDispatcher
   {
      
      public static const DEADZONE_DEFAULT:Number = 0.2;
      
      public static const DASHZONE_DEFAULT:Number = 0.7;
      
      private static var USE_ANE_RUMBLE:Boolean = true;
      
      private static var m_aneReady:Boolean = false;
      
      private static var m_aneInitLogged:Boolean = false;
      
      private static var ENABLE_RUMBLE_DEBUG:Boolean = false;
      
      private static var m_lastRumbleTime:Object = {};
      
      private static const RUMBLE_MIN_INTERVAL:int = 16;
      
      private static var m_globalRumbleEnabled:Boolean = true;
      
      private static var m_deviceMapping:Object = {};
      
      private static var m_deviceMappingDirty:Boolean = true;
      
      protected var m_controlState:Object;
      
      protected var m_controlsList:Array;
      
      protected var m_controlsMap:Object;
      
      protected var m_name:String;
      
      protected var m_port:int;
      
      protected var m_xinputIndex:int = -1;
      
      protected var m_xinputDetected:Boolean = false;
      
      protected var m_rumbleEnabled:Boolean = true;
      
      public function Gamepad(param1:String, param2:int, param3:int = -1)
      {
         super();
         this.m_controlState = {};
         this.m_controlsList = [];
         this.m_controlsMap = {};
         this.m_name = param1;
         this.m_port = param2;
         this.m_xinputIndex = param3;
         this.m_xinputDetected = false;
         this.resetControlsMap();
      }
      
      public static function setGlobalRumbleEnabled(param1:Boolean) : void
      {
         m_globalRumbleEnabled = param1;
      }
      
      public static function getGlobalRumbleEnabled() : Boolean
      {
         return m_globalRumbleEnabled;
      }
      
      public static function toggleGlobalRumble() : Boolean
      {
         m_globalRumbleEnabled = !m_globalRumbleEnabled;
         return m_globalRumbleEnabled;
      }
      
      public static function rumbleForPlayer(param1:int, param2:Number, param3:Number, param4:int) : void
      {
         var index:int = 0;
         var isOnline:Boolean = false;
         var localPlayerID:int = 0;
         var gamepad:Gamepad = null;
         var playerID:int = param1;
         var left:Number = param2;
         var right:Number = param3;
         var duration:int = param4;
         if(ENABLE_RUMBLE_DEBUG)
         {
            SSF2API.print("[RUMBLE] rumbleForPlayer called: playerID=" + playerID + ", left=" + left + ", right=" + right + ", duration=" + duration);
         }
         if(!SaveData.getRumbleEnabled(playerID))
         {
            if(ENABLE_RUMBLE_DEBUG)
            {
               SSF2API.print("[RUMBLE] Rumble disabled for playerID=" + playerID + ", aborting");
            }
            return;
         }
         try
         {
            isOnline = Boolean(MultiplayerManager.Active);
            localPlayerID = int(MultiplayerManager.PlayerID);
            if(ENABLE_RUMBLE_DEBUG)
            {
               SSF2API.print("[RUMBLE] MultiplayerManager.Active=" + isOnline + ", MultiplayerManager.PlayerID=" + localPlayerID);
            }
            if(isOnline)
            {
               if(ENABLE_RUMBLE_DEBUG)
               {
                  SSF2API.print("[RUMBLE] Online mode detected. Checking if playerID=" + playerID + " matches localPlayerID=" + localPlayerID);
               }
               if(playerID != localPlayerID)
               {
                  if(ENABLE_RUMBLE_DEBUG)
                  {
                     SSF2API.print("[RUMBLE] playerID=" + playerID + " is NOT local player (" + localPlayerID + "), skipping rumble");
                  }
                  return;
               }
               index = 0;
               if(ENABLE_RUMBLE_DEBUG)
               {
                  SSF2API.print("[RUMBLE] Online mode: using controller index 0 for local player");
               }
            }
            else
            {
               index = playerID - 1;
               if(ENABLE_RUMBLE_DEBUG)
               {
                  SSF2API.print("[RUMBLE] Offline mode: using controller index " + index + " (playerID-1)");
               }
            }
            if(Boolean(SaveData.Controllers && index >= 0) && Boolean(index < SaveData.Controllers.length) && Boolean(SaveData.Controllers[index]))
            {
               gamepad = SaveData.Controllers[index].GamepadInstance;
               if(ENABLE_RUMBLE_DEBUG)
               {
                  SSF2API.print("[RUMBLE] Controller[" + index + "] found, GamepadInstance=" + (gamepad != null ? gamepad.Name : "null"));
               }
               if(gamepad != null)
               {
                  if(ENABLE_RUMBLE_DEBUG)
                  {
                     SSF2API.print("[RUMBLE] Calling gamepad.setRumble(" + left + ", " + right + ", " + duration + ")");
                  }
                  gamepad.setRumble(left,right,duration);
               }
               else if(ENABLE_RUMBLE_DEBUG)
               {
                  SSF2API.print("[RUMBLE] GamepadInstance is null, cannot rumble");
               }
            }
            else if(ENABLE_RUMBLE_DEBUG)
            {
               SSF2API.print("[RUMBLE] No valid controller at index " + index + " (Controllers=" + (SaveData.Controllers ? SaveData.Controllers.length : "null") + ")");
            }
         }
         catch(e:Error)
         {
            if(ENABLE_RUMBLE_DEBUG)
            {
               SSF2API.print("[RUMBLE] Error in rumbleForPlayer: " + e.message);
            }
         }
      }
      
      public static function rumbleOnHit(param1:int, param2:Number, param3:Number) : void
      {
         var _loc4_:Number = Math.min(0.8,Math.max(0.2,param2 / 25));
         var _loc5_:int = Math.min(150,Math.max(50,int(param3 * 2)));
         rumbleForPlayer(param1,_loc4_ * 0.8,_loc4_,_loc5_);
      }
      
      public static function rumbleOnDamage(param1:int, param2:Number, param3:Number) : void
      {
         var _loc4_:Number = Math.min(1,Math.max(0.3,param2 / 20));
         var _loc5_:int = Math.min(200,Math.max(80,int(param3 * 5)));
         rumbleForPlayer(param1,_loc4_,_loc4_ * 0.6,_loc5_);
      }
      
      public static function rumbleOnKO(param1:int) : void
      {
         rumbleForPlayer(param1,1,0.8,200);
      }
      
      public static function rumbleOnShieldHit(param1:int) : void
      {
         rumbleForPlayer(param1,0.1,0.2,40);
      }
      
      public static function rumbleOnShieldBreak(param1:int) : void
      {
         rumbleForPlayer(param1,1,1,300);
      }
      
      public static function rumbleOnLand(param1:int, param2:Number) : void
      {
         if(param2 < 5)
         {
            return;
         }
         var _loc3_:Number = Math.min(0.4,Math.max(0.1,param2 / 60));
         var _loc4_:int = Math.min(80,Math.max(30,int(param2 * 2)));
         rumbleForPlayer(param1,_loc3_,_loc3_ * 0.5,_loc4_);
      }
      
      public static function rumbleOnTech(param1:int) : void
      {
         rumbleForPlayer(param1,0.2,0.4,50);
      }
      
      public static function rumbleOnLedgeGrab(param1:int) : void
      {
         rumbleForPlayer(param1,0.15,0.3,40);
      }
      
      public static function rumbleOnGrab(param1:int) : void
      {
         rumbleForPlayer(param1,0.3,0.5,60);
      }
      
      public static function rumbleOnGrabbed(param1:int) : void
      {
         rumbleForPlayer(param1,0.4,0.2,80);
      }
      
      public static function rumbleOnScreenKO(param1:int) : void
      {
         rumbleForPlayer(param1,1,1,250);
      }
      
      public static function rumbleOnStarKO(param1:int) : void
      {
         rumbleForPlayer(param1,0.6,0.4,150);
      }
      
      public static function rumbleOnFinalSmash(param1:int) : void
      {
         rumbleForPlayer(param1,0.8,1,300);
      }
      
      public static function rumbleOnMeteor(param1:int) : void
      {
         rumbleForPlayer(param1,0.7,0.9,120);
      }
      
      public static function rumbleOnItemPickup(param1:int) : void
      {
         if(ENABLE_RUMBLE_DEBUG)
         {
            SSF2API.print("rumbleOnItemPickup: " + param1);
         }
         rumbleForPlayer(param1,0.3,0.3,150);
      }
      
      public static function rumbleOnCharge(param1:int) : void
      {
         if(ENABLE_RUMBLE_DEBUG)
         {
            SSF2API.print("rumbleOnCharge: " + param1);
         }
         rumbleForPlayer(param1,0.2,0.2,200);
      }
      
      public static function rumbleOnAttack(param1:int, param2:* = null) : void
      {
         if(ENABLE_RUMBLE_DEBUG)
         {
            SSF2API.print("rumbleOnAttack: " + param1);
         }
         rumbleForPlayer(param1,0.6,0.5,150);
      }
      
      private static function sendRumbleCommand(param1:int, param2:Number, param3:Number, param4:int) : void
      {
         var result:Boolean = false;
         var port:int = param1;
         var leftMotor:Number = param2;
         var rightMotor:Number = param3;
         var duration:int = param4;
         var now:int = int(getTimer());
         var lastTime:int = int(int(m_lastRumbleTime[port]) || 0);
         if(now - lastTime < RUMBLE_MIN_INTERVAL && leftMotor > 0)
         {
            return;
         }
         m_lastRumbleTime[port] = now;
         if(!ensureAneInitialized())
         {
            return;
         }
         try
         {
            if(ENABLE_RUMBLE_DEBUG)
            {
               trace("[RUMBLE DEBUG] Calling Rumble.setRumble with port=" + port + ", left=" + leftMotor + ", right=" + rightMotor + ", duration=" + duration);
            }
            result = Boolean(Rumble.setRumble(port,leftMotor,rightMotor,duration));
            if(ENABLE_RUMBLE_DEBUG)
            {
               trace("[RUMBLE DEBUG] Rumble.setRumble returned: " + result);
            }
            if(!result)
            {
               if(ENABLE_RUMBLE_DEBUG)
               {
                  trace("[RUMBLE DEBUG] ANE setRumble failed");
               }
            }
         }
         catch(e:Error)
         {
            if(ENABLE_RUMBLE_DEBUG)
            {
               trace("[RUMBLE DEBUG] Rumble.setRumble threw error: " + e.message);
            }
         }
      }
      
      private static function ensureAneInitialized() : Boolean
      {
         var info:Object = null;
         if(!m_aneReady)
         {
            try
            {
               m_aneReady = Rumble.initialize();
               if(m_aneReady)
               {
                  info = Rumble.identifyActiveControllers();
                  if(ENABLE_RUMBLE_DEBUG)
                  {
                     trace("[RUMBLE ANE] Initialized successfully. Active controllers:",info);
                  }
                  m_aneInitLogged = false;
               }
               else if(ENABLE_RUMBLE_DEBUG)
               {
                  trace("[RUMBLE ANE] Rumble.initialize() returned false");
               }
            }
            catch(e:Error)
            {
               m_aneReady = false;
               if(!m_aneInitLogged)
               {
                  if(ENABLE_RUMBLE_DEBUG)
                  {
                     trace("[RUMBLE ANE] Initialization error (ANE likely not packaged or failed to load): " + e.message);
                  }
                  m_aneInitLogged = true;
               }
            }
            if(!m_aneReady && !m_aneInitLogged)
            {
               if(ENABLE_RUMBLE_DEBUG)
               {
                  trace("[RUMBLE ANE] Rumble.initialize() returned false; ANE not ready so rumble will fall back.");
               }
               m_aneInitLogged = true;
            }
         }
         return m_aneReady;
      }
      
      public static function refreshDeviceMapping() : void
      {
      }
      
      public static function getMappedXInputIndex(param1:int) : int
      {
         if(m_deviceMappingDirty)
         {
            refreshDeviceMapping();
         }
         return int(m_deviceMapping[param1]) || param1;
      }
      
      public static function listControllers() : void
      {
         if(!ensureAneInitialized())
         {
            return;
         }
         var _loc1_:* = Rumble.identifyActiveControllers();
         trace("[RUMBLE DEBUG] Active XInput controllers:",_loc1_);
      }
      
      public static function testRumble(param1:int = 0) : void
      {
         if(!ensureAneInitialized())
         {
            return;
         }
         trace("[RUMBLE DEBUG] Testing rumble on port " + param1);
         sendRumbleCommand(param1,0.5,0.5,1000);
      }
      
      private function detectXInputIndex(param1:String) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:uint = 0;
         var _loc2_:uint = uint(this.getXInputButtonBit(param1));
         if(_loc2_ == 0)
         {
            return;
         }
         var _loc3_:* = Rumble.identifyActiveControllers();
         if(!_loc3_)
         {
            return;
         }
         if(ENABLE_RUMBLE_DEBUG)
         {
            trace("[RUMBLE DEBUG] Detecting XInput index for button \'" + param1 + "\' (bit 0x" + _loc2_.toString(16) + ")");
         }
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = Rumble.getControllerState(_loc4_);
            if(Boolean(_loc5_) && Boolean(_loc5_.buttons))
            {
               _loc6_ = uint(_loc5_.buttons);
               if(ENABLE_RUMBLE_DEBUG)
               {
                  trace("[RUMBLE DEBUG]   XInput[" + _loc4_ + "] buttons: 0x" + _loc6_.toString(16));
               }
               if((_loc6_ & _loc2_) != 0)
               {
                  this.m_xinputIndex = _loc4_;
                  this.m_xinputDetected = true;
                  if(ENABLE_RUMBLE_DEBUG)
                  {
                     trace("[RUMBLE DEBUG]   Detected match! Mapping to XInput[" + _loc4_ + "]");
                  }
                  break;
               }
            }
         }
         if(this.m_xinputIndex == -1)
         {
            if(ENABLE_RUMBLE_DEBUG)
            {
               trace("[RUMBLE DEBUG]   No match found, keeping default mapping");
            }
         }
      }
      
      public function get Name() : String
      {
         return this.m_name;
      }
      
      public function get Port() : int
      {
         return this.m_port;
      }
      
      public function set Port(param1:int) : void
      {
         this.m_port = param1;
      }
      
      public function get XInputIndex() : int
      {
         return this.m_xinputIndex;
      }
      
      public function set XInputIndex(param1:int) : void
      {
         this.m_xinputIndex = param1;
      }
      
      public function get ControlsMap() : Object
      {
         return this.m_controlsMap;
      }
      
      public function get ControlState() : Object
      {
         return this.m_controlState;
      }
      
      public function get ControlsList() : Array
      {
         return this.m_controlsList;
      }
      
      private function resetInputs() : void
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this.m_controlState)
         {
            this.m_controlState[_loc1_].inputs = [];
            this.m_controlState[_loc1_].inputsInverse = [];
         }
      }
      
      private function resetControlsMap() : void
      {
         this.m_controlsMap["SHIELD"] = 0;
         this.m_controlsMap["TAUNT"] = 0;
         this.m_controlsMap["START"] = 0;
         this.m_controlsMap["GRAB"] = 0;
         this.m_controlsMap["BUTTON2"] = 0;
         this.m_controlsMap["BUTTON1"] = 0;
         this.m_controlsMap["JUMP"] = 0;
         this.m_controlsMap["RIGHT"] = 0;
         this.m_controlsMap["LEFT"] = 0;
         this.m_controlsMap["DOWN"] = 0;
         this.m_controlsMap["UP"] = 0;
         this.m_controlsMap["DASH"] = 0;
         this.m_controlsMap["C_RIGHT"] = 0;
         this.m_controlsMap["C_LEFT"] = 0;
         this.m_controlsMap["C_DOWN"] = 0;
         this.m_controlsMap["C_UP"] = 0;
         this.m_controlsMap["JUMP2"] = 0;
         this.m_controlsMap["SHIELD2"] = 0;
         this.m_controlsMap["TAP_JUMP"] = 1;
         this.m_controlsMap["AUTO_DASH"] = 0;
         this.m_controlsMap["DT_DASH"] = 1;
      }
      
      public function registerInput(param1:String, param2:Number, param3:Number, param4:Number) : void
      {
         if(!this.m_controlState[param1])
         {
            this.m_controlState[param1] = {
               "id":param1,
               "index":this.m_controlsList.length,
               "type":(param2 < 0 ? "axis" : "button"),
               "minValue":param2,
               "maxValue":param3,
               "prevValue":0,
               "value":param4,
               "deadZone":Gamepad.DEADZONE_DEFAULT,
               "dashZone":Gamepad.DASHZONE_DEFAULT,
               "inputs":[],
               "inputsInverse":[]
            };
            this.m_controlsList.push(this.m_controlState[param1]);
         }
      }
      
      private function checkAxis(param1:Object, param2:Number, param3:Function) : void
      {
         var _loc4_:GamepadEvent = null;
         if(param1.value > param1.maxValue * param2)
         {
            if(param1.prevValue <= param1.maxValue * param2)
            {
               _loc4_ = new GamepadEvent(GamepadEvent.AXIS_CHANGED);
               _loc4_.gamepad = this;
               _loc4_.controlState = param1;
               param3(param1,param1.inputs,true);
               dispatchEvent(_loc4_);
            }
         }
         else if(param1.value <= param1.minValue * param2)
         {
            if(param1.prevValue > param1.minValue * param2)
            {
               _loc4_ = new GamepadEvent(GamepadEvent.AXIS_CHANGED);
               _loc4_.gamepad = this;
               _loc4_.controlState = param1;
               param3(param1,param1.inputsInverse,true);
               dispatchEvent(_loc4_);
            }
         }
         if(param1.value <= param1.maxValue * param2)
         {
            if(param1.prevValue > param1.maxValue * param2)
            {
               _loc4_ = new GamepadEvent(GamepadEvent.AXIS_CHANGED);
               _loc4_.gamepad = this;
               _loc4_.controlState = param1;
               param3(param1,param1.inputs,false);
               dispatchEvent(_loc4_);
            }
         }
         if(param1.value >= param1.minValue * param2)
         {
            if(param1.prevValue < param1.minValue * param2)
            {
               _loc4_ = new GamepadEvent(GamepadEvent.AXIS_CHANGED);
               _loc4_.gamepad = this;
               _loc4_.controlState = param1;
               param3(param1,param1.inputsInverse,false);
               dispatchEvent(_loc4_);
            }
         }
      }
      
      private function handleDeadZone(param1:Object, param2:Array, param3:Boolean) : void
      {
         this.toggleControl(param2,param3);
      }
      
      private function handleDashZone(param1:Object, param2:Array, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         if(this.m_controlsMap["AUTO_DASH"])
         {
            return;
         }
         while(_loc4_ < param2.length)
         {
            if(param2[_loc4_] === "LEFT" || param2[_loc4_] === "RIGHT" || param2[_loc4_] === "DOWN")
            {
               this.toggleControl(["DASH"],param3);
            }
            _loc4_++;
         }
      }
      
      private function toggleControl(param1:Array, param2:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc3_:String = param2 ? "on: " : "off: ";
         while(_loc4_ < param1.length)
         {
            this.m_controlsMap[param1[_loc4_]] = param2 ? 1 : 0;
            _loc4_++;
         }
      }
      
      public function onDeviceInput(param1:String, param2:Number) : void
      {
         var _loc3_:int = 0;
         var _loc4_:GamepadEvent = null;
         var _loc5_:Object = this.m_controlState[param1];
         if(!_loc5_)
         {
            return;
         }
         _loc5_.value = param2;
         if(_loc5_.type === "axis")
         {
            this.checkAxis(_loc5_,_loc5_.deadZone,this.handleDeadZone);
            this.checkAxis(_loc5_,_loc5_.dashZone,this.handleDashZone);
         }
         else if(Boolean(_loc5_.value) && !_loc5_.prevValue)
         {
            if(ENABLE_RUMBLE_DEBUG)
            {
               trace("[RUMBLE DEBUG] Button pressed: \'" + param1 + "\', m_xinputDetected=" + this.m_xinputDetected);
            }
            if(!this.m_xinputDetected)
            {
               this.detectXInputIndex(param1);
            }
            _loc4_ = new GamepadEvent(GamepadEvent.BUTTON_DOWN);
            _loc4_.gamepad = this;
            _loc4_.controlState = _loc5_;
            this.toggleControl(_loc5_.inputs,true);
            dispatchEvent(_loc4_);
         }
         else if(!_loc5_.value && Boolean(_loc5_.prevValue))
         {
            _loc4_ = new GamepadEvent(GamepadEvent.BUTTON_UP);
            _loc4_.gamepad = this;
            _loc4_.controlState = _loc5_;
            this.toggleControl(_loc5_.inputs,false);
            dispatchEvent(_loc4_);
         }
         _loc5_.prevValue = _loc5_.value;
      }
      
      public function isPressed(param1:String) : Boolean
      {
         return this.getState(param1) !== 0 ? true : false;
      }
      
      public function getState(param1:String) : Number
      {
         return this.m_controlsMap[param1];
      }
      
      public function setControl(param1:String, param2:String, param3:Boolean = false) : void
      {
         var _loc4_:Object = this.m_controlState[param1];
         if(!_loc4_)
         {
            return;
         }
         if(_loc4_.type === "axis")
         {
            if(param3)
            {
               if(_loc4_.inputsInverse.indexOf(param2) < 0)
               {
                  _loc4_.inputsInverse.push(param2);
               }
            }
            else if(_loc4_.inputs.indexOf(param2) < 0)
            {
               _loc4_.inputs.push(param2);
            }
         }
         else if(_loc4_.inputs.indexOf(param2) < 0)
         {
            _loc4_.inputs.push(param2);
         }
      }
      
      public function unsetControl(param1:String, param2:String, param3:Boolean = false) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Object = this.m_controlState[param1];
         if(!_loc5_)
         {
            return;
         }
         if(_loc5_.type === "axis")
         {
            if(param3)
            {
               _loc4_ = int(_loc5_.inputsInverse.indexOf(param2));
               this.m_controlsMap[_loc5_.inputsInverse[_loc4_]] = 0;
               _loc5_.inputsInverse.splice(_loc4_,1);
            }
            else
            {
               _loc4_ = int(_loc5_.inputs.indexOf(param2));
               this.m_controlsMap[_loc5_.inputs[_loc4_]] = 0;
               _loc5_.inputs.splice(_loc4_,1);
            }
         }
         else
         {
            _loc4_ = int(_loc5_.inputs.indexOf(param2));
            this.m_controlsMap[_loc5_.inputs[_loc4_]] = 0;
            _loc5_.inputs.splice(_loc4_,1);
         }
      }
      
      public function exportControls() : Object
      {
         return null;
      }
      
      public function importControls(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.resetControlsMap();
         this.resetInputs();
         if(param1)
         {
            for(_loc2_ in param1)
            {
               if(["TAP_JUMP","AUTO_DASH","DT_DASH"].indexOf(_loc2_) >= 0)
               {
                  this.m_controlsMap[_loc2_] = param1[_loc2_];
               }
               else
               {
                  for(_loc3_ in param1[_loc2_].inputs)
                  {
                     this.setControl(_loc2_,param1[_loc2_].inputs[_loc3_],false);
                  }
                  for(_loc3_ in param1[_loc2_].inputsInverse)
                  {
                     this.setControl(_loc2_,param1[_loc2_].inputsInverse[_loc3_],true);
                  }
                  if(param1[_loc2_].dashZone)
                  {
                     if(this.m_controlState[_loc2_])
                     {
                        this.m_controlState[_loc2_].dashZone = param1[_loc2_].dashZone;
                        this.m_controlState[_loc2_].deadZone = param1[_loc2_].deadZone;
                     }
                     else
                     {
                        this.m_controlState[_loc2_] = Utils.copyObject(param1[_loc2_]);
                        this.m_controlState[_loc2_] = Utils.copyObject(param1[_loc2_]);
                     }
                  }
               }
            }
         }
      }
      
      public function setRumble(param1:Number = 0, param2:Number = 0, param3:int = 0) : void
      {
         if(!m_globalRumbleEnabled || !this.m_rumbleEnabled)
         {
            return;
         }
         if(this.m_name.toLowerCase().indexOf("playstation") >= 0 || this.m_name.toLowerCase().indexOf("dualshock") >= 0 || this.m_name.toLowerCase().indexOf("dualsense") >= 0)
         {
            param1 *= 0.01;
            param2 *= 0.01;
            trace("[RUMBLE DEBUG] Adjusted rumble for PlayStation controller: Left=" + param1 + ", Right=" + param2);
         }
         param1 = Math.max(0,Math.min(1,param1));
         param2 = Math.max(0,Math.min(1,param2));
         if(param1 <= 0 && param2 <= 0)
         {
            return;
         }
         var _loc4_:int = this.m_xinputIndex >= 0 ? this.m_xinputIndex : this.m_port;
         if(ENABLE_RUMBLE_DEBUG)
         {
            trace("[RUMBLE DEBUG] Gamepad.setRumble() called:");
            trace("  -> Gamepad Name: " + this.m_name);
            trace("  -> m_port (display): " + this.m_port);
            trace("  -> m_xinputIndex: " + this.m_xinputIndex);
            trace("  -> FINAL rumbleIndex being sent: " + _loc4_);
            trace("  -> Left: " + param1 + ", Right: " + param2 + ", Duration: " + param3);
         }
         if(ENABLE_RUMBLE_DEBUG)
         {
            trace("[RUMBLE] Xbox XInput: routing to ANE (port=" + _loc4_ + ")");
         }
         sendRumbleCommand(_loc4_,param1,param2,param3);
      }
      
      public function stopRumble() : void
      {
         this.setRumble(0,0,0);
      }
      
      public function supportsRumble() : Boolean
      {
         return m_aneReady;
      }
      
      public function getRumbleEnabled() : Boolean
      {
         return this.m_rumbleEnabled;
      }
      
      public function setRumbleEnabled(param1:Boolean) : void
      {
         this.m_rumbleEnabled = param1;
      }
      
      private function getXInputButtonBit(param1:String) : uint
      {
         switch(param1)
         {
            case "BUTTON_0":
               return 4096;
            case "BUTTON_1":
               return 8192;
            case "BUTTON_2":
               return 16384;
            case "BUTTON_3":
               return 32768;
            case "BUTTON_4":
               return 256;
            case "BUTTON_5":
               return 512;
            case "BUTTON_6":
               return 32;
            case "BUTTON_7":
               return 16;
            case "BUTTON_8":
               return 64;
            case "BUTTON_9":
               return 128;
            default:
               return 0;
         }
      }
   }
}


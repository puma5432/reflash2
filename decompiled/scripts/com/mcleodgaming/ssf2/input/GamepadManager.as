package com.mcleodgaming.ssf2.input
{
   import com.iam2bam.ane.nativejoystick.NativeJoystick;
   import com.iam2bam.ane.nativejoystick.event.*;
   import com.iam2bam.ane.nativejoystick.intern.*;
   import com.mcleodgaming.ssf2.*;
   import flash.events.*;
   import flash.system.*;
   import flash.ui.*;
   
   public class GamepadManager
   {
      
      protected static var m_nativeJoystick:NativeJoystickMgr;
      
      protected static var m_gameInput:GameInput;
      
      protected static var m_gamepadDeviceMap:Object;
      
      protected static var m_gamepadInstanceMap:Object;
      
      protected static var m_gamepadInstanceList:Vector.<Gamepad>;
      
      public function GamepadManager()
      {
         super();
      }
      
      public static function init() : void
      {
         GamepadManager.m_gamepadDeviceMap = {};
         GamepadManager.m_gamepadInstanceMap = {};
         GamepadManager.m_gamepadInstanceList = new Vector.<Gamepad>();
         if(Version.supportedProfiles.indexOf("extendedDesktop") >= 0 && Capabilities.os.indexOf("Mac") < 0)
         {
            GamepadManager.setupGameInputNative();
         }
         else
         {
            GamepadManager.setupGameInput();
         }
      }
      
      protected static function setupGameInput() : void
      {
         GamepadManager.m_gameInput = new GameInput();
         GamepadManager.m_gameInput.addEventListener(GameInputEvent.DEVICE_ADDED,GamepadManager.onDeviceAttached);
         GamepadManager.m_gameInput.addEventListener(GameInputEvent.DEVICE_REMOVED,GamepadManager.onDeviceRemoved);
         GamepadManager.m_gameInput.addEventListener(GameInputEvent.DEVICE_UNUSABLE,GamepadManager.onDeviceError);
      }
      
      protected static function onDeviceAttached(param1:GameInputEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:GameInputControl = null;
         var _loc4_:GameInputDevice = param1.device;
         var _loc5_:String = _loc4_.id + _loc4_.name;
         GamepadManager.m_gamepadDeviceMap[_loc5_] = _loc4_;
         var _loc6_:Vector.<Gamepad> = getGamepads();
         var _loc7_:int = 1;
         _loc2_ = 0;
         while(_loc2_ < _loc6_.length)
         {
            if(_loc6_[_loc2_].Name === _loc4_.name && _loc6_[_loc2_].Port === _loc7_)
            {
               _loc7_++;
               _loc2_ = -1;
            }
            _loc2_++;
         }
         var _loc8_:Gamepad = m_gamepadInstanceMap[_loc5_] ? m_gamepadInstanceMap[_loc5_] : new Gamepad(_loc4_.name,_loc7_);
         m_gamepadInstanceMap[_loc5_] = _loc8_;
         m_gamepadInstanceList.push(_loc8_);
         _loc4_.enabled = true;
         _loc2_ = 0;
         while(_loc2_ < _loc4_.numControls)
         {
            _loc3_ = _loc4_.getControlAt(_loc2_);
            _loc3_.addEventListener(Event.CHANGE,GamepadManager.onDeviceInput);
            Gamepad(m_gamepadInstanceMap[_loc5_]).registerInput(_loc3_.id,_loc3_.minValue,_loc3_.maxValue,_loc3_.value);
            _loc2_++;
         }
      }
      
      protected static function onDeviceInput(param1:Event) : void
      {
         var _loc2_:GameInputControl = GameInputControl(param1.currentTarget);
         var _loc3_:GameInputDevice = _loc2_.device;
         var _loc4_:String = _loc3_.id + _loc3_.name;
         var _loc5_:Gamepad = Gamepad(m_gamepadInstanceMap[_loc4_]);
         if(_loc5_)
         {
            _loc5_.onDeviceInput(_loc2_.id,_loc2_.value);
         }
      }
      
      protected static function onDeviceRemoved(param1:GameInputEvent) : void
      {
         var _loc2_:GameInputControl = null;
         var _loc5_:int = 0;
         var _loc3_:GameInputDevice = param1.device;
         var _loc4_:String = _loc3_.id + _loc3_.name;
         while(_loc5_ < _loc3_.numControls)
         {
            _loc2_ = _loc3_.getControlAt(_loc5_);
            _loc2_.removeEventListener(Event.CHANGE,Gamepad(m_gamepadInstanceMap[_loc4_]).onDeviceInput);
            _loc5_++;
         }
         m_gamepadInstanceList.splice(m_gamepadInstanceList.indexOf(m_gamepadDeviceMap[_loc4_]),1);
         delete m_gamepadDeviceMap[_loc3_.id + _loc3_.name];
      }
      
      protected static function onDeviceError(param1:GameInputEvent) : void
      {
         trace("Device errroed");
      }
      
      public static function getGamepads() : Vector.<Gamepad>
      {
         var _loc2_:int = 0;
         var _loc1_:Vector.<Gamepad> = new Vector.<Gamepad>();
         while(_loc2_ < m_gamepadInstanceList.length)
         {
            _loc1_.push(m_gamepadInstanceList[_loc2_]);
            _loc2_++;
         }
         return _loc1_;
      }
      
      protected static function setupGameInputNative() : void
      {
         GamepadManager.m_nativeJoystick = new NativeJoystickMgr();
         GamepadManager.m_nativeJoystick.pollInterval = 20;
         GamepadManager.m_nativeJoystick.detectIntervalMillis = 500;
         GamepadManager.m_nativeJoystick.addEventListener(NativeJoystickEvent.JOY_PLUGGED,onDeviceAttachedNative);
         GamepadManager.m_nativeJoystick.addEventListener(NativeJoystickEvent.JOY_UNPLUGGED,onDeviceRemovedNative);
      }
      
      protected static function onDeviceAttachedNative(param1:NativeJoystickEvent) : void
      {
         var e:NativeJoystickEvent = param1;
         var getCaps:Function = function():void
         {
            var joyStick:NativeJoystick = null;
            var identifier:String = null;
            var i:int = 0;
            var oldGamepads:Vector.<Gamepad> = null;
            var targetPort:int = 0;
            var gamepad:Gamepad = null;
            try
            {
               GamepadManager.m_nativeJoystick.getCapabilities(e.joystick.index,e.joystick.capabilities);
            }
            catch(err:*)
            {
               return;
            }
            if(e.joystick.capabilities.numButtons)
            {
               joyStick = e.joystick;
               identifier = (joyStick.capabilities.oemName || "Generic Device") + joyStick.index;
               GamepadManager.m_gamepadDeviceMap[identifier] = joyStick;
               oldGamepads = getGamepads();
               targetPort = 1;
               i = 0;
               while(i < oldGamepads.length)
               {
                  if(oldGamepads[i].Name === (joyStick.capabilities.oemName || "Generic Device") && oldGamepads[i].Port === targetPort)
                  {
                     targetPort += 1;
                     i = -1;
                  }
                  i += 1;
               }
               gamepad = m_gamepadInstanceMap[identifier] ? m_gamepadInstanceMap[identifier] : new Gamepad(joyStick.capabilities.oemName || "Generic Device",targetPort);
               m_gamepadInstanceMap[identifier] = gamepad;
               m_gamepadInstanceList.unshift(gamepad);
               GamepadManager.m_nativeJoystick.addEventListener(NativeJoystickEvent.BUTTON_DOWN,onNativeDeviceInput);
               GamepadManager.m_nativeJoystick.addEventListener(NativeJoystickEvent.BUTTON_UP,onNativeDeviceInput);
               GamepadManager.m_nativeJoystick.addEventListener(NativeJoystickEvent.AXIS_MOVE,onNativeDeviceInput);
               i = 0;
               while(i < joyStick.numButtons)
               {
                  Gamepad(m_gamepadInstanceMap[identifier]).registerInput("BUTTON_" + i,0,1,0);
                  i += 1;
               }
               try
               {
                  i = 0;
                  while(i < e.joystick.capabilities.axesRange.length)
                  {
                     if(e.joystick.hasAxis(i))
                     {
                        Gamepad(m_gamepadInstanceMap[identifier]).registerInput("AXIS_" + i,-1,1,0);
                     }
                     i += 1;
                  }
               }
               catch(e:RangeError)
               {
               }
               catch(e:Error)
               {
                  trace(e);
               }
               fixNativePortOrder();
            }
         };
         getCaps();
      }
      
      protected static function fixNativePortOrder() : void
      {
         var _loc2_:int = 0;
         var _loc1_:Object = {};
         while(_loc2_ < m_gamepadInstanceList.length)
         {
            _loc1_[m_gamepadInstanceList[_loc2_].Name] = _loc1_[m_gamepadInstanceList[_loc2_].Name] || 0;
            ++_loc1_[m_gamepadInstanceList[_loc2_].Name];
            m_gamepadInstanceList[_loc2_].Port = _loc1_[m_gamepadInstanceList[_loc2_].Name];
            _loc2_++;
         }
      }
      
      protected static function onNativeDeviceInput(param1:NativeJoystickEvent) : void
      {
         var _loc2_:Gamepad = null;
         var _loc3_:NativeJoystick = param1.joystick;
         var _loc4_:String = (_loc3_.capabilities.oemName || "Generic Device") + _loc3_.index;
         if(m_gamepadDeviceMap[_loc4_])
         {
            _loc2_ = m_gamepadInstanceMap[_loc4_];
            if(param1.type === NativeJoystickEvent.BUTTON_DOWN)
            {
               _loc2_.onDeviceInput("BUTTON_" + param1.buttonIndex,1);
            }
            else if(param1.type === NativeJoystickEvent.BUTTON_UP)
            {
               _loc2_.onDeviceInput("BUTTON_" + param1.buttonIndex,0);
            }
            else if(param1.type === NativeJoystickEvent.AXIS_MOVE)
            {
               _loc2_.onDeviceInput("AXIS_" + param1.axisIndex,param1.axisValue);
            }
         }
      }
      
      protected static function onDeviceRemovedNative(param1:NativeJoystickEvent) : void
      {
         var _loc2_:NativeJoystick = param1.joystick;
         var _loc3_:String = (_loc2_.capabilities.oemName || "Generic Device") + _loc2_.index;
         GamepadManager.m_nativeJoystick.removeEventListener(NativeJoystickEvent.BUTTON_DOWN,onNativeDeviceInput);
         GamepadManager.m_nativeJoystick.removeEventListener(NativeJoystickEvent.BUTTON_UP,onNativeDeviceInput);
         GamepadManager.m_nativeJoystick.removeEventListener(NativeJoystickEvent.AXIS_MOVE,onNativeDeviceInput);
         m_gamepadInstanceList.splice(m_gamepadInstanceList.indexOf(m_gamepadDeviceMap[_loc3_]),1);
         delete m_gamepadDeviceMap[_loc3_];
      }
   }
}


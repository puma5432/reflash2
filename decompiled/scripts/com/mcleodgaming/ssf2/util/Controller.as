package com.mcleodgaming.ssf2.util
{
   import com.mcleodgaming.ssf2.input.*;
   
   public class Controller
   {
      
      public const _UP:String = "UP";
      
      public const _DOWN:String = "DOWN";
      
      public const _LEFT:String = "LEFT";
      
      public const _RIGHT:String = "RIGHT";
      
      public const _JUMP:String = "JUMP";
      
      public const _BUTTON1:String = "BUTTON1";
      
      public const _BUTTON2:String = "BUTTON2";
      
      public const _GRAB:String = "GRAB";
      
      public const _START:String = "START";
      
      public const _TAUNT:String = "TAUNT";
      
      public const _SHIELD:String = "SHIELD";
      
      public const _SHIELD2:String = "SHIELD2";
      
      public const _JUMP2:String = "JUMP2";
      
      public const _C_UP:String = "C_UP";
      
      public const _C_DOWN:String = "C_DOWN";
      
      public const _C_LEFT:String = "C_LEFT";
      
      public const _C_RIGHT:String = "C_RIGHT";
      
      public const _DASH:String = "DASH";
      
      public const _JUMP3:String = "JUMP3";
      
      public var _TAP_JUMP:int;
      
      public var _AUTO_DASH:int;
      
      public var _DT_DASH:int;
      
      public var isConnected:Boolean = true;
      
      private var m_controlsObject:ControlsObject;
      
      private var _ID:int;
      
      private var m_controlBitsQueue:Vector.<int>;
      
      private var m_objQueue:Vector.<Object>;
      
      private var m_keyboard:Keyboard;
      
      private var m_gamepad:Gamepad;
      
      public function Controller(param1:int, param2:Object)
      {
         var _loc3_:String = null;
         super();
         this._ID = param1;
         this.m_keyboard = new Keyboard();
         this.m_gamepad = null;
         this.setControls(param2);
         this.m_controlsObject = new ControlsObject();
         this.m_controlBitsQueue = new Vector.<int>();
         this.m_objQueue = new Vector.<Object>();
      }
      
      public function get ID() : int
      {
         return this._ID;
      }
      
      public function get ControlsQueue() : Vector.<int>
      {
         return this.m_controlBitsQueue;
      }
      
      public function get KeyboardInstance() : Keyboard
      {
         return this.m_keyboard;
      }
      
      public function get GamepadInstance() : Gamepad
      {
         return this.m_gamepad;
      }
      
      public function set GamepadInstance(param1:Gamepad) : void
      {
         this.m_gamepad = param1;
         if(this.m_gamepad)
         {
            this.m_gamepad.ControlsMap["TAP_JUMP"] = this._TAP_JUMP;
            this.m_gamepad.ControlsMap["AUTO_DASH"] = this._AUTO_DASH;
            this.m_gamepad.ControlsMap["DT_DASH"] = this._DT_DASH;
         }
      }
      
      public function getControls() : Object
      {
         var _loc1_:Object = this.m_keyboard.exportControls();
         _loc1_["TAP_JUMP"] = this._TAP_JUMP;
         _loc1_["AUTO_DASH"] = this._AUTO_DASH;
         _loc1_["DT_DASH"] = this._DT_DASH;
         return _loc1_;
      }
      
      public function getControlStatus() : ControlsObject
      {
         var _loc1_:ControlsObject = new ControlsObject();
         _loc1_.UP = this.IsDown(this._UP);
         _loc1_.DOWN = this.IsDown(this._DOWN);
         _loc1_.LEFT = this.IsDown(this._LEFT);
         _loc1_.RIGHT = this.IsDown(this._RIGHT);
         _loc1_.JUMP = this.IsDown(this._JUMP);
         _loc1_.BUTTON1 = this.IsDown(this._BUTTON1);
         _loc1_.BUTTON2 = this.IsDown(this._BUTTON2);
         _loc1_.GRAB = this.IsDown(this._GRAB);
         _loc1_.START = this.IsDown(this._START);
         _loc1_.TAUNT = this.IsDown(this._TAUNT);
         _loc1_.SHIELD = this.IsDown(this._SHIELD);
         _loc1_.JUMP2 = this.IsDown(this._JUMP2);
         _loc1_.C_UP = this.IsDown(this._C_UP);
         _loc1_.C_DOWN = this.IsDown(this._C_DOWN);
         _loc1_.C_LEFT = this.IsDown(this._C_LEFT);
         _loc1_.C_RIGHT = this.IsDown(this._C_RIGHT);
         _loc1_.DASH = this.IsDown(this._DASH);
         _loc1_.TAP_JUMP = this._TAP_JUMP == 1;
         _loc1_.AUTO_DASH = this._AUTO_DASH == 1;
         _loc1_.DT_DASH = this._DT_DASH == 1;
         _loc1_.SHIELD2 = this.IsDown(this._SHIELD2);
         _loc1_.JUMP3 = _loc1_.TAP_JUMP && this.IsDown(this._UP);
         return _loc1_;
      }
      
      public function queueControlBits(param1:int) : void
      {
         this.m_controlBitsQueue.push(param1);
      }
      
      public function nextControlBits() : int
      {
         var _loc1_:int = this.m_controlBitsQueue.length > 0 ? int(this.m_controlBitsQueue[0]) : 0;
         this.m_controlBitsQueue.splice(0,1);
         return _loc1_;
      }
      
      public function flushControlBits() : Vector.<int>
      {
         return this.m_controlBitsQueue.splice(0,this.m_controlBitsQueue.length);
      }
      
      public function getControlsObject() : ControlsObject
      {
         return this.m_controlsObject;
      }
      
      public function setControlsObject(param1:ControlsObject) : void
      {
         this.m_controlsObject.controls = param1.controls;
      }
      
      public function setControls(param1:Object) : void
      {
         var key:String = null;
         var controls:Object = param1;
         if(controls != null)
         {
            for(key in controls)
            {
               try
               {
                  if(key in this.m_keyboard.ControlsMap)
                  {
                     this.m_keyboard.ControlsMap[key] = controls[key];
                  }
                  else if(["_TAP_JUMP","_AUTO_DASH","_DT_DASH"].indexOf("_" + key) >= 0)
                  {
                     this["_" + key] = controls[key];
                  }
                  else
                  {
                     trace(key + " [in Controller.as] does not exist!!");
                  }
               }
               catch(e:*)
               {
                  trace("A control wasn\'t set somewhere (" + key + ")");
               }
            }
         }
      }
      
      public function IsDown(param1:String) : Boolean
      {
         if(this.m_gamepad)
         {
            return this.m_gamepad.isPressed(param1);
         }
         return this.m_keyboard.isPressed(param1);
      }
   }
}


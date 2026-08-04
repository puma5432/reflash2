package com.mcleodgaming.ssf2.input
{
   import com.mcleodgaming.ssf2.util.*;
   
   public class Keyboard
   {
      
      protected var m_controlState:Object;
      
      protected var m_controlsMap:Object;
      
      public function Keyboard()
      {
         super();
         this.m_controlState = {};
         this.m_controlsMap = {};
         this.resetControlsMap();
      }
      
      public function get ControlsMap() : Object
      {
         return this.m_controlsMap;
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
      }
      
      public function isPressed(param1:String) : Boolean
      {
         return this.getState(param1) ? true : false;
      }
      
      public function getState(param1:String) : Number
      {
         return this.m_controlsMap[param1] === 0 ? 0 : (Key.isDown(this.m_controlsMap[param1]) ? 1 : 0);
      }
      
      public function getValue(param1:String) : Number
      {
         if(this.m_controlState[param1])
         {
            if(this.m_controlState[param1].type === "axis")
            {
               if(this.m_controlState[param1].value > Math.abs(this.m_controlState[param1].maxValue) * this.m_controlState[param1].deadZone)
               {
                  return this.m_controlState[param1].value;
               }
               return 0;
            }
            return this.m_controlState[param1].value;
         }
         return 0;
      }
      
      public function exportControls() : Object
      {
         var _loc1_:* = undefined;
         var _loc2_:Object = {};
         for(_loc1_ in this.m_controlsMap)
         {
            _loc2_[_loc1_] = this.m_controlsMap[_loc1_];
         }
         return _loc2_;
      }
      
      public function importControls(param1:Object) : void
      {
         var _loc2_:* = undefined;
         this.resetControlsMap();
         for(_loc2_ in param1)
         {
            if(this.m_controlsMap[_loc2_] is Number)
            {
               this.m_controlsMap[_loc2_] = param1[_loc2_];
            }
         }
      }
   }
}


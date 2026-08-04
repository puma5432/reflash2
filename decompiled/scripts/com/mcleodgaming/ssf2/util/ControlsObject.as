package com.mcleodgaming.ssf2.util
{
   public class ControlsObject
   {
      
      public static const TAP_JUMP:int = 1 << 0;
      
      public static const SHIELD:int = 1 << 1;
      
      public static const TAUNT:int = 1 << 2;
      
      public static const START:int = 1 << 3;
      
      public static const GRAB:int = 1 << 4;
      
      public static const BUTTON2:int = 1 << 5;
      
      public static const BUTTON1:int = 1 << 6;
      
      public static const JUMP:int = 1 << 7;
      
      public static const RIGHT:int = 1 << 8;
      
      public static const LEFT:int = 1 << 9;
      
      public static const DOWN:int = 1 << 10;
      
      public static const UP:int = 1 << 11;
      
      public static const DT_DASH:int = 1 << 12;
      
      public static const AUTO_DASH:int = 1 << 13;
      
      public static const DASH:int = 1 << 14;
      
      public static const C_RIGHT:int = 1 << 15;
      
      public static const C_LEFT:int = 1 << 16;
      
      public static const C_DOWN:int = 1 << 17;
      
      public static const C_UP:int = 1 << 18;
      
      public static const JUMP2:int = 1 << 19;
      
      public static const SHIELD2:int = 1 << 20;
      
      public static const JUMP3:int = 1 << 21;
      
      public var controls:int;
      
      public function ControlsObject(param1:int = 0)
      {
         super();
         this.controls = param1;
      }
      
      public static function getControls(param1:int, param2:int) : int
      {
         return (param1 | param2) - param2;
      }
      
      public function get TAP_JUMP() : Boolean
      {
         return this.controls & ControlsObject.TAP_JUMP ? true : false;
      }
      
      public function set TAP_JUMP(param1:Boolean) : void
      {
         this.controls = param1 ? this.controls | ControlsObject.TAP_JUMP : this.controls & ~ControlsObject.TAP_JUMP;
      }
      
      public function get SHIELD() : Boolean
      {
         return this.controls & ControlsObject.SHIELD ? true : false;
      }
      
      public function set SHIELD(param1:Boolean) : void
      {
         this.controls = param1 ? this.controls | ControlsObject.SHIELD : this.controls & ~ControlsObject.SHIELD;
      }
      
      public function get TAUNT() : Boolean
      {
         return this.controls & ControlsObject.TAUNT ? true : false;
      }
      
      public function set TAUNT(param1:Boolean) : void
      {
         this.controls = param1 ? this.controls | ControlsObject.TAUNT : this.controls & ~ControlsObject.TAUNT;
      }
      
      public function get START() : Boolean
      {
         return this.controls & ControlsObject.START ? true : false;
      }
      
      public function set START(param1:Boolean) : void
      {
         this.controls = param1 ? this.controls | ControlsObject.START : this.controls & ~ControlsObject.START;
      }
      
      public function get GRAB() : Boolean
      {
         return this.controls & ControlsObject.GRAB ? true : false;
      }
      
      public function set GRAB(param1:Boolean) : void
      {
         this.controls = param1 ? this.controls | ControlsObject.GRAB : this.controls & ~ControlsObject.GRAB;
      }
      
      public function get BUTTON2() : Boolean
      {
         return this.controls & ControlsObject.BUTTON2 ? true : false;
      }
      
      public function set BUTTON2(param1:Boolean) : void
      {
         this.controls = param1 ? this.controls | ControlsObject.BUTTON2 : this.controls & ~ControlsObject.BUTTON2;
      }
      
      public function get BUTTON1() : Boolean
      {
         return this.controls & ControlsObject.BUTTON1 ? true : false;
      }
      
      public function set BUTTON1(param1:Boolean) : void
      {
         this.controls = param1 ? this.controls | ControlsObject.BUTTON1 : this.controls & ~ControlsObject.BUTTON1;
      }
      
      public function get JUMP() : Boolean
      {
         return this.controls & ControlsObject.JUMP ? true : false;
      }
      
      public function set JUMP(param1:Boolean) : void
      {
         this.controls = param1 ? this.controls | ControlsObject.JUMP : this.controls & ~ControlsObject.JUMP;
      }
      
      public function get RIGHT() : Boolean
      {
         return this.controls & ControlsObject.RIGHT ? true : false;
      }
      
      public function set RIGHT(param1:Boolean) : void
      {
         this.controls = param1 ? this.controls | ControlsObject.RIGHT : this.controls & ~ControlsObject.RIGHT;
      }
      
      public function get LEFT() : Boolean
      {
         return this.controls & ControlsObject.LEFT ? true : false;
      }
      
      public function set LEFT(param1:Boolean) : void
      {
         this.controls = param1 ? this.controls | ControlsObject.LEFT : this.controls & ~ControlsObject.LEFT;
      }
      
      public function get DOWN() : Boolean
      {
         return this.controls & ControlsObject.DOWN ? true : false;
      }
      
      public function set DOWN(param1:Boolean) : void
      {
         this.controls = param1 ? this.controls | ControlsObject.DOWN : this.controls & ~ControlsObject.DOWN;
      }
      
      public function get UP() : Boolean
      {
         return this.controls & ControlsObject.UP ? true : false;
      }
      
      public function set UP(param1:Boolean) : void
      {
         this.controls = param1 ? this.controls | ControlsObject.UP : this.controls & ~ControlsObject.UP;
      }
      
      public function get DT_DASH() : Boolean
      {
         return this.controls & ControlsObject.DT_DASH ? true : false;
      }
      
      public function set DT_DASH(param1:Boolean) : void
      {
         this.controls = param1 ? this.controls | ControlsObject.DT_DASH : this.controls & ~ControlsObject.DT_DASH;
      }
      
      public function get AUTO_DASH() : Boolean
      {
         return this.controls & ControlsObject.AUTO_DASH ? true : false;
      }
      
      public function set AUTO_DASH(param1:Boolean) : void
      {
         this.controls = param1 ? this.controls | ControlsObject.AUTO_DASH : this.controls & ~ControlsObject.AUTO_DASH;
      }
      
      public function get DASH() : Boolean
      {
         return this.controls & ControlsObject.DASH ? true : false;
      }
      
      public function set DASH(param1:Boolean) : void
      {
         this.controls = param1 ? this.controls | ControlsObject.DASH : this.controls & ~ControlsObject.DASH;
      }
      
      public function get C_RIGHT() : Boolean
      {
         return this.controls & ControlsObject.C_RIGHT ? true : false;
      }
      
      public function set C_RIGHT(param1:Boolean) : void
      {
         this.controls = param1 ? this.controls | ControlsObject.C_RIGHT : this.controls & ~ControlsObject.C_RIGHT;
      }
      
      public function get C_LEFT() : Boolean
      {
         return this.controls & ControlsObject.C_LEFT ? true : false;
      }
      
      public function set C_LEFT(param1:Boolean) : void
      {
         this.controls = param1 ? this.controls | ControlsObject.C_LEFT : this.controls & ~ControlsObject.C_LEFT;
      }
      
      public function get C_DOWN() : Boolean
      {
         return this.controls & ControlsObject.C_DOWN ? true : false;
      }
      
      public function set C_DOWN(param1:Boolean) : void
      {
         this.controls = param1 ? this.controls | ControlsObject.C_DOWN : this.controls & ~ControlsObject.C_DOWN;
      }
      
      public function get C_UP() : Boolean
      {
         return this.controls & ControlsObject.C_UP ? true : false;
      }
      
      public function set C_UP(param1:Boolean) : void
      {
         this.controls = param1 ? this.controls | ControlsObject.C_UP : this.controls & ~ControlsObject.C_UP;
      }
      
      public function get JUMP2() : Boolean
      {
         return this.controls & ControlsObject.JUMP2 ? true : false;
      }
      
      public function set JUMP2(param1:Boolean) : void
      {
         this.controls = param1 ? this.controls | ControlsObject.JUMP2 : this.controls & ~ControlsObject.JUMP2;
      }
      
      public function get SHIELD2() : Boolean
      {
         return this.controls & ControlsObject.SHIELD2 ? true : false;
      }
      
      public function set SHIELD2(param1:Boolean) : void
      {
         this.controls = param1 ? this.controls | ControlsObject.SHIELD2 : this.controls & ~ControlsObject.SHIELD2;
      }
      
      public function get JUMP3() : Boolean
      {
         return this.controls & ControlsObject.JUMP3 ? true : false;
      }
      
      public function set JUMP3(param1:Boolean) : void
      {
         this.controls = param1 ? this.controls | ControlsObject.JUMP3 : this.controls & ~ControlsObject.JUMP3;
      }
      
      public function reset() : void
      {
         this.controls = 0;
      }
      
      public function clone() : ControlsObject
      {
         return new ControlsObject(this.controls);
      }
   }
}


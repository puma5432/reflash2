package com.mcleodgaming.ssf2.controllers
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.events.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   
   public class SelectHand
   {
      
      protected var BOUNDS_RECT:Rectangle = new Rectangle();
      
      protected var START_POSITION:Point = new Point();
      
      protected var HAND_SPEED:Number = 10;
      
      protected var HAND_ACCEL:Number = 1.5;
      
      protected var m_targetMC:MovieClip;
      
      protected var m_hand:MovieClip;
      
      protected var m_hand_xSpeed:Number;
      
      protected var m_hand_ySpeed:Number;
      
      protected var m_players:Vector.<Controller>;
      
      protected var m_leftRightID:int;
      
      protected var m_upDownID:int;
      
      protected var m_buttons:Vector.<HandButton>;
      
      protected var m_rollOverID:int;
      
      protected var m_backFunc:Function;
      
      protected var m_autoKillEvents:Boolean;
      
      protected var m_clickEventClipsCheckBounds:Vector.<DisplayObject>;
      
      protected var m_clickEventClipsHitTest:Vector.<DisplayObject>;
      
      protected var m_selectLetGo:Object;
      
      protected var m_backLetGo:Object;
      
      protected var m_lastControllerIndex:int = -1;
      
      public function SelectHand(param1:MovieClip, param2:Vector.<HandButton>, param3:Function)
      {
         super();
         this.m_targetMC = param1;
         this.m_backFunc = param3;
         this.m_hand = MovieClip(this.m_targetMC.addChild(ResourceManager.getLibraryMC("stageselect_hand")));
         this.m_hand.visible = false;
         this.m_hand_xSpeed = 0;
         this.m_hand_ySpeed = 0;
         this.m_selectLetGo = {};
         this.m_backLetGo = {};
         this.m_players = new Vector.<Controller>();
         var _loc4_:int = 1;
         while(_loc4_ <= SaveData.Controllers.length)
         {
            this.m_players.push(Controller(SaveData.Controllers[_loc4_ - 1]));
            _loc4_++;
         }
         this.m_leftRightID = -1;
         this.m_upDownID = -1;
         this.m_buttons = param2;
         this.m_rollOverID = -1;
         this.m_autoKillEvents = true;
         this.BOUNDS_RECT = new Rectangle();
         this.START_POSITION = new Point();
         this.START_POSITION.x = -246;
         this.START_POSITION.y = -132;
         this.BOUNDS_RECT.x = -303;
         this.BOUNDS_RECT.y = -145;
         this.BOUNDS_RECT.width = 600;
         this.BOUNDS_RECT.height = 320;
         this.HAND_SPEED = 10;
         this.HAND_ACCEL = 3;
         this.m_clickEventClipsCheckBounds = new Vector.<DisplayObject>();
         this.m_clickEventClipsHitTest = new Vector.<DisplayObject>();
      }
      
      public function get rollOverID() : int
      {
         return this.m_rollOverID;
      }
      
      public function get lastControllerIndex() : int
      {
         return this.m_lastControllerIndex;
      }
      
      public function setBackFunction(param1:Function) : void
      {
         this.m_backFunc = param1;
      }
      
      public function setAutoKillEvents(param1:Boolean) : void
      {
         this.m_autoKillEvents = param1;
      }
      
      public function addClickEventClipCheckBounds(param1:DisplayObject) : void
      {
         if(this.m_clickEventClipsCheckBounds.indexOf(param1) < 0)
         {
            this.m_clickEventClipsCheckBounds.push(param1);
         }
      }
      
      public function removeClickEventClipCheckBounds(param1:DisplayObject) : void
      {
         var _loc2_:int = this.m_clickEventClipsCheckBounds.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this.m_clickEventClipsCheckBounds.splice(_loc2_,1);
         }
      }
      
      public function addClickEventClipHitTest(param1:DisplayObject) : void
      {
         if(this.m_clickEventClipsHitTest.indexOf(param1) < 0)
         {
            this.m_clickEventClipsHitTest.push(param1);
         }
      }
      
      public function removeClickEventClipHitTest(param1:DisplayObject) : void
      {
         var _loc2_:int = this.m_clickEventClipsHitTest.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this.m_clickEventClipsHitTest.splice(_loc2_,1);
         }
      }
      
      public function makeEvents() : void
      {
         var _loc1_:int = 0;
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,this.checkControls);
         Main.Root.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.checkHit);
         while(_loc1_ < SaveData.Controllers.length)
         {
            if(SaveData.Controllers[_loc1_].GamepadInstance)
            {
               SaveData.Controllers[_loc1_].GamepadInstance.addEventListener(GamepadEvent.BUTTON_DOWN,this.checkHit);
            }
            _loc1_++;
         }
         this.resetPosition();
         this.resetLetGo();
      }
      
      public function killEvents() : void
      {
         var _loc1_:int = 0;
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,this.checkControls);
         Main.Root.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.checkHit);
         while(_loc1_ < SaveData.Controllers.length)
         {
            if(SaveData.Controllers[_loc1_].GamepadInstance)
            {
               SaveData.Controllers[_loc1_].GamepadInstance.removeEventListener(GamepadEvent.BUTTON_DOWN,this.checkHit);
            }
            _loc1_++;
         }
      }
      
      public function resetLetGo() : void
      {
         this.m_backLetGo = {};
         this.m_selectLetGo = {};
      }
      
      public function get HandMC() : MovieClip
      {
         return this.m_hand;
      }
      
      public function resetPosition(param1:Point = null, param2:Rectangle = null) : void
      {
         if(param1)
         {
            this.START_POSITION.x = param1.x;
            this.START_POSITION.y = param1.y;
         }
         if(param2)
         {
            this.BOUNDS_RECT.x = param2.x;
            this.BOUNDS_RECT.y = param2.y;
            this.BOUNDS_RECT.width = param2.width;
            this.BOUNDS_RECT.height = param2.height;
         }
         this.m_hand.x = this.START_POSITION.x;
         this.m_hand.y = this.START_POSITION.y;
      }
      
      protected function validateLeftRightID(param1:int) : Boolean
      {
         return param1 == this.m_leftRightID || this.m_leftRightID == -1;
      }
      
      protected function validateUpDownID(param1:int) : Boolean
      {
         return param1 == this.m_upDownID || this.m_upDownID == -1;
      }
      
      protected function move() : void
      {
         this.m_hand.x += this.m_hand_xSpeed;
         this.m_hand.y += this.m_hand_ySpeed;
         this.checkHit(new Event(Event.ENTER_FRAME));
      }
      
      protected function checkControls(param1:Event) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         while(_loc5_ < this.m_players.length)
         {
            if(this.m_players[_loc5_].IsDown(this.m_players[_loc5_]._START))
            {
               _loc2_ = true;
            }
            if(this.m_players[_loc5_].IsDown(this.m_players[_loc5_]._BUTTON2))
            {
               _loc3_ = true;
            }
            if(this.m_players[_loc5_].IsDown(this.m_players[_loc5_]._BUTTON1))
            {
               _loc4_ = true;
            }
            if(this.validateUpDownID(_loc5_) && this.m_players[_loc5_].IsDown(this.m_players[_loc5_]._UP) && !this.m_players[_loc5_].IsDown(this.m_players[_loc5_]._DOWN))
            {
               this.m_hand.visible = true;
               this.m_hand_ySpeed -= this.m_hand_ySpeed > -this.HAND_SPEED && this.m_hand.y > this.BOUNDS_RECT.y ? this.HAND_ACCEL : 0;
               this.m_upDownID = _loc5_;
               if(this.m_hand.y <= this.BOUNDS_RECT.y || this.m_hand_ySpeed > 0)
               {
                  this.m_hand_ySpeed = 0;
               }
            }
            else if(this.validateUpDownID(_loc5_) && this.m_players[_loc5_].IsDown(this.m_players[_loc5_]._DOWN) && !this.m_players[_loc5_].IsDown(this.m_players[_loc5_]._UP))
            {
               this.m_hand.visible = true;
               this.m_hand_ySpeed += this.m_hand_ySpeed < this.HAND_SPEED && this.m_hand.y < this.BOUNDS_RECT.y + this.BOUNDS_RECT.height ? this.HAND_ACCEL : 0;
               this.m_upDownID = _loc5_;
               if(this.m_hand.y >= this.BOUNDS_RECT.y + this.BOUNDS_RECT.height || this.m_hand_ySpeed < 0)
               {
                  this.m_hand_ySpeed = 0;
               }
            }
            else if(this.m_upDownID == _loc5_ && this.m_upDownID != -1)
            {
               this.m_hand_ySpeed = 0;
               this.m_upDownID = -1;
            }
            if(this.validateLeftRightID(_loc5_) && this.m_players[_loc5_].IsDown(this.m_players[_loc5_]._LEFT) && !this.m_players[_loc5_].IsDown(this.m_players[_loc5_]._RIGHT))
            {
               this.m_hand.visible = true;
               this.m_hand_xSpeed -= this.m_hand_xSpeed > -this.HAND_SPEED && this.m_hand.x > this.BOUNDS_RECT.x ? this.HAND_ACCEL : 0;
               this.m_leftRightID = _loc5_;
               if(this.m_hand.x <= this.BOUNDS_RECT.x || this.m_hand_xSpeed > 0)
               {
                  this.m_hand_xSpeed = 0;
               }
            }
            else if(this.validateLeftRightID(_loc5_) && this.m_players[_loc5_].IsDown(this.m_players[_loc5_]._RIGHT) && !this.m_players[_loc5_].IsDown(this.m_players[_loc5_]._LEFT))
            {
               this.m_hand.visible = true;
               this.m_hand_xSpeed += this.m_hand_xSpeed < this.HAND_SPEED && this.m_hand.x < this.BOUNDS_RECT.x + this.BOUNDS_RECT.width ? this.HAND_ACCEL : 0;
               this.m_leftRightID = _loc5_;
               if(this.m_hand.x >= this.BOUNDS_RECT.x + this.BOUNDS_RECT.width || this.m_hand_xSpeed < 0)
               {
                  this.m_hand_xSpeed = 0;
               }
            }
            else if(this.m_leftRightID == _loc5_ && this.m_leftRightID != -1)
            {
               this.m_hand_xSpeed = 0;
               this.m_leftRightID = -1;
            }
            _loc5_++;
         }
         this.move();
      }
      
      protected function checkHit(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc5_:int = 0;
         var _loc4_:Boolean = param1 is KeyboardEvent || param1 is GamepadEvent;
         _loc2_ = 0;
         while(_loc2_ < this.m_players.length)
         {
            if(!this.m_players[_loc2_].IsDown(this.m_players[_loc2_]._BUTTON2) && !this.m_players[_loc2_].IsDown(this.m_players[_loc2_]._START))
            {
               this.m_selectLetGo[_loc2_] = true;
            }
            if(!this.m_players[_loc2_].IsDown(this.m_players[_loc2_]._BUTTON1))
            {
               this.m_backLetGo[_loc2_] = true;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         if(this.m_targetMC.root == null)
         {
            this.killEvents();
         }
         else
         {
            _loc3_ = false;
            _loc2_ = 0;
            while(_loc2_ < this.m_players.length)
            {
               if(Boolean(this.m_backLetGo[_loc2_]) && this.m_players[_loc2_].IsDown(this.m_players[_loc2_]._BUTTON1))
               {
                  if(this.m_backFunc != null)
                  {
                     this.m_backLetGo[_loc2_] = false;
                     if(this.m_autoKillEvents)
                     {
                        this.killEvents();
                     }
                     this.m_backFunc(null);
                     return;
                  }
               }
               _loc2_++;
            }
            _loc5_ = 0;
            while(_loc5_ < this.m_buttons.length && !_loc3_)
            {
               if(this.checkBounds(this.m_buttons[_loc5_].ButtonInstance) && this.m_hand.visible)
               {
                  if(this.m_rollOverID != _loc5_)
                  {
                     if(this.m_rollOverID != -1)
                     {
                        this.m_buttons[this.m_rollOverID].rollout();
                        this.m_buttons[this.m_rollOverID].mouseout();
                     }
                     this.m_buttons[_loc5_].rollover();
                     this.m_buttons[_loc5_].mouseover();
                  }
                  this.m_rollOverID = _loc5_;
                  _loc3_ = true;
                  _loc2_ = 0;
                  while(_loc2_ < this.m_players.length && _loc4_)
                  {
                     if(this.m_players[_loc2_].IsDown(this.m_players[_loc2_]._BUTTON2) || this.m_players[_loc2_].IsDown(this.m_players[_loc2_]._START))
                     {
                        this.m_lastControllerIndex = _loc2_;
                        this.m_buttons[_loc5_].click();
                        return;
                     }
                     _loc2_++;
                  }
               }
               _loc5_++;
            }
            if(_loc4_)
            {
               this.evaluateExtraButtons();
            }
            if(!_loc3_)
            {
               if(this.m_rollOverID != -1)
               {
                  this.m_buttons[this.m_rollOverID].rollout();
               }
               this.m_rollOverID = -1;
            }
         }
      }
      
      protected function evaluateExtraButtons() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.m_clickEventClipsCheckBounds.length)
         {
            if(this.checkBounds(this.m_clickEventClipsCheckBounds[_loc1_]) && this.m_hand.visible)
            {
               _loc2_ = 0;
               while(_loc2_ < this.m_players.length)
               {
                  if(Boolean(this.m_selectLetGo[_loc2_]) && this.m_players[_loc2_].IsDown(this.m_players[_loc2_]._BUTTON2))
                  {
                     this.m_selectLetGo[_loc2_] = false;
                     this.m_clickEventClipsCheckBounds[_loc1_].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
                  _loc2_++;
               }
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.m_clickEventClipsHitTest.length)
         {
            if(this.m_hand.hitTestObject(this.m_clickEventClipsHitTest[_loc1_]) && this.m_hand.visible)
            {
               _loc2_ = 0;
               while(_loc2_ < this.m_players.length)
               {
                  if(Boolean(this.m_selectLetGo[_loc2_]) && this.m_players[_loc2_].IsDown(this.m_players[_loc2_]._BUTTON2))
                  {
                     this.m_selectLetGo[_loc2_] = false;
                     this.m_clickEventClipsHitTest[_loc1_].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
                  _loc2_++;
               }
            }
            _loc1_++;
         }
      }
      
      protected function checkBounds(param1:DisplayObject, param2:DisplayObject = null) : Boolean
      {
         var _loc3_:Rectangle = param1.getBounds(param2 ? param2 : param1.parent);
         return param1.visible && _loc3_.containsPoint(new Point(this.m_hand.x,this.m_hand.y));
      }
   }
}


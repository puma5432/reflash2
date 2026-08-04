package com.mcleodgaming.ssf2.controllers
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.menus.*;
   import com.mcleodgaming.ssf2.modapi.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.TextField;
   
   public class Chip
   {
      
      private var HAND_MAX_SPEED:Number = 14;
      
      private var HAND_ACCEL:Number = 1.5;
      
      private var m_chip:MovieClip;
      
      private var m_grabbedChip:Chip;
      
      private var m_hand:MovieClip;
      
      private var m_hand_xSpeed:Number;
      
      private var m_hand_ySpeed:Number;
      
      private var m_keyLetGo:Boolean;
      
      private var m_key2LetGo:Boolean;
      
      private var m_prevCostumeKey:Boolean;
      
      private var m_prevCostumeKeyLetGo:Boolean;
      
      private var m_nextCostumeKey:Boolean;
      
      private var m_nextCostumeKeyLetGo:Boolean;
      
      private var m_playerID:int;
      
      private var m_lastHit:String;
      
      private var m_pressed:Boolean;
      
      private var m_held:Boolean;
      
      private var m_expansionNum:Number;
      
      private var m_keys:Controller;
      
      private var m_backTimer:FrameTimer;
      
      private var m_handBoundary:Rectangle;
      
      private var m_chipBoundary:Rectangle;
      
      private var m_originalPosition:Point;
      
      private var m_characterSelectMenu:CharacterSelectMenu;
      
      public function Chip(param1:CharacterSelectMenu, param2:MovieClip, param3:int)
      {
         super();
         this.m_characterSelectMenu = param1;
         this.m_chip = param2;
         this.m_originalPosition = new Point(param2.x,param2.y);
         this.m_grabbedChip = null;
         this.m_playerID = param3;
         this.m_lastHit = null;
         this.m_pressed = false;
         this.m_held = false;
         this.m_expansionNum = 0;
         this.m_hand_xSpeed = 0;
         this.m_hand_ySpeed = 0;
         this.m_keyLetGo = false;
         this.m_key2LetGo = false;
         this.m_prevCostumeKey = false;
         this.m_prevCostumeKeyLetGo = false;
         this.m_nextCostumeKey = false;
         this.m_nextCostumeKeyLetGo = false;
         this.m_hand = ResourceManager.getLibraryMC("charselect_hand");
         Utils.tryToGotoAndStop(this.m_hand,"p" + this.m_playerID);
         this.m_hand.visible = false;
         this.m_hand.x = this.m_chip.x;
         this.m_hand.y = this.m_chip.y;
         this.m_keys = SaveData.Controllers[param3 - 1];
         this.m_chip.visible = false;
         this.m_backTimer = new FrameTimer(60);
         var _loc4_:Object = ResourceManager.getResourceByID("mappings").getProp("metadata");
         var _loc5_:Object = _loc4_.character_select_screen;
         this.m_handBoundary = new Rectangle(_loc5_.hand_bounds.x,_loc5_.hand_bounds.y,_loc5_.hand_bounds.width,_loc5_.hand_bounds.height);
         this.m_chipBoundary = new Rectangle(_loc5_.chip_bounds.x,_loc5_.chip_bounds.y,_loc5_.chip_bounds.width,_loc5_.chip_bounds.height);
      }
      
      public function get OriginalPosition() : Point
      {
         return this.m_originalPosition;
      }
      
      public function resetLetGo() : void
      {
         this.m_keyLetGo = false;
         this.m_key2LetGo = false;
      }
      
      public function makeEvents() : void
      {
         this.m_chip.addEventListener(MouseEvent.MOUSE_DOWN,this.press);
         Main.Root.stage.addEventListener(MouseEvent.MOUSE_UP,this.release);
         this.m_hand.addEventListener(Event.ENTER_FRAME,this.checkGrab);
         this.m_keyLetGo = false;
         this.m_key2LetGo = false;
      }
      
      public function killEvents() : void
      {
         this.m_chip.removeEventListener(MouseEvent.MOUSE_DOWN,this.press);
         Main.Root.stage.removeEventListener(MouseEvent.MOUSE_UP,this.release);
         this.m_hand.removeEventListener(Event.ENTER_FRAME,this.checkGrab);
      }
      
      public function incrementExpansionNum() : void
      {
         this.m_expansionNum = ResourceManager.getNextExpansionCharacter(this.m_expansionNum);
         this.m_characterSelectMenu.setPlayer(this.m_playerID,this.m_lastHit,this.m_expansionNum);
      }
      
      public function decrementExpansionNum() : void
      {
         this.m_expansionNum = ResourceManager.getPrevExpansionCharacter(this.m_expansionNum);
         this.m_characterSelectMenu.setPlayer(this.m_playerID,this.m_lastHit,this.m_expansionNum);
      }
      
      private function checkControls() : void
      {
         if(!(Boolean(ModeFeatures.hasFeature(ModeFeatures.FORCE_SINGLE_PLAYER,this.m_characterSelectMenu.GameObj.GameMode)) && this.m_playerID != 1) && !(Boolean(ModeFeatures.hasFeature(ModeFeatures.FORCE_TWO_PLAYER,this.m_characterSelectMenu.GameObj.GameMode)) && this.m_playerID > 2))
         {
            if(Boolean(this.m_keys.IsDown(this.m_keys._UP)) && !this.m_keys.IsDown(this.m_keys._DOWN))
            {
               this.m_hand.visible = true;
               this.m_hand_ySpeed -= this.m_hand_ySpeed > -this.HAND_MAX_SPEED && this.m_hand.y > this.m_handBoundary.y ? this.HAND_ACCEL : 0;
               if(this.m_hand.y <= this.m_handBoundary.y || this.m_hand_ySpeed > 0)
               {
                  this.m_hand_ySpeed = 0;
               }
            }
            else if(Boolean(this.m_keys.IsDown(this.m_keys._DOWN)) && !this.m_keys.IsDown(this.m_keys._UP))
            {
               this.m_hand.visible = true;
               this.m_hand_ySpeed += this.m_hand_ySpeed < this.HAND_MAX_SPEED && this.m_hand.y < this.m_handBoundary.y + this.m_handBoundary.height ? this.HAND_ACCEL : 0;
               if(this.m_hand.y >= this.m_handBoundary.y + this.m_handBoundary.height || this.m_hand_ySpeed < 0)
               {
                  this.m_hand_ySpeed = 0;
               }
            }
            else
            {
               this.m_hand_ySpeed = 0;
            }
            if(Boolean(this.m_keys.IsDown(this.m_keys._LEFT)) && !this.m_keys.IsDown(this.m_keys._RIGHT))
            {
               this.m_hand.visible = true;
               this.m_hand_xSpeed -= this.m_hand_xSpeed > -this.HAND_MAX_SPEED && this.m_hand.x > this.m_handBoundary.x ? this.HAND_ACCEL : 0;
               if(this.m_hand.x <= this.m_handBoundary.x || this.m_hand_xSpeed > 0)
               {
                  this.m_hand_xSpeed = 0;
               }
            }
            else if(Boolean(this.m_keys.IsDown(this.m_keys._RIGHT)) && !this.m_keys.IsDown(this.m_keys._LEFT))
            {
               this.m_hand.visible = true;
               this.m_hand_xSpeed += this.m_hand_xSpeed < this.HAND_MAX_SPEED && this.m_hand.x < this.m_handBoundary.x + this.m_handBoundary.width ? this.HAND_ACCEL : 0;
               if(this.m_hand.x >= this.m_handBoundary.x + this.m_handBoundary.width || this.m_hand_xSpeed < 0)
               {
                  this.m_hand_xSpeed = 0;
               }
            }
            else
            {
               this.m_hand_xSpeed = 0;
            }
            if(!this.m_keys.IsDown(this.m_keys._BUTTON2))
            {
               this.m_keyLetGo = true;
            }
            if(!this.m_keys.IsDown(this.m_keys._BUTTON1))
            {
               this.m_key2LetGo = true;
            }
         }
         if(!this.m_keys.IsDown(this.m_keys._GRAB) && !this.m_keys.IsDown(this.m_keys._SHIELD2))
         {
            this.m_prevCostumeKeyLetGo = true;
         }
         if(!this.m_keys.IsDown(this.m_keys._SHIELD))
         {
            this.m_nextCostumeKeyLetGo = true;
         }
         this.m_prevCostumeKey = Boolean(this.m_keys.IsDown(this.m_keys._GRAB)) || Boolean(this.m_keys.IsDown(this.m_keys._SHIELD2));
         this.m_nextCostumeKey = this.m_keys.IsDown(this.m_keys._SHIELD);
         if(Boolean(this.m_prevCostumeKey) && Boolean(this.m_prevCostumeKeyLetGo))
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            this.m_characterSelectMenu.prevCostume(this.m_playerID);
            this.m_prevCostumeKeyLetGo = false;
         }
         if(Boolean(this.m_nextCostumeKey) && Boolean(this.m_nextCostumeKeyLetGo))
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            this.m_characterSelectMenu.nextCostume(this.m_playerID);
            this.m_nextCostumeKeyLetGo = false;
         }
      }
      
      private function checkOutOfChipBounds() : void
      {
         if(Boolean(this.m_hand_ySpeed < 0) && Boolean(this.m_grabbedChip) && this.m_grabbedChip.Y < this.m_chipBoundary.y)
         {
            this.m_grabbedChip.Y = this.m_chipBoundary.y;
            this.m_grabbedChip.Held = false;
            this.m_grabbedChip.checkCollision();
            this.m_grabbedChip = null;
            this.m_held = false;
         }
      }
      
      private function move() : void
      {
         this.m_hand.x += this.m_hand_xSpeed;
         this.m_hand.y += this.m_hand_ySpeed;
         if(this.m_hand_ySpeed < 0)
         {
            this.checkOutOfChipBounds();
         }
         if(Boolean(this.m_held) && this.m_grabbedChip != null)
         {
            this.m_grabbedChip.MC.x = this.m_hand.x;
            this.m_grabbedChip.MC.y = this.m_hand.y;
         }
      }
      
      private function checkGrab(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TextField = null;
         var _loc4_:int = 0;
         if(!(MenuController.rulesMenu && MenuController.rulesMenu.isOnscreen()) && !(MenuController.controlsMenu && MenuController.controlsMenu.isOnscreen()))
         {
            if(!this.m_keys.IsDown(this.m_keys._BUTTON1))
            {
               this.m_backTimer.reset();
            }
            else
            {
               this.m_backTimer.tick();
               if(this.m_backTimer.IsComplete)
               {
                  MenuController.CurrentCharacterSelectMenu.backMain_CLICK(null);
                  return;
               }
            }
            if(this.m_playerID == 1)
            {
               this.m_characterSelectMenu.ReadyDelay.tick();
            }
            if(this.m_grabbedChip != null && !this.m_grabbedChip.Visible)
            {
               this.m_grabbedChip.Held = false;
               this.m_grabbedChip = null;
            }
            this.checkControls();
            this.move();
            if(Boolean(this.m_key2LetGo) && Boolean(this.m_chip.visible) && this.m_grabbedChip == null && !this.m_held && !this.m_pressed && Boolean(this.m_hand.visible) && Boolean(this.m_keys.IsDown(this.m_keys._BUTTON1)) && this.m_hand.y >= this.m_chipBoundary.y && !this.m_chip.parent.parent["display" + this.m_playerID]["nameDisplay"]["nameKeyPad"].visible)
            {
               this.m_keyLetGo = false;
               this.m_key2LetGo = false;
               this.m_characterSelectMenu.setPlayer(this.m_playerID,null);
               this.m_lastHit = null;
               this.m_grabbedChip = this;
               this.m_grabbedChip.Held = true;
               this.m_grabbedChip.MC.x = this.m_hand.x;
               this.m_grabbedChip.MC.y = this.m_hand.y;
            }
            if(Boolean(this.m_grabbedChip == null && !this.m_held && this.m_keyLetGo && !this.m_pressed && this.m_hand.visible && this.m_hand.hitBox.hitTestObject(this.m_chip)) && Boolean(this.m_keys.IsDown(this.m_keys._BUTTON2)) && this.m_hand.y >= this.m_chipBoundary.y)
            {
               this.m_characterSelectMenu.setPlayer(this.m_playerID,null);
               this.m_lastHit = null;
               this.m_grabbedChip = this;
               this.m_key2LetGo = false;
               this.m_keyLetGo = false;
               this.m_grabbedChip.Held = true;
            }
            if(this.m_grabbedChip == null && !this.m_held && Boolean(this.m_keyLetGo) && !this.m_pressed && Boolean(this.m_hand.visible) && Boolean(this.m_keys.IsDown(this.m_keys._BUTTON2)) && this.m_hand.y >= this.m_chipBoundary.y)
            {
               _loc2_ = 1;
               while(_loc2_ <= this.m_characterSelectMenu.GameObj.PlayerSettings.length && !this.m_held)
               {
                  if(_loc2_ != this.m_playerID && !this.m_characterSelectMenu.PlayerChips[_loc2_ - 1].Held && !this.m_characterSelectMenu.PlayerChips[_loc2_ - 1].Pressed && this.m_characterSelectMenu.PlayerChips[_loc2_ - 1] != null && Boolean(this.m_characterSelectMenu.PlayerChips[_loc2_ - 1].MC.visible) && this.m_characterSelectMenu.PlayerChips[_loc2_ - 1].MC.currentLabel == "cpu" && Boolean(this.m_hand.hitBox.hitTestObject(this.m_characterSelectMenu.PlayerChips[_loc2_ - 1].MC)))
                  {
                     this.m_characterSelectMenu.setPlayer(_loc2_,null);
                     this.m_characterSelectMenu.PlayerChips[_loc2_ - 1].LastHit = null;
                     this.m_grabbedChip = this.m_characterSelectMenu.PlayerChips[_loc2_ - 1];
                     this.m_key2LetGo = false;
                     this.m_keyLetGo = false;
                     this.m_held = true;
                     this.m_grabbedChip.Held = true;
                  }
                  _loc2_++;
               }
            }
            if(this.m_grabbedChip != null && Boolean(this.m_keyLetGo) && Boolean(this.m_held) && Boolean(this.m_keys.IsDown(this.m_keys._BUTTON2)))
            {
               this.m_grabbedChip.checkCollision();
               this.m_key2LetGo = false;
               this.m_keyLetGo = false;
               this.m_grabbedChip.Held = false;
               this.m_held = false;
               this.m_grabbedChip = null;
            }
            if(this.m_grabbedChip == null && Boolean(this.m_hand.visible) && Boolean(this.m_keyLetGo) && Boolean(this.m_keys.IsDown(this.m_keys._BUTTON1)))
            {
               if(this.m_chip.parent.parent["display" + this.m_playerID]["nameDisplay"]["nameKeyPad"].visible)
               {
                  if(this.m_key2LetGo)
                  {
                     this.m_key2LetGo = false;
                     _loc3_ = this.m_chip.parent.parent["display" + this.m_playerID]["nameDisplay"]["nameTxt"];
                     if(_loc3_.length > 0)
                     {
                        _loc3_.text = _loc3_.text.substr(0,_loc3_.length - 1);
                     }
                     else
                     {
                        DisplayObject(this.m_chip.parent.parent["display" + this.m_playerID]["nameDisplay"]["nameKeyPad"]["btn_done"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                     }
                  }
               }
            }
            if(this.m_grabbedChip == null && Boolean(this.m_hand.visible) && Boolean(this.m_keyLetGo) && Boolean(this.m_keys.IsDown(this.m_keys._BUTTON2)))
            {
               if(this.m_characterSelectMenu.GameObj.PlayerSettings[this.m_playerID - 1].human)
               {
                  if(this.m_chip.parent.parent["display" + this.m_playerID]["nameDisplay"]["nameKeyPad"].visible)
                  {
                     if(Boolean(this.m_keyLetGo) && Boolean(this.checkBoundsKeypad(this.m_chip.parent.parent["display" + this.m_playerID]["nameDisplay"]["nameKeyPad"]["btn_abc"])))
                     {
                        this.m_keyLetGo = false;
                        DisplayObject(this.m_chip.parent.parent["display" + this.m_playerID]["nameDisplay"]["nameKeyPad"]["btn_abc"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                     }
                     if(Boolean(this.m_keyLetGo) && Boolean(this.checkBoundsKeypad(this.m_chip.parent.parent["display" + this.m_playerID]["nameDisplay"]["nameKeyPad"]["btn_abc"])))
                     {
                        this.m_keyLetGo = false;
                        DisplayObject(this.m_chip.parent.parent["display" + this.m_playerID]["nameDisplay"]["nameKeyPad"]["btn_abc"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                     }
                     if(Boolean(this.m_keyLetGo) && Boolean(this.checkBoundsKeypad(this.m_chip.parent.parent["display" + this.m_playerID]["nameDisplay"]["nameKeyPad"]["btn_def"])))
                     {
                        this.m_keyLetGo = false;
                        DisplayObject(this.m_chip.parent.parent["display" + this.m_playerID]["nameDisplay"]["nameKeyPad"]["btn_def"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                     }
                     if(Boolean(this.m_keyLetGo) && Boolean(this.checkBoundsKeypad(this.m_chip.parent.parent["display" + this.m_playerID]["nameDisplay"]["nameKeyPad"]["btn_ghi"])))
                     {
                        this.m_keyLetGo = false;
                        DisplayObject(this.m_chip.parent.parent["display" + this.m_playerID]["nameDisplay"]["nameKeyPad"]["btn_ghi"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                     }
                     if(Boolean(this.m_keyLetGo) && Boolean(this.checkBoundsKeypad(this.m_chip.parent.parent["display" + this.m_playerID]["nameDisplay"]["nameKeyPad"]["btn_jkl"])))
                     {
                        this.m_keyLetGo = false;
                        DisplayObject(this.m_chip.parent.parent["display" + this.m_playerID]["nameDisplay"]["nameKeyPad"]["btn_jkl"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                     }
                     if(Boolean(this.m_keyLetGo) && Boolean(this.checkBoundsKeypad(this.m_chip.parent.parent["display" + this.m_playerID]["nameDisplay"]["nameKeyPad"]["btn_mno"])))
                     {
                        this.m_keyLetGo = false;
                        DisplayObject(this.m_chip.parent.parent["display" + this.m_playerID]["nameDisplay"]["nameKeyPad"]["btn_mno"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                     }
                     if(Boolean(this.m_keyLetGo) && Boolean(this.checkBoundsKeypad(this.m_chip.parent.parent["display" + this.m_playerID]["nameDisplay"]["nameKeyPad"]["btn_pqrs"])))
                     {
                        this.m_keyLetGo = false;
                        DisplayObject(this.m_chip.parent.parent["display" + this.m_playerID]["nameDisplay"]["nameKeyPad"]["btn_pqrs"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                     }
                     if(Boolean(this.m_keyLetGo) && Boolean(this.checkBoundsKeypad(this.m_chip.parent.parent["display" + this.m_playerID]["nameDisplay"]["nameKeyPad"]["btn_tuv"])))
                     {
                        this.m_keyLetGo = false;
                        DisplayObject(this.m_chip.parent.parent["display" + this.m_playerID]["nameDisplay"]["nameKeyPad"]["btn_tuv"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                     }
                     if(Boolean(this.m_keyLetGo) && Boolean(this.checkBoundsKeypad(this.m_chip.parent.parent["display" + this.m_playerID]["nameDisplay"]["nameKeyPad"]["btn_wxyz"])))
                     {
                        this.m_keyLetGo = false;
                        DisplayObject(this.m_chip.parent.parent["display" + this.m_playerID]["nameDisplay"]["nameKeyPad"]["btn_wxyz"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                     }
                     if(Boolean(this.m_keyLetGo) && Boolean(this.checkBoundsKeypad(this.m_chip.parent.parent["display" + this.m_playerID]["nameDisplay"]["nameKeyPad"]["btn_misc"])))
                     {
                        this.m_keyLetGo = false;
                        DisplayObject(this.m_chip.parent.parent["display" + this.m_playerID]["nameDisplay"]["nameKeyPad"]["btn_misc"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                     }
                     if(Boolean(this.m_keyLetGo) && Boolean(this.checkBoundsKeypad(this.m_chip.parent.parent["display" + this.m_playerID]["nameDisplay"]["nameKeyPad"]["btn_done"])))
                     {
                        this.m_keyLetGo = false;
                        DisplayObject(this.m_chip.parent.parent["display" + this.m_playerID]["nameDisplay"]["nameKeyPad"]["btn_done"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                     }
                  }
                  else if(Boolean(this.m_keyLetGo) && Boolean(this.m_hand.hitBox.hitTestObject(this.m_chip.parent.parent["display" + this.m_playerID]["nameDisplay"]["btn_keypad"])))
                  {
                     this.m_keyLetGo = false;
                     DisplayObject(this.m_chip.parent.parent["display" + this.m_playerID]["nameDisplay"]["btn_keypad"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
               }
               if(Boolean(this.m_keyLetGo) && Boolean(MenuController.CurrentCharacterSelectMenu) && (MenuController.CurrentCharacterSelectMenu is VSMenu || MenuController.CurrentCharacterSelectMenu is OnlineCharacterMenu))
               {
                  if(Boolean(this.m_keyLetGo) && Boolean(this.m_hand.hitBox.hitTestObject(this.m_chip.parent.parent.parent["incShortcut"])))
                  {
                     this.m_keyLetGo = false;
                     DisplayObject(this.m_chip.parent.parent.parent["incShortcut"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
                  if(Boolean(this.m_keyLetGo) && Boolean(this.m_hand.hitBox.hitTestObject(this.m_chip.parent.parent.parent["decShortcut"])))
                  {
                     this.m_keyLetGo = false;
                     DisplayObject(this.m_chip.parent.parent.parent["decShortcut"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
                  if(Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(this.m_keyLetGo) && Boolean(this.m_hand.hitBox.hitTestObject(this.m_chip.parent.parent.parent["bnGameMode"])))
                  {
                     this.m_keyLetGo = false;
                     DisplayObject(this.m_chip.parent.parent.parent["bnGameMode"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
                  if(Boolean(this.m_keyLetGo) && Boolean(this.m_hand.hitBox.hitTestObject(this.m_chip.parent.parent.parent["menu_open"])))
                  {
                     this.m_keyLetGo = false;
                     DisplayObject(this.m_chip.parent.parent.parent["menu_open"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
                  if(Boolean(this.m_keyLetGo) && Boolean(this.m_chip.parent.parent.parent["controls_btn"]) && Boolean(this.m_hand.hitBox.hitTestObject(this.m_chip.parent.parent.parent["controls_btn"])))
                  {
                     this.m_keyLetGo = false;
                     DisplayObject(this.m_chip.parent.parent.parent["controls_btn"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
               }
               if(Boolean(this.m_keyLetGo) && Boolean(MenuController.CurrentCharacterSelectMenu) && MenuController.CurrentCharacterSelectMenu is ArenaCharacterSelectMenu)
               {
                  if(Boolean(this.m_keyLetGo) && Boolean(this.m_hand.hitBox.hitTestObject(this.m_chip.parent.parent.parent["incShortcut"])))
                  {
                     this.m_keyLetGo = false;
                     DisplayObject(this.m_chip.parent.parent.parent["incShortcut"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
                  if(Boolean(this.m_keyLetGo) && Boolean(this.m_hand.hitBox.hitTestObject(this.m_chip.parent.parent.parent["decShortcut"])))
                  {
                     this.m_keyLetGo = false;
                     DisplayObject(this.m_chip.parent.parent.parent["decShortcut"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
               }
               if(Boolean(this.m_keyLetGo) && Boolean(MenuController.CurrentCharacterSelectMenu) && MenuController.CurrentCharacterSelectMenu is TargetTestMenu)
               {
                  if(Boolean(this.m_keyLetGo) && Boolean(this.m_hand.hitBox.hitTestObject(this.m_chip.parent.parent.parent["decLevel"])))
                  {
                     this.m_keyLetGo = false;
                     DisplayObject(this.m_chip.parent.parent.parent["decLevel"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
                  if(Boolean(this.m_keyLetGo) && Boolean(this.m_hand.hitBox.hitTestObject(this.m_chip.parent.parent.parent["incLevel"])))
                  {
                     this.m_keyLetGo = false;
                     DisplayObject(this.m_chip.parent.parent.parent["incLevel"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
               }
               if(Boolean(this.m_keyLetGo) && Boolean(MenuController.CurrentCharacterSelectMenu) && MenuController.CurrentCharacterSelectMenu is HomeRunContestMenu)
               {
                  if(Boolean(this.m_keyLetGo) && Boolean(this.m_hand.hitBox.hitTestObject(this.m_chip.parent.parent.parent["decLevel"])))
                  {
                     this.m_keyLetGo = false;
                     DisplayObject(this.m_chip.parent.parent.parent["decLevel"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
                  if(Boolean(this.m_keyLetGo) && Boolean(this.m_hand.hitBox.hitTestObject(this.m_chip.parent.parent.parent["incLevel"])))
                  {
                     this.m_keyLetGo = false;
                     DisplayObject(this.m_chip.parent.parent.parent["incLevel"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
               }
               if(Boolean(this.m_keyLetGo) && Boolean(MenuController.CurrentCharacterSelectMenu) && MenuController.CurrentCharacterSelectMenu is ClassicModeMenu)
               {
                  if(Boolean(this.m_keyLetGo) && Boolean(this.m_hand.hitBox.hitTestObject(this.m_chip.parent.parent.parent["decDifficulty"])))
                  {
                     this.m_keyLetGo = false;
                     DisplayObject(this.m_chip.parent.parent.parent["decDifficulty"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
                  if(Boolean(this.m_keyLetGo) && Boolean(this.m_hand.hitBox.hitTestObject(this.m_chip.parent.parent.parent["incDifficulty"])))
                  {
                     this.m_keyLetGo = false;
                     DisplayObject(this.m_chip.parent.parent.parent["incDifficulty"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
               }
               if(Boolean(this.m_keyLetGo) && Boolean(MenuController.CurrentCharacterSelectMenu) && MenuController.CurrentCharacterSelectMenu is ClassicModeMenu)
               {
                  if(Boolean(this.m_keyLetGo) && Boolean(this.m_hand.hitBox.hitTestObject(this.m_chip.parent.parent.parent["decLives"])))
                  {
                     this.m_keyLetGo = false;
                     DisplayObject(this.m_chip.parent.parent.parent["decLives"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
                  if(Boolean(this.m_keyLetGo) && Boolean(this.m_hand.hitBox.hitTestObject(this.m_chip.parent.parent.parent["incLives"])))
                  {
                     this.m_keyLetGo = false;
                     DisplayObject(this.m_chip.parent.parent.parent["incLives"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
               }
               if(Boolean(this.m_keyLetGo) && Boolean(MenuController.CurrentCharacterSelectMenu) && MenuController.CurrentCharacterSelectMenu is AllStarModeMenu)
               {
                  if(Boolean(this.m_keyLetGo) && Boolean(this.m_hand.hitBox.hitTestObject(this.m_chip.parent.parent.parent["decDifficulty"])))
                  {
                     this.m_keyLetGo = false;
                     DisplayObject(this.m_chip.parent.parent.parent["decDifficulty"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
                  if(Boolean(this.m_keyLetGo) && Boolean(this.m_hand.hitBox.hitTestObject(this.m_chip.parent.parent.parent["incDifficulty"])))
                  {
                     this.m_keyLetGo = false;
                     DisplayObject(this.m_chip.parent.parent.parent["incDifficulty"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
               }
               if(Boolean(this.m_keyLetGo) && Boolean(MenuController.CurrentCharacterSelectMenu) && MenuController.CurrentCharacterSelectMenu is CrystalSmashCharacterMenu)
               {
                  if(Boolean(this.m_keyLetGo) && Boolean(this.m_hand.hitBox.hitTestObject(this.m_chip.parent.parent.parent["decLevel"])))
                  {
                     this.m_keyLetGo = false;
                     DisplayObject(this.m_chip.parent.parent.parent["decLevel"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
                  if(Boolean(this.m_keyLetGo) && Boolean(this.m_hand.hitBox.hitTestObject(this.m_chip.parent.parent.parent["incLevel"])))
                  {
                     this.m_keyLetGo = false;
                     DisplayObject(this.m_chip.parent.parent.parent["incLevel"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
               }
               if(Boolean(this.m_keyLetGo) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj) && Boolean(ModeFeatures.hasFeature(ModeFeatures.HAS_HOME_BUTTON,MenuController.CurrentCharacterSelectMenu.GameObj.GameMode)))
               {
                  if(Boolean(this.m_keyLetGo) && Boolean(this.m_hand.hitBox.hitTestObject(this.m_chip.parent.parent.parent["bg_top"]["home_btn"])))
                  {
                     this.m_keyLetGo = false;
                     DisplayObject(this.m_chip.parent.parent.parent["bg_top"]["home_btn"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                     return;
                  }
               }
               _loc4_ = 1;
               while(_loc4_ <= this.m_characterSelectMenu.GameObj.PlayerSettings.length && Boolean(this.m_keyLetGo))
               {
                  if(Boolean(this.m_keyLetGo) && Boolean(this.m_chip.parent.parent["display" + _loc4_]["nextExp"].visible) && Boolean(this.m_hand.hitBox.hitTestObject(this.m_chip.parent.parent["display" + _loc4_].nextExp)))
                  {
                     this.m_keyLetGo = false;
                     this.m_chip.parent.parent["display" + _loc4_].nextExp.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
                  if(Boolean(this.m_keyLetGo && MenuController.CurrentCharacterSelectMenu.GameObj) && Boolean(!ModeFeatures.hasFeature(ModeFeatures.FORCE_SINGLE_PLAYER,MenuController.CurrentCharacterSelectMenu.GameObj.GameMode)) && Boolean(MovieClip(this.m_chip.parent.parent["display" + _loc4_].controlType).hitTestObject(this.m_hand.hitBox)))
                  {
                     this.m_keyLetGo = false;
                     MovieClip(this.m_chip.parent.parent["display" + _loc4_].controlType).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
                  if(Boolean(this.m_keyLetGo && MenuController.CurrentCharacterSelectMenu.GameObj) && Boolean(ModeFeatures.hasFeature(ModeFeatures.ALLOW_TEAM_TOGGLE,MenuController.CurrentCharacterSelectMenu.GameObj.GameMode)) && Boolean(this.m_chip.parent.parent["display" + _loc4_]["flag"].visible) && Boolean(this.m_hand.hitBox.hitTestObject(this.m_chip.parent.parent["display" + _loc4_])))
                  {
                     this.m_keyLetGo = false;
                     this.m_chip.parent.parent["display" + _loc4_].flag.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
                  if(Boolean(this.m_keyLetGo) && Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(this.m_chip.parent.parent["display" + _loc4_]["levelDisplay"].visible) && Boolean(this.m_hand.hitBox.hitTestObject(this.m_chip.parent.parent["display" + _loc4_]["levelDisplay"])))
                  {
                     this.m_keyLetGo = false;
                     MenuController.CurrentCharacterSelectMenu.incLevel(_loc4_);
                  }
                  if(Boolean(this.m_keyLetGo && (_loc4_ == this.m_playerID || !this.m_characterSelectMenu.GameObj.PlayerSettings[_loc4_ - 1].human) && !this.m_characterSelectMenu.GameObj.LevelData.teams) && Boolean(this.m_characterSelectMenu.GameObj.PlayerSettings[_loc4_ - 1].character) && Boolean(this.m_chip.parent.parent["display" + _loc4_].pic) && Boolean(MovieClip(MovieClip(this.m_chip.parent.parent["display" + _loc4_].pic).getChildAt(0)).alternateStatsName) && Boolean(this.m_hand.hitBox.hitTestObject(MovieClip(MovieClip(this.m_chip.parent.parent["display" + _loc4_].pic).getChildAt(0)).hitBox)))
                  {
                     this.m_keyLetGo = false;
                     this.m_characterSelectMenu.setPlayer(_loc4_,MovieClip(MovieClip(this.m_chip.parent.parent["display" + _loc4_].pic).getChildAt(0)).alternateStatsName,this.m_characterSelectMenu.GameObj.PlayerSettings[_loc4_ - 1].expansion);
                  }
                  if(Boolean(this.m_keyLetGo && !this.m_chip.parent.parent["display" + _loc4_].charPortrait.alt && (_loc4_ == this.m_playerID || !this.m_characterSelectMenu.GameObj.PlayerSettings[_loc4_ - 1].human) && !this.m_characterSelectMenu.GameObj.LevelData.teams) && Boolean(this.m_characterSelectMenu.GameObj.PlayerSettings[_loc4_ - 1].character) && Boolean(this.m_hand.hitBox.hitTestObject(this.m_chip.parent.parent["display" + _loc4_].charPortrait)) && !MovieClip(MovieClip(this.m_chip.parent.parent["display" + _loc4_].pic).getChildAt(0)).alternateStatsName)
                  {
                     this.m_keyLetGo = false;
                     this.m_characterSelectMenu.nextCostume(_loc4_);
                  }
                  _loc4_++;
               }
               if(Boolean(this.m_keyLetGo) && Boolean(this.m_hand.hitBox.hitTestObject(this.m_chip.parent.parent.parent["bg_top"]["back_btn"])))
               {
                  this.m_keyLetGo = false;
                  DisplayObject(this.m_chip.parent.parent.parent["bg_top"]["back_btn"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
               }
            }
         }
      }
      
      private function press(param1:MouseEvent) : void
      {
         if(!this.m_held)
         {
            this.m_characterSelectMenu.setPlayer(this.m_playerID,null);
            this.m_lastHit = null;
            this.m_pressed = true;
            this.m_chip.startDrag(true,this.m_chipBoundary);
         }
      }
      
      public function checkCollision() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Boolean = false;
         var _loc3_:MovieClip = null;
         var _loc4_:Point = new Point(0,0);
         for(_loc1_ in this.m_characterSelectMenu.CharMCHash)
         {
            _loc4_.x = 0;
            _loc4_.y = 0;
            _loc4_ = this.m_chip.localToGlobal(_loc4_);
            if(_loc1_ !== "cxp" && Boolean(this.checkBounds(this.m_characterSelectMenu.CharMCHash[_loc1_])))
            {
               if(this.m_lastHit != this.m_characterSelectMenu.CharMCHash[_loc1_].characterID)
               {
                  this.m_lastHit = this.m_characterSelectMenu.CharMCHash[_loc1_].characterID;
                  this.m_characterSelectMenu.setPlayer(this.m_playerID,this.m_lastHit,-1);
                  this.sayCharacter(this.m_lastHit);
                  _loc3_ = MovieClip(this.m_chip.parent.addChild(ResourceManager.getLibraryMC("mgsymbol_charselect")));
                  _loc3_.x = this.m_chip.x;
                  _loc3_.y = this.m_chip.y;
                  ModAPI.triggerMenuRumble(this.m_playerID - 1);
               }
               _loc2_ = true;
               break;
            }
         }
         if(!_loc2_)
         {
            if(this.m_characterSelectMenu.CharMCHash["cxp"] != undefined && Boolean(this.checkBounds(MovieClip(this.m_characterSelectMenu.CharMCHash["cxp"]))) && ResourceManager.TotalExpansions > 0)
            {
               if(this.m_lastHit != this.m_characterSelectMenu.CharMCHash["cxp"].characterID)
               {
                  this.m_lastHit = this.m_characterSelectMenu.CharMCHash["cxp"].characterID;
                  this.m_characterSelectMenu.setPlayer(this.m_playerID,this.m_lastHit,this.m_expansionNum);
                  SoundQueue.instance.playSoundEffect("menu_charselect");
                  SoundQueue.instance.playVoiceEffect("narrator_expansion");
                  _loc3_ = MovieClip(this.m_chip.parent.addChild(ResourceManager.getLibraryMC("mgsymbol_charselect")));
                  _loc3_.x = this.m_chip.x;
                  _loc3_.y = this.m_chip.y;
                  ModAPI.triggerMenuRumble(this.m_playerID - 1);
               }
            }
            else
            {
               this.m_characterSelectMenu.setPlayer(this.m_playerID,null);
               this.m_lastHit = null;
            }
         }
      }
      
      private function release(param1:MouseEvent) : void
      {
         if(this.m_pressed)
         {
            this.m_chip.stopDrag();
            this.checkCollision();
            this.m_pressed = false;
         }
      }
      
      private function checkBounds(param1:MovieClip) : Boolean
      {
         if(!param1.parent || !param1.visible)
         {
            return false;
         }
         var _loc2_:Rectangle = param1.getRect(param1.parent);
         return _loc2_.containsPoint(new Point(this.m_chip.x,this.m_chip.y)) && param1.visible;
      }
      
      private function checkBoundsKeypad(param1:MovieClip) : Boolean
      {
         var _loc2_:Rectangle = param1.getRect(this.m_hand.parent);
         return _loc2_.containsPoint(new Point(this.m_hand.x,this.m_hand.y)) && param1.visible;
      }
      
      public function destroy() : void
      {
         if(this.m_chip.parent)
         {
            this.m_chip.parent.removeChild(this.m_chip);
         }
         if(this.m_hand.parent)
         {
            this.m_hand.parent.removeChild(this.m_hand);
         }
      }
      
      public function get Held() : Boolean
      {
         return this.m_held;
      }
      
      public function set Held(param1:Boolean) : void
      {
         this.m_held = param1;
      }
      
      public function get Pressed() : Boolean
      {
         return this.m_pressed;
      }
      
      public function get PlayerID() : int
      {
         return this.m_playerID;
      }
      
      public function get MC() : MovieClip
      {
         return this.m_chip;
      }
      
      public function get HandMC() : MovieClip
      {
         return this.m_hand;
      }
      
      public function get LastHit() : String
      {
         return this.m_lastHit;
      }
      
      public function set LastHit(param1:String) : void
      {
         this.m_lastHit = param1;
      }
      
      public function set ExpansionNum(param1:Number) : void
      {
         this.m_expansionNum = param1;
         if(this.m_expansionNum < 0)
         {
            this.m_expansionNum = 0;
         }
      }
      
      public function get ExpansionNum() : Number
      {
         return this.m_expansionNum;
      }
      
      public function get X() : Number
      {
         return this.m_chip.x;
      }
      
      public function set X(param1:Number) : void
      {
         this.m_chip.x = param1;
      }
      
      public function get Y() : Number
      {
         return this.m_chip.y;
      }
      
      public function set Y(param1:Number) : void
      {
         this.m_chip.y = param1;
      }
      
      public function set Visible(param1:Boolean) : void
      {
         if(!(Boolean(ModeFeatures.hasFeature(ModeFeatures.FORCE_SINGLE_PLAYER,this.m_characterSelectMenu.GameObj.GameMode)) && this.m_playerID != 1))
         {
            this.m_chip.visible = param1;
         }
      }
      
      public function get Visible() : Boolean
      {
         return this.m_chip.visible;
      }
      
      private function sayCharacter(param1:String) : void
      {
         SoundQueue.instance.playSoundEffect("menu_charselect");
         SoundQueue.instance.playVoiceEffect("narrator_" + param1);
         SoundQueue.instance.playVoiceEffect("taunt_" + param1);
      }
   }
}


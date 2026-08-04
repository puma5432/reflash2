package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.events.*;
   import com.mcleodgaming.ssf2.modes.CustomMode;
   import com.mcleodgaming.ssf2.net.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class CharacterSelectMenu extends Menu
   {
      
      protected var m_game:Game;
      
      protected var m_playerLimit:Number;
      
      protected var m_playerChips:Vector.<Chip>;
      
      protected var draggingMC:MovieClip;
      
      protected var gameMode:uint;
      
      protected var displayObjectTable:DisplayObjectTable;
      
      protected var keyPadMapping:Array;
      
      protected var m_charSelectionMC:MovieClip;
      
      protected var m_charSelectionBoxes:Vector.<MovieClip>;
      
      protected var m_charMCHash:Object;
      
      protected var m_unlockMCHash:Object;
      
      private var m_nextScreenDelay:Timer;
      
      private var m_nextScreenEnabled:Boolean;
      
      protected var m_loadingMask:MovieClip;
      
      private var m_readyDelay:FrameTimer;
      
      protected var m_modeInstance:CustomMode;
      
      private var costumeSelectorIsOpen:Boolean;
      
      public function CharacterSelectMenu(param1:String)
      {
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         super();
         this.m_playerLimit = Main.MAXPLAYERS;
         m_subMenu = ResourceManager.getLibraryMC(param1);
         m_backgroundID = "space";
         m_container.addChild(m_subMenu);
         this.draggingMC = null;
         this.gameMode = Mode.VS;
         this.m_charSelectionMC = m_subMenu.charSelection;
         this.m_charSelectionBoxes = new Vector.<MovieClip>();
         this.m_playerChips = new Vector.<Chip>();
         this.keyPadMapping = new Array();
         this.keyPadMapping["btn_abc"] = ["A","B","C","a","b","c"];
         this.keyPadMapping["btn_def"] = ["D","E","F","d","e","f"];
         this.keyPadMapping["btn_ghi"] = ["G","H","I","g","h","i"];
         this.keyPadMapping["btn_jkl"] = ["J","K","L","j","k","l"];
         this.keyPadMapping["btn_mno"] = ["M","N","O","m","n","o"];
         this.keyPadMapping["btn_pqrs"] = ["P","Q","R","S","p","q","r","s"];
         this.keyPadMapping["btn_tuv"] = ["T","U","V","t","u","v"];
         this.keyPadMapping["btn_wxyz"] = ["W","X","Y","Z","w","x","y","z"];
         this.keyPadMapping["btn_misc"] = ["\"","#","$","%","&","\'","(",")","*","+",",","-",".","/","0","1","2","3","4","5","6","7","8","9",":",";","<","=",">","?","@","[","\\","]","^","_","`","{","|","}","~"];
         var _loc5_:Object = ResourceManager.getResourceByID("mappings").getProp("metadata");
         var _loc6_:Object = _loc5_.character_select_screen.rows;
         var _loc7_:Array = Utils.flatten(_loc6_ as Array);
         this.m_charMCHash = {};
         this.m_unlockMCHash = {};
         _loc2_ = 0;
         while(_loc2_ < this.CharSelectionIconsMC.numChildren)
         {
            if(this.CharSelectionIconsMC.getChildAt(_loc2_) is MovieClip)
            {
               _loc4_ = MovieClip(this.CharSelectionIconsMC.getChildAt(_loc2_));
               _loc4_.parent.removeChild(_loc4_);
               _loc2_--;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc7_.length)
         {
            if(Boolean(_loc5_.character[_loc7_[_loc2_]]) || Boolean(_loc7_[_loc2_] === "cxp") || _loc7_[_loc2_] === "random")
            {
               _loc4_ = ResourceManager.getLibraryMC(_loc7_[_loc2_] + "_select");
               if(_loc4_)
               {
                  _loc4_.characterID = _loc4_.characterID || _loc7_[_loc2_];
                  if(_loc4_.characterID)
                  {
                     this.m_charMCHash[_loc4_.characterID] = _loc4_;
                  }
                  else
                  {
                     this.m_charMCHash[_loc7_[_loc2_]] = _loc4_;
                  }
                  _loc4_.gotoAndStop(1);
                  this.CharSelectionIconsMC.addChild(_loc4_);
               }
            }
            _loc2_++;
         }
         this.displayObjectTable = new DisplayObjectTable(new Rectangle(_loc5_.character_select_screen.position.x,_loc5_.character_select_screen.position.y,_loc5_.character_select_screen.icon_size.width,_loc5_.character_select_screen.icon_size.height));
         this.displayObjectTable.fixDepths();
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         this.m_nextScreenEnabled = false;
         this.m_nextScreenDelay = new Timer(30,1);
         this.m_loadingMask = ResourceManager.getLibraryMC("loadingMask");
         this.m_loadingMask.x = Main.Width / 2;
         this.m_loadingMask.y = Main.Height / 2;
         this.m_readyDelay = new FrameTimer(10);
      }
      
      public function get ReadyDelay() : FrameTimer
      {
         return this.m_readyDelay;
      }
      
      public function get PlayerLimit() : int
      {
         return this.m_playerLimit;
      }
      
      public function get CharMCHash() : Object
      {
         return this.m_charMCHash;
      }
      
      public function get CharSelectionMC() : MovieClip
      {
         return this.m_charSelectionMC;
      }
      
      public function get CharSelectionIconsMC() : MovieClip
      {
         return this.m_charSelectionMC.charSelect;
      }
      
      public function get CharSelectionBoxes() : Vector.<MovieClip>
      {
         return this.m_charSelectionBoxes;
      }
      
      public function get PlayerChips() : Vector.<Chip>
      {
         return this.m_playerChips;
      }
      
      public function get GameObj() : Game
      {
         return this.m_game;
      }
      
      override public function makeEvents() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.backMain_CLICK);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.MOUSE_OVER,this.backMain_OVER);
         _loc1_ = 0;
         while(_loc1_ < this.m_charSelectionBoxes.length)
         {
            this.m_charSelectionBoxes[_loc1_].levelDisplay.levelHandle.addEventListener(MouseEvent.MOUSE_DOWN,this.levelHandle_MOUSE_DOWN);
            this.m_charSelectionBoxes[_loc1_].flag.addEventListener(MouseEvent.CLICK,this.flag_MOUSE_CLICK);
            this.m_charSelectionBoxes[_loc1_].controlType.addEventListener(MouseEvent.CLICK,this.controlType_CLICK);
            this.m_charSelectionBoxes[_loc1_].nextExp.addEventListener(MouseEvent.CLICK,this.nextExp_CLICK);
            this.m_charSelectionBoxes[_loc1_].nameDisplay.btn_keypad.addEventListener(MouseEvent.CLICK,this.namesDisplay_CLICK);
            this.m_charSelectionBoxes[_loc1_].nameDisplay.nameKeyPad.btn_abc.addEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[_loc1_].nameDisplay.nameKeyPad.btn_def.addEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[_loc1_].nameDisplay.nameKeyPad.btn_ghi.addEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[_loc1_].nameDisplay.nameKeyPad.btn_jkl.addEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[_loc1_].nameDisplay.nameKeyPad.btn_mno.addEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[_loc1_].nameDisplay.nameKeyPad.btn_pqrs.addEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[_loc1_].nameDisplay.nameKeyPad.btn_tuv.addEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[_loc1_].nameDisplay.nameKeyPad.btn_wxyz.addEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[_loc1_].nameDisplay.nameKeyPad.btn_misc.addEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[_loc1_].nameDisplay.nameKeyPad.btn_done.addEventListener(MouseEvent.CLICK,this.namesDisplayDone_CLICK);
            this.m_charSelectionBoxes[_loc1_].nameDisplay.addEventListener(Event.ENTER_FRAME,this.runKeyPadDelayTimer);
            this.m_charSelectionBoxes[_loc1_].charPortrait.addEventListener(MouseEvent.CLICK,this.nextCostume_CLICK);
            Main.Root.stage.addEventListener(MouseEvent.MOUSE_UP,this.levelHandle_MOUSE_UP);
            Main.Root.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.levelHandle_MOUSE_MOVE);
            _loc1_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.m_playerChips.length)
         {
            this.m_playerChips[_loc2_].makeEvents();
            _loc2_++;
         }
         if(m_subMenu.controls_btn)
         {
            m_subMenu.controls_btn.addEventListener(MouseEvent.CLICK,this.controls_btn_CLICK);
            m_subMenu.controls_btn.addEventListener(MouseEvent.ROLL_OVER,this.controls_btn_ROLL_OVER);
         }
         this.m_nextScreenEnabled = false;
         this.m_nextScreenDelay.reset();
         Main.Root.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyPressed);
         _loc1_ = 0;
         while(_loc1_ < SaveData.Controllers.length)
         {
            if(SaveData.Controllers[_loc1_].GamepadInstance)
            {
               SaveData.Controllers[_loc1_].GamepadInstance.addEventListener(GamepadEvent.BUTTON_DOWN,this.onGamepadButtonPressed);
            }
            _loc1_++;
         }
         this.m_nextScreenDelay.addEventListener(TimerEvent.TIMER_COMPLETE,this.enableNextScreen);
         this.m_nextScreenDelay.start();
      }
      
      override public function killEvents() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.killEvents();
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.backMain_CLICK);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.backMain_OVER);
         _loc1_ = 0;
         while(_loc1_ < this.m_charSelectionBoxes.length)
         {
            this.m_charSelectionBoxes[_loc1_].levelDisplay.levelHandle.removeEventListener(MouseEvent.MOUSE_DOWN,this.levelHandle_MOUSE_DOWN);
            this.m_charSelectionBoxes[_loc1_].flag.removeEventListener(MouseEvent.CLICK,this.flag_MOUSE_CLICK);
            this.m_charSelectionBoxes[_loc1_].controlType.removeEventListener(MouseEvent.CLICK,this.controlType_CLICK);
            this.m_charSelectionBoxes[_loc1_].nextExp.removeEventListener(MouseEvent.CLICK,this.nextExp_CLICK);
            this.m_charSelectionBoxes[_loc1_].nameDisplay.btn_keypad.removeEventListener(MouseEvent.CLICK,this.namesDisplay_CLICK);
            this.m_charSelectionBoxes[_loc1_].nameDisplay.nameKeyPad.btn_abc.removeEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[_loc1_].nameDisplay.nameKeyPad.btn_def.removeEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[_loc1_].nameDisplay.nameKeyPad.btn_ghi.removeEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[_loc1_].nameDisplay.nameKeyPad.btn_jkl.removeEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[_loc1_].nameDisplay.nameKeyPad.btn_mno.removeEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[_loc1_].nameDisplay.nameKeyPad.btn_pqrs.removeEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[_loc1_].nameDisplay.nameKeyPad.btn_tuv.removeEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[_loc1_].nameDisplay.nameKeyPad.btn_wxyz.removeEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[_loc1_].nameDisplay.nameKeyPad.btn_misc.removeEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[_loc1_].nameDisplay.nameKeyPad.btn_done.removeEventListener(MouseEvent.CLICK,this.namesDisplayDone_CLICK);
            this.m_charSelectionBoxes[_loc1_].nameDisplay.removeEventListener(Event.ENTER_FRAME,this.runKeyPadDelayTimer);
            this.m_charSelectionBoxes[_loc1_].charPortrait.removeEventListener(MouseEvent.CLICK,this.nextCostume_CLICK);
            Main.Root.stage.removeEventListener(MouseEvent.MOUSE_UP,this.levelHandle_MOUSE_UP);
            Main.Root.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.levelHandle_MOUSE_MOVE);
            _loc1_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.m_playerChips.length)
         {
            this.m_playerChips[_loc2_].killEvents();
            _loc2_++;
         }
         if(m_subMenu.controls_btn)
         {
            m_subMenu.controls_btn.removeEventListener(MouseEvent.CLICK,this.controls_btn_CLICK);
            m_subMenu.controls_btn.removeEventListener(MouseEvent.ROLL_OVER,this.controls_btn_ROLL_OVER);
         }
         this.m_nextScreenEnabled = false;
         Main.Root.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyPressed);
         _loc1_ = 0;
         while(_loc1_ < SaveData.Controllers.length)
         {
            if(SaveData.Controllers[_loc1_].GamepadInstance)
            {
               SaveData.Controllers[_loc1_].GamepadInstance.removeEventListener(GamepadEvent.BUTTON_DOWN,this.onGamepadButtonPressed);
            }
            _loc1_++;
         }
         if(this.m_nextScreenDelay.running)
         {
            this.m_nextScreenDelay.removeEventListener(TimerEvent.TIMER_COMPLETE,this.enableNextScreen);
         }
      }
      
      override public function show() : void
      {
         this.updateIcons();
         super.show();
         SoundQueue.instance.playMusic("menumusic",0);
      }
      
      protected function updateIcons() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:Object = ResourceManager.getResourceByID("mappings").getProp("metadata");
         this.displayObjectTable.empty();
         var _loc5_:Object = _loc4_.character_select_screen.rows;
         _loc1_ = 0;
         while(_loc1_ < _loc5_.length)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc5_[_loc1_].length)
            {
               if(this.m_charMCHash[_loc5_[_loc1_][_loc2_]])
               {
                  m_subMenu.charSelection.charSelect.addChild(this.m_charMCHash[_loc5_[_loc1_][_loc2_]]);
                  this.displayObjectTable.insertObject(_loc1_,this.m_charMCHash[_loc5_[_loc1_][_loc2_]]);
               }
               _loc2_++;
            }
            _loc1_++;
         }
         this.insertExpansionSlot(_loc1_ - 1);
         if(!Main.DEBUG)
         {
            for(_loc3_ in this.m_charMCHash)
            {
               if(SaveData.Unlocks[_loc3_] === false)
               {
                  this.m_charMCHash[_loc3_].visible = false;
               }
               else if(SaveData.Unlocks[_loc3_] === true)
               {
                  this.m_charMCHash[_loc3_].visible = true;
               }
            }
         }
         this.displayObjectTable.fixDepths();
         this.displayObjectTable.spaceObjects();
      }
      
      public function reset() : void
      {
         m_subMenu.readyToFight.visible = false;
         this.updateIcons();
         if(this.m_game)
         {
            trace("ROGUE GAME IN EXISTENCE IN CHARSELECTMENU");
         }
         this.m_game = new Game(this.m_playerLimit,this.gameMode);
         this.initSelectionBoxes();
         this.m_game.loadSavedVSOptions();
         this.updateDisplay();
      }
      
      public function initSelectionBoxes() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:Number = 7.85;
         var _loc4_:Object = ResourceManager.getResourceByID("mappings").getProp("metadata");
         while(this.m_charSelectionBoxes.length > 0)
         {
            if(this.m_charSelectionBoxes[0].parent)
            {
               this.m_charSelectionBoxes[0].parent.removeChild(this.m_charSelectionBoxes[0]);
            }
            this.m_charSelectionBoxes.splice(0,1);
         }
         _loc3_ = 7.85 + _loc4_.character_select_screen.portrait_offset.x;
         _loc1_ = 1;
         while(_loc1_ <= this.m_playerLimit)
         {
            _loc2_ = ResourceManager.getLibraryMC("CharacterSelectBox");
            _loc2_.pid = _loc1_;
            _loc2_.levelDisplay.dragging = false;
            _loc2_.pic.mouseChildren = false;
            _loc2_.pic.mouseEnabled = false;
            _loc2_.flag.mouseChildren = false;
            _loc2_.flag.visible = false;
            _loc2_.nameDisplay.nameKeyPad.visible = false;
            _loc2_.nameDisplay.nameTxt.text = "P" + _loc1_;
            _loc2_.nameDisplay.delayTimer = 0;
            _loc2_.x = _loc3_;
            _loc2_.y = 182 + _loc4_.character_select_screen.portrait_offset.y;
            _loc2_.name = "display" + _loc1_;
            _loc2_.visible = true;
            this.m_charSelectionMC["display" + _loc1_] = _loc2_;
            _loc3_ += _loc4_.character_select_screen.portrait_spacing || 130;
            this.m_charSelectionMC.addChildAt(_loc2_,0);
            this.m_charSelectionBoxes.push(_loc2_);
            _loc1_++;
         }
         while(this.m_playerChips.length > 0)
         {
            this.m_playerChips[0].destroy();
            this.m_playerChips.splice(0,1);
         }
         this.m_playerChips = new Vector.<Chip>();
         _loc1_ = 0;
         while(_loc1_ < this.m_game.PlayerSettings.length)
         {
            _loc2_ = ResourceManager.getLibraryMC("CharacterSelectChip");
            _loc2_.name = "chip" + (_loc1_ + 1);
            _loc2_.x = this.m_charSelectionMC["display" + (_loc1_ + 1)].x - this.m_charSelectionMC.charSelect.x + _loc4_.character_select_screen.chip_offset.x;
            _loc2_.y = this.m_charSelectionMC["display" + (_loc1_ + 1)].y + this.m_charSelectionMC.charSelect.y + _loc4_.character_select_screen.chip_offset.y;
            this.m_charSelectionMC.charSelect.addChild(_loc2_);
            this.m_charSelectionMC.charSelect["chip" + (_loc1_ + 1)] = _loc2_;
            this.m_playerChips.push(new Chip(this,_loc2_,_loc1_ + 1));
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.m_playerChips.length)
         {
            this.m_charSelectionMC.charSelect.addChild(this.m_playerChips[_loc1_].HandMC);
            _loc1_++;
         }
      }
      
      public function resetScreen() : void
      {
         var _loc1_:int = 0;
         if(this.m_game)
         {
            _loc1_ = 1;
            while(_loc1_ <= this.m_game.PlayerSettings.length)
            {
               this.resetChipPosition(_loc1_);
               this.removePic(_loc1_);
               _loc1_++;
            }
         }
      }
      
      public function backMain_CLICK(param1:MouseEvent) : void
      {
         this.resetScreen();
         this.m_game = null;
         SoundQueue.instance.playSoundEffect("menu_back");
         removeSelf();
         MenuController.disposeAllMenus(true);
      }
      
      public function backMain_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      protected function levelHandle_MOUSE_DOWN(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         if(this.draggingMC != null)
         {
            return;
         }
         while(_loc3_ < this.m_charSelectionBoxes.length)
         {
            if(param1.currentTarget == this.m_charSelectionBoxes[_loc3_].levelDisplay.levelHandle)
            {
               _loc2_ = MovieClip(param1.currentTarget);
               break;
            }
            _loc3_++;
         }
         if(_loc2_ != null)
         {
            _loc2_.dragging = true;
            _loc2_.startDrag(true,new Rectangle(_loc2_.x,-54,0,50));
            this.draggingMC = _loc2_;
         }
      }
      
      protected function levelHandle_MOUSE_UP(param1:MouseEvent) : void
      {
         if(this.draggingMC != null && Boolean(this.draggingMC.dragging))
         {
            this.draggingMC.dragging = false;
            this.draggingMC.stopDrag();
            this.setLevel(MovieClip(this.draggingMC.parent.parent).pid,Math.round(-(this.draggingMC.y + 4) / 50 * 8) + 1);
            SaveData.saveGame();
         }
         else
         {
            this.draggingMC = null;
         }
      }
      
      protected function levelHandle_MOUSE_MOVE(param1:MouseEvent) : void
      {
         if(Boolean(this.draggingMC != null) && Boolean(this.draggingMC.dragging) && Boolean(m_subMenu.root))
         {
            this.setLevel(MovieClip(this.draggingMC.parent.parent).pid,Math.round(-(this.draggingMC.y + 4) / 50 * 8) + 1);
         }
         else
         {
            this.draggingMC = null;
         }
      }
      
      public function incLevel(param1:int) : void
      {
         this.setLevel(param1,this.m_game.PlayerSettings[param1 - 1].level + 1);
      }
      
      protected function flag_MOUSE_CLICK(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.m_charSelectionBoxes.length)
         {
            if(param1.currentTarget.parent == this.m_charSelectionBoxes[_loc3_])
            {
               _loc2_ = MovieClip(param1.currentTarget.parent);
               break;
            }
            _loc3_++;
         }
         if(_loc2_ != null)
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            this.toggleTeam(_loc2_.pid);
         }
      }
      
      protected function controlType_CLICK(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         if(!ModeFeatures.hasFeature(ModeFeatures.ALLOW_CONROL_TYPE,this.gameMode))
         {
            return;
         }
         while(_loc3_ < this.m_charSelectionBoxes.length)
         {
            if(param1.currentTarget.parent == this.m_charSelectionBoxes[_loc3_])
            {
               _loc2_ = MovieClip(param1.currentTarget.parent);
               break;
            }
            _loc3_++;
         }
         if(_loc2_ != null)
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            this.toggleControl(_loc2_.pid);
         }
      }
      
      protected function namesKeypad_CLICK(param1:MouseEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:TextField = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:* = undefined;
         var _loc8_:MovieClip = null;
         var _loc9_:int = 0;
         while(_loc9_ < this.m_charSelectionBoxes.length)
         {
            if(param1.currentTarget.parent.parent.parent == this.m_charSelectionBoxes[_loc9_])
            {
               _loc8_ = MovieClip(param1.currentTarget.parent.parent.parent);
               break;
            }
            _loc9_++;
         }
         if(Boolean(_loc8_ != null) && Boolean(param1.currentTarget.name) && Boolean(this.keyPadMapping[param1.currentTarget.name]))
         {
            _loc2_ = this.keyPadMapping[param1.currentTarget.name];
            _loc3_ = _loc8_.nameDisplay.nameTxt;
            _loc4_ = _loc3_.text == "" ? null : _loc3_.text.charAt(_loc3_.text.length - 1);
            _loc5_ = null;
            if(_loc4_ != null)
            {
               for(_loc7_ in this.keyPadMapping)
               {
                  if(this.keyPadMapping[_loc7_].indexOf(_loc4_) >= 0)
                  {
                     if(_loc2_ == this.keyPadMapping[_loc7_])
                     {
                        _loc5_ = this.keyPadMapping[_loc7_];
                     }
                     else
                     {
                        _loc4_ = null;
                     }
                  }
               }
            }
            if(_loc3_.textColor != 16711680)
            {
               _loc4_ = null;
               _loc5_ = null;
            }
            _loc6_ = !_loc4_ ? _loc2_[0] : _loc2_[(_loc2_.indexOf(_loc4_) + 1) % _loc2_.length];
            if(Boolean(_loc5_) || _loc3_.length >= 15)
            {
               _loc3_.text = _loc3_.text.substr(0,_loc3_.length - 1) + _loc6_;
            }
            else
            {
               _loc3_.appendText(_loc6_);
            }
            _loc3_.textColor = 16711680;
            _loc8_.nameDisplay.delayTimer = 25;
            SoundQueue.instance.playSoundEffect("menu_hover");
         }
      }
      
      protected function namesDisplay_CLICK(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.m_charSelectionBoxes.length)
         {
            if(param1.currentTarget.parent.parent == this.m_charSelectionBoxes[_loc3_])
            {
               _loc2_ = MovieClip(param1.currentTarget.parent.parent);
               break;
            }
            _loc3_++;
         }
         if(_loc2_ != null)
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            this.showNamesKeypad(_loc2_.pid);
         }
      }
      
      protected function namesDisplayDone_CLICK(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.m_charSelectionBoxes.length)
         {
            if(param1.currentTarget.parent.parent.parent == this.m_charSelectionBoxes[_loc3_])
            {
               _loc2_ = MovieClip(param1.currentTarget.parent.parent.parent);
               break;
            }
            _loc3_++;
         }
         if(_loc2_ != null)
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            this.hideNamesKeypad(_loc2_.pid);
         }
      }
      
      protected function runKeyPadDelayTimer(param1:Event) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.m_charSelectionBoxes.length)
         {
            if(param1.currentTarget.parent == this.m_charSelectionBoxes[_loc3_])
            {
               _loc2_ = MovieClip(param1.currentTarget.parent);
               break;
            }
            _loc3_++;
         }
         if(_loc2_ != null)
         {
            --_loc2_.nameDisplay.delayTimer;
            if(_loc2_.nameDisplay.delayTimer <= 0)
            {
               TextField(_loc2_.nameDisplay.nameTxt).textColor = 15658734;
            }
         }
      }
      
      protected function nextCostume_CLICK(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.m_charSelectionBoxes.length)
         {
            if(param1.currentTarget.parent == this.m_charSelectionBoxes[_loc3_])
            {
               _loc2_ = MovieClip(param1.currentTarget.parent);
               break;
            }
            _loc3_++;
         }
         if(_loc2_ != null)
         {
            if(Boolean(Config.enable_palette_maker) && !this.m_game.LevelData.teams)
            {
               this.costumeSelectorDisplay(_loc2_.pid - 1);
            }
            else
            {
               this.nextCostume(_loc2_.pid,true);
            }
         }
      }
      
      protected function costumeSelectorDisplay(param1:int) : void
      {
         var selectedCharacter:String = null;
         var pid:int = param1;
         selectedCharacter = this.m_game.PlayerSettings[pid].character;
         MenuController.costumeSelectorDisplay.setCharacter(selectedCharacter,pid);
         MenuController.costumeSelectorDisplay.onClickContainer = function():*
         {
            var _loc1_:int = int(MenuController.costumeSelectorDisplay.getSelectedCostume());
            Utils.setColorFilterCharacter(m_charSelectionBoxes[pid].getChildByName("pic"),-1,selectedCharacter,_loc1_,true,true);
            m_game.PlayerSettings[pid].costume = _loc1_;
            SoundQueue.instance.playSoundEffect("menu_select");
         };
         MenuController.costumeSelectorDisplay.onCloseMenu = function():*
         {
            SoundQueue.instance.playSoundEffect("menu_back");
         };
      }
      
      protected function nextExp_CLICK(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.m_charSelectionBoxes.length)
         {
            if(param1.currentTarget.parent == this.m_charSelectionBoxes[_loc3_])
            {
               _loc2_ = MovieClip(param1.currentTarget.parent);
               break;
            }
            _loc3_++;
         }
         if(_loc2_ != null)
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            this.incrementExpansion(_loc2_.pid);
         }
      }
      
      public function controls_btn_CLICK(param1:MouseEvent) : void
      {
         if(this.hasVisibleKeypad())
         {
            SoundQueue.instance.playSoundEffect("menu_error");
            return;
         }
         SoundQueue.instance.playSoundEffect("menu_select");
         MenuController.controlsMenu.show();
      }
      
      public function controls_btn_ROLL_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      public function incrementExpansion(param1:Number) : void
      {
         this.m_playerChips[param1 - 1].incrementExpansionNum();
      }
      
      private function enableNextScreen(param1:TimerEvent) : void
      {
         if(!Key.isDown(32))
         {
            this.m_nextScreenEnabled = true;
         }
         else
         {
            this.m_nextScreenDelay.reset();
            this.m_nextScreenDelay.start();
         }
      }
      
      public function onGamepadButtonPressed(param1:GamepadEvent) : void
      {
         if(Boolean(this.m_nextScreenEnabled) && !MenuController.rulesMenu.isOnscreen() && !MenuController.controlsMenu.isOnscreen() && param1.controlState.inputs.indexOf("START") >= 0)
         {
            this.readyConfirm();
         }
      }
      
      private function onKeyPressed(param1:KeyboardEvent) : void
      {
         if(Boolean(this.m_nextScreenEnabled) && !MenuController.rulesMenu.isOnscreen() && !MenuController.controlsMenu.isOnscreen() && (param1.keyCode == 32 || Boolean(this.controllerStart())) && !(Boolean(MenuController.debugConsole) && Boolean(MenuController.debugConsole.isOnscreen()) && MenuController.debugConsole.DisableKeyCapture))
         {
            this.readyConfirm();
         }
      }
      
      private function controllerStart() : Boolean
      {
         var _loc1_:int = 1;
         while(_loc1_ <= SaveData.Controllers.length)
         {
            if(SaveData.Controllers[_loc1_ - 1] != null && Boolean(SaveData.Controllers[_loc1_ - 1].IsDown(SaveData.Controllers[_loc1_ - 1]._START)))
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      private function readyConfirm() : void
      {
         if(this.gameIsReady())
         {
            this.killEvents();
            this.initMatch();
         }
         else
         {
            SoundQueue.instance.playSoundEffect("menu_error");
         }
      }
      
      public function initMatch() : void
      {
      }
      
      public function startReplay(param1:* = null) : void
      {
         if(this.m_loadingMask.parent != null)
         {
            Main.Root.removeChild(this.m_loadingMask);
         }
         MenuController.disposeAllMenus(true);
         GameController.startMatch(this.m_game);
      }
      
      public function initReplay() : void
      {
         var _loc1_:int = 0;
         this.m_game.importSettings({
            "levelData":this.m_game.ReplayDataObj.MatchSettings,
            "items":this.m_game.ReplayDataObj.ItemSettingsObj,
            "playerSettings":this.m_game.ReplayDataObj.PlayerData
         });
         this.m_game.HudDisplay = SaveData.HudDisplay;
         this.m_game.ScoreDisplay = SaveData.ScoreDisplay;
         this.m_game.PauseEnabled = false;
         this.m_game.ShowPlayerID = SaveData.ShowPlayerID;
         SoundQueue.instance.playSoundEffect("menu_crowd");
         GameController.isStarted = true;
         if(this.m_game.LevelData.unlocks.alternate_tracks === true)
         {
            ResourceManager.FORCE_ENABLE_ALT_TRACKS = true;
         }
         this.m_game.LevelData.randSeed = this.m_game.ReplayDataObj.MatchSettings.randSeed;
         Utils.setRandSeed(this.m_game.LevelData.randSeed);
         Utils.shuffleRandom();
         Main.prepRandomCharacters(this.m_game.PlayerSettings.length);
         ResourceManager.queueResources([this.m_game.LevelData.stage]);
         while(_loc1_ < this.m_game.PlayerSettings.length)
         {
            if(Boolean(this.m_game.PlayerSettings[_loc1_] && this.m_game.PlayerSettings[_loc1_].exist) && Boolean(this.m_game.PlayerSettings[_loc1_].character != null) && this.m_game.PlayerSettings[_loc1_].character != "xp")
            {
               ResourceManager.queueResources([this.m_game.PlayerSettings[_loc1_].character == "random" ? Main.RandCharList[_loc1_].StatsName : this.m_game.PlayerSettings[_loc1_].character]);
            }
            _loc1_++;
         }
         Main.Root.addChild(this.m_loadingMask);
         ResourceManager.load({"oncomplete":this.startReplay});
      }
      
      public function startArena(param1:* = null) : void
      {
         if(this.m_loadingMask.parent != null)
         {
            Main.Root.removeChild(this.m_loadingMask);
         }
         MenuController.disposeAllMenus();
         GameController.startMatch(this.m_game);
      }
      
      public function removePic(param1:Number) : void
      {
         var _loc2_:MovieClip = null;
         if(param1 <= 0 || param1 > this.m_charSelectionBoxes.length)
         {
            return;
         }
         var _loc3_:MovieClip = this.m_charSelectionBoxes[param1 - 1];
         if(MovieClip(_loc3_.getChildByName("pic")).numChildren > 0)
         {
            MovieClip(_loc3_.getChildByName("pic")).removeChild(MovieClip(_loc3_.getChildByName("pic")).getChildByName("mc"));
            _loc2_ = MovieClip(_loc3_.getChildByName("pic")).addChild(ResourceManager.getLibraryMC("blankmc")) as MovieClip;
            _loc2_.name = "mc";
            if(MovieClip(_loc3_.getChildByName("icon")).numChildren > 0)
            {
               MovieClip(_loc3_.getChildByName("icon")).removeChild(MovieClip(_loc3_.getChildByName("icon")).getChildByName("mc"));
               _loc2_ = MovieClip(_loc3_.getChildByName("icon")).addChild(ResourceManager.getLibraryMC("blankmc")) as MovieClip;
               _loc2_.name = "mc";
            }
            _loc3_.nextExp.visible = false;
            _loc3_.playerTxt.text = "";
         }
      }
      
      public function changePic(param1:Number, param2:String, param3:Number = -1) : void
      {
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = this.m_charSelectionBoxes[param1 - 1];
         if(param2 == "xp" && ResourceManager.TotalExpansions > 0)
         {
            param2 = Stats.getStats(param2,param3).StatsName;
            _loc5_.nextExp.visible = true;
            _loc5_.playerTxt.text = Stats.getStats(param2,param3).DisplayName != null ? Stats.getStats(param2,param3).DisplayName : "";
         }
         else
         {
            param3 = -1;
            _loc5_.nextExp.visible = false;
            _loc5_.playerTxt.text = param2 == "random" ? "Random" : Stats.getStats(param2,param3).DisplayName;
         }
         Utils.fitText(_loc5_.playerTxt,20,1);
         if(MovieClip(_loc5_.getChildByName("pic")).numChildren > 0)
         {
            MovieClip(_loc5_.getChildByName("pic")).removeChild(MovieClip(_loc5_.getChildByName("pic")).getChildByName("mc"));
         }
         if(param2 == "random")
         {
            _loc4_ = ResourceManager.getLibraryMC("rand_mc");
         }
         else if(param3 < 0)
         {
            if(ResourceManager.getLibraryMC(Stats.getStats(param2,-1).StatsName + "_charselect") != null)
            {
               _loc4_ = ResourceManager.getLibraryMC(Stats.getStats(param2,param3).StatsName + "_charselect");
            }
            else
            {
               _loc4_ = ResourceManager.getLibraryMC("mario_charselect");
            }
         }
         else
         {
            _loc4_ = ResourceManager.getLibraryMC(Stats.getStats(param2,param3).StatsName);
         }
         MovieClip(_loc5_.getChildByName("pic")).addChild(_loc4_);
         _loc4_.mouseChildren = false;
         _loc4_.mouseEnabled = false;
         _loc4_.name = "mc";
         _loc4_.filters = null;
         Utils.setColorFilterCharacter(_loc4_,this.m_game.PlayerSettings[param1 - 1].team,param2,this.m_game.PlayerSettings[param1 - 1].costume,true,true);
         if(MovieClip(_loc5_.getChildByName("icon")).numChildren > 0)
         {
            MovieClip(_loc5_.getChildByName("icon")).removeChild(MovieClip(_loc5_.getChildByName("icon")).getChildByName("mc"));
         }
         _loc4_ = param2 == "random" ? null : ResourceManager.getLibraryMC(Stats.getStats(param2,param3).SeriesIcon);
         if(_loc4_ != null)
         {
            _loc4_ = MovieClip(_loc5_.getChildByName("icon")).addChild(_loc4_) as MovieClip;
            _loc4_.name = "mc";
            if(this.m_game.PlayerSettings[param1 - 1].human && this.m_game.PlayerSettings[param1 - 1].team > 0)
            {
               switch(this.m_game.PlayerSettings[param1 - 1].team)
               {
                  case 1:
                     Utils.setTint(_loc4_,1,1,1,1,90,0,0,0);
                     break;
                  case 2:
                     Utils.setTint(_loc4_,1,1,1,1,0,90,0,0);
                     break;
                  case 3:
                     Utils.setTint(_loc4_,1,1,1,1,0,0,90,0);
                     break;
                  case 4:
                     Utils.setTint(_loc4_,1,1,1,1,90,72,0,0);
               }
            }
            else if(this.m_game.PlayerSettings[param1 - 1].human)
            {
               switch(param1)
               {
                  case 1:
                     Utils.setTint(_loc4_,1,1,1,1,90,0,0,0);
                     break;
                  case 2:
                     Utils.setTint(_loc4_,1,1,1,1,0,0,90,0);
                     break;
                  case 3:
                     Utils.setTint(_loc4_,1,1,1,1,90,90,0,0);
                     break;
                  case 4:
                     Utils.setTint(_loc4_,1,1,1,1,0,90,0,0);
               }
            }
            else
            {
               Utils.setTint(_loc4_,1,1,1,1,0,0,0,0);
            }
         }
      }
      
      public function setLevel(param1:Number, param2:Number) : void
      {
         var _loc3_:MovieClip = this.m_charSelectionBoxes[param1 - 1];
         if(param2 > 9)
         {
            param2 = 1;
         }
         else if(param2 < 1)
         {
            param2 = 9;
         }
         if(this.m_game.PlayerSettings[param1 - 1].level != param2)
         {
            this.m_game.PlayerSettings[param1 - 1].level = param2;
            _loc3_.levelDisplay.levelTxt.text = "" + param2;
            SaveData["VSCPULevel" + param1] = param2;
         }
         this.updateLevelDisplay();
      }
      
      public function toggleGameMode() : void
      {
         this.m_game.LevelData.teams = !this.m_game.LevelData.teams;
         this.updateGameMode();
      }
      
      private function updateGameMode() : void
      {
         var _loc1_:int = 0;
         if(this.m_game.LevelData.teams)
         {
            _loc1_ = 0;
            while(_loc1_ < this.m_game.PlayerSettings.length)
            {
               this.m_charSelectionBoxes[_loc1_].flag.visible = this.m_game.PlayerSettings[_loc1_].exist;
               this.m_game.PlayerSettings[_loc1_].team = this.m_game.PlayerSettings[_loc1_].team_prev;
               this.updatePlayerInfo(_loc1_ + 1);
               _loc1_++;
            }
         }
         else
         {
            _loc1_ = 0;
            while(_loc1_ < this.m_game.PlayerSettings.length)
            {
               this.m_charSelectionBoxes[_loc1_].flag.visible = false;
               this.m_game.PlayerSettings[_loc1_].team_prev = this.m_game.PlayerSettings[_loc1_].team;
               this.m_game.PlayerSettings[_loc1_].team = -1;
               this.m_game.PlayerSettings[_loc1_].costume = -1;
               this.updatePlayerInfo(_loc1_ + 1);
               if(_loc1_ != 0 && this.costumeExistsElsewhere(this.m_game.PlayerSettings[_loc1_].costume,_loc1_ + 1))
               {
                  this.nextCostume(_loc1_ + 1);
               }
               _loc1_++;
            }
         }
         if(Boolean(ModeFeatures.hasFeature(ModeFeatures.ALLOW_FFA_TEAM_TOGGLE,this.m_game.GameMode)) && Boolean(ModeFeatures.hasFeature(ModeFeatures.ALLOW_FFA_TEAM_TOGGLE,this.m_game.GameMode)))
         {
            m_subMenu.bnGameMode.gameModeTxt.gotoAndStop(this.m_game.LevelData.teams ? "team" : "ffa");
         }
         this.updateGameIsReady();
         this.updateSeriesIconColors();
      }
      
      private function updateSeriesIconColors() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:MovieClip = null;
         var _loc3_:int = 1;
         while(_loc3_ <= this.m_charSelectionBoxes.length)
         {
            _loc1_ = this.m_charSelectionBoxes[_loc3_ - 1];
            if(Boolean(_loc1_.getChildByName("pic")) && MovieClip(_loc1_.getChildByName("pic")).getChildByName("mc") != null)
            {
               Utils.setColorFilterCharacter(MovieClip(MovieClip(_loc1_.getChildByName("pic")).getChildByName("mc")),this.m_game.PlayerSettings[_loc3_ - 1].team,this.m_game.PlayerSettings[_loc3_ - 1].character == "xp" ? Stats.getStats("xp",this.m_game.PlayerSettings[_loc3_ - 1].expansion).StatsName : this.m_game.PlayerSettings[_loc3_ - 1].character,this.m_game.PlayerSettings[_loc3_ - 1].costume,true,true);
            }
            if(_loc1_.getChildByName("icon") != null && MovieClip(_loc1_.getChildByName("icon")).getChildByName("mc") != null)
            {
               _loc2_ = MovieClip(MovieClip(_loc1_.getChildByName("icon")).getChildByName("mc"));
               if(this.m_game.PlayerSettings[_loc3_ - 1].team > 0 && this.m_game.PlayerSettings[_loc3_ - 1].human)
               {
                  switch(this.m_game.PlayerSettings[_loc3_ - 1].team)
                  {
                     case 1:
                        Utils.setTint(_loc2_,1,1,1,1,90,0,0,0);
                        break;
                     case 2:
                        Utils.setTint(_loc2_,1,1,1,1,0,90,0,0);
                        break;
                     case 3:
                        Utils.setTint(_loc2_,1,1,1,1,0,0,90,0);
                        break;
                     case 4:
                        Utils.setTint(_loc2_,1,1,1,1,90,72,0,0);
                  }
               }
               else if(this.m_game.PlayerSettings[_loc3_ - 1].human)
               {
                  switch(_loc3_)
                  {
                     case 1:
                        Utils.setTint(_loc2_,1,1,1,1,90,0,0,0);
                        break;
                     case 2:
                        Utils.setTint(_loc2_,1,1,1,1,0,0,90,0);
                        break;
                     case 3:
                        Utils.setTint(_loc2_,1,1,1,1,90,90,0,0);
                        break;
                     case 4:
                        Utils.setTint(_loc2_,1,1,1,1,0,90,0,0);
                  }
               }
               else
               {
                  Utils.setTint(_loc2_,1,1,1,1,0,0,0,0);
               }
            }
            _loc3_++;
         }
      }
      
      public function prevCostume(param1:int) : void
      {
         var _loc2_:Object = null;
         var _loc4_:String = null;
         var _loc3_:int = this.m_game.PlayerSettings[param1 - 1].costume;
         if(!this.m_game.LevelData.teams && this.m_game.PlayerSettings[param1 - 1].character != null)
         {
            do
            {
               _loc4_ = this.m_game.PlayerSettings[param1 - 1].character == "xp" ? Stats.getStats("xp",this.m_game.PlayerSettings[param1 - 1].expansion).StatsName : this.m_game.PlayerSettings[param1 - 1].character;
               --this.m_game.PlayerSettings[param1 - 1].costume;
               if(this.m_game.PlayerSettings[param1 - 1].costume < -1)
               {
                  this.m_game.PlayerSettings[param1 - 1].costume = ResourceManager.getCostumeCount(_loc4_) - 2;
               }
               _loc2_ = ResourceManager.getCostume(_loc4_,null,this.m_game.PlayerSettings[param1 - 1].costume);
            }
            while(!(!this.costumeExistsElsewhere(this.m_game.PlayerSettings[param1 - 1].costume,param1) || _loc3_ == this.m_game.PlayerSettings[param1 - 1].costume));
            this.updateSeriesIconColors();
         }
      }
      
      public function nextCostume(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc6_:String = null;
         var _loc5_:MovieClip = this.m_charSelectionBoxes[param1 - 1];
         if(!this.m_game.PlayerSettings[param1 - 1].character || this.m_game.PlayerSettings[param1 - 1].character === "random")
         {
            return;
         }
         if(Boolean(_loc5_ && _loc5_.pic) && Boolean(MovieClip(_loc5_.pic).numChildren > 0) && Boolean(MovieClip(MovieClip(_loc5_.pic).getChildAt(0)).alternateStatsName))
         {
            if(param2)
            {
               SoundQueue.instance.playSoundEffect("menu_hover");
            }
            this.setPlayer(param1,MovieClip(MovieClip(_loc5_.pic).getChildAt(0)).alternateStatsName,this.m_game.PlayerSettings[param1 - 1].expansion);
         }
         else
         {
            _loc3_ = this.m_game.PlayerSettings[param1 - 1].costume;
            if(!this.m_game.LevelData.teams)
            {
               do
               {
                  _loc6_ = this.m_game.PlayerSettings[param1 - 1].character == "xp" ? Stats.getStats("xp",this.m_game.PlayerSettings[param1 - 1].expansion).StatsName : this.m_game.PlayerSettings[param1 - 1].character;
                  ++this.m_game.PlayerSettings[param1 - 1].costume;
                  if(this.m_game.PlayerSettings[param1 - 1].costume >= ResourceManager.getCostumeCount(_loc6_) - 1)
                  {
                     this.m_game.PlayerSettings[param1 - 1].costume = -1;
                  }
                  _loc4_ = ResourceManager.getCostume(_loc6_,null,this.m_game.PlayerSettings[param1 - 1].costume);
               }
               while(!(!this.costumeExistsElsewhere(this.m_game.PlayerSettings[param1 - 1].costume,param1) || _loc3_ == this.m_game.PlayerSettings[param1 - 1].costume));
               if(param2)
               {
                  SoundQueue.instance.playSoundEffect("menu_hover");
               }
               this.updateSeriesIconColors();
            }
         }
      }
      
      public function costumeExistsElsewhere(param1:int, param2:int) : Boolean
      {
         var _loc3_:int = 0;
         while(_loc3_ < this.m_game.PlayerSettings.length)
         {
            if(this.m_game.PlayerSettings[_loc3_] != this.m_game.PlayerSettings[param2 - 1])
            {
               if(this.m_game.PlayerSettings[_loc3_].costume == param1 && this.m_game.PlayerSettings[param2 - 1].character == this.m_game.PlayerSettings[_loc3_].character)
               {
                  return true;
               }
            }
            _loc3_++;
         }
         return false;
      }
      
      public function toggleTeam(param1:int) : void
      {
         if(!ModeFeatures.hasFeature(ModeFeatures.ALLOW_TEAM_TOGGLE,this.gameMode))
         {
            return;
         }
         var _loc2_:MovieClip = this.m_charSelectionBoxes[param1 - 1];
         ++this.m_game.PlayerSettings[param1 - 1].team;
         if((this.gameMode === Mode.ARENA || this.gameMode === Mode.ONLINE_ARENA) && this.m_game.PlayerSettings[param1 - 1].team === 2)
         {
            ++this.m_game.PlayerSettings[param1 - 1].team;
         }
         if(this.m_game.PlayerSettings[param1 - 1].team > 3)
         {
            this.m_game.PlayerSettings[param1 - 1].team = 1;
         }
         this.m_game.PlayerSettings[param1 - 1].team_prev = this.m_game.PlayerSettings[param1 - 1].team;
         _loc2_.flag.gotoAndStop("team" + this.m_game.PlayerSettings[param1 - 1].team);
         _loc2_.charPortrait.gotoAndStop(this.m_game.PlayerSettings[param1 - 1].human ? "team" + this.m_game.PlayerSettings[param1 - 1].team : "cpu");
         _loc2_.playerTitle.gotoAndStop(this.m_game.PlayerSettings[param1 - 1].human ? "player" + this.m_game.PlayerSettings[param1 - 1].team : "cpu");
         this.updateGameIsReady();
         this.updateSeriesIconColors();
      }
      
      public function toggleControl(param1:int) : void
      {
         this.hideNamesKeypad(param1);
         var _loc2_:String = "display" + param1;
         if(this.m_game.PlayerSettings[param1 - 1].exist)
         {
            if(this.m_game.PlayerSettings[param1 - 1].human)
            {
               this.m_game.PlayerSettings[param1 - 1].human = false;
               this.m_game.PlayerSettings[param1 - 1].name = null;
            }
            else
            {
               this.m_game.PlayerSettings[param1 - 1].exist = false;
               this.m_game.PlayerSettings[param1 - 1].name = null;
               this.setPlayer(param1,null);
            }
         }
         else
         {
            this.resetChipPosition(param1);
            this.m_game.PlayerSettings[param1 - 1].exist = true;
            this.m_game.PlayerSettings[param1 - 1].human = true;
            this.m_game.PlayerSettings[param1 - 1].name = null;
         }
         this.updateControl(param1);
         this.updatePlayerInfo(param1);
         this.updateNamesDisplay();
         this.updateGameIsReady();
      }
      
      private function updateControl(param1:int) : void
      {
         var _loc2_:MovieClip = this.m_charSelectionBoxes[param1 - 1];
         var _loc3_:Chip = this.m_playerChips[param1 - 1];
         if(this.m_game.PlayerSettings[param1 - 1].exist)
         {
            _loc2_.gotoAndStop("on");
            if(this.m_game.PlayerSettings[param1 - 1].human)
            {
               _loc2_.playerTxt.visible = true;
               _loc2_.playerTitle.visible = true;
               _loc2_.levelDisplay.visible = false;
               _loc2_.nameDisplay.visible = true;
               _loc3_.Visible = true;
               _loc3_.MC.gotoAndStop("human" + param1);
               _loc2_.playerTitle.nameTxt.text = "PLAYER" + param1;
               _loc2_.controlType.gotoAndStop("human");
            }
            else
            {
               _loc2_.playerTxt.visible = true;
               _loc2_.playerTitle.visible = true;
               _loc2_.levelDisplay.visible = true;
               _loc2_.nameDisplay.visible = false;
               _loc2_.controlType.gotoAndStop("cpu");
               _loc2_.flag.visible = this.m_game.LevelData.teams;
               _loc2_.playerTitle.nameTxt.text = "PLAYER" + param1;
               if(MovieClip(_loc2_.icon).getChildByName("mc") != null)
               {
                  Utils.setTint(MovieClip(_loc2_.icon).getChildByName("mc") as MovieClip,1,1,1,1,0,0,0,0);
               }
               _loc3_.MC.gotoAndStop("cpu");
            }
         }
         else
         {
            _loc2_.playerTxt.visible = false;
            _loc2_.playerTitle.visible = false;
            _loc2_.controlType.gotoAndStop("na");
            _loc2_.levelDisplay.visible = false;
            _loc2_.nameDisplay.visible = false;
            _loc2_.flag.visible = false;
            _loc2_.playerTitle.nameTxt.text = "PLAYER" + param1;
            _loc3_.Visible = false;
            _loc3_.LastHit = null;
            _loc3_.MC.gotoAndStop("human" + param1);
            _loc2_.gotoAndStop("off");
         }
      }
      
      public function showNamesKeypad(param1:int) : void
      {
         var _loc2_:MovieClip = this.m_charSelectionBoxes[param1 - 1];
         var _loc3_:String = _loc2_.nameDisplay.nameTxt.text;
         if(!_loc2_.nameDisplay.nameKeyPad.visible)
         {
            _loc2_.nameDisplay.nameKeyPad.visible = true;
            _loc2_.nameDisplay.nameTxt.text = "";
         }
         this.updateGameIsReady();
      }
      
      public function hideNamesKeypad(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = this.m_charSelectionBoxes[param1 - 1];
         var _loc4_:String = _loc3_.nameDisplay.nameTxt.text;
         if(_loc3_.nameDisplay.nameKeyPad.visible)
         {
            _loc2_ = 0;
            while(_loc2_ < this.m_game.PlayerSettings.length)
            {
               if(Boolean(_loc2_ + 1 !== param1) && Boolean(_loc4_) && this.m_game.PlayerSettings[_loc2_].name === _loc4_)
               {
                  SoundQueue.instance.playSoundEffect("menu_error");
                  return;
               }
               _loc2_++;
            }
            this.m_game.PlayerSettings[param1 - 1].name = _loc4_ == "" ? null : _loc3_.nameDisplay.nameTxt.text;
            _loc3_.nameDisplay.nameKeyPad.visible = false;
            if(!this.m_game.PlayerSettings[param1 - 1].name)
            {
               _loc3_.nameDisplay.nameTxt.text = "P" + param1;
            }
            TextField(_loc3_.nameDisplay.nameTxt).textColor = 15658734;
            if(SaveData.Controllers[param1 - 1].GamepadInstance)
            {
               if(this.m_game.PlayerSettings[param1 - 1].name)
               {
                  SaveData.reimportNamedPlayerControls(param1,this.m_game.PlayerSettings[param1 - 1].name);
               }
               else
               {
                  SaveData.reimportSlottedPlayerControls(param1);
               }
            }
         }
         this.updateGameIsReady();
      }
      
      private function updatePlayerInfo(param1:int) : void
      {
         var _loc2_:MovieClip = this.m_charSelectionBoxes[param1 - 1];
         if(this.m_game.LevelData.teams && this.m_game.PlayerSettings[param1 - 1].exist)
         {
            _loc2_.charPortrait.gotoAndStop(this.m_game.PlayerSettings[param1 - 1].human ? "team" + this.m_game.PlayerSettings[param1 - 1].team : "cpu");
            _loc2_.playerTitle.gotoAndStop(this.m_game.PlayerSettings[param1 - 1].human ? "player" + this.m_game.PlayerSettings[param1 - 1].team : "cpu");
            _loc2_.flag.visible = this.m_game.LevelData.teams;
            _loc2_.flag.gotoAndStop(this.m_game.PlayerSettings[param1 - 1].team);
            _loc2_.playerTitle.nameTxt.text = "PLAYER" + param1;
         }
         else if(this.m_game.PlayerSettings[param1 - 1].exist)
         {
            switch(param1)
            {
               case 1:
                  _loc2_.charPortrait.gotoAndStop(this.m_game.PlayerSettings[param1 - 1].human ? "team1" : "cpu");
                  _loc2_.playerTitle.gotoAndStop(this.m_game.PlayerSettings[param1 - 1].human ? "player1" : "cpu");
                  break;
               case 2:
                  _loc2_.charPortrait.gotoAndStop(this.m_game.PlayerSettings[param1 - 1].human ? "team3" : "cpu");
                  _loc2_.playerTitle.gotoAndStop(this.m_game.PlayerSettings[param1 - 1].human ? "player3" : "cpu");
                  break;
               case 3:
                  _loc2_.charPortrait.gotoAndStop(this.m_game.PlayerSettings[param1 - 1].human ? "team4" : "cpu");
                  _loc2_.playerTitle.gotoAndStop(this.m_game.PlayerSettings[param1 - 1].human ? "player4" : "cpu");
                  break;
               case 4:
                  _loc2_.charPortrait.gotoAndStop(this.m_game.PlayerSettings[param1 - 1].human ? "team2" : "cpu");
                  _loc2_.playerTitle.gotoAndStop(this.m_game.PlayerSettings[param1 - 1].human ? "player2" : "cpu");
            }
            _loc2_.flag.visible = this.m_game.LevelData.teams;
            _loc2_.playerTitle.nameTxt.text = "PLAYER" + param1;
         }
         else
         {
            _loc2_.playerTitle.visible = false;
            _loc2_.flag.visible = false;
         }
      }
      
      public function resetChipPosition(param1:int) : void
      {
         if(param1 >= 0 && param1 < this.m_playerChips.length)
         {
            this.m_playerChips[param1 - 1].X = this.m_playerChips[param1 - 1].OriginalPosition.x;
            this.m_playerChips[param1 - 1].Y = this.m_playerChips[param1 - 1].OriginalPosition.y;
         }
      }
      
      public function updateLevelDisplay() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.m_charSelectionBoxes.length)
         {
            _loc1_ = this.m_charSelectionBoxes[_loc2_];
            _loc1_.levelDisplay.visible = !this.m_game.PlayerSettings[_loc2_].human && this.m_game.PlayerSettings[_loc2_].exist ? true : false;
            _loc1_.levelDisplay.levelHandle.y = -4 - 50 * ((this.m_game.PlayerSettings[_loc2_].level - 1) / 10);
            _loc1_.levelDisplay.levelTxt.text = this.m_game.PlayerSettings[_loc2_].level;
            _loc2_++;
         }
      }
      
      public function updateNamesDisplay() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.m_charSelectionBoxes.length)
         {
            _loc1_ = this.m_charSelectionBoxes[_loc2_];
            _loc1_.nameDisplay.visible = this.m_game.PlayerSettings[_loc2_].human && this.m_game.PlayerSettings[_loc2_].exist ? true : false;
            _loc1_.nameDisplay.nameTxt.text = this.m_game.PlayerSettings[_loc2_].name ? this.m_game.PlayerSettings[_loc2_].name : "P" + (_loc2_ + 1);
            _loc2_++;
         }
      }
      
      public function setPlayerRandom(param1:int) : void
      {
         var _loc2_:MovieClip = null;
         this.setPlayer(param1,null,-1);
         this.m_game.PlayerSettings[param1 - 1].character = Stats.getCharacterList()[Utils.randomInteger(0,Stats.getCharacterList().length - 1)];
         this.m_game.PlayerSettings[param1 - 1].exist = true;
         this.m_game.PlayerSettings[param1 - 1].expansion = -1;
         if(this.m_charMCHash[this.m_game.PlayerSettings[param1 - 1].character])
         {
            _loc2_ = this.m_charMCHash[this.m_game.PlayerSettings[param1 - 1].character];
         }
         else
         {
            this.m_game.PlayerSettings[param1 - 1].character = "random";
            _loc2_ = this.m_charMCHash["random"];
         }
         if(_loc2_)
         {
            this.m_playerChips[param1 - 1].MC.x = _loc2_.x;
            this.m_playerChips[param1 - 1].MC.y = _loc2_.y;
         }
      }
      
      public function updateDisplay() : void
      {
         var _loc1_:String = null;
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         if(this.m_game.GameMode == Mode.TRAINING)
         {
            this.setPlayerRandom(2);
         }
         this.updateLevelDisplay();
         this.updateNamesDisplay();
         _loc3_ = 0;
         while(_loc3_ < this.m_playerChips.length)
         {
            this.m_playerChips[_loc3_].ExpansionNum = this.m_game.PlayerSettings[_loc3_].expansion;
            this.m_playerChips[_loc3_].Visible = this.m_game.PlayerSettings[_loc3_].exist ? true : false;
            this.m_playerChips[_loc3_].MC.gotoAndStop(this.m_game.PlayerSettings[_loc3_].human ? "human" + (_loc3_ + 1) : "cpu");
            _loc1_ = this.m_game.PlayerSettings[_loc3_].character;
            _loc2_ = this.m_charSelectionBoxes[_loc3_];
            if(_loc1_ != null)
            {
               this.changePic(_loc3_ + 1,_loc1_,this.m_game.PlayerSettings[_loc3_].expansion);
               this.m_playerChips[_loc3_].LastHit = _loc1_;
            }
            else
            {
               _loc2_.playerTxt.text = "";
               this.removePic(_loc3_ + 1);
               this.resetChipPosition(_loc3_ + 1);
            }
            Utils.fitText(_loc2_.playerTxt,20,1);
            _loc2_.gotoAndStop(this.m_game.PlayerSettings[_loc3_].exist ? "on" : "off");
            _loc2_.nextExp.visible = this.m_game.PlayerSettings[_loc3_].character == "xp";
            this.updatePlayerInfo(_loc3_ + 1);
            if(!this.m_game.PlayerSettings[_loc3_].exist)
            {
               _loc2_.controlType.gotoAndStop("na");
               _loc2_.gotoAndStop("off");
            }
            else if(!this.m_game.PlayerSettings[_loc3_].human)
            {
               _loc2_.controlType.gotoAndStop("cpu");
            }
            else
            {
               _loc2_.controlType.gotoAndStop("human");
            }
            this.updateControl(_loc3_ + 1);
            _loc3_++;
         }
         if(Boolean(ModeFeatures.hasFeature(ModeFeatures.ALLOW_FFA_TEAM_TOGGLE,this.m_game.GameMode)) && Boolean(ModeFeatures.hasFeature(ModeFeatures.ALLOW_FFA_TEAM_TOGGLE,this.m_game.GameMode)) && Boolean(m_subMenu.bnGameMode))
         {
            m_subMenu.bnGameMode.gameModeTxt.gotoAndStop(this.m_game.LevelData.teams ? "team" : "ffa");
         }
         if(Boolean(ModeFeatures.hasFeature(ModeFeatures.ALLOW_FFA_TEAM_TOGGLE,this.m_game.GameMode)) && Boolean(ModeFeatures.hasFeature(ModeFeatures.ALLOW_FFA_TEAM_TOGGLE,this.m_game.GameMode)) && Boolean(m_subMenu.bnGameMode))
         {
            this.updateIncDecDisplay();
         }
         this.updateGameIsReady();
         this.updateSeriesIconColors();
      }
      
      public function hasVisibleKeypad() : Boolean
      {
         var _loc1_:int = 1;
         while(_loc1_ <= this.m_charSelectionBoxes.length)
         {
            if(this.m_charSelectionBoxes[_loc1_ - 1].nameDisplay.nameKeyPad.visible)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function gameIsReady() : Boolean
      {
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         if(Boolean(MultiplayerManager.Connected) || Boolean(ModeFeatures.hasFeature(ModeFeatures.ALLOW_SINGLE_PLAYER,this.m_game.GameMode)))
         {
            return this.singlePlayerReady();
         }
         var _loc1_:Number = 0;
         var _loc2_:int = 2;
         var _loc3_:Number = 999;
         while(_loc5_ < this.m_game.PlayerSettings.length)
         {
            if(_loc1_ < _loc2_)
            {
               if(this.m_game.PlayerSettings[_loc5_].character != null && this.m_game.PlayerSettings[_loc5_].team != _loc3_ || this.m_game.PlayerSettings[_loc5_].character != null && this.m_game.PlayerSettings[_loc5_].team == -1)
               {
                  _loc3_ = this.m_game.PlayerSettings[_loc5_].team;
                  _loc1_++;
               }
            }
            _loc5_++;
         }
         if(this.hasVisibleKeypad())
         {
            _loc4_ = true;
         }
         if(_loc1_ >= _loc2_ && Boolean(this.m_readyDelay.IsComplete) && !(this.m_game.GameMode == Mode.TRAINING && this.m_game.PlayerSettings[0].character == null) && !_loc4_ && !MenuController.costumeSelectorDisplay.isOnscreen())
         {
            return true;
         }
         return false;
      }
      
      private function singlePlayerReady() : Boolean
      {
         if(this.m_game.PlayerSettings[0].character != null)
         {
            return true;
         }
         return false;
      }
      
      public function incrementShortcut() : void
      {
         if(this.m_game.UsingLives)
         {
            SaveData.toggleStock(true);
            this.m_game.LevelData.lives = SaveData.Lives;
         }
         else
         {
            SaveData.toggleTime(true);
            this.m_game.LevelData.time = SaveData.Time;
         }
         this.m_game.loadSavedVSOptions();
         this.updateIncDecDisplay();
      }
      
      public function decrementShortcut() : void
      {
         if(this.m_game.UsingLives)
         {
            SaveData.toggleStock(false);
         }
         else
         {
            SaveData.toggleTime(false);
         }
         this.m_game.loadSavedVSOptions();
         this.updateIncDecDisplay();
      }
      
      private function updateIncDecDisplay() : void
      {
         if(this.m_game.UsingLives)
         {
            m_subMenu.match_desc.text = "-man survival fest!";
            m_subMenu.opCount.text = this.m_game.Lives;
         }
         else
         {
            m_subMenu.match_desc.text = "-minute KO test!";
            m_subMenu.opCount.text = this.m_game.Time;
         }
      }
      
      public function setPlayer(param1:int, param2:String, param3:Number = -1) : void
      {
         if(param2 == null && this.m_game.PlayerSettings[param1 - 1].character != null)
         {
            this.removePic(param1);
            this.m_game.PlayerSettings[param1 - 1].character = null;
            this.m_game.PlayerSettings[param1 - 1].costume = -1;
         }
         else if(param2 != null && this.m_game.PlayerSettings[param1 - 1].exist)
         {
            if(this.m_game.PlayerSettings[param1 - 1].character != param2 || param2 == "xp" && ResourceManager.TotalExpansions != 0)
            {
               this.m_game.PlayerSettings[param1 - 1].costume = -1;
               this.m_game.PlayerSettings[param1 - 1].character = param2;
               this.m_game.PlayerSettings[param1 - 1].expansion = param3;
               this.changePic(param1,param2,param3);
               if(this.costumeExistsElsewhere(this.m_game.PlayerSettings[param1 - 1].costume,param1))
               {
                  this.nextCostume(param1);
               }
            }
         }
         this.updateGameIsReady();
      }
      
      public function updateGameIsReady() : void
      {
         if(this.gameIsReady() && !MenuController.CurrentCharacterSelectMenu.SubMenu.readyToFight.visible)
         {
            MenuController.CurrentCharacterSelectMenu.SubMenu.readyToFight.gotoAndPlay(2);
            MenuController.CurrentCharacterSelectMenu.SubMenu.readyToFight.visible = true;
         }
         else if(!this.gameIsReady() && Boolean(MenuController.CurrentCharacterSelectMenu.SubMenu.readyToFight.visible))
         {
            MenuController.CurrentCharacterSelectMenu.SubMenu.readyToFight.gotoAndStop(1);
            MenuController.CurrentCharacterSelectMenu.SubMenu.readyToFight.visible = false;
         }
      }
      
      protected function insertExpansionSlot(param1:int) : void
      {
         if(!Main.DEBUG || !Config.character_expansion)
         {
            return;
         }
         var _loc2_:MovieClip = ResourceManager.getLibraryMC("xp_select");
         _loc2_.gotoAndStop(1);
         this.m_charMCHash["cxp"] = _loc2_;
         this.CharSelectionIconsMC.addChild(_loc2_);
         m_subMenu.charSelection.charSelect.addChild(_loc2_);
         this.displayObjectTable.insertObject(param1,_loc2_);
      }
   }
}


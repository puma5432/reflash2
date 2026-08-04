package com.sbxmod.paletteMaker
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.api.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.Character;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.menus.Menu;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   
   public class PaletteMakerMenu extends Menu
   {
      
      private static var statsName:String;
      
      private const COSTUME_NAME_MAX_LENGTH:int = 16;
      
      private const COLOR_BOX_PA_LIMIT:int = 20;
      
      private var ENABLE_PIXEL_ART_LIVE_UPDATE:Boolean = false;
      
      private var currentPaletteData:Object;
      
      private var mixedBasePaletteData:Array = [];
      
      private var player:Character;
      
      private var colorArrFactor:Array = [];
      
      private var brightnessArrFactor:Array = [];
      
      private var saturationArrFactor:Array = [];
      
      private var alphaArrFactor:Array = [];
      
      private var PixelArt:MovieClip;
      
      private var m_game:Game;
      
      private var updateFrameCount:int = 0;
      
      private var colorArrow:MovieClip;
      
      private var colorArrowStartX:Number;
      
      private var colorArrowStartY:Number;
      
      private var colorBounds:MovieClip;
      
      private var brightnessArrow:MovieClip;
      
      private var brightnessArrowStartX:Number;
      
      private var brightnessArrowStartY:Number;
      
      private var brightnessBounds:MovieClip;
      
      private var saturationArrow:MovieClip;
      
      private var saturationArrowStartX:Number;
      
      private var saturationArrowStartY:Number;
      
      private var saturationBounds:MovieClip;
      
      private var alphaArrow:MovieClip;
      
      private var alphaArrowStartX:Number;
      
      private var alphaArrowStartY:Number;
      
      private var alphaBounds:MovieClip;
      
      public function PaletteMakerMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("VCostumeCreatorMenu");
         m_fillBackground = false;
         m_backgroundID = "space";
         m_container.addChild(m_subMenu);
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         this.colorArrow = m_subMenu.colors.arrow;
         this.colorArrowStartX = this.colorArrow.x;
         this.colorArrowStartY = this.colorArrow.y;
         this.colorArrow.x = this.colorArrowStartX;
         this.colorArrow.y = this.colorArrowStartY;
         this.colorBounds = m_subMenu.colors.bounds;
         this.brightnessArrow = m_subMenu.brightness.arrow;
         this.brightnessArrowStartX = this.brightnessArrow.x;
         this.brightnessArrowStartY = this.brightnessArrow.y;
         this.brightnessArrow.x = this.brightnessArrowStartX;
         this.brightnessArrow.y = this.brightnessArrowStartY;
         this.brightnessBounds = m_subMenu.brightness.bounds;
         this.saturationArrow = m_subMenu.saturation.arrow;
         this.saturationArrowStartX = this.saturationArrow.x;
         this.saturationArrowStartY = this.saturationArrow.y;
         this.saturationArrow.x = this.saturationArrowStartX;
         this.saturationArrow.y = this.saturationArrowStartY;
         this.saturationBounds = m_subMenu.saturation.bounds;
         this.alphaArrow = m_subMenu._alpha.arrow;
         this.alphaArrowStartX = this.alphaArrow.x;
         this.alphaArrowStartY = this.alphaArrow.y;
         this.alphaArrow.x = this.alphaArrowStartX;
         this.alphaArrow.y = this.alphaArrowStartY;
         this.alphaBounds = m_subMenu._alpha.bounds;
         this.colorArrow.x = this.colorBounds.width;
         this.brightnessArrow.x = m_subMenu.brightness.width / 2;
         this.saturationArrow.x = m_subMenu.saturation.width / 2;
         this.alphaArrow.x = this.alphaBounds.width;
      }
      
      public static function setCharacter(param1:String) : void
      {
         statsName = param1;
      }
      
      override public function show() : void
      {
         var _loc5_:Object = null;
         super.show();
         this.player = null;
         var _loc1_:Object = null;
         try
         {
            _loc1_ = ResourceManager.getCostume(statsName,null);
         }
         catch(err:Error)
         {
         }
         var _loc2_:Boolean = false;
         try
         {
            _loc5_ = ResourceManager.getResourceByID("misc").getProp("metadata");
            _loc2_ = Boolean(_loc5_) && Boolean(_loc5_.costume_data) && Boolean(_loc5_.costume_data[statsName]);
         }
         catch(err2:Error)
         {
         }
         var _loc3_:Array = PaletteMakerUtils.getCostume(statsName);
         var _loc4_:Object = this.getPaletteMakerBaseCostumeData(statsName,_loc1_);
         m_subMenu.slotName.text = "New Costume";
         this.mixedBasePaletteData = this.mixArrays(_loc4_.paletteSwap.colors,_loc4_.paletteSwapPA.colors);
         this.currentPaletteData = Utils.cloneObject(_loc4_);
         this.currentPaletteData.paletteSwapPA.replacements = Utils.cloneObject(_loc4_.paletteSwapPA.colors);
         this.currentPaletteData.paletteSwap.replacements = Utils.cloneObject(_loc4_.paletteSwap.colors);
         this.makeColorBoxes(this.mixedBasePaletteData);
         this.startGame(null);
      }
      
      override public function makeEvents() : void
      {
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         resetAllButtons();
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.save_btn.addEventListener(MouseEvent.CLICK,this.saveCostume_CLICK);
         m_subMenu.locker_btn.addEventListener(MouseEvent.CLICK,this.locker_CLICK);
         m_subMenu.slotName.addEventListener(FocusEvent.FOCUS_IN,this.editingTextStart);
         m_subMenu.slotName.addEventListener(FocusEvent.FOCUS_OUT,this.editingTextEnd);
         m_subMenu.slotName.addEventListener(Event.CHANGE,this.checkCostumeName);
         this.colorArrow.addEventListener(MouseEvent.MOUSE_DOWN,this.startDragColorArrow);
         this.brightnessArrow.addEventListener(MouseEvent.MOUSE_DOWN,this.startDragBrightnessArrow);
         this.saturationArrow.addEventListener(MouseEvent.MOUSE_DOWN,this.startDragSaturationArrow);
         this.alphaArrow.addEventListener(MouseEvent.MOUSE_DOWN,this.startDragAlphaArrow);
         m_subMenu.addEventListener(MouseEvent.MOUSE_UP,this.stopDragArrow);
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,manageMenuMappings);
      }
      
      override public function killEvents() : void
      {
         var _loc2_:ColorSquare = null;
         super.killEvents();
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.save_btn.removeEventListener(MouseEvent.CLICK,this.saveCostume_CLICK);
         m_subMenu.locker_btn.removeEventListener(MouseEvent.CLICK,this.locker_CLICK);
         m_subMenu.slotName.removeEventListener(FocusEvent.FOCUS_IN,this.editingTextStart);
         m_subMenu.slotName.removeEventListener(FocusEvent.FOCUS_OUT,this.editingTextEnd);
         m_subMenu.slotName.removeEventListener(Event.CHANGE,this.checkCostumeName);
         this.colorArrow.removeEventListener(MouseEvent.MOUSE_DOWN,this.startDragColorArrow);
         this.brightnessArrow.removeEventListener(MouseEvent.MOUSE_DOWN,this.startDragBrightnessArrow);
         this.saturationArrow.removeEventListener(MouseEvent.MOUSE_DOWN,this.startDragSaturationArrow);
         this.alphaArrow.removeEventListener(MouseEvent.MOUSE_DOWN,this.startDragAlphaArrow);
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,manageMenuMappings);
         var _loc1_:int = 0;
         while(_loc1_ < m_subMenu.colorBoxBG.numChildren)
         {
            _loc2_ = m_subMenu.colorBoxBG.getChildAt(_loc1_) as ColorSquare;
            if(_loc2_)
            {
               _loc2_.killEvents();
            }
            _loc1_++;
         }
      }
      
      private function updateCharacter(param1:Event) : void
      {
         var _loc2_:Character = null;
         try
         {
            ++this.updateFrameCount;
            _loc2_ = Boolean(GameController.stageData) && Boolean(GameController.stageData.Players) ? GameController.stageData.Players[0] : null;
            if(_loc2_ == null)
            {
               return;
            }
            if(this.player !== _loc2_)
            {
               this.player = _loc2_;
               try
               {
                  this.player.setCostumeAPI(-2);
               }
               catch(ignore:Error)
               {
               }
            }
            try
            {
               if(this.player.getX() > 434.25)
               {
                  this.player.setX(-24.4);
               }
               this.player.setPaletteSwap(this.currentPaletteData.paletteSwap,this.currentPaletteData.paletteSwapPA);
            }
            catch(err:Error)
            {
            }
         }
         catch(errAll:Error)
         {
         }
      }
      
      private function editingTextStart(param1:FocusEvent) : void
      {
         this.freezeKeys(true);
      }
      
      private function editingTextEnd(param1:FocusEvent) : void
      {
         this.freezeKeys(false);
      }
      
      private function checkCostumeName(param1:Event) : void
      {
         if(m_subMenu.slotName.text.length > this.COSTUME_NAME_MAX_LENGTH)
         {
            m_subMenu.slotName.text = m_subMenu.slotName.text.substr(0,this.COSTUME_NAME_MAX_LENGTH);
         }
         if(m_subMenu.slotName.text == "\t")
         {
            param1.preventDefault();
         }
         if(m_subMenu.slotName.text == PaletteMakerUtils.DEFAULT_COSTUME_NAME)
         {
            Utils.setBrightness(m_subMenu.save_btn,-75);
         }
         else
         {
            Utils.setBrightness(m_subMenu.save_btn,0);
         }
      }
      
      private function freezeKeys(param1:Boolean) : void
      {
         GameController.stageData.FreezeKeys = param1;
         if(param1)
         {
            GameController.hud.killEvents();
         }
         else
         {
            GameController.hud.makeEvents();
         }
      }
      
      private function mixArrays(param1:Array, param2:Array) : Array
      {
         var _loc5_:* = undefined;
         var _loc3_:Array = param1.concat(param2);
         var _loc4_:Array = [];
         for each(_loc5_ in _loc3_)
         {
            if(_loc4_.indexOf(_loc5_) == -1)
            {
               _loc4_.push(_loc5_);
            }
         }
         return _loc4_;
      }
      
      private function replaceBracket(param1:*, param2:*, param3:Array, param4:Array) : void
      {
         var _loc5_:* = param3.indexOf(param1);
         if(_loc5_ != -1 && _loc5_ < param3.length)
         {
            param4[_loc5_] = param2;
         }
      }
      
      private function startGame(param1:MouseEvent) : void
      {
         this.m_game = new Game(1,Mode.TRAINING);
         var _loc2_:Array = ["bgm_restareasmash4","bgm_restareabrawl","bgm_restareamelee","bgm_restarea"];
         SSF2API.setGlobalVar("allstar_mode_match_count",7);
         this.m_game.LevelData.stage = "restarea";
         this.m_game.LevelData.musicOverride = _loc2_[Utils.randomInteger(0,_loc2_.length - 1)];
         this.m_game.LevelData.randSeed = Utils.randomInteger(1,1000);
         this.m_game.UsingLives = false;
         this.m_game.UsingTime = false;
         this.m_game.UsingStamina = false;
         this.m_game.DamageRatio = 1;
         this.m_game.StartDamage = 0;
         this.m_game.FinalSmashMeter = false;
         this.m_game.ScoreDisplay = false;
         this.m_game.HudDisplay = false;
         this.m_game.PauseEnabled = false;
         this.m_game.LevelData.showEntrances = true;
         this.m_game.LevelData.showCountdownType = 2;
         this.m_game.ItemFrequency = 0;
         Utils.setRandSeed(this.m_game.LevelData.randSeed);
         this.m_game.PlayerSettings[0].character = statsName;
         ResourceManager.queueResources([this.m_game.LevelData.stage,this.m_game.LevelData.musicOverride]);
         PaletteMakerUtils.showPaletteMakerLoadingScreen(statsName,false);
         ResourceManager.load({"oncomplete":this.startMatch});
      }
      
      private function startMatch(param1:* = null) : void
      {
         try
         {
            GameController.startMatch(this.m_game);
         }
         catch(err:Error)
         {
         }
         this.player = null;
         PaletteMakerUtils.removeAllChildrenMC(m_backgroundContainer);
         PaletteMakerUtils.ensureFront(m_subMenu,GameController.stage);
         this.restAreaMod();
      }
      
      private function restAreaMod() : MovieClip
      {
         var PAContainer:MovieClip = null;
         var samplesContainer:MovieClip = ResourceManager.getLibraryMC("samplesContainer");
         var stageTerrain:* = GameController.stage.terrain;
         var stageForeground:MovieClip = GameController.stage.foreground;
         var stageBackground:MovieClip = GameController.stage.background;
         samplesContainer.name = "samplesContainer";
         this.PixelArt = ResourceManager.getLibraryMC(statsName + "_classic_trophy") || ResourceManager.getLibraryMC("placeholder_classic_trophy");
         stageTerrain.telepad.x = 1200;
         stageTerrain.camBoundary.y = -116.7;
         stageTerrain.camBoundary.height = 394;
         stageTerrain.camBoundary.width = 478.15;
         stageForeground.trophies.x = 1200;
         stageBackground.addChild(samplesContainer);
         PAContainer = MovieClip(stageBackground.getChildByName("samplesContainer"));
         stageBackground.trophies.x = 1200;
         PAContainer.scaleX = 0.598;
         PAContainer.scaleY = 0.598;
         PAContainer.x = 120.45;
         PAContainer.y = -66;
         try
         {
            if(Boolean(this.PixelArt) && Boolean(this.PixelArt.hasOwnProperty("stop")))
            {
               try
               {
                  this.PixelArt.stop();
               }
               catch(ignore:Error)
               {
               }
            }
            if(Boolean(this.PixelArt) && Boolean(this.PixelArt.hasOwnProperty("gotoAndStop")))
            {
               try
               {
                  this.PixelArt.gotoAndStop(1);
               }
               catch(ignore:Error)
               {
               }
            }
            MovieClip(PAContainer.placeholder).addChild(this.PixelArt);
         }
         catch(err:Error)
         {
            try
            {
               PixelArt = ResourceManager.getLibraryMC("placeholder_classic_trophy");
               MovieClip(PAContainer.placeholder).addChild(PixelArt);
            }
            catch(err2:Error)
            {
            }
         }
         Main.Root.removeEventListener(Event.ENTER_FRAME,this.updateCharacter);
         Main.Root.addEventListener(Event.ENTER_FRAME,this.updateCharacter);
      }
      
      private function locker_CLICK(param1:MouseEvent) : void
      {
         MenuController.costumeSelectorDisplay.setCharacter(statsName,0,true);
         MenuController.costumeSelectorDisplay.forceRefresh();
         MenuController.costumeSelectorDisplay.onClickContainer = this._onClickContainer;
         MenuController.costumeSelectorDisplay.onCloseMenu = this._onCloseMenu;
         this.freezeKeys(true);
         SoundQueue.instance.playSoundEffect("menu_select");
      }
      
      private function _onClickContainer() : void
      {
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:int = 0;
         var _loc13_:DisplayObject = null;
         var _loc14_:ColorSquare = null;
         var _loc1_:int = int(MenuController.costumeSelectorDisplay.getSelectedCostume());
         var _loc2_:Object = ResourceManager.getCostume(statsName,null,_loc1_);
         if(!_loc2_)
         {
            _loc2_ = this.getPaletteMakerBaseCostumeData(statsName,null);
         }
         var _loc3_:String = Boolean(_loc2_) && _loc2_.hasOwnProperty("profile") ? _loc2_.profile : PaletteMakerUtils.DEFAULT_COSTUME_NAME;
         var _loc4_:Object = this.normalizePaletteBlock(_loc2_.paletteSwap);
         var _loc5_:Object = this.normalizePaletteBlock(_loc2_.paletteSwapPA);
         var _loc6_:Array = this.mixColorPairs(_loc4_.colors.concat(_loc5_.colors),_loc4_.replacements.concat(_loc5_.replacements));
         var _loc7_:Array = [];
         for each(_loc8_ in _loc6_)
         {
            _loc10_ = uint(_loc8_.color);
            _loc11_ = uint(_loc8_.replacement);
            if(this.mixedBasePaletteData.indexOf(_loc10_) != -1)
            {
               _loc7_.push({
                  "color":_loc10_,
                  "replacement":_loc11_
               });
            }
         }
         for each(_loc9_ in _loc7_)
         {
            this.updatePaletteColor(_loc9_.color,_loc9_.replacement);
            _loc12_ = 0;
            while(_loc12_ < m_subMenu.colorBoxBG.numChildren)
            {
               _loc13_ = m_subMenu.colorBoxBG.getChildAt(_loc12_);
               if(_loc13_ is ColorSquare)
               {
                  _loc14_ = _loc13_ as ColorSquare;
                  if(_loc14_.colorValue == _loc9_.color)
                  {
                     _loc14_.updateIndicator(_loc9_.replacement);
                  }
               }
               _loc12_++;
            }
         }
         m_subMenu.slotName.text = _loc3_;
         this.checkCostumeName(null);
         ColorSquare.deselectAll();
         SoundQueue.instance.playSoundEffect("menu_select");
      }
      
      private function getPaletteMakerBaseCostumeData(param1:String, param2:Object) : Object
      {
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc3_:Object = param2;
         if(!_loc3_)
         {
            try
            {
               _loc4_ = ResourceManager.getResourceByID("misc").getProp("metadata");
               _loc5_ = Boolean(_loc4_) && Boolean(_loc4_.costume_data) ? _loc4_.costume_data[param1] : null;
               if(Boolean(_loc5_) && _loc5_.length > 0)
               {
                  _loc6_ = null;
                  for each(_loc7_ in _loc5_)
                  {
                     if(Boolean(_loc7_) && !_loc7_.team)
                     {
                        _loc6_ = _loc7_;
                        break;
                     }
                  }
                  _loc3_ = Utils.cloneObject(_loc6_ || _loc5_[0]);
               }
            }
            catch(err:Error)
            {
            }
         }
         if(!_loc3_)
         {
            _loc3_ = Utils.getCostumeObject({});
         }
         if(!_loc3_.paletteSwap)
         {
            _loc3_.paletteSwap = {
               "colors":[],
               "replacements":[]
            };
         }
         if(!_loc3_.paletteSwapPA)
         {
            _loc3_.paletteSwapPA = {
               "colors":[],
               "replacements":[]
            };
         }
         return _loc3_;
      }
      
      private function normalizePaletteBlock(param1:Object) : Object
      {
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(!param1)
         {
            return {
               "colors":[],
               "replacements":[]
            };
         }
         var _loc2_:Array = param1.colors is Array ? param1.colors : [];
         var _loc3_:Array = param1.replacements is Array ? param1.replacements : [];
         var _loc4_:int = Math.min(_loc2_.length,_loc3_.length);
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         var _loc7_:int = 0;
         while(_loc7_ < _loc4_)
         {
            _loc5_.push(_loc2_[_loc7_]);
            _loc6_.push(_loc3_[_loc7_]);
            _loc7_++;
         }
         if(_loc2_.length > _loc3_.length)
         {
            _loc8_ = int(_loc3_.length);
            while(_loc8_ < _loc2_.length)
            {
               _loc5_.push(_loc2_[_loc8_]);
               _loc6_.push(_loc2_[_loc8_]);
               _loc8_++;
            }
         }
         if(_loc3_.length > _loc2_.length)
         {
            _loc9_ = int(_loc2_.length);
            while(_loc9_ < _loc3_.length)
            {
               _loc5_.push(_loc3_[_loc9_]);
               _loc6_.push(_loc3_[_loc9_]);
               _loc9_++;
            }
         }
         return {
            "colors":_loc5_,
            "replacements":_loc6_
         };
      }
      
      private function mixColorPairs(param1:Array, param2:Array) : Array
      {
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc3_.push({
               "color":param1[_loc4_],
               "replacement":param2[_loc4_]
            });
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function _onCloseMenu() : void
      {
         this.freezeKeys(false);
         SoundQueue.instance.playSoundEffect("menu_back");
      }
      
      private function startDragColorArrow(param1:MouseEvent) : void
      {
         this.colorArrow.startDrag(false,new Rectangle(this.colorArrowStartX,this.colorArrowStartY,this.colorBounds.width,0));
         m_subMenu.addEventListener(MouseEvent.MOUSE_MOVE,this.updateColor);
      }
      
      private function blendColors(param1:*, param2:*, param3:Number) : *
      {
         var _loc4_:* = param1 >> 16 & 0xFF;
         var _loc5_:* = param1 >> 8 & 0xFF;
         var _loc6_:* = param1 & 0xFF;
         var _loc7_:* = param2 >> 16 & 0xFF;
         var _loc8_:* = param2 >> 8 & 0xFF;
         var _loc9_:* = param2 & 0xFF;
         var _loc10_:* = _loc4_ + param3 * (_loc7_ - _loc4_);
         var _loc11_:* = _loc5_ + param3 * (_loc8_ - _loc5_);
         var _loc12_:* = _loc6_ + param3 * (_loc9_ - _loc6_);
         return _loc10_ << 16 | _loc11_ << 8 | _loc12_;
      }
      
      private function getColorAtRatio(param1:Number) : *
      {
         var _loc2_:Array = [16711680,16776960,65280,65535,255,16711935,16711680];
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = Math.floor(param1 * (_loc3_ - 1));
         var _loc5_:int = Math.ceil(param1 * (_loc3_ - 1));
         var _loc6_:Number = param1 * (_loc3_ - 1) % 1;
         var _loc7_:* = _loc2_[_loc4_];
         var _loc8_:* = _loc2_[_loc5_];
         return this.blendColors(_loc7_,_loc8_,_loc6_);
      }
      
      private function updateColor(param1:MouseEvent) : void
      {
         var _loc2_:Number = this.colorArrow.x - this.colorBounds.x;
         var _loc3_:Number = _loc2_ / this.colorBounds.width;
         var _loc4_:Number = Number(this.getColorAtRatio(_loc3_));
         this.updateShapeColor("shiftColor",_loc4_);
      }
      
      private function adjustColor(param1:*, param2:*) : *
      {
         var _loc3_:Number = param1 >> 16 & 0xFF;
         var _loc4_:Number = param1 >> 8 & 0xFF;
         var _loc5_:Number = param1 & 0xFF;
         var _loc6_:* = param1 >> 24 & 0xFF;
         var _loc7_:Number = (_loc3_ + _loc4_ + _loc5_) / 3;
         var _loc8_:Number = Math.max(_loc3_,_loc4_,_loc5_);
         var _loc9_:Number = Math.min(_loc3_,_loc4_,_loc5_);
         var _loc10_:Number = _loc8_ == 0 ? 0 : (_loc8_ - _loc9_) / _loc8_;
         var _loc11_:Number = param2 >> 16 & 0xFF;
         var _loc12_:Number = param2 >> 8 & 0xFF;
         var _loc13_:Number = param2 & 0xFF;
         var _loc14_:Number = (_loc11_ + _loc12_ + _loc13_) / 3;
         var _loc15_:Number = _loc7_ == 0 ? 0 : _loc7_ / _loc14_;
         _loc11_ *= _loc15_;
         _loc12_ *= _loc15_;
         _loc13_ *= _loc15_;
         var _loc16_:Number = (_loc11_ + _loc12_ + _loc13_) / 3;
         _loc11_ = _loc16_ + (_loc11_ - _loc16_) * _loc10_;
         _loc12_ = _loc16_ + (_loc12_ - _loc16_) * _loc10_;
         _loc13_ = _loc16_ + (_loc13_ - _loc16_) * _loc10_;
         var _loc17_:* = Math.min(255,Math.max(0,_loc11_));
         var _loc18_:* = Math.min(255,Math.max(0,_loc12_));
         var _loc19_:* = Math.min(255,Math.max(0,_loc13_));
         return _loc6_ << 24 | _loc17_ << 16 | _loc18_ << 8 | _loc19_;
      }
      
      private function startDragBrightnessArrow(param1:MouseEvent) : void
      {
         this.brightnessArrow.startDrag(false,new Rectangle(this.brightnessArrowStartX,this.brightnessArrowStartY,this.brightnessBounds.width,0));
         m_subMenu.addEventListener(MouseEvent.MOUSE_MOVE,this.updateBrightness);
      }
      
      private function updateBrightness(param1:MouseEvent) : void
      {
         var _loc2_:Number = this.brightnessArrow.x - this.brightnessBounds.x;
         var _loc3_:Number = _loc2_ / this.brightnessBounds.width;
         var _loc4_:Number = _loc3_ * 2;
         _loc4_ = Math.max(0,Math.min(2,_loc4_));
         this.updateShapeColor("brightness",_loc4_);
         TextField(m_subMenu.brightness.lvl_txt).text = _loc4_.toFixed(2);
      }
      
      internal function adjustBrightness(param1:*, param2:Number) : *
      {
         param2 = Math.max(0,Math.min(2,param2));
         var _loc3_:* = param1 >> 24 & 0xFF;
         var _loc4_:Number = (param1 >> 16 & 0xFF) / 255;
         var _loc5_:Number = (param1 >> 8 & 0xFF) / 255;
         var _loc6_:Number = (param1 & 0xFF) / 255;
         var _loc7_:Number = Math.max(_loc4_,_loc5_,_loc6_);
         var _loc8_:Number = Math.min(_loc4_,_loc5_,_loc6_);
         var _loc9_:Number = _loc7_ - _loc8_;
         var _loc10_:Number = 0;
         var _loc11_:Number = _loc7_ == 0 ? 0 : _loc9_ / _loc7_;
         var _loc12_:Number = _loc7_;
         if(_loc9_ != 0)
         {
            if(_loc7_ == _loc4_)
            {
               _loc10_ = 60 * ((_loc5_ - _loc6_) / _loc9_ % 6);
            }
            else if(_loc7_ == _loc5_)
            {
               _loc10_ = 60 * ((_loc6_ - _loc4_) / _loc9_ + 2);
            }
            else
            {
               _loc10_ = 60 * ((_loc4_ - _loc5_) / _loc9_ + 4);
            }
            if(_loc10_ < 0)
            {
               _loc10_ += 360;
            }
         }
         _loc12_ *= param2;
         _loc12_ = Math.max(0,Math.min(1,_loc12_));
         var _loc13_:Number = _loc12_ * _loc11_;
         var _loc14_:Number = _loc13_ * (1 - Math.abs(_loc10_ / 60 % 2 - 1));
         var _loc15_:Number = _loc12_ - _loc13_;
         var _loc16_:Number = 0;
         var _loc17_:Number = 0;
         var _loc18_:Number = 0;
         if(_loc10_ >= 0 && _loc10_ < 60)
         {
            _loc16_ = _loc13_;
            _loc17_ = _loc14_;
            _loc18_ = 0;
         }
         else if(_loc10_ >= 60 && _loc10_ < 120)
         {
            _loc16_ = _loc14_;
            _loc17_ = _loc13_;
            _loc18_ = 0;
         }
         else if(_loc10_ >= 120 && _loc10_ < 180)
         {
            _loc16_ = 0;
            _loc17_ = _loc13_;
            _loc18_ = _loc14_;
         }
         else if(_loc10_ >= 180 && _loc10_ < 240)
         {
            _loc16_ = 0;
            _loc17_ = _loc14_;
            _loc18_ = _loc13_;
         }
         else if(_loc10_ >= 240 && _loc10_ < 300)
         {
            _loc16_ = _loc14_;
            _loc17_ = 0;
            _loc18_ = _loc13_;
         }
         else
         {
            _loc16_ = _loc13_;
            _loc17_ = 0;
            _loc18_ = _loc14_;
         }
         var _loc19_:Number = Math.round((_loc16_ + _loc15_) * 255);
         var _loc20_:Number = Math.round((_loc17_ + _loc15_) * 255);
         var _loc21_:Number = Math.round((_loc18_ + _loc15_) * 255);
         return _loc3_ << 24 | _loc19_ << 16 | _loc20_ << 8 | _loc21_;
      }
      
      private function startDragSaturationArrow(param1:MouseEvent) : void
      {
         this.saturationArrow.startDrag(false,new Rectangle(this.saturationArrowStartX,this.saturationArrowStartY,this.saturationBounds.width,0));
         m_subMenu.addEventListener(MouseEvent.MOUSE_MOVE,this.updateSaturation);
      }
      
      private function updateSaturation(param1:MouseEvent) : void
      {
         var _loc2_:Number = this.saturationArrow.x - this.saturationBounds.x;
         var _loc3_:Number = _loc2_ / this.saturationBounds.width;
         var _loc4_:Number = _loc3_ * 2;
         _loc4_ = Math.max(0,Math.min(2,_loc4_));
         this.updateShapeColor("saturation",_loc4_);
         TextField(m_subMenu.saturation.lvl_txt).text = _loc4_.toFixed(2);
      }
      
      internal function adjustSaturation(param1:*, param2:Number) : *
      {
         var _loc3_:* = param1 >> 24 & 0xFF;
         var _loc4_:Number = param1 >> 16 & 0xFF;
         var _loc5_:Number = param1 >> 8 & 0xFF;
         var _loc6_:Number = param1 & 0xFF;
         var _loc7_:Number = (_loc4_ + _loc5_ + _loc6_) / 3;
         _loc4_ = _loc7_ + (_loc4_ - _loc7_) * param2;
         _loc5_ = _loc7_ + (_loc5_ - _loc7_) * param2;
         _loc6_ = _loc7_ + (_loc6_ - _loc7_) * param2;
         _loc4_ = Math.min(255,Math.max(0,_loc4_));
         _loc5_ = Math.min(255,Math.max(0,_loc5_));
         _loc6_ = Math.min(255,Math.max(0,_loc6_));
         return _loc3_ << 24 | _loc4_ << 16 | _loc5_ << 8 | _loc6_;
      }
      
      private function startDragAlphaArrow(param1:MouseEvent) : void
      {
         this.alphaArrow.startDrag(false,new Rectangle(this.alphaArrowStartX,this.alphaArrowStartY,this.alphaBounds.width,0));
         m_subMenu.addEventListener(MouseEvent.MOUSE_MOVE,this.updateAlpha);
      }
      
      private function updateAlpha(param1:MouseEvent) : void
      {
         var _loc2_:Number = this.alphaArrow.x - this.alphaBounds.x;
         var _loc3_:Number = _loc2_ / this.alphaBounds.width;
         var _loc4_:Number = _loc3_ * 1;
         _loc4_ = Math.max(0,Math.min(1,_loc4_));
         this.updateShapeColor("alpha",_loc4_);
         TextField(m_subMenu._alpha.lvl_txt).text = _loc4_.toFixed(2);
      }
      
      internal function adjustAlpha(param1:*, param2:Number) : *
      {
         return param2 * 255 << 24 | param1 & 0xFFFFFF;
      }
      
      private function stopDragArrow(param1:MouseEvent) : void
      {
         this.colorArrow.stopDrag();
         this.brightnessArrow.stopDrag();
         this.saturationArrow.stopDrag();
         this.alphaArrow.stopDrag();
         m_subMenu.removeEventListener(MouseEvent.MOUSE_MOVE,this.updateColor);
         m_subMenu.removeEventListener(MouseEvent.MOUSE_MOVE,this.updateBrightness);
         m_subMenu.removeEventListener(MouseEvent.MOUSE_MOVE,this.updateSaturation);
         m_subMenu.removeEventListener(MouseEvent.MOUSE_MOVE,this.updateAlpha);
         if(!this.ENABLE_PIXEL_ART_LIVE_UPDATE)
         {
            Utils.replacePalette(this.PixelArt,this.currentPaletteData.paletteSwapPA,2,true);
         }
      }
      
      private function checkLivePAUpdate() : void
      {
         this.ENABLE_PIXEL_ART_LIVE_UPDATE = ColorSquare.selectedBoxes.length <= this.COLOR_BOX_PA_LIMIT;
      }
      
      private function updateShapeColor(param1:String, param2:Number = 0) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc6_:ColorSquare = null;
         var _loc5_:int = 0;
         while(_loc5_ < ColorSquare.selectedBoxes.length)
         {
            _loc6_ = ColorSquare.selectedBoxes[_loc5_];
            _loc4_ = _loc6_.colorValue;
            if(this.mixedBasePaletteData.indexOf(_loc4_) !== -1)
            {
               if(this.colorArrFactor[_loc5_] == null)
               {
                  this.colorArrFactor[_loc5_] = _loc4_;
               }
               if(this.brightnessArrFactor[_loc5_] == null)
               {
                  this.brightnessArrFactor[_loc5_] = 1;
               }
               if(this.saturationArrFactor[_loc5_] == null)
               {
                  this.saturationArrFactor[_loc5_] = 1;
               }
               if(this.alphaArrFactor[_loc5_] == null)
               {
                  this.alphaArrFactor[_loc5_] = 1;
               }
               switch(param1)
               {
                  case "shiftColor":
                     this.colorArrFactor[_loc5_] = this.adjustColor(_loc4_,param2);
                     break;
                  case "brightness":
                     this.brightnessArrFactor[_loc5_] = param2;
                     break;
                  case "saturation":
                     this.saturationArrFactor[_loc5_] = param2;
                     break;
                  case "alpha":
                     this.alphaArrFactor[_loc5_] = param2;
               }
               _loc3_ = this.colorArrFactor[_loc5_];
               _loc3_ = this.adjustBrightness(_loc3_,this.brightnessArrFactor[_loc5_]);
               _loc3_ = this.adjustSaturation(_loc3_,this.saturationArrFactor[_loc5_]);
               _loc3_ = this.adjustAlpha(_loc3_,this.alphaArrFactor[_loc5_]);
               _loc6_.drawTriangle(_loc3_);
               this.updatePaletteColor(_loc4_,_loc3_);
            }
            _loc5_++;
         }
      }
      
      private function updatePaletteColor(param1:uint, param2:uint) : void
      {
         if(Boolean(param1) && Boolean(param2))
         {
            this.checkLivePAUpdate();
            this.replaceBracket(param1,param2,this.currentPaletteData.paletteSwapPA.colors,this.currentPaletteData.paletteSwapPA.replacements);
            this.replaceBracket(param1,param2,this.currentPaletteData.paletteSwap.colors,this.currentPaletteData.paletteSwap.replacements);
            if(this.ENABLE_PIXEL_ART_LIVE_UPDATE)
            {
               Utils.replacePalette(this.PixelArt,this.currentPaletteData.paletteSwapPA,2,true);
            }
         }
      }
      
      private function makeColorBoxes(param1:Array) : void
      {
         var _loc9_:ColorSquare = null;
         var _loc10_:int = 0;
         var _loc2_:Number = 15;
         var _loc3_:Number = 15;
         var _loc4_:Number = 17;
         var _loc5_:int = 39;
         var _loc6_:Number = 0.9;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         while(_loc8_ < param1.length)
         {
            _loc9_ = new ColorSquare(param1[_loc8_],_loc2_,_loc8_);
            _loc10_ = _loc8_ % _loc5_;
            _loc7_ = Math.floor(_loc8_ / _loc5_);
            _loc9_.x = _loc3_ + _loc10_ * (_loc2_ + _loc6_);
            _loc9_.y = _loc4_ + _loc7_ * (_loc2_ + _loc6_);
            m_subMenu.colorBoxBG.addChild(_loc9_);
            _loc8_++;
         }
         m_subMenu.colorBoxBG.y += _loc7_ * -_loc2_;
      }
      
      private function saveCostume_CLICK(param1:MouseEvent) : void
      {
         if(Boolean(m_subMenu.slotName.text) && m_subMenu.slotName.text !== PaletteMakerUtils.DEFAULT_COSTUME_NAME)
         {
            PaletteMakerUtils.saveCostume(statsName,m_subMenu.slotName.text,this.currentPaletteData);
            SoundQueue.instance.playSoundEffect("menu_select");
         }
      }
      
      private function back_CLICK(param1:MouseEvent) : void
      {
         statsName = null;
         this.player = null;
         this.currentPaletteData = null;
         this.mixedBasePaletteData = null;
         this.colorArrFactor = null;
         this.brightnessArrFactor = null;
         this.saturationArrFactor = null;
         this.alphaArrFactor = null;
         ColorSquare.deselectAll();
         GameController.stageData.endGame();
         MenuController.disposeAllMenus(true);
         MenuController.vaultMenu.show();
         SSF2API.setGlobalVar("allstar_mode_match_count",0);
         SoundQueue.instance.playSoundEffect("menu_back");
         Main.Root.removeEventListener(Event.ENTER_FRAME,this.updateCharacter);
      }
   }
}


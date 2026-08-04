package com.sbxmod.paletteMaker
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.menus.Menu;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.utils.*;
   
   public class CostumeSelectorDisplay extends Menu
   {
      
      public var onCloseMenu:Function = null;
      
      public var onClickContainer:Function = null;
      
      private var m_statsName:String = null;
      
      private var m_pid:int;
      
      private var m_allowDelete:Boolean;
      
      private var currentStockIcon:MovieClip;
      
      private var onDeleteMode:Boolean = false;
      
      private var toDelete:Array = [];
      
      private var buildIndex:int = 0;
      
      private var batchSize:int = 3;
      
      private var start_y:Number;
      
      private var isDragging:Boolean;
      
      private var listLocation:Point = new Point(30,37);
      
      private var scrollTop:Point;
      
      private var scrollHeight:Number = 270;
      
      private var container:MovieClip;
      
      private var containerButton:Vector.<EventButton>;
      
      private var allCostumes:Array;
      
      private var selectedCostume:int;
      
      private var blurOverlay:Bitmap;
      
      private var animating:Boolean = false;
      
      public function CostumeSelectorDisplay()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("costumeSubMenu_r2");
         m_container.addChild(m_subMenu);
         m_fillBackground = false;
         this.scrollTop = new Point(m_subMenu.scrollbarMC.x,m_subMenu.scrollbarMC.y);
      }
      
      override public function show() : void
      {
         super.show();
         if(this.m_statsName)
         {
            this.showWarningMessage(null);
            this.preDeleteMode(false);
            PaletteMakerUtils.fadeIn(m_subMenu,80);
            this.toggleBlurBackground(true);
         }
         else
         {
            removeSelf();
         }
      }
      
      override public function makeEvents() : void
      {
         super.makeEvents();
         m_subMenu.scrollbarMC.addEventListener(MouseEvent.MOUSE_DOWN,this.startDragBar);
         m_subMenu.stage.addEventListener(MouseEvent.MOUSE_UP,this.stopDragBar);
         m_subMenu.addEventListener(MouseEvent.MOUSE_MOVE,this.moveDragBar);
         m_subMenu.close_btn.addEventListener(MouseEvent.CLICK,this.closeMenu);
         m_subMenu.refresh_btn.addEventListener(MouseEvent.CLICK,this.refresh_CLICK);
         m_subMenu.delete_btn.addEventListener(MouseEvent.CLICK,this.deleteMode_CLICK);
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.scrollbarMC.removeEventListener(MouseEvent.MOUSE_DOWN,this.startDragBar);
         m_subMenu.removeEventListener(MouseEvent.MOUSE_UP,this.stopDragBar);
         m_subMenu.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveDragBar);
         m_subMenu.refresh_btn.removeEventListener(MouseEvent.CLICK,this.refresh_CLICK);
         m_subMenu.delete_btn.removeEventListener(MouseEvent.CLICK,this.deleteMode_CLICK);
         m_subMenu.removeEventListener(Event.ENTER_FRAME,this.buildStep);
         this.onCloseMenu = null;
         this.onClickContainer = null;
      }
      
      public function setCharacter(param1:String, param2:int, param3:Boolean = false) : void
      {
         if(PaletteMakerUtils.isCharRegistered(param1))
         {
            this.m_statsName = param1;
            this.m_pid = param2;
            this.m_allowDelete = param3;
            this.startCreatingContainers();
            this.show();
         }
         else
         {
            trace("[Palette Maker]",param1,"is not registered!");
         }
      }
      
      private function startCreatingContainers() : void
      {
         this.currentStockIcon = PaletteMakerUtils.getStockIcon(this.m_statsName,true);
         this.allCostumes = ResourceManager.getAllCostumes(this.m_statsName,null,true);
         this.selectedCostume = 0;
         this.container = new MovieClip();
         this.container.x = 48;
         this.container.y = 37;
         this.containerButton = new Vector.<EventButton>();
         m_subMenu.addChild(this.container);
         this.container.mask = m_subMenu.masker;
         this.updateNameplate();
         MovieClip(m_subMenu.delete_btn).visible = this.m_allowDelete;
         this.buildIndex = 0;
         m_subMenu.addEventListener(Event.ENTER_FRAME,this.buildStep);
      }
      
      private function buildStep(param1:Event) : void
      {
         var _loc2_:int = int(this.batchSize);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_ && this.buildIndex < this.allCostumes.length)
         {
            this.createCostumeButton(this.buildIndex);
            ++this.buildIndex;
            _loc3_++;
         }
         if(this.buildIndex >= this.allCostumes.length)
         {
            m_subMenu.removeEventListener(Event.ENTER_FRAME,this.buildStep);
         }
      }
      
      private function createCostumeButton(param1:int) : void
      {
         var _loc2_:EventButton = new EventButton(ResourceManager.getLibraryMC("costume_selector_fla.container"));
         var _loc3_:uint = Boolean(this.allCostumes[param1].paletteSwapPA) && Boolean(this.allCostumes[param1].paletteSwapPA.replacements) ? uint(PaletteMakerUtils.pickBestColor(this.allCostumes[param1].paletteSwapPA.replacements)) : 2304649;
         var _loc4_:String = Boolean(this.allCostumes[param1]) && Boolean(this.allCostumes[param1].hasOwnProperty("profile")) ? this.allCostumes[param1].profile : PaletteMakerUtils.DEFAULT_COSTUME_NAME;
         this.containerButton.push(_loc2_);
         this.container.addChild(_loc2_.ButtonInstance);
         PaletteMakerUtils.fadeIn(_loc2_.ButtonInstance,200);
         _loc2_.ButtonInstance.x = param1 % 7 * 82;
         _loc2_.ButtonInstance.y = int(param1 / 7) * 111.7;
         _loc2_.ButtonInstance.addEventListener(MouseEvent.MOUSE_OVER,this.containerButton_OVER);
         _loc2_.ButtonInstance.addEventListener(MouseEvent.CLICK,this.containerButton_CLICK);
         var _loc5_:MovieClip = PaletteMakerUtils.getPixelArt(this.m_statsName);
         if(_loc5_)
         {
            MovieClip(_loc2_.ButtonInstance.getChildByName("ph")).addChild(_loc5_);
            _loc5_.gotoAndStop(10);
            Utils.setColorFilterCharacter(_loc5_,-1,this.m_statsName,param1 - 1,true);
         }
         var _loc6_:MovieClip = PaletteMakerUtils.getStockIcon(this.m_statsName);
         if(_loc6_)
         {
            MovieClip(_loc2_.ButtonInstance.getChildByName("ph2")).addChild(_loc6_);
            Utils.setColorFilterCharacter(_loc6_,-1,this.m_statsName,param1 - 1,false);
         }
         _loc2_.ButtonInstance.costumeName_txt.text = _loc4_;
         Utils.fitText(_loc2_.ButtonInstance.costumeName_txt,9,1);
         if(_loc2_.ButtonInstance.costumeName_txt.text == PaletteMakerUtils.DEFAULT_COSTUME_NAME)
         {
            _loc2_.ButtonInstance.costumeName_txt.textColor = 4868682;
         }
         PaletteMakerUtils.setTint(_loc2_.ButtonInstance.bg.tintedFrontLayout,_loc3_);
         PaletteMakerUtils.setTint(_loc2_.ButtonInstance.bg.tintedBG,_loc3_);
      }
      
      private function containerButton_OVER(param1:MouseEvent) : void
      {
         var _loc2_:int = int(this.findEvent(param1.target as MovieClip));
         if(_loc2_ >= 0 && _loc2_ < this.allCostumes.length)
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            this.selectedCostume = _loc2_;
         }
      }
      
      private function containerButton_CLICK(param1:MouseEvent) : void
      {
         var _loc3_:EventButton = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc2_:int = int(this.findEvent(param1.currentTarget as MovieClip));
         if(_loc2_ >= 0)
         {
            this.selectedCostume = _loc2_;
         }
         if(this.onDeleteMode)
         {
            _loc3_ = this.containerButton[this.selectedCostume];
            _loc4_ = Boolean(this.allCostumes[this.selectedCostume]) && Boolean(this.allCostumes[this.selectedCostume].hasOwnProperty("profile")) ? this.allCostumes[this.selectedCostume].profile : PaletteMakerUtils.DEFAULT_COSTUME_NAME;
            if(_loc4_ !== PaletteMakerUtils.DEFAULT_COSTUME_NAME)
            {
               _loc5_ = int(this.toDelete.indexOf(_loc4_));
               if(_loc5_ == -1)
               {
                  this.toDelete.push(_loc4_);
                  _loc3_.ButtonInstance.alpha = 0.4;
                  SoundQueue.instance.playSoundEffect("menu_select");
               }
               else
               {
                  this.toDelete.splice(_loc5_,1);
                  _loc3_.ButtonInstance.alpha = 1;
                  SoundQueue.instance.playSoundEffect("menu_back");
               }
            }
            return;
         }
         if(this.onClickContainer != null)
         {
            this.onClickContainer();
         }
      }
      
      private function refresh_CLICK(param1:MouseEvent) : void
      {
         this.preDeleteMode(false);
         PaletteMakerUtils.loadCostumeFile(this.m_statsName,{
            "onComplete":this.onCompleteAfterRefresh,
            "onError":this.errorAfterRefresh,
            "onParseError":this.parseErrAfterRefresh
         });
      }
      
      private function deleteMode_CLICK(param1:MouseEvent) : void
      {
         if(this.m_allowDelete)
         {
            if(this.toDelete.length > 0 && Boolean(this.onDeleteMode))
            {
               MenuController.onlinePromptMenu.message = "You will delete " + this.toDelete.length + " costume(s)... \n Are you sure?";
               MenuController.onlinePromptMenu.onAccept = this.execeuteOrder66;
               MenuController.onlinePromptMenu.onDismiss = this.cancelBatchDelete;
               MenuController.onlinePromptMenu.show();
               return;
            }
            if(this.onDeleteMode)
            {
               this.preDeleteMode(false);
               SoundQueue.instance.playSoundEffect("menu_back");
            }
            else
            {
               this.preDeleteMode(true);
               SoundQueue.instance.playSoundEffect("menu_select");
            }
         }
      }
      
      private function preDeleteMode(param1:Boolean) : *
      {
         MovieClip(m_subMenu.delete_btn.activated).visible = param1;
         this.onDeleteMode = param1;
         this.toDelete = [];
      }
      
      private function execeuteOrder66() : void
      {
         PaletteMakerUtils.deleteCostumes(this.m_statsName,this.toDelete);
         this.preDeleteMode(false);
         this.refresh_CLICK(null);
         MenuController.onlinePromptMenu.removeSelf();
      }
      
      private function cancelBatchDelete() : void
      {
         var _loc2_:EventButton = null;
         this.preDeleteMode(false);
         MenuController.onlinePromptMenu.removeSelf();
         var _loc1_:int = 0;
         while(_loc1_ < this.containerButton.length)
         {
            _loc2_ = this.containerButton[_loc1_];
            _loc2_.ButtonInstance.alpha = 1;
            _loc1_++;
         }
      }
      
      private function onCompleteAfterRefresh() : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.reset();
      }
      
      private function errorAfterRefresh() : void
      {
         SoundQueue.instance.playSoundEffect("menu_error");
         this.reset();
         this.showWarningMessage("File Error");
      }
      
      private function parseErrAfterRefresh() : void
      {
         SoundQueue.instance.playSoundEffect("menu_error");
         this.reset();
         this.showWarningMessage("Parse Error");
      }
      
      private function reset() : void
      {
         MovieClip(m_subMenu.nameplate.stockMain).removeChild(this.currentStockIcon);
         this.removeAllContainers();
         this.startCreatingContainers();
         this.restoreScrollbarPos();
         this.showWarningMessage(null);
      }
      
      private function reset2() : void
      {
         this.removeAllContainers();
         this.startCreatingContainers();
         this.restoreScrollbarPos();
      }
      
      private function removeAllContainers() : void
      {
         var _loc2_:EventButton = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.containerButton.length)
         {
            _loc2_ = this.containerButton[_loc1_];
            _loc2_.ButtonInstance.removeEventListener(MouseEvent.MOUSE_OVER,this.containerButton_OVER);
            _loc2_.ButtonInstance.removeEventListener(MouseEvent.CLICK,this.containerButton_CLICK);
            if(_loc2_.ButtonInstance.parent != null)
            {
               _loc2_.ButtonInstance.parent.removeChild(_loc2_.ButtonInstance);
            }
            _loc1_++;
         }
         this.containerButton = null;
      }
      
      private function closeMenu(param1:MouseEvent) : *
      {
         if(this.onCloseMenu != null)
         {
            this.onCloseMenu();
         }
         this.restoreScrollbarPos();
         this.cancelBatchDelete();
         this.toggleBlurBackground(false);
         MovieClip(m_subMenu.nameplate.stockMain).removeChild(this.currentStockIcon);
         this.removeAllContainers();
         removeSelf();
      }
      
      private function restoreScrollbarPos() : void
      {
         m_subMenu.scrollbarMC.y = 38;
      }
      
      private function startDragBar(param1:MouseEvent) : void
      {
         if(!this.isDragging)
         {
            this.isDragging = true;
            m_subMenu.scrollbarMC.startDrag(false,new Rectangle(this.scrollTop.x,this.scrollTop.y,0,this.scrollHeight));
         }
      }
      
      private function moveDragBar(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(this.isDragging)
         {
            _loc2_ = (m_subMenu.scrollbarMC.y - this.scrollTop.y) / this.scrollHeight;
            _loc3_ = 27.6;
            _loc4_ = _loc3_ * Math.max(0,this.allCostumes.length);
            _loc2_ = Math.max(0,Math.min(1,_loc2_));
            this.container.y = this.listLocation.y - _loc2_ * _loc4_;
         }
      }
      
      private function stopDragBar(param1:MouseEvent) : void
      {
         if(this.isDragging)
         {
            this.isDragging = false;
            m_subMenu.scrollbarMC.stopDrag();
         }
      }
      
      private function findEvent(param1:MovieClip) : int
      {
         var _loc2_:int = 0;
         if(Boolean(param1) && !param1.visible)
         {
            return -1;
         }
         while(_loc2_ < this.containerButton.length)
         {
            if(this.containerButton[_loc2_].ButtonInstance == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      private function toggleBlurBackground(param1:Boolean) : void
      {
         var _loc2_:MovieClip = null;
         if(param1)
         {
            _loc2_ = MenuController.costumeSelectorDisplay.SubMenu.blur;
            if(Boolean(this.blurOverlay) && Boolean(this.blurOverlay.parent))
            {
               return;
            }
            this.blurOverlay = new Bitmap(Utils.getSnapshot(Main.Root));
            this.blurOverlay.x = Main.Root.x;
            this.blurOverlay.y = Main.Root.y;
            _loc2_.addChild(this.blurOverlay);
            this.animateBlur(this.blurOverlay,true);
         }
         else if(Boolean(this.blurOverlay) && Boolean(this.blurOverlay.parent))
         {
            this.animateBlur(this.blurOverlay,false);
         }
      }
      
      private function animateBlur(param1:Bitmap, param2:Boolean) : void
      {
         var startTime:int = 0;
         var duration:int = 0;
         var onEnterFrame:* = undefined;
         var targetBmp:Bitmap = param1;
         var apply:Boolean = param2;
         onEnterFrame = function(param1:Event):void
         {
            var _loc2_:int = getTimer() - startTime;
            var _loc3_:Number = Math.min(_loc2_ / duration,1);
            if(!apply)
            {
               _loc3_ = 1 - _loc3_;
            }
            var _loc4_:Number = 4;
            var _loc5_:Number = _loc4_ * _loc3_;
            targetBmp.filters = [new BlurFilter(_loc5_,_loc5_,1)];
            if(_loc2_ >= duration)
            {
               targetBmp.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
               animating = false;
               if(!apply)
               {
                  if(targetBmp.parent)
                  {
                     targetBmp.parent.removeChild(targetBmp);
                  }
                  blurOverlay = null;
               }
            }
         };
         startTime = int(getTimer());
         duration = 100;
         this.animating = true;
         targetBmp.addEventListener(Event.ENTER_FRAME,onEnterFrame);
      }
      
      private function updateNameplate() : void
      {
         MovieClip(m_subMenu.nameplate.stockMain).addChild(this.currentStockIcon);
         m_subMenu.nameplate.counter_txt.text = this.allCostumes.length;
         m_subMenu.nameplate.title_txt.text = Stats.getStats(this.m_statsName).DisplayName;
      }
      
      private function showWarningMessage(param1:String) : *
      {
         if(param1)
         {
            MovieClip(m_subMenu.warningplate).visible = true;
            m_subMenu.warningplate.reason_txt.text = param1;
         }
         else
         {
            MovieClip(m_subMenu.warningplate).visible = false;
         }
      }
      
      public function getPID() : int
      {
         return this.m_pid;
      }
      
      public function getSelectedCostume() : int
      {
         return this.selectedCostume - 1;
      }
      
      public function getCostumesNumber() : int
      {
         return this.allCostumes.length;
      }
      
      public function forceRefresh() : void
      {
         PaletteMakerUtils.loadCostumeFile(this.m_statsName,{"onComplete":this.reset2});
      }
   }
}


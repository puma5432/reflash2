package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   
   public class StageSwitchMenu extends Menu
   {
      
      private var selectHand:StageSwitchHand;
      
      private var stageButtonsMaster:Vector.<StageSwitchButton>;
      
      private var stageButtonsNormal:Vector.<StageSwitchButton>;
      
      private var stageButtonsPast:Vector.<StageSwitchButton>;
      
      private var lastClickedNormal:StageSwitchButton;
      
      private var lastClickedPast:StageSwitchButton;
      
      protected var normalTable:DisplayObjectTable;
      
      protected var pastTable:DisplayObjectTable;
      
      protected var m_stageMCHash:Object;
      
      public function StageSwitchMenu()
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_stageswitch");
         m_backgroundID = "space";
         this.stageButtonsMaster = new Vector.<StageSwitchButton>();
         this.stageButtonsNormal = new Vector.<StageSwitchButton>();
         this.stageButtonsPast = new Vector.<StageSwitchButton>();
         this.lastClickedNormal = null;
         this.lastClickedPast = null;
         var _loc4_:Object = ResourceManager.getResourceByID("mappings").getProp("metadata");
         var _loc5_:Object = _loc4_.stage_switch_screen.normal;
         var _loc6_:Object = _loc4_.stage_switch_screen.past;
         var _loc7_:Array = _loc4_.random_stages.stages;
         var _loc8_:Array = ["normal","past"];
         this.m_stageMCHash = {};
         _loc1_ = 0;
         while(_loc1_ < this.StageSwitchIconsMC.numChildren)
         {
            if(this.StageSwitchIconsMC.getChildAt(_loc1_) is MovieClip)
            {
               _loc3_ = MovieClip(this.StageSwitchIconsMC.getChildAt(_loc1_));
               _loc3_.parent.removeChild(_loc3_);
               _loc1_--;
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < _loc7_.length)
         {
            if(_loc4_.stage[_loc7_[_loc1_]])
            {
               _loc3_ = MovieClip(ResourceManager.getLibraryMC(_loc7_[_loc1_] + "_switch"));
               _loc3_.gotoAndStop(1);
               _loc3_.stageID = _loc3_.stageID || _loc7_[_loc1_];
               if(_loc8_.indexOf(_loc3_.stageType) >= 0)
               {
                  this.m_stageMCHash[_loc3_.stageID] = _loc3_;
                  this.StageSwitchIconsMC.addChild(_loc3_);
                  this.stageButtonsMaster.push(new StageSwitchButton(this.m_stageMCHash[_loc3_.stageID],_loc3_.stageID));
                  if(_loc3_.stageType === "normal")
                  {
                     this.stageButtonsNormal.push(new StageSwitchButton(this.m_stageMCHash[_loc3_.stageID],_loc3_.stageID));
                  }
                  else if(_loc3_.stageType === "past")
                  {
                     this.stageButtonsPast.push(new StageSwitchButton(this.m_stageMCHash[_loc3_.stageID],_loc3_.stageID));
                  }
               }
            }
            _loc1_++;
         }
         this.normalTable = new DisplayObjectTable(new Rectangle(_loc5_.position.x,_loc5_.position.y,_loc5_.icon_size.width,_loc5_.icon_size.height));
         this.pastTable = new DisplayObjectTable(new Rectangle(_loc6_.position.x,_loc6_.position.y,_loc6_.icon_size.width,_loc6_.icon_size.height));
         _loc1_ = 0;
         while(_loc1_ < _loc5_.rows.length)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc5_.rows[_loc1_].length)
            {
               this.normalTable.insertObject(_loc1_,this.m_stageMCHash[_loc5_.rows[_loc1_][_loc2_]]);
               _loc2_++;
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < _loc6_.rows.length)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc6_.rows[_loc1_].length)
            {
               this.pastTable.insertObject(_loc1_,this.m_stageMCHash[_loc6_.rows[_loc1_][_loc2_]]);
               _loc2_++;
            }
            _loc1_++;
         }
         this.updateStages();
         this.checkAllBtn();
         this.selectHand = new StageSwitchHand(m_subMenu,this.stageButtonsMaster,this.back_CLICK);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.allNormal_btn);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.allPast_btn);
         this.selectHand.addClickEventClipHitTest(m_subMenu.bg_top.back_btn);
         this.selectHand.addClickEventClipHitTest(m_subMenu.bg_top.home_btn);
         m_container.addChild(m_subMenu);
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
      }
      
      public function get StageSwitchIconsMC() : MovieClip
      {
         return m_subMenu.stageButtons;
      }
      
      override public function makeEvents() : void
      {
         var _loc1_:int = 0;
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         this.selectHand.makeEvents();
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_ROLL_OVER);
         m_subMenu.allNormal_btn.addEventListener(MouseEvent.CLICK,this.allNormal_CLICK);
         m_subMenu.allNormal_btn.addEventListener(MouseEvent.MOUSE_OVER,this.allNormal_MOUSE_OVER);
         m_subMenu.allPast_btn.addEventListener(MouseEvent.CLICK,this.allPast_CLICK);
         m_subMenu.allPast_btn.addEventListener(MouseEvent.MOUSE_OVER,this.allPast_MOUSE_OVER);
         m_subMenu.bg_top.home_btn.addEventListener(MouseEvent.CLICK,this.home_CLICK);
         _loc1_ = 0;
         while(_loc1_ < this.stageButtonsNormal.length)
         {
            this.stageButtonsNormal[_loc1_].setClickFunc(this.checkAllBtn);
            this.stageButtonsNormal[_loc1_].makeEvents();
            if(this.lastClickedNormal == null && Boolean(this.stageButtonsNormal[_loc1_].getStatus()) && Boolean(this.stageButtonsNormal[_loc1_].ButtonInstance.visible))
            {
               this.lastClickedNormal = this.stageButtonsNormal[_loc1_];
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.stageButtonsPast.length)
         {
            this.stageButtonsPast[_loc1_].makeEvents();
            this.stageButtonsPast[_loc1_].setClickFunc(this.checkAllBtn);
            if(this.lastClickedPast == null && Boolean(this.stageButtonsPast[_loc1_].getStatus()) && Boolean(this.stageButtonsPast[_loc1_].ButtonInstance.visible))
            {
               this.lastClickedPast = this.stageButtonsPast[_loc1_];
            }
            _loc1_++;
         }
      }
      
      override public function killEvents() : void
      {
         var _loc1_:int = 0;
         super.killEvents();
         this.selectHand.killEvents();
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_ROLL_OVER);
         m_subMenu.allNormal_btn.removeEventListener(MouseEvent.CLICK,this.allNormal_CLICK);
         m_subMenu.allNormal_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.allNormal_MOUSE_OVER);
         m_subMenu.allPast_btn.removeEventListener(MouseEvent.CLICK,this.allPast_CLICK);
         m_subMenu.allPast_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.allPast_MOUSE_OVER);
         m_subMenu.bg_top.home_btn.removeEventListener(MouseEvent.CLICK,this.home_CLICK);
         _loc1_ = 0;
         while(_loc1_ < this.stageButtonsNormal.length)
         {
            this.stageButtonsNormal[_loc1_].killEvents();
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.stageButtonsPast.length)
         {
            this.stageButtonsPast[_loc1_].killEvents();
            _loc1_++;
         }
      }
      
      override public function show() : void
      {
         var _loc1_:* = undefined;
         if(!Main.DEBUG)
         {
            for(_loc1_ in this.m_stageMCHash)
            {
               if(SaveData.Unlocks[_loc1_] === false)
               {
                  this.m_stageMCHash[_loc1_].visible = false;
               }
            }
         }
         this.pastTable.spaceObjects();
         this.normalTable.spaceObjects();
         this.checkAllBtn();
         super.show();
      }
      
      private function back_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_back");
         removeSelf();
      }
      
      private function back_ROLL_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function updateStages() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.stageButtonsNormal.length)
         {
            this.stageButtonsNormal[_loc1_].ButtonInstance.gotoAndStop(SaveData.getStageStatus(this.stageButtonsNormal[_loc1_].ID) ? "on" : "off");
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.stageButtonsPast.length)
         {
            this.stageButtonsPast[_loc1_].ButtonInstance.gotoAndStop(SaveData.getStageStatus(this.stageButtonsPast[_loc1_].ID) ? "on" : "off");
            _loc1_++;
         }
      }
      
      private function allNormal_CLICK(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         SoundQueue.instance.playSoundEffect("menu_select");
         var _loc4_:Boolean = m_subMenu.allNormal_btn.currentFrameLabel == "on";
         m_subMenu.allNormal_btn.gotoAndStop(_loc4_ ? "off" : "on");
         _loc2_ = 0;
         while(_loc2_ < this.stageButtonsNormal.length)
         {
            if(this.stageButtonsNormal[_loc2_].ButtonInstance.visible)
            {
               this.stageButtonsNormal[_loc2_].setStatus(_loc4_);
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.stageButtonsPast.length)
         {
            if(Boolean(this.stageButtonsPast[_loc2_].ButtonInstance.visible) && Boolean(this.stageButtonsPast[_loc2_].getStatus()))
            {
               _loc3_++;
            }
            _loc2_++;
         }
         if(_loc3_ == 0)
         {
            if(!this.lastClickedNormal)
            {
               this.lastClickedNormal = this.stageButtonsNormal[0];
               this.lastClickedNormal.setStatus(true);
            }
            else
            {
               this.lastClickedNormal.setStatus(true);
            }
         }
      }
      
      private function allNormal_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function allPast_CLICK(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         SoundQueue.instance.playSoundEffect("menu_select");
         var _loc4_:Boolean = m_subMenu.allPast_btn.currentFrameLabel == "on";
         m_subMenu.allPast_btn.gotoAndStop(_loc4_ ? "off" : "on");
         _loc2_ = 0;
         while(_loc2_ < this.stageButtonsPast.length)
         {
            if(this.stageButtonsPast[_loc2_].ButtonInstance.visible)
            {
               this.stageButtonsPast[_loc2_].setStatus(_loc4_);
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.stageButtonsNormal.length)
         {
            if(Boolean(this.stageButtonsNormal[_loc2_].ButtonInstance.visible) && Boolean(this.stageButtonsNormal[_loc2_].getStatus()))
            {
               _loc3_++;
            }
            _loc2_++;
         }
         if(_loc3_ == 0)
         {
            if(!this.lastClickedPast)
            {
               this.lastClickedPast = this.stageButtonsPast[1];
               this.lastClickedPast.setStatus(true);
            }
            else
            {
               this.lastClickedPast.setStatus(true);
            }
         }
      }
      
      private function allPast_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function checkAllBtn(param1:StageSwitchButton = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(this.stageButtonsNormal.indexOf(param1) >= 0)
         {
            _loc7_ = 0;
            this.lastClickedNormal = param1;
         }
         else if(this.stageButtonsPast.indexOf(param1) >= 0)
         {
            _loc7_ = 1;
            this.lastClickedPast = param1;
         }
         _loc2_ = 0;
         while(_loc2_ < this.stageButtonsNormal.length)
         {
            if(Boolean(this.stageButtonsNormal[_loc2_].ButtonInstance.visible) && Boolean(this.stageButtonsNormal[_loc2_].getStatus()))
            {
               _loc3_++;
            }
            else if(!this.stageButtonsNormal[_loc2_].ButtonInstance.visible)
            {
               _loc5_++;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.stageButtonsPast.length)
         {
            if(Boolean(this.stageButtonsPast[_loc2_].ButtonInstance.visible) && Boolean(this.stageButtonsPast[_loc2_].getStatus()))
            {
               _loc4_++;
            }
            else if(!this.stageButtonsPast[_loc2_].ButtonInstance.visible)
            {
               _loc6_++;
            }
            _loc2_++;
         }
         if(_loc7_ == 0)
         {
            m_subMenu.allNormal_btn.gotoAndStop(_loc3_ == this.stageButtonsNormal.length - _loc5_ ? "off" : "on");
            if(_loc3_ == 0 && _loc4_ == 0 && Boolean(this.lastClickedNormal))
            {
               this.lastClickedNormal.setStatus(true);
            }
         }
         if(_loc7_ == 1)
         {
            m_subMenu.allPast_btn.gotoAndStop(_loc4_ == this.stageButtonsPast.length - _loc6_ ? "off" : "on");
            if(_loc3_ == 0 && _loc4_ == 0 && Boolean(this.lastClickedPast))
            {
               this.lastClickedPast.setStatus(true);
            }
         }
      }
      
      private function home_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_back");
         SoundQueue.instance.stopMusic();
         if(MenuController.CurrentCharacterSelectMenu)
         {
            MenuController.CurrentCharacterSelectMenu.resetScreen();
         }
         GameController.currentGame = null;
         MenuController.removeAllMenus();
         MenuController.titleMenu.show();
      }
   }
}


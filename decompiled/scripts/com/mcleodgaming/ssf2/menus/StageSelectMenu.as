package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.net.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   
   public class StageSelectMenu extends Menu
   {
      
      private var m_currentGame:Game;
      
      private var stageButtons:Vector.<StageButton>;
      
      private var previewer:MovieClip;
      
      private var selectHand:StageSelectHand;
      
      protected var normalStageTable:DisplayObjectTable;
      
      protected var pastStageTable:DisplayObjectTable;
      
      protected var m_stageMCHash:Object;
      
      private var m_normal_btn:MovieClip;
      
      private var m_past_btn:MovieClip;
      
      private var m_unlockable_btn:MovieClip;
      
      private var m_other_btn:MovieClip;
      
      public function StageSelectMenu()
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc8_:StageButton = null;
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_stageselect");
         m_backgroundID = "space";
         this.stageButtons = new Vector.<StageButton>();
         this.previewer = MovieClip(m_subMenu.stage_sample.previewer.addChild(ResourceManager.getLibraryMC("stagePreviewer")));
         this.previewer.name = "mc";
         var _loc4_:Object = ResourceManager.getResourceByID("mappings").getProp("metadata");
         var _loc5_:Object = _loc4_.stage_select_screen.normal;
         var _loc6_:Object = _loc4_.stage_select_screen.past;
         var _loc7_:Array = Utils.union(Utils.flatten(Utils.flatten(_loc5_.rows as Array).concat(Utils.flatten(_loc6_.rows as Array))));
         this.m_stageMCHash = {};
         _loc1_ = 0;
         while(_loc1_ < this.StageSelectionIconsMC.numChildren)
         {
            if(this.StageSelectionIconsMC.getChildAt(_loc1_) is MovieClip)
            {
               _loc3_ = MovieClip(this.StageSelectionIconsMC.getChildAt(_loc1_));
               _loc3_.parent.removeChild(_loc3_);
               _loc1_--;
            }
            _loc1_++;
         }
         m_subMenu.sxp.gotoAndStop(1);
         this.m_stageMCHash["xpstage"] = m_subMenu.sxp;
         this.StageSelectionIconsMC.addChild(m_subMenu.sxp);
         this.stageButtons.push(new StageButton(GameController.currentGame,m_subMenu.sxp,m_subMenu.sxp.stageID));
         _loc1_ = 0;
         while(_loc1_ < _loc7_.length)
         {
            if(Boolean(_loc4_.stage[_loc7_[_loc1_]]) || Boolean(_loc7_[_loc1_] === "xpstage") || _loc7_[_loc1_] === "random")
            {
               _loc3_ = MovieClip(ResourceManager.getLibraryMC(_loc7_[_loc1_] + "_stage_select"));
               _loc3_.gotoAndStop(1);
               _loc3_.stageID = _loc3_.stageID || _loc7_[_loc1_];
               this.m_stageMCHash[_loc3_.stageID] = _loc3_;
               this.StageSelectionIconsMC.addChild(_loc3_);
               this.stageButtons.push(new StageButton(GameController.currentGame,_loc3_,_loc3_.stageID));
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < m_subMenu.numChildren)
         {
            if(m_subMenu.getChildAt(_loc1_) is MovieClip)
            {
               _loc3_ = MovieClip(m_subMenu.getChildAt(_loc1_));
               if(_loc3_.name === "normal_btn" || _loc3_.name === "past_btn")
               {
                  this.m_stageMCHash[_loc3_.name] = _loc3_;
               }
            }
            _loc1_++;
         }
         this.selectHand = new StageSelectHand(m_subMenu,this.stageButtons,this.backCharSelect_CLICK);
         for each(_loc8_ in this.stageButtons)
         {
            _loc8_.setSelectHand(this.selectHand);
         }
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.normal_btn);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.past_btn);
         this.selectHand.addClickEventClipHitTest(m_subMenu.bg_top.back_btn);
         this.selectHand.addClickEventClipHitTest(m_subMenu.hazardsbut);
         this.normalStageTable = new DisplayObjectTable(new Rectangle(_loc5_.position.x,_loc5_.position.y,_loc5_.icon_size.width,_loc5_.icon_size.height));
         this.pastStageTable = new DisplayObjectTable(new Rectangle(_loc4_.stage_select_screen.past.position.x,_loc4_.stage_select_screen.past.position.y,_loc4_.stage_select_screen.past.icon_size.width,_loc4_.stage_select_screen.past.icon_size.height));
         _loc1_ = 0;
         while(_loc1_ < _loc5_.rows.length)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc5_.rows[_loc1_].length)
            {
               this.normalStageTable.insertObject(_loc1_,this.m_stageMCHash[_loc5_.rows[_loc1_][_loc2_]]);
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
               this.pastStageTable.insertObject(_loc1_,this.m_stageMCHash[_loc6_.rows[_loc1_][_loc2_]]);
               _loc2_++;
            }
            _loc1_++;
         }
         this.m_normal_btn = m_subMenu.normal_btn;
         this.m_past_btn = m_subMenu.past_btn;
         this.m_unlockable_btn = m_subMenu.unlockable_btn;
         this.m_other_btn = m_subMenu.other_btn;
         this.m_normal_btn.visible = false;
         this.m_past_btn.visible = false;
         this.m_unlockable_btn.visible = false;
         this.m_other_btn.visible = false;
         this.m_normal_btn.gotoAndStop("on");
         this.m_past_btn.gotoAndStop("off");
         this.m_unlockable_btn.gotoAndStop("off");
         this.m_other_btn.gotoAndStop("off");
         m_container.addChild(m_subMenu);
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         this.m_stageMCHash["xpstage"].visible = false;
         this.pastStageTable.hideAll();
         this.normalStageTable.showAll();
      }
      
      override public function manageMenuMappings(param1:Event) : void
      {
         super.manageMenuMappings(param1);
         if(m_lastControllerIndex >= 0)
         {
            this.selectHand.lastControllerIndex = m_lastControllerIndex;
         }
      }
      
      public function get StageSelectionIconsMC() : MovieClip
      {
         return m_subMenu.stageSelect;
      }
      
      override public function makeEvents() : void
      {
         var _loc1_:int = 0;
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
            findSpecificMenuButtons(m_subMenu);
         }
         super.makeEvents();
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.backCharSelect_CLICK);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.MOUSE_OVER,this.backCharSelect_OVER);
         m_subMenu.hazardsbut.addEventListener(MouseEvent.CLICK,this.hazards_CLICK);
         this.m_normal_btn.addEventListener(MouseEvent.CLICK,this.showNormalStages);
         this.m_past_btn.addEventListener(MouseEvent.CLICK,this.showPastStages);
         this.m_other_btn.addEventListener(MouseEvent.CLICK,this.showOtherStages);
         this.selectHand.makeEvents();
         while(_loc1_ < this.stageButtons.length)
         {
            this.stageButtons[_loc1_].makeEvents();
            _loc1_++;
         }
         this.updateFields();
      }
      
      override public function killEvents() : void
      {
         var _loc1_:int = 0;
         super.killEvents();
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.backCharSelect_CLICK);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.backCharSelect_OVER);
         m_subMenu.hazardsbut.removeEventListener(MouseEvent.CLICK,this.hazards_CLICK);
         this.m_normal_btn.removeEventListener(MouseEvent.CLICK,this.showNormalStages);
         this.m_past_btn.removeEventListener(MouseEvent.CLICK,this.showPastStages);
         this.m_other_btn.removeEventListener(MouseEvent.CLICK,this.showOtherStages);
         this.selectHand.killEvents();
         while(_loc1_ < this.stageButtons.length)
         {
            this.stageButtons[_loc1_].killEvents();
            _loc1_++;
         }
      }
      
      private function updateFields() : void
      {
         if(!SaveData.Hazards)
         {
            m_subMenu.hazardsbut.gotoAndStop("off");
         }
         else
         {
            m_subMenu.hazardsbut.gotoAndStop("on");
         }
      }
      
      public function setCurrentGame(param1:Game) : void
      {
         var _loc2_:int = 0;
         this.m_currentGame = param1;
         while(_loc2_ < this.stageButtons.length)
         {
            this.stageButtons[_loc2_].setCurrentGame(param1);
            _loc2_++;
         }
      }
      
      private function showNormalStages(param1:MouseEvent) : void
      {
      }
      
      private function showPastStages(param1:MouseEvent) : void
      {
      }
      
      private function showUnlockableStages(param1:MouseEvent) : void
      {
      }
      
      private function showOtherStages(param1:MouseEvent) : void
      {
      }
      
      private function resetAll() : void
      {
         this.normalStageTable.hideAll();
         this.pastStageTable.hideAll();
         this.m_normal_btn.gotoAndStop("off");
         this.m_past_btn.gotoAndStop("off");
         this.m_unlockable_btn.gotoAndStop("off");
         this.m_other_btn.gotoAndStop("off");
      }
      
      private function updateIcons() : void
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
         else
         {
            this.m_stageMCHash["xpstage"].visible = ResourceManager.getResourceByID("xpstage",true) != null;
         }
         Utils.setBrightness(this.m_unlockable_btn,-100);
         Utils.setBrightness(this.m_other_btn,-100);
         this.m_stageMCHash["xpstage"].visible = this.m_stageMCHash["xpstage"].visible && (Main.DEBUG && Config.stage_expansion);
         var _loc2_:Object = ResourceManager.getResourceByID("mappings").getProp("metadata");
         for(_loc1_ in this.m_stageMCHash)
         {
            if(Boolean(_loc2_.stage[_loc1_]) && Boolean(this.m_currentGame.GameMode !== Mode.TRAINING) && Boolean(_loc2_.stage[_loc1_].training_only))
            {
               this.m_stageMCHash[_loc1_].visible = false;
            }
         }
      }
      
      override public function show() : void
      {
         this.resetAll();
         this.pastStageTable.hideAll();
         this.normalStageTable.showAll();
         this.updateIcons();
         this.normalStageTable.spaceObjects();
         this.m_normal_btn.gotoAndStop("on");
         MovieClip(m_subMenu.stage_sample.previewer.getChildByName("mc")).gotoAndStop("paused");
         m_subMenu.stage_sample.stage_txt.text = "";
         this.selectHand.resetPosition();
         GameController.isStarted = false;
         super.show();
      }
      
      private function backCharSelect_CLICK(param1:MouseEvent) : void
      {
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_back");
         MenuController.CurrentCharacterSelectMenu.show();
      }
      
      private function backCharSelect_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function hazards_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         SaveData.toggleHazards();
         if(Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj))
         {
            MenuController.CurrentCharacterSelectMenu.GameObj.LevelData.hazards = SaveData.Hazards;
         }
         this.updateFields();
      }
   }
}


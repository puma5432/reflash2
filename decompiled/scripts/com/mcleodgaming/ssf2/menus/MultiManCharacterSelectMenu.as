package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.modes.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   import flash.events.*;
   
   public class MultiManCharacterSelectMenu extends CharacterSelectMenu
   {
      
      public function MultiManCharacterSelectMenu(param1:String)
      {
         super(param1);
         m_playerLimit = 1;
         gameMode = Mode.MULTIMAN;
      }
      
      override public function makeEvents() : void
      {
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         m_subMenu.bg_top.home_btn.addEventListener(MouseEvent.CLICK,this.home_CLICK);
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.bg_top.home_btn.removeEventListener(MouseEvent.CLICK,this.home_CLICK);
      }
      
      override public function initMatch() : void
      {
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         SoundQueue.instance.playSoundEffect("menu_crowd");
         removeSelf();
         m_game.LevelData.customModeID = MultiManMenu.SELECTED_MULTI_MAN_MODE;
         m_game.LevelData.lives = 1;
         m_game.LevelData.usingStamina = false;
         m_game.LevelData.scoreDisplay = false;
         m_game.FinalSmashMeter = false;
         m_game.ScoreDisplay = false;
         m_game.HudDisplay = true;
         m_game.PauseEnabled = true;
         m_modeInstance = new MultiManMode(m_game,{"multiManModeID":m_game.LevelData.customModeID},{"classAPI":ResourceManager.getResourceByID("multiman_mode").getProp("mode")});
         m_modeInstance.PreviousMenu = this;
      }
      
      override public function initReplay() : void
      {
         m_game.importSettings({
            "levelData":m_game.ReplayDataObj.MatchSettings,
            "items":m_game.ReplayDataObj.ItemSettingsObj,
            "playerSettings":m_game.ReplayDataObj.PlayerData
         });
         SoundQueue.instance.playSoundEffect("menu_crowd");
         m_modeInstance = new MultiManMode(m_game,{"multiManModeID":m_game.LevelData.customModeID},{"classAPI":ResourceManager.getResourceByID("multiman_mode").getProp("mode")});
         m_modeInstance.PreviousMenu = MenuController.vaultMenu;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.updateMultiManScoreDisplay();
      }
      
      override public function updateGameIsReady() : void
      {
         super.updateGameIsReady();
         this.updateMultiManScoreDisplay();
      }
      
      override public function show() : void
      {
         super.show();
         this.updateMultiManScoreDisplay();
         SoundQueue.instance.playMusic("menumusic",0);
      }
      
      override public function backMain_CLICK(param1:MouseEvent) : void
      {
         super.backMain_CLICK(param1);
         MenuController.multimanMenu.show();
      }
      
      private function home_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_back");
         SoundQueue.instance.stopMusic();
         resetScreen();
         m_game = null;
         MenuController.removeAllMenus();
         MenuController.titleMenu.show();
      }
      
      protected function updateMultiManScoreDisplay() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Object = null;
         var _loc3_:MovieClip = null;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc6_:Object = SaveData.Records.multiman.modes[MultiManMenu.SELECTED_MULTI_MAN_MODE];
         m_subMenu.record.record_minutes_txt.text = "----------";
         m_subMenu.record.record_millis_txt.text = "";
         m_subMenu.record.minutes_txt.text = "----------";
         m_subMenu.record.millis_txt.text = "";
         while(m_subMenu.record.best_icon.numChildren > 0)
         {
            m_subMenu.record.best_icon.removeChild(m_subMenu.record.best_icon.getChildAt(0));
         }
         while(m_subMenu.record.high_icon.numChildren > 0)
         {
            m_subMenu.record.high_icon.removeChild(m_subMenu.record.high_icon.getChildAt(0));
         }
         for(_loc1_ in _loc6_)
         {
            if(!_loc4_)
            {
               _loc4_ = _loc6_[_loc1_];
               _loc5_ = _loc1_;
            }
            else if(_loc4_.scoreType === "kos" && _loc6_[_loc1_].scoreType === "time")
            {
               _loc4_ = _loc6_[_loc1_];
               _loc5_ = _loc1_;
            }
            else if(_loc4_.scoreType === "time" && _loc6_[_loc1_].scoreType === "time" && _loc4_.score > _loc6_[_loc1_].score)
            {
               _loc4_ = _loc6_[_loc1_];
               _loc5_ = _loc1_;
            }
            else if(_loc4_.scoreType === "kos" && _loc6_[_loc1_].scoreType === "kos" && _loc4_.score < _loc6_[_loc1_].score)
            {
               _loc4_ = _loc6_[_loc1_];
               _loc5_ = _loc1_;
            }
         }
         if(_loc4_)
         {
            if(_loc4_.scoreType === "time")
            {
               m_subMenu.record.record_minutes_txt.text = Utils.framesToMinutesString(_loc4_.score) + ":" + Utils.framesToSecondsString(_loc4_.score);
               m_subMenu.record.record_millis_txt.text = Utils.framesToMillisecondsString(_loc4_.score);
            }
            else if(_loc4_.scoreType === "kos")
            {
               m_subMenu.record.record_minutes_txt.text = "" + _loc4_.score;
               m_subMenu.record.record_millis_txt.text = "KOs";
            }
            _loc3_ = ResourceManager.getLibraryMC(_loc5_ + "_stock");
            if(_loc3_)
            {
               if(Config.enable_new_stock_counter)
               {
                  Utils.setColorFilterCharacter(_loc3_,-1,_loc5_,-1,false,true);
               }
               m_subMenu.record.best_icon.addChild(_loc3_);
            }
         }
         if(m_game.PlayerSettings[0].character)
         {
            _loc2_ = SaveData.getMultiManModeData(MultiManMenu.SELECTED_MULTI_MAN_MODE,m_game.PlayerSettings[0].character);
            if(_loc2_)
            {
               if(_loc2_.scoreType === "time")
               {
                  m_subMenu.record.minutes_txt.text = Utils.framesToMinutesString(_loc2_.score) + ":" + Utils.framesToSecondsString(_loc2_.score);
                  m_subMenu.record.millis_txt.text = Utils.framesToMillisecondsString(_loc2_.score);
               }
               else if(_loc2_.scoreType === "kos")
               {
                  m_subMenu.record.minutes_txt.text = "" + _loc2_.score;
                  m_subMenu.record.millis_txt.text = "KOs";
               }
            }
            _loc3_ = ResourceManager.getLibraryMC(m_game.PlayerSettings[0].character + "_stock");
            if(_loc3_)
            {
               if(Config.enable_new_stock_counter)
               {
                  Utils.setColorFilterCharacter(_loc3_,-1,m_game.PlayerSettings[0].character,-1,false,true);
               }
               m_subMenu.record.high_icon.addChild(_loc3_);
            }
         }
      }
      
      override protected function insertExpansionSlot(param1:int) : void
      {
      }
   }
}


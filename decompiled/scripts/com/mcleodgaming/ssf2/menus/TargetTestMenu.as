package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.modes.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   
   public class TargetTestMenu extends CharacterSelectMenu
   {
      
      private var m_stage_id:int = 0;
      
      public function TargetTestMenu(param1:String)
      {
         super(param1);
         m_playerLimit = 1;
         gameMode = Mode.TARGET_TEST;
      }
      
      override public function makeEvents() : void
      {
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         if(m_game)
         {
            m_game.UsingLives = false;
            m_game.UsingTime = true;
            m_game.UsingStamina = false;
            m_game.CountDown = false;
            m_game.StartDamage = 0;
            m_game.DamageRatio = 1;
            m_game.FinalSmashMeter = false;
            m_game.ScoreDisplay = false;
            m_game.HudDisplay = true;
            m_game.PauseEnabled = true;
         }
         m_subMenu.decLevel.addEventListener(MouseEvent.CLICK,this.decLevel_CLICK);
         m_subMenu.incLevel.addEventListener(MouseEvent.CLICK,this.incLevel_CLICK);
         m_subMenu.bg_top.home_btn.addEventListener(MouseEvent.CLICK,this.home_CLICK);
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.decLevel.removeEventListener(MouseEvent.CLICK,this.decLevel_CLICK);
         m_subMenu.incLevel.removeEventListener(MouseEvent.CLICK,this.incLevel_CLICK);
         m_subMenu.bg_top.home_btn.removeEventListener(MouseEvent.CLICK,this.home_CLICK);
      }
      
      override public function initMatch() : void
      {
         if(m_charMCHash[m_game.PlayerSettings[0].character].__blocked)
         {
            SoundQueue.instance.playSoundEffect("menu_error");
            if(!Main.DEBUG)
            {
               this.makeEvents();
               return;
            }
         }
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         SoundQueue.instance.playSoundEffect("menu_crowd");
         removeSelf();
         m_game.LevelData.customModeID = ResourceManager.getResourceByID("targets_mode").getProp("targetStageList")[this.m_stage_id].id;
         m_game.LevelData.scoreDisplay = false;
         m_modeInstance = new TargetTestMode(m_game,{"targetMatchID":m_game.LevelData.customModeID},{"classAPI":ResourceManager.getResourceByID("targets_mode").getProp("mode")});
         m_modeInstance.PreviousMenu = MenuController.targetTestMenu;
      }
      
      override public function initReplay() : void
      {
         m_game.importSettings({
            "levelData":m_game.ReplayDataObj.MatchSettings,
            "items":m_game.ReplayDataObj.ItemSettingsObj,
            "playerSettings":m_game.ReplayDataObj.PlayerData
         });
         SoundQueue.instance.playSoundEffect("menu_crowd");
         m_modeInstance = new TargetTestMode(m_game,{"targetMatchID":m_game.LevelData.customModeID},{"classAPI":ResourceManager.getResourceByID("targets_mode").getProp("mode")});
         m_modeInstance.PreviousMenu = MenuController.vaultMenu;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.updateTargetTestDisplay();
      }
      
      override public function show() : void
      {
         SoundQueue.instance.playMusic("menumusic",0);
         this.updateTargetTestDisplay();
         super.show();
         this.updateText();
      }
      
      override public function backMain_CLICK(param1:MouseEvent) : void
      {
         super.backMain_CLICK(param1);
         MenuController.stadiumMenu.show();
      }
      
      public function updateText() : void
      {
         m_subMenu.level_txt.text = ResourceManager.getResourceByID("targets_mode").getProp("targetStageList")[this.m_stage_id].name;
      }
      
      override public function updateGameIsReady() : void
      {
         super.updateGameIsReady();
         this.updateTargetTestDisplay();
      }
      
      private function decLevel_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         --this.m_stage_id;
         if(this.m_stage_id < 0)
         {
            this.m_stage_id = ResourceManager.getResourceByID("targets_mode").getProp("targetStageList").length - 1;
         }
         this.updateText();
         this.updateTargetTestDisplay();
      }
      
      private function incLevel_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         ++this.m_stage_id;
         if(this.m_stage_id > ResourceManager.getResourceByID("targets_mode").getProp("targetStageList").length - 1)
         {
            this.m_stage_id = 0;
         }
         this.updateText();
         this.updateTargetTestDisplay();
      }
      
      private function home_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_back");
         SoundQueue.instance.stopMusic();
         resetScreen();
         m_game = null;
         MenuController.disposeAllMenus(true);
         MenuController.titleMenu.show();
      }
      
      public function updateTargetTestDisplay() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Array = null;
         var _loc7_:int = 0;
         var _loc11_:int = 0;
         var _loc3_:String = "-:--";
         var _loc4_:String = "";
         var _loc5_:String = "";
         var _loc6_:String = ResourceManager.getResourceByID("targets_mode").getProp("targetStageList")[this.m_stage_id].id;
         var _loc8_:* = null;
         for(_loc8_ in m_charMCHash)
         {
            if(m_charMCHash[_loc8_].__oldFilters)
            {
               m_charMCHash[_loc8_].filters = m_charMCHash[_loc8_].__oldFilters;
               m_charMCHash[_loc8_].__blocked = false;
            }
         }
         if(_loc6_ === "Character")
         {
            _loc1_ = ResourceManager.getResourceByID("mappings").getProp("metadata_original");
            for(_loc8_ in m_charMCHash)
            {
               if(_loc8_ === "random" || !(Boolean(ResourceManager.getResourceByID("targettest_" + _loc8_)) && Boolean(_loc1_.stage["targettest_" + _loc8_]) && ResourceManager.getResourceByID("targettest_" + _loc8_).EncryptedFileName))
               {
                  _loc2_ = null;
                  if(m_charMCHash[_loc8_].filters)
                  {
                     _loc2_ = new Array();
                     _loc7_ = 0;
                     while(_loc7_ < m_charMCHash[_loc8_].filters.length)
                     {
                        _loc2_.push(m_charMCHash[_loc8_].filters[_loc7_]);
                        _loc7_++;
                     }
                  }
                  m_charMCHash[_loc8_].__oldFilters = _loc2_;
                  m_charMCHash[_loc8_].__blocked = true;
                  Utils.setColorFilter(m_charMCHash[_loc8_],{
                     "saturation":-100,
                     "brightness":-75
                  });
               }
            }
         }
         if(m_game.PlayerSettings[0].character != null)
         {
            if(SaveData.getTargetTestData(_loc6_,m_game.PlayerSettings[0].character) != null)
            {
               if(SaveData.getTargetTestData(_loc6_,m_game.PlayerSettings[0].character).score > 0)
               {
                  _loc3_ = Utils.framesToMinutesString(SaveData.getTargetTestData(_loc6_,m_game.PlayerSettings[0].character).score) + ":" + Utils.framesToSecondsString(SaveData.getTargetTestData(_loc6_,m_game.PlayerSettings[0].character).score);
                  _loc4_ = "\'" + Utils.framesToMillisecondsString(SaveData.getTargetTestData(_loc6_,m_game.PlayerSettings[0].character).score);
                  _loc5_ = SaveData.getTargetTestData(_loc6_,m_game.PlayerSettings[0].character).score_fps;
               }
            }
            m_subMenu.minutes_txt.text = _loc3_;
            m_subMenu.millis_txt.text = _loc4_;
            m_subMenu.fps_txt.text = _loc5_;
         }
         else
         {
            m_subMenu.minutes_txt.text = _loc3_;
            m_subMenu.millis_txt.text = _loc4_;
            m_subMenu.fps_txt.text = _loc5_;
         }
         _loc3_ = "-:--";
         _loc4_ = "";
         var _loc9_:Boolean = true;
         var _loc10_:Array = Stats.getCharacterList(false);
         _loc7_ = 0;
         while(_loc7_ < _loc10_.length)
         {
            if(SaveData.getTargetTestData(_loc6_,_loc10_[_loc7_]) != null)
            {
               if(SaveData.getTargetTestData(_loc6_,_loc10_[_loc7_]).score <= 0)
               {
                  _loc9_ = false;
                  break;
               }
               _loc11_ += SaveData.getTargetTestData(_loc6_,_loc10_[_loc7_]).score;
            }
            else
            {
               _loc9_ = false;
            }
            _loc7_++;
         }
         if(_loc9_)
         {
            _loc3_ = Utils.framesToMinutesString(_loc11_) + ":" + Utils.framesToSecondsString(_loc11_);
            _loc4_ = "\'" + Utils.framesToMillisecondsString(_loc11_);
         }
         m_subMenu.total_minutes_txt.text = _loc3_;
         m_subMenu.total_millis_txt.text = _loc4_;
      }
      
      override protected function insertExpansionSlot(param1:int) : void
      {
      }
   }
}


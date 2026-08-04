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
   
   public class HomeRunContestMenu extends CharacterSelectMenu
   {
      
      private var m_stage_id:int = 0;
      
      private var m_meters:Boolean;
      
      public function HomeRunContestMenu(param1:String)
      {
         super(param1);
         m_playerLimit = 1;
         gameMode = Mode.HOME_RUN_CONTEST;
         this.m_meters = false;
      }
      
      override public function makeEvents() : void
      {
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         m_subMenu.decLevel.addEventListener(MouseEvent.CLICK,this.decLevel_CLICK);
         m_subMenu.incLevel.addEventListener(MouseEvent.CLICK,this.incLevel_CLICK);
         m_subMenu.bg_top.home_btn.addEventListener(MouseEvent.CLICK,this.home_CLICK);
         Main.Root.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyPress);
         this.updateText();
         this.updateRecordsDisplay();
      }
      
      override public function updateGameIsReady() : void
      {
         super.updateGameIsReady();
         this.updateRecordsDisplay();
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.decLevel.removeEventListener(MouseEvent.CLICK,this.decLevel_CLICK);
         m_subMenu.incLevel.removeEventListener(MouseEvent.CLICK,this.incLevel_CLICK);
         m_subMenu.bg_top.home_btn.removeEventListener(MouseEvent.CLICK,this.home_CLICK);
         Main.Root.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyPress);
      }
      
      private function onKeyPress(param1:KeyboardEvent) : void
      {
         if(param1.keyCode === Key.M && Boolean(param1.controlKey))
         {
            this.m_meters = !this.m_meters;
         }
         this.updateRecordsDisplay();
      }
      
      override public function initMatch() : void
      {
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         SoundQueue.instance.playSoundEffect("menu_crowd");
         removeSelf();
         m_game.LevelData.customModeID = ResourceManager.getResourceByID("homeruncontest_mode").getProp("hrcStageList")[this.m_stage_id].id;
         m_game.LevelData.lives = 1;
         m_game.LevelData.usingStamina = false;
         m_game.LevelData.scoreDisplay = false;
         m_game.FinalSmashMeter = false;
         m_game.ScoreDisplay = false;
         m_game.HudDisplay = true;
         m_game.PauseEnabled = true;
         m_modeInstance = new HomeRunContestMode(m_game,{"hrcMatchID":m_game.LevelData.customModeID},{"classAPI":ResourceManager.getResourceByID("homeruncontest_mode").getProp("mode")});
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
         m_modeInstance = new HomeRunContestMode(m_game,{"hrcMatchID":m_game.LevelData.customModeID},{"classAPI":ResourceManager.getResourceByID("homeruncontest_mode").getProp("mode")});
         m_modeInstance.PreviousMenu = MenuController.vaultMenu;
      }
      
      override public function reset() : void
      {
         super.reset();
      }
      
      public function updateText() : void
      {
         m_subMenu.level_txt.text = ResourceManager.getResourceByID("homeruncontest_mode").getProp("hrcStageList")[this.m_stage_id].name;
      }
      
      override public function show() : void
      {
         super.show();
         SoundQueue.instance.playMusic("menumusic",0);
      }
      
      private function decLevel_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         --this.m_stage_id;
         if(this.m_stage_id < 0)
         {
            this.m_stage_id = ResourceManager.getResourceByID("homeruncontest_mode").getProp("hrcStageList").length - 1;
         }
         this.updateText();
         this.updateRecordsDisplay();
      }
      
      private function incLevel_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         ++this.m_stage_id;
         if(this.m_stage_id > ResourceManager.getResourceByID("homeruncontest_mode").getProp("hrcStageList").length - 1)
         {
            this.m_stage_id = 0;
         }
         this.updateText();
         this.updateRecordsDisplay();
      }
      
      private function getDistanceString(param1:int) : String
      {
         if(this.m_meters)
         {
            return Math.round(param1 * 0.3048 * 100) / 100 + "m";
         }
         return param1 + "ft";
      }
      
      public function updateRecordsDisplay() : void
      {
         var _loc4_:int = 0;
         var _loc1_:String = ResourceManager.getResourceByID("homeruncontest_mode").getProp("hrcStageList")[this.m_stage_id].id;
         if(SaveData.getHRCModeData(_loc1_,m_game.PlayerSettings[0].character))
         {
            m_subMenu.distance_txt.text = this.getDistanceString(SaveData.getHRCModeData(_loc1_,m_game.PlayerSettings[0].character).score);
         }
         else
         {
            m_subMenu.distance_txt.text = "--";
         }
         var _loc2_:Array = Stats.getCharacterList(false);
         var _loc3_:Number = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(SaveData.getHRCModeData(_loc1_,_loc2_[_loc4_]) != null)
            {
               _loc3_ += SaveData.getHRCModeData(_loc1_,_loc2_[_loc4_]).score;
            }
            _loc4_++;
         }
         _loc3_ = Math.round(_loc3_ * 10) / 10;
         m_subMenu.total_distance_txt.text = this.getDistanceString(_loc3_);
      }
      
      override public function backMain_CLICK(param1:MouseEvent) : void
      {
         super.backMain_CLICK(param1);
         MenuController.stadiumMenu.show();
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
   }
}


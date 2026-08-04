package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.modapi.*;
   import com.mcleodgaming.ssf2.modes.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   
   public class ClassicModeMenu extends CharacterSelectMenu
   {
      
      public static var lives:int = 3;
      
      public static var difficulty:uint = 1;
      
      public static const difficultyList:Array = [Difficulty.EASY,Difficulty.NORMAL,Difficulty.HARD,Difficulty.INSANE];
      
      public function ClassicModeMenu(param1:String)
      {
         super(param1);
         m_playerLimit = 1;
         gameMode = Mode.CLASSIC;
      }
      
      override public function reset() : void
      {
         super.reset();
         m_subMenu.readyToFight.visible = false;
         super.updateIcons();
         updateDisplay();
      }
      
      override public function updateGameIsReady() : void
      {
         super.updateGameIsReady();
         this.updateClassicModeDisplay();
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
            m_game.UsingTime = false;
            m_game.UsingStamina = false;
            m_game.DamageRatio = 1;
            m_game.StartDamage = 0;
            m_game.FinalSmashMeter = false;
            m_game.ScoreDisplay = false;
            m_game.HudDisplay = true;
            m_game.PauseEnabled = true;
         }
         m_subMenu.bg_top.home_btn.addEventListener(MouseEvent.CLICK,this.home_CLICK);
         m_subMenu.decLives.addEventListener(MouseEvent.CLICK,this.decLives_CLICK);
         m_subMenu.incLives.addEventListener(MouseEvent.CLICK,this.incLives_CLICK);
         m_subMenu.decDifficulty.addEventListener(MouseEvent.CLICK,this.decDifficulty_CLICK);
         m_subMenu.incDifficulty.addEventListener(MouseEvent.CLICK,this.incDifficulty_CLICK);
         this.updateClassicModeDisplay();
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.bg_top.home_btn.removeEventListener(MouseEvent.CLICK,this.home_CLICK);
         m_subMenu.decLives.removeEventListener(MouseEvent.CLICK,this.decLives_CLICK);
         m_subMenu.incLives.removeEventListener(MouseEvent.CLICK,this.incLives_CLICK);
         m_subMenu.decDifficulty.removeEventListener(MouseEvent.CLICK,this.decDifficulty_CLICK);
         m_subMenu.incDifficulty.removeEventListener(MouseEvent.CLICK,this.incDifficulty_CLICK);
      }
      
      override public function initMatch() : void
      {
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         SoundQueue.instance.playSoundEffect("menu_crowd");
         removeSelf();
         m_game.LevelData.lives = ClassicModeMenu.lives;
         m_game.LevelData.difficulty = ClassicModeMenu.difficultyList[ClassicModeMenu.difficulty];
         m_modeInstance = new ClassicMode(m_game,{},{"classAPI":ResourceManager.getResourceByID("classic_mode").getProp("mode")});
         m_modeInstance.PreviousMenu = this;
      }
      
      override public function backMain_CLICK(param1:MouseEvent) : void
      {
         ModAPI.stopMenuRumble();
         super.backMain_CLICK(param1);
         MenuController.soloMenu.show();
      }
      
      private function home_CLICK(param1:MouseEvent) : void
      {
         ModAPI.stopMenuRumble();
         SoundQueue.instance.playSoundEffect("menu_back");
         SoundQueue.instance.stopMusic();
         resetScreen();
         m_game = null;
         MenuController.removeAllMenus();
         MenuController.titleMenu.show();
      }
      
      private function updateClassicModeDisplay() : void
      {
         if(SaveData.getClassicModeData(m_game.PlayerSettings[0].character))
         {
            m_subMenu.score_txt.text = "" + SaveData.getClassicModeData(m_game.PlayerSettings[0].character).score;
         }
         else
         {
            m_subMenu.score_txt.text = "--";
         }
         m_subMenu.lives_txt.text = "" + ClassicModeMenu.lives;
         switch(ClassicModeMenu.difficultyList[ClassicModeMenu.difficulty])
         {
            case Difficulty.VERY_EASY:
               m_subMenu.difficulty_txt.text = "Very Easy";
               break;
            case Difficulty.EASY:
               m_subMenu.difficulty_txt.text = "Easy";
               break;
            case Difficulty.NORMAL:
               m_subMenu.difficulty_txt.text = "Normal";
               break;
            case Difficulty.HARD:
               m_subMenu.difficulty_txt.text = "Hard";
               break;
            case Difficulty.VERY_HARD:
               m_subMenu.difficulty_txt.text = "Very Hard";
               break;
            case Difficulty.INSANE:
               m_subMenu.difficulty_txt.text = "Insane";
               break;
            default:
               m_subMenu.difficulty_txt.text = "???";
         }
         Utils.fitText(m_subMenu.difficulty_txt,14);
      }
      
      private function decLives_CLICK(param1:MouseEvent) : void
      {
         --ClassicModeMenu.lives;
         if(ClassicModeMenu.lives < 1)
         {
            ClassicModeMenu.lives = 5;
         }
         this.updateClassicModeDisplay();
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function incLives_CLICK(param1:MouseEvent) : void
      {
         ++ClassicModeMenu.lives;
         if(ClassicModeMenu.lives > 5)
         {
            ClassicModeMenu.lives = 1;
         }
         this.updateClassicModeDisplay();
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function decDifficulty_CLICK(param1:MouseEvent) : void
      {
         if(ClassicModeMenu.difficulty <= 0)
         {
            ClassicModeMenu.difficulty = difficultyList.length - 1;
         }
         else
         {
            --ClassicModeMenu.difficulty;
         }
         this.updateClassicModeDisplay();
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function incDifficulty_CLICK(param1:MouseEvent) : void
      {
         ++ClassicModeMenu.difficulty;
         if(ClassicModeMenu.difficulty > difficultyList.length - 1)
         {
            ClassicModeMenu.difficulty = 0;
         }
         this.updateClassicModeDisplay();
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      override protected function insertExpansionSlot(param1:int) : void
      {
      }
   }
}


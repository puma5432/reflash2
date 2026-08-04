package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.net.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   
   public class VSMenu extends CharacterSelectMenu
   {
      
      public function VSMenu(param1:String)
      {
         super(param1);
      }
      
      override public function makeEvents() : void
      {
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         m_subMenu.menu_open.addEventListener(MouseEvent.CLICK,this.menu_open_CLICK);
         m_subMenu.menu_open.addEventListener(MouseEvent.ROLL_OVER,this.menu_open_ROLL_OVER);
         if(m_subMenu.controls_btn)
         {
            m_subMenu.controls_btn.addEventListener(MouseEvent.CLICK,controls_btn_CLICK);
            m_subMenu.controls_btn.addEventListener(MouseEvent.ROLL_OVER,controls_btn_ROLL_OVER);
         }
         m_subMenu.bnGameMode.addEventListener(MouseEvent.CLICK,this.gameMode_CLICK);
         m_subMenu.incShortcut.addEventListener(MouseEvent.CLICK,this.inc_CLICK);
         m_subMenu.decShortcut.addEventListener(MouseEvent.CLICK,this.dec_CLICK);
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.menu_open.removeEventListener(MouseEvent.CLICK,this.menu_open_CLICK);
         m_subMenu.menu_open.removeEventListener(MouseEvent.ROLL_OVER,this.menu_open_ROLL_OVER);
         if(m_subMenu.controls_btn)
         {
            m_subMenu.controls_btn.removeEventListener(MouseEvent.CLICK,controls_btn_CLICK);
            m_subMenu.controls_btn.removeEventListener(MouseEvent.ROLL_OVER,controls_btn_ROLL_OVER);
         }
         m_subMenu.bnGameMode.removeEventListener(MouseEvent.CLICK,this.gameMode_CLICK);
         m_subMenu.incShortcut.removeEventListener(MouseEvent.CLICK,this.inc_CLICK);
         m_subMenu.decShortcut.removeEventListener(MouseEvent.CLICK,this.dec_CLICK);
      }
      
      override public function initMatch() : void
      {
         m_game.StartDamage = m_game.StartDamage;
         SaveData.setSavedVSOptions(m_game);
         SaveData.saveGame();
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         MenuController.CurrentCharacterSelectMenu.removeSelf();
         MenuController.stageSelectMenu.setCurrentGame(m_game);
         MenuController.stageSelectMenu.show();
      }
      
      override public function reset() : void
      {
         gameMode = Mode.VS;
         super.reset();
      }
      
      override public function backMain_CLICK(param1:MouseEvent) : void
      {
         var _loc2_:uint = uint(Mode.VS);
         if(m_game.GameMode)
         {
            _loc2_ = m_game.GameMode;
            if(ModeFeatures.hasFeature(ModeFeatures.ALLOW_SAVE_VS_OPTIONS,m_game.GameMode))
            {
               SaveData.setSavedVSOptions(m_game);
               SaveData.saveGame();
            }
         }
         super.backMain_CLICK(param1);
         MenuController.groupMenu.show();
      }
      
      public function menu_open_CLICK(param1:MouseEvent) : void
      {
         if(hasVisibleKeypad())
         {
            SoundQueue.instance.playSoundEffect("menu_error");
            return;
         }
         SoundQueue.instance.playSoundEffect("menu_select");
         MenuController.rulesMenu.show();
      }
      
      public function menu_open_ROLL_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      protected function inc_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         incrementShortcut();
      }
      
      protected function dec_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         decrementShortcut();
      }
      
      public function gameMode_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         toggleGameMode();
      }
   }
}


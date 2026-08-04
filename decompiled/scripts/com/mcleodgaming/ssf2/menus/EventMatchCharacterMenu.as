package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.modes.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   
   public class EventMatchCharacterMenu extends CharacterSelectMenu
   {
      
      public function EventMatchCharacterMenu(param1:String)
      {
         super(param1);
         m_playerLimit = 1;
         gameMode = Mode.EVENT;
      }
      
      override public function reset() : void
      {
         SoundQueue.instance.playSoundEffect("narrator_choose");
         super.reset();
      }
      
      override public function show() : void
      {
         if(Boolean(m_game) && !m_game.PlayerSettings[0].character)
         {
            super.show();
         }
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
         if(m_game)
         {
            m_game.UsingLives = false;
            m_game.UsingTime = false;
            m_game.UsingStamina = false;
            m_game.DamageRatio = 1;
            m_game.FinalSmashMeter = false;
            m_game.StartDamage = 0;
         }
         m_modeInstance = new EventMode(m_game,{"eventMatchID":MenuController.eventMenu.CurrentEvent.id},{"classAPI":ResourceManager.getResourceByID("event_mode").getProp("mode")});
         m_modeInstance.PreviousMenu = MenuController.eventMenu;
      }
      
      override public function backMain_CLICK(param1:MouseEvent) : void
      {
         super.backMain_CLICK(param1);
         MenuController.eventMenu.show();
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
      
      override protected function insertExpansionSlot(param1:int) : void
      {
      }
   }
}


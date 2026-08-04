package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.modes.*;
   import com.mcleodgaming.ssf2.net.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   
   public class ArenaCharacterSelectMenu extends CharacterSelectMenu
   {
      
      public function ArenaCharacterSelectMenu(param1:String)
      {
         super(param1);
         m_subMenu.match_desc.text = " - Score Limit";
         gameMode = MultiplayerManager.Connected ? uint(Mode.ONLINE_ARENA) : uint(Mode.ARENA);
      }
      
      override public function makeEvents() : void
      {
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         m_subMenu.incShortcut.addEventListener(MouseEvent.CLICK,this.inc_CLICK);
         m_subMenu.decShortcut.addEventListener(MouseEvent.CLICK,this.dec_CLICK);
         m_subMenu.opCount.text = m_game.LevelData.scoreLimit;
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.incShortcut.removeEventListener(MouseEvent.CLICK,this.inc_CLICK);
         m_subMenu.decShortcut.removeEventListener(MouseEvent.CLICK,this.dec_CLICK);
      }
      
      override public function initReplay() : void
      {
         m_game.importSettings({
            "levelData":m_game.ReplayDataObj.MatchSettings,
            "items":m_game.ReplayDataObj.ItemSettingsObj,
            "playerSettings":m_game.ReplayDataObj.PlayerData
         });
         SoundQueue.instance.playSoundEffect("menu_crowd");
         m_modeInstance = new ArenaMode(m_game,{"arenaModeID":m_game.LevelData.customModeID},{"classAPI":ResourceManager.getResourceByID("arena_mode").getProp("mode")});
         m_modeInstance.PreviousMenu = MenuController.vaultMenu;
      }
      
      override public function initMatch() : void
      {
         SaveData.getSavedVSOptions().arenaScore = m_game.LevelData.scoreLimit;
         SaveData.saveGame();
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         SoundQueue.instance.playSoundEffect("menu_crowd");
         removeSelf();
         m_game.LevelData.customModeID = ArenaModeMenu.SELECTED_ARENA_MODE;
         m_game.LevelData.lives = 1;
         if(MultiplayerManager.Connected)
         {
            MenuController.pleaseWaitMenu.show();
            MultiplayerManager.toWaitingRoom(m_game,this.waitingRoomReady);
         }
         else
         {
            m_modeInstance = new ArenaMode(m_game,{"arenaModeID":ArenaModeMenu.SELECTED_ARENA_MODE},{"classAPI":ResourceManager.getResourceByID("arena_mode").getProp("mode")});
            m_modeInstance.PreviousMenu = this;
         }
      }
      
      private function waitingRoomReady(param1:* = null) : void
      {
         MenuController.disposeAllMenus();
         GameController.startMatch(m_game);
      }
      
      override public function reset() : void
      {
         var _loc1_:int = 0;
         gameMode = MultiplayerManager.Connected ? uint(Mode.ONLINE_ARENA) : uint(Mode.ARENA);
         if(MultiplayerManager.Connected)
         {
            m_playerLimit = 1;
         }
         else
         {
            m_playerLimit = 4;
         }
         super.reset();
         toggleGameMode();
         m_game.LevelData.usingLives = false;
         m_game.LevelData.usingTime = false;
         m_game.LevelData.usingStamina = false;
         m_game.LevelData.scoreDisplay = false;
         m_game.FinalSmashMeter = false;
         if(MultiplayerManager.Connected)
         {
            m_game.LevelData.inputBuffer = MultiplayerManager.INPUT_BUFFER;
            m_playerLimit = 1;
            m_game.PlayerSettings[0].team = MultiplayerManager.IsHost ? 1 : 3;
            m_game.PlayerSettings[0].name = m_game.PlayerSettings[0].name || MultiplayerManager.Username.substr(0,10) || null;
            if(Boolean(SaveData.Controllers[0].GamepadInstance) && Boolean(m_game.PlayerSettings[0].name))
            {
               SaveData.reimportNamedPlayerControls(1,m_game.PlayerSettings[0].name);
            }
         }
         else
         {
            _loc1_ = 0;
            while(_loc1_ < m_game.PlayerSettings.length)
            {
               m_game.PlayerSettings[_loc1_].team = _loc1_ === 0 ? 1 : 3;
               _loc1_++;
            }
         }
         updateDisplay();
      }
      
      override public function backMain_CLICK(param1:MouseEvent) : void
      {
         SaveData.getSavedVSOptions().arenaScore = m_game.LevelData.scoreLimit;
         SaveData.saveGame();
         super.backMain_CLICK(param1);
         MenuController.arenaMenu.show();
      }
      
      protected function inc_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         ++m_game.LevelData.scoreLimit;
         if(m_game.LevelData.scoreLimit > 99)
         {
            m_game.LevelData.scoreLimit = 99;
         }
         m_subMenu.opCount.text = m_game.LevelData.scoreLimit;
      }
      
      protected function dec_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         --m_game.LevelData.scoreLimit;
         if(m_game.LevelData.scoreLimit < 1)
         {
            m_game.LevelData.scoreLimit = 1;
         }
         m_subMenu.opCount.text = m_game.LevelData.scoreLimit;
      }
      
      override protected function insertExpansionSlot(param1:int) : void
      {
      }
   }
}


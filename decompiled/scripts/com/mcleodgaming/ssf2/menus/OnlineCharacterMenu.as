package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.mgn.events.*;
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.net.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   
   public class OnlineCharacterMenu extends CharacterSelectMenu
   {
      
      public function OnlineCharacterMenu(param1:String)
      {
         super(param1);
         m_playerLimit = 1;
         gameMode = Mode.ONLINE;
      }
      
      override public function reset() : void
      {
         super.reset();
         var _loc1_:int = 1;
         while(_loc1_ < m_game.PlayerSettings.length)
         {
            m_game.PlayerSettings[_loc1_].exist = false;
            _loc1_++;
         }
         m_game.PlayerSettings[0].name = m_game.PlayerSettings[0].name || MultiplayerManager.Username.substr(0,15) || null;
         if(Boolean(SaveData.Controllers[0].GamepadInstance) && Boolean(m_game.PlayerSettings[0].name))
         {
            SaveData.reimportNamedPlayerControls(1,m_game.PlayerSettings[0].name);
         }
         if(MultiplayerManager.Connected)
         {
            m_game.LevelData.inputBuffer = MultiplayerManager.INPUT_BUFFER;
         }
         updateDisplay();
      }
      
      override public function show() : void
      {
         super.show();
         if(m_game)
         {
            m_game.GameMode = Mode.ONLINE;
            updateDisplay();
         }
         SoundQueue.instance.playMusic("menumusic",0);
         this.updateDiscordPresenceForCharacterSelect();
      }
      
      private function updateDiscordPresenceForCharacterSelect() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         if(Boolean(Main.m_sdk) && Boolean(Config.rich_presence) && Boolean(MultiplayerManager.Connected))
         {
            _loc1_ = MultiplayerManager.RoomKey;
            _loc2_ = MultiplayerManager.RoomCode;
            if(_loc1_ == null || _loc1_ == "" || _loc2_ == null || _loc2_ == "")
            {
               trace("[Discord] No room key/code for character select");
               return;
            }
            _loc3_ = MultiplayerManager.RoomPassword;
            _loc4_ = int(MultiplayerManager.Players.length);
            _loc5_ = int(MultiplayerManager.ROOM_CAPACITY);
            _loc6_ = MenuController.buildDiscordJoinSecret(_loc1_,_loc2_,_loc3_,_loc5_);
            _loc7_ = MultiplayerManager.DiscordPartyID;
            trace("[Discord] Updating presence for online character selection");
            trace("[Discord] Room Key: " + _loc1_);
            trace("[Discord] Room Code: " + _loc2_);
            trace("[Discord] Join Secret: " + _loc6_);
            trace("[Discord] Party: " + _loc4_ + "/" + _loc5_);
            MenuController.updateDiscordPresence("Choosing a character","Playing online",MenuController.getCurrentTimestamp(),0,"ssf2","Super Smash Flash 2","online",null,_loc7_,_loc4_,_loc5_,_loc1_,_loc6_);
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
         m_subMenu.menu_open.addEventListener(MouseEvent.CLICK,this.menu_open_CLICK);
         m_subMenu.menu_open.addEventListener(MouseEvent.ROLL_OVER,this.menu_open_ROLL_OVER);
         m_subMenu.bnGameMode.addEventListener(MouseEvent.CLICK,this.gameMode_CLICK);
         m_subMenu.incShortcut.addEventListener(MouseEvent.CLICK,this.inc_CLICK);
         m_subMenu.decShortcut.addEventListener(MouseEvent.CLICK,this.dec_CLICK);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.LEAVE_ROOM,this.onLeaveRoom);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.ERROR_LEAVE_ROOM,this.onLeaveRoomError);
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.menu_open.removeEventListener(MouseEvent.CLICK,this.menu_open_CLICK);
         m_subMenu.menu_open.removeEventListener(MouseEvent.ROLL_OVER,this.menu_open_ROLL_OVER);
         m_subMenu.bnGameMode.removeEventListener(MouseEvent.CLICK,this.gameMode_CLICK);
         m_subMenu.incShortcut.removeEventListener(MouseEvent.CLICK,this.inc_CLICK);
         m_subMenu.decShortcut.removeEventListener(MouseEvent.CLICK,this.dec_CLICK);
         MGNEventManager.dispatcher.removeEventListener(MGNEvent.LEAVE_ROOM,this.onLeaveRoom);
         MGNEventManager.dispatcher.removeEventListener(MGNEvent.ERROR_LEAVE_ROOM,this.onLeaveRoomError);
      }
      
      override public function initMatch() : void
      {
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         MenuController.CurrentCharacterSelectMenu.removeSelf();
         if(MultiplayerManager.IsHost)
         {
            MenuController.stageSelectMenu.setCurrentGame(MenuController.CurrentCharacterSelectMenu.GameObj);
            MenuController.stageSelectMenu.show();
         }
         else
         {
            MenuController.pleaseWaitMenu.show();
            MultiplayerManager.toWaitingRoom(m_game,this.waitingRoomReady);
         }
      }
      
      private function waitingRoomReady(param1:* = null) : void
      {
         MenuController.disposeAllMenus();
         GameController.startMatch(m_game);
      }
      
      override public function backMain_CLICK(param1:MouseEvent) : void
      {
         if(MultiplayerManager.IsHost)
         {
            super.backMain_CLICK(param1);
            MenuController.onlineGroupMenu.show();
         }
         else
         {
            MultiplayerManager.leaveRoom();
            m_container.visible = false;
         }
      }
      
      private function onLeaveRoom(param1:MGNEvent) : void
      {
         m_container.visible = true;
         super.backMain_CLICK(null);
         MenuController.onlineMenu.show();
         MenuController.onlineMenu.refreshRoomsList();
      }
      
      private function onLeaveRoomError(param1:MGNEvent) : void
      {
         m_container.visible = true;
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
      
      public function gameMode_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         toggleGameMode();
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
      
      override protected function insertExpansionSlot(param1:int) : void
      {
      }
   }
}


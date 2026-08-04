package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.mgn.events.*;
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.net.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   
   public class OnlineGroupMenu extends Menu
   {
      
      private var m_brawlNode:MenuMapperNode;
      
      private var m_specialNode:MenuMapperNode;
      
      private var m_arenaNode:MenuMapperNode;
      
      private var m_wasOnlineEnabled:Boolean;
      
      public function OnlineGroupMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_group_online");
         m_backgroundID = "space";
         m_container.addChild(m_subMenu);
         this.initMenuMappings();
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         if(!Config.mode_arena)
         {
            Utils.setBrightness(m_subMenu.arena_btn,-100);
         }
         if(!Config.mode_special)
         {
            Utils.setBrightness(m_subMenu.specialbrawl_btn,-100);
         }
      }
      
      override public function initMenuMappings() : void
      {
         this.m_brawlNode = new MenuMapperNode(m_subMenu.brawl_btn);
         this.m_specialNode = new MenuMapperNode(m_subMenu.specialbrawl_btn);
         this.m_arenaNode = new MenuMapperNode(m_subMenu.arena_btn);
         this.m_brawlNode.updateNodes([this.m_specialNode,this.m_arenaNode],[this.m_specialNode,this.m_arenaNode],[],[],this.brawl_MOUSE_OVER,this.brawl_MOUSE_OUT,this.brawl_CLICK,this.back_CLICK_mode);
         this.m_specialNode.updateNodes([this.m_brawlNode],[this.m_brawlNode],[this.m_arenaNode],[this.m_arenaNode],this.specialbrawl_MOUSE_OVER,this.specialbrawl_MOUSE_OUT,this.specialbrawl_CLICK,this.back_CLICK_mode);
         this.m_arenaNode.updateNodes([this.m_brawlNode],[this.m_brawlNode],[this.m_specialNode],[this.m_specialNode],this.arena_MOUSE_OVER,this.arena_MOUSE_OUT,this.arena_CLICK,this.back_CLICK_mode);
         m_menuMapper = new MenuMapper(this.m_brawlNode);
         m_menuMapper.init();
      }
      
      override public function show() : void
      {
         super.show();
         SoundQueue.instance.playMusic("menumusic",0);
         this.updateDiscordPresenceForOnlineGroup();
      }
      
      override public function makeEvents() : void
      {
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         resetAllButtons();
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK_mode);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER_mode);
         m_subMenu.brawl_btn.addEventListener(MouseEvent.MOUSE_OVER,this.brawl_MOUSE_OVER);
         m_subMenu.brawl_btn.addEventListener(MouseEvent.MOUSE_OUT,this.brawl_MOUSE_OUT);
         m_subMenu.brawl_btn.addEventListener(MouseEvent.CLICK,this.brawl_CLICK);
         m_subMenu.specialbrawl_btn.addEventListener(MouseEvent.MOUSE_OVER,this.specialbrawl_MOUSE_OVER);
         m_subMenu.specialbrawl_btn.addEventListener(MouseEvent.MOUSE_OUT,this.specialbrawl_MOUSE_OUT);
         m_subMenu.specialbrawl_btn.addEventListener(MouseEvent.CLICK,this.specialbrawl_CLICK);
         m_subMenu.arena_btn.addEventListener(MouseEvent.MOUSE_OVER,this.arena_MOUSE_OVER);
         m_subMenu.arena_btn.addEventListener(MouseEvent.MOUSE_OUT,this.arena_MOUSE_OUT);
         m_subMenu.arena_btn.addEventListener(MouseEvent.CLICK,this.arena_CLICK);
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,manageMenuMappings);
         setMenuMappingFocus();
         MGNEventManager.dispatcher.addEventListener(MGNEvent.LEAVE_ROOM,this.onLeaveRoom);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.ERROR_LEAVE_ROOM,this.onLeaveRoomError);
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK_mode);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER_mode);
         m_subMenu.brawl_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.brawl_MOUSE_OVER);
         m_subMenu.brawl_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.brawl_MOUSE_OUT);
         m_subMenu.brawl_btn.removeEventListener(MouseEvent.CLICK,this.brawl_CLICK);
         m_subMenu.specialbrawl_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.specialbrawl_MOUSE_OVER);
         m_subMenu.specialbrawl_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.specialbrawl_MOUSE_OUT);
         m_subMenu.specialbrawl_btn.removeEventListener(MouseEvent.CLICK,this.specialbrawl_CLICK);
         m_subMenu.arena_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.arena_MOUSE_OVER);
         m_subMenu.arena_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.arena_MOUSE_OUT);
         m_subMenu.arena_btn.removeEventListener(MouseEvent.CLICK,this.arena_CLICK);
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,manageMenuMappings);
         MGNEventManager.dispatcher.removeEventListener(MGNEvent.LEAVE_ROOM,this.onLeaveRoom);
         MGNEventManager.dispatcher.removeEventListener(MGNEvent.ERROR_LEAVE_ROOM,this.onLeaveRoomError);
      }
      
      private function brawl_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Jump right in and start brawling with your friends!";
      }
      
      private function brawl_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function brawl_CLICK(param1:MouseEvent) : void
      {
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         m_subMenu.desc_txt.text = "";
         MenuController.CurrentCharacterSelectMenu = MenuController.onlineCharacterMenu;
         MenuController.CurrentCharacterSelectMenu.reset();
         MenuController.CurrentCharacterSelectMenu.show();
         SoundQueue.instance.playVoiceEffect("narrator_choose");
      }
      
      private function specialbrawl_MOUSE_OVER(param1:MouseEvent) : void
      {
         if(Config.mode_special)
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            m_subMenu.desc_txt.text = "Battle with special rules! These don\'t affect records.";
         }
      }
      
      private function specialbrawl_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function specialbrawl_CLICK(param1:MouseEvent) : void
      {
         if(Config.mode_special)
         {
            removeSelf();
            SoundQueue.instance.playSoundEffect("menu_select");
            m_subMenu.desc_txt.text = "";
            MenuController.CurrentCharacterSelectMenu = MenuController.onlineCharacterMenu;
            MenuController.specialModeMenu.show();
         }
      }
      
      private function arena_MOUSE_OVER(param1:MouseEvent) : void
      {
         if(Config.mode_arena)
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            m_subMenu.desc_txt.text = "A new type of competitive smash!";
         }
      }
      
      private function arena_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function arena_CLICK(param1:MouseEvent) : void
      {
         if(Config.mode_arena)
         {
            removeSelf();
            SoundQueue.instance.playSoundEffect("menu_selectstage");
            m_subMenu.desc_txt.text = "";
            MenuController.arenaMenu.show();
         }
      }
      
      private function back_CLICK_mode(param1:MouseEvent) : void
      {
         if(MultiplayerManager.Connected)
         {
            MultiplayerManager.leaveRoom();
            m_container.visible = false;
            SoundQueue.instance.playSoundEffect("menu_back");
            m_subMenu.desc_txt.text = "";
         }
         else
         {
            removeSelf();
            SoundQueue.instance.playSoundEffect("menu_back");
            m_subMenu.desc_txt.text = "";
            MenuController.mainMenu.show();
         }
      }
      
      private function back_ROLL_OVER_mode(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function onLeaveRoom(param1:MGNEvent) : void
      {
         removeSelf();
         m_container.visible = true;
         MenuController.onlineMenu.show();
         MenuController.onlineMenu.refreshRoomsList();
      }
      
      private function onLeaveRoomError(param1:MGNEvent) : void
      {
         m_container.visible = true;
      }
      
      private function updateDiscordPresenceForOnlineGroup() : void
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
               trace("[Discord OnlineGroup] No room key/code available yet");
               return;
            }
            _loc3_ = MultiplayerManager.RoomPassword;
            _loc4_ = int(MultiplayerManager.Players.length);
            _loc5_ = int(MultiplayerManager.ROOM_CAPACITY);
            _loc6_ = MenuController.buildDiscordJoinSecret(_loc1_,_loc2_,_loc3_,_loc5_);
            trace("[Discord OnlineGroup] Updating presence with join secret");
            trace("[Discord OnlineGroup] Room Key: " + _loc1_);
            trace("[Discord OnlineGroup] Room Code: " + _loc2_);
            trace("[Discord OnlineGroup] Join Secret: " + _loc6_);
            trace("[Discord OnlineGroup] Party: " + _loc4_ + "/" + _loc5_);
            _loc7_ = MultiplayerManager.DiscordPartyID;
            MenuController.updateDiscordPresence("In Online Lobby","Waiting for players",MenuController.getCurrentTimestamp(),0,"ssf2","Super Smash Flash 2","online",null,_loc7_,_loc4_,_loc5_,_loc1_,_loc6_);
            trace("[Discord OnlineGroup] Presence updated");
         }
         else
         {
            trace("[Discord OnlineGroup] Cannot update - ext: " + (Main.m_sdk != null) + ", connected: " + MultiplayerManager.Connected);
         }
      }
   }
}


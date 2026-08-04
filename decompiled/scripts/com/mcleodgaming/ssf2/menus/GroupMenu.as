package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.modapi.*;
   import com.mcleodgaming.ssf2.net.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   
   public class GroupMenu extends Menu
   {
      
      private var m_brawlNode:MenuMapperNode;
      
      private var m_rulesNode:MenuMapperNode;
      
      private var m_specialNode:MenuMapperNode;
      
      private var m_arenaNode:MenuMapperNode;
      
      public function GroupMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_group");
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
      
      override public function manageMenuMappings(param1:Event) : void
      {
         if(!(MenuController.rulesMenu && MenuController.rulesMenu.isOnscreen()))
         {
            super.manageMenuMappings(param1);
            return;
         }
         resetControlsLetGo();
      }
      
      override public function initMenuMappings() : void
      {
         this.m_brawlNode = new MenuMapperNode(m_subMenu.brawl_btn);
         this.m_rulesNode = new MenuMapperNode(m_subMenu.rules_btn);
         this.m_specialNode = new MenuMapperNode(m_subMenu.specialbrawl_btn);
         this.m_arenaNode = new MenuMapperNode(m_subMenu.arena_btn);
         this.m_brawlNode.updateNodes([this.m_rulesNode],[this.m_rulesNode],[this.m_specialNode],[this.m_specialNode],this.brawl_MOUSE_OVER,this.brawl_MOUSE_OUT,this.brawl_CLICK,this.back_CLICK_mode);
         this.m_rulesNode.updateNodes([this.m_brawlNode],[this.m_brawlNode],[this.m_arenaNode],[this.m_arenaNode],this.rules_MOUSE_OVER,this.rules_MOUSE_OUT,this.rules_CLICK,this.back_CLICK_mode);
         this.m_specialNode.updateNodes([this.m_arenaNode],[this.m_arenaNode],[this.m_brawlNode],[this.m_brawlNode],this.specialbrawl_MOUSE_OVER,this.specialbrawl_MOUSE_OUT,this.specialbrawl_CLICK,this.back_CLICK_mode);
         this.m_arenaNode.updateNodes([this.m_specialNode],[this.m_specialNode],[this.m_rulesNode,this.m_brawlNode],[this.m_rulesNode,this.m_brawlNode],this.arena_MOUSE_OVER,this.arena_MOUSE_OUT,this.arena_CLICK,this.back_CLICK_mode);
         m_menuMapper = new MenuMapper(this.m_brawlNode);
         m_menuMapper.init();
      }
      
      override public function show() : void
      {
         super.show();
         SoundQueue.instance.playMusic("menumusic",0);
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
         m_subMenu.rules_btn.addEventListener(MouseEvent.MOUSE_OVER,this.rules_MOUSE_OVER);
         m_subMenu.rules_btn.addEventListener(MouseEvent.MOUSE_OUT,this.rules_MOUSE_OUT);
         m_subMenu.rules_btn.addEventListener(MouseEvent.CLICK,this.rules_CLICK);
         m_subMenu.specialbrawl_btn.addEventListener(MouseEvent.MOUSE_OVER,this.specialbrawl_MOUSE_OVER);
         m_subMenu.specialbrawl_btn.addEventListener(MouseEvent.MOUSE_OUT,this.specialbrawl_MOUSE_OUT);
         m_subMenu.specialbrawl_btn.addEventListener(MouseEvent.CLICK,this.specialbrawl_CLICK);
         m_subMenu.arena_btn.addEventListener(MouseEvent.MOUSE_OVER,this.arena_MOUSE_OVER);
         m_subMenu.arena_btn.addEventListener(MouseEvent.MOUSE_OUT,this.arena_MOUSE_OUT);
         m_subMenu.arena_btn.addEventListener(MouseEvent.CLICK,this.arena_CLICK);
         m_subMenu.bg_top.home_btn.addEventListener(MouseEvent.CLICK,this.home_CLICK);
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,this.manageMenuMappings);
         setMenuMappingFocus();
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK_mode);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER_mode);
         m_subMenu.brawl_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.brawl_MOUSE_OVER);
         m_subMenu.brawl_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.brawl_MOUSE_OUT);
         m_subMenu.brawl_btn.removeEventListener(MouseEvent.CLICK,this.brawl_CLICK);
         m_subMenu.rules_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.rules_MOUSE_OVER);
         m_subMenu.rules_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.rules_MOUSE_OUT);
         m_subMenu.rules_btn.removeEventListener(MouseEvent.CLICK,this.rules_CLICK);
         m_subMenu.specialbrawl_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.specialbrawl_MOUSE_OVER);
         m_subMenu.specialbrawl_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.specialbrawl_MOUSE_OUT);
         m_subMenu.specialbrawl_btn.removeEventListener(MouseEvent.CLICK,this.specialbrawl_CLICK);
         m_subMenu.arena_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.arena_MOUSE_OVER);
         m_subMenu.arena_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.arena_MOUSE_OUT);
         m_subMenu.arena_btn.removeEventListener(MouseEvent.CLICK,this.arena_CLICK);
         m_subMenu.bg_top.home_btn.removeEventListener(MouseEvent.CLICK,this.home_CLICK);
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,this.manageMenuMappings);
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
         ModAPI.triggerMenuRumble(0);
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         m_subMenu.desc_txt.text = "";
         MenuController.CurrentCharacterSelectMenu = MenuController.vsMenu;
         MenuController.CurrentCharacterSelectMenu.reset();
         MenuController.CurrentCharacterSelectMenu.show();
         SoundQueue.instance.playVoiceEffect("narrator_choose");
      }
      
      private function rules_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Set the brawl rules before you fight!";
      }
      
      private function rules_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function rules_CLICK(param1:MouseEvent) : void
      {
         ModAPI.triggerMenuRumble(0);
         SoundQueue.instance.playSoundEffect("menu_select");
         m_subMenu.desc_txt.text = "";
         MenuController.rulesMenu.show();
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
            ModAPI.triggerMenuRumble(0);
            removeSelf();
            SoundQueue.instance.playSoundEffect("menu_select");
            m_subMenu.desc_txt.text = "";
            MenuController.CurrentCharacterSelectMenu = MenuController.vsMenu;
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
            ModAPI.triggerMenuRumble(0);
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
      
      private function home_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_back");
         SoundQueue.instance.stopMusic();
         MenuController.disposeAllMenus(true);
         MenuController.titleMenu.show();
      }
   }
}


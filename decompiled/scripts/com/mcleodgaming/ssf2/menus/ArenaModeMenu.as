package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.modapi.*;
   import com.mcleodgaming.ssf2.net.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   
   public class ArenaModeMenu extends Menu
   {
      
      public static var SELECTED_ARENA_MODE:String = null;
      
      private var m_soccerNode:MenuMapperNode;
      
      private var m_basketballNode:MenuMapperNode;
      
      public function ArenaModeMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_arena");
         m_backgroundID = "space";
         m_container.addChild(m_subMenu);
         m_subMenu.soccer_btn.y += 50;
         m_subMenu.basketball_btn.y += 50;
         this.initMenuMappings();
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
      }
      
      override public function manageMenuMappings(param1:Event) : void
      {
         super.manageMenuMappings(param1);
         if(m_lastControllerIndex >= 0)
         {
            ModAPI.triggerMenuRumble(m_lastControllerIndex);
         }
      }
      
      override public function initMenuMappings() : void
      {
         this.m_soccerNode = new MenuMapperNode(m_subMenu.soccer_btn);
         this.m_basketballNode = new MenuMapperNode(m_subMenu.basketball_btn);
         this.m_soccerNode.updateNodes([],[],[this.m_basketballNode],[this.m_basketballNode],this.soccer_MOUSE_OVER,this.clearDescription,this.soccer_CLICK,this.back_CLICK_arena,null,null);
         this.m_basketballNode.updateNodes([],[],[this.m_soccerNode],[this.m_soccerNode],this.basketball_MOUSE_OVER,this.clearDescription,this.basketball_CLICK,this.back_CLICK_arena,null,null);
         m_menuMapper = new MenuMapper(this.m_soccerNode);
         m_menuMapper.init();
      }
      
      override public function show() : void
      {
         super.show();
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
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK_arena);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER_multiman);
         m_subMenu.soccer_btn.addEventListener(MouseEvent.CLICK,this.soccer_CLICK);
         m_subMenu.soccer_btn.addEventListener(MouseEvent.MOUSE_OVER,this.soccer_MOUSE_OVER);
         m_subMenu.soccer_btn.addEventListener(MouseEvent.MOUSE_OUT,this.clearDescription);
         m_subMenu.basketball_btn.addEventListener(MouseEvent.CLICK,this.basketball_CLICK);
         m_subMenu.basketball_btn.addEventListener(MouseEvent.MOUSE_OVER,this.basketball_MOUSE_OVER);
         m_subMenu.basketball_btn.addEventListener(MouseEvent.MOUSE_OUT,this.clearDescription);
         if(m_subMenu.volleyball_btn)
         {
            m_subMenu.volleyball_btn.visible = false;
         }
         if(m_subMenu.dodgeball_btn)
         {
            m_subMenu.dodgeball_btn.visible = false;
         }
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,this.manageMenuMappings);
         setMenuMappingFocus();
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK_arena);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER_multiman);
         m_subMenu.soccer_btn.removeEventListener(MouseEvent.CLICK,this.soccer_CLICK);
         m_subMenu.soccer_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.soccer_MOUSE_OVER);
         m_subMenu.soccer_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.clearDescription);
         m_subMenu.basketball_btn.removeEventListener(MouseEvent.CLICK,this.basketball_CLICK);
         m_subMenu.basketball_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.basketball_MOUSE_OVER);
         m_subMenu.basketball_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.clearDescription);
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,this.manageMenuMappings);
      }
      
      private function clearDescription(param1:* = null) : void
      {
         if(m_subMenu.desc_txt != null)
         {
            m_subMenu.desc_txt.text = "";
         }
      }
      
      private function soccer_CLICK(param1:MouseEvent) : void
      {
         ModAPI.triggerMenuRumble(0);
         ArenaModeMenu.SELECTED_ARENA_MODE = "soccer";
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         MenuController.CurrentCharacterSelectMenu = MenuController.arenaCharacterSelectMenu;
         MenuController.CurrentCharacterSelectMenu.reset();
         MenuController.CurrentCharacterSelectMenu.show();
         SoundQueue.instance.playVoiceEffect("narrator_choose");
      }
      
      private function soccer_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Kick sandbag into a soccer goal!";
      }
      
      private function basketball_CLICK(param1:MouseEvent) : void
      {
         ModAPI.triggerMenuRumble(0);
         ArenaModeMenu.SELECTED_ARENA_MODE = "basketball";
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         MenuController.CurrentCharacterSelectMenu = MenuController.arenaCharacterSelectMenu;
         MenuController.CurrentCharacterSelectMenu.reset();
         MenuController.CurrentCharacterSelectMenu.show();
         SoundQueue.instance.playVoiceEffect("narrator_choose");
      }
      
      private function basketball_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Shoot sandbag through a basketball net!";
      }
      
      private function back_CLICK_arena(param1:MouseEvent) : void
      {
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_back");
         if(MultiplayerManager.Connected)
         {
            MenuController.onlineGroupMenu.show();
         }
         else
         {
            MenuController.groupMenu.show();
         }
      }
      
      private function back_ROLL_OVER_multiman(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
   }
}


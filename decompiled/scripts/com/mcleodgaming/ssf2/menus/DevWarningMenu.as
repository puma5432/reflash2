package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   
   public class DevWarningMenu extends Menu
   {
      
      private var m_skipNode:MenuMapperNode;
      
      public function DevWarningMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_dev_warning");
         m_subMenu.stop();
         m_container.addChild(m_subMenu);
         this.initMenuMappings();
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
      }
      
      override public function initMenuMappings() : void
      {
         this.m_skipNode = new MenuMapperNode(m_subMenu);
         this.m_skipNode.updateNodes(null,null,null,null,null,null,this.skipDisclaimer,this.skipDisclaimer);
         m_menuMapper = new MenuMapper(this.m_skipNode);
         m_menuMapper.init();
      }
      
      override public function makeEvents() : void
      {
         if(m_showCount == 0)
         {
            findSubMenuButtons();
         }
         super.makeEvents();
         Main.Root.stage.addEventListener(MouseEvent.CLICK,this.skipDisclaimer);
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,manageMenuMappings);
         m_subMenu.gotoAndPlay(1);
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         Main.Root.stage.removeEventListener(MouseEvent.CLICK,this.skipDisclaimer);
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,manageMenuMappings);
      }
      
      private function skipDisclaimer(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         m_subMenu.gotoAndStop(1);
         removeSelf();
      }
   }
}


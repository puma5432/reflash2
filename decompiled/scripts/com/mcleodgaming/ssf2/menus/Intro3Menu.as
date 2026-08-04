package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   
   public class Intro3Menu extends Menu
   {
      
      private var waitASec:Boolean;
      
      private var m_skipNode:MenuMapperNode;
      
      private var m_vault:Boolean;
      
      private var m_showedTitle:Boolean;
      
      public function Intro3Menu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("ssf2intro_beta");
         this.m_vault = false;
         this.m_showedTitle = false;
         if(m_subMenu)
         {
            m_subMenu.stop();
            m_container.addChild(m_subMenu);
            this.initMenuMappings();
            m_subMenu.x = Main.Width / 2;
            m_subMenu.y = Main.Height / 2;
         }
         this.waitASec = true;
      }
      
      public function setVault(param1:Boolean) : void
      {
         this.m_vault = param1;
      }
      
      override public function initMenuMappings() : void
      {
         this.m_skipNode = new MenuMapperNode(m_subMenu);
         this.m_skipNode.updateNodes(null,null,null,null,null,null,this.endIntro,this.endIntro);
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
         if(m_subMenu == null)
         {
            removeSelf();
            MenuController.disposeAllMenus(true);
            MenuController.titleMenu.show();
         }
         else
         {
            m_subMenu.visible = true;
            Main.Root.stage.addEventListener(MouseEvent.CLICK,this.endIntro);
            Main.Root.stage.addEventListener(Event.ENTER_FRAME,this.checkIntro);
            Main.Root.stage.addEventListener(Event.ENTER_FRAME,manageMenuMappings);
         }
         this.m_showedTitle = false;
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         if(m_subMenu)
         {
            Main.Root.stage.removeEventListener(MouseEvent.CLICK,this.endIntro);
            Main.Root.stage.removeEventListener(Event.ENTER_FRAME,this.checkIntro);
            Main.Root.stage.removeEventListener(Event.ENTER_FRAME,manageMenuMappings);
         }
      }
      
      private function endIntro(param1:MouseEvent) : void
      {
         if(!this.waitASec)
         {
            SoundQueue.instance.playSoundEffect("menu_back");
            this.toTitle();
         }
      }
      
      private function toTitle() : void
      {
         removeSelf();
         if(m_subMenu)
         {
            m_subMenu.gotoAndStop(1);
         }
         if(this.m_vault)
         {
            MenuController.vaultMenu.show();
         }
         else if(this.m_showedTitle)
         {
            MenuController.titleMenu.makeEvents();
         }
         else
         {
            MenuController.titleMenu.show();
         }
      }
      
      private function checkIntro(param1:Event) : void
      {
         if(this.m_vault)
         {
            if(m_subMenu.currentFrame >= m_subMenu.totalFrames)
            {
               this.toTitle();
            }
         }
         else if(m_subMenu.currentFrame === 3361)
         {
            m_subMenu.visible = false;
            Main.Root.stage.addEventListener(Event.ADDED,moveToFront);
            MenuController.titleMenu.show();
            MenuController.titleMenu.killEvents();
            Main.Root.stage.removeEventListener(Event.ADDED,moveToFront);
            this.m_showedTitle = true;
         }
         else if(m_subMenu.currentFrame >= 3593)
         {
            this.toTitle();
         }
         this.waitASec = false;
      }
      
      override public function show() : void
      {
         this.waitASec = true;
         if(m_subMenu)
         {
            m_subMenu.gotoAndPlay(1);
            super.show();
         }
         else
         {
            this.toTitle();
         }
      }
   }
}


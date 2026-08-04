package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.events.*;
   
   public class IntroMenu extends Menu
   {
      
      private var waitASec:Boolean;
      
      private var m_skipNode:MenuMapperNode;
      
      private var m_bars:MovieClip;
      
      public function IntroMenu()
      {
         super();
         this.m_bars = new MovieClip();
         this.m_bars.graphics.beginFill(0,1);
         this.m_bars.graphics.drawRect(-10,-10,65,Main.Height + 20);
         this.m_bars.graphics.drawRect(Main.Width - 55,-10,Main.Width - 65,Main.Height + 20);
         this.m_bars.graphics.endFill();
         m_subMenu = ResourceManager.getLibraryMC("ssf2intro_v8");
         if(m_subMenu)
         {
            m_subMenu.stop();
            m_container.addChild(m_subMenu);
            m_subMenu.scaleX = 0.95;
            m_subMenu.scaleY = 0.95;
            m_subMenu.x = Main.Width / 2;
            m_subMenu.y = Main.Height / 2;
            this.initMenuMappings();
         }
         m_container.addChild(this.m_bars);
         this.waitASec = true;
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
            MenuController.titleMenu.show();
         }
         else
         {
            Main.Root.stage.addEventListener(MouseEvent.CLICK,this.endIntro);
            Main.Root.stage.addEventListener(Event.ENTER_FRAME,this.checkIntro);
            Main.Root.stage.addEventListener(Event.ENTER_FRAME,manageMenuMappings);
         }
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
            m_subMenu.stop();
            SoundQueue.instance.playSoundEffect("menu_back");
            this.toVault();
         }
      }
      
      private function toVault() : void
      {
         removeSelf();
         if(m_subMenu)
         {
            m_subMenu.stop();
         }
         MenuController.vaultMenu.show();
      }
      
      private function checkIntro(param1:Event) : void
      {
         if(m_subMenu.currentFrame >= m_subMenu.totalFrames - 1)
         {
            m_subMenu.stop();
            MenuController.vaultMenu.show();
            removeSelf();
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
            this.toVault();
         }
      }
   }
}


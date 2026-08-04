package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.net.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   
   public class OnlinePromptMenu extends Menu
   {
      
      public var onAccept:Function = null;
      
      public var onDismiss:Function = null;
      
      public var message:String = "";
      
      public var data:Object;
      
      private var m_yesNode:MenuMapperNode;
      
      private var m_noNode:MenuMapperNode;
      
      public function OnlinePromptMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_online_prompt");
         m_container.addChild(m_subMenu);
         m_fillBackground = false;
         this.initMenuMappings();
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
      }
      
      override public function initMenuMappings() : void
      {
         this.m_yesNode = new MenuMapperNode(m_subMenu.yesBtn);
         this.m_noNode = new MenuMapperNode(m_subMenu.noBtn);
         this.m_yesNode.updateNodes(null,null,[this.m_noNode],[this.m_noNode],null,null,this.yes_CLICK,this.no_CLICK);
         this.m_noNode.updateNodes(null,null,[this.m_yesNode],[this.m_yesNode],null,null,this.no_CLICK,this.no_CLICK);
         m_menuMapper = new MenuMapper(this.m_yesNode);
         m_menuMapper.init();
      }
      
      override public function makeEvents() : void
      {
         super.makeEvents();
         resetAllButtons();
         m_subMenu.yesBtn.addEventListener(MouseEvent.CLICK,this.yes_CLICK);
         m_subMenu.noBtn.addEventListener(MouseEvent.CLICK,this.no_CLICK);
         m_subMenu.promptText.text = this.message;
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,manageMenuMappings);
         Main.Root.addEventListener(Event.ADDED,moveToFront);
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.yesBtn.removeEventListener(MouseEvent.CLICK,this.yes_CLICK);
         m_subMenu.noBtn.removeEventListener(MouseEvent.CLICK,this.no_CLICK);
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,manageMenuMappings);
         Main.Root.removeEventListener(Event.ADDED,moveToFront);
         this.onAccept = null;
         this.onDismiss = null;
         this.message = "";
         this.data = null;
      }
      
      private function yes_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         if(this.onAccept !== null)
         {
            this.onAccept();
         }
      }
      
      private function no_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_back");
         if(this.onDismiss !== null)
         {
            this.onDismiss();
         }
      }
   }
}


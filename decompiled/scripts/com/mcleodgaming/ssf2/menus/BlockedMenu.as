package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   
   public class BlockedMenu extends Menu
   {
      
      public function BlockedMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_blocked");
         m_container.addChild(m_subMenu);
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
      }
      
      override public function makeEvents() : void
      {
         if(m_showCount == 0)
         {
            findSubMenuButtons();
         }
         super.makeEvents();
         m_subMenu.mglink.addEventListener(MouseEvent.CLICK,this.callLink);
         Main.Root.addEventListener(Event.ADDED,moveToFront);
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.mglink.removeEventListener(MouseEvent.CLICK,this.callLink);
         Main.Root.removeEventListener(Event.ADDED,moveToFront);
      }
      
      private function callLink(param1:*) : void
      {
         var e:* = param1;
         var url:String = "https://www.supersmashflash.com";
         try
         {
            Main.getURL(url,"_blank");
         }
         catch(e:Error)
         {
            trace("Error occurred calling MG URL!");
         }
      }
   }
}


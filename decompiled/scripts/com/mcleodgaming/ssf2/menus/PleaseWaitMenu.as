package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.util.*;
   
   public class PleaseWaitMenu extends Menu
   {
      
      public function PleaseWaitMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_pleasewait");
         m_container.addChild(m_subMenu);
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
      }
      
      override public function makeEvents() : void
      {
         super.makeEvents();
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
      }
   }
}


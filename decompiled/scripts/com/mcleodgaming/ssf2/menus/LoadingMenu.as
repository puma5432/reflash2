package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.util.*;
   
   public class LoadingMenu extends Menu
   {
      
      public function LoadingMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("loadingMask");
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


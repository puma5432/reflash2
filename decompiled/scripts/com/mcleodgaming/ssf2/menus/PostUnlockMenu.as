package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   
   public class PostUnlockMenu extends Menu
   {
      
      private var ready:Boolean;
      
      private var m_keyLetGo:Boolean;
      
      private var m_delay:FrameTimer;
      
      public function PostUnlockMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_postunlock");
         m_subMenu.stop();
         this.ready = false;
         m_container.addChild(m_subMenu);
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         this.m_keyLetGo = false;
         this.m_delay = new FrameTimer(60);
      }
      
      override public function makeEvents() : void
      {
         if(m_showCount == 0)
         {
            findSubMenuButtons();
         }
         super.makeEvents();
         m_subMenu.addEventListener(MouseEvent.CLICK,this.CLICKED);
         m_subMenu.addEventListener(Event.ENTER_FRAME,this.nextUnlock);
         this.m_keyLetGo = false;
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.removeEventListener(MouseEvent.CLICK,this.CLICKED);
         m_subMenu.removeEventListener(Event.ENTER_FRAME,this.nextUnlock);
      }
      
      override public function show() : void
      {
         if(UnlockController.pendingUnlockScreens.length > 0)
         {
            Utils.tryToGotoAndStop(m_subMenu,UnlockController.pendingUnlockScreens[0].ID);
            UnlockController.pendingUnlockScreens[0].unlock();
            SoundQueue.instance.playSoundEffect("menu_unlock");
            UnlockController.pendingUnlockScreens.shift();
         }
         SoundQueue.instance.stopMusic();
         super.show();
         this.m_delay.reset();
      }
      
      private function CLICKED(param1:MouseEvent) : void
      {
         this.ready = true;
      }
      
      private function nextUnlock(param1:Event) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         this.m_delay.tick();
         if(!this.m_delay.IsComplete)
         {
            return;
         }
         while(_loc3_ < SaveData.Controllers.length && !this.ready)
         {
            if(SaveData.Controllers[_loc3_] != null)
            {
               if(SaveData.Controllers[_loc3_].IsDown(SaveData.Controllers[_loc3_]._BUTTON2))
               {
                  if(this.m_keyLetGo)
                  {
                     this.ready = true;
                  }
                  _loc2_ = true;
               }
            }
            _loc3_++;
         }
         if(!_loc2_)
         {
            this.m_keyLetGo = true;
         }
         if(this.ready)
         {
            this.ready = false;
            SoundQueue.instance.playSoundEffect("menu_select");
            if(UnlockController.pendingUnlockScreens.length > 0)
            {
               removeSelf();
               MenuController.postUnlockMenu.show();
            }
            else if(UnlockController.pendingUnlockFights.length > 0)
            {
               removeSelf();
               MenuController.preUnlockMenu.show();
            }
            else
            {
               removeSelf();
               UnlockController.nextMenuFunc();
            }
         }
      }
   }
}


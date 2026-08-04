package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   import flash.geom.*;
   
   public class CreditsMenu extends Menu
   {
      
      private var start_y:Number;
      
      private var max_y:Number;
      
      private var credits_orig_y:Number;
      
      private var isDragging:Boolean;
      
      public function CreditsMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_credits");
         m_backgroundID = "space";
         this.start_y = m_subMenu.scrollbar.y;
         this.max_y = 133 - m_subMenu.scrollbar.height;
         this.credits_orig_y = m_subMenu.credits_mc.y;
         this.isDragging = false;
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
         m_subMenu.scrollbar.addEventListener(MouseEvent.MOUSE_DOWN,this.scroll_START);
         m_subMenu.stage.addEventListener(MouseEvent.MOUSE_UP,this.scroll_STOP);
         m_subMenu.addEventListener(MouseEvent.MOUSE_MOVE,this.scroll_MOVE);
         m_subMenu.back_btn.addEventListener(MouseEvent.CLICK,this.back_GO);
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.scrollbar.removeEventListener(MouseEvent.MOUSE_DOWN,this.scroll_START);
         m_subMenu.stage.removeEventListener(MouseEvent.MOUSE_UP,this.scroll_STOP);
         m_subMenu.removeEventListener(MouseEvent.MOUSE_MOVE,this.scroll_MOVE);
         m_subMenu.back_btn.removeEventListener(MouseEvent.CLICK,this.back_GO);
      }
      
      private function scroll_START(param1:Event) : void
      {
         if(!this.isDragging)
         {
            this.isDragging = true;
            m_subMenu.scrollbar.startDrag(false,new Rectangle(m_subMenu.scrollbar.x,this.start_y,0,this.max_y - this.start_y));
         }
      }
      
      private function scroll_STOP(param1:Event) : void
      {
         if(this.isDragging)
         {
            this.isDragging = false;
            m_subMenu.scrollbar.stopDrag();
         }
      }
      
      private function scroll_MOVE(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         if(this.isDragging)
         {
            _loc2_ = (m_subMenu.scrollbar.y - this.start_y) / (this.max_y - this.start_y);
            m_subMenu.credits_mc.y = this.credits_orig_y - _loc2_ * (m_subMenu.credits_mc.height - 15 - 855);
         }
      }
      
      private function back_GO(param1:Event) : void
      {
         removeSelf();
      }
      
      override public function show() : void
      {
         m_subMenu.scrollbar.y = this.start_y;
         m_subMenu.credits_mc.y = this.credits_orig_y;
         super.show();
      }
   }
}


package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   
   public class NewsArticleMenu extends Menu
   {
      
      private var m_customMenu:CustomAPIMenu;
      
      private var selectHand:SelectHand;
      
      public function NewsArticleMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_newsarticle");
         m_backgroundID = "space";
         m_container.addChild(m_subMenu);
         initMenuMappings();
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
      }
      
      override public function makeEvents() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         resetAllButtons();
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER);
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,manageMenuMappings);
         setMenuMappingFocus();
         this.m_customMenu = new CustomAPIMenu({"classAPI":MenuController.newsMenu.CurrentNewsArticle.menuClass});
         this.m_customMenu.show();
         this.selectHand = new SelectHand(this.m_customMenu.Container,new Vector.<HandButton>(),this.back_CLICK);
         this.selectHand.addClickEventClipHitTest(m_subMenu.bg_top.back_btn);
         this.selectHand.makeEvents();
         while(_loc3_ < this.m_customMenu.Container.numChildren)
         {
            if(this.m_customMenu.Container.getChildAt(_loc3_) is MovieClip)
            {
               _loc1_ = MovieClip(this.m_customMenu.Container.getChildAt(_loc3_));
               _loc2_ = 0;
               while(_loc2_ < _loc1_.numChildren)
               {
                  if(_loc1_.getChildAt(_loc2_) is MovieClip && Boolean(MovieClip(_loc1_.getChildAt(_loc2_)).buttonMode) || _loc1_.getChildAt(_loc2_) is SimpleButton)
                  {
                     this.selectHand.addClickEventClipHitTest(_loc1_.getChildAt(_loc2_));
                  }
                  _loc2_++;
               }
            }
            _loc3_++;
         }
         this.selectHand.resetPosition(new Point(320,240),new Rectangle(10,10,630,350));
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         this.selectHand.killEvents();
         this.selectHand = null;
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER);
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,manageMenuMappings);
         this.m_customMenu.removeSelf();
         this.m_customMenu.APIInstance.dispose();
      }
      
      private function back_CLICK(param1:MouseEvent) : void
      {
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_back");
         MenuController.newsMenu.show();
      }
      
      private function back_ROLL_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
   }
}


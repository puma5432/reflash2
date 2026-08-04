package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   
   public class NewsMenu extends Menu
   {
      
      private var m_currentEntry:Object;
      
      private var m_entries:Array;
      
      private var m_newsButtons:Vector.<NewsButton>;
      
      private var newsSelectHand:NewsMenuHand;
      
      private var m_listLocation:Point;
      
      private var m_newsContainer:MovieClip;
      
      private var m_newsMask:MovieClip;
      
      private var m_isDragging:Boolean;
      
      private var m_scrollTop:Point;
      
      private var m_scrollHeight:Number;
      
      public function NewsMenu()
      {
         var _loc1_:int = 0;
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_news");
         m_backgroundID = "space";
         m_container.addChild(m_subMenu);
         this.m_currentEntry = null;
         initMenuMappings();
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         this.m_scrollTop = new Point(m_subMenu.scroller.x,m_subMenu.scroller.y);
         this.m_scrollHeight = 197 - m_subMenu.scroller.height;
         this.m_isDragging = false;
         this.m_listLocation = new Point(-260,-30);
         this.m_newsMask = new MovieClip();
         this.m_newsMask.x = this.m_listLocation.x - 10;
         this.m_newsMask.y = this.m_listLocation.y - 10;
         this.m_newsMask.graphics.beginFill(16711680,1);
         this.m_newsMask.graphics.drawRect(0,0,576 + 20,190 + 20);
         this.m_newsMask.graphics.endFill();
         this.m_newsMask.visible = false;
         this.m_newsContainer = new MovieClip();
         this.m_newsContainer.x = this.m_listLocation.x;
         this.m_newsContainer.y = this.m_listLocation.y;
         this.m_entries = new Array();
         if(ResourceManager.getResourceByID("menu_news").Loaded)
         {
            this.m_entries = ResourceManager.getResourceByID("menu_news").getProp("entries") || new Array();
         }
         this.m_newsButtons = new Vector.<NewsButton>();
         while(_loc1_ < this.m_entries.length)
         {
            this.m_newsButtons.push(new NewsButton(ResourceManager.getLibraryMC("newsItemMC")));
            this.m_newsContainer.addChildAt(this.m_newsButtons[_loc1_].ButtonInstance,0);
            _loc1_++;
         }
         m_subMenu.addChild(this.m_newsContainer);
         m_subMenu.addChild(this.m_newsMask);
         this.m_newsContainer.mask = this.m_newsMask;
         this.newsSelectHand = new NewsMenuHand(m_subMenu,this.m_newsButtons,this.back_CLICK);
         this.newsSelectHand.topBoundPush = this.handPushListUpHelper;
         this.newsSelectHand.bottomBoundPush = this.handPushListDownHelper;
         this.newsSelectHand.addClickEventClipHitTest(m_subMenu.bg_top.back_btn);
      }
      
      public static function getLatestHeadline() : Object
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         if(ResourceManager.getResourceByID("menu_news").Loaded)
         {
            _loc1_ = ResourceManager.getResourceByID("menu_news").getProp("entries") || new Array();
            _loc2_ = 0;
            while(_loc2_ < _loc1_.length)
            {
               if(!_loc3_)
               {
                  _loc3_ = _loc1_[_loc2_].title || "Problem loading latest headline";
                  _loc4_ = !SaveData.Once.newsRead[_loc1_[_loc2_].id];
               }
               else if(!SaveData.Once.newsRead[_loc1_[_loc2_].id])
               {
                  _loc3_ = _loc1_[_loc2_].title || "Problem loading latest headline";
                  _loc4_ = !SaveData.Once.newsRead[_loc1_[_loc2_].id];
                  break;
               }
               _loc2_++;
            }
         }
         return {
            "text":_loc3_ || "No news currently available",
            "unread":_loc4_
         };
      }
      
      public function get CurrentNewsArticle() : Object
      {
         return this.m_currentEntry;
      }
      
      override public function show() : void
      {
         super.show();
         SoundQueue.instance.playMusic("menumusic",0);
      }
      
      override public function makeEvents() : void
      {
         var _loc2_:int = 0;
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         resetAllButtons();
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER);
         m_subMenu.scroller.addEventListener(MouseEvent.MOUSE_DOWN,this.scroll_CLICK);
         m_subMenu.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.scroll_MOVE);
         m_subMenu.addEventListener(MouseEvent.MOUSE_UP,this.scroll_RELEASE);
         this.newsSelectHand.makeEvents();
         var _loc1_:Number = 0;
         while(_loc2_ < this.m_entries.length)
         {
            this.m_newsButtons[_loc2_].ButtonInstance.status.gotoAndStop(SaveData.Once.newsRead[this.m_entries[_loc2_].id] ? "read" : "new");
            this.m_newsButtons[_loc2_].ButtonInstance.title.text = this.m_entries[_loc2_].title;
            this.m_newsButtons[_loc2_].ButtonInstance.y = _loc1_ * 23;
            this.m_newsButtons[_loc2_].ButtonInstance.addEventListener(MouseEvent.CLICK,this.news_CLICK);
            this.m_newsButtons[_loc2_].ButtonInstance.addEventListener(MouseEvent.MOUSE_OVER,this.news_MOUSE_OVER);
            this.m_newsButtons[_loc2_].ButtonInstance.addEventListener(MouseEvent.MOUSE_OUT,this.news_MOUSE_OUT);
            this.m_newsButtons[_loc2_].makeEvents();
            _loc2_++;
            _loc1_++;
         }
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,manageMenuMappings);
         setMenuMappingFocus();
      }
      
      override public function killEvents() : void
      {
         var _loc1_:int = 0;
         super.killEvents();
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER);
         m_subMenu.scroller.removeEventListener(MouseEvent.MOUSE_DOWN,this.scroll_CLICK);
         m_subMenu.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.scroll_MOVE);
         m_subMenu.removeEventListener(MouseEvent.MOUSE_UP,this.scroll_RELEASE);
         this.newsSelectHand.killEvents();
         while(_loc1_ < this.m_entries.length)
         {
            this.m_newsButtons[_loc1_].ButtonInstance.visible = true;
            this.m_newsButtons[_loc1_].killEvents();
            this.m_newsButtons[_loc1_].ButtonInstance.removeEventListener(MouseEvent.CLICK,this.news_CLICK);
            this.m_newsButtons[_loc1_].ButtonInstance.removeEventListener(MouseEvent.MOUSE_OVER,this.news_MOUSE_OVER);
            this.m_newsButtons[_loc1_].ButtonInstance.removeEventListener(MouseEvent.MOUSE_OUT,this.news_MOUSE_OUT);
            _loc1_++;
         }
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,manageMenuMappings);
      }
      
      private function findNewsArticle(param1:MovieClip) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.m_newsButtons.length)
         {
            if(this.m_newsButtons[_loc2_].ButtonInstance == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function news_CLICK(param1:MouseEvent) : void
      {
         var _loc2_:int = int(this.findNewsArticle(param1.target as MovieClip));
         if(_loc2_ >= 0 && _loc2_ < this.m_entries.length)
         {
            this.m_currentEntry = this.m_entries[_loc2_];
            removeSelf();
            SoundQueue.instance.playSoundEffect("menu_select");
            MenuController.newsArticleMenu.show();
            MenuController.newsArticleMenu.SubMenu.shortTitle.text = this.m_currentEntry.shortTitle.toUpperCase();
            SaveData.Once.newsRead[this.m_currentEntry.id] = true;
         }
      }
      
      public function news_MOUSE_OVER(param1:MouseEvent) : void
      {
         var _loc2_:int = int(this.findNewsArticle(param1.target as MovieClip));
         if(_loc2_ >= 0 && _loc2_ < this.m_entries.length)
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            this.m_currentEntry = this.m_entries[_loc2_];
            while(m_subMenu.thumbnail.contents.numChildren > 0)
            {
               m_subMenu.thumbnail.contents.removeChildAt(0);
            }
            if(this.m_currentEntry.thumbnailMC)
            {
               m_subMenu.thumbnail.contents.addChild(new (this.m_currentEntry.thumbnailMC as Class)());
            }
            m_subMenu.thumbnail.title.text = this.m_currentEntry.title;
         }
      }
      
      public function news_MOUSE_OUT(param1:MouseEvent) : void
      {
         var _loc2_:int = int(this.findNewsArticle(param1.target as MovieClip));
         if(_loc2_ >= 0)
         {
            this.m_currentEntry = null;
            while(m_subMenu.thumbnail.contents.numChildren > 0)
            {
               m_subMenu.thumbnail.contents.removeChildAt(0);
            }
            m_subMenu.thumbnail.title.text = "";
         }
      }
      
      public function scroll_CLICK(param1:MouseEvent) : void
      {
         if(!this.m_isDragging)
         {
            MovieClip(m_subMenu.scroller).startDrag(false,new Rectangle(this.m_scrollTop.x,this.m_scrollTop.y,0,this.m_scrollHeight));
            this.m_isDragging = true;
         }
      }
      
      public function scroll_MOVE(param1:MouseEvent) : void
      {
         if(this.m_isDragging)
         {
            this.repositionList();
         }
      }
      
      public function scroll_RELEASE(param1:MouseEvent) : void
      {
         if(this.m_isDragging)
         {
            MovieClip(m_subMenu.scroller).stopDrag();
            this.m_isDragging = false;
         }
      }
      
      private function repositionList() : void
      {
         var _loc1_:Number = (m_subMenu.scroller.y - this.m_scrollTop.y) / this.m_scrollHeight;
         if(_loc1_ < 0.01)
         {
            _loc1_ = 0;
         }
         else if(_loc1_ > 0.99)
         {
            _loc1_ = 1;
         }
         var _loc2_:Number = 23;
         this.m_newsContainer.y = this.m_listLocation.y - _loc1_ * (_loc2_ * Math.max(0,this.m_entries.length - 5));
      }
      
      private function handPushListUpHelper() : void
      {
         m_subMenu.scroller.y -= 4;
         if(m_subMenu.scroller.y < this.m_scrollTop.y)
         {
            m_subMenu.scroller.y = this.m_scrollTop.y;
         }
         this.repositionList();
      }
      
      private function handPushListDownHelper() : void
      {
         m_subMenu.scroller.y += 4;
         if(m_subMenu.scroller.y > this.m_scrollTop.y + this.m_scrollHeight)
         {
            m_subMenu.scroller.y = this.m_scrollTop.y + this.m_scrollHeight;
         }
         this.repositionList();
      }
      
      private function back_CLICK(param1:MouseEvent) : void
      {
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_back");
         MenuController.mainMenu.show();
         SaveData.saveGame();
      }
      
      private function back_ROLL_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
   }
}


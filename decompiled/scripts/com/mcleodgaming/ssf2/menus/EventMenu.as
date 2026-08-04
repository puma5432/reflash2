package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.modapi.*;
   import com.mcleodgaming.ssf2.modes.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   
   public class EventMenu extends Menu
   {
      
      private var m_isDragging:Boolean;
      
      private var m_currentEvent:Object;
      
      private var m_eventContainer:MovieClip;
      
      private var m_eventMask:MovieClip;
      
      private var m_eventButtons:Vector.<EventButton>;
      
      private var m_listLocation:Point;
      
      private var m_scrollTop:Point;
      
      private var m_scrollHeight:Number;
      
      private var eventSelectHand:EventMenuHand;
      
      private var m_events:Array;
      
      private var m_game:Game;
      
      private var m_modeInstance:EventMode;
      
      private var m_unlockIcon:MovieClip;
      
      public function EventMenu()
      {
         var _loc1_:int = 0;
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_event");
         m_backgroundID = "space";
         m_container.addChild(m_subMenu);
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         this.m_game = null;
         this.m_modeInstance = null;
         this.m_currentEvent = null;
         this.m_listLocation = new Point(-235.1,-120.2);
         this.m_eventMask = new MovieClip();
         this.m_eventMask.x = -286.35;
         this.m_eventMask.y = -125.85;
         this.m_eventMask.graphics.beginFill(16711680,1);
         this.m_eventMask.graphics.drawRect(0,0,500,255);
         this.m_eventMask.graphics.endFill();
         this.m_eventMask.visible = false;
         this.m_eventContainer = new MovieClip();
         this.m_eventContainer.x = this.m_listLocation.x;
         this.m_eventContainer.y = this.m_listLocation.y;
         this.m_events = ResourceManager.getResourceByID("event_mode").getProp("eventList");
         this.m_unlockIcon = ResourceManager.getLibraryMC("eventIconMC");
         this.m_unlockIcon.alpha = 0.75;
         this.m_unlockIcon.complete.visible = false;
         this.m_eventButtons = new Vector.<EventButton>();
         _loc1_ = 0;
         while(_loc1_ < this.m_events.length)
         {
            this.m_eventButtons.push(new EventButton(ResourceManager.getLibraryMC("eventIconMC")));
            this.m_eventContainer.addChild(this.m_eventButtons[_loc1_].ButtonInstance);
            _loc1_++;
         }
         this.reset();
         m_subMenu.addChild(this.m_eventContainer);
         m_subMenu.addChild(this.m_eventMask);
         this.m_eventContainer.mask = this.m_eventMask;
         this.m_scrollTop = new Point(m_subMenu.scroller.x,m_subMenu.scroller.y);
         this.m_scrollHeight = 213;
         m_subMenu.sample.visible = false;
         this.m_isDragging = false;
         this.eventSelectHand = new EventMenuHand(m_subMenu,this.m_eventButtons,this.backMain_CLICK);
         this.eventSelectHand.topBoundPush = this.handPushListUpHelper;
         this.eventSelectHand.bottomBoundPush = this.handPushListDownHelper;
         m_subMenu.setChildIndex(this.eventSelectHand.HandMC,m_subMenu.numChildren - 1);
         this.eventSelectHand.addClickEventClipHitTest(m_subMenu.bg_top.back_btn);
      }
      
      public function get CurrentEvent() : Object
      {
         return this.m_currentEvent;
      }
      
      public function reset() : void
      {
         this.m_currentEvent = null;
         this.updateDisplay();
      }
      
      private function getEventNumString(param1:Object) : String
      {
         var _loc4_:int = 0;
         var _loc2_:int = 1;
         var _loc3_:int = 1;
         while(_loc4_ < this.m_events.length)
         {
            if(this.m_events[_loc4_] === param1)
            {
               return this.m_events[_loc4_].allStar ? "All-Star # " + _loc3_ : "#" + _loc2_;
            }
            if(this.m_events[_loc4_].allStar)
            {
               _loc3_++;
            }
            else
            {
               _loc2_++;
            }
            _loc4_++;
         }
         return "---";
      }
      
      public function updateDisplay() : void
      {
         if(this.m_eventButtons.length > 0 && Boolean(this.m_currentEvent))
         {
            m_subMenu.eventNum.text = this.getEventNumString(this.m_currentEvent);
            m_subMenu.eventName.text = this.m_currentEvent.name;
            m_subMenu.eventDesc.text = this.m_currentEvent.description;
            if(SaveData.Records.events.wins[this.m_currentEvent.id])
            {
               m_subMenu.rank_txt.text = SaveData.Records.events.wins[this.m_currentEvent.id].rank;
               if(SaveData.Records.events.wins[this.m_currentEvent.id].scoreType === "time")
               {
                  m_subMenu.desc_txt.text = Utils.framesToTimeString(SaveData.Records.events.wins[this.m_currentEvent.id].score) + " (Avg. FPS: " + SaveData.Records.events.wins[this.m_currentEvent.id].fps + ")";
               }
               else if(SaveData.Records.events.wins[this.m_currentEvent.id].scoreType === "points")
               {
                  m_subMenu.desc_txt.text = SaveData.Records.events.wins[this.m_currentEvent.id].score + " Points (Avg. FPS: " + SaveData.Records.events.wins[this.m_currentEvent.id].fps + ")";
               }
               else if(SaveData.Records.events.wins[this.m_currentEvent.id].scoreType === "damage")
               {
                  m_subMenu.desc_txt.text = Math.round(SaveData.Records.events.wins[this.m_currentEvent.id].score) + " % (Avg. FPS: " + SaveData.Records.events.wins[this.m_currentEvent.id].fps + ")";
               }
               else if(SaveData.Records.events.wins[this.m_currentEvent.id].scoreType === "stamina")
               {
                  m_subMenu.desc_txt.text = Math.round(SaveData.Records.events.wins[this.m_currentEvent.id].score) + " % (Avg. FPS: " + SaveData.Records.events.wins[this.m_currentEvent.id].fps + ")";
               }
               else if(SaveData.Records.events.wins[this.m_currentEvent.id].scoreType === "kos")
               {
                  m_subMenu.desc_txt.text = SaveData.Records.events.wins[this.m_currentEvent.id].score + " KOs (Avg. FPS: " + SaveData.Records.events.wins[this.m_currentEvent.id].fps + ")";
               }
               else
               {
                  m_subMenu.desc_txt.text = "[ Invalid Score Type ]";
               }
            }
            else
            {
               m_subMenu.rank_txt.text = "--";
               m_subMenu.desc_txt.text = "[ Incomplete ]";
            }
            Utils.tryToGotoAndStop(m_subMenu.previewer,this.m_currentEvent.id);
         }
         else
         {
            m_subMenu.eventNum.text = "";
            m_subMenu.eventName.text = "";
            m_subMenu.eventDesc.text = "";
            m_subMenu.previewer.gotoAndStop(1);
            m_subMenu.desc_txt.text = "";
         }
      }
      
      override public function makeEvents() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.backMain_CLICK);
         m_subMenu.scroller.addEventListener(MouseEvent.MOUSE_DOWN,this.scroll_CLICK);
         m_subMenu.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.scroll_MOVE);
         m_subMenu.addEventListener(MouseEvent.MOUSE_UP,this.scroll_RELEASE);
         this.eventSelectHand.makeEvents();
         var _loc3_:Number = 0;
         this.m_unlockIcon.visible = false;
         while(_loc5_ < this.m_events.length)
         {
            this.m_eventButtons[_loc5_].ButtonInstance.complete.visible = SaveData.Records.events.wins[this.m_events[_loc5_].id];
            this.m_eventButtons[_loc5_].ButtonInstance.eventName.text = this.m_events[_loc5_].name;
            this.m_eventButtons[_loc5_].ButtonInstance.name = "e" + _loc5_;
            this.m_eventButtons[_loc5_].ButtonInstance.y = _loc3_ * 23;
            this.m_eventButtons[_loc5_].ButtonInstance.addEventListener(MouseEvent.CLICK,this.event_CLICK);
            this.m_eventButtons[_loc5_].ButtonInstance.addEventListener(MouseEvent.MOUSE_OVER,this.event_MOUSE_OVER);
            this.m_eventButtons[_loc5_].ButtonInstance.addEventListener(MouseEvent.MOUSE_OUT,this.event_MOUSE_OUT);
            this.m_eventButtons[_loc5_].makeEvents();
            this.m_eventButtons[_loc5_].ButtonInstance.visible = true;
            if(SaveData.Records.events.wins[this.m_events[_loc5_].id])
            {
               this.m_eventButtons[_loc5_].ButtonInstance.complete.gotoAndStop(SaveData.Records.events.wins[this.m_events[_loc5_].id].rank.toUpperCase());
               this.m_eventButtons[_loc5_].ButtonInstance.complete.visible = true;
            }
            else
            {
               this.m_eventButtons[_loc5_].ButtonInstance.complete.visible = false;
            }
            if(Boolean(this.m_events[_loc5_].dev) && !Main.DEBUG)
            {
               this.m_eventButtons[_loc5_].ButtonInstance.visible = false;
            }
            else
            {
               if(Boolean(this.m_events[_loc5_].dev) && Boolean(Main.DEBUG))
               {
                  this.m_eventButtons[_loc5_].ButtonInstance.eventName.text += " (dev)";
               }
               _loc3_++;
            }
            if(this.m_events[_loc5_].allStar)
            {
               if(++_loc1_ === 1 && !SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_01] || _loc1_ === 2 && !SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_06] || _loc1_ === 3 && !SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_07] || _loc1_ === 4 && !SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_08] || _loc1_ === 5 && !SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_09] || _loc1_ === 6 && !SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_BETA])
               {
                  if(Main.DEBUG)
                  {
                     this.m_eventButtons[_loc5_].ButtonInstance.eventName.text += " (*)";
                  }
                  else
                  {
                     this.m_eventButtons[_loc5_].ButtonInstance.visible = false;
                  }
               }
            }
            else if(++_loc2_ >= 11 && _loc2_ <= 20 && !SaveData.Unlocks[Unlockable.EVENTS_11_20] || _loc2_ >= 21 && _loc2_ <= 30 && !SaveData.Unlocks[Unlockable.EVENTS_21_30] || _loc2_ >= 31 && _loc2_ <= 36 && !SaveData.Unlocks[Unlockable.EVENTS_31_36] || _loc2_ >= 37 && _loc2_ <= 44 && !SaveData.Unlocks[Unlockable.EVENTS_37_44] || _loc2_ >= 45 && _loc2_ <= 50 && !SaveData.Unlocks[Unlockable.EVENTS_45_50] || _loc2_ >= 51 && _loc2_ <= 51 && !SaveData.Unlocks[Unlockable.EVENTS_51])
            {
               if(Main.DEBUG)
               {
                  this.m_eventButtons[_loc5_].ButtonInstance.eventName.text += " (*)";
               }
               else
               {
                  this.m_eventButtons[_loc5_].ButtonInstance.visible = false;
               }
            }
            if(!_loc4_)
            {
               if(!SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_01] && _loc2_ === 10)
               {
                  _loc4_ = true;
                  this.m_unlockIcon.eventName.text = "Must complete events 1-10";
               }
               else if(!SaveData.Unlocks[Unlockable.EVENTS_11_20] && _loc1_ === 1)
               {
                  _loc4_ = true;
                  this.m_unlockIcon.eventName.text = "Must complete All Star v0.1";
               }
               else if(!SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_06] && _loc2_ === 20)
               {
                  _loc4_ = true;
                  this.m_unlockIcon.eventName.text = "Must complete events 11-20";
               }
               else if(!SaveData.Unlocks[Unlockable.EVENTS_21_30] && _loc1_ === 2)
               {
                  _loc4_ = true;
                  this.m_unlockIcon.eventName.text = "Must complete All Star v0.6";
               }
               else if(!SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_07] && _loc2_ === 30)
               {
                  _loc4_ = true;
                  this.m_unlockIcon.eventName.text = "Must complete events 21-30";
               }
               else if(!SaveData.Unlocks[Unlockable.EVENTS_31_36] && _loc1_ === 3)
               {
                  _loc4_ = true;
                  this.m_unlockIcon.eventName.text = "Must complete All Star v0.7";
               }
               else if(!SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_08] && _loc2_ === 36)
               {
                  _loc4_ = true;
                  this.m_unlockIcon.eventName.text = "Must complete events 31-36";
               }
               else if(!SaveData.Unlocks[Unlockable.EVENTS_37_44] && _loc1_ === 4)
               {
                  _loc4_ = true;
                  this.m_unlockIcon.eventName.text = "Must complete All Star v0.8";
               }
               else if(!SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_09] && _loc2_ === 44)
               {
                  _loc4_ = true;
                  this.m_unlockIcon.eventName.text = "Must complete events 37-44";
               }
               else if(!SaveData.Unlocks[Unlockable.EVENTS_45_50] && _loc1_ === 5)
               {
                  _loc4_ = true;
                  this.m_unlockIcon.eventName.text = "Must complete All Star v0.9";
               }
               else if(!SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_BETA] && _loc2_ === 50)
               {
                  _loc4_ = true;
                  this.m_unlockIcon.eventName.text = "Must complete events 45-50";
               }
               else if(!SaveData.Records.events.wins["AllStarBattleBeta"] && !SaveData.Unlocks[Unlockable.EVENTS_51] && _loc1_ === 6)
               {
                  _loc4_ = true;
                  this.m_unlockIcon.eventName.text = "Must complete All Star Beta";
               }
               else if(Boolean(SaveData.Records.events.wins["AllStarBattleBeta"] && !SaveData.Unlocks[Unlockable.EVENT_ARANK]) && Boolean(!SaveData.Unlocks[Unlockable.EVENTS_51]) && _loc1_ === 6)
               {
                  _loc4_ = true;
                  this.m_unlockIcon.eventName.text = "Must A-rank or above every event";
               }
               if(_loc4_)
               {
                  this.m_unlockIcon.visible = true;
                  this.m_eventContainer.addChild(this.m_unlockIcon);
                  this.m_unlockIcon.y = _loc3_ * 23;
                  _loc3_++;
                  _loc4_ = true;
               }
            }
            _loc5_++;
         }
      }
      
      override public function killEvents() : void
      {
         var _loc1_:int = 0;
         super.killEvents();
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.backMain_CLICK);
         m_subMenu.scroller.removeEventListener(MouseEvent.MOUSE_DOWN,this.scroll_CLICK);
         m_subMenu.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.scroll_MOVE);
         m_subMenu.removeEventListener(MouseEvent.MOUSE_UP,this.scroll_RELEASE);
         while(_loc1_ < this.m_events.length)
         {
            this.m_eventButtons[_loc1_].ButtonInstance.visible = true;
            this.m_eventButtons[_loc1_].killEvents();
            this.m_eventButtons[_loc1_].ButtonInstance.removeEventListener(MouseEvent.CLICK,this.event_CLICK);
            this.m_eventButtons[_loc1_].ButtonInstance.removeEventListener(MouseEvent.MOUSE_OVER,this.event_MOUSE_OVER);
            this.m_eventButtons[_loc1_].ButtonInstance.removeEventListener(MouseEvent.MOUSE_OUT,this.event_MOUSE_OUT);
            _loc1_++;
         }
         this.eventSelectHand.killEvents();
         MovieClip(m_subMenu.scroller).stopDrag();
      }
      
      override public function show() : void
      {
         this.reset();
         super.show();
         SoundQueue.instance.playMusic("menumusic",0);
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
         var _loc2_:Number = 30;
         this.m_eventContainer.y = this.m_listLocation.y - _loc1_ * (_loc2_ * Math.max(0,this.m_events.length - 21));
      }
      
      private function handPushListUpHelper() : void
      {
         m_subMenu.scroller.y -= 2;
         if(m_subMenu.scroller.y < this.m_scrollTop.y)
         {
            m_subMenu.scroller.y = this.m_scrollTop.y;
         }
         this.repositionList();
      }
      
      private function handPushListDownHelper() : void
      {
         m_subMenu.scroller.y += 2;
         if(m_subMenu.scroller.y > this.m_scrollTop.y + this.m_scrollHeight)
         {
            m_subMenu.scroller.y = this.m_scrollTop.y + this.m_scrollHeight;
         }
         this.repositionList();
      }
      
      private function findEvent(param1:MovieClip) : int
      {
         var _loc2_:int = 0;
         if(Boolean(param1) && !param1.visible)
         {
            return -1;
         }
         while(_loc2_ < this.m_eventButtons.length)
         {
            if(this.m_eventButtons[_loc2_].ButtonInstance == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function event_CLICK(param1:MouseEvent) : void
      {
         ModAPI.triggerMenuRumble(m_lastControllerIndex >= 0 ? m_lastControllerIndex : 0);
         var _loc2_:int = int(this.findEvent(param1.target as MovieClip));
         if(_loc2_ >= 0 && _loc2_ < this.m_events.length)
         {
            this.m_currentEvent = this.m_events[_loc2_];
            removeSelf();
            if(this.m_currentEvent.chooseCharacter)
            {
               SoundQueue.instance.playSoundEffect("menu_selectstage");
               MenuController.eventMatchCharacterMenu.reset();
               if(!MenuController.eventMatchCharacterMenu.isOnscreen())
               {
                  MenuController.eventMatchCharacterMenu.show();
               }
            }
            else
            {
               SoundQueue.instance.playSoundEffect("menu_selectstage");
               SoundQueue.instance.playSoundEffect("menu_crowd");
               this.m_game = new Game(Main.MAXPLAYERS,Mode.EVENT);
               this.m_modeInstance = new EventMode(this.m_game,{"eventMatchID":this.m_currentEvent.id},{"classAPI":ResourceManager.getResourceByID("event_mode").getProp("mode")});
               this.m_modeInstance.PreviousMenu = this;
            }
         }
      }
      
      public function event_MOUSE_OVER(param1:MouseEvent) : void
      {
         var _loc2_:int = int(this.findEvent(param1.target as MovieClip));
         if(_loc2_ >= 0 && _loc2_ < this.m_events.length)
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            this.m_currentEvent = this.m_events[_loc2_];
            this.updateDisplay();
         }
      }
      
      public function event_MOUSE_OUT(param1:MouseEvent) : void
      {
         var _loc2_:int = int(this.findEvent(param1.target as MovieClip));
         if(_loc2_ >= 0)
         {
            this.m_currentEvent = null;
            this.updateDisplay();
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
      
      public function backMain_CLICK(param1:MouseEvent) : void
      {
         ModAPI.stopMenuRumble();
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_back");
         MenuController.soloMenu.show();
      }
   }
}


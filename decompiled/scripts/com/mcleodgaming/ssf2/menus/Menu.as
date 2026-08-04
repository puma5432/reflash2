package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.events.Event;
   
   public class Menu
   {
      
      protected var m_container:MovieClip;
      
      protected var m_subMenu:MovieClip;
      
      protected var m_clickBlocker:MovieClip;
      
      protected var m_secondaryClickBlocker:MovieClip;
      
      protected var m_bgBlocker:MovieClip;
      
      protected var m_fillBackground:Boolean;
      
      protected var m_buttons:Vector.<MovieClip>;
      
      protected var m_showCount:int = 0;
      
      protected var m_menuMapper:MenuMapper;
      
      protected var m_upLetGo:Boolean;
      
      protected var m_downLetGo:Boolean;
      
      protected var m_leftLetGo:Boolean;
      
      protected var m_rightLetGo:Boolean;
      
      protected var m_letGoTimer:FrameTimer;
      
      protected var m_releaseTimer:FrameTimer;
      
      protected var m_releaseDoubleTimer:FrameTimer;
      
      protected var m_aLetGo:Boolean;
      
      protected var m_bLetGo:Boolean;
      
      protected var m_startLetGo:Boolean;
      
      protected var m_backgroundContainer:MovieClip;
      
      protected var m_backgroundID:String;
      
      protected var m_hasEvents:Boolean;
      
      protected var m_disablePauseMapping:Boolean;
      
      protected var m_lastControllerIndex:int = -1;
      
      public function Menu()
      {
         super();
         this.m_container = new MovieClip();
         this.m_backgroundContainer = new MovieClip();
         this.m_subMenu = null;
         this.m_backgroundID = null;
         this.m_fillBackground = true;
         this.m_hasEvents = false;
         this.m_clickBlocker = new MovieClip();
         this.m_clickBlocker.graphics.beginFill(0,0.5);
         this.m_clickBlocker.graphics.drawRect(-2,-2,Main.Width + 4,Main.Height + 4);
         this.m_clickBlocker.graphics.endFill();
         this.m_clickBlocker.buttonMode = true;
         this.m_clickBlocker.useHandCursor = false;
         this.m_secondaryClickBlocker = new MovieClip();
         this.m_secondaryClickBlocker.graphics.beginFill(0,0.5);
         this.m_secondaryClickBlocker.graphics.drawRect(-2,-2,Main.Width + 4,Main.Height + 4);
         this.m_secondaryClickBlocker.graphics.endFill();
         this.m_secondaryClickBlocker.buttonMode = true;
         this.m_secondaryClickBlocker.useHandCursor = false;
         this.m_bgBlocker = new MovieClip();
         this.m_bgBlocker.graphics.beginFill(0,0.3);
         this.m_bgBlocker.graphics.drawRect(-2,-2,Main.Width + 4,Main.Height + 4);
         this.m_bgBlocker.graphics.endFill();
         this.m_buttons = new Vector.<MovieClip>();
         this.m_menuMapper = null;
         this.m_upLetGo = false;
         this.m_downLetGo = false;
         this.m_leftLetGo = false;
         this.m_rightLetGo = false;
         this.m_aLetGo = false;
         this.m_bLetGo = false;
         this.m_startLetGo = false;
         this.m_letGoTimer = new FrameTimer(15);
         this.m_releaseTimer = new FrameTimer(2);
         this.m_releaseDoubleTimer = new FrameTimer(30);
         this.m_disablePauseMapping = false;
      }
      
      public function resetControlsLetGo(param1:Boolean = true) : void
      {
         this.m_upLetGo = false;
         this.m_downLetGo = false;
         this.m_leftLetGo = false;
         this.m_rightLetGo = false;
         if(param1)
         {
            this.m_aLetGo = false;
            this.m_bLetGo = false;
            this.m_startLetGo = false;
         }
      }
      
      public function get Container() : MovieClip
      {
         return this.m_container;
      }
      
      public function get SubMenu() : MovieClip
      {
         return this.m_subMenu;
      }
      
      public function initMenuMappings() : void
      {
      }
      
      public function setMenuMappingFocus() : void
      {
         if(Boolean(this.m_menuMapper) && Boolean(this.m_menuMapper.currentNode))
         {
            this.setButtonFocus(this.m_menuMapper.currentNode.clip);
         }
      }
      
      public function makeEvents() : void
      {
         if(this.m_showCount == 0)
         {
            this.findContainerButtons();
         }
         this.m_upLetGo = false;
         this.m_downLetGo = false;
         this.m_leftLetGo = false;
         this.m_rightLetGo = false;
         this.m_aLetGo = false;
         this.m_bLetGo = false;
         this.m_startLetGo = false;
         this.m_hasEvents = true;
      }
      
      public function killEvents() : void
      {
         this.m_hasEvents = false;
      }
      
      public function moveToFront(param1:Event = null) : void
      {
         if(this.m_container.parent)
         {
            this.m_container.parent.setChildIndex(this.m_container,this.m_container.parent.numChildren - 1);
         }
      }
      
      public function resetButtonFocus(param1:MovieClip) : void
      {
         Utils.tryToGotoAndStop(param1,"_up");
      }
      
      public function setButtonFocus(param1:MovieClip) : void
      {
         Utils.tryToGotoAndStop(param1,"_over");
      }
      
      public function manageMenuMappings(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         if(this.m_menuMapper)
         {
            this.m_letGoTimer.tick();
            _loc2_ = 1;
            while(_loc2_ <= SaveData.Controllers.length && this.m_hasEvents)
            {
               if(Boolean(SaveData.Controllers[_loc2_ - 1].IsDown(SaveData.Controllers[_loc2_ - 1]._BUTTON1)) && this.m_hasEvents)
               {
                  if(this.m_bLetGo)
                  {
                     this.m_bLetGo = false;
                     this.m_menuMapper.back();
                     if(Boolean(this.m_menuMapper) && Boolean(this.m_menuMapper.currentNode))
                     {
                        this.setButtonFocus(this.m_menuMapper.currentNode.clip);
                     }
                  }
                  _loc3_ = true;
               }
               if(Boolean(SaveData.Controllers[_loc2_ - 1].IsDown(SaveData.Controllers[_loc2_ - 1]._BUTTON2)) && this.m_hasEvents)
               {
                  if(this.m_aLetGo)
                  {
                     this.m_aLetGo = false;
                     this.m_lastControllerIndex = _loc2_ - 1;
                     if(this.m_menuMapper is SelectHand)
                     {
                        SelectHand(this.m_menuMapper).lastControllerIndex = this.m_lastControllerIndex;
                     }
                     this.m_menuMapper.press();
                     if(Boolean(this.m_menuMapper) && Boolean(this.m_menuMapper.currentNode))
                     {
                        this.setButtonFocus(this.m_menuMapper.currentNode.clip);
                     }
                  }
                  _loc3_ = true;
               }
               else if(Boolean(SaveData.Controllers[_loc2_ - 1].IsDown(SaveData.Controllers[_loc2_ - 1]._START)) && !this.m_disablePauseMapping && this.m_hasEvents)
               {
                  if(this.m_startLetGo)
                  {
                     this.m_startLetGo = false;
                     this.m_menuMapper.press();
                     if(Boolean(this.m_menuMapper) && Boolean(this.m_menuMapper.currentNode))
                     {
                        this.setButtonFocus(this.m_menuMapper.currentNode.clip);
                     }
                  }
                  _loc3_ = true;
               }
               if(Boolean(SaveData.Controllers[_loc2_ - 1].IsDown(SaveData.Controllers[_loc2_ - 1]._UP)) && this.m_hasEvents)
               {
                  if(this.m_upLetGo)
                  {
                     this.m_upLetGo = false;
                     if(Boolean(this.m_menuMapper) && Boolean(this.m_menuMapper.currentNode))
                     {
                        this.resetButtonFocus(this.m_menuMapper.currentNode.clip);
                     }
                     this.m_menuMapper.up();
                     if(Boolean(this.m_menuMapper) && Boolean(this.m_menuMapper.currentNode))
                     {
                        this.setButtonFocus(this.m_menuMapper.currentNode.clip);
                     }
                  }
                  _loc3_ = true;
               }
               if(Boolean(SaveData.Controllers[_loc2_ - 1].IsDown(SaveData.Controllers[_loc2_ - 1]._DOWN)) && this.m_hasEvents)
               {
                  if(this.m_downLetGo)
                  {
                     this.m_downLetGo = false;
                     if(this.m_menuMapper.currentNode)
                     {
                        this.resetButtonFocus(this.m_menuMapper.currentNode.clip);
                     }
                     this.m_menuMapper.down();
                     if(Boolean(this.m_menuMapper) && Boolean(this.m_menuMapper.currentNode))
                     {
                        this.setButtonFocus(this.m_menuMapper.currentNode.clip);
                     }
                  }
                  _loc3_ = true;
               }
               if(Boolean(SaveData.Controllers[_loc2_ - 1].IsDown(SaveData.Controllers[_loc2_ - 1]._LEFT)) && this.m_hasEvents)
               {
                  if(this.m_leftLetGo)
                  {
                     this.m_leftLetGo = false;
                     if(this.m_menuMapper.currentNode)
                     {
                        this.resetButtonFocus(this.m_menuMapper.currentNode.clip);
                     }
                     this.m_menuMapper.left();
                     if(Boolean(this.m_menuMapper) && Boolean(this.m_menuMapper.currentNode))
                     {
                        this.setButtonFocus(this.m_menuMapper.currentNode.clip);
                     }
                  }
                  _loc3_ = true;
               }
               if(Boolean(SaveData.Controllers[_loc2_ - 1].IsDown(SaveData.Controllers[_loc2_ - 1]._RIGHT)) && this.m_hasEvents)
               {
                  if(this.m_rightLetGo)
                  {
                     this.m_rightLetGo = false;
                     if(this.m_menuMapper.currentNode)
                     {
                        this.resetButtonFocus(this.m_menuMapper.currentNode.clip);
                     }
                     this.m_menuMapper.right();
                     if(Boolean(this.m_menuMapper) && Boolean(this.m_menuMapper.currentNode))
                     {
                        this.setButtonFocus(this.m_menuMapper.currentNode.clip);
                     }
                  }
                  _loc3_ = true;
               }
               _loc2_++;
            }
            if(!_loc3_)
            {
               this.m_upLetGo = true;
               this.m_downLetGo = true;
               this.m_leftLetGo = true;
               this.m_rightLetGo = true;
               this.m_aLetGo = true;
               this.m_bLetGo = true;
               this.m_startLetGo = true;
               this.m_letGoTimer.reset();
               this.m_releaseTimer.reset();
               this.m_releaseDoubleTimer.reset();
            }
            else
            {
               this.m_letGoTimer.tick();
               if(this.m_letGoTimer.IsComplete)
               {
                  this.m_releaseTimer.tick();
                  this.m_releaseDoubleTimer.tick();
                  if(this.m_releaseTimer.IsComplete || this.m_releaseDoubleTimer.IsComplete && this.m_releaseTimer.CurrentTime <= this.m_releaseTimer.MaxTime / 2)
                  {
                     this.m_upLetGo = true;
                     this.m_downLetGo = true;
                     this.m_leftLetGo = true;
                     this.m_rightLetGo = true;
                     this.m_releaseTimer.reset();
                  }
               }
            }
         }
      }
      
      public function findContainerButtons() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.m_container.numChildren)
         {
            if(this.m_container.getChildAt(_loc1_) is MovieClip && Boolean(MovieClip(this.m_container.getChildAt(_loc1_)).buttonMode))
            {
               this.m_buttons.push(MovieClip(this.m_container.getChildAt(_loc1_) as MovieClip));
            }
            _loc1_++;
         }
      }
      
      public function findSubMenuButtons() : void
      {
         var _loc1_:int = 0;
         if(this.m_subMenu == null)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < this.m_subMenu.numChildren)
         {
            if(this.m_subMenu.getChildAt(_loc1_) is MovieClip && Boolean(MovieClip(this.m_subMenu.getChildAt(_loc1_)).buttonMode))
            {
               this.m_buttons.push(MovieClip(this.m_subMenu.getChildAt(_loc1_) as MovieClip));
            }
            _loc1_++;
         }
      }
      
      public function findSpecificMenuButtons(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         if(param1 == null)
         {
            return;
         }
         _loc2_ = 0;
         while(_loc2_ < param1.numChildren)
         {
            if(param1.getChildAt(_loc2_) is MovieClip && Boolean(MovieClip(param1.getChildAt(_loc2_)).buttonMode))
            {
               this.m_buttons.push(MovieClip(param1.getChildAt(_loc2_) as MovieClip));
            }
            _loc2_++;
         }
      }
      
      public function resetAllButtons() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.m_buttons.length)
         {
            this.resetButtonFocus(this.m_buttons[_loc1_]);
            _loc1_++;
         }
      }
      
      public function isOnscreen() : Boolean
      {
         return this.m_container.stage != null;
      }
      
      protected function updateMenuBackground() : void
      {
         if(this.m_subMenu)
         {
            this.m_subMenu.addChildAt(this.m_backgroundContainer,0);
            if(!SaveData.Quality.menu_bg)
            {
               Utils.recursiveMovieClipPlay(this.m_backgroundContainer,false,false);
               this.m_backgroundContainer.visible = false;
            }
            else
            {
               Utils.recursiveMovieClipPlay(this.m_backgroundContainer,true,true);
               this.m_backgroundContainer.visible = true;
            }
            if(this.m_fillBackground)
            {
               this.m_subMenu.graphics.beginFill(0);
               this.m_subMenu.graphics.drawRect(-2 - Main.Width / 2,-2 - Main.Height / 2,Main.Width + 4,Main.Height + 4);
               this.m_subMenu.graphics.endFill();
            }
         }
         if(this.m_backgroundID)
         {
            this.m_backgroundContainer.addChild(ResourceManager.getLibraryMC("menu_bg_" + this.m_backgroundID));
            this.m_backgroundID = null;
         }
      }
      
      public function show() : void
      {
         this.updateMenuBackground();
         Main.Root.addChild(this.m_container);
         this.makeEvents();
         ++this.m_showCount;
         Main.fixFocus();
      }
      
      public function removeSelf() : void
      {
         if(this.m_container.parent)
         {
            this.resetAllButtons();
            this.killEvents();
            this.m_container.parent.removeChild(this.m_container);
         }
         Main.fixFocus();
      }
      
      public function addClickBlocker() : void
      {
         this.m_container.addChild(this.m_clickBlocker);
      }
      
      public function removeClickBlocker() : void
      {
         if(this.m_clickBlocker.parent)
         {
            this.m_clickBlocker.parent.removeChild(this.m_clickBlocker);
         }
      }
      
      public function addBGBlocker() : void
      {
         this.m_container.addChild(this.m_bgBlocker);
      }
      
      public function removeBGBlocker() : void
      {
         if(this.m_bgBlocker.parent)
         {
            this.m_bgBlocker.parent.removeChild(this.m_bgBlocker);
         }
      }
      
      public function addSecondaryClickBlocker() : void
      {
         this.m_container.addChild(this.m_secondaryClickBlocker);
      }
      
      public function removeSecondaryClickBlocker() : void
      {
         if(this.m_secondaryClickBlocker.parent)
         {
            this.m_secondaryClickBlocker.parent.removeChild(this.m_secondaryClickBlocker);
         }
      }
   }
}


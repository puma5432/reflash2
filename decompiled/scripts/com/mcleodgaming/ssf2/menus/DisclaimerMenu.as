package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   
   public class DisclaimerMenu extends Menu
   {
      
      private var waitASec:Boolean;
      
      private var m_skipNode:MenuMapperNode;
      
      private var m_featuredLoadingShape:Shape;
      
      private var m_featuredSkipBlockTimer:FrameTimer;
      
      private var m_featuredCustomMenu:CustomAPIMenu;
      
      private var m_featuredSelectHand:SelectHand;
      
      public function DisclaimerMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_disclaimer");
         if(m_subMenu)
         {
            m_subMenu.stop();
            m_container.addChild(m_subMenu);
            this.initMenuMappings();
            m_subMenu.x = Main.Width / 2;
            m_subMenu.y = Main.Height / 2;
         }
         this.waitASec = true;
         this.m_featuredSkipBlockTimer = new FrameTimer(30 * 2);
         this.m_featuredLoadingShape = new Shape();
         this.m_featuredLoadingShape.graphics.beginFill(15658734,0.5);
         this.m_featuredLoadingShape.graphics.lineStyle(1,1118481,0.5);
         this.m_featuredLoadingShape.graphics.drawRect(0,0,50,3);
         this.m_featuredLoadingShape.graphics.endFill();
         this.m_featuredLoadingShape.x = 5;
         this.m_featuredLoadingShape.y = 360 - 10;
      }
      
      override public function initMenuMappings() : void
      {
         this.m_skipNode = new MenuMapperNode(m_subMenu);
         this.m_skipNode.updateNodes(null,null,null,null,null,null,this.skipDisclaimer,this.skipDisclaimer);
         m_menuMapper = new MenuMapper(this.m_skipNode);
         m_menuMapper.init();
      }
      
      override public function makeEvents() : void
      {
         if(m_showCount == 0)
         {
            findSubMenuButtons();
         }
         super.makeEvents();
         if(m_subMenu == null)
         {
            removeSelf();
            MenuController.intro3Menu.setVault(false);
            MenuController.intro3Menu.show();
         }
         else
         {
            Main.Root.stage.addEventListener(MouseEvent.CLICK,this.skipDisclaimer);
            Main.Root.stage.addEventListener(Event.ENTER_FRAME,this.checkDisclaimer);
            Main.Root.stage.addEventListener(Event.ENTER_FRAME,manageMenuMappings);
         }
         SaveData.saveGame();
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         Main.Root.stage.removeEventListener(MouseEvent.CLICK,this.skipDisclaimer);
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,this.checkDisclaimer);
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,manageMenuMappings);
      }
      
      private function skipDisclaimer(param1:MouseEvent) : void
      {
         if(!this.waitASec && (m_subMenu.currentFrame > 90 || Boolean(Main.DEBUG)))
         {
            SoundQueue.instance.playSoundEffect("menu_selectstage");
            if(m_subMenu)
            {
               m_subMenu.stop();
            }
            this.nextMenu();
         }
      }
      
      private function checkDisclaimer(param1:Event) : void
      {
         if(m_subMenu)
         {
            if(m_subMenu.currentFrame >= m_subMenu.totalFrames - 1)
            {
               m_subMenu.stop();
               this.nextMenu();
            }
         }
         this.waitASec = false;
      }
      
      override public function show() : void
      {
         this.waitASec = true;
         if(m_subMenu)
         {
            m_subMenu.gotoAndPlay(1);
            super.show();
         }
         else
         {
            this.nextMenu();
         }
         ResourceManager.getResourceByID("mappings").getProp("metadata");
      }
      
      private function checkFeaturedNewsInputs(param1:Event) : void
      {
         var _loc2_:int = 0;
         this.m_featuredSkipBlockTimer.tick();
         this.m_featuredLoadingShape.scaleX = 1 - this.m_featuredSkipBlockTimer.CurrentTime / this.m_featuredSkipBlockTimer.MaxTime;
         if(this.m_featuredSkipBlockTimer.IsComplete)
         {
            _loc2_ = 0;
            while(_loc2_ < SaveData.Controllers.length)
            {
               if(param1 is MouseEvent || Boolean(SaveData.Controllers[_loc2_].IsDown(SaveData.Controllers[_loc2_]._START)) || Boolean(SaveData.Controllers[_loc2_].IsDown(SaveData.Controllers[_loc2_]._BUTTON1)) || Boolean(SaveData.Controllers[_loc2_].IsDown(SaveData.Controllers[_loc2_]._BUTTON2)))
               {
                  Main.Root.removeEventListener(Event.ENTER_FRAME,this.checkFeaturedNewsInputs);
                  Main.Root.stage.removeEventListener(MouseEvent.CLICK,this.checkFeaturedNewsInputs);
                  this.m_featuredCustomMenu.removeSelf();
                  this.m_featuredCustomMenu.APIInstance.dispose();
                  this.m_featuredSelectHand.killEvents();
                  SaveData.saveGame();
                  this.nextMenu();
                  return;
               }
               _loc2_++;
            }
         }
      }
      
      private function nextMenu() : void
      {
         var entries:Array = null;
         var e:int = 0;
         var entry:Object = null;
         var i:int = 0;
         var customContainerChild:MovieClip = null;
         var j:int = 0;
         removeSelf();
         if(ResourceManager.getResourceByID("menu_news").Loaded)
         {
            entries = ResourceManager.getResourceByID("menu_news").getProp("entries") || new Array();
            e = 0;
            while(e < entries.length)
            {
               entry = entries[e];
               if(Boolean(!SaveData.Once.newsRead[entry.id] && entry.featured) && Boolean(!(entry.featuredIfVersion && Version.getVersion() !== entry.featuredIfVersion)) && !(entry.featuredIfNotVersion && Version.getVersion() === entry.featuredIfNotVersion))
               {
                  this.m_featuredSkipBlockTimer.reset();
                  if(entry.unskippableFrames !== undefined)
                  {
                     this.m_featuredSkipBlockTimer.MaxTime = entry.unskippableFrames;
                  }
                  SaveData.Once.newsRead[entry.id] = true;
                  this.m_featuredCustomMenu = new CustomAPIMenu({"classAPI":entry.menuClass});
                  this.m_featuredCustomMenu.show();
                  this.m_featuredSelectHand = new SelectHand(this.m_featuredCustomMenu.Container,new Vector.<HandButton>(),null);
                  this.m_featuredSelectHand.makeEvents();
                  i = 0;
                  while(i < this.m_featuredCustomMenu.Container.numChildren)
                  {
                     if(this.m_featuredCustomMenu.Container.getChildAt(i) is MovieClip)
                     {
                        customContainerChild = MovieClip(this.m_featuredCustomMenu.Container.getChildAt(i));
                        j = 0;
                        while(j < customContainerChild.numChildren)
                        {
                           if(customContainerChild.getChildAt(j) is MovieClip && Boolean(MovieClip(customContainerChild.getChildAt(j)).buttonMode) || customContainerChild.getChildAt(j) is SimpleButton)
                           {
                              this.m_featuredSelectHand.addClickEventClipHitTest(customContainerChild.getChildAt(j));
                           }
                           j += 1;
                        }
                     }
                     i += 1;
                  }
                  this.m_featuredSelectHand.resetPosition(new Point(320,240),new Rectangle(10,10,630,350));
                  SoundQueue.instance.playSoundEffect("menu_unlock");
                  Main.Root.addEventListener(Event.ENTER_FRAME,this.checkFeaturedNewsInputs);
                  Main.Root.stage.addEventListener(MouseEvent.CLICK,this.checkFeaturedNewsInputs);
                  this.m_featuredCustomMenu.Container.addChild(this.m_featuredLoadingShape);
                  return;
               }
               e += 1;
            }
         }
         if(UnlockController.checkUnlocked(UnlockController.getUnlockableByID(Unlockable.ALTERNATE_TRACKS)))
         {
            UnlockController.nextMenuFunc = function():void
            {
               MenuController.intro3Menu.setVault(false);
               MenuController.intro3Menu.show();
            };
            UnlockController.pendingUnlockScreens.push(UnlockController.getUnlockableByID(Unlockable.ALTERNATE_TRACKS));
            MenuController.postUnlockMenu.show();
         }
         else
         {
            MenuController.intro3Menu.setVault(false);
            MenuController.intro3Menu.show();
         }
      }
   }
}


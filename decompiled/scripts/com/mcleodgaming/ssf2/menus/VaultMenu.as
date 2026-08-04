package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.net.*;
   import com.mcleodgaming.ssf2.util.*;
   import com.sbxmod.paletteMaker.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class VaultMenu extends Menu
   {
      
      private var m_replayNode:MenuMapperNode;
      
      private var m_introNode:MenuMapperNode;
      
      private var m_intro2Node:MenuMapperNode;
      
      private var m_intro3Node:MenuMapperNode;
      
      private var m_paletteMakerNode:MenuMapperNode;
      
      private var m_characterGridNodes:Vector.<MenuMapperNode>;
      
      private var m_mainMenuMapper:MenuMapper;
      
      protected var m_loadingMask:MovieClip;
      
      private var PaletteMakerButton:MovieClip = ResourceManager.getLibraryMC("PaletteMakerButton");
      
      private var container:MovieClip;
      
      private var containerButton:Vector.<EventButton>;
      
      private var characters:Array;
      
      private var selectedCharacter:String;
      
      public function VaultMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_vault");
         m_backgroundID = "space";
         m_container.addChild(m_subMenu);
         this.initMenuMappings();
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         this.m_loadingMask = ResourceManager.getLibraryMC("loadingMask");
         this.m_loadingMask.x = Main.Width / 2;
         this.m_loadingMask.y = Main.Height / 2;
      }
      
      override public function initMenuMappings() : void
      {
         this.m_replayNode = new MenuMapperNode(m_subMenu.replays_btn);
         this.m_introNode = new MenuMapperNode(m_subMenu.intro_btn);
         this.m_intro2Node = new MenuMapperNode(m_subMenu.intro2_btn);
         this.m_intro3Node = new MenuMapperNode(m_subMenu.intro3_btn);
         if(this.PaletteMakerButton)
         {
            this.m_paletteMakerNode = new MenuMapperNode(this.PaletteMakerButton);
         }
         this.m_replayNode.updateNodes(null,[this.m_paletteMakerNode],[this.m_intro3Node],[this.m_introNode],this.replay_MOUSE_OVER,null,this.replay_CLICK,this.back_CLICK_vault,null,null);
         this.m_introNode.updateNodes(null,[this.m_paletteMakerNode],[this.m_replayNode],[this.m_intro2Node],this.intro_MOUSE_OVER,null,this.play_intro,this.back_CLICK_vault,null,null);
         this.m_intro2Node.updateNodes(null,[this.m_paletteMakerNode],[this.m_introNode],[this.m_intro3Node],this.intro2_MOUSE_OVER,null,this.play_intro2,this.back_CLICK_vault,null,null);
         this.m_intro3Node.updateNodes(null,[this.m_paletteMakerNode],[this.m_intro2Node],[this.m_replayNode],this.intro3_MOUSE_OVER,null,this.play_intro3,this.back_CLICK_vault,null,null);
         if(this.m_paletteMakerNode)
         {
            this.m_paletteMakerNode.updateNodes([this.m_replayNode],[this.m_replayNode],null,null,this.paletteMaker_MOUSE_OVER,this.paletteMaker_MOUSE_OUT,this.paletteMaker_CLICK,this.back_CLICK_vault,null,null);
         }
         m_menuMapper = new MenuMapper(this.m_replayNode);
         this.m_mainMenuMapper = m_menuMapper;
         m_menuMapper.init();
      }
      
      override public function show() : void
      {
         super.show();
         SoundQueue.instance.playMusic("menumusic",0);
      }
      
      override public function makeEvents() : void
      {
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         resetAllButtons();
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK_vault);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER_vault);
         m_subMenu.intro_btn.addEventListener(MouseEvent.CLICK,this.play_intro);
         m_subMenu.intro2_btn.addEventListener(MouseEvent.CLICK,this.play_intro2);
         m_subMenu.intro3_btn.addEventListener(MouseEvent.CLICK,this.play_intro3);
         m_subMenu.intro_btn.addEventListener(MouseEvent.MOUSE_OVER,this.intro_MOUSE_OVER);
         m_subMenu.intro2_btn.addEventListener(MouseEvent.MOUSE_OVER,this.intro2_MOUSE_OVER);
         m_subMenu.intro3_btn.addEventListener(MouseEvent.MOUSE_OVER,this.intro3_MOUSE_OVER);
         m_subMenu.intro_btn.addEventListener(MouseEvent.MOUSE_OUT,this.intro_MOUSE_OUT);
         m_subMenu.intro2_btn.addEventListener(MouseEvent.MOUSE_OUT,this.intro_MOUSE_OUT);
         m_subMenu.intro3_btn.addEventListener(MouseEvent.MOUSE_OUT,this.intro_MOUSE_OUT);
         m_subMenu.replays_btn.addEventListener(MouseEvent.CLICK,this.replay_CLICK);
         m_subMenu.replays_btn.addEventListener(MouseEvent.MOUSE_OVER,this.replay_MOUSE_OVER);
         m_subMenu.replays_btn.addEventListener(MouseEvent.MOUSE_OUT,this.replay_MOUSE_OUT);
         m_subMenu.bg_top.home_btn.addEventListener(MouseEvent.CLICK,this.home_CLICK);
         if(Config.enable_palette_maker)
         {
            this.injectBnuys();
            if(this.PaletteMakerButton)
            {
               this.PaletteMakerButton.addEventListener(MouseEvent.MOUSE_OVER,this.paletteMaker_MOUSE_OVER);
               this.PaletteMakerButton.addEventListener(MouseEvent.MOUSE_OUT,this.paletteMaker_MOUSE_OUT);
               this.PaletteMakerButton.addEventListener(MouseEvent.CLICK,this.paletteMaker_CLICK);
            }
         }
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,manageMenuMappings);
         setMenuMappingFocus();
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK_vault);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER_vault);
         m_subMenu.intro_btn.removeEventListener(MouseEvent.CLICK,this.play_intro);
         m_subMenu.intro2_btn.removeEventListener(MouseEvent.CLICK,this.play_intro2);
         m_subMenu.intro3_btn.removeEventListener(MouseEvent.CLICK,this.play_intro3);
         m_subMenu.intro_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.intro_MOUSE_OVER);
         m_subMenu.intro2_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.intro2_MOUSE_OVER);
         m_subMenu.intro3_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.intro3_MOUSE_OVER);
         m_subMenu.intro_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.intro_MOUSE_OUT);
         m_subMenu.intro2_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.intro_MOUSE_OUT);
         m_subMenu.intro3_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.intro_MOUSE_OUT);
         m_subMenu.replays_btn.removeEventListener(MouseEvent.CLICK,this.replay_CLICK);
         m_subMenu.replays_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.replay_MOUSE_OVER);
         m_subMenu.replays_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.replay_MOUSE_OUT);
         m_subMenu.bg_top.home_btn.removeEventListener(MouseEvent.CLICK,this.home_CLICK);
         if(this.PaletteMakerButton)
         {
            this.PaletteMakerButton.removeEventListener(MouseEvent.MOUSE_OVER,this.paletteMaker_MOUSE_OVER);
            this.PaletteMakerButton.removeEventListener(MouseEvent.MOUSE_OUT,this.paletteMaker_MOUSE_OUT);
            this.PaletteMakerButton.removeEventListener(MouseEvent.CLICK,this.paletteMaker_CLICK);
         }
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,manageMenuMappings);
      }
      
      private function play_intro(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         if(ResourceManager.getResourceByID("ssf2intro_v8").Loaded)
         {
            SoundQueue.instance.stopMusic();
            removeSelf();
            if(!MenuController.introMenu)
            {
               MenuController.introMenu = new IntroMenu();
            }
            MenuController.introMenu.show();
         }
         else
         {
            Main.Root.addChild(this.m_loadingMask);
            ResourceManager.queueResources(["ssf2intro_v8"]);
            ResourceManager.load({"oncomplete":this.introLoaded});
         }
      }
      
      private function introLoaded(param1:Event = null) : void
      {
         SoundQueue.instance.stopMusic();
         removeSelf();
         Main.Root.removeChild(this.m_loadingMask);
         if(!MenuController.introMenu)
         {
            MenuController.introMenu = new IntroMenu();
         }
         MenuController.introMenu.show();
      }
      
      private function play_intro2(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         if(ResourceManager.getResourceByID("ssf2intro_v9").Loaded)
         {
            SoundQueue.instance.stopMusic();
            removeSelf();
            if(!MenuController.intro2Menu)
            {
               MenuController.intro2Menu = new Intro2Menu();
            }
            MenuController.intro2Menu.show();
         }
         else
         {
            Main.Root.addChild(this.m_loadingMask);
            ResourceManager.queueResources(["ssf2intro_v9"]);
            ResourceManager.load({"oncomplete":this.intro2Loaded});
         }
      }
      
      private function intro2Loaded(param1:Event = null) : void
      {
         SoundQueue.instance.stopMusic();
         removeSelf();
         Main.Root.removeChild(this.m_loadingMask);
         if(!MenuController.intro2Menu)
         {
            MenuController.intro2Menu = new Intro2Menu();
         }
         MenuController.intro2Menu.show();
      }
      
      private function play_intro3(param1:MouseEvent) : void
      {
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         SoundQueue.instance.stopMusic();
         MenuController.intro3Menu.setVault(true);
         MenuController.intro3Menu.show();
      }
      
      private function intro_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Watch the SSF2 v0.8 Intro.";
      }
      
      private function intro2_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Watch the SSF2 v0.9 Intro.";
      }
      
      private function intro3_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Watch the SSF2 Beta Intro.";
      }
      
      private function intro_MOUSE_OUT(param1:MouseEvent) : void
      {
         if(m_subMenu.desc_txt != null)
         {
            m_subMenu.desc_txt.text = "";
         }
      }
      
      private function replay_CLICK(param1:MouseEvent) : void
      {
         var replayTimer:Timer = null;
         var replayFunc:Function = null;
         var e:MouseEvent = param1;
         SoundQueue.instance.playSoundEffect("menu_select");
         Utils.openFile("SSF2 Replay File (*.ssfrec)","*.ssfrec");
         replayTimer = new Timer(20);
         MultiplayerManager.makeNotifier();
         replayFunc = function(param1:TimerEvent):void
         {
            var _loc2_:ByteArray = null;
            var _loc3_:ReplayData = null;
            if(Utils.finishedLoading)
            {
               replayTimer.removeEventListener(TimerEvent.TIMER,replayFunc);
               replayTimer.stop();
               makeEvents();
               if(Utils.openSuccess)
               {
                  _loc2_ = Utils.fileRef.data;
                  _loc2_.uncompress();
                  _loc3_ = new ReplayData(Main.MAXPLAYERS);
                  _loc3_.importReplay(_loc2_.readUTF());
                  if(_loc3_.VersionNumber != Version.getVersion() && ReplayData.COMPATIBLE_VERSIONS.indexOf(_loc3_.VersionNumber) < 0)
                  {
                     MultiplayerManager.notify("Error, incompatible version number. Received version\t" + _loc3_.VersionNumber + " (Expecting " + Version.getVersion() + ")");
                  }
                  else if(Boolean(ModeFeatures.hasFeature(ModeFeatures.ALLOW_REPLAY_RECORD,_loc3_.GameMode)) && _loc3_.GameMode !== Mode.CLASSIC)
                  {
                     MenuController.removeAllMenus();
                     if(_loc3_.GameMode === Mode.ONLINE)
                     {
                        MenuController.vsMenu.reset();
                        MenuController.CurrentCharacterSelectMenu = MenuController.vsMenu;
                        GameController.currentGame = new Game(_loc3_.PlayerData.length,Mode.VS);
                     }
                     else if(_loc3_.GameMode === Mode.ONLINE_ARENA || _loc3_.GameMode === Mode.ARENA)
                     {
                        MenuController.arenaCharacterSelectMenu.reset();
                        MenuController.CurrentCharacterSelectMenu = MenuController.arenaCharacterSelectMenu;
                        GameController.currentGame = new Game(_loc3_.PlayerData.length,Mode.ARENA);
                     }
                     else if(_loc3_.GameMode === Mode.TARGET_TEST)
                     {
                        MenuController.targetTestMenu.reset();
                        MenuController.CurrentCharacterSelectMenu = MenuController.targetTestMenu;
                        GameController.currentGame = new Game(_loc3_.PlayerData.length,Mode.TARGET_TEST);
                     }
                     else if(_loc3_.GameMode === Mode.HOME_RUN_CONTEST)
                     {
                        MenuController.homeRunContestMenu.reset();
                        MenuController.CurrentCharacterSelectMenu = MenuController.homeRunContestMenu;
                        GameController.currentGame = new Game(_loc3_.PlayerData.length,Mode.HOME_RUN_CONTEST);
                     }
                     else if(_loc3_.GameMode === Mode.MULTIMAN)
                     {
                        MenuController.multimanCharacterSelectMenu.reset();
                        MenuController.CurrentCharacterSelectMenu = MenuController.multimanCharacterSelectMenu;
                        GameController.currentGame = new Game(_loc3_.PlayerData.length,Mode.MULTIMAN);
                     }
                     else if(_loc3_.GameMode === Mode.CRYSTAL_SMASH)
                     {
                        MenuController.crystalSmashCharacterMenu.reset();
                        MenuController.CurrentCharacterSelectMenu = MenuController.crystalSmashCharacterMenu;
                        GameController.currentGame = new Game(_loc3_.PlayerData.length,Mode.CRYSTAL_SMASH);
                     }
                     else if(_loc3_.GameMode === Mode.RACE_TO_THE_FINISH)
                     {
                        MenuController.raceToTheFinishCharacterMenu.reset();
                        MenuController.CurrentCharacterSelectMenu = MenuController.raceToTheFinishCharacterMenu;
                        GameController.currentGame = new Game(_loc3_.PlayerData.length,Mode.RACE_TO_THE_FINISH);
                     }
                     else
                     {
                        MenuController.vsMenu.reset();
                        MenuController.CurrentCharacterSelectMenu = MenuController.vsMenu;
                        GameController.currentGame = new Game(_loc3_.PlayerData.length,_loc3_.GameMode);
                     }
                     MenuController.CurrentCharacterSelectMenu.GameObj.ReplayDataObj = _loc3_;
                     MenuController.CurrentCharacterSelectMenu.initReplay();
                  }
                  else
                  {
                     MultiplayerManager.notify("Replay file was not playable.");
                  }
               }
               else
               {
                  MultiplayerManager.notify("Replay file could not be loaded.");
               }
            }
         };
         this.killEvents();
         replayTimer.addEventListener(TimerEvent.TIMER,replayFunc);
         replayTimer.start();
      }
      
      private function replay_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Re-watch all the action!";
      }
      
      private function replay_MOUSE_OUT(param1:MouseEvent) : void
      {
         if(m_subMenu.desc_txt != null)
         {
            m_subMenu.desc_txt.text = "";
         }
      }
      
      private function back_CLICK_vault(param1:MouseEvent) : void
      {
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_back");
         MenuController.mainMenu.show();
      }
      
      private function back_ROLL_OVER_vault(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function home_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_back");
         SoundQueue.instance.stopMusic();
         MenuController.removeAllMenus();
         MenuController.titleMenu.show();
      }
      
      private function injectBnuys() : void
      {
         if(!this.PaletteMakerButton)
         {
            return;
         }
         m_subMenu.addChild(this.PaletteMakerButton);
         this.PaletteMakerButton.x = 110;
         this.PaletteMakerButton.y = 100;
         this.PaletteMakerButton.addEventListener(MouseEvent.MOUSE_OVER,this.paletteMaker_MOUSE_OVER);
         this.PaletteMakerButton.addEventListener(MouseEvent.CLICK,this.paletteMaker_CLICK);
         trace("Palette Maker Menu injected!");
      }
      
      private function makeStocksButtons() : void
      {
         var _loc3_:EventButton = null;
         var _loc4_:String = null;
         var _loc5_:MovieClip = null;
         var _loc1_:int = 14;
         this.characters = PaletteMakerUtils.getCharsCompatibleWithCostumes();
         this.container = new MovieClip();
         this.container.x = -295;
         this.container.y = -120;
         this.containerButton = new Vector.<EventButton>();
         this.m_characterGridNodes = new Vector.<MenuMapperNode>();
         m_subMenu.addChild(this.container);
         var _loc2_:int = 0;
         while(_loc2_ < this.characters.length)
         {
            _loc3_ = new EventButton(ResourceManager.getLibraryMC("StockButtonContainer"));
            _loc4_ = this.characters[_loc2_];
            _loc5_ = PaletteMakerUtils.getStockIcon(_loc4_,_loc4_ != "peach");
            this.containerButton.push(_loc3_);
            this.container.addChild(_loc3_.ButtonInstance);
            _loc3_.ButtonInstance.x = _loc2_ % _loc1_ * 45;
            _loc3_.ButtonInstance.y = int(_loc2_ / _loc1_) * 40;
            _loc3_.ButtonInstance.self.ph.addChild(_loc5_);
            _loc3_.ButtonInstance.addEventListener(MouseEvent.MOUSE_OVER,this.containerButton_OVER);
            _loc3_.ButtonInstance.addEventListener(MouseEvent.CLICK,this.containerButton_CLICK);
            _loc3_.ButtonInstance.addEventListener(MouseEvent.MOUSE_OUT,this.containerButton_OUT);
            this.m_characterGridNodes.push(new MenuMapperNode(_loc3_.ButtonInstance));
            _loc2_++;
         }
         this.setupCharacterGridNavigation(_loc1_);
      }
      
      private function setupCharacterGridNavigation(param1:int) : void
      {
         var leftNode:Array = null;
         var rightNode:Array = null;
         var upNode:Array = null;
         var downNode:Array = null;
         var charIndex:int = 0;
         var hoverFunc:Function = null;
         var cols:int = param1;
         var charCount:int = int(this.m_characterGridNodes.length);
         var i:int = 0;
         while(i < charCount)
         {
            leftNode = i % cols > 0 ? [this.m_characterGridNodes[i - 1]] : [];
            rightNode = i % cols < cols - 1 && i + 1 < charCount ? [this.m_characterGridNodes[i + 1]] : [];
            upNode = i >= cols ? [this.m_characterGridNodes[i - cols]] : [];
            downNode = i + cols < charCount ? [this.m_characterGridNodes[i + cols]] : [];
            charIndex = i;
            hoverFunc = (function(param1:int):Function
            {
               var index:int = param1;
               return function(param1:MouseEvent):void
               {
                  containerButton_OVER_ByIndex(index);
               };
            })(charIndex);
            this.m_characterGridNodes[i].updateNodes(upNode,downNode,leftNode,rightNode,hoverFunc,this.containerButton_OUT,this.containerButton_CLICK,this.back_CHARACTER_GRID,null,null);
            i++;
         }
      }
      
      private function containerButton_OVER_ByIndex(param1:int) : void
      {
         if(param1 >= 0 && param1 < this.characters.length)
         {
            this.selectedCharacter = this.characters[param1];
            SoundQueue.instance.playSoundEffect("menu_hover");
            m_subMenu.desc_txt.text = "Manage costumes for " + Stats.getStats(this.characters[param1]).DisplayName + ".";
         }
      }
      
      private function containerButton_OUT(param1:MouseEvent) : void
      {
         if(m_subMenu.desc_txt != null)
         {
            m_subMenu.desc_txt.text = "";
         }
      }
      
      private function removeStocksButtons() : void
      {
         var _loc2_:EventButton = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.containerButton.length)
         {
            _loc2_ = this.containerButton[_loc1_];
            _loc2_.ButtonInstance.removeEventListener(MouseEvent.MOUSE_OVER,this.containerButton_OVER);
            _loc2_.ButtonInstance.removeEventListener(MouseEvent.CLICK,this.containerButton_CLICK);
            _loc2_.ButtonInstance.removeEventListener(MouseEvent.MOUSE_OUT,this.replay_MOUSE_OUT);
            if(_loc2_.ButtonInstance.parent != null)
            {
               _loc2_.ButtonInstance.parent.removeChild(_loc2_.ButtonInstance);
            }
            _loc1_++;
         }
         this.containerButton = null;
      }
      
      private function containerButton_CLICK(param1:MouseEvent) : void
      {
         PaletteMakerUtils.showPaletteMakerLoadingScreen(this.selectedCharacter,true);
         ResourceManager.queueResources([this.selectedCharacter]);
         ResourceManager.load({"oncomplete":this.onComplete});
         SoundQueue.instance.playSoundEffect("pm_mark");
      }
      
      private function onComplete(param1:* = null) : void
      {
         var e:* = param1;
         var timer:Timer = new Timer(30,1);
         timer.addEventListener(TimerEvent.TIMER_COMPLETE,function(param1:TimerEvent):void
         {
            removeSelf();
            PaletteMakerMenu.setCharacter(selectedCharacter);
            MenuController.paletteMakerMenu.show();
         });
         timer.start();
      }
      
      private function containerButton_OVER(param1:MouseEvent) : void
      {
         var _loc2_:int = int(this.findEvent(param1.target as MovieClip));
         if(_loc2_ >= 0 && _loc2_ < this.characters.length)
         {
            this.containerButton_OVER_ByIndex(_loc2_);
         }
      }
      
      private function back_CHARACTER_GRID(param1:MouseEvent = null) : void
      {
         this.removeStocksButtons();
         this.gtfo(0);
         this.PaletteMakerButton.y = 100;
         this.PaletteMakerButton.addEventListener(MouseEvent.CLICK,this.paletteMaker_CLICK);
         this.PaletteMakerButton.addEventListener(MouseEvent.MOUSE_OVER,this.paletteMaker_MOUSE_OVER);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CHARACTER_GRID);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK_vault);
         this.restoreMainMenuMapper();
         SoundQueue.instance.playSoundEffect("menu_back");
      }
      
      private function paletteMaker_CLICK(param1:MouseEvent) : void
      {
         if(this.PaletteMakerButton)
         {
            this.PaletteMakerButton.removeEventListener(MouseEvent.CLICK,this.paletteMaker_CLICK);
            this.PaletteMakerButton.removeEventListener(MouseEvent.MOUSE_OVER,this.paletteMaker_MOUSE_OVER);
            this.PaletteMakerButton.y = 9999;
         }
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK_vault);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_CHARACTER_GRID);
         this.makeStocksButtons();
         this.gtfo(9999);
         this.switchToCharacterGridMapper();
         SoundQueue.instance.playSoundEffect("menu_select");
      }
      
      private function switchToCharacterGridMapper() : void
      {
         if(Boolean(this.m_characterGridNodes) && this.m_characterGridNodes.length > 0)
         {
            m_menuMapper = new MenuMapper(this.m_characterGridNodes[0]);
            m_menuMapper.init();
         }
      }
      
      private function restoreMainMenuMapper() : void
      {
         m_menuMapper = this.m_mainMenuMapper;
         m_menuMapper.init();
      }
      
      private function gtfo(param1:Number) : void
      {
         MovieClip(m_subMenu.intro_btn).y = param1;
         MovieClip(m_subMenu.intro2_btn).y = param1;
         MovieClip(m_subMenu.intro3_btn).y = param1;
         MovieClip(m_subMenu.replays_btn).y = param1;
      }
      
      private function paletteMaker_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Manage custom character palettes.";
      }
      
      private function paletteMaker_MOUSE_OUT(param1:MouseEvent) : void
      {
         if(m_subMenu.desc_txt != null)
         {
            m_subMenu.desc_txt.text = "";
         }
      }
      
      private function findEvent(param1:MovieClip) : int
      {
         var _loc2_:int = 0;
         if(Boolean(param1) && !param1.visible)
         {
            return -1;
         }
         while(_loc2_ < this.containerButton.length)
         {
            if(this.containerButton[_loc2_].ButtonInstance == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
   }
}


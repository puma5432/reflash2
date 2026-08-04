package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.input.*;
   import com.mcleodgaming.ssf2.modapi.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   
   public class TitleMenu extends Menu
   {
      
      private var m_playNode:MenuMapperNode;
      
      private var m_started:Boolean;
      
      public function TitleMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_title");
         m_backgroundID = "space";
         this.m_started = false;
         this.initMenuMappings();
         m_container.addChild(m_subMenu);
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         var _loc1_:String = Version.getVersion().split(".").splice(0,3).join(".");
         var _loc2_:String = Version.getVersion().split(".")[3];
         m_subMenu.build_txt.text = _loc2_ !== "0" ? _loc1_ + "." + _loc2_ + " + ModAPI " + ModAPI.getAPIVersion() : _loc1_ + " + ModAPI " + ModAPI.getAPIVersion();
         m_subMenu.stop();
         m_subMenu.play_btn2.useHandCursor = true;
         m_subMenu.play_btn2.buttonMode = true;
      }
      
      override public function initMenuMappings() : void
      {
         this.m_playNode = new MenuMapperNode(m_subMenu.play_btn2);
         this.m_playNode.updateNodes(null,null,null,null,null,null,this.play_btn_CLICK,null);
         m_menuMapper = new MenuMapper(this.m_playNode);
         m_menuMapper.init();
      }
      
      override public function manageMenuMappings(param1:Event) : void
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
                     this.m_lastControllerIndex = _loc2_ - 1;
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
      
      override public function show() : void
      {
         super.show();
         m_subMenu.gotoAndPlay(1);
         m_subMenu.gotoAndPlay(2);
      }
      
      override public function makeEvents() : void
      {
         if(m_showCount == 0)
         {
            findSubMenuButtons();
         }
         super.makeEvents();
         resetAllButtons();
         m_subMenu.play_btn2.addEventListener(MouseEvent.CLICK,this.play_btn_CLICK);
         m_subMenu.mglink.addEventListener(MouseEvent.CLICK,this.callLink);
         m_subMenu.yt.addEventListener(MouseEvent.CLICK,this.ytLink);
         m_subMenu.twit.addEventListener(MouseEvent.CLICK,this.twitLink);
         m_subMenu.dsc.addEventListener(MouseEvent.CLICK,this.dscLink);
         m_subMenu.cred.addEventListener(MouseEvent.CLICK,this.cred_CLICK);
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,this.manageMenuMappings);
         setMenuMappingFocus();
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.play_btn2.removeEventListener(MouseEvent.CLICK,this.play_btn_CLICK);
         m_subMenu.mglink.removeEventListener(MouseEvent.CLICK,this.callLink);
         m_subMenu.yt.removeEventListener(MouseEvent.CLICK,this.ytLink);
         m_subMenu.twit.removeEventListener(MouseEvent.CLICK,this.twitLink);
         m_subMenu.dsc.removeEventListener(MouseEvent.CLICK,this.dscLink);
         m_subMenu.cred.removeEventListener(MouseEvent.CLICK,this.cred_CLICK);
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,this.manageMenuMappings);
      }
      
      override public function removeSelf() : void
      {
         super.removeSelf();
         m_subMenu.gotoAndStop(1);
      }
      
      private function cred_CLICK(param1:MouseEvent) : void
      {
         MenuController.creditsMenu.show();
      }
      
      private function callLink(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         var url:String = "https://www.supersmashflash.com";
         try
         {
            Main.getURL(url,"_blank");
         }
         catch(err:Error)
         {
            trace("Error occurred!");
         }
      }
      
      private function ytLink(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         var url:String = "https://www.youtube.com/c/SmashFlashDevs";
         try
         {
            Main.getURL(url,"_blank");
         }
         catch(err:Error)
         {
            trace("Error occurred!");
         }
      }
      
      private function twitLink(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         var url:String = "https://twitter.com/SmashFlashDevs/";
         try
         {
            Main.getURL(url,"_blank");
         }
         catch(err:Error)
         {
            trace("Error occurred!");
         }
      }
      
      private function dscLink(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         var url:String = "https://discord.gg/mcleodgaming";
         try
         {
            Main.getURL(url,"_blank");
         }
         catch(err:Error)
         {
            trace("Error occurred!");
         }
      }
      
      private function play_btn_CLICK(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Gamepad = null;
         if(!this.m_started)
         {
            this.m_started = true;
            SoundQueue.instance.playSoundEffect("menu_selectstage");
            Main.Root.stage.addEventListener(Event.ENTER_FRAME,this.play_btn_ENTER_FRAME);
            m_subMenu.starter.play();
            if(param1 is MouseEvent)
            {
               _loc2_ = 0;
               while(_loc2_ < SaveData.Controllers.length)
               {
                  if(Boolean(Gamepad.getGlobalRumbleEnabled()) && Boolean(SaveData.getRumbleEnabled(_loc2_ + 1)))
                  {
                     _loc3_ = SaveData.Controllers[_loc2_].GamepadInstance;
                     if(_loc3_ != null)
                     {
                        _loc3_.setRumble(0.4,0.4,80);
                     }
                     trace("Rumbling controller at port " + _loc2_);
                  }
                  _loc2_++;
               }
            }
            else if(this.m_lastControllerIndex >= 0 && Boolean(Gamepad.getGlobalRumbleEnabled()) && Boolean(SaveData.getRumbleEnabled(this.m_lastControllerIndex + 1)))
            {
               _loc3_ = SaveData.Controllers[this.m_lastControllerIndex].GamepadInstance;
               if(_loc3_ != null)
               {
                  _loc3_.setRumble(0.4,0.4,80);
               }
               trace("Rumbling controller at port " + this.m_lastControllerIndex);
            }
         }
      }
      
      private function play_btn_ENTER_FRAME(param1:Event) : void
      {
         if(Boolean(this.m_started) && m_subMenu.starter.currentFrame >= m_subMenu.starter.totalFrames)
         {
            this.removeSelf();
            this.m_started = false;
            Main.Root.stage.removeEventListener(Event.ENTER_FRAME,this.play_btn_ENTER_FRAME);
            m_subMenu.starter.gotoAndStop(1);
            if(Main.AUTHORIZED)
            {
               MenuController.mainMenu.show();
            }
            else
            {
               MenuController.blockedMenu.show();
            }
         }
      }
   }
}


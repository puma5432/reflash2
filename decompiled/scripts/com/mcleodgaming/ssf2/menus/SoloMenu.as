package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.modapi.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   
   public class SoloMenu extends Menu
   {
      
      private var m_allstarNode:MenuMapperNode;
      
      private var m_classicNode:MenuMapperNode;
      
      private var m_trainingNode:MenuMapperNode;
      
      private var m_stadiumNode:MenuMapperNode;
      
      private var m_eventsNode:MenuMapperNode;
      
      public function SoloMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_solo");
         m_backgroundID = "space";
         m_container.addChild(m_subMenu);
         this.initMenuMappings();
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         if(!Config.mode_events)
         {
            Utils.setBrightness(m_subMenu.events_btn,-100);
         }
         if(!Config.mode_stadium)
         {
            Utils.setBrightness(m_subMenu.stadium_btn,-100);
         }
         if(!Config.mode_training)
         {
            Utils.setBrightness(m_subMenu.training_btn,-100);
         }
         if(!Config.mode_classic)
         {
            Utils.setBrightness(m_subMenu.classic_btn,-100);
         }
         if(!Config.mode_allstar)
         {
            Utils.setBrightness(m_subMenu.allstar_btn,-100);
         }
      }
      
      override public function initMenuMappings() : void
      {
         this.m_classicNode = new MenuMapperNode(m_subMenu.classic_btn);
         this.m_allstarNode = new MenuMapperNode(m_subMenu.allstar_btn);
         this.m_trainingNode = new MenuMapperNode(m_subMenu.training_btn);
         this.m_stadiumNode = new MenuMapperNode(m_subMenu.stadium_btn);
         this.m_eventsNode = new MenuMapperNode(m_subMenu.events_btn);
         this.m_classicNode.updateNodes([this.m_trainingNode],[this.m_trainingNode],[this.m_allstarNode],[this.m_allstarNode],this.classic_MOUSE_OVER,this.classic_MOUSE_OUT,this.classic_CLICK,this.back_CLICK_menu);
         this.m_allstarNode.updateNodes([this.m_stadiumNode],[this.m_stadiumNode],[this.m_classicNode],[this.m_classicNode],this.allstar_MOUSE_OVER,this.allstar_MOUSE_OUT,this.allstar_CLICK,this.back_CLICK_menu);
         this.m_trainingNode.updateNodes([this.m_classicNode],[this.m_classicNode],[this.m_stadiumNode],[this.m_eventsNode],this.training_MOUSE_OVER,this.training_MOUSE_OUT,this.training_CLICK,this.back_CLICK_menu);
         this.m_stadiumNode.updateNodes([this.m_allstarNode],[this.m_allstarNode],[this.m_eventsNode],[this.m_trainingNode],this.stadium_MOUSE_OVER,this.stadium_MOUSE_OUT,this.stadium_CLICK,this.back_CLICK_menu);
         this.m_eventsNode.updateNodes([this.m_classicNode],[this.m_classicNode],[this.m_trainingNode],[this.m_stadiumNode],this.events_MOUSE_OVER,this.events_MOUSE_OUT,this.events_CLICK,this.back_CLICK_menu);
         m_menuMapper = new MenuMapper(this.m_classicNode);
         m_menuMapper.init();
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
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK_menu);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER_menu);
         m_subMenu.training_btn.addEventListener(MouseEvent.MOUSE_OVER,this.training_MOUSE_OVER);
         m_subMenu.training_btn.addEventListener(MouseEvent.MOUSE_OUT,this.training_MOUSE_OUT);
         m_subMenu.training_btn.addEventListener(MouseEvent.CLICK,this.training_CLICK);
         m_subMenu.allstar_btn.addEventListener(MouseEvent.MOUSE_OVER,this.allstar_MOUSE_OVER);
         m_subMenu.allstar_btn.addEventListener(MouseEvent.MOUSE_OUT,this.allstar_MOUSE_OUT);
         m_subMenu.allstar_btn.addEventListener(MouseEvent.CLICK,this.allstar_CLICK);
         m_subMenu.classic_btn.addEventListener(MouseEvent.MOUSE_OVER,this.classic_MOUSE_OVER);
         m_subMenu.classic_btn.addEventListener(MouseEvent.MOUSE_OUT,this.classic_MOUSE_OUT);
         m_subMenu.classic_btn.addEventListener(MouseEvent.CLICK,this.classic_CLICK);
         m_subMenu.events_btn.addEventListener(MouseEvent.MOUSE_OVER,this.events_MOUSE_OVER);
         m_subMenu.events_btn.addEventListener(MouseEvent.MOUSE_OUT,this.events_MOUSE_OUT);
         m_subMenu.events_btn.addEventListener(MouseEvent.CLICK,this.events_CLICK);
         m_subMenu.stadium_btn.addEventListener(MouseEvent.MOUSE_OVER,this.stadium_MOUSE_OVER);
         m_subMenu.stadium_btn.addEventListener(MouseEvent.MOUSE_OUT,this.stadium_MOUSE_OUT);
         m_subMenu.stadium_btn.addEventListener(MouseEvent.CLICK,this.stadium_CLICK);
         m_subMenu.bg_top.home_btn.addEventListener(MouseEvent.CLICK,this.home_CLICK);
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,manageMenuMappings);
         setMenuMappingFocus();
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK_menu);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER_menu);
         m_subMenu.training_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.training_MOUSE_OVER);
         m_subMenu.training_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.training_MOUSE_OUT);
         m_subMenu.training_btn.removeEventListener(MouseEvent.CLICK,this.training_CLICK);
         m_subMenu.allstar_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.allstar_MOUSE_OVER);
         m_subMenu.allstar_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.allstar_MOUSE_OUT);
         m_subMenu.allstar_btn.removeEventListener(MouseEvent.CLICK,this.allstar_CLICK);
         m_subMenu.classic_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.classic_MOUSE_OVER);
         m_subMenu.classic_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.classic_MOUSE_OUT);
         m_subMenu.classic_btn.removeEventListener(MouseEvent.CLICK,this.classic_CLICK);
         m_subMenu.events_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.events_MOUSE_OVER);
         m_subMenu.events_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.events_MOUSE_OUT);
         m_subMenu.events_btn.removeEventListener(MouseEvent.CLICK,this.events_CLICK);
         m_subMenu.stadium_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.stadium_MOUSE_OVER);
         m_subMenu.stadium_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.stadium_MOUSE_OUT);
         m_subMenu.stadium_btn.removeEventListener(MouseEvent.CLICK,this.stadium_CLICK);
         m_subMenu.bg_top.home_btn.removeEventListener(MouseEvent.CLICK,this.home_CLICK);
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,manageMenuMappings);
      }
      
      private function classic_MOUSE_OVER(param1:MouseEvent) : void
      {
         if(Config.mode_classic)
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            m_subMenu.desc_txt.text = "Defeat foes to advance!";
         }
      }
      
      private function classic_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function classic_CLICK(param1:MouseEvent) : void
      {
         if(Config.mode_classic)
         {
            ModAPI.triggerMenuRumble(m_lastControllerIndex >= 0 ? m_lastControllerIndex : 0);
            removeSelf();
            SoundQueue.instance.playSoundEffect("menu_selectstage");
            m_subMenu.desc_txt.text = "";
            MenuController.classicMenu.reset();
            MenuController.classicMenu.show();
            SoundQueue.instance.playVoiceEffect("narrator_classic");
         }
      }
      
      private function allstar_MOUSE_OVER(param1:MouseEvent) : void
      {
         if(Config.mode_allstar)
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            m_subMenu.desc_txt.text = "Defeat the entire cast with limited recovery items!";
         }
      }
      
      private function allstar_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function allstar_CLICK(param1:MouseEvent) : void
      {
         if(Config.mode_allstar)
         {
            ModAPI.triggerMenuRumble(m_lastControllerIndex >= 0 ? m_lastControllerIndex : 0);
            removeSelf();
            SoundQueue.instance.playSoundEffect("menu_selectstage");
            m_subMenu.desc_txt.text = "";
            MenuController.allstarMenu.reset();
            MenuController.allstarMenu.show();
            SoundQueue.instance.playVoiceEffect("narrator_allstar");
         }
      }
      
      private function events_MOUSE_OVER(param1:MouseEvent) : void
      {
         if(Config.mode_events)
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            m_subMenu.desc_txt.text = "Complete specific objectives!";
         }
      }
      
      private function events_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function events_CLICK(param1:MouseEvent) : void
      {
         if(Config.mode_events)
         {
            ModAPI.triggerMenuRumble(m_lastControllerIndex >= 0 ? m_lastControllerIndex : 0);
            removeSelf();
            SoundQueue.instance.playSoundEffect("menu_selectstage");
            m_subMenu.desc_txt.text = "";
            MenuController.eventMenu.reset();
            MenuController.eventMenu.show();
            SoundQueue.instance.playVoiceEffect("narrator_event");
         }
      }
      
      private function training_MOUSE_OVER(param1:MouseEvent) : void
      {
         if(Config.mode_training)
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            m_subMenu.desc_txt.text = "Head here for your daily training.";
         }
      }
      
      private function training_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function training_CLICK(param1:MouseEvent) : void
      {
         if(Config.mode_training)
         {
            ModAPI.triggerMenuRumble(m_lastControllerIndex >= 0 ? m_lastControllerIndex : 0);
            removeSelf();
            SoundQueue.instance.playSoundEffect("menu_selectstage");
            m_subMenu.desc_txt.text = "";
            MenuController.trainingMenu.reset();
            MenuController.trainingMenu.show();
            SoundQueue.instance.playVoiceEffect("narrator_training");
         }
      }
      
      private function adventure_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Adventure Mode.";
      }
      
      private function adventure_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function adventure_CLICK(param1:MouseEvent) : void
      {
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         m_subMenu.desc_txt.text = "";
      }
      
      private function stadium_MOUSE_OVER(param1:MouseEvent) : void
      {
         if(Config.mode_stadium)
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            m_subMenu.desc_txt.text = "Mini-game testing ground.";
         }
      }
      
      private function stadium_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function stadium_CLICK(param1:MouseEvent) : void
      {
         if(Config.mode_stadium)
         {
            ModAPI.triggerMenuRumble(m_lastControllerIndex >= 0 ? m_lastControllerIndex : 0);
            removeSelf();
            SoundQueue.instance.playSoundEffect("menu_select");
            m_subMenu.desc_txt.text = "";
            MenuController.stadiumMenu.show();
         }
      }
      
      private function back_CLICK_menu(param1:Event) : void
      {
         ModAPI.stopMenuRumble();
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_back");
         m_subMenu.desc_txt.text = "";
         MenuController.mainMenu.show();
      }
      
      private function back_ROLL_OVER_menu(param1:Event) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function home_CLICK(param1:MouseEvent) : void
      {
         ModAPI.stopMenuRumble();
         SoundQueue.instance.playSoundEffect("menu_back");
         SoundQueue.instance.stopMusic();
         MenuController.removeAllMenus();
         MenuController.titleMenu.show();
      }
   }
}


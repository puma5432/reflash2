package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.modapi.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   
   public class StadiumMenu extends Menu
   {
      
      private var m_targetTestNode:MenuMapperNode;
      
      private var m_hrcNode:MenuMapperNode;
      
      private var m_multimanNode:MenuMapperNode;
      
      private var m_crystalSmashNode:MenuMapperNode;
      
      private var m_raceToTheFinishNode:MenuMapperNode;
      
      public function StadiumMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_stadium");
         m_backgroundID = "space";
         m_container.addChild(m_subMenu);
         this.initMenuMappings();
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         if(!Config.mode_hrc)
         {
            Utils.setBrightness(m_subMenu.hrc_btn,-100);
         }
         if(!Config.mode_targettest)
         {
            Utils.setBrightness(m_subMenu.targettest_btn,-100);
         }
         if(!Config.mode_multiman)
         {
            Utils.setBrightness(m_subMenu.multiman_btn,-100);
         }
         if(!Config.mode_crystal_smash)
         {
            Utils.setBrightness(m_subMenu.crystal_btn,-100);
         }
         if(!Config.mode_race_to_the_finish)
         {
            Utils.setBrightness(m_subMenu.rttf_btn,-100);
         }
      }
      
      override public function initMenuMappings() : void
      {
         if(!Config.mode_race_to_the_finish)
         {
            this.m_targetTestNode = new MenuMapperNode(m_subMenu.targettest_btn);
            this.m_hrcNode = new MenuMapperNode(m_subMenu.hrc_btn);
            this.m_multimanNode = new MenuMapperNode(m_subMenu.multiman_btn);
            this.m_crystalSmashNode = new MenuMapperNode(m_subMenu.crystal_btn);
            this.m_targetTestNode.updateNodes(null,null,[this.m_crystalSmashNode],[this.m_hrcNode],this.targettest_MOUSE_OVER,this.targettest_MOUSE_OUT,this.targettest_CLICK,this.back_CLICK_solo,null,null);
            this.m_hrcNode.updateNodes(null,null,[this.m_targetTestNode],[this.m_multimanNode],this.hrc_MOUSE_OVER,this.hrc_MOUSE_OUT,this.hrc_CLICK,this.back_CLICK_solo,null,null);
            this.m_multimanNode.updateNodes(null,null,[this.m_hrcNode],[this.m_crystalSmashNode],this.multiman_MOUSE_OVER,this.multiman_MOUSE_OUT,this.multiman_CLICK,this.back_CLICK_solo,null,null);
            this.m_crystalSmashNode.updateNodes(null,null,[this.m_multimanNode],[this.m_targetTestNode],this.crystal_MOUSE_OVER,this.crystal_MOUSE_OUT,this.crystal_CLICK,this.back_CLICK_solo,null,null);
            m_menuMapper = new MenuMapper(this.m_targetTestNode);
            m_menuMapper.init();
         }
         else
         {
            this.m_targetTestNode = new MenuMapperNode(m_subMenu.targettest_btn);
            this.m_hrcNode = new MenuMapperNode(m_subMenu.hrc_btn);
            this.m_multimanNode = new MenuMapperNode(m_subMenu.multiman_btn);
            this.m_crystalSmashNode = new MenuMapperNode(m_subMenu.crystal_btn);
            this.m_raceToTheFinishNode = new MenuMapperNode(m_subMenu.rttf_btn);
            this.m_targetTestNode.updateNodes(null,null,[this.m_raceToTheFinishNode],[this.m_hrcNode],this.targettest_MOUSE_OVER,this.targettest_MOUSE_OUT,this.targettest_CLICK,this.back_CLICK_solo,null,null);
            this.m_hrcNode.updateNodes(null,null,[this.m_targetTestNode],[this.m_multimanNode],this.hrc_MOUSE_OVER,this.hrc_MOUSE_OUT,this.hrc_CLICK,this.back_CLICK_solo,null,null);
            this.m_multimanNode.updateNodes(null,null,[this.m_hrcNode],[this.m_crystalSmashNode],this.multiman_MOUSE_OVER,this.multiman_MOUSE_OUT,this.multiman_CLICK,this.back_CLICK_solo,null,null);
            this.m_crystalSmashNode.updateNodes(null,null,[this.m_multimanNode],[this.m_raceToTheFinishNode],this.crystal_MOUSE_OVER,this.crystal_MOUSE_OUT,this.crystal_CLICK,this.back_CLICK_solo,null,null);
            this.m_raceToTheFinishNode.updateNodes(null,null,[this.m_crystalSmashNode],[this.m_targetTestNode],this.racetothefinish_MOUSE_OVER,this.racetothefinish_MOUSE_OUT,this.racetothefinish_CLICK,this.back_CLICK_solo,null,null);
            m_menuMapper = new MenuMapper(this.m_targetTestNode);
            m_menuMapper.init();
         }
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
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK_solo);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER_solo);
         m_subMenu.targettest_btn.addEventListener(MouseEvent.MOUSE_OVER,this.targettest_MOUSE_OVER);
         m_subMenu.targettest_btn.addEventListener(MouseEvent.MOUSE_OUT,this.targettest_MOUSE_OUT);
         m_subMenu.targettest_btn.addEventListener(MouseEvent.CLICK,this.targettest_CLICK);
         m_subMenu.hrc_btn.addEventListener(MouseEvent.MOUSE_OVER,this.hrc_MOUSE_OVER);
         m_subMenu.hrc_btn.addEventListener(MouseEvent.MOUSE_OUT,this.hrc_MOUSE_OUT);
         m_subMenu.hrc_btn.addEventListener(MouseEvent.CLICK,this.hrc_CLICK);
         m_subMenu.multiman_btn.addEventListener(MouseEvent.MOUSE_OVER,this.multiman_MOUSE_OVER);
         m_subMenu.multiman_btn.addEventListener(MouseEvent.MOUSE_OUT,this.multiman_MOUSE_OUT);
         m_subMenu.multiman_btn.addEventListener(MouseEvent.CLICK,this.multiman_CLICK);
         m_subMenu.crystal_btn.addEventListener(MouseEvent.MOUSE_OVER,this.crystal_MOUSE_OVER);
         m_subMenu.crystal_btn.addEventListener(MouseEvent.MOUSE_OUT,this.crystal_MOUSE_OUT);
         m_subMenu.crystal_btn.addEventListener(MouseEvent.CLICK,this.crystal_CLICK);
         m_subMenu.rttf_btn.addEventListener(MouseEvent.MOUSE_OVER,this.racetothefinish_MOUSE_OVER);
         m_subMenu.rttf_btn.addEventListener(MouseEvent.MOUSE_OUT,this.racetothefinish_MOUSE_OUT);
         m_subMenu.rttf_btn.addEventListener(MouseEvent.CLICK,this.racetothefinish_CLICK);
         m_subMenu.bg_top.home_btn.addEventListener(MouseEvent.CLICK,this.home_CLICK);
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,manageMenuMappings);
         setMenuMappingFocus();
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK_solo);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER_solo);
         m_subMenu.targettest_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.targettest_MOUSE_OVER);
         m_subMenu.targettest_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.targettest_MOUSE_OUT);
         m_subMenu.targettest_btn.removeEventListener(MouseEvent.CLICK,this.targettest_CLICK);
         m_subMenu.hrc_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.hrc_MOUSE_OVER);
         m_subMenu.hrc_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.hrc_MOUSE_OUT);
         m_subMenu.hrc_btn.removeEventListener(MouseEvent.CLICK,this.hrc_CLICK);
         m_subMenu.multiman_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.multiman_MOUSE_OVER);
         m_subMenu.multiman_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.multiman_MOUSE_OUT);
         m_subMenu.multiman_btn.removeEventListener(MouseEvent.CLICK,this.multiman_CLICK);
         m_subMenu.crystal_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.crystal_MOUSE_OVER);
         m_subMenu.crystal_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.crystal_MOUSE_OUT);
         m_subMenu.crystal_btn.removeEventListener(MouseEvent.CLICK,this.crystal_CLICK);
         m_subMenu.rttf_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.racetothefinish_MOUSE_OVER);
         m_subMenu.rttf_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.racetothefinish_MOUSE_OUT);
         m_subMenu.rttf_btn.removeEventListener(MouseEvent.CLICK,this.racetothefinish_CLICK);
         m_subMenu.bg_top.home_btn.removeEventListener(MouseEvent.CLICK,this.home_CLICK);
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,manageMenuMappings);
      }
      
      private function targettest_MOUSE_OVER(param1:MouseEvent) : void
      {
         if(Config.mode_targettest)
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            m_subMenu.desc_txt.text = "Target test practice.";
         }
      }
      
      private function targettest_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function targettest_CLICK(param1:MouseEvent) : void
      {
         if(Config.mode_targettest)
         {
            ModAPI.triggerMenuRumble(m_lastControllerIndex >= 0 ? m_lastControllerIndex : 0);
            removeSelf();
            SoundQueue.instance.playSoundEffect("menu_selectstage");
            m_subMenu.desc_txt.text = "";
            MenuController.targetTestMenu.reset();
            MenuController.targetTestMenu.show();
            SoundQueue.instance.playVoiceEffect("narrator_targets");
         }
      }
      
      private function hrc_MOUSE_OVER(param1:MouseEvent) : void
      {
         if(Config.mode_hrc)
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            m_subMenu.desc_txt.text = "Help Sandbag go the distance! It\'s a glutton for punishment!";
         }
      }
      
      private function hrc_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function hrc_CLICK(param1:MouseEvent) : void
      {
         if(Config.mode_hrc)
         {
            ModAPI.triggerMenuRumble(m_lastControllerIndex >= 0 ? m_lastControllerIndex : 0);
            removeSelf();
            SoundQueue.instance.playSoundEffect("menu_selectstage");
            m_subMenu.desc_txt.text = "";
            MenuController.homeRunContestMenu.reset();
            MenuController.homeRunContestMenu.show();
            SoundQueue.instance.playVoiceEffect("narrator_hrc");
         }
      }
      
      private function multiman_MOUSE_OVER(param1:MouseEvent) : void
      {
         if(Config.mode_multiman)
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            m_subMenu.desc_txt.text = "Fight for your life! Fight!";
         }
      }
      
      private function multiman_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function multiman_CLICK(param1:MouseEvent) : void
      {
         if(Config.mode_multiman)
         {
            ModAPI.triggerMenuRumble(m_lastControllerIndex >= 0 ? m_lastControllerIndex : 0);
            removeSelf();
            SoundQueue.instance.playSoundEffect("menu_select");
            m_subMenu.desc_txt.text = "";
            MenuController.multimanMenu.show();
         }
      }
      
      private function crystal_MOUSE_OVER(param1:MouseEvent) : void
      {
         if(Config.mode_crystal_smash)
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            m_subMenu.desc_txt.text = "Shatter crystals as fast as you can!";
         }
      }
      
      private function crystal_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function crystal_CLICK(param1:MouseEvent) : void
      {
         if(Config.mode_crystal_smash)
         {
            ModAPI.triggerMenuRumble(m_lastControllerIndex >= 0 ? m_lastControllerIndex : 0);
            removeSelf();
            SoundQueue.instance.playSoundEffect("menu_select");
            m_subMenu.desc_txt.text = "";
            MenuController.crystalSmashCharacterMenu.reset();
            MenuController.crystalSmashCharacterMenu.show();
            SoundQueue.instance.playVoiceEffect("narrator_crystalsmash");
         }
      }
      
      private function racetothefinish_MOUSE_OVER(param1:MouseEvent) : void
      {
         if(Config.mode_race_to_the_finish)
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            m_subMenu.desc_txt.text = "Get to the goal as fast you can!";
         }
      }
      
      private function racetothefinish_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function racetothefinish_CLICK(param1:MouseEvent) : void
      {
         if(Config.mode_race_to_the_finish)
         {
            ModAPI.triggerMenuRumble(m_lastControllerIndex >= 0 ? m_lastControllerIndex : 0);
            removeSelf();
            SoundQueue.instance.playSoundEffect("menu_select");
            m_subMenu.desc_txt.text = "";
            MenuController.raceToTheFinishCharacterMenu.reset();
            MenuController.raceToTheFinishCharacterMenu.show();
            SoundQueue.instance.playVoiceEffect("narrator_racetothefinish");
         }
      }
      
      private function back_CLICK_solo(param1:MouseEvent) : void
      {
         ModAPI.stopMenuRumble();
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_back");
         m_subMenu.desc_txt.text = "";
         MenuController.soloMenu.show();
      }
      
      private function back_ROLL_OVER_solo(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function home_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_back");
         SoundQueue.instance.stopMusic();
         MenuController.disposeAllMenus(true);
         MenuController.titleMenu.show();
      }
   }
}


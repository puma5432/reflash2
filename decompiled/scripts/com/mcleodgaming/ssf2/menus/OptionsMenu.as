package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   
   public class OptionsMenu extends Menu
   {
      
      private var m_soundNode:MenuMapperNode;
      
      private var m_qualityNode:MenuMapperNode;
      
      private var m_controlsNode:MenuMapperNode;
      
      public function OptionsMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_options");
         m_backgroundID = "space";
         m_container.addChild(m_subMenu);
         this.initMenuMappings();
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
      }
      
      override public function initMenuMappings() : void
      {
         this.m_soundNode = new MenuMapperNode(m_subMenu.sounds_btn);
         this.m_qualityNode = new MenuMapperNode(m_subMenu.quality_btn);
         this.m_controlsNode = new MenuMapperNode(m_subMenu.controls_btn);
         this.m_soundNode.updateNodes(null,null,[this.m_controlsNode],[this.m_qualityNode],this.sounds_MOUSE_OVER,this.sounds_MOUSE_OUT,this.sounds_CLICK,this.back_CLICK_main);
         this.m_qualityNode.updateNodes(null,null,[this.m_soundNode],[this.m_controlsNode],this.quality_MOUSE_OVER,this.quality_MOUSE_OUT,this.quality_CLICK,this.back_CLICK_main);
         this.m_controlsNode.updateNodes(null,null,[this.m_qualityNode],[this.m_soundNode],this.controls_MOUSE_OVER,this.controls_MOUSE_OUT,this.controls_CLICK,this.back_CLICK_main);
         m_menuMapper = new MenuMapper(this.m_soundNode);
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
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK_main);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.MOUSE_OVER,this.back_MOUSE_OVER_main);
         m_subMenu.controls_btn.addEventListener(MouseEvent.CLICK,this.controls_CLICK);
         m_subMenu.controls_btn.addEventListener(MouseEvent.MOUSE_OVER,this.controls_MOUSE_OVER);
         m_subMenu.controls_btn.addEventListener(MouseEvent.MOUSE_OUT,this.controls_MOUSE_OUT);
         m_subMenu.sounds_btn.addEventListener(MouseEvent.CLICK,this.sounds_CLICK);
         m_subMenu.sounds_btn.addEventListener(MouseEvent.MOUSE_OVER,this.sounds_MOUSE_OVER);
         m_subMenu.sounds_btn.addEventListener(MouseEvent.MOUSE_OUT,this.sounds_MOUSE_OUT);
         m_subMenu.quality_btn.addEventListener(MouseEvent.CLICK,this.quality_CLICK);
         m_subMenu.quality_btn.addEventListener(MouseEvent.MOUSE_OVER,this.quality_MOUSE_OVER);
         m_subMenu.quality_btn.addEventListener(MouseEvent.MOUSE_OUT,this.quality_MOUSE_OUT);
         m_subMenu.bg_top.home_btn.addEventListener(MouseEvent.CLICK,this.home_CLICK);
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,manageMenuMappings);
         setMenuMappingFocus();
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK_main);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.back_MOUSE_OVER_main);
         m_subMenu.controls_btn.removeEventListener(MouseEvent.CLICK,this.controls_CLICK);
         m_subMenu.controls_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.controls_MOUSE_OVER);
         m_subMenu.controls_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.controls_MOUSE_OUT);
         m_subMenu.sounds_btn.removeEventListener(MouseEvent.CLICK,this.sounds_CLICK);
         m_subMenu.sounds_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.sounds_MOUSE_OVER);
         m_subMenu.sounds_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.sounds_MOUSE_OUT);
         m_subMenu.quality_btn.removeEventListener(MouseEvent.CLICK,this.quality_CLICK);
         m_subMenu.quality_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.quality_MOUSE_OVER);
         m_subMenu.quality_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.quality_MOUSE_OUT);
         m_subMenu.bg_top.home_btn.removeEventListener(MouseEvent.CLICK,this.home_CLICK);
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,manageMenuMappings);
      }
      
      private function back_CLICK_main(param1:MouseEvent) : void
      {
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_back");
         MenuController.mainMenu.show();
      }
      
      private function back_MOUSE_OVER_main(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function controls_CLICK(param1:MouseEvent) : void
      {
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_select");
         m_subMenu.desc_txt.text = "";
         MenuController.controlsMenu.show();
      }
      
      private function controls_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Modify control settings.";
      }
      
      private function controls_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function sounds_CLICK(param1:MouseEvent) : void
      {
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_select");
         m_subMenu.desc_txt.text = "";
         MenuController.soundMenu.show();
      }
      
      private function sounds_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Customize audio volumes.";
      }
      
      private function sounds_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function quality_CLICK(param1:MouseEvent) : void
      {
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_select");
         m_subMenu.desc_txt.text = "";
         MenuController.qualityMenu.show();
      }
      
      private function quality_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Adjust the game\'s visual settings.";
      }
      
      private function quality_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function home_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_back");
         SoundQueue.instance.stopMusic();
         MenuController.removeAllMenus();
         MenuController.titleMenu.show();
      }
   }
}


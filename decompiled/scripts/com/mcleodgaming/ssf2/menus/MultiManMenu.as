package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.modapi.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   
   public class MultiManMenu extends Menu
   {
      
      public static var SELECTED_MULTI_MAN_MODE:String = null;
      
      private var m_10ManNode:MenuMapperNode;
      
      private var m_100ManNode:MenuMapperNode;
      
      private var m_3MinuteNode:MenuMapperNode;
      
      private var m_endlessNode:MenuMapperNode;
      
      private var m_cruelNode:MenuMapperNode;
      
      public function MultiManMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_multiman");
         m_backgroundID = "space";
         m_container.addChild(m_subMenu);
         this.initMenuMappings();
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
      }
      
      override public function initMenuMappings() : void
      {
         this.m_10ManNode = new MenuMapperNode(m_subMenu.man10_btn);
         this.m_100ManNode = new MenuMapperNode(m_subMenu.man100_btn);
         this.m_3MinuteNode = new MenuMapperNode(m_subMenu.min3_btn);
         this.m_endlessNode = new MenuMapperNode(m_subMenu.endless_btn);
         this.m_cruelNode = new MenuMapperNode(m_subMenu.cruel_btn);
         this.m_10ManNode.updateNodes([this.m_cruelNode],[this.m_100ManNode],null,null,this.man10_MOUSE_OVER,this.clearDescription,this.man10_CLICK,this.back_CLICK_multiman,null,null);
         this.m_100ManNode.updateNodes([this.m_10ManNode],[this.m_3MinuteNode],null,null,this.man100_MOUSE_OVER,this.clearDescription,this.man100_CLICK,this.back_CLICK_multiman,null,null);
         this.m_3MinuteNode.updateNodes([this.m_100ManNode],[this.m_endlessNode],null,null,this.min3_MOUSE_OVER,this.clearDescription,this.min3_CLICK,this.back_CLICK_multiman,null,null);
         this.m_endlessNode.updateNodes([this.m_3MinuteNode],[this.m_cruelNode],null,null,this.endless_MOUSE_OVER,this.clearDescription,this.endless_CLICK,this.back_CLICK_multiman,null,null);
         this.m_cruelNode.updateNodes([this.m_endlessNode],[this.m_10ManNode],null,null,this.cruel_MOUSE_OVER,this.clearDescription,this.cruel_CLICK,this.back_CLICK_multiman,null,null);
         m_menuMapper = new MenuMapper(this.m_10ManNode);
         m_menuMapper.init();
      }
      
      override public function show() : void
      {
         super.show();
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
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK_multiman);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER_multiman);
         m_subMenu.man10_btn.addEventListener(MouseEvent.CLICK,this.man10_CLICK);
         m_subMenu.man10_btn.addEventListener(MouseEvent.MOUSE_OVER,this.man10_MOUSE_OVER);
         m_subMenu.man10_btn.addEventListener(MouseEvent.MOUSE_OUT,this.clearDescription);
         m_subMenu.man100_btn.addEventListener(MouseEvent.CLICK,this.man100_CLICK);
         m_subMenu.man100_btn.addEventListener(MouseEvent.MOUSE_OVER,this.man100_MOUSE_OVER);
         m_subMenu.man100_btn.addEventListener(MouseEvent.MOUSE_OUT,this.clearDescription);
         m_subMenu.min3_btn.addEventListener(MouseEvent.CLICK,this.min3_CLICK);
         m_subMenu.min3_btn.addEventListener(MouseEvent.MOUSE_OVER,this.min3_MOUSE_OVER);
         m_subMenu.min3_btn.addEventListener(MouseEvent.MOUSE_OUT,this.clearDescription);
         m_subMenu.endless_btn.addEventListener(MouseEvent.CLICK,this.endless_CLICK);
         m_subMenu.endless_btn.addEventListener(MouseEvent.MOUSE_OVER,this.endless_MOUSE_OVER);
         m_subMenu.endless_btn.addEventListener(MouseEvent.MOUSE_OUT,this.clearDescription);
         m_subMenu.cruel_btn.addEventListener(MouseEvent.CLICK,this.cruel_CLICK);
         m_subMenu.cruel_btn.addEventListener(MouseEvent.MOUSE_OVER,this.cruel_MOUSE_OVER);
         m_subMenu.cruel_btn.addEventListener(MouseEvent.MOUSE_OUT,this.clearDescription);
         m_subMenu.bg_top.home_btn.addEventListener(MouseEvent.CLICK,this.home_CLICK);
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,manageMenuMappings);
         setMenuMappingFocus();
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK_multiman);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER_multiman);
         m_subMenu.man10_btn.removeEventListener(MouseEvent.CLICK,this.man10_CLICK);
         m_subMenu.man10_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.man10_MOUSE_OVER);
         m_subMenu.man10_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.clearDescription);
         m_subMenu.man100_btn.removeEventListener(MouseEvent.CLICK,this.man100_CLICK);
         m_subMenu.man100_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.man100_MOUSE_OVER);
         m_subMenu.man100_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.clearDescription);
         m_subMenu.min3_btn.removeEventListener(MouseEvent.CLICK,this.min3_CLICK);
         m_subMenu.min3_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.min3_MOUSE_OVER);
         m_subMenu.min3_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.clearDescription);
         m_subMenu.endless_btn.removeEventListener(MouseEvent.CLICK,this.endless_CLICK);
         m_subMenu.endless_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.endless_MOUSE_OVER);
         m_subMenu.endless_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.clearDescription);
         m_subMenu.cruel_btn.removeEventListener(MouseEvent.CLICK,this.cruel_CLICK);
         m_subMenu.cruel_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.cruel_MOUSE_OVER);
         m_subMenu.cruel_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.clearDescription);
         m_subMenu.bg_top.home_btn.removeEventListener(MouseEvent.CLICK,this.home_CLICK);
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,manageMenuMappings);
      }
      
      private function clearDescription(param1:* = null) : void
      {
         if(m_subMenu.desc_txt != null)
         {
            m_subMenu.desc_txt.text = "";
         }
      }
      
      private function man10_CLICK(param1:MouseEvent) : void
      {
         ModAPI.triggerMenuRumble(m_lastControllerIndex >= 0 ? m_lastControllerIndex : 0);
         MultiManMenu.SELECTED_MULTI_MAN_MODE = "man10";
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         MenuController.multimanCharacterSelectMenu.reset();
         MenuController.multimanCharacterSelectMenu.show();
         SoundQueue.instance.playVoiceEffect("narrator_multiman");
      }
      
      private function man10_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "How fast can you defeat 10 opponents?";
      }
      
      private function man100_CLICK(param1:MouseEvent) : void
      {
         ModAPI.triggerMenuRumble(m_lastControllerIndex >= 0 ? m_lastControllerIndex : 0);
         MultiManMenu.SELECTED_MULTI_MAN_MODE = "man100";
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         MenuController.multimanCharacterSelectMenu.reset();
         MenuController.multimanCharacterSelectMenu.show();
         SoundQueue.instance.playVoiceEffect("narrator_multiman");
      }
      
      private function man100_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "100 enemies! Can you defeat them all?";
      }
      
      private function min3_CLICK(param1:MouseEvent) : void
      {
         ModAPI.triggerMenuRumble(m_lastControllerIndex >= 0 ? m_lastControllerIndex : 0);
         MultiManMenu.SELECTED_MULTI_MAN_MODE = "min3";
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         MenuController.multimanCharacterSelectMenu.reset();
         MenuController.multimanCharacterSelectMenu.show();
         SoundQueue.instance.playVoiceEffect("narrator_multiman");
      }
      
      private function min3_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "How many foes can you KO in 3 minutes?";
      }
      
      private function endless_CLICK(param1:MouseEvent) : void
      {
         ModAPI.triggerMenuRumble(m_lastControllerIndex >= 0 ? m_lastControllerIndex : 0);
         MultiManMenu.SELECTED_MULTI_MAN_MODE = "endless";
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         MenuController.multimanCharacterSelectMenu.reset();
         MenuController.multimanCharacterSelectMenu.show();
         SoundQueue.instance.playVoiceEffect("narrator_multiman");
      }
      
      private function endless_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "The enemies don\'t stop until you\'re defeated.";
      }
      
      private function cruel_CLICK(param1:MouseEvent) : void
      {
         ModAPI.triggerMenuRumble(m_lastControllerIndex >= 0 ? m_lastControllerIndex : 0);
         MultiManMenu.SELECTED_MULTI_MAN_MODE = "cruel";
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         MenuController.multimanCharacterSelectMenu.reset();
         MenuController.multimanCharacterSelectMenu.show();
         SoundQueue.instance.playVoiceEffect("narrator_multiman");
      }
      
      private function cruel_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "The toughest enemies around and no items!";
      }
      
      private function back_CLICK_multiman(param1:MouseEvent) : void
      {
         ModAPI.stopMenuRumble();
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_back");
         MenuController.stadiumMenu.show();
      }
      
      private function back_ROLL_OVER_multiman(param1:MouseEvent) : void
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


package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.net.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   
   public class SpecialModeMenu extends Menu
   {
      
      private var selectHand:SelectHand;
      
      private var m_specialButtons:Vector.<HandButton>;
      
      private var m_specialModeFlags:int;
      
      public function SpecialModeMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_special");
         m_backgroundID = "space";
         m_container.addChild(m_subMenu);
         this.m_specialModeFlags = 0;
         this.m_specialButtons = new Vector.<HandButton>();
         this.selectHand = new SelectHand(m_subMenu,this.m_specialButtons,this.back_CLICK_mode);
         this.selectHand.addClickEventClipHitTest(m_subMenu.bg_top.back_btn);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.size_toggle);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.speed_toggle);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.vampire_toggle);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.freeze_toggle);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.special_toggle);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.weight_toggle);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.visibility_toggle);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.ssf1_toggle);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.mini_btn);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.mega_btn);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.slow_btn);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.lightning_btn);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.vampire_btn);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.vengeance_btn);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.freeze_btn);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.egg_btn);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.dramatic_btn);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.turbo_btn);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.light_btn);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.heavy_btn);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.invisible_btn);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.metal_btn);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.ssf1_btn);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.ok_btn);
         initMenuMappings();
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
      }
      
      override public function makeEvents() : void
      {
         var _loc1_:int = 0;
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         resetAllButtons();
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK_mode);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.MOUSE_OVER,this.back_MOUSE_OVER_mode);
         m_subMenu.size_toggle.addEventListener(MouseEvent.MOUSE_OVER,this.size_toggle_MOUSE_OVER);
         m_subMenu.size_toggle.addEventListener(MouseEvent.MOUSE_OUT,this.size_toggle_MOUSE_OUT);
         m_subMenu.size_toggle.addEventListener(MouseEvent.CLICK,this.size_toggle_CLICK);
         m_subMenu.speed_toggle.addEventListener(MouseEvent.MOUSE_OVER,this.speed_toggle_MOUSE_OVER);
         m_subMenu.speed_toggle.addEventListener(MouseEvent.MOUSE_OUT,this.speed_toggle_MOUSE_OUT);
         m_subMenu.speed_toggle.addEventListener(MouseEvent.CLICK,this.speed_toggle_CLICK);
         m_subMenu.vampire_toggle.addEventListener(MouseEvent.MOUSE_OVER,this.vampire_toggle_MOUSE_OVER);
         m_subMenu.vampire_toggle.addEventListener(MouseEvent.MOUSE_OUT,this.vampire_toggle_MOUSE_OUT);
         m_subMenu.vampire_toggle.addEventListener(MouseEvent.CLICK,this.vampire_toggle_CLICK);
         m_subMenu.freeze_toggle.addEventListener(MouseEvent.MOUSE_OVER,this.freeze_toggle_MOUSE_OVER);
         m_subMenu.freeze_toggle.addEventListener(MouseEvent.MOUSE_OUT,this.freeze_toggle_MOUSE_OUT);
         m_subMenu.freeze_toggle.addEventListener(MouseEvent.CLICK,this.freeze_toggle_CLICK);
         m_subMenu.special_toggle.addEventListener(MouseEvent.MOUSE_OVER,this.special_toggle_MOUSE_OVER);
         m_subMenu.special_toggle.addEventListener(MouseEvent.MOUSE_OUT,this.special_toggle_MOUSE_OUT);
         m_subMenu.special_toggle.addEventListener(MouseEvent.CLICK,this.special_toggle_CLICK);
         m_subMenu.weight_toggle.addEventListener(MouseEvent.MOUSE_OVER,this.weight_toggle_MOUSE_OVER);
         m_subMenu.weight_toggle.addEventListener(MouseEvent.MOUSE_OUT,this.weight_toggle_MOUSE_OUT);
         m_subMenu.weight_toggle.addEventListener(MouseEvent.CLICK,this.weight_toggle_CLICK);
         m_subMenu.visibility_toggle.addEventListener(MouseEvent.MOUSE_OVER,this.visibility_toggle_MOUSE_OVER);
         m_subMenu.visibility_toggle.addEventListener(MouseEvent.MOUSE_OUT,this.visibility_toggle_MOUSE_OUT);
         m_subMenu.visibility_toggle.addEventListener(MouseEvent.CLICK,this.visibility_toggle_CLICK);
         m_subMenu.ssf1_toggle.addEventListener(MouseEvent.MOUSE_OVER,this.ssf1_toggle_MOUSE_OVER);
         m_subMenu.ssf1_toggle.addEventListener(MouseEvent.MOUSE_OUT,this.ssf1_toggle_MOUSE_OUT);
         m_subMenu.ssf1_toggle.addEventListener(MouseEvent.CLICK,this.ssf1_toggle_CLICK);
         m_subMenu.mini_btn.addEventListener(MouseEvent.MOUSE_OVER,this.mini_MOUSE_OVER);
         m_subMenu.mini_btn.addEventListener(MouseEvent.MOUSE_OUT,this.mini_MOUSE_OUT);
         m_subMenu.mini_btn.addEventListener(MouseEvent.CLICK,this.mini_CLICK);
         m_subMenu.mega_btn.addEventListener(MouseEvent.MOUSE_OVER,this.mega_MOUSE_OVER);
         m_subMenu.mega_btn.addEventListener(MouseEvent.MOUSE_OUT,this.mega_MOUSE_OUT);
         m_subMenu.mega_btn.addEventListener(MouseEvent.CLICK,this.mega_CLICK);
         m_subMenu.slow_btn.addEventListener(MouseEvent.MOUSE_OVER,this.slow_MOUSE_OVER);
         m_subMenu.slow_btn.addEventListener(MouseEvent.MOUSE_OUT,this.slow_MOUSE_OUT);
         m_subMenu.slow_btn.addEventListener(MouseEvent.CLICK,this.slow_CLICK);
         m_subMenu.lightning_btn.addEventListener(MouseEvent.MOUSE_OVER,this.lightning_MOUSE_OVER);
         m_subMenu.lightning_btn.addEventListener(MouseEvent.MOUSE_OUT,this.lightning_MOUSE_OUT);
         m_subMenu.lightning_btn.addEventListener(MouseEvent.CLICK,this.lightning_CLICK);
         m_subMenu.vampire_btn.addEventListener(MouseEvent.MOUSE_OVER,this.vampire_MOUSE_OVER);
         m_subMenu.vampire_btn.addEventListener(MouseEvent.MOUSE_OUT,this.vampire_MOUSE_OUT);
         m_subMenu.vampire_btn.addEventListener(MouseEvent.CLICK,this.vampire_CLICK);
         m_subMenu.vengeance_btn.addEventListener(MouseEvent.MOUSE_OVER,this.vengeance_MOUSE_OVER);
         m_subMenu.vengeance_btn.addEventListener(MouseEvent.MOUSE_OUT,this.vengeance_MOUSE_OUT);
         m_subMenu.vengeance_btn.addEventListener(MouseEvent.CLICK,this.vengeance_CLICK);
         m_subMenu.freeze_btn.addEventListener(MouseEvent.MOUSE_OVER,this.freeze_MOUSE_OVER);
         m_subMenu.freeze_btn.addEventListener(MouseEvent.MOUSE_OUT,this.freeze_MOUSE_OUT);
         m_subMenu.freeze_btn.addEventListener(MouseEvent.CLICK,this.freeze_CLICK);
         m_subMenu.egg_btn.addEventListener(MouseEvent.MOUSE_OVER,this.egg_MOUSE_OVER);
         m_subMenu.egg_btn.addEventListener(MouseEvent.MOUSE_OUT,this.egg_MOUSE_OUT);
         m_subMenu.egg_btn.addEventListener(MouseEvent.CLICK,this.egg_CLICK);
         m_subMenu.dramatic_btn.addEventListener(MouseEvent.MOUSE_OVER,this.dramatic_MOUSE_OVER);
         m_subMenu.dramatic_btn.addEventListener(MouseEvent.MOUSE_OUT,this.dramatic_MOUSE_OUT);
         m_subMenu.dramatic_btn.addEventListener(MouseEvent.CLICK,this.dramatic_CLICK);
         m_subMenu.turbo_btn.addEventListener(MouseEvent.MOUSE_OVER,this.turbo_MOUSE_OVER);
         m_subMenu.turbo_btn.addEventListener(MouseEvent.MOUSE_OUT,this.turbo_MOUSE_OUT);
         m_subMenu.turbo_btn.addEventListener(MouseEvent.CLICK,this.turbo_CLICK);
         m_subMenu.light_btn.addEventListener(MouseEvent.MOUSE_OVER,this.light_MOUSE_OVER);
         m_subMenu.light_btn.addEventListener(MouseEvent.MOUSE_OUT,this.light_MOUSE_OUT);
         m_subMenu.light_btn.addEventListener(MouseEvent.CLICK,this.light_CLICK);
         m_subMenu.heavy_btn.addEventListener(MouseEvent.MOUSE_OVER,this.heavy_MOUSE_OVER);
         m_subMenu.heavy_btn.addEventListener(MouseEvent.MOUSE_OUT,this.heavy_MOUSE_OUT);
         m_subMenu.heavy_btn.addEventListener(MouseEvent.CLICK,this.heavy_CLICK);
         m_subMenu.invisible_btn.addEventListener(MouseEvent.MOUSE_OVER,this.invisible_MOUSE_OVER);
         m_subMenu.invisible_btn.addEventListener(MouseEvent.MOUSE_OUT,this.invisible_MOUSE_OUT);
         m_subMenu.invisible_btn.addEventListener(MouseEvent.CLICK,this.invisible_CLICK);
         m_subMenu.metal_btn.addEventListener(MouseEvent.MOUSE_OVER,this.metal_MOUSE_OVER);
         m_subMenu.metal_btn.addEventListener(MouseEvent.MOUSE_OUT,this.metal_MOUSE_OUT);
         m_subMenu.metal_btn.addEventListener(MouseEvent.CLICK,this.metal_CLICK);
         m_subMenu.ssf1_btn.addEventListener(MouseEvent.MOUSE_OVER,this.ssf1_MOUSE_OVER);
         m_subMenu.ssf1_btn.addEventListener(MouseEvent.MOUSE_OUT,this.ssf1_MOUSE_OUT);
         m_subMenu.ssf1_btn.addEventListener(MouseEvent.CLICK,this.ssf1_CLICK);
         m_subMenu.ok_btn.addEventListener(MouseEvent.MOUSE_OVER,this.ok_MOUSE_OVER);
         m_subMenu.ok_btn.addEventListener(MouseEvent.MOUSE_OUT,this.ok_MOUSE_OUT);
         m_subMenu.ok_btn.addEventListener(MouseEvent.CLICK,this.ok_CLICK);
         this.selectHand.makeEvents();
         while(_loc1_ < this.m_specialButtons.length)
         {
            this.m_specialButtons[_loc1_].makeEvents();
            _loc1_++;
         }
         this.updateDisplay();
      }
      
      override public function killEvents() : void
      {
         var _loc1_:int = 0;
         super.killEvents();
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK_mode);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.back_MOUSE_OVER_mode);
         m_subMenu.size_toggle.removeEventListener(MouseEvent.MOUSE_OVER,this.size_toggle_MOUSE_OVER);
         m_subMenu.size_toggle.removeEventListener(MouseEvent.MOUSE_OUT,this.size_toggle_MOUSE_OUT);
         m_subMenu.size_toggle.removeEventListener(MouseEvent.CLICK,this.size_toggle_CLICK);
         m_subMenu.speed_toggle.removeEventListener(MouseEvent.MOUSE_OVER,this.speed_toggle_MOUSE_OVER);
         m_subMenu.speed_toggle.removeEventListener(MouseEvent.MOUSE_OUT,this.speed_toggle_MOUSE_OUT);
         m_subMenu.speed_toggle.removeEventListener(MouseEvent.CLICK,this.speed_toggle_CLICK);
         m_subMenu.vampire_toggle.removeEventListener(MouseEvent.MOUSE_OVER,this.vampire_toggle_MOUSE_OVER);
         m_subMenu.vampire_toggle.removeEventListener(MouseEvent.MOUSE_OUT,this.vampire_toggle_MOUSE_OUT);
         m_subMenu.vampire_toggle.removeEventListener(MouseEvent.CLICK,this.vampire_toggle_CLICK);
         m_subMenu.freeze_toggle.removeEventListener(MouseEvent.MOUSE_OVER,this.freeze_toggle_MOUSE_OVER);
         m_subMenu.freeze_toggle.removeEventListener(MouseEvent.MOUSE_OUT,this.freeze_toggle_MOUSE_OUT);
         m_subMenu.freeze_toggle.removeEventListener(MouseEvent.CLICK,this.freeze_toggle_CLICK);
         m_subMenu.special_toggle.removeEventListener(MouseEvent.MOUSE_OVER,this.special_toggle_MOUSE_OVER);
         m_subMenu.special_toggle.removeEventListener(MouseEvent.MOUSE_OUT,this.special_toggle_MOUSE_OUT);
         m_subMenu.special_toggle.removeEventListener(MouseEvent.CLICK,this.special_toggle_CLICK);
         m_subMenu.weight_toggle.removeEventListener(MouseEvent.MOUSE_OVER,this.weight_toggle_MOUSE_OVER);
         m_subMenu.weight_toggle.removeEventListener(MouseEvent.MOUSE_OUT,this.weight_toggle_MOUSE_OUT);
         m_subMenu.weight_toggle.removeEventListener(MouseEvent.CLICK,this.weight_toggle_CLICK);
         m_subMenu.visibility_toggle.removeEventListener(MouseEvent.MOUSE_OVER,this.visibility_toggle_MOUSE_OVER);
         m_subMenu.visibility_toggle.removeEventListener(MouseEvent.MOUSE_OUT,this.visibility_toggle_MOUSE_OUT);
         m_subMenu.visibility_toggle.removeEventListener(MouseEvent.CLICK,this.visibility_toggle_CLICK);
         m_subMenu.ssf1_toggle.removeEventListener(MouseEvent.MOUSE_OVER,this.ssf1_toggle_MOUSE_OVER);
         m_subMenu.ssf1_toggle.removeEventListener(MouseEvent.MOUSE_OUT,this.ssf1_toggle_MOUSE_OUT);
         m_subMenu.ssf1_toggle.removeEventListener(MouseEvent.CLICK,this.ssf1_toggle_CLICK);
         m_subMenu.mini_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.mini_MOUSE_OVER);
         m_subMenu.mini_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.mini_MOUSE_OUT);
         m_subMenu.mini_btn.removeEventListener(MouseEvent.CLICK,this.mini_CLICK);
         m_subMenu.mega_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.mega_MOUSE_OVER);
         m_subMenu.mega_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.mega_MOUSE_OUT);
         m_subMenu.mega_btn.removeEventListener(MouseEvent.CLICK,this.mega_CLICK);
         m_subMenu.slow_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.slow_MOUSE_OVER);
         m_subMenu.slow_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.slow_MOUSE_OUT);
         m_subMenu.slow_btn.removeEventListener(MouseEvent.CLICK,this.slow_CLICK);
         m_subMenu.lightning_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.lightning_MOUSE_OVER);
         m_subMenu.lightning_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.lightning_MOUSE_OUT);
         m_subMenu.lightning_btn.removeEventListener(MouseEvent.CLICK,this.lightning_CLICK);
         m_subMenu.vampire_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.vampire_MOUSE_OVER);
         m_subMenu.vampire_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.vampire_MOUSE_OUT);
         m_subMenu.vampire_btn.removeEventListener(MouseEvent.CLICK,this.vampire_CLICK);
         m_subMenu.vengeance_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.vengeance_MOUSE_OVER);
         m_subMenu.vengeance_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.vengeance_MOUSE_OUT);
         m_subMenu.vengeance_btn.removeEventListener(MouseEvent.CLICK,this.vengeance_CLICK);
         m_subMenu.freeze_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.freeze_MOUSE_OVER);
         m_subMenu.freeze_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.freeze_MOUSE_OUT);
         m_subMenu.freeze_btn.removeEventListener(MouseEvent.CLICK,this.freeze_CLICK);
         m_subMenu.egg_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.egg_MOUSE_OVER);
         m_subMenu.egg_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.egg_MOUSE_OUT);
         m_subMenu.egg_btn.removeEventListener(MouseEvent.CLICK,this.egg_CLICK);
         m_subMenu.dramatic_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.dramatic_MOUSE_OVER);
         m_subMenu.dramatic_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.dramatic_MOUSE_OUT);
         m_subMenu.dramatic_btn.removeEventListener(MouseEvent.CLICK,this.dramatic_CLICK);
         m_subMenu.turbo_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.turbo_MOUSE_OVER);
         m_subMenu.turbo_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.turbo_MOUSE_OUT);
         m_subMenu.turbo_btn.removeEventListener(MouseEvent.CLICK,this.turbo_CLICK);
         m_subMenu.light_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.light_MOUSE_OVER);
         m_subMenu.light_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.light_MOUSE_OUT);
         m_subMenu.light_btn.removeEventListener(MouseEvent.CLICK,this.light_CLICK);
         m_subMenu.heavy_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.heavy_MOUSE_OVER);
         m_subMenu.heavy_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.heavy_MOUSE_OUT);
         m_subMenu.heavy_btn.removeEventListener(MouseEvent.CLICK,this.heavy_CLICK);
         m_subMenu.metal_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.metal_MOUSE_OVER);
         m_subMenu.metal_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.metal_MOUSE_OUT);
         m_subMenu.metal_btn.removeEventListener(MouseEvent.CLICK,this.metal_CLICK);
         m_subMenu.ssf1_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.ssf1_MOUSE_OVER);
         m_subMenu.ssf1_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.ssf1_MOUSE_OUT);
         m_subMenu.ssf1_btn.removeEventListener(MouseEvent.CLICK,this.ssf1_CLICK);
         m_subMenu.ok_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.ok_MOUSE_OVER);
         m_subMenu.ok_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.ok_MOUSE_OUT);
         m_subMenu.ok_btn.removeEventListener(MouseEvent.CLICK,this.ok_CLICK);
         this.selectHand.killEvents();
         while(_loc1_ < this.m_specialButtons.length)
         {
            this.m_specialButtons[_loc1_].killEvents();
            _loc1_++;
         }
      }
      
      private function updateDisplay() : void
      {
         m_subMenu.size_toggle.gotoAndStop(Boolean(this.m_specialModeFlags & SpecialMode.MINI) || Boolean(this.m_specialModeFlags & SpecialMode.MEGA) ? "_up_off" : "_up_on");
         m_subMenu.speed_toggle.gotoAndStop(Boolean(this.m_specialModeFlags & SpecialMode.LIGHTNING) || Boolean(this.m_specialModeFlags & SpecialMode.SLOW) ? "_up_off" : "_up_on");
         m_subMenu.vampire_toggle.gotoAndStop(Boolean(this.m_specialModeFlags & SpecialMode.VAMPIRE) || Boolean(this.m_specialModeFlags & SpecialMode.VENGEANCE) ? "_up_off" : "_up_on");
         m_subMenu.freeze_toggle.gotoAndStop(Boolean(this.m_specialModeFlags & SpecialMode.FREEZE) || Boolean(this.m_specialModeFlags & SpecialMode.EGG) ? "_up_off" : "_up_on");
         m_subMenu.special_toggle.gotoAndStop(Boolean(this.m_specialModeFlags & SpecialMode.DRAMATIC) || Boolean(this.m_specialModeFlags & SpecialMode.TURBO) ? "_up_off" : "_up_on");
         m_subMenu.weight_toggle.gotoAndStop(Boolean(this.m_specialModeFlags & SpecialMode.HEAVY) || Boolean(this.m_specialModeFlags & SpecialMode.LIGHT) ? "_up_off" : "_up_on");
         m_subMenu.visibility_toggle.gotoAndStop(Boolean(this.m_specialModeFlags & SpecialMode.INVISIBLE) || Boolean(this.m_specialModeFlags & SpecialMode.METAL) ? "_up_off" : "_up_on");
         m_subMenu.ssf1_toggle.gotoAndStop(this.m_specialModeFlags & SpecialMode.SSF1 ? "_up_off" : "_up_on");
         m_subMenu.mini_btn.gotoAndStop(this.m_specialModeFlags & SpecialMode.MINI ? "on" : "off");
         m_subMenu.mega_btn.gotoAndStop(this.m_specialModeFlags & SpecialMode.MEGA ? "on" : "off");
         m_subMenu.slow_btn.gotoAndStop(this.m_specialModeFlags & SpecialMode.SLOW ? "on" : "off");
         m_subMenu.lightning_btn.gotoAndStop(this.m_specialModeFlags & SpecialMode.LIGHTNING ? "on" : "off");
         m_subMenu.vampire_btn.gotoAndStop(this.m_specialModeFlags & SpecialMode.VAMPIRE ? "on" : "off");
         m_subMenu.vengeance_btn.gotoAndStop(this.m_specialModeFlags & SpecialMode.VENGEANCE ? "on" : "off");
         m_subMenu.freeze_btn.gotoAndStop(this.m_specialModeFlags & SpecialMode.FREEZE ? "on" : "off");
         m_subMenu.egg_btn.gotoAndStop(this.m_specialModeFlags & SpecialMode.EGG ? "on" : "off");
         m_subMenu.dramatic_btn.gotoAndStop(this.m_specialModeFlags & SpecialMode.DRAMATIC ? "on" : "off");
         m_subMenu.turbo_btn.gotoAndStop(this.m_specialModeFlags & SpecialMode.TURBO ? "on" : "off");
         m_subMenu.light_btn.gotoAndStop(this.m_specialModeFlags & SpecialMode.LIGHT ? "on" : "off");
         m_subMenu.heavy_btn.gotoAndStop(this.m_specialModeFlags & SpecialMode.HEAVY ? "on" : "off");
         m_subMenu.invisible_btn.gotoAndStop(this.m_specialModeFlags & SpecialMode.INVISIBLE ? "on" : "off");
         m_subMenu.metal_btn.gotoAndStop(this.m_specialModeFlags & SpecialMode.METAL ? "on" : "off");
         m_subMenu.ssf1_btn.gotoAndStop(this.m_specialModeFlags & SpecialMode.SSF1 ? "on" : "off");
      }
      
      private function back_CLICK_mode(param1:MouseEvent) : void
      {
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_back");
         m_subMenu.modeDesc.text = "";
         if(MultiplayerManager.Connected)
         {
            MenuController.onlineGroupMenu.show();
         }
         else
         {
            MenuController.groupMenu.show();
         }
      }
      
      private function back_MOUSE_OVER_mode(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function size_toggle_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function size_toggle_MOUSE_OUT(param1:MouseEvent) : void
      {
      }
      
      private function size_toggle_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.m_specialModeFlags &= ~SpecialMode.MEGA;
         this.m_specialModeFlags &= ~SpecialMode.MINI;
         this.updateDisplay();
      }
      
      private function speed_toggle_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function speed_toggle_MOUSE_OUT(param1:MouseEvent) : void
      {
      }
      
      private function speed_toggle_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.m_specialModeFlags &= ~SpecialMode.SLOW;
         this.m_specialModeFlags &= ~SpecialMode.LIGHTNING;
         this.updateDisplay();
      }
      
      private function vampire_toggle_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function vampire_toggle_MOUSE_OUT(param1:MouseEvent) : void
      {
      }
      
      private function vampire_toggle_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.m_specialModeFlags &= ~SpecialMode.VAMPIRE;
         this.m_specialModeFlags &= ~SpecialMode.VENGEANCE;
         this.updateDisplay();
      }
      
      private function freeze_toggle_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function freeze_toggle_MOUSE_OUT(param1:MouseEvent) : void
      {
      }
      
      private function freeze_toggle_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.m_specialModeFlags &= ~SpecialMode.FREEZE;
         this.m_specialModeFlags &= ~SpecialMode.EGG;
         this.updateDisplay();
      }
      
      private function special_toggle_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function special_toggle_MOUSE_OUT(param1:MouseEvent) : void
      {
      }
      
      private function special_toggle_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.m_specialModeFlags &= ~SpecialMode.DRAMATIC;
         this.m_specialModeFlags &= ~SpecialMode.TURBO;
         this.updateDisplay();
      }
      
      private function weight_toggle_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function weight_toggle_MOUSE_OUT(param1:MouseEvent) : void
      {
      }
      
      private function weight_toggle_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.m_specialModeFlags &= ~SpecialMode.LIGHT;
         this.m_specialModeFlags &= ~SpecialMode.HEAVY;
         this.updateDisplay();
      }
      
      private function visibility_toggle_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function visibility_toggle_MOUSE_OUT(param1:MouseEvent) : void
      {
      }
      
      private function visibility_toggle_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.m_specialModeFlags &= ~SpecialMode.INVISIBLE;
         this.m_specialModeFlags &= ~SpecialMode.METAL;
         this.updateDisplay();
      }
      
      private function ssf1_toggle_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function ssf1_toggle_MOUSE_OUT(param1:MouseEvent) : void
      {
      }
      
      private function ssf1_toggle_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.m_specialModeFlags &= ~SpecialMode.SSF1;
         this.updateDisplay();
      }
      
      private function mini_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.modeDesc.text = "Play mini-sized!";
      }
      
      private function mini_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.modeDesc.text = "";
      }
      
      private function mini_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.m_specialModeFlags &= ~SpecialMode.MEGA;
         this.m_specialModeFlags |= SpecialMode.MINI;
         this.updateDisplay();
      }
      
      private function mega_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.modeDesc.text = "Play giant-sized!";
      }
      
      private function mega_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.modeDesc.text = "";
      }
      
      private function mega_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.m_specialModeFlags &= ~SpecialMode.MINI;
         this.m_specialModeFlags |= SpecialMode.MEGA;
         this.updateDisplay();
      }
      
      private function slow_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.modeDesc.text = "Take your time in a cinematic fight!";
      }
      
      private function slow_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.modeDesc.text = "";
      }
      
      private function slow_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.m_specialModeFlags &= ~SpecialMode.LIGHTNING;
         this.m_specialModeFlags |= SpecialMode.SLOW;
         this.updateDisplay();
      }
      
      private function lightning_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.modeDesc.text = "Think fast in a lightning-quick battle!";
      }
      
      private function lightning_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.modeDesc.text = "";
      }
      
      private function lightning_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.m_specialModeFlags &= ~SpecialMode.SLOW;
         this.m_specialModeFlags |= SpecialMode.LIGHTNING;
         this.updateDisplay();
      }
      
      private function vampire_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.modeDesc.text = " Recover half of the HP you deal to your foes!";
      }
      
      private function vampire_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.modeDesc.text = "";
      }
      
      private function vampire_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.m_specialModeFlags &= ~SpecialMode.VENGEANCE;
         this.m_specialModeFlags |= SpecialMode.VAMPIRE;
         this.updateDisplay();
      }
      
      private function vengeance_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.modeDesc.text = " Receive half of the damage you deal to your foes!";
      }
      
      private function vengeance_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.modeDesc.text = "";
      }
      
      private function vengeance_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.m_specialModeFlags &= ~SpecialMode.VAMPIRE;
         this.m_specialModeFlags |= SpecialMode.VENGEANCE;
         this.updateDisplay();
      }
      
      private function freeze_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.modeDesc.text = " Every attack will freeze your foe in a block of ice!";
      }
      
      private function freeze_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.modeDesc.text = "";
      }
      
      private function freeze_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.m_specialModeFlags &= ~SpecialMode.EGG;
         this.m_specialModeFlags |= SpecialMode.FREEZE;
         this.updateDisplay();
      }
      
      private function egg_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.modeDesc.text = "Every attack will trap your foe in an egg!";
      }
      
      private function egg_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.modeDesc.text = "";
      }
      
      private function egg_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.m_specialModeFlags &= ~SpecialMode.FREEZE;
         this.m_specialModeFlags |= SpecialMode.EGG;
         this.updateDisplay();
      }
      
      private function dramatic_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.modeDesc.text = "The camera will pay extra attention to your successful attacks!";
      }
      
      private function dramatic_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.modeDesc.text = "";
      }
      
      private function dramatic_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.m_specialModeFlags &= ~SpecialMode.TURBO;
         this.m_specialModeFlags |= SpecialMode.DRAMATIC;
         this.updateDisplay();
      }
      
      private function turbo_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.modeDesc.text = "Cancel attacks after a successful hit for mind-blowing combos!";
      }
      
      private function turbo_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.modeDesc.text = "";
      }
      
      private function turbo_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.m_specialModeFlags &= ~SpecialMode.DRAMATIC;
         this.m_specialModeFlags |= SpecialMode.TURBO;
         this.updateDisplay();
      }
      
      private function light_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.modeDesc.text = " Fly high in a floaty battle!";
      }
      
      private function light_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.modeDesc.text = "";
      }
      
      private function light_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.m_specialModeFlags &= ~SpecialMode.HEAVY;
         this.m_specialModeFlags |= SpecialMode.LIGHT;
         this.updateDisplay();
      }
      
      private function heavy_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.modeDesc.text = "Battle with intense gravity!";
      }
      
      private function heavy_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.modeDesc.text = "";
      }
      
      private function heavy_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.m_specialModeFlags &= ~SpecialMode.LIGHT;
         this.m_specialModeFlags |= SpecialMode.HEAVY;
         this.updateDisplay();
      }
      
      private function invisible_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.modeDesc.text = "Fight while invisible!";
      }
      
      private function invisible_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.modeDesc.text = "";
      }
      
      private function invisible_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.m_specialModeFlags &= ~SpecialMode.METAL;
         this.m_specialModeFlags |= SpecialMode.INVISIBLE;
         this.updateDisplay();
      }
      
      private function metal_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.modeDesc.text = "Clash against each other as solid metal!";
      }
      
      private function metal_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.modeDesc.text = "";
      }
      
      private function metal_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.m_specialModeFlags &= ~SpecialMode.INVISIBLE;
         this.m_specialModeFlags |= SpecialMode.METAL;
         this.updateDisplay();
      }
      
      private function ssf1_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.modeDesc.text = "Relive the nostalgic gameplay style from SSF1!";
      }
      
      private function ssf1_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.modeDesc.text = "";
      }
      
      private function ssf1_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.m_specialModeFlags ^= SpecialMode.SSF1;
         this.updateDisplay();
      }
      
      private function ok_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function ok_MOUSE_OUT(param1:MouseEvent) : void
      {
      }
      
      private function ok_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         removeSelf();
         m_subMenu.modeDesc.text = "";
         MenuController.CurrentCharacterSelectMenu.reset();
         MenuController.CurrentCharacterSelectMenu.GameObj.LevelData.specialModes = this.m_specialModeFlags;
         MenuController.CurrentCharacterSelectMenu.show();
         SoundQueue.instance.playVoiceEffect("narrator_choose");
      }
   }
}


package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   import flash.geom.*;
   
   public class SoundMenu extends Menu
   {
      
      private var m_musicNode:MenuMapperNode;
      
      private var m_soundNode:MenuMapperNode;
      
      private var m_voiceNode:MenuMapperNode;
      
      public function SoundMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_sound");
         m_backgroundID = "space";
         if(!Main.DEBUG)
         {
            m_subMenu.soundtest.visible = false;
         }
         this.initMenuMappings();
         m_container.addChild(m_subMenu);
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
      }
      
      override public function initMenuMappings() : void
      {
         this.m_musicNode = new MenuMapperNode(m_subMenu.music_btn);
         this.m_soundNode = new MenuMapperNode(m_subMenu.sound_btn);
         this.m_voiceNode = new MenuMapperNode(m_subMenu.voice_btn);
         this.m_musicNode.updateNodes([this.m_voiceNode],[this.m_soundNode],null,null,this.music_ROLL_OVER,this.music_ROLL_OUT,null,this.back_CLICK_sound,null,null,this.decreaseMusic,this.increaseMusic);
         this.m_soundNode.updateNodes([this.m_musicNode],[this.m_voiceNode],null,null,this.sound_ROLL_OVER,this.sound_ROLL_OUT,null,this.back_CLICK_sound,null,null,this.decreaseSFX,this.increaseSFX);
         this.m_voiceNode.updateNodes([this.m_soundNode],[this.m_musicNode],null,null,this.voice_ROLL_OVER,this.voice_ROLL_OUT,null,this.back_CLICK_sound,null,null,this.decreaseVFX,this.increaseVFX);
         m_menuMapper = new MenuMapper(this.m_musicNode);
         m_menuMapper.init();
      }
      
      private function decreaseMusic(param1:MouseEvent) : void
      {
         this.knobBG_MOUSE_UP(null);
         SaveData.BGVolumeLevel -= 0.01;
         if(SaveData.BGVolumeLevel < 0)
         {
            SaveData.BGVolumeLevel = 0;
         }
         this.adjustKnobs();
         if(!SoundQueue.instance.MusicIsMuted)
         {
            SoundQueue.instance.setMusicVolume(SaveData.BGVolumeLevel);
         }
      }
      
      private function increaseMusic(param1:MouseEvent) : void
      {
         this.knobBG_MOUSE_UP(null);
         SaveData.BGVolumeLevel += 0.01;
         if(SaveData.BGVolumeLevel > 1)
         {
            SaveData.BGVolumeLevel = 1;
         }
         this.adjustKnobs();
         if(!SoundQueue.instance.MusicIsMuted)
         {
            SoundQueue.instance.setMusicVolume(SaveData.BGVolumeLevel);
         }
      }
      
      private function decreaseSFX(param1:MouseEvent) : void
      {
         this.knobFX_MOUSE_UP(null);
         SaveData.SEVolumeLevel -= 0.01;
         if(SaveData.SEVolumeLevel < 0)
         {
            SaveData.SEVolumeLevel = 0;
         }
         this.adjustKnobs();
      }
      
      private function increaseSFX(param1:MouseEvent) : void
      {
         this.knobFX_MOUSE_UP(null);
         SaveData.SEVolumeLevel += 0.01;
         if(SaveData.SEVolumeLevel > 1)
         {
            SaveData.SEVolumeLevel = 1;
         }
         this.adjustKnobs();
      }
      
      private function decreaseVFX(param1:MouseEvent) : void
      {
         this.knobVA_MOUSE_UP(null);
         SaveData.VAVolumeLevel -= 0.01;
         if(SaveData.VAVolumeLevel < 0)
         {
            SaveData.VAVolumeLevel = 0;
         }
         this.adjustKnobs();
      }
      
      private function increaseVFX(param1:MouseEvent) : void
      {
         this.knobVA_MOUSE_UP(null);
         SaveData.VAVolumeLevel += 0.01;
         if(SaveData.VAVolumeLevel > 1)
         {
            SaveData.VAVolumeLevel = 1;
         }
         this.adjustKnobs();
      }
      
      private function adjustKnobs() : void
      {
         m_subMenu.music_btn.dragging = false;
         m_subMenu.music_btn.h = 187;
         m_subMenu.music_btn.knob.x = 247 - 187 * (1 - SaveData.BGVolumeLevel);
         m_subMenu.music_btn.amount.text = "" + Math.round(100 * (m_subMenu.music_btn.knob.x - 60) / m_subMenu.music_btn.h);
         m_subMenu.sound_btn.dragging = false;
         m_subMenu.sound_btn.h = 187;
         m_subMenu.sound_btn.knob.x = 247 - 187 * (1 - SaveData.SEVolumeLevel);
         m_subMenu.sound_btn.amount.text = "" + Math.round(100 * (m_subMenu.sound_btn.knob.x - 60) / m_subMenu.sound_btn.h);
         m_subMenu.voice_btn.dragging = false;
         m_subMenu.voice_btn.h = 187;
         m_subMenu.voice_btn.knob.x = 247 - 187 * (1 - SaveData.VAVolumeLevel);
         m_subMenu.voice_btn.amount.text = "" + Math.round(100 * (m_subMenu.voice_btn.knob.x - 60) / m_subMenu.voice_btn.h);
      }
      
      override public function show() : void
      {
         this.adjustKnobs();
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
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK_sound);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER_sound);
         m_subMenu.music_btn.addEventListener(MouseEvent.ROLL_OVER,this.music_ROLL_OVER);
         m_subMenu.music_btn.addEventListener(MouseEvent.ROLL_OUT,this.music_ROLL_OUT);
         m_subMenu.music_btn.knob.addEventListener(MouseEvent.MOUSE_DOWN,this.knobBG_MOUSE_DOWN);
         m_subMenu.stage.addEventListener(MouseEvent.MOUSE_UP,this.knobBG_MOUSE_UP);
         m_subMenu.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.knobBG_MOUSE_MOVE);
         m_subMenu.sound_btn.addEventListener(MouseEvent.ROLL_OVER,this.sound_ROLL_OVER);
         m_subMenu.sound_btn.addEventListener(MouseEvent.ROLL_OUT,this.sound_ROLL_OUT);
         m_subMenu.sound_btn.knob.addEventListener(MouseEvent.MOUSE_DOWN,this.knobFX_MOUSE_DOWN);
         m_subMenu.stage.addEventListener(MouseEvent.MOUSE_UP,this.knobFX_MOUSE_UP);
         m_subMenu.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.knobFX_MOUSE_MOVE);
         m_subMenu.voice_btn.addEventListener(MouseEvent.ROLL_OVER,this.voice_ROLL_OVER);
         m_subMenu.voice_btn.addEventListener(MouseEvent.ROLL_OUT,this.voice_ROLL_OUT);
         m_subMenu.voice_btn.knob.addEventListener(MouseEvent.MOUSE_DOWN,this.knobVA_MOUSE_DOWN);
         m_subMenu.stage.addEventListener(MouseEvent.MOUSE_UP,this.knobVA_MOUSE_UP);
         m_subMenu.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.knobVA_MOUSE_MOVE);
         m_subMenu.soundtest.tmpBtn.addEventListener(MouseEvent.CLICK,this.tmpBtn_CLICK);
         m_subMenu.bg_top.home_btn.addEventListener(MouseEvent.CLICK,this.home_CLICK);
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,manageMenuMappings);
         setMenuMappingFocus();
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK_sound);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER_sound);
         m_subMenu.music_btn.removeEventListener(MouseEvent.ROLL_OVER,this.music_ROLL_OVER);
         m_subMenu.music_btn.removeEventListener(MouseEvent.ROLL_OUT,this.music_ROLL_OUT);
         m_subMenu.music_btn.knob.removeEventListener(MouseEvent.MOUSE_DOWN,this.knobBG_MOUSE_DOWN);
         m_subMenu.stage.removeEventListener(MouseEvent.MOUSE_UP,this.knobBG_MOUSE_UP);
         m_subMenu.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.knobBG_MOUSE_MOVE);
         m_subMenu.sound_btn.removeEventListener(MouseEvent.ROLL_OVER,this.sound_ROLL_OVER);
         m_subMenu.sound_btn.removeEventListener(MouseEvent.ROLL_OUT,this.sound_ROLL_OUT);
         m_subMenu.sound_btn.knob.removeEventListener(MouseEvent.MOUSE_DOWN,this.knobFX_MOUSE_DOWN);
         m_subMenu.stage.removeEventListener(MouseEvent.MOUSE_UP,this.knobFX_MOUSE_UP);
         m_subMenu.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.knobFX_MOUSE_MOVE);
         m_subMenu.voice_btn.removeEventListener(MouseEvent.ROLL_OVER,this.voice_ROLL_OVER);
         m_subMenu.voice_btn.removeEventListener(MouseEvent.ROLL_OUT,this.voice_ROLL_OUT);
         m_subMenu.voice_btn.knob.removeEventListener(MouseEvent.MOUSE_DOWN,this.knobVA_MOUSE_DOWN);
         m_subMenu.stage.removeEventListener(MouseEvent.MOUSE_UP,this.knobVA_MOUSE_UP);
         m_subMenu.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.knobVA_MOUSE_MOVE);
         m_subMenu.soundtest.tmpBtn.removeEventListener(MouseEvent.CLICK,this.tmpBtn_CLICK);
         m_subMenu.bg_top.home_btn.removeEventListener(MouseEvent.CLICK,this.home_CLICK);
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,manageMenuMappings);
      }
      
      private function tmpBtn_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect(m_subMenu.soundtest.intxt.text);
      }
      
      private function back_CLICK_sound(param1:MouseEvent) : void
      {
         SaveData.saveGame();
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_back");
         MenuController.optionsMenu.show();
      }
      
      private function back_ROLL_OVER_sound(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function music_ROLL_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Adjusts BGM Volume.";
      }
      
      private function music_ROLL_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function sound_ROLL_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Adjusts Sound FX Volume.";
      }
      
      private function sound_ROLL_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function voice_ROLL_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Adjusts Voice Volume.";
      }
      
      private function voice_ROLL_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function knobBG_MOUSE_DOWN(param1:MouseEvent) : void
      {
         m_subMenu.music_btn.dragging = true;
         m_subMenu.music_btn.knob.startDrag(false,new Rectangle(60,m_subMenu.music_btn.knob.y,m_subMenu.music_btn.h,0));
      }
      
      private function knobBG_MOUSE_UP(param1:MouseEvent) : void
      {
         if(m_subMenu.music_btn.dragging)
         {
            m_subMenu.music_btn.dragging = false;
            m_subMenu.music_btn.knob.stopDrag();
            SaveData.BGVolumeLevel = (m_subMenu.music_btn.knob.x - 60) / m_subMenu.music_btn.h;
            SoundQueue.instance.setMusicVolume((m_subMenu.music_btn.knob.x - 60) / m_subMenu.music_btn.h);
            SaveData.saveGame();
         }
      }
      
      private function knobBG_MOUSE_MOVE(param1:MouseEvent) : void
      {
         if(m_subMenu.music_btn.dragging)
         {
            SaveData.BGVolumeLevel = (m_subMenu.music_btn.knob.x - 60) / m_subMenu.music_btn.h;
            m_subMenu.music_btn.amount.text = "" + Math.round(100 * (m_subMenu.music_btn.knob.x - 60) / m_subMenu.music_btn.h);
            SoundQueue.instance.setMusicVolume((m_subMenu.music_btn.knob.x - 60) / m_subMenu.music_btn.h);
         }
      }
      
      private function knobFX_MOUSE_DOWN(param1:MouseEvent) : void
      {
         m_subMenu.sound_btn.dragging = true;
         m_subMenu.sound_btn.knob.startDrag(false,new Rectangle(60,m_subMenu.sound_btn.knob.y,m_subMenu.sound_btn.h,0));
      }
      
      private function knobFX_MOUSE_UP(param1:MouseEvent) : void
      {
         if(m_subMenu.sound_btn.dragging)
         {
            m_subMenu.sound_btn.dragging = false;
            m_subMenu.sound_btn.knob.stopDrag();
            SaveData.SEVolumeLevel = (m_subMenu.sound_btn.knob.x - 60) / m_subMenu.sound_btn.h;
            SaveData.saveGame();
         }
      }
      
      private function knobFX_MOUSE_MOVE(param1:MouseEvent) : void
      {
         if(m_subMenu.sound_btn.dragging)
         {
            m_subMenu.sound_btn.amount.text = "" + Math.round(100 * (m_subMenu.sound_btn.knob.x - 60) / m_subMenu.sound_btn.h);
            SaveData.SEVolumeLevel = (m_subMenu.sound_btn.knob.x - 60) / m_subMenu.sound_btn.h;
         }
      }
      
      private function knobVA_MOUSE_DOWN(param1:MouseEvent) : void
      {
         m_subMenu.voice_btn.dragging = true;
         m_subMenu.voice_btn.knob.startDrag(false,new Rectangle(60,m_subMenu.voice_btn.knob.y,m_subMenu.voice_btn.h,0));
      }
      
      private function knobVA_MOUSE_UP(param1:MouseEvent) : void
      {
         if(m_subMenu.voice_btn.dragging)
         {
            m_subMenu.voice_btn.dragging = false;
            m_subMenu.voice_btn.knob.stopDrag();
            SaveData.VAVolumeLevel = (m_subMenu.voice_btn.knob.x - 60) / m_subMenu.voice_btn.h;
            SaveData.saveGame();
         }
      }
      
      private function knobVA_MOUSE_MOVE(param1:MouseEvent) : void
      {
         if(m_subMenu.voice_btn.dragging)
         {
            m_subMenu.voice_btn.amount.text = "" + Math.round(100 * (m_subMenu.voice_btn.knob.x - 60) / m_subMenu.voice_btn.h);
            SaveData.VAVolumeLevel = (m_subMenu.voice_btn.knob.x - 60) / m_subMenu.voice_btn.h;
         }
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


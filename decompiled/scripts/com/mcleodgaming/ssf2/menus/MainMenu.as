package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.*;
   
   public class MainMenu extends Menu
   {
      
      private var m_newsNode:MenuMapperNode;
      
      private var m_groupNode:MenuMapperNode;
      
      private var m_soloNode:MenuMapperNode;
      
      private var m_optionsNode:MenuMapperNode;
      
      private var m_onlineNode:MenuMapperNode;
      
      private var m_dataNode:MenuMapperNode;
      
      private var m_vaultNode:MenuMapperNode;
      
      private var m_eNode:String;
      
      public function MainMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_main");
         m_backgroundID = "space";
         m_container.addChild(m_subMenu);
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         this.initMenuMappings();
         if(!Config.mode_online)
         {
            Utils.setBrightness(m_subMenu.online_btn,-100);
         }
         if(!Config.mode_solo)
         {
            Utils.setBrightness(m_subMenu.solo_btn,-100);
         }
      }
      
      override public function initMenuMappings() : void
      {
         this.m_newsNode = new MenuMapperNode(m_subMenu.news_btn);
         this.m_groupNode = new MenuMapperNode(m_subMenu.group_btn);
         this.m_soloNode = new MenuMapperNode(m_subMenu.solo_btn);
         this.m_optionsNode = new MenuMapperNode(m_subMenu.options_btn);
         this.m_dataNode = new MenuMapperNode(m_subMenu.data_btn);
         this.m_vaultNode = new MenuMapperNode(m_subMenu.vault_btn);
         this.m_onlineNode = new MenuMapperNode(m_subMenu.online_btn);
         this.m_newsNode.updateNodes([this.m_optionsNode,this.m_vaultNode,this.m_soloNode],[this.m_groupNode,this.m_onlineNode,this.m_dataNode],[],[],this.news_MOUSE_OVER,this.news_MOUSE_OUT,this.news_CLICK,this.back_CLICK);
         this.m_groupNode.updateNodes([this.m_newsNode],[this.m_optionsNode],[this.m_dataNode],[this.m_onlineNode],this.group_MOUSE_OVER,this.group_MOUSE_OUT,this.group_CLICK,this.back_CLICK);
         this.m_soloNode.updateNodes([this.m_dataNode],[this.m_newsNode],[this.m_vaultNode],[this.m_optionsNode],this.solo_MOUSE_OVER,this.solo_MOUSE_OUT,this.solo_CLICK,this.back_CLICK);
         this.m_optionsNode.updateNodes([this.m_groupNode],[this.m_newsNode],[this.m_soloNode],[this.m_vaultNode],this.options_MOUSE_OVER,this.options_MOUSE_OUT,this.options_CLICK,this.back_CLICK);
         this.m_dataNode.updateNodes([this.m_newsNode],[this.m_soloNode],[this.m_onlineNode],[this.m_groupNode],this.data_MOUSE_OVER,this.data_MOUSE_OUT,this.data_CLICK,this.back_CLICK);
         this.m_vaultNode.updateNodes([this.m_onlineNode],[this.m_newsNode],[this.m_optionsNode],[this.m_soloNode],this.vault_MOUSE_OVER,this.vault_MOUSE_OUT,this.vault_CLICK,this.back_CLICK);
         this.m_onlineNode.updateNodes([this.m_newsNode],[this.m_vaultNode],[this.m_groupNode],[this.m_dataNode],this.online_MOUSE_OVER,this.online_MOUSE_OUT,this.online_CLICK,this.back_CLICK);
         m_subMenu.online_btn.buttonMode = true;
         m_subMenu.online_btn.useHandCursor = true;
         Utils.setTint(m_subMenu.online_btn,1,1,1,1,0,0,0,0);
         m_menuMapper = new MenuMapper(this.m_groupNode);
         m_menuMapper.init();
      }
      
      override public function show() : void
      {
         super.show();
         SoundQueue.instance.playMusic("menumusic",0);
      }
      
      override public function makeEvents() : void
      {
         var llc:LocalConnection;
         var dn:String;
         var headline:Object;
         var a:Timer = null;
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         resetAllButtons();
         m_subMenu.news_btn.addEventListener(MouseEvent.MOUSE_OVER,this.news_MOUSE_OVER);
         m_subMenu.news_btn.addEventListener(MouseEvent.MOUSE_OUT,this.news_MOUSE_OUT);
         m_subMenu.news_btn.addEventListener(MouseEvent.CLICK,this.news_CLICK);
         m_subMenu.vault_btn.addEventListener(MouseEvent.MOUSE_OVER,this.vault_MOUSE_OVER);
         m_subMenu.vault_btn.addEventListener(MouseEvent.MOUSE_OUT,this.vault_MOUSE_OUT);
         m_subMenu.vault_btn.addEventListener(MouseEvent.CLICK,this.vault_CLICK);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER);
         m_subMenu.group_btn.addEventListener(MouseEvent.MOUSE_OVER,this.group_MOUSE_OVER);
         m_subMenu.group_btn.addEventListener(MouseEvent.MOUSE_OUT,this.group_MOUSE_OUT);
         m_subMenu.group_btn.addEventListener(MouseEvent.CLICK,this.group_CLICK);
         m_subMenu.options_btn.addEventListener(MouseEvent.MOUSE_OVER,this.options_MOUSE_OVER);
         m_subMenu.options_btn.addEventListener(MouseEvent.MOUSE_OUT,this.options_MOUSE_OUT);
         m_subMenu.options_btn.addEventListener(MouseEvent.CLICK,this.options_CLICK);
         m_subMenu.online_btn.addEventListener(MouseEvent.MOUSE_OVER,this.online_MOUSE_OVER);
         m_subMenu.online_btn.addEventListener(MouseEvent.MOUSE_OUT,this.online_MOUSE_OUT);
         m_subMenu.online_btn.addEventListener(MouseEvent.CLICK,this.online_CLICK);
         m_subMenu.solo_btn.addEventListener(MouseEvent.MOUSE_OVER,this.solo_MOUSE_OVER);
         m_subMenu.solo_btn.addEventListener(MouseEvent.MOUSE_OUT,this.solo_MOUSE_OUT);
         m_subMenu.solo_btn.addEventListener(MouseEvent.CLICK,this.solo_CLICK);
         m_subMenu.data_btn.addEventListener(MouseEvent.MOUSE_OVER,this.data_MOUSE_OVER);
         m_subMenu.data_btn.addEventListener(MouseEvent.MOUSE_OUT,this.data_MOUSE_OUT);
         m_subMenu.data_btn.addEventListener(MouseEvent.CLICK,this.data_CLICK);
         m_subMenu.bg_top.home_btn.addEventListener(MouseEvent.CLICK,this.home_CLICK);
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,manageMenuMappings);
         setMenuMappingFocus();
         llc = new LocalConnection();
         dn = llc.domain;
         if(dn == Base64.decode("bG9jYWxob3N0") || dn == Base64.decode("MTI3LjAuMC4x") || Boolean(dn.match(/^app#com\.mcleodgaming\.ssf2(?:2|3|4)?$/)))
         {
            Main[Base64.decode("QVVUSE9SSVpFRA==")] = true;
         }
         else if(!dn.match(/mcleodgaming\.com$/) && !dn.match(/ssf2\.com$/) && !dn.match(/supersmashflash\.com$/))
         {
            Main[Base64.decode("QVVUSE9SSVpFRA==")] = false;
         }
         if(!Main[Base64.decode("QVVUSE9SSVpFRA==")])
         {
            a = new Timer(200,1);
            SoundQueue.instance.stopMusic();
            MenuController.removeAllMenus();
            a.addEventListener(TimerEvent.TIMER_COMPLETE,function():void
            {
               SoundQueue.instance.stopMusic();
               MenuController.removeAllMenus();
               MenuController.blockedMenu.show();
            });
            a.start();
         }
         headline = NewsMenu.getLatestHeadline();
         if(headline.text.length > 36)
         {
            headline.text = headline.text.substr(0,36) + "...";
         }
         m_subMenu.news_btn.title.text = headline.text;
         m_subMenu.news_btn.icons.gotoAndStop(headline.unread ? "unread" : "read");
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.news_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.news_MOUSE_OVER);
         m_subMenu.news_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.news_MOUSE_OUT);
         m_subMenu.news_btn.removeEventListener(MouseEvent.CLICK,this.news_CLICK);
         m_subMenu.vault_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.vault_MOUSE_OVER);
         m_subMenu.vault_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.vault_MOUSE_OUT);
         m_subMenu.vault_btn.removeEventListener(MouseEvent.CLICK,this.vault_CLICK);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER);
         m_subMenu.group_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.group_MOUSE_OVER);
         m_subMenu.group_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.group_MOUSE_OUT);
         m_subMenu.group_btn.removeEventListener(MouseEvent.CLICK,this.group_CLICK);
         m_subMenu.options_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.options_MOUSE_OVER);
         m_subMenu.options_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.options_MOUSE_OUT);
         m_subMenu.options_btn.removeEventListener(MouseEvent.CLICK,this.options_CLICK);
         m_subMenu.online_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.online_MOUSE_OVER);
         m_subMenu.online_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.online_MOUSE_OUT);
         m_subMenu.online_btn.removeEventListener(MouseEvent.CLICK,this.online_CLICK);
         m_subMenu.solo_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.solo_MOUSE_OVER);
         m_subMenu.solo_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.solo_MOUSE_OUT);
         m_subMenu.solo_btn.removeEventListener(MouseEvent.CLICK,this.solo_CLICK);
         m_subMenu.data_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.data_MOUSE_OVER);
         m_subMenu.data_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.data_MOUSE_OUT);
         m_subMenu.data_btn.removeEventListener(MouseEvent.CLICK,this.data_CLICK);
         m_subMenu.bg_top.home_btn.removeEventListener(MouseEvent.CLICK,this.home_CLICK);
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,manageMenuMappings);
         m_subMenu.news_btn.gotoAndStop(1);
      }
      
      private function group_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Play a variety of Smash modes with multiple players.";
      }
      
      private function group_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function group_CLICK(param1:MouseEvent) : void
      {
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_select");
         m_subMenu.desc_txt.text = "";
         MenuController.groupMenu.show();
      }
      
      private function options_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Choose and save your own personal Smash settings.";
      }
      
      private function options_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function options_CLICK(param1:MouseEvent) : void
      {
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_select");
         m_subMenu.desc_txt.text = "";
         MenuController.optionsMenu.show();
      }
      
      private function news_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Discover the latest news in the SSF2 community!";
      }
      
      private function news_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function news_CLICK(param1:MouseEvent) : void
      {
         if(!ResourceManager.getResourceByID("menu_news").Loaded)
         {
            SoundQueue.instance.playSoundEffect("menu_error");
            return;
         }
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_select");
         m_subMenu.desc_txt.text = "";
         MenuController.newsMenu.show();
      }
      
      private function vault_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Check out SSF2 Media Content";
      }
      
      private function vault_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function vault_CLICK(param1:MouseEvent) : void
      {
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_select");
         m_subMenu.desc_txt.text = "";
         MenuController.vaultMenu.show();
      }
      
      private function online_MOUSE_OVER(param1:MouseEvent) : void
      {
         if(Config.mode_online)
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            m_subMenu.desc_txt.text = "Go online and play against your friends!";
         }
      }
      
      private function online_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function online_CLICK(param1:MouseEvent) : void
      {
         if(Config.mode_online)
         {
            removeSelf();
            SoundQueue.instance.playSoundEffect("menu_select");
            m_subMenu.desc_txt.text = "";
            MenuController.onlineMenu.show();
         }
      }
      
      private function solo_MOUSE_OVER(param1:MouseEvent) : void
      {
         if(Config.mode_solo)
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            m_subMenu.desc_txt.text = "Play this mode solo or challenge it cooperatively.";
         }
      }
      
      private function solo_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function solo_CLICK(param1:MouseEvent) : void
      {
         if(Config.mode_solo)
         {
            removeSelf();
            SoundQueue.instance.playSoundEffect("menu_select");
            m_subMenu.desc_txt.text = "";
            MenuController.soloMenu.show();
         }
      }
      
      private function data_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Manage saved game data and records.";
      }
      
      private function data_MOUSE_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function data_CLICK(param1:MouseEvent) : void
      {
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_select");
         m_subMenu.desc_txt.text = "";
         MenuController.dataMenu.show();
      }
      
      private function back_CLICK(param1:MouseEvent) : void
      {
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_back");
         SoundQueue.instance.stopMusic();
         m_subMenu.desc_txt.text = "";
         MenuController.titleMenu.show();
      }
      
      private function back_ROLL_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function home_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_back");
         SoundQueue.instance.stopMusic();
         removeSelf();
         MenuController.titleMenu.show();
      }
   }
}


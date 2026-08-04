package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.mgn.events.*;
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.net.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   
   public class RulesMenu extends Menu
   {
      
      private var startDamageTimer:FrameTimer;
      
      private var startDamageMouseDown:Boolean;
      
      private var startDamageDiff:Number;
      
      private var startDamageInc:Boolean;
      
      private var m_timeNode:MenuMapperNode;
      
      private var m_stockNode:MenuMapperNode;
      
      private var m_ratioNode:MenuMapperNode;
      
      private var m_itemNode:MenuMapperNode;
      
      private var m_damageNode:MenuMapperNode;
      
      private var m_displayNode:MenuMapperNode;
      
      private var m_hazardNode:MenuMapperNode;
      
      private var m_staminaNode:MenuMapperNode;
      
      private var m_teamDamageNode:MenuMapperNode;
      
      private var m_fsMeterNode:MenuMapperNode;
      
      private var m_scoreDisplayNode:MenuMapperNode;
      
      private var m_hudDisplayNode:MenuMapperNode;
      
      private var m_pausingNode:MenuMapperNode;
      
      private var m_itemSwitchNode:MenuMapperNode;
      
      private var m_stageSwitchNode:MenuMapperNode;
      
      private var m_controlsNode:MenuMapperNode;
      
      public function RulesMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_rules");
         m_backgroundID = "space";
         this.startDamageTimer = new FrameTimer(5);
         this.startDamageMouseDown = false;
         this.startDamageDiff = 0;
         this.startDamageInc = true;
         this.initMenuMappings();
         m_container.addChild(m_subMenu);
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         if(!Config.enable_items)
         {
            Utils.setBrightness(m_subMenu.iSwitch_btn,-100);
         }
         this.updateFields();
      }
      
      override public function manageMenuMappings(param1:Event) : void
      {
         if(!(Boolean(MenuController.hasControlsMenu()) && Boolean(MenuController.controlsMenu.isOnscreen())) && !(Boolean(MenuController.hasItemSwitchMenu()) && Boolean(MenuController.itemSwitchMenu.isOnscreen())) && !(Boolean(MenuController.hasStageSwitchMenu()) && Boolean(MenuController.stageSwitchMenu.isOnscreen())))
         {
            super.manageMenuMappings(param1);
            return;
         }
         resetControlsLetGo();
      }
      
      override public function initMenuMappings() : void
      {
         this.m_timeNode = new MenuMapperNode(m_subMenu.time_hover);
         this.m_stockNode = new MenuMapperNode(m_subMenu.stock_hover);
         this.m_ratioNode = new MenuMapperNode(m_subMenu.ratio_hover);
         this.m_itemNode = m_subMenu.item_hover ? new MenuMapperNode(m_subMenu.item_hover) : null;
         this.m_damageNode = new MenuMapperNode(m_subMenu.damage_hover);
         this.m_displayNode = new MenuMapperNode(m_subMenu.display_hover);
         this.m_hazardNode = new MenuMapperNode(m_subMenu.hazard_hover);
         this.m_staminaNode = new MenuMapperNode(m_subMenu.stamina_hover);
         this.m_teamDamageNode = new MenuMapperNode(m_subMenu.teamdamage_hover);
         this.m_fsMeterNode = new MenuMapperNode(m_subMenu.fsmeter_hover);
         this.m_scoreDisplayNode = new MenuMapperNode(m_subMenu.score_hover);
         this.m_hudDisplayNode = new MenuMapperNode(m_subMenu.hud_hover);
         this.m_pausingNode = new MenuMapperNode(m_subMenu.pausing_hover);
         this.m_itemSwitchNode = new MenuMapperNode(m_subMenu.iSwitch_btn);
         this.m_stageSwitchNode = new MenuMapperNode(m_subMenu.sSwitch_btn);
         this.m_controlsNode = m_subMenu.controls_btn ? new MenuMapperNode(m_subMenu.controls_btn) : null;
         this.m_timeNode.updateNodes([this.m_itemSwitchNode,this.m_stageSwitchNode],[this.m_stockNode],null,null,this.generic_ROLL_OVER,null,this.timebut_CLICK,this.back_CLICK,null,null,this.tarrow_l_CLICK,this.tarrow_r_CLICK);
         this.m_stockNode.updateNodes([this.m_timeNode],[this.m_ratioNode],null,null,this.generic_ROLL_OVER,null,this.stockbut_CLICK,this.back_CLICK,null,null,this.sarrow_l_CLICK,this.sarrow_r_CLICK);
         this.m_ratioNode.updateNodes([this.m_stockNode],[this.m_damageNode],null,null,this.generic_ROLL_OVER,null,null,this.back_CLICK,null,null,this.darrow_l_CLICK,this.darrow_r_CLICK);
         this.m_damageNode.updateNodes([this.m_ratioNode],[this.m_staminaNode,this.m_hudDisplayNode],null,null,this.generic_ROLL_OVER,null,null,this.back_CLICK,null,null,this.prev_startDamage_CLICK,this.next_startDamage_CLICK);
         this.m_staminaNode.updateNodes([this.m_damageNode],[this.m_fsMeterNode],[this.m_hudDisplayNode],[this.m_hudDisplayNode],this.generic_ROLL_OVER,null,this.stamina_CLICK,this.back_CLICK);
         this.m_fsMeterNode.updateNodes([this.m_staminaNode],[this.m_hazardNode],[this.m_scoreDisplayNode],[this.m_scoreDisplayNode],this.generic_ROLL_OVER,null,this.fsmeter_CLICK,this.back_CLICK);
         this.m_hazardNode.updateNodes([this.m_fsMeterNode],[this.m_teamDamageNode],[this.m_displayNode],[this.m_displayNode],this.generic_ROLL_OVER,null,this.hazards_CLICK,this.back_CLICK);
         this.m_teamDamageNode.updateNodes([this.m_hazardNode],[this.m_itemSwitchNode,this.m_stageSwitchNode],[this.m_pausingNode],[this.m_pausingNode],this.generic_ROLL_OVER,null,this.teamdamage_CLICK,this.back_CLICK);
         this.m_hudDisplayNode.updateNodes([this.m_damageNode],[this.m_scoreDisplayNode],[this.m_staminaNode],[this.m_staminaNode],this.generic_ROLL_OVER,null,this.hud_CLICK,this.back_CLICK);
         this.m_scoreDisplayNode.updateNodes([this.m_hudDisplayNode],[this.m_displayNode],[this.m_fsMeterNode],[this.m_fsMeterNode],this.generic_ROLL_OVER,null,this.score_CLICK,this.back_CLICK);
         this.m_displayNode.updateNodes([this.m_scoreDisplayNode],[this.m_pausingNode],[this.m_hazardNode],[this.m_hazardNode],this.generic_ROLL_OVER,null,this.pDisplaybut_CLICK,this.back_CLICK);
         this.m_pausingNode.updateNodes([this.m_displayNode],[this.m_stageSwitchNode,this.m_itemSwitchNode],[this.m_teamDamageNode],[this.m_teamDamageNode],this.generic_ROLL_OVER,null,this.pausing_CLICK,this.back_CLICK);
         this.m_itemSwitchNode.updateNodes([this.m_teamDamageNode,this.m_pausingNode],[this.m_timeNode],[this.m_stageSwitchNode],[this.m_stageSwitchNode],this.generic_ROLL_OVER,null,this.iSwitch_btn_CLICK,this.back_CLICK);
         this.m_stageSwitchNode.updateNodes([this.m_pausingNode,this.m_teamDamageNode],[this.m_timeNode],[this.m_itemSwitchNode],[this.m_itemSwitchNode],this.generic_ROLL_OVER,null,this.sSwitch_btn_CLICK,this.back_CLICK);
         m_menuMapper = new MenuMapper(this.m_timeNode);
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
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER);
         m_subMenu.bg_top.home_btn.addEventListener(MouseEvent.CLICK,this.home_CLICK);
         if(m_subMenu.controls_btn)
         {
            m_subMenu.controls_btn.addEventListener(MouseEvent.CLICK,this.controls_CLICK);
            m_subMenu.controls_btn.addEventListener(MouseEvent.ROLL_OVER,this.controls_ROLL_OVER);
         }
         m_subMenu.tarrow_l.addEventListener(MouseEvent.CLICK,this.tarrow_l_CLICK);
         m_subMenu.tarrow_r.addEventListener(MouseEvent.CLICK,this.tarrow_r_CLICK);
         m_subMenu.sarrow_l.addEventListener(MouseEvent.CLICK,this.sarrow_l_CLICK);
         m_subMenu.sarrow_r.addEventListener(MouseEvent.CLICK,this.sarrow_r_CLICK);
         m_subMenu.darrow_l.addEventListener(MouseEvent.CLICK,this.darrow_l_CLICK);
         m_subMenu.darrow_r.addEventListener(MouseEvent.CLICK,this.darrow_r_CLICK);
         m_subMenu.starrow_l.addEventListener(MouseEvent.MOUSE_DOWN,this.prev_startDamage_DOWN);
         m_subMenu.starrow_l.addEventListener(MouseEvent.MOUSE_UP,this.prev_startDamage_UP);
         m_subMenu.starrow_r.addEventListener(MouseEvent.MOUSE_DOWN,this.next_startDamage_DOWN);
         m_subMenu.starrow_r.addEventListener(MouseEvent.MOUSE_UP,this.next_startDamage_UP);
         m_subMenu.starrow_l.addEventListener(MouseEvent.MOUSE_OUT,this.prev_startDamage_UP);
         m_subMenu.starrow_r.addEventListener(MouseEvent.MOUSE_OUT,this.next_startDamage_UP);
         m_subMenu.timebut.addEventListener(MouseEvent.CLICK,this.timebut_CLICK);
         m_subMenu.stockbut.addEventListener(MouseEvent.CLICK,this.stockbut_CLICK);
         m_subMenu.pDisplaybut.addEventListener(MouseEvent.CLICK,this.pDisplaybut_CLICK);
         m_subMenu.iSwitch_btn.addEventListener(MouseEvent.CLICK,this.iSwitch_btn_CLICK);
         m_subMenu.sSwitch_btn.addEventListener(MouseEvent.CLICK,this.sSwitch_btn_CLICK);
         m_subMenu.hazardsbut.addEventListener(MouseEvent.CLICK,this.hazards_CLICK);
         m_subMenu.staminabut.addEventListener(MouseEvent.CLICK,this.stamina_CLICK);
         m_subMenu.teamdamagebut.addEventListener(MouseEvent.CLICK,this.teamdamage_CLICK);
         m_subMenu.fsmeterbut.addEventListener(MouseEvent.CLICK,this.fsmeter_CLICK);
         m_subMenu.scorebut.addEventListener(MouseEvent.CLICK,this.score_CLICK);
         m_subMenu.hudbut.addEventListener(MouseEvent.CLICK,this.hud_CLICK);
         m_subMenu.pausingbut.addEventListener(MouseEvent.CLICK,this.pausing_CLICK);
         m_subMenu.addEventListener(Event.ENTER_FRAME,this.updateStartDamage);
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,this.manageMenuMappings);
         m_menuMapper.init();
         setMenuMappingFocus();
         this.updateFields();
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER);
         m_subMenu.bg_top.home_btn.removeEventListener(MouseEvent.CLICK,this.home_CLICK);
         if(m_subMenu.controls_btn)
         {
            m_subMenu.controls_btn.removeEventListener(MouseEvent.CLICK,this.controls_CLICK);
            m_subMenu.controls_btn.removeEventListener(MouseEvent.ROLL_OVER,this.controls_ROLL_OVER);
         }
         m_subMenu.tarrow_l.removeEventListener(MouseEvent.CLICK,this.tarrow_l_CLICK);
         m_subMenu.tarrow_r.removeEventListener(MouseEvent.CLICK,this.tarrow_r_CLICK);
         m_subMenu.sarrow_l.removeEventListener(MouseEvent.CLICK,this.sarrow_l_CLICK);
         m_subMenu.sarrow_r.removeEventListener(MouseEvent.CLICK,this.sarrow_r_CLICK);
         m_subMenu.darrow_l.removeEventListener(MouseEvent.CLICK,this.darrow_l_CLICK);
         m_subMenu.darrow_r.removeEventListener(MouseEvent.CLICK,this.darrow_r_CLICK);
         m_subMenu.starrow_l.removeEventListener(MouseEvent.MOUSE_DOWN,this.prev_startDamage_DOWN);
         m_subMenu.starrow_l.removeEventListener(MouseEvent.MOUSE_UP,this.prev_startDamage_UP);
         m_subMenu.starrow_r.removeEventListener(MouseEvent.MOUSE_DOWN,this.next_startDamage_DOWN);
         m_subMenu.starrow_r.removeEventListener(MouseEvent.MOUSE_UP,this.next_startDamage_UP);
         m_subMenu.starrow_l.removeEventListener(MouseEvent.MOUSE_OUT,this.prev_startDamage_UP);
         m_subMenu.starrow_r.removeEventListener(MouseEvent.MOUSE_OUT,this.next_startDamage_UP);
         m_subMenu.timebut.removeEventListener(MouseEvent.CLICK,this.timebut_CLICK);
         m_subMenu.stockbut.removeEventListener(MouseEvent.CLICK,this.stockbut_CLICK);
         m_subMenu.pDisplaybut.removeEventListener(MouseEvent.CLICK,this.pDisplaybut_CLICK);
         m_subMenu.iSwitch_btn.removeEventListener(MouseEvent.CLICK,this.iSwitch_btn_CLICK);
         m_subMenu.sSwitch_btn.removeEventListener(MouseEvent.CLICK,this.sSwitch_btn_CLICK);
         m_subMenu.hazardsbut.removeEventListener(MouseEvent.CLICK,this.hazards_CLICK);
         m_subMenu.staminabut.removeEventListener(MouseEvent.CLICK,this.stamina_CLICK);
         m_subMenu.teamdamagebut.removeEventListener(MouseEvent.CLICK,this.teamdamage_CLICK);
         m_subMenu.fsmeterbut.removeEventListener(MouseEvent.CLICK,this.fsmeter_CLICK);
         m_subMenu.scorebut.removeEventListener(MouseEvent.CLICK,this.score_CLICK);
         m_subMenu.hudbut.removeEventListener(MouseEvent.CLICK,this.hud_CLICK);
         m_subMenu.pausingbut.removeEventListener(MouseEvent.CLICK,this.pausing_CLICK);
         m_subMenu.removeEventListener(Event.ENTER_FRAME,this.updateStartDamage);
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,this.manageMenuMappings);
      }
      
      override public function show() : void
      {
         super.show();
      }
      
      private function back_CLICK(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(MenuController.CurrentCharacterSelectMenu != null && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj))
         {
            _loc2_ = 0;
            while(_loc2_ < MenuController.CurrentCharacterSelectMenu.PlayerChips.length)
            {
               MenuController.CurrentCharacterSelectMenu.PlayerChips[_loc2_].resetLetGo();
               _loc2_++;
            }
            MenuController.CurrentCharacterSelectMenu.GameObj.loadSavedVSOptions();
            MenuController.CurrentCharacterSelectMenu.updateDisplay();
            Main.Root.stage.focus = Main.Root;
         }
         SoundQueue.instance.playSoundEffect("menu_back");
         SaveData.saveGame();
         if(Boolean(MultiplayerManager.Connected) && Boolean(MultiplayerManager.IsHost) && Boolean(MenuController.CurrentCharacterSelectMenu))
         {
            MenuController.pleaseWaitMenu.show();
            MGNEventManager.dispatcher.addEventListener(MGNEvent.ROOM_DATA,this.roomData);
            MGNEventManager.dispatcher.addEventListener(MGNEvent.ERROR_ROOM_DATA,this.roomData);
            MultiplayerManager.sendMatchSettings({
               "version":Version.getVersion(),
               "protocol":MultiplayerManager.Protocol,
               "matchSettings":MenuController.CurrentCharacterSelectMenu.GameObj.exportSettings()
            });
         }
         else
         {
            removeSelf();
         }
      }
      
      private function roomData(param1:MGNEvent) : void
      {
         MGNEventManager.dispatcher.removeEventListener(MGNEvent.ROOM_DATA,this.roomData);
         MGNEventManager.dispatcher.removeEventListener(MGNEvent.ERROR_ROOM_DATA,this.roomData);
         if(param1.type === MGNEvent.ERROR_ROOM_DATA)
         {
            MultiplayerManager.notify("Warning, room data on the server could not be updated");
         }
         removeSelf();
         MenuController.pleaseWaitMenu.removeSelf();
      }
      
      private function generic_ROLL_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function back_ROLL_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function controls_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         MenuController.controlsMenu.show();
      }
      
      private function controls_ROLL_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function tarrow_l_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         SaveData.toggleTime(false);
         this.updateFields();
      }
      
      private function tarrow_r_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         SaveData.toggleTime(true);
         this.updateFields();
      }
      
      private function sarrow_l_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         SaveData.toggleStock(false);
         this.updateFields();
      }
      
      private function sarrow_r_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         SaveData.toggleStock(true);
         this.updateFields();
      }
      
      private function darrow_l_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         SaveData.toggleDamageRatio(false);
         this.updateFields();
      }
      
      private function darrow_r_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         SaveData.toggleDamageRatio(true);
         this.updateFields();
      }
      
      private function timebut_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         SaveData.toggleUsingTime();
         this.updateFields();
      }
      
      private function stockbut_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         SaveData.toggleUsingLives();
         this.updateFields();
      }
      
      private function pDisplaybut_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         SaveData.toggleShowPlayerID();
         this.updateFields();
      }
      
      private function iSwitch_btn_CLICK(param1:MouseEvent) : void
      {
         if(!Config.enable_items)
         {
            SoundQueue.instance.playSoundEffect("menu_error");
            return;
         }
         SoundQueue.instance.playSoundEffect("menu_select");
         MenuController.itemSwitchMenu.show();
      }
      
      private function sSwitch_btn_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         MenuController.stageSwitchMenu.show();
      }
      
      private function hazards_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         SaveData.toggleHazards();
         if(Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj))
         {
            MenuController.CurrentCharacterSelectMenu.GameObj.LevelData.hazards = SaveData.Hazards;
         }
         this.updateFields();
      }
      
      private function stamina_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         SaveData.toggleUsingStamina();
         if(Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj))
         {
            MenuController.CurrentCharacterSelectMenu.GameObj.LevelData.usingStamina = SaveData.UsingStamina;
         }
         this.updateFields();
      }
      
      private function teamdamage_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         SaveData.toggleTeamDamage();
         this.updateFields();
      }
      
      private function fsmeter_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         SaveData.FinalSmashMeter = !SaveData.FinalSmashMeter;
         this.updateFields();
      }
      
      private function score_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         SaveData.ScoreDisplay = !SaveData.ScoreDisplay;
         this.updateFields();
      }
      
      private function hud_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         SaveData.HudDisplay = !SaveData.HudDisplay;
         this.updateFields();
      }
      
      private function pausing_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         SaveData.PauseEnabled = !SaveData.PauseEnabled;
         this.updateFields();
      }
      
      private function next_startDamage_DOWN(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         this.startDamageMouseDown = true;
         this.startDamageInc = true;
         this.startDamageDiff = 0;
         this.startDamageTimer.CurrentTime = this.startDamageTimer.MaxTime;
      }
      
      private function prev_startDamage_DOWN(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         this.startDamageMouseDown = true;
         this.startDamageInc = false;
         this.startDamageDiff = 0;
         this.startDamageTimer.CurrentTime = this.startDamageTimer.MaxTime;
      }
      
      private function next_startDamage_UP(param1:MouseEvent) : void
      {
         this.startDamageMouseDown = false;
         this.startDamageInc = true;
      }
      
      private function prev_startDamage_UP(param1:MouseEvent) : void
      {
         this.startDamageMouseDown = false;
         this.startDamageInc = false;
      }
      
      private function next_startDamage_CLICK(param1:MouseEvent) : void
      {
         var _loc2_:Number = SaveData.UsingStamina ? Number(SaveData.StartStamina) : Number(SaveData.StartDamage);
         if(SaveData.UsingStamina)
         {
            SaveData.setStartStamina(_loc2_ + 1);
         }
         else
         {
            SaveData.setStartDamage(_loc2_ + 1);
         }
         if(Boolean(MenuController.CurrentCharacterSelectMenu) && MenuController.CurrentCharacterSelectMenu.GameObj != null)
         {
            MenuController.CurrentCharacterSelectMenu.GameObj.loadSavedVSOptions();
         }
         m_subMenu.startDmgTxt.text = SaveData.UsingStamina ? "" + SaveData.StartStamina : "" + SaveData.StartDamage;
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function prev_startDamage_CLICK(param1:MouseEvent) : void
      {
         var _loc2_:Number = SaveData.UsingStamina ? Number(SaveData.StartStamina) : Number(SaveData.StartDamage);
         if(SaveData.UsingStamina)
         {
            SaveData.setStartStamina(_loc2_ - 1);
         }
         else
         {
            SaveData.setStartDamage(_loc2_ - 1);
         }
         if(Boolean(MenuController.CurrentCharacterSelectMenu) && MenuController.CurrentCharacterSelectMenu.GameObj != null)
         {
            MenuController.CurrentCharacterSelectMenu.GameObj.loadSavedVSOptions();
         }
         m_subMenu.startDmgTxt.text = SaveData.UsingStamina ? "" + SaveData.StartStamina : "" + SaveData.StartDamage;
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function updateStartDamage(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         if(this.startDamageMouseDown)
         {
            this.startDamageTimer.tick();
            if(this.startDamageTimer.IsComplete)
            {
               _loc2_ = SaveData.UsingStamina ? Number(SaveData.StartStamina) : Number(SaveData.StartDamage);
               this.startDamageTimer.reset();
               ++this.startDamageDiff;
               if(this.startDamageDiff >= 5)
               {
                  this.startDamageTimer.MaxTime = 1;
               }
               else if(this.startDamageDiff < 5)
               {
                  this.startDamageTimer.MaxTime = 5;
               }
               if(this.startDamageInc)
               {
                  _loc2_ += this.startDamageDiff >= 60 ? 6 : 1;
               }
               else
               {
                  _loc2_ -= this.startDamageDiff >= 60 ? 6 : 1;
               }
               if(SaveData.UsingStamina)
               {
                  SaveData.setStartStamina(_loc2_);
               }
               else
               {
                  SaveData.setStartDamage(_loc2_);
               }
               if(Boolean(MenuController.CurrentCharacterSelectMenu) && MenuController.CurrentCharacterSelectMenu.GameObj != null)
               {
                  MenuController.CurrentCharacterSelectMenu.GameObj.loadSavedVSOptions();
               }
               m_subMenu.startDmgTxt.text = SaveData.UsingStamina ? SaveData.StartStamina : SaveData.StartDamage;
            }
         }
      }
      
      private function updateFields() : void
      {
         if(!SaveData.UsingTime)
         {
            m_subMenu.timebut.gotoAndStop("off");
         }
         else
         {
            m_subMenu.timebut.gotoAndStop("on");
         }
         if(!SaveData.UsingLives)
         {
            m_subMenu.stockbut.gotoAndStop("off");
         }
         else
         {
            m_subMenu.stockbut.gotoAndStop("on");
         }
         if(!SaveData.ShowPlayerID)
         {
            m_subMenu.pDisplaybut.gotoAndStop("off");
         }
         else
         {
            m_subMenu.pDisplaybut.gotoAndStop("on");
         }
         if(!SaveData.Hazards)
         {
            m_subMenu.hazardsbut.gotoAndStop("off");
         }
         else
         {
            m_subMenu.hazardsbut.gotoAndStop("on");
         }
         if(!SaveData.UsingStamina)
         {
            m_subMenu.staminabut.gotoAndStop("off");
         }
         else
         {
            m_subMenu.staminabut.gotoAndStop("on");
         }
         if(!SaveData.TeamDamage)
         {
            m_subMenu.teamdamagebut.gotoAndStop("off");
         }
         else
         {
            m_subMenu.teamdamagebut.gotoAndStop("on");
         }
         if(!SaveData.FinalSmashMeter)
         {
            m_subMenu.fsmeterbut.gotoAndStop("off");
         }
         else
         {
            m_subMenu.fsmeterbut.gotoAndStop("on");
         }
         if(!SaveData.ScoreDisplay)
         {
            m_subMenu.scorebut.gotoAndStop("off");
         }
         else
         {
            m_subMenu.scorebut.gotoAndStop("on");
         }
         if(!SaveData.HudDisplay)
         {
            m_subMenu.hudbut.gotoAndStop("off");
         }
         else
         {
            m_subMenu.hudbut.gotoAndStop("on");
         }
         if(!SaveData.PauseEnabled)
         {
            m_subMenu.pausingbut.gotoAndStop("off");
         }
         else
         {
            m_subMenu.pausingbut.gotoAndStop("on");
         }
         m_subMenu.timeTxt.text = SaveData.Time + ":00";
         m_subMenu.dmgRatioTxt.text = SaveData.DamageRatio == Math.round(SaveData.DamageRatio) ? "x" + SaveData.DamageRatio + ".0" : "x" + SaveData.DamageRatio;
         m_subMenu.stockTxt.text = "" + SaveData.Lives;
         if(SaveData.UsingStamina)
         {
            m_subMenu.startDmgTxt.text = "" + SaveData.StartStamina;
         }
         else
         {
            m_subMenu.startDmgTxt.text = "" + SaveData.StartDamage;
         }
      }
      
      private function home_CLICK(param1:MouseEvent) : void
      {
         if(MultiplayerManager.Connected)
         {
            MultiplayerManager.disconnect();
         }
         SaveData.saveGame();
         SoundQueue.instance.playSoundEffect("menu_back");
         SoundQueue.instance.stopMusic();
         if(MenuController.CurrentCharacterSelectMenu)
         {
            MenuController.CurrentCharacterSelectMenu.resetScreen();
         }
         MenuController.removeAllMenus();
         MenuController.titleMenu.show();
      }
   }
}


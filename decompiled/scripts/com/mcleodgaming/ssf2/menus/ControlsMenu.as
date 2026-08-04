package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.events.*;
   import com.mcleodgaming.ssf2.input.*;
   import com.mcleodgaming.ssf2.net.*;
   import com.mcleodgaming.ssf2.util.*;
   import fl.controls.CheckBox;
   import fl.controls.ComboBox;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.text.TextField;
   
   public class ControlsMenu extends Menu
   {
      
      public var playNum:int;
      
      public var selectHand:ControlsSelectHand;
      
      private var controlsButtons:Vector.<ControlsButton>;
      
      private var m_tapJumpCheckBox:CheckBox;
      
      private var m_autoDashCheckBox:CheckBox;
      
      private var m_dtDashCheckBox:CheckBox;
      
      private var m_rumbleCheckBox:CheckBox;
      
      private var m_autoDashTxt:TextField;
      
      private var m_dtDashTxt:TextField;
      
      private var m_rumbleTxt:TextField;
      
      private var m_gamepadDropdown:ComboBox;
      
      private var m_rumbleToggle:MovieClip;
      
      public var controlStickDashZone:Number;
      
      public var controlStickDeadZone:Number;
      
      public var cStickDashZone:Number;
      
      public var cStickDeadZone:Number;
      
      public function ControlsMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_controls");
         m_backgroundID = "space";
         this.m_tapJumpCheckBox = m_subMenu.tapJump;
         this.m_autoDashCheckBox = m_subMenu.autoDash;
         this.m_autoDashTxt = m_subMenu.autoDashTxt;
         this.m_dtDashCheckBox = m_subMenu.dtapDash;
         this.m_dtDashTxt = m_subMenu.dtapDashTxt;
         this.m_rumbleCheckBox = m_subMenu.rumble;
         this.m_rumbleTxt = m_subMenu.rumbleTxt;
         this.m_gamepadDropdown = m_subMenu.gamepadDropdown;
         m_subMenu.keySetter.visible = false;
         this.controlStickDashZone = Gamepad.DASHZONE_DEFAULT * 100;
         this.controlStickDeadZone = Gamepad.DEADZONE_DEFAULT * 100;
         this.cStickDashZone = Gamepad.DASHZONE_DEFAULT * 100;
         this.cStickDeadZone = Gamepad.DEADZONE_DEFAULT * 100;
         this.playNum = 1;
         this.controlsButtons = new Vector.<ControlsButton>();
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k1,"Up","UP",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k2,"Jump","JUMP",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k3,"Pause","START",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k4,"Grab","GRAB",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k5,"Shield","SHIELD",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k6,"Left","LEFT",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k7,"Right","RIGHT",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k8,"Taunt","TAUNT",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k9,"Standard Attack","BUTTON2",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k10,"Down","DOWN",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k11,"Special Attack","BUTTON1",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k12,"Jump","JUMP2",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k13,"C-Stick Up","C_UP",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k14,"C-Stick Down","C_DOWN",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k15,"C-Stick Left","C_LEFT",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k16,"C-Stick Right","C_RIGHT",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k17,"Dash Button","DASH",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k18,"Shield Button","SHIELD2",this.playNum));
         m_subMenu.key_up.mouseEnabled = false;
         m_subMenu.key_down.mouseEnabled = false;
         m_subMenu.key_left.mouseEnabled = false;
         m_subMenu.key_right.mouseEnabled = false;
         m_subMenu.key_jump.mouseEnabled = false;
         m_subMenu.key_a.mouseEnabled = false;
         m_subMenu.key_b.mouseEnabled = false;
         m_subMenu.key_grab.mouseEnabled = false;
         m_subMenu.key_shield.mouseEnabled = false;
         m_subMenu.key_taunt.mouseEnabled = false;
         m_subMenu.key_pause.mouseEnabled = false;
         m_subMenu.key_jump2.mouseEnabled = false;
         m_subMenu.key_cup.mouseEnabled = false;
         m_subMenu.key_cdown.mouseEnabled = false;
         m_subMenu.key_cleft.mouseEnabled = false;
         m_subMenu.key_cright.mouseEnabled = false;
         m_subMenu.key_dash.mouseEnabled = false;
         m_subMenu.key_shield2.mouseEnabled = false;
         this.updateControls();
         this.updateCurrPlayer();
         m_container.addChild(m_subMenu);
         this.selectHand = new ControlsSelectHand(m_subMenu,this.controlsButtons,this.back_CLICK);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.p1Controls_btn);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.p2Controls_btn);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.p3Controls_btn);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.p4Controls_btn);
         this.selectHand.addClickEventClipHitTest(m_subMenu.bg_top.back_btn);
         this.selectHand.addClickEventClipHitTest(m_subMenu.bg_top.home_btn);
         initMenuMappings();
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
      }
      
      private static function shortenInputID(param1:String, param2:Boolean = false) : String
      {
         if(param1.match(/AXIS_(\d+)/))
         {
            return "AX" + param1.match(/AXIS_(\d+)/)[1] + (!param2 ? "+" : "-");
         }
         if(param1.match(/BUTTON_(\d+)/))
         {
            return "BN" + param1.match(/BUTTON_(\d+)/)[1];
         }
         return param1;
      }
      
      public static function getGamepadInputName(param1:int, param2:String) : String
      {
         var _loc3_:* = undefined;
         var _loc4_:Object = null;
         var _loc8_:int = 0;
         var _loc5_:Vector.<String> = new Vector.<String>();
         var _loc6_:Gamepad = SaveData.Controllers[param1 - 1].GamepadInstance;
         var _loc7_:String = Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj) ? MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[param1 - 1].name : null;
         for(_loc3_ in _loc6_.ControlState)
         {
            _loc4_ = SaveData.getGamepadInputData(_loc6_.Name,_loc7_ ? 0 : _loc6_.Port,_loc7_ ? _loc7_ : "port" + _loc6_.Port,_loc3_);
            _loc8_ = int(_loc4_.inputs.indexOf(param2));
            if(_loc8_ >= 0)
            {
               _loc5_.push(ControlsMenu.shortenInputID(_loc3_));
            }
            _loc8_ = int(_loc4_.inputsInverse.indexOf(param2));
            if(_loc8_ >= 0)
            {
               _loc5_.push(ControlsMenu.shortenInputID(_loc3_,true));
            }
         }
         return _loc5_.join(", ");
      }
      
      public function get AutoDashCheckBox() : CheckBox
      {
         return this.m_autoDashCheckBox;
      }
      
      public function get DTDashCheckBox() : CheckBox
      {
         return this.m_dtDashCheckBox;
      }
      
      public function get TapJumpCheckBox() : CheckBox
      {
         return this.m_tapJumpCheckBox;
      }
      
      public function get RumbleCheckBox() : CheckBox
      {
         return this.m_rumbleCheckBox;
      }
      
      override public function show() : void
      {
         this.updateControls();
         super.show();
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
         m_subMenu.p1Controls_btn.addEventListener(MouseEvent.CLICK,this.p1Controls_CLICK);
         m_subMenu.p2Controls_btn.addEventListener(MouseEvent.CLICK,this.p2Controls_CLICK);
         m_subMenu.p3Controls_btn.addEventListener(MouseEvent.CLICK,this.p3Controls_CLICK);
         m_subMenu.p4Controls_btn.addEventListener(MouseEvent.CLICK,this.p4Controls_CLICK);
         m_subMenu.p1Controls_btn.addEventListener(MouseEvent.ROLL_OVER,this.pControls_ROLL_OVER);
         m_subMenu.p2Controls_btn.addEventListener(MouseEvent.ROLL_OVER,this.pControls_ROLL_OVER);
         m_subMenu.p3Controls_btn.addEventListener(MouseEvent.ROLL_OVER,this.pControls_ROLL_OVER);
         m_subMenu.p4Controls_btn.addEventListener(MouseEvent.ROLL_OVER,this.pControls_ROLL_OVER);
         _loc1_ = 0;
         while(_loc1_ < this.controlsButtons.length)
         {
            this.controlsButtons[_loc1_].makeEvents();
            _loc1_++;
         }
         this.m_tapJumpCheckBox.addEventListener(Event.CHANGE,this.tapJump_CHANGE);
         this.m_autoDashCheckBox.addEventListener(Event.CHANGE,this.autoDash_CHANGE);
         this.m_dtDashCheckBox.addEventListener(Event.CHANGE,this.dtDash_CHANGE);
         this.m_rumbleCheckBox.addEventListener(Event.CHANGE,this.rumble_CHANGE);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER);
         m_subMenu.bg_top.home_btn.addEventListener(MouseEvent.CLICK,this.home_CLICK);
         m_subMenu.controllerConfig.addEventListener(MouseEvent.CLICK,this.gamepad_CLICK);
         this.selectHand.makeEvents();
         this.playNum = 1;
         this.setPlayer(this.playNum);
         this.extractDeadAndDashZones();
         this.updateCurrPlayer();
         this.updateControls();
         this.m_gamepadDropdown.addEventListener(Event.CHANGE,this.inputTypeChanged);
         this.redrawGamepadList();
         this.RumbleCheckBox.selected = SaveData.getRumbleEnabled(this.playNum);
         this.RumbleCheckBox.visible = true;
         this.m_rumbleTxt.visible = true;
         m_subMenu.cStickConfig.gotoAndStop("cStick");
         m_subMenu.controlStickConfig.radiusTxt.addEventListener(Event.CHANGE,this.onControlStickRadiusChanged);
         m_subMenu.controlStickConfig.deadZoneTxt.addEventListener(Event.CHANGE,this.onControlStickDeadZoneChanged);
         m_subMenu.cStickConfig.radiusTxt.addEventListener(Event.CHANGE,this.onCStickRadiusChanged);
         m_subMenu.cStickConfig.deadZoneTxt.addEventListener(Event.CHANGE,this.onCStickDeadZoneChanged);
      }
      
      override public function killEvents() : void
      {
         var _loc1_:int = 0;
         super.killEvents();
         m_subMenu.p1Controls_btn.removeEventListener(MouseEvent.CLICK,this.p1Controls_CLICK);
         m_subMenu.p2Controls_btn.removeEventListener(MouseEvent.CLICK,this.p2Controls_CLICK);
         m_subMenu.p3Controls_btn.removeEventListener(MouseEvent.CLICK,this.p3Controls_CLICK);
         m_subMenu.p4Controls_btn.removeEventListener(MouseEvent.CLICK,this.p4Controls_CLICK);
         m_subMenu.p1Controls_btn.removeEventListener(MouseEvent.ROLL_OVER,this.pControls_ROLL_OVER);
         m_subMenu.p2Controls_btn.removeEventListener(MouseEvent.ROLL_OVER,this.pControls_ROLL_OVER);
         m_subMenu.p3Controls_btn.removeEventListener(MouseEvent.ROLL_OVER,this.pControls_ROLL_OVER);
         m_subMenu.p4Controls_btn.removeEventListener(MouseEvent.ROLL_OVER,this.pControls_ROLL_OVER);
         while(_loc1_ < this.controlsButtons.length)
         {
            this.controlsButtons[_loc1_].killEvents();
            _loc1_++;
         }
         this.m_tapJumpCheckBox.removeEventListener(Event.CHANGE,this.tapJump_CHANGE);
         this.m_autoDashCheckBox.removeEventListener(Event.CHANGE,this.autoDash_CHANGE);
         this.m_dtDashCheckBox.removeEventListener(Event.CHANGE,this.dtDash_CHANGE);
         this.m_rumbleCheckBox.removeEventListener(Event.CHANGE,this.rumble_CHANGE);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER);
         m_subMenu.bg_top.home_btn.removeEventListener(MouseEvent.CLICK,this.home_CLICK);
         m_subMenu.controllerConfig.removeEventListener(MouseEvent.CLICK,this.gamepad_CLICK);
         this.selectHand.killEvents();
         this.m_gamepadDropdown.removeEventListener(Event.CHANGE,this.inputTypeChanged);
         if(SaveData.Controllers[this.playNum - 1].GamepadInstance)
         {
            SaveData.Controllers[this.playNum - 1].GamepadInstance.removeEventListener(GamepadEvent.AXIS_CHANGED,this.onAxisChanged);
            SaveData.Controllers[this.playNum - 1].GamepadInstance.removeEventListener(GamepadEvent.BUTTON_DOWN,this.onGamepadButtonDown);
         }
         m_subMenu.controlStickConfig.radiusTxt.removeEventListener(Event.CHANGE,this.onControlStickRadiusChanged);
         m_subMenu.controlStickConfig.deadZoneTxt.removeEventListener(Event.CHANGE,this.onControlStickDeadZoneChanged);
         m_subMenu.cStickConfig.radiusTxt.removeEventListener(Event.CHANGE,this.onCStickRadiusChanged);
         m_subMenu.cStickConfig.deadZoneTxt.removeEventListener(Event.CHANGE,this.onCStickDeadZoneChanged);
      }
      
      private function redrawGamepadList() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         this.m_gamepadDropdown.removeAll();
         var _loc3_:Vector.<Gamepad> = GamepadManager.getGamepads();
         this.m_gamepadDropdown.addItem({
            "label":"Keyboard",
            "gamepad":null
         });
         this.m_gamepadDropdown.selectedIndex = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc1_ = false;
            _loc2_ = 0;
            while(_loc2_ < SaveData.Controllers.length)
            {
               if(_loc3_[_loc4_] === SaveData.Controllers[_loc2_].GamepadInstance && this.playNum !== _loc2_ + 1)
               {
                  _loc1_ = true;
                  break;
               }
               _loc2_++;
            }
            if(!_loc1_)
            {
               this.m_gamepadDropdown.addItem({
                  "label":_loc3_[_loc4_].Name + " " + _loc3_[_loc4_].Port,
                  "gamepad":_loc3_[_loc4_]
               });
            }
            if(SaveData.Controllers[this.playNum - 1].GamepadInstance === _loc3_[_loc4_])
            {
               this.m_gamepadDropdown.selectedIndex = this.m_gamepadDropdown.length - 1;
            }
            _loc4_++;
         }
      }
      
      public function inputTypeChanged(param1:Event) : void
      {
         var _loc5_:int = 0;
         var _loc2_:Gamepad = this.m_gamepadDropdown.selectedItem.gamepad;
         var _loc3_:PlayerSetting = Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj) ? MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[this.playNum - 1] : null;
         var _loc4_:Gamepad = SaveData.Controllers[this.playNum - 1].GamepadInstance;
         SaveData.Controllers[this.playNum - 1].GamepadInstance = _loc2_;
         if(_loc4_)
         {
            _loc4_.removeEventListener(GamepadEvent.AXIS_CHANGED,this.onAxisChanged);
            _loc4_.removeEventListener(GamepadEvent.BUTTON_DOWN,this.onGamepadButtonDown);
            if(MenuController.CurrentCharacterSelectMenu)
            {
               _loc4_.removeEventListener(GamepadEvent.BUTTON_DOWN,MenuController.CurrentCharacterSelectMenu.onGamepadButtonPressed);
            }
         }
         if(_loc2_)
         {
            if(_loc2_ != null)
            {
               _loc5_ = 0;
               while(_loc5_ < SaveData.Controllers.length)
               {
                  if(_loc5_ != this.playNum - 1 && SaveData.Controllers[_loc5_].GamepadInstance === _loc2_)
                  {
                     SaveData.Controllers[_loc5_].GamepadInstance = null;
                     SaveData.PortInputs[_loc5_ + 1] = null;
                  }
                  _loc5_++;
               }
            }
            SaveData.PortInputs[this.playNum] = _loc2_.Name + " " + _loc2_.Port;
            SaveData.Gamepads[_loc2_.Name] = SaveData.Gamepads[_loc2_.Name] || {
               "names":{},
               "ports":{}
            };
            _loc2_.addEventListener(GamepadEvent.AXIS_CHANGED,this.onAxisChanged);
            _loc2_.addEventListener(GamepadEvent.BUTTON_DOWN,this.onGamepadButtonDown);
            if(MenuController.CurrentCharacterSelectMenu)
            {
               _loc2_.addEventListener(GamepadEvent.BUTTON_DOWN,MenuController.CurrentCharacterSelectMenu.onGamepadButtonPressed);
            }
            if(Boolean(_loc3_) && Boolean(_loc3_.human) && Boolean(_loc3_.name))
            {
               SaveData.Gamepads[_loc2_.Name].names[_loc3_.name] = SaveData.Gamepads[_loc2_.Name].names[_loc3_.name] || {};
               SaveData.reimportNamedPlayerControls(this.playNum,_loc3_.name);
            }
            else
            {
               SaveData.Gamepads[_loc2_.Name].ports["port" + _loc2_.Port] = SaveData.Gamepads[_loc2_.Name].ports["port" + _loc2_.Port] || {};
               SaveData.reimportSlottedPlayerControls(this.playNum);
            }
            m_subMenu.controlStickConfig.visible = true;
            m_subMenu.cStickConfig.visible = true;
            this.m_rumbleCheckBox.visible = true;
            this.m_rumbleTxt.visible = true;
            this.extractDeadAndDashZones();
         }
         else
         {
            SaveData.PortInputs[this.playNum] = null;
            m_subMenu.controlStickConfig.visible = false;
            m_subMenu.cStickConfig.visible = false;
            this.m_rumbleCheckBox.visible = false;
            this.m_rumbleTxt.visible = false;
         }
         this.updateControls();
      }
      
      private function getAxisPressure(param1:Object, param2:String) : Number
      {
         if(param1.inputs.indexOf(param2) >= 0)
         {
            if(param2 === "UP" || param2 === "LEFT" || param2 === "C_UP" || param2 === "C_LEFT")
            {
               return -param1.value;
            }
            if(param2 === "DOWN" || param2 === "RIGHT" || param2 === "C_DOWN" || param2 === "C_RIGHT")
            {
               return param1.value;
            }
         }
         if(param1.inputsInverse.indexOf(param2) >= 0)
         {
            if(param2 === "UP" || param2 === "LEFT" || param2 === "C_UP" || param2 === "C_LEFT")
            {
               return param1.value;
            }
            if(param2 === "DOWN" || param2 === "RIGHT" || param2 === "C_DOWN" || param2 === "C_RIGHT")
            {
               return -param1.value;
            }
         }
         return 0;
      }
      
      private function onAxisChanged(param1:GamepadEvent) : void
      {
         var _loc2_:Number = Number(this.getAxisPressure(param1.controlState,"UP"));
         var _loc3_:Number = Number(this.getAxisPressure(param1.controlState,"DOWN"));
         var _loc4_:Number = Number(this.getAxisPressure(param1.controlState,"LEFT"));
         var _loc5_:Number = Number(this.getAxisPressure(param1.controlState,"RIGHT"));
         if(Boolean(_loc2_) || Boolean(_loc3_) || Boolean(_loc4_) || Boolean(_loc5_))
         {
            if(_loc2_)
            {
               m_subMenu.controlStickConfig.dot.y = _loc2_ * 20;
            }
            if(_loc3_)
            {
               m_subMenu.controlStickConfig.dot.y = _loc3_ * 20;
            }
            if(_loc4_)
            {
               m_subMenu.controlStickConfig.dot.x = _loc4_ * 20;
            }
            if(_loc5_)
            {
               m_subMenu.controlStickConfig.dot.x = _loc5_ * 20;
            }
         }
         else
         {
            m_subMenu.controlStickConfig.dot.x = 0;
            m_subMenu.controlStickConfig.dot.y = 0;
         }
         var _loc6_:Number = Number(this.getAxisPressure(param1.controlState,"C_UP"));
         var _loc7_:Number = Number(this.getAxisPressure(param1.controlState,"C_DOWN"));
         var _loc8_:Number = Number(this.getAxisPressure(param1.controlState,"C_LEFT"));
         var _loc9_:Number = Number(this.getAxisPressure(param1.controlState,"C_RIGHT"));
         if(Boolean(_loc6_) || Boolean(_loc7_) || Boolean(_loc8_) || Boolean(_loc9_))
         {
            if(_loc6_)
            {
               m_subMenu.cStickConfig.dot.y = _loc6_ * 20;
            }
            if(_loc7_)
            {
               m_subMenu.cStickConfig.dot.y = _loc7_ * 20;
            }
            if(_loc8_)
            {
               m_subMenu.cStickConfig.dot.x = _loc8_ * 20;
            }
            if(_loc9_)
            {
               m_subMenu.cStickConfig.dot.x = _loc9_ * 20;
            }
         }
         else
         {
            m_subMenu.cStickConfig.dot.x = 0;
            m_subMenu.cStickConfig.dot.y = 0;
         }
      }
      
      private function onControlStickRadiusChanged(param1:Event) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         var _loc5_:Object = null;
         var _loc6_:Gamepad = SaveData.Controllers[this.playNum - 1].GamepadInstance;
         var _loc7_:Number = Number(parseFloat(m_subMenu.controlStickConfig.radiusTxt.text));
         if(Boolean(_loc6_) && !isNaN(_loc7_))
         {
            _loc7_ = Math.min(Math.max(0,_loc7_ / 100),1);
            m_subMenu.controlStickConfig.radius.scaleX = _loc7_;
            m_subMenu.controlStickConfig.radius.scaleY = _loc7_;
            this.controlStickDashZone = _loc7_ * 100;
            _loc2_ = Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj) ? MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[this.playNum - 1].name : null;
            _loc3_ = _loc2_ ? "names" : "ports";
            for(_loc4_ in _loc6_.ControlState)
            {
               if(_loc6_.ControlState[_loc4_].inputs.indexOf("UP") >= 0 || _loc6_.ControlState[_loc4_].inputs.indexOf("DOWN") >= 0 || _loc6_.ControlState[_loc4_].inputs.indexOf("LEFT") >= 0 || _loc6_.ControlState[_loc4_].inputs.indexOf("RIGHT") >= 0)
               {
                  _loc5_ = SaveData.getGamepadInputData(_loc6_.Name,_loc2_ ? 0 : _loc6_.Port,_loc2_ ? _loc2_ : "port" + _loc6_.Port,_loc4_);
                  _loc5_.dashZone = _loc7_;
               }
            }
            _loc6_.importControls(SaveData.Gamepads[_loc6_.Name][_loc3_][_loc2_ || "port" + _loc6_.Port]);
         }
      }
      
      private function onControlStickDeadZoneChanged(param1:Event) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         var _loc5_:Object = null;
         var _loc6_:Gamepad = SaveData.Controllers[this.playNum - 1].GamepadInstance;
         var _loc7_:Number = Number(parseFloat(m_subMenu.controlStickConfig.deadZoneTxt.text));
         if(Boolean(_loc6_) && !isNaN(_loc7_))
         {
            _loc7_ = Math.min(Math.max(0,_loc7_ / 100),1);
            m_subMenu.controlStickConfig.deadZone.scaleX = _loc7_;
            m_subMenu.controlStickConfig.deadZone.scaleY = _loc7_;
            this.controlStickDeadZone = _loc7_ * 100;
            _loc2_ = Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj) ? MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[this.playNum - 1].name : null;
            _loc3_ = _loc2_ ? "names" : "ports";
            for(_loc4_ in _loc6_.ControlState)
            {
               if(_loc6_.ControlState[_loc4_].inputs.indexOf("UP") >= 0 || _loc6_.ControlState[_loc4_].inputs.indexOf("DOWN") >= 0 || _loc6_.ControlState[_loc4_].inputs.indexOf("LEFT") >= 0 || _loc6_.ControlState[_loc4_].inputs.indexOf("RIGHT") >= 0)
               {
                  _loc5_ = SaveData.getGamepadInputData(_loc6_.Name,_loc2_ ? 0 : _loc6_.Port,_loc2_ ? _loc2_ : "port" + _loc6_.Port,_loc4_);
                  _loc5_.deadZone = _loc7_;
               }
            }
            _loc6_.importControls(SaveData.Gamepads[_loc6_.Name][_loc3_][_loc2_ || "port" + _loc6_.Port]);
         }
      }
      
      private function onCStickRadiusChanged(param1:Event) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         var _loc5_:Object = null;
         var _loc6_:Gamepad = SaveData.Controllers[this.playNum - 1].GamepadInstance;
         var _loc7_:Number = Number(parseFloat(m_subMenu.cStickConfig.radiusTxt.text));
         if(Boolean(_loc6_) && !isNaN(_loc7_))
         {
            _loc7_ = Math.min(Math.max(0,_loc7_ / 100),1);
            m_subMenu.cStickConfig.radius.scaleX = _loc7_;
            m_subMenu.cStickConfig.radius.scaleY = _loc7_;
            this.cStickDashZone = _loc7_ * 100;
            _loc2_ = Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj) ? MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[this.playNum - 1].name : null;
            _loc3_ = _loc2_ ? "names" : "ports";
            for(_loc4_ in _loc6_.ControlState)
            {
               if(_loc6_.ControlState[_loc4_].inputs.indexOf("C_UP") >= 0 || _loc6_.ControlState[_loc4_].inputs.indexOf("C_DOWN") >= 0 || _loc6_.ControlState[_loc4_].inputs.indexOf("C_LEFT") >= 0 || _loc6_.ControlState[_loc4_].inputs.indexOf("C_RIGHT") >= 0)
               {
                  _loc5_ = SaveData.getGamepadInputData(_loc6_.Name,_loc2_ ? 0 : _loc6_.Port,_loc2_ ? _loc2_ : "port" + _loc6_.Port,_loc4_);
                  _loc5_.dashZone = _loc7_;
               }
            }
            _loc6_.importControls(SaveData.Gamepads[_loc6_.Name][_loc3_][_loc2_ || "port" + _loc6_.Port]);
         }
      }
      
      private function onCStickDeadZoneChanged(param1:Event) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         var _loc5_:Object = null;
         var _loc6_:Gamepad = SaveData.Controllers[this.playNum - 1].GamepadInstance;
         var _loc7_:Number = Number(parseFloat(m_subMenu.cStickConfig.deadZoneTxt.text));
         if(Boolean(_loc6_) && !isNaN(_loc7_))
         {
            _loc7_ = Math.min(Math.max(0,_loc7_ / 100),1);
            m_subMenu.cStickConfig.deadZone.scaleX = _loc7_;
            m_subMenu.cStickConfig.deadZone.scaleY = _loc7_;
            this.cStickDeadZone = _loc7_ * 100;
            _loc2_ = Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj) ? MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[this.playNum - 1].name : null;
            _loc3_ = _loc2_ ? "names" : "ports";
            for(_loc4_ in _loc6_.ControlState)
            {
               if(_loc6_.ControlState[_loc4_].inputs.indexOf("C_UP") >= 0 || _loc6_.ControlState[_loc4_].inputs.indexOf("C_DOWN") >= 0 || _loc6_.ControlState[_loc4_].inputs.indexOf("C_LEFT") >= 0 || _loc6_.ControlState[_loc4_].inputs.indexOf("C_RIGHT") >= 0)
               {
                  _loc5_ = SaveData.getGamepadInputData(_loc6_.Name,_loc2_ ? 0 : _loc6_.Port,_loc2_ ? _loc2_ : "port" + _loc6_.Port,_loc4_);
                  _loc5_.deadZone = _loc7_;
               }
            }
            _loc6_.importControls(SaveData.Gamepads[_loc6_.Name][_loc3_][_loc2_ || "port" + _loc6_.Port]);
         }
      }
      
      public function updateControls() : void
      {
         var _loc1_:Controller = SaveData.Controllers[this.playNum - 1];
         if(_loc1_.GamepadInstance)
         {
            m_subMenu.key_up.text = ControlsMenu.getGamepadInputName(this.playNum,_loc1_._UP);
            m_subMenu.key_down.text = ControlsMenu.getGamepadInputName(this.playNum,_loc1_._DOWN);
            m_subMenu.key_left.text = ControlsMenu.getGamepadInputName(this.playNum,_loc1_._LEFT);
            m_subMenu.key_right.text = ControlsMenu.getGamepadInputName(this.playNum,_loc1_._RIGHT);
            m_subMenu.key_jump.text = ControlsMenu.getGamepadInputName(this.playNum,_loc1_._JUMP);
            m_subMenu.key_a.text = ControlsMenu.getGamepadInputName(this.playNum,_loc1_._BUTTON2);
            m_subMenu.key_b.text = ControlsMenu.getGamepadInputName(this.playNum,_loc1_._BUTTON1);
            m_subMenu.key_grab.text = ControlsMenu.getGamepadInputName(this.playNum,_loc1_._GRAB);
            m_subMenu.key_shield.text = ControlsMenu.getGamepadInputName(this.playNum,_loc1_._SHIELD);
            m_subMenu.key_taunt.text = ControlsMenu.getGamepadInputName(this.playNum,_loc1_._TAUNT);
            m_subMenu.key_pause.text = ControlsMenu.getGamepadInputName(this.playNum,_loc1_._START);
            m_subMenu.key_jump2.text = ControlsMenu.getGamepadInputName(this.playNum,_loc1_._JUMP2);
            m_subMenu.key_cup.text = ControlsMenu.getGamepadInputName(this.playNum,_loc1_._C_UP);
            m_subMenu.key_cdown.text = ControlsMenu.getGamepadInputName(this.playNum,_loc1_._C_DOWN);
            m_subMenu.key_cleft.text = ControlsMenu.getGamepadInputName(this.playNum,_loc1_._C_LEFT);
            m_subMenu.key_cright.text = ControlsMenu.getGamepadInputName(this.playNum,_loc1_._C_RIGHT);
            m_subMenu.key_dash.text = ControlsMenu.getGamepadInputName(this.playNum,_loc1_._DASH);
            m_subMenu.key_shield2.text = ControlsMenu.getGamepadInputName(this.playNum,_loc1_._SHIELD2);
            m_subMenu.controlStickConfig.visible = true;
            m_subMenu.cStickConfig.visible = true;
            if(isNaN(this.controlStickDashZone))
            {
               trace(this.controlStickDashZone);
            }
            m_subMenu.controlStickConfig.radiusTxt.text = this.controlStickDashZone;
            m_subMenu.controlStickConfig.deadZoneTxt.text = this.controlStickDeadZone;
            m_subMenu.cStickConfig.radiusTxt.text = this.cStickDashZone;
            m_subMenu.cStickConfig.deadZoneTxt.text = this.cStickDeadZone;
            _loc1_.GamepadInstance.ControlsMap["TAP_JUMP"] = _loc1_._TAP_JUMP;
            _loc1_.GamepadInstance.ControlsMap["AUTO_DASH"] = _loc1_._AUTO_DASH;
            _loc1_.GamepadInstance.ControlsMap["DT_DASH"] = _loc1_._DT_DASH;
            this.m_rumbleCheckBox.visible = true;
            this.m_rumbleTxt.visible = true;
         }
         else
         {
            m_subMenu.key_up.text = Utils.KEY_ARR_SHORT[_loc1_.KeyboardInstance.ControlsMap[_loc1_._UP]];
            m_subMenu.key_down.text = Utils.KEY_ARR_SHORT[_loc1_.KeyboardInstance.ControlsMap[_loc1_._DOWN]];
            m_subMenu.key_left.text = Utils.KEY_ARR_SHORT[_loc1_.KeyboardInstance.ControlsMap[_loc1_._LEFT]];
            m_subMenu.key_right.text = Utils.KEY_ARR_SHORT[_loc1_.KeyboardInstance.ControlsMap[_loc1_._RIGHT]];
            m_subMenu.key_jump.text = Utils.KEY_ARR_SHORT[_loc1_.KeyboardInstance.ControlsMap[_loc1_._JUMP]];
            m_subMenu.key_a.text = Utils.KEY_ARR_SHORT[_loc1_.KeyboardInstance.ControlsMap[_loc1_._BUTTON2]];
            m_subMenu.key_b.text = Utils.KEY_ARR_SHORT[_loc1_.KeyboardInstance.ControlsMap[_loc1_._BUTTON1]];
            m_subMenu.key_grab.text = Utils.KEY_ARR_SHORT[_loc1_.KeyboardInstance.ControlsMap[_loc1_._GRAB]];
            m_subMenu.key_shield.text = Utils.KEY_ARR_SHORT[_loc1_.KeyboardInstance.ControlsMap[_loc1_._SHIELD]];
            m_subMenu.key_taunt.text = Utils.KEY_ARR_SHORT[_loc1_.KeyboardInstance.ControlsMap[_loc1_._TAUNT]];
            m_subMenu.key_pause.text = Utils.KEY_ARR_SHORT[_loc1_.KeyboardInstance.ControlsMap[_loc1_._START]];
            m_subMenu.key_jump2.text = Utils.KEY_ARR_SHORT[_loc1_.KeyboardInstance.ControlsMap[_loc1_._JUMP2]];
            m_subMenu.key_cup.text = Utils.KEY_ARR_SHORT[_loc1_.KeyboardInstance.ControlsMap[_loc1_._C_UP]];
            m_subMenu.key_cdown.text = Utils.KEY_ARR_SHORT[_loc1_.KeyboardInstance.ControlsMap[_loc1_._C_DOWN]];
            m_subMenu.key_cleft.text = Utils.KEY_ARR_SHORT[_loc1_.KeyboardInstance.ControlsMap[_loc1_._C_LEFT]];
            m_subMenu.key_cright.text = Utils.KEY_ARR_SHORT[_loc1_.KeyboardInstance.ControlsMap[_loc1_._C_RIGHT]];
            m_subMenu.key_dash.text = Utils.KEY_ARR_SHORT[_loc1_.KeyboardInstance.ControlsMap[_loc1_._DASH]];
            m_subMenu.key_shield2.text = Utils.KEY_ARR_SHORT[_loc1_.KeyboardInstance.ControlsMap[_loc1_._SHIELD2]];
            m_subMenu.controlStickConfig.visible = false;
            m_subMenu.cStickConfig.visible = false;
            this.m_rumbleCheckBox.visible = false;
            this.m_rumbleTxt.visible = false;
         }
         this.m_tapJumpCheckBox.selected = _loc1_._TAP_JUMP == 1;
         this.m_autoDashCheckBox.selected = _loc1_._AUTO_DASH == 1;
         this.m_dtDashCheckBox.selected = _loc1_._DT_DASH == 1;
         this.RumbleCheckBox.selected = SaveData.getRumbleEnabled(this.playNum);
         if(this.m_autoDashCheckBox.selected)
         {
            this.m_dtDashCheckBox.selected = false;
            this.m_dtDashCheckBox.enabled = false;
            this.m_dtDashTxt.alpha = 0.5;
            _loc1_._DT_DASH = 0;
         }
         else
         {
            this.m_dtDashTxt.alpha = 1;
            this.m_dtDashCheckBox.enabled = true;
         }
         m_subMenu.t17.text = this.m_autoDashCheckBox.selected ? "WALK" : "DASH";
         this.updateDefaultData();
         this.updateNameData();
         this.redrawGamepadList();
      }
      
      private function gamepad_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         removeSelf();
         MenuController.gamepadMenu.show();
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
         }
         this.updateControls();
         SaveData.saveGame();
         SoundQueue.instance.playSoundEffect("menu_back");
         if(Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.isOnscreen()))
         {
            removeSelf();
         }
         else if(Boolean(MenuController.groupMenu) && Boolean(MenuController.groupMenu.isOnscreen()))
         {
            removeSelf();
         }
         else if(Boolean(MenuController.rulesMenu) && Boolean(MenuController.rulesMenu.isOnscreen()))
         {
            removeSelf();
         }
         else
         {
            removeSelf();
            MenuController.optionsMenu.show();
         }
      }
      
      private function back_ROLL_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function pControls_ROLL_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function p1Controls_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         var _loc2_:int = this.playNum;
         this.playNum = 1;
         this.updateGamepadListeners(_loc2_,this.playNum);
         this.setPlayer(this.playNum);
         this.extractDeadAndDashZones();
         this.updateCurrPlayer();
         this.updateControls();
      }
      
      private function p2Controls_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         var _loc2_:int = this.playNum;
         this.playNum = 2;
         this.updateGamepadListeners(_loc2_,this.playNum);
         this.setPlayer(this.playNum);
         this.extractDeadAndDashZones();
         this.updateCurrPlayer();
         this.updateControls();
      }
      
      private function p3Controls_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         var _loc2_:int = this.playNum;
         this.playNum = 3;
         this.updateGamepadListeners(_loc2_,this.playNum);
         this.setPlayer(this.playNum);
         this.updateCurrPlayer();
         this.extractDeadAndDashZones();
         this.updateControls();
      }
      
      private function extractDeadAndDashZones() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Gamepad = SaveData.Controllers[this.playNum - 1].GamepadInstance;
         if(_loc2_)
         {
            for(_loc1_ in _loc2_.ControlState)
            {
               if(_loc2_.ControlState[_loc1_].inputs.indexOf("UP") >= 0 || _loc2_.ControlState[_loc1_].inputs.indexOf("DOWN") >= 0 || _loc2_.ControlState[_loc1_].inputs.indexOf("LEFT") >= 0 || _loc2_.ControlState[_loc1_].inputs.indexOf("RIGHT") >= 0)
               {
                  this.controlStickDashZone = _loc2_.ControlState[_loc1_].dashZone * 100;
                  this.controlStickDeadZone = _loc2_.ControlState[_loc1_].deadZone * 100;
                  break;
               }
            }
            for(_loc1_ in _loc2_.ControlState)
            {
               if(_loc2_.ControlState[_loc1_].inputs.indexOf("C_UP") >= 0 || _loc2_.ControlState[_loc1_].inputs.indexOf("C_DOWN") >= 0 || _loc2_.ControlState[_loc1_].inputs.indexOf("C_LEFT") >= 0 || _loc2_.ControlState[_loc1_].inputs.indexOf("C_RIGHT") >= 0)
               {
                  this.cStickDashZone = _loc2_.ControlState[_loc1_].dashZone * 100;
                  this.cStickDeadZone = _loc2_.ControlState[_loc1_].deadZone * 100;
                  break;
               }
            }
         }
      }
      
      private function p4Controls_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         var _loc2_:int = this.playNum;
         this.playNum = 4;
         this.updateGamepadListeners(_loc2_,this.playNum);
         this.setPlayer(this.playNum);
         this.extractDeadAndDashZones();
         this.updateCurrPlayer();
         this.updateControls();
      }
      
      private function setPlayer(param1:int) : void
      {
         var _loc2_:ControlsButton = null;
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < this.controlsButtons.length)
         {
            _loc2_ = this.controlsButtons[_loc3_];
            _loc2_.setPlayer(param1);
            _loc3_++;
         }
      }
      
      private function updateCurrPlayer() : void
      {
         m_subMenu.p1Controls_btn.bnshadow.visible = this.playNum != 1;
         m_subMenu.p2Controls_btn.bnshadow.visible = this.playNum != 2;
         m_subMenu.p3Controls_btn.bnshadow.visible = this.playNum != 3;
         m_subMenu.p4Controls_btn.bnshadow.visible = this.playNum != 4;
      }
      
      private function updateDefaultData() : void
      {
         var _loc1_:Gamepad = null;
         var _loc2_:PlayerSetting = null;
         var _loc3_:int = 1;
         while(_loc3_ <= SaveData.Controllers.length)
         {
            _loc1_ = SaveData.Controllers[_loc3_ - 1].GamepadInstance;
            if(Boolean(_loc1_ && MenuController.CurrentCharacterSelectMenu && MenuController.CurrentCharacterSelectMenu.GameObj && _loc3_ - 1 < MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings.length) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[_loc3_ - 1].human) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[_loc3_ - 1].name))
            {
               _loc2_ = MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[_loc3_ - 1];
               SaveData.Gamepads[_loc1_.Name].names[_loc2_.name].TAP_JUMP = SaveData.Controllers[_loc3_ - 1]._TAP_JUMP;
               SaveData.Gamepads[_loc1_.Name].names[_loc2_.name].DT_DASH = SaveData.Controllers[_loc3_ - 1]._DT_DASH;
               SaveData.Gamepads[_loc1_.Name].names[_loc2_.name].AUTO_DASH = SaveData.Controllers[_loc3_ - 1]._AUTO_DASH;
               _loc1_.importControls(SaveData.Gamepads[_loc1_.Name].names[_loc2_.name]);
            }
            else
            {
               SaveData.ControlSettings["player" + _loc3_] = SaveData.Controllers[_loc3_ - 1].getControls();
            }
            _loc3_++;
         }
      }
      
      private function updateNameData() : void
      {
         var _loc1_:Object = null;
      }
      
      private function tapJump_CHANGE(param1:Event) : void
      {
         SaveData.Controllers[this.playNum - 1]._TAP_JUMP = this.m_tapJumpCheckBox.selected ? 1 : 0;
         Main.fixFocus();
      }
      
      private function autoDash_CHANGE(param1:Event) : void
      {
         SaveData.Controllers[this.playNum - 1]._AUTO_DASH = this.m_autoDashCheckBox.selected ? 1 : 0;
         if(this.m_autoDashCheckBox.selected)
         {
            this.m_dtDashCheckBox.selected = false;
            this.m_dtDashCheckBox.enabled = false;
            this.m_dtDashTxt.alpha = 0.5;
            SaveData.Controllers[this.playNum - 1]._DT_DASH = 0;
         }
         else
         {
            this.m_dtDashTxt.alpha = 1;
            this.m_dtDashCheckBox.enabled = true;
         }
         m_subMenu.t17.text = this.m_autoDashCheckBox.selected ? "WALK" : "DASH";
         Main.fixFocus();
      }
      
      private function dtDash_CHANGE(param1:Event) : void
      {
         SaveData.Controllers[this.playNum - 1]._DT_DASH = this.m_dtDashCheckBox.selected ? 1 : 0;
         Main.fixFocus();
      }
      
      private function rumble_CHANGE(param1:Event) : void
      {
         var _loc3_:Gamepad = null;
         var _loc2_:Boolean = Boolean(this.m_rumbleCheckBox.selected);
         SaveData.setRumbleEnabled(_loc2_,this.playNum);
         SaveData.saveGame();
         if(_loc2_)
         {
            _loc3_ = SaveData.Controllers[this.playNum - 1].GamepadInstance;
            if(_loc3_)
            {
               _loc3_.setRumble(0.5,0.5,80);
            }
         }
         Main.fixFocus();
      }
      
      private function home_CLICK(param1:MouseEvent) : void
      {
         if(MultiplayerManager.Connected)
         {
            MultiplayerManager.disconnect();
         }
         SoundQueue.instance.playSoundEffect("menu_back");
         SoundQueue.instance.stopMusic();
         if(MenuController.CurrentCharacterSelectMenu)
         {
            MenuController.CurrentCharacterSelectMenu.resetScreen();
         }
         GameController.currentGame = null;
         MenuController.disposeAllMenus(true);
         MenuController.titleMenu.show();
      }
      
      private function updateGamepadListeners(param1:int, param2:int) : void
      {
         var _loc3_:Gamepad = null;
         var _loc4_:Gamepad = null;
         if(param1 >= 1 && param1 <= 4)
         {
            _loc3_ = SaveData.Controllers[param1 - 1].GamepadInstance;
            if(_loc3_)
            {
               _loc3_.removeEventListener(GamepadEvent.AXIS_CHANGED,this.onAxisChanged);
               _loc3_.removeEventListener(GamepadEvent.BUTTON_DOWN,this.onGamepadButtonDown);
            }
         }
         if(param2 >= 1 && param2 <= 4)
         {
            _loc4_ = SaveData.Controllers[param2 - 1].GamepadInstance;
            if(_loc4_)
            {
               _loc4_.addEventListener(GamepadEvent.AXIS_CHANGED,this.onAxisChanged);
               _loc4_.addEventListener(GamepadEvent.BUTTON_DOWN,this.onGamepadButtonDown);
               m_subMenu.controlStickConfig.visible = true;
               m_subMenu.cStickConfig.visible = true;
               this.m_rumbleCheckBox.visible = true;
               this.m_rumbleTxt.visible = true;
               this.m_rumbleCheckBox.selected = SaveData.getRumbleEnabled(param2);
            }
            else
            {
               m_subMenu.controlStickConfig.visible = false;
               m_subMenu.cStickConfig.visible = false;
               this.m_rumbleCheckBox.visible = false;
               this.m_rumbleTxt.visible = false;
            }
         }
      }
      
      private function onGamepadButtonDown(param1:GamepadEvent) : void
      {
         var onRumbleToggleClick:*;
         var enabled:Boolean = false;
         var e:GamepadEvent = param1;
         var state:Object = e.controlState;
         if(Boolean(state) && Boolean(state.inputs) && state.inputs.indexOf("TAUNT") >= 0)
         {
            enabled = !SaveData.getRumbleEnabled(this.playNum);
            SaveData.setRumbleEnabled(enabled,this.playNum);
            SaveData.saveGame();
            this.RumbleCheckBox.selected = enabled;
            MultiplayerManager.makeNotifier();
            if(enabled)
            {
               onRumbleToggleClick = function(param1:MouseEvent):void
               {
                  SaveData.rumbleEnabled = !SaveData.rumbleEnabled;
                  this.m_rumbleCheckBox.selected = SaveData.getRumbleEnabled();
                  SoundQueue.instance.playSoundEffect("menu_select");
               };
               MultiplayerManager.notify("Controller Rumble for Player " + this.playNum + ": ON");
               if(e.gamepad)
               {
                  trace("[RUMBLE DEBUG] TAUNT pressed - About to rumble gamepad:");
                  trace("  -> e.gamepad.Name: " + e.gamepad.Name);
                  trace("  -> e.gamepad.Port: " + e.gamepad.Port);
                  trace("  -> e.gamepad.XInputIndex: " + e.gamepad.XInputIndex);
                  trace("  -> Current player tab: " + this.playNum);
                  e.gamepad.setRumble(0.5,0.5,80);
               }
            }
            else
            {
               MultiplayerManager.notify("Controller Rumble for Player " + this.playNum + ": OFF");
            }
            SoundQueue.instance.playSoundEffect("menu_movecursor");
         }
      }
   }
}


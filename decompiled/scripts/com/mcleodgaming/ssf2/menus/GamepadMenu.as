package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.events.*;
   import com.mcleodgaming.ssf2.input.*;
   import com.mcleodgaming.ssf2.util.*;
   import fl.controls.*;
   import fl.events.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class GamepadMenu extends Menu
   {
      
      private var selectHand:SelectHand;
      
      private var m_userDropdown:ComboBox;
      
      private var m_gamepadDropdown:ComboBox;
      
      private var m_selectedDropdown:ComboBox;
      
      private var m_deadZoneDropdown:ComboBox;
      
      private var m_deadZoneSlider:Slider;
      
      private var m_dashZoneSlider:Slider;
      
      private var m_deadZoneText:TextField;
      
      private var m_dashZoneText:TextField;
      
      private var m_axisValueText:TextField;
      
      private var m_currentDeadZoneID:String;
      
      private var m_activeGamepads:Vector.<Gamepad>;
      
      private var m_buttonDropdowns:Vector.<MovieClip>;
      
      private var m_inputs:Array;
      
      private var m_currentGamepad:String;
      
      private var m_currentPortType:String;
      
      private var m_currentPortName:String;
      
      public function GamepadMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_gamepad");
         m_backgroundID = "space";
         m_container.addChild(m_subMenu);
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         this.m_userDropdown = m_subMenu.userDropdown;
         this.m_gamepadDropdown = m_subMenu.gamepadDropdown;
         this.m_deadZoneDropdown = m_subMenu.deadZoneDropdown;
         this.m_deadZoneSlider = m_subMenu.deadZoneSlider;
         this.m_dashZoneSlider = m_subMenu.dashZoneSlider;
         this.m_deadZoneText = m_subMenu.deadZoneText;
         this.m_dashZoneText = m_subMenu.dashZoneText;
         this.m_axisValueText = m_subMenu.axisValueText;
         this.m_axisValueText.text = "0";
         this.m_currentDeadZoneID = null;
         var _loc1_:Vector.<HandButton> = new Vector.<HandButton>();
         this.m_activeGamepads = new Vector.<Gamepad>();
         this.m_buttonDropdowns = new Vector.<MovieClip>();
         this.m_currentGamepad = null;
         this.m_currentPortType = null;
         this.m_currentPortName = null;
         this.m_inputs = [];
         this.m_inputs.push({
            "label":"Up",
            "id":"UP"
         });
         this.m_inputs.push({
            "label":"Down",
            "id":"DOWN"
         });
         this.m_inputs.push({
            "label":"Left",
            "id":"LEFT"
         });
         this.m_inputs.push({
            "label":"Right",
            "id":"RIGHT"
         });
         this.m_inputs.push({
            "label":"Jump 1",
            "id":"JUMP"
         });
         this.m_inputs.push({
            "label":"Jump 2",
            "id":"JUMP2"
         });
         this.m_inputs.push({
            "label":"A Attack",
            "id":"BUTTON2"
         });
         this.m_inputs.push({
            "label":"B Attack",
            "id":"BUTTON1"
         });
         this.m_inputs.push({
            "label":"Grab",
            "id":"GRAB"
         });
         this.m_inputs.push({
            "label":"Shield 1",
            "id":"SHIELD"
         });
         this.m_inputs.push({
            "label":"Shield 2",
            "id":"SHIELD2"
         });
         this.m_inputs.push({
            "label":"Taunt",
            "id":"TAUNT"
         });
         this.m_inputs.push({
            "label":"C-Stick Up",
            "id":"C_UP"
         });
         this.m_inputs.push({
            "label":"C-Stick Down",
            "id":"C_DOWN"
         });
         this.m_inputs.push({
            "label":"C-Stick Left",
            "id":"C_LEFT"
         });
         this.m_inputs.push({
            "label":"C-Stick Right",
            "id":"C_RIGHT"
         });
         this.m_inputs.push({
            "label":"Pause",
            "id":"START"
         });
         this.m_inputs.push({
            "label":"Dash Button",
            "id":"DASH"
         });
      }
      
      override public function makeEvents() : void
      {
         var _loc1_:int = 0;
         var _loc2_:PlayerSetting = null;
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         resetAllButtons();
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.MOUSE_OVER,this.back_ROLL_OVER);
         m_subMenu.bg_top.home_btn.addEventListener(MouseEvent.CLICK,this.home_CLICK);
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,manageMenuMappings);
         this.m_gamepadDropdown.removeAll();
         var _loc3_:Vector.<Gamepad> = GamepadManager.getGamepads();
         this.m_gamepadDropdown.addItem({
            "label":"Choose gamepad",
            "gamepad":null
         });
         this.m_gamepadDropdown.selectedIndex = 0;
         var _loc4_:Object = {};
         _loc1_ = 0;
         while(_loc1_ < _loc3_.length)
         {
            if(!_loc4_[_loc3_[_loc1_].Name])
            {
               _loc4_[_loc3_[_loc1_].Name] = true;
               this.m_gamepadDropdown.addItem({
                  "label":_loc3_[_loc1_].Name,
                  "gamepad":_loc3_[_loc1_]
               });
               if(!SaveData.Gamepads[_loc3_[_loc1_].Name])
               {
                  SaveData.Gamepads[_loc3_[_loc1_].Name] = {
                     "names":{},
                     "ports":{}
                  };
               }
            }
            _loc1_++;
         }
         this.m_gamepadDropdown.addEventListener(Event.CHANGE,this.gamepadChanged);
         this.m_deadZoneDropdown.addEventListener(Event.CHANGE,this.deadZoneChanged);
         this.m_deadZoneText.addEventListener(Event.CHANGE,this.deadZoneTextChanged);
         this.m_dashZoneText.addEventListener(Event.CHANGE,this.dashZoneTextChanged);
         this.m_deadZoneSlider.addEventListener(SliderEvent.CHANGE,this.deadZoneSliderChanged);
         this.m_dashZoneSlider.addEventListener(SliderEvent.CHANGE,this.dashZoneSliderChanged);
         this.m_userDropdown.removeAll();
         _loc1_ = 0;
         while(_loc1_ < Main.MAXPLAYERS)
         {
            this.m_userDropdown.addItem({
               "label":"Port " + (_loc1_ + 1),
               "port":_loc1_ + 1
            });
            _loc1_++;
         }
         if(Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj))
         {
            _loc2_ = MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[MenuController.controlsMenu.playNum - 1];
            if(_loc2_)
            {
               if(_loc2_.human && Boolean(_loc2_.name))
               {
                  this.m_userDropdown.addItem({
                     "label":_loc2_.name,
                     "playerSetting":_loc2_
                  });
                  this.m_userDropdown.selectedIndex = this.m_userDropdown.length - 1;
               }
               else
               {
                  this.m_userDropdown.selectedIndex = MenuController.controlsMenu.playNum - 1;
               }
            }
         }
         this.m_userDropdown.addEventListener(Event.CHANGE,this.userChanged);
         this.gamepadChanged();
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.back_ROLL_OVER);
         m_subMenu.bg_top.home_btn.removeEventListener(MouseEvent.CLICK,this.home_CLICK);
         this.m_gamepadDropdown.removeEventListener(Event.CHANGE,this.gamepadChanged);
         this.m_deadZoneText.removeEventListener(Event.CHANGE,this.deadZoneTextChanged);
         this.m_dashZoneText.removeEventListener(Event.CHANGE,this.dashZoneTextChanged);
         this.m_deadZoneSlider.removeEventListener(SliderEvent.CHANGE,this.deadZoneSliderChanged);
         this.m_dashZoneSlider.removeEventListener(SliderEvent.CHANGE,this.dashZoneSliderChanged);
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,manageMenuMappings);
         MenuController.controlsMenu.inputTypeChanged(null);
      }
      
      private function getInputData(param1:String) : Object
      {
         SaveData.Gamepads[this.m_currentGamepad][this.m_currentPortType][this.m_currentPortName][param1] = SaveData.Gamepads[this.m_currentGamepad][this.m_currentPortType][this.m_currentPortName][param1] || {
            "inputs":[],
            "inputsInverse":[],
            "deadZone":Gamepad.DEADZONE_DEFAULT,
            "dashZone":Gamepad.DASHZONE_DEFAULT
         };
         return SaveData.Gamepads[this.m_currentGamepad][this.m_currentPortType][this.m_currentPortName][param1];
      }
      
      private function setInput(param1:String, param2:String, param3:Boolean) : void
      {
         this.unsetInput(param1,param2);
         var _loc4_:Object = this.getInputData(param1);
         if(param3)
         {
            _loc4_.inputsInverse.push(param2);
         }
         else
         {
            _loc4_.inputs.push(param2);
         }
         this.updateNamedPlayers();
      }
      
      private function unsetInput(param1:String, param2:String) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Object = this.getInputData(param1);
         _loc3_ = int(_loc4_.inputs.indexOf(param2));
         if(_loc3_ >= 0)
         {
            _loc4_.inputs.splice(_loc3_,1);
         }
         _loc3_ = int(_loc4_.inputsInverse.indexOf(param2));
         if(_loc3_ >= 0)
         {
            _loc4_.inputsInverse.splice(_loc3_,1);
         }
         this.updateNamedPlayers();
      }
      
      private function updateNamedPlayers() : void
      {
         var _loc1_:Game = null;
         var _loc2_:int = 0;
         if(Boolean(this.m_currentPortType === "names") && Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj))
         {
            _loc1_ = MenuController.CurrentCharacterSelectMenu.GameObj;
            _loc2_ = 0;
            while(_loc2_ < _loc1_.PlayerSettings.length)
            {
               if(_loc1_.PlayerSettings[_loc2_].name === this.m_currentPortName)
               {
                  SaveData.reimportNamedPlayerControls(_loc2_ + 1,_loc1_.PlayerSettings[_loc2_].name);
               }
               _loc2_++;
            }
         }
      }
      
      private function gamepadChanged(param1:Event = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc7_:int = 0;
         while(this.m_buttonDropdowns.length > 0)
         {
            this.m_buttonDropdowns[0].removeEventListener(Event.CHANGE,this.onInputDropdownChanged);
            this.m_buttonDropdowns[0].parent.removeChild(this.m_buttonDropdowns[0]);
            this.m_buttonDropdowns.splice(0,1);
         }
         while(this.m_deadZoneDropdown.length > 0)
         {
            this.m_deadZoneDropdown.removeAll();
         }
         if(!this.m_gamepadDropdown.selectedItem.gamepad)
         {
            return;
         }
         this.m_currentGamepad = this.m_gamepadDropdown.selectedItem.gamepad.Name;
         this.m_currentPortType = Boolean(this.m_userDropdown.selectedItem.playerSetting) && Boolean(this.m_userDropdown.selectedItem.playerSetting.name) ? "names" : "ports";
         this.m_currentPortName = this.m_currentPortType === "names" ? this.m_userDropdown.selectedItem.playerSetting.name : "port" + this.m_userDropdown.selectedItem.port;
         SaveData.Gamepads[this.m_currentGamepad] = SaveData.Gamepads[this.m_currentGamepad] || {
            "names":{},
            "ports":{}
         };
         SaveData.Gamepads[this.m_currentGamepad][this.m_currentPortType][this.m_currentPortName] = SaveData.Gamepads[this.m_currentGamepad][this.m_currentPortType][this.m_currentPortName] || {};
         _loc2_ = 0;
         while(_loc2_ < this.m_activeGamepads.length)
         {
            this.m_activeGamepads[_loc2_].removeEventListener(GamepadEvent.AXIS_CHANGED,this.onDeadZoneAxisChanged);
            _loc2_++;
         }
         this.m_activeGamepads.splice(0,this.m_activeGamepads.length);
         var _loc4_:Vector.<Gamepad> = GamepadManager.getGamepads();
         _loc2_ = 0;
         while(_loc2_ < _loc4_.length)
         {
            if(_loc4_[_loc2_].Name === this.m_gamepadDropdown.selectedItem.gamepad.Name)
            {
               this.m_activeGamepads.push(_loc4_[_loc2_]);
            }
            _loc2_++;
         }
         this.m_deadZoneDropdown.addItem({"label":""});
         _loc2_ = 0;
         while(_loc2_ < this.m_activeGamepads[0].ControlsList.length)
         {
            if(this.m_activeGamepads[0].ControlsList[_loc2_].type === "axis")
            {
               this.m_deadZoneDropdown.addItem({
                  "label":this.m_activeGamepads[0].ControlsList[_loc2_].id.replace(/_/g," "),
                  "id":this.m_activeGamepads[0].ControlsList[_loc2_].id
               });
            }
            _loc2_++;
         }
         this.m_deadZoneSlider.value = 0;
         this.m_deadZoneText.text = "";
         this.m_dashZoneText.text = "";
         var _loc5_:int = -300;
         var _loc6_:int = -70;
         while(_loc7_ < this.m_inputs.length)
         {
            _loc3_ = ResourceManager.getLibraryMC("ControlInputSelection");
            _loc3_.id = this.m_inputs[_loc7_].id;
            _loc3_.actionText.text = this.m_inputs[_loc7_].label;
            _loc3_.buttonDropdown.addItem({
               "label":"-",
               "controls":null,
               "previous":null
            });
            _loc2_ = 0;
            while(_loc2_ < this.m_activeGamepads[0].ControlsList.length)
            {
               if(this.m_activeGamepads[0].ControlsList[_loc2_].type === "axis")
               {
                  _loc3_.buttonDropdown.addItem({
                     "label":this.m_activeGamepads[0].ControlsList[_loc2_].id.replace(/_/g," ") + "-",
                     "controls":this.m_activeGamepads[0].ControlsList[_loc2_],
                     "input":this.m_inputs[_loc7_],
                     "inverse":true
                  });
                  if(this.getInputData(this.m_activeGamepads[0].ControlsList[_loc2_].id).inputsInverse.indexOf(this.m_inputs[_loc7_].id) >= 0)
                  {
                     _loc3_.buttonDropdown.selectedIndex = _loc3_.buttonDropdown.length - 1;
                  }
                  _loc3_.buttonDropdown.addItem({
                     "label":this.m_activeGamepads[0].ControlsList[_loc2_].id.replace(/_/g," ") + "+",
                     "controls":this.m_activeGamepads[0].ControlsList[_loc2_],
                     "input":this.m_inputs[_loc7_],
                     "inverse":false
                  });
                  if(this.getInputData(this.m_activeGamepads[0].ControlsList[_loc2_].id).inputs.indexOf(this.m_inputs[_loc7_].id) >= 0)
                  {
                     _loc3_.buttonDropdown.selectedIndex = _loc3_.buttonDropdown.length - 1;
                  }
               }
               else
               {
                  _loc3_.buttonDropdown.addItem({
                     "label":this.m_activeGamepads[0].ControlsList[_loc2_].id,
                     "controls":this.m_activeGamepads[0].ControlsList[_loc2_],
                     "input":this.m_inputs[_loc7_],
                     "inverse":false
                  });
                  if(this.getInputData(this.m_activeGamepads[0].ControlsList[_loc2_].id).inputs.indexOf(this.m_inputs[_loc7_].id) >= 0)
                  {
                     _loc3_.buttonDropdown.selectedIndex = _loc3_.buttonDropdown.length - 1;
                  }
               }
               if(_loc3_.buttonDropdown.selectedIndex >= 0)
               {
                  _loc3_.buttonDropdown.getItemAt(0).previous = _loc3_.buttonDropdown.selectedItem;
               }
               _loc2_++;
            }
            _loc3_.buttonDropdown.addEventListener(Event.CHANGE,this.onInputDropdownChanged);
            _loc3_.buttonDropdown.addEventListener(Event.OPEN,this.openDropdown);
            _loc3_.buttonDropdown.addEventListener(Event.CLOSE,this.closeDropdown);
            _loc3_.x = _loc5_;
            _loc3_.y = _loc6_;
            _loc6_ += 30;
            if(_loc6_ > 130)
            {
               _loc5_ += 200;
               _loc6_ = -70;
            }
            m_subMenu.addChild(_loc3_);
            this.m_buttonDropdowns.push(_loc3_);
            _loc7_++;
         }
      }
      
      private function onInputDropdownChanged(param1:Event) : void
      {
         var _loc6_:Object = null;
         var _loc2_:Object = param1.currentTarget.selectedItem.controls;
         var _loc3_:Object = param1.currentTarget.selectedItem.input;
         var _loc4_:Boolean = Boolean(param1.currentTarget.selectedItem.inverse);
         var _loc5_:Object = param1.currentTarget.getItemAt(0).previous;
         if(_loc2_)
         {
            this.setInput(_loc2_.id,_loc3_.id,_loc4_);
            _loc6_ = param1.currentTarget.selectedItem;
         }
         if(_loc5_)
         {
            this.unsetInput(_loc5_.controls.id,_loc5_.input.id);
         }
         param1.currentTarget.getItemAt(0).previous = _loc6_;
      }
      
      private function openDropdown(param1:Event) : void
      {
         var _loc2_:int = 0;
         this.m_selectedDropdown = param1.currentTarget as ComboBox;
         while(_loc2_ < this.m_activeGamepads.length)
         {
            this.m_activeGamepads[_loc2_].addEventListener(GamepadEvent.BUTTON_DOWN,this.onDropdownButtonPressed);
            this.m_activeGamepads[_loc2_].addEventListener(GamepadEvent.AXIS_CHANGED,this.onDropdownAxisChanged);
            _loc2_++;
         }
      }
      
      private function closeDropdown(param1:Event) : void
      {
         var _loc2_:int = 0;
         this.m_selectedDropdown = null;
         while(_loc2_ < this.m_activeGamepads.length)
         {
            this.m_activeGamepads[_loc2_].removeEventListener(GamepadEvent.BUTTON_DOWN,this.onDropdownButtonPressed);
            this.m_activeGamepads[_loc2_].removeEventListener(GamepadEvent.AXIS_CHANGED,this.onDropdownAxisChanged);
            _loc2_++;
         }
      }
      
      private function onDropdownButtonPressed(param1:GamepadEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.m_selectedDropdown.length)
         {
            _loc2_ = this.m_selectedDropdown.getItemAt(_loc3_);
            if(Boolean(_loc2_.controls) && _loc2_.controls.id === param1.controlState.id)
            {
               this.m_selectedDropdown.selectedIndex = _loc3_;
               this.m_selectedDropdown.dispatchEvent(new Event(Event.CHANGE));
               break;
            }
            _loc3_++;
         }
         this.m_selectedDropdown.close();
      }
      
      private function onDropdownAxisChanged(param1:GamepadEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.m_selectedDropdown.length)
         {
            _loc2_ = this.m_selectedDropdown.getItemAt(_loc3_);
            if(Boolean(_loc2_.controls) && Boolean(_loc2_.controls.id === param1.controlState.id) && (Boolean(param1.controlState.value < 0 && _loc2_.inverse) || Boolean(param1.controlState.value > 0 && !_loc2_.inverse)))
            {
               this.m_selectedDropdown.selectedIndex = _loc3_;
               this.m_selectedDropdown.dispatchEvent(new Event(Event.CHANGE));
               break;
            }
            _loc3_++;
         }
         this.m_selectedDropdown.close();
      }
      
      private function deadZoneChanged(param1:Event) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.m_activeGamepads.length)
         {
            this.m_activeGamepads[_loc2_].removeEventListener(GamepadEvent.AXIS_CHANGED,this.onDeadZoneAxisChanged);
            _loc2_++;
         }
         if(!param1.currentTarget.selectedItem.id)
         {
            return;
         }
         this.m_currentDeadZoneID = param1.currentTarget.selectedItem.id;
         _loc2_ = 0;
         while(_loc2_ < this.m_activeGamepads.length)
         {
            this.m_activeGamepads[_loc2_].addEventListener(GamepadEvent.AXIS_CHANGED,this.onDeadZoneAxisChanged);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.m_activeGamepads[0].ControlsList.length)
         {
            if(this.m_activeGamepads[0].ControlsList[_loc2_].id === this.m_currentDeadZoneID)
            {
               this.m_deadZoneText.text = "" + this.m_activeGamepads[0].ControlsList[_loc2_].deadZone;
               this.m_deadZoneSlider.value = this.m_activeGamepads[0].ControlsList[_loc2_].deadZone * 100;
               this.m_dashZoneText.text = "" + this.m_activeGamepads[0].ControlsList[_loc2_].dashZone;
               this.m_dashZoneSlider.value = this.m_activeGamepads[0].ControlsList[_loc2_].dashZone * 100;
               break;
            }
            _loc2_++;
         }
      }
      
      private function deadZoneTextChanged(param1:Event) : void
      {
         var _loc2_:Number = Number((param1.currentTarget as TextField).text);
         if(!isNaN(_loc2_))
         {
            this.setDeadZoneValue(_loc2_);
         }
      }
      
      private function dashZoneTextChanged(param1:Event) : void
      {
         var _loc2_:Number = Number((param1.currentTarget as TextField).text);
         if(!isNaN(_loc2_))
         {
            this.setDashZoneValue(_loc2_);
         }
      }
      
      private function deadZoneSliderChanged(param1:Event) : void
      {
         var _loc2_:Number = Number((param1.currentTarget as Slider).value);
         this.setDeadZoneValue(Math.round(_loc2_) / 100);
      }
      
      private function dashZoneSliderChanged(param1:Event) : void
      {
         var _loc2_:Number = Number((param1.currentTarget as Slider).value);
         this.setDashZoneValue(Math.round(_loc2_) / 100);
      }
      
      private function setDeadZoneValue(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.m_currentDeadZoneID)
         {
            this.m_deadZoneText.text = "" + param1;
            this.m_deadZoneSlider.value = param1 * 100;
            SaveData.Gamepads[this.m_currentGamepad][this.m_currentPortType][this.m_currentPortName][this.m_currentDeadZoneID].deadZone = param1;
            _loc2_ = 0;
            while(_loc2_ < this.m_activeGamepads.length)
            {
               _loc3_ = 0;
               while(_loc3_ < this.m_activeGamepads[_loc2_].ControlsList.length)
               {
                  if(this.m_activeGamepads[_loc2_].ControlsList[_loc3_].id === this.m_currentDeadZoneID)
                  {
                     this.m_activeGamepads[_loc2_].ControlsList[_loc3_].deadZone = param1;
                     break;
                  }
                  _loc3_++;
               }
               _loc2_++;
            }
         }
      }
      
      private function setDashZoneValue(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.m_currentDeadZoneID)
         {
            this.m_dashZoneText.text = "" + param1;
            this.m_dashZoneSlider.value = param1 * 100;
            SaveData.Gamepads[this.m_currentGamepad][this.m_currentPortType][this.m_currentPortName][this.m_currentDeadZoneID].dashZone = param1;
            _loc2_ = 0;
            while(_loc2_ < this.m_activeGamepads.length)
            {
               _loc3_ = 0;
               while(_loc3_ < this.m_activeGamepads[_loc2_].ControlsList.length)
               {
                  if(this.m_activeGamepads[_loc2_].ControlsList[_loc3_].id === this.m_currentDeadZoneID)
                  {
                     this.m_activeGamepads[_loc2_].ControlsList[_loc3_].dashZone = param1;
                     break;
                  }
                  _loc3_++;
               }
               _loc2_++;
            }
         }
      }
      
      private function onDeadZoneAxisChanged(param1:GamepadEvent) : void
      {
         if(this.m_currentDeadZoneID === param1.controlState.id)
         {
            this.m_axisValueText.text = "" + Math.round(param1.controlState.value * 1000000) / 1000000;
            if(Utils.fastAbs(param1.controlState.value) < param1.controlState.deadZone)
            {
               this.m_axisValueText.textColor = 0;
               this.m_axisValueText.alpha = 0.5;
            }
            else if(Utils.fastAbs(param1.controlState.value) < param1.controlState.dashZone)
            {
               this.m_axisValueText.textColor = 0;
               this.m_axisValueText.alpha = 1;
            }
            else
            {
               this.m_axisValueText.textColor = 255;
               this.m_axisValueText.alpha = 1;
            }
         }
      }
      
      private function userChanged(param1:Event) : void
      {
         this.gamepadChanged();
      }
      
      private function back_ROLL_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function back_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_back");
         removeSelf();
         MenuController.controlsMenu.show();
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


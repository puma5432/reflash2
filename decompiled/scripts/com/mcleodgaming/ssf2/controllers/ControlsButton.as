package com.mcleodgaming.ssf2.controllers
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.events.*;
   import com.mcleodgaming.ssf2.input.*;
   import com.mcleodgaming.ssf2.menus.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   import flash.events.*;
   
   public class ControlsButton extends HandButton
   {
      
      private var m_currentMC:MovieClip;
      
      private var m_keyVar:String;
      
      private var m_keyName:String;
      
      private var m_playerNum:Number;
      
      private var currKey:String = "";
      
      private var currKeyNum:Number = 0;
      
      public function ControlsButton(param1:MovieClip, param2:MovieClip, param3:String, param4:String, param5:Number)
      {
         super(param2);
         this.m_currentMC = param1;
         this.m_keyName = param3;
         this.m_keyVar = param4;
         this.m_playerNum = param5;
      }
      
      private function setInput(param1:String, param2:String, param3:Boolean) : void
      {
         var _loc4_:Gamepad = SaveData.Controllers[this.m_playerNum - 1].GamepadInstance;
         var _loc5_:String = Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj) ? MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[this.m_playerNum - 1].name : null;
         var _loc6_:String = _loc5_ ? "names" : "ports";
         this.unsetInput(param1,param2);
         var _loc7_:Object = SaveData.getGamepadInputData(_loc4_.Name,_loc5_ ? 0 : _loc4_.Port,_loc5_ ? _loc5_ : "port" + _loc4_.Port,param1);
         if(param3)
         {
            _loc7_.inputsInverse.push(param2);
         }
         else
         {
            _loc7_.inputs.push(param2);
         }
         if(param1 === "UP" || param1 === "DOWN" || param1 === "LEFT" || param1 === "RIGHT")
         {
            _loc7_.deadZone = MenuController.controlsMenu.controlStickDeadZone / 100;
            _loc7_.dashZone = MenuController.controlsMenu.controlStickDashZone / 100;
         }
         if(param1 === "C_UP" || param1 === "C_DOWN" || param1 === "C_LEFT" || param1 === "C_RIGHT")
         {
            _loc7_.deadZone = MenuController.controlsMenu.cStickDeadZone / 100;
            _loc7_.dashZone = MenuController.controlsMenu.cStickDashZone / 100;
         }
      }
      
      private function unsetInput(param1:String, param2:String) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Gamepad = SaveData.Controllers[this.m_playerNum - 1].GamepadInstance;
         var _loc5_:String = Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj) ? MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[this.m_playerNum - 1].name : null;
         var _loc6_:String = _loc5_ ? "names" : "ports";
         var _loc7_:Object = SaveData.getGamepadInputData(_loc4_.Name,_loc5_ ? 0 : _loc4_.Port,_loc5_ ? _loc5_ : "port" + _loc4_.Port,param1);
         _loc3_ = int(_loc7_.inputs.indexOf(param2));
         if(_loc3_ >= 0)
         {
            _loc7_.inputs.splice(_loc3_,1);
         }
         _loc3_ = int(_loc7_.inputsInverse.indexOf(param2));
         if(_loc3_ >= 0)
         {
            _loc7_.inputsInverse.splice(_loc3_,1);
         }
         _loc7_.deadZone = Gamepad.DEADZONE_DEFAULT;
         _loc7_.dashZone = Gamepad.DASHZONE_DEFAULT;
      }
      
      public function setPlayer(param1:Number) : void
      {
         this.m_playerNum = param1;
      }
      
      override protected function button_ROLLOVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_button.gotoAndStop("_over");
      }
      
      override protected function button_ROLLOUT(param1:MouseEvent) : void
      {
         m_button.gotoAndStop("_up");
      }
      
      override protected function button_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.m_currentMC.keySetter.currKey = this.m_keyName;
         this.m_currentMC.keySetter.currKeyNum = SaveData.Controllers[this.m_playerNum - 1].KeyboardInstance.ControlsMap[this.m_keyVar];
         this.m_currentMC.keySetter.visible = true;
         this.m_currentMC.keySetter.blocker.useHandCursor = false;
         this.m_currentMC.keySetter.keyVal.text = Utils.KEY_ARR[this.currKeyNum];
         this.m_currentMC.keySetter.currKey_txt.text = this.currKey;
         Main.Root.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyListener);
         Main.fixFocus();
         MenuController.controlsMenu.selectHand.enabled = false;
         if(SaveData.Controllers[this.m_playerNum - 1].GamepadInstance)
         {
            SaveData.Controllers[this.m_playerNum - 1].GamepadInstance.addEventListener(GamepadEvent.BUTTON_DOWN,this.onButtonDown);
            SaveData.Controllers[this.m_playerNum - 1].GamepadInstance.addEventListener(GamepadEvent.AXIS_CHANGED,this.onAxisChanged);
         }
      }
      
      private function exitScreen() : void
      {
         var _loc1_:Gamepad = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         Main.Root.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyListener);
         if(SaveData.Controllers[this.m_playerNum - 1].GamepadInstance)
         {
            _loc1_ = SaveData.Controllers[this.m_playerNum - 1].GamepadInstance;
            _loc2_ = Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj) ? MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[this.m_playerNum - 1].name : null;
            _loc3_ = _loc2_ ? "names" : "ports";
            SaveData.Controllers[this.m_playerNum - 1].GamepadInstance.removeEventListener(GamepadEvent.BUTTON_DOWN,this.onButtonDown);
            SaveData.Controllers[this.m_playerNum - 1].GamepadInstance.removeEventListener(GamepadEvent.AXIS_CHANGED,this.onAxisChanged);
            SaveData.Controllers[this.m_playerNum - 1].GamepadInstance.importControls(SaveData.Gamepads[_loc1_.Name][_loc3_][_loc2_ || "port" + _loc1_.Port]);
         }
         MenuController.controlsMenu.updateControls();
         this.m_currentMC.keySetter.visible = false;
         MenuController.controlsMenu.resetControlsLetGo();
         MenuController.controlsMenu.selectHand.enabled = true;
         MenuController.controlsMenu.selectHand.resetLetGo();
      }
      
      private function onButtonDown(param1:GamepadEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:Gamepad = SaveData.Controllers[this.m_playerNum - 1].GamepadInstance;
         var _loc5_:String = Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj) ? MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[this.m_playerNum - 1].name : null;
         var _loc6_:String = _loc5_ ? "names" : "ports";
         var _loc7_:Object = SaveData.getGamepadInputData(_loc4_.Name,_loc5_ ? 0 : _loc4_.Port,_loc5_ ? _loc5_ : "port" + _loc4_.Port,param1.controlState.id);
         for(_loc3_ in param1.gamepad.ControlState)
         {
            this.unsetInput(_loc3_,this.m_keyVar);
         }
         _loc7_.inputs.splice(0,_loc7_.inputs.length);
         this.setInput(param1.controlState.id,this.m_keyVar,false);
         this.exitScreen();
      }
      
      private function onAxisChanged(param1:GamepadEvent) : void
      {
         var _loc2_:Gamepad = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:* = undefined;
         if(Utils.fastAbs(param1.controlState.value) >= param1.controlState.deadZone)
         {
            _loc2_ = SaveData.Controllers[this.m_playerNum - 1].GamepadInstance;
            _loc3_ = Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj) ? MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[this.m_playerNum - 1].name : null;
            _loc4_ = _loc3_ ? "names" : "ports";
            _loc6_ = SaveData.getGamepadInputData(_loc2_.Name,_loc3_ ? 0 : _loc2_.Port,_loc3_ ? _loc3_ : "port" + _loc2_.Port,param1.controlState.id);
            for(_loc7_ in param1.gamepad.ControlState)
            {
               this.unsetInput(_loc7_,this.m_keyVar);
            }
            if(param1.controlState.value < 0)
            {
               _loc6_.inputsInverse.splice(0,_loc6_.inputsInverse.length);
            }
            else
            {
               _loc6_.inputs.splice(0,_loc6_.inputs.length);
            }
            this.setInput(param1.controlState.id,this.m_keyVar,param1.controlState.value < 0);
            this.exitScreen();
         }
      }
      
      private function keyListener(param1:KeyboardEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = param1.keyCode;
         var _loc7_:Controller = SaveData.Controllers[this.m_playerNum - 1];
         if(Utils.KEY_ARR[_loc6_] != undefined && Utils.KEY_ARR[_loc6_] != null)
         {
            _loc2_ = new Array("UP","DOWN","LEFT","RIGHT","JUMP","BUTTON1","BUTTON2","SHIELD","SHIELD2","TAUNT","START","GRAB","JUMP2","C_UP","C_DOWN","C_LEFT","C_RIGHT","DASH");
            if(_loc6_ != 27)
            {
               if(_loc6_ == 46)
               {
                  if(SaveData.Controllers[this.m_playerNum - 1].GamepadInstance)
                  {
                     for(_loc3_ in SaveData.Controllers[this.m_playerNum - 1].GamepadInstance.ControlState)
                     {
                        this.unsetInput(_loc3_,this.m_keyVar);
                     }
                  }
                  else
                  {
                     _loc7_.KeyboardInstance.ControlsMap[this.m_keyVar] = 0;
                  }
               }
               else
               {
                  if(SaveData.Controllers[this.m_playerNum - 1].GamepadInstance)
                  {
                     return;
                  }
                  _loc7_.KeyboardInstance.ControlsMap[this.m_keyVar] = _loc6_;
                  _loc4_ = 1;
                  while(_loc4_ <= SaveData.Controllers.length)
                  {
                     _loc5_ = 0;
                     while(_loc5_ < _loc2_.length)
                     {
                        if(_loc4_ != this.m_playerNum || _loc4_ == this.m_playerNum && this.m_keyVar != _loc2_[_loc5_])
                        {
                           if(SaveData.Controllers[_loc4_ - 1].KeyboardInstance.ControlsMap[_loc2_[_loc5_]] == _loc6_)
                           {
                              SaveData.Controllers[_loc4_ - 1].KeyboardInstance.ControlsMap[_loc2_[_loc5_]] = 0;
                           }
                        }
                        _loc5_++;
                     }
                     _loc4_++;
                  }
               }
            }
            this.exitScreen();
         }
      }
   }
}


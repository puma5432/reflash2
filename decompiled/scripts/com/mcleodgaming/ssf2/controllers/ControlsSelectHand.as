package com.mcleodgaming.ssf2.controllers
{
   import com.mcleodgaming.ssf2.events.*;
   import flash.display.MovieClip;
   import flash.events.*;
   
   public class ControlsSelectHand extends SelectHand
   {
      
      private var m_enabled:Boolean;
      
      public function ControlsSelectHand(param1:MovieClip, param2:Vector.<ControlsButton>, param3:Function)
      {
         var _loc5_:int = 0;
         var _loc4_:Vector.<HandButton> = new Vector.<HandButton>();
         while(_loc5_ < param2.length)
         {
            _loc4_.push(param2[_loc5_]);
            _loc5_++;
         }
         super(param1,_loc4_,param3);
         START_POSITION.x = -295;
         START_POSITION.y = 113;
         BOUNDS_RECT.x = -300;
         BOUNDS_RECT.y = -165;
         BOUNDS_RECT.width = 580;
         BOUNDS_RECT.height = 360;
         this.m_enabled = true;
      }
      
      public function get enabled() : Boolean
      {
         return this.m_enabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         this.m_enabled = param1;
      }
      
      override protected function checkControls(param1:Event) : void
      {
         if(!this.m_enabled)
         {
            return;
         }
         super.checkControls(param1);
      }
      
      override protected function checkHit(param1:Event) : void
      {
         var _loc3_:int = 0;
         if(!this.m_enabled)
         {
            return;
         }
         var _loc2_:Boolean = param1 is KeyboardEvent || param1 is GamepadEvent;
         if(Boolean(MenuController.controlsMenu.TapJumpCheckBox.enabled) && checkBounds(MenuController.controlsMenu.TapJumpCheckBox) && m_hand.visible && _loc2_)
         {
            _loc3_ = 0;
            while(_loc3_ < m_players.length)
            {
               if(m_players[_loc3_].IsDown(m_players[_loc3_]._BUTTON2))
               {
                  MenuController.controlsMenu.TapJumpCheckBox.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
               }
               _loc3_++;
            }
         }
         if(Boolean(MenuController.controlsMenu.RumbleCheckBox.enabled) && checkBounds(MenuController.controlsMenu.RumbleCheckBox) && m_hand.visible && _loc2_)
         {
            _loc3_ = 0;
            while(_loc3_ < m_players.length)
            {
               if(m_players[_loc3_].IsDown(m_players[_loc3_]._BUTTON2))
               {
                  MenuController.controlsMenu.RumbleCheckBox.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
               }
               _loc3_++;
            }
         }
         if(Boolean(MenuController.controlsMenu.AutoDashCheckBox.enabled) && checkBounds(MenuController.controlsMenu.AutoDashCheckBox) && m_hand.visible && _loc2_)
         {
            _loc3_ = 0;
            while(_loc3_ < m_players.length)
            {
               if(m_players[_loc3_].IsDown(m_players[_loc3_]._BUTTON2))
               {
                  MenuController.controlsMenu.AutoDashCheckBox.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
               }
               _loc3_++;
            }
         }
         if(Boolean(MenuController.controlsMenu.DTDashCheckBox.enabled) && checkBounds(MenuController.controlsMenu.DTDashCheckBox) && m_hand.visible && _loc2_)
         {
            _loc3_ = 0;
            while(_loc3_ < m_players.length)
            {
               if(m_players[_loc3_].IsDown(m_players[_loc3_]._BUTTON2))
               {
                  MenuController.controlsMenu.DTDashCheckBox.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
               }
               _loc3_++;
            }
         }
         super.checkHit(param1);
      }
   }
}


package com.mcleodgaming.ssf2.controllers
{
   import com.mcleodgaming.ssf2.events.*;
   import fl.controls.*;
   import flash.display.MovieClip;
   import flash.events.*;
   
   public class QualitySelectHand extends SelectHand
   {
      
      public function QualitySelectHand(param1:MovieClip, param2:Vector.<HandButton>, param3:Function)
      {
         super(param1,param2,param3);
         START_POSITION.x = -295;
         START_POSITION.y = 113;
         BOUNDS_RECT.x = -300;
         BOUNDS_RECT.y = -165;
         BOUNDS_RECT.width = 580;
         BOUNDS_RECT.height = 360;
      }
      
      override protected function checkHit(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc7_:int = 0;
         var _loc4_:Boolean = param1 is KeyboardEvent || param1 is GamepadEvent;
         var _loc6_:Vector.<ComboBox> = new Vector.<ComboBox>();
         _loc6_.push(MenuController.qualityMenu.FullScreenQualityComboBox);
         _loc6_.push(MenuController.qualityMenu.DisplayQualityComboBox);
         _loc6_.push(MenuController.qualityMenu.StageEffectsQualityComboBox);
         _loc6_.push(MenuController.qualityMenu.GlobalEffectsQualityComboBox);
         _loc6_.push(MenuController.qualityMenu.HitEffectsComboBox);
         _loc6_.push(MenuController.qualityMenu.HUDAlphaQualityComboBox);
         _loc6_.push(MenuController.qualityMenu.KnockbackSmokeQualityComboBox);
         _loc6_.push(MenuController.qualityMenu.ScreenFlashQualityComboBox);
         _loc6_.push(MenuController.qualityMenu.ShadowsQualityComboBox);
         _loc6_.push(MenuController.qualityMenu.WeatherQualityComboBox);
         _loc6_.push(MenuController.qualityMenu.AmbientLightingQualityComboBox);
         _loc6_.push(MenuController.qualityMenu.MenuBGQualityComboBox);
         while(_loc7_ < _loc6_.length)
         {
            if(checkBounds(_loc6_[_loc7_],_loc6_[_loc7_].parent.parent) && m_hand.visible && _loc4_)
            {
               _loc2_ = _loc6_[_loc7_].length;
               _loc3_ = _loc6_[_loc7_].selectedIndex + 1 < _loc2_ ? int(_loc6_[_loc7_].selectedIndex + 1) : 0;
               _loc5_ = 0;
               while(_loc5_ < m_players.length)
               {
                  if(m_players[_loc5_].IsDown(m_players[_loc5_]._BUTTON2))
                  {
                     _loc6_[_loc7_].selectedIndex = _loc3_;
                     _loc6_[_loc7_].dispatchEvent(new Event(Event.CHANGE));
                  }
                  _loc5_++;
               }
            }
            _loc7_++;
         }
         super.checkHit(param1);
      }
   }
}


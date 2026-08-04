package com.mcleodgaming.ssf2.controllers
{
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   
   public class StageSwitchHand extends SelectHand
   {
      
      public function StageSwitchHand(param1:MovieClip, param2:Vector.<StageSwitchButton>, param3:Function)
      {
         var _loc5_:int = 0;
         var _loc4_:Vector.<HandButton> = new Vector.<HandButton>();
         while(_loc5_ < param2.length)
         {
            _loc4_.push(param2[_loc5_]);
            _loc5_++;
         }
         super(param1,_loc4_,param3);
         var _loc6_:Object = ResourceManager.getResourceByID("mappings").getProp("metadata");
         var _loc7_:Object = _loc6_.stage_switch_screen;
         START_POSITION.x = _loc7_.hand_start.x;
         START_POSITION.y = _loc7_.hand_start.y;
         BOUNDS_RECT.x = _loc7_.hand_bounds.x;
         BOUNDS_RECT.y = _loc7_.hand_bounds.y;
         BOUNDS_RECT.width = _loc7_.hand_bounds.width;
         BOUNDS_RECT.height = _loc7_.hand_bounds.height;
      }
   }
}


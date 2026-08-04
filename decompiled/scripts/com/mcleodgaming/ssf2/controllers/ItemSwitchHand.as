package com.mcleodgaming.ssf2.controllers
{
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   
   public class ItemSwitchHand extends SelectHand
   {
      
      public function ItemSwitchHand(param1:MovieClip, param2:Vector.<ItemButton>, param3:Function)
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
         var _loc7_:Object = _loc6_.item_switch_screen;
         START_POSITION.x = _loc7_.hand_start.x;
         START_POSITION.y = _loc7_.hand_start.y;
         BOUNDS_RECT.x = _loc7_.hand_bounds.x;
         BOUNDS_RECT.y = _loc7_.hand_bounds.y;
         BOUNDS_RECT.width = _loc7_.hand_bounds.width;
         BOUNDS_RECT.height = _loc7_.hand_bounds.height;
         BOUNDS_RECT.x = -287;
         BOUNDS_RECT.y = -145;
         BOUNDS_RECT.width = 585;
         BOUNDS_RECT.height = 320;
         resetPosition();
      }
      
      override protected function checkBounds(param1:DisplayObject, param2:DisplayObject = null) : Boolean
      {
         return Boolean(super.checkBounds(param1,param2)) && !MovieClip(param1).disabled;
      }
   }
}


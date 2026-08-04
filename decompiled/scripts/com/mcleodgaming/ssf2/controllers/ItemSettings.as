package com.mcleodgaming.ssf2.controllers
{
   public class ItemSettings
   {
      
      public static const FREQUENCY_OFF:int = 0;
      
      public static const FREQUENCY_VERY_LOW:int = 1;
      
      public static const FREQUENCY_LOW:int = 2;
      
      public static const FREQUENCY_MEDIUM:int = 3;
      
      public static const FREQUENCY_HIGH:int = 4;
      
      public static const FREQUENCY_VERY_HIGH:int = 5;
      
      public static const FREQUENCY_SUPER_HIGH:int = 6;
      
      public static const FREQUENCY_ULTRA_HIGH:int = 7;
      
      public static const FREQUENCY_MAX:int = 8;
      
      public var frequency:int;
      
      public var items:Object;
      
      public function ItemSettings()
      {
         super();
         this.frequency = ItemSettings.FREQUENCY_HIGH;
         this.items = {};
      }
      
      public function setAllItemStatuses(param1:Boolean) : void
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this.items)
         {
            this.items[_loc2_] = param1;
         }
      }
      
      public function exportSettings() : Object
      {
         return {
            "frequency":this.frequency,
            "items":JSON.parse(JSON.stringify(this.items))
         };
      }
      
      public function importSettings(param1:Object) : void
      {
         var _loc2_:* = undefined;
         for(_loc2_ in param1)
         {
            if(this[_loc2_] !== undefined)
            {
               this[_loc2_] = param1[_loc2_];
            }
            else
            {
               trace("You tried to set \"" + _loc2_ + "\" but it doesn\'t exist in the GameSetting class.");
            }
         }
      }
   }
}


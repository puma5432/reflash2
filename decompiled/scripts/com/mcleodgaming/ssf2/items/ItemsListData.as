package com.mcleodgaming.ssf2.items
{
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.util.*;
   
   public class ItemsListData
   {
      
      public static var OBJECTS:Object;
      
      public static var DATA:Array = null;
      
      public function ItemsListData()
      {
         super();
      }
      
      public static function init() : void
      {
         var _loc1_:int = 0;
         DATA = ResourceManager.getItemStats();
         OBJECTS = {};
         while(_loc1_ < DATA.length)
         {
            OBJECTS[DATA[_loc1_].statsName] = DATA[_loc1_];
            _loc1_++;
         }
      }
      
      public static function getItemByID(param1:String) : Object
      {
         return OBJECTS[param1] ? OBJECTS[param1] : null;
      }
      
      public static function getItemStatsList(param1:Boolean = true, param2:Boolean = true) : Array
      {
         var _loc5_:int = 0;
         var _loc3_:Array = [];
         var _loc4_:Array = ResourceManager.getItemStats();
         while(_loc5_ < _loc4_.length)
         {
            if((param2 || SaveData.ItemDataObj[_loc4_[_loc5_].statsName] === undefined) && (param1 || SaveData.Unlocks[_loc4_[_loc5_].statsName] !== false))
            {
               _loc3_.push(_loc4_[_loc5_]);
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      public static function getRandomItemStats(param1:Boolean = true, param2:Boolean = true) : Object
      {
         var _loc3_:Array = ItemsListData.getItemStatsList(param1,param2);
         return _loc3_.length === 0 ? null : _loc3_[Utils.randomInteger(0,_loc3_.length)];
      }
   }
}


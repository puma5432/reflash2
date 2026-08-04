package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.util.*;
   
   public class StageSetting
   {
      
      public function StageSetting()
      {
         super();
      }
      
      private static function getStagesArray(param1:Boolean = false, param2:Boolean = true) : Vector.<String>
      {
         var _loc6_:int = 0;
         var _loc3_:Vector.<String> = new Vector.<String>();
         var _loc4_:Object = ResourceManager.getResourceByID("mappings").getProp("metadata");
         var _loc5_:Array = _loc4_.random_stages.stages;
         while(_loc6_ < _loc5_.length)
         {
            if((Boolean(Main.DEBUG || param1 || !param1 && SaveData.Unlocks[_loc5_[_loc6_]] !== false)) && Boolean(_loc4_.stage[_loc5_[_loc6_]]) && !(param2 && _loc4_.stage[_loc5_[_loc6_]].training_only))
            {
               _loc3_.push(_loc5_[_loc6_]);
            }
            _loc6_++;
         }
         return _loc3_;
      }
      
      public static function getRandomStage(param1:Boolean = false, param2:Boolean = false, param3:Boolean = true) : String
      {
         var _loc4_:Vector.<String> = getStagesArray(param1,param3);
         var _loc5_:* = int(_loc4_.length - 1);
         while(_loc5_ >= 0 && !param2)
         {
            if(SaveData.VSStageDataObj[_loc4_[_loc5_]] === false)
            {
               _loc4_.splice(_loc5_,1);
            }
            _loc5_--;
         }
         if(_loc4_.length == 0)
         {
            return "battlefield";
         }
         return _loc4_[Utils.randomInteger(0,_loc4_.length - 1)];
      }
   }
}


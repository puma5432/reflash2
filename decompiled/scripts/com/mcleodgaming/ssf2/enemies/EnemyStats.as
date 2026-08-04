package com.mcleodgaming.ssf2.enemies
{
   import com.mcleodgaming.ssf2.engine.InteractiveSpriteStats;
   
   public class EnemyStats extends InteractiveSpriteStats
   {
      
      public function EnemyStats()
      {
         super();
      }
      
      public function Clone() : EnemyStats
      {
         var _loc1_:Object = exportData();
         var _loc2_:EnemyStats = new EnemyStats();
         _loc2_.importData(_loc1_);
         return _loc2_;
      }
      
      override public function getVar(param1:String) : *
      {
         if(this["m_" + param1] !== undefined)
         {
            return this["m_" + param1];
         }
         return null;
      }
   }
}


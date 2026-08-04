package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.enemies.Enemy;
   import com.mcleodgaming.ssf2.engine.InteractiveSprite;
   import com.mcleodgaming.ssf2.engine.Projectile;
   
   public class SSF2Enemy extends SSF2GameObject
   {
      
      protected var _ownerCasted:Enemy;
      
      public function SSF2Enemy(param1:Class, param2:Enemy)
      {
         super(param1,param2);
         this._ownerCasted = param2;
      }
      
      public function destroy() : void
      {
         this._ownerCasted.destroy();
      }
      
      public function getOwner() : *
      {
         return this._ownerCasted.getOwnerAPI();
      }
      
      public function setOwner(param1:*) : void
      {
         this._ownerCasted.setOwnerAPI(param1 ? param1.$ext.getAPI().owner : null);
      }
      
      public function fireProjectile(param1:*, param2:Number = 0, param3:Number = 0, param4:Boolean = false, param5:Object = null) : *
      {
         var _loc6_:Projectile = this._ownerCasted.fireProjectile(param1,param2,param3,param4,param5);
         return Boolean(_loc6_) && Boolean(_loc6_.APIInstance) ? _loc6_.APIInstance.instance : null;
      }
      
      public function getEnemyStat(param1:String) : *
      {
         return this._ownerCasted.getEnemyStat(param1);
      }
      
      public function updateEnemyStats(param1:Object) : void
      {
         this._ownerCasted.updateEnemyStats(param1);
      }
      
      public function setHurtInterrupt(param1:Function) : void
      {
         _ownerCastedBase.HurtInterrupt = param1;
      }
   }
}


package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.engine.*;
   
   public class SSF2Projectile extends SSF2GameObject
   {
      
      protected var _ownerCasted:Projectile;
      
      public function SSF2Projectile(param1:Class, param2:Projectile)
      {
         super(param1,param2);
         this._ownerCasted = Projectile(param2);
      }
      
      public function angleControl(param1:Number, param2:Number) : void
      {
         this._ownerCasted.angleControl(param1,param2);
      }
      
      public function destroy(param1:* = null) : void
      {
         this._ownerCasted.destroy(param1);
      }
      
      public function endControl() : void
      {
         this._ownerCasted.endControl();
         SSF2API.print("WARNING: SSF2Projectile\'s endControl() method has been deprecated. Use updateProjectileStats() instead");
      }
      
      public function exportStats() : Object
      {
         return this._ownerCasted.exportStats();
      }
      
      public function getProjectileStat(param1:String) : *
      {
         return this._ownerCasted.getProjectileStat(param1);
      }
      
      public function isReversed() : Boolean
      {
         return this._ownerCasted.isReversed();
      }
      
      public function updateProjectileStats(param1:Object) : void
      {
         this._ownerCasted.updateProjectileStats(param1);
      }
      
      public function getOwner() : *
      {
         return this._ownerCasted.getOwnerAPI();
      }
      
      public function setOwner(param1:*) : void
      {
         return this._ownerCasted.setOwnerAPI(param1 ? param1.$ext.getAPI().owner : null);
      }
   }
}


package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.engine.Character;
   import com.mcleodgaming.ssf2.engine.InteractiveSprite;
   import com.mcleodgaming.ssf2.engine.Projectile;
   import com.mcleodgaming.ssf2.items.*;
   
   public class SSF2Item extends SSF2GameObject
   {
      
      protected var _ownerCasted:Item;
      
      public function SSF2Item(param1:Class, param2:Item)
      {
         super(param1,param2);
         this._ownerCasted = Item(param2);
      }
      
      public function destroy(param1:Boolean = false) : void
      {
         this._ownerCasted.destroy(param1);
      }
      
      public function fireProjectile(param1:*, param2:Number = 0, param3:Number = 0, param4:Boolean = false, param5:Object = null) : *
      {
         var _loc6_:Projectile = this._ownerCasted.fireProjectile(param1,param2,param3,param4,param5);
         return Boolean(_loc6_) && Boolean(_loc6_.APIInstance) ? _loc6_.APIInstance.instance : null;
      }
      
      public function getItemStat(param1:String) : *
      {
         return this._ownerCasted.getItemStat(param1);
      }
      
      public function isReversed() : Boolean
      {
         return this._ownerCasted.isReversed();
      }
      
      public function resetTime() : void
      {
         this._ownerCasted.resetTime();
      }
      
      public function updateItemStats(param1:Object) : void
      {
         this._ownerCasted.updateItemStats(param1);
      }
      
      public function getOwner() : *
      {
         return this._ownerCasted.getOwnerAPI();
      }
      
      public function setOwner(param1:*) : void
      {
         return this._ownerCasted.setOwnerAPI(param1 ? param1.$ext.getAPI().owner : null);
      }
      
      public function getHolder() : *
      {
         return this._ownerCasted.getHolderAPI();
      }
      
      public function setHolder(param1:*) : void
      {
         return this._ownerCasted.setHolderAPI(param1 ? param1.$ext.getAPI().owner : null);
      }
      
      public function toIdle(param1:* = null) : void
      {
         this._ownerCasted.toIdle(param1);
      }
      
      public function toHeld(param1:* = null) : void
      {
         this._ownerCasted.toHeld(param1);
      }
      
      public function toToss(param1:* = null) : void
      {
         this._ownerCasted.toToss(param1);
      }
      
      public function setFrameInterrupt(param1:Function) : void
      {
         this._ownerCasted.FrameInterrupt = param1;
      }
      
      public function setHurtInterrupt(param1:Function) : void
      {
         _ownerCastedBase.HurtInterrupt = param1;
      }
      
      public function isZDropped() : Boolean
      {
         return this._ownerCasted.WasZDropped;
      }
   }
}


package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.engine.TargetTestTarget;
   
   public class SSF2Target extends SSF2GameObject
   {
      
      protected var _ownerCasted:TargetTestTarget;
      
      public function SSF2Target(param1:Class, param2:TargetTestTarget)
      {
         super(param1,param2);
         this._ownerCasted = param2;
      }
      
      public function breakTarget() : void
      {
         this._ownerCasted.breakTarget();
      }
      
      public function destroy() : void
      {
         this._ownerCasted.destroy();
      }
      
      public function addMovement(param1:Object) : void
      {
         this._ownerCasted.addMovement(param1);
      }
      
      public function clearMovement() : void
      {
         this._ownerCasted.clearMovement();
      }
      
      public function setHurtInterrupt(param1:Function) : void
      {
         _ownerCastedBase.HurtInterrupt = param1;
      }
   }
}


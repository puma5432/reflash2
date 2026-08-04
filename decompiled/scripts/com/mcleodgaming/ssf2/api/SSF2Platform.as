package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.platforms.*;
   import flash.geom.Point;
   
   public class SSF2Platform extends SSF2CollisionBoundary
   {
      
      private var _ownerCasted:MovingPlatform;
      
      public function SSF2Platform(param1:Class, param2:MovingPlatform)
      {
         super(param1,param2);
         this._ownerCasted = MovingPlatform(param2);
      }
      
      public function faceRight() : void
      {
         this._ownerCasted.faceRight();
      }
      
      public function faceLeft() : void
      {
         this._ownerCasted.faceLeft();
      }
      
      public function setForeground(param1:String) : void
      {
         this._ownerCasted.foreground = param1;
      }
      
      public function getFallthrough() : Boolean
      {
         return this._ownerCasted.fallthrough;
      }
      
      public function setFallthrough(param1:Boolean) : void
      {
         this._ownerCasted.fallthrough = param1;
      }
      
      public function getNoDropThrough() : Boolean
      {
         return this._ownerCasted.noDropThrough;
      }
      
      public function setNoDropThrough(param1:Boolean) : void
      {
         this._ownerCasted.noDropThrough = param1;
      }
      
      public function getAccelFriction() : Number
      {
         return this._ownerCasted.accel_friction;
      }
      
      public function setAccelFriction(param1:Number) : void
      {
         this._ownerCasted.accel_friction = param1;
      }
      
      public function getDecelFriction() : Number
      {
         return this._ownerCasted.decel_friction;
      }
      
      public function setDecelFriction(param1:Number) : void
      {
         this._ownerCasted.decel_friction = param1;
      }
      
      public function get XInfluence() : Number
      {
         return this._ownerCasted.x_influence;
      }
      
      public function set XInfluence(param1:Number) : void
      {
         this._ownerCasted.x_influence = param1;
      }
      
      public function getDanger() : Boolean
      {
         return this._ownerCasted.danger;
      }
      
      public function setDanger(param1:Boolean) : void
      {
         this._ownerCasted.danger = param1;
      }
      
      public function getBounceSpeed() : Number
      {
         return this._ownerCasted.bounce_speed;
      }
      
      public function setBounceSpeed(param1:Number) : void
      {
         this._ownerCasted.bounce_speed = param1;
      }
      
      public function setAlpha(param1:Number) : void
      {
         this._ownerCasted.setAlpha(param1);
      }
      
      public function setCamFocus(param1:Boolean) : void
      {
         this._ownerCasted.setCamFocus(param1);
      }
      
      public function getXSpeed() : Number
      {
         return this._ownerCasted.getXSpeed();
      }
      
      public function setXSpeed(param1:Number) : void
      {
         this._ownerCasted.setXSpeed(param1);
      }
      
      public function getYSpeed() : Number
      {
         return this._ownerCasted.getYSpeed();
      }
      
      public function setYSpeed(param1:Number) : void
      {
         this._ownerCasted.setYSpeed(param1);
      }
      
      public function getStartPosition() : Point
      {
         return this._ownerCasted.getStartPosition();
      }
      
      public function addMovement(param1:Object) : void
      {
         this._ownerCasted.addMovement(param1);
      }
      
      public function clearMovement() : void
      {
         this._ownerCasted.clearMovement();
      }
      
      public function getConserveHorizontalMomentum() : Boolean
      {
         return this._ownerCasted.conserve_horizontal_momentum;
      }
      
      public function setConserveHorizontalMomentum(param1:Boolean) : void
      {
         this._ownerCasted.conserve_horizontal_momentum = param1;
      }
      
      public function getConserveUpwardMomentum() : Boolean
      {
         return this._ownerCasted.conserve_upward_momentum;
      }
      
      public function setConserveUpwardMomentum(param1:Boolean) : void
      {
         this._ownerCasted.conserve_upward_momentum = param1;
      }
      
      public function getConserveDownwardMomentum() : Boolean
      {
         return this._ownerCasted.conserve_downward_momentum;
      }
      
      public function setConserveDownwardMomentum(param1:Boolean) : void
      {
         this._ownerCasted.conserve_downward_momentum = param1;
      }
      
      public function extraHitTests(param1:Number, param2:Number, param3:InteractiveSprite) : Boolean
      {
         if(Boolean(param3.APIInstance) && Boolean(_api) && "extraHitTests" in _api)
         {
            return _api.extraHitTests(param1,param2,param3.APIInstance.instance);
         }
         return false;
      }
      
      public function addIgnoreObject(param1:*) : void
      {
         var _loc2_:InteractiveSprite = null;
         if("$ext" in param1 && param1.$ext.getAPI().owner is InteractiveSprite)
         {
            _loc2_ = param1.$ext.getAPI().owner;
            if(this._ownerCasted.IgnoreList.indexOf(_loc2_) < 0)
            {
               this._ownerCasted.IgnoreList.push(_loc2_);
            }
         }
      }
      
      public function removeIgnoreObject(param1:*) : void
      {
         var _loc2_:InteractiveSprite = null;
         var _loc3_:int = 0;
         if("$ext" in param1 && param1.$ext.getAPI().owner is InteractiveSprite)
         {
            _loc2_ = param1.$ext.getAPI().owner;
            _loc3_ = int(this._ownerCasted.IgnoreList.indexOf(_loc2_));
            if(_loc3_ >= 0)
            {
               this._ownerCasted.IgnoreList.splice(_loc3_,1);
            }
         }
      }
      
      public function setIgnoreObjectListInversed(param1:Boolean) : void
      {
         this._ownerCasted.setIgnoreObjectListInversed(param1);
      }
   }
}


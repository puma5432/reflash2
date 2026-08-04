package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.platforms.*;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   
   public class SSF2CollisionBoundary extends SSF2BaseAPIObject
   {
      
      private var _ownerCasted:BitmapCollisionBoundary;
      
      public function SSF2CollisionBoundary(param1:Class, param2:BitmapCollisionBoundary)
      {
         super(param1,param2);
         this._ownerCasted = BitmapCollisionBoundary(param2);
      }
      
      public function getOwnStats() : Object
      {
         if(Boolean(_api) && "getOwnStats" in _api)
         {
            return _api.getOwnStats();
         }
         return {};
      }
      
      public function getMC() : MovieClip
      {
         return this._ownerCasted.Container;
      }
      
      public function destroy() : void
      {
         return this._ownerCasted.destroy();
      }
      
      public function getX() : Number
      {
         return this._ownerCasted.X;
      }
      
      public function setX(param1:Number) : void
      {
         this._ownerCasted.X = param1;
      }
      
      public function getY() : Number
      {
         return this._ownerCasted.Y;
      }
      
      public function setY(param1:Number) : void
      {
         this._ownerCasted.Y = param1;
      }
      
      public function hitTestPoint(param1:Number, param2:Number, param3:Boolean = true) : Boolean
      {
         return this._ownerCasted.hitTestPointAPI(param1,param2,param3);
      }
      
      public function hitTestRect(param1:Rectangle, param2:Boolean = true) : Boolean
      {
         return this._ownerCasted.hitTestRectAPI(param1,param2);
      }
      
      public function hitTestRectAPIOverride(param1:Rectangle, param2:Boolean = true) : Boolean
      {
         return _api.hitTestRect(param1,param2);
      }
      
      public function hitTestPointAPIOverride(param1:Number, param2:Number, param3:Boolean = true) : Boolean
      {
         return _api.hitTestPoint(param1,param2,param3);
      }
   }
}


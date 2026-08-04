package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.util.Vcam;
   import flash.display.MovieClip;
   import flash.geom.*;
   
   public class SSF2Camera extends SSF2BaseAPIObject
   {
      
      protected var _ownerCasted:Vcam;
      
      public function SSF2Camera(param1:Class, param2:Vcam)
      {
         super(param1,param2);
         this._ownerCasted = param2;
      }
      
      public function getCameraParameter(param1:String) : *
      {
         var _loc2_:Object = this._ownerCasted.Settings.exportSettings();
         return _loc2_[param1] !== undefined ? _loc2_[param1] : null;
      }
      
      public function updateCameraParameters(param1:Object) : void
      {
         this._ownerCasted.Settings.importSettings(param1);
         if(param1.backgrounds)
         {
            this._ownerCasted.changeBG(this._ownerCasted.Settings.backgrounds);
         }
      }
      
      public function addTarget(param1:MovieClip) : void
      {
         this._ownerCasted.addTarget(param1);
      }
      
      public function deleteTarget(param1:MovieClip) : void
      {
         this._ownerCasted.deleteTarget(param1);
      }
      
      public function getTopLeftPoint() : Point
      {
         return new Point(this._ownerCasted.CornerX,this._ownerCasted.CornerY);
      }
      
      public function getMC() : MovieClip
      {
         return this._ownerCasted.CamMC;
      }
      
      public function maxZoomOut() : void
      {
         this._ownerCasted.maxZoomOut();
         this._ownerCasted.camControl();
      }
      
      public function targetCenterStage() : void
      {
         this._ownerCasted.targetCenterStage();
         this._ownerCasted.camControl();
      }
      
      public function forceTarget() : void
      {
         this._ownerCasted.forceTarget();
         this._ownerCasted.camControl();
      }
      
      public function forceInBounds() : void
      {
         this._ownerCasted.forceInBounds();
         this._ownerCasted.camControl();
      }
      
      public function darken() : void
      {
         this._ownerCasted.darken();
      }
      
      public function killDarkener(param1:Boolean = false) : void
      {
         this._ownerCasted.killDarkener(param1);
      }
      
      public function addTimedTarget(param1:MovieClip, param2:int) : void
      {
         this._ownerCasted.addTimedTarget(param1,param2);
      }
      
      public function deleteTimedTarget(param1:MovieClip) : void
      {
         this._ownerCasted.deleteTimedTarget(param1);
      }
      
      public function addTimedTargetPoint(param1:Point, param2:int) : void
      {
         this._ownerCasted.addTimedTargetPoint(param1,param2);
      }
      
      public function deleteTimedTargetPoint(param1:Point) : void
      {
         this._ownerCasted.deleteTimedTargetPoint(param1);
      }
      
      public function addForcedTarget(param1:MovieClip) : void
      {
         this._ownerCasted.addForcedTarget(param1);
      }
      
      public function deleteForcedTarget(param1:MovieClip) : void
      {
         this._ownerCasted.deleteForcedTarget(param1);
      }
      
      public function lightFlash(param1:Boolean = true) : void
      {
         this._ownerCasted.lightFlash(param1);
      }
      
      public function setStageFocus(param1:int) : void
      {
         this._ownerCasted.setStageFocus(param1);
      }
      
      public function removeStageFocus() : void
      {
         this._ownerCasted.removeStageFocus();
      }
      
      public function shake(param1:int) : void
      {
         this._ownerCasted.shake(param1);
      }
      
      public function getMode() : int
      {
         return this._ownerCasted.Mode;
      }
      
      public function setMode(param1:int) : void
      {
         this._ownerCasted.Mode = param1;
      }
   }
}


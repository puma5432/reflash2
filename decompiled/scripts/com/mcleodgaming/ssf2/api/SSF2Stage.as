package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.util.VcamBG;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.*;
   
   public class SSF2Stage extends SSF2BaseAPIObject
   {
      
      protected var _ownerCasted:StageData;
      
      public function SSF2Stage(param1:Class, param2:StageData)
      {
         super(param1,param2);
         this._ownerCasted = StageData(param2);
      }
      
      public function getForeground() : MovieClip
      {
         return this._ownerCasted.StageFG;
      }
      
      public function getMidground() : MovieClip
      {
         return this._ownerCasted.StageRef;
      }
      
      public function getBackground() : MovieClip
      {
         return this._ownerCasted.StageBG;
      }
      
      public function getCameraBackgrounds() : Array
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc7_:int = 0;
         var _loc5_:Vector.<VcamBG> = this._ownerCasted.CamRef.BGs;
         var _loc6_:Array = new Array();
         while(_loc7_ < _loc5_.length)
         {
            _loc2_ = _loc5_[_loc7_].sprite;
            _loc3_ = [];
            _loc4_ = [];
            _loc1_ = 0;
            while(Boolean(_loc5_[_loc7_].horizontalScrollPair) && _loc1_ < _loc5_[_loc7_].horizontalScrollPair.length)
            {
               _loc3_.push(_loc5_[_loc7_].horizontalScrollPair[_loc1_]);
               _loc1_++;
            }
            _loc1_ = 0;
            while(Boolean(_loc5_[_loc7_].verticalScrollPair) && _loc1_ < _loc5_[_loc7_].verticalScrollPair.length)
            {
               _loc4_.push(_loc5_[_loc7_].verticalScrollPair[_loc1_]);
               _loc1_++;
            }
            _loc6_.push({
               "mc":_loc2_,
               "horizontalScrollPair":_loc3_,
               "verticalScrollPair":_loc4_
            });
            _loc7_++;
         }
         return _loc6_;
      }
      
      public function getWeatherMC() : MovieClip
      {
         return this._ownerCasted.WeatherRef;
      }
      
      public function getWeatherMaskMC() : MovieClip
      {
         return this._ownerCasted.WeatherMaskRef;
      }
      
      public function getShadowMC() : MovieClip
      {
         return this._ownerCasted.ShadowsRef;
      }
      
      public function getShadowMaskMC() : MovieClip
      {
         return this._ownerCasted.ShadowMaskRef;
      }
      
      public function getHUDBackgroundMC() : MovieClip
      {
         return this._ownerCasted.HudForegroundRef;
      }
      
      public function getHUDForegroundMC() : MovieClip
      {
         return this._ownerCasted.HudOverlayRef;
      }
      
      public function enableCeilingDeath(param1:Boolean = true) : void
      {
         this._ownerCasted.DisableCeilingDeath = !param1;
      }
      
      public function enableFallDeath(param1:Boolean = true) : void
      {
         this._ownerCasted.DisableFallDeath = !param1;
      }
      
      public function isCeilingDeathEnabled() : Boolean
      {
         return !this._ownerCasted.DisableCeilingDeath;
      }
      
      public function isFallDeathEnabled() : Boolean
      {
         return !this._ownerCasted.DisableFallDeath;
      }
      
      public function createTimer(param1:int, param2:int, param3:Function, param4:Object = null) : void
      {
         this._ownerCasted.createTimer(param1,param2,param3,param4);
      }
      
      public function destroyTimer(param1:Function) : void
      {
         this._ownerCasted.destroyTimer(param1);
      }
      
      public function toLocalPoint(param1:DisplayObject) : Point
      {
         return this.getMidground().globalToLocal(param1.localToGlobal(new Point(0,0)));
      }
      
      public function getStartingPositionMCs() : Array
      {
         var _loc2_:int = 0;
         var _loc1_:Array = new Array();
         while(_loc2_ < this._ownerCasted.StartPositionMCs.length)
         {
            _loc1_.push(this._ownerCasted.StartPositionMCs[_loc2_]);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getSpawnPositionMCs() : Array
      {
         var _loc2_:int = 0;
         var _loc1_:Array = new Array();
         while(_loc2_ < this._ownerCasted.SpawnPositionMCs.length)
         {
            _loc1_.push(this._ownerCasted.SpawnPositionMCs[_loc2_]);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getLightSourceMC() : MovieClip
      {
         return this._ownerCasted.LightSource;
      }
      
      public function getLedges() : Array
      {
         return this._ownerCasted.getLedgesAPI();
      }
      
      public function getCameraBounds() : MovieClip
      {
         return this._ownerCasted.getCamBounds();
      }
      
      public function getDeathBounds() : MovieClip
      {
         return this._ownerCasted.getDeathBounds();
      }
      
      public function getSmashBallBounds() : MovieClip
      {
         return this._ownerCasted.SmashBallBounds;
      }
      
      public function getItemSpawnBoundsList() : Array
      {
         var _loc3_:int = 0;
         var _loc1_:Array = [];
         var _loc2_:Vector.<MovieClip> = this._ownerCasted.getItemGens();
         while(_loc3_ < _loc2_.length)
         {
            _loc1_.push(_loc2_[_loc3_]);
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function getStarKOEnabled() : Boolean
      {
         return this._ownerCasted.StarKOEnabled;
      }
      
      public function setStarKOEnabled(param1:Boolean) : void
      {
         this._ownerCasted.StarKOEnabled = param1;
      }
      
      public function getScreenKOEnabled() : Boolean
      {
         return this._ownerCasted.ScreenKOEnabled;
      }
      
      public function setScreenKOEnabled(param1:Boolean) : void
      {
         this._ownerCasted.ScreenKOEnabled = param1;
      }
   }
}


package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.platforms.MovingPlatform;
   import com.mcleodgaming.ssf2.platforms.Platform;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   import flash.geom.*;
   
   public class SSF2GameObject extends SSF2BaseAPIObject
   {
      
      protected var _ownerCastedBase:InteractiveSprite;
      
      public function SSF2GameObject(param1:Class, param2:InteractiveSprite)
      {
         super(param1,param2);
         this._ownerCastedBase = InteractiveSprite(param2);
      }
      
      public function getOwnStats() : Object
      {
         if(Boolean(_api) && "getOwnStats" in _api)
         {
            return _api.getOwnStats();
         }
         return {};
      }
      
      public function getAttackStats() : Object
      {
         if(Boolean(_api) && "getAttackStats" in _api)
         {
            return _api.getAttackStats();
         }
         return {};
      }
      
      public function getProjectileStats() : Object
      {
         if(Boolean(_api) && "getProjectileStats" in _api)
         {
            return _api.getProjectileStats();
         }
         return {};
      }
      
      public function getItemStats() : Object
      {
         if(Boolean(_api) && "getItemStats" in _api)
         {
            return _api.getItemStats();
         }
         return {};
      }
      
      public function playSound(param1:*, param2:Boolean = false) : int
      {
         return this._ownerCastedBase.playSound(param1,param2);
      }
      
      public function stopSound(param1:int) : void
      {
         this._ownerCastedBase.stopSound(param1);
      }
      
      public function addToCamera() : void
      {
         this._ownerCastedBase.addToCamera();
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Object = null) : void
      {
         this._ownerCastedBase.addEventListener(param1,param2,param3);
      }
      
      public function hasEventListener(param1:String, param2:Function = null) : Boolean
      {
         return this._ownerCastedBase.hasEventListener(param1,param2);
      }
      
      public function removeEventListener(param1:String, param2:Function) : void
      {
         this._ownerCastedBase.removeEventListener(param1,param2);
      }
      
      public function attachEffect(param1:*, param2:Object = null) : MovieClip
      {
         return this._ownerCastedBase.attachEffect(param1,param2);
      }
      
      public function attachEffectOverlay(param1:*, param2:Object = null) : MovieClip
      {
         return this._ownerCastedBase.attachEffectOverlay(param1,param2);
      }
      
      public function camFocus(param1:int) : void
      {
         this._ownerCastedBase.camFocus(param1);
      }
      
      public function camUnfocus() : void
      {
         this._ownerCastedBase.camUnfocus();
      }
      
      public function createTimer(param1:int, param2:int, param3:Function, param4:Object = null) : void
      {
         this._ownerCastedBase.createTimer(param1,param2,param3,param4);
      }
      
      public function destroyTimer(param1:Function) : void
      {
         this._ownerCastedBase.destroyTimer(param1);
      }
      
      public function faceLeft() : void
      {
         this._ownerCastedBase.faceLeft();
      }
      
      public function faceRight() : void
      {
         this._ownerCastedBase.faceRight();
      }
      
      public function flip(param1:* = null) : void
      {
         this._ownerCastedBase.flip(param1);
      }
      
      public function forceHitStun(param1:int, param2:Number = -1) : void
      {
         this._ownerCastedBase.forceHitStun(param1,param2);
      }
      
      public function getGameObjectStat(param1:String) : *
      {
         return this._ownerCastedBase.getGameObjectStat(param1);
      }
      
      public function getAttackBoxStat(param1:int, param2:String) : *
      {
         return this._ownerCastedBase.getAttackBoxStat(param1,param2);
      }
      
      public function exportAttackBoxStats(param1:int, param2:String) : Object
      {
         return this._ownerCastedBase.exportAttackBoxStats(param1,param2);
      }
      
      public function getAttackStat(param1:String) : *
      {
         return this._ownerCastedBase.getAttackStat(param1);
      }
      
      public function getCounterAttackBoxStats() : Object
      {
         return this._ownerCastedBase.getCounterAttackBoxStats();
      }
      
      public function getGlobalVariable(param1:String) : *
      {
         return this._ownerCastedBase.getGlobalVariable(param1);
      }
      
      public function getHeight() : Number
      {
         return this._ownerCastedBase.getHeight();
      }
      
      public function getHitBox(param1:String) : Object
      {
         return this._ownerCastedBase.getHitBox(param1);
      }
      
      public function getHomingTarget() : *
      {
         return this._ownerCastedBase.getHomingTargetAPI();
      }
      
      public function getID() : int
      {
         return this._ownerCastedBase.getID();
      }
      
      public function getTeamID() : int
      {
         return this._ownerCastedBase.Team;
      }
      
      public function setTeamID(param1:int) : void
      {
         this._ownerCastedBase.Team = param1;
      }
      
      public function getLinkageID() : String
      {
         return this._ownerCastedBase.getLinkageID();
      }
      
      public function getMC() : MovieClip
      {
         return this._ownerCastedBase.getMC();
      }
      
      public function getRotation() : Number
      {
         return this._ownerCastedBase.getRotation();
      }
      
      public function getScale() : Point
      {
         return this._ownerCastedBase.getScale();
      }
      
      public function getStanceMC() : MovieClip
      {
         return this._ownerCastedBase.getStanceMC();
      }
      
      public function getUID() : int
      {
         return this._ownerCastedBase.UID;
      }
      
      public function getWidth() : Number
      {
         return this._ownerCastedBase.getWidth();
      }
      
      public function getX() : Number
      {
         return this._ownerCastedBase.getX();
      }
      
      public function getXScale() : Number
      {
         return this._ownerCastedBase.getXScale();
      }
      
      public function getXSpeed() : Number
      {
         return this._ownerCastedBase.getXSpeed();
      }
      
      public function getY() : Number
      {
         return this._ownerCastedBase.getY();
      }
      
      public function getYScale() : Number
      {
         return this._ownerCastedBase.getYScale();
      }
      
      public function getYSpeed() : Number
      {
         return this._ownerCastedBase.getYSpeed();
      }
      
      public function getNearest(param1:String, param2:Boolean = true, param3:Boolean = true) : *
      {
         var _loc4_:InteractiveSprite = this._ownerCastedBase.getNearest(param1,param2,param3);
         return Boolean(_loc4_) && Boolean(_loc4_.APIInstance) ? _loc4_.APIInstance.instance : null;
      }
      
      public function getNearestPath(param1:String, param2:Boolean = true, param3:Boolean = true) : Array
      {
         var _loc6_:int = 0;
         var _loc4_:Array = this._ownerCastedBase.getNearestPath(param1,param2,param3);
         var _loc5_:Array = [];
         while(_loc6_ < _loc4_.length)
         {
            if(_loc4_[_loc6_] is InteractiveSprite && Boolean(InteractiveSprite(_loc4_[_loc6_]).APIInstance))
            {
               _loc5_.push(_loc4_[_loc6_].APIInstance.instance);
            }
            _loc6_++;
         }
         return _loc5_;
      }
      
      public function getCurrentPlatform() : *
      {
         var _loc1_:Platform = this._ownerCastedBase.CurrentPlatform;
         return Boolean(_loc1_) && Boolean(_loc1_.APIInstance) ? _loc1_.APIInstance.instance : null;
      }
      
      public function getStageParentPosition() : Point
      {
         return new Point(this._ownerCastedBase.OverlayX,this._ownerCastedBase.OverlayY);
      }
      
      public function homeTowardsTarget(param1:Number, param2:*) : void
      {
         this._ownerCastedBase.homeTowardsTargetAPI(param1,param2 ? param2.$ext.getAPI().owner : null);
      }
      
      public function isFacingRight() : Boolean
      {
         return this._ownerCastedBase.isFacingRight();
      }
      
      public function isOnGround() : Boolean
      {
         return this._ownerCastedBase.isOnGround();
      }
      
      public function netSpeed(param1:Boolean = false, param2:Boolean = false) : Number
      {
         return this._ownerCastedBase.netSpeed(param1,param2);
      }
      
      public function netXSpeed(param1:Boolean = false, param2:Boolean = false) : Number
      {
         return this._ownerCastedBase.netXSpeed(param1,param2);
      }
      
      public function netYSpeed(param1:Boolean = false, param2:Boolean = false) : Number
      {
         return this._ownerCastedBase.netYSpeed(param1,param2);
      }
      
      public function removeFromCamera() : void
      {
         this._ownerCastedBase.removeFromCamera();
      }
      
      public function refreshAttackID() : void
      {
         this._ownerCastedBase.refreshAttackID();
      }
      
      public function refreshStaleID() : void
      {
         this._ownerCastedBase.refreshStaleID();
      }
      
      public function resetRotation() : void
      {
         this._ownerCastedBase.resetRotation();
      }
      
      public function resetKnockback() : void
      {
         this._ownerCastedBase.resetKnockback();
      }
      
      public function resetKnockbackDecay() : void
      {
         this._ownerCastedBase.resetKnockbackDecay();
      }
      
      public function getKnockbackDecay() : Object
      {
         return this._ownerCastedBase.getKnockbackDecay();
      }
      
      public function setKnockbackDecay(param1:Number, param2:Number) : void
      {
         this._ownerCastedBase.setKnockbackDecay(param1,param2);
      }
      
      public function safeMove(param1:Number, param2:Number) : Boolean
      {
         return this._ownerCastedBase.safeMove(param1,param2);
      }
      
      public function setCamBoxSize(param1:Number, param2:Number, param3:Number = 0, param4:Number = 0) : void
      {
         this._ownerCastedBase.setCamBoxSize(param1,param2,param3,param4);
      }
      
      public function setGlobalVariable(param1:String, param2:*) : void
      {
         this._ownerCastedBase.setGlobalVariable(param1,param2);
      }
      
      public function setPosition(param1:Number, param2:Number) : void
      {
         this._ownerCastedBase.setPosition(param1,param2);
      }
      
      public function setRotation(param1:Number) : void
      {
         this._ownerCastedBase.setRotation(param1);
      }
      
      public function setScale(param1:Number, param2:Number) : void
      {
         this._ownerCastedBase.setScale(param1,param2);
      }
      
      public function setX(param1:Number) : void
      {
         this._ownerCastedBase.setX(param1);
      }
      
      public function setXSpeed(param1:Number, param2:Boolean = true) : void
      {
         this._ownerCastedBase.setXSpeed(param1,param2);
      }
      
      public function setY(param1:Number) : void
      {
         this._ownerCastedBase.setY(param1);
      }
      
      public function setYSpeed(param1:Number) : void
      {
         this._ownerCastedBase.setYSpeed(param1);
      }
      
      public function stancePlayFrame(param1:*) : void
      {
         if(param1 === "backflip" && this._ownerCastedBase.HasStance && !Utils.hasLabel(this._ownerCastedBase.Stance,"backflip"))
         {
            return;
         }
         this._ownerCastedBase.stancePlayFrame(param1);
      }
      
      public function swapDepths(param1:*) : void
      {
         this._ownerCastedBase.swapDepths(param1 ? param1.$ext.getAPI().owner : null);
      }
      
      public function bringBehind(param1:*) : void
      {
         this._ownerCastedBase.bringBehindAPI(param1 ? param1.$ext.getAPI().owner : null);
      }
      
      public function bringInFront(param1:*) : void
      {
         this._ownerCastedBase.bringInFrontAPI(param1 ? param1.$ext.getAPI().owner : null);
      }
      
      public function attachToGround() : void
      {
         this._ownerCastedBase.attachToGround();
      }
      
      public function unnattachFromGround() : void
      {
         this._ownerCastedBase.unnattachFromGround();
      }
      
      public function updateAttackBoxStats(param1:int, param2:Object) : void
      {
         this._ownerCastedBase.updateAttackBoxStats(param1,param2);
      }
      
      public function updateAttackStats(param1:Object) : void
      {
         this._ownerCastedBase.updateAttackStats(param1);
      }
      
      public function replaceAttackStats(param1:String, param2:Object) : void
      {
         this._ownerCastedBase.replaceAttackStats(param1,param2);
      }
      
      public function replaceAttackBoxStats(param1:String, param2:int, param3:Object) : void
      {
         this._ownerCastedBase.replaceAttackBoxStats(param1,param2,param3);
      }
      
      public function inState(param1:uint) : Boolean
      {
         return this._ownerCastedBase.inState(param1);
      }
      
      public function getState() : uint
      {
         return this._ownerCastedBase.getState();
      }
      
      public function setState(param1:uint) : void
      {
         this._ownerCastedBase.setState(param1);
      }
      
      public function extraHitTests(param1:Number, param2:Number, param3:InteractiveSprite) : Boolean
      {
         if(Boolean(param3.APIInstance) && Boolean(_api) && "extraHitTests" in _api)
         {
            return _api.extraHitTests(param1,param2,param3.APIInstance.instance);
         }
         return false;
      }
      
      public function takeDamage(param1:Object, param2:*, param3:Rectangle = null) : Boolean
      {
         var _loc4_:InteractiveSprite = param2 ? param2.$ext.getAPI().owner : null;
         var _loc5_:HitBoxSprite = param3 ? new HitBoxSprite(HitBoxSprite.ATTACK,param3) : null;
         var _loc6_:int = -1;
         var _loc7_:int = -1;
         if(param1.player_id)
         {
            _loc6_ = int(param1.player_id);
         }
         else if(_loc4_)
         {
            _loc6_ = _loc4_.getID();
         }
         if(param1.team_id)
         {
            _loc7_ = int(param1.team_id);
         }
         else if(_loc4_)
         {
            _loc7_ = _loc4_.Team;
         }
         var _loc8_:AttackDamage = new AttackDamage(_loc6_,_loc4_);
         _loc8_.TeamID = _loc7_;
         if(!param1.atk_id)
         {
            _loc8_.AttackID = Utils.getUID();
         }
         _loc8_.importAttackDamageData(param1);
         return this._ownerCastedBase.takeDamage(_loc8_,_loc5_);
      }
      
      public function getBoundsRect() : Rectangle
      {
         return this._ownerCastedBase.BoundsRect;
      }
      
      public function getCurrentAnimation() : String
      {
         return this._ownerCastedBase.CurrentFrame;
      }
      
      public function applyKnockback(param1:Number, param2:Number) : void
      {
         this._ownerCastedBase.applyKnockback(param1,param2);
      }
      
      public function applyKnockbackSpeed(param1:Number, param2:Number) : void
      {
         this._ownerCastedBase.applyKnockbackSpeed(param1,param2);
      }
      
      public function resetFade(param1:int = 15) : void
      {
         this._ownerCastedBase.resetFade(param1);
      }
      
      public function fadeIn() : void
      {
         this._ownerCastedBase.fadeIn();
      }
      
      public function fadeOut() : void
      {
         this._ownerCastedBase.fadeOut();
      }
      
      public function inHitStun() : Boolean
      {
         return this._ownerCastedBase.inHitStun();
      }
      
      public function inParalysis() : Boolean
      {
         return this._ownerCastedBase.inParalysis();
      }
      
      public function getWarningCollisions() : Boolean
      {
         return this._ownerCastedBase.inParalysis();
      }
      
      public function inLowerLeftWarningBounds() : Boolean
      {
         return this._ownerCastedBase.inLowerLeftWarningBounds();
      }
      
      public function inUpperLeftWarningBounds() : Boolean
      {
         return this._ownerCastedBase.inUpperLeftWarningBounds();
      }
      
      public function inLowerRightWarningBounds() : Boolean
      {
         return this._ownerCastedBase.inLowerRightWarningBounds();
      }
      
      public function inUpperRightWarningBounds() : Boolean
      {
         return this._ownerCastedBase.inUpperRightWarningBounds();
      }
      
      public function setTargetInterrupt(param1:Function) : void
      {
         this._ownerCastedBase.TargetInterrupt = param1;
      }
      
      public function createSelfPlatform(param1:Number, param2:Number, param3:Number, param4:Number, param5:Boolean = true, param6:Class = null) : *
      {
         var _loc7_:MovingPlatform = this._ownerCastedBase.createSelfPlatform(param1,param2,param3,param4,param5,param6);
         return _loc7_.APIInstance ? _loc7_.APIInstance.instance : null;
      }
      
      public function createSelfPlatformWithMC(param1:MovieClip, param2:Boolean = true, param3:Class = null) : *
      {
         var _loc4_:MovingPlatform = this._ownerCastedBase.createSelfPlatformWithMC(param1,param2,param3);
         return _loc4_.APIInstance ? _loc4_.APIInstance.instance : null;
      }
      
      public function removeSelfPlatform() : void
      {
         this._ownerCastedBase.removeSelfPlatform();
      }
      
      public function setDamage(param1:Number) : void
      {
         this._ownerCastedBase.setDamage(param1);
      }
      
      public function getDamage() : Number
      {
         return this._ownerCastedBase.getDamage();
      }
      
      public function dealDamage(param1:Number) : void
      {
         this._ownerCastedBase.dealDamage(param1);
      }
      
      public function healDamage(param1:Number) : void
      {
         this._ownerCastedBase.healDamage(param1);
      }
      
      public function isFading() : Boolean
      {
         return this._ownerCastedBase.isFading();
      }
      
      public function forceOnGround(param1:Number = 200) : void
      {
         this._ownerCastedBase.forceOnGroundAPI(param1);
      }
      
      public function getSizeRatio() : Number
      {
         return this._ownerCastedBase.SizeRatio;
      }
      
      public function setSizeRatio(param1:Number) : void
      {
         this._ownerCastedBase.SizeRatio = param1;
      }
      
      public function setVisibility(param1:Boolean) : void
      {
         this._ownerCastedBase.setVisibility(param1);
      }
      
      public function getPreviousAnimation() : String
      {
         return this._ownerCastedBase.PreviousAnimation;
      }
      
      public function getWeight2() : Number
      {
         return this._ownerCastedBase.Weight2;
      }
      
      public function setWeight2(param1:Number) : void
      {
         this._ownerCastedBase.Weight2 = param1;
      }
      
      public function getLastHurtAttackBoxStats() : Object
      {
         var _loc1_:Object = null;
         var _loc2_:InteractiveSprite = null;
         if(this._ownerCastedBase.LastHitObject)
         {
            _loc1_ = this._ownerCastedBase.LastHitObject.exportAttackDamageData();
            _loc2_ = this._ownerCastedBase.LastHitObject.Owner;
            if(Boolean(_loc2_) && Boolean(_loc2_.APIInstance) && Boolean(_loc2_.APIInstance.instance))
            {
               _loc1_.owner = _loc2_.APIInstance.instance;
            }
            else
            {
               delete _loc1_.owner;
            }
            return _loc1_;
         }
         return null;
      }
      
      public function attachHealthBox(param1:String, param2:String, param3:String, param4:int = -1, param5:String = null, param6:int = -1) : void
      {
         this._ownerCastedBase.attachHealthBox(param1,param2,param3,param4,param5,param6);
      }
      
      public function detachHealthBox() : void
      {
         this._ownerCastedBase.detachHealthBox();
      }
      
      public function setColorFilters(param1:Object) : void
      {
         return this._ownerCastedBase.updateColorFilterAPI(param1);
      }
      
      public function applyPalette(param1:MovieClip) : void
      {
         this._ownerCastedBase.applyPalette(param1);
      }
      
      public function throbDamageCounter() : void
      {
         this._ownerCastedBase.throbDamageCounter();
      }
      
      public function getInvincibility() : Boolean
      {
         return this._ownerCastedBase.Invincible;
      }
      
      public function getIntangibility() : Boolean
      {
         return this._ownerCastedBase.Intangible;
      }
      
      public function setIntangibility(param1:Boolean) : void
      {
         this._ownerCastedBase.setIntangibility(param1);
      }
      
      public function setInvincibility(param1:Boolean) : void
      {
         this._ownerCastedBase.setInvincibility(param1);
      }
      
      public function getNearestLedge() : MovieClip
      {
         return this._ownerCastedBase.getNearestLedge();
      }
      
      public function getHealthBox() : MovieClip
      {
         return this._ownerCastedBase.HealthBox;
      }
      
      public function forceAttack(param1:String, param2:* = null, param3:Boolean = false) : Boolean
      {
         return this._ownerCastedBase.forceAttack(param1,param2,param3);
      }
      
      public function getPaletteSwapData() : Object
      {
         return {
            "paletteSwap":this._ownerCastedBase.PaletteSwapData,
            "paletteSwapPA":this._ownerCastedBase.PaletteSwapPAData
         };
      }
      
      public function setPaletteSwapData(param1:Object) : void
      {
         if(param1.paletteSwap === null)
         {
            this._ownerCastedBase.PaletteSwapData = null;
         }
         else if(param1.paletteSwap)
         {
            this._ownerCastedBase.PaletteSwapData = param1.paletteSwap;
         }
         if(param1.paletteSwapPA === null)
         {
            this._ownerCastedBase.PaletteSwapPAData = null;
         }
         else if(param1.paletteSwapPA)
         {
            this._ownerCastedBase.PaletteSwapPAData = param1.paletteSwapPA;
         }
      }
   }
}


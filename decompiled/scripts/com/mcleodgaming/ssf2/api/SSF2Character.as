package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.input.*;
   import com.mcleodgaming.ssf2.items.Item;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   import flash.geom.*;
   
   public class SSF2Character extends SSF2GameObject
   {
      
      protected var _ownerCasted:Character;
      
      public function SSF2Character(param1:Class, param2:Character)
      {
         super(param1,param2);
         this._ownerCasted = Character(param2);
      }
      
      public function get KirbyPower() : String
      {
         return this._ownerCasted.KirbyPower;
      }
      
      public function set KirbyPower(param1:String) : void
      {
         this._ownerCasted.KirbyPower = param1;
      }
      
      public function getCurrentKirbyPower() : String
      {
         return this._ownerCasted.getCurrentKirbyPower();
      }
      
      public function shootOutOpponent() : void
      {
         this._ownerCasted.shootOutOpponent();
      }
      
      public function activateFinalForm() : void
      {
         this._ownerCasted.activateFinalForm();
      }
      
      public function dropItem(param1:Boolean = false) : void
      {
         this._ownerCasted.dropItem(param1);
      }
      
      public function endAttack(param1:String = null, param2:String = null) : void
      {
         this._ownerCasted.endAttack(param1,param2);
      }
      
      public function endFinalForm() : void
      {
         this._ownerCasted.endFinalForm();
      }
      
      public function fireProjectile(param1:*, param2:Number = 0, param3:Number = 0, param4:Boolean = false, param5:Object = null) : *
      {
         var _loc6_:Projectile = this._ownerCasted.fireProjectile(param1,param2,param3,param4,param5);
         return Boolean(_loc6_) && Boolean(_loc6_.APIInstance) ? _loc6_.APIInstance.instance : null;
      }
      
      public function rocketCharacter(param1:Number, param2:Number, param3:Number, param4:Boolean) : void
      {
         this._ownerCasted.rocketCharacter(param1,param2,param3,param4);
      }
      
      public function forceGrabbedHurtFrame(param1:String) : void
      {
         this._ownerCasted.forceGrabbedHurtFrame(param1);
      }
      
      public function generateItem(param1:String, param2:Boolean = false, param3:Boolean = true, param4:Boolean = false) : *
      {
         var _loc5_:Item = this._ownerCasted.generateItem(param1,param2,param3,param4);
         if(Boolean(_loc5_) && Boolean(_loc5_.APIInstance))
         {
            return _loc5_.APIInstance.instance;
         }
         return null;
      }
      
      public function generateCharacterItem(param1:String, param2:String, param3:Boolean = false) : *
      {
         var _loc4_:Item = this._ownerCasted.generateCharacterItem(param1,param2,param3);
         if(Boolean(_loc4_) && Boolean(_loc4_.APIInstance))
         {
            return _loc4_.APIInstance.instance;
         }
         return null;
      }
      
      public function getCharacterStat(param1:String) : *
      {
         return this._ownerCasted.getCharacterStat(param1);
      }
      
      public function getPlayerSetting(param1:String) : *
      {
         return this._ownerCasted.getPlayerSetting(param1);
      }
      
      public function getControls(param1:Boolean = false) : Object
      {
         return this._ownerCasted.getControls(param1);
      }
      
      public function getControlBits(param1:Boolean = false) : int
      {
         return this._ownerCasted.getControlBitsAPI(param1);
      }
      
      public function getCostume() : int
      {
         return this._ownerCasted.CostumeID;
      }
      
      public function setCostume(param1:int, param2:int = -1) : void
      {
         this._ownerCasted.setCostumeAPI(param1,param2);
      }
      
      public function getCPUAction() : int
      {
         return this._ownerCasted.getCPUAction();
      }
      
      public function getCPUForcedAction() : int
      {
         return this._ownerCasted.getCPUForcedAction();
      }
      
      public function setCPUForcedAction(param1:int) : void
      {
         this._ownerCasted.getAI().ForcedAction = param1;
      }
      
      public function getCPULevel() : int
      {
         return this._ownerCasted.getCPULevel();
      }
      
      public function getCPUTarget() : *
      {
         return this._ownerCasted.getCPUTargetAPI();
      }
      
      public function getCurrentAttackFrame() : String
      {
         return this._ownerCasted.getCurrentAttackFrame();
      }
      
      public function getCurrentProjectile() : *
      {
         return this._ownerCasted.getCurrentProjectileAPI();
      }
      
      public function getExecTime() : int
      {
         return this._ownerCasted.getExecTime();
      }
      
      public function getHitsDealtCounter() : int
      {
         return this._ownerCasted.getHitsDealtCounter();
      }
      
      public function getHitsReceivedCounter() : int
      {
         return this._ownerCasted.getHitsReceivedCounter();
      }
      
      public function getGrabbedOpponent() : *
      {
         return this._ownerCasted.getGrabbedOpponentAPI();
      }
      
      public function getGrabbedOpponents() : Array
      {
         var _loc3_:int = 0;
         var _loc1_:Vector.<Character> = this._ownerCasted.Grabbed;
         var _loc2_:Array = [];
         while(_loc3_ < _loc1_.length)
         {
            _loc2_.push(_loc1_[_loc3_].APIInstance.instance);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getGrabber() : *
      {
         var _loc1_:Character = this._ownerCasted.inState(CState.CAUGHT) ? SSF2API.getCharacter(this._ownerCasted.GrabberID) : null;
         if(_loc1_)
         {
            return _loc1_.APIInstance.instance;
         }
         return null;
      }
      
      public function getItem() : *
      {
         return this._ownerCasted.getItemAPI();
      }
      
      public function getLastUsed(param1:String = null) : int
      {
         return this._ownerCasted.getLastUsed(param1);
      }
      
      public function getLives() : int
      {
         return this._ownerCasted.getLives();
      }
      
      public function getShieldPower() : Number
      {
         return this._ownerCasted.getShieldPower();
      }
      
      public function getSizeStatus() : int
      {
         return this._ownerCasted.getSizeStatus();
      }
      
      public function getSmashTimer() : int
      {
         return this._ownerCasted.getSmashTimer();
      }
      
      public function getTeammates() : Array
      {
         return this._ownerCasted.getTeammatesAPI();
      }
      
      public function getTetherCount() : int
      {
         return this._ownerCasted.getTetherCount();
      }
      
      public function gotoGrabbedCharacter() : void
      {
         this._ownerCasted.gotoGrabbedCharacter();
      }
      
      public function grabRelease() : void
      {
         this._ownerCasted.grabRelease();
      }
      
      public function grabReleaseOpponent() : void
      {
         this._ownerCasted.grabReleaseOpponent();
      }
      
      public function importCPUControls(param1:Array) : void
      {
         this._ownerCasted.importCPUControls(param1);
      }
      
      public function initiateCrash() : void
      {
         this._ownerCasted.initiateCrash();
      }
      
      public function isCPU() : Boolean
      {
         return this._ownerCasted.isCPU();
      }
      
      public function isForcedCrash() : Boolean
      {
         return this._ownerCasted.isForcedCrash();
      }
      
      public function isGrabbing() : Boolean
      {
         return this._ownerCasted.Grabbing;
      }
      
      public function isRecovering() : Boolean
      {
         return this._ownerCasted.isRecovering();
      }
      
      public function isCPURecovering() : Boolean
      {
         if(!this._ownerCasted.CpuAI)
         {
            return false;
         }
         return this._ownerCasted.CpuAI.Recovering;
      }
      
      public function isStandby() : Boolean
      {
         return this._ownerCasted.isStandby();
      }
      
      public function confuseAI(param1:int) : void
      {
         if(Boolean(this._ownerCasted) && Boolean(this._ownerCasted.isCPU()) && Boolean(this._ownerCasted.CpuAI))
         {
            this._ownerCasted.CpuAI.beginConfusion(param1);
         }
      }
      
      public function jumpFullyReleased() : Boolean
      {
         return this._ownerCasted.jumpFullyReleased();
      }
      
      public function maxOutJumps() : void
      {
         this._ownerCasted.maxOutJumps();
      }
      
      public function playCharacterSound(param1:String) : int
      {
         return this._ownerCasted.playCharacterSound(param1);
      }
      
      public function playAttackSound(param1:Number = -1) : int
      {
         return this._ownerCasted.playAttackSound(param1);
      }
      
      public function playVoiceSound(param1:Number = -1) : int
      {
         return this._ownerCasted.playVoiceSound(param1);
      }
      
      public function recover(param1:int) : Boolean
      {
         return this._ownerCasted.recover(param1);
      }
      
      public function releaseLedge() : void
      {
         this._ownerCasted.releaseLedge();
      }
      
      public function releaseOpponent() : void
      {
         this._ownerCasted.releaseOpponent();
      }
      
      public function removeItem() : void
      {
         this._ownerCasted.removeItem();
      }
      
      public function replaceCharacter(param1:String, param2:String = null, param3:String = null) : void
      {
         this._ownerCasted.replaceCharacter(param1,param2,param3);
      }
      
      public function resetCPUControls() : void
      {
         this._ownerCasted.resetCPUControls();
      }
      
      public function resetHitsDealtCounter() : void
      {
         this._ownerCasted.resetHitsDealtCounter();
      }
      
      public function resetHitsReceivedCounter() : void
      {
         this._ownerCasted.resetHitsReceivedCounter();
      }
      
      public function resetJumps() : void
      {
         this._ownerCasted.resetJumps();
      }
      
      public function resetMovement(param1:* = null) : void
      {
         this._ownerCasted.resetMovement(param1);
      }
      
      public function resetStaleMoves() : void
      {
         this._ownerCasted.resetStaleMoves();
      }
      
      public function setAttackEnabled(param1:Boolean, param2:String = null, param3:int = -1) : void
      {
         this._ownerCasted.setAttackEnabled(param1,param2,param3);
      }
      
      public function setCPUAttackQueue(param1:String) : void
      {
         this._ownerCasted.setCPUAttackQueue(param1);
      }
      
      public function setInvisibilityTimer(param1:int) : void
      {
         this._ownerCasted.setInvisibilityTimer(param1);
      }
      
      public function setLastUsed(param1:String, param2:int) : void
      {
         this._ownerCasted.setLastUsed(param1,param2);
      }
      
      public function setSizeStatus(param1:int) : void
      {
         this._ownerCasted.setSizeStatus(param1);
      }
      
      public function swapDepthsWithGrabbedOpponent(param1:Boolean) : void
      {
         this._ownerCasted.swapDepthsWithGrabbedOpponent(param1);
      }
      
      public function switchAttack(param1:String, param2:* = null) : void
      {
         this._ownerCasted.switchAttack(param1,param2);
      }
      
      public function switchAttackData(param1:String, param2:String) : void
      {
         this._ownerCasted.switchAttackData(param1,param2);
      }
      
      public function toBounce(param1:* = null) : void
      {
         this._ownerCasted.toBounce(param1);
      }
      
      public function toCrashLand(param1:* = null) : void
      {
         this._ownerCasted.toCrashLand(param1);
      }
      
      public function toHeavyLand(param1:* = null) : void
      {
         this._ownerCasted.toHeavyLand(param1);
      }
      
      public function toHelpless(param1:* = null) : void
      {
         this._ownerCasted.toHelpless(param1);
      }
      
      public function toIdle(param1:* = null) : void
      {
         this._ownerCasted.toIdle(param1);
      }
      
      public function toLand(param1:* = null) : void
      {
         this._ownerCasted.toLand(param1);
      }
      
      public function toToss(param1:* = null) : void
      {
         this._ownerCasted.toToss(param1);
      }
      
      public function toFlying(param1:* = null) : void
      {
         this._ownerCasted.toFlying(param1);
      }
      
      public function toBarrel(param1:* = null) : void
      {
         this._ownerCasted.toBarrel(param1);
      }
      
      public function toGrabbing(param1:* = null) : void
      {
         this._ownerCasted.toGrabbing(param1);
      }
      
      public function toRoll(param1:* = null) : void
      {
         this._ownerCasted.initRoll(this._ownerCasted.isFacingRight());
      }
      
      public function toDodgeRoll(param1:* = null) : void
      {
         this._ownerCasted.initDodgeRoll(this._ownerCasted.isFacingRight());
      }
      
      public function toJumpChamber(param1:* = null) : void
      {
         this._ownerCasted.jumpChamber();
      }
      
      public function toJump(param1:* = null) : void
      {
         this._ownerCasted.initGroundJump();
      }
      
      public function toDoubleJump(param1:* = null) : void
      {
         this._ownerCasted.initMidairJump();
      }
      
      public function tossItem(param1:Number) : void
      {
         this._ownerCasted.tossItem(param1);
      }
      
      public function pickupItem() : Boolean
      {
         if(this._ownerCasted.IsHuman && this._ownerCasted.ID > 0)
         {
            Gamepad.rumbleForPlayer(this._ownerCasted.ID,0.4,0.3,120);
         }
         return this._ownerCasted.pickupItem();
      }
      
      public function updateCharacterStats(param1:Object) : void
      {
         this._ownerCasted.updateCharacterStats(param1);
      }
      
      public function updatePlayerSettings(param1:Object) : void
      {
         this._ownerCasted.updatePlayerSettings(param1);
      }
      
      public function usingCPUControls() : Boolean
      {
         return this._ownerCasted.usingCPUControls();
      }
      
      public function getRank() : int
      {
         this._ownerCasted.updateRanksProxy();
         return this._ownerCasted.getMatchResults().Rank;
      }
      
      public function setRank(param1:int) : void
      {
         this._ownerCasted.getMatchResults().Rank = param1;
      }
      
      public function getForceTransformTime() : int
      {
         return this._ownerCasted.getForceTransformTime();
      }
      
      public function setStarmanInvincibility(param1:int) : void
      {
         this._ownerCasted.starmanEffect(param1);
      }
      
      public function setHurtInterrupt(param1:Function) : void
      {
         _ownerCastedBase.HurtInterrupt = param1;
      }
      
      public function forceTaunt() : void
      {
         this._ownerCasted.forceTaunt();
      }
      
      public function warioWareEffect(param1:Boolean, param2:Boolean) : void
      {
         this._ownerCasted.warioWareEffect(param1,param2);
      }
      
      public function isUsingFinalSmash() : Boolean
      {
         return this._ownerCasted.UsingFinalSmash;
      }
      
      public function grab(param1:int = -1, param2:Boolean = true, param3:Boolean = false, param4:Boolean = false) : Boolean
      {
         return this._ownerCasted.grabAPI(param1,param2,param3,param4);
      }
      
      public function release() : void
      {
         this._ownerCasted.Uncapture();
      }
      
      public function triggerFSCutscene() : void
      {
         this._ownerCasted.triggerFSCutscene();
      }
      
      public function killFSCutscene() : void
      {
         this._ownerCasted.killFSCutscene();
      }
      
      public function getOriginalSizeRatio() : Number
      {
         return this._ownerCasted.OriginalSizeRatio;
      }
      
      public function setOriginalSizeRatio(param1:Number) : void
      {
         this._ownerCasted.OriginalSizeRatio = param1;
      }
      
      public function lockSizeStatus(param1:Boolean) : void
      {
         this._ownerCasted.lockSizeStatus(param1);
      }
      
      public function getStartPosition() : Point
      {
         return new Point(this._ownerCasted.getPlayerSettings().x_start,this._ownerCasted.getPlayerSettings().y_start);
      }
      
      public function setStartPosition(param1:Point) : void
      {
         this._ownerCasted.getPlayerSettings().x_start = param1.x;
         this._ownerCasted.getPlayerSettings().y_start = param1.y;
      }
      
      public function getSpawnPosition() : Point
      {
         return new Point(this._ownerCasted.getPlayerSettings().x_respawn,this._ownerCasted.getPlayerSettings().y_respawn);
      }
      
      public function setSpawnPosition(param1:Point) : void
      {
         this._ownerCasted.getPlayerSettings().x_respawn = param1.x;
         this._ownerCasted.getPlayerSettings().y_respawn = param1.y;
      }
      
      public function setOffScreenIndicatorEnabled(param1:Boolean) : void
      {
         this._ownerCasted.OffScreenIndicatorEnabled = param1;
      }
      
      public function setHumanControl(param1:Boolean, param2:int = 1) : void
      {
         this._ownerCasted.setHumanControl(param1,param2);
      }
      
      public function getStandby() : Boolean
      {
         return this._ownerCasted.isStandby();
      }
      
      public function setStandby(param1:Boolean) : void
      {
         this._ownerCasted.StandBy = param1;
      }
      
      public function getHitLag() : int
      {
         return this._ownerCasted.HitLag;
      }
      
      public function setHitLag(param1:int) : void
      {
         this._ownerCasted.HitLag = param1;
      }
      
      public function grantFinalSmash(param1:* = null) : Boolean
      {
         var _loc2_:Item = param1 ? param1.$ext.getAPI().owner : null;
         if(_loc2_)
         {
            return this._ownerCasted.grantSmashBall(_loc2_);
         }
         if(!this._ownerCasted.HasSmashBall)
         {
            return this._ownerCasted.grantFinalSmash();
         }
         return false;
      }
      
      public function releaseSmashBall() : Boolean
      {
         return this._ownerCasted.releaseSmashBall();
      }
      
      public function setLivesEnabled(param1:Boolean) : void
      {
         this._ownerCasted.setLivesEnabled(param1);
      }
      
      public function setLives(param1:int) : void
      {
         this._ownerCasted.setLives(param1);
      }
      
      public function setMetalStatus(param1:Boolean) : void
      {
         this._ownerCasted.setMetalStatus(param1);
      }
      
      public function getMetalStatus() : Boolean
      {
         return this._ownerCasted.getMetalStatus();
      }
      
      public function getPoison() : Object
      {
         return this._ownerCasted.getPoison();
      }
      
      public function setPoison(param1:int, param2:int = 15, param3:int = 300) : void
      {
         this._ownerCasted.setPoison(param1,param2,param3);
      }
      
      public function hasSmashBallAura() : Boolean
      {
         return this._ownerCasted.HasFinalSmash ? true : false;
      }
      
      public function getFinalSmashCutscene() : MovieClip
      {
         return this._ownerCasted.AttachedFSCutscene;
      }
      
      public function getFinalSmashReticule() : MovieClip
      {
         return this._ownerCasted.AttachedReticule;
      }
      
      public function getMatchStatistics() : Object
      {
         var _loc1_:Object = this._ownerCasted.getMatchResults().exportData();
         delete _loc1_.rank;
         delete _loc1_.swimTime;
         delete _loc1_.transformationTime;
         delete _loc1_.finalSmashCount;
         return Utils.cloneObject(_loc1_);
      }
      
      public function destroy() : void
      {
         return this._ownerCasted.destroy();
      }
      
      public function getKirbyHatMC() : MovieClip
      {
         return this._ownerCasted.KirbyHatMC;
      }
      
      public function getMidairJumpCount() : int
      {
         return this._ownerCasted.JumpCount;
      }
      
      public function setMidairJumpCount(param1:int) : void
      {
         this._ownerCasted.JumpCount = param1;
      }
      
      public function setIASA(param1:Boolean) : void
      {
         this._ownerCasted.updateAttackStats({"IASA":param1});
      }
      
      public function getFinalSmashMeterCharge() : Number
      {
         return this._ownerCasted.FinalSmashMeterCharge;
      }
      
      public function setFinalSmashMeterCharge(param1:Number) : void
      {
         this._ownerCasted.FinalSmashMeterCharge = param1;
      }
   }
}


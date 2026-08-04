package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.items.*;
   import com.mcleodgaming.ssf2.util.*;
   
   public class AttackState
   {
      
      protected var m_owner:InteractiveSprite;
      
      protected var m_isAttacking:Boolean;
      
      protected var m_isForward:Boolean;
      
      protected var m_staleMultiplier:Number;
      
      protected var m_xSpeedAccel:Number;
      
      protected var m_xSpeedAccelAir:Number;
      
      protected var m_xSpeedDecay:Number;
      
      protected var m_xSpeedDecayAir:Number;
      
      protected var m_invincible:Boolean;
      
      protected var m_superArmor:Boolean;
      
      protected var m_heavyArmor:Number;
      
      protected var m_launchResistance:Number;
      
      protected var m_combo_total:int;
      
      protected var m_combo_max:int;
      
      protected var m_forceComboContinue:Boolean;
      
      protected var m_forceTumbleFall:Boolean;
      
      protected var m_forceFallThrough:Boolean;
      
      protected var m_forceGrabbable:Boolean;
      
      protected var m_rocket:Boolean;
      
      protected var m_holdRepeat:Boolean;
      
      protected var m_rotate:Boolean;
      
      protected var m_nextComboFrame:String;
      
      protected var m_atk_id:int;
      
      protected var m_id:int;
      
      protected var m_frame:String;
      
      protected var m_letGo:Boolean;
      
      protected var m_hasLanded:Boolean;
      
      protected var m_exec_time:int;
      
      protected var m_allowControl:Boolean;
      
      protected var m_allowControlGround:Boolean;
      
      protected var m_disable:Boolean;
      
      protected var m_chargedAttacks:Object;
      
      protected var m_direction:Number;
      
      protected var m_reversableAngle:Boolean;
      
      protected var m_chargetime:int;
      
      protected var m_chargetime_max:int;
      
      protected var m_linkCharge:String;
      
      protected var m_charge_retain:Boolean;
      
      protected var m_ignoreChargeKnockback:Boolean;
      
      protected var m_attackType:int;
      
      protected var m_transformed:Boolean;
      
      protected var m_refreshRate:int;
      
      protected var m_refreshRateTimer:int;
      
      protected var m_refreshRateReady:Boolean;
      
      protected var m_resetMovement:Boolean;
      
      protected var m_cancel:Boolean;
      
      protected var m_cancelWhenAirborne:Boolean;
      
      protected var m_cancelSoundOnEnd:Boolean;
      
      protected var m_cancelVoiceOnEnd:Boolean;
      
      protected var m_wasCancelled:Boolean;
      
      protected var m_airCancel:Boolean;
      
      protected var m_airCancelSpecial:Boolean;
      
      protected var m_xloc:Number;
      
      protected var m_yloc:Number;
      
      protected var m_attackDelay:int;
      
      protected var m_mustCharge:Boolean;
      
      protected var m_isAirAttack:Boolean;
      
      protected var m_disableHurtSound:Boolean;
      
      protected var m_disableHurtFallOff:Boolean;
      
      protected var m_disableLastHitUpdate:Boolean;
      
      protected var m_reverseID:int;
      
      protected var m_reverseTeam:int;
      
      protected var m_air_ease:Number;
      
      protected var m_hit_ease:Number;
      
      protected var m_xSpeedCap:Number;
      
      protected var m_homingTarget:InteractiveSprite;
      
      protected var m_homingSpeed:Number;
      
      protected var m_disableJump:Boolean;
      
      protected var m_jumpCancelAttack:Boolean;
      
      protected var m_doubleJumpCancelAttack:Boolean;
      
      protected var m_allowJump:Boolean;
      
      protected var m_allowFastFall:Boolean;
      
      protected var m_allowRun:Boolean;
      
      protected var m_allowTurn:Boolean;
      
      protected var m_allowDoubleJump:Boolean;
      
      protected var m_allowFullInterrupt:Boolean;
      
      protected var m_linkFrames:Boolean;
      
      protected var m_isTurning:Boolean;
      
      protected var m_isAccelerating:Boolean;
      
      protected var m_isThrow:Boolean;
      
      protected var m_chargeInAir:Boolean;
      
      protected var m_canFallOff:Boolean;
      
      protected var m_canBeAbsorbed:Boolean;
      
      protected var m_maintainSpeed:Boolean;
      
      protected var m_secondaryAttack:String;
      
      protected var m_sizeStatus:int;
      
      protected var m_facedLedgesOnly:Boolean;
      
      protected var m_canGrabInverseLedges:Boolean;
      
      protected var m_ledgeFrame:String;
      
      protected var m_ignorePlatformInfluence:Boolean;
      
      protected var m_IASA:Boolean;
      
      protected var m_grabBehind:Boolean;
      
      protected var m_attackRatio:Number;
      
      protected var m_hasClanked:Boolean;
      
      public function AttackState(param1:InteractiveSprite = null)
      {
         super();
         this.m_owner = param1;
         this.m_isAttacking = false;
         this.m_isForward = true;
         this.m_staleMultiplier = 1.05;
         this.m_xSpeedAccel = 0;
         this.m_xSpeedAccelAir = 0;
         this.m_xSpeedDecay = 0;
         this.m_xSpeedDecayAir = 0;
         this.m_invincible = false;
         this.m_superArmor = false;
         this.m_heavyArmor = 0;
         this.m_launchResistance = 0;
         this.m_combo_total = 0;
         this.m_combo_max = 0;
         this.m_forceComboContinue = false;
         this.m_forceTumbleFall = false;
         this.m_forceFallThrough = false;
         this.m_forceGrabbable = false;
         this.m_rocket = false;
         this.m_holdRepeat = false;
         this.m_rotate = false;
         this.m_nextComboFrame = null;
         this.m_atk_id = Utils.getUID();
         this.m_id = Utils.getUID();
         this.m_frame = null;
         this.m_letGo = false;
         this.m_hasLanded = true;
         this.m_exec_time = 0;
         this.m_allowControl = false;
         this.m_allowControlGround = true;
         this.m_chargedAttacks = {};
         this.m_charge_retain = false;
         this.m_chargetime = 0;
         this.m_chargetime_max = 0;
         this.m_linkCharge = null;
         this.m_attackType = 0;
         this.m_transformed = false;
         this.m_refreshRate = 50;
         this.m_refreshRateTimer = 1;
         this.m_refreshRateReady = true;
         this.m_resetMovement = false;
         this.m_cancel = false;
         this.m_cancelWhenAirborne = true;
         this.m_cancelSoundOnEnd = false;
         this.m_cancelVoiceOnEnd = false;
         this.m_wasCancelled = false;
         this.m_airCancel = false;
         this.m_airCancelSpecial = false;
         this.m_xloc = 0;
         this.m_yloc = 0;
         this.m_attackDelay = 0;
         this.m_mustCharge = false;
         this.m_isAirAttack = false;
         this.m_disableHurtSound = false;
         this.m_disableHurtFallOff = false;
         this.m_disableLastHitUpdate = false;
         this.m_reverseID = -1;
         this.m_reverseTeam = -1;
         this.m_air_ease = -1;
         this.m_hit_ease = 0;
         this.m_xSpeedCap = -1;
         this.m_homingTarget = null;
         this.m_homingSpeed = -1;
         this.m_disableJump = false;
         this.m_jumpCancelAttack = false;
         this.m_doubleJumpCancelAttack = false;
         this.m_allowJump = false;
         this.m_allowFastFall = true;
         this.m_allowRun = false;
         this.m_allowTurn = false;
         this.m_allowDoubleJump = false;
         this.m_allowFullInterrupt = false;
         this.m_linkFrames = false;
         this.m_isTurning = false;
         this.m_isAccelerating = false;
         this.m_isThrow = false;
         this.m_chargeInAir = true;
         this.m_canFallOff = false;
         this.m_canBeAbsorbed = false;
         this.m_maintainSpeed = false;
         this.m_secondaryAttack = null;
         this.m_sizeStatus = 0;
         this.m_facedLedgesOnly = false;
         this.m_canGrabInverseLedges = true;
         this.m_ledgeFrame = null;
         this.m_ignorePlatformInfluence = false;
         this.m_IASA = false;
         this.m_grabBehind = false;
         this.m_attackRatio = 1;
         this.m_hasClanked = false;
      }
      
      public function simpleReset() : void
      {
         this.m_isAttacking = false;
         this.m_isForward = true;
         this.m_staleMultiplier = 1.05;
         this.m_xSpeedAccel = 0;
         this.m_xSpeedAccelAir = 0;
         this.m_xSpeedDecay = 0;
         this.m_xSpeedDecayAir = 0;
         this.m_invincible = false;
         this.m_superArmor = false;
         this.m_heavyArmor = 0;
         this.m_launchResistance = 0;
         this.m_combo_total = 0;
         this.m_combo_max = 0;
         this.m_forceComboContinue = false;
         this.m_forceTumbleFall = false;
         this.m_forceFallThrough = false;
         this.m_forceGrabbable = false;
         this.m_rocket = false;
         this.m_holdRepeat = false;
         this.m_rotate = false;
         this.m_nextComboFrame = null;
         this.m_frame = null;
         this.m_letGo = false;
         this.m_hasLanded = true;
         this.m_exec_time = 0;
         this.m_allowControl = false;
         this.m_allowControlGround = true;
         this.m_chargedAttacks = {};
         this.m_charge_retain = false;
         this.m_chargetime = 0;
         this.m_chargetime_max = 0;
         this.m_linkCharge = null;
         this.m_attackType = 0;
         this.m_transformed = false;
         this.m_refreshRate = 50;
         this.m_resetMovement = false;
         this.m_cancel = false;
         this.m_cancelWhenAirborne = true;
         this.m_cancelSoundOnEnd = false;
         this.m_cancelVoiceOnEnd = false;
         this.m_wasCancelled = false;
         this.m_airCancel = false;
         this.m_airCancelSpecial = false;
         this.m_xloc = 0;
         this.m_yloc = 0;
         this.m_attackDelay = 0;
         this.m_mustCharge = false;
         this.m_isAirAttack = false;
         this.m_disableHurtSound = false;
         this.m_disableHurtFallOff = false;
         this.m_disableLastHitUpdate = false;
         this.m_reverseID = -1;
         this.m_reverseTeam = -1;
         this.m_air_ease = -1;
         this.m_hit_ease = 0;
         this.m_xSpeedCap = -1;
         this.m_homingTarget = null;
         this.m_homingSpeed = -1;
         this.m_disableJump = false;
         this.m_jumpCancelAttack = false;
         this.m_doubleJumpCancelAttack = false;
         this.m_allowJump = false;
         this.m_allowFastFall = true;
         this.m_allowRun = false;
         this.m_allowTurn = false;
         this.m_allowDoubleJump = false;
         this.m_allowFullInterrupt = false;
         this.m_linkFrames = false;
         this.m_isTurning = false;
         this.m_isAccelerating = false;
         this.m_isThrow = false;
         this.m_chargeInAir = true;
         this.m_canFallOff = false;
         this.m_canBeAbsorbed = false;
         this.m_maintainSpeed = false;
         this.m_secondaryAttack = null;
         this.m_sizeStatus = 0;
         this.m_facedLedgesOnly = false;
         this.m_canGrabInverseLedges = true;
         this.m_ledgeFrame = null;
         this.m_ignorePlatformInfluence = false;
         this.m_IASA = false;
         this.m_grabBehind = false;
         this.m_attackRatio = 1;
         this.m_hasClanked = false;
      }
      
      public function syncState(param1:AttackState) : void
      {
         this.m_isForward = param1.IsForward;
         this.m_id = param1.ID;
         this.m_atk_id = param1.AttackID;
         this.m_isAirAttack = param1.IsAirAttack;
         this.m_isThrow = param1.IsThrow;
         this.m_attackRatio = param1.AttackRatio;
         this.m_sizeStatus = param1.SizeStatus;
         this.m_disableHurtSound = param1.DisableHurtSound;
         this.m_xloc = param1.XLoc;
         this.m_yloc = param1.YLoc;
         this.m_owner = param1.Owner;
         this.m_chargetime = param1.ChargeTime;
         this.m_chargetime_max = param1.ChargeTimeMax;
         this.m_staleMultiplier = param1.StaleMultiplier;
         this.m_frame = param1.Frame;
      }
      
      public function get Owner() : InteractiveSprite
      {
         return this.m_owner;
      }
      
      public function get IsAttacking() : Boolean
      {
         return this.m_isAttacking;
      }
      
      public function get IsForward() : Boolean
      {
         return this.m_isForward;
      }
      
      public function get StaleMultiplier() : Number
      {
         return this.m_staleMultiplier;
      }
      
      public function get XSpeedAccel() : Number
      {
         return this.m_xSpeedAccel;
      }
      
      public function get XSpeedAccelAir() : Number
      {
         return this.m_xSpeedAccelAir;
      }
      
      public function get XSpeedDecay() : Number
      {
         return this.m_xSpeedDecay;
      }
      
      public function get XSpeedDecayAir() : Number
      {
         return this.m_xSpeedDecayAir;
      }
      
      public function get Invincible() : Boolean
      {
         return this.m_invincible;
      }
      
      public function get SuperArmor() : Boolean
      {
         return this.m_superArmor;
      }
      
      public function get HeavyArmor() : Number
      {
         return this.m_heavyArmor;
      }
      
      public function get LaunchResistance() : Number
      {
         return this.m_launchResistance;
      }
      
      public function get ComboTotal() : int
      {
         return this.m_combo_total;
      }
      
      public function set ComboTotal(param1:int) : void
      {
         this.m_combo_total = param1;
      }
      
      public function get ComboMax() : int
      {
         return this.m_combo_max;
      }
      
      public function set ComboMax(param1:int) : void
      {
         this.m_combo_max = param1;
      }
      
      public function get ForceComboContinue() : Boolean
      {
         return this.m_forceComboContinue;
      }
      
      public function get ForceTumbleFall() : Boolean
      {
         return this.m_forceTumbleFall;
      }
      
      public function get ForceFallThrough() : Boolean
      {
         return this.m_forceFallThrough;
      }
      
      public function get ForceGrabbable() : Boolean
      {
         return this.m_forceGrabbable;
      }
      
      public function get Rocket() : Boolean
      {
         return this.m_rocket;
      }
      
      public function get HoldRepeat() : Boolean
      {
         return this.m_holdRepeat;
      }
      
      public function get Rotate() : Boolean
      {
         return this.m_rotate;
      }
      
      public function get NextComboFrame() : String
      {
         return this.m_nextComboFrame;
      }
      
      public function get AttackID() : int
      {
         return this.m_atk_id;
      }
      
      public function get ID() : int
      {
         return this.m_id;
      }
      
      public function get Frame() : String
      {
         return this.m_frame;
      }
      
      public function get LetGo() : Boolean
      {
         return this.m_letGo;
      }
      
      public function get HasLanded() : Boolean
      {
         return this.m_hasLanded;
      }
      
      public function get ExecTime() : int
      {
         return this.m_exec_time;
      }
      
      public function get AllowControl() : Boolean
      {
         return this.m_allowControl;
      }
      
      public function get AllowControlGround() : Boolean
      {
         return this.m_allowControlGround;
      }
      
      public function get ChargedAttacks() : Object
      {
         return this.m_chargedAttacks;
      }
      
      public function get ChargeTime() : int
      {
         return this.m_chargetime;
      }
      
      public function get ChargeTimeMax() : int
      {
         return this.m_chargetime_max;
      }
      
      public function get LinkCharge() : String
      {
         return this.m_linkCharge;
      }
      
      public function get AttackType() : int
      {
         return this.m_attackType;
      }
      
      public function get Transformed() : Boolean
      {
         return this.m_transformed;
      }
      
      public function get RefreshRate() : int
      {
         return this.m_refreshRate;
      }
      
      public function get RefreshRateTimer() : int
      {
         return this.m_refreshRateTimer;
      }
      
      public function get RefreshRateReady() : Boolean
      {
         return this.m_refreshRateReady;
      }
      
      public function get Cancel() : Boolean
      {
         return this.m_cancel;
      }
      
      public function get CancelWhenAirborne() : Boolean
      {
         return this.m_cancelWhenAirborne;
      }
      
      public function get CancelSoundOnEnd() : Boolean
      {
         return this.m_cancelSoundOnEnd;
      }
      
      public function get CancelVoiceOnEnd() : Boolean
      {
         return this.m_cancelVoiceOnEnd;
      }
      
      public function get WasCancelled() : Boolean
      {
         return this.m_wasCancelled;
      }
      
      public function get AirCancel() : Boolean
      {
         return this.m_airCancel;
      }
      
      public function get AirCancelSpecial() : Boolean
      {
         return this.m_airCancelSpecial;
      }
      
      public function get XLoc() : Number
      {
         return this.m_xloc;
      }
      
      public function get YLoc() : Number
      {
         return this.m_yloc;
      }
      
      public function get AttackDelay() : int
      {
         return this.m_attackDelay;
      }
      
      public function get MustCharge() : Boolean
      {
         return this.m_mustCharge;
      }
      
      public function get IsAirAttack() : Boolean
      {
         return this.m_isAirAttack;
      }
      
      public function get DisableHurtSound() : Boolean
      {
         return this.m_disableHurtSound;
      }
      
      public function get DisableHurtFallOff() : Boolean
      {
         return this.m_disableHurtFallOff;
      }
      
      public function get DisableLastHitUpdate() : Boolean
      {
         return this.m_disableLastHitUpdate;
      }
      
      public function get ReverseID() : int
      {
         return this.m_reverseID;
      }
      
      public function get ReverseTeam() : int
      {
         return this.m_reverseTeam;
      }
      
      public function get AirEase() : Number
      {
         return this.m_air_ease;
      }
      
      public function get HitEase() : Number
      {
         return this.m_hit_ease;
      }
      
      public function get XSpeedCap() : Number
      {
         return this.m_xSpeedCap;
      }
      
      public function get HomingTarget() : InteractiveSprite
      {
         return this.m_homingTarget;
      }
      
      public function get HomingSpeed() : Number
      {
         return this.m_homingSpeed;
      }
      
      public function get DisableJump() : Boolean
      {
         return this.m_disableJump;
      }
      
      public function get JumpCancelAttack() : Boolean
      {
         return this.m_jumpCancelAttack;
      }
      
      public function get DoubleJumpCancelAttack() : Boolean
      {
         return this.m_doubleJumpCancelAttack;
      }
      
      public function get AllowJump() : Boolean
      {
         return this.m_allowJump;
      }
      
      public function get AllowFastFall() : Boolean
      {
         return this.m_allowFastFall;
      }
      
      public function get AllowRun() : Boolean
      {
         return this.m_allowRun;
      }
      
      public function get AllowTurn() : Boolean
      {
         return this.m_allowTurn;
      }
      
      public function get AllowDoubleJump() : Boolean
      {
         return this.m_allowDoubleJump;
      }
      
      public function get AllowFullInterrupt() : Boolean
      {
         return this.m_allowFullInterrupt;
      }
      
      public function get LinkFrames() : Boolean
      {
         return this.m_linkFrames;
      }
      
      public function get IsTurning() : Boolean
      {
         return this.m_isTurning;
      }
      
      public function get IsAccelerating() : Boolean
      {
         return this.m_isAccelerating;
      }
      
      public function get IsThrow() : Boolean
      {
         return this.m_isThrow;
      }
      
      public function get ChargeInAir() : Boolean
      {
         return this.m_chargeInAir;
      }
      
      public function get SizeStatus() : int
      {
         return this.m_sizeStatus;
      }
      
      public function get FacedLedgesOnly() : Boolean
      {
         return this.m_facedLedgesOnly;
      }
      
      public function get CanGrabInverseLedges() : Boolean
      {
         return this.m_canGrabInverseLedges;
      }
      
      public function get LedgeFrame() : String
      {
         return this.m_ledgeFrame;
      }
      
      public function get IgnorePlatformInfluence() : Boolean
      {
         return this.m_ignorePlatformInfluence;
      }
      
      public function get IASA() : Boolean
      {
         return this.m_IASA;
      }
      
      public function get GrabBehind() : Boolean
      {
         return this.m_grabBehind;
      }
      
      public function get AttackRatio() : Number
      {
         return this.m_attackRatio;
      }
      
      public function get ChargeRetain() : Boolean
      {
         return this.m_charge_retain;
      }
      
      public function get IgnoreChargeKnockback() : Boolean
      {
         return this.m_ignoreChargeKnockback;
      }
      
      public function get ResetMovement() : Boolean
      {
         return this.m_resetMovement;
      }
      
      public function get CanFallOff() : Boolean
      {
         return this.m_canFallOff;
      }
      
      public function get CanBeAbsorbed() : Boolean
      {
         return this.m_canBeAbsorbed;
      }
      
      public function get MaintainSpeed() : Boolean
      {
         return this.m_maintainSpeed;
      }
      
      public function get SecondaryAttack() : String
      {
         return this.m_secondaryAttack;
      }
      
      public function get HasClanked() : Boolean
      {
         return this.m_hasClanked;
      }
      
      public function set Owner(param1:InteractiveSprite) : void
      {
         this.m_owner = param1;
      }
      
      public function set IsAttacking(param1:Boolean) : void
      {
         this.m_isAttacking = param1;
      }
      
      public function set IsForward(param1:Boolean) : void
      {
         this.m_isForward = param1;
      }
      
      public function set StaleMultiplier(param1:Number) : void
      {
         this.m_staleMultiplier = param1;
      }
      
      public function set XSpeedAccel(param1:Number) : void
      {
         this.m_xSpeedAccel = param1;
      }
      
      public function set XSpeedAccelAir(param1:Number) : void
      {
         this.m_xSpeedAccelAir = param1;
      }
      
      public function set XSpeedDecay(param1:Number) : void
      {
         this.m_xSpeedDecay = param1;
      }
      
      public function set XSpeedDecayAir(param1:Number) : void
      {
         this.m_xSpeedDecayAir = param1;
      }
      
      public function set Invincible(param1:Boolean) : void
      {
         this.m_invincible = param1;
      }
      
      public function set SuperArmor(param1:Boolean) : void
      {
         this.m_superArmor = param1;
      }
      
      public function set HeavyArmor(param1:Number) : void
      {
         this.m_heavyArmor = param1;
      }
      
      public function set LaunchResistance(param1:Number) : void
      {
         this.m_launchResistance = param1;
      }
      
      public function set ForceComboContinue(param1:Boolean) : void
      {
         this.m_forceComboContinue = param1;
      }
      
      public function set ForceTumbleFall(param1:Boolean) : void
      {
         this.m_forceTumbleFall = param1;
      }
      
      public function set ForceFallThrough(param1:Boolean) : void
      {
         this.m_forceFallThrough = param1;
      }
      
      public function set ForceGrabbable(param1:Boolean) : void
      {
         this.m_forceGrabbable = param1;
      }
      
      public function set Rocket(param1:Boolean) : void
      {
         this.m_rocket = param1;
      }
      
      public function set HoldRepeat(param1:Boolean) : void
      {
         this.m_holdRepeat = param1;
      }
      
      public function set Rotate(param1:Boolean) : void
      {
         this.m_rotate = param1;
      }
      
      public function set NextComboFrame(param1:String) : void
      {
         this.m_nextComboFrame = param1;
      }
      
      public function set AttackID(param1:int) : void
      {
         this.m_atk_id = param1;
      }
      
      public function set ID(param1:int) : void
      {
         this.m_id = param1;
      }
      
      public function set Frame(param1:String) : void
      {
         this.m_frame = param1;
      }
      
      public function set LetGo(param1:Boolean) : void
      {
         this.m_letGo = param1;
      }
      
      public function set HasLanded(param1:Boolean) : void
      {
         this.m_hasLanded = param1;
      }
      
      public function set ExecTime(param1:int) : void
      {
         this.m_exec_time = param1;
      }
      
      public function set AllowControl(param1:Boolean) : void
      {
         this.m_allowControl = param1;
      }
      
      public function set AllowControlGround(param1:Boolean) : void
      {
         this.m_allowControlGround = param1;
      }
      
      public function set ChargedAttacks(param1:Object) : void
      {
         this.m_chargedAttacks = param1;
      }
      
      public function set ChargeTime(param1:int) : void
      {
         this.m_chargetime = param1;
      }
      
      public function set ChargeTimeMax(param1:int) : void
      {
         this.m_chargetime_max = param1;
      }
      
      public function set LinkCharge(param1:String) : void
      {
         this.m_linkCharge = param1;
      }
      
      public function set AttackType(param1:int) : void
      {
         this.m_attackType = param1;
      }
      
      public function set Transformed(param1:Boolean) : void
      {
         this.m_transformed = param1;
      }
      
      public function set RefreshRate(param1:int) : void
      {
         this.m_refreshRate = param1;
      }
      
      public function set RefreshRateTimer(param1:int) : void
      {
         if(this.m_refreshRateReady)
         {
            this.m_refreshRateTimer = param1;
         }
      }
      
      public function set RefreshRateReady(param1:Boolean) : void
      {
         this.m_refreshRateReady = param1;
      }
      
      public function set Cancel(param1:Boolean) : void
      {
         this.m_cancel = param1;
      }
      
      public function set CancelWhenAirborne(param1:Boolean) : void
      {
         this.m_cancelWhenAirborne = param1;
      }
      
      public function set CancelSoundOnEnd(param1:Boolean) : void
      {
         this.m_cancelSoundOnEnd = param1;
      }
      
      public function set CancelVoiceOnEnd(param1:Boolean) : void
      {
         this.m_cancelVoiceOnEnd = param1;
      }
      
      public function set WasCancelled(param1:Boolean) : void
      {
         this.m_wasCancelled = param1;
      }
      
      public function set AirCancel(param1:Boolean) : void
      {
         this.m_airCancel = param1;
      }
      
      public function set AirCancelSpecial(param1:Boolean) : void
      {
         this.m_airCancelSpecial = param1;
      }
      
      public function set XLoc(param1:Number) : void
      {
         this.m_xloc = param1;
      }
      
      public function set YLoc(param1:Number) : void
      {
         this.m_yloc = param1;
      }
      
      public function set AttackDelay(param1:int) : void
      {
         this.m_attackDelay = param1;
      }
      
      public function set MustCharge(param1:Boolean) : void
      {
         this.m_mustCharge = param1;
      }
      
      public function set IsAirAttack(param1:Boolean) : void
      {
         this.m_isAirAttack = param1;
      }
      
      public function set DisableHurtSound(param1:Boolean) : void
      {
         this.m_disableHurtSound = param1;
      }
      
      public function set DisableHurtFallOff(param1:Boolean) : void
      {
         this.m_disableHurtFallOff = param1;
      }
      
      public function set DisableLastHitUpdate(param1:Boolean) : void
      {
         this.m_disableLastHitUpdate = param1;
      }
      
      public function set ReverseID(param1:int) : void
      {
         this.m_reverseID = param1;
      }
      
      public function set ReverseTeam(param1:int) : void
      {
         this.m_reverseTeam = param1;
      }
      
      public function set AirEase(param1:Number) : void
      {
         this.m_air_ease = param1;
      }
      
      public function set XSpeedCap(param1:Number) : void
      {
         this.m_xSpeedCap = param1;
      }
      
      public function set HitEase(param1:Number) : void
      {
         this.m_hit_ease = param1;
      }
      
      public function set HomingTarget(param1:InteractiveSprite) : void
      {
         this.m_homingTarget = param1;
      }
      
      public function set HomingSpeed(param1:Number) : void
      {
         this.m_homingSpeed = param1;
      }
      
      public function set DisableJump(param1:Boolean) : void
      {
         this.m_disableJump = param1;
      }
      
      public function set JumpCancelAttack(param1:Boolean) : void
      {
         this.m_jumpCancelAttack = param1;
      }
      
      public function set DoubleJumpCancelAttack(param1:Boolean) : void
      {
         this.m_doubleJumpCancelAttack = param1;
      }
      
      public function set AllowJump(param1:Boolean) : void
      {
         this.m_allowJump = param1;
      }
      
      public function set AllowFastFall(param1:Boolean) : void
      {
         this.m_allowFastFall = param1;
      }
      
      public function set AllowRun(param1:Boolean) : void
      {
         this.m_allowRun = param1;
      }
      
      public function set AllowTurn(param1:Boolean) : void
      {
         this.m_allowTurn = param1;
      }
      
      public function set AllowDoubleJump(param1:Boolean) : void
      {
         this.m_allowDoubleJump = param1;
      }
      
      public function set AllowFullInterrupt(param1:Boolean) : void
      {
         this.m_allowFullInterrupt = param1;
      }
      
      public function set LinkFrames(param1:Boolean) : void
      {
         this.m_linkFrames = param1;
      }
      
      public function set IsTurning(param1:Boolean) : void
      {
         this.m_isTurning = param1;
      }
      
      public function set IsAccelerating(param1:Boolean) : void
      {
         this.m_isAccelerating = param1;
      }
      
      public function set IsThrow(param1:Boolean) : void
      {
         this.m_isThrow = param1;
      }
      
      public function set ChargeInAir(param1:Boolean) : void
      {
         this.m_chargeInAir = param1;
      }
      
      public function set SizeStatus(param1:int) : void
      {
         this.m_sizeStatus = param1;
      }
      
      public function set FacedLedgesOnly(param1:Boolean) : void
      {
         this.m_facedLedgesOnly = param1;
      }
      
      public function set CanGrabInverseLedges(param1:Boolean) : void
      {
         this.m_canGrabInverseLedges = param1;
      }
      
      public function set AttackRatio(param1:Number) : void
      {
         this.m_attackRatio = param1;
      }
      
      public function set LedgeFrame(param1:String) : void
      {
         this.m_ledgeFrame = param1;
      }
      
      public function set IgnorePlatformInfluence(param1:Boolean) : void
      {
         this.m_ignorePlatformInfluence = param1;
      }
      
      public function set IASA(param1:Boolean) : void
      {
         this.m_IASA = param1;
      }
      
      public function set GrabBehind(param1:Boolean) : void
      {
         this.m_grabBehind = param1;
      }
      
      public function set ChargeRetain(param1:Boolean) : void
      {
         this.m_charge_retain = param1;
      }
      
      public function set IgnoreChargeKnockback(param1:Boolean) : void
      {
         this.m_ignoreChargeKnockback = param1;
      }
      
      public function set ResetMovement(param1:Boolean) : void
      {
         this.m_resetMovement = param1;
      }
      
      public function set CanFallOff(param1:Boolean) : void
      {
         this.m_canFallOff = param1;
      }
      
      public function set CanBeAbsorbed(param1:Boolean) : void
      {
         this.m_canBeAbsorbed = param1;
      }
      
      public function set MaintainSpeed(param1:Boolean) : void
      {
         this.m_maintainSpeed = param1;
      }
      
      public function set SecondaryAttack(param1:String) : void
      {
         this.m_secondaryAttack = param1;
      }
      
      public function set HasClanked(param1:Boolean) : void
      {
         this.m_hasClanked = param1;
      }
      
      public function importAttackStateData(param1:Object) : void
      {
         var _loc2_:* = undefined;
         for(_loc2_ in param1)
         {
            if(this["m_" + _loc2_] !== undefined)
            {
               this["m_" + _loc2_] = param1[_loc2_];
            }
            else
            {
               trace("You tried to set \"m_" + _loc2_ + "\" but it doesn\'t exist in the AttackState class.");
            }
         }
      }
      
      public function getVar(param1:String) : *
      {
         if(this["m_" + param1] !== undefined)
         {
            return this["m_" + param1];
         }
         return null;
      }
   }
}


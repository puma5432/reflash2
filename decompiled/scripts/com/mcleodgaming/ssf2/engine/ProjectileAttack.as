package com.mcleodgaming.ssf2.engine
{
   public class ProjectileAttack extends InteractiveSpriteStats
   {
      
      protected var m_statsName:String;
      
      protected var m_inheritPalette:Boolean;
      
      protected var m_time_max:int;
      
      protected var m_xdecay:Number;
      
      protected var m_trailEffect:String;
      
      protected var m_trailEffectInterval:int;
      
      protected var m_trailEffectRotate:Boolean;
      
      protected var m_homingSpeed:Number;
      
      protected var m_homingEase:Number;
      
      protected var m_xspeed:Number;
      
      protected var m_yspeed:Number;
      
      protected var m_calcAngle:Boolean;
      
      protected var m_influenceXMovement:Number;
      
      protected var m_influenceYMovement:Number;
      
      protected var m_influenceXFactor:Number;
      
      protected var m_influenceYFactor:Number;
      
      protected var m_controlInitDirection:Boolean;
      
      protected var m_controlDirection:Number;
      
      protected var m_rocketSpeed:Number;
      
      protected var m_rocketDecay:Number;
      
      protected var m_rocketAngleAbsolute:Boolean;
      
      protected var m_rocketRotation:Boolean;
      
      protected var m_rotate:Boolean;
      
      protected var m_cancel:Boolean;
      
      protected var m_cancelSoundOnEnd:Boolean;
      
      protected var m_cancelVoiceOnEnd:Boolean;
      
      protected var m_maxgravity:Number;
      
      protected var m_rideGround:Boolean;
      
      protected var m_disableHurtSound:Boolean;
      
      protected var m_disableHurtFallOff:Boolean;
      
      protected var m_disableLastHitUpdate:Boolean;
      
      protected var m_stale:Boolean;
      
      protected var m_pushCharacters:Boolean;
      
      protected var m_bounce:Number;
      
      protected var m_bounce_decay:Number;
      
      protected var m_bounce_limit:int;
      
      protected var m_bounce_max_height:Number;
      
      protected var m_followUser:Boolean;
      
      protected var m_xoffset:Number;
      
      protected var m_yoffset:Number;
      
      protected var m_canBeReversed:Boolean;
      
      protected var m_canBeAbsorbed:Boolean;
      
      protected var m_canBePocketed:Boolean;
      
      protected var m_sticky:Boolean;
      
      protected var m_latch:Boolean;
      
      protected var m_latch_x_offset:Number;
      
      protected var m_latch_y_offset:Number;
      
      protected var m_suction:Boolean;
      
      protected var m_boomerang:Boolean;
      
      protected var m_limit:int;
      
      protected var m_limitOverwrite:Boolean;
      
      protected var m_linkAttackID:Boolean;
      
      protected var m_lockTrajectory:Boolean;
      
      protected var m_canFallOff:Boolean;
      
      protected var m_noFlip:Boolean;
      
      protected var m_lockSize:Boolean;
      
      protected var m_dangerous:Boolean;
      
      protected var m_suspend:Boolean;
      
      protected var m_sizeStatus:int;
      
      protected var m_attackData:AttackData;
      
      public function ProjectileAttack()
      {
         super();
         this.m_statsName = null;
         this.m_inheritPalette = false;
         this.m_time_max = 60;
         this.m_xdecay = 0;
         this.m_trailEffect = null;
         this.m_trailEffectInterval = 1;
         this.m_trailEffectRotate = false;
         this.m_homingSpeed = -1;
         this.m_homingEase = 1;
         this.m_xspeed = 0;
         this.m_yspeed = 0;
         this.m_calcAngle = false;
         this.m_influenceXMovement = -1;
         this.m_influenceYMovement = -1;
         this.m_influenceXFactor = 1;
         this.m_influenceYFactor = 1;
         this.m_controlInitDirection = false;
         this.m_controlDirection = -1;
         this.m_rocketSpeed = 0;
         this.m_rocketDecay = -1;
         this.m_rocketAngleAbsolute = true;
         this.m_rocketRotation = false;
         this.m_rotate = false;
         this.m_cancel = false;
         this.m_cancelSoundOnEnd = false;
         this.m_cancelVoiceOnEnd = false;
         this.m_maxgravity = 0;
         this.m_rideGround = true;
         this.m_disableHurtSound = false;
         this.m_disableHurtFallOff = false;
         this.m_disableLastHitUpdate = false;
         this.m_stale = true;
         this.m_pushCharacters = false;
         this.m_bounce = 0;
         this.m_bounce_decay = 1;
         this.m_bounce_limit = 0;
         this.m_bounce_max_height = -1;
         this.m_followUser = false;
         this.m_xoffset = 0;
         this.m_yoffset = 0;
         this.m_canBeReversed = true;
         this.m_canBeAbsorbed = true;
         this.m_canBePocketed = true;
         this.m_sticky = false;
         this.m_latch = false;
         this.m_latch_x_offset = 0;
         this.m_latch_y_offset = 0;
         this.m_suction = false;
         this.m_boomerang = false;
         this.m_limit = 10;
         this.m_limitOverwrite = true;
         this.m_linkAttackID = false;
         this.m_lockTrajectory = false;
         this.m_canFallOff = true;
         this.m_noFlip = false;
         this.m_lockSize = false;
         this.m_dangerous = true;
         this.m_suspend = false;
         this.m_sizeStatus = 0;
         m_canReceiveDamage = false;
         m_canReceiveKnockback = false;
         m_canReceiveHits = false;
         this.m_attackData = new AttackData(null,["attack_idle"]);
      }
      
      public function get StatsName() : String
      {
         return this.m_statsName;
      }
      
      public function set StatsName(param1:String) : void
      {
         this.m_statsName = param1;
      }
      
      public function get InheritPalette() : Boolean
      {
         return this.m_inheritPalette;
      }
      
      public function get TimeMax() : int
      {
         return this.m_time_max;
      }
      
      public function get XDecay() : Number
      {
         return this.m_xdecay;
      }
      
      public function set XDecay(param1:Number) : void
      {
         this.m_xdecay = param1;
      }
      
      public function get TrailEffect() : String
      {
         return this.m_trailEffect;
      }
      
      public function get TrailEffectInterval() : int
      {
         return this.m_trailEffectInterval;
      }
      
      public function get TrailEffectRotate() : Boolean
      {
         return this.m_trailEffectRotate;
      }
      
      public function get HomingSpeed() : Number
      {
         return this.m_homingSpeed;
      }
      
      public function set HomingSpeed(param1:Number) : void
      {
         this.m_homingSpeed = param1;
      }
      
      public function get HomingEase() : Number
      {
         return this.m_homingEase;
      }
      
      public function get XSpeed() : Number
      {
         return this.m_xspeed;
      }
      
      public function get YSpeed() : Number
      {
         return this.m_yspeed;
      }
      
      public function get MaxGravity() : Number
      {
         return this.m_maxgravity;
      }
      
      public function get RideGround() : Boolean
      {
         return this.m_rideGround;
      }
      
      public function get CalcAngle() : Boolean
      {
         return this.m_calcAngle;
      }
      
      public function get InfluenceXMovement() : Number
      {
         return this.m_influenceXMovement;
      }
      
      public function get InfluenceYMovement() : Number
      {
         return this.m_influenceYMovement;
      }
      
      public function get InfluenceXFactor() : Number
      {
         return this.m_influenceXFactor;
      }
      
      public function get InfluenceYFactor() : Number
      {
         return this.m_influenceYFactor;
      }
      
      public function get ControlInitDirection() : Boolean
      {
         return this.m_controlInitDirection;
      }
      
      public function get ControlDirection() : Number
      {
         return this.m_controlDirection;
      }
      
      public function get RocketSpeed() : Number
      {
         return this.m_rocketSpeed;
      }
      
      public function set RocketSpeed(param1:Number) : void
      {
         this.m_rocketSpeed = param1;
      }
      
      public function get RocketAngleAbsolute() : Boolean
      {
         return this.m_rocketAngleAbsolute;
      }
      
      public function get RocketDecay() : Number
      {
         return this.m_rocketDecay;
      }
      
      public function get RocketRotation() : Boolean
      {
         return this.m_rocketRotation;
      }
      
      public function get Rotate() : Boolean
      {
         return this.m_rotate;
      }
      
      public function get Cancel() : Boolean
      {
         return this.m_cancel;
      }
      
      public function get CancelSoundOnEnd() : Boolean
      {
         return this.m_cancelSoundOnEnd;
      }
      
      public function get CancelVoiceOnEnd() : Boolean
      {
         return this.m_cancelVoiceOnEnd;
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
      
      public function get Stale() : Boolean
      {
         return this.m_stale;
      }
      
      public function get PushCharacters() : Boolean
      {
         return this.m_pushCharacters;
      }
      
      public function get Bounce() : Number
      {
         return this.m_bounce;
      }
      
      public function set Bounce(param1:Number) : void
      {
         this.m_bounce = param1;
      }
      
      public function get BounceDecay() : Number
      {
         return this.m_bounce_decay;
      }
      
      public function get BounceLimit() : int
      {
         return this.m_bounce_limit;
      }
      
      public function get BounceMaxHeight() : Number
      {
         return this.m_bounce_max_height;
      }
      
      public function get FollowUser() : Boolean
      {
         return this.m_followUser;
      }
      
      public function get XOffset() : Number
      {
         return this.m_xoffset;
      }
      
      public function get YOffset() : Number
      {
         return this.m_yoffset;
      }
      
      public function get CanBeReversed() : Boolean
      {
         return this.m_canBeReversed;
      }
      
      public function set CanBeReversed(param1:Boolean) : void
      {
         this.m_canBeReversed = param1;
      }
      
      public function get CanBeAbsorbed() : Boolean
      {
         return this.m_canBeAbsorbed;
      }
      
      public function get CanBePocketed() : Boolean
      {
         return this.m_canBePocketed;
      }
      
      public function get Sticky() : Boolean
      {
         return this.m_sticky;
      }
      
      public function get Latch() : Boolean
      {
         return this.m_latch;
      }
      
      public function get LatchXOffset() : Number
      {
         return this.m_latch_x_offset;
      }
      
      public function get LatchYOffset() : Number
      {
         return this.m_latch_y_offset;
      }
      
      public function get Suction() : Boolean
      {
         return this.m_suction;
      }
      
      public function get Boomerang() : Boolean
      {
         return this.m_boomerang;
      }
      
      public function get Limit() : int
      {
         return this.m_limit;
      }
      
      public function get LimitOverwrite() : Boolean
      {
         return this.m_limitOverwrite;
      }
      
      public function get LinkAttackID() : Boolean
      {
         return this.m_linkAttackID;
      }
      
      public function get LockTrajectory() : Boolean
      {
         return this.m_lockTrajectory;
      }
      
      public function get CanFallOff() : Boolean
      {
         return this.m_canFallOff;
      }
      
      public function get NoFlip() : Boolean
      {
         return this.m_noFlip;
      }
      
      public function get LockSize() : Boolean
      {
         return this.m_lockSize;
      }
      
      public function get Dangerous() : Boolean
      {
         return this.m_dangerous;
      }
      
      public function get Suspend() : Boolean
      {
         return this.m_suspend;
      }
      
      public function get SizeStatus() : int
      {
         return this.m_sizeStatus;
      }
      
      public function get AttackDataObj() : AttackData
      {
         return this.m_attackData;
      }
      
      public function Clone() : ProjectileAttack
      {
         var _loc1_:Object = this.exportData();
         var _loc2_:ProjectileAttack = new ProjectileAttack();
         _loc2_.importData(_loc1_);
         return _loc2_;
      }
      
      override public function importData(param1:Object) : Boolean
      {
         var _loc2_:* = undefined;
         var _loc3_:Boolean = true;
         for(_loc2_ in param1)
         {
            if(this.m_attackData.getAttack(_loc2_) != null)
            {
               this.m_attackData.getAttack(_loc2_).importAttackData(param1[_loc2_]);
            }
            else if(this["m_" + _loc2_] !== undefined)
            {
               this["m_" + _loc2_] = param1[_loc2_];
            }
            else
            {
               _loc3_ = false;
               trace("You tried to set \"m_" + _loc2_ + "\" but it doesn\'t exist in the ProjectileAttack class. (" + param1["linkage_id"] + ")");
            }
         }
         return _loc3_;
      }
      
      public function importDataCopy(param1:ProjectileAttack) : Boolean
      {
         var _loc2_:* = undefined;
         var _loc3_:Object = null;
         var _loc4_:Boolean = false;
         var _loc5_:* = undefined;
         var _loc6_:AttackObject = null;
         var _loc7_:AttackObject = null;
         for(_loc2_ in param1.AttackDataObj.AttackArray)
         {
            _loc6_ = param1.m_attackData.AttackArray[_loc2_];
            _loc7_ = this.m_attackData.getAttack(_loc6_.Name) != null ? this.m_attackData.getAttack(_loc6_.Name) : new AttackObject(_loc6_.Name);
            _loc7_.importAttackData(_loc6_.exportAttackData());
            this.m_attackData.setAttack(_loc7_.Name,_loc7_);
         }
         _loc3_ = param1.exportData();
         _loc4_ = true;
         for(_loc5_ in _loc3_)
         {
            if(this.m_attackData.getAttack(_loc5_) != null)
            {
               this.m_attackData.getAttack(_loc5_).importAttackData(_loc3_[_loc5_]);
            }
            else if(this["m_" + _loc5_] !== undefined)
            {
               this["m_" + _loc5_] = _loc3_[_loc5_];
            }
         }
         return _loc4_;
      }
      
      override public function exportData() : Object
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:Object = super.exportData();
         var _loc4_:Object = new Object();
         _loc4_.statsName = this.m_statsName;
         _loc4_.inheritPalette = this.m_inheritPalette;
         _loc4_.time_max = this.m_time_max;
         _loc4_.xdecay = this.m_xdecay;
         _loc4_.trailEffect = this.m_trailEffect;
         _loc4_.trailEffectInterval = this.m_trailEffectInterval;
         _loc4_.trailEffectRotate = this.m_trailEffectRotate;
         _loc4_.homingSpeed = this.m_homingSpeed;
         _loc4_.homingEase = this.m_homingEase;
         _loc4_.xspeed = this.m_xspeed;
         _loc4_.yspeed = this.m_yspeed;
         _loc4_.calcAngle = this.m_calcAngle;
         _loc4_.influenceXMovement = this.m_influenceXMovement;
         _loc4_.influenceYMovement = this.m_influenceYMovement;
         _loc4_.influenceXFactor = this.m_influenceXFactor;
         _loc4_.influenceYFactor = this.m_influenceYFactor;
         _loc4_.controlInitDirection = this.m_controlInitDirection;
         _loc4_.controlDirection = this.m_controlDirection;
         _loc4_.rocketSpeed = this.m_rocketSpeed;
         _loc4_.rocketDecay = this.m_rocketDecay;
         _loc4_.rocketAngleAbsolute = this.m_rocketAngleAbsolute;
         _loc4_.rocketRotation = this.m_rocketRotation;
         _loc4_.rotate = this.m_rotate;
         _loc4_.cancel = this.m_cancel;
         _loc4_.cancelSoundOnEnd = this.m_cancelSoundOnEnd;
         _loc4_.cancelVoiceOnEnd = this.m_cancelVoiceOnEnd;
         _loc4_.maxgravity = this.m_maxgravity;
         _loc4_.rideGround = this.m_rideGround;
         _loc4_.disableHurtSound = this.m_disableHurtSound;
         _loc4_.disableHurtFallOff = this.m_disableHurtFallOff;
         _loc4_.disableLastHitUpdate = this.m_disableLastHitUpdate;
         _loc4_.pushCharacters = this.m_pushCharacters;
         _loc4_.bounce = this.m_bounce;
         _loc4_.bounce_decay = this.m_bounce_decay;
         _loc4_.bounce_limit = this.m_bounce_limit;
         _loc4_.bounce_max_height = this.m_bounce_max_height;
         _loc4_.followUser = this.m_followUser;
         _loc4_.xoffset = this.m_xoffset;
         _loc4_.yoffset = this.m_yoffset;
         _loc4_.canBeReversed = this.m_canBeReversed;
         _loc4_.canBeAbsorbed = this.m_canBeAbsorbed;
         _loc4_.canBePocketed = this.m_canBePocketed;
         _loc4_.sticky = this.m_sticky;
         _loc4_.latch = this.m_latch;
         _loc4_.latch_x_offset = this.m_latch_x_offset;
         _loc4_.latch_y_offset = this.m_latch_y_offset;
         _loc4_.suction = this.m_suction;
         _loc4_.boomerang = this.m_boomerang;
         _loc4_.limit = this.m_limit;
         _loc4_.limitOverwrite = this.m_limitOverwrite;
         _loc4_.linkAttackID = this.m_linkAttackID;
         _loc4_.lockTrajectory = this.m_lockTrajectory;
         _loc4_.canFallOff = this.m_canFallOff;
         _loc4_.noFlip = this.m_noFlip;
         _loc4_.lockSize = this.m_lockSize;
         _loc4_.dangerous = this.m_dangerous;
         _loc4_.suspend = this.m_suspend;
         _loc4_.sizeStatus = this.m_sizeStatus;
         for(_loc1_ in this.m_attackData.AttackArray)
         {
            _loc4_[_loc1_] = this.m_attackData.AttackArray[_loc1_].exportAttackData();
         }
         for(_loc2_ in _loc3_)
         {
            if(!(_loc2_ in _loc4_))
            {
               _loc4_[_loc2_] = _loc3_[_loc2_];
            }
         }
         return _loc4_;
      }
      
      public function exportAttackStateData() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.cancelSoundOnEnd = this.m_cancelSoundOnEnd;
         _loc1_.cancelVoiceOnEnd = this.m_cancelVoiceOnEnd;
         _loc1_.sizeStatus = this.m_sizeStatus;
         _loc1_.disableHurtSound = this.m_disableHurtSound;
         _loc1_.disableHurtFallOff = this.m_disableHurtFallOff;
         _loc1_.disableLastHitUpdate = this.m_disableLastHitUpdate;
         return _loc1_;
      }
      
      override public function getVar(param1:String) : *
      {
         if(this["m_" + param1] !== undefined)
         {
            return this["m_" + param1];
         }
         return null;
      }
   }
}


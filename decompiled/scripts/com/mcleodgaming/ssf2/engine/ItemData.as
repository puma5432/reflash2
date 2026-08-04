package com.mcleodgaming.ssf2.engine
{
   public class ItemData extends InteractiveSpriteStats
   {
      
      protected var m_statsName:String;
      
      protected var m_type:String;
      
      protected var m_class_id:String;
      
      protected var m_inheritPalette:Boolean;
      
      protected var m_displayName:String;
      
      protected var m_retainPlayerID:Boolean;
      
      protected var m_disableFlip:Boolean;
      
      protected var m_sizeRatio:Number;
      
      protected var m_canBeReversed:Boolean;
      
      protected var m_canPickup:Boolean;
      
      protected var m_canToss:Boolean;
      
      protected var m_canBackToss:Boolean;
      
      protected var m_canJumpWith:Boolean;
      
      protected var m_canAttackWith:Boolean;
      
      protected var m_canHangWith:Boolean;
      
      protected var m_canShieldWith:Boolean;
      
      protected var m_canRunWith:Boolean;
      
      protected var m_canBePushed:Boolean;
      
      protected var m_pushCharacters:Boolean;
      
      protected var m_time_max:int;
      
      protected var m_max_gravity:Number;
      
      protected var m_effectSound:String;
      
      protected var m_landSound:String;
      
      protected var m_spawnEffect:String;
      
      protected var m_deathEffect:String;
      
      protected var m_bounce:Number;
      
      protected var m_bounce_decay:Number;
      
      protected var m_bounce_limit:int;
      
      protected var m_bounce_max_height:Number;
      
      protected var m_initialBounce:Boolean;
      
      protected var m_slideDecay:Number;
      
      protected var m_dangerous:Boolean;
      
      protected var m_redirects:Array;
      
      protected var m_tossSpeed:Number;
      
      protected var m_rotate:Boolean;
      
      protected var m_spawnLimit:int;
      
      protected var m_attackData:AttackData;
      
      protected var m_projectiles:Object;
      
      public function ItemData()
      {
         super();
         this.m_statsName = null;
         this.m_type = "carryable";
         this.m_class_id = null;
         this.m_inheritPalette = false;
         this.m_displayName = null;
         this.m_retainPlayerID = false;
         this.m_disableFlip = false;
         this.m_sizeRatio = 1;
         this.m_canBeReversed = true;
         this.m_canPickup = false;
         this.m_canToss = true;
         this.m_canBackToss = false;
         this.m_canJumpWith = true;
         this.m_canAttackWith = true;
         this.m_canHangWith = true;
         this.m_canShieldWith = true;
         this.m_canRunWith = true;
         this.m_canBePushed = true;
         this.m_pushCharacters = true;
         this.m_time_max = 750;
         this.m_max_gravity = 5;
         this.m_effectSound = null;
         this.m_landSound = "item_land";
         this.m_spawnEffect = "global_spark";
         this.m_deathEffect = "dust";
         this.m_bounce = 0;
         this.m_bounce_decay = 1;
         this.m_bounce_limit = 0;
         this.m_bounce_max_height = -1;
         this.m_initialBounce = true;
         this.m_slideDecay = 0.85;
         this.m_dangerous = false;
         this.m_tossSpeed = 8;
         this.m_rotate = false;
         this.m_spawnLimit = 8;
         this.m_redirects = [];
         this.m_attackData = new AttackData(null,["attack_idle","attack_toss","attack_hold"]);
         this.m_projectiles = new Object();
      }
      
      public function get StatsName() : String
      {
         return this.m_statsName;
      }
      
      public function get Type() : String
      {
         return this.m_type;
      }
      
      public function get ClassID() : String
      {
         return this.m_class_id;
      }
      
      public function get InheritPalette() : Boolean
      {
         return this.m_inheritPalette;
      }
      
      public function get DisplayName() : String
      {
         if(this.m_displayName == null)
         {
            return "";
         }
         return this.m_displayName;
      }
      
      public function get RetainPlayerID() : Boolean
      {
         return this.m_retainPlayerID;
      }
      
      public function get DisableFlip() : Boolean
      {
         return this.m_disableFlip;
      }
      
      public function get SizeRatio() : Number
      {
         return this.m_sizeRatio;
      }
      
      public function get CanBeReversed() : Boolean
      {
         return this.m_canBeReversed;
      }
      
      public function set CanBeReversed(param1:Boolean) : void
      {
         this.m_canBeReversed = param1;
      }
      
      public function get CanPickup() : Boolean
      {
         return this.m_canPickup;
      }
      
      public function set CanPickup(param1:Boolean) : void
      {
         this.m_canPickup = param1;
      }
      
      public function get CanToss() : Boolean
      {
         return this.m_canToss;
      }
      
      public function set CanToss(param1:Boolean) : void
      {
         this.m_canToss = param1;
      }
      
      public function get CanBackToss() : Boolean
      {
         return this.m_canBackToss;
      }
      
      public function get CanJumpWith() : Boolean
      {
         return this.m_canJumpWith;
      }
      
      public function get CanAttackWith() : Boolean
      {
         return this.m_canAttackWith;
      }
      
      public function get CanHangWith() : Boolean
      {
         return this.m_canHangWith;
      }
      
      public function get CanShieldWith() : Boolean
      {
         return this.m_canShieldWith;
      }
      
      public function get CanRunWith() : Boolean
      {
         return this.m_canRunWith;
      }
      
      public function get CanBePushed() : Boolean
      {
         return this.m_canBePushed;
      }
      
      public function set CanBePushed(param1:Boolean) : void
      {
         this.m_canBePushed = param1;
      }
      
      public function get PushCharacters() : Boolean
      {
         return this.m_pushCharacters;
      }
      
      public function set PushCharacters(param1:Boolean) : void
      {
         this.m_pushCharacters = param1;
      }
      
      public function get TimeMax() : int
      {
         return this.m_time_max;
      }
      
      public function set TimeMax(param1:int) : void
      {
         this.m_time_max = param1;
      }
      
      public function get MaxGravity() : Number
      {
         return this.m_max_gravity;
      }
      
      public function get EffectSound() : String
      {
         return this.m_effectSound;
      }
      
      public function get LandSound() : String
      {
         return this.m_landSound;
      }
      
      public function get SpawnEffect() : String
      {
         return this.m_spawnEffect;
      }
      
      public function get DeathEffect() : String
      {
         return this.m_deathEffect;
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
      
      public function get InitialBounce() : Boolean
      {
         return this.m_initialBounce;
      }
      
      public function get Dangerous() : Boolean
      {
         return this.m_dangerous;
      }
      
      public function set Dangerous(param1:Boolean) : void
      {
         this.m_dangerous = param1;
      }
      
      public function get TossSpeed() : Number
      {
         return this.m_tossSpeed;
      }
      
      public function set TossSpeed(param1:Number) : void
      {
         this.m_tossSpeed = param1;
      }
      
      public function get Rotate() : Boolean
      {
         return this.m_rotate;
      }
      
      public function set Rotate(param1:Boolean) : void
      {
         this.m_rotate = param1;
      }
      
      public function get SpawnLimit() : int
      {
         return this.m_spawnLimit;
      }
      
      public function set SpawnLimit(param1:int) : void
      {
         this.m_spawnLimit = param1;
      }
      
      public function get Redirects() : Array
      {
         return this.m_redirects;
      }
      
      public function set Redirects(param1:Array) : void
      {
         this.m_redirects = param1;
      }
      
      public function get SlideDecay() : Number
      {
         return this.m_slideDecay;
      }
      
      public function set SlideDecay(param1:Number) : void
      {
         this.m_slideDecay = param1;
      }
      
      public function get AttackDataObj() : AttackData
      {
         return this.m_attackData;
      }
      
      public function get Projectiles() : Object
      {
         return this.m_projectiles;
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
            else if(String(_loc2_).match(/^attack_/))
            {
               this.m_attackData.AttackArray[_loc2_] = new AttackObject(_loc2_);
               this.m_attackData.AttackMap.push(_loc2_,this.m_attackData.AttackArray[_loc2_]);
               this.m_attackData.getAttack(_loc2_).importAttackData(param1[_loc2_]);
            }
            else if(this["m_" + _loc2_] !== undefined)
            {
               this["m_" + _loc2_] = param1[_loc2_];
            }
            else
            {
               _loc3_ = false;
               trace("You tried to set \"m_" + _loc2_ + "\" but it doesn\'t exist in the ItemData class.");
            }
         }
         return _loc3_;
      }
      
      override public function exportData() : Object
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:ProjectileAttack = null;
         var _loc5_:Object = super.exportData();
         var _loc6_:Object = new Object();
         _loc6_.statsName = this.m_statsName;
         _loc6_.type = this.m_type;
         _loc6_.class_id = this.m_class_id;
         _loc6_.inheritPalette = this.m_inheritPalette;
         _loc6_.displayName = this.m_displayName;
         _loc6_.retainPlayerID = this.m_retainPlayerID;
         _loc6_.disableFlip = this.m_disableFlip;
         _loc6_.sizeRatio = this.m_sizeRatio;
         _loc6_.canBeReversed = this.m_canBeReversed;
         _loc6_.canPickup = this.m_canPickup;
         _loc6_.canToss = this.m_canToss;
         _loc6_.canBackToss = this.m_canBackToss;
         _loc6_.canJumpWith = this.m_canJumpWith;
         _loc6_.canAttackWith = this.m_canAttackWith;
         _loc6_.canHangWith = this.m_canHangWith;
         _loc6_.canShieldWith = this.m_canShieldWith;
         _loc6_.canRunWith = this.m_canRunWith;
         _loc6_.canBePushed = this.m_canBePushed;
         _loc6_.pushCharacters = this.m_pushCharacters;
         _loc6_.time_max = this.m_time_max;
         _loc6_.max_gravity = this.m_max_gravity;
         _loc6_.effectSound = this.m_effectSound;
         _loc6_.landSound = this.m_landSound;
         _loc6_.spawnEffect = this.m_spawnEffect;
         _loc6_.deathEffect = this.m_deathEffect;
         _loc6_.bounce = this.m_bounce;
         _loc6_.bounce_decay = this.m_bounce_decay;
         _loc6_.bounce_limit = this.m_bounce_limit;
         _loc6_.bounce_max_height = this.m_bounce_max_height;
         _loc6_.initialBounce = this.m_initialBounce;
         _loc6_.slideDecay = this.m_slideDecay;
         _loc6_.dangerous = this.m_dangerous;
         _loc6_.redirects = this.m_redirects;
         _loc6_.tossSpeed = this.m_tossSpeed;
         _loc6_.rotate = this.m_rotate;
         _loc6_.spawnLimit = this.m_spawnLimit;
         _loc6_.projectiles = {};
         for(_loc1_ in this.m_attackData.AttackArray)
         {
            _loc6_[_loc1_] = this.m_attackData.AttackArray[_loc1_].exportAttackData();
         }
         for(_loc2_ in this.m_projectiles)
         {
            _loc4_ = new ProjectileAttack();
            _loc4_.importData(this.m_projectiles[_loc2_]);
            _loc6_.projectiles[_loc2_] = _loc4_.exportData();
         }
         for(_loc3_ in _loc5_)
         {
            if(!(_loc3_ in _loc6_))
            {
               _loc6_[_loc3_] = _loc5_[_loc3_];
            }
         }
         return _loc6_;
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


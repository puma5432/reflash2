package com.mcleodgaming.ssf2.engine
{
   public class AttackDamage
   {
      
      protected var m_attackState:AttackState;
      
      protected var m_player_id:int;
      
      protected var m_owner:InteractiveSprite;
      
      protected var m_attackBoxName:String;
      
      protected var m_isForward:Boolean;
      
      protected var m_damage:Number;
      
      protected var m_absorb_damage:Number;
      
      protected var m_shieldDamage:Number;
      
      protected var m_shieldStunMultiplier:Number;
      
      protected var m_forceTumbleFall:Boolean;
      
      protected var m_kbConstant:Number;
      
      protected var m_stackKnockback:Boolean;
      
      protected var m_canDI:Boolean;
      
      protected var m_staleMultiplier:Number;
      
      protected var m_power:Number;
      
      protected var m_priority:int;
      
      protected var m_chargedPriority:int;
      
      protected var m_rebound:Boolean;
      
      protected var m_frame:String;
      
      protected var m_atk_id:int;
      
      protected var m_id:int;
      
      protected var m_chargetime:int;
      
      protected var m_chargetime_max:int;
      
      protected var m_charge_kbMultiplier:Number;
      
      protected var m_charge_damageMultiplier:Number;
      
      protected var m_ignoreChargeDamage:Boolean;
      
      protected var m_ignoreKnockbackStackingTimer:Boolean;
      
      protected var m_direction:Number;
      
      protected var m_reversableAngle:Boolean;
      
      protected var m_stun:int;
      
      protected var m_dizzy:int;
      
      protected var m_dizzySelf:int;
      
      protected var m_pitfall:int;
      
      protected var m_egg:Boolean;
      
      protected var m_effect_id:String;
      
      protected var m_effectSound:String;
      
      protected var m_stunSelf:int;
      
      protected var m_hasEffect:Boolean;
      
      protected var m_sdiDistance:Number;
      
      protected var m_shieldSound:String;
      
      protected var m_freeze:int;
      
      protected var m_shock:Boolean;
      
      protected var m_burn:Boolean;
      
      protected var m_darkness:Boolean;
      
      protected var m_aura:Boolean;
      
      protected var m_sleep:int;
      
      protected var m_poison:int;
      
      protected var m_poisonInterval:int;
      
      protected var m_poisonLength:int;
      
      protected var m_bypassShield:Boolean;
      
      protected var m_bypassProjectiles:Boolean;
      
      protected var m_bypassEnemies:Boolean;
      
      protected var m_bypassItems:Boolean;
      
      protected var m_xloc:Number;
      
      protected var m_yloc:Number;
      
      protected var m_otherPlayerID:int;
      
      protected var m_hurtSelf:Boolean;
      
      protected var m_hurtSelfShield:Boolean;
      
      protected var m_meteorBounce:Boolean;
      
      protected var m_meteorSFX:String;
      
      protected var m_paralysis:int;
      
      protected var m_hitStun:Number;
      
      protected var m_hitStunProjectile:Number;
      
      protected var m_hitLag:Number;
      
      protected var m_weightKB:Number;
      
      protected var m_selfHitStun:Number;
      
      protected var m_camShake:int;
      
      protected var m_team_id:int;
      
      protected var m_bypassGrabbed:Boolean;
      
      protected var m_bypassNonLatched:Boolean;
      
      protected var m_bypassNonGrabbed:Boolean;
      
      protected var m_bypassHeavyArmor:Boolean;
      
      protected var m_bypassSuperArmor:Boolean;
      
      protected var m_bypassLaunchResistance:Boolean;
      
      protected var m_onlyAffectsAir:Boolean;
      
      protected var m_onlyAffectsFall:Boolean;
      
      protected var m_onlyAffectsGround:Boolean;
      
      protected var m_allowTurboInterrupt:Boolean;
      
      protected var m_sizeStatus:int;
      
      protected var m_reverse_character:Boolean;
      
      protected var m_reverse_item:Boolean;
      
      protected var m_reverse_projectile:Boolean;
      
      protected var m_disableLastHitUpdate:Boolean;
      
      protected var m_disableHurtSound:Boolean;
      
      protected var m_disableHurtFallOff:Boolean;
      
      protected var m_isAirAttack:Boolean;
      
      protected var m_isThrow:Boolean;
      
      protected var m_attackRatio:Number;
      
      protected var m_metadata:Object;
      
      public function AttackDamage(param1:int, param2:InteractiveSprite = null)
      {
         super();
         this.m_attackState = new AttackState();
         this.m_player_id = param1;
         this.m_owner = param2;
         this.m_attackBoxName = null;
         this.m_isForward = true;
         this.m_damage = 0;
         this.m_absorb_damage = 0;
         this.m_shieldDamage = -1;
         this.m_shieldStunMultiplier = 1;
         this.m_forceTumbleFall = false;
         this.m_kbConstant = 100;
         this.m_stackKnockback = true;
         this.m_canDI = true;
         this.m_staleMultiplier = 1.05;
         this.m_power = 0;
         this.m_priority = 0;
         this.m_chargedPriority = -1;
         this.m_rebound = true;
         this.m_frame = null;
         this.m_atk_id = 0;
         this.m_id = 0;
         this.m_charge_kbMultiplier = 1;
         this.m_charge_damageMultiplier = 1;
         this.m_ignoreChargeDamage = false;
         this.m_ignoreKnockbackStackingTimer = false;
         this.m_direction = 0;
         this.m_reversableAngle = true;
         this.m_chargetime = 0;
         this.m_chargetime_max = 0;
         this.m_stun = 0;
         this.m_dizzy = 0;
         this.m_dizzySelf = 0;
         this.m_pitfall = 0;
         this.m_egg = false;
         this.m_effect_id = null;
         this.m_effectSound = null;
         this.m_stunSelf = 0;
         this.m_hasEffect = true;
         this.m_sdiDistance = 1;
         this.m_shieldSound = "shieldhit";
         this.m_freeze = 0;
         this.m_sleep = 0;
         this.m_poison = 0;
         this.m_poisonInterval = 15;
         this.m_poisonLength = 300;
         this.m_bypassShield = false;
         this.m_bypassProjectiles = false;
         this.m_bypassEnemies = false;
         this.m_bypassItems = false;
         this.m_shock = false;
         this.m_burn = false;
         this.m_darkness = false;
         this.m_aura = false;
         this.m_xloc = 0;
         this.m_yloc = 0;
         this.m_otherPlayerID = 0;
         this.m_hurtSelf = false;
         this.m_hurtSelfShield = false;
         this.m_meteorBounce = true;
         this.m_meteorSFX = "ssb4_meteor";
         this.m_paralysis = -1;
         this.m_hitStun = -1;
         this.m_hitStunProjectile = 0;
         this.m_hitLag = -1;
         this.m_weightKB = 0;
         this.m_selfHitStun = -1;
         this.m_camShake = 0;
         this.m_team_id = -1;
         this.m_bypassGrabbed = false;
         this.m_bypassNonGrabbed = false;
         this.m_bypassNonLatched = false;
         this.m_bypassHeavyArmor = false;
         this.m_bypassSuperArmor = false;
         this.m_bypassLaunchResistance = false;
         this.m_onlyAffectsAir = false;
         this.m_onlyAffectsFall = false;
         this.m_onlyAffectsGround = false;
         this.m_allowTurboInterrupt = true;
         this.m_sizeStatus = 0;
         this.m_reverse_character = false;
         this.m_reverse_item = false;
         this.m_reverse_projectile = false;
         this.m_disableLastHitUpdate = false;
         this.m_disableHurtSound = false;
         this.m_disableHurtFallOff = false;
         this.m_isAirAttack = false;
         this.m_isThrow = false;
         this.m_attackRatio = 1;
         this.m_metadata = null;
      }
      
      public function get PlayerID() : int
      {
         return this.m_player_id;
      }
      
      public function set PlayerID(param1:int) : void
      {
         this.m_player_id = param1;
      }
      
      public function get Owner() : InteractiveSprite
      {
         return this.m_owner;
      }
      
      public function set Owner(param1:InteractiveSprite) : void
      {
         this.m_owner = param1;
      }
      
      public function get AttackBoxName() : String
      {
         return this.m_attackBoxName;
      }
      
      public function set AttackBoxName(param1:String) : void
      {
         this.m_attackBoxName = param1;
      }
      
      public function get IsForward() : Boolean
      {
         return this.m_isForward;
      }
      
      public function set IsForward(param1:Boolean) : void
      {
         this.m_isForward = param1;
      }
      
      public function get Damage() : Number
      {
         return this.m_damage;
      }
      
      public function set Damage(param1:Number) : void
      {
         this.m_damage = Math.min(param1,999);
      }
      
      public function get AbsorbDamage() : Number
      {
         return this.m_absorb_damage;
      }
      
      public function set AbsorbDamage(param1:Number) : void
      {
         this.m_absorb_damage = param1;
      }
      
      public function get ShieldDamage() : Number
      {
         return this.m_shieldDamage;
      }
      
      public function set ShieldDamage(param1:Number) : void
      {
         this.m_shieldDamage = param1;
      }
      
      public function get ShieldStunMultiplier() : Number
      {
         return this.m_shieldStunMultiplier;
      }
      
      public function set ShieldStunMultiplier(param1:Number) : void
      {
         this.m_shieldStunMultiplier = param1;
      }
      
      public function get ForceTumbleFall() : Boolean
      {
         return this.m_forceTumbleFall;
      }
      
      public function set ForceTumbleFall(param1:Boolean) : void
      {
         this.m_forceTumbleFall = param1;
      }
      
      public function get KBConstant() : Number
      {
         return this.m_kbConstant;
      }
      
      public function set KBConstant(param1:Number) : void
      {
         this.m_kbConstant = param1;
      }
      
      public function get StackKnockback() : Boolean
      {
         return this.m_stackKnockback;
      }
      
      public function set StackKnockback(param1:Boolean) : void
      {
         this.m_stackKnockback = param1;
      }
      
      public function get CanDI() : Boolean
      {
         return this.m_canDI;
      }
      
      public function set CanDI(param1:Boolean) : void
      {
         this.m_canDI = param1;
      }
      
      public function get StaleMultiplier() : Number
      {
         return this.m_staleMultiplier;
      }
      
      public function set StaleMultiplier(param1:Number) : void
      {
         this.m_staleMultiplier = param1;
      }
      
      public function get Power() : Number
      {
         return this.m_power;
      }
      
      public function set Power(param1:Number) : void
      {
         this.m_power = param1;
      }
      
      public function get ChargedPriority() : int
      {
         return this.m_chargedPriority;
      }
      
      public function set ChargedPriority(param1:int) : void
      {
         this.m_chargedPriority = param1;
      }
      
      public function get Priority() : int
      {
         return this.m_priority;
      }
      
      public function set Priority(param1:int) : void
      {
         this.m_priority = param1;
      }
      
      public function get Rebound() : Boolean
      {
         return this.m_rebound;
      }
      
      public function set Rebound(param1:Boolean) : void
      {
         this.m_rebound = param1;
      }
      
      public function get Frame() : String
      {
         return this.m_frame;
      }
      
      public function set Frame(param1:String) : void
      {
         this.m_frame = param1;
      }
      
      public function get AttackID() : int
      {
         return this.m_atk_id;
      }
      
      public function set AttackID(param1:int) : void
      {
         this.m_atk_id = param1;
      }
      
      public function get ID() : int
      {
         return this.m_id;
      }
      
      public function set ID(param1:int) : void
      {
         this.m_id = param1;
      }
      
      public function get Direction() : Number
      {
         return this.m_direction;
      }
      
      public function set Direction(param1:Number) : void
      {
         this.m_direction = param1;
      }
      
      public function get ReversableAngle() : Boolean
      {
         return this.m_reversableAngle;
      }
      
      public function set ReversableAngle(param1:Boolean) : void
      {
         this.m_reversableAngle = param1;
      }
      
      public function get ChargeTime() : int
      {
         return this.m_chargetime;
      }
      
      public function set ChargeTime(param1:int) : void
      {
         this.m_chargetime = param1;
      }
      
      public function get ChargeTimeMax() : int
      {
         return this.m_chargetime_max;
      }
      
      public function set ChargeTimeMax(param1:int) : void
      {
         this.m_chargetime_max = param1;
      }
      
      public function get Stun() : int
      {
         return this.m_stun;
      }
      
      public function set Stun(param1:int) : void
      {
         this.m_stun = param1;
      }
      
      public function get Dizzy() : int
      {
         return this.m_dizzy;
      }
      
      public function set Dizzy(param1:int) : void
      {
         this.m_dizzy = param1;
      }
      
      public function get DizzySelf() : int
      {
         return this.m_dizzySelf;
      }
      
      public function set DizzySelf(param1:int) : void
      {
         this.m_dizzySelf = param1;
      }
      
      public function get Pitfall() : int
      {
         return this.m_pitfall;
      }
      
      public function set Pitfall(param1:int) : void
      {
         this.m_pitfall = param1;
      }
      
      public function get Egg() : Boolean
      {
         return this.m_egg;
      }
      
      public function set Egg(param1:Boolean) : void
      {
         this.m_egg = param1;
      }
      
      public function get EffectID() : String
      {
         return this.m_effect_id;
      }
      
      public function set EffectID(param1:String) : void
      {
         this.m_effect_id = param1;
      }
      
      public function get EffectSound() : String
      {
         return this.m_effectSound;
      }
      
      public function set EffectSound(param1:String) : void
      {
         this.m_effectSound = param1;
      }
      
      public function get StunSelf() : int
      {
         return this.m_stunSelf;
      }
      
      public function set StunSelf(param1:int) : void
      {
         this.m_stunSelf = param1;
      }
      
      public function get HasEffect() : Boolean
      {
         return this.m_hasEffect;
      }
      
      public function set HasEffect(param1:Boolean) : void
      {
         this.m_hasEffect = param1;
      }
      
      public function get SDIDistance() : Number
      {
         return this.m_sdiDistance;
      }
      
      public function set SDIDistance(param1:Number) : void
      {
         this.m_sdiDistance = param1;
      }
      
      public function get ShieldSound() : String
      {
         return this.m_shieldSound;
      }
      
      public function set ShieldSound(param1:String) : void
      {
         this.m_shieldSound = param1;
      }
      
      public function get Freeze() : int
      {
         return this.m_freeze;
      }
      
      public function set Freeze(param1:int) : void
      {
         this.m_freeze = param1;
      }
      
      public function get Sleep() : int
      {
         return this.m_sleep;
      }
      
      public function set Sleep(param1:int) : void
      {
         this.m_sleep = param1;
      }
      
      public function get Poison() : int
      {
         return this.m_poison;
      }
      
      public function set Poison(param1:int) : void
      {
         this.m_poison = param1;
      }
      
      public function get PoisonInterval() : int
      {
         return this.m_poisonInterval;
      }
      
      public function set PoisonInterval(param1:int) : void
      {
         this.m_poisonInterval = param1;
      }
      
      public function get PoisonLength() : int
      {
         return this.m_poisonLength;
      }
      
      public function set PoisonLength(param1:int) : void
      {
         this.m_poisonLength = param1;
      }
      
      public function get BypassShield() : Boolean
      {
         return this.m_bypassShield;
      }
      
      public function set BypassShield(param1:Boolean) : void
      {
         this.m_bypassShield = param1;
      }
      
      public function get BypassProjectiles() : Boolean
      {
         return this.m_bypassProjectiles;
      }
      
      public function set BypassProjectiles(param1:Boolean) : void
      {
         this.m_bypassProjectiles = param1;
      }
      
      public function get BypassEnemies() : Boolean
      {
         return this.m_bypassEnemies;
      }
      
      public function set BypassEnemies(param1:Boolean) : void
      {
         this.m_bypassEnemies = param1;
      }
      
      public function get BypassItems() : Boolean
      {
         return this.m_bypassItems;
      }
      
      public function set BypassItems(param1:Boolean) : void
      {
         this.m_bypassItems = param1;
      }
      
      public function get Shock() : Boolean
      {
         return this.m_shock;
      }
      
      public function set Shock(param1:Boolean) : void
      {
         this.m_shock = param1;
      }
      
      public function get Burn() : Boolean
      {
         return this.m_burn;
      }
      
      public function set Burn(param1:Boolean) : void
      {
         this.m_burn = param1;
      }
      
      public function get Darkness() : Boolean
      {
         return this.m_darkness;
      }
      
      public function set Darkness(param1:Boolean) : void
      {
         this.m_darkness = param1;
      }
      
      public function get Aura() : Boolean
      {
         return this.m_aura;
      }
      
      public function set Aura(param1:Boolean) : void
      {
         this.m_aura = param1;
      }
      
      public function get XLoc() : Number
      {
         return this.m_xloc;
      }
      
      public function set XLoc(param1:Number) : void
      {
         this.m_xloc = param1;
      }
      
      public function get YLoc() : Number
      {
         return this.m_yloc;
      }
      
      public function set YLoc(param1:Number) : void
      {
         this.m_yloc = param1;
      }
      
      public function get OtherPlayerID() : int
      {
         return this.m_otherPlayerID;
      }
      
      public function set OtherPlayerID(param1:int) : void
      {
         this.m_otherPlayerID = param1;
      }
      
      public function get HurtSelf() : Boolean
      {
         return this.m_hurtSelf;
      }
      
      public function set HurtSelf(param1:Boolean) : void
      {
         this.m_hurtSelf = param1;
      }
      
      public function get HurtSelfShield() : Boolean
      {
         return this.m_hurtSelfShield;
      }
      
      public function set HurtSelfShield(param1:Boolean) : void
      {
         this.m_hurtSelfShield = param1;
      }
      
      public function get MeteorBounce() : Boolean
      {
         return this.m_meteorBounce;
      }
      
      public function set MeteorBounce(param1:Boolean) : void
      {
         this.m_meteorBounce = param1;
      }
      
      public function get MeteorSFX() : String
      {
         return this.m_meteorSFX;
      }
      
      public function set MeteorSFX(param1:String) : void
      {
         this.m_meteorSFX = param1;
      }
      
      public function get Paralysis() : int
      {
         return this.m_paralysis;
      }
      
      public function set Paralysis(param1:int) : void
      {
         this.m_paralysis = param1;
      }
      
      public function get HitStun() : Number
      {
         return this.m_hitStun;
      }
      
      public function set HitStun(param1:Number) : void
      {
         this.m_hitStun = param1;
      }
      
      public function get HitStunProjectile() : Number
      {
         return this.m_hitStunProjectile;
      }
      
      public function set HitStunProjectile(param1:Number) : void
      {
         this.m_hitStunProjectile = param1;
      }
      
      public function get HitLag() : Number
      {
         return this.m_hitLag;
      }
      
      public function set HitLag(param1:Number) : void
      {
         this.m_hitLag = param1;
      }
      
      public function get WeightKB() : Number
      {
         return this.m_weightKB;
      }
      
      public function set WeightKB(param1:Number) : void
      {
         this.m_weightKB = param1;
      }
      
      public function get SelfHitStun() : Number
      {
         return this.m_selfHitStun;
      }
      
      public function set SelfHitStun(param1:Number) : void
      {
         this.m_selfHitStun = param1;
      }
      
      public function get CamShake() : int
      {
         return this.m_camShake;
      }
      
      public function set CamShake(param1:int) : void
      {
         this.m_camShake = param1;
      }
      
      public function get TeamID() : int
      {
         return this.m_team_id;
      }
      
      public function set TeamID(param1:int) : void
      {
         this.m_team_id = param1;
      }
      
      public function get BypassGrabbed() : Boolean
      {
         return this.m_bypassGrabbed;
      }
      
      public function set BypassGrabbed(param1:Boolean) : void
      {
         this.m_bypassGrabbed = param1;
      }
      
      public function get BypassNonGrabbed() : Boolean
      {
         return this.m_bypassNonGrabbed;
      }
      
      public function set BypassNonGrabbed(param1:Boolean) : void
      {
         this.m_bypassNonGrabbed = param1;
      }
      
      public function get BypassNonLatched() : Boolean
      {
         return this.m_bypassNonLatched;
      }
      
      public function set BypassNonLatched(param1:Boolean) : void
      {
         this.m_bypassNonLatched = param1;
      }
      
      public function get BypassHeavyArmor() : Boolean
      {
         return this.m_bypassHeavyArmor;
      }
      
      public function set BypassHeavyArmor(param1:Boolean) : void
      {
         this.m_bypassHeavyArmor = param1;
      }
      
      public function get BypassSuperArmor() : Boolean
      {
         return this.m_bypassSuperArmor;
      }
      
      public function set BypassSuperArmor(param1:Boolean) : void
      {
         this.m_bypassSuperArmor = param1;
      }
      
      public function get BypassLaunchResistance() : Boolean
      {
         return this.m_bypassLaunchResistance;
      }
      
      public function set BypassLaunchResistance(param1:Boolean) : void
      {
         this.m_bypassLaunchResistance = param1;
      }
      
      public function get SizeStatus() : int
      {
         return this.m_sizeStatus;
      }
      
      public function set SizeStatus(param1:int) : void
      {
         this.m_sizeStatus = param1;
      }
      
      public function get OnlyAffectsAir() : Boolean
      {
         return this.m_onlyAffectsAir;
      }
      
      public function set OnlyAffectsAir(param1:Boolean) : void
      {
         this.m_onlyAffectsAir = param1;
      }
      
      public function get OnlyAffectsGround() : Boolean
      {
         return this.m_onlyAffectsGround;
      }
      
      public function set OnlyAffectsGround(param1:Boolean) : void
      {
         this.m_onlyAffectsGround = param1;
      }
      
      public function get OnlyAffectsFall() : Boolean
      {
         return this.m_onlyAffectsFall;
      }
      
      public function set OnlyAffectsFall(param1:Boolean) : void
      {
         this.m_onlyAffectsFall = param1;
      }
      
      public function get AllowTurboInterrupt() : Boolean
      {
         return this.m_allowTurboInterrupt;
      }
      
      public function set AllowTurboInterrupt(param1:Boolean) : void
      {
         this.m_allowTurboInterrupt = param1;
      }
      
      public function get ChargeKBMultiplier() : Number
      {
         return this.m_charge_kbMultiplier;
      }
      
      public function set ChargeKBMultiplier(param1:Number) : void
      {
         this.m_charge_kbMultiplier = param1;
      }
      
      public function get ChargeDamageMultiplier() : Number
      {
         return this.m_charge_damageMultiplier;
      }
      
      public function set ChargeDamageMultiplier(param1:Number) : void
      {
         this.m_charge_damageMultiplier = param1;
      }
      
      public function get IgnoreChargeDamage() : Boolean
      {
         return this.m_ignoreChargeDamage;
      }
      
      public function set IgnoreChargeDamage(param1:Boolean) : void
      {
         this.m_ignoreChargeDamage = param1;
      }
      
      public function get IgnoreKnockbackStackingTimer() : Boolean
      {
         return this.m_ignoreKnockbackStackingTimer;
      }
      
      public function set IgnoreKnockbackStackingTimer(param1:Boolean) : void
      {
         this.m_ignoreKnockbackStackingTimer = param1;
      }
      
      public function get ReverseCharacter() : Boolean
      {
         return this.m_reverse_character;
      }
      
      public function set ReverseCharacter(param1:Boolean) : void
      {
         this.m_reverse_character = param1;
      }
      
      public function get ReverseItem() : Boolean
      {
         return this.m_reverse_item;
      }
      
      public function set ReverseItem(param1:Boolean) : void
      {
         this.m_reverse_item = param1;
      }
      
      public function get ReverseProjectile() : Boolean
      {
         return this.m_reverse_projectile;
      }
      
      public function set ReverseProjectile(param1:Boolean) : void
      {
         this.m_reverse_projectile = param1;
      }
      
      public function get DisableLastHitUpdate() : Boolean
      {
         return this.m_disableLastHitUpdate;
      }
      
      public function set DisableLastHitUpdate(param1:Boolean) : void
      {
         this.m_disableLastHitUpdate = param1;
      }
      
      public function get DisableHurtSound() : Boolean
      {
         return this.m_disableHurtSound;
      }
      
      public function set DisableHurtSound(param1:Boolean) : void
      {
         this.m_disableHurtSound = param1;
      }
      
      public function get DisableHurtFallOff() : Boolean
      {
         return this.m_disableHurtFallOff;
      }
      
      public function set DisableHurtFallOff(param1:Boolean) : void
      {
         this.m_disableHurtFallOff = param1;
      }
      
      public function get IsAirAttack() : Boolean
      {
         return this.m_isAirAttack;
      }
      
      public function set IsAirAttack(param1:Boolean) : void
      {
         this.m_isAirAttack = param1;
      }
      
      public function get IsThrow() : Boolean
      {
         return this.m_isThrow;
      }
      
      public function set IsThrow(param1:Boolean) : void
      {
         this.m_isThrow = param1;
      }
      
      public function get AttackRatio() : Number
      {
         return this.m_attackRatio;
      }
      
      public function set AttackRatio(param1:Number) : void
      {
         this.m_attackRatio = param1;
      }
      
      public function get Metadata() : Object
      {
         return this.m_metadata;
      }
      
      public function set Metadata(param1:Object) : void
      {
         this.m_metadata = param1;
      }
      
      public function getVar(param1:String) : *
      {
         if(this["m_" + param1] !== undefined)
         {
            return this["m_" + param1];
         }
         return null;
      }
      
      public function syncState(param1:AttackState) : AttackDamage
      {
         if(param1)
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
            if(this.m_owner)
            {
               this.m_player_id = param1.ReverseID > 0 ? param1.ReverseID : this.m_owner.ID;
               this.m_team_id = param1.ReverseTeam > 0 ? param1.ReverseTeam : this.m_owner.Team;
            }
            else
            {
               this.m_player_id = -1;
               this.m_team_id = -1;
            }
         }
         return this;
      }
      
      public function importAttackDamageData(param1:Object) : void
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
         if(this.m_damage > 999)
         {
            this.m_damage = 999;
         }
      }
      
      public function exportAttackDamageData() : Object
      {
         return {
            "player_id":this.m_player_id,
            "owner":this.m_owner,
            "isForward":this.m_isForward,
            "damage":this.m_damage,
            "absorb_damage":this.m_absorb_damage,
            "shieldDamage":this.m_shieldDamage,
            "shieldStunMultiplier":this.m_shieldStunMultiplier,
            "forceTumbleFall":this.m_forceTumbleFall,
            "kbConstant":this.m_kbConstant,
            "stackKnockback":this.m_stackKnockback,
            "canDI":this.m_canDI,
            "staleMultiplier":this.m_staleMultiplier,
            "power":this.m_power,
            "priority":this.m_priority,
            "rebound":this.m_rebound,
            "frame":this.m_frame,
            "atk_id":this.m_atk_id,
            "id":this.m_id,
            "charge_kbMultiplier":this.m_charge_kbMultiplier,
            "charge_damageMultiplier":this.m_charge_damageMultiplier,
            "ignoreChargeDamage":this.m_ignoreChargeDamage,
            "ignoreKnockbackStackingTimer":this.m_ignoreKnockbackStackingTimer,
            "direction":this.m_direction,
            "reversableAngle":this.m_reversableAngle,
            "chargetime":this.m_chargetime,
            "chargetime_max":this.m_chargetime_max,
            "stun":this.m_stun,
            "dizzy":this.m_dizzy,
            "dizzySelf":this.m_dizzySelf,
            "pitfall":this.m_pitfall,
            "egg":this.m_egg,
            "effect_id":this.m_effect_id,
            "effectSound":this.m_effectSound,
            "stunSelf":this.m_stunSelf,
            "hasEffect":this.m_hasEffect,
            "sdiDistance":this.m_sdiDistance,
            "shieldSound":this.m_shieldSound,
            "freeze":this.m_freeze,
            "sleep":this.m_sleep,
            "poison":this.m_poison,
            "poisonInterval":this.m_poisonInterval,
            "poisonLength":this.m_poisonLength,
            "bypassShield":this.m_bypassShield,
            "bypassProjectiles":this.m_bypassProjectiles,
            "bypassEnemies":this.m_bypassEnemies,
            "bypassItems":this.m_bypassItems,
            "shock":this.m_shock,
            "burn":this.m_burn,
            "darkness":this.m_darkness,
            "aura":this.m_aura,
            "xloc":this.m_xloc,
            "yloc":this.m_yloc,
            "otherPlayerID":this.m_otherPlayerID,
            "hurtSelf":this.m_hurtSelf,
            "hurtSelfShield":this.m_hurtSelfShield,
            "meteorBounce":this.m_meteorBounce,
            "meteorSFX":this.m_meteorSFX,
            "paralysis":this.m_paralysis,
            "hitStun":this.m_hitStun,
            "hitStunProjectile":this.m_hitStunProjectile,
            "hitLag":this.m_hitLag,
            "weightKB":this.m_weightKB,
            "selfHitStun":this.m_selfHitStun,
            "camShake":this.m_camShake,
            "team_id":this.m_team_id,
            "bypassGrabbed":this.m_bypassGrabbed,
            "bypassNonGrabbed":this.m_bypassNonGrabbed,
            "bypassNonLatched":this.m_bypassNonLatched,
            "bypassHeavyArmor":this.m_bypassHeavyArmor,
            "bypassSuperArmor":this.m_bypassSuperArmor,
            "bypassLaunchResistance":this.m_bypassLaunchResistance,
            "onlyAffectsAir":this.m_onlyAffectsAir,
            "onlyAffectsFall":this.m_onlyAffectsFall,
            "onlyAffectsGround":this.m_onlyAffectsGround,
            "allowTurboInterrupt":this.m_allowTurboInterrupt,
            "sizeStatus":this.m_sizeStatus,
            "disableLastHitUpdate":this.m_disableLastHitUpdate,
            "disableHurtSound":this.m_disableHurtSound,
            "disableHurtFallOff":this.m_disableHurtFallOff,
            "isAirAttack":this.m_isAirAttack,
            "isThrow":this.m_isThrow,
            "attackRatio":this.m_attackRatio,
            "reverse_character":this.m_reverse_character,
            "reverse_item":this.m_reverse_item,
            "reverse_projectile":this.m_reverse_projectile,
            "metadata":this.m_metadata
         };
      }
   }
}


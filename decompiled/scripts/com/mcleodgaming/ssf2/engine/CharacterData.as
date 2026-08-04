package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.controllers.*;
   
   public class CharacterData extends InteractiveSpriteStats
   {
      
      protected var m_player_id:int;
      
      protected var m_shieldType:String;
      
      protected var m_statsName:String;
      
      protected var m_displayName:String;
      
      protected var m_linkage_id2:String;
      
      protected var m_linkage_id_special:String;
      
      protected var m_thumbnail:String;
      
      protected var m_seriesIcon:String;
      
      protected var m_cam_width:Number;
      
      protected var m_cam_height:Number;
      
      protected var m_cam_x_offset:Number;
      
      protected var m_cam_y_offset:Number;
      
      protected var m_deathSwitchID:String;
      
      protected var m_revivalEffect:String;
      
      protected var m_jumpSpeed:Number;
      
      protected var m_jumpSpeedMidair:Number;
      
      protected var m_jumpSpeedList:String;
      
      protected var m_shortHopSpeed:Number;
      
      protected var m_jumpStartup:int;
      
      protected var m_max_jumpSpeed:Number;
      
      protected var m_midAirTurn:Boolean;
      
      protected var m_midAirHover:int;
      
      protected var m_midAirJumpConstant:int;
      
      protected var m_midAirJumpConstantDelay:int;
      
      protected var m_midAirJumpConstantAccel:Number;
      
      protected var m_wallJump:Boolean;
      
      protected var m_wallStick:int;
      
      protected var m_airDodgeSpeed:Number;
      
      protected var m_tiltTossMultiplier:Number;
      
      protected var m_smashTossMultiplier:Number;
      
      protected var m_dodgeSpeed:Number;
      
      protected var m_dodgeStartup:int;
      
      protected var m_dodgeDecel:Number;
      
      protected var m_power:String;
      
      protected var m_norm_xSpeed:Number;
      
      protected var m_max_xSpeed:Number;
      
      protected var m_fastFallSpeed:Number;
      
      protected var m_accel_start:Number;
      
      protected var m_accel_start_dash:Number;
      
      protected var m_accel_rate:Number;
      
      protected var m_accel_rate_air:Number;
      
      protected var m_decel_rate:Number;
      
      protected var m_decel_rate_air:Number;
      
      protected var m_glideSpeed:Number;
      
      protected var m_holdJump:Boolean;
      
      protected var m_max_jump:int;
      
      protected var m_tetherGrab:Boolean;
      
      protected var m_roll_speed:Number;
      
      protected var m_roll_decay:Number;
      
      protected var m_roll_decay_ice:Number;
      
      protected var m_roll_delay:int;
      
      protected var m_getup_roll_delay:int;
      
      protected var m_tech_roll_delay:int;
      
      protected var m_climb_roll_delay:int;
      
      protected var m_itemScaleRatio:Number;
      
      protected var m_shieldBreakPower:Number;
      
      protected var m_shieldBreakKBConstant:Number;
      
      protected var m_shieldBreakWeightKB:Number;
      
      protected var m_shield_x_offset:Number;
      
      protected var m_shield_y_offset:Number;
      
      protected var m_shield_scale:Number;
      
      protected var m_special_type:int;
      
      protected var m_normalStats_id:String;
      
      protected var m_alternateStats_id:String;
      
      protected var m_specialStats_id:String;
      
      protected var m_sounds:Array;
      
      protected var m_hurtFrames:int;
      
      protected var m_attacks:AttackData;
      
      protected var m_canThrow:Boolean;
      
      protected var m_canBeGrabbed:Boolean;
      
      protected var m_canHoldItems:Boolean;
      
      protected var m_canUseItems:Boolean;
      
      protected var m_canShield:Boolean;
      
      protected var m_canDodge:Boolean;
      
      protected var m_canTaunt:Boolean;
      
      protected var m_canBarrel:Boolean;
      
      protected var m_canGrabLedges:Boolean;
      
      protected var m_canUseSpecials:Boolean;
      
      protected var m_canStarKO:Boolean;
      
      protected var m_grabDamage:int;
      
      protected var m_damageIncrease:Number;
      
      protected var m_damageIncreaseInterval:int;
      
      protected var m_heavyArmor:Number;
      
      protected var m_windArmor:Number;
      
      protected var m_launchResistance:Number;
      
      protected var m_customShield:Boolean;
      
      protected var m_customShieldStartup:int;
      
      protected var m_crouchWalkSpeed:Number;
      
      protected var m_volume_sfx:Number;
      
      protected var m_volume_vfx:Number;
      
      protected var m_forceTransformTime:int;
      
      protected var m_forceTransformID:String;
      
      protected var m_fs_time_limit:int;
      
      protected var m_fs_magnet:Boolean;
      
      protected var m_minShieldSize:Number;
      
      protected var m_maxShieldSize:Number;
      
      protected var m_statusEffectImmunity:Boolean;
      
      protected var m_groundToAirMultiplier:Number;
      
      protected var m_finalSmashCutin:String;
      
      public var m_damageRatio:Number;
      
      public var m_attackRatio:Number;
      
      public var m_unlimitedFinal:Boolean;
      
      public var m_finalSmashMeter:Boolean;
      
      public var m_startDamage:int;
      
      public function CharacterData()
      {
         super();
         this.m_player_id = -1;
         this.m_shieldType = "shield-1";
         this.m_statsName = null;
         this.m_displayName = null;
         this.m_linkage_id2 = null;
         this.m_linkage_id_special = null;
         this.m_thumbnail = null;
         this.m_seriesIcon = null;
         this.m_cam_width = 150;
         this.m_cam_height = 150;
         this.m_cam_x_offset = 25;
         this.m_cam_y_offset = 50;
         this.m_deathSwitchID = null;
         this.m_revivalEffect = null;
         this.m_jumpSpeed = 0;
         this.m_jumpSpeedMidair = 0;
         this.m_jumpSpeedList = null;
         this.m_shortHopSpeed = 0;
         this.m_jumpStartup = 0;
         this.m_max_jumpSpeed = 0;
         this.m_midAirTurn = false;
         this.m_midAirHover = 0;
         this.m_midAirJumpConstant = 0;
         this.m_midAirJumpConstantDelay = 0;
         this.m_midAirJumpConstantAccel = 0;
         this.m_wallJump = false;
         this.m_wallStick = 0;
         this.m_airDodgeSpeed = 6.5;
         this.m_tiltTossMultiplier = 1;
         this.m_smashTossMultiplier = 1.2;
         this.m_dodgeSpeed = 7;
         this.m_dodgeStartup = 0;
         this.m_dodgeDecel = 0;
         this.m_power = null;
         this.m_norm_xSpeed = 0;
         this.m_max_xSpeed = 0;
         this.m_fastFallSpeed = 0;
         this.m_accel_start = 0;
         this.m_accel_start_dash = -1;
         this.m_accel_rate = 0;
         this.m_accel_rate_air = 0.7;
         this.m_decel_rate = 0;
         this.m_decel_rate_air = -0.15;
         this.m_glideSpeed = 0;
         this.m_holdJump = false;
         this.m_max_jump = 1;
         this.m_tetherGrab = false;
         this.m_roll_speed = 0;
         this.m_roll_decay = 0.65;
         this.m_roll_decay_ice = 0.93;
         this.m_getup_roll_delay = 0;
         this.m_tech_roll_delay = 0;
         this.m_climb_roll_delay = 0;
         this.m_itemScaleRatio = 0;
         this.m_shieldBreakPower = 14;
         this.m_shieldBreakKBConstant = 100;
         this.m_shieldBreakWeightKB = 40;
         this.m_shield_x_offset = 0;
         this.m_shield_y_offset = 0;
         this.m_shield_scale = 1;
         this.m_special_type = 0;
         this.m_normalStats_id = null;
         this.m_alternateStats_id = null;
         this.m_specialStats_id = null;
         this.m_sounds = new Array();
         this.m_hurtFrames = 1;
         this.m_attacks = new AttackData(null,["a","a_up","a_up_tilt","a_forward","a_forward_tilt","a_forwardsmash","a_down","a_air","a_air_up","a_air_forward","a_air_backward","a_air_down","b","b_air","b_up","b_up_air","b_forward","b_forward_air","b_down","b_down_air","throw_up","throw_forward","throw_back","throw_down","crouch_attack","ledge_attack","getup_attack","kirby","kirby_air","star","item","special"]);
         this.m_canDodge = true;
         this.m_canHoldItems = true;
         this.m_canShield = true;
         this.m_canThrow = true;
         this.m_canBeGrabbed = true;
         this.m_canUseItems = true;
         this.m_canTaunt = true;
         this.m_canBarrel = true;
         this.m_canGrabLedges = true;
         this.m_canUseSpecials = true;
         this.m_canStarKO = true;
         this.m_grabDamage = 0;
         this.m_damageIncrease = 0;
         this.m_damageIncreaseInterval = 30;
         this.m_heavyArmor = 0;
         this.m_windArmor = 0;
         this.m_launchResistance = 0;
         this.m_customShield = false;
         this.m_customShieldStartup = 0;
         this.m_crouchWalkSpeed = 0;
         this.m_volume_sfx = 1;
         this.m_volume_vfx = 1;
         this.m_forceTransformTime = 0;
         this.m_forceTransformID = null;
         this.m_fs_time_limit = 0;
         this.m_fs_magnet = false;
         this.m_minShieldSize = 0.5;
         this.m_maxShieldSize = 1.4;
         this.m_statusEffectImmunity = false;
         this.m_groundToAirMultiplier = 1;
         this.m_finalSmashCutin = null;
         this.m_attackRatio = 1;
         this.m_damageRatio = 1;
         this.m_unlimitedFinal = false;
         this.m_finalSmashMeter = false;
         this.m_startDamage = 0;
      }
      
      public function get PlayerID() : int
      {
         return this.m_player_id;
      }
      
      public function get ShieldType() : String
      {
         return this.m_shieldType;
      }
      
      public function get StatsName() : String
      {
         return this.m_statsName;
      }
      
      public function get DisplayName() : String
      {
         if(this.m_displayName == null)
         {
            return "";
         }
         return this.m_displayName;
      }
      
      public function get LinkageID2() : String
      {
         return this.m_linkage_id2;
      }
      
      public function get LinkageIDSpecial() : String
      {
         return this.m_linkage_id_special;
      }
      
      public function get Thumbnail() : String
      {
         return this.m_thumbnail;
      }
      
      public function get SeriesIcon() : String
      {
         return this.m_seriesIcon;
      }
      
      public function get CamWidth() : Number
      {
         return this.m_cam_width;
      }
      
      public function get CamHeight() : Number
      {
         return this.m_cam_height;
      }
      
      public function get CamXOffset() : Number
      {
         return this.m_cam_x_offset;
      }
      
      public function get CamYOffset() : Number
      {
         return this.m_cam_y_offset;
      }
      
      public function get DeathSwitchID() : String
      {
         return this.m_deathSwitchID;
      }
      
      public function get RevivalEffect() : String
      {
         return this.m_revivalEffect;
      }
      
      public function get JumpSpeed() : Number
      {
         return this.m_jumpSpeed;
      }
      
      public function get JumpSpeedMidAir() : Number
      {
         return this.m_jumpSpeedMidair;
      }
      
      public function get JumpSpeedList() : String
      {
         return this.m_jumpSpeedList;
      }
      
      public function get ShortHopSpeed() : Number
      {
         return this.m_shortHopSpeed;
      }
      
      public function get JumpStartup() : int
      {
         return this.m_jumpStartup;
      }
      
      public function get MaxJumpSpeed() : Number
      {
         return this.m_max_jumpSpeed;
      }
      
      public function set MaxJumpSpeed(param1:Number) : void
      {
         this.m_max_jumpSpeed = param1;
      }
      
      public function get MidAirTurn() : Boolean
      {
         return this.m_midAirTurn;
      }
      
      public function get MidAirHover() : int
      {
         return this.m_midAirHover;
      }
      
      public function get MidAirJumpConstant() : int
      {
         return this.m_midAirJumpConstant;
      }
      
      public function get MidAirJumpConstantDelay() : int
      {
         return this.m_midAirJumpConstantDelay;
      }
      
      public function get MidAirJumpConstantAccel() : Number
      {
         return this.m_midAirJumpConstantAccel;
      }
      
      public function get WallJump() : Boolean
      {
         return this.m_wallJump;
      }
      
      public function get WallStick() : int
      {
         return this.m_wallStick;
      }
      
      public function get AirDodgeSpeed() : int
      {
         return this.m_airDodgeSpeed;
      }
      
      public function get DodgeSpeed() : Number
      {
         return this.m_dodgeSpeed;
      }
      
      public function get DodgeStartup() : int
      {
         return this.m_dodgeStartup;
      }
      
      public function get DodgeDecel() : Number
      {
         return this.m_dodgeDecel;
      }
      
      public function get TiltTossMultiplier() : Number
      {
         return this.m_tiltTossMultiplier;
      }
      
      public function get SmashTossMultiplier() : Number
      {
         return this.m_smashTossMultiplier;
      }
      
      public function get Power() : String
      {
         return this.m_power;
      }
      
      public function set Power(param1:String) : void
      {
         this.m_power = param1;
      }
      
      public function get NormalXSpeed() : Number
      {
         return this.m_norm_xSpeed;
      }
      
      public function get MaxXSpeed() : Number
      {
         return this.m_max_xSpeed;
      }
      
      public function get FastFallSpeed() : Number
      {
         return this.m_fastFallSpeed;
      }
      
      public function get AccelStart() : Number
      {
         return this.m_accel_start;
      }
      
      public function get AccelStartDash() : Number
      {
         return this.m_accel_start_dash;
      }
      
      public function get AccelRate() : Number
      {
         return this.m_accel_rate;
      }
      
      public function get AccelRateAir() : Number
      {
         return this.m_accel_rate_air;
      }
      
      public function get DecelRate() : Number
      {
         return this.m_decel_rate;
      }
      
      public function get DecelRateAir() : Number
      {
         return this.m_decel_rate_air;
      }
      
      public function get GlideSpeed() : Number
      {
         return this.m_glideSpeed;
      }
      
      public function get HoldJump() : Boolean
      {
         return this.m_holdJump;
      }
      
      public function get MaxJump() : int
      {
         return this.m_max_jump;
      }
      
      public function set MaxJump(param1:int) : void
      {
         this.m_max_jump = param1;
      }
      
      public function get TetherGrab() : Boolean
      {
         return this.m_tetherGrab;
      }
      
      public function get RollSpeed() : Number
      {
         return this.m_roll_speed;
      }
      
      public function get RollDecay() : Number
      {
         return this.m_roll_decay;
      }
      
      public function get RollDecayIce() : Number
      {
         return this.m_roll_decay_ice;
      }
      
      public function get GetupRollDelay() : int
      {
         return this.m_getup_roll_delay;
      }
      
      public function get TechRollDelay() : int
      {
         return this.m_tech_roll_delay;
      }
      
      public function get ClimbRollDelay() : int
      {
         return this.m_climb_roll_delay;
      }
      
      public function get ItemScaleRatio() : Number
      {
         return this.m_itemScaleRatio;
      }
      
      public function get ShieldBreakPower() : Number
      {
         return this.m_shieldBreakPower;
      }
      
      public function get ShieldBreakKBConstant() : Number
      {
         return this.m_shieldBreakKBConstant;
      }
      
      public function get ShieldBreakWeightKB() : Number
      {
         return this.m_shieldBreakWeightKB;
      }
      
      public function get ShieldXOffset() : Number
      {
         return this.m_shield_x_offset;
      }
      
      public function get ShieldYOffset() : Number
      {
         return this.m_shield_y_offset;
      }
      
      public function get ShieldScale() : Number
      {
         return this.m_shield_scale;
      }
      
      public function get SpecialType() : int
      {
         return this.m_special_type;
      }
      
      public function get NormalStatsID() : String
      {
         return this.m_normalStats_id;
      }
      
      public function get AlternateStatsID() : String
      {
         return this.m_alternateStats_id;
      }
      
      public function get SpecialStatsID() : String
      {
         return this.m_specialStats_id;
      }
      
      public function get Sounds() : Array
      {
         return this.m_sounds;
      }
      
      public function set Sounds(param1:Array) : void
      {
         this.m_sounds = param1;
      }
      
      public function get HurtFrames() : int
      {
         return this.m_hurtFrames;
      }
      
      public function get Attacks() : AttackData
      {
         return this.m_attacks;
      }
      
      public function get CanDodge() : Boolean
      {
         return this.m_canDodge;
      }
      
      public function get CanHoldItems() : Boolean
      {
         return this.m_canHoldItems;
      }
      
      public function get CanThrow() : Boolean
      {
         return this.m_canThrow;
      }
      
      public function get CanBeGrabbed() : Boolean
      {
         return this.m_canBeGrabbed;
      }
      
      public function get CanShield() : Boolean
      {
         return this.m_canShield;
      }
      
      public function get CanUseItems() : Boolean
      {
         return this.m_canUseItems;
      }
      
      public function get CanTaunt() : Boolean
      {
         return this.m_canTaunt;
      }
      
      public function get CanBarrel() : Boolean
      {
         return this.m_canBarrel;
      }
      
      public function get CanGrabLedges() : Boolean
      {
         return this.m_canGrabLedges;
      }
      
      public function get CanUseSpecials() : Boolean
      {
         return this.m_canUseSpecials;
      }
      
      public function get CanStarKO() : Boolean
      {
         return this.m_canStarKO;
      }
      
      public function get GrabDamage() : int
      {
         return this.m_grabDamage;
      }
      
      public function get DamageIncrease() : Number
      {
         return this.m_damageIncrease;
      }
      
      public function get DamageIncreaseInterval() : int
      {
         return this.m_damageIncreaseInterval;
      }
      
      public function get HeavyArmor() : Number
      {
         return this.m_heavyArmor;
      }
      
      public function get WindArmor() : Number
      {
         return this.m_windArmor;
      }
      
      public function get LaunchResistance() : Number
      {
         return this.m_launchResistance;
      }
      
      public function get CustomShield() : Boolean
      {
         return this.m_customShield;
      }
      
      public function get CustomShieldStartup() : int
      {
         return this.m_customShieldStartup;
      }
      
      public function get CrouchWalkSpeed() : Number
      {
         return this.m_crouchWalkSpeed;
      }
      
      public function get VolumeSFX() : Number
      {
         return this.m_volume_sfx;
      }
      
      public function get VolumeVFX() : Number
      {
         return this.m_volume_vfx;
      }
      
      public function get ForceTransformTime() : int
      {
         return this.m_forceTransformTime;
      }
      
      public function get ForceTransformID() : String
      {
         return this.m_forceTransformID;
      }
      
      public function get FSTimer() : int
      {
         return this.m_fs_time_limit;
      }
      
      public function get FSMagnet() : Boolean
      {
         return this.m_fs_magnet;
      }
      
      public function get MinShieldSize() : Number
      {
         return this.m_minShieldSize;
      }
      
      public function get MaxShieldSize() : Number
      {
         return this.m_maxShieldSize;
      }
      
      public function get StatusEffectImmunity() : Boolean
      {
         return this.m_statusEffectImmunity;
      }
      
      public function get GroundToAirMultiplier() : Number
      {
         return this.m_groundToAirMultiplier;
      }
      
      public function get FinalSmashCutin() : String
      {
         return this.m_finalSmashCutin;
      }
      
      public function get DamageRatio() : Number
      {
         return this.m_damageRatio;
      }
      
      public function get AttackRatio() : Number
      {
         return this.m_attackRatio;
      }
      
      public function get UnlimitedFinal() : Boolean
      {
         return this.m_unlimitedFinal;
      }
      
      public function get FinalSmashMeter() : Boolean
      {
         return this.m_finalSmashMeter;
      }
      
      public function get StartDamage() : Number
      {
         return this.m_startDamage;
      }
      
      override public function importData(param1:Object) : Boolean
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:Boolean = true;
         var _loc5_:String = this.m_seriesIcon;
         if(param1 != null)
         {
            if(Boolean(Main.DEBUG) && "roll_delay" in param1)
            {
               MenuController.debugConsole.alert("Warning: roll_delay field is deprecated and should be removed in character \'" + (param1.statsName || this.m_statsName) + "\'");
            }
            for(_loc2_ in param1)
            {
               if(this["m_" + _loc2_] !== undefined)
               {
                  if(_loc2_ == "sounds")
                  {
                     for(_loc3_ in param1[_loc2_])
                     {
                        this.m_sounds[_loc3_] = param1[_loc2_][_loc3_];
                     }
                  }
                  else
                  {
                     this["m_" + _loc2_] = param1[_loc2_];
                  }
               }
               else
               {
                  _loc4_ = false;
                  trace("You tried to set \"m_" + _loc2_ + "\" but it doesn\'t exist in the CharacterData class.");
               }
            }
            if(this.m_volume_sfx > 1)
            {
               this.m_volume_sfx = 1;
            }
            else if(this.m_volume_sfx < 0)
            {
               this.m_volume_sfx = 0;
            }
            if(this.m_volume_vfx > 1)
            {
               this.m_volume_vfx = 1;
            }
            else if(this.m_volume_vfx < 0)
            {
               this.m_volume_vfx = 0;
            }
         }
         if(_loc5_)
         {
            this.m_seriesIcon = _loc5_;
         }
         return _loc4_;
      }
      
      public function importAttacks(param1:Object) : void
      {
         if(param1 != null)
         {
            this.m_attacks.importAttacks(param1);
         }
      }
      
      public function addProjectiles(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:ProjectileAttack = null;
         if(param1 != null)
         {
            for(_loc2_ in param1)
            {
               _loc3_ = new ProjectileAttack();
               _loc3_.importData(param1[_loc2_]);
               this.m_attacks.addProjectile(_loc2_,_loc3_);
            }
         }
      }
      
      public function addItems(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:ItemData = null;
         if(param1 != null)
         {
            for(_loc2_ in param1)
            {
               _loc3_ = new ItemData();
               _loc3_.importData(param1[_loc2_]);
               this.m_attacks.addItem(_loc2_,_loc3_);
            }
         }
      }
      
      override public function exportData() : Object
      {
         var _loc1_:* = undefined;
         var _loc4_:int = 0;
         var _loc2_:Object = super.exportData();
         var _loc3_:Object = new Object();
         var _loc5_:* = null;
         _loc3_.classAPI = m_classAPI;
         _loc3_.statsName = this.m_statsName;
         _loc3_.displayName = this.m_displayName;
         _loc3_.linkage_id = m_linkage_id;
         _loc3_.linkage_id2 = this.m_linkage_id2;
         _loc3_.linkage_id_special = this.m_linkage_id_special;
         _loc3_.thumbnail = this.m_thumbnail;
         _loc3_.seriesIcon = this.m_seriesIcon;
         _loc3_.width = m_width;
         _loc3_.height = m_height;
         _loc3_.cam_width = this.m_cam_width;
         _loc3_.cam_height = this.m_cam_height;
         _loc3_.cam_x_offset = this.m_cam_x_offset;
         _loc3_.cam_y_offset = this.m_cam_y_offset;
         _loc3_.deathSwitchID = this.m_deathSwitchID;
         _loc3_.revivalEffect = this.m_revivalEffect;
         _loc3_.jumpSpeed = this.m_jumpSpeed;
         _loc3_.jumpSpeedMidair = this.m_jumpSpeedMidair;
         _loc3_.jumpSpeedList = this.m_jumpSpeedList;
         _loc3_.shortHopSpeed = this.m_shortHopSpeed;
         _loc3_.jumpStartup = this.m_jumpStartup;
         _loc3_.max_jumpSpeed = this.m_max_jumpSpeed;
         _loc3_.midAirTurn = this.m_midAirTurn;
         _loc3_.midAirHover = this.m_midAirHover;
         _loc3_.midAirJumpConstant = this.m_midAirJumpConstant;
         _loc3_.midAirJumpConstantDelay = this.m_midAirJumpConstantDelay;
         _loc3_.midAirJumpConstantAccel = this.m_midAirJumpConstantAccel;
         _loc3_.wallJump = this.m_wallJump;
         _loc3_.wallStick = this.m_wallStick;
         _loc3_.airDodgeSpeed = this.m_airDodgeSpeed;
         _loc3_.dodgeSpeed = this.m_dodgeSpeed;
         _loc3_.dodgeStartup = this.m_dodgeStartup;
         _loc3_.dodgeDecel = this.m_dodgeDecel;
         _loc3_.tiltTossMultiplier = this.m_tiltTossMultiplier;
         _loc3_.smashTossMultiplier = this.m_smashTossMultiplier;
         _loc3_.gravity = m_gravity;
         _loc3_.weight1 = m_weight1;
         _loc3_.power = this.m_power;
         _loc3_.norm_xSpeed = this.m_norm_xSpeed;
         _loc3_.max_xSpeed = this.m_max_xSpeed;
         _loc3_.max_ySpeed = m_max_ySpeed;
         _loc3_.fastFallSpeed = this.m_fastFallSpeed;
         _loc3_.accel_start = this.m_accel_start;
         _loc3_.accel_start_dash = this.m_accel_start_dash;
         _loc3_.accel_rate = this.m_accel_rate;
         _loc3_.accel_rate_air = this.m_accel_rate_air;
         _loc3_.decel_rate = this.m_decel_rate;
         _loc3_.decel_rate_air = this.m_decel_rate_air;
         _loc3_.glideSpeed = this.m_glideSpeed;
         _loc3_.holdJump = this.m_holdJump;
         _loc3_.max_jump = this.m_max_jump;
         _loc3_.max_projectile = m_max_projectile;
         _loc3_.tetherGrab = this.m_tetherGrab;
         _loc3_.roll_speed = this.m_roll_speed;
         _loc3_.roll_decay = this.m_roll_decay;
         _loc3_.roll_decay_ice = this.m_roll_decay_ice;
         _loc3_.getup_roll_delay = this.m_getup_roll_delay;
         _loc3_.tech_roll_delay = this.m_tech_roll_delay;
         _loc3_.climb_roll_delay = this.m_climb_roll_delay;
         _loc3_.itemScaleRatio = this.m_itemScaleRatio;
         _loc3_.shieldBreakPower = this.m_shieldBreakPower;
         _loc3_.shieldBreakKBConstant = this.m_shieldBreakKBConstant;
         _loc3_.shieldBreakWeightKB = this.m_shieldBreakWeightKB;
         _loc3_.shield_x_offset = this.m_shield_x_offset;
         _loc3_.shield_y_offset = this.m_shield_y_offset;
         _loc3_.shield_scale = this.m_shield_scale;
         _loc3_.special_type = this.m_special_type;
         _loc3_.normalStats_id = this.m_normalStats_id;
         _loc3_.alternateStats_id = this.m_alternateStats_id;
         _loc3_.specialStats_id = this.m_specialStats_id;
         _loc3_.sounds = new Array();
         for(_loc5_ in this.m_sounds)
         {
            _loc3_.sounds[_loc5_] = this.m_sounds[_loc5_];
         }
         _loc3_.hurtFrames = this.m_hurtFrames;
         _loc3_.canDodge = this.m_canDodge;
         _loc3_.canHoldItems = this.m_canHoldItems;
         _loc3_.canShield = this.m_canShield;
         _loc3_.canThrow = this.m_canThrow;
         _loc3_.canBeGrabbed = this.m_canBeGrabbed;
         _loc3_.canUseItems = this.m_canUseItems;
         _loc3_.canTaunt = this.m_canTaunt;
         _loc3_.canBarrel = this.m_canBarrel;
         _loc3_.canGrabLedges = this.m_canGrabLedges;
         _loc3_.canUseSpecials = this.m_canUseSpecials;
         _loc3_.canStarKO = this.m_canStarKO;
         _loc3_.canReceiveKnockback = m_canReceiveKnockback;
         _loc3_.canReceiveDamage = m_canReceiveDamage;
         _loc3_.grabDamage = this.m_grabDamage;
         _loc3_.damageIncrease = this.m_damageIncrease;
         _loc3_.damageIncreaseInterval = this.m_damageIncreaseInterval;
         _loc3_.heavyArmor = this.m_heavyArmor;
         _loc3_.windArmor = this.m_windArmor;
         _loc3_.launchResistance = this.m_launchResistance;
         _loc3_.customShield = this.m_customShield;
         _loc3_.customShieldStartup = this.m_customShieldStartup;
         _loc3_.crouchWalkSpeed = this.m_crouchWalkSpeed;
         _loc3_.volume_sfx = this.m_volume_sfx;
         _loc3_.volume_vfx = this.m_volume_vfx;
         _loc3_.forceTransformTime = this.m_forceTransformTime;
         _loc3_.forceTransformID = this.m_forceTransformID;
         _loc3_.fs_time_limit = this.m_fs_time_limit;
         _loc3_.fs_magnet = this.m_fs_magnet;
         _loc3_.minShieldSize = this.m_minShieldSize;
         _loc3_.maxShieldSize = this.m_maxShieldSize;
         _loc3_.statusEffectImmunity = this.m_statusEffectImmunity;
         _loc3_.groundToAirMultiplier = this.m_groundToAirMultiplier;
         _loc3_.finalSmashCutin = this.m_finalSmashCutin;
         for(_loc1_ in _loc2_)
         {
            if(!(_loc1_ in _loc3_))
            {
               _loc3_[_loc1_] = _loc2_[_loc1_];
            }
         }
         _loc3_.attackRatio = this.m_attackRatio;
         _loc3_.damageRatio = this.m_damageRatio;
         _loc3_.unlimitedFinal = this.m_unlimitedFinal;
         _loc3_.finalSmashMeter = this.m_finalSmashMeter;
         _loc3_.startDamage = this.m_startDamage;
         return _loc3_;
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


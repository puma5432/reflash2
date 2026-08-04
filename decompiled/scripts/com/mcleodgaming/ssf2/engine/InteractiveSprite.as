package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.api.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.enemies.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.events.*;
   import com.mcleodgaming.ssf2.items.*;
   import com.mcleodgaming.ssf2.platforms.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.events.Event;
   import flash.geom.*;
   import flash.text.*;
   
   public class InteractiveSprite
   {
      
      public static var SHOW_HITBOXES:Boolean = false;
      
      public var HITBOXES_WAS_ON:Boolean = false;
      
      protected var m_uid:int;
      
      protected var m_state:uint;
      
      protected var m_hitBoxManager:HitBoxManager;
      
      protected var m_apiInstance:SSF2GameObject;
      
      protected var m_delayPlayback:Boolean;
      
      protected var m_delayPlayBackAnimation:String;
      
      protected var m_delayPlayBackFrame:String;
      
      protected var m_delayPlayBackFacingRight:Boolean;
      
      protected var m_delayPlayBackHitStun:Boolean;
      
      protected var STAGE:MovieClip;
      
      protected var STAGEPARENT:MovieClip;
      
      protected var STAGEEFFECTS:MovieClip;
      
      protected var CAM:Vcam;
      
      protected var STAGEDATA:StageData;
      
      protected var m_baseStats:InteractiveSpriteStats;
      
      protected var m_sprite:MovieClip;
      
      protected var m_collision:Collision;
      
      protected var m_width:Number;
      
      protected var m_height:Number;
      
      protected var m_terrains:Vector.<Platform>;
      
      protected var m_platforms:Vector.<Platform>;
      
      protected var m_eventManager:EventManager;
      
      protected var m_tempEvents:Vector.<Object>;
      
      protected var m_timers:Vector.<IntervalTimer>;
      
      protected var m_sizeRatio:Number;
      
      protected var m_currentPlatform:Platform;
      
      protected var m_gravity:Number;
      
      protected var m_max_ySpeed:Number;
      
      protected var m_xSpeed:Number;
      
      protected var m_ySpeed:Number;
      
      protected var m_facingForward:Boolean;
      
      protected var m_started:Boolean;
      
      protected var m_hitPlatform:Platform;
      
      protected var m_collisionPoint:Point;
      
      protected var m_selfPlatform:MovingPlatform;
      
      protected var m_player_id:int;
      
      protected var m_team_id:int;
      
      protected var m_healthBoxMC:MovieClip;
      
      protected var m_damage:Number;
      
      protected var m_attack:AttackState;
      
      protected var m_attackCache:AttackState;
      
      protected var m_attackData:AttackData;
      
      protected var m_skipAttackCollisionTests:Boolean;
      
      protected var m_skipAttackProcessing:Boolean;
      
      protected var m_attackCollisionTestsPreProcessed:Boolean;
      
      protected var m_lastHitID:int;
      
      protected var m_lastHitObject:AttackDamage;
      
      protected var m_lastAttackID:Array;
      
      protected var m_lastAttackIndex:int;
      
      protected var m_lastStaleID:Array;
      
      protected var m_lastStaleIndex:int;
      
      protected var m_xKnockback:Number;
      
      protected var m_yKnockback:Number;
      
      protected var m_xKnockbackDecay:Number;
      
      protected var m_yKnockbackDecay:Number;
      
      protected var m_knockbackStackingTimer:FrameTimer;
      
      protected var m_knockbackStacked:Boolean;
      
      protected var m_counterAttackData:Object;
      
      protected var m_invincible:Boolean;
      
      protected var m_intangible:Boolean;
      
      protected var m_actionShot:Boolean;
      
      protected var m_actionTimer:int;
      
      protected var m_actionTimerUpdatedOnFrame:Boolean;
      
      protected var m_paralysis:Boolean;
      
      protected var m_paralysisHitCount:int;
      
      protected var m_paralysisTimer:int;
      
      protected var m_maxParalysisTime:FrameTimer;
      
      protected var m_hitStunToggle:Boolean;
      
      protected var m_hitStunTimer:int;
      
      protected var m_weight2:Number;
      
      protected var m_cancelEffectDelay:FrameTimer;
      
      protected var m_cancelEffectDelay2:FrameTimer;
      
      protected var m_cancelEffectCount:int;
      
      protected var m_cancelEffect:String;
      
      protected var m_bypassCollisionTesting:Boolean;
      
      private var m_globalVariables:Object;
      
      protected var m_framesSinceLastState:int;
      
      protected var m_shadowEffect:MovieClip;
      
      protected var m_reflectionEffect:MovieClip;
      
      protected var m_fadeTimer:FrameTimer;
      
      protected var m_hurtInterrupt:Function;
      
      protected var m_targetInterrupt:Function;
      
      protected var m_warningBounds_lower:Array;
      
      protected var m_warningBounds_upper:Array;
      
      protected var m_currentAnimationID:String;
      
      protected var m_paletteSwapData:Object;
      
      protected var m_paletteSwapPAData:Object;
      
      protected var m_shortestPath:Vector.<Beacon>;
      
      protected var m_currentTarget:Target;
      
      protected var m_targetTemp:Target;
      
      protected var m_previousAnimation:String;
      
      private var __locationCached:Point;
      
      private var __boundsRectCached:Rectangle;
      
      private var __currentScaleCached:Point;
      
      private var __attemptToMovePointCache:Point;
      
      public function InteractiveSprite(param1:MovieClip, param2:StageData, param3:Boolean = true)
      {
         var _loc4_:int = 0;
         this.__locationCached = new Point();
         this.__boundsRectCached = new Rectangle();
         this.__currentScaleCached = new Point();
         this.__attemptToMovePointCache = new Point();
         super();
         this.m_globalVariables = new Object();
         this.m_attack = new AttackState(this);
         this.m_attackCache = new AttackState(this);
         this.m_state = 0;
         this.STAGEDATA = param2;
         this.STAGE = this.STAGEDATA.StageRef;
         this.STAGEPARENT = this.STAGEDATA.StageParentRef;
         this.STAGEEFFECTS = this.STAGEDATA.StageEffectsRef;
         this.CAM = this.STAGEDATA.CamRef;
         this.m_uid = Utils.getUID();
         if(param3)
         {
            this.m_sprite = MovieClip(this.STAGE.addChild(param1));
         }
         else
         {
            this.m_sprite = param1;
         }
         this.m_delayPlayback = false;
         this.m_delayPlayBackAnimation = null;
         this.m_delayPlayBackFrame = null;
         this.m_delayPlayBackFacingRight = true;
         this.m_delayPlayBackHitStun = false;
         this.m_collision = new Collision();
         this.m_healthBoxMC = null;
         this.m_damage = this.m_baseStats.Stamina > 0 ? this.m_baseStats.Stamina : 0;
         this.m_currentPlatform = null;
         this.m_gravity = 0;
         this.m_max_ySpeed = 0;
         this.m_xSpeed = 0;
         this.m_ySpeed = 0;
         this.m_sizeRatio = 1;
         this.m_facingForward = true;
         this.m_terrains = this.STAGEDATA.Terrains;
         this.m_platforms = this.STAGEDATA.Platforms;
         this.m_started = false;
         this.m_collisionPoint = new Point();
         this.m_hitPlatform = null;
         this.m_selfPlatform = null;
         this.m_counterAttackData = null;
         this.m_eventManager = new EventManager();
         this.m_tempEvents = new Vector.<Object>();
         this.m_timers = new Vector.<IntervalTimer>();
         this.m_player_id = -1;
         this.m_team_id = -1;
         this.m_lastHitID = 0;
         this.m_lastHitObject = null;
         this.m_lastAttackIndex = 0;
         this.m_lastAttackID = new Array(60);
         this.m_shadowEffect = new MovieClip();
         this.m_reflectionEffect = new MovieClip();
         _loc4_ = 0;
         while(_loc4_ < this.m_lastAttackID.length)
         {
            this.m_lastAttackID[_loc4_] = 0;
            _loc4_++;
         }
         this.m_lastStaleIndex = 0;
         this.m_lastStaleID = new Array(60);
         _loc4_ = 0;
         while(_loc4_ < this.m_lastStaleID.length)
         {
            this.m_lastStaleID[_loc4_] = 0;
            _loc4_++;
         }
         this.m_xKnockback = 0;
         this.m_yKnockback = 0;
         this.m_xKnockbackDecay = 0;
         this.m_yKnockbackDecay = 0;
         this.m_knockbackStackingTimer = new FrameTimer(5);
         this.m_knockbackStacked = false;
         this.m_invincible = false;
         this.m_intangible = false;
         this.m_actionShot = false;
         this.m_actionTimer = 0;
         this.m_paralysis = false;
         this.m_paralysisHitCount = 0;
         this.m_paralysisTimer = 0;
         this.m_maxParalysisTime = new FrameTimer(15);
         this.m_maxParalysisTime.finish();
         this.m_hitStunTimer = 0;
         this.m_hitStunToggle = false;
         this.m_weight2 = Utils.VELOCITY_SCALE * Utils.WEIGHT2_BASE;
         this.m_cancelEffectDelay = new FrameTimer(10);
         this.m_cancelEffectDelay2 = new FrameTimer(60);
         this.m_cancelEffectCount = 0;
         this.m_cancelEffect = "effect_cancel";
         this.m_bypassCollisionTesting = false;
         this.m_framesSinceLastState = 0;
         this.m_fadeTimer = new FrameTimer(15);
         this.m_hurtInterrupt = null;
         this.m_targetInterrupt = null;
         this.m_warningBounds_lower = new Array(this.STAGEDATA.getWarningBounds_LL(),this.STAGEDATA.getWarningBounds_LR());
         this.m_warningBounds_upper = new Array(this.STAGEDATA.getWarningBounds_UL(),this.STAGEDATA.getWarningBounds_UR());
         this.m_skipAttackCollisionTests = false;
         this.m_skipAttackProcessing = false;
         this.m_attackCollisionTestsPreProcessed = false;
         this.m_shortestPath = null;
         this.m_currentTarget = new Target();
         this.m_targetTemp = new Target();
         this.m_previousAnimation = null;
         this.m_currentAnimationID = this.m_sprite.xframe || this.m_sprite.currentLabel || null;
         this.m_paletteSwapData = null;
         this.m_paletteSwapPAData = null;
      }
      
      public static function hitTest(param1:InteractiveSprite, param2:InteractiveSprite, param3:uint, param4:uint, param5:Function = null, param6:HitBoxProcessor = null, param7:Boolean = false) : Vector.<HitBoxCollisionResult>
      {
         var _loc8_:HitBoxAnimation = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Rectangle = null;
         var _loc12_:HitBoxCollisionResult = null;
         var _loc13_:int = 0;
         var _loc14_:Vector.<HitBoxCollisionResult> = null;
         var _loc15_:Array = null;
         var _loc16_:Array = null;
         if(!param1.hitboxManager.HasHitBoxes || !param2.hitboxManager.HasHitBoxes)
         {
            return new Vector.<HitBoxCollisionResult>();
         }
         if(param3 == HitBoxSprite.SHIELD && Boolean(param1 as Character))
         {
            _loc15_ = Character(param1).ShieldHitBoxes;
         }
         else if(param3 == HitBoxSprite.STAR && Boolean(param1 as Character))
         {
            _loc15_ = Character(param1).StarHitBoxes;
         }
         else if(param3 == HitBoxSprite.EGG && Boolean(param1 as Character))
         {
            _loc15_ = Character(param1).EggHitBoxes;
         }
         else if(param3 == HitBoxSprite.FREEZE && Boolean(param1 as Character))
         {
            _loc15_ = Character(param1).FreezeHitBoxes;
         }
         else if(param3 == HitBoxSprite.PICKUP && Boolean(param1 as Character))
         {
            _loc15_ = Character(param1).PickupHitBoxes;
         }
         else
         {
            _loc15_ = param1.CurrentAnimation.getHitBoxes(param1.CurrentFrameNum,param3);
         }
         if(param4 == HitBoxSprite.SHIELD && Boolean(param2 as Character))
         {
            _loc16_ = Character(param2).ShieldHitBoxes;
         }
         else if(param4 == HitBoxSprite.STAR && Boolean(param4 as Character))
         {
            _loc16_ = Character(param2).StarHitBoxes;
         }
         else if(param4 == HitBoxSprite.EGG && Boolean(param2 as Character))
         {
            _loc16_ = Character(param2).EggHitBoxes;
         }
         else if(param4 == HitBoxSprite.FREEZE && Boolean(param2 as Character))
         {
            _loc16_ = Character(param2).FreezeHitBoxes;
         }
         else if(param4 == HitBoxSprite.PICKUP && Boolean(param2 as Character))
         {
            _loc16_ = Character(param2).PickupHitBoxes;
         }
         else
         {
            _loc8_ = param2.CurrentAnimation;
            _loc16_ = Boolean(param2) && Boolean(_loc8_) ? _loc8_.getHitBoxes(param2.CurrentFrameNum,param4) : null;
            if(!_loc8_)
            {
               SSF2API.print("Warning!!! Missing hitboxes for animation detected in MC. Current label: " + param2.MC.currentLabel + " Frame #: " + param2.MC.currentFrame);
            }
         }
         var _loc17_:int = 6;
         if(param3 == HitBoxSprite.GRAB || param4 === HitBoxSprite.GRAB)
         {
            _loc17_ = 0;
         }
         else if(param3 == HitBoxSprite.COUNTER || param4 === HitBoxSprite.COUNTER)
         {
            _loc17_ = 1;
         }
         else if(param3 == HitBoxSprite.REVERSE || param4 === HitBoxSprite.REVERSE)
         {
            _loc17_ = 2;
         }
         else if(param3 == HitBoxSprite.ATTACK && param4 === HitBoxSprite.ATTACK)
         {
            _loc17_ = 3;
         }
         else if(param3 == HitBoxSprite.GRAB && param4 === HitBoxSprite.GRAB)
         {
            _loc17_ = 4;
         }
         else if(param3 == HitBoxSprite.SHIELDPROJECTILE || param4 === HitBoxSprite.SHIELDPROJECTILE)
         {
            _loc17_ = 5;
         }
         if(param7)
         {
            _loc14_ = new Vector.<HitBoxCollisionResult>();
            if(_loc15_ == null || _loc16_ == null)
            {
               return _loc14_;
            }
            _loc9_ = 0;
            while(_loc9_ < _loc15_.length)
            {
               _loc10_ = 0;
               while(_loc10_ < _loc16_.length)
               {
                  _loc11_ = _loc15_[_loc9_].hitTest(_loc16_[_loc10_],param1.Location,param2.Location,!param1.FacingForward,!param2.FacingForward,param1.CurrentScale,param2.CurrentScale,param1.CurrentRotation,param2.CurrentRotation);
                  if(_loc11_)
                  {
                     _loc12_ = new HitBoxCollisionResult(_loc15_[_loc9_],_loc16_[_loc10_],new HitBoxSprite(_loc15_[_loc9_].Type,_loc11_,_loc15_[_loc9_].Circular,_loc15_[_loc9_].CustomData));
                     _loc14_.push(_loc12_);
                     if(param5 != null && Boolean(param5(param2,_loc12_)))
                     {
                        return _loc14_;
                     }
                  }
                  _loc10_++;
               }
               _loc9_++;
            }
         }
         else
         {
            _loc14_ = HitBoxSprite.hitTestArray(_loc15_,_loc16_,param1.Location,param2.Location,!param1.FacingForward,!param2.FacingForward,param1.CurrentScale,param2.CurrentScale,param1.CurrentRotation,param2.CurrentRotation);
            if(_loc14_.length > 0 && param5 != null)
            {
               _loc13_ = 0;
               while(_loc13_ < _loc14_.length)
               {
                  if(param6)
                  {
                     param6.queue(new HitBoxProcessorNode(param1,param2,_loc14_[_loc13_],param5),_loc17_);
                  }
                  else
                  {
                     param5(param2,_loc14_[_loc13_]);
                  }
                  _loc13_++;
               }
            }
         }
         return _loc14_;
      }
      
      public function get ID() : int
      {
         return this.m_player_id;
      }
      
      public function get UID() : int
      {
         return this.m_uid;
      }
      
      public function get APIInstance() : SSF2GameObject
      {
         return this.m_apiInstance;
      }
      
      public function get Team() : int
      {
         return this.m_team_id;
      }
      
      public function set Team(param1:int) : void
      {
         if(param1 === -1 || param1 >= 1 && param1 <= 3)
         {
            this.m_team_id = param1;
         }
      }
      
      public function get EventManagerObj() : EventManager
      {
         return this.m_eventManager;
      }
      
      public function get TempEventObj() : Vector.<Object>
      {
         return this.m_tempEvents;
      }
      
      public function get ActionShot() : Boolean
      {
         return this.m_actionShot;
      }
      
      public function get SelfPlatform() : MovingPlatform
      {
         return this.m_selfPlatform;
      }
      
      public function get Location() : Point
      {
         this.__locationCached.setTo(this.m_sprite.x,this.m_sprite.y);
         return this.__locationCached;
      }
      
      public function get BoundsRect() : Rectangle
      {
         this.__boundsRectCached.setTo(this.m_sprite.x - this.m_width / 2 * this.m_sizeRatio,this.m_sprite.y - this.m_height * this.m_sizeRatio,this.m_width * this.m_sizeRatio,this.m_height * this.m_sizeRatio);
         return this.__boundsRectCached;
      }
      
      public function get CurrentAnimation() : HitBoxAnimation
      {
         return this.m_hitBoxManager == null ? null : (this.m_hitBoxManager.HitBoxAnimationList.length <= 0 || !this.m_currentAnimationID ? null : this.m_hitBoxManager.getHitBoxAnimation(this.m_currentAnimationID));
      }
      
      public function get CurrentFrame() : String
      {
         return this.m_sprite.xframe != null ? this.m_sprite.xframe : this.m_currentAnimationID;
      }
      
      public function get CurrentFrameNum() : int
      {
         return this.HasStance ? int(this.m_sprite.stance.currentFrame) : this.m_sprite.currentFrame;
      }
      
      public function get CurrentScale() : Point
      {
         this.__currentScaleCached.setTo(Utils.fastAbs(this.m_sprite.scaleX),Utils.fastAbs(this.m_sprite.scaleY));
         return this.__currentScaleCached;
      }
      
      public function get CurrentRotation() : Number
      {
         return Utils.forceBase360(360 - this.m_sprite.rotation);
      }
      
      public function get CollisionObj() : Collision
      {
         return this.m_collision;
      }
      
      public function get Width() : Number
      {
         return this.m_width;
      }
      
      public function get FacingForward() : Boolean
      {
         return this.m_facingForward;
      }
      
      public function get Height() : Number
      {
         return this.m_height;
      }
      
      public function get OnPlatform() : Boolean
      {
         return this.m_currentPlatform != null && this.STAGEDATA.Platforms.indexOf(this.m_currentPlatform) >= 0;
      }
      
      public function get OnTerrain() : Boolean
      {
         return this.m_currentPlatform != null && this.STAGEDATA.Terrains.indexOf(this.m_currentPlatform) >= 0;
      }
      
      public function get Weight2() : Number
      {
         return this.m_weight2;
      }
      
      public function set Weight2(param1:Number) : void
      {
         this.m_weight2 = param1;
      }
      
      public function get LastHitID() : int
      {
         return this.m_lastHitID;
      }
      
      public function get X() : Number
      {
         return this.m_sprite.x;
      }
      
      public function get Y() : Number
      {
         return this.m_sprite.y;
      }
      
      public function set X(param1:Number) : void
      {
         this.m_sprite.x = param1;
      }
      
      public function set Y(param1:Number) : void
      {
         this.m_sprite.y = param1;
      }
      
      public function get XSpeed() : Number
      {
         return this.m_xSpeed;
      }
      
      public function set XSpeed(param1:Number) : void
      {
         this.m_xSpeed = param1;
      }
      
      public function get YSpeed() : Number
      {
         return this.m_ySpeed;
      }
      
      public function set YSpeed(param1:Number) : void
      {
         this.m_ySpeed = param1;
      }
      
      public function get GlobalX() : Number
      {
         return this.m_sprite.x;
      }
      
      public function get GlobalY() : Number
      {
         return this.m_sprite.y;
      }
      
      public function get OverlayX() : Number
      {
         return this.m_sprite.x + this.STAGEDATA.StageRef.x;
      }
      
      public function get OverlayY() : Number
      {
         return this.m_sprite.y + this.STAGEDATA.StageRef.y;
      }
      
      public function get Ground() : Boolean
      {
         return this.m_collision.ground as Boolean;
      }
      
      public function get MC() : MovieClip
      {
         return this.m_sprite;
      }
      
      public function get CurrentPlatform() : Platform
      {
         return this.m_currentPlatform;
      }
      
      public function get Depth() : Number
      {
         return !this.m_sprite.parent ? 0 : this.m_sprite.parent.getChildIndex(this.m_sprite);
      }
      
      public function get HasMC() : Boolean
      {
         return Boolean(this.m_sprite != null);
      }
      
      public function get HasStance() : Boolean
      {
         return Boolean(this.HasMC && this.m_sprite.stance != null);
      }
      
      public function get HasHand() : Boolean
      {
         return Boolean(this.HasStance && this.CurrentAnimation && this.CurrentAnimation.getHitBoxes(this.CurrentFrameNum,HitBoxSprite.HAND));
      }
      
      public function get HasHitBox() : Boolean
      {
         return Boolean(this.HasStance && this.CurrentAnimation && this.CurrentAnimation.getHitBoxes(this.CurrentFrameNum,HitBoxSprite.HIT));
      }
      
      public function get HasAttackBox() : Boolean
      {
         return Boolean(this.HasStance && this.CurrentAnimation && this.CurrentAnimation.getHitBoxes(this.CurrentFrameNum,HitBoxSprite.ATTACK));
      }
      
      public function get HasReverseBox() : Boolean
      {
         return Boolean(this.HasStance && this.CurrentAnimation && this.CurrentAnimation.getHitBoxes(this.CurrentFrameNum,HitBoxSprite.REVERSE));
      }
      
      public function get HasAbsorbBox() : Boolean
      {
         return Boolean(this.HasStance && this.CurrentAnimation && this.CurrentAnimation.getHitBoxes(this.CurrentFrameNum,HitBoxSprite.ABSORB));
      }
      
      public function get HasShieldAttackBox() : Boolean
      {
         return Boolean(this.HasStance && this.CurrentAnimation && this.CurrentAnimation.getHitBoxes(this.CurrentFrameNum,HitBoxSprite.SHIELDATTACK));
      }
      
      public function get HasShieldProjectileBox() : Boolean
      {
         return Boolean(this.HasStance && this.CurrentAnimation && this.CurrentAnimation.getHitBoxes(this.CurrentFrameNum,HitBoxSprite.SHIELDPROJECTILE));
      }
      
      public function get HasCamBox() : Boolean
      {
         return Boolean(this.HasStance && this.CurrentAnimation && this.CurrentAnimation.getHitBoxes(this.CurrentFrameNum,HitBoxSprite.CAM));
      }
      
      public function get HasGrabBox() : Boolean
      {
         return Boolean(this.HasStance && this.CurrentAnimation && this.CurrentAnimation.getHitBoxes(this.CurrentFrameNum,HitBoxSprite.GRAB));
      }
      
      public function get HasGrabber() : Boolean
      {
         return Boolean(this.HasStance && this.m_sprite.stance.grabber != null);
      }
      
      public function get HasItemBox() : Boolean
      {
         return Boolean(this.HasStance && this.CurrentAnimation && this.CurrentAnimation.getHitBoxes(this.CurrentFrameNum,HitBoxSprite.ITEM));
      }
      
      public function get HasHatBox() : Boolean
      {
         return Boolean(this.HasStance && this.CurrentAnimation && this.CurrentAnimation.getHitBoxes(this.CurrentFrameNum,HitBoxSprite.HAT));
      }
      
      public function get HasTouchBox() : Boolean
      {
         return Boolean(this.HasStance && this.CurrentAnimation && this.CurrentAnimation.getHitBoxes(this.CurrentFrameNum,HitBoxSprite.TOUCH));
      }
      
      public function get HasRange() : Boolean
      {
         return Boolean(this.HasStance && this.m_sprite.stance.range != null);
      }
      
      public function get HasHoming() : Boolean
      {
         return Boolean(this.HasStance && this.CurrentAnimation && this.CurrentAnimation.getHitBoxes(this.CurrentFrameNum,HitBoxSprite.HOMING));
      }
      
      public function get HasCatchBox() : Boolean
      {
         return Boolean(this.HasStance && this.CurrentAnimation && this.CurrentAnimation.getHitBoxes(this.CurrentFrameNum,HitBoxSprite.CATCH));
      }
      
      public function get HasCounterBox() : Boolean
      {
         return Boolean(this.HasStance && this.CurrentAnimation && this.CurrentAnimation.getHitBoxes(this.CurrentFrameNum,HitBoxSprite.COUNTER));
      }
      
      public function get HasPLockBox() : Boolean
      {
         return Boolean(this.HasStance && this.CurrentAnimation && this.CurrentAnimation.getHitBoxes(this.CurrentFrameNum,HitBoxSprite.PLOCK));
      }
      
      public function get PickupHitBoxes() : Array
      {
         return null;
      }
      
      public function get ShieldHitBoxes() : Array
      {
         return null;
      }
      
      public function get StarHitBoxes() : Array
      {
         return null;
      }
      
      public function get EggHitBoxes() : Array
      {
         return null;
      }
      
      public function get FreezeHitBoxes() : Array
      {
         return null;
      }
      
      public function get hitboxManager() : HitBoxManager
      {
         return this.m_hitBoxManager;
      }
      
      public function get AttackDataObj() : AttackData
      {
         return this.m_attackData;
      }
      
      public function get AttackStateData() : AttackState
      {
         return this.m_attack;
      }
      
      public function get AttackCache() : AttackState
      {
         return this.m_attackCache;
      }
      
      public function get PreviousAttackID() : int
      {
         return this.m_lastAttackIndex == 0 ? int(this.m_lastAttackID[this.m_lastAttackID.length - 1]) : int(this.m_lastAttackID[this.m_lastAttackIndex - 1]);
      }
      
      public function get LastAttackID() : Array
      {
         return this.m_lastAttackID;
      }
      
      public function get LastHitObject() : AttackDamage
      {
         return this.m_lastHitObject;
      }
      
      public function get LastAttackIndex() : int
      {
         return this.m_lastAttackIndex;
      }
      
      public function get Stance() : MovieClip
      {
         return this.HasStance ? this.m_sprite.stance : null;
      }
      
      public function get SizeRatio() : Number
      {
         return this.m_sizeRatio;
      }
      
      public function get Invincible() : Boolean
      {
         return this.isInvincible();
      }
      
      public function get Intangible() : Boolean
      {
         return this.isIntangible();
      }
      
      public function set SizeRatio(param1:Number) : void
      {
         this.m_sizeRatio = param1;
         this.m_sprite.scaleX = this.m_sprite.scaleX > 0 ? this.m_sizeRatio : -this.m_sizeRatio;
         this.m_sprite.scaleY = this.m_sprite.scaleY > 0 ? this.m_sizeRatio : -this.m_sizeRatio;
      }
      
      public function get BypassCollisionTesting() : Boolean
      {
         return this.m_bypassCollisionTesting;
      }
      
      public function set BypassCollisionTesting(param1:Boolean) : void
      {
         this.m_bypassCollisionTesting = param1;
      }
      
      public function get HurtInterrupt() : Function
      {
         return this.m_hurtInterrupt;
      }
      
      public function set HurtInterrupt(param1:Function) : void
      {
         this.m_hurtInterrupt = param1;
      }
      
      public function get TargetInterrupt() : Function
      {
         return this.m_targetInterrupt;
      }
      
      public function set TargetInterrupt(param1:Function) : void
      {
         this.m_targetInterrupt = param1;
      }
      
      public function get PreviousAnimation() : String
      {
         return this.m_previousAnimation;
      }
      
      public function get HealthBox() : MovieClip
      {
         return this.m_healthBoxMC;
      }
      
      public function get SkipAttackCollisionTests() : Boolean
      {
         return this.m_skipAttackCollisionTests;
      }
      
      public function get SkipAttackProcessing() : Boolean
      {
         return this.m_skipAttackProcessing;
      }
      
      public function get AttackCollisionTestsPreProcessed() : Boolean
      {
         return this.m_attackCollisionTestsPreProcessed;
      }
      
      public function get PaletteSwapData() : Object
      {
         return this.m_paletteSwapData;
      }
      
      public function set PaletteSwapData(param1:Object) : void
      {
         this.m_paletteSwapData = param1;
      }
      
      public function get PaletteSwapPAData() : Object
      {
         return this.m_paletteSwapPAData;
      }
      
      public function set PaletteSwapPAData(param1:Object) : void
      {
         this.m_paletteSwapPAData = param1;
      }
      
      protected function buildHitBoxData(param1:String, param2:Boolean = true) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         this.m_hitBoxManager = HitBoxManager.getOrCreate(param1);
         if(param2)
         {
            for(_loc3_ in this.m_attackData.ProjectilesArray)
            {
               if(ProjectileAttack(this.m_attackData.ProjectilesArray[_loc3_]).LinkageID)
               {
                  HitBoxManager.getOrCreate(ProjectileAttack(this.m_attackData.ProjectilesArray[_loc3_]).LinkageID);
               }
            }
            for(_loc4_ in this.m_attackData.ItemsArray)
            {
               if(ItemData(this.m_attackData.ItemsArray[_loc4_]).LinkageID)
               {
                  HitBoxManager.getOrCreate(ItemData(this.m_attackData.ItemsArray[_loc4_]).LinkageID);
               }
            }
         }
      }
      
      public function setInvincibility(param1:Boolean) : void
      {
         this.m_invincible = param1;
      }
      
      public function setIntangibility(param1:Boolean) : void
      {
         this.m_intangible = param1;
      }
      
      public function playSound(param1:*, param2:Boolean = false) : int
      {
         if(param1 is Array)
         {
            return this.STAGEDATA.SoundQueueRef.playChainedAudio(param1,param2);
         }
         if(param2)
         {
            return this.STAGEDATA.SoundQueueRef.playVoiceEffect(param1);
         }
         return this.STAGEDATA.SoundQueueRef.playSoundEffect(param1);
      }
      
      public function stopSound(param1:int) : void
      {
         this.STAGEDATA.SoundQueueRef.stopSound(param1);
      }
      
      public function applyPalette(param1:MovieClip) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Array = [];
         while(Boolean(this.m_sprite.filters) && _loc3_ < this.m_sprite.filters.length)
         {
            _loc2_.push(this.m_sprite.filters[_loc3_].clone());
            _loc3_++;
         }
         param1.filters = _loc2_;
      }
      
      public function updatePaletteSwap() : void
      {
         if(Boolean(this.m_paletteSwapData) && this.HasStance)
         {
            Utils.replacePalette(this.m_sprite.stance,this.m_paletteSwapData,2);
         }
      }
      
      public function setPaletteSwap(param1:Object, param2:Object) : void
      {
         this.m_paletteSwapData = param1;
         this.m_paletteSwapPAData = param2;
         if(this.m_healthBoxMC)
         {
            Utils.replacePalette(this.m_healthBoxMC.charHead,this.m_paletteSwapPAData,1,true,true);
         }
         this.updatePaletteSwap();
      }
      
      public function updateColorFilter(param1:DisplayObject, param2:int, param3:String, param4:int = -1) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Character = null;
         var _loc8_:String = Utils.getColorString(param2);
         var _loc9_:Object = ResourceManager.getCostume(param3,_loc8_,param4);
         if(_loc9_ == null)
         {
            _loc9_ = Utils.getCostumeObject();
         }
         if(_loc9_ != null)
         {
            if(param2 > 0)
            {
               _loc5_ = 0;
               _loc6_ = 0;
               while(_loc6_ < this.STAGEDATA.Players.length)
               {
                  _loc7_ = this.STAGEDATA.Players[_loc6_];
                  if(_loc7_ != null)
                  {
                     if(_loc7_ == this)
                     {
                        break;
                     }
                     if(_loc7_.Team == param2 && _loc7_ !== this && this is Character && _loc7_.StatsName == Character(this).StatsName)
                     {
                        _loc5_++;
                     }
                  }
                  _loc6_++;
               }
               if(_loc5_ == 1)
               {
                  _loc9_.redOffset = _loc9_.redOffset || 0;
                  _loc9_.greenOffset = _loc9_.greenOffset || 0;
                  _loc9_.blueOffset = _loc9_.blueOffset || 0;
                  _loc9_.redOffset += 60;
                  _loc9_.greenOffset += 60;
                  _loc9_.blueOffset += 60;
               }
               else if(_loc5_ == 2)
               {
                  _loc9_.redOffset = _loc9_.redOffset || 0;
                  _loc9_.greenOffset = _loc9_.greenOffset || 0;
                  _loc9_.blueOffset = _loc9_.blueOffset || 0;
                  _loc9_.redOffset -= 60;
                  _loc9_.greenOffset -= 60;
                  _loc9_.blueOffset -= 60;
               }
            }
            else
            {
               _loc9_.brightness = _loc9_.brightness || 0;
            }
            Utils.setColorFilter(param1,_loc9_);
         }
         this.setPaletteSwap(_loc9_.paletteSwap || null,_loc9_.paletteSwapPA || null);
      }
      
      public function updateColorFilterAPI(param1:Object) : void
      {
         if(param1 == null)
         {
            param1 = Utils.getCostumeObject();
         }
         if(param1 != null)
         {
            Utils.setColorFilter(this.m_sprite,param1);
         }
      }
      
      public function attachHealthBox(param1:String, param2:String, param3:String, param4:int = -1, param5:String = null, param6:int = -1) : void
      {
         var _loc7_:MovieClip = null;
         if(!this.m_healthBoxMC)
         {
            this.m_healthBoxMC = ResourceManager.getLibraryMC("DamageCounter");
         }
         this.m_healthBoxMC.visible = true;
         this.m_healthBoxMC.cacheAsBitmap = true;
         if(this.m_healthBoxMC.charHead.getChildByName("charhead"))
         {
            this.m_healthBoxMC.charHead.removeChild(this.m_healthBoxMC.charHead.getChildByName("charhead"));
         }
         _loc7_ = ResourceManager.getLibraryMC(param2);
         if(_loc7_ != null)
         {
            _loc7_.name = "charhead";
            this.m_healthBoxMC.charHead.addChild(_loc7_);
         }
         _loc7_ = ResourceManager.getLibraryMC(param3);
         if(_loc7_ != null)
         {
            _loc7_.name = "icon";
            this.m_healthBoxMC.icon.addChild(_loc7_);
            this.applyPalette(this.m_healthBoxMC.charHead);
            Utils.replacePalette(this.m_healthBoxMC.charHead,this.m_paletteSwapPAData,1,true,true);
            if(param4 > 0 && !ModeFeatures.hasFeature(ModeFeatures.IGNORE_TEAM_COSTUME,this.STAGEDATA.GameRef.GameMode))
            {
               switch(param4)
               {
                  case 1:
                     Utils.setTint(this.m_healthBoxMC.icon,1,1,1,1,90,0,0,0);
                     break;
                  case 2:
                     Utils.setTint(this.m_healthBoxMC.icon,1,1,1,1,0,90,0,0);
                     break;
                  case 3:
                     Utils.setTint(this.m_healthBoxMC.icon,1,1,1,1,0,0,90,0);
                     break;
                  case 4:
                     Utils.setTint(this.m_healthBoxMC.icon,1,1,1,1,90,72,0,0);
               }
            }
            else
            {
               switch(this.m_player_id)
               {
                  case 1:
                     Utils.setTint(this.m_healthBoxMC.icon,1,1,1,1,90,0,0,0);
                     break;
                  case 2:
                     Utils.setTint(this.m_healthBoxMC.icon,1,1,1,1,0,0,90,0);
                     break;
                  case 3:
                     Utils.setTint(this.m_healthBoxMC.icon,1,1,1,1,90,90,0,0);
                     break;
                  case 4:
                     Utils.setTint(this.m_healthBoxMC.icon,1,1,1,1,0,90,0,0);
               }
               if(this.STAGEDATA.GameRef.GameMode == Mode.TRAINING && this.m_player_id > 1)
               {
                  Utils.setTint(this.m_healthBoxMC.icon,1,1,1,1,0,0,0,0);
               }
            }
         }
         if(!ModeFeatures.hasFeature(ModeFeatures.IGNORE_TEAM_COSTUME,this.STAGEDATA.GameRef.GameMode))
         {
            if(param4 < 0)
            {
               switch(this.m_player_id)
               {
                  case 1:
                     Utils.tryToGotoAndStop(this.m_healthBoxMC.damageBox,"team1");
                     Utils.tryToGotoAndStop(this.m_healthBoxMC.damageStrike,"team1");
                     break;
                  case 2:
                     Utils.tryToGotoAndStop(this.m_healthBoxMC.damageBox,"team3");
                     Utils.tryToGotoAndStop(this.m_healthBoxMC.damageStrike,"team3");
                     break;
                  case 3:
                     Utils.tryToGotoAndStop(this.m_healthBoxMC.damageBox,"team4");
                     Utils.tryToGotoAndStop(this.m_healthBoxMC.damageStrike,"team4");
                     break;
                  case 4:
                     Utils.tryToGotoAndStop(this.m_healthBoxMC.damageBox,"team2");
                     Utils.tryToGotoAndStop(this.m_healthBoxMC.damageStrike,"team2");
               }
            }
            else
            {
               Utils.tryToGotoAndStop(this.m_healthBoxMC.damageBox,"team" + param4);
               Utils.tryToGotoAndStop(this.m_healthBoxMC.damageStrike,"team" + param4);
            }
         }
         else
         {
            switch(this.m_player_id)
            {
               case 1:
                  Utils.tryToGotoAndStop(this.m_healthBoxMC.damageBox,"team1");
                  Utils.tryToGotoAndStop(this.m_healthBoxMC.damageStrike,"team1");
                  break;
               case 2:
                  Utils.tryToGotoAndStop(this.m_healthBoxMC.damageBox,"team3");
                  Utils.tryToGotoAndStop(this.m_healthBoxMC.damageStrike,"team3");
                  break;
               case 3:
                  Utils.tryToGotoAndStop(this.m_healthBoxMC.damageBox,"team4");
                  Utils.tryToGotoAndStop(this.m_healthBoxMC.damageStrike,"team4");
                  break;
               case 4:
                  Utils.tryToGotoAndStop(this.m_healthBoxMC.damageBox,"team2");
                  Utils.tryToGotoAndStop(this.m_healthBoxMC.damageStrike,"team2");
            }
            if(this.m_player_id > 1)
            {
               Utils.tryToGotoAndStop(this.m_healthBoxMC.damageBox,"team-1");
               Utils.tryToGotoAndStop(this.m_healthBoxMC.damageStrike,"team-1");
            }
         }
         this.m_healthBoxMC.charName.text = param1;
         this.setDamage(this.m_damage);
         if(this.m_healthBoxMC.score)
         {
            this.m_healthBoxMC.score.visible = false;
            this.m_healthBoxMC.scoreLabel.visible = false;
         }
         this.STAGEDATA.HudRef.addHealthBox(this.m_healthBoxMC);
      }
      
      public function detachHealthBox() : void
      {
         this.STAGEDATA.HudRef.removeHealthBox(this.m_healthBoxMC);
         this.m_healthBoxMC = null;
      }
      
      public function getDamage() : Number
      {
         return this.m_damage;
      }
      
      public function dealDamage(param1:Number) : void
      {
         this.setDamage(this.m_baseStats.Stamina > 0 ? this.m_damage - param1 : this.m_damage + param1);
      }
      
      public function healDamage(param1:Number) : void
      {
         this.setDamage(this.m_baseStats.Stamina > 0 ? Math.min(this.m_baseStats.Stamina,this.m_damage + param1) : this.m_damage - param1);
      }
      
      public function setDamage(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         if(param1 > 999)
         {
            param1 = 999;
         }
         else if(param1 < 0)
         {
            param1 = 0;
         }
         if(this.m_baseStats.Stamina > 0 && this.m_damage > this.m_baseStats.Stamina)
         {
            param1 = this.m_baseStats.Stamina;
         }
         var _loc6_:Number = param1 - this.m_damage;
         this.m_damage = param1;
         if(this.m_healthBoxMC != null)
         {
            this.m_healthBoxMC.damageMC_holder.damageMC.damage.text = this.m_damage > 0 && this.m_damage < 1.5 ? 1 : Math.ceil(this.m_damage);
            this.m_healthBoxMC.percent_mc.damage.text = this.m_baseStats.Stamina > 0 ? "HP" : "%";
            _loc2_ = 0;
            if(this.m_baseStats.Stamina > 0)
            {
               _loc2_ = this.m_damage < 50 ? 1 : 1 - Math.max(1,this.m_damage - 50) / Math.max(1,this.m_baseStats.Stamina - 50);
            }
            else
            {
               _loc2_ = this.m_damage > 300 ? 1 : this.m_damage / 300;
            }
            _loc3_ = _loc2_ < 0.6 ? 255 : uint(255 - 128 * ((_loc2_ - 0.6) / 0.6));
            _loc4_ = _loc2_ >= 0.6 ? 0 : uint(255 - 255 * (_loc2_ / 0.6));
            _loc5_ = _loc2_ >= 0.6 ? 0 : uint(255 - 255 * (_loc2_ / 0.6));
            TextField(this.m_healthBoxMC.damageMC_holder.damageMC.damage).textColor = (_loc3_ << 16) + (_loc4_ << 8) + _loc5_;
            TextField(this.m_healthBoxMC.percent_mc.damage).textColor = (_loc3_ << 16) + (_loc4_ << 8) + _loc5_;
         }
         if(_loc6_ !== 0)
         {
            this.m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.DAMAGE_CHANGED,{
               "caller":this.APIInstance.instance,
               "damage":_loc6_
            }));
         }
      }
      
      public function throbDamageCounter() : void
      {
         if(this.m_healthBoxMC != null)
         {
            if(this.m_healthBoxMC.damageMC_holder)
            {
               this.m_healthBoxMC.damageMC_holder.damage = this.m_damage;
            }
            this.m_healthBoxMC.damageMC_holder.gotoAndPlay("throb");
         }
      }
      
      public function inLowerLeftWarningBounds() : Boolean
      {
         this.updateWarningCollision();
         return this.m_collision.lbound_lower;
      }
      
      public function inUpperLeftWarningBounds() : Boolean
      {
         this.updateWarningCollision();
         return this.m_collision.lbound_upper;
      }
      
      public function inLowerRightWarningBounds() : Boolean
      {
         this.updateWarningCollision();
         return this.m_collision.rbound_lower;
      }
      
      public function inUpperRightWarningBounds() : Boolean
      {
         this.updateWarningCollision();
         return this.m_collision.rbound_upper;
      }
      
      public function updateWarningCollision() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < this.m_warningBounds_lower[0].length && !_loc1_)
         {
            if(this.m_warningBounds_lower[0][_loc3_].hitTestPoint(this.GlobalX,this.GlobalY,true))
            {
               _loc1_ = true;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.m_warningBounds_lower[1].length && !_loc2_)
         {
            if(this.m_warningBounds_lower[1][_loc3_].hitTestPoint(this.GlobalX,this.GlobalY,true))
            {
               _loc2_ = true;
            }
            _loc3_++;
         }
         this.m_collision.lbound_lower = _loc1_;
         this.m_collision.rbound_lower = _loc2_;
         _loc1_ = false;
         _loc2_ = false;
         _loc3_ = 0;
         while(_loc3_ < this.m_warningBounds_upper[0].length && !_loc1_)
         {
            if(this.m_warningBounds_upper[0][_loc3_].hitTestPoint(this.GlobalX,this.GlobalY,true))
            {
               _loc1_ = true;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.m_warningBounds_upper[1].length && !_loc2_)
         {
            if(this.m_warningBounds_upper[1][_loc3_].hitTestPoint(this.GlobalX,this.GlobalY,true))
            {
               _loc2_ = true;
            }
            _loc3_++;
         }
         this.m_collision.lbound_upper = _loc1_;
         this.m_collision.rbound_upper = _loc2_;
      }
      
      public function getNearestPath(param1:String, param2:Boolean = true, param3:Boolean = true) : Array
      {
         var _loc4_:* = 0;
         var _loc5_:Array = [];
         this.m_shortestPath = null;
         this.getNearestOpponent(param1,param2,param3);
         if(this.m_currentTarget.CurrentTarget)
         {
            this.getNearestOpponent(param1,param2,param3);
            this.checkPotentialBeaconPath(param1,param2,param3);
            if(this.m_shortestPath !== null)
            {
               _loc4_ = int(this.m_shortestPath.length - 1);
               while(_loc4_ >= 0)
               {
                  _loc5_.push(this.m_shortestPath[_loc4_]);
                  _loc4_--;
               }
            }
            _loc5_.push(this.m_targetTemp.CurrentTarget);
         }
         return _loc5_;
      }
      
      protected function getNearestTarget(param1:String, param2:Boolean = true, param3:Boolean = true) : Target
      {
         var _loc4_:Target = new Target();
         _loc4_.CurrentTarget = this.getNearest(param1,param2,param3);
         if(_loc4_.CurrentTarget)
         {
            _loc4_.Distance = Utils.getDistanceFrom(this,_loc4_.CurrentTarget);
         }
         return _loc4_.CurrentTarget == null ? null : _loc4_;
      }
      
      protected function getNearestOpponent(param1:String, param2:Boolean = true, param3:Boolean = true) : void
      {
         var _loc4_:Beacon = null;
         var _loc5_:Beacon = null;
         if(this.m_targetTemp.CurrentTarget != null && this.m_targetTemp.CurrentTarget.MC.parent == null)
         {
            this.m_targetTemp.CurrentTarget = null;
         }
         this.m_currentTarget.CurrentTarget = null;
         var _loc6_:Target = this.getNearestTarget(param1,param2,param3);
         if(_loc6_ != null)
         {
            this.m_currentTarget.CurrentTarget = _loc6_.CurrentTarget;
            this.m_targetTemp.CurrentTarget = this.m_currentTarget.CurrentTarget;
            this.m_currentTarget.setDistance(new Point(this.m_sprite.x,this.m_sprite.y));
            this.m_targetTemp.setDistance(new Point(this.m_sprite.x,this.m_sprite.y));
         }
         if(this.m_currentTarget != null && this.m_currentTarget.CurrentTarget != null && this.STAGEDATA.getBeacons().length > 0 && this.m_shortestPath == null && (this.m_currentTarget.Distance > 200 || !this.m_currentTarget.CurrentTarget.checkLinearPath(this)))
         {
            _loc4_ = Utils.getClosetBeaconTo(this.STAGEDATA,this.m_sprite);
            _loc5_ = Utils.getClosetBeaconTo(this.STAGEDATA,this.m_currentTarget.CurrentTarget.MC);
            if(_loc4_ != _loc5_)
            {
               this.m_shortestPath = Utils.getPath(this.STAGEDATA.getBeacons(),Utils.dijkstra(this.STAGEDATA,this.STAGEDATA.getBeacons(),this.STAGEDATA.getAdjMatrix(),_loc4_,_loc5_),_loc4_.BID,_loc5_.BID);
            }
         }
         else if(this.m_shortestPath != null)
         {
            this.m_currentTarget.CurrentTarget = this.m_shortestPath[this.m_shortestPath.length - 1];
            this.m_currentTarget.setDistance(new Point(this.m_sprite.x,this.m_sprite.y));
         }
      }
      
      protected function checkPotentialBeaconPath(param1:String, param2:Boolean = true, param3:Boolean = true) : void
      {
         if(this.m_targetTemp.CurrentTarget != null)
         {
            this.m_targetTemp.setDistance(new Point(this.m_sprite.x,this.m_sprite.y));
         }
         if(this.m_shortestPath != null && this.m_targetTemp.CurrentTarget != null && (this.m_targetTemp.Distance < 100 && this.m_targetTemp.CurrentTarget.checkLinearPath(this)))
         {
            this.m_shortestPath = null;
            this.m_currentTarget.CurrentTarget = this.m_targetTemp.CurrentTarget;
            this.m_targetTemp.CurrentTarget = null;
            this.getNearestOpponent(param1,param2,param3);
         }
         else if(this.m_shortestPath != null)
         {
            this.m_currentTarget.CurrentTarget = this.m_shortestPath[this.m_shortestPath.length - 1];
            this.m_currentTarget.setDistance(new Point(this.m_sprite.x,this.m_sprite.y));
            if(this.m_currentTarget.Distance < 50)
            {
               this.m_currentTarget.CurrentTarget = null;
               this.m_shortestPath.pop();
               if(this.m_shortestPath.length > 0 && !(this.m_targetTemp.CurrentTarget != null && this.m_targetTemp.CurrentTarget.checkLinearPath(this) && this.m_targetTemp.Distance < Utils.getDistanceFrom(this,this.m_shortestPath[this.m_shortestPath.length - 1])))
               {
                  this.m_currentTarget.CurrentTarget = this.m_shortestPath[this.m_shortestPath.length - 1];
               }
               else
               {
                  this.m_shortestPath = null;
                  this.getNearestOpponent(param1,param2,param3);
               }
            }
         }
      }
      
      public function getNearestLedge() : MovieClip
      {
         var _loc2_:MovieClip = null;
         var _loc4_:int = 0;
         var _loc1_:Array = this.STAGEDATA.getLedgesAPI();
         var _loc3_:Number = 0;
         while(_loc4_ < _loc1_.length)
         {
            if(!_loc2_ || _loc2_.x * this.m_sprite.x + _loc2_.y * this.m_sprite.y < _loc3_)
            {
               if(_loc2_)
               {
                  _loc3_ = Math.pow(_loc2_.x - this.m_sprite.x,2) + Math.pow(_loc2_.y - this.m_sprite.y,2);
               }
               _loc2_ = _loc1_[_loc4_];
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function forceOnGroundAPI(param1:Number = 200) : void
      {
         var _loc2_:Number = this.m_sprite.y;
         var _loc3_:Number = 0;
         if(this.m_currentPlatform)
         {
            return;
         }
         while(!(this.m_currentPlatform = this.testGroundWithCoord(this.m_sprite.x,this.m_sprite.y + 1)) && _loc3_ < param1)
         {
            ++this.m_sprite.y;
            _loc3_++;
         }
         if(!this.m_currentPlatform)
         {
            this.m_sprite.y = _loc2_;
         }
         else
         {
            this.m_collision.ground = true;
            this.attachToGround();
         }
      }
      
      public function forceAttack(param1:String, param2:* = null, param3:Boolean = false) : Boolean
      {
         return false;
      }
      
      public function getLinkageID() : String
      {
         return null;
      }
      
      public function getProjectiles() : Array
      {
         return [];
      }
      
      public function isInvincible() : Boolean
      {
         return this.m_invincible;
      }
      
      public function isIntangible() : Boolean
      {
         return this.m_intangible;
      }
      
      public function isHitStunOrParalysis() : Boolean
      {
         return this.inParalysis() || this.inHitStun();
      }
      
      public function inHitStun() : Boolean
      {
         return this.m_actionShot;
      }
      
      public function inParalysis() : Boolean
      {
         return this.m_paralysis;
      }
      
      protected function checkShowHitBoxes() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Rectangle = null;
         var _loc3_:int = 0;
         var _loc4_:Point = null;
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         var _loc7_:Point = null;
         var _loc8_:MovieClip = null;
         var _loc9_:MovieClip = null;
         if(InteractiveSprite.SHOW_HITBOXES)
         {
            this.HITBOXES_WAS_ON = true;
            _loc1_ = null;
            _loc2_ = null;
            _loc3_ = 0;
            _loc4_ = new Point();
            _loc5_ = new Point();
            _loc6_ = new Point();
            _loc7_ = new Point();
            _loc8_ = this.m_sprite.getChildByName("hBoxHolder") ? MovieClip(this.m_sprite.getChildByName("hBoxHolder")) : null;
            if(_loc8_)
            {
               _loc8_.graphics.clear();
            }
            if(this.HasHitBox)
            {
               if(!_loc8_)
               {
                  _loc8_ = new MovieClip();
                  _loc8_.name = "hBoxHolder";
                  this.m_sprite.addChild(_loc8_);
               }
               _loc1_ = this.CurrentAnimation.getHitBoxes(this.CurrentFrameNum,HitBoxSprite.HIT);
               _loc3_ = 0;
               while(_loc3_ < _loc1_.length)
               {
                  _loc2_ = _loc1_[_loc3_].BoundingBox;
                  _loc4_.x = _loc2_.x;
                  _loc4_.y = _loc2_.y;
                  _loc5_.x = _loc2_.x + _loc2_.width;
                  _loc5_.y = _loc2_.y;
                  _loc6_.x = _loc2_.x + _loc2_.width;
                  _loc6_.y = _loc2_.y + _loc2_.height;
                  _loc7_.x = _loc2_.x;
                  _loc7_.y = _loc2_.y + _loc2_.height;
                  _loc8_.graphics.beginFill(16763904,0.5);
                  _loc8_.graphics.moveTo(_loc4_.x,_loc4_.y);
                  _loc8_.graphics.lineTo(_loc5_.x,_loc5_.y);
                  _loc8_.graphics.lineTo(_loc6_.x,_loc6_.y);
                  _loc8_.graphics.lineTo(_loc7_.x,_loc7_.y);
                  _loc8_.graphics.lineTo(_loc4_.x,_loc4_.y);
                  _loc8_.graphics.endFill();
                  _loc8_.parent.setChildIndex(_loc8_,_loc8_.parent.numChildren - 1);
                  _loc3_++;
               }
            }
            if(this.HasAttackBox)
            {
               if(!_loc8_)
               {
                  _loc8_ = new MovieClip();
                  _loc8_.name = "hBoxHolder";
                  this.m_sprite.addChild(_loc8_);
               }
               _loc1_ = this.CurrentAnimation.getHitBoxes(this.CurrentFrameNum,HitBoxSprite.ATTACK);
               _loc3_ = 0;
               while(_loc3_ < _loc1_.length)
               {
                  _loc2_ = _loc1_[_loc3_].BoundingBox;
                  _loc4_.x = _loc2_.x;
                  _loc4_.y = _loc2_.y;
                  _loc5_.x = _loc2_.x + _loc2_.width;
                  _loc5_.y = _loc2_.y;
                  _loc6_.x = _loc2_.x + _loc2_.width;
                  _loc6_.y = _loc2_.y + _loc2_.height;
                  _loc7_.x = _loc2_.x;
                  _loc7_.y = _loc2_.y + _loc2_.height;
                  _loc8_.graphics.beginFill(16711680,0.5);
                  _loc8_.graphics.moveTo(_loc4_.x,_loc4_.y);
                  _loc8_.graphics.lineTo(_loc5_.x,_loc5_.y);
                  _loc8_.graphics.lineTo(_loc6_.x,_loc6_.y);
                  _loc8_.graphics.lineTo(_loc7_.x,_loc7_.y);
                  _loc8_.graphics.lineTo(_loc4_.x,_loc4_.y);
                  _loc8_.graphics.endFill();
                  _loc8_.parent.setChildIndex(_loc8_,_loc8_.parent.numChildren - 1);
                  _loc3_++;
               }
            }
            if(this.HasTouchBox)
            {
               if(!_loc8_)
               {
                  _loc8_ = new MovieClip();
                  _loc8_.name = "hBoxHolder";
                  this.m_sprite.addChild(_loc8_);
               }
               _loc1_ = this.CurrentAnimation.getHitBoxes(this.CurrentFrameNum,HitBoxSprite.TOUCH);
               _loc3_ = 0;
               while(_loc3_ < _loc1_.length)
               {
                  _loc2_ = _loc1_[_loc3_].BoundingBox;
                  _loc4_.x = _loc2_.x;
                  _loc4_.y = _loc2_.y;
                  _loc5_.x = _loc2_.x + _loc2_.width;
                  _loc5_.y = _loc2_.y;
                  _loc6_.x = _loc2_.x + _loc2_.width;
                  _loc6_.y = _loc2_.y + _loc2_.height;
                  _loc7_.x = _loc2_.x;
                  _loc7_.y = _loc2_.y + _loc2_.height;
                  _loc8_.graphics.beginFill(255,0.5);
                  _loc8_.graphics.moveTo(_loc4_.x,_loc4_.y);
                  _loc8_.graphics.lineTo(_loc5_.x,_loc5_.y);
                  _loc8_.graphics.lineTo(_loc6_.x,_loc6_.y);
                  _loc8_.graphics.lineTo(_loc7_.x,_loc7_.y);
                  _loc8_.graphics.lineTo(_loc4_.x,_loc4_.y);
                  _loc8_.graphics.endFill();
                  _loc8_.parent.setChildIndex(_loc8_,_loc8_.parent.numChildren - 1);
                  _loc3_++;
               }
            }
            if(this.HasGrabBox)
            {
               if(!_loc8_)
               {
                  _loc8_ = new MovieClip();
                  _loc8_.name = "hBoxHolder";
                  this.m_sprite.addChild(_loc8_);
               }
               _loc1_ = this.CurrentAnimation.getHitBoxes(this.CurrentFrameNum,HitBoxSprite.GRAB);
               _loc3_ = 0;
               while(_loc3_ < _loc1_.length)
               {
                  _loc2_ = _loc1_[_loc3_].BoundingBox;
                  _loc4_.x = _loc2_.x;
                  _loc4_.y = _loc2_.y;
                  _loc5_.x = _loc2_.x + _loc2_.width;
                  _loc5_.y = _loc2_.y;
                  _loc6_.x = _loc2_.x + _loc2_.width;
                  _loc6_.y = _loc2_.y + _loc2_.height;
                  _loc7_.x = _loc2_.x;
                  _loc7_.y = _loc2_.y + _loc2_.height;
                  _loc8_.graphics.beginFill(16711935,0.5);
                  _loc8_.graphics.moveTo(_loc4_.x,_loc4_.y);
                  _loc8_.graphics.lineTo(_loc5_.x,_loc5_.y);
                  _loc8_.graphics.lineTo(_loc6_.x,_loc6_.y);
                  _loc8_.graphics.lineTo(_loc7_.x,_loc7_.y);
                  _loc8_.graphics.lineTo(_loc4_.x,_loc4_.y);
                  _loc8_.graphics.endFill();
                  _loc8_.parent.setChildIndex(_loc8_,_loc8_.parent.numChildren - 1);
                  _loc3_++;
               }
            }
            if(this.HasHand)
            {
               if(!_loc8_)
               {
                  _loc8_ = new MovieClip();
                  _loc8_.name = "hBoxHolder";
                  this.m_sprite.addChild(_loc8_);
               }
               _loc1_ = this.CurrentAnimation.getHitBoxes(this.CurrentFrameNum,HitBoxSprite.HAND);
               _loc3_ = 0;
               while(_loc3_ < _loc1_.length)
               {
                  _loc2_ = _loc1_[_loc3_].BoundingBox;
                  _loc4_.x = _loc2_.x;
                  _loc4_.y = _loc2_.y;
                  _loc5_.x = _loc2_.x + _loc2_.width;
                  _loc5_.y = _loc2_.y;
                  _loc6_.x = _loc2_.x + _loc2_.width;
                  _loc6_.y = _loc2_.y + _loc2_.height;
                  _loc7_.x = _loc2_.x;
                  _loc7_.y = _loc2_.y + _loc2_.height;
                  _loc8_.graphics.beginFill(6737151,0.25);
                  _loc8_.graphics.moveTo(_loc4_.x,_loc4_.y);
                  _loc8_.graphics.lineTo(_loc5_.x,_loc5_.y);
                  _loc8_.graphics.lineTo(_loc6_.x,_loc6_.y);
                  _loc8_.graphics.lineTo(_loc7_.x,_loc7_.y);
                  _loc8_.graphics.lineTo(_loc4_.x,_loc4_.y);
                  _loc8_.graphics.endFill();
                  _loc8_.parent.setChildIndex(_loc8_,_loc8_.parent.numChildren - 1);
                  _loc3_++;
               }
            }
            if(this.HasCounterBox)
            {
               if(!_loc8_)
               {
                  _loc8_ = new MovieClip();
                  _loc8_.name = "hBoxHolder";
                  this.m_sprite.addChild(_loc8_);
               }
               _loc1_ = this.CurrentAnimation.getHitBoxes(this.CurrentFrameNum,HitBoxSprite.COUNTER);
               _loc3_ = 0;
               while(_loc3_ < _loc1_.length)
               {
                  _loc2_ = _loc1_[_loc3_].BoundingBox;
                  _loc4_.x = _loc2_.x;
                  _loc4_.y = _loc2_.y;
                  _loc5_.x = _loc2_.x + _loc2_.width;
                  _loc5_.y = _loc2_.y;
                  _loc6_.x = _loc2_.x + _loc2_.width;
                  _loc6_.y = _loc2_.y + _loc2_.height;
                  _loc7_.x = _loc2_.x;
                  _loc7_.y = _loc2_.y + _loc2_.height;
                  _loc8_.graphics.beginFill(31265,0.25);
                  _loc8_.graphics.moveTo(_loc4_.x,_loc4_.y);
                  _loc8_.graphics.lineTo(_loc5_.x,_loc5_.y);
                  _loc8_.graphics.lineTo(_loc6_.x,_loc6_.y);
                  _loc8_.graphics.lineTo(_loc7_.x,_loc7_.y);
                  _loc8_.graphics.lineTo(_loc4_.x,_loc4_.y);
                  _loc8_.graphics.endFill();
                  _loc8_.parent.setChildIndex(_loc8_,_loc8_.parent.numChildren - 1);
                  _loc3_++;
               }
            }
            _loc1_ = this.PickupHitBoxes;
            if(Boolean(_loc1_) && _loc1_.length > 0)
            {
               if(!_loc8_)
               {
                  _loc8_ = new MovieClip();
                  _loc8_.name = "hBoxHolder";
                  this.m_sprite.addChild(_loc8_);
               }
               _loc3_ = 0;
               while(_loc3_ < _loc1_.length)
               {
                  _loc2_ = _loc1_[_loc3_].BoundingBox;
                  _loc4_.x = _loc2_.x;
                  _loc4_.y = _loc2_.y;
                  _loc5_.x = _loc2_.x + _loc2_.width;
                  _loc5_.y = _loc2_.y;
                  _loc6_.x = _loc2_.x + _loc2_.width;
                  _loc6_.y = _loc2_.y + _loc2_.height;
                  _loc7_.x = _loc2_.x;
                  _loc7_.y = _loc2_.y + _loc2_.height;
                  _loc8_.graphics.beginFill(6750003,0.15);
                  _loc8_.graphics.moveTo(_loc4_.x,_loc4_.y);
                  _loc8_.graphics.lineTo(_loc5_.x,_loc5_.y);
                  _loc8_.graphics.lineTo(_loc6_.x,_loc6_.y);
                  _loc8_.graphics.lineTo(_loc7_.x,_loc7_.y);
                  _loc8_.graphics.lineTo(_loc4_.x,_loc4_.y);
                  _loc8_.graphics.endFill();
                  _loc8_.parent.setChildIndex(_loc8_,_loc8_.parent.numChildren - 1);
                  _loc3_++;
               }
            }
         }
         else if(this.HITBOXES_WAS_ON)
         {
            _loc9_ = this.m_sprite.getChildByName("hBoxHolder") ? MovieClip(this.m_sprite.getChildByName("hBoxHolder")) : null;
            if(_loc9_)
            {
               _loc9_.graphics.clear();
            }
            this.HITBOXES_WAS_ON = false;
         }
      }
      
      public function verifiyHitBoxData() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:AttackObject = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         if(!Main.DEBUG)
         {
            return;
         }
         while(_loc5_ < this.m_hitBoxManager.HitBoxAnimationList.length)
         {
            _loc1_ = this.m_hitBoxManager.HitBoxAnimationList[_loc5_].Name;
            _loc1_ = _loc1_ ? _loc1_.substr(_loc1_.indexOf("_") + 1) : "";
            if(_loc1_ != "item")
            {
               _loc2_ = 0;
               while(_loc2_ < this.m_hitBoxManager.HitBoxAnimationList[_loc5_].AttackBoxes.length)
               {
                  _loc3_ = this.m_attackData.getAttack(_loc1_);
                  if(Boolean(Main.DEBUG && _loc1_ != "star") && Boolean(_loc3_) && !_loc3_.AttackBoxes[this.m_hitBoxManager.HitBoxAnimationList[_loc5_].AttackBoxes[_loc2_].Name])
                  {
                     _loc4_ = "some object";
                     if(this is Character)
                     {
                        _loc4_ = Character(this).LinkageName;
                     }
                     else if(this is Projectile)
                     {
                        _loc4_ = Projectile(this).LinkageID;
                     }
                     else if(this is Item)
                     {
                        _loc4_ = Item(this).LinkageID;
                     }
                     else if(this is Enemy)
                     {
                        _loc4_ = Enemy(this).LinkageID;
                     }
                     if(MenuController.debugConsole)
                     {
                        MenuController.debugConsole.alert("Warning! Unstatted " + this.m_hitBoxManager.HitBoxAnimationList[_loc5_].AttackBoxes[_loc2_].Name + " found on " + _loc4_ + "\'s " + _loc1_ + " attack!");
                     }
                  }
                  _loc2_++;
               }
            }
            _loc5_++;
         }
      }
      
      public function hasHitBoxType(param1:int) : Boolean
      {
         if(param1 == HitBoxSprite.HIT)
         {
            return this.HasHitBox;
         }
         if(param1 == HitBoxSprite.ATTACK)
         {
            return this.HasAttackBox;
         }
         if(param1 == HitBoxSprite.REVERSE)
         {
            return this.HasReverseBox;
         }
         if(param1 == HitBoxSprite.ABSORB)
         {
            return this.HasAbsorbBox;
         }
         if(param1 == HitBoxSprite.SHIELDATTACK)
         {
            return this.HasShieldAttackBox;
         }
         if(param1 == HitBoxSprite.SHIELDPROJECTILE)
         {
            return this.HasShieldProjectileBox;
         }
         if(param1 == HitBoxSprite.CAM)
         {
            return this.HasCamBox;
         }
         if(param1 == HitBoxSprite.GRAB)
         {
            return this.HasGrabBox;
         }
         if(param1 == HitBoxSprite.ITEM)
         {
            return this.HasItemBox;
         }
         if(param1 == HitBoxSprite.HAT)
         {
            return this.HasHatBox;
         }
         if(param1 == HitBoxSprite.TOUCH)
         {
            return this.HasTouchBox;
         }
         if(param1 == HitBoxSprite.RANGE)
         {
            return this.HasRange;
         }
         if(param1 == HitBoxSprite.HOMING)
         {
            return this.HasHoming;
         }
         if(param1 == HitBoxSprite.CATCH)
         {
            return this.HasCatchBox;
         }
         if(param1 == HitBoxSprite.COUNTER)
         {
            return this.HasCounterBox;
         }
         if(param1 == HitBoxSprite.PLOCK)
         {
            return this.HasPLockBox;
         }
         return false;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Object = null) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:Object = {"persistent":false};
         if(!param3)
         {
            param3 = new Object();
         }
         for(_loc4_ in _loc5_)
         {
            if(param3[_loc4_] === undefined)
            {
               param3[_loc4_] = _loc5_[_loc4_];
            }
         }
         this.m_eventManager.addEventListener(param1,param2);
         if(!param3.persistent)
         {
            this.m_tempEvents.push({
               "type":param1,
               "listener":param2,
               "useCapture":false
            });
         }
      }
      
      public function hasEventListener(param1:String, param2:Function = null) : Boolean
      {
         return this.m_eventManager.hasEvent(param1,param2);
      }
      
      public function removeEventListener(param1:String, param2:Function) : void
      {
         this.m_eventManager.removeEventListener(param1,param2);
      }
      
      public function reactionMaster(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         return true;
      }
      
      public function reactionShield(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         return false;
      }
      
      public function reactionShieldAttack(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         return false;
      }
      
      public function reactionShieldProjectile(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         return false;
      }
      
      public function reactionAbsorb(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         return false;
      }
      
      public function reactionGrab(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         return false;
      }
      
      public function reactionReverse(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         return false;
      }
      
      public function reactionAttackReverse(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         return false;
      }
      
      public function reactionClank(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         return false;
      }
      
      public function reactionHit(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         return false;
      }
      
      public function reactionCollide(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         return false;
      }
      
      public function reactionCounter(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         return false;
      }
      
      public function reactionTouch(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         return false;
      }
      
      public function reactionRange(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         return false;
      }
      
      public function reactionCatch(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         return false;
      }
      
      public function clang(param1:AttackDamage, param2:HitBoxCollisionResult) : void
      {
      }
      
      public function handleHit(param1:InteractiveSprite, param2:AttackDamage, param3:HitBoxCollisionResult) : void
      {
      }
      
      public function cancelAttack(param1:AttackDamage, param2:HitBoxCollisionResult) : void
      {
      }
      
      public function setXSpeed(param1:Number, param2:Boolean = true) : void
      {
         if(param2)
         {
            this.m_xSpeed = param1;
         }
         else if(this.m_facingForward)
         {
            this.m_xSpeed = param1 > 0 ? Number(Utils.fastAbs(param1)) : -Utils.fastAbs(param1);
         }
         else
         {
            this.m_xSpeed = param1 < 0 ? Number(Utils.fastAbs(param1)) : -Utils.fastAbs(param1);
         }
      }
      
      public function forceHitStun(param1:int, param2:Number = -1) : void
      {
         this.startActionShot(param1);
      }
      
      protected function checkHitStun() : void
      {
         if(this.m_actionShot)
         {
            --this.m_actionTimer;
            --this.m_hitStunTimer;
            if(this.m_actionTimer < 0)
            {
               if(this.m_paralysis)
               {
                  this.m_actionShot = false;
               }
               else
               {
                  this.stopActionShot();
               }
            }
            else if(this.m_hitStunTimer <= 0)
            {
               this.m_hitStunTimer = 2;
               this.m_hitStunToggle = !this.m_hitStunToggle;
               this.m_attemptToMove(this.m_hitStunToggle ? 2 : -2,0);
            }
         }
         else if(this.m_paralysis)
         {
            --this.m_paralysisTimer;
            if(this.m_paralysisTimer < 0)
            {
               this.stopActionShot();
            }
            else if(this.m_hitStunTimer <= 0)
            {
               this.m_hitStunTimer = 2;
               this.m_hitStunToggle = !this.m_hitStunToggle;
               this.m_attemptToMove(this.m_hitStunToggle ? 4 : -4,0);
            }
         }
      }
      
      public function startActionShot(param1:int, param2:int = -1) : void
      {
         if(SpecialMode.modeEnabled(this.STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
         {
            return;
         }
         if(param1 > 0)
         {
            if(!this.m_actionShot)
            {
               if(this.HasStance)
               {
                  this.Stance.stop();
               }
               this.m_actionShot = true;
            }
            if(this.m_actionTimerUpdatedOnFrame)
            {
               this.m_actionTimer = Math.max(this.m_actionTimer,param1 - 1);
            }
            else
            {
               this.m_actionTimer = param1 - 1;
               this.m_actionTimerUpdatedOnFrame = true;
            }
         }
         if(param2 > 0 && this.m_paralysisHitCount < 3 && this.m_maxParalysisTime.IsComplete)
         {
            if(!this.m_paralysis)
            {
               if(this.HasStance)
               {
                  this.Stance.stop();
               }
               this.m_paralysis = true;
               this.m_paralysisHitCount = 1;
               this.m_paralysisTimer = param2 - 1;
            }
            else
            {
               ++this.m_paralysisHitCount;
               if(this.m_paralysisHitCount >= 3)
               {
                  this.stopActionShot();
                  return;
               }
            }
         }
      }
      
      public function stopActionShot(param1:Boolean = true, param2:Boolean = true) : void
      {
         if(this.m_actionShot && param1)
         {
            this.m_actionShot = false;
            this.m_controlFrames();
         }
         if(this.m_paralysis && param2)
         {
            this.m_paralysis = false;
            this.m_maxParalysisTime.reset();
            this.m_controlFrames();
         }
      }
      
      public function getGameObjectStat(param1:String) : *
      {
         return this.m_baseStats.getVar(param1);
      }
      
      public function updateAttackStats(param1:Object) : void
      {
         this.m_attack.importAttackStateData(param1);
      }
      
      public function getAttackStat(param1:String) : *
      {
         return this.m_attack.getVar(param1);
      }
      
      public function updateAttackBoxStats(param1:int, param2:Object) : void
      {
         var _loc4_:Boolean = false;
         var _loc3_:String = "attackBox";
         if(param1 > 1)
         {
            _loc3_ += param1;
         }
         this.m_attackData.setAttackBoxDataOverride(this.m_attack.Frame,_loc3_,param2);
      }
      
      public function getAttackBoxStat(param1:int, param2:String) : *
      {
         var _loc3_:String = "attackBox";
         if(param1 > 1)
         {
            _loc3_ += param1;
         }
         var _loc4_:AttackDamage = this.m_attackData.getAttackBoxData(this.m_attack.Frame,_loc3_).syncState(this.m_attack);
         return _loc4_.getVar(param2);
      }
      
      public function exportAttackBoxStats(param1:int, param2:String) : Object
      {
         var _loc3_:String = "attackBox";
         if(param1 > 1)
         {
            _loc3_ += param1;
         }
         var _loc4_:AttackDamage = this.m_attackData.getAttackBoxData(param2,_loc3_).syncState(this.m_attack);
         return _loc4_.exportAttackDamageData();
      }
      
      public function replaceAttackStats(param1:String, param2:Object) : void
      {
         this.m_attackData.getAttack(param1).importAttackData(param2);
      }
      
      public function replaceAttackBoxStats(param1:String, param2:int, param3:Object) : void
      {
         var _loc4_:AttackDamage = null;
         var _loc5_:String = "attackBox";
         if(param2 > 1)
         {
            _loc5_ += param2;
         }
         var _loc6_:AttackObject = this.m_attackData.getAttack(param1);
         if(_loc6_.AttackBoxes[_loc5_])
         {
            _loc4_ = _loc6_.AttackBoxes[_loc5_];
            _loc4_.importAttackDamageData(param3);
         }
      }
      
      public function refreshAttackID() : void
      {
         this.m_attack.AttackID = Utils.getUID();
      }
      
      public function refreshStaleID() : void
      {
         this.m_attack.ID = Utils.getUID();
      }
      
      public function getHitBox(param1:String) : Object
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc6_:HitBoxSprite = null;
         var _loc7_:Array = param1.match(/[a-zA-Z]+/g);
         var _loc8_:Array = param1.match(/[0-9]+/g);
         if(!_loc7_ || !_loc8_)
         {
            return null;
         }
         _loc2_ = _loc7_[0];
         _loc3_ = parseInt(_loc8_[0]) - 1;
         _loc4_ = {};
         _loc4_["attackBox"] = HitBoxSprite.ATTACK;
         _loc4_["hitBox"] = HitBoxSprite.HIT;
         _loc4_["grabBox"] = HitBoxSprite.GRAB;
         _loc4_["touchBox"] = HitBoxSprite.TOUCH;
         _loc4_["hand"] = HitBoxSprite.HAND;
         _loc4_["range"] = HitBoxSprite.RANGE;
         _loc4_["absorbBox"] = HitBoxSprite.ABSORB;
         _loc4_["counterBox"] = HitBoxSprite.COUNTER;
         _loc4_["shieldBox"] = HitBoxSprite.SHIELD;
         _loc4_["shieldAttackBox"] = HitBoxSprite.SHIELDATTACK;
         _loc4_["shieldProjectileBox"] = HitBoxSprite.SHIELDPROJECTILE;
         _loc4_["reverseBox"] = HitBoxSprite.REVERSE;
         _loc4_["catchBox"] = HitBoxSprite.CATCH;
         _loc4_["ledgeBox"] = HitBoxSprite.LEDGE;
         _loc4_["camBox"] = HitBoxSprite.CAM;
         _loc4_["homing"] = HitBoxSprite.HOMING;
         _loc4_["pLockBox"] = HitBoxSprite.PLOCK;
         _loc4_["hatBox"] = HitBoxSprite.HAT;
         _loc4_["itemBox"] = HitBoxSprite.ITEM;
         _loc4_["eggBox"] = HitBoxSprite.EGG;
         _loc4_["freezeBox"] = HitBoxSprite.FREEZE;
         _loc4_["starBox"] = HitBoxSprite.STAR;
         _loc4_["customBox"] = HitBoxSprite.CUSTOM;
         if(_loc4_[_loc2_])
         {
            _loc5_ = this.CurrentAnimation.getHitBoxes(this.CurrentFrameNum,_loc4_[_loc2_]);
            if(Boolean(_loc5_) && _loc3_ < _loc5_.length)
            {
               _loc6_ = _loc5_[_loc3_];
               return {
                  "x":_loc6_.BoundingBox.x,
                  "y":_loc6_.BoundingBox.y,
                  "width":_loc6_.BoundingBox.width,
                  "height":_loc6_.BoundingBox.height,
                  "rotation":_loc6_.rotation,
                  "xreg":_loc6_.xreg,
                  "yreg":_loc6_.yreg,
                  "scaleX":_loc6_.scaleX,
                  "scaleY":_loc6_.scaleY,
                  "transform":_loc6_.transform,
                  "depth":_loc6_.depth
               };
            }
            return null;
         }
         return null;
      }
      
      public function getHomingTarget() : InteractiveSprite
      {
         if(Boolean(this.m_attack) && Boolean(this.m_attack.HomingTarget))
         {
            return this.m_attack.HomingTarget;
         }
         return null;
      }
      
      public function getHomingTargetAPI() : *
      {
         if(Boolean(this.m_attack) && Boolean(this.m_attack.HomingTarget))
         {
            return this.m_attack.HomingTarget.APIInstance.instance;
         }
         return null;
      }
      
      public function homeTowardsTargetAPI(param1:Number, param2:InteractiveSprite) : void
      {
         var _loc3_:Number = NaN;
         if(Boolean(this.m_attack) && Boolean(param2))
         {
            _loc3_ = Number(Utils.getAngleBetween(new Point(this.m_sprite.x,this.m_sprite.y),new Point(param2.X,param2.Y)));
            this.m_xSpeed = Utils.calculateXSpeed(param1,_loc3_);
            this.m_ySpeed = -Utils.calculateYSpeed(param1,_loc3_);
            if(this.m_xSpeed > 0)
            {
               this.m_faceRight();
            }
            else
            {
               this.m_faceLeft();
            }
         }
      }
      
      protected function syncStats() : void
      {
      }
      
      public function setYSpeed(param1:Number) : void
      {
         this.m_ySpeed = param1;
         if(param1 < 0 && this.m_collision.ground)
         {
            this.unnattachFromGround();
         }
      }
      
      public function forceSetXSpeed(param1:Number) : void
      {
         this.m_xSpeed = param1;
      }
      
      public function forceSetYSpeed(param1:Number) : void
      {
         this.m_ySpeed = param1;
      }
      
      public function swapDepths(param1:InteractiveSprite) : void
      {
         if(param1 != null && param1.MC.parent == this.m_sprite.parent && this.m_sprite.parent != null)
         {
            this.m_sprite.parent.swapChildren(param1.MC,this.m_sprite);
         }
      }
      
      public function swapDepthsAPI(param1:InteractiveSprite) : void
      {
         if(param1 != null && param1.MC.parent == this.m_sprite.parent && this.m_sprite.parent != null)
         {
            this.m_sprite.parent.swapChildren(param1.MC,this.m_sprite);
         }
      }
      
      public function bringBehindAPI(param1:InteractiveSprite) : void
      {
         if(param1 != null && param1.MC.parent == this.m_sprite.parent && this.m_sprite.parent != null && this.Depth > param1.Depth)
         {
            this.m_sprite.parent.swapChildren(param1.MC,this.m_sprite);
         }
      }
      
      public function bringInFrontAPI(param1:InteractiveSprite) : void
      {
         if(param1 != null && param1.MC.parent == this.m_sprite.parent && this.m_sprite.parent != null && this.Depth < param1.Depth)
         {
            this.m_sprite.parent.swapChildren(param1.MC,this.m_sprite);
         }
      }
      
      public function updateSelfPlatform() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(this.m_selfPlatform)
         {
            this.m_selfPlatform.storeOldLocation();
            _loc1_ = this.m_sprite.x - this.m_selfPlatform.PreviousX;
            _loc2_ = this.m_sprite.y - this.m_selfPlatform.PreviousY;
            this.m_selfPlatform.setXSpeed(_loc1_);
            this.m_selfPlatform.setYSpeed(_loc2_);
         }
      }
      
      public function recover(param1:int) : Boolean
      {
         return false;
      }
      
      public function reverse(param1:int, param2:int, param3:Boolean) : Boolean
      {
         return false;
      }
      
      public function stackAttackID(param1:Number) : void
      {
         this.m_lastAttackID[this.m_lastAttackIndex] = param1;
         ++this.m_lastAttackIndex;
         if(this.m_lastAttackIndex >= this.m_lastAttackID.length)
         {
            this.m_lastAttackIndex = 0;
         }
      }
      
      public function attackIDArrayContains(param1:Number) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.m_lastAttackID.length)
         {
            if(this.m_lastAttackID[_loc2_] == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function stackStaleID(param1:Number) : void
      {
         this.m_lastStaleID[this.m_lastStaleIndex] = param1;
         ++this.m_lastStaleIndex;
         if(this.m_lastStaleIndex >= this.m_lastStaleID.length)
         {
            this.m_lastStaleIndex = 0;
         }
      }
      
      public function staleIDArrayContains(param1:Number) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.m_lastStaleID.length)
         {
            if(this.m_lastStaleID[_loc2_] == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function createSelfPlatform(param1:Number, param2:Number, param3:Number, param4:Number, param5:Boolean = true, param6:Class = null) : MovingPlatform
      {
         this.removeSelfPlatform();
         var _loc7_:MovieClip = new MovieClip();
         this.STAGE.addChild(_loc7_);
         _loc7_.graphics.beginFill(16711680,1);
         _loc7_.graphics.drawRect(param1,param2,param3,param4);
         _loc7_.graphics.endFill();
         _loc7_.visible = false;
         this.m_selfPlatform = new MovingPlatform(_loc7_,this.STAGEDATA,"ground",{"classAPI":param6});
         this.m_selfPlatform.SpriteOwner = this;
         if(param5)
         {
            this.STAGEDATA.Terrains.push(this.m_selfPlatform);
         }
         else
         {
            this.STAGEDATA.Platforms.push(this.m_selfPlatform);
         }
         this.STAGEDATA.MovingPlatforms.push(this.m_selfPlatform);
         this.updateSelfPlatform();
         if(this.m_selfPlatform.APIInstance)
         {
            this.m_selfPlatform.APIInstance.initialize();
         }
         this.m_selfPlatform.IgnoreList.push(this);
         return this.m_selfPlatform;
      }
      
      public function createSelfPlatformWithMC(param1:MovieClip, param2:Boolean = true, param3:Class = null) : MovingPlatform
      {
         this.removeSelfPlatform();
         this.STAGE.addChild(param1);
         this.m_selfPlatform = new MovingPlatform(param1,this.STAGEDATA,"ground",{"classAPI":param3});
         this.m_selfPlatform.SpriteOwner = this;
         if(param2)
         {
            this.STAGEDATA.Terrains.push(this.m_selfPlatform);
         }
         else
         {
            this.STAGEDATA.Platforms.push(this.m_selfPlatform);
         }
         this.STAGEDATA.MovingPlatforms.push(this.m_selfPlatform);
         if(this.m_selfPlatform.APIInstance)
         {
            this.m_selfPlatform.APIInstance.initialize();
         }
         this.m_selfPlatform.IgnoreList.push(this);
         return this.m_selfPlatform;
      }
      
      public function pushBackSlightly(param1:Boolean) : void
      {
         this.stackKnockback(3,param1 ? 0 : 180,this.m_xKnockback,this.m_yKnockback);
      }
      
      protected function m_convertForceToSpeed() : void
      {
         this.m_xSpeed += this.m_xKnockback;
         this.m_ySpeed += this.m_yKnockback;
         this.m_xKnockback = 0;
         this.m_yKnockback = 0;
      }
      
      public function resetRotation() : void
      {
         this.m_sprite.rotation = 0;
      }
      
      public function getKnockbackDecay() : Object
      {
         return {
            "x":this.m_xKnockbackDecay,
            "y":this.m_yKnockbackDecay
         };
      }
      
      public function setKnockbackDecay(param1:Number, param2:Number) : void
      {
         this.m_xKnockbackDecay = param1;
         this.m_yKnockbackDecay = param2;
      }
      
      public function resetKnockbackDecay() : void
      {
         var _loc1_:Number = Number(Utils.getAngleBetween(new Point(0,0),new Point(this.m_xKnockback,this.m_yKnockback)));
         this.m_xKnockbackDecay = -Utils.calculateXSpeed(this.m_weight2,_loc1_);
         this.m_yKnockbackDecay = Utils.calculateYSpeed(this.m_weight2,_loc1_);
      }
      
      protected function stackKnockback(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         var _loc7_:Number = 0;
         var _loc8_:Number = 0;
         _loc5_ = param1 * Math.cos(param2 * Math.PI / 180);
         _loc6_ = -param1 * Math.sin(param2 * Math.PI / 180);
         if(_loc5_ <= 0 && param3 >= 0 || _loc5_ >= 0 && param3 <= 0)
         {
            _loc7_ = _loc5_ + param3;
         }
         else if(Utils.fastAbs(_loc5_) > Utils.fastAbs(param3))
         {
            _loc7_ = _loc5_;
         }
         else
         {
            _loc7_ = param3;
         }
         if(_loc6_ <= 0 && param4 >= 0 || _loc6_ >= 0 && param4 <= 0)
         {
            _loc8_ = _loc6_ + param4;
         }
         else if(Utils.fastAbs(_loc6_) > Utils.fastAbs(param4))
         {
            _loc8_ = _loc6_;
         }
         else
         {
            _loc8_ = param4;
         }
         var _loc9_:Number = Number(Utils.getAngleBetween(new Point(0,0),new Point(_loc7_,_loc8_)));
         var _loc10_:Number = Number(Utils.calculateSpeed(_loc7_,_loc8_));
         param2 = _loc9_;
         if(this.m_knockbackStackingTimer.CurrentTime == 0 && _loc10_ < Utils.calculateSpeed(this.m_xKnockback,this.m_yKnockback))
         {
            return;
         }
         this.m_xKnockback = _loc10_ * Math.cos(_loc9_ * Math.PI / 180);
         this.m_yKnockback = -_loc10_ * Math.sin(_loc9_ * Math.PI / 180);
         this.resetKnockbackDecay();
         this.m_knockbackStackingTimer.reset();
      }
      
      protected function move() : void
      {
         this.applyGroundInfluence();
         this.m_sprite.x += this.m_xSpeed;
         this.m_sprite.y += this.m_ySpeed;
      }
      
      protected function gravity() : void
      {
         if(!this.m_collision.ground && this.m_ySpeed < this.m_max_ySpeed && !this.isHitStunOrParalysis())
         {
            this.m_ySpeed += this.m_gravity;
         }
      }
      
      public function decel(param1:Number) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Number = NaN;
         var _loc4_:Boolean = false;
         if(this.m_xSpeed == 0)
         {
            return;
         }
         if(!this.m_collision.ground)
         {
            if(param1 >= 0)
            {
               this.m_xSpeed = this.m_xSpeed < 0 ? -Math.abs(-this.m_xSpeed * param1) : this.m_xSpeed * param1;
            }
            else
            {
               _loc2_ = this.m_xSpeed > 0;
               this.m_xSpeed -= this.m_xSpeed > 0 ? Utils.fastAbs(param1) : -Utils.fastAbs(param1);
               if(_loc2_ && this.m_xSpeed < 0 || !_loc2_ && this.m_xSpeed > 0)
               {
                  this.m_xSpeed = 0;
               }
            }
            if(Utils.fastAbs(this.m_xSpeed) < 0.5)
            {
               this.m_xSpeed = 0;
            }
         }
         else
         {
            if(param1 >= 0)
            {
               _loc3_ = this.m_currentPlatform != null && this.m_currentPlatform.decel_friction != 1 ? this.m_currentPlatform.decel_friction * param1 : param1;
               this.m_xSpeed = this.m_xSpeed < 0 ? -Math.abs(-this.m_xSpeed * _loc3_) : this.m_xSpeed * _loc3_;
            }
            else
            {
               if(this.m_currentPlatform != null)
               {
                  param1 *= this.m_currentPlatform.decel_friction;
               }
               else if(SpecialMode.modeEnabled(this.STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
               {
                  param1 *= 0.6;
               }
               _loc4_ = this.m_xSpeed > 0;
               this.m_xSpeed -= this.m_xSpeed > 0 ? Utils.fastAbs(param1) : -Utils.fastAbs(param1);
               if(_loc4_ && this.m_xSpeed < 0 || !_loc4_ && this.m_xSpeed > 0)
               {
                  this.m_xSpeed = 0;
               }
            }
            if(Utils.fastAbs(this.m_xSpeed) < 0.5)
            {
               this.m_xSpeed = 0;
            }
         }
         if(Utils.fastAbs(this.m_xSpeed) < 0.5)
         {
            this.m_xSpeed = 0;
         }
      }
      
      public function decel_air(param1:Number) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         if(this.m_ySpeed == 0)
         {
            return;
         }
         if(!this.m_collision.ground)
         {
            if(param1 >= 0)
            {
               this.m_ySpeed *= param1;
            }
            else
            {
               _loc2_ = this.m_ySpeed < 0;
               this.m_ySpeed -= this.m_ySpeed > 0 ? Utils.fastAbs(param1) : -Utils.fastAbs(param1);
               if(_loc2_ && this.m_ySpeed > 0 || !_loc2_ && this.m_ySpeed < 0)
               {
                  this.m_ySpeed = 0;
               }
            }
            if(Utils.fastAbs(this.m_ySpeed) < 0.5)
            {
               this.m_ySpeed = 0;
            }
         }
         else if(this.m_ySpeed > 0)
         {
            this.m_ySpeed = 0;
         }
         else
         {
            if(param1 >= 0)
            {
               this.m_ySpeed *= this.m_ySpeed != 0 ? (this.m_currentPlatform != null && this.m_currentPlatform.decel_friction != 1 ? this.m_currentPlatform.decel_friction * param1 : param1) : 0;
            }
            else
            {
               if(this.m_currentPlatform != null)
               {
                  param1 *= this.m_currentPlatform.decel_friction;
               }
               _loc3_ = this.m_ySpeed < 0;
               this.m_ySpeed -= this.m_ySpeed > 0 ? Utils.fastAbs(param1) : -Utils.fastAbs(param1);
               if(_loc3_ && this.m_ySpeed < 0 || !_loc3_ && this.m_ySpeed > 0)
               {
                  this.m_ySpeed = 0;
               }
            }
            if(Utils.fastAbs(this.m_ySpeed) < 0.5)
            {
               this.m_ySpeed = 0;
            }
         }
         if(Utils.fastAbs(this.m_ySpeed) < 0.5)
         {
            this.m_ySpeed = 0;
         }
      }
      
      public function netXSpeed(param1:Boolean = false, param2:Boolean = false) : Number
      {
         var _loc3_:Number = 0;
         if(!param1)
         {
            _loc3_ += this.m_xSpeed;
         }
         if(!param2)
         {
            _loc3_ += this.m_xKnockback;
         }
         return _loc3_;
      }
      
      public function netYSpeed(param1:Boolean = false, param2:Boolean = false) : Number
      {
         var _loc3_:Number = 0;
         if(!param1)
         {
            _loc3_ += this.m_ySpeed;
         }
         if(!param2)
         {
            _loc3_ += this.m_yKnockback;
         }
         return _loc3_;
      }
      
      public function netSpeed(param1:Boolean = false, param2:Boolean = false) : Number
      {
         return Number(Utils.getDistance(new Point(),new Point(this.netXSpeed(param1,param2),this.netYSpeed(param1,param2))));
      }
      
      protected function applyGroundInfluence() : void
      {
         if(Boolean(this.m_currentPlatform && this.m_currentPlatform.x_influence && !this.m_attack.IgnorePlatformInfluence) && Boolean(!this.STAGEDATA.FSCutscene) && this.STAGEDATA.FSCutins <= 0)
         {
            this.m_attemptToMove(this.m_currentPlatform.x_influence,0);
         }
      }
      
      protected function checkPlatformBounce() : void
      {
      }
      
      protected function validateBypass(param1:AttackDamage) : Boolean
      {
         return false;
      }
      
      public function validateOnlyAffects(param1:AttackDamage) : Boolean
      {
         if(param1.OnlyAffectsAir && this.m_collision.ground)
         {
            return false;
         }
         if(param1.OnlyAffectsGround && !this.m_collision.ground)
         {
            return false;
         }
         if(param1.OnlyAffectsFall && !(!this.m_collision.ground && this.netYSpeed() >= 0))
         {
            return false;
         }
         return true;
      }
      
      public function checkUnhittableTeamHit(param1:AttackDamage) : Boolean
      {
         return !param1.HurtSelf && !this.m_baseStats.HurtByTeam && this.m_team_id == param1.TeamID && this.m_team_id > 0 && !this.STAGEDATA.TeamDamage;
      }
      
      public function checkUnhittableSelfHit(param1:AttackDamage) : Boolean
      {
         return !param1.HurtSelf && !this.m_baseStats.HurtByOwner && (param1.PlayerID == this.m_player_id && this.m_player_id > 0 || param1.Owner is Projectile && Projectile(param1.Owner).getOwner() === this && Projectile(param1.Owner).WasReversed != true);
      }
      
      public function validateHit(param1:AttackDamage, param2:Boolean = false, param3:Boolean = false) : Boolean
      {
         if(!param1 || !this.m_baseStats.CanReceiveHits || !this.validateBypass(param1) || !this.validateOnlyAffects(param1) || this.checkUnhittableSelfHit(param1) || this.checkUnhittableTeamHit(param1) || !param2 && this.isInvincible() || !param3 && this.isIntangible() || this.attackIDArrayContains(param1.AttackID))
         {
            return false;
         }
         if(this is Character && param1.Damage === 0 && !param1.ReverseCharacter && (param1.ReverseItem || param1.ReverseProjectile) || this is Item && param1.Damage === 0 && !param1.ReverseItem && (param1.ReverseCharacter || param1.ReverseProjectile) || this is Projectile && param1.Damage === 0 && !param1.ReverseProjectile && (param1.ReverseCharacter || param1.ReverseItem))
         {
            return false;
         }
         return true;
      }
      
      public function removeSelfPlatform() : void
      {
         var _loc1_:int = 0;
         if(this.m_selfPlatform)
         {
            this.m_selfPlatform.SpriteOwner = null;
            _loc1_ = this.STAGEDATA.Terrains.indexOf(this.m_selfPlatform);
            if(_loc1_ >= 0)
            {
               this.STAGEDATA.Terrains.splice(_loc1_,1);
            }
            _loc1_ = this.STAGEDATA.Platforms.indexOf(this.m_selfPlatform);
            if(_loc1_ >= 0)
            {
               this.STAGEDATA.Platforms.splice(_loc1_,1);
            }
            _loc1_ = this.STAGEDATA.MovingPlatforms.indexOf(this.m_selfPlatform);
            if(_loc1_ >= 0)
            {
               this.STAGEDATA.MovingPlatforms.splice(_loc1_,1);
            }
            if(Boolean(this.m_selfPlatform) && Boolean(this.m_selfPlatform.Container.parent))
            {
               this.m_selfPlatform.Container.parent.removeChild(this.m_selfPlatform.Container);
            }
         }
      }
      
      public function attachToGround() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:Number = NaN;
         if(!this.m_currentPlatform)
         {
            return false;
         }
         var _loc3_:Boolean = true;
         var _loc4_:Number = 0;
         var _loc5_:Number = this.m_sprite.y;
         _loc1_ = this.m_sprite.y + 20;
         while(this.m_sprite.y < _loc1_ && !this.testGroundWithCoord(this.m_sprite.x,this.m_sprite.y))
         {
            ++this.m_sprite.y;
         }
         if(!this.testGroundWithCoord(this.m_sprite.x,this.m_sprite.y))
         {
            this.m_sprite.y = _loc1_ - 20;
         }
         if(this.m_currentPlatform != null && this.netYSpeed() >= 0)
         {
            _loc4_ = 0;
            if(this.m_currentPlatform.fallthrough != true && !this.m_currentPlatform.shouldIgnore(this))
            {
               while(Boolean(this.testGroundWithCoord(this.m_sprite.x,this.m_sprite.y)) && _loc4_ < 150)
               {
                  this.m_sprite.y -= 0.5;
                  _loc4_ += 0.5;
               }
            }
            _loc2_ = Number(Utils.fastAbs(this.m_currentPlatform.Y - this.m_currentPlatform.PreviousY));
            if(_loc4_ >= (this.STAGEDATA.Terrains.indexOf(this.m_currentPlatform) >= 0 ? 40 + _loc2_ : 10))
            {
               this.m_sprite.y += _loc4_ - 0.5;
               _loc3_ = false;
            }
         }
         else
         {
            _loc3_ = false;
         }
         if(this.STAGEDATA.testGroundWithCoord(this.m_sprite.x,this.m_sprite.y,{
            "platforms":false,
            "ignoreList":[this.m_currentPlatform]
         }))
         {
            this.m_sprite.y = _loc5_;
         }
         return _loc3_;
      }
      
      protected function calcGroundAngle() : Number
      {
         var _loc1_:int = 0;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = 0;
         var _loc8_:Number = 0;
         if(this.m_currentPlatform != null)
         {
            _loc1_ = 0;
            _loc2_ = this.m_sprite.y;
            _loc3_ = 0;
            _loc4_ = 0;
            _loc5_ = 0;
            _loc6_ = 0;
            while(this.testCoordCollision(this.m_sprite.x - 5,_loc2_) && _loc8_ > -20)
            {
               _loc2_ -= 1 / 4;
               _loc8_ -= 1 / 4;
            }
            if(_loc8_ <= -20)
            {
               _loc2_ = this.m_sprite.y;
               _loc8_ = 0;
            }
            _loc1_ = this.m_sprite.y + 20;
            while(_loc2_ < _loc1_ && !this.testCoordCollision(this.m_sprite.x - 5,_loc2_ - 2))
            {
               _loc2_++;
            }
            if(_loc2_ < _loc1_ && this.testCoordCollision(this.m_sprite.x - 5,_loc2_))
            {
               _loc3_ = this.m_sprite.x - 5;
               _loc5_ = _loc2_;
               _loc2_ = this.m_sprite.y;
               while(this.testCoordCollision(this.m_sprite.x + 5,_loc2_) && _loc8_ > -20)
               {
                  _loc2_ -= 1 / 4;
                  _loc8_ -= 1 / 4;
               }
               if(_loc8_ <= -20)
               {
                  _loc2_ = this.m_sprite.y;
                  _loc8_ = 0;
               }
               _loc1_ = this.m_sprite.y + 20;
               while(_loc2_ < _loc1_ && !this.testCoordCollision(this.m_sprite.x + 5,_loc2_ - 2))
               {
                  _loc2_++;
               }
               if(_loc2_ < _loc1_ && this.testCoordCollision(this.m_sprite.x + 5,_loc2_))
               {
                  _loc4_ = this.m_sprite.x + 5;
                  _loc6_ = _loc2_;
                  _loc7_ = _loc6_ > _loc5_ ? Math.tan(Utils.fastAbs(_loc5_ - _loc6_) / Utils.fastAbs(_loc3_ - _loc4_)) / (Math.PI / 180) : -Math.tan(Utils.fastAbs(_loc5_ - _loc6_) / Utils.fastAbs(_loc3_ - _loc4_)) / (Math.PI / 180);
               }
            }
         }
         if(_loc7_ > 45)
         {
            _loc7_ = 45;
         }
         else if(_loc7_ < -45)
         {
            _loc7_ = -45;
         }
         return _loc7_;
      }
      
      protected function attachToGroundTest(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:Number = this.m_sprite.x;
         var _loc4_:Number = this.m_sprite.y;
         this.m_sprite.x = param1;
         this.m_sprite.y = param2;
         var _loc5_:Boolean = this.attachToGround();
         this.m_sprite.x = _loc3_;
         this.m_sprite.y = _loc4_;
         return _loc5_;
      }
      
      public function willFallOffRange(param1:Number, param2:Number, param3:int = 5, param4:int = 85) : Boolean
      {
         var _loc5_:Number = NaN;
         param4 = 90 - param4;
         var _loc6_:int = -param3;
         while(_loc6_ < param3)
         {
            if(this.testGroundWithCoord(param1,param2 + _loc6_))
            {
               _loc5_ = Number(Utils.getAngleBetween(new Point(this.m_sprite.x,this.m_sprite.y),new Point(param1,param2 + _loc6_)));
               if(!(_loc5_ >= 90 - param4 && _loc5_ <= 90 + param4 || _loc5_ >= 270 - param4 && _loc5_ <= 270 + param4))
               {
                  return false;
               }
            }
            _loc6_++;
         }
         return true;
      }
      
      protected function testCoordCollision(param1:Number, param2:Number) : Boolean
      {
         if(this.m_currentPlatform != null && this.m_currentPlatform.hitTestPoint(param1,param2 + 1,true) && this.m_currentPlatform.fallthrough != true && !this.m_currentPlatform.shouldIgnore(this) && !(this.OnPlatform && this.netYSpeed() < 0))
         {
            return true;
         }
         return false;
      }
      
      protected function testAbsCoordCollision(param1:Number, param2:Number) : Boolean
      {
         if(this.m_currentPlatform != null && this.m_currentPlatform.hitTestPoint(param1,param2 + 1,true) && this.m_currentPlatform.fallthrough != true && !this.m_currentPlatform.shouldIgnore(this) && !(this.OnPlatform && this.netYSpeed() < 0))
         {
            return true;
         }
         return false;
      }
      
      public function testGroundWithCoord(param1:Number, param2:Number) : Platform
      {
         var _loc3_:Platform = null;
         var _loc4_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < this.m_terrains.length && (!this.m_terrains[_loc4_].hitTestPoint(param1,param2,true) || this.m_terrains[_loc4_].fallthrough == true || this.m_terrains[_loc4_].shouldIgnore(this) || this.m_selfPlatform == this.m_terrains[_loc4_]))
         {
            _loc4_++;
         }
         if(_loc4_ < this.m_terrains.length && this.m_terrains[_loc4_].hitTestPoint(param1,param2,true))
         {
            _loc3_ = this.testPlatformWithCoord(param1,param2);
            if(_loc3_)
            {
               return _loc3_;
            }
            return this.m_terrains[_loc4_];
         }
         _loc4_ = 0;
         while(_loc4_ < this.m_platforms.length && (!this.m_platforms[_loc4_].hitTestPoint(param1,param2,true) || this.m_platforms[_loc4_].fallthrough == true || this.m_platforms[_loc4_].shouldIgnore(this) || this.m_selfPlatform == this.m_platforms[_loc4_]))
         {
            _loc4_++;
         }
         if(_loc4_ < this.m_platforms.length && this.m_platforms[_loc4_].hitTestPoint(param1,param2,true) && this.netYSpeed() >= 0)
         {
            return this.m_platforms[_loc4_];
         }
         return null;
      }
      
      public function testTerrainWithCoord(param1:Number, param2:Number) : Platform
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < this.m_terrains.length && (!this.m_terrains[_loc3_].hitTestPoint(param1,param2,true) || this.m_terrains[_loc3_].fallthrough == true || this.m_terrains[_loc3_].shouldIgnore(this) || this.m_selfPlatform == this.m_terrains[_loc3_]))
         {
            _loc3_++;
         }
         if(_loc3_ < this.m_terrains.length && this.m_terrains[_loc3_].hitTestPoint(param1,param2,true))
         {
            return this.m_terrains[_loc3_];
         }
         return null;
      }
      
      public function testPlatformWithCoord(param1:Number, param2:Number) : Platform
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < this.m_platforms.length && (!this.m_platforms[_loc3_].hitTestPoint(param1,param2,true) || this.m_platforms[_loc3_].fallthrough == true || this.m_platforms[_loc3_].shouldIgnore(this) || this.m_selfPlatform == this.m_platforms[_loc3_]))
         {
            _loc3_++;
         }
         if(_loc3_ < this.m_platforms.length && this.m_platforms[_loc3_].hitTestPoint(param1,param2,true) && this.netYSpeed() >= 0)
         {
            return this.m_platforms[_loc3_];
         }
         return null;
      }
      
      protected function testAbsCoordinates(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < this.m_terrains.length && (!this.m_terrains[_loc3_].hitTestPoint(param1,param2,true) || this.m_terrains[_loc3_].fallthrough == true || this.m_terrains[_loc3_].shouldIgnore(this) || this.m_selfPlatform == this.m_terrains[_loc3_]))
         {
            _loc3_++;
         }
         if(_loc3_ < this.m_terrains.length && this.m_terrains[_loc3_].hitTestPoint(param1,param2,true))
         {
            return true;
         }
         return false;
      }
      
      public function testCoordinates(param1:Number, param2:Number) : Platform
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < this.m_terrains.length && (!this.m_terrains[_loc3_].hitTestPoint(param1,param2,true) || this.m_selfPlatform == this.m_terrains[_loc3_]))
         {
            _loc3_++;
         }
         if(_loc3_ < this.m_terrains.length && this.m_terrains[_loc3_].hitTestPoint(param1,param2,true))
         {
            return this.m_terrains[_loc3_];
         }
         _loc3_ = 0;
         while(_loc3_ < this.m_platforms.length && (!this.m_platforms[_loc3_].hitTestPoint(param1,param2,true) || this.m_selfPlatform == this.m_platforms[_loc3_]))
         {
            _loc3_++;
         }
         if(_loc3_ < this.m_platforms.length && this.m_platforms[_loc3_].hitTestPoint(param1,param2,true))
         {
            return this.m_platforms[_loc3_];
         }
         return null;
      }
      
      public function checkLinearPath(param1:InteractiveSprite) : Boolean
      {
         return this.checkLinearPathBetweenPoints(new Point(this.X,this.Y),new Point(param1.X,param1.Y));
      }
      
      public function checkLinearPathBetweenPoints(param1:Point, param2:Point, param3:Boolean = true, param4:Platform = null) : Boolean
      {
         return this.getPlatformBetweenPoints(param1,param2,param3,param4) == null;
      }
      
      public function getPlatformBetweenPoints(param1:Point, param2:Point, param3:Boolean = true, param4:Platform = null) : Platform
      {
         var _loc13_:int = 0;
         var _loc5_:Number = param1.x;
         var _loc6_:Number = param1.y;
         var _loc7_:Number = param1.x;
         var _loc8_:Number = param1.y;
         var _loc9_:Number = param2.x - param1.x;
         var _loc10_:Number = param2.y - param1.y;
         var _loc11_:Number = (Math.abs(_loc9_) + Math.abs(_loc10_)) / 10;
         var _loc12_:Platform = param4;
         if(_loc11_ < 1)
         {
            _loc11_ = 1;
         }
         while(_loc13_ < Math.floor(_loc11_))
         {
            if(Boolean(param4) && Boolean(param4.hitTestPoint(_loc7_ + _loc9_ / _loc11_,_loc8_ + _loc10_ / _loc11_)) || Boolean(param3 && param4 == null) && (Boolean(_loc12_ = this.testTerrainWithCoord(_loc7_ + _loc9_ / _loc11_,_loc8_ + _loc10_ / _loc11_))) || Boolean(!param3 && param4 == null) && (Boolean(_loc12_ = this.testGroundWithCoord(_loc7_ + _loc9_ / _loc11_,_loc8_ + _loc10_ / _loc11_))))
            {
               return _loc12_;
            }
            _loc7_ += _loc9_ / _loc11_;
            _loc8_ += _loc10_ / _loc11_;
            _loc13_++;
         }
         return null;
      }
      
      protected function pushOutOfGround() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 50;
         while(_loc2_ < _loc1_ && Boolean(this.testTerrainWithCoord(this.m_sprite.x,this.m_sprite.y)))
         {
            --this.m_sprite.y;
            _loc2_++;
         }
         if(_loc2_ >= _loc1_)
         {
            this.m_sprite.y += _loc2_;
         }
      }
      
      protected function m_groundCollisionTest() : void
      {
         var _loc1_:Boolean = this.m_collision.ground;
         if(this.m_collision.ground && !this.m_ySpeed < 0)
         {
            this.attachToGround();
         }
         var _loc2_:Boolean = (this.m_currentPlatform = this.testGroundWithCoord(this.m_sprite.x,this.m_sprite.y + 1)) != null;
         this.m_collision.ground = _loc2_;
         if(this.m_collision.ground)
         {
            this.attachToGround();
         }
         if(this.m_collision.ground)
         {
            this.attachToGround();
         }
         if(this.m_collision.ground && !_loc1_)
         {
            this.m_ySpeed = 0;
            this.m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.GROUND_TOUCH,{"caller":this.APIInstance.instance}));
         }
         else if(!this.m_collision.ground && _loc1_)
         {
            this.m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.GROUND_LEAVE,{"caller":this.APIInstance.instance}));
         }
      }
      
      public function m_attemptToMove(param1:Number, param2:Number) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Point = null;
         var _loc5_:Platform = null;
         var _loc6_:Boolean = false;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         if(!(param1 == 0 && param2 == 0))
         {
            _loc3_ = 0;
            this.m_collision.leftSide = param1 < 0 && this.m_collision.ground && Boolean(this.testTerrainWithCoord(this.m_sprite.x + param1 - this.m_baseStats.KneeXOffset,this.m_sprite.y + param2 + this.m_baseStats.KneeYOffset));
            this.m_collision.rightSide = param1 > 0 && this.m_collision.ground && Boolean(this.testTerrainWithCoord(this.m_sprite.x + param1 + this.m_baseStats.KneeXOffset,this.m_sprite.y + param2 + this.m_baseStats.KneeYOffset));
            if(!this.m_collision.ground)
            {
               _loc4_ = this.__attemptToMovePointCache;
               _loc4_.copyFrom(this.Location);
               _loc5_ = this.moveSprite(param1,param2,param1 === 0 && param2 >= 20 ? 10 : 5);
               _loc6_ = _loc5_ != null;
               _loc7_ = Number(Utils.getAngleBetween(new Point(_loc4_.x,_loc4_.y),new Point(this.m_sprite.x,this.m_sprite.y)));
               if(_loc6_ && !(_loc7_ >= 225 && _loc7_ <= 315) && !(this.m_sprite.x == _loc4_.x && this.m_sprite.y == _loc4_.y))
               {
                  this.m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.HIT_WALL,{
                     "caller":this.APIInstance.instance,
                     "left":_loc7_ < 225 && _loc7_ > 135,
                     "right":_loc7_ < 45 && _loc7_ >= 0 || _loc7_ <= 360 && _loc7_ > 315,
                     "top":_loc7_ >= 45 && _loc7_ >= 135
                  }));
               }
               if(this.m_collision.rightSide && param1 > 0 || this.m_collision.leftSide && param1 < 0)
               {
                  this.m_sprite.x = _loc4_.x;
               }
               if(_loc6_ && param2 >= 0)
               {
                  this.m_groundCollisionTest();
               }
            }
            else
            {
               _loc8_ = Utils.fastAbs(param1) >= 10 || Utils.fastAbs(param2) >= 10 ? 10 : 1;
               _loc9_ = false;
               param1 /= _loc8_;
               param2 /= _loc8_;
               _loc3_ = 0;
               while(_loc3_ < _loc8_)
               {
                  this.m_collision.leftSide = param1 < 0 && this.m_collision.ground && Boolean(this.testTerrainWithCoord(this.m_sprite.x + param1 - this.m_width / 2,this.m_sprite.y + param2 - 35));
                  this.m_collision.rightSide = param1 > 0 && this.m_collision.ground && Boolean(this.testTerrainWithCoord(this.m_sprite.x + param1 + this.m_width / 2,this.m_sprite.y + param2 - 35));
                  if(!_loc9_ && param1 != 0 && (this.m_collision.rightSide || this.m_collision.leftSide))
                  {
                     _loc9_ = true;
                     this.m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.HIT_WALL,{
                        "caller":this.APIInstance.instance,
                        "left":this.m_collision.leftSide,
                        "right":this.m_collision.rightSide,
                        "top":false
                     }));
                  }
                  if(param2 < 0)
                  {
                     this.m_sprite.y += param2;
                  }
                  this.m_sprite.x += !(this.m_collision.rightSide && param1 > 0 || this.m_collision.leftSide && param1 < 0) ? param1 : 0;
                  if(param2 > 0 && !this.testTerrainWithCoord(this.m_sprite.x,this.m_sprite.y + param2))
                  {
                     this.m_sprite.y += param2;
                  }
                  if(!this.m_collision.leftSide && !this.m_collision.rightSide)
                  {
                     this.attachToGround();
                  }
                  if((Utils.fastAbs(param1) > 10 || Utils.fastAbs(param2) > 10) && this.runExtraHitTests(0,0))
                  {
                     break;
                  }
                  _loc3_++;
               }
            }
         }
      }
      
      public function safeMove(param1:Number, param2:Number) : Boolean
      {
         return this.moveSprite(param1,param2) != null;
      }
      
      protected function moveSprite(param1:Number, param2:Number, param3:int = 5) : Platform
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc8_:Platform = null;
         var _loc18_:Boolean = false;
         this.m_hitPlatform = null;
         var _loc6_:Number = Number(Utils.fastAbs(param1));
         var _loc7_:Number = Number(Utils.fastAbs(param2));
         var _loc9_:int = param3;
         if(param3 == 0 || param1 == 0 && param2 == 0)
         {
            return _loc8_;
         }
         if(_loc6_ > _loc7_)
         {
            param3 = int(Math.max(param3,_loc6_ / param3));
         }
         else
         {
            param3 = int(Math.max(param3,_loc7_ / param3));
         }
         var _loc10_:Number = this.m_sprite.x;
         var _loc11_:Number = this.m_sprite.y;
         var _loc12_:Number = _loc10_;
         var _loc13_:Number = _loc11_;
         var _loc14_:Number = 0;
         var _loc15_:Number = 0;
         if(param1 > 0)
         {
            _loc14_ = -this.m_width * this.m_sizeRatio / 2;
            _loc12_ += this.m_width * this.m_sizeRatio / 2;
         }
         else if(param1 < 0)
         {
            _loc14_ = this.m_width * this.m_sizeRatio / 2;
            _loc12_ -= this.m_width * this.m_sizeRatio / 2;
         }
         if(param2 == 0)
         {
            _loc15_ = this.m_height * this.m_sizeRatio / 2;
            _loc13_ -= this.m_height * this.m_sizeRatio / 2;
         }
         else if(param2 < 0)
         {
            _loc15_ = this.m_height * this.m_sizeRatio;
            _loc13_ -= this.m_height * this.m_sizeRatio;
         }
         var _loc16_:Number = param1 / param3;
         var _loc17_:Number = param2 / param3;
         _loc4_ = 0;
         while(_loc4_ < param3 - 1)
         {
            _loc8_ = this.testGroundWithCoord(_loc12_ + _loc16_,_loc13_ + _loc17_);
            if(_loc8_)
            {
               if(!((param2 < 0 || param2 == 0) && this.STAGEDATA.Platforms.indexOf(_loc8_) >= 0))
               {
                  break;
               }
               _loc8_ = null;
            }
            else
            {
               if(_loc6_ > 10 || _loc7_ > 10)
               {
                  if(this.runExtraHitTests(_loc12_ + _loc14_ - _loc10_,_loc13_ + _loc15_ - _loc11_))
                  {
                     return null;
                  }
               }
               _loc12_ += _loc16_;
               _loc13_ += _loc17_;
            }
            _loc4_++;
         }
         param3 = _loc9_;
         _loc16_ /= param3;
         _loc17_ /= param3;
         _loc18_ = false;
         _loc4_ = 0;
         while(_loc4_ < param3 && !_loc18_)
         {
            _loc8_ = this.testGroundWithCoord(_loc12_ + _loc16_,_loc13_ + _loc17_);
            if(_loc8_)
            {
               if(!((param2 < 0 || param2 == 0) && this.STAGEDATA.Platforms.indexOf(_loc8_) >= 0))
               {
                  break;
               }
               _loc8_ = null;
            }
            else
            {
               if(_loc6_ > 10 || _loc7_ > 10)
               {
                  if(this.runExtraHitTests(_loc12_ + _loc14_ - _loc10_,_loc13_ + _loc15_ - _loc11_))
                  {
                     return null;
                  }
               }
               _loc12_ += _loc16_;
               _loc13_ += _loc17_;
            }
            _loc4_++;
         }
         if(_loc8_ == null && !this.testTerrainWithCoord(_loc10_ + param1,_loc11_ + param2))
         {
            this.m_sprite.x = _loc10_ + param1;
            this.m_sprite.y = _loc11_ + param2;
         }
         else
         {
            this.m_sprite.x = _loc12_ + _loc14_;
            this.m_sprite.y = _loc13_ + _loc15_;
         }
         this.m_collisionPoint.x = _loc12_ - _loc14_;
         this.m_collisionPoint.y = _loc13_ - _loc15_;
         this.m_hitPlatform = _loc8_;
         return _loc8_;
      }
      
      protected function getCollisionQuadrants(param1:Number) : Object
      {
         return {
            "left":param1 < 225 && param1 > 135,
            "right":param1 < 45 && param1 >= 0 || param1 <= 360 && param1 > 315,
            "top":param1 >= 45 && param1 >= 135,
            "bottom":param1 >= 225 && param1 <= 315
         };
      }
      
      public function extraHitTests(param1:Number, param2:Number, param3:InteractiveSprite = null) : Boolean
      {
         return this.m_apiInstance.extraHitTests(param1,param2,param3);
      }
      
      public function runExtraHitTests(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:Character = null;
         var _loc4_:Item = null;
         var _loc5_:Projectile = null;
         var _loc6_:Enemy = null;
         var _loc7_:int = 0;
         var _loc9_:Boolean = false;
         var _loc8_:Vector.<MovingPlatform> = this.STAGEDATA.MovingPlatforms;
         _loc7_ = 0;
         while(_loc7_ < _loc8_.length)
         {
            _loc9_ ||= _loc8_[_loc7_].extraHitTests(param1,param2,this);
            _loc7_++;
         }
         _loc7_ = 0;
         while(_loc7_ < this.STAGEDATA.Players.length)
         {
            _loc3_ = this.STAGEDATA.getPlayerByID(_loc7_ + 1);
            if(_loc3_)
            {
               _loc9_ ||= _loc3_.extraHitTests(param1,param2,this);
            }
            _loc7_++;
         }
         _loc7_ = 0;
         while(_loc7_ < this.STAGEDATA.ItemsRef.ItemsInUse.length)
         {
            _loc4_ = this.STAGEDATA.ItemsRef.ItemsInUse[_loc7_];
            if(_loc4_)
            {
               _loc9_ ||= _loc4_.extraHitTests(param1,param2,this);
            }
            _loc7_++;
         }
         _loc7_ = 0;
         while(_loc7_ < this.STAGEDATA.Projectiles.length)
         {
            _loc5_ = this.STAGEDATA.Projectiles[_loc7_];
            if(_loc5_)
            {
               _loc9_ ||= _loc5_.extraHitTests(param1,param2,this);
            }
            _loc7_++;
         }
         _loc7_ = 0;
         while(_loc7_ < this.STAGEDATA.Enemies.length)
         {
            _loc6_ = this.STAGEDATA.Enemies[_loc7_];
            if(_loc6_)
            {
               _loc9_ ||= _loc6_.extraHitTests(param1,param2,this);
            }
            _loc7_++;
         }
         return _loc9_;
      }
      
      public function checkMovingPlatforms(param1:MovingPlatform) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.m_collision.ground && this.m_currentPlatform != null && this.m_currentPlatform == param1)
         {
            _loc2_ = param1.X - param1.PreviousX;
            _loc3_ = param1.Y - param1.PreviousY;
            this.safeMove(0,_loc3_);
            this.safeMove(_loc2_,0);
         }
      }
      
      public function faceLeft() : void
      {
         this.m_faceLeft();
      }
      
      public function faceRight() : void
      {
         this.m_faceRight();
      }
      
      public function isFacingRight() : Boolean
      {
         return this.m_facingForward;
      }
      
      public function isCloseToGround() : Boolean
      {
         return this.m_collision.ground || Boolean(this.testGroundWithCoord(this.m_sprite.x,this.m_sprite.y + 10));
      }
      
      public function isOnGround() : Boolean
      {
         return this.m_collision.ground;
      }
      
      public function getCounterAttackBoxStats() : Object
      {
         return this.m_counterAttackData;
      }
      
      public function flip(param1:* = null) : void
      {
         if(this.m_facingForward)
         {
            this.m_faceLeft();
         }
         else
         {
            this.m_faceRight();
         }
      }
      
      public function addToCamera() : void
      {
         this.STAGEDATA.CamRef.addTarget(this.m_sprite);
      }
      
      public function removeFromCamera() : void
      {
         this.STAGEDATA.CamRef.deleteTarget(this.m_sprite);
      }
      
      public function resetCameraBox() : void
      {
         if(this.m_sprite)
         {
            this.m_sprite.camOverride = null;
         }
      }
      
      public function updateCamerBox() : void
      {
         var _loc1_:HitBoxSprite = null;
         if(this.HasCamBox)
         {
            _loc1_ = this.CurrentAnimation.getHitBoxes(this.CurrentFrameNum,HitBoxSprite.CAM)[0];
            if(Boolean(this.m_sprite.camOverride) && this.m_sprite.camOverride is Rectangle)
            {
               this.m_sprite.camOverride.x = _loc1_.x;
               this.m_sprite.camOverride.y = _loc1_.y;
               this.m_sprite.camOverride.width = _loc1_.width;
               this.m_sprite.camOverride.height = _loc1_.height;
            }
            else
            {
               this.m_sprite.camOverride = new Rectangle(_loc1_.x,_loc1_.y,_loc1_.width,_loc1_.height);
            }
         }
         else
         {
            if(Boolean(this.m_sprite.camOverride) && this.m_sprite.camOverride is Rectangle)
            {
               this.m_sprite.camOverride = null;
            }
            this.resetCameraBox();
         }
      }
      
      protected function m_faceRight() : void
      {
         if(this.m_delayPlayback)
         {
            this.m_delayPlayBackFacingRight = true;
         }
         else
         {
            this.m_sprite.scaleX = Math.abs(this.m_sprite.scaleX);
         }
         this.m_facingForward = true;
         if(this.m_attack)
         {
            this.m_attack.IsForward = true;
         }
      }
      
      protected function m_faceLeft() : void
      {
         if(this.m_delayPlayback)
         {
            this.m_delayPlayBackFacingRight = false;
         }
         else
         {
            this.m_sprite.scaleX = -Math.abs(this.m_sprite.scaleX);
         }
         this.m_facingForward = false;
         if(this.m_attack)
         {
            this.m_attack.IsForward = false;
         }
      }
      
      public function setGravity(param1:Number) : void
      {
         this.m_gravity = param1;
      }
      
      public function setCamBoxSize(param1:Number, param2:Number, param3:Number = 0, param4:Number = 0) : void
      {
         this.m_sprite.cam_width = param1;
         this.m_sprite.cam_height = param2;
         this.m_sprite.cam_x_offset = param3;
         this.m_sprite.cam_y_offset = param4;
      }
      
      public function camFocus(param1:int) : void
      {
         this.CAM.addZoomFocus(this.m_sprite,param1);
      }
      
      public function camUnfocus() : void
      {
         this.CAM.removeZoomFocus(this.m_sprite);
         this.CAM.deleteForcedTarget(this.m_sprite);
      }
      
      public function setGlobalVariable(param1:String, param2:*) : void
      {
         this.m_globalVariables[param1] = param2;
      }
      
      public function getGlobalVariable(param1:String) : *
      {
         return this.m_globalVariables[param1] == undefined ? null : this.m_globalVariables[param1];
      }
      
      public function getRotation() : Number
      {
         return this.m_sprite.rotation;
      }
      
      public function setRotation(param1:Number) : void
      {
         this.m_sprite.rotation = param1;
      }
      
      public function getWidth() : Number
      {
         return this.m_width;
      }
      
      public function getHeight() : Number
      {
         return this.m_height;
      }
      
      public function setWidth(param1:Number) : void
      {
         this.m_width = param1;
      }
      
      public function setHeight(param1:Number) : void
      {
         this.m_height = param1;
      }
      
      public function getXSpeed() : Number
      {
         return this.m_xSpeed;
      }
      
      public function getYSpeed() : Number
      {
         return this.m_ySpeed;
      }
      
      public function getX() : Number
      {
         return this.m_sprite.x;
      }
      
      public function setX(param1:Number) : void
      {
         this.m_sprite.x = param1;
      }
      
      public function getY() : Number
      {
         return this.m_sprite.y;
      }
      
      public function setY(param1:Number) : void
      {
         this.m_sprite.y = param1;
      }
      
      public function getXScale() : Number
      {
         return this.CurrentScale.x;
      }
      
      public function getYScale() : Number
      {
         return this.CurrentScale.y;
      }
      
      public function playFrame(param1:String) : void
      {
         if(this.m_delayPlayback)
         {
            this.m_delayPlayBackAnimation = param1;
            this.m_delayPlayBackFrame = null;
            return;
         }
         this.m_delayPlayBackAnimation = null;
         this.m_delayPlayBackFrame = null;
         if(!this.currentFrameIs(param1))
         {
            this.m_currentAnimationID = param1;
            this.m_sprite.gotoAndStop(param1);
            this.refreshAttackID();
            this.updatePaletteSwap();
         }
      }
      
      public function stancePlayFrame(param1:*) : void
      {
         if(this.m_delayPlayback)
         {
            this.m_delayPlayBackFrame = param1;
            return;
         }
         if(this.HasStance)
         {
            this.m_sprite.stance.gotoAndStop(param1);
            this.updatePaletteSwap();
         }
      }
      
      public function currentStanceFrameIs(param1:String) : Boolean
      {
         return this.HasStance && this.m_sprite.stance.xframe != null && this.m_sprite.stance.xframe == param1 ? true : false;
      }
      
      protected function getStanceVar(param1:String, param2:*) : Boolean
      {
         if(this.HasStance && this.m_sprite.stance[param1] != null && this.m_sprite.stance[param1] == param2)
         {
            return true;
         }
         return false;
      }
      
      public function currentFrameIs(param1:String) : Boolean
      {
         return this.m_sprite.xframe != null && this.m_sprite.xframe == param1 || this.m_sprite.xframe == null && this.m_currentAnimationID == param1 ? true : false;
      }
      
      protected function setBrightness(param1:Number) : void
      {
         if(Math.abs(param1) > 100)
         {
            param1 = param1 > 0 ? 100 : -100;
         }
         var _loc2_:Number = this.m_sprite.alpha;
         var _loc3_:ColorTransform = new ColorTransform();
         _loc3_.redOffset = param1 * 2.55;
         _loc3_.greenOffset = param1 * 2.55;
         _loc3_.blueOffset = param1 * 2.55;
         this.m_sprite.transform.colorTransform = _loc3_;
         this.m_sprite.alpha = _loc2_;
      }
      
      public function setPosition(param1:Number, param2:Number) : void
      {
         this.m_sprite.x = param1;
         this.m_sprite.y = param2;
      }
      
      protected function setTint(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : void
      {
         Utils.setTint(this.m_sprite,param1,param2,param3,param4,param5,param6,param7,param8);
      }
      
      public function getMC() : MovieClip
      {
         return this.m_sprite;
      }
      
      public function getStanceMC() : MovieClip
      {
         return this.HasStance ? this.m_sprite.stance : null;
      }
      
      public function getScale() : Point
      {
         return this.CurrentScale;
      }
      
      public function setScale(param1:Number, param2:Number) : void
      {
         this.m_sprite.scaleX = param1 * this.m_sizeRatio;
         this.m_sprite.scaleY = param2 * this.m_sizeRatio;
      }
      
      public function getID() : int
      {
         return this.m_player_id;
      }
      
      public function getNearest(param1:String, param2:Boolean = true, param3:Boolean = true) : InteractiveSprite
      {
         var _loc4_:InteractiveSprite = null;
         var _loc5_:InteractiveSprite = null;
         var _loc8_:int = 0;
         var _loc6_:Number = Number.MAX_VALUE;
         var _loc7_:Number = 0;
         switch(param1)
         {
            case "character":
               _loc8_ = 0;
               while(_loc8_ < this.STAGEDATA.Characters.length)
               {
                  _loc4_ = this.STAGEDATA.Characters[_loc8_];
                  if(!(Boolean(_loc4_ && !Character(_loc4_).isStandby()) && Boolean(this.m_targetInterrupt != null) && Boolean(this.m_targetInterrupt({"target":_loc4_.APIInstance.instance}))))
                  {
                     if(Boolean(_loc4_ && _loc4_ != this) && Boolean(!this.STAGEDATA.Characters[_loc8_].StandBy) && !(this.m_player_id > 0 && _loc4_.ID == this.m_player_id))
                     {
                        if(!(param2 && (this.m_team_id > 0 && _loc4_.Team == this.m_team_id || this.m_player_id === _loc4_.ID)))
                        {
                           _loc7_ = Number(Utils.getDistanceFrom(this,_loc4_));
                           if(_loc7_ < _loc6_)
                           {
                              _loc5_ = _loc4_;
                              _loc6_ = _loc7_;
                           }
                        }
                     }
                  }
                  _loc8_++;
               }
               break;
            case "player":
               _loc8_ = 0;
               while(_loc8_ < this.STAGEDATA.Players.length)
               {
                  _loc4_ = this.STAGEDATA.Players[_loc8_];
                  if(!(this.m_targetInterrupt != null && Boolean(this.m_targetInterrupt({"target":_loc4_.APIInstance.instance}))))
                  {
                     if(Boolean(_loc4_) && Boolean(_loc4_ != this) && !(this.m_player_id > 0 && _loc4_.ID == this.m_player_id))
                     {
                        if(!(param2 && (this.m_team_id > 0 && _loc4_.Team == this.m_team_id) || this.m_player_id === _loc4_.ID))
                        {
                           _loc7_ = Number(Utils.getDistanceFrom(this,_loc4_));
                           if(_loc7_ < _loc6_)
                           {
                              _loc5_ = _loc4_;
                              _loc6_ = _loc7_;
                           }
                        }
                     }
                  }
                  _loc8_++;
               }
               break;
            case "item":
               _loc8_ = 0;
               while(_loc8_ < this.STAGEDATA.ItemsRef.ItemsInUse.length)
               {
                  _loc4_ = this.STAGEDATA.ItemsRef.ItemsInUse[_loc8_];
                  if(!(this.m_targetInterrupt != null && Boolean(this.m_targetInterrupt({"target":_loc4_.APIInstance.instance}))))
                  {
                     if(Boolean(_loc4_) && Boolean(_loc4_ != this) && !(this.m_player_id > 0 && _loc4_.ID == this.m_player_id))
                     {
                        if(!(param2 && (this.m_team_id > 0 && _loc4_.Team == this.m_team_id || this.m_player_id === _loc4_.ID)) && !(param3 && Item(_loc4_).getOwner() === this))
                        {
                           _loc7_ = Number(Utils.getDistanceFrom(this,_loc4_));
                           if(_loc7_ < _loc6_)
                           {
                              _loc5_ = _loc4_;
                              _loc6_ = _loc7_;
                           }
                        }
                     }
                  }
                  _loc8_++;
               }
               break;
            case "projectile":
               _loc8_ = 0;
               while(_loc8_ < this.STAGEDATA.Projectiles.length)
               {
                  _loc4_ = this.STAGEDATA.Projectiles[_loc8_];
                  if(!(this.m_targetInterrupt != null && Boolean(this.m_targetInterrupt({"target":_loc4_.APIInstance.instance}))))
                  {
                     if(Boolean(_loc4_) && Boolean(_loc4_ != this) && !(this.m_player_id > 0 && _loc4_.ID == this.m_player_id))
                     {
                        if(!(param2 && (this.m_team_id > 0 && _loc4_.Team == this.m_team_id) || this.m_player_id === _loc4_.ID) && !(param3 && Projectile(_loc4_).getOwner() === this))
                        {
                           _loc7_ = Number(Utils.getDistanceFrom(this,_loc4_));
                           if(_loc7_ < _loc6_)
                           {
                              _loc5_ = _loc4_;
                              _loc6_ = _loc7_;
                           }
                        }
                     }
                  }
                  _loc8_++;
               }
               break;
            case "enemy":
               _loc8_ = 0;
               while(_loc8_ < this.STAGEDATA.Enemies.length)
               {
                  _loc4_ = this.STAGEDATA.Enemies[_loc8_];
                  if(!(this.m_targetInterrupt != null && Boolean(this.m_targetInterrupt({"target":_loc4_.APIInstance.instance}))))
                  {
                     if(Boolean(_loc4_) && Boolean(_loc4_ != this) && !(this.m_player_id > 0 && _loc4_.ID == this.m_player_id))
                     {
                        if(!(param2 && (this.m_team_id > 0 && _loc4_.Team == this.m_team_id || this.m_player_id === _loc4_.ID)) && !(param3 && Enemy(_loc4_).getOwner() === this))
                        {
                           _loc7_ = Number(Utils.getDistanceFrom(this,_loc4_));
                           if(_loc7_ < _loc6_)
                           {
                              _loc5_ = _loc4_;
                              _loc6_ = _loc7_;
                           }
                        }
                     }
                  }
                  _loc8_++;
               }
         }
         return _loc5_;
      }
      
      public function showHealthBoxes(param1:Boolean) : void
      {
         if(param1 && this.STAGEDATA.GameRef.GameMode === Mode.TRAINING && this.STAGEDATA.HudRef.HudMode === 2)
         {
            return;
         }
         if(this.m_healthBoxMC)
         {
            this.m_healthBoxMC.visible = param1;
            this.m_healthBoxMC.damageMC_holder.visible = param1;
            this.m_healthBoxMC.percent_mc.damage.visible = param1;
         }
      }
      
      public function setVisibility(param1:Boolean) : void
      {
         this.m_sprite.visible = param1;
         this.m_shadowEffect.visible = param1;
         this.m_reflectionEffect.visible = param1;
      }
      
      public function unnattachFromGround() : void
      {
         var _loc1_:Number = 0;
         while(_loc1_ < 30 && Boolean(this.testGroundWithCoord(this.m_sprite.x,this.m_sprite.y + 1)))
         {
            _loc1_++;
            --this.m_sprite.y;
         }
         if(_loc1_ >= 30)
         {
            this.m_sprite.y += _loc1_;
         }
         this.m_collision.ground = false;
         this.m_currentPlatform = null;
      }
      
      public function resetFade(param1:int = 15) : void
      {
         this.m_fadeTimer.reset();
         this.m_fadeTimer.MaxTime = param1;
      }
      
      public function resetKnockback() : void
      {
         this.m_xKnockback = 0;
         this.m_yKnockback = 0;
         this.resetKnockbackDecay();
      }
      
      public function fadeIn() : void
      {
         if(!this.m_fadeTimer.IsComplete)
         {
            this.m_fadeTimer.tick();
            this.setBrightness((1 - this.m_fadeTimer.CurrentTime / this.m_fadeTimer.MaxTime) * 100);
         }
      }
      
      public function fadeOut() : void
      {
         if(!this.m_fadeTimer.IsComplete)
         {
            this.m_fadeTimer.tick();
            this.setBrightness(this.m_fadeTimer.CurrentTime / this.m_fadeTimer.MaxTime * 100);
         }
      }
      
      public function isFading() : Boolean
      {
         return !this.m_fadeTimer.IsComplete;
      }
      
      public function initDelayPlayback(param1:Boolean = false) : void
      {
         this.m_delayPlayback = true;
         this.m_delayPlayBackFacingRight = this.m_facingForward;
         this.m_delayPlayBackHitStun = param1;
      }
      
      public function disableDelayPlayback() : void
      {
         this.m_delayPlayback = false;
         this.m_delayPlayBackAnimation = null;
         this.m_delayPlayBackFrame = null;
      }
      
      protected function handleDelayPlayback() : void
      {
         if(this.m_delayPlayback && !(this.m_delayPlayBackHitStun && this.isHitStunOrParalysis()))
         {
            this.m_delayPlayback = false;
            if(this.m_delayPlayBackFacingRight)
            {
               this.m_faceRight();
            }
            else
            {
               this.m_faceLeft();
            }
            if(this.m_delayPlayBackAnimation)
            {
               this.playFrame(this.m_delayPlayBackAnimation);
            }
            if(this.m_delayPlayBackFrame)
            {
               this.stancePlayFrame(this.m_delayPlayBackFrame);
            }
            this.m_delayPlayBackAnimation = null;
            this.m_delayPlayBackFrame = null;
         }
      }
      
      protected function PREPERFORM() : void
      {
         this.m_actionTimerUpdatedOnFrame = false;
         if(this.m_started && this.HasMC && !this.STAGEDATA.Paused && !this.isHitStunOrParalysis() && !this.m_delayPlayback)
         {
            Utils.advanceFrame(this.m_sprite);
            Utils.recursiveMovieClipPlay(this.m_sprite,true);
         }
         else
         {
            this.handleDelayPlayback();
         }
      }
      
      public function PERFORMALL() : void
      {
         this.PREPERFORM();
         this.move();
         this.m_forces();
         this.gravity();
         this.m_groundCollisionTest();
         this.updateSelfPlatform();
         this.updateCamerBox();
         this.POSTPERFORM();
      }
      
      protected function POSTPERFORM() : void
      {
         if(this.HasMC)
         {
            this.m_sprite.stop();
            Utils.recursiveMovieClipPlay(this.m_sprite,false);
            this.updatePaletteSwap();
            this.checkReflection();
            this.checkShadow();
         }
         this.m_started = true;
      }
      
      protected function checkReflection(param1:Number = 1) : void
      {
         var _loc2_:Point = null;
         var _loc3_:Rectangle = null;
         var _loc4_:Rectangle = null;
         var _loc5_:BitmapData = null;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:Matrix = null;
         var _loc9_:Bitmap = null;
         var _loc10_:Matrix = null;
         var _loc11_:Number = NaN;
         if(Boolean(this.m_baseStats.Reflection && this.m_reflectionEffect && this.STAGEDATA.ReflectionsRef && this.STAGEDATA.ReflectionsMaskRef) && Boolean(this.HasStance) && Boolean(this.STAGEDATA.getQualitySettings().shadows))
         {
            _loc2_ = this.STAGEDATA.getPlatformBetweenPointsAsPoint(this.Location,new Point(this.m_sprite.x,this.m_sprite.y + 200));
            if(Boolean(this.m_sprite) && Boolean(this.m_sprite.parent) && Boolean(_loc2_))
            {
               while(this.STAGEDATA.testGroundWithCoord(_loc2_.x,_loc2_.y))
               {
                  --_loc2_.y;
               }
               _loc3_ = this.m_sprite.getBounds(this.m_sprite);
               _loc3_.x *= param1;
               _loc3_.y *= param1;
               _loc3_.width *= param1;
               _loc3_.height *= param1;
               _loc4_ = this.m_sprite.getBounds(this.m_sprite.parent);
               if(_loc3_.width > 2000 || _loc3_.height > 2000)
               {
                  return;
               }
               _loc5_ = new BitmapData(Math.round(_loc3_.width + 0.5),Math.round(_loc3_.height + 0.5),true,1127270);
               _loc6_ = false;
               _loc7_ = false;
               _loc8_ = new Matrix();
               _loc8_.tx = -_loc3_.x;
               _loc8_.ty = -_loc3_.y;
               _loc8_.a = param1;
               _loc8_.d = param1;
               _loc6_ = this.m_sprite.transform.matrix.a < 0;
               _loc7_ = this.m_sprite.transform.matrix.d < 0;
               _loc5_.draw(this.m_sprite,_loc8_,null,null,new Rectangle(0,0,_loc3_.width,Utils.fastAbs(_loc3_.height)),false);
               while(this.m_reflectionEffect.numChildren > 0)
               {
                  if(this.m_reflectionEffect.getChildAt(0) is Bitmap)
                  {
                     (this.m_reflectionEffect.getChildAt(0) as Bitmap).bitmapData.dispose();
                     (this.m_reflectionEffect.getChildAt(0) as Bitmap).bitmapData = null;
                  }
                  this.m_reflectionEffect.removeChild(this.m_reflectionEffect.getChildAt(0));
               }
               _loc9_ = new Bitmap(_loc5_);
               _loc9_.transform.colorTransform = new ColorTransform(1,1,1,0.75);
               _loc10_ = new Matrix();
               _loc11_ = 0;
               if(_loc6_)
               {
                  _loc10_.a = -1;
               }
               if(_loc7_)
               {
                  _loc10_.d = -1;
               }
               _loc10_.tx = _loc6_ ? -_loc3_.x : _loc3_.x;
               _loc10_.ty = _loc7_ ? -_loc3_.y : _loc3_.y;
               _loc9_.transform.matrix = _loc10_.clone();
               this.m_reflectionEffect.addChild(_loc9_);
               this.m_reflectionEffect.scaleX = this.CurrentScale.x;
               this.m_reflectionEffect.scaleY = -0.9 * this.CurrentScale.y;
               this.m_reflectionEffect.alpha = this.m_sprite.alpha;
               this.m_reflectionEffect.x = this.m_sprite.x;
               this.m_reflectionEffect.y = _loc2_.y + (_loc2_.y - this.m_sprite.y);
               if(!this.m_reflectionEffect.parent)
               {
                  this.STAGEDATA.ReflectionsRef.addChildAt(this.m_reflectionEffect,0);
               }
            }
            else
            {
               this.toggleEffect(this.m_reflectionEffect,false);
            }
         }
      }
      
      protected function checkShadow(param1:Number = 1) : void
      {
         var _loc2_:Rectangle = null;
         var _loc3_:Rectangle = null;
         var _loc4_:BitmapData = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Matrix = null;
         var _loc8_:Bitmap = null;
         var _loc9_:Matrix = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         if(Boolean(this.m_baseStats.Shadow && this.m_shadowEffect && this.STAGEDATA.LightSource && this.STAGEDATA.ShadowsRef) && Boolean(this.HasStance) && Boolean(this.STAGEDATA.getQualitySettings().shadows))
         {
            if(Boolean(this.m_collision.ground && this.m_currentPlatform) && Boolean(this.m_sprite) && Boolean(this.m_sprite.parent))
            {
               _loc2_ = this.m_sprite.getBounds(this.m_sprite);
               _loc2_.x *= param1;
               _loc2_.y *= param1;
               _loc2_.width *= param1;
               _loc2_.height *= param1;
               _loc3_ = this.m_sprite.getBounds(this.m_sprite.parent);
               if(_loc2_.width > 2000 || _loc2_.height > 2000 || _loc2_.y >= 0)
               {
                  return;
               }
               if(_loc2_.y + _loc2_.height > 0)
               {
                  _loc2_.height -= _loc2_.height + _loc2_.y;
               }
               _loc4_ = new BitmapData(Math.round(_loc2_.width + 0.5),Math.round(_loc2_.height + 0.5),true,1127270);
               _loc5_ = false;
               _loc6_ = false;
               _loc7_ = new Matrix();
               _loc7_.tx = -_loc2_.x;
               _loc7_.ty = -_loc2_.y;
               _loc7_.a = param1;
               _loc7_.d = param1;
               _loc5_ = this.m_sprite.transform.matrix.a < 0;
               _loc6_ = this.m_sprite.transform.matrix.d < 0;
               _loc4_.draw(this.m_sprite,_loc7_,null,null,new Rectangle(0,0,_loc2_.width,Utils.fastAbs(_loc2_.height)),false);
               while(this.m_shadowEffect.numChildren > 0)
               {
                  if(this.m_shadowEffect.getChildAt(0) is Bitmap)
                  {
                     (this.m_shadowEffect.getChildAt(0) as Bitmap).bitmapData.dispose();
                     (this.m_shadowEffect.getChildAt(0) as Bitmap).bitmapData = null;
                  }
                  this.m_shadowEffect.removeChild(this.m_shadowEffect.getChildAt(0));
               }
               _loc8_ = new Bitmap(_loc4_);
               _loc8_.transform.colorTransform = new ColorTransform(1,1,1,0.25,-255,-255,-255,0);
               _loc9_ = new Matrix();
               _loc10_ = 0;
               if(this.STAGEDATA.LightSource)
               {
                  _loc10_ = Number(Utils.forceBase360(90 - Utils.getAngleBetween(new Point(this.STAGEDATA.LightSource.x,this.m_sprite.y > this.STAGEDATA.LightSource.y ? this.STAGEDATA.LightSource.y - Utils.fastAbs(this.STAGEDATA.LightSource.y - this.m_sprite.y) : this.m_sprite.y),new Point(this.m_sprite.x,this.STAGEDATA.LightSource.y))));
                  if(_loc10_ > 180)
                  {
                     _loc10_ -= 180;
                  }
               }
               _loc11_ = _loc10_ >= 45 && _loc10_ < 90 ? 45 : (_loc10_ >= 90 && _loc10_ < 135 ? 135 : _loc10_);
               _loc9_.c = Math.tan(Utils.toRadians(_loc11_));
               if(_loc5_)
               {
                  _loc9_.a = -1;
               }
               if(_loc6_)
               {
                  _loc9_.d = -1;
               }
               _loc9_.tx = _loc5_ ? -_loc2_.x : _loc2_.x;
               _loc9_.ty = _loc6_ ? -_loc2_.y : _loc2_.y;
               _loc8_.transform.matrix = _loc9_.clone();
               this.m_shadowEffect.addChild(_loc8_);
               this.m_shadowEffect.x = this.m_sprite.x - Math.tan(Utils.toRadians(_loc11_)) * _loc2_.height;
               this.m_shadowEffect.y = this.m_sprite.y;
               this.m_shadowEffect.scaleX = 1;
               this.m_shadowEffect.scaleY = 1;
               this.m_shadowEffect.scaleY = -0.25;
               this.m_shadowEffect.alpha = this.m_sprite.alpha;
               if(!this.m_shadowEffect.parent)
               {
                  this.STAGEDATA.ShadowsRef.addChildAt(this.m_shadowEffect,0);
               }
            }
            else
            {
               this.toggleEffect(this.m_shadowEffect,false);
            }
         }
      }
      
      protected function toggleEffect(param1:MovieClip, param2:Boolean = true) : void
      {
         if(param2)
         {
            if(Boolean(param1) && !param1.parent)
            {
               this.STAGE.addChild(param1);
            }
         }
         else if(Boolean(param1) && param1.parent != null)
         {
            param1.parent.removeChild(param1);
         }
      }
      
      protected function hideAllEffects() : void
      {
         this.toggleEffect(this.m_shadowEffect,false);
      }
      
      public function inKnockback() : Boolean
      {
         return !(this.m_xKnockback == 0 && this.m_yKnockback == 0);
      }
      
      public function inState(param1:uint) : Boolean
      {
         return this.m_state == param1;
      }
      
      public function getState() : uint
      {
         return this.m_state;
      }
      
      public function setState(param1:uint) : void
      {
         var _loc2_:Boolean = param1 != this.m_state;
         var _loc3_:uint = this.m_state;
         this.m_state = param1;
         if(_loc2_)
         {
            this.m_framesSinceLastState = 0;
            this.flushTimers();
            this.removeAllTempEvents();
            this.m_controlFrames();
            this.m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.STATE_CHANGE,{
               "caller":this.APIInstance.instance,
               "fromState":_loc3_,
               "toState":this.m_state
            }));
         }
      }
      
      protected function removeAllTempEvents() : void
      {
         while(this.m_tempEvents.length > 0)
         {
            this.m_eventManager.removeEventListener(this.m_tempEvents[0].type,this.m_tempEvents[0].listener,this.m_tempEvents[0].useCapture);
            this.m_tempEvents.splice(0,1);
         }
      }
      
      protected function m_controlFrames() : void
      {
      }
      
      public function attachEffect(param1:*, param2:Object = null) : MovieClip
      {
         var _loc3_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:MovieClip = null;
         param2 ||= {};
         var _loc4_:Boolean = true;
         var _loc5_:Boolean = true;
         var _loc7_:Number = 1;
         var _loc8_:Number = 1;
         _loc5_ = param2.flip !== undefined ? Boolean(param2.flip) : _loc5_;
         _loc4_ = param2.resize !== undefined ? Boolean(param2.resize) : _loc4_;
         _loc3_ = param2.absolute !== undefined ? Boolean(param2.absolute) : _loc3_;
         _loc6_ = param2.force !== undefined ? Boolean(param2.force) : _loc6_;
         param2.x = param2.x !== undefined ? param2.x : 0;
         param2.y = param2.y !== undefined ? param2.y : 0;
         _loc9_ = param2.behind !== undefined ? Boolean(param2.behind) : false;
         if(Boolean(param1 is String && param1.match(/^global_/)) && Boolean(!this.STAGEDATA.getQualitySettings().global_effects) && !_loc6_)
         {
            return new MovieClip();
         }
         if(param1 != null && (this.m_cancelEffectDelay.IsComplete || param1 != this.m_cancelEffect || this.m_cancelEffectCount < 6))
         {
            if(!_loc3_)
            {
               if(_loc4_)
               {
                  param2.x = this.m_sprite.x + param2.x * this.m_sizeRatio;
                  param2.y = this.m_sprite.y + param2.y * this.m_sizeRatio;
               }
               else
               {
                  param2.x = this.m_sprite.x + param2.x;
                  param2.y = this.m_sprite.y + param2.y;
               }
            }
            _loc10_ = this.STAGEDATA.attachEffect(param1,param2);
            if(_loc10_)
            {
               if(_loc4_)
               {
                  _loc10_.width *= this.m_sizeRatio;
                  _loc10_.height *= this.m_sizeRatio;
               }
               if(!this.m_facingForward && _loc5_)
               {
                  _loc10_.scaleX *= -1;
               }
               if(param1 != this.m_cancelEffect)
               {
                  this.m_cancelEffectCount = 0;
               }
               else
               {
                  ++this.m_cancelEffectCount;
                  this.m_cancelEffectDelay2.reset();
               }
               this.m_cancelEffectDelay.reset();
               this.augmentEffect(_loc10_,param2);
               if(Boolean(_loc9_) && Boolean(_loc10_.parent) && _loc10_.parent === this.m_sprite.parent)
               {
                  _loc10_.parent.setChildIndex(_loc10_,this.m_sprite.parent.getChildIndex(this.m_sprite));
               }
            }
         }
         return _loc10_;
      }
      
      public function attachEffectOverlay(param1:*, param2:Object = null) : MovieClip
      {
         var _loc3_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc9_:MovieClip = null;
         param2 ||= {};
         var _loc4_:Boolean = true;
         var _loc5_:Boolean = true;
         var _loc7_:Number = 1;
         var _loc8_:Number = 1;
         _loc5_ = param2.flip !== undefined ? Boolean(param2.flip) : _loc5_;
         _loc4_ = param2.resize !== undefined ? Boolean(param2.resize) : _loc4_;
         _loc3_ = param2.absolute !== undefined ? Boolean(param2.absolute) : _loc3_;
         _loc6_ = param2.force !== undefined ? Boolean(param2.force) : _loc6_;
         param2.x = param2.x !== undefined ? param2.x : 0;
         param2.y = param2.y !== undefined ? param2.y : 0;
         if(Boolean(param1 is String && param1.match(/^global_/)) && Boolean(!this.STAGEDATA.getQualitySettings().global_effects) && !_loc6_)
         {
            return new MovieClip();
         }
         if(param1 != null)
         {
            if(_loc3_)
            {
               param2.x = this.STAGEDATA.StageRef.x + param2.x;
               param2.y = this.STAGEDATA.StageRef.y + param2.y;
            }
            else if(_loc4_)
            {
               param2.x = this.OverlayX + param2.x * this.m_sizeRatio;
               param2.y = this.OverlayY + param2.y * this.m_sizeRatio;
            }
            else
            {
               param2.x = this.OverlayX + param2.x;
               param2.y = this.OverlayY + param2.y;
            }
            _loc9_ = this.STAGEDATA.attachEffectOverlay(param1,param2);
            if(_loc9_)
            {
               if(_loc4_)
               {
                  _loc9_.width *= this.m_sizeRatio;
                  _loc9_.height *= this.m_sizeRatio;
               }
               if(!this.m_facingForward && _loc5_)
               {
                  _loc9_.scaleX *= -1;
               }
               this.augmentEffect(_loc9_,param2);
            }
         }
         return _loc9_;
      }
      
      private function augmentEffect(param1:MovieClip, param2:Object) : void
      {
         var loop:int = 0;
         var loopHandler:Function = null;
         var parentLockHandler:Function = null;
         var flipXHandler:Function = null;
         var hitStuncheckHandler:Function = null;
         var parentLock:Boolean = false;
         var flipOnX:Boolean = false;
         var syncHitStun:Boolean = false;
         var effect:MovieClip = param1;
         var options:Object = param2;
         loop = 0;
         loop = options.loop !== undefined ? int(options.loop) : loop;
         parentLock = options.parentLock !== undefined ? Boolean(options.parentLock) : parentLock;
         flipOnX = options.flipOnX !== undefined ? Boolean(options.flipOnX) : flipOnX;
         syncHitStun = options.syncHitStun !== undefined ? Boolean(options.syncHitStun) : syncHitStun;
         if(loop > 0)
         {
            loopHandler = function(param1:Event):void
            {
               if(effect.currentFrame === effect.totalFrames - 1)
               {
                  effect.gotoAndStop(1);
                  --loop;
                  if(loop <= 0)
                  {
                     STAGEDATA.removeEventListener(SSF2Event.GAME_TICK_END,loopHandler);
                  }
               }
            };
            this.STAGEDATA.addEventListener(SSF2Event.GAME_TICK_END,loopHandler);
         }
         if(parentLock)
         {
            parentLockHandler = function(param1:Event):void
            {
               effect.x = m_sprite.x + effect.x_offset;
               effect.y = m_sprite.y + effect.y_offset;
               if(effect.currentFrame === effect.totalFrames || !effect.parent)
               {
                  STAGEDATA.removeEventListener(SSF2Event.GAME_TICK_END,parentLockHandler);
               }
            };
            effect.x_offset = effect.x - this.m_sprite.x;
            effect.y_offset = effect.y - this.m_sprite.y;
            this.STAGEDATA.addEventListener(SSF2Event.GAME_TICK_END,parentLockHandler);
         }
         if(flipOnX)
         {
            effect.originalScaleX = effect.scaleX;
            effect.originalFacingRight = this.m_facingForward;
            flipXHandler = function(param1:Event):void
            {
               if(m_facingForward !== effect.originalFacingRight)
               {
                  effect.scaleX = effect.originalScaleX * -1;
               }
               else
               {
                  effect.scaleX = effect.originalScaleX;
               }
               if(effect.currentFrame === effect.totalFrames)
               {
                  STAGEDATA.removeEventListener(SSF2Event.GAME_TICK_END,flipXHandler);
               }
            };
            this.STAGEDATA.addEventListener(SSF2Event.GAME_TICK_END,flipXHandler);
         }
         if(syncHitStun)
         {
            effect.bypassTicker = this.inHitStun();
            hitStuncheckHandler = function(param1:Event):void
            {
               effect.bypassTicker = inHitStun();
               if(!effect.parent)
               {
                  STAGEDATA.removeEventListener(SSF2Event.GAME_TICK_END,hitStuncheckHandler);
               }
            };
            this.STAGEDATA.addEventListener(SSF2Event.GAME_TICK_END,hitStuncheckHandler);
         }
      }
      
      public function attachHurtEffect(param1:String, param2:HitBoxSprite = null, param3:Object = null) : MovieClip
      {
         var _loc4_:* = undefined;
         var _loc5_:Object = {
            "x":(param2 ? param2.centerx : 0),
            "y":(param2 ? param2.centery : 0),
            "scaleX":(1 + Math.min(0 / 100,0.5)) * this.CurrentScale.x,
            "scaleY":(1 + Math.min(0 / 100,0.5)) * this.CurrentScale.y,
            "resize":false,
            "absolute":true
         };
         if(param3)
         {
            for(_loc4_ in param3)
            {
               _loc5_[_loc4_] = param3[_loc4_];
            }
         }
         return this.attachEffectOverlay(param1,_loc5_);
      }
      
      public function dispose() : void
      {
         while(Boolean(this.m_shadowEffect) && this.m_shadowEffect.numChildren > 0)
         {
            if(this.m_shadowEffect.getChildAt(0) is Bitmap)
            {
               (this.m_shadowEffect.getChildAt(0) as Bitmap).bitmapData.dispose();
               (this.m_shadowEffect.getChildAt(0) as Bitmap).bitmapData = null;
            }
            this.m_shadowEffect.removeChild(this.m_shadowEffect.getChildAt(0));
         }
         while(Boolean(this.m_reflectionEffect) && this.m_reflectionEffect.numChildren > 0)
         {
            if(this.m_reflectionEffect.getChildAt(0) is Bitmap)
            {
               (this.m_reflectionEffect.getChildAt(0) as Bitmap).bitmapData.dispose();
               (this.m_reflectionEffect.getChildAt(0) as Bitmap).bitmapData = null;
            }
            this.m_reflectionEffect.removeChild(this.m_reflectionEffect.getChildAt(0));
         }
         if(this.m_apiInstance)
         {
            this.m_apiInstance.dispose();
         }
      }
      
      protected function checkTimers() : void
      {
         if(SpecialMode.modeEnabled(this.STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
         {
            this.m_attack.RefreshRate = 1;
         }
         ++this.m_framesSinceLastState;
         this.tickTimers();
         this.m_knockbackStackingTimer.tick();
         if(!this.m_paralysis)
         {
            if(!this.m_maxParalysisTime.IsComplete)
            {
               this.m_maxParalysisTime.tick();
               if(this.m_maxParalysisTime.IsComplete)
               {
                  this.m_paralysisHitCount = 0;
               }
            }
         }
         this.m_cancelEffectDelay.tick();
         this.m_cancelEffectDelay2.tick();
         if(this.m_cancelEffectDelay2.IsComplete)
         {
            this.m_cancelEffectDelay2.reset();
            this.m_cancelEffectCount = 0;
         }
         this.m_knockbackStacked = false;
      }
      
      public function createTimer(param1:int, param2:int, param3:Function, param4:Object = null) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:Object = {
            "persistent":false,
            "hitStunPause":true
         };
         if(!param4)
         {
            param4 = {};
         }
         for(_loc5_ in _loc6_)
         {
            if(param4[_loc5_] === undefined)
            {
               param4[_loc5_] = _loc6_[_loc5_];
            }
         }
         if(param4.hitStunPause)
         {
            param4.pauseCondition = this.timerHitStunPauseCallback;
         }
         this.m_timers.push(new IntervalTimer(param1,param2,param3,param4));
      }
      
      public function flushTimers(param1:Boolean = false) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.m_timers.length)
         {
            if(param1 || !this.m_timers[_loc2_].Options.persistent)
            {
               this.m_timers[_loc2_].disableProcess();
               this.m_timers.splice(_loc2_--,1);
            }
            _loc2_++;
         }
      }
      
      private function timerHitStunPauseCallback() : Boolean
      {
         return this.m_actionShot;
      }
      
      private function tickTimers() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Vector.<IntervalTimer> = null;
         var _loc3_:int = 0;
         if(this.m_timers.length)
         {
            _loc2_ = new Vector.<IntervalTimer>();
            _loc1_ = 0;
            while(_loc1_ < this.m_timers.length)
            {
               this.m_timers[_loc1_].tick();
               if(this.m_timers[_loc1_].ReadyToProcess)
               {
                  _loc2_.push(this.m_timers[_loc1_]);
               }
               _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < _loc2_.length)
            {
               _loc2_[_loc1_].process();
               if(!_loc2_[_loc1_].Active)
               {
                  _loc3_ = this.m_timers.indexOf(_loc2_[_loc1_]);
                  if(_loc3_ >= 0)
                  {
                     this.m_timers.splice(_loc3_,1);
                  }
               }
               _loc1_++;
            }
         }
      }
      
      public function destroyTimer(param1:Function) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.m_timers.length)
         {
            if(this.m_timers[_loc2_].Callback == param1)
            {
               this.m_timers[_loc2_].disableProcess();
               this.m_timers.splice(_loc2_--,1);
            }
            _loc2_++;
         }
      }
      
      public function takeDamage(param1:AttackDamage, param2:HitBoxSprite = null) : Boolean
      {
         return false;
      }
      
      public function attackCollisionTest() : void
      {
      }
      
      public function attackCollisionTestsCompleted() : void
      {
         this.m_skipAttackCollisionTests = false;
         this.m_skipAttackProcessing = false;
         this.m_attackCollisionTestsPreProcessed = false;
         this.m_attack.HasClanked = false;
      }
      
      public function applyKnockback(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = Number(Utils.calculateVelocity(param1));
         this.applyKnockbackSpeed(_loc3_,param2);
      }
      
      public function applyKnockbackSpeed(param1:Number, param2:Number) : void
      {
         this.m_xKnockback = Utils.calculateXSpeed(param1,param2);
         this.m_yKnockback = -Utils.calculateYSpeed(param1,param2);
         this.resetKnockbackDecay();
      }
      
      protected function decel_knockback() : void
      {
         if(this.m_xKnockback == 0 && this.m_yKnockback == 0)
         {
            return;
         }
         var _loc1_:Boolean = this.m_xKnockback > 0;
         var _loc2_:Boolean = this.m_yKnockback < 0;
         if(this.m_xKnockback != 0)
         {
            this.m_xKnockback += this.m_xKnockbackDecay;
         }
         if(this.m_yKnockback != 0)
         {
            this.m_yKnockback += this.m_yKnockbackDecay;
         }
         if(_loc1_ && this.m_xKnockback < 0 || !_loc1_ && this.m_xKnockback > 0 || Utils.fastAbs(this.m_xKnockback) < 0.0001)
         {
            this.m_xKnockback = 0;
         }
         if(_loc2_ && this.m_yKnockback > 0 || !_loc2_ && this.m_yKnockback < 0 || Utils.fastAbs(this.m_yKnockback) < 0.0001)
         {
            this.m_yKnockback = 0;
         }
      }
      
      protected function m_forces() : void
      {
         if(!this.isHitStunOrParalysis() && this.inKnockback())
         {
            if(this.m_collision.ground && this.m_yKnockback > 0)
            {
               this.m_yKnockback = 0;
            }
            this.m_attemptToMove(this.m_xKnockback,0);
            this.m_attemptToMove(0,this.m_yKnockback);
            this.decel_knockback();
            if(Main.FRAMERATE == 30)
            {
               this.m_attemptToMove(this.m_xKnockback,0);
               this.m_attemptToMove(0,this.m_yKnockback);
               this.decel_knockback();
            }
         }
      }
      
      public function get IsFrozenInTime() : Boolean
      {
         return false;
      }
   }
}


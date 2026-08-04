package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.api.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.platforms.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   
   public class TargetTestTarget extends InteractiveSprite
   {
      
      protected var m_targetMovement:Vector.<PlatformMovement>;
      
      protected var m_moveIndex:int;
      
      protected var m_moveTimer:FrameTimer;
      
      protected var m_waitTimer:FrameTimer;
      
      protected var m_wait:Boolean;
      
      protected var m_xLoc:Number;
      
      protected var m_yLoc:Number;
      
      protected var m_className:String;
      
      public function TargetTestTarget(param1:MovieClip, param2:StageData, param3:Object = null)
      {
         m_baseStats = new InteractiveSpriteStats();
         if(!param3)
         {
            param3 = {};
         }
         if(!param3.classAPI)
         {
            param3.classAPI = param2.BASE_CLASSES.SSF2Target;
         }
         m_apiInstance = new SSF2Target(param3.classAPI,this);
         if(!param1)
         {
            param1 = ResourceManager.getLibraryMC(m_apiInstance.getOwnStats().linkage_id);
            param2.StageRef.addChild(param1);
         }
         super(param1,param2,false);
         STAGEDATA = param2;
         m_sprite = param1;
         m_gravity = 0;
         m_max_ySpeed = 0;
         this.m_targetMovement = new Vector.<PlatformMovement>();
         this.m_moveIndex = m_sprite.startIndex ? int(m_sprite.startIndex) : 0;
         this.m_moveTimer = new FrameTimer(1);
         this.m_waitTimer = new FrameTimer(1);
         var _loc4_:int = 1;
         while(m_sprite["movement" + _loc4_])
         {
            this.addMovement(m_sprite["movement" + _loc4_]);
            _loc4_++;
         }
         this.m_wait = false;
         this.m_xLoc = m_sprite.x;
         this.m_yLoc = m_sprite.y;
         this.m_className = Main.getClassName(m_sprite);
         buildHitBoxData(this.m_className,false);
         disableDelayPlayback();
         setState(TState.IDLE);
      }
      
      override public function get CurrentAnimation() : HitBoxAnimation
      {
         return m_hitBoxManager == null ? null : (m_hitBoxManager.HitBoxAnimationList.length <= 0 || !m_sprite.currentLabel ? null : m_hitBoxManager.getHitBoxAnimation(this.m_className + "_" + m_sprite.currentLabel));
      }
      
      override protected function m_controlFrames() : void
      {
         if(m_state == TState.IDLE)
         {
            playFrame("idle");
         }
         else if(m_state == TState.BROKEN)
         {
            playFrame("idle");
         }
         else if(m_state == TState.DEAD)
         {
         }
      }
      
      override protected function validateBypass(param1:AttackDamage) : Boolean
      {
         if(param1.BypassNonGrabbed)
         {
            return false;
         }
         if(Boolean(param1.Owner as Projectile && param1.BypassNonLatched) && Boolean(Projectile(param1.Owner).Latched) && Projectile(param1.Owner).LatchID == this)
         {
            return false;
         }
         return true;
      }
      
      override public function validateHit(param1:AttackDamage, param2:Boolean = false, param3:Boolean = false) : Boolean
      {
         if(!super.validateHit(param1,param2,param3) || !inState(TState.IDLE))
         {
            return false;
         }
         return true;
      }
      
      override public function takeDamage(param1:AttackDamage, param2:HitBoxSprite = null) : Boolean
      {
         var _loc3_:Number = NaN;
         var _loc4_:MovieClip = null;
         if(!this.validateHit(param1,false,true))
         {
            return false;
         }
         if(param1.HasEffect || !param1.HasEffect && !isIntangible() && param1.Damage > 0)
         {
            if(m_hurtInterrupt != null && Boolean(m_hurtInterrupt({
               "target":(Boolean(param1.Owner) && Boolean(param1.Owner.APIInstance) ? param1.Owner.APIInstance.instance : null),
               "attackBoxData":param1.exportAttackDamageData(),
               "collisionRect":(param2 ? param2.BoundingBox : null)
            })))
            {
               return false;
            }
            initDelayPlayback(false);
            _loc3_ = Number(Utils.calculateReversedAngle(Utils.calculateAttackDirection(param1,this),param1,this));
            if(param1.EffectID != null && param1.EffectID != null && Boolean(STAGEDATA.getQualitySettings().hit_effects))
            {
               _loc4_ = attachHurtEffect(param1.EffectID,param2,{
                  "scaleX":0.25 + 0.75 * Math.min(param1.Damage / 16,1),
                  "scaleY":0.25 + 0.75 * Math.min(param1.Damage / 16,1)
               });
               if(_loc4_)
               {
                  _loc4_.rotation = param1.IsForward ? 180 - _loc3_ : -_loc3_;
               }
            }
            this.breakTarget();
            return true;
         }
         return false;
      }
      
      public function destroy() : void
      {
         if(!inState(TState.DEAD))
         {
            m_skipAttackCollisionTests = true;
            m_skipAttackProcessing = true;
            STAGEDATA.CamRef.deleteTarget(m_sprite);
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.TARGET_DESTROYED,{"caller":this.APIInstance.instance}));
            disableDelayPlayback();
            setState(TState.DEAD);
            if(m_sprite.parent)
            {
               m_sprite.parent.removeChild(m_sprite);
            }
            removeAllTempEvents();
            flushTimers();
            if(Boolean(m_shadowEffect) && Boolean(m_shadowEffect.parent))
            {
               m_shadowEffect.parent.removeChild(m_shadowEffect);
            }
            m_shadowEffect = null;
            if(Boolean(m_reflectionEffect) && Boolean(m_reflectionEffect.parent))
            {
               m_reflectionEffect.parent.removeChild(m_reflectionEffect);
            }
            m_reflectionEffect = null;
            STAGEDATA.removeTarget(this);
         }
      }
      
      public function breakTarget() : void
      {
         if(inState(TState.IDLE))
         {
            disableDelayPlayback();
            setState(TState.BROKEN);
            stancePlayFrame("break");
            STAGEDATA.playSpecificSound("targetbreak");
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.TARGET_BROKEN,{"caller":this.APIInstance.instance}));
         }
      }
      
      override protected function move() : void
      {
         if(this.m_targetMovement.length)
         {
            if(!this.m_wait)
            {
               if(!this.m_moveTimer.IsComplete)
               {
                  if(this.m_targetMovement[this.m_moveIndex].xAccel > 0)
                  {
                     if(this.m_targetMovement[this.m_moveIndex].xSpeed > 0 && m_xSpeed < this.m_targetMovement[this.m_moveIndex].xSpeed)
                     {
                        m_xSpeed += this.m_targetMovement[this.m_moveIndex].xAccel;
                     }
                     else if(this.m_targetMovement[this.m_moveIndex].xSpeed < 0 && m_xSpeed > this.m_targetMovement[this.m_moveIndex].xSpeed)
                     {
                        m_xSpeed -= this.m_targetMovement[this.m_moveIndex].xAccel;
                     }
                  }
                  if(this.m_targetMovement[this.m_moveIndex].yAccel > 0)
                  {
                     if(this.m_targetMovement[this.m_moveIndex].ySpeed > 0 && m_ySpeed < this.m_targetMovement[this.m_moveIndex].ySpeed)
                     {
                        m_ySpeed += this.m_targetMovement[this.m_moveIndex].yAccel;
                     }
                     else if(this.m_targetMovement[this.m_moveIndex].ySpeed < 0 && m_ySpeed > this.m_targetMovement[this.m_moveIndex].ySpeed)
                     {
                        m_ySpeed -= this.m_targetMovement[this.m_moveIndex].yAccel;
                     }
                  }
               }
               else if(this.m_moveTimer.IsComplete)
               {
                  if(this.m_targetMovement[this.m_moveIndex].xDecel > 0)
                  {
                     if(this.m_targetMovement[this.m_moveIndex].xSpeed > 0)
                     {
                        m_xSpeed -= this.m_targetMovement[this.m_moveIndex].xDecel;
                        if(m_xSpeed <= 0)
                        {
                           this.m_moveTimer.reset();
                           this.m_wait = true;
                        }
                     }
                     else if(this.m_targetMovement[this.m_moveIndex].xSpeed < 0)
                     {
                        m_xSpeed += this.m_targetMovement[this.m_moveIndex].xDecel;
                        if(m_xSpeed >= 0)
                        {
                           this.m_moveTimer.reset();
                           this.m_wait = true;
                        }
                     }
                  }
                  if(this.m_targetMovement[this.m_moveIndex].yDecel > 0)
                  {
                     if(this.m_targetMovement[this.m_moveIndex].ySpeed > 0)
                     {
                        m_ySpeed -= this.m_targetMovement[this.m_moveIndex].yDecel;
                        if(m_ySpeed < 0)
                        {
                           this.m_moveTimer.reset();
                           this.m_wait = true;
                        }
                     }
                     else if(this.m_targetMovement[this.m_moveIndex].ySpeed < 0)
                     {
                        m_ySpeed += this.m_targetMovement[this.m_moveIndex].yDecel;
                        if(m_ySpeed > 0)
                        {
                           this.m_moveTimer.reset();
                           this.m_wait = true;
                        }
                     }
                     else
                     {
                        this.m_moveTimer.reset();
                        this.m_wait = true;
                     }
                  }
                  if(this.m_targetMovement[this.m_moveIndex].xDecel <= 0 && this.m_targetMovement[this.m_moveIndex].yDecel <= 0)
                  {
                     this.m_moveTimer.reset();
                     this.m_wait = true;
                  }
               }
            }
            else
            {
               this.m_waitTimer.tick();
               if(this.m_waitTimer.IsComplete)
               {
                  this.m_moveTimer.reset();
                  this.m_waitTimer.reset();
                  this.incrementMovement();
                  this.m_moveTimer.MaxTime = this.m_targetMovement[this.m_moveIndex].moveTime;
                  this.m_waitTimer.MaxTime = this.m_targetMovement[this.m_moveIndex].waitTime;
                  m_xSpeed = this.m_targetMovement[this.m_moveIndex].xAccel > 0 ? 0 : this.m_targetMovement[this.m_moveIndex].xSpeed;
                  m_ySpeed = this.m_targetMovement[this.m_moveIndex].yAccel > 0 ? 0 : this.m_targetMovement[this.m_moveIndex].ySpeed;
                  this.m_wait = false;
               }
            }
         }
      }
      
      public function addMovement(param1:Object) : void
      {
         var _loc2_:PlatformMovement = new PlatformMovement();
         _loc2_.xAccel = param1.xAccel ? Number(param1.xAccel) : 0;
         _loc2_.xDecel = param1.xDecel ? Number(param1.xDecel) : 0;
         _loc2_.yAccel = param1.yAccel ? Number(param1.yAccel) : 0;
         _loc2_.yDecel = param1.yDecel ? Number(param1.yDecel) : 0;
         _loc2_.moveTime = param1.moveTime ? int(param1.moveTime) : 0;
         _loc2_.waitTime = param1.waitTime ? int(param1.waitTime) : 0;
         _loc2_.xSpeed = param1.xSpeed ? Number(param1.xSpeed) : 0;
         _loc2_.ySpeed = param1.ySpeed ? Number(param1.ySpeed) : 0;
         _loc2_.fallthrough = param1.fallthrough !== undefined ? Boolean(param1.fallthrough) : false;
         _loc2_.noDropThrough = param1.noDropThrough !== undefined ? Boolean(param1.noDropThrough) : false;
         _loc2_.camFocus = param1.camFocus !== undefined ? Boolean(param1.camFocus) : false;
         this.m_targetMovement.push(_loc2_);
         if(this.m_targetMovement.length === 1)
         {
            this.m_wait = false;
            this.m_moveIndex = 0;
            this.m_moveTimer.MaxTime = _loc2_.moveTime;
            this.m_moveTimer.MaxTime = _loc2_.moveTime;
            this.m_waitTimer.reset();
            this.m_waitTimer.reset();
            m_xSpeed = _loc2_.xAccel > 0 ? 0 : _loc2_.xSpeed;
            m_ySpeed = _loc2_.yAccel > 0 ? 0 : _loc2_.ySpeed;
            if(_loc2_.camFocus)
            {
               STAGEDATA.CamRef.addForcedTarget(m_sprite);
            }
         }
      }
      
      public function clearMovement() : void
      {
         this.m_targetMovement.splice(0,this.m_targetMovement.length);
      }
      
      private function incrementMovement() : void
      {
         ++this.m_moveIndex;
         if(this.m_moveIndex >= this.m_targetMovement.length)
         {
            this.m_moveIndex = 0;
         }
      }
      
      public function stop() : void
      {
         m_sprite.stop();
      }
      
      public function play() : void
      {
         m_sprite.play();
      }
      
      override public function PERFORMALL() : void
      {
         PREPERFORM();
         if(inState(TState.IDLE))
         {
            this.move();
         }
         POSTPERFORM();
      }
   }
}


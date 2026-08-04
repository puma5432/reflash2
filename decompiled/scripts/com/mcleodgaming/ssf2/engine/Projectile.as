package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.api.*;
   import com.mcleodgaming.ssf2.audio.SoundObject;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.enemies.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.items.*;
   import com.mcleodgaming.ssf2.platforms.Platform;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.geom.*;
   
   public class Projectile extends InteractiveSprite
   {
      
      public static const ATTACK_IDLE:String = "attack_idle";
      
      protected var m_owner:InteractiveSprite;
      
      private var m_bounce_total:int;
      
      private var m_xSpeedInit:Number;
      
      private var m_ySpeedInit:Number;
      
      private var m_x_start:Number;
      
      private var m_y_start:Number;
      
      private var m_time:int;
      
      private var m_attachedEffect:Boolean;
      
      private var m_trailEffectTimer:int;
      
      private var m_homingAngle:Number;
      
      private var m_reverseTimer:int;
      
      private var m_wasReversed:Boolean;
      
      private var m_damageWasDone:Boolean;
      
      private var m_x_influence:Number;
      
      private var m_y_influence:Number;
      
      private var m_angle:Number;
      
      private var m_latch_id:InteractiveSprite;
      
      private var m_latch_xLoc:Number;
      
      private var m_latch_yLoc:Number;
      
      private var m_hasSwitched:Boolean;
      
      private var m_rocketReadyTimer:FrameTimer;
      
      private var m_lastSFX:int;
      
      private var m_lastVFX:int;
      
      private var m_volume_sfx:Number;
      
      private var m_volume_vfx:Number;
      
      private var m_projectileStats:ProjectileAttack;
      
      private var m_projectileStatsOriginal:ProjectileAttack;
      
      private var __attemptToMovePointCache:Point;
      
      public function Projectile(param1:Object, param2:ProjectileAttack, param3:StageData)
      {
         var _loc5_:String = null;
         this.__attemptToMovePointCache = new Point();
         param3.addProjectile(this);
         m_baseStats = this.m_projectileStats = new ProjectileAttack();
         this.m_projectileStats.importData(param2.exportData());
         this.m_projectileStatsOriginal = new ProjectileAttack();
         m_apiInstance = new SSF2Projectile(this.m_projectileStats.ClassAPI,this);
         this.m_projectileStats.importData(m_apiInstance.getOwnStats());
         this.m_owner = param1["owner"];
         var _loc4_:MovieClip = ResourceManager.getLibraryMC(this.m_projectileStats.LinkageID);
         _loc4_.ACTIVE = true;
         super(_loc4_,param3);
         m_player_id = param1["player_id"];
         m_attackData = this.m_projectileStats.AttackDataObj;
         m_attackData.Owner = this;
         m_shadowEffect = new MovieClip();
         m_xSpeed = param1["facingForward"] ? Number(this.m_projectileStats.XSpeed) : -this.m_projectileStats.XSpeed;
         this.m_xSpeedInit = m_xSpeed;
         m_ySpeed = this.m_projectileStats.YSpeed;
         this.m_ySpeedInit = this.m_projectileStats.YSpeed;
         this.m_bounce_total = 0;
         this.m_x_start = param1["x_start"];
         this.m_y_start = param1["y_start"];
         m_sizeRatio = param1["sizeRatio"];
         if(this.m_owner is Character)
         {
            this.m_volume_sfx = param1["volume_sfx"];
            this.m_volume_vfx = param1["volume_vfx"];
         }
         else
         {
            this.m_volume_sfx = 1;
            this.m_volume_vfx = 1;
         }
         m_sprite.width *= m_sizeRatio;
         m_sprite.height *= m_sizeRatio;
         m_width = this.m_projectileStats.Width;
         m_height = this.m_projectileStats.Height;
         m_facingForward = param1["facingForward"];
         m_sprite.x = this.m_x_start;
         m_sprite.y = this.m_y_start;
         this.m_hasSwitched = false;
         if(Boolean(this.m_projectileStats.InheritPalette) && this.m_owner is Character)
         {
            this.m_owner.applyPalette(m_sprite);
            setPaletteSwap(this.m_owner.PaletteSwapData,this.m_owner.PaletteSwapPAData);
         }
         m_lastAttackID = new Array(15);
         m_lastAttackIndex = 0;
         this.m_x_influence = 0;
         this.m_y_influence = 0;
         this.m_lastSFX = -1;
         this.m_lastVFX = -1;
         this.m_rocketReadyTimer = new FrameTimer(5);
         this.m_latch_id = null;
         this.m_latch_xLoc = 0;
         this.m_latch_yLoc = 0;
         this.m_reverseTimer = 0;
         this.m_wasReversed = false;
         m_terrains = param1["terrains"];
         m_platforms = param1["platforms"];
         this.m_homingAngle = Utils.forceBase360(Utils.getAngleBetween(new Point(),new Point(m_xSpeed,m_ySpeed)));
         this.m_trailEffectTimer = 0;
         this.m_attachedEffect = false;
         this.m_damageWasDone = false;
         m_sprite.player_id = m_player_id;
         m_sprite.uid = m_uid;
         m_sprite.cam_width = m_width;
         m_sprite.cam_height = m_height;
         m_currentPlatform = null;
         m_collision = new Collision();
         if(!m_facingForward)
         {
            this.m_faceLeft();
         }
         this.m_time = 0;
         if(Boolean(this.m_owner) && Boolean(this.m_owner.AttackStateData))
         {
            m_attack.AttackRatio = this.m_owner.AttackStateData.AttackRatio;
         }
         m_attack.importAttackStateData(this.m_projectileStats.exportAttackStateData());
         m_attack.ID = Utils.getUID();
         m_attack.XLoc = m_sprite.x;
         m_attack.YLoc = m_sprite.y;
         m_attack.IsForward = m_facingForward;
         m_attack.ChargeTime = param1["chargetime"];
         m_attack.ChargeTimeMax = param1["chargetime_max"];
         m_attack.Frame = Projectile.ATTACK_IDLE;
         m_attack.SizeStatus = param1["sizeStatus"];
         m_attack.ExecTime = 0;
         m_attack.RefreshRate = m_attackData.getAttack(m_attack.Frame).RefreshRate;
         m_attack.ForceComboContinue = m_attackData.getAttack(m_attack.Frame).ForceComboContinue;
         m_attack.RefreshRateReady = false;
         m_attackData.getAttack(m_attack.Frame).OverrideMap.clear();
         m_attack.StaleMultiplier = param1["staleMultiplier"];
         m_attack.IsAttacking = true;
         m_team_id = param1["team_id"];
         if(this.m_owner is Character && this.m_owner.AttackStateData.IsAttacking && this.m_owner.AttackStateData.IsThrow)
         {
            m_attack.IsThrow = true;
         }
         m_started = false;
         buildHitBoxData(this.m_projectileStats.LinkageID);
         if(Main.DEBUG)
         {
            verifiyHitBoxData();
         }
         m_apiInstance = new SSF2Projectile(this.m_projectileStats.ClassAPI,this);
         m_attackData.importAttacks(m_apiInstance.getAttackStats());
         m_attackData.importItems(m_apiInstance.getItemStats());
         m_attackData.importProjectiles(m_apiInstance.getProjectileStats());
         m_attack.AttackID = this.m_projectileStats.LinkAttackID ? this.m_owner.AttackStateData.AttackID : int(Utils.getUID());
         if(this.m_projectileStats.ControlDirection >= 0)
         {
            this.m_projectileStats.importData({"controlDirection":Utils.forceBase360(this.m_projectileStats.ControlDirection)});
            this.m_angle = this.m_projectileStats.ControlDirection;
            m_xSpeed = Utils.fastAbs(m_xSpeed);
            this.m_xSpeedInit = m_xSpeed;
            this.angleControl(this.m_xSpeedInit,this.m_projectileStats.ControlDirection);
         }
         else
         {
            this.m_angle = 0;
         }
         if(Boolean(this.m_projectileStats.LockSize) && this.m_owner is Character)
         {
            m_sizeRatio = Character(this.m_owner).OriginalSizeRatio;
         }
         this.m_projectileStatsOriginal.importDataCopy(this.m_projectileStats);
         this.syncStats();
         m_apiInstance.initialize();
         playFrame(m_attack.Frame);
      }
      
      override public function get CurrentAnimation() : HitBoxAnimation
      {
         return m_hitBoxManager == null ? null : (m_hitBoxManager.HitBoxAnimationList.length <= 0 || !m_currentAnimationID ? null : m_hitBoxManager.getHitBoxAnimation(this.m_projectileStats.LinkageID + "_" + m_currentAnimationID));
      }
      
      override public function m_attemptToMove(param1:Number, param2:Number) : void
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
            m_collision.leftSide = param1 < 0 && m_collision.ground && Boolean(testTerrainWithCoord(m_sprite.x + param1 - this.m_projectileStats.KneeXOffset,m_sprite.y + param2 + this.m_projectileStats.KneeYOffset));
            m_collision.rightSide = param1 > 0 && m_collision.ground && Boolean(testTerrainWithCoord(m_sprite.x + param1 + this.m_projectileStats.KneeXOffset,m_sprite.y + param2 + this.m_projectileStats.KneeYOffset));
            if(!m_collision.ground && !this.m_projectileStats.Ghost && !this.m_projectileStats.Latch)
            {
               _loc4_ = this.__attemptToMovePointCache;
               _loc4_.copyFrom(Location);
               _loc5_ = moveSprite(param1,param2);
               _loc6_ = _loc5_ != null;
               if(m_collision.rightSide && param1 > 0 || m_collision.leftSide && param1 < 0)
               {
                  m_sprite.x = _loc4_.x;
               }
               _loc7_ = Number(Utils.getAngleBetween(new Point(_loc4_.x,_loc4_.y),new Point(m_sprite.x,m_sprite.y)));
               if(_loc6_ && !(_loc7_ >= 225 && _loc7_ <= 315))
               {
                  m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.HIT_WALL,{
                     "caller":this.APIInstance.instance,
                     "left":_loc7_ < 225 && _loc7_ > 135,
                     "right":_loc7_ < 45 && _loc7_ >= 0 || _loc7_ <= 360 && _loc7_ > 315,
                     "top":_loc7_ >= 45 && _loc7_ >= 135
                  }));
               }
               if(_loc6_ && param2 >= 0)
               {
                  this.m_groundCollisionTest();
               }
               if(_loc6_ && Boolean(this.m_projectileStats.Sticky))
               {
                  this.stick();
               }
               if(this.m_projectileStats.Boomerang)
               {
                  if(_loc6_ || m_collision.leftSide && m_xSpeed < 0 || m_collision.rightSide && m_xSpeed > 0)
                  {
                     this.m_hasSwitched = true;
                     m_xSpeed *= -1;
                     m_ySpeed *= -1;
                  }
               }
            }
            else if(!this.m_projectileStats.Ghost && !this.m_projectileStats.Latch)
            {
               _loc8_ = 10;
               param1 /= _loc8_;
               param2 /= _loc8_;
               _loc9_ = false;
               _loc3_ = 0;
               while(_loc3_ < _loc8_ && !inState(PState.DEAD))
               {
                  m_collision.leftSide = param1 < 0 && m_collision.ground && Boolean(testTerrainWithCoord(m_sprite.x + param1 - this.m_projectileStats.KneeXOffset,m_sprite.y + param2 + this.m_projectileStats.KneeYOffset));
                  m_collision.rightSide = param1 > 0 && m_collision.ground && Boolean(testTerrainWithCoord(m_sprite.x + param1 + this.m_projectileStats.KneeXOffset,m_sprite.y + param2 + this.m_projectileStats.KneeYOffset));
                  if(m_collision.leftSide || m_collision.rightSide)
                  {
                     _loc9_ = true;
                  }
                  if(param2 < 0 && !testTerrainWithCoord(m_sprite.x,m_sprite.y + param2))
                  {
                     m_sprite.y += param2;
                  }
                  m_sprite.x += !(!this.m_projectileStats.Ghost && m_collision.rightSide && param1 > 0 || !this.m_projectileStats.Ghost && m_collision.leftSide && param1 < 0) ? param1 : 0;
                  if(param2 > 0 && !testTerrainWithCoord(m_sprite.x,m_sprite.y + param2))
                  {
                     m_sprite.y += param2;
                  }
                  if(!inState(PState.DEAD))
                  {
                     this.attachToGround();
                  }
                  _loc3_++;
               }
               if(_loc9_)
               {
                  m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.HIT_WALL,{
                     "caller":this.APIInstance.instance,
                     "left":m_collision.leftSide,
                     "right":m_collision.rightSide,
                     "top":false
                  }));
                  if(this.m_projectileStats.Boomerang)
                  {
                     if(m_collision.leftSide && m_xSpeed < 0 || m_collision.rightSide && m_xSpeed > 0)
                     {
                        this.m_hasSwitched = true;
                        m_xSpeed *= -1;
                        m_ySpeed *= -1;
                     }
                  }
               }
            }
            else
            {
               m_sprite.x += param1;
               m_sprite.y += param2;
            }
         }
      }
      
      override protected function m_groundCollisionTest() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         if(this.m_projectileStats.Suspend)
         {
            return;
         }
         if(!this.m_projectileStats.Ghost && !inState(PState.DEAD) && m_ySpeed >= 0 && !this.m_projectileStats.Latch && Boolean(this.m_projectileStats.RideGround))
         {
            _loc1_ = m_collision.ground;
            if(m_collision.ground && m_ySpeed >= 0)
            {
               this.attachToGround();
            }
            _loc2_ = (m_currentPlatform = testGroundWithCoord(m_sprite.x,m_sprite.y + 1)) != null;
            m_currentPlatform = testGroundWithCoord(m_sprite.x,m_sprite.y + 1);
            m_collision.ground = _loc2_;
            if(m_collision.ground)
            {
               this.attachToGround();
            }
            if(!inState(PState.DEAD) && m_collision.ground && !_loc1_)
            {
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.GROUND_TOUCH,{"caller":this.APIInstance.instance}));
            }
            else if(!inState(PState.DEAD) && !m_collision.ground && _loc1_)
            {
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.GROUND_LEAVE,{"caller":this.APIInstance.instance}));
            }
         }
      }
      
      private function getGround(param1:Number, param2:Number) : Platform
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < m_terrains.length && !m_terrains[_loc3_].hitTestPoint(param1,param2 + 1,true))
         {
            _loc3_++;
         }
         if(_loc3_ < m_terrains.length && m_terrains[_loc3_].hitTestPoint(param1,param2 + 1,true) && m_terrains[_loc3_].fallthrough != true && !m_terrains[_loc3_].shouldIgnore(this))
         {
            return m_terrains[_loc3_];
         }
         _loc3_ = 0;
         while(_loc3_ < m_platforms.length && !m_platforms[_loc3_].hitTestPoint(param1,param2 + 1,true))
         {
            _loc3_++;
         }
         if(_loc3_ < m_platforms.length && m_platforms[_loc3_].hitTestPoint(param1,param2 + 1,true) && m_ySpeed >= 0 && m_platforms[_loc3_].fallthrough != true && !m_platforms[_loc3_].shouldIgnore(this))
         {
            return m_platforms[_loc3_];
         }
         return null;
      }
      
      override protected function m_faceRight() : void
      {
         if(m_delayPlayback)
         {
            m_delayPlayBackFacingRight = true;
         }
         if(!this.m_projectileStats.NoFlip && !m_delayPlayback)
         {
            m_sprite.scaleX = Math.abs(m_sprite.scaleX);
         }
         m_facingForward = true;
      }
      
      override protected function m_faceLeft() : void
      {
         if(m_delayPlayback)
         {
            m_delayPlayBackFacingRight = false;
         }
         if(!this.m_projectileStats.NoFlip && !m_delayPlayback)
         {
            m_sprite.scaleX = -Math.abs(m_sprite.scaleX);
         }
         m_facingForward = false;
      }
      
      override public function attachToGround() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Boolean = true;
         if(m_ySpeed >= 0 && Boolean(this.m_projectileStats.RideGround))
         {
            _loc2_ = 0;
            _loc1_ = m_sprite.y + 20;
            while(m_sprite.y < _loc1_ && !testCoordCollision(m_sprite.x,m_sprite.y))
            {
               ++m_sprite.y;
            }
            this.checkIfDead();
            if(!testCoordCollision(m_sprite.x,m_sprite.y) || inState(PState.DEAD))
            {
               m_sprite.y = _loc1_ - 20;
            }
            if(m_currentPlatform != null && m_ySpeed >= 0)
            {
               _loc2_ = 0;
               if(m_currentPlatform.fallthrough != true && !m_currentPlatform.shouldIgnore(this))
               {
                  while(m_currentPlatform.hitTestPoint(GlobalX,GlobalY,true))
                  {
                     m_sprite.y -= 1 / 4;
                     _loc2_ = int(_loc2_ + 1 / 4);
                  }
               }
               this.checkIfDead();
               if((_loc2_ >= (STAGEDATA.Terrains.indexOf(m_currentPlatform) >= 0) ? Boolean(40) : Boolean(10)) || inState(PState.DEAD))
               {
                  m_sprite.y += _loc2_;
                  if(Boolean(this.m_projectileStats.Sticky) && OnTerrain)
                  {
                     this.stick();
                  }
                  _loc3_ = false;
               }
            }
            else
            {
               _loc3_ = false;
            }
         }
         else
         {
            _loc3_ = false;
         }
         return _loc3_;
      }
      
      public function get ProjectileAttackObj() : ProjectileAttack
      {
         return this.m_projectileStats;
      }
      
      public function get Dead() : Boolean
      {
         return inState(PState.DEAD);
      }
      
      public function get Attack() : AttackState
      {
         return m_attack;
      }
      
      public function get Visible() : Boolean
      {
         return m_sprite.visible;
      }
      
      public function get LinkageID() : String
      {
         return this.m_projectileStats.LinkageID;
      }
      
      public function get TeamID() : int
      {
         return m_team_id;
      }
      
      public function get Time() : int
      {
         return this.m_time;
      }
      
      public function get Instance() : MovieClip
      {
         return m_sprite;
      }
      
      public function get Latched() : Boolean
      {
         return this.m_latch_id != null;
      }
      
      public function get LatchID() : InteractiveSprite
      {
         return this.m_latch_id;
      }
      
      public function get WasReversed() : Boolean
      {
         return this.m_wasReversed;
      }
      
      public function get JustReversed() : Boolean
      {
         return Boolean(this.m_reverseTimer > 0);
      }
      
      public function isReversed() : Boolean
      {
         return this.m_wasReversed;
      }
      
      public function getCurrentCharge() : int
      {
         return m_attack.ChargeTime;
      }
      
      public function getCurrentMaxCharge() : int
      {
         return m_attack.ChargeTimeMax;
      }
      
      override public function getLinkageID() : String
      {
         return this.m_projectileStats.LinkageID;
      }
      
      public function getProjectileStat(param1:String) : *
      {
         return this.m_projectileStats.getVar(param1);
      }
      
      public function exportStats() : Object
      {
         return this.m_projectileStatsOriginal.exportData();
      }
      
      public function updateProjectileStats(param1:Object) : void
      {
         this.m_projectileStats.importData(param1);
         this.syncStats();
      }
      
      override public function updateAttackStats(param1:Object) : void
      {
         super.updateAttackStats(param1);
         this.syncStats();
      }
      
      override public function updateAttackBoxStats(param1:int, param2:Object) : void
      {
         super.updateAttackBoxStats(param1,param2);
      }
      
      public function getOwner() : InteractiveSprite
      {
         return this.m_owner;
      }
      
      public function getOwnerAPI() : *
      {
         if(this.m_owner)
         {
            return this.m_owner.APIInstance.instance;
         }
         return null;
      }
      
      public function setOwnerAPI(param1:InteractiveSprite) : void
      {
         this.m_owner = param1 ? STAGEDATA.getGameObjectByUID(param1.UID) : null;
         if(!this.m_owner)
         {
            m_player_id = -1;
            m_team_id = -1;
         }
         else
         {
            m_player_id = param1.ID;
            m_team_id = m_team_id;
         }
      }
      
      override protected function syncStats() : void
      {
         m_gravity = this.m_projectileStats.Gravity;
         m_max_ySpeed = this.m_projectileStats.MaxGravity;
         m_width = this.m_projectileStats.Width;
         m_height = this.m_projectileStats.Height;
         m_bypassCollisionTesting = this.m_projectileStats.BypassCollisionTesting;
         this.m_x_influence = this.m_projectileStats.InfluenceXMovement === -1 ? 0 : Number(this.m_x_influence);
         this.m_y_influence = this.m_projectileStats.InfluenceYMovement === -1 ? 0 : Number(this.m_y_influence);
      }
      
      public function angleControl(param1:Number, param2:Number) : void
      {
         param2 = Number(Utils.forceBase360(param2));
         m_xSpeed = param2 === 90 || param2 === 270 ? 0 : param1 * Math.cos(param2 * Math.PI / 180);
         m_ySpeed = param2 === 0 || param2 === 180 ? 0 : -param1 * Math.sin(param2 * Math.PI / 180);
      }
      
      private function checkIfDead() : void
      {
         if(this.m_projectileStats.Suspend)
         {
            return;
         }
         if(Boolean(!inState(PState.DEAD) && !this.m_projectileStats.SurviveDeathBounds) && Boolean(STAGEDATA.DeathBounds) && (this.m_projectileStats.ControlDirection == -1 && (m_sprite.x < STAGEDATA.DeathBounds.x || m_sprite.x > STAGEDATA.DeathBounds.x + STAGEDATA.DeathBounds.width || m_sprite.y < STAGEDATA.DeathBounds.y || m_sprite.y > STAGEDATA.DeathBounds.y + STAGEDATA.DeathBounds.height)))
         {
            this.destroy();
         }
         else if(this.m_projectileStats.TimeMax > 0 && this.m_time >= this.m_projectileStats.TimeMax && !inState(PState.DEAD))
         {
            this.destroy();
         }
         else if((m_xSpeed <= 0 && this.m_xSpeedInit > 0 || m_xSpeed >= 0 && this.m_xSpeedInit < 0) && this.m_projectileStats.XDecay != 0)
         {
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.PROJ_X_DECAY_COMPLETE,{"caller":this.APIInstance.instance}));
         }
      }
      
      private function stopSoundsAfterDeath() : void
      {
         if(m_attack.CancelSoundOnEnd)
         {
            this.stopSoundID(this.m_lastSFX);
            this.m_lastSFX = -1;
         }
         if(m_attack.CancelVoiceOnEnd)
         {
            this.stopSoundID(this.m_lastSFX);
            this.m_lastVFX = -1;
         }
      }
      
      private function stopSoundID(param1:int) : void
      {
         var _loc2_:SoundObject = null;
         if(param1 >= 0)
         {
            _loc2_ = STAGEDATA.SoundQueueRef.getSoundObject(param1);
            if(_loc2_.IsPlaying && _loc2_.IsPlaying)
            {
               _loc2_.stop();
            }
         }
      }
      
      public function playSpecificSound(param1:String) : int
      {
         return this.m_lastSFX = STAGEDATA.SoundQueueRef.playSoundEffect(param1,this.m_volume_sfx);
      }
      
      public function playSpecificVoice(param1:String) : int
      {
         return this.m_lastVFX = STAGEDATA.SoundQueueRef.playVoiceEffect(param1,this.m_volume_vfx);
      }
      
      public function playGlobalSound(param1:String) : int
      {
         return this.m_lastSFX = STAGEDATA.SoundQueueRef.playSoundEffect(param1,this.m_volume_sfx);
      }
      
      public function destroy(param1:SSF2Event = null) : void
      {
         if(!inState(PState.DEAD))
         {
            m_skipAttackCollisionTests = true;
            m_skipAttackProcessing = true;
            removeFromCamera();
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.PROJ_DESTROYED,{"caller":this.APIInstance.instance}));
            this.stopSoundsAfterDeath();
            setState(PState.DEAD);
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
            STAGEDATA.removeProjectile(this);
         }
      }
      
      public function endControl() : void
      {
         this.m_projectileStats.importData({
            "controlDirection":-1,
            "influenceXMovement":-1,
            "influenceYMovement":-2
         });
         this.m_x_influence = 0;
         this.m_y_influence = 0;
      }
      
      public function stick() : void
      {
         m_xSpeed = 0;
         m_ySpeed = 0;
         this.m_projectileStats.importData({
            "xdecay":0,
            "sticky":false
         });
         m_max_ySpeed = 0;
         m_gravity = 0;
      }
      
      private function checkInfluence() : void
      {
         var _loc1_:Object = this.m_owner is Character ? Character(this.m_owner).getControls() : null;
         if(this.m_owner is Character && (this.m_projectileStats.InfluenceXMovement > 0 || this.m_projectileStats.InfluenceYMovement > 0) && !(Boolean(Character(this.m_owner).IsCaught) || Boolean(Character(this.m_owner).StandBy)))
         {
            if(Boolean(_loc1_.UP) && Boolean(!_loc1_.DOWN) && Boolean(_loc1_.LEFT) && !_loc1_.RIGHT)
            {
               this.m_x_influence -= this.m_projectileStats.InfluenceXFactor > 0 && this.m_projectileStats.InfluenceXMovement > 0 ? this.m_projectileStats.InfluenceXFactor : 0;
               this.m_y_influence -= this.m_projectileStats.InfluenceYFactor > 0 && this.m_projectileStats.InfluenceYMovement > 0 ? this.m_projectileStats.InfluenceYFactor : 0;
            }
            else if(Boolean(_loc1_.UP && !_loc1_.DOWN) && Boolean(!_loc1_.LEFT) && Boolean(_loc1_.RIGHT))
            {
               this.m_x_influence += this.m_projectileStats.InfluenceXFactor > 0 && this.m_projectileStats.InfluenceXMovement > 0 ? this.m_projectileStats.InfluenceXFactor : 0;
               this.m_y_influence -= this.m_projectileStats.InfluenceYFactor > 0 && this.m_projectileStats.InfluenceYMovement > 0 ? this.m_projectileStats.InfluenceYFactor : 0;
            }
            else if(Boolean(!_loc1_.UP) && Boolean(_loc1_.DOWN) && Boolean(_loc1_.LEFT) && !_loc1_.RIGHT)
            {
               this.m_x_influence -= this.m_projectileStats.InfluenceXFactor > 0 && this.m_projectileStats.InfluenceXMovement > 0 ? this.m_projectileStats.InfluenceXFactor : 0;
               this.m_y_influence += this.m_projectileStats.InfluenceYFactor > 0 && this.m_projectileStats.InfluenceYMovement > 0 ? this.m_projectileStats.InfluenceYFactor : 0;
            }
            else if(Boolean(!_loc1_.UP && _loc1_.DOWN) && Boolean(!_loc1_.LEFT) && Boolean(_loc1_.RIGHT))
            {
               this.m_x_influence += this.m_projectileStats.InfluenceXFactor > 0 && this.m_projectileStats.InfluenceXMovement > 0 ? this.m_projectileStats.InfluenceXFactor : 0;
               this.m_y_influence += this.m_projectileStats.InfluenceYFactor > 0 && this.m_projectileStats.InfluenceYMovement > 0 ? this.m_projectileStats.InfluenceYFactor : 0;
            }
            else if(Boolean(_loc1_.UP && !_loc1_.DOWN) && Boolean(!_loc1_.LEFT) && !_loc1_.RIGHT)
            {
               this.m_y_influence -= this.m_projectileStats.InfluenceYFactor > 0 && this.m_projectileStats.InfluenceYMovement > 0 ? this.m_projectileStats.InfluenceYFactor : 0;
            }
            else if(Boolean(!_loc1_.UP && _loc1_.DOWN) && Boolean(!_loc1_.LEFT) && !_loc1_.RIGHT)
            {
               this.m_y_influence += this.m_projectileStats.InfluenceYFactor > 0 && this.m_projectileStats.InfluenceYMovement > 0 ? this.m_projectileStats.InfluenceYFactor : 0;
            }
            else if(Boolean(!_loc1_.UP && !_loc1_.DOWN) && Boolean(_loc1_.LEFT) && !_loc1_.RIGHT)
            {
               this.m_x_influence -= this.m_projectileStats.InfluenceXFactor > 0 && this.m_projectileStats.InfluenceXMovement > 0 ? this.m_projectileStats.InfluenceXFactor : 0;
            }
            else if(!_loc1_.UP && !_loc1_.DOWN && !_loc1_.LEFT && Boolean(_loc1_.RIGHT))
            {
               this.m_x_influence += this.m_projectileStats.InfluenceXFactor > 0 && this.m_projectileStats.InfluenceXMovement > 0 ? this.m_projectileStats.InfluenceXFactor : 0;
            }
            else
            {
               if(this.m_projectileStats.InfluenceXFactor > 0)
               {
                  if(this.m_x_influence > 0 && this.m_x_influence - this.m_projectileStats.InfluenceXFactor < 0)
                  {
                     this.m_x_influence = 0;
                  }
                  else if(this.m_x_influence < 0 && this.m_x_influence + this.m_projectileStats.InfluenceXFactor > 0)
                  {
                     this.m_x_influence = 0;
                  }
                  else if(this.m_x_influence != 0)
                  {
                     this.m_x_influence -= this.m_projectileStats.InfluenceXFactor;
                  }
               }
               if(this.m_projectileStats.InfluenceYFactor > 0)
               {
                  if(this.m_y_influence > 0 && this.m_y_influence - this.m_projectileStats.InfluenceYFactor < 0)
                  {
                     this.m_y_influence = 0;
                  }
                  else if(this.m_y_influence < 0 && this.m_y_influence + this.m_projectileStats.InfluenceYFactor > 0)
                  {
                     this.m_y_influence = 0;
                  }
                  else if(this.m_y_influence != 0)
                  {
                     this.m_y_influence -= this.m_projectileStats.InfluenceYFactor;
                  }
               }
            }
            if(this.m_projectileStats.InfluenceXMovement > 0)
            {
               if(this.m_x_influence > this.m_projectileStats.InfluenceXMovement)
               {
                  this.m_x_influence = this.m_projectileStats.InfluenceXMovement;
               }
               if(this.m_x_influence < -this.m_projectileStats.InfluenceXMovement)
               {
                  this.m_x_influence = -this.m_projectileStats.InfluenceXMovement;
               }
            }
            if(this.m_projectileStats.InfluenceYMovement > 0)
            {
               if(this.m_y_influence > this.m_projectileStats.InfluenceYMovement)
               {
                  this.m_y_influence = this.m_projectileStats.InfluenceYMovement;
               }
               if(this.m_y_influence < -this.m_projectileStats.InfluenceYMovement)
               {
                  this.m_y_influence = -this.m_projectileStats.InfluenceYMovement;
               }
            }
         }
      }
      
      private function checkControls() : Boolean
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Object = this.m_owner is Character ? Character(this.m_owner).getControls() : null;
         if(this.m_owner is Character && this.m_projectileStats.ControlDirection >= 0 && !(Boolean(Character(this.m_owner).IsCaught) || Boolean(Character(this.m_owner).StandBy)))
         {
            if(this.m_projectileStats.CalcAngle)
            {
               _loc1_ = Number(this.m_angle);
               _loc2_ = Number(this.m_angle);
               if(Boolean(_loc4_.UP) && Boolean(!_loc4_.DOWN) && Boolean(_loc4_.LEFT) && !_loc4_.RIGHT)
               {
                  _loc1_ = 135;
               }
               else if(Boolean(_loc4_.UP && !_loc4_.DOWN) && Boolean(!_loc4_.LEFT) && Boolean(_loc4_.RIGHT))
               {
                  _loc1_ = 45;
               }
               else if(Boolean(!_loc4_.UP) && Boolean(_loc4_.DOWN) && Boolean(_loc4_.LEFT) && !_loc4_.RIGHT)
               {
                  _loc1_ = 225;
               }
               else if(Boolean(!_loc4_.UP && _loc4_.DOWN) && Boolean(!_loc4_.LEFT) && Boolean(_loc4_.RIGHT))
               {
                  _loc1_ = 315;
               }
               else if(Boolean(_loc4_.UP && !_loc4_.DOWN) && Boolean(!_loc4_.LEFT) && !_loc4_.RIGHT)
               {
                  _loc1_ = 90;
               }
               else if(Boolean(!_loc4_.UP && _loc4_.DOWN) && Boolean(!_loc4_.LEFT) && !_loc4_.RIGHT)
               {
                  _loc1_ = 270;
               }
               else if(Boolean(!_loc4_.UP && !_loc4_.DOWN) && Boolean(_loc4_.LEFT) && !_loc4_.RIGHT)
               {
                  _loc1_ = 180;
               }
               else if(!_loc4_.UP && !_loc4_.DOWN && !_loc4_.LEFT && Boolean(_loc4_.RIGHT))
               {
                  _loc1_ = 0;
               }
               _loc3_ = Utils.calculateDifferenceBetweenAngles(_loc1_,_loc2_) / 6;
               this.m_angle -= _loc3_;
               this.m_angle = Utils.forceBase360(this.m_angle);
               this.angleControl(this.m_xSpeedInit,this.m_angle);
            }
            else
            {
               if(Boolean(_loc4_.UP) && Boolean(!_loc4_.DOWN) && Boolean(_loc4_.LEFT) && !_loc4_.RIGHT)
               {
                  this.m_angle = 135;
               }
               else if(Boolean(_loc4_.UP && !_loc4_.DOWN) && Boolean(!_loc4_.LEFT) && Boolean(_loc4_.RIGHT))
               {
                  this.m_angle = 45;
               }
               else if(Boolean(!_loc4_.UP) && Boolean(_loc4_.DOWN) && Boolean(_loc4_.LEFT) && !_loc4_.RIGHT)
               {
                  this.m_angle = 225;
               }
               else if(Boolean(!_loc4_.UP && _loc4_.DOWN) && Boolean(!_loc4_.LEFT) && Boolean(_loc4_.RIGHT))
               {
                  this.m_angle = 315;
               }
               else if(Boolean(_loc4_.UP && !_loc4_.DOWN) && Boolean(!_loc4_.LEFT) && !_loc4_.RIGHT)
               {
                  this.m_angle = 90;
               }
               else if(Boolean(!_loc4_.UP && _loc4_.DOWN) && Boolean(!_loc4_.LEFT) && !_loc4_.RIGHT)
               {
                  this.m_angle = 270;
               }
               else if(Boolean(!_loc4_.UP && !_loc4_.DOWN) && Boolean(_loc4_.LEFT) && !_loc4_.RIGHT)
               {
                  this.m_angle = 180;
               }
               else if(!_loc4_.UP && !_loc4_.DOWN && !_loc4_.LEFT && Boolean(_loc4_.RIGHT))
               {
                  this.m_angle = 0;
               }
               this.angleControl(this.m_xSpeedInit,this.m_angle);
            }
            return true;
         }
         return false;
      }
      
      public function syncPosition() : void
      {
         var _loc1_:Point = null;
         if(Boolean(this.m_projectileStats.LockTrajectory) && this.m_owner is Character && this.m_owner.HasPLockBox)
         {
            _loc1_ = new Point(HitBoxSprite(this.m_owner.CurrentAnimation.getHitBoxes(this.m_owner.CurrentFrameNum,HitBoxSprite.PLOCK)[0]).centerx * this.m_owner.MC.scaleX,HitBoxSprite(this.m_owner.CurrentAnimation.getHitBoxes(this.m_owner.CurrentFrameNum,HitBoxSprite.PLOCK)[0]).centery * this.m_owner.MC.scaleY);
            m_sprite.x = this.m_owner.getX() + _loc1_.x;
            m_sprite.y = this.m_owner.getY() + _loc1_.y;
            m_attack.XLoc = m_sprite.x;
            m_attack.YLoc = m_sprite.y;
         }
         else if(Boolean(this.m_projectileStats.LockTrajectory) && this.m_owner is Enemy)
         {
            m_sprite.x = this.m_owner.X;
            m_sprite.y = this.m_owner.Y;
            m_attack.XLoc = m_sprite.x;
            m_attack.YLoc = m_sprite.y;
         }
      }
      
      private function getDistanceFrom(param1:Number, param2:Number) : Number
      {
         return Math.sqrt(Math.pow(param1 - m_sprite.x,2) + Math.pow(param2 - m_sprite.y,2));
      }
      
      private function findHomingTarget() : void
      {
         var _loc1_:int = 0;
         var _loc3_:Vector.<HitBoxCollisionResult> = null;
         var _loc4_:Character = null;
         var _loc5_:Item = null;
         var _loc6_:TargetTestTarget = null;
         var _loc2_:Number = 99999999;
         m_attack.HomingTarget = null;
         _loc1_ = 0;
         while(_loc1_ < STAGEDATA.ItemsRef.MAXITEMS && m_attack.HomingTarget == null)
         {
            if(HasHoming)
            {
               _loc5_ = STAGEDATA.ItemsRef.ItemsInUse[_loc1_];
               if(_loc5_ != null && _loc5_.MC.hitBox != null && _loc5_.IsSmashBall && (_loc3_ = InteractiveSprite.hitTest(this,_loc5_,HitBoxSprite.HOMING,HitBoxSprite.HIT)).length > 0)
               {
                  m_attack.HomingTarget = _loc5_;
                  m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.HOMING_TARGET,{
                     "caller":this.APIInstance.instance,
                     "target":_loc4_.APIInstance.instance,
                     "type":"Item"
                  }));
               }
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < STAGEDATA.Characters.length)
         {
            if(HasHoming)
            {
               _loc4_ = STAGEDATA.Characters[_loc1_];
               if(!_loc4_.StandBy && !_loc4_.Revival && !_loc4_.AirDodge && _loc4_.HasHitBox && !_loc4_.Dead && !_loc4_.Invincible && (m_attack.HomingTarget == null || this.getDistanceFrom(m_attack.HomingTarget.X,m_attack.HomingTarget.Y) < _loc2_) && (_loc3_ = InteractiveSprite.hitTest(this,_loc4_,HitBoxSprite.HOMING,HitBoxSprite.HIT)).length > 0 && (!this.m_wasReversed || Boolean(this.m_wasReversed) && !(m_attack.ReverseID == _loc4_.ID || m_team_id > 0 && _loc4_.Team == m_attack.ReverseTeam && !STAGEDATA.TeamDamage)) && !(m_team_id > 0 && _loc4_.Team == m_team_id || m_player_id === _loc4_.ID))
               {
                  m_attack.HomingTarget = _loc4_;
                  _loc2_ = Number(this.getDistanceFrom(m_attack.HomingTarget.X,m_attack.HomingTarget.Y));
                  m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.HOMING_TARGET,{
                     "caller":this.APIInstance.instance,
                     "target":_loc4_.APIInstance.instance,
                     "type":"Character"
                  }));
               }
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < STAGEDATA.Targets.length)
         {
            if(HasHoming)
            {
               _loc6_ = STAGEDATA.Targets[_loc1_];
               if(_loc6_.inState(TState.IDLE) && (m_attack.HomingTarget == null || this.getDistanceFrom(m_attack.HomingTarget.X,m_attack.HomingTarget.Y) < _loc2_) && (_loc3_ = InteractiveSprite.hitTest(this,_loc6_,HitBoxSprite.HOMING,HitBoxSprite.HIT)).length > 0)
               {
                  m_attack.HomingTarget = _loc6_;
                  _loc2_ = Number(this.getDistanceFrom(m_attack.HomingTarget.X,m_attack.HomingTarget.Y));
                  m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.HOMING_TARGET,{
                     "caller":this.APIInstance.instance,
                     "target":_loc6_.APIInstance.instance,
                     "type":"Target"
                  }));
               }
            }
            _loc1_++;
         }
      }
      
      private function projectileMove() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Boolean = false;
         var _loc4_:Number = NaN;
         var _loc5_:MovieClip = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         if(this.m_projectileStats.Suspend)
         {
            return;
         }
         if(!inState(PState.DEAD) && !isHitStunOrParalysis())
         {
            if(this.m_projectileStats.HomingSpeed >= 0 && !m_attack.HomingTarget)
            {
               this.findHomingTarget();
            }
            if(m_attack.HomingTarget)
            {
               _loc1_ = Number(Utils.getAngleBetween(new Point(m_sprite.x,m_sprite.y),new Point(m_attack.HomingTarget.X,m_attack.HomingTarget.Y)));
               _loc2_ = Number(Utils.calculateDifferenceBetweenAngles(this.m_homingAngle,_loc1_));
               this.m_homingAngle += Utils.forceBase360(_loc2_ / this.m_projectileStats.HomingEase);
               m_xSpeed = Utils.calculateXSpeed(this.m_projectileStats.HomingSpeed,this.m_homingAngle);
               m_ySpeed = -Utils.calculateYSpeed(this.m_projectileStats.HomingSpeed,this.m_homingAngle);
               if(this.m_projectileStats.HomingSpeed != 0 && this.m_projectileStats.XDecay != 0)
               {
                  _loc3_ = this.m_projectileStats.HomingSpeed > 0;
                  this.m_projectileStats.HomingSpeed -= this.m_projectileStats.XDecay;
                  if(_loc3_ && this.m_projectileStats.HomingSpeed < 0 || !_loc3_ && this.m_projectileStats.HomingSpeed > 0)
                  {
                     this.m_projectileStats.HomingSpeed = 0;
                     this.checkIfDead();
                  }
               }
            }
            applyGroundInfluence();
            this.m_rocketReadyTimer.tick();
            this.checkInfluence();
            if(this.checkControls())
            {
               this.m_attemptToMove(m_xSpeed + this.m_x_influence,0);
               this.m_attemptToMove(0,m_ySpeed + this.m_y_influence);
            }
            else if(this.m_projectileStats.LockTrajectory)
            {
               this.syncPosition();
            }
            else
            {
               if(!m_collision.ground && !this.m_projectileStats.Boomerang && m_gravity > 0)
               {
                  if(!this.m_projectileStats.Boomerang && m_ySpeed < m_max_ySpeed)
                  {
                     m_ySpeed += m_gravity;
                  }
               }
               else if(this.m_projectileStats.Bounce <= 0 && m_ySpeed > 0 && m_collision.ground && !this.m_projectileStats.Boomerang)
               {
                  m_ySpeed = 0;
               }
               else if(this.m_projectileStats.Boomerang)
               {
                  if(Boolean(this.m_hasSwitched) && (this.m_xSpeedInit < 0 && m_sprite.x <= this.m_owner.MC.x || this.m_xSpeedInit > 0 && m_sprite.x >= this.m_owner.MC.x))
                  {
                     if(m_sprite.y <= this.m_owner.MC.y && m_ySpeed < m_max_ySpeed)
                     {
                        m_ySpeed += m_gravity;
                     }
                     else if(m_sprite.y > this.m_owner.MC.y && m_ySpeed > -m_max_ySpeed)
                     {
                        m_ySpeed -= m_gravity;
                     }
                  }
                  else if(!this.m_hasSwitched)
                  {
                     if(this.m_xSpeedInit < 0 && m_xSpeed >= 0 || this.m_xSpeedInit > 0 && m_xSpeed <= 0)
                     {
                        this.m_hasSwitched = true;
                        this.m_projectileStats.importData({"ghost":true});
                     }
                     else if(Math.abs(m_ySpeed) > 1)
                     {
                        if(m_ySpeed > 0)
                        {
                           m_ySpeed -= m_gravity;
                        }
                        else if(m_ySpeed < 0)
                        {
                           m_ySpeed += m_gravity;
                        }
                     }
                  }
               }
               _loc4_ = 0;
               if(m_sprite.rotation > 20 && m_collision.ground)
               {
                  _loc4_ = 8;
               }
               else if(m_sprite.rotation < -20 && m_collision.ground)
               {
                  _loc4_ = -8;
               }
               if(_loc4_ < 0)
               {
               }
               if(!(m_attack.IsAttacking && !this.m_projectileStats.CanFallOff && !m_attack.CanFallOff && m_collision.ground && !testGroundWithCoord(m_xSpeed > 0 ? m_sprite.x + m_xSpeed + 10 : m_sprite.x + m_xSpeed - 10,m_sprite.y + 9)))
               {
                  if(_loc4_ < 0)
                  {
                     this.m_attemptToMove(0,_loc4_);
                     this.m_attemptToMove(m_xSpeed + this.m_x_influence,0);
                  }
                  else if(_loc4_ > 0)
                  {
                     this.m_attemptToMove(m_xSpeed + this.m_x_influence,0);
                     this.m_attemptToMove(0,_loc4_);
                     this.m_attemptToMove(0,_loc4_);
                  }
                  else
                  {
                     this.m_attemptToMove(m_xSpeed + this.m_x_influence,_loc4_);
                  }
               }
               if(m_collision.ground)
               {
                  this.attachToGround();
               }
               if(this.m_xSpeedInit > 0)
               {
                  m_xSpeed -= m_xSpeed > -this.m_xSpeedInit ? this.m_projectileStats.XDecay : 0;
                  if(!this.m_projectileStats.Boomerang && m_xSpeed < 0 && this.m_projectileStats.XDecay != 0)
                  {
                     this.m_projectileStats.importData({"xdecay":0});
                     m_xSpeed = 0;
                  }
               }
               else
               {
                  m_xSpeed += m_xSpeed < -this.m_xSpeedInit ? this.m_projectileStats.XDecay : 0;
                  if(!this.m_projectileStats.Boomerang && m_xSpeed > 0 && this.m_projectileStats.XDecay != 0)
                  {
                     this.m_projectileStats.importData({"xdecay":0});
                     m_xSpeed = 0;
                  }
               }
               this.m_attemptToMove(0,m_ySpeed + this.m_y_influence);
               if(m_collision.ground && this.m_projectileStats.Bounce > 0 && m_ySpeed >= 0)
               {
                  ++this.m_bounce_total;
                  if(!(this.m_projectileStats.BounceLimit > 0 && this.m_bounce_total > this.m_projectileStats.BounceLimit))
                  {
                     m_ySpeed = -this.m_projectileStats.Bounce;
                     this.m_projectileStats.Bounce *= this.m_projectileStats.BounceDecay;
                     while(this.m_projectileStats.BounceMaxHeight > 0 && this.getBounceHeight(m_ySpeed) > this.m_projectileStats.BounceMaxHeight)
                     {
                        ++m_ySpeed;
                     }
                     unnattachFromGround();
                     m_collision.ground = false;
                  }
               }
               if(this.m_projectileStats.FollowUser)
               {
                  m_sprite.x = m_facingForward ? this.m_owner.MC.x + this.m_projectileStats.XOffset * m_sizeRatio : this.m_owner.MC.x - this.m_projectileStats.XOffset * m_sizeRatio;
                  m_sprite.y = this.m_owner.MC.y + this.m_projectileStats.YOffset * m_sizeRatio;
               }
            }
            if(!inState(PState.DEAD))
            {
               m_attack.XLoc = m_sprite.x;
               m_attack.YLoc = m_sprite.y;
               m_attack.IsForward = this.m_projectileStats.ControlDirection >= 0 ? m_xSpeed > 0 : m_facingForward;
            }
         }
         if(!inState(PState.DEAD) && this.m_projectileStats.TrailEffect != null)
         {
            ++this.m_trailEffectTimer;
            if(this.m_trailEffectTimer >= this.m_projectileStats.TrailEffectInterval)
            {
               this.m_trailEffectTimer = 0;
               _loc5_ = STAGEDATA.attachEffectOverlay(this.m_projectileStats.TrailEffect);
               _loc5_.x = OverlayX;
               _loc5_.y = OverlayY;
               if(!m_facingForward)
               {
                  _loc5_.scaleX *= -1;
               }
               if(this.m_projectileStats.TrailEffectRotate)
               {
                  if(Boolean(this.m_projectileStats.ControlDirection) && Boolean(this.m_projectileStats.CalcAngle))
                  {
                     _loc6_ = Number(this.m_angle);
                     _loc6_ = Number(Utils.forceBase360(m_facingForward ? -_loc6_ : -_loc6_ + 180));
                     _loc5_.rotation = _loc6_;
                  }
                  else
                  {
                     _loc7_ = Number(Utils.getAngleBetween(new Point(0,0),new Point(m_xSpeed,m_ySpeed)));
                     _loc7_ = Number(Utils.forceBase360(m_facingForward ? -_loc7_ : -_loc7_ + 180));
                     _loc5_.rotation = _loc7_;
                  }
               }
            }
         }
      }
      
      private function getBounceHeight(param1:int) : Number
      {
         var _loc2_:Number = 0;
         while(param1 < 0 && m_gravity > 0)
         {
            _loc2_ -= param1;
            param1 += m_gravity;
         }
         return _loc2_;
      }
      
      override public function reverse(param1:int, param2:int, param3:Boolean) : Boolean
      {
         if(this.m_reverseTimer <= 0 && Boolean(this.m_projectileStats.CanBeReversed) && m_attack.ReverseID !== param1 && !this.m_projectileStats.Suspend && !(!this.m_wasReversed && param1 === m_player_id) && !(param2 == m_team_id && m_team_id > 0 && !STAGEDATA.TeamDamage))
         {
            if(!m_facingForward)
            {
               m_facingForward = true;
               this.m_faceRight();
               m_attack.IsForward = true;
            }
            else
            {
               m_facingForward = false;
               this.m_faceLeft();
               m_attack.IsForward = false;
            }
            this.m_reverseTimer = 2;
            m_team_id = param2;
            if(Boolean(this.m_owner) && this.m_owner.ID === param1)
            {
               m_attack.ReverseID = -1;
               m_attack.ReverseTeam = -1;
               this.m_wasReversed = false;
               m_attackData.Owner = this.m_owner;
               m_player_id = this.m_owner.ID;
            }
            else
            {
               m_attack.ReverseID = param1;
               m_attack.ReverseTeam = param2;
               this.m_wasReversed = true;
               m_attack.AttackID = Utils.getUID();
               m_attackData.Owner = this.m_owner;
               m_player_id = param1;
            }
            m_xSpeed *= -1;
            this.m_xSpeedInit *= -1;
            if(this.m_projectileStats.ControlInitDirection < 0)
            {
               this.m_xSpeedInit *= -1;
            }
            if(this.m_projectileStats.TimeMax > 0 && this.m_time < 0)
            {
               this.m_time = 0;
            }
            if(this.m_projectileStats.Boomerang)
            {
               this.m_hasSwitched = true;
            }
            if(m_attack.HomingTarget)
            {
               this.m_homingAngle = Utils.getAngleBetween(new Point(),new Point(m_xSpeed,m_ySpeed));
               this.findHomingTarget();
            }
            return true;
         }
         return false;
      }
      
      private function checkReverse() : void
      {
         if(!inState(PState.DEAD))
         {
            if(this.m_reverseTimer > 0)
            {
               --this.m_reverseTimer;
            }
         }
      }
      
      private function checkIfLinked() : void
      {
         if(this.m_projectileStats.LinkAttackID)
         {
            this.m_owner.AttackStateData.AttackID = m_attack.AttackID;
         }
      }
      
      override public function reactionShield(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         if(Boolean(this.m_projectileStats.Suspend) || !this.m_wasReversed && param1 === this.m_owner || STAGEDATA.TeamDamage && param1.Team == m_team_id && m_team_id > 0)
         {
            return false;
         }
         var _loc3_:Character = param1 as Character ? Character(param1) : null;
         var _loc4_:AttackDamage = m_attackData.getAttackBoxData(m_attackCache.Frame,param2.FirstHitBox.Name).syncState(m_attackCache);
         if(_loc3_)
         {
            if(_loc4_.BypassShield && param1.takeDamage(_loc4_,param2.OverlapHitBox))
            {
               this.handleHit(param1,_loc4_,param2);
               return true;
            }
            if(_loc3_.takeShieldDamage(m_attackData.getAttackBoxData(m_attackCache.Frame,param2.FirstHitBox.Name).syncState(m_attackCache),param2.OverlapHitBox))
            {
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_CONNECT_SHIELD,{
                  "caller":this.APIInstance.instance,
                  "receiver":param1.APIInstance.instance,
                  "attackBoxData":_loc4_.exportAttackDamageData()
               }));
               startActionShot(Utils.calculateSelfHitStun(_loc4_.SelfHitStun,Utils.calculateChargeDamage(_loc4_)));
               m_eventManager.dispatchEvent(new SSF2Event(Character(param1).PerfectShield ? SSF2Event.ATTACK_HIT_POWER_SHIELD : SSF2Event.ATTACK_HIT_SHIELD,{
                  "caller":this.APIInstance.instance,
                  "receiver":param1.APIInstance.instance,
                  "attackBoxData":_loc4_.exportAttackDamageData()
               }));
               m_attack.RefreshRateReady = true;
               if(_loc3_.PerfectShield && _loc4_.Priority >= -1 && _loc4_.Priority < 7)
               {
                  if(this.m_projectileStats.CanBeReversed)
                  {
                     this.reverse(param1.ID,param1.Team,param1.FacingForward);
                  }
               }
               return true;
            }
            return false;
         }
         return false;
      }
      
      override public function reactionShieldProjectile(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         if(this.m_projectileStats.Suspend)
         {
            return false;
         }
         var _loc3_:AttackDamage = m_attackData.getAttackBoxData(m_attackCache.Frame,param2.FirstHitBox.Name).syncState(m_attackCache);
         if(_loc3_.Priority < 7 && _loc3_.Priority > -1 && param1.validateHit(_loc3_,true))
         {
            attachEffect("effect_cancel",Boolean(param2) && Boolean(param2.OverlapHitBox) ? {
               "x":param2.OverlapHitBox.centerx,
               "y":param2.OverlapHitBox.centery,
               "absolute":true
            } : null);
            this.destroy();
            if(param1 as Character)
            {
               Character(param1).pushBackSlightly(m_sprite.x < param1.X);
            }
            return true;
         }
         return false;
      }
      
      override public function reactionReverse(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         if(Boolean(param1 as Projectile) || Boolean(param1 as Item))
         {
            if(param1.reverse(m_player_id,m_team_id,m_facingForward))
            {
               param1.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.REVERSE,{
                  "caller":param1.APIInstance.instance,
                  "opponent":this.APIInstance.instance,
                  "attackBoxData":null
               }));
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.REVERSE_HIT,{
                  "caller":this.APIInstance.instance,
                  "opponent":param1.APIInstance.instance,
                  "attackBoxData":null
               }));
            }
         }
         return false;
      }
      
      override public function reactionAttackReverse(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         var _loc3_:AttackDamage = m_attackData.getAttackBoxData(m_attackCache.Frame,param2.FirstHitBox.Name).syncState(m_attackCache);
         if(Boolean(_loc3_.ReverseProjectile) && Boolean(param1 as Projectile) && param1.reverse(m_player_id,m_team_id,m_facingForward))
         {
            param1.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.REVERSE,{
               "caller":param1.APIInstance.instance,
               "opponent":this.APIInstance.instance,
               "attackBoxData":null
            }));
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.REVERSE_HIT,{
               "caller":this.APIInstance.instance,
               "opponent":param1.APIInstance.instance,
               "attackBoxData":null
            }));
         }
         else if(Boolean(_loc3_.ReverseItem) && Boolean(param1 as Item) && param1.reverse(m_player_id,m_team_id,m_facingForward))
         {
            param1.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.REVERSE,{
               "caller":param1.APIInstance.instance,
               "opponent":this.APIInstance.instance,
               "attackBoxData":null
            }));
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.REVERSE_HIT,{
               "caller":this.APIInstance.instance,
               "opponent":param1.APIInstance.instance,
               "attackBoxData":null
            }));
         }
         return false;
      }
      
      override public function reactionAbsorb(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         if(this.m_projectileStats.Suspend)
         {
            return false;
         }
         var _loc3_:AttackDamage = m_attackData.getAttackBoxData(m_attackCache.Frame,param2.FirstHitBox.Name).syncState(m_attackCache);
         if(Boolean(this.m_projectileStats.CanBeAbsorbed) && param1.validateHit(_loc3_,true))
         {
            param1.stackAttackID(_loc3_.AttackID);
            param1.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.CHAR_ABSORB,{
               "caller":param1,
               "projectile":this,
               "attackBoxData":_loc3_.exportAttackDamageData()
            }));
            return true;
         }
         return false;
      }
      
      override public function reactionClank(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         if(Boolean(this.m_projectileStats.Suspend) || param1.isIntangible())
         {
            return false;
         }
         if(inState(PState.DEAD))
         {
            return false;
         }
         var _loc3_:AttackDamage = m_attackData.getAttackBoxData(m_attackCache.Frame,param2.FirstHitBox.Name).syncState(m_attackCache);
         var _loc4_:AttackDamage = param1.AttackDataObj.getAttackBoxData(param1.AttackStateData.Frame,param2.SecondHitBox.Name).syncState(param1.AttackCache);
         var _loc5_:Number = Number(Utils.calculateChargeDamage(_loc3_));
         var _loc6_:Number = Number(Utils.calculateChargeDamage(_loc4_));
         var _loc7_:Boolean = _loc3_.Damage === 0 && _loc3_.ReverseProjectile && param1 is Projectile || _loc3_.Damage === 0 && _loc3_.ReverseItem && param1 is Item || _loc3_.Damage === 0 && _loc3_.ReverseCharacter && param1 is Character || _loc4_.Damage === 0 && _loc4_.ReverseProjectile;
         var _loc8_:Boolean = _loc3_.Damage === 0 && _loc3_.HitStunProjectile && param1 is Projectile || _loc4_.Damage === 0 && Boolean(_loc4_.HitStunProjectile);
         if(!_loc3_.HasEffect || !_loc4_.HasEffect || isInvincible() || param1.isInvincible() || _loc3_.IsThrow || _loc4_.IsThrow || !(param1 is Projectile) && !param1.validateHit(_loc3_) || _loc7_ || _loc8_)
         {
            return false;
         }
         if(!this.validateHitClank(_loc4_))
         {
            return false;
         }
         if(param1 is Projectile && !Projectile(param1).validateHitClank(_loc3_))
         {
            return false;
         }
         if(Utils.fastAbs(_loc5_ - _loc6_) < 8 && _loc3_.Priority != -1 && _loc4_.Priority != -1)
         {
            if(m_attack.HasClanked || param1.AttackStateData.HasClanked || param1 is Item && !Item(param1).PickedUp)
            {
               return false;
            }
            if(m_hurtInterrupt != null && Boolean(m_hurtInterrupt({
               "target":(param1.APIInstance ? param1.APIInstance.instance : null),
               "attackBoxData":null,
               "collisionRect":param2.OverlapHitBox.BoundingBox
            })))
            {
               return false;
            }
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_COLLIDE,{
               "caller":this.APIInstance.instance,
               "receiver":param1.APIInstance.instance,
               "callerAttackBoxData":_loc3_.exportAttackDamageData(),
               "receiverAttackBoxData":_loc4_.exportAttackDamageData()
            }));
            param1.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_COLLIDE,{
               "caller":param1.APIInstance.instance,
               "receiver":this.APIInstance.instance,
               "callerAttackBoxData":_loc4_.exportAttackDamageData(),
               "receiverAttackBoxData":_loc3_.exportAttackDamageData()
            }));
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_CLANK,{
               "caller":this.APIInstance.instance,
               "receiver":param1.APIInstance.instance,
               "callerAttackBoxData":_loc3_.exportAttackDamageData(),
               "receiverAttackBoxData":_loc4_.exportAttackDamageData()
            }));
            param1.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_CLANK,{
               "caller":param1.APIInstance.instance,
               "receiver":this.APIInstance.instance,
               "callerAttackBoxData":_loc4_.exportAttackDamageData(),
               "receiverAttackBoxData":_loc3_.exportAttackDamageData()
            }));
            STAGEDATA.playSpecificSound("reflected");
            attachEffect("effect_cancel",Boolean(param2) && Boolean(param2.OverlapHitBox) ? {
               "x":param2.OverlapHitBox.centerx,
               "y":param2.OverlapHitBox.centery,
               "absolute":true
            } : null);
            CAM.shake(15);
            this.clang(_loc4_,param2);
            if(!(param1 is Character))
            {
               param1.clang(_loc3_,param2);
            }
            else
            {
               param1.startActionShot(Utils.calculateSelfHitStun(_loc4_.SelfHitStun,Utils.calculateChargeDamage(_loc4_)));
               Character(param1).SmashDISelf = true;
               param1.AttackStateData.HasClanked = true;
            }
            return true;
         }
         if(_loc5_ - _loc6_ >= 8 && _loc3_.Priority != -1 && _loc4_.Priority != -1)
         {
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_COLLIDE,{
               "caller":this.APIInstance.instance,
               "receiver":param1.APIInstance.instance,
               "callerAttackBoxData":_loc3_.exportAttackDamageData(),
               "receiverAttackBoxData":_loc4_.exportAttackDamageData()
            }));
            param1.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_COLLIDE,{
               "caller":param1.APIInstance.instance,
               "receiver":this.APIInstance.instance,
               "callerAttackBoxData":_loc4_.exportAttackDamageData(),
               "receiverAttackBoxData":_loc3_.exportAttackDamageData()
            }));
            if(!(param1 is Character))
            {
               param1.clang(_loc3_,param2);
               param1.attachEffect("effect_cancel",Boolean(param2) && Boolean(param2.OverlapHitBox) ? {
                  "x":param2.OverlapHitBox.centerx,
                  "y":param2.OverlapHitBox.centery,
                  "absolute":true
               } : null);
            }
            return true;
         }
         if(_loc5_ - _loc6_ <= -8 && _loc3_.Priority != -1 && _loc4_.Priority != -1)
         {
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_COLLIDE,{
               "caller":this.APIInstance.instance,
               "receiver":param1.APIInstance.instance,
               "callerAttackBoxData":_loc3_.exportAttackDamageData(),
               "receiverAttackBoxData":_loc4_.exportAttackDamageData()
            }));
            param1.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_COLLIDE,{
               "caller":param1.APIInstance.instance,
               "receiver":this.APIInstance.instance,
               "callerAttackBoxData":_loc4_.exportAttackDamageData(),
               "receiverAttackBoxData":_loc3_.exportAttackDamageData()
            }));
            this.clang(_loc4_,param2);
            attachEffect("effect_cancel",Boolean(param2) && Boolean(param2.OverlapHitBox) ? {
               "x":param2.OverlapHitBox.centerx,
               "y":param2.OverlapHitBox.centery,
               "absolute":true
            } : null);
            return true;
         }
         return false;
      }
      
      override public function clang(param1:AttackDamage, param2:HitBoxCollisionResult) : void
      {
         initDelayPlayback(true);
         m_skipAttackCollisionTests = true;
         this.destroy();
      }
      
      override public function handleHit(param1:InteractiveSprite, param2:AttackDamage, param3:HitBoxCollisionResult) : void
      {
         if(param1.isIntangible())
         {
            return;
         }
         m_attack.RefreshRateReady = true;
         m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_HIT,{
            "caller":this.APIInstance.instance,
            "receiver":param1.APIInstance.instance,
            "attackBoxData":param2.exportAttackDamageData()
         }));
         if(param1.Invincible && !(param1 as Character && Character(param1).Revival))
         {
            param1.attachEffect("effect_cancel",Boolean(param3) && Boolean(param3.OverlapHitBox) ? {
               "x":param3.OverlapHitBox.centerx,
               "y":param3.OverlapHitBox.centery,
               "absolute":true
            } : null);
         }
         else
         {
            if(Boolean(this.m_projectileStats.Stale) && this.m_owner is Character && param2.Frame != null && !staleIDArrayContains(param2.ID))
            {
               Character(this.m_owner).queueMove(param2.Frame);
               stackStaleID(param2.ID);
            }
            if(this.m_owner is Character)
            {
               Character(this.m_owner).increaseComboCount(param2,param1.UID);
            }
            startActionShot(Utils.calculateSelfHitStun(param2.SelfHitStun,Utils.calculateChargeDamage(param2)));
         }
         if(Boolean(param2.ReverseCharacter) && Boolean(param1 as Character) || Boolean(param2.ReverseProjectile) && Boolean(param1 as Projectile) || Boolean(param2.ReverseItem) && Boolean(param1 as Item))
         {
            if(param1.reverse(param2.PlayerID,param2.TeamID,param2.IsForward))
            {
               param1.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.REVERSE,{
                  "caller":param1.APIInstance.instance,
                  "opponent":this.APIInstance.instance,
                  "attackBoxData":param2.exportAttackDamageData()
               }));
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.REVERSE_HIT,{
                  "caller":this.APIInstance.instance,
                  "opponent":param1.APIInstance.instance,
                  "attackBoxData":param2.exportAttackDamageData()
               }));
            }
         }
      }
      
      override public function forceAttack(param1:String, param2:* = null, param3:Boolean = false) : Boolean
      {
         if(param1 === m_attack.Frame)
         {
            if(Boolean(Main.DEBUG) && Boolean(MenuController.debugConsole) && Boolean(MenuController.debugConsole.Alerts))
            {
               MenuController.debugConsole.alert("[Warning] forceAttack(\"" + param1 + "\") was called when the SSF2Projectile object was already using that attack. Call has been aborted");
            }
            return false;
         }
         if(param1 != null)
         {
            if(param1 !== m_attack.Frame)
            {
               flushTimers();
               removeAllTempEvents();
            }
            this.InitAttack(param1);
            if(param2 !== null)
            {
               stancePlayFrame(param2);
            }
            return true;
         }
         return false;
      }
      
      public function InitAttack(param1:String) : void
      {
         var _loc2_:AttackObject = m_attackData.getAttack(param1);
         if(!_loc2_)
         {
            m_attack.Frame = null;
            if(param1)
            {
               playFrame(param1);
            }
            return;
         }
         m_attack.IsAttacking = true;
         m_attack.IsAirAttack = !m_collision.ground;
         m_attack.IsForward = m_facingForward;
         m_attack.ExecTime = 0;
         m_attack.HasClanked = false;
         if(m_attack.ResetMovement)
         {
            m_xSpeed = 0;
            m_ySpeed = 0;
         }
         m_attack.RefreshRate = _loc2_.RefreshRate;
         m_attack.SuperArmor = _loc2_.SuperArmor;
         m_attack.HeavyArmor = _loc2_.HeavyArmor;
         m_attack.LaunchResistance = _loc2_.LaunchResistance;
         m_attack.Rotate = _loc2_.Rotate;
         m_attack.Frame = param1;
         m_attack.AttackID = Utils.getUID();
         m_attack.ID = Utils.getUID();
         playFrame(param1);
      }
      
      override public function cancelAttack(param1:AttackDamage, param2:HitBoxCollisionResult) : void
      {
         m_skipAttackCollisionTests = true;
         if(param1.HitStunProjectile !== 0)
         {
            startActionShot(Utils.calculateHitStun(param1.HitStunProjectile,Utils.calculateChargeDamage(param1),param1.Shock,false));
         }
         else
         {
            attachEffect("effect_cancel",Boolean(param2) && Boolean(param2.OverlapHitBox) ? {
               "x":param2.OverlapHitBox.centerx,
               "y":param2.OverlapHitBox.centery,
               "absolute":true
            } : null);
            this.destroy();
         }
      }
      
      override public function reactionCounter(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         if(this.m_projectileStats.Suspend)
         {
            return false;
         }
         var _loc3_:AttackDamage = param1.AttackDataObj.getAttackBoxData(param1.AttackStateData.Frame,param2.SecondHitBox.Name).syncState(param1.AttackCache);
         if(this.validateHit(_loc3_,true))
         {
            return true;
         }
         return false;
      }
      
      override public function reactionRange(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(Boolean(this.m_projectileStats.Suspend) || !this.m_wasReversed && param1 === this.m_owner || STAGEDATA.TeamDamage && param1.Team == m_team_id && m_team_id > 0)
         {
            return false;
         }
         var _loc5_:Character = param1 as Character ? Character(param1) : null;
         if(Boolean(this.m_projectileStats.Suction) && Boolean(_loc5_) && !(_loc5_ && (_loc5_.isLandingOrSkiddingOrChambering() || _loc5_.Caught() || _loc5_.StandBy || _loc5_.Revival || _loc5_.Hanging)))
         {
            _loc3_ = (m_sprite.x - param1.X) / 20;
            _loc4_ = (m_sprite.y - param1.Y) / 20;
            param1.unnattachFromGround();
            param1.m_attemptToMove(_loc3_,0);
            param1.setYSpeed(_loc4_);
            return true;
         }
         return false;
      }
      
      override public function reactionHit(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         var _loc3_:Character = null;
         var _loc4_:AttackDamage = m_attackData.getAttackBoxData(m_attackCache.Frame,param2.FirstHitBox.Name).syncState(m_attackCache);
         if(param1 == this.m_owner && !inState(PState.DEAD) && Boolean(this.m_rocketReadyTimer.IsComplete) && this.m_projectileStats.RocketSpeed != 0 && !this.m_wasReversed && Boolean(param1 as Character))
         {
            m_attack.RefreshRateReady = true;
            _loc3_ = Character(param1);
            _loc3_.rocketCharacter(this.m_projectileStats.RocketSpeed,this.m_projectileStats.RocketAngleAbsolute ? Number(Utils.getAngleBetween(new Point(m_sprite.x,m_sprite.y),new Point(_loc3_.X,_loc3_.Y - _loc3_.Height / 2))) : Number(this.m_angle),this.m_projectileStats.RocketDecay,this.m_projectileStats.RocketRotation);
            this.m_projectileStats.RocketSpeed = 0;
            return true;
         }
         if(param1.takeDamage(_loc4_,param2.OverlapHitBox))
         {
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_CONNECT,{
               "caller":this.APIInstance.instance,
               "receiver":param1.APIInstance.instance,
               "attackBoxData":_loc4_.exportAttackDamageData()
            }));
            this.handleHit(param1,_loc4_,param2);
            return true;
         }
         if(param1.validateHit(_loc4_,true) && param1.isInvincible())
         {
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_CONNECT,{
               "caller":this.APIInstance.instance,
               "receiver":param1.APIInstance.instance,
               "attackBoxData":_loc4_.exportAttackDamageData()
            }));
            return true;
         }
         return false;
      }
      
      override public function reactionCollide(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         if(this.m_projectileStats.Suspend)
         {
            return false;
         }
         m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.PROJ_COLLIDE,{
            "caller":this.APIInstance.instance,
            "opponent":param1.APIInstance.instance
         }));
         if(!(!this.m_wasReversed && param1 === this.m_owner) && !param1.Intangible && Boolean(this.m_projectileStats.Latch) && this.m_latch_id == null && Boolean(param1 as Character))
         {
            m_xSpeed = 0;
            this.m_projectileStats.XDecay = 0;
            m_ySpeed = 0;
            m_gravity = 0;
            m_max_ySpeed = 0;
            this.m_projectileStats.CanBeReversed = false;
            this.m_latch_id = Character(param1);
            this.m_latch_xLoc = m_sprite.x - param1.X;
            this.m_latch_yLoc = m_sprite.y - param1.Y;
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.PROJ_LATCHED,{
               "caller":this.APIInstance.instance,
               "opponent":param1.APIInstance.instance
            }));
            return true;
         }
         return false;
      }
      
      override public function attackCollisionTest() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Character = null;
         var _loc3_:Enemy = null;
         var _loc4_:Projectile = null;
         var _loc5_:Item = null;
         var _loc6_:TargetTestTarget = null;
         var _loc7_:Vector.<HitBoxCollisionResult> = null;
         var _loc8_:Array = null;
         if(m_bypassCollisionTesting || !m_hitBoxManager.HasHitBoxes || m_attackCollisionTestsPreProcessed)
         {
            return;
         }
         if(this.IsFrozenInTime)
         {
            return;
         }
         if(!inState(PState.DEAD))
         {
            if(!isHitStunOrParalysis())
            {
               ++m_attack.ExecTime;
               ++m_attack.RefreshRateTimer;
               if(m_attack.RefreshRate > 0 && m_attack.RefreshRateReady && m_attack.RefreshRateTimer % m_attack.RefreshRate == 0)
               {
                  m_attack.AttackID = Utils.getUID();
               }
            }
            this.checkIfLinked();
            m_attackCache.syncState(m_attack);
            _loc1_ = 0;
            while(_loc1_ < STAGEDATA.Characters.length)
            {
               _loc2_ = STAGEDATA.Characters[_loc1_];
               if(_loc2_ != null && !_loc2_.StandBy && !_loc2_.Dead && !_loc2_.inState(CState.STAR_KO) && !_loc2_.inState(CState.SCREEN_KO) && !_loc2_.inState(CState.REVIVAL))
               {
                  InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.ATTACK,HitBoxSprite.SHIELD,this.reactionShield,STAGEDATA.HitBoxProcessorInstance);
                  if(InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster).length)
                  {
                     InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.ATTACK,HitBoxSprite.ATTACK,this.reactionClank,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.ATTACK,HitBoxSprite.SHIELDPROJECTILE,this.reactionShieldProjectile,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.ATTACK,HitBoxSprite.ABSORB,this.reactionAbsorb,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.ATTACK,HitBoxSprite.HIT,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.ATTACK,HitBoxSprite.EGG,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.ATTACK,HitBoxSprite.FREEZE,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.ATTACK,HitBoxSprite.STAR,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.COUNTER,HitBoxSprite.ATTACK,this.reactionCounter,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.RANGE,HitBoxSprite.HIT,this.reactionRange,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.HIT,HitBoxSprite.HIT,this.reactionCollide,STAGEDATA.HitBoxProcessorInstance);
                  }
               }
               _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < STAGEDATA.Projectiles.length)
            {
               _loc4_ = STAGEDATA.Projectiles[_loc1_];
               if(Boolean(_loc4_) && Boolean(_loc4_ != this) && !(_loc4_.getOwner() == this.getOwner() && !_loc4_.WasReversed && !this.WasReversed))
               {
                  if(InteractiveSprite.hitTest(this,_loc4_,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster).length)
                  {
                     InteractiveSprite.hitTest(this,_loc4_,HitBoxSprite.ATTACK,HitBoxSprite.ATTACK,this.reactionAttackReverse,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,_loc4_,HitBoxSprite.ATTACK,HitBoxSprite.ATTACK,this.reactionClank,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,_loc4_,HitBoxSprite.HIT,HitBoxSprite.HIT,this.reactionCollide,STAGEDATA.HitBoxProcessorInstance);
                  }
               }
               _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < STAGEDATA.Enemies.length)
            {
               _loc3_ = STAGEDATA.Enemies[_loc1_];
               if(_loc3_ != null)
               {
                  if(InteractiveSprite.hitTest(this,_loc3_,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster).length)
                  {
                     InteractiveSprite.hitTest(this,_loc3_,HitBoxSprite.ATTACK,HitBoxSprite.HIT,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,_loc3_,HitBoxSprite.COUNTER,HitBoxSprite.ATTACK,this.reactionCounter,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,_loc3_,HitBoxSprite.HIT,HitBoxSprite.HIT,this.reactionCollide,STAGEDATA.HitBoxProcessorInstance);
                  }
               }
               _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < STAGEDATA.ItemsRef.MAXITEMS)
            {
               _loc5_ = STAGEDATA.ItemsRef.getItemData(_loc1_);
               if(_loc5_ != null)
               {
                  InteractiveSprite.hitTest(this,_loc5_,HitBoxSprite.ATTACK,HitBoxSprite.HIT,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc5_,HitBoxSprite.ATTACK,HitBoxSprite.ATTACK,this.reactionAttackReverse,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc5_,HitBoxSprite.REVERSE,HitBoxSprite.ATTACK,this.reactionReverse,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc5_,HitBoxSprite.REVERSE,HitBoxSprite.HIT,this.reactionReverse,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc5_,HitBoxSprite.HIT,HitBoxSprite.HIT,this.reactionCollide,STAGEDATA.HitBoxProcessorInstance);
               }
               _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < STAGEDATA.Targets.length)
            {
               _loc6_ = STAGEDATA.Targets[_loc1_];
               if(_loc6_ != null)
               {
                  if(InteractiveSprite.hitTest(this,_loc6_,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster).length)
                  {
                     InteractiveSprite.hitTest(this,_loc6_,HitBoxSprite.ATTACK,HitBoxSprite.HIT,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,_loc6_,HitBoxSprite.HIT,HitBoxSprite.HIT,this.reactionCollide,STAGEDATA.HitBoxProcessorInstance);
                  }
               }
               _loc1_++;
            }
            this.checkLatch();
         }
         if(HasMC)
         {
            m_sprite.stop();
            Utils.recursiveMovieClipPlay(m_sprite,false);
         }
      }
      
      override protected function validateBypass(param1:AttackDamage) : Boolean
      {
         if(param1.BypassProjectiles)
         {
            return false;
         }
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
         if(!super.validateHit(param1,param2,param3) || inState(PState.DEAD))
         {
            return false;
         }
         return true;
      }
      
      public function validateHitClank(param1:AttackDamage, param2:Boolean = false, param3:Boolean = false) : Boolean
      {
         if(inState(PState.DEAD) || !param1 || !this.validateBypass(param1) || !validateOnlyAffects(param1) || checkUnhittableSelfHit(param1) || checkUnhittableTeamHit(param1) || !param2 && isInvincible() || !param3 && isIntangible() || attackIDArrayContains(param1.AttackID))
         {
            return false;
         }
         return true;
      }
      
      override public function takeDamage(param1:AttackDamage, param2:HitBoxSprite = null) : Boolean
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:MovieClip = null;
         if(!this.validateHit(param1,false,true))
         {
            return false;
         }
         var _loc10_:Number = m_damage;
         var _loc11_:Number = param1.Damage <= 0 ? 0 : Number(Utils.calculateChargeDamage(param1));
         var _loc12_:Number = param1.SizeStatus == 0 ? 1 : (param1.SizeStatus > 0 ? 2 : 0.5);
         var _loc13_:Number = 0;
         var _loc14_:Number = 0;
         if(param1.HasEffect)
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
            _loc3_ = 0;
            _loc4_ = param1.Damage <= 0 ? 0 : Number(Utils.calculateChargeDamage(param1));
            _loc4_ *= param1.StaleMultiplier;
            if(param1.Damage > 0 && _loc4_ <= 0)
            {
               _loc4_ = 1;
            }
            stackAttackID(param1.AttackID);
            if(param1.Power >= 0)
            {
               if(Boolean(param1.Owner as Projectile) && param1.ChargeTimeMax > 0)
               {
                  _loc13_ = param1.ChargeTimeMax > 0 ? (0.25 + 1 * (param1.ChargeTime / param1.ChargeTimeMax)) * param1.Power + 10 * param1.KBConstant * 1 / 1 : param1.Power + 10 * param1.KBConstant * 1 / 1;
               }
               else
               {
                  _loc13_ = param1.ChargeTimeMax > 0 ? (0.85 + 0.25 * (param1.ChargeTime / param1.ChargeTimeMax)) * param1.Power + 10 * param1.KBConstant * 1 / 1 : param1.Power + 10 * param1.KBConstant * 1 / 1;
               }
               if(_loc13_ < 2550)
               {
               }
            }
            else
            {
               _loc13_ = -param1.Power;
            }
            _loc13_ /= 100;
            if(m_collision.ground)
            {
               if(_loc3_ > 180 && _loc3_ < 360)
               {
                  _loc3_ = 360 - _loc3_;
               }
            }
            if(!param1.IsForward)
            {
               _loc3_ = 180 - _loc3_;
            }
            _loc3_ = Number(Utils.forceBase360(_loc3_));
            _loc5_ = Math.abs(_loc13_ * Math.cos(_loc3_ * Math.PI / 180));
            _loc6_ = Math.abs(_loc13_ * Math.sin(_loc3_ * Math.PI / 180));
            _loc7_ = _loc3_ >= 0 && _loc3_ < 90 || _loc3_ >= 270 && _loc3_ < 360 ? true : false;
            _loc8_ = _loc3_ >= 0 && _loc3_ < 180 ? true : false;
            if(_loc6_ > 50 && !_loc8_)
            {
               _loc6_ = 50;
            }
            _loc3_ = Number(Utils.calculateReversedAngle(Utils.calculateAttackDirection(param1,this),param1,this));
            if(param1.EffectID != null && param1.EffectID != null && Boolean(STAGEDATA.getQualitySettings().hit_effects))
            {
               _loc9_ = attachHurtEffect(param1.EffectID,param2,{
                  "scaleX":(0.25 + 0.75 * Math.min(param1.Damage / 16,1)) * _loc12_,
                  "scaleY":(0.25 + 0.75 * Math.min(param1.Damage / 16,1)) * _loc12_
               });
               if(_loc9_)
               {
                  _loc9_.rotation = param1.IsForward ? 180 - _loc3_ : -_loc3_;
               }
            }
            if(param1.EffectSound != null)
            {
               this.playGlobalSound(param1.EffectSound);
            }
            if(param1.HasEffect)
            {
               if(m_paralysis)
               {
                  stopActionShot(false,true);
                  m_paralysisHitCount = 3;
                  startActionShot(Utils.calculateHitStun(param1.HitStun,_loc4_,param1.Shock,false));
               }
               else
               {
                  startActionShot(Utils.calculateHitStun(param1.HitStun,_loc4_,param1.Shock,false),param1.Paralysis);
               }
            }
            else
            {
               startActionShot(-1,param1.Paralysis);
            }
            _loc14_ = Number(Utils.calculateKnockback(param1.KBConstant,param1.Power,param1.WeightKB,_loc11_,_loc10_,this.m_projectileStats.Weight1,false,STAGEDATA.GameRef.LevelData.damageRatio,param1.AttackRatio));
            _loc13_ = Number(Utils.calculateVelocity(_loc14_));
            if(this.m_projectileStats.CanReceiveKnockback)
            {
               applyKnockbackSpeed(_loc13_,_loc3_);
            }
            if(this.m_projectileStats.CanReceiveDamage)
            {
               setDamage(this.m_projectileStats.Stamina > 0 ? m_damage - _loc4_ : m_damage + _loc4_);
            }
            if(_loc13_ < Character.HEAVY_KNOCKBACK_THRESHOLD || Utils.calculateHitlag(_loc14_,param1.HitLag) < Character.HEAVY_KNOCKBACK_HITLAG_THRESHOLD)
            {
               if(param1.Power >= 1000)
               {
                  CAM.shake(6);
               }
            }
            else
            {
               if(_loc13_ > 35)
               {
                  STAGEDATA.lightFlash(false);
               }
               CAM.shake(12);
            }
            if(param1.CamShake > 0)
            {
               CAM.shake(param1.CamShake);
            }
            if(!m_attack.DisableLastHitUpdate)
            {
               m_lastHitID = param1.PlayerID;
               m_lastHitObject = param1;
            }
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.PROJ_HURT,{
               "caller":this.APIInstance.instance,
               "opponent":(param1.Owner ? param1.Owner.APIInstance.instance : null),
               "attackBoxData":param1.exportAttackDamageData(),
               "collisionRect":(param2 ? param2.BoundingBox : null)
            }));
            return true;
         }
         return false;
      }
      
      public function checkLatch() : void
      {
         var _loc1_:Character = null;
         if(this.m_latch_id != null)
         {
            _loc1_ = this.m_latch_id as Character ? Character(this.m_latch_id) : null;
            if(Boolean(_loc1_) && (_loc1_.Revival || _loc1_.Dead || _loc1_.StandBy))
            {
               this.destroy();
               this.m_latch_id = null;
            }
            else if(this.m_projectileStats.LatchXOffset == 0 && this.m_projectileStats.LatchYOffset == 0)
            {
               m_sprite.x = this.m_latch_id.X + this.m_latch_xLoc;
               m_sprite.y = Boolean(_loc1_) && _loc1_.Hanging ? this.m_latch_id.Y + this.m_latch_yLoc + this.m_latch_id.Height / 2 : this.m_latch_id.Y + this.m_latch_yLoc - this.m_latch_id.Height / 2;
            }
            else
            {
               m_sprite.x = this.m_latch_id.X + this.m_projectileStats.LatchXOffset;
               m_sprite.y = Boolean(_loc1_) && _loc1_.Hanging ? this.m_latch_id.Y + this.m_projectileStats.LatchYOffset + this.m_latch_id.Height / 2 : this.m_latch_id.Y + this.m_projectileStats.LatchYOffset - this.m_latch_id.Height / 2;
            }
         }
      }
      
      private function visible() : Boolean
      {
         return m_sprite.visible;
      }
      
      private function setVar(param1:String, param2:*) : void
      {
         m_sprite[param1] = param2;
      }
      
      private function m_calcFlyingAngle() : void
      {
         var _loc1_:Number = NaN;
         if(Boolean(this.m_projectileStats.Rotate) && !(m_xSpeed == 0 && m_ySpeed == 0 || this.m_projectileStats.HomingSpeed == 0 && Boolean(m_attack.HomingTarget)))
         {
            _loc1_ = Number(Utils.getAngleBetween(new Point(0,0),new Point(m_xSpeed,m_ySpeed)));
            _loc1_ = Number(Utils.forceBase360(m_facingForward ? -_loc1_ : -_loc1_ + 180));
            m_sprite.rotation = _loc1_;
         }
      }
      
      private function checkWall() : void
      {
         if(!m_collision.ground && this.m_projectileStats.XOffset != 0 && !this.m_projectileStats.Ghost && !this.m_projectileStats.Latch && !inState(PState.DEAD) && Boolean(testTerrainWithCoord(m_sprite.x,m_sprite.y)))
         {
            if(m_facingForward)
            {
               m_sprite.x -= this.m_projectileStats.XOffset > 0 ? 1 : -1;
            }
            else
            {
               m_sprite.x += this.m_projectileStats.XOffset > 0 ? 1 : -1;
            }
         }
      }
      
      override protected function m_controlFrames() : void
      {
         if(m_state == PState.IDLE)
         {
            playFrame(m_attack.Frame);
         }
         else if(m_state == PState.DEAD)
         {
         }
      }
      
      protected function m_pushAwayOpponents() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Character = null;
         var _loc3_:Rectangle = null;
         var _loc4_:Rectangle = null;
         if(Boolean(this.m_projectileStats.PushCharacters) && m_collision.ground && !inState(PState.DEAD))
         {
            _loc1_ = 0;
            while(_loc1_ < STAGEDATA.Characters.length)
            {
               _loc2_ = STAGEDATA.Characters[_loc1_];
               if(!(!m_collision.ground && !_loc2_ || !_loc2_.CollisionObj.ground || !InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster).length))
               {
                  _loc3_ = _loc2_.BoundsRect;
                  _loc4_ = BoundsRect;
                  _loc3_.x += _loc2_.X;
                  _loc3_.y += _loc2_.Y;
                  _loc4_.x += m_sprite.x;
                  _loc4_.y += m_sprite.y;
                  if(_loc3_.intersects(_loc4_))
                  {
                     if(m_sprite.x < _loc2_.X)
                     {
                        _loc2_.pushAway(true);
                     }
                     else
                     {
                        _loc2_.pushAway(false);
                     }
                  }
               }
               _loc1_++;
            }
         }
      }
      
      override public function PERFORMALL() : void
      {
         this.PREPERFORM();
         if(!inState(PState.DEAD) && !STAGEDATA.FSCutscene && (STAGEDATA.FSCutins <= 0 || this.m_owner is Character && Boolean(Character(this.m_owner).UsingFinalSmash)))
         {
            if(!this.IsFrozenInTime)
            {
               checkTimers();
               if(this.m_projectileStats.TimeMax > 0 && !isHitStunOrParalysis() && !this.m_projectileStats.Suspend)
               {
                  ++this.m_time;
               }
               this.checkWall();
               this.m_groundCollisionTest();
            }
            this.m_calcFlyingAngle();
            if(!this.IsFrozenInTime)
            {
               this.checkReverse();
               this.projectileMove();
               this.m_pushAwayOpponents();
               m_forces();
               updateSelfPlatform();
            }
            checkReflection();
            checkShadow();
            if(!this.IsFrozenInTime)
            {
               checkHitStun();
            }
            checkShowHitBoxes();
            if(!this.IsFrozenInTime)
            {
               updateCamerBox();
               this.checkIfDead();
            }
         }
         this.POSTPERFORM();
      }
      
      override protected function PREPERFORM() : void
      {
         m_actionTimerUpdatedOnFrame = false;
         if(!STAGEDATA.FSCutscene && (STAGEDATA.FSCutins <= 0 || this.m_owner is Character && Boolean(Character(this.m_owner).UsingFinalSmash)))
         {
            if(m_started && HasStance && !inState(PState.DEAD) && !isHitStunOrParalysis() && !m_delayPlayback)
            {
               if(!this.IsFrozenInTime)
               {
                  Utils.advanceFrame(m_sprite.stance);
                  Utils.recursiveMovieClipPlay(m_sprite.stance,true);
               }
            }
            else
            {
               handleDelayPlayback();
            }
         }
      }
      
      override protected function POSTPERFORM() : void
      {
         if(!STAGEDATA.FSCutscene && (STAGEDATA.FSCutins <= 0 || this.m_owner is Character && Boolean(Character(this.m_owner).UsingFinalSmash)))
         {
            if(!this.IsFrozenInTime)
            {
               super.POSTPERFORM();
               m_apiInstance.update();
            }
         }
      }
      
      override public function get IsFrozenInTime() : Boolean
      {
         if(Boolean(this.m_owner) && this.m_owner != this)
         {
            if(this.STAGEDATA.InTimeStop && this.m_owner is Character)
            {
               return this.m_owner.IsFrozenInTime || Boolean(STAGEDATA.getCharacterTimeStopperBypassOptions(this.m_owner.UID)) && !STAGEDATA.getCharacterTimeStopperBypassOptions(this.m_owner.UID).bypassProjectile;
            }
            return this.m_owner.IsFrozenInTime;
         }
         return this.STAGEDATA.InTimeStop;
      }
   }
}


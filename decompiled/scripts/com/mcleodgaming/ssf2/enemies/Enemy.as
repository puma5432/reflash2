package com.mcleodgaming.ssf2.enemies
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.api.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.items.*;
   import com.mcleodgaming.ssf2.platforms.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   import flash.geom.*;
   
   public class Enemy extends InteractiveSprite
   {
      
      protected var m_owner:InteractiveSprite;
      
      protected var m_linkage_id:String;
      
      protected var m_dead:Boolean;
      
      protected var m_x_start:Number;
      
      protected var m_y_start:Number;
      
      protected var m_projectile:Vector.<Projectile>;
      
      protected var m_lastProjectile:int;
      
      protected var m_didDamage:Boolean;
      
      protected var m_didDamageList:Vector.<InteractiveSprite>;
      
      protected var m_beaconTimer:FrameTimer;
      
      protected var m_findTimer:FrameTimer;
      
      protected var m_enemyStats:EnemyStats;
      
      public function Enemy(param1:EnemyStats, param2:StageData, param3:Number, param4:Number, param5:int = -1, param6:MovieClip = null, param7:InteractiveSprite = null)
      {
         m_baseStats = this.m_enemyStats = param1;
         if(!this.m_enemyStats.ClassAPI)
         {
            this.m_enemyStats.importData({"classAPI":param2.BASE_CLASSES.SSF2Enemy});
         }
         m_apiInstance = new SSF2Enemy(this.m_enemyStats.ClassAPI,this);
         this.m_enemyStats.importData(m_apiInstance.getOwnStats());
         this.m_x_start = param3;
         this.m_y_start = param4;
         this.m_linkage_id = this.m_enemyStats.LinkageID;
         param2.addEnemy(this);
         var _loc8_:MovieClip = param6 ? param6 : ResourceManager.getLibraryMC(this.m_enemyStats.LinkageID);
         _loc8_.ACTIVE = true;
         super(_loc8_,param2);
         m_player_id = param5;
         if(m_player_id > 0)
         {
            m_team_id = STAGEDATA.getPlayerByID(m_player_id).Team;
         }
         else
         {
            m_team_id = -1;
         }
         if(param5 > 0)
         {
            this.setOwnerAPI(STAGEDATA.getPlayerByID(param5));
         }
         else
         {
            this.setOwnerAPI(param7);
         }
         m_sprite.x = this.m_x_start;
         m_sprite.y = this.m_y_start;
         m_sprite.uid = m_uid;
         this.m_dead = false;
         m_state = EState.IDLE;
         this.m_linkage_id = this.m_enemyStats.LinkageID;
         this.m_projectile = new Vector.<Projectile>();
         var _loc9_:Number = 0;
         _loc9_ = 0;
         while(_loc9_ < this.m_enemyStats.MaxProjectile)
         {
            this.m_projectile.push(null);
            _loc9_++;
         }
         this.m_lastProjectile = 0;
         m_attackData = new AttackData(this);
         this.m_beaconTimer = new FrameTimer(150);
         this.m_findTimer = new FrameTimer(5);
         this.m_didDamage = false;
         this.m_didDamageList = new Vector.<InteractiveSprite>();
         m_actionShot = false;
         m_actionTimer = 0;
         m_lastHitID = 0;
         m_lastAttackID = new Array(15);
         m_lastAttackIndex = 0;
         buildHitBoxData(this.m_linkage_id);
         if(Main.DEBUG)
         {
            verifiyHitBoxData();
         }
         this.syncStats();
         m_attackData.importAttacks(m_apiInstance.getAttackStats());
         m_attackData.importItems(m_apiInstance.getItemStats());
         m_attackData.importProjectiles(m_apiInstance.getProjectileStats());
      }
      
      override public function get CurrentAnimation() : HitBoxAnimation
      {
         return m_hitBoxManager == null ? null : (m_hitBoxManager.HitBoxAnimationList.length <= 0 || !m_sprite.currentLabel ? null : m_hitBoxManager.getHitBoxAnimation(this.m_linkage_id + "_" + m_sprite.currentLabel));
      }
      
      public function get Dead() : Boolean
      {
         return this.m_dead;
      }
      
      public function get ProjectileList() : Vector.<Projectile>
      {
         return this.m_projectile;
      }
      
      public function get LinkageID() : String
      {
         return this.m_linkage_id;
      }
      
      public function get PlayerID() : int
      {
         return m_player_id;
      }
      
      public function get TeamID() : int
      {
         return m_team_id;
      }
      
      public function get ProjectileArray() : Vector.<Projectile>
      {
         return this.m_projectile;
      }
      
      public function getOwner() : InteractiveSprite
      {
         return this.m_owner;
      }
      
      override public function getLinkageID() : String
      {
         return this.m_linkage_id;
      }
      
      public function getEnemyStat(param1:String) : *
      {
         return this.m_enemyStats.getVar(param1);
      }
      
      public function updateEnemyStats(param1:Object) : void
      {
         this.m_enemyStats.importData(param1);
         this.syncStats();
      }
      
      override protected function syncStats() : void
      {
         m_gravity = this.m_enemyStats.Gravity;
         m_max_ySpeed = this.m_enemyStats.MaxYSpeed;
         m_width = this.m_enemyStats.Width;
         m_height = this.m_enemyStats.Height;
         m_bypassCollisionTesting = this.m_enemyStats.BypassCollisionTesting;
      }
      
      protected function checkDeath() : void
      {
         if(Boolean(!this.m_enemyStats.SurviveDeathBounds) && Boolean(STAGEDATA.DeathBounds) && (m_sprite.x < STAGEDATA.DeathBounds.x || m_sprite.x > STAGEDATA.DeathBounds.x + STAGEDATA.DeathBounds.width || m_sprite.y < STAGEDATA.DeathBounds.y || m_sprite.y > STAGEDATA.DeathBounds.y + STAGEDATA.DeathBounds.height))
         {
            this.destroy();
         }
      }
      
      public function setPlayerID(param1:Number) : void
      {
         m_player_id = param1;
      }
      
      public function setTeamID(param1:Number) : void
      {
         m_team_id = param1;
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
         this.m_owner = param1;
         if(this.m_owner)
         {
            m_player_id = this.m_owner.ID;
            m_team_id = this.m_owner.Team;
         }
         else
         {
            m_player_id = -1;
            m_team_id = -1;
         }
      }
      
      public function pause() : void
      {
         if(HasStance)
         {
            m_sprite.stance.stop();
            Utils.recursiveMovieClipPlay(m_sprite.stance,false);
         }
      }
      
      public function unpause() : void
      {
         if(HasStance)
         {
            m_sprite.stance.play();
            Utils.recursiveMovieClipPlay(m_sprite.stance,true);
         }
      }
      
      public function destroy() : void
      {
         if(!inState(EState.DEAD))
         {
            m_skipAttackCollisionTests = true;
            m_skipAttackProcessing = true;
            this.m_didDamageList.splice(0,this.m_didDamageList.length);
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ENEMY_DESTROYED,{"caller":this.APIInstance.instance}));
            if(m_sprite.parent != null)
            {
               STAGE.removeChild(m_sprite);
            }
            this.m_dead = true;
            STAGEDATA.removeEnemy(this);
            removeSelfPlatform();
            m_state = EState.DEAD;
            if(Boolean(m_shadowEffect) && Boolean(m_shadowEffect.parent))
            {
               m_shadowEffect.parent.removeChild(m_shadowEffect);
            }
            m_shadowEffect = null;
            if(Boolean(m_reflectionEffect) && Boolean(m_reflectionEffect.parent))
            {
               m_reflectionEffect.parent.removeChild(m_reflectionEffect);
            }
            removeFromCamera();
            m_reflectionEffect = null;
         }
      }
      
      public function destroyInterruptedProjectiles() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.m_projectile.length)
         {
            if(this.m_projectile[_loc1_] != null && !this.m_projectile[_loc1_].Visible)
            {
               this.m_projectile[_loc1_].destroy();
               this.m_projectile[_loc1_] = null;
            }
            _loc1_++;
         }
      }
      
      private function getIndexOfOldestProjectile(param1:String) : int
      {
         var _loc3_:int = 0;
         var _loc2_:int = -1;
         while(_loc3_ < this.m_enemyStats.MaxProjectile && _loc3_ < this.m_projectile.length)
         {
            if(this.m_projectile[_loc3_] != null && this.m_projectile[_loc3_].ProjectileAttackObj.StatsName == param1 && (_loc2_ < 0 || this.m_projectile[_loc3_].Time > this.m_projectile[_loc2_].Time))
            {
               _loc2_ = _loc3_;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getCurrentProjectile() : Projectile
      {
         if(this.m_lastProjectile >= 0 && this.m_lastProjectile < this.m_projectile.length)
         {
            return this.m_projectile[this.m_lastProjectile];
         }
         return null;
      }
      
      public function getProjectile(param1:Number) : Projectile
      {
         if(param1 >= 0 && param1 < this.m_projectile.length)
         {
            return this.m_projectile[param1];
         }
         return null;
      }
      
      private function getProjectileLimit(param1:String) : Number
      {
         var _loc3_:int = 0;
         var _loc2_:Number = 0;
         while(_loc3_ < this.m_projectile.length)
         {
            if(this.m_projectile[_loc3_] != null && !this.m_projectile[_loc3_].inState(PState.DEAD) && (Boolean(this.m_projectile[_loc3_].LinkageID == param1) || Boolean(this.m_projectile[_loc3_].getProjectileStat("statsName") && this.m_projectile[_loc3_].getProjectileStat("statsName") == param1)))
            {
               _loc2_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      override public function getProjectiles() : Array
      {
         var _loc2_:int = 0;
         var _loc1_:Array = new Array();
         while(_loc2_ < this.m_projectile.length)
         {
            if(Boolean(this.m_projectile[_loc2_]) && !this.m_projectile[_loc2_].Dead)
            {
               _loc1_.push(this.m_projectile[_loc2_]);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function fireProjectile(param1:*, param2:Number = 0, param3:Number = 0, param4:Boolean = false, param5:Object = null) : Projectile
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Projectile = null;
         var _loc10_:ProjectileAttack = null;
         if(param1 as String)
         {
            _loc10_ = m_attackData.getProjectile(param1);
         }
         else
         {
            _loc10_ = new ProjectileAttack();
            _loc10_.importData(param1);
         }
         if(!param5)
         {
            param5 = {};
         }
         if(_loc10_ != null)
         {
            _loc6_ = 0;
            while(_loc6_ < this.m_enemyStats.MaxProjectile && _loc6_ < this.m_projectile.length && !_loc9_)
            {
               if((this.m_projectile[_loc6_] == null || this.m_projectile[_loc6_].inState(PState.DEAD) || _loc10_.LimitOverwrite) && _loc10_.LinkageID != null && (this.getProjectileLimit(_loc10_.LinkageID) < _loc10_.Limit || _loc10_.LimitOverwrite))
               {
                  _loc7_ = _loc6_;
                  if(_loc10_.LimitOverwrite && this.getProjectileLimit(_loc10_.LinkageID) >= _loc10_.Limit)
                  {
                     _loc6_ = int(this.getIndexOfOldestProjectile(_loc10_.LinkageID));
                     if(_loc6_ < 0)
                     {
                        return null;
                     }
                     this.m_projectile[_loc6_].destroy();
                     this.m_projectile[_loc6_] = null;
                  }
                  else if(_loc10_.LimitOverwrite)
                  {
                     _loc6_ = int(this.getIndexOfOldestProjectile(_loc10_.LinkageID));
                     _loc8_ = 0;
                     while(_loc8_ < this.m_projectile.length)
                     {
                        if(this.m_projectile[_loc8_] == null)
                        {
                           _loc6_ = _loc8_;
                           break;
                        }
                        _loc8_++;
                     }
                     if(_loc6_ < 0)
                     {
                        return null;
                     }
                     if(this.m_projectile[_loc6_])
                     {
                        this.m_projectile[_loc6_].destroy();
                     }
                  }
                  this.m_projectile[_loc6_] = new Projectile({
                     "owner":this,
                     "player_id":m_player_id,
                     "x_start":m_sprite.x,
                     "y_start":m_sprite.y,
                     "sizeRatio":m_sizeRatio,
                     "facingForward":m_facingForward,
                     "chargetime":param5.chargetime || 0,
                     "chargetime_max":param5.chargetime_max || 0,
                     "frame":_loc10_.StatsName + "_proj",
                     "staleMultiplier":1,
                     "sizeStatus":0,
                     "terrains":m_terrains,
                     "platforms":m_platforms,
                     "team_id":m_team_id
                  },_loc10_,STAGEDATA);
                  _loc9_ = this.m_projectile[_loc6_];
                  this.m_lastProjectile = _loc6_;
                  if(param2 != 0 || param3 != 0)
                  {
                     if(param4)
                     {
                        this.m_projectile[_loc6_].X = param2;
                        this.m_projectile[_loc6_].Y = param3;
                        this.m_projectile[_loc6_].X += m_facingForward ? _loc10_.XOffset * m_sizeRatio : -_loc10_.XOffset * m_sizeRatio;
                        this.m_projectile[_loc6_].Y += _loc10_.YOffset * m_sizeRatio;
                     }
                     else
                     {
                        this.m_projectile[_loc6_].X += m_facingForward ? param2 : -param2;
                        this.m_projectile[_loc6_].Y += param3 * m_sizeRatio;
                        this.m_projectile[_loc6_].X += m_facingForward ? _loc10_.XOffset * m_sizeRatio : -_loc10_.XOffset * m_sizeRatio;
                        this.m_projectile[_loc6_].Y += _loc10_.YOffset * m_sizeRatio;
                     }
                  }
                  else
                  {
                     this.m_projectile[_loc6_].X += m_facingForward ? _loc10_.XOffset * m_sizeRatio : -_loc10_.XOffset * m_sizeRatio;
                     this.m_projectile[_loc6_].Y += _loc10_.YOffset * m_sizeRatio;
                  }
                  break;
               }
               _loc6_++;
            }
         }
         return _loc9_;
      }
      
      public function getActiveProjectiles(param1:int, param2:int) : Vector.<Projectile>
      {
         var _loc4_:int = 0;
         var _loc3_:Vector.<Projectile> = new Vector.<Projectile>();
         while(_loc4_ < this.m_projectile.length)
         {
            if(this.m_projectile[_loc4_] != null && !this.m_projectile[_loc4_].Dead && (this.m_projectile[_loc4_].ID != param1 && !(param2 > 0 && this.m_projectile[_loc4_].TeamID > 0 && this.m_projectile[_loc4_].TeamID == param2) || this.m_projectile[_loc4_].WasReversed))
            {
               _loc3_.push(this.m_projectile[_loc4_]);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function destroyAllProjectiles() : void
      {
         var _loc1_:* = 0;
         while(_loc1_ < this.m_projectile.length)
         {
            if(this.m_projectile[_loc1_] != null)
            {
               this.m_projectile[_loc1_].destroy();
               this.m_projectile[_loc1_] = null;
            }
            _loc1_++;
         }
      }
      
      protected function runBeaconTimer() : void
      {
         this.m_beaconTimer.tick();
         if(this.m_beaconTimer.IsComplete)
         {
            if(m_currentTarget.BeaconSprite)
            {
               m_shortestPath = null;
               getNearestOpponent("character",true);
            }
            this.m_beaconTimer.reset();
         }
      }
      
      protected function runTargetTimer() : void
      {
         getNearestOpponent("character",true);
         this.m_findTimer.tick();
         if(this.m_findTimer.IsComplete)
         {
            checkPotentialBeaconPath("character",true);
            this.m_findTimer.reset();
         }
      }
      
      protected function performAttackChecks() : void
      {
         var _loc1_:Number = NaN;
         if(!isHitStunOrParalysis())
         {
            ++m_attack.ExecTime;
            ++m_attack.RefreshRateTimer;
            if(m_attack.RefreshRate > 0 && m_attack.RefreshRateReady && m_attack.RefreshRateTimer % m_attack.RefreshRate == 0)
            {
               m_attack.AttackID = Utils.getUID();
            }
            if(m_attack.Rotate)
            {
               _loc1_ = Number(Utils.getAngleBetween(new Point(),new Point(m_xSpeed,m_ySpeed)));
               _loc1_ = Number(Utils.forceBase360(m_facingForward ? -_loc1_ : -_loc1_ + 180));
               m_sprite.rotation = _loc1_;
            }
         }
         m_attack.XLoc = m_sprite.x;
         m_attack.YLoc = m_sprite.y;
      }
      
      override public function forceAttack(param1:String, param2:* = null, param3:Boolean = false) : Boolean
      {
         if(param1 === m_attack.Frame)
         {
            if(Boolean(Main.DEBUG) && Boolean(MenuController.debugConsole) && Boolean(MenuController.debugConsole.Alerts))
            {
               MenuController.debugConsole.alert("[Warning] forceAttack(\"" + param1 + "\") was called when the SSF2Enemy object was already using that attack. Call has been aborted");
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
            this.Attack(param1);
            if(param2 !== null)
            {
               stancePlayFrame(param2);
            }
            return true;
         }
         return false;
      }
      
      protected function Attack(param1:String) : void
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
      
      override public function reactionShield(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         var _loc5_:Array = null;
         var _loc3_:Character = param1 as Character ? Character(param1) : null;
         var _loc4_:AttackDamage = m_attackData.getAttackBoxData(m_attackCache.Frame,param2.FirstHitBox.Name).syncState(m_attackCache);
         if(_loc3_)
         {
            if(_loc4_.BypassShield && param1.takeDamage(_loc4_,param2.OverlapHitBox))
            {
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_CONNECT_SHIELD,{
                  "caller":this.APIInstance.instance,
                  "receiver":param1.APIInstance.instance,
                  "attackBoxData":_loc4_.exportAttackDamageData()
               }));
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
               return true;
            }
         }
         return false;
      }
      
      override public function reactionAbsorb(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         return false;
      }
      
      override public function reactionCounter(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         var _loc3_:AttackDamage = param1.AttackDataObj.getAttackBoxData(param1.AttackStateData.Frame,param2.SecondHitBox.Name).syncState(param1.AttackCache);
         if(!this.m_dead && this.validateHit(_loc3_,true))
         {
            return true;
         }
         return false;
      }
      
      override public function reactionHit(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         var _loc3_:AttackDamage = m_attackData.getAttackBoxData(m_attackCache.Frame,param2.FirstHitBox.Name).syncState(m_attackCache);
         if(param1.takeDamage(_loc3_,param2.OverlapHitBox))
         {
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_CONNECT,{
               "caller":this.APIInstance.instance,
               "receiver":param1.APIInstance.instance,
               "attackBoxData":_loc3_.exportAttackDamageData()
            }));
            startActionShot(Utils.calculateSelfHitStun(_loc3_.SelfHitStun,Utils.calculateChargeDamage(_loc3_)));
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_HIT,{
               "caller":this.APIInstance.instance,
               "receiver":param1.APIInstance.instance,
               "attackBoxData":_loc3_.exportAttackDamageData()
            }));
            this.m_didDamage = true;
            if(this.m_didDamageList.indexOf(param1) < 0)
            {
               this.m_didDamageList.push(param1);
            }
            return true;
         }
         if(param1.validateHit(_loc3_,true) && param1.isInvincible())
         {
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_CONNECT,{
               "caller":this.APIInstance.instance,
               "receiver":param1.APIInstance.instance,
               "attackBoxData":_loc3_.exportAttackDamageData()
            }));
            if(param1 as Character)
            {
               param1.attachEffect("effect_cancel",Boolean(param2) && Boolean(param2.OverlapHitBox) ? {
                  "x":param2.OverlapHitBox.centerx,
                  "y":param2.OverlapHitBox.centery,
                  "absolute":true
               } : null);
            }
         }
         return false;
      }
      
      override public function handleHit(param1:InteractiveSprite, param2:AttackDamage, param3:HitBoxCollisionResult) : void
      {
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
      
      override public function attackCollisionTest() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Character = null;
         var _loc3_:Enemy = null;
         var _loc4_:Item = null;
         var _loc5_:Projectile = null;
         var _loc6_:TargetTestTarget = null;
         var _loc7_:Vector.<HitBoxCollisionResult> = null;
         var _loc8_:Array = null;
         if(m_bypassCollisionTesting || !m_hitBoxManager.HasHitBoxes || m_attackCollisionTestsPreProcessed)
         {
            return;
         }
         if(!this.m_dead)
         {
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
                     InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.ATTACK,HitBoxSprite.ABSORB,this.reactionAbsorb,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.ATTACK,HitBoxSprite.HIT,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.ATTACK,HitBoxSprite.EGG,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.ATTACK,HitBoxSprite.FREEZE,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.ATTACK,HitBoxSprite.STAR,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.COUNTER,HitBoxSprite.ATTACK,this.reactionCounter,STAGEDATA.HitBoxProcessorInstance);
                  }
               }
               _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < STAGEDATA.Projectiles.length && !inState(EState.DEAD))
            {
               _loc5_ = STAGEDATA.Projectiles[_loc1_];
               if(_loc5_ != null)
               {
                  if(InteractiveSprite.hitTest(this,_loc5_,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster).length)
                  {
                     InteractiveSprite.hitTest(this,_loc5_,HitBoxSprite.ATTACK,HitBoxSprite.ATTACK,this.reactionAttackReverse,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,_loc5_,HitBoxSprite.REVERSE,HitBoxSprite.ATTACK,this.reactionReverse,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,_loc5_,HitBoxSprite.REVERSE,HitBoxSprite.HIT,this.reactionReverse,STAGEDATA.HitBoxProcessorInstance);
                  }
               }
               _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < STAGEDATA.Enemies.length)
            {
               _loc3_ = STAGEDATA.Enemies[_loc1_];
               if(_loc3_ != null && _loc3_ != this)
               {
                  if(InteractiveSprite.hitTest(this,_loc3_,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster).length)
                  {
                     InteractiveSprite.hitTest(this,_loc3_,HitBoxSprite.ATTACK,HitBoxSprite.HIT,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                  }
               }
               _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < STAGEDATA.ItemsRef.MAXITEMS)
            {
               _loc4_ = STAGEDATA.ItemsRef.getItemData(_loc1_);
               if(_loc4_ != null)
               {
                  if(InteractiveSprite.hitTest(this,_loc4_,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster).length)
                  {
                     InteractiveSprite.hitTest(this,_loc4_,HitBoxSprite.REVERSE,HitBoxSprite.HIT,this.reactionReverse,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,_loc4_,HitBoxSprite.REVERSE,HitBoxSprite.ATTACK,this.reactionReverse,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,_loc4_,HitBoxSprite.ATTACK,HitBoxSprite.HIT,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                  }
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
                  }
               }
               _loc1_++;
            }
         }
         if(HasMC)
         {
            m_sprite.stop();
            Utils.recursiveMovieClipPlay(m_sprite,false);
         }
      }
      
      override protected function validateBypass(param1:AttackDamage) : Boolean
      {
         if(param1.BypassEnemies)
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
         if(!super.validateHit(param1,param2,param3) || inState(EState.DEAD))
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
         var _loc6_:MovieClip = null;
         var _loc13_:Boolean = false;
         if(!this.validateHit(param1,false,true))
         {
            return false;
         }
         var _loc7_:Number = m_damage;
         var _loc8_:Number = param1.Damage <= 0 ? 0 : Number(Utils.calculateChargeDamage(param1));
         var _loc9_:Number = m_baseStats.Stamina > 0 ? Number(Utils.calculateVelocity(Utils.calculateKnockback(param1.KBConstant,param1.Power,param1.WeightKB,0,0,this.m_enemyStats.Weight1 * _loc3_,false,1,param1.AttackRatio))) : Number(Utils.calculateVelocity(Utils.calculateKnockback(param1.KBConstant,param1.Power,param1.WeightKB,_loc8_,_loc7_,this.m_enemyStats.Weight1 * _loc3_,false,1,param1.AttackRatio)));
         var _loc10_:Number = 0;
         var _loc11_:Number = 0;
         var _loc12_:Number = 1;
         _loc3_ = 1;
         var _loc14_:Boolean = true;
         var _loc15_:Number = 0;
         var _loc16_:Number = 0;
         var _loc17_:Number = param1.BypassLaunchResistance ? 0 : (m_attack.LaunchResistance > 0 ? m_attack.LaunchResistance : 0);
         var _loc18_:Number = _loc17_ > 0 ? _loc9_ - _loc17_ : 0;
         var _loc19_:Number = _loc17_ > 0 ? -_loc17_ : 0;
         if(inState(CState.ATTACKING) && (m_attack.SuperArmor && !param1.BypassSuperArmor || m_attack.HeavyArmor != 0 && !param1.BypassHeavyArmor && (m_attack.HeavyArmor > 0 && _loc8_ <= m_attack.HeavyArmor || m_attack.HeavyArmor < 0 && _loc9_ <= -m_attack.HeavyArmor) || _loc19_ != 0 && !param1.BypassHeavyArmor && (_loc19_ > 0 && _loc8_ <= _loc19_ || _loc19_ < 0 && _loc9_ <= -_loc19_)))
         {
            if(_loc17_ <= 0 || _loc17_ > 0 && _loc18_ <= 0)
            {
               _loc13_ = true;
               _loc14_ = param1.HasEffect;
               _loc15_ = param1.Power;
               _loc16_ = param1.KBConstant;
               param1.Power = 0;
               param1.KBConstant = 0;
               param1.HasEffect = false;
            }
         }
         if(param1.HasEffect || !param1.HasEffect && !(isIntangible() && param1.Damage > 0))
         {
            if(m_hurtInterrupt != null && Boolean(m_hurtInterrupt({
               "target":(Boolean(param1.Owner) && Boolean(param1.Owner.APIInstance) ? param1.Owner.APIInstance.instance : null),
               "attackBoxData":param1.exportAttackDamageData(),
               "collisionRect":(param2 ? param2.BoundingBox : null)
            })))
            {
               if(_loc13_)
               {
                  param1.HasEffect = _loc14_;
                  param1.Power = _loc15_;
                  param1.KBConstant = _loc16_;
               }
               return false;
            }
            if(param1.HasEffect)
            {
               initDelayPlayback(false);
            }
            stackAttackID(param1.AttackID);
            _loc4_ = Number(Utils.calculateReversedAngle(Utils.calculateAttackDirection(param1,this),param1,this));
            if(param1.EffectID != null && param1.EffectID != null && Boolean(STAGEDATA.getQualitySettings().hit_effects))
            {
               _loc6_ = attachHurtEffect(param1.EffectID,param2,{
                  "scaleX":(0.25 + 0.75 * Math.min(param1.Damage / 16,1)) * _loc12_,
                  "scaleY":(0.25 + 0.75 * Math.min(param1.Damage / 16,1)) * _loc12_
               });
               if(_loc6_)
               {
                  _loc6_.rotation = param1.IsForward ? 180 - _loc4_ : -_loc4_;
               }
            }
            if(param1.EffectSound != null)
            {
               STAGEDATA.playSpecificSound(param1.EffectSound);
            }
            _loc5_ = param1.Damage <= 0 ? 0 : Number(Utils.calculateChargeDamage(param1));
            _loc5_ *= param1.StaleMultiplier;
            if(param1.Damage > 0 && _loc5_ <= 0)
            {
               _loc5_ = 1;
            }
            if(this.m_enemyStats.Stamina > 0)
            {
               _loc11_ = Number(Utils.calculateKnockback(param1.KBConstant,param1.Power,param1.WeightKB,0,0,this.m_enemyStats.Weight1,false,STAGEDATA.GameRef.LevelData.damageRatio,param1.AttackRatio));
            }
            else
            {
               _loc11_ = Number(Utils.calculateKnockback(param1.KBConstant,param1.Power,param1.WeightKB,_loc8_,_loc7_,this.m_enemyStats.Weight1,false,STAGEDATA.GameRef.LevelData.damageRatio,param1.AttackRatio));
            }
            _loc10_ = _loc18_ > 0 ? _loc18_ : Number(Utils.calculateVelocity(_loc11_));
            if(this.m_enemyStats.CanReceiveKnockback)
            {
               applyKnockbackSpeed(_loc10_,_loc4_);
            }
            if(this.m_enemyStats.CanReceiveDamage)
            {
               setDamage(this.m_enemyStats.Stamina > 0 ? m_damage - _loc5_ : m_damage + _loc5_);
            }
            if(_loc10_ < Character.HEAVY_KNOCKBACK_THRESHOLD || Utils.calculateHitlag(_loc11_,param1.HitLag) < Character.HEAVY_KNOCKBACK_HITLAG_THRESHOLD)
            {
               if(param1.Power >= 1000)
               {
                  CAM.shake(6);
               }
            }
            else
            {
               if(_loc10_ > 35)
               {
                  STAGEDATA.lightFlash(false);
               }
               CAM.shake(12);
            }
            if(param1.CamShake > 0)
            {
               CAM.shake(param1.CamShake);
            }
            if(param1.HasEffect)
            {
               if(m_paralysis)
               {
                  stopActionShot(false,true);
                  m_paralysisHitCount = 3;
                  startActionShot(Utils.calculateHitStun(param1.HitStun,_loc5_,param1.Shock,false));
               }
               else
               {
                  startActionShot(Utils.calculateHitStun(param1.HitStun,_loc5_,param1.Shock,false),param1.Paralysis);
               }
            }
            else if(!_loc13_)
            {
               startActionShot(-1,param1.Paralysis);
            }
            if(!m_attack.DisableLastHitUpdate)
            {
               m_lastHitID = param1.PlayerID;
               m_lastHitObject = param1;
            }
            m_eventManager.dispatchEvent(new SSF2Event(param1.HasEffect ? SSF2Event.ENEMY_HURT : SSF2Event.ENEMY_WIND,{
               "caller":this.APIInstance.instance,
               "opponent":(param1.Owner ? param1.Owner.APIInstance.instance : null),
               "attackBoxData":param1.exportAttackDamageData(),
               "collisionRect":(param2 ? param2.BoundingBox : null)
            }));
            if(_loc13_)
            {
               param1.HasEffect = _loc14_;
               param1.Power = _loc15_;
               param1.KBConstant = _loc16_;
            }
            return true;
         }
         return false;
      }
      
      protected function forceOnGround(param1:Number = 200) : void
      {
         var _loc2_:Number = m_sprite.y;
         var _loc3_:Number = 0;
         if(m_currentPlatform)
         {
            return;
         }
         while(!(m_currentPlatform = testGroundWithCoord(m_sprite.x,m_sprite.y + 1)) && _loc3_ < param1)
         {
            ++m_sprite.y;
            _loc3_++;
         }
         if(!m_currentPlatform)
         {
            m_sprite.y = _loc2_;
         }
         else
         {
            attachToGround();
         }
      }
      
      override protected function move() : void
      {
         if(!isHitStunOrParalysis())
         {
            if(this.m_enemyStats.Ghost)
            {
               m_sprite.x += m_xSpeed;
               m_sprite.y += m_ySpeed;
            }
            else
            {
               m_attemptToMove(m_xSpeed,0);
               m_attemptToMove(0,m_ySpeed);
               applyGroundInfluence();
            }
         }
      }
      
      override public function get IsFrozenInTime() : Boolean
      {
         if(Boolean(this.m_owner) && this.m_owner != this)
         {
            if(this.STAGEDATA.InTimeStop && this.m_owner is Character)
            {
               return this.m_owner.IsFrozenInTime || Boolean(STAGEDATA.getCharacterTimeStopperBypassOptions(this.m_owner.UID)) && !STAGEDATA.getCharacterTimeStopperBypassOptions(this.m_owner.UID).bypassEnemy;
            }
            return this.m_owner.IsFrozenInTime;
         }
         return this.STAGEDATA.InTimeStop;
      }
      
      override protected function PREPERFORM() : void
      {
         m_actionTimerUpdatedOnFrame = false;
         if(!STAGEDATA.FSCutscene && STAGEDATA.FSCutins <= 0)
         {
            if(m_started && HasStance && !inState(EState.DEAD) && !isHitStunOrParalysis() && !m_delayPlayback)
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
      
      override public function PERFORMALL() : void
      {
         this.PREPERFORM();
         if(m_started && !this.m_dead && !inState(EState.DEAD) && !STAGEDATA.FSCutscene && STAGEDATA.FSCutins <= 0)
         {
            if(!this.IsFrozenInTime)
            {
               checkTimers();
               this.performAttackChecks();
               this.move();
               m_forces();
               gravity();
               if(!this.m_enemyStats.Ghost)
               {
                  m_groundCollisionTest();
               }
               updateSelfPlatform();
            }
            checkReflection();
            checkShadow();
            if(!this.IsFrozenInTime)
            {
               checkHitStun();
               updateCamerBox();
               this.checkDeath();
            }
         }
         this.POSTPERFORM();
      }
      
      override protected function POSTPERFORM() : void
      {
         if(!STAGEDATA.FSCutscene && STAGEDATA.FSCutins <= 0)
         {
            if(!this.IsFrozenInTime)
            {
               super.POSTPERFORM();
               m_apiInstance.update();
            }
         }
      }
   }
}


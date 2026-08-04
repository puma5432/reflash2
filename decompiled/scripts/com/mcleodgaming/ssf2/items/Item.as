package com.mcleodgaming.ssf2.items
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.api.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.enemies.Enemy;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   import flash.geom.*;
   
   public class Item extends InteractiveSprite
   {
      
      public static const ATTACK_IDLE:String = "attack_idle";
      
      public static const ATTACK_TOSS:String = "attack_toss";
      
      public static const ATTACK_HOLD:String = "attack_hold";
      
      protected var m_owner:InteractiveSprite;
      
      protected var m_linkage_id:String;
      
      protected var m_slot:int;
      
      protected var m_originalPlayerID:int;
      
      protected var m_currentHolder:Character;
      
      protected var m_previousHolder:Character;
      
      protected var m_wasZDropped:Boolean;
      
      protected var m_lastReleaseTimer:int;
      
      protected var m_time:int;
      
      protected var m_projectile:Vector.<Projectile>;
      
      protected var m_lastProjectile:int;
      
      protected var m_pickedUp:Boolean;
      
      protected var m_bounceOrig:Number;
      
      protected var m_bounce_limit:FrameTimer;
      
      protected var m_bounce_total:int;
      
      protected var m_effectSound:String;
      
      protected var m_landSound:String;
      
      protected var m_initTimer:int;
      
      protected var m_reverseTimer:int;
      
      protected var m_wasReversed:Boolean;
      
      protected var m_reverse_id:int;
      
      protected var m_richochetTimer:FrameTimer;
      
      protected var m_richochetX:Number;
      
      protected var m_richochetY:Number;
      
      protected var m_reactivationDelay:FrameTimer;
      
      protected var m_bounce_remaining:int;
      
      protected var m_frameInterrupt:Function;
      
      protected var m_itemStats:ItemData;
      
      public function Item(param1:ItemData, param2:int, param3:StageData)
      {
         var _loc5_:int = 0;
         m_baseStats = this.m_itemStats = new ItemData();
         this.m_itemStats.importData(param1.exportData());
         m_apiInstance = new SSF2Item(this.m_itemStats.ClassAPI,this);
         this.m_owner = null;
         this.m_itemStats.importData(m_apiInstance.getOwnStats());
         this.m_slot = param2;
         this.m_linkage_id = this.m_itemStats.LinkageID;
         m_sizeRatio = this.m_itemStats.SizeRatio;
         param3.ItemsRef.ItemsInUse[param2] = this;
         var _loc4_:MovieClip = ResourceManager.getLibraryMC(this.m_linkage_id);
         _loc4_.ACTIVE = true;
         super(_loc4_,param3);
         _loc4_.width *= m_sizeRatio;
         _loc4_.height *= m_sizeRatio;
         m_currentPlatform = null;
         this.m_frameInterrupt = null;
         m_player_id = 0;
         this.m_originalPlayerID = 0;
         this.m_currentHolder = null;
         this.m_previousHolder = null;
         m_team_id = -1;
         m_sprite.uid = m_uid;
         m_gravity = this.m_itemStats.Gravity;
         m_max_ySpeed = this.m_itemStats.MaxGravity;
         m_xSpeed = 0;
         m_ySpeed = 0;
         this.m_initTimer = 0;
         this.m_time = 0;
         m_lastAttackID = new Array(15);
         m_lastAttackIndex = 0;
         m_width = this.m_itemStats.Width;
         m_height = this.m_itemStats.Height;
         this.m_pickedUp = false;
         m_collision = new Collision();
         this.m_effectSound = this.m_itemStats.EffectSound;
         this.m_landSound = this.m_itemStats.LandSound;
         this.m_lastReleaseTimer = 0;
         this.m_wasZDropped = false;
         m_attackData = this.m_itemStats.AttackDataObj;
         m_attackData.Owner = this;
         m_attackData.importProjectiles(this.m_itemStats.Projectiles);
         this.m_projectile = new Vector.<Projectile>();
         this.m_bounce_remaining = this.m_itemStats.InitialBounce ? 3 : 0;
         this.m_lastProjectile = 0;
         m_actionShot = false;
         m_actionTimer = 0;
         m_hitStunTimer = 0;
         m_hitStunToggle = false;
         this.m_reverseTimer = 0;
         this.m_wasReversed = false;
         this.m_reverse_id = 0;
         this.m_richochetTimer = new FrameTimer(2);
         this.m_richochetX = 0;
         this.m_richochetY = 0;
         m_sprite.cam_width = m_width;
         m_sprite.cam_height = m_height;
         this.m_reactivationDelay = new FrameTimer(3);
         buildHitBoxData(this.m_linkage_id);
         if(Main.DEBUG)
         {
            verifiyHitBoxData();
         }
         this.getTerrainData();
         m_state = IState.IDLE;
         m_attackData.importAttacks(m_apiInstance.getAttackStats());
         m_attackData.importItems(m_apiInstance.getItemStats());
         m_attackData.importProjectiles(m_apiInstance.getProjectileStats());
         this.m_bounceOrig = this.m_itemStats.Bounce;
         this.m_bounce_limit = new FrameTimer(this.m_itemStats.BounceLimit);
         this.m_bounce_total = 0;
         while(_loc5_ < this.m_itemStats.MaxProjectile)
         {
            this.m_projectile[_loc5_] = null;
            _loc5_++;
         }
         this.syncStats();
         m_apiInstance.initialize();
         this.Attack(Item.ATTACK_IDLE,m_facingForward);
         if(this.m_itemStats.StatsName === "cucco")
         {
            ++STAGEDATA.CuccoCount;
         }
         if(this.m_itemStats.StatsName === "assistTrophy")
         {
            ++STAGEDATA.AssistCount;
         }
         if(this.m_itemStats.StatsName === "pokeball")
         {
            ++STAGEDATA.PokemonCount;
         }
      }
      
      override public function get CurrentAnimation() : HitBoxAnimation
      {
         return m_hitBoxManager == null ? null : (m_hitBoxManager.HitBoxAnimationList.length <= 0 || !m_currentAnimationID ? null : m_hitBoxManager.getHitBoxAnimation(this.m_linkage_id + "_" + m_currentAnimationID));
      }
      
      protected function m_initFunctions() : void
      {
      }
      
      override public function setVisibility(param1:Boolean) : void
      {
         if(!this.m_pickedUp)
         {
            super.setVisibility(param1);
         }
         else
         {
            m_sprite.visible = param1;
            m_reflectionEffect.visible = param1;
         }
      }
      
      public function isReversed() : Boolean
      {
         return this.m_wasReversed;
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
      
      private function checkDeadProjectiles() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.m_projectile.length)
         {
            if(this.m_projectile[_loc1_] != null && this.m_projectile[_loc1_].Dead)
            {
               this.m_projectile[_loc1_] = null;
            }
            _loc1_++;
         }
      }
      
      public function destroyAllProjectiles() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.m_itemStats.MaxProjectile && _loc1_ < this.m_projectile.length)
         {
            if(this.m_projectile[_loc1_] != null)
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
         while(_loc3_ < this.m_itemStats.MaxProjectile && _loc3_ < this.m_projectile.length)
         {
            if(this.m_projectile[_loc3_] != null && this.m_projectile[_loc3_].ProjectileAttackObj.StatsName == param1 && (_loc2_ < 0 || this.m_projectile[_loc3_].Time > this.m_projectile[_loc2_].Time))
            {
               _loc2_ = _loc3_;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function fireProjectile(param1:*, param2:Number = 0, param3:Number = 0, param4:Boolean = false, param5:Object = null) : Projectile
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Point = null;
         var _loc9_:Boolean = false;
         var _loc10_:int = 0;
         var _loc11_:Projectile = null;
         var _loc12_:ProjectileAttack = null;
         if(param1 as String)
         {
            _loc12_ = m_attackData.getProjectile(param1);
         }
         else
         {
            _loc12_ = new ProjectileAttack();
            _loc12_.importData(param1);
         }
         if(!param5)
         {
            param5 = {};
         }
         if(_loc12_ != null)
         {
            _loc6_ = 0;
            while(_loc6_ < this.m_itemStats.MaxProjectile && _loc6_ < this.m_projectile.length && !_loc11_)
            {
               if((this.m_projectile[_loc6_] == null || this.m_projectile[_loc6_].inState(PState.DEAD) || _loc12_.LimitOverwrite) && _loc12_.LinkageID != null && (this.getProjectileLimit(_loc12_.LinkageID) < _loc12_.Limit || _loc12_.LimitOverwrite))
               {
                  _loc7_ = _loc6_;
                  if(_loc12_.LimitOverwrite && this.getProjectileLimit(_loc12_.LinkageID) >= _loc12_.Limit)
                  {
                     _loc6_ = int(this.getIndexOfOldestProjectile(_loc12_.LinkageID));
                     if(_loc6_ < 0)
                     {
                        return null;
                     }
                     this.m_projectile[_loc6_].destroy();
                     this.m_projectile[_loc6_] = null;
                  }
                  else if(_loc12_.LimitOverwrite)
                  {
                     _loc6_ = int(this.getIndexOfOldestProjectile(_loc12_.StatsName));
                     _loc10_ = 0;
                     while(_loc10_ < this.m_projectile.length)
                     {
                        if(this.m_projectile[_loc10_] == null)
                        {
                           _loc6_ = _loc10_;
                           break;
                        }
                        _loc10_++;
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
                  _loc8_ = new Point(m_sprite.x,m_sprite.y);
                  _loc9_ = m_facingForward;
                  if(Boolean(this.m_currentHolder) && this.m_pickedUp)
                  {
                     _loc8_.x = this.m_currentHolder.X;
                     _loc8_.y = this.m_currentHolder.Y;
                     _loc9_ = this.m_currentHolder.isFacingRight();
                  }
                  this.m_projectile[_loc6_] = new Projectile({
                     "owner":this,
                     "player_id":m_player_id,
                     "x_start":_loc8_.x,
                     "y_start":_loc8_.y,
                     "sizeRatio":m_sizeRatio,
                     "facingForward":_loc9_,
                     "chargetime":param5.chargetime || m_attack.ChargeTime,
                     "chargetime_max":param5.chargetime_max || m_attack.ChargeTimeMax,
                     "frame":_loc12_.StatsName + "_proj",
                     "staleMultiplier":1,
                     "sizeStatus":1,
                     "terrains":m_terrains,
                     "platforms":m_platforms,
                     "team_id":m_team_id,
                     "keys":(this.m_currentHolder ? this.m_currentHolder.ControlSettings : null),
                     "volume_sfx":1,
                     "volume_vfx":1
                  },_loc12_,STAGEDATA);
                  _loc11_ = this.m_projectile[_loc6_];
                  this.m_lastProjectile = _loc6_;
                  if(param2 != 0 || param3 != 0)
                  {
                     if(param4)
                     {
                        this.m_projectile[_loc6_].X = param2;
                        this.m_projectile[_loc6_].Y = param3;
                        this.m_projectile[_loc6_].X += m_facingForward ? _loc12_.XOffset * m_sizeRatio : -_loc12_.XOffset * m_sizeRatio;
                        this.m_projectile[_loc6_].Y += _loc12_.YOffset * m_sizeRatio;
                     }
                     else
                     {
                        this.m_projectile[_loc6_].X += m_facingForward ? param2 : -param2;
                        this.m_projectile[_loc6_].Y += param3 * m_sizeRatio;
                        this.m_projectile[_loc6_].X += m_facingForward ? _loc12_.XOffset * m_sizeRatio : -_loc12_.XOffset * m_sizeRatio;
                        this.m_projectile[_loc6_].Y += _loc12_.YOffset * m_sizeRatio;
                     }
                  }
                  else
                  {
                     this.m_projectile[_loc6_].X += m_facingForward ? _loc12_.XOffset * m_sizeRatio : -_loc12_.XOffset * m_sizeRatio;
                     this.m_projectile[_loc6_].Y += _loc12_.YOffset * m_sizeRatio;
                  }
                  break;
               }
               _loc6_++;
            }
         }
         return _loc11_;
      }
      
      public function getTerrainData() : void
      {
      }
      
      protected function m_checkReverse() : void
      {
         if(!inState(IState.DEAD))
         {
            if(this.m_reverseTimer > 0)
            {
               --this.m_reverseTimer;
            }
         }
      }
      
      protected function m_itemAttack() : void
      {
         if(HasAttackBox)
         {
            if(this.m_currentHolder)
            {
               m_attack.XLoc = this.m_currentHolder.X;
               m_attack.YLoc = this.m_currentHolder.Y;
            }
            else
            {
               m_attack.XLoc = m_sprite.x;
               m_attack.YLoc = m_sprite.y;
            }
         }
         if(!isHitStunOrParalysis())
         {
            ++m_attack.ExecTime;
            ++m_attack.RefreshRateTimer;
            if(m_attack.RefreshRate > 0 && m_attack.RefreshRateReady && m_attack.RefreshRateTimer % m_attack.RefreshRate == 0)
            {
               m_attack.AttackID = Utils.getUID();
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
            this.Attack(param1,m_facingForward);
            if(param2 !== null)
            {
               stancePlayFrame(param2);
            }
            return true;
         }
         return false;
      }
      
      public function Attack(param1:String, param2:Boolean) : void
      {
         var _loc3_:AttackObject = m_attackData.getAttack(param1);
         _loc3_.OverrideMap.clear();
         m_attack.simpleReset();
         m_attack.Frame = param1;
         m_attack.ExecTime = 0;
         m_attack.AttackID = Utils.getUID();
         m_attack.ID = Utils.getUID();
         m_attack.ChargeTime = _loc3_.ChargeTime;
         m_attack.ChargeTimeMax = _loc3_.ChargeTimeMax;
         m_attack.ChargeRetain = _loc3_.ChargeRetain;
         m_attack.ResetMovement = _loc3_.ResetMovement;
         m_attack.RefreshRate = _loc3_.RefreshRate;
         m_attack.ForceComboContinue = _loc3_.ForceComboContinue;
         m_attack.AirEase = _loc3_.AirEase;
         m_attack.RefreshRateReady = false;
         m_attack.IsForward = param2;
         m_attack.HasClanked = false;
         playFrame(m_attack.Frame);
         if(!_loc3_.ChargeRetain)
         {
            _loc3_.ChargeTime = 0;
         }
         switch(param1)
         {
            case "attack_idle":
               this.setState(IState.IDLE);
               break;
            case "attack_hold":
               this.setState(IState.HOLD);
               break;
            case "attack_toss":
               this.setState(IState.TOSS);
         }
      }
      
      override public function reactionShield(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         var _loc3_:Character = param1 as Character ? Character(param1) : null;
         var _loc4_:AttackDamage = m_attackData.getAttackBoxData(m_attackCache.Frame,param2.FirstHitBox.Name).syncState(m_attackCache);
         if(_loc3_)
         {
            if(_loc4_.BypassShield && param1.takeDamage(_loc4_,param2.OverlapHitBox))
            {
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_CONNECT,{
                  "caller":this.APIInstance.instance,
                  "receiver":param1.APIInstance.instance,
                  "attackBoxData":_loc4_.exportAttackDamageData()
               }));
               this.handleHit(param1,_loc4_,param2);
               return true;
            }
            if(_loc3_.takeShieldDamage(_loc4_,param2.OverlapHitBox))
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
      
      override public function reactionCounter(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         if(inState(IState.DEAD))
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
      
      override public function reactionClank(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         if(inState(IState.DEAD))
         {
            return false;
         }
         var _loc3_:AttackDamage = m_attackData.getAttackBoxData(m_attackCache.Frame,param2.FirstHitBox.Name).syncState(m_attackCache);
         var _loc4_:AttackDamage = param1.AttackDataObj.getAttackBoxData(param1.AttackStateData.Frame,param2.SecondHitBox.Name).syncState(param1.AttackCache);
         var _loc5_:Number = Number(Utils.calculateChargeDamage(_loc3_));
         var _loc6_:Number = Number(Utils.calculateChargeDamage(_loc4_));
         var _loc7_:Boolean = _loc3_.Damage === 0 && _loc3_.ReverseProjectile && param1 is Projectile || _loc3_.Damage === 0 && _loc3_.ReverseItem && param1 is Item || _loc3_.Damage === 0 && _loc3_.ReverseCharacter && param1 is Character || _loc4_.Damage === 0 && _loc4_.ReverseItem;
         var _loc8_:Boolean = _loc3_.Damage === 0 && Boolean(_loc3_.HitStunProjectile) && param1 is Projectile;
         if(!_loc3_.HasEffect || !_loc4_.HasEffect || isInvincible() || param1.isInvincible() || _loc3_.IsThrow || _loc4_.IsThrow || (!m_collision.ground || !param1.CollisionObj.ground || _loc3_.IsAirAttack || _loc4_.IsAirAttack) && inState(IState.HOLD) || !this.validateHit(_loc4_) || !param1.validateHit(_loc3_) || _loc7_ || _loc8_)
         {
            return false;
         }
         if(!(_loc3_.PlayerID == _loc4_.PlayerID && !_loc3_.HurtSelf) && !(_loc3_.TeamID > 0 && _loc3_.TeamID == _loc4_.TeamID && (_loc3_.HurtSelf || STAGEDATA.TeamDamage)))
         {
            if(Utils.fastAbs(_loc5_ - _loc6_) < 8 && _loc3_.Priority != -1 && _loc4_.Priority != -1)
            {
               if(m_attack.HasClanked || param1.AttackStateData.HasClanked || param1 is Item && !Item(param1).PickedUp || !this.m_pickedUp)
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
               return true;
            }
            if(_loc5_ - _loc6_ >= 8 && _loc3_.Priority != -1 && _loc4_.Priority != -1)
            {
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
               if(param1.takeDamage(_loc3_,param2.OverlapHitBox))
               {
                  this.handleHit(param1,_loc3_,param2);
               }
               return true;
            }
            if(_loc5_ - _loc6_ <= -8 && _loc3_.Priority != -1 && _loc4_.Priority != -1)
            {
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
               if(this.takeDamage(_loc4_,param2.OverlapHitBox))
               {
                  param1.handleHit(this,_loc4_,param2);
               }
               return true;
            }
         }
         return false;
      }
      
      override public function clang(param1:AttackDamage, param2:HitBoxCollisionResult) : void
      {
         initDelayPlayback(true);
         stackAttackID(param1.AttackID);
         m_skipAttackCollisionTests = true;
         if(Boolean(this.m_currentHolder) && this.m_pickedUp)
         {
            this.m_currentHolder.clang(param1,param2);
         }
         else
         {
            startActionShot(param1.HitStun);
         }
      }
      
      override public function handleHit(param1:InteractiveSprite, param2:AttackDamage, param3:HitBoxCollisionResult) : void
      {
         m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_HIT,{
            "caller":this.APIInstance.instance,
            "receiver":param1.APIInstance.instance,
            "attackBoxData":param2.exportAttackDamageData()
         }));
         startActionShot(Utils.calculateSelfHitStun(param2.SelfHitStun,Utils.calculateChargeDamage(param2)));
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
      
      override public function cancelAttack(param1:AttackDamage, param2:HitBoxCollisionResult) : void
      {
         m_skipAttackCollisionTests = true;
         if(this.m_pickedUp && Boolean(this.m_currentHolder))
         {
            this.m_currentHolder.cancelAttack(param1,param2);
         }
         else
         {
            this.destroy();
         }
      }
      
      override public function reactionHit(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         var _loc3_:AttackDamage = m_attackData.getAttackBoxData(m_attackCache.Frame,param2.FirstHitBox.Name).syncState(m_attackCache);
         m_attack.RefreshRateReady = true;
         if(param1.takeDamage(_loc3_,param2.OverlapHitBox))
         {
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_CONNECT,{
               "caller":this.APIInstance.instance,
               "receiver":param1.APIInstance.instance,
               "attackBoxData":_loc3_.exportAttackDamageData()
            }));
            this.handleHit(param1,_loc3_,param2);
            return true;
         }
         if(param1.validateHit(_loc3_,true) && param1.isInvincible())
         {
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_CONNECT,{
               "caller":this.APIInstance.instance,
               "receiver":param1.APIInstance.instance,
               "attackBoxData":_loc3_.exportAttackDamageData()
            }));
            return true;
         }
         return false;
      }
      
      override public function reactionTouch(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         if(!param1.Invincible)
         {
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ITEM_TOUCH,{
               "caller":this.APIInstance.instance,
               "receiver":param1.APIInstance.instance
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
         var _loc6_:Vector.<HitBoxCollisionResult> = null;
         var _loc7_:Array = null;
         var _loc8_:TargetTestTarget = null;
         if(m_bypassCollisionTesting || !m_hitBoxManager.HasHitBoxes || m_attackCollisionTestsPreProcessed)
         {
            return;
         }
         m_attackCache.syncState(m_attack);
         _loc1_ = 0;
         while(_loc1_ < STAGEDATA.Characters.length && !inState(IState.DEAD))
         {
            _loc2_ = STAGEDATA.Characters[_loc1_];
            if(_loc2_ != null && !_loc2_.StandBy && !_loc2_.Dead && !_loc2_.inState(CState.STAR_KO) && !_loc2_.inState(CState.SCREEN_KO) && !_loc2_.inState(CState.REVIVAL))
            {
               InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.ATTACK,HitBoxSprite.SHIELD,this.reactionShield,STAGEDATA.HitBoxProcessorInstance);
               if(InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster).length)
               {
                  InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.ATTACK,HitBoxSprite.ATTACK,this.reactionClank,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.ATTACK,HitBoxSprite.ABSORB,this.reactionAbsorb,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.ATTACK,HitBoxSprite.HIT,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.ATTACK,HitBoxSprite.EGG,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.ATTACK,HitBoxSprite.FREEZE,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.COUNTER,HitBoxSprite.ATTACK,this.reactionCounter,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.HIT,HitBoxSprite.HIT,this.reactionTouch,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(_loc2_,this,HitBoxSprite.CATCH,HitBoxSprite.HIT,_loc2_.reactionCatch,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(_loc2_,this,HitBoxSprite.CATCH,HitBoxSprite.CATCH,_loc2_.reactionCatch,STAGEDATA.HitBoxProcessorInstance);
               }
            }
            _loc1_++;
         }
         if(this.m_currentHolder)
         {
            InteractiveSprite.hitTest(this,this.m_currentHolder,HitBoxSprite.ATTACK,HitBoxSprite.SHIELD,this.reactionShield,STAGEDATA.HitBoxProcessorInstance);
            InteractiveSprite.hitTest(this,this.m_currentHolder,HitBoxSprite.ATTACK,HitBoxSprite.HIT,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
            InteractiveSprite.hitTest(this,this.m_currentHolder,HitBoxSprite.HIT,HitBoxSprite.HIT,this.reactionTouch,STAGEDATA.HitBoxProcessorInstance);
         }
         _loc1_ = 0;
         while(_loc1_ < STAGEDATA.Projectiles.length && !inState(IState.DEAD))
         {
            _loc4_ = STAGEDATA.Projectiles[_loc1_];
            if(_loc4_ != null)
            {
               if(InteractiveSprite.hitTest(this,_loc4_,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster).length)
               {
                  InteractiveSprite.hitTest(this,_loc4_,HitBoxSprite.ATTACK,HitBoxSprite.ATTACK,this.reactionAttackReverse,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc4_,HitBoxSprite.ATTACK,HitBoxSprite.ATTACK,this.reactionClank,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc4_,HitBoxSprite.REVERSE,HitBoxSprite.ATTACK,this.reactionReverse,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc4_,HitBoxSprite.REVERSE,HitBoxSprite.HIT,this.reactionReverse,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc4_,HitBoxSprite.HIT,HitBoxSprite.HIT,this.reactionTouch,STAGEDATA.HitBoxProcessorInstance);
               }
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < STAGEDATA.Enemies.length && !inState(IState.DEAD))
         {
            _loc3_ = STAGEDATA.Enemies[_loc1_];
            if(_loc3_ != null)
            {
               if(InteractiveSprite.hitTest(this,_loc3_,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster).length)
               {
                  InteractiveSprite.hitTest(this,_loc3_,HitBoxSprite.ATTACK,HitBoxSprite.HIT,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc3_,HitBoxSprite.HIT,HitBoxSprite.HIT,this.reactionTouch,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc3_,HitBoxSprite.REVERSE,HitBoxSprite.ATTACK,this.reactionReverse,STAGEDATA.HitBoxProcessorInstance);
               }
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < STAGEDATA.ItemsRef.MAXITEMS && !inState(IState.DEAD))
         {
            _loc5_ = STAGEDATA.ItemsRef.getItemData(_loc1_);
            if(_loc5_ != null && _loc5_ != this)
            {
               if(InteractiveSprite.hitTest(this,_loc5_,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster).length)
               {
                  InteractiveSprite.hitTest(this,_loc5_,HitBoxSprite.ATTACK,HitBoxSprite.ATTACK,this.reactionAttackReverse,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc5_,HitBoxSprite.ATTACK,HitBoxSprite.ATTACK,this.reactionClank,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc5_,HitBoxSprite.REVERSE,HitBoxSprite.ATTACK,this.reactionReverse,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc5_,HitBoxSprite.REVERSE,HitBoxSprite.HIT,this.reactionReverse,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc5_,HitBoxSprite.ATTACK,HitBoxSprite.HIT,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc5_,HitBoxSprite.HIT,HitBoxSprite.HIT,this.reactionTouch,STAGEDATA.HitBoxProcessorInstance);
               }
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < STAGEDATA.Targets.length && !inState(IState.DEAD))
         {
            _loc8_ = STAGEDATA.Targets[_loc1_];
            if(_loc8_ != null)
            {
               if(InteractiveSprite.hitTest(this,_loc8_,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster).length)
               {
                  InteractiveSprite.hitTest(this,_loc8_,HitBoxSprite.ATTACK,HitBoxSprite.HIT,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc8_,HitBoxSprite.HIT,HitBoxSprite.HIT,this.reactionTouch,STAGEDATA.HitBoxProcessorInstance);
               }
            }
            _loc1_++;
         }
         if(HasMC)
         {
            m_sprite.stop();
            Utils.recursiveMovieClipPlay(m_sprite,false);
         }
      }
      
      protected function m_checkDeathBounds() : void
      {
         if(Boolean(!inState(IState.DEAD) && !this.m_itemStats.SurviveDeathBounds) && Boolean(STAGEDATA.DeathBounds) && (m_sprite.x < STAGEDATA.DeathBounds.x || m_sprite.x > STAGEDATA.DeathBounds.x + STAGEDATA.DeathBounds.width || m_sprite.y < STAGEDATA.DeathBounds.y || m_sprite.y > STAGEDATA.DeathBounds.y + STAGEDATA.DeathBounds.height))
         {
            STAGEDATA.ItemsRef.killItem(this.m_slot);
         }
      }
      
      override public function reverse(param1:int, param2:int, param3:Boolean) : Boolean
      {
         if(this.m_reverseTimer <= 0 && this.m_itemStats.CanBeReversed && inState(IState.TOSS) && this.m_reverse_id !== param1 && !(!this.m_wasReversed && param1 === m_player_id) && !(param2 == m_team_id && m_team_id > 0 && !STAGEDATA.TeamDamage))
         {
            if(param3)
            {
               m_attack.IsForward = true;
               this.m_faceRight();
            }
            else
            {
               m_attack.IsForward = false;
               this.m_faceLeft();
            }
            this.m_reverseTimer = 5;
            this.m_reverse_id = param1;
            m_team_id = param2;
            m_player_id = param1;
            this.m_wasReversed = true;
            m_xSpeed *= -1;
            m_ySpeed *= -1;
            if(this.m_owner)
            {
               this.setOwnerAPI(STAGEDATA.getPlayerByID(param1));
            }
            return true;
         }
         return false;
      }
      
      protected function m_checkDead() : void
      {
         this.checkDeadProjectiles();
         if(this.m_itemStats.TimeMax > 0 && !inState(IState.DEAD) && !this.m_pickedUp)
         {
            ++this.m_time;
            if(this.m_time >= this.m_itemStats.TimeMax && !this.m_pickedUp && m_collision.ground)
            {
               this.destroy();
            }
         }
      }
      
      private function m_calcFlyingAngle() : void
      {
         var _loc1_:Number = NaN;
         if(this.m_itemStats.Rotate && !(m_xSpeed == 0 && m_ySpeed == 0))
         {
            _loc1_ = Number(Utils.getAngleBetween(new Point(0,0),new Point(m_xSpeed,m_ySpeed)));
            _loc1_ = Number(Utils.forceBase360(m_facingForward ? -_loc1_ : -_loc1_ + 180));
            m_sprite.rotation = _loc1_;
         }
      }
      
      protected function setVar(param1:String, param2:*) : void
      {
         m_sprite[param1] = param2;
      }
      
      protected function getVar(param1:String, param2:*) : Boolean
      {
         if(m_sprite[param1] == param2)
         {
            return true;
         }
         return false;
      }
      
      public function get Dangerous() : Boolean
      {
         return this.m_itemStats.Dangerous;
      }
      
      public function get InheritPalette() : Boolean
      {
         return this.m_itemStats.InheritPalette;
      }
      
      public function get ItemInstance() : MovieClip
      {
         return m_sprite;
      }
      
      public function get SlideDecay() : Number
      {
         return this.m_itemStats.SlideDecay;
      }
      
      public function get TossSpeed() : Number
      {
         return this.m_itemStats.TossSpeed;
      }
      
      public function get Slot() : Number
      {
         return this.m_slot;
      }
      
      public function get OriginalPlayerID() : int
      {
         return this.m_originalPlayerID;
      }
      
      public function set OriginalPlayerID(param1:int) : void
      {
         this.m_originalPlayerID = param1;
      }
      
      public function get PlayerID() : int
      {
         return m_player_id;
      }
      
      public function set PlayerID(param1:int) : void
      {
         m_player_id = param1;
      }
      
      public function get TeamID() : int
      {
         return m_team_id;
      }
      
      public function set TeamID(param1:int) : void
      {
         m_team_id = param1;
      }
      
      public function get Dead() : Boolean
      {
         return inState(IState.DEAD);
      }
      
      public function get ItemStats() : ItemData
      {
         return this.m_itemStats;
      }
      
      public function get PickedUp() : Boolean
      {
         return this.m_pickedUp;
      }
      
      public function set PickedUp(param1:Boolean) : void
      {
         if(param1)
         {
            this.m_bounce_remaining = 0;
         }
         this.m_pickedUp = param1;
         if(this.m_pickedUp)
         {
            stopActionShot();
            this.m_lastReleaseTimer = 999;
            this.toHeld();
         }
         else
         {
            this.m_previousHolder = this.m_currentHolder;
            this.m_currentHolder = null;
            this.m_lastReleaseTimer = 0;
            m_sprite.alpha = 1;
            this.toIdle();
            resetRotation();
         }
      }
      
      public function get CurrentAttackState() : AttackState
      {
         return m_attack;
      }
      
      public function get EffectSound() : String
      {
         return this.m_effectSound;
      }
      
      public function get LinkageID() : String
      {
         return this.m_linkage_id;
      }
      
      public function get CanPickup() : Boolean
      {
         return this.m_itemStats.CanPickup;
      }
      
      public function get CanBeReversed() : Boolean
      {
         return this.m_itemStats.CanBeReversed;
      }
      
      public function get CanBackToss() : Boolean
      {
         return this.m_itemStats.CanBackToss;
      }
      
      public function get CanJumpWith() : Boolean
      {
         return this.m_itemStats.CanJumpWith;
      }
      
      public function get CanAttackWith() : Boolean
      {
         return this.m_itemStats.CanAttackWith;
      }
      
      public function get CanHangWith() : Boolean
      {
         return this.m_itemStats.CanHangWith;
      }
      
      public function get CanShieldWith() : Boolean
      {
         return this.m_itemStats.CanShieldWith;
      }
      
      public function get LastProjectile() : Projectile
      {
         return this.getCurrentProjectile();
      }
      
      public function get IsSmashBall() : Boolean
      {
         return this.m_itemStats.LinkageID === "smashball";
      }
      
      public function get WasReversed() : Boolean
      {
         return this.m_wasReversed;
      }
      
      public function get JustReversed() : Boolean
      {
         return Boolean(this.m_reverseTimer > 0);
      }
      
      public function set LetGo(param1:Boolean) : void
      {
         m_attack.LetGo = param1;
      }
      
      public function get ClassID() : String
      {
         return this.m_itemStats.ClassID;
      }
      
      public function get DisableFlip() : Boolean
      {
         return this.m_itemStats.DisableFlip;
      }
      
      public function get ReleaseTimer() : int
      {
         return this.m_lastReleaseTimer;
      }
      
      public function get WasZDropped() : Boolean
      {
         return this.m_wasZDropped;
      }
      
      public function get FrameInterrupt() : Function
      {
         return this.m_frameInterrupt;
      }
      
      public function set FrameInterrupt(param1:Function) : void
      {
         this.m_frameInterrupt = param1;
      }
      
      public function get PreviousHolder() : Character
      {
         return this.m_previousHolder;
      }
      
      public function getOwner() : InteractiveSprite
      {
         return this.m_owner;
      }
      
      public function resetTime() : void
      {
         this.m_time = 0;
      }
      
      public function getDangerous() : Boolean
      {
         return this.m_itemStats.Dangerous;
      }
      
      public function getItemStat(param1:String) : *
      {
         return this.m_itemStats.getVar(param1);
      }
      
      public function updateItemStats(param1:Object) : void
      {
         this.m_itemStats.importData(param1);
         this.syncStats();
      }
      
      override protected function syncStats() : void
      {
         m_gravity = this.m_itemStats.Gravity;
         m_max_ySpeed = this.m_itemStats.MaxGravity;
         m_width = this.m_itemStats.Width;
         m_height = this.m_itemStats.Height;
      }
      
      override public function getLinkageID() : String
      {
         return this.m_linkage_id;
      }
      
      public function activate(param1:AttackDamage, param2:Class = null) : void
      {
      }
      
      public function reactivate(param1:AttackDamage, param2:Class = null) : void
      {
      }
      
      public function SetPlayer(param1:Number) : void
      {
         this.m_currentHolder = STAGEDATA.getCharacterByUID(param1);
         this.m_owner = this.m_currentHolder;
         if(this.m_currentHolder)
         {
            m_player_id = this.m_currentHolder.ID;
            this.m_previousHolder = this.m_currentHolder;
            this.m_wasReversed = false;
            m_team_id = this.m_currentHolder.Team;
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ITEM_PICKUP,{
               "caller":this.APIInstance.instance,
               "holder":this.m_currentHolder.APIInstance.instance
            }));
         }
      }
      
      public function inheritPalette() : void
      {
         if(this.m_itemStats.InheritPalette && Boolean(this.m_currentHolder))
         {
            this.m_currentHolder.applyPalette(m_sprite);
            setPaletteSwap(this.m_currentHolder.PaletteSwapData,this.m_currentHolder.PaletteSwapPAData);
         }
      }
      
      protected function findClosestOpponent(param1:Number = -1, param2:Number = 0) : Target
      {
         var _loc3_:Character = null;
         var _loc4_:Number = NaN;
         var _loc6_:Boolean = false;
         var _loc8_:int = 0;
         var _loc5_:Target = new Target();
         var _loc7_:Number = 0;
         while(_loc8_ < STAGEDATA.Characters.length)
         {
            _loc3_ = STAGEDATA.Characters[_loc8_];
            if(param2 != _loc3_.Team && param1 != _loc3_.ID && !_loc3_.StandBy && _loc3_.MC.parent != null)
            {
               _loc4_ = this.getDistanceFrom(_loc3_.X,_loc3_.Y);
               if(_loc5_.CurrentTarget == null || _loc4_ < _loc5_.Distance)
               {
                  _loc5_.CurrentTarget = _loc3_;
                  _loc5_.setDistance(new Point(m_sprite.x,m_sprite.y));
               }
            }
            _loc8_++;
         }
         if(_loc5_.CurrentTarget == null)
         {
            return null;
         }
         return _loc5_;
      }
      
      public function Toss(param1:Number, param2:Number, param3:Number, param4:Number, param5:Boolean = false) : void
      {
         this.m_wasZDropped = param5;
         this.PickedUp = false;
         m_sprite.x = param1;
         m_sprite.y = param2;
         m_xSpeed = Utils.calculateXSpeed(param3,param4);
         m_ySpeed = -Utils.calculateYSpeed(param3,param4);
         unnattachFromGround();
         this.Attack(Item.ATTACK_TOSS,m_facingForward);
         m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ITEM_TOSSED,{
            "caller":this.APIInstance.instance,
            "opponent":(this.m_currentHolder ? this.m_currentHolder.APIInstance.instance : null)
         }));
      }
      
      public function Drop(param1:Boolean = false) : void
      {
         m_xSpeed = 0;
         m_ySpeed = 0;
         this.m_wasZDropped = param1;
         this.PickedUp = false;
         this.playGlobalSound("itemdrop");
      }
      
      override protected function validateBypass(param1:AttackDamage) : Boolean
      {
         if(param1.BypassItems)
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
         if(!super.validateHit(param1,param2,param3) || inState(IState.DEAD))
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
         if(param1.HasEffect || !param1.HasEffect && !(isIntangible() && param1.Damage > 0))
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
            if(m_attack.ChargeRetain)
            {
               m_attack.ChargeTime = 0;
            }
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
            if(!this.IsSmashBall)
            {
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
            }
            if(this.m_itemStats.Stamina > 0)
            {
               _loc14_ = Number(Utils.calculateKnockback(param1.KBConstant,param1.Power,param1.WeightKB,0,0,this.m_itemStats.Weight1,false,STAGEDATA.GameRef.LevelData.damageRatio,param1.AttackRatio));
            }
            else
            {
               _loc14_ = Number(Utils.calculateKnockback(param1.KBConstant,param1.Power,param1.WeightKB,_loc11_,_loc10_,this.m_itemStats.Weight1,false,STAGEDATA.GameRef.LevelData.damageRatio,param1.AttackRatio));
            }
            _loc13_ = Number(Utils.calculateVelocity(_loc14_));
            if(this.m_itemStats.CanReceiveKnockback)
            {
               applyKnockbackSpeed(_loc13_,_loc3_);
               if(m_yKnockback < 0)
               {
                  unnattachFromGround();
               }
            }
            if(this.m_itemStats.CanReceiveDamage)
            {
               setDamage(this.m_itemStats.Stamina > 0 ? m_damage - _loc4_ : m_damage + _loc4_);
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
            m_eventManager.dispatchEvent(new SSF2Event(param1.HasEffect ? SSF2Event.ITEM_HURT : SSF2Event.ITEM_WIND,{
               "caller":this.APIInstance.instance,
               "opponent":(param1.Owner ? param1.Owner.APIInstance.instance : null),
               "attackBoxData":param1.exportAttackDamageData(),
               "collisionRect":(param2 ? param2.BoundingBox : null)
            }));
            return true;
         }
         return false;
      }
      
      public function destroy(param1:* = null) : void
      {
         this.kill();
      }
      
      public function getHolder() : Character
      {
         return this.m_currentHolder;
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
         m_player_id = param1 ? param1.ID : -1;
         if(!param1)
         {
            m_player_id = -1;
            m_team_id = -1;
         }
      }
      
      public function getHolderAPI() : *
      {
         if(Boolean(this.m_currentHolder) && this.m_pickedUp)
         {
            return this.m_currentHolder.APIInstance.instance;
         }
         return null;
      }
      
      public function setHolderAPI(param1:Character) : void
      {
         if(Boolean(param1) && Boolean(!param1.ItemObj) && !this.m_pickedUp)
         {
            m_player_id = param1.ID;
            m_team_id = param1.Team;
            this.PickedUp = true;
            this.SetPlayer(param1.UID);
         }
      }
      
      public function toIdle(param1:* = null) : void
      {
         disableDelayPlayback();
         this.Attack(Item.ATTACK_IDLE,m_facingForward);
      }
      
      public function toHeld(param1:* = null) : void
      {
         disableDelayPlayback();
         this.Attack(Item.ATTACK_HOLD,m_facingForward);
      }
      
      public function toToss(param1:* = null) : void
      {
         if(!this.m_itemStats.CanToss)
         {
            return;
         }
         disableDelayPlayback();
         this.Attack(Item.ATTACK_TOSS,m_facingForward);
      }
      
      private function kill() : void
      {
         if(!inState(IState.DEAD))
         {
            m_skipAttackCollisionTests = true;
            m_skipAttackProcessing = true;
            if(this.m_itemStats.StatsName === "cucco")
            {
               --STAGEDATA.CuccoCount;
            }
            if(this.m_itemStats.StatsName === "assistTrophy")
            {
               --STAGEDATA.AssistCount;
            }
            if(this.m_itemStats.StatsName === "pokeball")
            {
               --STAGEDATA.PokemonCount;
            }
            STAGEDATA.CamRef.deleteTarget(m_sprite);
            STAGEDATA.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.GAME_ITEM_DESTROYED,{"item":this.APIInstance.instance}));
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ITEM_DESTROYED,{"caller":this.APIInstance.instance}));
            if(Boolean(this.m_pickedUp) && Boolean(this.m_currentHolder) && Boolean(this.m_currentHolder.ItemObj))
            {
               this.m_currentHolder.dropItem();
            }
            removeFromCamera();
            if(m_sprite != null && m_sprite.parent != null)
            {
               m_sprite.parent.removeChild(m_sprite);
            }
            this.setState(IState.DEAD);
            m_eventManager.removeAllEvents();
            STAGEDATA.ItemsRef.checkDeadItems();
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
            if(this.m_itemStats.DeathEffect)
            {
               attachEffect(this.m_itemStats.DeathEffect);
            }
         }
      }
      
      protected function m_itemFall() : void
      {
         if(!this.m_pickedUp && !m_collision.ground && !this.IsSmashBall && !isHitStunOrParalysis())
         {
            if(m_ySpeed < m_max_ySpeed)
            {
               m_ySpeed += m_gravity;
            }
            if(this.m_itemStats.Ghost)
            {
               m_sprite.y += m_ySpeed;
            }
            else
            {
               m_attemptToMove(0,m_ySpeed);
            }
         }
      }
      
      protected function m_itemMove() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(!isHitStunOrParalysis() && !this.IsSmashBall)
         {
            applyGroundInfluence();
            _loc1_ = calcGroundAngle();
            _loc2_ = 0;
            if(_loc1_ > 20 && m_collision.ground)
            {
               _loc2_ = 8;
            }
            else if(_loc1_ < -20 && m_collision.ground)
            {
               _loc2_ = -8;
            }
            if(this.m_itemStats.Ghost)
            {
               m_sprite.x += m_xSpeed;
            }
            else if(_loc2_ < 0)
            {
               m_attemptToMove(0,_loc2_);
               m_attemptToMove(m_xSpeed,0);
            }
            else if(_loc2_ > 0)
            {
               m_attemptToMove(m_xSpeed,0);
               m_attemptToMove(0,_loc2_);
            }
            else
            {
               m_attemptToMove(m_xSpeed,_loc2_);
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
      
      protected function getDistanceFrom(param1:Number, param2:Number) : Number
      {
         return Math.sqrt(Math.pow(param1 - m_sprite.x,2) + Math.pow(param2 - m_sprite.y,2));
      }
      
      protected function checkRichochetTimer() : void
      {
         var _loc1_:Number = NaN;
         if(!isHitStunOrParalysis() && inState(IState.TOSS))
         {
            _loc1_ = 15;
            m_collision.leftSide = m_xSpeed < 0 && Boolean(testTerrainWithCoord(m_sprite.x - _loc1_,m_sprite.y - 25));
            m_collision.rightSide = m_xSpeed > 0 && Boolean(testTerrainWithCoord(m_sprite.x + _loc1_,m_sprite.y - 25));
            if(!m_collision.ground && (m_collision.rightSide || m_collision.leftSide))
            {
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.HIT_WALL,{
                  "caller":this.APIInstance.instance,
                  "left":m_collision.leftSide,
                  "right":m_collision.rightSide,
                  "top":false
               }));
            }
            this.m_richochetTimer.tick();
            if(this.m_richochetTimer.IsComplete)
            {
               this.m_richochetTimer.reset();
               if(!m_collision.ground && m_sprite.y == this.m_richochetY && m_ySpeed < 0 && Boolean(testGroundWithCoord(m_sprite.x,m_sprite.y - this.m_itemStats.Height - 1)))
               {
                  m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.HIT_WALL,{
                     "caller":this.APIInstance.instance,
                     "left":m_xSpeed < 0,
                     "right":m_xSpeed > 0,
                     "top":true
                  }));
               }
            }
            this.m_richochetX = m_sprite.x;
            this.m_richochetY = m_sprite.y;
         }
         else if(isHitStunOrParalysis())
         {
            this.m_richochetTimer.reset();
         }
      }
      
      protected function m_checkBounce() : void
      {
         if(!this.m_pickedUp && this.m_bounce_remaining > 0 && inState(IState.IDLE) && m_collision.ground)
         {
            m_ySpeed *= -0.6;
            unnattachFromGround();
            --this.m_bounce_remaining;
         }
         else if(m_collision.ground && this.m_itemStats.Bounce > 0 && m_ySpeed >= 0 && inState(IState.TOSS))
         {
            if(!(this.m_bounce_limit.IsComplete && this.m_bounce_total < this.m_bounce_limit.MaxTime))
            {
               m_ySpeed = -this.m_itemStats.Bounce;
               this.m_itemStats.Bounce *= this.m_itemStats.BounceDecay;
               while(this.m_itemStats.BounceMaxHeight > 0 && this.getBounceHeight(m_ySpeed) > this.m_itemStats.BounceMaxHeight)
               {
                  ++m_ySpeed;
               }
               this.m_bounce_limit.tick();
               unnattachFromGround();
               m_collision.ground = false;
            }
         }
      }
      
      override protected function m_groundCollisionTest() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         if(!this.IsSmashBall && !this.m_itemStats.Ghost)
         {
            _loc1_ = Boolean(m_collision.ground);
            _loc2_ = m_ySpeed > 0;
            if(m_collision.ground && netYSpeed() >= 0)
            {
               attachToGround();
            }
            _loc3_ = (m_currentPlatform = testGroundWithCoord(m_sprite.x,m_sprite.y + 1)) != null;
            m_collision.ground = _loc3_;
            this.m_checkBounce();
            if(m_collision.ground)
            {
               attachToGround();
            }
            if(!_loc1_ && _loc2_ && netYSpeed() < 0)
            {
               STAGEDATA.playSpecificSound(this.m_landSound);
               _loc3_ = false;
               m_currentPlatform = null;
               m_collision.ground = false;
            }
            if(!inState(IState.DEAD) && m_collision.ground && !_loc1_)
            {
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.GROUND_TOUCH,{"caller":this.APIInstance.instance}));
            }
            else if(!inState(IState.DEAD) && !m_collision.ground && _loc1_)
            {
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.GROUND_LEAVE,{"caller":this.APIInstance.instance}));
            }
            if(m_collision.ground && !this.m_pickedUp && !inState(IState.TOSS))
            {
               if(!_loc1_)
               {
                  STAGEDATA.playSpecificSound(this.m_landSound);
               }
               if(this.m_itemStats.SlideDecay >= 0)
               {
                  m_xSpeed = m_xSpeed < 0 ? -Math.abs(-m_xSpeed * this.m_itemStats.SlideDecay) : m_xSpeed * this.m_itemStats.SlideDecay;
               }
               else if(m_xSpeed != 0)
               {
                  _loc4_ = m_xSpeed > 0;
                  m_xSpeed -= m_xSpeed > 0 ? Utils.fastAbs(this.m_itemStats.SlideDecay) : -Utils.fastAbs(this.m_itemStats.SlideDecay);
                  if(_loc4_ && m_xSpeed < 0 || !_loc4_ && m_xSpeed > 0)
                  {
                     m_xSpeed = 0;
                  }
                  if(Utils.fastAbs(m_xSpeed) <= 0.5)
                  {
                     m_xSpeed = 0;
                  }
               }
            }
         }
      }
      
      override public function currentStanceFrameIs(param1:String) : Boolean
      {
         return m_sprite.stance.frame == param1 ? true : false;
      }
      
      public function pushAway(param1:Boolean, param2:int = 1) : void
      {
         if(!isHitStunOrParalysis() && this.m_itemStats.CanBePushed && !this.m_itemStats.Ghost)
         {
            if(m_collision.ground && m_xSpeed == 0)
            {
               if(param1 && !m_collision.rightSide)
               {
                  m_attemptToMove(param2,0);
                  attachToGround();
               }
               else if(!param1 && !m_collision.leftSide)
               {
                  m_attemptToMove(-param2,0);
                  attachToGround();
               }
            }
         }
      }
      
      protected function m_pushAwayOpponents() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Character = null;
         var _loc3_:Rectangle = null;
         var _loc4_:Rectangle = null;
         if(this.m_itemStats.PushCharacters && m_collision.ground && !this.m_pickedUp && this.m_itemStats.PushCharacters && !inState(IState.DEAD))
         {
            _loc1_ = 0;
            while(_loc1_ < STAGEDATA.Characters.length)
            {
               _loc2_ = STAGEDATA.Characters[_loc1_];
               if(!(!m_collision.ground || !_loc2_ || !_loc2_.CollisionObj.ground || !InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster).length))
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
      
      protected function m_pushAwayItems() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Vector.<HitBoxCollisionResult> = null;
         var _loc3_:Item = null;
         var _loc4_:Rectangle = null;
         var _loc5_:Rectangle = null;
         if(m_collision.ground && !this.m_pickedUp && !this.IsSmashBall && !inState(IState.DEAD))
         {
            _loc1_ = 0;
            while(_loc1_ < STAGEDATA.ItemsRef.ItemsInUse.length)
            {
               _loc2_ = null;
               _loc3_ = STAGEDATA.ItemsRef.ItemsInUse[_loc1_];
               if(!(!_loc3_ || _loc1_ === this.m_slot || _loc3_.Dead || _loc3_.PickedUp || !_loc3_.Ground || !_loc3_.ItemStats.CanBePushed))
               {
                  _loc4_ = _loc3_.BoundsRect;
                  _loc5_ = BoundsRect;
                  _loc4_.x += _loc3_.X;
                  _loc4_.y += _loc3_.Y;
                  _loc5_.x += m_sprite.x;
                  _loc5_.y += m_sprite.y;
                  if(_loc4_.intersects(_loc5_))
                  {
                     if(m_sprite.x > _loc3_.X)
                     {
                        _loc3_.pushAway(false);
                     }
                     else if(m_sprite.x < _loc3_.X)
                     {
                        _loc3_.pushAway(true);
                     }
                     else if(m_sprite.x == _loc3_.X)
                     {
                        _loc3_.pushAway(true);
                        this.pushAway(false);
                     }
                  }
               }
               _loc1_++;
            }
         }
      }
      
      override public function setState(param1:uint) : void
      {
         var _loc2_:Boolean = param1 != m_state;
         var _loc3_:uint = m_state;
         m_state = param1;
         if(_loc2_)
         {
            m_framesSinceLastState = 0;
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.STATE_CHANGE,{
               "caller":this.APIInstance.instance,
               "fromState":_loc3_,
               "toState":m_state
            }));
            flushTimers();
            removeAllTempEvents();
            this.m_controlFrames();
         }
      }
      
      public function playGlobalSound(param1:String) : int
      {
         return STAGEDATA.SoundQueueRef.playSoundEffect(param1);
      }
      
      override protected function m_faceRight() : void
      {
         if(m_delayPlayback)
         {
            m_delayPlayBackFacingRight = true;
         }
         if(!this.m_itemStats.DisableFlip && !m_delayPlayback)
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
         if(!this.m_itemStats.DisableFlip && !m_delayPlayback)
         {
            m_sprite.scaleX = -Math.abs(m_sprite.scaleX);
         }
         m_facingForward = false;
      }
      
      override protected function m_controlFrames() : void
      {
         if(m_state == IState.IDLE)
         {
            playFrame(m_attack.Frame);
         }
         else if(m_state == IState.HOLD)
         {
            playFrame(m_attack.Frame);
         }
         else if(m_state == IState.TOSS)
         {
            playFrame(m_attack.Frame);
         }
         else if(m_state == IState.DEAD)
         {
         }
      }
      
      override protected function checkTimers() : void
      {
         super.checkTimers();
         if(this.m_pickedUp)
         {
            this.m_lastReleaseTimer = 999;
         }
         else if(this.m_previousHolder)
         {
            ++this.m_lastReleaseTimer;
         }
      }
      
      override public function PERFORMALL() : void
      {
         this.PREPERFORM();
         if(!STAGEDATA.FSCutscene && STAGEDATA.FSCutins <= 0)
         {
            if(this.m_pickedUp && !inState(IState.DEAD))
            {
               if(!this.IsFrozenInTime)
               {
                  this.checkTimers();
                  this.m_itemAttack();
                  checkReflection();
                  this.m_checkDead();
               }
            }
            else if(!this.m_pickedUp && !inState(IState.DEAD))
            {
               if(!this.IsFrozenInTime)
               {
                  this.checkTimers();
                  this.m_pushAwayItems();
                  this.m_groundCollisionTest();
                  this.m_calcFlyingAngle();
                  this.m_itemAttack();
                  this.m_checkReverse();
                  this.m_itemFall();
                  this.m_itemMove();
                  m_forces();
                  this.m_pushAwayOpponents();
               }
               checkReflection();
               checkShadow();
               if(!this.IsFrozenInTime)
               {
                  this.checkRichochetTimer();
                  checkHitStun();
                  updateCamerBox();
                  this.m_checkDeathBounds();
                  this.m_checkDead();
               }
            }
            updateSelfPlatform();
         }
         this.POSTPERFORM();
      }
      
      override protected function PREPERFORM() : void
      {
         m_actionTimerUpdatedOnFrame = false;
         if(!STAGEDATA.FSCutscene && STAGEDATA.FSCutins <= 0)
         {
            if(m_started && HasStance && !inState(IState.DEAD) && !isHitStunOrParalysis() && !m_delayPlayback)
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
         if(!STAGEDATA.FSCutscene && STAGEDATA.FSCutins <= 0)
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
            return this.m_owner.IsFrozenInTime;
         }
         return this.STAGEDATA ? this.STAGEDATA.InTimeStop : false;
      }
   }
}


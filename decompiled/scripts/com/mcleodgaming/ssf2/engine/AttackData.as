package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.api.*;
   import com.mcleodgaming.ssf2.util.*;
   
   public class AttackData
   {
      
      private var m_owner:InteractiveSprite;
      
      private var m_attacks:Object;
      
      private var m_attackMap:Dictionary;
      
      private var m_projectiles:Array;
      
      private var m_items:Array;
      
      public function AttackData(param1:InteractiveSprite, param2:Array = null)
      {
         super();
         this.m_owner = param1;
         var _loc3_:Array = param2 ? param2 : new Array();
         this.m_attacks = new Object();
         this.m_attackMap = new Dictionary(AttackObject);
         this.m_projectiles = new Array();
         this.m_items = new Array();
         var _loc4_:Number = 0;
         while(_loc4_ < _loc3_.length)
         {
            this.m_attacks[_loc3_[_loc4_]] = new AttackObject(_loc3_[_loc4_]);
            this.m_attackMap.push(_loc3_[_loc4_],this.m_attacks[_loc3_[_loc4_]]);
            _loc4_++;
         }
      }
      
      public function get Owner() : InteractiveSprite
      {
         return this.m_owner;
      }
      
      public function set Owner(param1:InteractiveSprite) : void
      {
         this.m_owner = param1;
      }
      
      public function get AttackArray() : Object
      {
         return this.m_attacks;
      }
      
      public function get AttackMap() : Dictionary
      {
         return this.m_attackMap;
      }
      
      public function get ProjectilesArray() : Object
      {
         return this.m_projectiles;
      }
      
      public function get ItemsArray() : Object
      {
         return this.m_items;
      }
      
      public function setAttackDamageVar(param1:String, param2:String, param3:String, param4:*) : void
      {
         var _loc5_:Object = null;
         if(this.m_attacks[param1] != null && this.m_attacks[param1].AttackBoxes[param2] != null)
         {
            _loc5_ = new Object();
            _loc5_[param3] = param4;
            this.m_attacks[param1].AttackBoxes[param2].importAttackDamageData(_loc5_);
         }
         else
         {
            trace(param1 + " does not cotnain the hitbox " + param2 + " in AttackData array");
         }
      }
      
      public function setAttackBoxDataOverride(param1:String, param2:String, param3:Object) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:Object = null;
         var _loc6_:AttackObject = this.getAttack(param1);
         if(_loc6_)
         {
            if(_loc6_.AttackBoxes[param2])
            {
               if(_loc6_.OverrideMap.containsKey(param2))
               {
                  for(_loc4_ in param3)
                  {
                     _loc6_.OverrideMap.getKey(param2)[_loc4_] = param3[_loc4_];
                  }
               }
               else
               {
                  _loc5_ = {};
                  for(_loc4_ in param3)
                  {
                     _loc5_[_loc4_] = param3[_loc4_];
                  }
                  _loc6_.OverrideMap.setKey(param2,_loc5_);
               }
            }
         }
      }
      
      public function getAttackBoxData(param1:String, param2:String) : AttackDamage
      {
         var _loc3_:AttackDamage = new AttackDamage(this.m_owner ? int(this.m_owner.ID) : -1,this.m_owner);
         var _loc4_:AttackObject = this.getAttack(param1);
         if(_loc4_)
         {
            if(Boolean(_loc4_.AttackBoxes[param2]) && (Boolean(!this.m_owner) || Boolean(this.m_owner.AttackStateData)))
            {
               _loc3_.importAttackDamageData(_loc4_.AttackBoxes[param2].exportAttackDamageData());
               if(_loc4_.OverrideMap.containsKey(param2))
               {
                  _loc3_.importAttackDamageData(_loc4_.OverrideMap.getKey(param2));
               }
            }
         }
         return _loc3_;
      }
      
      public function resetCharges() : void
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this.m_attacks)
         {
            this.m_attacks[_loc1_].ChargeTime = 0;
         }
      }
      
      public function resetDisabledAttacks() : void
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this.m_attacks)
         {
            this.m_attacks[_loc1_].IsDisabled = false;
         }
      }
      
      public function incrementAttackTimers(param1:Character) : void
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this.m_attacks)
         {
            if(this.m_attacks[_loc2_].ReenableTimer > 0 && this.m_attacks[_loc2_].ReenableTimerCount > 0)
            {
               --this.m_attacks[_loc2_].ReenableTimerCount;
               if(this.m_attacks[_loc2_].ReenableTimerCount == 0)
               {
                  if(this.m_owner)
                  {
                     this.m_owner.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_ENABLED,{
                        "caller":this.m_owner.APIInstance.instance,
                        "attackData":this.m_attacks[_loc2_].exportAttackData()
                     }));
                  }
                  this.m_attacks[_loc2_].IsDisabled = false;
                  if(this.m_attacks[_loc2_].ReenableEffect != null)
                  {
                     param1.attachEffect(this.m_attacks[_loc2_].ReenableEffect);
                  }
               }
            }
            ++this.m_attacks[_loc2_].LastUsed;
            ++this.m_attacks[_loc2_].LastUsedPrevious;
         }
      }
      
      public function addProjectile(param1:String, param2:ProjectileAttack) : void
      {
         this.m_projectiles[param1] = param2;
         param2.StatsName = param1;
      }
      
      public function getProjectile(param1:String) : ProjectileAttack
      {
         if(this.m_projectiles[param1] == undefined)
         {
            return null;
         }
         return this.m_projectiles[param1];
      }
      
      public function addItem(param1:String, param2:ItemData) : void
      {
         this.m_items[param1] = param2;
      }
      
      public function getItem(param1:String) : ItemData
      {
         if(this.m_items[param1] == undefined)
         {
            return null;
         }
         return this.m_items[param1];
      }
      
      public function getAttack(param1:String) : AttackObject
      {
         if(param1 == null)
         {
            return null;
         }
         return this.m_attacks[param1] != null ? this.m_attacks[param1] : null;
      }
      
      public function setAttack(param1:String, param2:AttackObject) : void
      {
         if(param1 != null && param2 != null)
         {
            param2.Name = param1;
            this.m_attacks[param1] = param2;
         }
         else
         {
            trace("Error, in attempting to set \"" + param1 + "\" to \"" + param2.Name + "\"a null was returned");
         }
      }
      
      public function setAttackVar(param1:String, param2:String, param3:*) : void
      {
         var _loc4_:Object = null;
         if(this.m_attacks[param1] != null)
         {
            _loc4_ = new Object();
            _loc4_[param2] = param3;
            this.m_attacks[param1].importAttackData(_loc4_);
         }
         else
         {
            trace(param1 + " does not exist in AttackData array");
         }
      }
      
      public function importAttacks(param1:Object) : void
      {
         var _loc2_:* = undefined;
         for(_loc2_ in param1)
         {
            if(this.m_attacks[_loc2_] !== undefined)
            {
               this.m_attacks[_loc2_].importAttackData(param1[_loc2_]);
            }
            else
            {
               this.m_attacks[_loc2_] = new AttackObject(_loc2_);
               this.m_attacks[_loc2_].importAttackData(param1[_loc2_]);
            }
         }
      }
      
      public function importProjectiles(param1:Object) : void
      {
         var _loc2_:* = undefined;
         for(_loc2_ in param1)
         {
            if(this.m_projectiles[_loc2_] !== undefined)
            {
               this.m_projectiles[_loc2_].importData(param1[_loc2_]);
            }
            else
            {
               this.m_projectiles[_loc2_] = new ProjectileAttack();
               this.m_projectiles[_loc2_].importData(param1[_loc2_]);
            }
         }
      }
      
      public function importItems(param1:Object) : void
      {
         var _loc2_:* = undefined;
         for(_loc2_ in param1)
         {
            if(this.m_items[_loc2_] !== undefined)
            {
               this.m_items[_loc2_].importData(param1[_loc2_]);
            }
            else
            {
               this.m_items[_loc2_] = new ItemData();
               this.m_items[_loc2_].importData(param1[_loc2_]);
            }
         }
      }
   }
}


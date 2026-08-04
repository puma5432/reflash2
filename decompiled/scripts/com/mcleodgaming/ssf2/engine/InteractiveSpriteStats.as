package com.mcleodgaming.ssf2.engine
{
   import flash.utils.*;
   
   public class InteractiveSpriteStats
   {
      
      protected var m_classAPI:Class;
      
      protected var m_width:Number;
      
      protected var m_height:Number;
      
      protected var m_weight1:Number;
      
      protected var m_linkage_id:String;
      
      protected var m_gravity:Number;
      
      protected var m_max_ySpeed:Number;
      
      protected var m_max_projectile:int;
      
      protected var m_ghost:Boolean;
      
      protected var m_surviveDeathBounds:Boolean;
      
      protected var m_canReceiveKnockback:Boolean;
      
      protected var m_canReceiveDamage:Boolean;
      
      protected var m_canReceiveHits:Boolean;
      
      protected var m_bypassCollisionTesting:Boolean;
      
      protected var m_shadow:Boolean;
      
      protected var m_reflection:Boolean;
      
      protected var m_stamina:int;
      
      protected var m_knee_x_offset:Number;
      
      protected var m_knee_y_offset:Number;
      
      protected var m_hurtByOwner:Boolean;
      
      protected var m_hurtByTeam:Boolean;
      
      public function InteractiveSpriteStats()
      {
         super();
         this.m_classAPI = null;
         this.m_width = 0;
         this.m_height = 0;
         this.m_weight1 = 100;
         this.m_linkage_id = null;
         this.m_gravity = 0;
         this.m_max_ySpeed = 0;
         this.m_max_projectile = 10;
         this.m_ghost = false;
         this.m_surviveDeathBounds = false;
         this.m_canReceiveKnockback = true;
         this.m_canReceiveDamage = true;
         this.m_canReceiveHits = true;
         this.m_bypassCollisionTesting = false;
         this.m_shadow = true;
         this.m_reflection = true;
         this.m_stamina = 0;
         this.m_knee_x_offset = 11;
         this.m_knee_y_offset = -25;
         this.m_hurtByOwner = false;
         this.m_hurtByTeam = false;
      }
      
      public function get ClassAPI() : Class
      {
         return this.m_classAPI;
      }
      
      public function get Width() : Number
      {
         return this.m_width;
      }
      
      public function get Height() : Number
      {
         return this.m_height;
      }
      
      public function get Weight1() : Number
      {
         return this.m_weight1;
      }
      
      public function get LinkageID() : String
      {
         return this.m_linkage_id;
      }
      
      public function get Gravity() : Number
      {
         return this.m_gravity;
      }
      
      public function get MaxYSpeed() : Number
      {
         return this.m_max_ySpeed;
      }
      
      public function get MaxProjectile() : int
      {
         return this.m_max_projectile;
      }
      
      public function get Ghost() : Boolean
      {
         return this.m_ghost;
      }
      
      public function get SurviveDeathBounds() : Boolean
      {
         return this.m_surviveDeathBounds;
      }
      
      public function get CanReceiveKnockback() : Boolean
      {
         return this.m_canReceiveKnockback;
      }
      
      public function get CanReceiveDamage() : Boolean
      {
         return this.m_canReceiveDamage;
      }
      
      public function get CanReceiveHits() : Boolean
      {
         return this.m_canReceiveHits;
      }
      
      public function get BypassCollisionTesting() : Boolean
      {
         return this.m_bypassCollisionTesting;
      }
      
      public function get Shadow() : Boolean
      {
         return this.m_shadow;
      }
      
      public function get Reflection() : Boolean
      {
         return this.m_reflection;
      }
      
      public function get Stamina() : int
      {
         return this.m_stamina;
      }
      
      public function get KneeXOffset() : Number
      {
         return this.m_knee_x_offset;
      }
      
      public function get KneeYOffset() : Number
      {
         return this.m_knee_y_offset;
      }
      
      public function get HurtByOwner() : Boolean
      {
         return this.m_hurtByOwner;
      }
      
      public function get HurtByTeam() : Boolean
      {
         return this.m_hurtByTeam;
      }
      
      public function getVar(param1:String) : *
      {
         if(this["m_" + param1] !== undefined)
         {
            return this["m_" + param1];
         }
         return null;
      }
      
      public function importData(param1:Object) : Boolean
      {
         var _loc2_:* = undefined;
         var _loc3_:Boolean = true;
         for(_loc2_ in param1)
         {
            if(this["m_" + _loc2_] !== undefined)
            {
               this["m_" + _loc2_] = param1[_loc2_];
            }
            else
            {
               _loc3_ = false;
               trace("You tried to set \"m_" + _loc2_ + "\" but it doesn\'t exist in the " + getQualifiedClassName(this) + " class. (" + param1["linkage_id"] + ")");
            }
         }
         return _loc3_;
      }
      
      public function exportData() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.classAPI = this.m_classAPI;
         _loc1_.width = this.m_width;
         _loc1_.height = this.m_height;
         _loc1_.weight1 = this.m_weight1;
         _loc1_.linkage_id = this.m_linkage_id;
         _loc1_.gravity = this.m_gravity;
         _loc1_.height = this.m_height;
         _loc1_.max_ySpeed = this.m_max_ySpeed;
         _loc1_.max_projectile = this.m_max_projectile;
         _loc1_.ghost = this.m_ghost;
         _loc1_.surviveDeathBounds = this.m_surviveDeathBounds;
         _loc1_.canReceiveKnockback = this.m_canReceiveKnockback;
         _loc1_.canReceiveDamage = this.m_canReceiveDamage;
         _loc1_.canReceiveHits = this.m_canReceiveHits;
         _loc1_.bypassCollisionTesting = this.m_bypassCollisionTesting;
         _loc1_.shadow = this.m_shadow;
         _loc1_.reflection = this.m_reflection;
         _loc1_.stamina = this.m_stamina;
         _loc1_.knee_x_offset = this.m_knee_x_offset;
         _loc1_.knee_y_offset = this.m_knee_y_offset;
         _loc1_.hurtByOwner = this.m_hurtByOwner;
         _loc1_.hurtByTeam = this.m_hurtByTeam;
         return _loc1_;
      }
   }
}


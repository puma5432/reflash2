package com.mcleodgaming.ssf2.controllers
{
   public class MatchResults
   {
      
      private var m_owner:int;
      
      private var m_rank:int;
      
      private var m_score:int;
      
      private var m_kos:int;
      
      private var m_falls:int;
      
      private var m_selfDestructs:int;
      
      private var m_damageGiven:Number;
      
      private var m_damageRemaining:Number;
      
      private var m_damageTaken:Number;
      
      private var m_peakDamage:Number;
      
      private var m_fastestPitch:Number;
      
      private var m_topSpeed:Number;
      
      private var m_swimTime:int;
      
      private var m_longestDrought:int;
      
      private var m_transformationTime:int;
      
      private var m_finalSmashCount:int;
      
      private var m_stockRemaining:int;
      
      private var m_survivalTime:int;
      
      private var m_koList:Array;
      
      private var m_killerList:Array;
      
      public function MatchResults(param1:int)
      {
         super();
         this.m_owner = param1;
         this.m_rank = 1;
         this.m_score = 0;
         this.m_kos = 0;
         this.m_falls = 0;
         this.m_selfDestructs = 0;
         this.m_damageGiven = 0;
         this.m_damageRemaining = 0;
         this.m_damageTaken = 0;
         this.m_peakDamage = 0;
         this.m_fastestPitch = 0;
         this.m_topSpeed = 0;
         this.m_swimTime = 0;
         this.m_longestDrought = 0;
         this.m_transformationTime = 0;
         this.m_finalSmashCount = 0;
         this.m_koList = new Array();
         this.m_killerList = new Array();
         this.m_stockRemaining = 0;
         this.m_survivalTime = 0;
      }
      
      public function get Owner() : Number
      {
         return this.m_owner;
      }
      
      public function get Rank() : int
      {
         return this.m_rank;
      }
      
      public function set Rank(param1:int) : void
      {
         this.m_rank = param1;
      }
      
      public function get Score() : int
      {
         return this.m_score;
      }
      
      public function set Score(param1:int) : void
      {
         this.m_score = param1;
      }
      
      public function get KOs() : int
      {
         return this.m_kos;
      }
      
      public function set KOs(param1:int) : void
      {
         this.m_kos = param1;
      }
      
      public function get Falls() : int
      {
         return this.m_falls;
      }
      
      public function set Falls(param1:int) : void
      {
         this.m_falls = param1;
      }
      
      public function get SelfDestructs() : int
      {
         return this.m_selfDestructs;
      }
      
      public function set SelfDestructs(param1:int) : void
      {
         this.m_selfDestructs = param1;
      }
      
      public function get DamageRemaining() : Number
      {
         return this.m_damageRemaining;
      }
      
      public function set DamageRemaining(param1:Number) : void
      {
         this.m_damageRemaining = param1;
      }
      
      public function get DamageGiven() : Number
      {
         return this.m_damageGiven;
      }
      
      public function set DamageGiven(param1:Number) : void
      {
         this.m_damageGiven = param1;
      }
      
      public function get DamageTaken() : Number
      {
         return this.m_damageTaken;
      }
      
      public function set DamageTaken(param1:Number) : void
      {
         this.m_damageTaken = param1;
      }
      
      public function get PeakDamage() : Number
      {
         return this.m_peakDamage;
      }
      
      public function set PeakDamage(param1:Number) : void
      {
         this.m_peakDamage = param1;
      }
      
      public function get FastestPitch() : Number
      {
         return this.m_fastestPitch;
      }
      
      public function set FastestPitch(param1:Number) : void
      {
         this.m_fastestPitch = param1;
      }
      
      public function get TopSpeed() : Number
      {
         return this.m_topSpeed;
      }
      
      public function set TopSpeed(param1:Number) : void
      {
         this.m_topSpeed = param1;
      }
      
      public function get SwimTime() : int
      {
         return this.m_swimTime;
      }
      
      public function set SwimTime(param1:int) : void
      {
         this.m_swimTime = param1;
      }
      
      public function get LongestDrought() : int
      {
         return this.m_longestDrought;
      }
      
      public function set LongestDrought(param1:int) : void
      {
         this.m_longestDrought = param1;
      }
      
      public function get TransformationTime() : int
      {
         return this.m_transformationTime;
      }
      
      public function set TransformationTime(param1:int) : void
      {
         this.m_transformationTime = param1;
      }
      
      public function get FinalSmashCount() : int
      {
         return this.m_finalSmashCount;
      }
      
      public function set FinalSmashCount(param1:int) : void
      {
         this.m_finalSmashCount = param1;
      }
      
      public function get StockRemaining() : int
      {
         return this.m_stockRemaining;
      }
      
      public function set StockRemaining(param1:int) : void
      {
         this.m_stockRemaining = param1;
      }
      
      public function get SurvivalTime() : int
      {
         return this.m_survivalTime;
      }
      
      public function set SurvivalTime(param1:int) : void
      {
         this.m_survivalTime = param1;
      }
      
      public function get KOList() : Array
      {
         return this.m_koList;
      }
      
      public function set KOList(param1:Array) : void
      {
         this.m_koList = param1;
      }
      
      public function get KillerList() : Array
      {
         return this.m_killerList;
      }
      
      public function set KillerList(param1:Array) : void
      {
         this.m_killerList = param1;
      }
      
      public function exportData() : Object
      {
         return {
            "owner":this.m_owner,
            "rank":this.m_rank,
            "score":this.m_score,
            "kos":this.m_kos,
            "falls":this.m_falls,
            "selfDestructs":this.m_selfDestructs,
            "damageGiven":this.m_damageGiven,
            "damageRemaining":this.m_damageRemaining,
            "damageTaken":this.m_damageTaken,
            "peakDamage":this.m_peakDamage,
            "fastestPitch":this.m_fastestPitch,
            "topSpeed":this.m_topSpeed,
            "swimTime":this.m_swimTime,
            "longestDrought":this.m_longestDrought,
            "transformationTime":this.m_transformationTime,
            "finalSmashCount":this.m_finalSmashCount,
            "stockRemaining":this.m_stockRemaining,
            "survivalTime":this.m_survivalTime,
            "koList":this.m_koList,
            "killerList":this.m_killerList
         };
      }
   }
}


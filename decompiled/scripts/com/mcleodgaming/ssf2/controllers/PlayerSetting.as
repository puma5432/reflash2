package com.mcleodgaming.ssf2.controllers
{
   import com.mcleodgaming.ssf2.util.*;
   
   public class PlayerSetting
   {
      
      public var character:String;
      
      public var name:String;
      
      public var level:int;
      
      public var damageRatio:Number;
      
      public var attackRatio:Number;
      
      public var human:Boolean;
      
      public var exist:Boolean;
      
      public var team:Number;
      
      public var costume:int;
      
      public var alternate:String;
      
      public var team_prev:Number;
      
      public var lives:Number;
      
      public var x_start:Number;
      
      public var y_start:Number;
      
      public var x_respawn:Number;
      
      public var y_respawn:Number;
      
      public var facingRight:Boolean;
      
      public var unlimitedFinal:Boolean;
      
      public var finalSmashMeter:Boolean;
      
      public var startDamage:int;
      
      public var expansion:int;
      
      public var isRandom:Boolean;
      
      public var socket_id:String;
      
      public var beatDevOnline:Boolean;
      
      public var ranked:Boolean;
      
      public function PlayerSetting()
      {
         super();
         this.init();
      }
      
      public function init() : void
      {
         this.character = null;
         this.name = null;
         this.level = 1;
         this.attackRatio = 1;
         this.damageRatio = 1;
         this.human = false;
         this.exist = true;
         this.team = -1;
         this.costume = -1;
         this.alternate = null;
         this.team_prev = 1;
         this.lives = 0;
         this.x_start = 0;
         this.y_start = 0;
         this.x_respawn = 0;
         this.y_respawn = 0;
         this.facingRight = true;
         this.unlimitedFinal = false;
         this.finalSmashMeter = false;
         this.startDamage = 0;
         this.expansion = -1;
         this.isRandom = false;
         this.socket_id = null;
         this.beatDevOnline = false;
         this.ranked = false;
      }
      
      public function getVar(param1:String) : *
      {
         if(this[param1] !== undefined)
         {
            return this[param1];
         }
         return null;
      }
      
      public function exportSettings() : Object
      {
         return {
            "character":this.character,
            "name":this.name,
            "level":this.level,
            "damageRatio":this.damageRatio,
            "attackRatio":this.attackRatio,
            "human":this.human,
            "exist":this.exist,
            "team":this.team,
            "team_prev":this.team_prev,
            "costume":this.costume,
            "lives":this.lives,
            "x_start":this.x_start,
            "y_start":this.y_start,
            "x_respawn":this.x_respawn,
            "y_respawn":this.y_respawn,
            "facingRight":this.facingRight,
            "unlimitedFinal":this.unlimitedFinal,
            "finalSmashMeter":this.finalSmashMeter,
            "startDamage":this.startDamage,
            "expansion":this.expansion,
            "isRandom":this.character === "random",
            "socket_id":this.socket_id,
            "beatDevOnline":SaveData.Unlocks.beatDevOnline,
            "ranked":this.ranked
         };
      }
      
      public function importSettings(param1:Object) : void
      {
         var _loc2_:* = undefined;
         for(_loc2_ in param1)
         {
            if(this[_loc2_] !== undefined)
            {
               this[_loc2_] = param1[_loc2_];
            }
            else
            {
               trace("You tried to set \"" + _loc2_ + "\" but it doesn\'t exist in the PlayerSetting class.");
            }
         }
      }
   }
}


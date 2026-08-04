package com.mcleodgaming.ssf2.controllers
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.modes.CustomMode;
   import com.mcleodgaming.ssf2.util.*;
   
   public class Game
   {
      
      private var m_playerSettings:Vector.<PlayerSetting>;
      
      private var m_levelData:GameSettings;
      
      private var m_items:ItemSettings;
      
      private var m_gameMode:uint;
      
      private var m_replayData:ReplayData;
      
      private var m_suddenDeath:Boolean;
      
      private var m_customMode:CustomMode;
      
      private var m_customMatch:CustomMatch;
      
      public function Game(param1:int = -1, param2:uint = 0)
      {
         super();
         if(param1 <= 0)
         {
            param1 = int(Main.MAXPLAYERS);
         }
         this.m_gameMode = param2;
         this.m_suddenDeath = false;
         this.m_playerSettings = new Vector.<PlayerSetting>();
         this.m_levelData = new GameSettings();
         this.m_items = new ItemSettings();
         this.m_replayData = null;
         var _loc3_:int = param1;
         var _loc4_:int = 1;
         while(_loc4_ <= _loc3_)
         {
            this.m_playerSettings.push(new PlayerSetting());
            this.m_playerSettings[_loc4_ - 1].importSettings({
               "human":_loc4_ == 1,
               "team_prev":(_loc4_ == 1 ? 1 : 2)
            });
            _loc4_++;
         }
         this.m_levelData.hazards = SaveData.Hazards;
      }
      
      public function get Time() : Number
      {
         return this.m_levelData.time as Number;
      }
      
      public function set Time(param1:Number) : void
      {
         this.m_levelData.time = param1;
         if(this.m_levelData.time <= 0)
         {
            this.m_levelData.time = 99;
         }
         else if(this.m_levelData.time > 99)
         {
            this.m_levelData.time = 1;
         }
      }
      
      public function get CustomMatchObj() : CustomMatch
      {
         return this.m_customMatch;
      }
      
      public function set CustomMatchObj(param1:CustomMatch) : void
      {
         this.m_customMatch = param1;
      }
      
      public function get CustomModeObj() : CustomMode
      {
         return this.m_customMode;
      }
      
      public function set CustomModeObj(param1:CustomMode) : void
      {
         this.m_customMode = param1;
      }
      
      public function get CountDown() : Boolean
      {
         return this.m_levelData.countdown as Boolean;
      }
      
      public function set CountDown(param1:Boolean) : void
      {
         this.m_levelData.countdown = param1;
      }
      
      public function get SizeRatio() : Number
      {
         return this.m_levelData.sizeRatio as Number;
      }
      
      public function get ShowPlayerID() : Boolean
      {
         return this.m_levelData.showPlayerID as Boolean;
      }
      
      public function set ShowPlayerID(param1:Boolean) : void
      {
         this.m_levelData.showPlayerID = param1;
      }
      
      public function set SizeRatio(param1:Number) : void
      {
         this.m_levelData.sizeRatio = param1;
      }
      
      public function get LevelData() : GameSettings
      {
         return this.m_levelData;
      }
      
      public function set LevelData(param1:GameSettings) : void
      {
         this.m_levelData = param1;
      }
      
      public function get Lives() : Number
      {
         return this.m_levelData.lives as Number;
      }
      
      public function set Lives(param1:Number) : void
      {
         var _loc2_:int = 0;
         this.m_levelData.lives = param1;
         if(this.m_levelData.lives <= 0)
         {
            this.m_levelData.lives = 99;
         }
         else if(this.m_levelData.lives > 99)
         {
            this.m_levelData.lives = 1;
         }
         while(_loc2_ < this.m_playerSettings.length)
         {
            this.m_playerSettings[_loc2_].lives = this.m_levelData.lives;
            _loc2_++;
         }
      }
      
      public function get UsingStamina() : Boolean
      {
         return this.m_levelData.usingStamina;
      }
      
      public function set UsingStamina(param1:Boolean) : void
      {
         this.m_levelData.usingStamina = param1;
      }
      
      public function get UsingTime() : Boolean
      {
         return this.m_levelData.usingTime;
      }
      
      public function set UsingTime(param1:Boolean) : void
      {
         this.m_levelData.usingTime = param1;
      }
      
      public function get UsingLives() : Boolean
      {
         return this.m_levelData.usingLives;
      }
      
      public function set UsingLives(param1:Boolean) : void
      {
         this.m_levelData.usingLives = param1;
      }
      
      public function get FinalSmashMeter() : Boolean
      {
         return this.m_levelData.finalSmashMeter;
      }
      
      public function set FinalSmashMeter(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         this.m_levelData.finalSmashMeter = param1;
         while(_loc2_ < this.m_playerSettings.length)
         {
            this.m_playerSettings[_loc2_].finalSmashMeter = this.m_levelData.finalSmashMeter;
            _loc2_++;
         }
      }
      
      public function get ScoreDisplay() : Boolean
      {
         return this.m_levelData.scoreDisplay;
      }
      
      public function set ScoreDisplay(param1:Boolean) : void
      {
         this.m_levelData.scoreDisplay = param1;
      }
      
      public function get HudDisplay() : Boolean
      {
         return this.m_levelData.hudDisplay;
      }
      
      public function set HudDisplay(param1:Boolean) : void
      {
         this.m_levelData.hudDisplay = param1;
      }
      
      public function get PauseEnabled() : Boolean
      {
         return this.m_levelData.pauseEnabled;
      }
      
      public function set PauseEnabled(param1:Boolean) : void
      {
         this.m_levelData.pauseEnabled = param1;
      }
      
      public function get TotalPlayers() : Number
      {
         var _loc2_:int = 0;
         var _loc1_:Number = 0;
         while(_loc2_ < this.m_playerSettings.length)
         {
            if(this.m_playerSettings[_loc2_].character != null && this.m_playerSettings[_loc2_].character != null)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function get DamageRatio() : Number
      {
         return this.m_levelData.damageRatio as Number;
      }
      
      public function set DamageRatio(param1:Number) : void
      {
         var _loc2_:int = 0;
         this.m_levelData.damageRatio = param1;
         if(this.m_levelData.damageRatio > 2)
         {
            this.m_levelData.damageRatio = 2;
         }
         else if(this.m_levelData.damageRatio < 0.5)
         {
            this.m_levelData.damageRatio = 0.5;
         }
         while(_loc2_ < this.m_playerSettings.length)
         {
            this.m_playerSettings[_loc2_].damageRatio = this.m_levelData.damageRatio;
            _loc2_++;
         }
      }
      
      public function set ItemFrequency(param1:Number) : void
      {
         this.m_items.frequency = param1;
         if(this.m_items.frequency > 5)
         {
            this.m_items.frequency = 5;
         }
         else if(this.m_items.frequency < 0)
         {
            this.m_items.frequency = 0;
         }
      }
      
      public function get Items() : ItemSettings
      {
         return this.m_items;
      }
      
      public function set Items(param1:ItemSettings) : void
      {
         this.m_items = param1;
      }
      
      public function get StartDamage() : Number
      {
         return this.m_levelData.startDamage as Number;
      }
      
      public function set StartDamage(param1:Number) : void
      {
         var _loc2_:int = 0;
         this.m_levelData.startDamage = param1;
         if(this.m_levelData.startDamage > 999)
         {
            this.m_levelData.startDamage = 999;
         }
         else if(this.m_levelData.startDamage < 0)
         {
            this.m_levelData.startDamage = 0;
         }
         while(_loc2_ < this.m_playerSettings.length)
         {
            this.m_playerSettings[_loc2_].startDamage = this.m_levelData.startDamage;
            _loc2_++;
         }
      }
      
      public function get SuddenDeath() : Boolean
      {
         return this.m_suddenDeath;
      }
      
      public function set SuddenDeath(param1:Boolean) : void
      {
         this.m_suddenDeath = param1;
      }
      
      public function get GameMode() : uint
      {
         return this.m_gameMode;
      }
      
      public function set GameMode(param1:uint) : void
      {
         this.m_gameMode = param1;
      }
      
      public function get PlayerSettings() : Vector.<PlayerSetting>
      {
         return this.m_playerSettings;
      }
      
      public function get ReplayDataObj() : ReplayData
      {
         return this.m_replayData;
      }
      
      public function set ReplayDataObj(param1:ReplayData) : void
      {
         this.m_replayData = param1;
      }
      
      public function set PlayerSettings(param1:Vector.<PlayerSetting>) : void
      {
         this.m_playerSettings = param1;
      }
      
      public function loadSavedVSOptions() : void
      {
         var _loc2_:int = 0;
         var _loc1_:Object = SaveData.getSavedVSOptions();
         this.LevelData.time = _loc1_.VS_Time;
         this.LevelData.showPlayerID = _loc1_.VS_DisplayPlayer;
         this.LevelData.lives = _loc1_.VS_Lives;
         this.LevelData.startDamage = _loc1_.VS_StartDamage;
         this.LevelData.startStamina = _loc1_.VS_StartStamina;
         this.LevelData.usingLives = _loc1_.VS_UsingLives;
         this.LevelData.usingTime = _loc1_.VS_UsingTime;
         this.LevelData.usingStamina = _loc1_.VS_UsingStamina;
         this.LevelData.teamDamage = _loc1_.teamDamage;
         this.LevelData.damageRatio = _loc1_.VS_DamageRatio;
         this.LevelData.scoreLimit = _loc1_.arenaScore;
         this.LevelData.finalSmashMeter = _loc1_.VS_FinalSmashMeter;
         this.LevelData.scoreDisplay = _loc1_.VS_ScoreDisplay;
         this.LevelData.hudDisplay = _loc1_.VS_HudDisplay;
         this.LevelData.pauseEnabled = _loc1_.VS_PauseEnabled;
         while(_loc2_ < this.m_playerSettings.length)
         {
            this.m_playerSettings[_loc2_].finalSmashMeter = _loc1_.VS_FinalSmashMeter;
            this.m_playerSettings[_loc2_].damageRatio = _loc1_.VS_DamageRatio;
            this.m_playerSettings[_loc2_].lives = _loc1_.VS_Lives;
            this.m_playerSettings[_loc2_].level = _loc1_["VS_CPULevel" + (_loc2_ + 1)];
            _loc2_++;
         }
         this.m_items.frequency = _loc1_.VS_ItemFreq;
         this.m_items.items = Utils.cloneObject(_loc1_.VS_Items);
      }
      
      public function fixDuplicateCostumes() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         while(_loc4_ < this.m_playerSettings.length)
         {
            if(Boolean(this.m_playerSettings[_loc4_].character) && Boolean(this.m_playerSettings[_loc4_].character !== "xp") && this.m_playerSettings[_loc4_].character !== "random")
            {
               _loc1_ = [];
               _loc2_ = 0;
               while(_loc2_ < this.m_playerSettings.length)
               {
                  if(_loc2_ !== _loc4_)
                  {
                     if(this.m_playerSettings[_loc4_].character === this.m_playerSettings[_loc2_].character && this.m_playerSettings[_loc4_].costume === this.m_playerSettings[_loc2_].costume)
                     {
                        _loc1_.push(this.m_playerSettings[_loc4_].costume);
                     }
                  }
                  _loc2_++;
               }
               if(_loc1_.length)
               {
                  _loc3_ = ResourceManager.getAllCostumes(this.m_playerSettings[_loc4_].character,null);
                  if(_loc1_.indexOf(-1) < 0)
                  {
                     this.m_playerSettings[_loc4_].costume = -1;
                  }
                  else
                  {
                     _loc2_ = 0;
                     while(_loc2_ < _loc3_.length)
                     {
                        if(_loc1_.indexOf(_loc2_) < 0)
                        {
                           this.m_playerSettings[_loc4_].costume = _loc2_;
                           break;
                        }
                        _loc2_++;
                     }
                  }
               }
            }
            _loc4_++;
         }
      }
      
      public function exportSettings() : Object
      {
         var _loc2_:int = 0;
         var _loc1_:Object = new Object();
         _loc1_.levelData = this.m_levelData.exportSettings();
         _loc1_.items = this.m_items.exportSettings();
         _loc1_.playerSettings = [];
         while(_loc2_ < this.m_playerSettings.length)
         {
            _loc1_.playerSettings.push(this.m_playerSettings[_loc2_].exportSettings());
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function importSettings(param1:Object) : void
      {
         var _loc2_:int = 0;
         this.m_levelData.importSettings(param1.levelData);
         this.m_items.importSettings(param1.items);
         this.m_playerSettings = new Vector.<PlayerSetting>();
         while(_loc2_ < param1.playerSettings.length)
         {
            this.m_playerSettings.push(new PlayerSetting());
            this.m_playerSettings[_loc2_].importSettings(param1.playerSettings[_loc2_]);
            _loc2_++;
         }
      }
   }
}


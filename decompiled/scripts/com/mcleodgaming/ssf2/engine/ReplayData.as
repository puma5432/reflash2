package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.enums.*;
   
   public class ReplayData
   {
      
      public static var COMPATIBLE_VERSIONS:Array = [];
      
      private var m_frameCount:int;
      
      private var m_name:String;
      
      private var m_version:String;
      
      private var m_gameMode:int;
      
      private var m_randSeed:Number;
      
      private var m_matchSettings:Object;
      
      private var m_itemSettings:Object;
      
      private var m_playerData:Array;
      
      private var m_controlsData:Array;
      
      private var m_controlsPointers:Array;
      
      private var m_timestamp:Date;
      
      public function ReplayData(param1:int)
      {
         var _loc2_:int = 0;
         super();
         this.m_frameCount = 0;
         this.m_name = "Untitled Replay";
         this.m_version = Version.getVersion();
         this.m_gameMode = Mode.VS;
         this.m_randSeed = 0;
         this.m_matchSettings = new Object();
         this.m_itemSettings = new Object();
         this.m_playerData = new Array();
         this.m_controlsData = [];
         this.m_timestamp = new Date();
         _loc2_ = 0;
         while(_loc2_ < param1)
         {
            this.m_controlsData.push([]);
            _loc2_++;
         }
         this.m_controlsPointers = null;
      }
      
      public function get FrameCount() : int
      {
         return this.m_frameCount;
      }
      
      public function set FrameCount(param1:int) : void
      {
         this.m_frameCount = param1;
      }
      
      public function get Name() : String
      {
         return this.m_name;
      }
      
      public function set Name(param1:String) : void
      {
         this.m_name = param1;
      }
      
      public function get VersionNumber() : String
      {
         return this.m_version;
      }
      
      public function get GameMode() : int
      {
         return this.m_gameMode;
      }
      
      public function set GameMode(param1:int) : void
      {
         this.m_gameMode = param1;
      }
      
      public function get MatchSettings() : Object
      {
         return this.m_matchSettings;
      }
      
      public function set MatchSettings(param1:Object) : void
      {
         this.m_matchSettings = param1;
      }
      
      public function get ItemSettingsObj() : Object
      {
         return this.m_itemSettings;
      }
      
      public function set ItemSettingsObj(param1:Object) : void
      {
         this.m_itemSettings = param1;
      }
      
      public function get PlayerData() : Array
      {
         return this.m_playerData;
      }
      
      public function set PlayerData(param1:Array) : void
      {
         this.m_playerData = param1;
      }
      
      public function get ControlsData() : Array
      {
         return this.m_controlsData;
      }
      
      public function get Timestamp() : Date
      {
         return this.m_timestamp;
      }
      
      public function set Timestamp(param1:Date) : void
      {
         this.m_timestamp = param1;
      }
      
      public function resetPointers() : void
      {
         var _loc1_:int = 0;
         this.m_controlsPointers = new Array();
         while(_loc1_ < this.m_controlsData.length)
         {
            this.m_controlsPointers.push({
               "index":0,
               "total":(this.m_controlsData[_loc1_].length ? this.m_controlsData[_loc1_][1] : 0)
            });
            _loc1_++;
         }
      }
      
      public function pushControls(param1:int, param2:int) : void
      {
         if(this.m_controlsData[param1 - 1].length <= 0 || param2 != this.m_controlsData[param1 - 1][this.m_controlsData[param1 - 1].length - 2])
         {
            this.m_controlsData[param1 - 1].push(param2);
            this.m_controlsData[param1 - 1].push(1);
         }
         else
         {
            ++this.m_controlsData[param1 - 1][this.m_controlsData[param1 - 1].length - 1];
         }
      }
      
      public function retrieveControls(param1:int) : int
      {
         return this.m_controlsData[param1 - 1][this.m_controlsPointers[param1 - 1].index];
      }
      
      public function nextControls() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.m_controlsPointers.length)
         {
            if(this.m_controlsData[_loc1_].length)
            {
               --this.m_controlsPointers[_loc1_].total;
               if(this.m_controlsPointers[_loc1_].total <= 0)
               {
                  this.m_controlsPointers[_loc1_].index += 2;
                  if(this.m_controlsPointers[_loc1_].index < this.m_controlsData[_loc1_].length)
                  {
                     this.m_controlsPointers[_loc1_].total = this.m_controlsData[_loc1_][this.m_controlsPointers[_loc1_].index + 1];
                  }
               }
            }
            _loc1_++;
         }
      }
      
      public function exportReplay() : String
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:Object = new Object();
         _loc1_.version = this.m_version;
         _loc1_.compatibleVersions = [];
         _loc1_.frameCount = this.m_frameCount;
         _loc1_.name = this.m_name;
         _loc1_.gameMode = this.m_gameMode;
         _loc1_.randSeed = this.m_randSeed;
         _loc1_.matchSettings = this.m_matchSettings;
         _loc1_.itemSettings = this.m_itemSettings;
         _loc1_.playerSettings = this.m_playerData;
         _loc1_.timestamp = this.m_timestamp;
         var _loc2_:Array = this.unoptimizeData(this.m_controlsData);
         _loc5_ = JSON.stringify(_loc2_).length;
         _loc4_ = JSON.stringify(this.m_controlsData).length;
         if(_loc5_ < _loc4_)
         {
            _loc1_.optimized = false;
            _loc1_.controlsData = _loc2_;
         }
         else
         {
            _loc1_.optimized = true;
            _loc1_.controlsData = this.m_controlsData;
         }
         return JSON.stringify(_loc1_);
      }
      
      private function unoptimizeData(param1:Array) : Array
      {
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Array = [];
         _loc3_ = 0;
         while(_loc3_ < this.m_controlsData.length)
         {
            _loc5_.push([]);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.m_controlsData.length)
         {
            _loc4_ = 0;
            while(_loc4_ < this.m_controlsData[_loc3_].length)
            {
               _loc2_ = int(this.m_controlsData[_loc3_][_loc4_ + 1]);
               while(_loc2_ > 0)
               {
                  _loc5_[_loc3_].push(this.m_controlsData[_loc3_][_loc4_]);
                  _loc2_--;
               }
               _loc4_ += 2;
            }
            _loc3_++;
         }
         return _loc5_;
      }
      
      public function importReplay(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = JSON.parse(param1);
         this.m_version = _loc5_.version;
         this.m_frameCount = _loc5_.frameCount;
         this.m_name = _loc5_.name;
         this.m_gameMode = _loc5_.gameMode;
         this.m_randSeed = _loc5_.randSeed;
         this.m_matchSettings = _loc5_.matchSettings;
         this.m_itemSettings = _loc5_.itemSettings;
         this.m_playerData = _loc5_.playerSettings;
         this.m_controlsData = _loc5_.controlsData;
         this.m_timestamp = new Date(_loc5_.timestamp);
         if(!_loc5_.optimized)
         {
            _loc2_ = this.m_controlsData;
            this.m_controlsData = new Array();
            _loc3_ = 0;
            while(_loc3_ < this.m_playerData.length)
            {
               this.m_controlsData.push([]);
               _loc3_++;
            }
            _loc4_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc2_[_loc3_].length)
               {
                  this.pushControls(_loc3_ + 1,_loc2_[_loc3_][_loc4_]);
                  _loc4_++;
               }
               _loc3_++;
            }
         }
      }
   }
}


package com.mcleodgaming.mgn.net
{
   public class PlayerDataSyncStream
   {
      
      private static const BUFFER:int = 30;
      
      private var _history:Vector.<DataFrameGroup>;
      
      private var _pointer:int;
      
      private var _size:int;
      
      public function PlayerDataSyncStream()
      {
         super();
         this._history = new Vector.<DataFrameGroup>();
         this._size = 0;
         this._pointer = 0;
      }
      
      public function get Pointer() : int
      {
         return this._pointer;
      }
      
      public function init(param1:int) : void
      {
         this._pointer = 0;
         this._history = null;
         this._history = new Vector.<DataFrameGroup>();
         this._size = param1;
         while(this._history.length < BUFFER)
         {
            this._history.push(new DataFrameGroup(this._history.length + 1,this._size));
         }
      }
      
      public function updateDataFrame(param1:uint, param2:int, param3:Object) : void
      {
         if(param1 > this._history.length)
         {
            while(this._history.length < param1 + BUFFER)
            {
               this._history.push(new DataFrameGroup(this._history.length + 1,this._size));
            }
         }
         this._history[param1 - 1].updateDataFrameFor(param2,param3);
      }
      
      public function getDataFrameGroup(param1:uint) : DataFrameGroup
      {
         return param1 > this._history.length ? null : this._history[param1 - 1];
      }
      
      public function getFilledDataFrameGroups() : Vector.<DataFrameGroup>
      {
         var _loc1_:Vector.<DataFrameGroup> = new Vector.<DataFrameGroup>();
         var _loc2_:int = int(this._pointer);
         while(_loc2_ < this._history.length && Boolean(this._history[_loc2_].Complete))
         {
            _loc1_.push(this._history[_loc2_]);
            _loc2_++;
            ++this._pointer;
         }
         return _loc1_;
      }
      
      public function getSurroundingDataFrames(param1:int, param2:int) : Vector.<DataFrameGroup>
      {
         var _loc3_:Vector.<DataFrameGroup> = new Vector.<DataFrameGroup>();
         var _loc4_:int = Math.max(0,this._pointer - param1);
         while(_loc4_ < this._history.length && _loc4_ < this._pointer + param2)
         {
            _loc3_.push(this._history[_loc4_]);
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function flushFilled() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 1;
         _loc1_ = int(this._pointer);
         while(_loc1_ < this._history.length)
         {
            this._history[_loc1_].Frame = _loc2_;
            _loc1_++;
            _loc2_++;
         }
         this._history.splice(0,this._pointer);
         this._pointer = 0;
      }
   }
}


package com.mcleodgaming.mgn.net
{
   public class DataFrameGroup
   {
      
      private var _frame:uint;
      
      private var _fulfillCount:int;
      
      private var _dataFrameGroup:Vector.<DataFrame>;
      
      private var _complete:Boolean;
      
      public function DataFrameGroup(param1:uint, param2:int)
      {
         super();
         this._frame = param1;
         this._fulfillCount = 0;
         this._dataFrameGroup = new Vector.<DataFrame>();
         while(param2 > 0)
         {
            param2--;
            this._dataFrameGroup.push(new DataFrame());
         }
         this._complete = false;
      }
      
      public function get Complete() : Boolean
      {
         return this._complete;
      }
      
      public function get Size() : int
      {
         return this._dataFrameGroup.length;
      }
      
      public function get Frame() : uint
      {
         return this._frame;
      }
      
      public function set Frame(param1:uint) : void
      {
         this._frame = param1;
      }
      
      public function getDataFrameFor(param1:int) : DataFrame
      {
         return this._dataFrameGroup[param1];
      }
      
      public function updateDataFrameFor(param1:int, param2:Object) : void
      {
         if(param1 >= this._dataFrameGroup.length)
         {
            trace("Warning: Missing slot for data frame! Perhaps was disconnected?");
            return;
         }
         if(this._dataFrameGroup[param1].updateData(param2))
         {
            ++this._fulfillCount;
            if(this._fulfillCount >= this._dataFrameGroup.length)
            {
               this._complete = true;
            }
         }
      }
   }
}


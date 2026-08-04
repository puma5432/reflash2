package com.hurlant.crypto.hash
{
   import flash.utils.*;
   
   public class SHABase implements IHash
   {
      
      public var pad_size:int = 40;
      
      public function SHABase()
      {
         super();
      }
      
      public function getInputSize() : uint
      {
         return 64;
      }
      
      public function getHashSize() : uint
      {
         return 0;
      }
      
      public function getPadSize() : int
      {
         return this.pad_size;
      }
      
      public function hash(param1:ByteArray) : ByteArray
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = param1.length;
         var _loc4_:String = param1.endian;
         param1.endian = "bigEndian";
         var _loc5_:uint = _loc3_ * 8;
         while(param1.length % 4 != 0)
         {
            param1[param1.length] = 0;
         }
         param1.position = 0;
         var _loc6_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc6_.push(param1.readUnsignedInt());
            _loc2_ += 4;
         }
         var _loc7_:Array = this.core(_loc6_,_loc5_);
         var _loc8_:ByteArray = new ByteArray();
         var _loc9_:uint = uint(this.getHashSize() / 4);
         _loc2_ = 0;
         while(_loc2_ < _loc9_)
         {
            _loc8_.writeUnsignedInt(_loc7_[_loc2_]);
            _loc2_++;
         }
         param1.length = _loc3_;
         param1.endian = _loc4_;
         return _loc8_;
      }
      
      protected function core(param1:Array, param2:uint) : Array
      {
         return null;
      }
      
      public function toString() : String
      {
         return "sha";
      }
   }
}


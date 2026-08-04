package com.hurlant.crypto.hash
{
   public class SHA1 extends SHABase implements IHash
   {
      
      public static const HASH_SIZE:int = 20;
      
      public function SHA1()
      {
         super();
      }
      
      override public function getHashSize() : uint
      {
         return 20;
      }
      
      override protected function core(param1:Array, param2:uint) : Array
      {
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:* = param2 >> 5;
         var _loc12_:* = param1[_loc11_] | 128 << 24 - param2 % 32;
         param1[_loc11_] = _loc12_;
         param1[(param2 + 64 >> 9 << 4) + 15] = param2;
         var _loc13_:Array = [];
         var _loc14_:* = 1732584193;
         var _loc15_:* = 4023233417;
         var _loc16_:* = 2562383102;
         var _loc17_:* = 271733878;
         var _loc18_:* = 3285377520;
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = _loc14_;
            _loc5_ = _loc15_;
            _loc6_ = _loc16_;
            _loc7_ = _loc17_;
            _loc8_ = _loc18_;
            _loc9_ = 0;
            while(_loc9_ < 80)
            {
               if(_loc9_ < 16)
               {
                  _loc13_[_loc9_] = param1[_loc3_ + _loc9_] || 0;
               }
               else
               {
                  _loc13_[_loc9_] = this.rol(_loc13_[_loc9_ - 3] ^ _loc13_[_loc9_ - 8] ^ _loc13_[_loc9_ - 14] ^ _loc13_[_loc9_ - 16],1);
               }
               _loc10_ = this.rol(_loc14_,5) + this.ft(_loc9_,_loc15_,_loc16_,_loc17_) + _loc18_ + _loc13_[_loc9_] + this.kt(_loc9_);
               _loc18_ = _loc17_;
               _loc17_ = _loc16_;
               _loc16_ = this.rol(_loc15_,30);
               _loc15_ = _loc14_;
               _loc14_ = _loc10_;
               _loc9_++;
            }
            _loc14_ += _loc4_;
            _loc15_ += _loc5_;
            _loc16_ += _loc6_;
            _loc17_ += _loc7_;
            _loc18_ += _loc8_;
            _loc3_ += 16;
         }
         return [_loc14_,_loc15_,_loc16_,_loc17_,_loc18_];
      }
      
      private function rol(param1:uint, param2:uint) : uint
      {
         return param1 << param2 | param1 >>> 32 - param2;
      }
      
      private function ft(param1:uint, param2:uint, param3:uint, param4:uint) : uint
      {
         if(param1 < 20)
         {
            return param2 & param3 | ~param2 & param4;
         }
         if(param1 < 40)
         {
            return param2 ^ param3 ^ param4;
         }
         if(param1 < 60)
         {
            return param2 & param3 | param2 & param4 | param3 & param4;
         }
         return param2 ^ param3 ^ param4;
      }
      
      private function kt(param1:uint) : uint
      {
         return param1 < 20 ? 1518500249 : (param1 < 40 ? 1859775393 : (param1 < 60 ? uint(2400959708) : uint(3395469782)));
      }
      
      override public function toString() : String
      {
         return "sha1";
      }
   }
}


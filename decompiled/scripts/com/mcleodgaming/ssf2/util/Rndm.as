package com.mcleodgaming.ssf2.util
{
   public class Rndm
   {
      
      public var seed:uint;
      
      public function Rndm()
      {
         super();
         this.seed = 1;
      }
      
      public function nextInt() : uint
      {
         return this.gen();
      }
      
      public function nextDouble() : Number
      {
         return this.gen() / 2147483647;
      }
      
      public function nextIntRange(param1:Number, param2:Number) : uint
      {
         param1 -= 0.4999;
         param2 += 0.4999;
         return Math.round(param1 + (param2 - param1) * this.nextDouble());
      }
      
      public function nextDoubleRange(param1:Number, param2:Number) : Number
      {
         return param1 + (param2 - param1) * this.nextDouble();
      }
      
      private function gen() : uint
      {
         if(this.seed == 0)
         {
            this.seed = 1;
         }
         return this.seed = this.seed * 16807 % 2147483647;
      }
   }
}


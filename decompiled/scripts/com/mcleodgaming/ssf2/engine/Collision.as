package com.mcleodgaming.ssf2.engine
{
   public class Collision
   {
      
      public var ground:Boolean;
      
      public var leftSide:Boolean;
      
      public var rightSide:Boolean;
      
      public var topSide:Boolean;
      
      public var bottomSide:Boolean;
      
      public var lbound_lower:Boolean;
      
      public var rbound_lower:Boolean;
      
      public var lbound_upper:Boolean;
      
      public var rbound_upper:Boolean;
      
      public function Collision()
      {
         super();
         this.ground = false;
         this.leftSide = false;
         this.rightSide = false;
         this.topSide = false;
         this.bottomSide = false;
         this.lbound_lower = false;
         this.rbound_lower = false;
         this.lbound_upper = false;
         this.rbound_upper = false;
      }
   }
}


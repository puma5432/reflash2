package com.mcleodgaming.ssf2.platforms
{
   public class PlatformMovement
   {
      
      public var moveTime:int;
      
      public var waitTime:int;
      
      public var fallthrough:Boolean;
      
      public var noDropThrough:Boolean;
      
      public var camFocus:Boolean;
      
      public var xSpeed:Number;
      
      public var ySpeed:Number;
      
      public var xAccel:Number;
      
      public var xDecel:Number;
      
      public var yAccel:Number;
      
      public var yDecel:Number;
      
      public function PlatformMovement()
      {
         super();
         this.fallthrough = false;
         this.noDropThrough = false;
         this.camFocus = false;
         this.moveTime = 0;
         this.waitTime = 0;
         this.xSpeed = 0;
         this.ySpeed = 0;
         this.xAccel = 0;
         this.xDecel = 0;
         this.yAccel = 0;
         this.yDecel = 0;
      }
   }
}


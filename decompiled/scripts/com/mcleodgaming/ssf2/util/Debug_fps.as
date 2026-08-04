package com.mcleodgaming.ssf2.util
{
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.*;
   import flash.geom.Point;
   import flash.utils.*;
   
   public class Debug_fps
   {
      
      private var fpsSymbol:Class = Debug_fps_fpsSymbol;
      
      private var fpsHolder:Sprite;
      
      private var pos:Point;
      
      private var stage:Stage;
      
      private var lowest:int;
      
      private var highest:int;
      
      private var checkCounter:int;
      
      private var checkRate:int;
      
      private var lowestResetCnt:int;
      
      private var startTime:Number;
      
      public function Debug_fps(param1:Stage, param2:Point)
      {
         super();
         this.stage = param1;
         this.pos = param2;
         this.lowest = this.stage.frameRate;
         this.highest = 0;
         this.checkCounter = 1;
         this.checkRate = 8;
         this.lowestResetCnt = this.lowest * 5;
         this.startTime = getTimer();
         this.fpsHolder = new this.fpsSymbol();
         this.stage.addChild(this.fpsHolder);
         this.fpsHolder.x = this.pos.x;
         this.fpsHolder.y = this.pos.y;
         this.fpsHolder.addEventListener(Event.ENTER_FRAME,this.mainloop);
      }
      
      public function toString() : String
      {
         return "Debug_fps";
      }
      
      public function get FrameRate() : Number
      {
         return this.fpsHolder.stage.frameRate;
      }
      
      public function set FrameRate(param1:Number) : void
      {
         trace("Frame rate set disabled");
      }
      
      public function get MC() : Sprite
      {
         return this.fpsHolder;
      }
      
      public function kill() : void
      {
         this.fpsHolder.removeEventListener(Event.ENTER_FRAME,this.mainloop);
         if(this.fpsHolder.parent)
         {
            this.fpsHolder.parent.removeChild(this.fpsHolder);
         }
      }
      
      private function mainloop(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         if(--this.checkCounter == 0)
         {
            _loc2_ = this.checkRate / ((getTimer() - this.startTime) / 1000);
            _loc2_ = Math.round(_loc2_ * 10 / 10 * 10) / 10;
            if(_loc2_ > this.fpsHolder.stage.frameRate)
            {
               _loc2_ = Number(this.fpsHolder.stage.frameRate);
            }
            this.fpsHolder["fps"].text = _loc2_;
            if(_loc2_ < this.lowest)
            {
               this.lowest = this.fpsHolder["lowestValue"].text = _loc2_;
            }
            if(_loc2_ > this.highest)
            {
               this.highest = _loc2_;
            }
            this.startTime = getTimer();
            this.checkCounter = this.checkRate;
         }
         if(--this.lowestResetCnt == 0)
         {
            this.lowest = this.fpsHolder["lowestValue"].text = this.highest;
            this.lowestResetCnt = this.fpsHolder.stage.frameRate * 6;
         }
         this.fpsHolder["bar"].height = this.fpsHolder["fps"].text / this.fpsHolder.stage.frameRate * 100 / 4;
         var _loc3_:int = this.stage.numChildren - 1;
         if(this.stage.getChildIndex(this.fpsHolder) < _loc3_)
         {
            this.stage.setChildIndex(this.fpsHolder,_loc3_);
         }
      }
      
      public function setVisible(param1:Boolean) : void
      {
         this.fpsHolder.visible = param1;
      }
   }
}


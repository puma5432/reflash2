package com.mcleodgaming.ssf2.util
{
   public class IntervalTimer
   {
      
      private var _readyToProccess:Boolean;
      
      private var _frameTimer:FrameTimer;
      
      private var _repeats:int;
      
      private var _callback:Function;
      
      private var _active:Boolean;
      
      private var _condition:Function;
      
      private var _inverseCondition:Function;
      
      private var _pauseCondition:Function;
      
      private var _options:Object;
      
      public function IntervalTimer(param1:int, param2:int, param3:Function, param4:Object = null)
      {
         super();
         this._active = true;
         this._readyToProccess = false;
         this._frameTimer = new FrameTimer(param1);
         this._repeats = param2;
         this._callback = param3;
         this._options = param4 || {};
         this._condition = this._options.condition || null;
         this._inverseCondition = this._options.inverseCondition || null;
         this._pauseCondition = this._options.pauseCondition || null;
      }
      
      public function get Options() : Object
      {
         return this._options;
      }
      
      public function get Active() : Boolean
      {
         return this._active;
      }
      
      public function get ReadyToProcess() : Boolean
      {
         return this._readyToProccess;
      }
      
      public function get Callback() : Function
      {
         return this._callback;
      }
      
      public function disableProcess() : void
      {
         this._readyToProccess = false;
      }
      
      public function process() : void
      {
         if(this._readyToProccess)
         {
            this._readyToProccess = false;
            this._callback();
         }
      }
      
      public function tick() : void
      {
         if(this._active)
         {
            if(!(this._pauseCondition != null && this._pauseCondition()))
            {
               this._frameTimer.tick();
            }
            if(this._frameTimer.IsComplete)
            {
               this._frameTimer.reset();
               if(!(this._condition != null && !this._condition()) && !(this._inverseCondition != null && this._inverseCondition()))
               {
                  this._readyToProccess = true;
               }
               if(this._repeats > 0)
               {
                  --this._repeats;
                  if(this._repeats <= 0)
                  {
                     this._active = false;
                  }
               }
            }
         }
      }
   }
}


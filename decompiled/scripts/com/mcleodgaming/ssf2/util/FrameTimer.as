package com.mcleodgaming.ssf2.util
{
   public class FrameTimer
   {
      
      private var m_initTime:int;
      
      private var m_currentTime:int;
      
      public function FrameTimer(param1:int)
      {
         super();
         this.m_initTime = param1;
         this.m_currentTime = 0;
      }
      
      public function get IsComplete() : Boolean
      {
         return Boolean(this.m_currentTime >= this.m_initTime);
      }
      
      public function get MaxTime() : int
      {
         return this.m_initTime;
      }
      
      public function set MaxTime(param1:int) : void
      {
         if(param1 < 0)
         {
            this.m_initTime = 0;
         }
         else
         {
            this.m_initTime = param1;
            if(this.m_currentTime > this.m_initTime)
            {
               this.m_currentTime = this.m_initTime;
            }
         }
      }
      
      public function get CurrentTime() : int
      {
         return this.m_currentTime;
      }
      
      public function set CurrentTime(param1:int) : void
      {
         if(param1 < 0)
         {
            this.m_currentTime = 0;
         }
         else
         {
            this.m_currentTime = param1 > this.MaxTime ? this.MaxTime : param1;
         }
      }
      
      public function tick(param1:int = 1) : void
      {
         this.CurrentTime = this.m_currentTime + param1;
      }
      
      public function finish() : void
      {
         this.m_currentTime = this.m_initTime;
      }
      
      public function reset() : void
      {
         this.m_currentTime = 0;
      }
   }
}


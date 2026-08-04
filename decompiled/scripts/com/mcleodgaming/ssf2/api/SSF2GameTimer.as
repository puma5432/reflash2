package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.engine.GameTimer;
   import flash.display.MovieClip;
   
   public class SSF2GameTimer extends SSF2BaseAPIObject
   {
      
      protected var _ownerCasted:GameTimer;
      
      public function SSF2GameTimer(param1:Class, param2:GameTimer)
      {
         super(param1,param2);
         this._ownerCasted = param2;
      }
      
      public function getCurrentTime() : int
      {
         return this._ownerCasted.CurrentTime;
      }
      
      public function setCurrentTime(param1:int) : void
      {
         this._ownerCasted.setCurrentTime(param1);
      }
      
      public function start() : void
      {
         this._ownerCasted.Start();
      }
      
      public function restart() : void
      {
         this._ownerCasted.Restart();
      }
      
      public function stop() : void
      {
         this._ownerCasted.Stop();
      }
      
      public function getMC() : MovieClip
      {
         return this._ownerCasted.TimeMC;
      }
      
      public function setEndGameOptions(param1:Object) : void
      {
         this._ownerCasted.setEndGameOptions(param1);
      }
   }
}


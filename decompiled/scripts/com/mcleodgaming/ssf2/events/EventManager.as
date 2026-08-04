package com.mcleodgaming.ssf2.events
{
   import flash.events.*;
   
   public class EventManager
   {
      
      private var _eventDispatcher:EventDispatcher;
      
      private var _eventList:Vector.<String>;
      
      private var _functionList:Vector.<Function>;
      
      private var _useCaptureList:Vector.<Boolean>;
      
      public function EventManager()
      {
         super();
         this._eventDispatcher = new EventDispatcher();
         this._eventList = new Vector.<String>();
         this._functionList = new Vector.<Function>();
         this._useCaptureList = new Vector.<Boolean>();
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._eventDispatcher.addEventListener(param1,param2,param3,param4,param5);
         this._eventList.push(param1);
         this._functionList.push(param2);
         this._useCaptureList.push(param3);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         var _loc4_:* = 0;
         while(_loc4_ < this._eventList.length)
         {
            if(param1 == this._eventList[_loc4_] && param2 == this._functionList[_loc4_] && this.hasEvent(param1,param2))
            {
               this._eventList.splice(_loc4_,1);
               this._functionList.splice(_loc4_,1);
               this._useCaptureList.splice(_loc4_,1);
               this._eventDispatcher.removeEventListener(param1,param2,param3);
               _loc4_--;
            }
            _loc4_++;
         }
      }
      
      public function dispatchEvent(param1:Event) : void
      {
         this._eventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEvent(param1:String, param2:Function) : Boolean
      {
         var _loc3_:int = 0;
         while(_loc3_ < this._eventList.length)
         {
            if(param1 == this._eventList[_loc3_] && (param2 == null || param2 == this._functionList[_loc3_]))
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function removeAllEvents() : void
      {
         while(this.Count > 0)
         {
            this.removeEventListener(this._eventList[0],this._functionList[0],this._useCaptureList[0]);
            this._eventList.splice(0,1);
            this._functionList.splice(0,1);
            this._useCaptureList.splice(0,1);
         }
      }
      
      public function get Count() : int
      {
         return this._eventList.length;
      }
   }
}


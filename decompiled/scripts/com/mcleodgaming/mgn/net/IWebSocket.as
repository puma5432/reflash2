package com.mcleodgaming.mgn.net
{
   import flash.events.*;
   import flash.utils.ByteArray;
   
   public interface IWebSocket extends IEventDispatcher
   {
      
      function get url() : String;
      
      function get connected() : Boolean;
      
      function connect() : void;
      
      function sendString(param1:String) : void;
      
      function sendBytes(param1:ByteArray) : void;
      
      function close() : void;
   }
}


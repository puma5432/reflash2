package com.mcleodgaming.mgn.net
{
   import flash.events.*;
   
   public interface IP2PSocket extends IEventDispatcher
   {
      
      function get connected() : Boolean;
      
      function getAckObj() : Object;
      
      function connect() : void;
      
      function sendToAll(param1:Object) : void;
      
      function close() : void;
   }
}


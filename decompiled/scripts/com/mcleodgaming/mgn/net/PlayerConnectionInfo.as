package com.mcleodgaming.mgn.net
{
   public class PlayerConnectionInfo
   {
      
      public var socket_id:String;
      
      public var username:String;
      
      public var user_key:String;
      
      public var is_dev:Boolean;
      
      public function PlayerConnectionInfo(param1:Object = null)
      {
         super();
         this.socket_id = "";
         this.username = "";
         this.user_key = "";
         this.is_dev = false;
         if(param1)
         {
            this.importPlayerConnectionInfo(param1);
         }
      }
      
      public function importPlayerConnectionInfo(param1:Object) : void
      {
         var _loc2_:* = undefined;
         for(_loc2_ in param1)
         {
            if(_loc2_ in this)
            {
               this[_loc2_] = param1[_loc2_];
            }
         }
      }
      
      public function exportPlayerConnectionInfo() : Object
      {
         return {
            "socket_id":this.socket_id,
            "username":this.username,
            "user_key":this.user_key,
            "is_dev":this.is_dev
         };
      }
   }
}


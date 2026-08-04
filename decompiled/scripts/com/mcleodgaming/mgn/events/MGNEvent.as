package com.mcleodgaming.mgn.events
{
   import flash.events.Event;
   
   public class MGNEvent extends Event
   {
      
      public static const SOCKET_CONNECT:String = "MGNEvent:socketConnect";
      
      public static const SOCKET_CLOSE:String = "MGNEvent:socketClose";
      
      public static const SOCKET_ERROR:String = "MGNEvent:socketError";
      
      public static const SOCKET_MESSAGE:String = "MGNEvent:socketMessage";
      
      public static const P2P_CONNECT:String = "MGNEvent:p2pConnect";
      
      public static const P2P_CLOSE:String = "MGNEvent:p2pClose";
      
      public static const P2P_ERROR:String = "MGNEvent:p2pError";
      
      public static const P2P_MESSAGE:String = "MGNEvent:p2pMessage";
      
      public static const CONNECT:String = "connect";
      
      public static const DISCONNECT:String = "disconnect";
      
      public static const LOGIN:String = "login";
      
      public static const ROOM_CREATED:String = "roomCreated";
      
      public static const ROOM_JOIN_REQUEST:String = "roomJoinRequest";
      
      public static const ROOM_JOINED:String = "roomJoined";
      
      public static const ROOM_LIST:String = "roomList";
      
      public static const ROOM_DATA:String = "roomData";
      
      public static const LOCK_ROOM:String = "lockRoom";
      
      public static const UNLOCK_ROOM:String = "unlockRoom";
      
      public static const LEAVE_ROOM:String = "leaveRoom";
      
      public static const MATCH_START:String = "matchStart";
      
      public static const MATCH_READY_STATUS:String = "matchReadyStatus";
      
      public static const MATCH_END:String = "matchEnd";
      
      public static const MATCH_FINISHED:String = "matchFinished";
      
      public static const DATA:String = "data";
      
      public static const NOTIFY:String = "notify";
      
      public static const PLAYER_JOINED:String = "playerJoined";
      
      public static const PLAYER_LEFT:String = "playerLeft";
      
      public static const ERROR_OFFLINE:String = "errorOffline";
      
      public static const ERROR_CONNECT:String = "errorConnect";
      
      public static const ERROR_CONNECT_GAME:String = "errorConnectGame";
      
      public static const ERROR_LOGIN:String = "errorLogin";
      
      public static const ERROR_CREATE_ROOM:String = "errorCreateRoom";
      
      public static const ERROR_REQUEST_TO_JOIN_ROOM:String = "errorRequestToJoinRoom";
      
      public static const ERROR_JOIN_ROOM:String = "errorJoinRoom";
      
      public static const ERROR_ROOM_DATA:String = "errorRoomData";
      
      public static const ERROR_LOCK_ROOM:String = "errorLockRoom";
      
      public static const ERROR_UNLOCK_ROOM:String = "errorUnlockRoom";
      
      public static const ERROR_LEAVE_ROOM:String = "errorLeaveRoom";
      
      public static const ERROR_MATCH_READY_STATUS:String = "errorMatchReadyStatus";
      
      public static const ERROR_PING:String = "errorPing";
      
      public var data:Object;
      
      public function MGNEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.data = param2 || {};
      }
   }
}


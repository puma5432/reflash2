package com.mcleodgaming.mgn.net
{
   import com.mcleodgaming.mgn.events.*;
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.net.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.*;
   
   public class MGNClient
   {
      
      public static const POLICY_FILE:String = "xmlsocket://xmlp.supersmashflash.com:843";
      
      public static const MODE_CLIENT_JOINED:int = 0;
      
      public static const MODE_DATAFRAME_RECEIVED:int = 1;
      
      public static const MODE_RESEND_DATAFRAME:int = 2;
      
      public static const MODE_ACK_REQUEST:int = 3;
      
      public static const MODE_ACK_RESPONSE:int = 4;
      
      public static const MODE_CLIENT_JOINED_RESPONSE:int = 5;
      
      public static const MODE_MATCH_END:int = 6;
      
      public static const MODE_DOWNGRADE_P2P:int = 7;
      
      public static const PACKET_CONTROLS:int = 0;
      
      public static const PACKET_JSON:int = 1;
      
      protected const LOBBY_SERVER:String = "wss://prod1.mgn.supersmashflash.com/";
      
      protected var RESEND_TIME:int = 90;
      
      protected var m_protocol:String;
      
      protected var m_ipAddress:String;
      
      protected var m_lobbySocket:IWebSocket;
      
      protected var m_lobbyLoginToken:String;
      
      protected var m_lobbySocketID:String;
      
      protected var m_gameSocket:IWebSocket;
      
      protected var m_gameSocketID:String;
      
      protected var m_gameSocketUrl:String;
      
      protected var m_maxPlayers:int;
      
      protected var m_players:Vector.<PlayerConnectionInfo>;
      
      protected var m_userName:String;
      
      protected var m_userKey:String;
      
      protected var m_version:String;
      
      protected var m_playerID:int;
      
      protected var m_active:Boolean;
      
      protected var m_isHost:Boolean;
      
      protected var m_resendTimer:int;
      
      protected var m_matchStarted:Boolean;
      
      protected var m_currentHostID:String;
      
      protected var m_isDev:Boolean;
      
      protected var m_lastSentPing:int;
      
      protected var m_pingRoundTripTime:int;
      
      private var m_password:String;
      
      protected var m_roomList:Array;
      
      protected var m_currentRoomKey:String;
      
      protected var m_currentRoomName:String;
      
      protected var m_currentRoomCode:String;
      
      protected var m_currentRoomPassword:String;
      
      protected var m_currentRoomCapacity:int;
      
      protected var m_currentPartyID:String;
      
      protected var m_roomData:Object;
      
      protected var m_roomLocked:Boolean;
      
      protected var m_playerData:Array;
      
      protected var m_playerSyncStream:PlayerDataSyncStream;
      
      protected var m_controlBits:Vector.<Vector.<int>>;
      
      protected var m_masterFrame:int;
      
      protected var m_p2pSocket:IP2PSocket;
      
      protected var m_pingTimer:Timer;
      
      protected var m_timeoutTimer:Timer;
      
      protected var m_gameSocketTimeout:Timer;
      
      protected var m_downgradedConnection:Boolean;
      
      public function MGNClient(param1:int)
      {
         var maxPlayers:int = param1;
         super();
         this.m_maxPlayers = maxPlayers;
         this.init();
         this.m_pingTimer = new Timer(30 * 1000);
         this.m_pingTimer.addEventListener(TimerEvent.TIMER,this.onPingInterval);
         this.m_timeoutTimer = new Timer(30 * 1000,1);
         this.m_gameSocketTimeout = new Timer(10 * 1000,1);
         this.m_timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,function(param1:TimerEvent):void
         {
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.NOTIFY,{"message":"Connection timeout."}));
            disconnect();
         });
         this.m_gameSocketTimeout.addEventListener(TimerEvent.TIMER_COMPLETE,function(param1:TimerEvent):void
         {
            disconnectGameServer();
            m_gameSocketTimeout.stop();
         });
      }
      
      public function get SocketID() : String
      {
         return this.m_lobbySocketID;
      }
      
      public function get CurrentHostID() : String
      {
         return this.m_currentHostID;
      }
      
      public function get UserKey() : String
      {
         return this.m_userKey;
      }
      
      public function get Username() : String
      {
         return this.m_userName;
      }
      
      public function get RoomList() : Array
      {
         return this.m_roomList;
      }
      
      public function get ControlBits() : Vector.<Vector.<int>>
      {
         return this.m_controlBits;
      }
      
      public function get Connected() : Boolean
      {
         return Boolean(this.m_lobbySocket) && this.m_lobbySocket.connected;
      }
      
      public function get Active() : Boolean
      {
         return this.m_active;
      }
      
      public function set Active(param1:Boolean) : void
      {
         this.m_active = param1;
      }
      
      public function get MaxPlayers() : int
      {
         return this.m_maxPlayers;
      }
      
      public function get MasterFrame() : int
      {
         return this.m_masterFrame;
      }
      
      public function set MasterFrame(param1:int) : void
      {
         this.m_masterFrame = param1;
      }
      
      public function get Protocol() : String
      {
         return this.m_protocol;
      }
      
      public function set Protocol(param1:String) : void
      {
         this.m_protocol = param1;
      }
      
      public function get DowngradedConnection() : Boolean
      {
         return this.m_downgradedConnection;
      }
      
      public function get PlayerID() : int
      {
         return this.m_playerID;
      }
      
      public function set PlayerID(param1:int) : void
      {
         this.m_playerID = param1;
      }
      
      public function get Players() : Vector.<PlayerConnectionInfo>
      {
         return this.m_players;
      }
      
      public function get RoomKey() : String
      {
         return this.m_currentRoomKey;
      }
      
      public function get RoomName() : String
      {
         return this.m_currentRoomCode;
      }
      
      public function get CurrentPartyID() : String
      {
         return this.m_currentPartyID;
      }
      
      public function get RoomLocked() : Boolean
      {
         return this.m_roomLocked;
      }
      
      public function get IsHost() : Boolean
      {
         return this.m_isHost;
      }
      
      public function get PlayerConnectionInfoList() : Vector.<PlayerConnectionInfo>
      {
         return this.m_players;
      }
      
      public function get PlayerSyncStream() : PlayerDataSyncStream
      {
         return this.m_playerSyncStream;
      }
      
      protected function init(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         if(!param1)
         {
            this.m_userName = "";
         }
         this.m_userKey = null;
         this.m_playerID = 0;
         this.m_masterFrame = 1;
         this.m_roomData = null;
         this.m_playerData = null;
         this.m_roomList = new Array();
         this.m_active = false;
         this.m_isHost = true;
         this.m_resendTimer = this.RESEND_TIME;
         this.m_matchStarted = false;
         this.m_currentHostID = null;
         this.m_isDev = false;
         this.m_lastSentPing = 0;
         this.m_pingRoundTripTime = 0;
         this.m_downgradedConnection = false;
         this.m_protocol = ProtocolSetting.P2P_UDP;
         this.m_controlBits = new Vector.<Vector.<int>>();
         while(_loc2_ < this.m_maxPlayers)
         {
            this.m_controlBits.push(new Vector.<int>());
            _loc2_++;
         }
         this.m_lobbySocket = null;
         this.m_gameSocket = null;
         this.m_gameSocketID = null;
         this.m_gameSocketUrl = null;
         this.m_currentRoomCode = null;
         this.m_currentRoomKey = "";
         this.m_currentRoomName = "";
         this.m_currentRoomPassword = "";
         this.m_currentRoomCapacity = 0;
         this.m_currentPartyID = "";
         this.m_roomLocked = false;
         this.m_lobbySocketID = null;
         this.m_playerSyncStream = new PlayerDataSyncStream();
         this.m_players = new Vector.<PlayerConnectionInfo>();
      }
      
      public function resetMasterFrame() : void
      {
         var _loc1_:int = 0;
         this.m_masterFrame = 1;
         this.m_playerSyncStream.init(this.m_players.length);
         this.m_controlBits = new Vector.<Vector.<int>>();
         while(_loc1_ < this.m_maxPlayers)
         {
            this.m_controlBits.push(new Vector.<int>());
            _loc1_++;
         }
      }
      
      public function getFrameDelay() : int
      {
         return this.m_playerSyncStream.Pointer - this.m_masterFrame;
      }
      
      public function connect(param1:String, param2:String, param3:String) : void
      {
         if(!this.m_lobbySocket)
         {
            this.m_userName = param1;
            this.m_password = param2;
            this.m_version = param3;
            this.m_lobbySocket = new WebSocketWorlize(this.LOBBY_SERVER);
            this.m_lobbySocket.addEventListener(MGNEvent.SOCKET_CONNECT,this.handleLobbyConnect);
            this.m_lobbySocket.addEventListener(MGNEvent.SOCKET_CLOSE,this.handleLobbyDisconnect);
            this.m_lobbySocket.addEventListener(MGNEvent.SOCKET_MESSAGE,this.onLobbySocketMessage);
            this.m_lobbySocket.addEventListener(MGNEvent.SOCKET_ERROR,this.handleLobbyConnectError);
            this.m_lobbySocket.connect();
            this.m_timeoutTimer.start();
         }
      }
      
      private function connectGameServer(param1:String) : void
      {
         if(this.m_gameSocket)
         {
            this.m_gameSocket.removeEventListener(MGNEvent.SOCKET_CONNECT,this.handleGameConnect);
            this.m_gameSocket.removeEventListener(MGNEvent.SOCKET_CLOSE,this.handleGameDisconnect);
            this.m_gameSocket.removeEventListener(MGNEvent.SOCKET_MESSAGE,this.onGameSocketMessage);
            this.m_gameSocket.removeEventListener(MGNEvent.SOCKET_ERROR,this.handleGameConnectError);
            this.m_gameSocket.close();
            this.m_gameSocket = null;
         }
         this.m_gameSocket = new WebSocketWorlize(param1);
         this.m_gameSocket.addEventListener(MGNEvent.SOCKET_CONNECT,this.handleGameConnect);
         this.m_gameSocket.addEventListener(MGNEvent.SOCKET_CLOSE,this.handleGameDisconnect);
         this.m_gameSocket.addEventListener(MGNEvent.SOCKET_MESSAGE,this.onGameSocketMessage);
         this.m_gameSocket.addEventListener(MGNEvent.SOCKET_ERROR,this.handleGameConnectError);
         this.m_gameSocket.connect();
         this.m_gameSocketTimeout.start();
      }
      
      public function disconnect(param1:Boolean = false) : void
      {
         if(this.m_lobbySocket)
         {
            this.m_timeoutTimer.stop();
            this.m_pingTimer.stop();
            this.disconnectGameServer();
            this.disconnectP2PServer();
            if(this.m_lobbySocket)
            {
               this.m_lobbySocket.removeEventListener(MGNEvent.SOCKET_CONNECT,this.handleLobbyConnect);
               this.m_lobbySocket.removeEventListener(MGNEvent.SOCKET_CLOSE,this.handleLobbyDisconnect);
               this.m_lobbySocket.removeEventListener(MGNEvent.SOCKET_MESSAGE,this.onLobbySocketMessage);
               this.m_lobbySocket.removeEventListener(MGNEvent.SOCKET_ERROR,this.handleLobbyConnectError);
               if(this.m_lobbySocket.connected)
               {
                  this.m_lobbySocket.close();
               }
            }
            this.m_lobbySocket = null;
            this.init(param1);
            if(!param1)
            {
               MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.DISCONNECT,{}));
            }
         }
         trace("Disconnected from lobby server. (Purposefully)");
      }
      
      private function disconnectGameServer() : void
      {
         if(this.m_gameSocket)
         {
            this.m_gameSocket.removeEventListener(MGNEvent.SOCKET_CONNECT,this.handleGameConnect);
            this.m_gameSocket.removeEventListener(MGNEvent.SOCKET_CLOSE,this.handleGameDisconnect);
            this.m_gameSocket.removeEventListener(MGNEvent.SOCKET_MESSAGE,this.onGameSocketMessage);
            this.m_gameSocket.removeEventListener(MGNEvent.SOCKET_ERROR,this.handleGameConnectError);
            if(this.m_gameSocket.connected)
            {
               this.m_gameSocket.close();
            }
            trace("Disconnected from game server. (Purposefully)");
         }
         this.m_gameSocket = null;
      }
      
      private function disconnectP2PServer() : void
      {
         if(this.m_p2pSocket)
         {
            this.m_p2pSocket.close();
         }
         trace("Disconnected from P2P server. (Purposefully)");
      }
      
      private function socketHelper(param1:IWebSocket, param2:*, param3:String) : void
      {
         var _loc4_:String = null;
         if(param3 == "binary")
         {
            param1.sendBytes(param2 as ByteArray);
         }
         else if(param3 == "string")
         {
            param1.sendString(param2);
         }
         else
         {
            if(param3 != "object")
            {
               throw new Error("Error, socket data type not supported: " + param3);
            }
            param1.sendString(JSON.stringify(param2));
         }
      }
      
      private function handleLobbyConnect(param1:MGNEvent) : void
      {
         this.socketHelper(this.m_lobbySocket,{
            "type":"login",
            "username":this.m_userName,
            "password":this.m_password,
            "version":this.m_version
         },"object");
      }
      
      private function handleLobbyConnectError(param1:MGNEvent) : void
      {
         this.m_timeoutTimer.stop();
         trace("Got error ",param1);
         MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.NOTIFY,{"message":"Could not connect to server."}));
         MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ERROR_CONNECT,{}));
         this.disconnect();
      }
      
      private function handleLobbyDisconnect(param1:MGNEvent = null) : void
      {
         this.m_timeoutTimer.stop();
         this.m_pingTimer.stop();
         trace("Disconnected from lobby server. (Lost Connection)");
         this.disconnect();
      }
      
      private function handleGameConnect(param1:MGNEvent) : void
      {
         this.socketHelper(this.m_gameSocket,{
            "type":"validateRoom",
            "room_key":this.m_currentRoomKey,
            "room_code":this.m_currentRoomCode
         },"object");
      }
      
      private function handleGameConnectError(param1:MGNEvent) : void
      {
         trace("Got error ",param1);
         MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ERROR_CONNECT_GAME,{"message":"Problem connecting to game server."}));
      }
      
      private function handleGameDisconnect(param1:MGNEvent = null) : void
      {
         trace("Disconnected from game server. (Lost Connection)");
         this.disconnect();
      }
      
      private function onGameSocketMessage(param1:MGNEvent) : void
      {
         var _loc2_:Object = param1.data.data;
         if(_loc2_ is ByteArray)
         {
            this.receiveMessage(this.readBinaryPacket(_loc2_ as ByteArray));
         }
         else if(_loc2_.type == "broadcast" || _loc2_.type == "directMessage")
         {
            switch(_loc2_.data.type)
            {
               case "neighborLeave":
                  this.participantDisconnected(_loc2_.data.id);
                  break;
               case "broadcast":
                  this.receiveMessage(_loc2_.data);
                  break;
               case "directMessage":
                  this.receiveMessage(_loc2_.data);
            }
         }
         else if(_loc2_.type == "validateRoomSuccess")
         {
            this.m_gameSocketID = _loc2_.sid;
            this.m_matchStarted = true;
            this.m_gameSocketTimeout.stop();
            trace("Room validated successfully, we can start match communication.");
            if(!this.m_downgradedConnection)
            {
               MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.MATCH_START,{
                  "room_data":this.m_roomData,
                  "player_data":this.m_playerData
               }));
            }
            else
            {
               MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.NOTIFY,{"message":"Successfully downgraded P2P connection"}));
            }
         }
         else if(_loc2_.type == "validateRoomError")
         {
            trace("Error, there was a problem validating the room data.");
         }
      }
      
      private function onLobbySocketMessage(param1:MGNEvent) : void
      {
         var _loc2_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc3_:Object = param1.data.data;
         if(_loc3_.type == "directMessage" || _loc3_.type == "broadcast")
         {
            _loc3_ = _loc3_.data;
         }
         if(Boolean(_loc3_.message) && _loc3_.type !== "loginSuccess")
         {
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.NOTIFY,{"message":_loc3_.message}));
         }
         if(_loc3_.type == "connectSuccess")
         {
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.CONNECT,{}));
         }
         else if(_loc3_.type == "loginSuccess")
         {
            this.m_lobbyLoginToken = _loc3_.login_token;
            this.m_ipAddress = _loc3_.ip;
            this.socketHelper(this.m_lobbySocket,{
               "type":"loginValidate",
               "username":this.m_userName,
               "login_token":this.m_lobbyLoginToken
            },"object");
         }
         else if(_loc3_.type == "loginValidateSuccess")
         {
            this.m_timeoutTimer.stop();
            this.m_userName = _loc3_.username;
            this.m_userKey = _loc3_.user_key;
            this.m_lobbySocketID = _loc3_.sid;
            this.m_isDev = _loc3_.is_dev;
            this.m_password = null;
            this.m_pingTimer.reset();
            this.m_pingTimer.start();
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.LOGIN,{}));
         }
         else if(_loc3_.type == "listRoomsSuccess")
         {
            this.getRoomList(_loc3_.rooms);
         }
         else if(_loc3_.type == "getRoomUsersSuccess")
         {
            trace("Got room user list");
         }
         else if(_loc3_.type == "roomJoinRequest")
         {
            if(this.m_players.length >= this.m_maxPlayers)
            {
               this.socketHelper(this.m_lobbySocket,{
                  "type":"directMessage",
                  "target":_loc3_.sid,
                  "data":{
                     "type":"requestToJoinRoomError",
                     "message":"Could not join, room is full."
                  }
               },"object");
            }
            else if(this.m_roomLocked)
            {
               this.socketHelper(this.m_lobbySocket,{
                  "type":"directMessage",
                  "target":_loc3_.sid,
                  "data":{
                     "type":"requestToJoinRoomError",
                     "message":"Could not join, room was locked."
                  }
               },"object");
            }
            else
            {
               MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ROOM_JOIN_REQUEST,{"playerConnectionInfo":new PlayerConnectionInfo({
                  "username":_loc3_.username,
                  "user_key":_loc3_.user_key,
                  "socket_id":_loc3_.sid,
                  "is_dev":_loc3_.is_dev
               })}));
            }
         }
         else if(_loc3_.type == "requestToJoinRoomSuccess")
         {
            this.m_players = new Vector.<PlayerConnectionInfo>();
            this.m_currentHostID = _loc3_.sid;
            this.m_protocol = _loc3_.protocol;
            this.joinRoom(_loc3_.room_key,_loc3_.room_code);
         }
         else if(_loc3_.type == "joinRoomSuccess")
         {
            this.m_isHost = false;
            this.handleJoin(_loc3_);
            this.m_currentPartyID = Utils.random().toString();
            _loc4_ = {
               "k":_loc3_.room_key.toString(),
               "c":_loc3_.room_code.toString(),
               "p":this.m_currentRoomPassword,
               "m":this.m_currentRoomCapacity
            };
            _loc5_ = JSON.stringify(_loc4_);
            trace("[MGNClient] ROOM_JOINED - joinRoomSuccess");
            trace("[MGNClient]   - partyID (NEW): " + this.m_currentPartyID);
            trace("[MGNClient]   - joinSecret: " + _loc5_);
            trace("[MGNClient]   - room_key: " + _loc3_.room_key);
            trace("[MGNClient]   - room_code: " + _loc3_.room_code);
            trace("[MGNClient]   - players: " + this.m_players.length + "/" + this.m_currentRoomCapacity);
            Main.m_sdk.updateActivity({
               "details":"In Online Lobby",
               "partyMaxSize":this.m_currentRoomCapacity,
               "partyCurrentSize":this.m_players.length,
               "partyID":this.m_currentPartyID,
               "matchSecret":_loc3_.room_key.toString(),
               "joinSecret":JSON.stringify(_loc4_)
            });
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ROOM_JOINED,{}));
         }
         else if(_loc3_.type == "createRoomSuccess")
         {
            this.m_isHost = true;
            this.m_currentPartyID = Utils.random().toString();
            _loc4_ = {
               "k":_loc3_.room_key.toString(),
               "c":_loc3_.room_code.toString(),
               "p":this.m_currentRoomPassword,
               "m":this.m_currentRoomCapacity
            };
            _loc5_ = JSON.stringify(_loc4_);
            trace("[MGNClient] ROOM_CREATED - createRoomSuccess");
            trace("[MGNClient]   - partyID (NEW): " + this.m_currentPartyID);
            trace("[MGNClient]   - joinSecret: " + _loc5_);
            trace("[MGNClient]   - room_key: " + _loc3_.room_key);
            trace("[MGNClient]   - room_code: " + _loc3_.room_code);
            trace("[MGNClient]   - players: " + this.m_players.length + "/" + this.m_currentRoomCapacity);
            Main.m_sdk.updateActivity({
               "details":"In Online Lobby",
               "partyMaxSize":this.m_currentRoomCapacity,
               "partyCurrentSize":this.m_players.length,
               "partyID":this.m_currentPartyID,
               "matchSecret":_loc3_.room_key.toString(),
               "joinSecret":_loc5_
            });
            this.handleJoin(_loc3_);
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ROOM_CREATED,{}));
         }
         else if(_loc3_.type == "startMatch")
         {
            this.m_currentRoomCode = _loc3_.room_code;
            this.m_gameSocketUrl = _loc3_.url;
            this.initMatch(_loc3_);
         }
         else if(_loc3_.type == "setRoomDataSuccess")
         {
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ROOM_DATA,{}));
         }
         else if(_loc3_.type == "lockRoomSuccess")
         {
            this.m_roomLocked = true;
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.LOCK_ROOM,{}));
         }
         else if(_loc3_.type == "unlockRoomSuccess")
         {
            this.m_roomLocked = false;
            this.m_matchStarted = false;
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.UNLOCK_ROOM,{}));
         }
         else if(_loc3_.type == "leaveRoomSuccess")
         {
            this.m_roomData = null;
            this.m_currentRoomCode = null;
            this.m_currentRoomKey = "";
            this.m_currentRoomName = "";
            this.m_players = new Vector.<PlayerConnectionInfo>();
            if(this.m_p2pSocket)
            {
               this.m_p2pSocket.close();
            }
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.LEAVE_ROOM,{}));
         }
         else if(_loc3_.type == "neighborLeave")
         {
            this.participantDisconnected(_loc3_.id);
         }
         else if(_loc3_.type == "broadcast" || _loc3_.type == "directMessage")
         {
            this.receiveMessage(_loc3_);
         }
         else if(_loc3_.type == "setReadySuccess")
         {
            trace("Received match ready success");
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.MATCH_READY_STATUS,{}));
         }
         else if(_loc3_.type == "finishMatch")
         {
            trace("Received match finish signal");
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.MATCH_FINISHED,{}));
            this.m_matchStarted = false;
            this.disconnectGameServer();
         }
         else if(_loc3_.type == "pingSuccess")
         {
            if(!this.m_pingRoundTripTime)
            {
               this.m_pingRoundTripTime = new Date().getTime() - this.m_lastSentPing;
               this.ping();
            }
            else
            {
               this.m_pingRoundTripTime = new Date().getTime() - this.m_lastSentPing;
            }
         }
         else if(_loc3_.type == "connectError")
         {
            trace("Error, problem logging in");
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.NOTIFY,{"message":"Could not communicate with server."}));
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ERROR_OFFLINE,{}));
            this.disconnect();
         }
         else if(_loc3_.type == "loginError")
         {
            trace("Error, problem logging in");
            this.m_timeoutTimer.stop();
            this.disconnect();
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ERROR_LOGIN,{"message":_loc3_.message || null}));
         }
         else if(_loc3_.type == "listRoomsError")
         {
            trace("Error, could not retrieve rooms list");
         }
         else if(_loc3_.type == "getRoomUsersError")
         {
            trace("Error, could not retrieve room user list");
         }
         else if(_loc3_.type == "requestToJoinRoomError")
         {
            trace("Error, there was a problem trying to join the room.");
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ERROR_REQUEST_TO_JOIN_ROOM,{"message":_loc3_.message || null}));
         }
         else if(_loc3_.type == "joinRoomError")
         {
            trace("Error, there was a problem trying to join the room.");
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ERROR_CREATE_ROOM,{}));
         }
         else if(_loc3_.type == "createRoomError")
         {
            trace("Error, there was a problem trying to create a room.");
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ERROR_JOIN_ROOM,{}));
         }
         else if(_loc3_.type == "lockRoomError")
         {
            trace("Error, there was a problem trying to lock the room.");
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ERROR_LOCK_ROOM,{}));
         }
         else if(_loc3_.type == "unlockRoomError")
         {
            trace("Error, there was a problem trying to unlock the room.");
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ERROR_UNLOCK_ROOM,{}));
         }
         else if(_loc3_.type == "leaveRoomError")
         {
            trace("Error, there was a problem trying to leave the room.");
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ERROR_LEAVE_ROOM,{}));
         }
         else if(_loc3_.type == "setReadyError")
         {
            trace("Error, there was a problem trying to set ready status on the room.");
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ERROR_MATCH_READY_STATUS,{}));
         }
         else if(_loc3_.type == "setRoomDataError")
         {
            trace("Error, there was a problem trying to update the room data.");
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ERROR_ROOM_DATA,{}));
         }
         else if(_loc3_.type == "startMatchError")
         {
            trace("Error, there was a problem starting the match");
         }
         else if(_loc3_.type == "finishMatchError")
         {
            trace("Error, there was a problem ending the match");
         }
         else if(_loc3_.type == "pingError")
         {
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ERROR_PING,{}));
         }
      }
      
      public function sendMatchReadySignal(param1:Object) : void
      {
         this.socketHelper(this.m_lobbySocket,{
            "type":"setReady",
            "player_data":{
               "data":param1,
               "protocol":this.m_protocol
            }
         },"object");
      }
      
      public function sendMatchFinishedSignal(param1:Object) : void
      {
         this.socketHelper(this.m_lobbySocket,{
            "type":"setFinish",
            "player_data":{
               "data":param1,
               "protocol":this.m_protocol
            }
         },"object");
      }
      
      public function sendMatchEndSignal() : void
      {
         this.broadcast({
            "type":"broadcast",
            "mode":MODE_MATCH_END,
            "sender":this.m_lobbySocketID
         });
      }
      
      public function sendMatchSettings(param1:Object) : void
      {
         this.socketHelper(this.m_lobbySocket,{
            "type":"setRoomData",
            "room_data":param1
         },"object");
      }
      
      public function createRoom(param1:String, param2:String, param3:int, param4:Object) : void
      {
         this.createJoinRoom(param1,param2,param3,param4);
      }
      
      public function requestToJoinRoom(param1:String, param2:String) : void
      {
         if(Boolean(this.m_lobbySocket) && this.m_lobbySocket.connected)
         {
            this.m_currentRoomCapacity = MultiplayerManager.ROOM_CAPACITY;
            this.socketHelper(this.m_lobbySocket,{
               "type":"requestToJoinRoom",
               "room_key":param1,
               "room_password":param2
            },"object");
         }
      }
      
      public function acceptRoomJoinRequest(param1:PlayerConnectionInfo) : void
      {
         if(Boolean(this.m_lobbySocket) && this.m_lobbySocket.connected)
         {
            if(this.m_players.length < this.m_maxPlayers)
            {
               this.m_players.push(param1);
               this.socketHelper(this.m_lobbySocket,{
                  "type":"directMessage",
                  "target":param1.socket_id,
                  "data":{
                     "type":"requestToJoinRoomSuccess",
                     "message":"Request accepted by host.",
                     "room_key":this.m_currentRoomKey,
                     "room_code":this.m_currentRoomCode,
                     "player_index":this.m_players.length - 1,
                     "sid":this.m_lobbySocketID,
                     "protocol":this.m_protocol
                  }
               },"object");
            }
            else
            {
               this.socketHelper(this.m_lobbySocket,{
                  "type":"directMessage",
                  "target":param1.socket_id,
                  "data":{
                     "type":"requestToJoinRoomError",
                     "message":"Room is full."
                  }
               },"object");
            }
         }
      }
      
      public function declineRoomJoinRequest(param1:PlayerConnectionInfo) : void
      {
         if(Boolean(this.m_lobbySocket) && this.m_lobbySocket.connected)
         {
            this.socketHelper(this.m_lobbySocket,{
               "type":"directMessage",
               "target":param1.socket_id,
               "data":{
                  "type":"requestToJoinRoomError",
                  "message":"Request denied by room host."
               }
            },"object");
         }
      }
      
      public function joinRoom(param1:String, param2:String) : void
      {
         if(Boolean(this.m_lobbySocket) && this.m_lobbySocket.connected)
         {
            this.socketHelper(this.m_lobbySocket,{
               "type":"joinRoom",
               "room_key":param1,
               "room_code":param2
            },"object");
         }
      }
      
      public function createJoinRoom(param1:String, param2:String, param3:int, param4:Object) : void
      {
         if(Boolean(this.m_lobbySocket) && this.m_lobbySocket.connected)
         {
            this.m_currentRoomCapacity = param3;
            this.m_currentRoomPassword = param2;
            this.socketHelper(this.m_lobbySocket,{
               "type":"createRoom",
               "room_name":param1,
               "room_password":param2,
               "room_capacity":param3,
               "room_data":param4
            },"object");
         }
      }
      
      public function refreshRoomList(param1:Boolean = false) : void
      {
         if(this.m_lobbySocket.connected)
         {
            this.socketHelper(this.m_lobbySocket,{
               "type":"listRooms",
               "friendsOnly":param1
            },"object");
         }
      }
      
      private function getRoomList(param1:Array) : void
      {
         var _loc2_:int = 0;
         this.m_roomList.splice(0,this.m_roomList.length);
         trace("Found: " + param1.length + " other rooms");
         while(_loc2_ < param1.length)
         {
            this.m_roomList.push(param1[_loc2_]);
            _loc2_++;
         }
         MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ROOM_LIST,{
            "rooms":this.m_roomList,
            "message":"Room listing refresh complete."
         }));
      }
      
      public function lockRoom() : void
      {
         this.socketHelper(this.m_lobbySocket,{"type":"lockRoom"},"object");
      }
      
      public function unlockRoom() : void
      {
         this.socketHelper(this.m_lobbySocket,{"type":"unlockRoom"},"object");
      }
      
      public function leaveRoom() : void
      {
         this.socketHelper(this.m_lobbySocket,{"type":"leaveRoom"},"object");
      }
      
      public function sendMyDataFrame(param1:int, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:Vector.<DataFrameGroup> = null;
         var _loc6_:DataFrameGroup = null;
         if(this.m_active)
         {
            _loc4_ = new Object();
            _loc4_.playerID = this.m_playerID;
            _loc4_.mode = MODE_DATAFRAME_RECEIVED;
            _loc4_.dataList = [];
            _loc4_.type = "broadcast";
            this.m_playerSyncStream.updateDataFrame(param1,this.m_playerID - 1,param2);
            _loc5_ = this.m_playerSyncStream.getSurroundingDataFrames(3,4);
            _loc3_ = 0;
            while(_loc3_ < _loc5_.length)
            {
               _loc6_ = _loc5_[_loc3_];
               if(!_loc6_.getDataFrameFor(this.m_playerID - 1).isReady())
               {
                  break;
               }
               _loc4_.dataList.push({
                  "masterFrame":_loc6_.Frame,
                  "data":_loc6_.getDataFrameFor(this.m_playerID - 1).getData()
               });
               _loc3_++;
            }
            this.updateControls();
            this.broadcast(this.writeBinaryPacket(PACKET_CONTROLS,_loc4_));
         }
      }
      
      public function checkResend() : void
      {
         --this.m_resendTimer;
         if(this.m_resendTimer < 0)
         {
            this.tryToRetrieve(this.m_playerSyncStream.Pointer + 1);
            this.m_resendTimer = this.RESEND_TIME;
         }
      }
      
      private function tryToRetrieve(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:DataFrameGroup = this.m_playerSyncStream.getDataFrameGroup(param1);
         if(Boolean(_loc3_) && !_loc3_.Complete)
         {
            trace("Too long of a delay, attempting to retrieve frame " + param1 + " data from another player.");
            _loc2_ = 0;
            while(_loc2_ < _loc3_.Size)
            {
               if(_loc2_ + 1 != this.m_playerID && !_loc3_.getDataFrameFor(_loc2_).isReady())
               {
                  this.resendRequest({
                     "frame":param1,
                     "playerID":_loc2_ + 1
                  });
               }
               _loc2_++;
            }
         }
      }
      
      public function resendRequest(param1:Object) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.playerID = param1.playerID;
         _loc2_.mode = MODE_RESEND_DATAFRAME;
         _loc2_.masterFrame = param1.frame;
         _loc2_.type = "broadcast";
         this.broadcast(_loc2_);
      }
      
      public function broadcast(param1:Object) : void
      {
         if(this.m_protocol !== ProtocolSetting.CLIENT_SERVER_TCP && Boolean(this.m_p2pSocket))
         {
            this.m_p2pSocket.sendToAll(param1);
         }
         else if(Boolean(this.m_protocol == ProtocolSetting.CLIENT_SERVER_TCP) && Boolean(this.m_gameSocket) && this.m_gameSocket.connected)
         {
            if(param1 is ByteArray)
            {
               this.socketHelper(this.m_gameSocket,param1,"binary");
            }
            else
            {
               this.socketHelper(this.m_gameSocket,{
                  "type":"broadcast",
                  "data":param1
               },"object");
            }
         }
      }
      
      private function handleJoin(param1:Object) : void
      {
         var _loc2_:Object = null;
         if(this.m_lobbySocket.connected)
         {
            this.m_lobbySocketID = param1.sid;
            this.m_currentRoomKey = param1.room_key;
            this.m_currentRoomCode = param1.room_code;
            this.m_currentRoomName = param1.room_name;
            this.m_players.push(new PlayerConnectionInfo({
               "username":this.m_userName,
               "user_key":this.m_userKey,
               "socket_id":this.m_lobbySocketID,
               "host":this.m_isHost,
               "is_dev":this.m_isDev
            }));
            trace("Sucessfully joined room: " + param1.room_name + " w/ player index " + this.m_playerID);
            if(this.m_p2pSocket)
            {
               this.m_p2pSocket.removeEventListener(MGNEvent.P2P_CONNECT,this.onP2PConnect);
               this.m_p2pSocket.removeEventListener(MGNEvent.P2P_ERROR,this.onP2PError);
               this.m_p2pSocket.removeEventListener(MGNEvent.P2P_CLOSE,this.onP2PClose);
               this.m_p2pSocket.removeEventListener(MGNEvent.P2P_MESSAGE,this.onP2PMessage);
               this.m_p2pSocket.close();
               this.m_p2pSocket = null;
            }
            if(this.m_protocol !== ProtocolSetting.CLIENT_SERVER_TCP)
            {
               this.m_p2pSocket = this.m_protocol === ProtocolSetting.P2P_UDP ? new P2PDatagramSocket(this.m_lobbySocket,this.m_ipAddress) : (this.m_protocol === ProtocolSetting.P2P_RTMFP ? new P2PRTMFP(this.m_lobbySocket,this.m_isHost,this.m_ipAddress) : new P2PServerSocket(this.m_lobbySocket,this.m_ipAddress));
               this.m_p2pSocket.addEventListener(MGNEvent.P2P_CONNECT,this.onP2PConnect);
               this.m_p2pSocket.addEventListener(MGNEvent.P2P_ERROR,this.onP2PError);
               this.m_p2pSocket.addEventListener(MGNEvent.P2P_CLOSE,this.onP2PClose);
               this.m_p2pSocket.addEventListener(MGNEvent.P2P_MESSAGE,this.onP2PMessage);
               this.m_p2pSocket.connect();
            }
            _loc2_ = new Object();
            _loc2_.mode = MODE_CLIENT_JOINED;
            _loc2_.username = this.m_userName;
            _loc2_.user_key = this.m_userKey;
            _loc2_.sender = this.m_lobbySocketID;
            _loc2_.playerID = this.m_playerID;
            _loc2_.type = "broadcast";
            _loc2_.is_dev = this.m_isDev;
            this.socketHelper(this.m_lobbySocket,{
               "type":"broadcast",
               "data":_loc2_
            },"object");
         }
      }
      
      private function receiveControls(param1:Object) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.m_players.length)
         {
            this.m_controlBits[_loc2_].push(param1["player" + (_loc2_ + 1)].controls);
            _loc2_++;
         }
      }
      
      public function ping() : void
      {
         if(Boolean(this.m_lobbySocket) && this.m_lobbySocket.connected)
         {
            this.m_lastSentPing = new Date().getTime();
            this.socketHelper(this.m_lobbySocket,{
               "type":"ping",
               "ping_average":this.m_pingRoundTripTime
            },"object");
         }
         else
         {
            trace("Cannot ping with disconnected lobby");
         }
      }
      
      private function onPingInterval(param1:TimerEvent) : void
      {
         this.ping();
      }
      
      private function writeBinaryPacket(param1:int, param2:Object) : ByteArray
      {
         var _loc3_:ByteArray = null;
         var _loc4_:int = 0;
         if(param1 === PACKET_CONTROLS)
         {
            _loc3_ = new ByteArray();
            _loc3_.writeShort(PACKET_CONTROLS);
            _loc3_.writeShort(this.m_playerID);
            _loc3_.writeShort(MODE_DATAFRAME_RECEIVED);
            _loc3_.writeShort(param2.dataList.length);
            _loc4_ = 0;
            while(_loc4_ < param2.dataList.length)
            {
               _loc3_.writeInt(param2.dataList[_loc4_].masterFrame);
               _loc3_.writeInt(param2.dataList[_loc4_].data.controls);
               _loc4_++;
            }
            return _loc3_;
         }
         return new ByteArray();
      }
      
      private function readBinaryPacket(param1:ByteArray) : Object
      {
         var _loc2_:Object = null;
         var _loc3_:* = 0;
         var _loc4_:Object = null;
         var _loc5_:int = param1.readShort();
         if(_loc5_ === PACKET_CONTROLS)
         {
            _loc2_ = {"type":"broadcast"};
            _loc2_.playerID = param1.readShort();
            _loc2_.mode = param1.readShort();
            _loc2_.dataList = [];
            _loc3_ = param1.readShort();
            while(_loc3_ > 0)
            {
               _loc4_ = {};
               _loc4_.masterFrame = param1.readInt();
               _loc4_.data = {"controls":param1.readInt()};
               _loc2_.dataList.push(_loc4_);
               _loc3_--;
            }
            return _loc2_;
         }
         return {};
      }
      
      private function receiveMessage(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:DataFrame = null;
         var _loc5_:Object = param1;
         if(_loc5_.mode == MODE_CLIENT_JOINED)
         {
            if(!this.m_isHost)
            {
               this.m_players.push(new PlayerConnectionInfo({
                  "username":_loc5_.username,
                  "user_key":_loc5_.user_key,
                  "socket_id":_loc5_.sender,
                  "is_dev":_loc5_.is_dev
               }));
            }
            this.resetMasterFrame();
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.PLAYER_JOINED,{
               "username":_loc5_.username,
               "is_dev":_loc5_.is_dev
            }));
            _loc3_ = new Object();
            _loc3_.mode = MODE_CLIENT_JOINED_RESPONSE;
            _loc3_.username = this.m_userName;
            _loc3_.user_key = this.m_userKey;
            _loc3_.sender = this.m_lobbySocketID;
            _loc3_.playerID = this.m_playerID;
            _loc3_.is_dev = this.m_isDev;
            _loc3_.type = "directMessage";
            this.socketHelper(this.m_lobbySocket,{
               "type":"directMessage",
               "target":_loc5_.sender,
               "data":_loc3_
            },"object");
            if(this.m_isHost && Boolean(this.m_p2pSocket))
            {
               this.socketHelper(this.m_lobbySocket,{
                  "type":"directMessage",
                  "target":_loc5_.sender,
                  "data":this.m_p2pSocket.getAckObj()
               },"object");
            }
         }
         else if(_loc5_.mode == MODE_CLIENT_JOINED_RESPONSE)
         {
            this.m_players.push(new PlayerConnectionInfo({
               "username":_loc5_.username,
               "user_key":_loc5_.user_key,
               "socket_id":_loc5_.sender,
               "is_dev":_loc5_.is_dev
            }));
            this.resetMasterFrame();
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.PLAYER_JOINED,{
               "username":_loc5_.username,
               "is_dev":_loc5_.is_dev
            }));
         }
         else if(_loc5_.mode == MODE_DATAFRAME_RECEIVED && _loc5_.playerID != this.m_playerID)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc5_.dataList.length)
            {
               this.m_playerSyncStream.updateDataFrame(_loc5_.dataList[_loc2_].masterFrame,_loc5_.playerID - 1,_loc5_.dataList[_loc2_].data);
               _loc2_++;
            }
            this.updateControls();
            this.m_resendTimer = this.RESEND_TIME;
         }
         else if(_loc5_.mode == MODE_RESEND_DATAFRAME)
         {
            trace("Recieved resend request for player " + _loc5_.playerID);
            _loc4_ = this.m_playerSyncStream.getDataFrameGroup(_loc5_.masterFrame).getDataFrameFor(_loc5_.playerID - 1);
            if(_loc4_.isReady())
            {
               this.broadcast({
                  "type":"broadcast",
                  "mode":MODE_DATAFRAME_RECEIVED,
                  "sender":this.m_lobbySocketID,
                  "playerID":_loc5_.playerID,
                  "dataList":[{
                     "masterFrame":_loc5_.masterFrame,
                     "data":_loc4_.getData()
                  }]
               });
               trace("Sent a manually requested data packet back to player.");
            }
         }
         else if(_loc5_.mode != MODE_ACK_REQUEST)
         {
            if(_loc5_.mode != MODE_ACK_RESPONSE)
            {
               if(_loc5_.mode == MODE_MATCH_END)
               {
                  MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.MATCH_END,{}));
               }
               else if(_loc5_.mode == MODE_DOWNGRADE_P2P)
               {
                  this.m_protocol = ProtocolSetting.CLIENT_SERVER_TCP;
                  this.m_downgradedConnection = true;
                  this.connectGameServer(this.m_gameSocketUrl);
                  MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.NOTIFY,{"message":"P2P Connection failed. Downgrading to client-server communication per host\'s request..."}));
               }
            }
         }
         MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.DATA,_loc5_));
      }
      
      private function participantDisconnected(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = -1;
         while(_loc2_ < this.m_players.length)
         {
            if(this.m_players[_loc2_].socket_id === param1)
            {
               _loc3_ = _loc2_;
               break;
            }
            _loc2_++;
         }
         if(_loc3_ >= 0)
         {
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.PLAYER_LEFT,{
               "username":this.m_players[_loc3_].username,
               "host":this.m_players[_loc3_].socket_id === this.m_currentHostID,
               "is_dev":this.m_players[_loc3_].is_dev
            }));
            this.m_players.splice(_loc3_,1);
            this.resetMasterFrame();
            this.updateDiscordActivity();
         }
      }
      
      private function onP2PConnect(param1:MGNEvent) : void
      {
         MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.NOTIFY,{"message":"Sucessfully connected to P2P Group."}));
      }
      
      private function onP2PError(param1:MGNEvent) : void
      {
         MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.NOTIFY,{"message":param1.data.message}));
      }
      
      private function onP2PClose(param1:MGNEvent) : void
      {
         MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.NOTIFY,{"message":"P2P connection was closed."}));
      }
      
      private function onP2PMessage(param1:MGNEvent) : void
      {
         if(param1.data.data is ByteArray)
         {
            this.receiveMessage(this.readBinaryPacket(param1.data.data));
         }
         else
         {
            this.receiveMessage(param1.data.data);
         }
      }
      
      private function updateControls() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:Vector.<DataFrameGroup> = this.m_playerSyncStream.getFilledDataFrameGroups();
         if(_loc6_.length > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < _loc6_.length)
            {
               _loc2_ = new Object();
               _loc3_ = 0;
               while(_loc3_ < _loc6_[_loc1_].Size)
               {
                  _loc4_ = _loc6_[_loc1_].getDataFrameFor(_loc3_).getData();
                  _loc5_ = _loc3_ + 1;
                  _loc2_["player" + _loc5_] = new Object();
                  _loc2_["player" + _loc5_].playerID = _loc5_;
                  _loc2_["player" + _loc5_].controls = _loc4_.controls;
                  _loc3_++;
               }
               this.receiveControls(_loc2_);
               _loc1_++;
            }
         }
      }
      
      private function initMatch(param1:Object) : void
      {
         if(this.m_matchStarted)
         {
            return;
         }
         this.m_roomData = param1.room_data;
         this.m_playerData = param1.player_data;
         this.m_downgradedConnection = false;
         if(!this.m_isHost)
         {
            this.m_protocol = this.m_playerData[0].protocol;
         }
         if(this.m_protocol !== ProtocolSetting.CLIENT_SERVER_TCP)
         {
            this.m_matchStarted = true;
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.MATCH_START,{
               "room_data":this.m_roomData,
               "player_data":this.m_playerData
            }));
         }
         else if(!this.m_gameSocket)
         {
            this.connectGameServer(this.m_gameSocketUrl);
         }
      }
      
      public function downgradeP2P() : void
      {
         var _loc1_:Object = null;
         if(this.m_protocol !== ProtocolSetting.CLIENT_SERVER_TCP)
         {
            this.m_protocol = ProtocolSetting.CLIENT_SERVER_TCP;
            this.m_downgradedConnection = true;
            _loc1_ = new Object();
            _loc1_.mode = MODE_DOWNGRADE_P2P;
            _loc1_.sender = this.m_lobbySocketID;
            _loc1_.type = "broadcast";
            this.socketHelper(this.m_lobbySocket,{
               "type":"broadcast",
               "data":_loc1_
            },"object");
            this.connectGameServer(this.m_gameSocketUrl);
         }
      }
      
      public function PERFORMALL() : void
      {
         if(this.m_active)
         {
            this.checkResend();
         }
      }
      
      public function updateDiscordActivity() : void
      {
         var _loc1_:Object = null;
         var _loc2_:String = null;
         if(Boolean(Main.m_sdk) && Boolean(this.m_currentRoomKey) && Boolean(this.m_currentRoomCode))
         {
            _loc1_ = {
               "k":this.m_currentRoomKey,
               "c":this.m_currentRoomCode,
               "p":this.m_currentRoomPassword,
               "m":this.m_currentRoomCapacity
            };
            _loc2_ = JSON.stringify(_loc1_);
            trace("[MGNClient Discord] UPDATING ACTIVITY");
            trace("[MGNClient Discord]   - partyID: " + this.m_currentPartyID);
            trace("[MGNClient Discord]   - joinSecret: " + _loc2_);
            trace("[MGNClient Discord]   - players: " + this.m_players.length + "/" + this.m_currentRoomCapacity);
            Main.m_sdk.updateActivity({
               "details":"In Online Lobby",
               "partyMaxSize":this.m_currentRoomCapacity,
               "partyCurrentSize":this.m_players.length,
               "partyID":this.m_currentPartyID,
               "matchSecret":this.m_currentRoomKey,
               "joinSecret":_loc2_
            });
         }
      }
      
      public function joinRoomDirectly(param1:String, param2:String) : void
      {
         this.m_currentRoomCapacity = MultiplayerManager.ROOM_CAPACITY;
         this.joinRoom(param1,param2);
      }
   }
}


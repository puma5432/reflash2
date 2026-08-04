package com.mcleodgaming.mgn.net
{
   import com.mcleodgaming.mgn.events.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.*;
   
   public class P2PServerSocket extends EventDispatcher implements IP2PSocket
   {
      
      public static var hostIP:String = "192.168.1.1";
      
      public static var hostPort:int = 27500;
      
      private var _socket:IWebSocket;
      
      private var _guid:String;
      
      private var _initialized:Boolean;
      
      private var _p2pGroup:Object;
      
      private var _serverSocket:ServerSocket;
      
      private var _clients:Vector.<Socket>;
      
      private var _ip:String;
      
      private var _port:int;
      
      public function P2PServerSocket(param1:IWebSocket, param2:String)
      {
         super();
         this._socket = param1;
         this._ip = param2;
         this._port = 0;
         this._clients = new Vector.<Socket>();
         this._guid = Base64.encode(Math.random() + "");
         this._initialized = false;
         this._p2pGroup = {};
      }
      
      public function get connected() : Boolean
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = true;
         for(_loc1_ in this._p2pGroup)
         {
            _loc2_ = this._p2pGroup[_loc1_];
            if(!_loc2_.ackin || !_loc2_.ackout)
            {
               _loc4_ = false;
            }
            _loc3_ = true;
         }
         return _loc3_;
      }
      
      public function getAckObj() : Object
      {
         return {
            "type":"p2pinit",
            "guid":this._guid,
            "ip":this._ip,
            "port":this._port,
            "ackin":false,
            "ackout":false
         };
      }
      
      private function onSocketMessage(param1:MGNEvent) : void
      {
         var _loc2_:Socket = null;
         var _loc4_:ByteArray = null;
         var _loc3_:* = param1.data.data;
         if(!(_loc3_ is ByteArray))
         {
            if(_loc3_.type == "directMessage" || _loc3_.type == "broadcast")
            {
               _loc3_ = _loc3_.data;
            }
            if(_loc3_.type === "p2pinit")
            {
               this._socket.sendString(JSON.stringify({
                  "type":"broadcast",
                  "data":{
                     "type":"p2pjoin",
                     "guid":this._guid,
                     "ip":this._ip,
                     "port":this._port
                  }
               }));
            }
            else if(_loc3_.type === "p2pjoin")
            {
               _loc2_ = new Socket();
               this._clients.push(_loc2_);
               this._p2pGroup[_loc3_.guid] = {
                  "ip":_loc3_.ip,
                  "port":_loc3_.port,
                  "ackin":false,
                  "ackout":false,
                  "client":_loc2_
               };
               _loc2_.addEventListener(Event.CLOSE,this.onClientClose);
               _loc2_.addEventListener(Event.CONNECT,this.onClientConnect);
               _loc2_.addEventListener(ProgressEvent.SOCKET_DATA,this.onTcpMessage);
               _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.onClientError);
               _loc2_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onClientError);
               _loc2_.connect(_loc3_.ip,_loc3_.port);
            }
         }
      }
      
      private function onClientClose(param1:Event) : void
      {
         trace("Client disconnected");
      }
      
      private function onClientConnect(param1:Event) : void
      {
         var _loc2_:Socket = param1.currentTarget as Socket;
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeShort(MGNClient.PACKET_JSON);
         _loc3_.writeUTF(JSON.stringify({
            "type":"p2pholepunch",
            "guid":this._guid
         }));
         _loc2_.writeBytes(_loc3_);
         _loc2_.flush();
         trace("Sending p2pholepunch");
      }
      
      private function onClientError(param1:Event) : void
      {
         trace("Client error occured");
         this.close();
      }
      
      private function onTcpMessage(param1:ProgressEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc4_:ByteArray = null;
         var _loc5_:ByteArray = new ByteArray();
         var _loc6_:Socket = Socket(param1.currentTarget);
         _loc6_.readBytes(_loc5_,0,_loc6_.bytesAvailable);
         var _loc7_:int = _loc5_.readShort();
         if(_loc7_ == MGNClient.PACKET_JSON)
         {
            _loc2_ = _loc5_.readUTF();
            _loc3_ = JSON.parse(_loc2_);
            if(this._p2pGroup[_loc3_.guid])
            {
               if(_loc3_.type === "ackin")
               {
                  if(!this._p2pGroup[_loc3_.guid].ackin)
                  {
                     this._p2pGroup[_loc3_.guid].ackin = true;
                     trace("Successfully inbound acked peer: " + _loc6_.remoteAddress + ":" + _loc6_.remotePort);
                  }
                  _loc4_ = new ByteArray();
                  _loc4_.writeShort(MGNClient.PACKET_JSON);
                  _loc4_.writeUTF(JSON.stringify({
                     "type":"ackout",
                     "guid":this._guid,
                     "ip":_loc3_.ip,
                     "port":_loc3_.port
                  }));
                  _loc6_.writeBytes(_loc4_);
                  _loc6_.flush();
               }
               else if(_loc3_.type === "ackout")
               {
                  if(!this._p2pGroup[_loc3_.guid].ackout)
                  {
                     this._p2pGroup[_loc3_.guid].ackout = true;
                     trace("Successfully outbound acked peer: " + _loc6_.remoteAddress + ":" + _loc6_.remotePort);
                  }
               }
               else if(_loc3_.type === "p2pholepunch")
               {
                  trace("got hole punch");
               }
               else
               {
                  dispatchEvent(new MGNEvent(MGNEvent.P2P_MESSAGE,{"data":_loc3_}));
               }
            }
            else
            {
               trace("Error, received UDP message from a non-registered peer" + _loc6_.remoteAddress + ":" + _loc6_.remotePort + "> " + _loc2_);
            }
         }
         else
         {
            _loc5_.position = 0;
            dispatchEvent(new MGNEvent(MGNEvent.P2P_MESSAGE,{"data":_loc5_}));
         }
      }
      
      private function onClientConnected(param1:ServerSocketConnectEvent) : void
      {
         trace("client connected");
         this._clients.push(param1.socket);
         param1.socket.addEventListener(Event.CLOSE,this.onClientClose);
         param1.socket.addEventListener(ProgressEvent.SOCKET_DATA,this.onTcpMessage);
         param1.socket.addEventListener(IOErrorEvent.IO_ERROR,this.onClientError);
         param1.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onClientError);
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeShort(MGNClient.PACKET_JSON);
         _loc2_.writeUTF(JSON.stringify({
            "type":"p2pholepunch",
            "guid":this._guid
         }));
         param1.socket.writeBytes(_loc2_);
         param1.socket.flush();
         trace("Sending p2pholepunch in return");
      }
      
      public function connect() : void
      {
         if(this._initialized)
         {
            throw new Error("Error, cannot initialized P2P more than once!");
         }
         this._initialized = true;
         this._serverSocket = new ServerSocket();
         this._port = ProtocolSetting.tcpPort;
         this._serverSocket.bind(this._port,ProtocolSetting.tcpIP);
         this._socket.addEventListener(MGNEvent.SOCKET_MESSAGE,this.onSocketMessage);
         this._serverSocket.addEventListener(ServerSocketConnectEvent.CONNECT,this.onClientConnected);
         this._serverSocket.listen();
         dispatchEvent(new MGNEvent(MGNEvent.P2P_CONNECT));
      }
      
      public function sendToAll(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         if(param1 is ByteArray)
         {
            _loc3_ = param1 as ByteArray;
         }
         else
         {
            _loc3_ = new ByteArray();
            _loc3_.writeShort(MGNClient.PACKET_JSON);
            param1.guid = this._guid;
            _loc3_.writeUTF(JSON.stringify(param1));
         }
         if(this._clients)
         {
            _loc2_ = 0;
            while(_loc2_ < this._clients.length)
            {
               if(this._clients[_loc2_].connected)
               {
                  this._clients[_loc2_].writeBytes(_loc3_);
                  this._clients[_loc2_].flush();
               }
               _loc3_.position = 0;
               _loc2_++;
            }
         }
      }
      
      public function close() : void
      {
         var _loc1_:int = 0;
         if(this._initialized)
         {
            this._socket.removeEventListener(MGNEvent.SOCKET_MESSAGE,this.onSocketMessage);
            this._serverSocket.removeEventListener(ProgressEvent.SOCKET_DATA,this.onTcpMessage);
            this._serverSocket.close();
            _loc1_ = 0;
            while(_loc1_ < this._clients.length)
            {
               this._clients[_loc1_].removeEventListener(Event.CLOSE,this.onClientClose);
               this._clients[_loc1_].removeEventListener(ProgressEvent.SOCKET_DATA,this.onTcpMessage);
               this._clients[_loc1_].removeEventListener(IOErrorEvent.IO_ERROR,this.onClientError);
               this._clients[_loc1_].removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onClientError);
               if(this._clients[_loc1_].connected)
               {
                  this._clients[_loc1_].close();
               }
               _loc1_++;
            }
            this._clients = null;
            this._p2pGroup = null;
            this._initialized = false;
            this._serverSocket = null;
            dispatchEvent(new MGNEvent(MGNEvent.P2P_CLOSE));
         }
      }
   }
}


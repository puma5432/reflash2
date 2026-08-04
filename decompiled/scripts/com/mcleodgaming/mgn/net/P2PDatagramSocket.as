package com.mcleodgaming.mgn.net
{
   import com.mcleodgaming.mgn.events.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.*;
   
   public class P2PDatagramSocket extends EventDispatcher implements IP2PSocket
   {
      
      public static var hostIP:String = "192.168.1.1";
      
      public static var hostPort:int = 27300;
      
      private var _socket:IWebSocket;
      
      private var _guid:String;
      
      private var _initialized:Boolean;
      
      private var _p2pGroup:Object;
      
      private var _datagramSocket:DatagramSocket;
      
      private var _ip:String;
      
      private var _port:int;
      
      public function P2PDatagramSocket(param1:IWebSocket, param2:String)
      {
         super();
         this._socket = param1;
         this._ip = param2;
         this._port = 0;
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
         var _loc3_:ByteArray = null;
         var _loc2_:* = param1.data.data;
         if(!(_loc2_ is ByteArray))
         {
            if(_loc2_.type == "directMessage" || _loc2_.type == "broadcast")
            {
               _loc2_ = _loc2_.data;
            }
            if(_loc2_.type === "p2pinit")
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
            else if(_loc2_.type === "p2pjoin")
            {
               this._p2pGroup[_loc2_.guid] = {
                  "ip":_loc2_.ip,
                  "port":_loc2_.port,
                  "ackin":false,
                  "ackout":false
               };
               this._socket.sendString(JSON.stringify({
                  "type":"broadcast",
                  "data":{
                     "type":"p2presponse",
                     "guid":this._guid,
                     "ip":this._ip,
                     "port":this._port
                  }
               }));
               _loc3_ = new ByteArray();
               _loc3_.writeShort(MGNClient.PACKET_JSON);
               _loc3_.writeUTF(JSON.stringify({
                  "type":"p2pholepunch",
                  "guid":this._guid
               }));
               this._datagramSocket.send(_loc3_,0,0,_loc2_.ip,_loc2_.port);
            }
            else if(_loc2_.type === "p2presponse")
            {
               this._p2pGroup[_loc2_.guid] = {
                  "ip":_loc2_.ip,
                  "port":_loc2_.port,
                  "ackin":false,
                  "ackout":false
               };
               _loc3_ = new ByteArray();
               _loc3_.writeShort(MGNClient.PACKET_JSON);
               _loc3_.writeUTF(JSON.stringify({
                  "type":"p2pholepunch",
                  "guid":this._guid
               }));
               this._datagramSocket.send(_loc3_,0,0,_loc2_.ip,_loc2_.port);
            }
         }
      }
      
      private function onUdpMessage(param1:DatagramSocketDataEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc4_:ByteArray = null;
         var _loc5_:int = int(param1.data.readShort());
         if(_loc5_ == MGNClient.PACKET_JSON)
         {
            _loc2_ = param1.data.readUTF();
            _loc3_ = JSON.parse(_loc2_);
            if(this._p2pGroup[_loc3_.guid])
            {
               if(_loc3_.type === "ackin")
               {
                  if(!this._p2pGroup[_loc3_.guid].ackin)
                  {
                     this._p2pGroup[_loc3_.guid].ackin = true;
                     trace("Successfully inbound acked peer: " + param1.srcAddress + ":" + param1.srcPort);
                  }
                  _loc4_ = new ByteArray();
                  _loc4_.writeShort(MGNClient.PACKET_JSON);
                  _loc4_.writeUTF(JSON.stringify({
                     "type":"ackout",
                     "guid":this._guid,
                     "ip":_loc3_.ip,
                     "port":_loc3_.port
                  }));
                  this._datagramSocket.send(_loc4_,0,0,_loc3_.ip,_loc3_.port);
               }
               else if(_loc3_.type === "ackout")
               {
                  if(!this._p2pGroup[_loc3_.guid].ackout)
                  {
                     this._p2pGroup[_loc3_.guid].ackout = true;
                     trace("Successfully outbound acked peer: " + param1.srcAddress + ":" + param1.srcPort);
                  }
               }
               else
               {
                  dispatchEvent(new MGNEvent(MGNEvent.P2P_MESSAGE,{"data":_loc3_}));
               }
            }
            else
            {
               trace("Error, received UDP message from a non-registered peer" + param1.srcAddress + ":" + param1.srcPort + "> " + _loc2_);
            }
         }
         else
         {
            param1.data.position = 0;
            dispatchEvent(new MGNEvent(MGNEvent.P2P_MESSAGE,{"data":param1.data}));
         }
      }
      
      public function connect() : void
      {
         if(this._initialized)
         {
            throw new Error("Error, cannot initialized P2P more than once!");
         }
         this._initialized = true;
         this._datagramSocket = new DatagramSocket();
         this._port = ProtocolSetting.udpPort;
         this._datagramSocket.bind(this._port,ProtocolSetting.udpIP);
         this._socket.addEventListener(MGNEvent.SOCKET_MESSAGE,this.onSocketMessage);
         this._datagramSocket.addEventListener(DatagramSocketDataEvent.DATA,this.onUdpMessage);
         this._datagramSocket.receive();
         dispatchEvent(new MGNEvent(MGNEvent.P2P_CONNECT));
      }
      
      public function sendToAll(param1:Object) : void
      {
         var _loc2_:String = null;
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
         for(_loc2_ in this._p2pGroup)
         {
            this._datagramSocket.send(_loc3_,0,0,this._p2pGroup[_loc2_].ip,this._p2pGroup[_loc2_].port);
         }
      }
      
      public function close() : void
      {
         if(this._initialized)
         {
            this._socket.removeEventListener(MGNEvent.SOCKET_MESSAGE,this.onSocketMessage);
            this._datagramSocket.removeEventListener(DatagramSocketDataEvent.DATA,this.onUdpMessage);
            this._datagramSocket.close();
            this._p2pGroup = null;
            this._initialized = false;
            this._datagramSocket = null;
            dispatchEvent(new MGNEvent(MGNEvent.P2P_CLOSE));
         }
      }
   }
}


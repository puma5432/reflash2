package com.mcleodgaming.mgn.net
{
   import com.mcleodgaming.mgn.events.*;
   import com.worlize.websocket.*;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   
   public class WebSocketWorlize extends EventDispatcher implements IWebSocket
   {
      
      private var _connected:Boolean;
      
      private var _initialized:Boolean;
      
      private var _webSocket:WebSocket;
      
      private var _url:String;
      
      public function WebSocketWorlize(param1:String)
      {
         super();
         this._url = param1;
         this._connected = false;
         this._initialized = false;
         this._webSocket = null;
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function get connected() : Boolean
      {
         return this._connected;
      }
      
      public function connect() : void
      {
         if(this._initialized)
         {
            throw new Error("Error, cannot initialized WebSocket more than once!");
         }
         this._initialized = true;
         this._webSocket = new WebSocket(this._url,"*","echo-protocol");
         this._webSocket.addEventListener(WebSocketEvent.OPEN,this.onopen);
         this._webSocket.addEventListener(WebSocketEvent.CLOSED,this.onclose);
         this._webSocket.addEventListener(WebSocketEvent.MESSAGE,this.onmessage);
         this._webSocket.addEventListener(WebSocketErrorEvent.ABNORMAL_CLOSE,this.onerror);
         this._webSocket.addEventListener(WebSocketErrorEvent.CONNECTION_FAIL,this.onerror);
         this._webSocket.connect();
      }
      
      public function sendString(param1:String) : void
      {
         this._webSocket.sendUTF(param1);
      }
      
      public function sendBytes(param1:ByteArray) : void
      {
         this._webSocket.sendBytes(param1);
      }
      
      public function close() : void
      {
         if(Boolean(this._initialized) && Boolean(this._connected))
         {
            this._connected = false;
            this._webSocket.close();
            this._webSocket.removeEventListener(WebSocketEvent.OPEN,this.onopen);
            this._webSocket.removeEventListener(WebSocketEvent.CLOSED,this.onclose);
            this._webSocket.removeEventListener(WebSocketEvent.MESSAGE,this.onmessage);
            this._webSocket.removeEventListener(WebSocketErrorEvent.ABNORMAL_CLOSE,this.onerror);
            this._webSocket.removeEventListener(WebSocketErrorEvent.CONNECTION_FAIL,this.onerror);
            this._webSocket = null;
            dispatchEvent(new MGNEvent(MGNEvent.SOCKET_CLOSE));
         }
      }
      
      private function onopen(param1:WebSocketEvent) : void
      {
         this._connected = true;
         dispatchEvent(new MGNEvent(MGNEvent.SOCKET_CONNECT));
      }
      
      private function onerror(param1:WebSocketErrorEvent) : void
      {
         dispatchEvent(new MGNEvent(MGNEvent.SOCKET_ERROR,{"message":param1.text}));
      }
      
      private function onmessage(param1:WebSocketEvent) : void
      {
         var evt:WebSocketEvent = param1;
         var data:* = null;
         try
         {
            if(evt.message.type === "utf8")
            {
               data = JSON.parse(evt.message.utf8Data);
            }
            else
            {
               data = evt.message.binaryData;
            }
         }
         catch(e:Error)
         {
            dispatchEvent(new MGNEvent(MGNEvent.SOCKET_ERROR,{"message":"Error parsing message"}));
         }
         if(data != null)
         {
            dispatchEvent(new MGNEvent(MGNEvent.SOCKET_MESSAGE,{"data":data}));
         }
      }
      
      private function onclose(param1:WebSocketEvent) : void
      {
         this.close();
      }
   }
}


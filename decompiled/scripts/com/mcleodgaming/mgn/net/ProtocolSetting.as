package com.mcleodgaming.mgn.net
{
   public class ProtocolSetting
   {
      
      public static const P2P_UDP:String = "p2pudp";
      
      public static const P2P_RTMFP:String = "p2prtmfp";
      
      public static const P2P_TCP:String = "p2ptcp";
      
      public static const CLIENT_SERVER_TCP:String = "cstcp";
      
      public static var udpIP:String = "192.168.1.1";
      
      public static var udpPort:int = 27300;
      
      public static var tcpIP:String = "192.168.1.1";
      
      public static var tcpPort:int = 27300;
      
      public function ProtocolSetting()
      {
         super();
      }
   }
}


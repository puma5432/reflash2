package com.mcleodgaming.ssf2
{
   import flash.desktop.*;
   
   public final class Version
   {
      
      public static const appXML:XML = NativeApplication.nativeApplication.applicationDescriptor;
      
      public static const ns:Namespace = appXML.namespace();
      
      public static const Major:int = parseInt(String(appXML.ns::versionNumber).replace(/(\d)(\d)(\d)\.(\d)(\d)(\d)\.(\d)(\d)(\d)/g,"$1$2$3"));
      
      public static const Minor:int = parseInt(String(appXML.ns::versionNumber).replace(/(\d)(\d)(\d)\.(\d)(\d)(\d)\.(\d)(\d)(\d)/g,"$4"));
      
      public static const Build:int = parseInt(String(appXML.ns::versionNumber).replace(/(\d)(\d)(\d)\.(\d)(\d)(\d)\.(\d)(\d)(\d)/g,"$5"));
      
      public static const Revision:int = parseInt(String(appXML.ns::versionNumber).replace(/(\d)(\d)(\d)\.(\d)(\d)(\d)\.(\d)(\d)(\d)/g,"$6$7$8$9"));
      
      public static const supportedProfiles:String = String(appXML.ns::supportedProfiles);
      
      public function Version()
      {
         super();
      }
      
      public static function getVersion() : String
      {
         return Version.Major + "." + Version.Minor + "." + Version.Build + "." + Version.Revision;
      }
      
      public static function compare(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int) : int
      {
         if(param1 > param4)
         {
            return 1;
         }
         if(param1 < param4)
         {
            return -1;
         }
         if(param2 > param5)
         {
            return 1;
         }
         if(param2 < param5)
         {
            return -1;
         }
         if(param3 > param6)
         {
            return 1;
         }
         if(param3 < param6)
         {
            return -1;
         }
         return 0;
      }
      
      public static function getAIRFormattedVersion() : String
      {
         var _loc1_:String = ("00" + Version.Major).replace(/\d*(\d\d\d)/g,"$1");
         var _loc2_:String = ("00" + Version.Minor).replace(/\d*(\d\d\d)/g,"$1");
         var _loc3_:String = ("00" + Version.Build).replace(/\d*(\d\d\d)/g,"$1");
         var _loc4_:String = ("00" + Version.Revision).replace(/\d*(\d\d\d)/g,"$1");
         return _loc1_ + _loc2_ + _loc3_ + _loc4_;
      }
   }
}


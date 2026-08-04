package com.jotard.ane
{
   import flash.events.EventDispatcher;
   import flash.external.ExtensionContext;
   
   public class DiscordGameSDK extends EventDispatcher
   {
      
      private static const EXTENSION_ID:String = "com.jotard.ane.DiscordANE";
      
      private static const NATIVE_HEADER_NAME:String = "[DiscordANENative]";
      
      private static const AS3_HEADER_NAME:String = "[DiscordGameSDK]";
      
      private static var _context:ExtensionContext;
      
      public function DiscordGameSDK()
      {
         super();
         _context = ExtensionContext.createExtensionContext("com.jotard.ane.DiscordANE",null);
         if(_context)
         {
            _context.addEventListener("status",onStatus);
         }
         else
         {
            trace("[DiscordGameSDK]","ExtensionContext DiscordGameSDK could not be created.");
         }
      }
      
      private function onStatus(param1:Object) : void
      {
         trace("[DiscordANENative]","Code:",param1.code,"- Level:",param1.level);
         if(param1.level is String || param1.level is Number || param1.level is Boolean)
         {
            this.dispatchEvent(new DiscordEvent(param1.code,param1.level));
         }
         else
         {
            this.dispatchEvent(new DiscordEvent(param1.code,JSON.parse(param1.level)));
         }
      }
      
      public function initialize(param1:String, param2:Object = null, param3:int = 5000) : void
      {
         var defaultFlag:String;
         var notRequireDiscordFlag:String;
         var onSuccessConnect:Function;
         var applicationID:String = param1;
         var activity:Object = param2;
         var reconnectInterval:int = param3;
         ;
         ;
         ;
         if(!_context)
         {
            trace("[DiscordGameSDK]","ERROR: No context to call!");
            return;
         }
         defaultFlag = "0";
         notRequireDiscordFlag = "1";
         _context.call("initialize",applicationID,notRequireDiscordFlag,activity);
         onSuccessConnect = function(param1:Object):void
         {
            var _loc2_:int = 0;
            _context.removeEventListener("status",onSuccessConnect);
            if(param1 && param1.code == "CORE_INIT")
            {
               _loc2_ = int(param1.level);
               if(_loc2_ == 0)
               {
                  _context.call("updateActivity",activity);
               }
            }
         };
         _context.addEventListener("status",onSuccessConnect);
      }
      
      public function runCallbacks() : void
      {
         if(!_context)
         {
            trace("[DiscordGameSDK]","ERROR: No context to call!");
            return;
         }
         _context.call("runCallbacks");
      }
      
      public function updateActivity(param1:Object) : void
      {
         if(!_context)
         {
            trace("[DiscordGameSDK]","ERROR: No context to call!");
            return;
         }
         _context.call("updateActivity",param1);
      }
      
      public function sendRequestReply(param1:String, param2:int) : void
      {
         if(!_context)
         {
            trace("[DiscordGameSDK]","ERROR: No context to call!");
            return;
         }
         _context.call("sendRequestReply",param1,param2);
      }
      
      public function sendInvite(param1:String, param2:int, param3:String) : void
      {
         if(!_context)
         {
            trace("[DiscordGameSDK]","ERROR: No context to call!");
            return;
         }
         _context.call("sendInvite",param1,param2,param3);
      }
      
      public function acceptInvite(param1:String) : void
      {
         if(!_context)
         {
            trace("[DiscordGameSDK]","ERROR: No context to call!");
            return;
         }
         _context.call("acceptInvite",param1);
      }
   }
}


package com.mcleodgaming.ssf2.util
{
   public class VcamBGSettings
   {
      
      public static const BOUNDS_MODE:String = "boundsMode";
      
      public static const PAN_MODE:String = "panMode";
      
      public var linkage_id:String;
      
      public var mode:String;
      
      public var autoPanMultiplier:Boolean;
      
      public var width_override:Number;
      
      public var height_override:Number;
      
      public var horizontalPanLock:Boolean;
      
      public var horizontalScroll:Boolean;
      
      public var verticalPanLock:Boolean;
      
      public var verticalScroll:Boolean;
      
      public var x_start:Number;
      
      public var y_start:Number;
      
      public var xPanMultiplier:Number;
      
      public var yPanMultiplier:Number;
      
      public var foreground:Boolean;
      
      public function VcamBGSettings(param1:String, param2:Object = null)
      {
         super();
         this.linkage_id = param1;
         this.mode = VcamBGSettings.PAN_MODE;
         this.autoPanMultiplier = true;
         this.width_override = 0;
         this.height_override = 0;
         this.horizontalPanLock = false;
         this.verticalPanLock = false;
         this.horizontalScroll = false;
         this.verticalScroll = false;
         this.x_start = 0;
         this.y_start = 0;
         this.xPanMultiplier = 1;
         this.yPanMultiplier = 1;
         this.foreground = false;
         this.importSettings(param2);
      }
      
      public function importSettings(param1:Object) : VcamBGSettings
      {
         var _loc2_:* = undefined;
         if(param1)
         {
            for(_loc2_ in param1)
            {
               if(typeof this[_loc2_] !== "undefined")
               {
                  this[_loc2_] = param1[_loc2_];
               }
            }
         }
         return this;
      }
      
      public function exportSettings() : Object
      {
         return {
            "linkage_id":this.linkage_id,
            "mode":this.mode,
            "autoPanMultiplier":this.autoPanMultiplier,
            "width_override":this.width_override,
            "height_override":this.height_override,
            "horizontalPanLock":this.horizontalPanLock,
            "verticalPanLock":this.verticalPanLock,
            "horizontalScroll":this.horizontalScroll,
            "verticalScroll":this.verticalScroll,
            "x_start":this.x_start,
            "y_start":this.y_start,
            "xPanMultiplier":this.xPanMultiplier,
            "yPanMultiplier":this.yPanMultiplier,
            "foreground":this.foreground
         };
      }
   }
}


package com.mcleodgaming.ssf2.util
{
   import com.mcleodgaming.ssf2.*;
   import flash.display.MovieClip;
   
   public class VcamSettings
   {
      
      public var linkage_id:String;
      
      public var x_start:Number;
      
      public var y_start:Number;
      
      public var width:Number;
      
      public var height:Number;
      
      public var x_zoom:Number;
      
      public var y_zoom:Number;
      
      public var panSpeedCap:Number;
      
      public var camEaseFactor:Number;
      
      public var camZoomFactor:Number;
      
      public var minZoomHeight:Number;
      
      public var mainTerrain:MovieClip;
      
      public var zoomSpeedCap:Number;
      
      public var backgrounds:Vector.<VcamBGSettings>;
      
      public function VcamSettings(param1:Object = null)
      {
         super();
         this.linkage_id = null;
         this.x_start = 0;
         this.y_start = 0;
         this.width = Main.Width;
         this.height = Main.Height;
         this.x_zoom = 0;
         this.y_zoom = 0;
         this.panSpeedCap = 50;
         this.camEaseFactor = 5.6;
         this.camZoomFactor = 8;
         this.mainTerrain = null;
         this.minZoomHeight = 200;
         this.zoomSpeedCap = 0;
         this.backgrounds = new Vector.<VcamBGSettings>();
         this.importSettings(param1);
         this.mainTerrain = this.mainTerrain || null;
      }
      
      public function importSettings(param1:Object) : VcamSettings
      {
         var _loc2_:* = undefined;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         if(param1)
         {
            for(_loc2_ in param1)
            {
               if(_loc2_ in this)
               {
                  if(_loc2_ === "backgrounds")
                  {
                     _loc3_ = param1[_loc2_];
                     this.backgrounds = new Vector.<VcamBGSettings>();
                     _loc4_ = 0;
                     while(_loc4_ < _loc3_.length)
                     {
                        this.backgrounds.push(new VcamBGSettings(_loc3_[_loc4_].linkage_id,_loc3_[_loc4_]));
                        _loc4_++;
                     }
                  }
                  else
                  {
                     this[_loc2_] = param1[_loc2_];
                  }
               }
            }
         }
         return this;
      }
      
      public function exportSettings() : Object
      {
         var _loc2_:int = 0;
         var _loc1_:Object = {
            "linkage_id":this.linkage_id,
            "x_start":this.x_start,
            "y_start":this.y_start,
            "width":this.width,
            "height":this.height,
            "x_zoom":this.x_zoom,
            "y_zoom":this.y_zoom,
            "panSpeedCap":this.panSpeedCap,
            "camEaseFactor":this.camEaseFactor,
            "camZoomFactor":this.camZoomFactor,
            "mainTerrain":this.mainTerrain,
            "minZoomHeight":this.minZoomHeight,
            "backgrounds":[]
         };
         while(_loc2_ < this.backgrounds.length)
         {
            _loc1_.backgrounds.push(this.backgrounds[_loc2_].exportSettings());
            _loc2_++;
         }
         return _loc1_;
      }
   }
}


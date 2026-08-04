package com.mcleodgaming.ssf2.util
{
   import flash.accessibility.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol13")]
   public dynamic class Debug_fps_fpsSymbol extends MovieClip
   {
      
      public var bar:DisplayObject;
      
      public var fps:DisplayObject;
      
      public var lowestValue:DisplayObject;
      
      public function Debug_fps_fpsSymbol()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
      }
   }
}


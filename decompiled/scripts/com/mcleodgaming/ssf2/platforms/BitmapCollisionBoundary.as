package com.mcleodgaming.ssf2.platforms
{
   import com.mcleodgaming.ssf2.api.*;
   import com.mcleodgaming.ssf2.enemies.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.geom.*;
   
   public class BitmapCollisionBoundary
   {
      
      public static const TRANS_COLOR:uint = 1127270;
      
      protected var STAGEDATA:StageData;
      
      protected var m_collisionClip:MovieClip;
      
      protected var m_collisionClipContainer:MovieClip;
      
      protected var m_bitmapData:Bitmap;
      
      protected var m_offset:Point;
      
      protected var m_originalLocation:Point;
      
      protected var m_useRectangle:Boolean;
      
      protected var m_apiInstance:SSF2CollisionBoundary;
      
      protected var m_dead:Boolean;
      
      private var __hitTestRectAPIRectCache:Rectangle;
      
      private var __hitTestRectAPIPointCache:Point;
      
      private var __hitTestPointAPIRectCache:Rectangle;
      
      private var __hitTestPointAPIPointCache:Point;
      
      private var __hitTestPointAPIPointCache2:Point;
      
      public function BitmapCollisionBoundary(param1:MovieClip, param2:StageData, param3:String = "ground", param4:Boolean = false, param5:Object = null)
      {
         var _loc6_:BitmapData = null;
         var _loc7_:Rectangle = null;
         var _loc8_:Rectangle = null;
         var _loc9_:Matrix = null;
         var _loc10_:Point = null;
         var _loc11_:Matrix = null;
         this.__hitTestRectAPIRectCache = new Rectangle();
         this.__hitTestRectAPIPointCache = new Point();
         this.__hitTestPointAPIRectCache = new Rectangle();
         this.__hitTestPointAPIPointCache = new Point();
         this.__hitTestPointAPIPointCache2 = new Point();
         super();
         if(!param5)
         {
            param5 = {};
         }
         if(!param5.classAPI)
         {
            param5.classAPI = param2.BASE_CLASSES.SSF2CollisionBoundary;
         }
         if(!this.m_apiInstance)
         {
            this.m_apiInstance = new SSF2CollisionBoundary(param5.classAPI,this);
            if(!param1)
            {
               param1 = ResourceManager.getLibraryMC(this.m_apiInstance.getOwnStats().linkage_id);
               param2.StageRef.addChild(param1);
            }
         }
         this.m_dead = false;
         this.STAGEDATA = param2;
         this.m_collisionClip = param1[param3] ? param1[param3] : param1;
         this.m_collisionClipContainer = param1;
         this.m_originalLocation = new Point(this.m_collisionClipContainer.x,this.m_collisionClipContainer.y);
         this.m_useRectangle = param4;
         if(!this.m_useRectangle)
         {
            _loc6_ = null;
            _loc7_ = null;
            _loc8_ = null;
            if(param1[param3])
            {
               _loc7_ = param1[param3].getBounds(param1.parent);
               _loc8_ = param1[param3].getBounds(param1[param3]);
            }
            else
            {
               _loc7_ = param1.getBounds(param1.parent);
               _loc8_ = param1.getBounds(param1);
            }
            this.m_bitmapData = new Bitmap(null,PixelSnapping.ALWAYS,false);
            this.m_bitmapData.x = _loc7_.x;
            this.m_bitmapData.y = _loc7_.y;
            this.m_offset = new Point(_loc7_.x - param1.x,_loc7_.y - param1.y);
            _loc9_ = new Matrix();
            _loc10_ = new Point();
            _loc10_.x = _loc8_.x;
            _loc10_.y = _loc8_.y;
            _loc9_.tx = -_loc10_.x;
            _loc9_.ty = -_loc10_.y;
            if(param1[param3])
            {
               _loc9_.scale(param1.scaleX * param1[param3].scaleX,param1.scaleY * param1[param3].scaleY);
            }
            else
            {
               _loc9_.scale(param1.scaleX,param1.scaleY);
            }
            if(param1.transform.matrix.a < 0 || param1.transform.matrix.d < 0)
            {
               _loc11_ = new Matrix();
               _loc11_.a = param1.transform.matrix.a < 0 ? -1 : 1;
               _loc11_.d = param1.transform.matrix.d < 0 ? -1 : 1;
               _loc11_.translate(_loc11_.a < 0 ? _loc7_.width : 0,_loc11_.d < 0 ? _loc7_.height : 0);
               _loc9_.concat(_loc11_);
            }
            _loc6_ = new BitmapData(Math.round(_loc7_.width + 0.5),Math.round(_loc7_.height + 0.5),true,TRANS_COLOR);
            _loc6_.drawWithQuality(this.m_collisionClip,_loc9_,this.m_collisionClip.transform.colorTransform,null,null,false,StageQuality.BEST);
            this.m_bitmapData.bitmapData = _loc6_;
         }
      }
      
      public function get APIInstance() : SSF2CollisionBoundary
      {
         return this.m_apiInstance;
      }
      
      public function set APIInstance(param1:SSF2CollisionBoundary) : void
      {
         this.m_apiInstance = param1;
      }
      
      public function get X() : Number
      {
         return this.m_collisionClipContainer.x;
      }
      
      public function set X(param1:Number) : void
      {
         this.m_collisionClipContainer.x = param1;
      }
      
      public function get Y() : Number
      {
         return this.m_collisionClipContainer.y;
      }
      
      public function set Y(param1:Number) : void
      {
         this.m_collisionClipContainer.y = param1;
      }
      
      public function get Width() : Number
      {
         return this.m_bitmapData.width;
      }
      
      public function get Height() : Number
      {
         return this.m_bitmapData.height;
      }
      
      public function get Container() : MovieClip
      {
         return this.m_collisionClipContainer;
      }
      
      public function get CollisionClip() : MovieClip
      {
         return this.m_collisionClip;
      }
      
      public function get Offset() : Point
      {
         return this.m_offset;
      }
      
      public function get BMPData() : Bitmap
      {
         return this.m_bitmapData;
      }
      
      public function stop() : void
      {
         this.m_collisionClipContainer.stop();
      }
      
      public function play() : void
      {
         this.m_collisionClipContainer.play();
      }
      
      public function hitTestRect(param1:Rectangle, param2:Boolean = true) : Boolean
      {
         if(Boolean(this.m_apiInstance) && Boolean(this.m_apiInstance.instance))
         {
            return this.m_apiInstance.hitTestRectAPIOverride(param1,param2);
         }
         return this.hitTestRectAPI(param1,param2);
      }
      
      public function hitTestPoint(param1:Number, param2:Number, param3:Boolean = true) : Boolean
      {
         if(Boolean(this.m_apiInstance) && Boolean(this.m_apiInstance.instance))
         {
            return this.m_apiInstance.hitTestPointAPIOverride(param1,param2,param3);
         }
         return this.hitTestPointAPI(param1,param2,param3);
      }
      
      public function hitTestRectAPI(param1:Rectangle, param2:Boolean = true) : Boolean
      {
         if(this.m_useRectangle)
         {
            this.__hitTestRectAPIRectCache.setTo(this.m_collisionClipContainer.x,this.m_collisionClipContainer.y,this.m_collisionClipContainer.width,this.m_collisionClipContainer.height);
            return this.__hitTestRectAPIRectCache.containsRect(param1);
         }
         if(param2)
         {
            this.__hitTestRectAPIPointCache.setTo(this.m_collisionClipContainer.x + this.m_offset.x,this.m_collisionClipContainer.y + this.m_offset.y);
            return this.m_bitmapData.bitmapData.hitTest(this.__hitTestRectAPIPointCache,0,param1);
         }
         this.__hitTestRectAPIRectCache.setTo(this.m_collisionClipContainer.x + this.m_offset.x,this.m_collisionClipContainer.y + this.m_offset.y,this.m_bitmapData.width,this.m_bitmapData.height);
         return this.__hitTestRectAPIRectCache.containsRect(param1);
      }
      
      public function hitTestPointAPI(param1:Number, param2:Number, param3:Boolean = true) : Boolean
      {
         if(this.m_useRectangle)
         {
            this.__hitTestPointAPIRectCache.setTo(this.m_collisionClipContainer.x,this.m_collisionClipContainer.y,this.m_collisionClipContainer.width,this.m_collisionClipContainer.height);
            this.__hitTestPointAPIPointCache.setTo(param1,param2);
            return this.__hitTestPointAPIRectCache.containsPoint(this.__hitTestPointAPIPointCache);
         }
         if(param1 < this.m_collisionClipContainer.x + this.m_offset.x || param1 > this.m_collisionClipContainer.x + this.m_collisionClipContainer.width + this.m_offset.x || param2 < this.m_collisionClipContainer.y + this.m_offset.y || param2 > this.m_collisionClipContainer.y + this.m_collisionClipContainer.height + this.m_offset.y)
         {
            return false;
         }
         if(param3)
         {
            this.__hitTestPointAPIPointCache.setTo(this.m_collisionClipContainer.x + this.m_offset.x,this.m_collisionClipContainer.y + this.m_offset.y);
            this.__hitTestPointAPIPointCache2.setTo(param1,param2);
            return this.m_bitmapData.bitmapData.hitTest(this.__hitTestPointAPIPointCache,0,this.__hitTestPointAPIPointCache2);
         }
         this.__hitTestPointAPIRectCache.setTo(this.m_collisionClipContainer.x + this.m_offset.x,this.m_collisionClipContainer.y + this.m_offset.y,this.m_bitmapData.width,this.m_bitmapData.height);
         this.__hitTestPointAPIPointCache.setTo(param1,param2);
         return this.__hitTestPointAPIRectCache.containsPoint(this.__hitTestPointAPIPointCache);
      }
      
      public function destroy() : void
      {
         this.m_dead = true;
         this.STAGEDATA.removeCollisionBoundary(this);
      }
      
      public function dispose() : void
      {
         if(Boolean(this.m_bitmapData) && Boolean(this.m_bitmapData.bitmapData))
         {
            this.m_bitmapData.bitmapData.dispose();
            this.m_bitmapData.bitmapData = null;
         }
         if(this.m_apiInstance)
         {
            this.m_apiInstance.dispose();
            this.m_apiInstance = null;
         }
      }
      
      public function PERFORMALL() : void
      {
         if(Boolean(this.m_apiInstance) && !this.m_dead)
         {
            this.m_apiInstance.update();
         }
      }
   }
}


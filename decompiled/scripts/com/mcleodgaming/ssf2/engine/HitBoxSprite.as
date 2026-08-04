package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.util.*;
   import flash.geom.*;
   
   public class HitBoxSprite
   {
      
      public static const ATTACK:uint = 0;
      
      public static const HIT:uint = 1;
      
      public static const GRAB:uint = 2;
      
      public static const TOUCH:uint = 3;
      
      public static const HAND:uint = 4;
      
      public static const RANGE:uint = 5;
      
      public static const ABSORB:uint = 6;
      
      public static const COUNTER:uint = 7;
      
      public static const SHIELDATTACK:uint = 8;
      
      public static const SHIELDPROJECTILE:uint = 9;
      
      public static const REVERSE:uint = 10;
      
      public static const CATCH:uint = 11;
      
      public static const LEDGE:uint = 12;
      
      public static const CAM:uint = 13;
      
      public static const HOMING:uint = 14;
      
      public static const PLOCK:uint = 15;
      
      public static const ITEM:uint = 16;
      
      public static const HAT:uint = 17;
      
      public static const SHIELD:uint = 18;
      
      public static const EGG:uint = 19;
      
      public static const FREEZE:uint = 20;
      
      public static const STAR:uint = 21;
      
      public static const CUSTOM:uint = 22;
      
      public static const PICKUP:uint = 23;
      
      public static const MASTER:uint = 24;
      
      private var m_name:String;
      
      private var m_type:uint;
      
      private var m_rectangle:Rectangle;
      
      private var m_flippedRectangle:Rectangle;
      
      private var m_rotation:Number;
      
      private var m_transform:Matrix;
      
      private var m_regPoint:Point;
      
      private var m_scale:Point;
      
      private var m_depth:int;
      
      private var m_circular:Boolean;
      
      private var m_customData:Object;
      
      private var m_order:int;
      
      private var m_rect1Temp:Rectangle;
      
      private var m_rect2Temp:Rectangle;
      
      private var m_rect3Temp:Rectangle;
      
      private var m_rect4Temp:Rectangle;
      
      public function HitBoxSprite(param1:uint, param2:Rectangle, param3:Boolean = false, param4:Object = null, param5:Point = null, param6:Point = null, param7:Number = 0, param8:Matrix = null, param9:int = 0, param10:int = -1)
      {
         super();
         this.m_name = null;
         this.m_type = param1;
         this.m_rectangle = param2;
         this.m_circular = param3;
         this.m_customData = param4;
         this.m_flippedRectangle = new Rectangle(-param2.x - param2.width,param2.y,param2.width,param2.height);
         this.m_rotation = param7;
         this.m_regPoint = param5 ? param5 : new Point(param2.x,param2.y);
         this.m_scale = param6 ? param6 : new Point(1,1);
         this.m_transform = param8 ? param8 : new Matrix();
         this.m_depth = param9;
         this.m_order = param10;
         this.m_rect1Temp = new Rectangle();
         this.m_rect2Temp = new Rectangle();
         this.m_rect3Temp = new Rectangle();
         this.m_rect4Temp = new Rectangle();
      }
      
      public static function hitTestArray(param1:Array, param2:Array, param3:Point, param4:Point, param5:Boolean, param6:Boolean, param7:Point, param8:Point, param9:Number, param10:Number) : Vector.<HitBoxCollisionResult>
      {
         var _loc11_:int = 0;
         var _loc12_:Rectangle = null;
         var _loc14_:int = 0;
         var _loc13_:Vector.<HitBoxCollisionResult> = new Vector.<HitBoxCollisionResult>();
         if(param1 == null || param2 == null)
         {
            return _loc13_;
         }
         while(_loc14_ < param1.length)
         {
            _loc11_ = 0;
            while(_loc11_ < param2.length)
            {
               _loc12_ = param1[_loc14_].hitTest(param2[_loc11_],param3,param4,param5,param6,param7,param8,param9,param10);
               if(_loc12_)
               {
                  _loc13_.push(new HitBoxCollisionResult(param1[_loc14_],param2[_loc11_],new HitBoxSprite(param1[_loc14_].Type,_loc12_,param1[_loc14_].Circular,param1[_loc14_].CustomData)));
               }
               _loc11_++;
            }
            _loc14_++;
         }
         return _loc13_;
      }
      
      public function get x() : Number
      {
         return this.m_rectangle.x;
      }
      
      public function get y() : Number
      {
         return this.m_rectangle.y;
      }
      
      public function get xreg() : Number
      {
         return this.m_regPoint.x;
      }
      
      public function get yreg() : Number
      {
         return this.m_regPoint.y;
      }
      
      public function get width() : Number
      {
         return this.m_rectangle.width;
      }
      
      public function get height() : Number
      {
         return this.m_rectangle.height;
      }
      
      public function get scaleX() : Number
      {
         return this.m_scale.x;
      }
      
      public function get scaleY() : Number
      {
         return this.m_scale.y;
      }
      
      public function get rotation() : Number
      {
         return this.m_rotation;
      }
      
      public function get transform() : Matrix
      {
         return this.m_transform;
      }
      
      public function get depth() : int
      {
         return this.m_depth;
      }
      
      public function get Order() : int
      {
         return this.m_order;
      }
      
      public function get centerx() : Number
      {
         return this.m_rectangle.x + this.m_rectangle.width / 2;
      }
      
      public function get centery() : Number
      {
         return this.m_rectangle.y + this.m_rectangle.height / 2;
      }
      
      public function get Name() : String
      {
         return this.m_name;
      }
      
      public function set Name(param1:String) : void
      {
         this.m_name = param1;
      }
      
      public function get Type() : uint
      {
         return this.m_type;
      }
      
      public function get BoundingBox() : Rectangle
      {
         return this.m_rectangle;
      }
      
      public function get FlippedBoundingBox() : Rectangle
      {
         return this.m_flippedRectangle;
      }
      
      public function get CustomData() : Object
      {
         return this.m_customData;
      }
      
      public function set CustomData(param1:Object) : void
      {
         this.m_customData = param1;
      }
      
      public function get Circular() : Boolean
      {
         return this.m_circular;
      }
      
      public function equals(param1:HitBoxSprite) : Boolean
      {
         return this.m_type == param1.Type && Boolean(this.m_rectangle.equals(param1.BoundingBox)) && this.m_circular == param1.Circular && Boolean(this.m_regPoint.equals(param1.m_regPoint)) && Boolean(this.m_scale.equals(param1.m_scale)) && this.m_rotation == param1.rotation && this.m_transform.a == param1.transform.a && this.m_transform.b == param1.transform.b && this.m_transform.c == param1.transform.c && this.m_transform.d == param1.transform.d && this.m_transform.tx == param1.transform.tx && this.m_transform.ty == param1.transform.ty && this.m_depth == param1.depth && this.m_order == param1.Order;
      }
      
      public function hitTest(param1:HitBoxSprite, param2:Point, param3:Point, param4:Boolean, param5:Boolean, param6:Point, param7:Point, param8:Number, param9:Number) : Rectangle
      {
         var _loc10_:Vector.<Point> = null;
         var _loc11_:Vector.<Point> = null;
         var _loc12_:Point = null;
         var _loc13_:Point = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Vector.<Point> = null;
         var _loc17_:Rectangle = this.m_rect1Temp;
         var _loc18_:Rectangle = this.m_rect2Temp;
         _loc17_.copyFrom(param4 ? this.m_flippedRectangle : this.m_rectangle);
         _loc18_.copyFrom(param5 ? param1.FlippedBoundingBox : param1.BoundingBox);
         var _loc19_:Rectangle = this.m_rect3Temp;
         var _loc20_:Rectangle = this.m_rect4Temp;
         this.m_rect3Temp.copyFrom(_loc17_);
         this.m_rect4Temp.copyFrom(_loc18_);
         _loc17_ = Utils.rotateRectangleAroundOrigin(_loc17_,param8);
         _loc18_ = Utils.rotateRectangleAroundOrigin(_loc18_,param9);
         _loc17_.x *= param6.x;
         _loc17_.y *= param6.y;
         _loc17_.width *= param6.x;
         _loc17_.height *= param6.y;
         _loc18_.x *= param7.x;
         _loc18_.y *= param7.y;
         _loc18_.width *= param7.x;
         _loc18_.height *= param7.y;
         _loc17_.x += param2.x;
         _loc17_.y += param2.y;
         _loc18_.x += param3.x;
         _loc18_.y += param3.y;
         var _loc21_:Rectangle = _loc17_.intersection(_loc18_);
         if(_loc21_.isEmpty())
         {
            return null;
         }
         if(param8 == 0 && param9 == 0 && !this.m_circular && !param1.Circular)
         {
            return _loc21_;
         }
         if(!this.m_circular && !param1.Circular)
         {
            _loc10_ = Utils.rotateRectangleAroundOriginPoints(_loc19_,param8,param6,param2);
            _loc11_ = Utils.rotateRectangleAroundOriginPoints(_loc20_,param9,param7,param3);
            if(FastCollisions.rectangles(_loc10_[0].x,_loc10_[0].y,_loc10_[1].x,_loc10_[1].y,_loc10_[2].x,_loc10_[2].y,_loc10_[3].x,_loc10_[3].y,_loc11_[0].x,_loc11_[0].y,_loc11_[1].x,_loc11_[1].y,_loc11_[2].x,_loc11_[2].y,_loc11_[3].x,_loc11_[3].y))
            {
               return _loc21_;
            }
            return null;
         }
         _loc12_ = new Point(_loc19_.x + _loc19_.width / 2,_loc19_.y + _loc19_.height / 2);
         _loc13_ = new Point(_loc20_.x + _loc20_.width / 2,_loc20_.y + _loc20_.height / 2);
         _loc12_ = Utils.rotatePointAroundOrigin(_loc12_,param8);
         _loc12_.x *= param6.x;
         _loc12_.y *= param6.y;
         _loc13_ = Utils.rotatePointAroundOrigin(_loc13_,param9);
         _loc13_.x *= param7.x;
         _loc13_.y *= param7.y;
         _loc14_ = Math.min(_loc19_.width / 2 * param6.x,_loc19_.height / 2 * param6.y);
         _loc15_ = Math.min(_loc20_.width / 2 * param7.x,_loc20_.height / 2 * param7.y);
         _loc12_.x += param2.x;
         _loc12_.y += param2.y;
         _loc13_.x += param3.x;
         _loc13_.y += param3.y;
         if(Boolean(this.m_circular) && !param1.Circular)
         {
            _loc16_ = Utils.rotateRectangleAroundOriginPoints(_loc20_,param9,param7,param3);
            if(Utils.testRectangleToCircle(_loc16_,_loc20_.width * param7.x,_loc20_.height * param7.y,_loc13_.x,_loc13_.y,_loc12_.x,_loc12_.y,_loc14_))
            {
               return _loc21_;
            }
            return null;
         }
         if(!this.m_circular && param1.Circular)
         {
            _loc16_ = Utils.rotateRectangleAroundOriginPoints(_loc19_,param8,param6,param2);
            if(Utils.testRectangleToCircle(_loc16_,_loc19_.width * param6.x,_loc19_.height * param6.y,_loc12_.x,_loc12_.y,_loc13_.x,_loc13_.y,_loc15_))
            {
               return _loc21_;
            }
            return null;
         }
         if(Point.distance(_loc12_,_loc13_) <= _loc14_ + _loc15_)
         {
            return _loc21_;
         }
         return null;
      }
      
      public function hitTestPoint(param1:Point, param2:Point, param3:Boolean, param4:Point, param5:Number, param6:Boolean = false) : Boolean
      {
         var _loc7_:Rectangle = param3 ? this.m_flippedRectangle.clone() : this.m_rectangle.clone();
         _loc7_ = Utils.rotateRectangleAroundOrigin(_loc7_,param5);
         _loc7_.x *= param4.x;
         _loc7_.y *= param4.y;
         _loc7_.width *= param4.x;
         _loc7_.height *= param4.y;
         _loc7_.x += param2.x;
         _loc7_.y += param2.y;
         trace("Call to HitBoxSprite.hitTestPoint(), please check");
         return param6 ? Point.distance(param1,new Point(_loc7_.x + _loc7_.width / 2,_loc7_.y + _loc7_.height / 2)) < Math.min(_loc7_.width / 2,_loc7_.height / 2) : _loc7_.containsPoint(param1);
      }
   }
}


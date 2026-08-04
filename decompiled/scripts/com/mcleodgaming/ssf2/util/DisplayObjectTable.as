package com.mcleodgaming.ssf2.util
{
   import flash.display.*;
   import flash.geom.Rectangle;
   
   public class DisplayObjectTable
   {
      
      private var m_displayObjects:Vector.<Vector.<DisplayObject>>;
      
      private var m_spaceRect:Rectangle;
      
      public function DisplayObjectTable(param1:Rectangle)
      {
         super();
         if(param1 == null)
         {
            trace("Error creating DisplayObjectTable, cannot have null spacing rectangle");
            return;
         }
         this.m_displayObjects = new Vector.<Vector.<DisplayObject>>();
         this.m_spaceRect = param1;
      }
      
      public function get RowCount() : int
      {
         return this.m_displayObjects.length;
      }
      
      public function maxPerRow() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.m_displayObjects.length)
         {
            _loc1_ = Math.max(_loc1_,this.m_displayObjects[_loc2_].length);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function insertObject(param1:int, param2:DisplayObject) : void
      {
         while(param1 >= this.m_displayObjects.length)
         {
            this.m_displayObjects.push(new Vector.<DisplayObject>());
         }
         this.m_displayObjects[param1].push(param2);
      }
      
      public function hideAll() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.m_displayObjects.length)
         {
            _loc1_ = 0;
            while(_loc1_ < this.m_displayObjects[_loc2_].length)
            {
               this.m_displayObjects[_loc2_][_loc1_].visible = false;
               _loc1_++;
            }
            _loc2_++;
         }
      }
      
      public function showAll() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.m_displayObjects.length)
         {
            _loc1_ = 0;
            while(_loc1_ < this.m_displayObjects[_loc2_].length)
            {
               this.m_displayObjects[_loc2_][_loc1_].visible = true;
               _loc1_++;
            }
            _loc2_++;
         }
      }
      
      public function scaleAll(param1:Number, param2:Number) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < this.m_displayObjects.length)
         {
            _loc3_ = 0;
            while(_loc3_ < this.m_displayObjects[_loc4_].length)
            {
               this.m_displayObjects[_loc4_][_loc3_].scaleX = param1;
               this.m_displayObjects[_loc4_][_loc3_].scaleY = param2;
               _loc3_++;
            }
            _loc4_++;
         }
      }
      
      public function fixDepths() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = int(this.m_displayObjects.length - 1);
         while(_loc2_ >= 0)
         {
            _loc1_ = int(this.m_displayObjects[_loc2_].length - 1);
            while(_loc1_ >= 0)
            {
               if(Boolean(this.m_displayObjects[_loc2_][_loc1_].parent) && Boolean(this.m_displayObjects[_loc2_][_loc1_].parent as MovieClip))
               {
                  MovieClip(this.m_displayObjects[_loc2_][_loc1_].parent).setChildIndex(this.m_displayObjects[_loc2_][_loc1_],0);
               }
               _loc1_--;
            }
            _loc2_--;
         }
      }
      
      public function spaceObjects() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = 0;
         _loc4_ = 0;
         while(_loc4_ < this.m_displayObjects.length)
         {
            _loc1_ = 0;
            _loc2_ = 0;
            _loc5_ = 0;
            while(_loc5_ < this.m_displayObjects[_loc4_].length)
            {
               if(!this.m_displayObjects[_loc4_][_loc5_].visible)
               {
                  _loc1_ += this.m_spaceRect.width / 2;
               }
               _loc5_++;
            }
            _loc3_ = this.maxPerRow() - this.m_displayObjects[_loc4_].length;
            _loc1_ += _loc3_ * this.m_spaceRect.width / 2;
            _loc5_ = 0;
            while(_loc5_ < this.m_displayObjects[_loc4_].length)
            {
               if(this.m_displayObjects[_loc4_][_loc5_].visible)
               {
                  this.m_displayObjects[_loc4_][_loc5_].x = this.m_spaceRect.x + this.m_spaceRect.width * _loc2_ + _loc1_;
                  this.m_displayObjects[_loc4_][_loc5_].y = this.m_spaceRect.y + this.m_spaceRect.height * _loc6_;
                  _loc2_++;
               }
               _loc5_++;
            }
            _loc6_++;
            _loc4_++;
         }
      }
      
      public function empty() : void
      {
         this.m_displayObjects = new Vector.<Vector.<DisplayObject>>();
      }
   }
}


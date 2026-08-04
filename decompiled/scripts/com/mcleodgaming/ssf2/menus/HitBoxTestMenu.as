package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   
   public class HitBoxTestMenu extends Menu
   {
      
      public var hitboxes:Vector.<HitBoxTestMenuShape>;
      
      public var currentlyDraggingShape:HitBoxTestMenuShape;
      
      public var overlapContainer:Shape;
      
      public function HitBoxTestMenu()
      {
         var i:int = 0;
         super();
         this.hitboxes = new Vector.<HitBoxTestMenuShape>();
         this.hitboxes.push(new HitBoxTestMenuShape(new Rectangle(0,0,100,100),16711680,false,100,100));
         this.hitboxes.push(new HitBoxTestMenuShape(new Rectangle(0,0,100,100),65280,false,400,100));
         this.hitboxes.push(new HitBoxTestMenuShape(new Rectangle(0,0,100,100),255,true,100,220));
         this.hitboxes.push(new HitBoxTestMenuShape(new Rectangle(0,0,100,100),15879682,true,400,220));
         while(i < this.hitboxes.length)
         {
            this.hitboxes[i].sprite.addEventListener(MouseEvent.MOUSE_DOWN,(function(param1:int):Function
            {
               var index:int = param1;
               return function(param1:MouseEvent):void
               {
                  currentlyDraggingShape = hitboxes[index];
                  hitboxes[index].sprite.startDrag(false);
               };
            })(i));
            this.hitboxes[i].sprite.addEventListener(MouseEvent.MOUSE_UP,(function(param1:int):Function
            {
               var index:int = param1;
               return function(param1:MouseEvent):void
               {
                  hitboxes[index].sprite.stopDrag();
                  currentlyDraggingShape = null;
               };
            })(i));
            i += 1;
         }
         this.currentlyDraggingShape = null;
      }
      
      override public function makeEvents() : void
      {
         var _loc1_:int = 0;
         super.makeEvents();
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         while(_loc1_ < this.hitboxes.length)
         {
            Main.Root.addChild(this.hitboxes[_loc1_].sprite);
            _loc1_++;
         }
         this.overlapContainer = new Shape();
         Main.Root.addChild(this.overlapContainer);
      }
      
      override public function killEvents() : void
      {
         var _loc1_:int = 0;
         super.killEvents();
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         while(_loc1_ < this.hitboxes.length)
         {
            Main.Root.removeChild(this.hitboxes[_loc1_].sprite);
            _loc1_++;
         }
         this.currentlyDraggingShape = null;
         Main.Root.removeChild(this.overlapContainer);
      }
      
      public function onEnterFrame(param1:Event) : void
      {
         var _loc2_:Rectangle = null;
         var _loc3_:Rectangle = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(this.currentlyDraggingShape)
         {
            if(Key.isDown(Key.LEFT))
            {
               this.currentlyDraggingShape.sprite.rotation += 1;
            }
            if(Key.isDown(Key.RIGHT))
            {
               --this.currentlyDraggingShape.sprite.rotation;
            }
            if(Key.isDown(Key.EQUALS))
            {
               this.currentlyDraggingShape.sprite.scaleX += 0.05;
               this.currentlyDraggingShape.sprite.scaleY += 0.05;
            }
            if(Key.isDown(Key.UNDERSCORE))
            {
               this.currentlyDraggingShape.sprite.scaleX -= 0.05;
               this.currentlyDraggingShape.sprite.scaleY -= 0.05;
            }
         }
         _loc4_ = 0;
         while(_loc4_ < this.hitboxes.length)
         {
            this.hitboxes[_loc4_].collision = false;
            this.hitboxes[_loc4_].processed = {};
            _loc4_++;
         }
         this.overlapContainer.graphics.clear();
         this.overlapContainer.graphics.beginFill(16777215,0.75);
         _loc4_ = 0;
         while(_loc4_ < this.hitboxes.length)
         {
            _loc5_ = 0;
            while(_loc5_ < this.hitboxes.length)
            {
               if(_loc4_ != _loc5_ && !this.hitboxes[_loc4_].processed[_loc5_])
               {
                  _loc2_ = this.hitboxes[_loc4_].hitbox.hitTest(this.hitboxes[_loc5_].hitbox,new Point(this.hitboxes[_loc4_].sprite.x,this.hitboxes[_loc4_].sprite.y),new Point(this.hitboxes[_loc5_].sprite.x,this.hitboxes[_loc5_].sprite.y),false,false,new Point(this.hitboxes[_loc4_].sprite.scaleX,this.hitboxes[_loc4_].sprite.scaleY),new Point(this.hitboxes[_loc5_].sprite.scaleX,this.hitboxes[_loc5_].sprite.scaleY),Utils.forceBase360(360 - this.hitboxes[_loc4_].sprite.rotation),Utils.forceBase360(360 - this.hitboxes[_loc5_].sprite.rotation));
                  if(_loc2_)
                  {
                     this.overlapContainer.graphics.drawRect(_loc2_.x,_loc2_.y,_loc2_.width,_loc2_.height);
                     this.hitboxes[_loc4_].collision = true;
                     this.hitboxes[_loc5_].collision = this.hitboxes[_loc4_].collision;
                  }
                  this.hitboxes[_loc4_].processed[_loc5_] = true;
                  this.hitboxes[_loc5_].processed[_loc4_] = true;
               }
               _loc5_++;
            }
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < this.hitboxes.length)
         {
            this.hitboxes[_loc4_].update();
            _loc4_++;
         }
      }
   }
}


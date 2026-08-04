package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.engine.*;
   import flash.display.*;
   import flash.geom.*;
   
   public class HitBoxTestMenuShape
   {
      
      public var sprite:Sprite;
      
      public var hitbox:HitBoxSprite;
      
      public var circular:Boolean;
      
      public var color:int;
      
      public var processed:Object;
      
      public var collision:Boolean;
      
      public function HitBoxTestMenuShape(param1:Rectangle, param2:int, param3:Boolean, param4:Number, param5:Number)
      {
         super();
         this.sprite = new Sprite();
         this.hitbox = new HitBoxSprite(0,param1,param3,null,new Point(),new Point(1,1),0,null,0);
         this.color = param2;
         this.circular = param3;
         this.sprite.x = param4;
         this.sprite.y = param5;
         this.processed = {};
         this.collision = false;
         this.sprite.graphics.beginFill(this.color,1);
         if(this.circular)
         {
            this.sprite.graphics.drawCircle(this.hitbox.BoundingBox.x + this.hitbox.BoundingBox.width / 2,this.hitbox.BoundingBox.y + this.hitbox.BoundingBox.height / 2,this.hitbox.BoundingBox.width / 2);
         }
         else
         {
            this.sprite.graphics.drawRect(this.hitbox.BoundingBox.x,this.hitbox.BoundingBox.y,this.hitbox.BoundingBox.width,this.hitbox.BoundingBox.height);
         }
         this.sprite.graphics.endFill();
      }
      
      public function update() : void
      {
         this.sprite.alpha = this.collision ? 1 : 0.5;
      }
   }
}


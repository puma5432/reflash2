package com.mcleodgaming.ssf2.platforms
{
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.*;
   import flash.display.MovieClip;
   import flash.geom.*;
   
   public class Platform extends BitmapCollisionBoundary
   {
      
      protected var m_spriteOwner:InteractiveSprite;
      
      protected var m_platform:MovieClip;
      
      protected var m_ignoreList:Vector.<InteractiveSprite>;
      
      protected var m_inversedIgnoreList:Boolean;
      
      protected var m_x_start:Number;
      
      protected var m_y_start:Number;
      
      protected var m_x_prev:Number;
      
      protected var m_y_prev:Number;
      
      public function Platform(param1:MovieClip, param2:StageData, param3:String = "ground", param4:Boolean = false)
      {
         super(param1,param2,param3,param4);
         this.m_platform = m_collisionClipContainer;
         this.m_spriteOwner = null;
         this.m_ignoreList = new Vector.<InteractiveSprite>();
         this.m_inversedIgnoreList = false;
         this.m_x_start = this.m_platform.x;
         this.m_y_start = this.m_platform.y;
         this.m_x_prev = this.m_platform.x;
         this.m_y_prev = this.m_platform.y;
         this.m_x_prev = 0;
         this.m_y_prev = 0;
         this.storeOldLocation();
      }
      
      public function faceRight() : void
      {
         this.m_platform.scaleX = Math.abs(this.m_platform.scaleX);
      }
      
      public function faceLeft() : void
      {
         this.m_platform.scaleX = -Math.abs(this.m_platform.scaleX);
      }
      
      public function get SpriteOwner() : InteractiveSprite
      {
         return this.m_spriteOwner;
      }
      
      public function set SpriteOwner(param1:InteractiveSprite) : void
      {
         this.m_spriteOwner = param1;
      }
      
      public function get IgnoreList() : Vector.<InteractiveSprite>
      {
         return this.m_ignoreList;
      }
      
      public function get PreviousX() : Number
      {
         return this.m_x_prev;
      }
      
      public function get PreviousY() : Number
      {
         return this.m_y_prev;
      }
      
      public function getStartPosition() : Point
      {
         return new Point(this.m_x_start,this.m_y_start);
      }
      
      public function setStartPosition(param1:Point) : void
      {
         this.m_x_start = param1.x;
         this.m_y_start = param1.y;
      }
      
      public function get foreground() : String
      {
         return m_collisionClipContainer.foreground || null;
      }
      
      public function set foreground(param1:String) : void
      {
         m_collisionClipContainer.foreground = param1;
      }
      
      public function get fallthrough() : Boolean
      {
         return m_collisionClipContainer.fallthrough == true;
      }
      
      public function set fallthrough(param1:Boolean) : void
      {
         m_collisionClipContainer.fallthrough = param1;
      }
      
      public function get noDropThrough() : Boolean
      {
         return m_collisionClipContainer.noDropThrough == true;
      }
      
      public function set noDropThrough(param1:Boolean) : void
      {
         m_collisionClipContainer.noDropThrough = param1;
      }
      
      public function get accel_friction() : Number
      {
         if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
         {
            return m_collisionClipContainer.accel_friction != undefined ? m_collisionClipContainer.accel_friction * 0.6 : 1;
         }
         return m_collisionClipContainer.accel_friction != undefined ? Number(m_collisionClipContainer.accel_friction) : 1;
      }
      
      public function set accel_friction(param1:Number) : void
      {
         m_collisionClipContainer.accel_friction = param1;
      }
      
      public function get decel_friction() : Number
      {
         if(Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1)) && Boolean(m_collisionClipContainer.decel_friction) && m_collisionClipContainer.decel_friction < 0)
         {
            return m_collisionClipContainer.decel_friction != undefined ? m_collisionClipContainer.decel_friction * 0.6 : 1;
         }
         return m_collisionClipContainer.decel_friction != undefined ? Number(m_collisionClipContainer.decel_friction) : 1;
      }
      
      public function set decel_friction(param1:Number) : void
      {
         m_collisionClipContainer.decel_friction = param1;
      }
      
      public function get x_influence() : Number
      {
         return m_collisionClipContainer.x_influence ? Number(m_collisionClipContainer.x_influence) : 0;
      }
      
      public function set x_influence(param1:Number) : void
      {
         m_collisionClipContainer.x_influence = param1;
      }
      
      public function get danger() : Boolean
      {
         return m_collisionClipContainer.danger == true;
      }
      
      public function set danger(param1:Boolean) : void
      {
         m_collisionClipContainer.danger = param1;
      }
      
      public function get bounce_speed() : Number
      {
         return m_collisionClipContainer.bounce_speed > 0 ? Number(m_collisionClipContainer.bounce_speed) : 0;
      }
      
      public function set bounce_speed(param1:Number) : void
      {
         m_collisionClipContainer.bounce_speed = param1;
      }
      
      public function get conserve_horizontal_momentum() : Boolean
      {
         return m_collisionClipContainer.conserve_horizontal_momentum == true;
      }
      
      public function set conserve_horizontal_momentum(param1:Boolean) : void
      {
         m_collisionClipContainer.conserve_horizontal_momentum = param1;
      }
      
      public function get conserve_upward_momentum() : Boolean
      {
         return m_collisionClipContainer.conserve_upward_momentum == true;
      }
      
      public function set conserve_upward_momentum(param1:Boolean) : void
      {
         m_collisionClipContainer.conserve_upward_momentum = param1;
      }
      
      public function get conserve_downward_momentum() : Boolean
      {
         return m_collisionClipContainer.conserve_downward_momentum == true;
      }
      
      public function set conserve_downward_momentum(param1:Boolean) : void
      {
         m_collisionClipContainer.conserve_downward_momentum = param1;
      }
      
      public function setAlpha(param1:Number) : void
      {
         m_collisionClipContainer.alpha = param1;
      }
      
      public function setCamFocus(param1:Boolean) : void
      {
         STAGEDATA.CamRef.addForcedTarget(this.m_platform);
      }
      
      public function setIgnoreObjectListInversed(param1:Boolean) : void
      {
         this.m_inversedIgnoreList = param1;
      }
      
      public function shouldIgnore(param1:InteractiveSprite) : Boolean
      {
         if(this.m_ignoreList.length === 0)
         {
            return false;
         }
         if(this.m_inversedIgnoreList)
         {
            return this.m_ignoreList.indexOf(param1) < 0;
         }
         return this.m_ignoreList.indexOf(param1) >= 0;
      }
      
      public function storeOldLocation() : void
      {
         this.m_x_prev = this.m_platform.x;
         this.m_y_prev = this.m_platform.y;
      }
      
      override public function destroy() : void
      {
         m_dead = true;
         this.fallthrough = true;
         if(this.m_platform.parent)
         {
            this.m_platform.parent.removeChild(this.m_platform);
         }
         STAGEDATA.removePlatform(this);
      }
      
      override public function PERFORMALL() : void
      {
         this.storeOldLocation();
      }
   }
}


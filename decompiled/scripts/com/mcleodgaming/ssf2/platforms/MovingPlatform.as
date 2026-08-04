package com.mcleodgaming.ssf2.platforms
{
   import com.mcleodgaming.ssf2.api.*;
   import com.mcleodgaming.ssf2.enemies.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.geom.*;
   
   public class MovingPlatform extends Platform
   {
      
      protected var m_foregroundPiece:MovieClip;
      
      protected var m_foregroundPoint:Point;
      
      protected var m_disabled:Boolean;
      
      protected var m_ledges:Vector.<MovieClip>;
      
      protected var m_ledgePoints:Vector.<Point>;
      
      protected var m_ledgePointsPrev:Vector.<Point>;
      
      protected var m_findLedges:Boolean;
      
      protected var m_xSpeed:Number;
      
      protected var m_ySpeed:Number;
      
      private var m_moveTimer:FrameTimer;
      
      private var m_waitTimer:FrameTimer;
      
      private var m_wait:Boolean;
      
      private var m_platformMovement:Vector.<PlatformMovement>;
      
      private var m_moveIndex:int;
      
      private var m_xLoc:Number;
      
      private var m_yLoc:Number;
      
      public function MovingPlatform(param1:MovieClip, param2:StageData, param3:String = "ground", param4:Object = null)
      {
         if(!param4)
         {
            param4 = {};
         }
         if(!param4.classAPI)
         {
            param4.classAPI = param2.BASE_CLASSES.SSF2Platform;
         }
         m_apiInstance = new SSF2Platform(param4.classAPI,this);
         if(!param1)
         {
            param1 = ResourceManager.getLibraryMC(m_apiInstance.getOwnStats().linkage_id);
            param2.StageRef.addChild(param1);
         }
         super(param1,param2,param3);
         this.m_xSpeed = 0;
         this.m_ySpeed = 0;
         this.m_disabled = false;
         this.m_ledges = new Vector.<MovieClip>();
         this.m_ledgePoints = new Vector.<Point>();
         this.m_ledgePointsPrev = new Vector.<Point>();
         this.m_foregroundPiece = null;
         this.m_foregroundPoint = new Point();
         this.m_findLedges = Boolean(m_apiInstance) && typeof m_apiInstance.getOwnStats().attachLedges !== "undefined" ? Boolean(m_apiInstance.getOwnStats().attachLedges) : true;
         this.m_platformMovement = new Vector.<PlatformMovement>();
         this.m_moveTimer = new FrameTimer(1);
         this.m_waitTimer = new FrameTimer(1);
         this.m_xSpeed = 0;
         this.m_ySpeed = 0;
         var _loc5_:int = 1;
         while(m_platform["movement" + _loc5_])
         {
            this.addMovement(m_platform["movement" + _loc5_]);
            _loc5_++;
         }
         this.m_moveIndex = m_platform.startIndex ? int(m_platform.startIndex) : int(this.m_moveIndex);
         this.m_wait = false;
         this.m_xLoc = m_platform.x;
         this.m_yLoc = m_platform.y;
         if(this.m_foregroundPiece != null)
         {
            this.m_foregroundPoint.x = this.m_foregroundPiece.x;
            this.m_foregroundPoint.y = this.m_foregroundPiece.y;
         }
         this.findLedges();
      }
      
      public function get syncPlatform() : String
      {
         return m_collisionClip.syncPlatform ? m_collisionClip.syncPlatform : null;
      }
      
      public function set syncPlatform(param1:String) : void
      {
         m_collisionClip.syncPlatform = param1;
      }
      
      public function get LedgeList() : Vector.<MovieClip>
      {
         return this.m_ledges;
      }
      
      override public function set X(param1:Number) : void
      {
         super.X = param1;
         this.syncForeground();
      }
      
      override public function set Y(param1:Number) : void
      {
         super.Y = param1;
         this.syncForeground();
      }
      
      public function getXSpeed() : Number
      {
         return this.m_xSpeed;
      }
      
      public function setXSpeed(param1:Number) : void
      {
         this.m_xSpeed = param1;
      }
      
      public function getYSpeed() : Number
      {
         return this.m_ySpeed;
      }
      
      public function setYSpeed(param1:Number) : void
      {
         this.m_ySpeed = param1;
      }
      
      override public function set foreground(param1:String) : void
      {
         m_collisionClipContainer.foreground = param1;
         this.findForegroundPieces();
      }
      
      public function addMovement(param1:Object) : void
      {
         var _loc2_:PlatformMovement = new PlatformMovement();
         _loc2_.xAccel = param1.xAccel ? Number(param1.xAccel) : 0;
         _loc2_.xDecel = param1.xDecel ? Number(param1.xDecel) : 0;
         _loc2_.yAccel = param1.yAccel ? Number(param1.yAccel) : 0;
         _loc2_.yDecel = param1.yDecel ? Number(param1.yDecel) : 0;
         _loc2_.moveTime = param1.moveTime ? int(param1.moveTime) : 0;
         _loc2_.waitTime = param1.waitTime ? int(param1.waitTime) : 0;
         _loc2_.xSpeed = param1.xSpeed ? Number(param1.xSpeed) : 0;
         _loc2_.ySpeed = param1.ySpeed ? Number(param1.ySpeed) : 0;
         _loc2_.fallthrough = param1.fallthrough !== undefined ? Boolean(param1.fallthrough) : fallthrough;
         _loc2_.noDropThrough = param1.noDropThrough !== undefined ? Boolean(param1.noDropThrough) : noDropThrough;
         _loc2_.camFocus = param1.camFocus !== undefined ? Boolean(param1.camFocus) : false;
         this.m_platformMovement.push(_loc2_);
         if(this.m_platformMovement.length === 1)
         {
            this.m_wait = false;
            this.m_moveIndex = 0;
            this.m_moveTimer.MaxTime = _loc2_.moveTime;
            this.m_moveTimer.MaxTime = _loc2_.moveTime;
            this.m_waitTimer.reset();
            this.m_waitTimer.reset();
            this.m_xSpeed = _loc2_.xAccel > 0 ? 0 : _loc2_.xSpeed;
            this.m_ySpeed = _loc2_.yAccel > 0 ? 0 : _loc2_.ySpeed;
            if(_loc2_.camFocus)
            {
               STAGEDATA.CamRef.addForcedTarget(m_platform);
            }
         }
      }
      
      public function clearMovement() : void
      {
         this.m_platformMovement.splice(0,this.m_platformMovement.length);
      }
      
      private function incrementMovement() : void
      {
         ++this.m_moveIndex;
         if(this.m_moveIndex >= this.m_platformMovement.length)
         {
            this.m_moveIndex = 0;
         }
      }
      
      public function extraHitTests(param1:Number, param2:Number, param3:InteractiveSprite) : Boolean
      {
         if(!m_apiInstance || !m_apiInstance.instance)
         {
            return false;
         }
         return SSF2Platform(m_apiInstance).extraHitTests(param1,param2,param3);
      }
      
      public function updateStart(param1:Point) : void
      {
         m_x_start = param1.x;
         m_y_start = param1.y;
      }
      
      public function setForegroundPiece(param1:MovieClip) : void
      {
         this.m_foregroundPiece = param1;
         this.m_foregroundPoint.x = this.m_foregroundPiece.x;
         this.m_foregroundPoint.y = this.m_foregroundPiece.y;
      }
      
      public function findForegroundPieces() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         if(foreground)
         {
            _loc1_ = 0;
            _loc2_ = false;
            _loc3_ = STAGEDATA.StageParentRef;
            _loc4_ = null;
            _loc1_ = 0;
            while(_loc1_ < _loc3_.numChildren)
            {
               if(_loc3_.getChildAt(_loc1_) is MovieClip)
               {
                  _loc4_ = MovieClip(_loc3_.getChildAt(_loc1_));
                  if(Boolean(_loc4_.foreground) && _loc4_.foreground == foreground)
                  {
                     this.m_foregroundPiece = _loc4_;
                     _loc2_ = true;
                     break;
                  }
               }
               _loc1_++;
            }
            if(!_loc2_)
            {
               _loc3_ = STAGEDATA.StageFG;
               _loc1_ = 0;
               while(_loc3_ != null && _loc1_ < _loc3_.numChildren)
               {
                  if(_loc3_.getChildAt(_loc1_) is MovieClip)
                  {
                     _loc4_ = MovieClip(_loc3_.getChildAt(_loc1_));
                     if(Boolean(_loc4_.foreground) && _loc4_.foreground == foreground)
                     {
                        this.m_foregroundPiece = _loc4_;
                        break;
                     }
                  }
                  _loc1_++;
               }
            }
            if(this.m_foregroundPiece != null)
            {
               this.m_foregroundPoint.x = this.m_foregroundPiece.x;
               this.m_foregroundPoint.y = this.m_foregroundPiece.y;
            }
         }
      }
      
      public function findLedges() : void
      {
         var _loc1_:Vector.<MovieClip> = null;
         var _loc2_:Vector.<MovieClip> = null;
         var _loc3_:Point = null;
         var _loc4_:int = 0;
         if(this.m_findLedges)
         {
            _loc1_ = STAGEDATA.getLedges_L();
            _loc2_ = STAGEDATA.getLedges_R();
            _loc3_ = new Point();
            _loc4_ = 0;
            while(_loc4_ < _loc1_.length)
            {
               if(Boolean(_loc1_[_loc4_].syncPlatform && this.syncPlatform) && Boolean(_loc1_[_loc4_].syncPlatform == this.syncPlatform) || !_loc1_[_loc4_].syncPlatform && !this.syncPlatform && hitTestPoint(_loc1_[_loc4_].x,_loc1_[_loc4_].y))
               {
                  this.m_ledges.push(_loc1_[_loc4_]);
                  this.m_ledgePoints.push(new Point(_loc1_[_loc4_].x,_loc1_[_loc4_].y));
                  this.m_ledgePointsPrev.push(new Point(_loc1_[_loc4_].x,_loc1_[_loc4_].y));
               }
               _loc4_++;
            }
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               if(Boolean(_loc2_[_loc4_].syncPlatform && this.syncPlatform) && Boolean(_loc2_[_loc4_].syncPlatform == this.syncPlatform) || !_loc2_[_loc4_].syncPlatform && !this.syncPlatform && hitTestPoint(_loc2_[_loc4_].x,_loc2_[_loc4_].y))
               {
                  this.m_ledges.push(_loc2_[_loc4_]);
                  this.m_ledgePoints.push(new Point(_loc2_[_loc4_].x,_loc2_[_loc4_].y));
                  this.m_ledgePointsPrev.push(new Point(_loc2_[_loc4_].x,_loc2_[_loc4_].y));
               }
               _loc4_++;
            }
         }
      }
      
      public function syncLedges() : void
      {
         var _loc1_:Point = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.m_ledges.length)
         {
            _loc1_ = new Point(m_platform.x - m_x_start,m_platform.y - m_y_start);
            this.m_ledges[_loc2_].x = this.m_ledgePoints[_loc2_].x + _loc1_.x;
            this.m_ledges[_loc2_].y = this.m_ledgePoints[_loc2_].y + _loc1_.y;
            _loc2_++;
         }
      }
      
      public function syncForeground() : void
      {
         var _loc1_:Point = null;
         if(this.m_foregroundPiece != null)
         {
            _loc1_ = new Point(m_platform.x - m_x_start,m_platform.y - m_y_start);
            this.m_foregroundPiece.x = this.m_foregroundPoint.x + _loc1_.x * (m_platform.parent.scaleX / this.m_foregroundPiece.parent.scaleX);
            this.m_foregroundPiece.y = this.m_foregroundPoint.y + _loc1_.y * (m_platform.parent.scaleY / this.m_foregroundPiece.parent.scaleY);
         }
      }
      
      protected function move() : void
      {
         if(this.m_platformMovement.length)
         {
            if(!this.m_wait)
            {
               this.m_moveTimer.tick();
               this.m_xLoc += this.m_xSpeed;
               this.m_yLoc += this.m_ySpeed;
               m_platform.x = this.m_xLoc;
               m_platform.y = this.m_yLoc;
               this.syncLedges();
               if(!this.m_moveTimer.IsComplete)
               {
                  if(this.m_platformMovement[this.m_moveIndex].xAccel > 0)
                  {
                     if(this.m_platformMovement[this.m_moveIndex].xSpeed > 0 && this.m_xSpeed < this.m_platformMovement[this.m_moveIndex].xSpeed)
                     {
                        this.m_xSpeed += this.m_platformMovement[this.m_moveIndex].xAccel;
                     }
                     else if(this.m_platformMovement[this.m_moveIndex].xSpeed < 0 && this.m_xSpeed > this.m_platformMovement[this.m_moveIndex].xSpeed)
                     {
                        this.m_xSpeed -= this.m_platformMovement[this.m_moveIndex].xAccel;
                     }
                  }
                  if(this.m_platformMovement[this.m_moveIndex].yAccel > 0)
                  {
                     if(this.m_platformMovement[this.m_moveIndex].ySpeed > 0 && this.m_ySpeed < this.m_platformMovement[this.m_moveIndex].ySpeed)
                     {
                        this.m_ySpeed += this.m_platformMovement[this.m_moveIndex].yAccel;
                     }
                     else if(this.m_platformMovement[this.m_moveIndex].ySpeed < 0 && this.m_ySpeed > this.m_platformMovement[this.m_moveIndex].ySpeed)
                     {
                        this.m_ySpeed -= this.m_platformMovement[this.m_moveIndex].yAccel;
                     }
                  }
               }
               else if(this.m_moveTimer.IsComplete)
               {
                  if(this.m_platformMovement[this.m_moveIndex].xDecel > 0)
                  {
                     if(this.m_platformMovement[this.m_moveIndex].xSpeed > 0)
                     {
                        this.m_xSpeed -= this.m_platformMovement[this.m_moveIndex].xDecel;
                        if(this.m_xSpeed <= 0)
                        {
                           this.m_moveTimer.reset();
                           this.m_wait = true;
                        }
                     }
                     else if(this.m_platformMovement[this.m_moveIndex].xSpeed < 0)
                     {
                        this.m_xSpeed += this.m_platformMovement[this.m_moveIndex].xDecel;
                        if(this.m_xSpeed >= 0)
                        {
                           this.m_moveTimer.reset();
                           this.m_wait = true;
                        }
                     }
                  }
                  if(this.m_platformMovement[this.m_moveIndex].yDecel > 0)
                  {
                     if(this.m_platformMovement[this.m_moveIndex].ySpeed > 0)
                     {
                        this.m_ySpeed -= this.m_platformMovement[this.m_moveIndex].yDecel;
                        if(this.m_ySpeed < 0)
                        {
                           this.m_moveTimer.reset();
                           this.m_wait = true;
                        }
                     }
                     else if(this.m_platformMovement[this.m_moveIndex].ySpeed < 0)
                     {
                        this.m_ySpeed += this.m_platformMovement[this.m_moveIndex].yDecel;
                        if(this.m_ySpeed > 0)
                        {
                           this.m_moveTimer.reset();
                           this.m_wait = true;
                        }
                     }
                     else
                     {
                        this.m_moveTimer.reset();
                        this.m_wait = true;
                     }
                  }
                  if(this.m_platformMovement[this.m_moveIndex].xDecel <= 0 && this.m_platformMovement[this.m_moveIndex].yDecel <= 0)
                  {
                     this.m_moveTimer.reset();
                     this.m_wait = true;
                  }
               }
            }
            if(this.m_wait)
            {
               if(this.m_waitTimer.IsComplete)
               {
                  this.m_moveTimer.reset();
                  this.m_waitTimer.reset();
                  this.incrementMovement();
                  this.m_moveTimer.MaxTime = this.m_platformMovement[this.m_moveIndex].moveTime;
                  this.m_waitTimer.MaxTime = this.m_platformMovement[this.m_moveIndex].waitTime < 0 ? int.MAX_VALUE : int(this.m_platformMovement[this.m_moveIndex].waitTime);
                  this.m_xSpeed = this.m_platformMovement[this.m_moveIndex].xAccel > 0 ? 0 : Number(this.m_platformMovement[this.m_moveIndex].xSpeed);
                  this.m_ySpeed = this.m_platformMovement[this.m_moveIndex].yAccel > 0 ? 0 : Number(this.m_platformMovement[this.m_moveIndex].ySpeed);
                  noDropThrough = this.m_platformMovement[this.m_moveIndex].noDropThrough;
                  fallthrough = this.m_platformMovement[this.m_moveIndex].fallthrough;
                  this.m_wait = false;
                  if(this.m_platformMovement[this.m_moveIndex].camFocus)
                  {
                     STAGEDATA.CamRef.addForcedTarget(m_platform);
                  }
                  else
                  {
                     STAGEDATA.CamRef.deleteForcedTarget(m_platform);
                  }
               }
               if(this.m_waitTimer.MaxTime < int.MAX_VALUE)
               {
                  this.m_waitTimer.tick();
               }
            }
         }
         if(this.m_xSpeed !== 0 || this.m_ySpeed !== 0)
         {
            m_platform.x += this.m_xSpeed;
            m_platform.y += this.m_ySpeed;
         }
         this.syncLedges();
         this.syncForeground();
      }
      
      override public function stop() : void
      {
         super.stop();
         if(this.m_foregroundPiece != null)
         {
            this.m_foregroundPiece.stop();
         }
      }
      
      override public function play() : void
      {
         super.play();
         if(this.m_foregroundPiece != null)
         {
            this.m_foregroundPiece.play();
         }
      }
      
      public function syncPlayers() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < STAGEDATA.Characters.length)
         {
            STAGEDATA.Characters[_loc1_].checkMovingPlatforms(this);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < STAGEDATA.Projectiles.length)
         {
            STAGEDATA.Projectiles[_loc1_].checkMovingPlatforms(this);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < STAGEDATA.Enemies.length)
         {
            if(STAGEDATA.Enemies[_loc1_] != null)
            {
               STAGEDATA.Enemies[_loc1_].checkMovingPlatforms(this);
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < STAGEDATA.ItemsRef.ItemsInUse.length)
         {
            if(STAGEDATA.ItemsRef.ItemsInUse[_loc1_] != null && !STAGEDATA.ItemsRef.ItemsInUse[_loc1_].Dead)
            {
               STAGEDATA.ItemsRef.ItemsInUse[_loc1_].checkMovingPlatforms(this);
            }
            _loc1_++;
         }
      }
      
      override public function destroy() : void
      {
         m_dead = true;
         STAGEDATA.removePlatform(this);
      }
      
      override public function PERFORMALL() : void
      {
         this.PREPERFORM();
         if(!this.m_disabled)
         {
            storeOldLocation();
            this.move();
            if(m_apiInstance)
            {
               m_apiInstance.update();
            }
            this.syncPlayers();
         }
         this.POSTPERFORM();
      }
      
      protected function PREPERFORM() : void
      {
         if(!this.m_disabled)
         {
            if(m_platform.currentFrame == m_platform.totalFrames)
            {
               m_platform.gotoAndStop(1);
            }
            else
            {
               m_platform.nextFrame();
            }
            if(this.m_foregroundPiece != null)
            {
               if(this.m_foregroundPiece.currentFrame == this.m_foregroundPiece.totalFrames)
               {
                  this.m_foregroundPiece.gotoAndStop(1);
               }
               else
               {
                  this.m_foregroundPiece.nextFrame();
               }
            }
         }
      }
      
      protected function POSTPERFORM() : void
      {
         if(!this.m_disabled)
         {
            this.stop();
         }
      }
      
      override public function setAlpha(param1:Number) : void
      {
         super.setAlpha(param1);
         if(this.m_foregroundPiece != null)
         {
            this.m_foregroundPiece.alpha = param1;
         }
      }
      
      public function killPlatform() : void
      {
         m_platform.visible = false;
         if(this.m_foregroundPiece != null)
         {
            this.m_foregroundPiece.visible = false;
         }
         if(m_platform.ground)
         {
            MovieClip(m_platform.ground).fallthrough = true;
         }
         else
         {
            m_platform.fallthrough = true;
         }
         m_platform.visible = false;
         this.m_disabled = true;
      }
   }
}


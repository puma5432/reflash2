package com.mcleodgaming.ssf2.util
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.api.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import flash.display.*;
   import flash.geom.*;
   
   public class Vcam
   {
      
      public static const NORMAL_MODE:int = 0;
      
      public static const ZOOM_MODE:int = 1;
      
      public static const STAGE_MODE:int = 2;
      
      public static const FREE_MODE:int = 3;
      
      public static const LOCK_MODE:int = 4;
      
      private static var FREE_CAM_MAX_SPEED:Number = 15;
      
      private static var FREE_CAM_ACCEL:Number = 4;
      
      private var m_apiInstance:SSF2Camera;
      
      private var BG_CONTAINER:DisplayObjectContainer;
      
      private var STAGE:MovieClip;
      
      private var m_xbounds:Array;
      
      private var m_ybounds:Array;
      
      private var m_xtarget:Number;
      
      private var m_ytarget:Number;
      
      private var m_xspeed:Number;
      
      private var m_yspeed:Number;
      
      private var m_horizontalPanLock:Vector.<Boolean>;
      
      private var m_verticalPanLock:Vector.<Boolean>;
      
      private var m_zoomSpeed:Number;
      
      private var m_mainTerrain:MovieClip;
      
      private var m_targets:Vector.<MovieClip>;
      
      private var m_timedTargets:Vector.<MovieClip>;
      
      private var m_forcedTargets:Vector.<MovieClip>;
      
      private var m_timedTargetTimers:Vector.<int>;
      
      private var m_timedTargetPoints:Vector.<Point>;
      
      private var m_timedTargetPointTimers:Vector.<int>;
      
      private var m_cam:MovieClip;
      
      private var m_backgrounds:Vector.<VcamBG>;
      
      private var m_bg_holder:MovieClip;
      
      private var m_fg_holder:MovieClip;
      
      private var m_shakeSpeed:Number;
      
      private var m_x_shakeSpeed:Number;
      
      private var m_y_shakeSpeed:Number;
      
      private var m_focusMCs:Vector.<MovieClip>;
      
      private var m_focusTimers:Vector.<int>;
      
      private var m_stageFocus:FrameTimer;
      
      private var m_mode:int;
      
      private var m_dead:Boolean;
      
      private var m_settings:VcamSettings;
      
      private var cX:Number;
      
      private var cY:Number;
      
      private var sX:Number;
      
      private var sY:Number;
      
      private var oX:Number;
      
      private var oY:Number;
      
      public function Vcam(param1:VcamSettings, param2:MovieClip, param3:DisplayObjectContainer)
      {
         super();
         this.STAGE = param2;
         this.BG_CONTAINER = param3;
         this.m_apiInstance = new SSF2Camera(null,this);
         this.m_backgrounds = new Vector.<VcamBG>();
         this.m_bg_holder = null;
         this.m_fg_holder = null;
         this.m_dead = false;
         this.init(param1);
         this.m_targets = new Vector.<MovieClip>();
         this.m_focusMCs = new Vector.<MovieClip>();
         this.m_focusTimers = new Vector.<int>();
         this.m_stageFocus = new FrameTimer(1);
         this.m_stageFocus.finish();
         this.m_timedTargets = new Vector.<MovieClip>();
         this.m_forcedTargets = new Vector.<MovieClip>();
         this.m_timedTargetTimers = new Vector.<int>();
         this.m_timedTargetPoints = new Vector.<Point>();
         this.m_timedTargetPointTimers = new Vector.<int>();
      }
      
      public function get APIInstance() : SSF2Camera
      {
         return this.m_apiInstance;
      }
      
      private function init(param1:VcamSettings) : void
      {
         this.m_settings = param1;
         if(Boolean(this.m_cam) && Boolean(this.m_cam.parent))
         {
            this.m_cam.parent.removeChild(this.m_cam);
         }
         this.m_cam = this.STAGE.parent.addChild(new MovieClip()) as MovieClip;
         this.m_cam.graphics.beginFill(16711680,0.5);
         this.m_cam.graphics.drawRect(-Main.Width / 2,-Main.Height / 2,Main.Width,Main.Height);
         this.m_cam.graphics.endFill();
         this.m_cam.x = this.m_settings.x_start;
         this.m_cam.y = this.m_settings.y_start;
         this.m_cam.width = this.m_settings.width;
         this.m_cam.height = this.m_settings.height;
         this.cX = Main.Width / 2;
         this.cY = Main.Height / 2;
         this.sX = Main.Width;
         this.sY = Main.Height;
         this.oX = this.m_cam.parent.x;
         this.oY = this.m_cam.parent.y;
         this.m_cam.visible = false;
         this.m_mainTerrain = this.m_settings.mainTerrain;
         this.changeBG(this.m_settings.backgrounds);
         while(this.m_cam.width > this.m_mainTerrain.width)
         {
            this.m_cam.width -= Main.Width / Main.Width;
            this.m_cam.height -= Main.Height / Main.Width;
         }
         while(this.m_cam.height > this.m_mainTerrain.height)
         {
            this.m_cam.width -= Main.Width / Main.Width;
            this.m_cam.height -= Main.Height / Main.Width;
         }
         this.m_xbounds = new Array();
         this.m_ybounds = new Array();
         this.m_xtarget = 0;
         this.m_ytarget = 0;
         this.m_xspeed = 0;
         this.m_yspeed = 0;
         this.m_zoomSpeed = 0;
         this.m_shakeSpeed = 0;
         this.m_x_shakeSpeed = 0;
         this.m_y_shakeSpeed = 0;
         this.m_mode = 0;
         this.m_targets = new Vector.<MovieClip>();
      }
      
      public function reload(param1:VcamSettings) : void
      {
         this.killBGs();
         if(this.m_mainTerrain.parent)
         {
            this.m_mainTerrain.parent.removeChild(this.m_mainTerrain);
         }
         if(this.m_cam.parent)
         {
            this.m_cam.parent.removeChild(this.m_cam);
         }
         this.m_mainTerrain = null;
         this.m_cam = null;
         this.init(param1);
      }
      
      public function get Width() : Number
      {
         return this.m_cam.width;
      }
      
      public function get Height() : Number
      {
         return this.m_cam.height;
      }
      
      public function get OriginalWidth() : Number
      {
         return this.m_settings.width;
      }
      
      public function get OriginalHeight() : Number
      {
         return this.m_settings.height;
      }
      
      public function get X() : Number
      {
         return this.m_cam.x;
      }
      
      public function get Y() : Number
      {
         return this.m_cam.y;
      }
      
      public function get CornerX() : Number
      {
         return this.m_cam.x - this.m_cam.width / 2;
      }
      
      public function get CornerY() : Number
      {
         return this.m_cam.y - this.m_cam.height / 2;
      }
      
      public function set CornerX(param1:Number) : void
      {
         this.m_cam.x = param1 + this.m_cam.width / 2;
      }
      
      public function set CornerY(param1:Number) : void
      {
         this.m_cam.y = param1 + this.m_cam.height / 2;
      }
      
      public function get MainTerrain() : MovieClip
      {
         return this.m_mainTerrain;
      }
      
      public function get CamMC() : MovieClip
      {
         return this.m_cam;
      }
      
      public function get Mode() : int
      {
         return this.m_mode;
      }
      
      public function get Targets() : Vector.<MovieClip>
      {
         return this.m_targets;
      }
      
      public function get ForcedTargets() : Vector.<MovieClip>
      {
         return this.m_forcedTargets;
      }
      
      public function get TimedTargets() : Vector.<MovieClip>
      {
         return this.m_timedTargets;
      }
      
      public function get BGs() : Vector.<VcamBG>
      {
         return this.m_backgrounds;
      }
      
      public function get Settings() : VcamSettings
      {
         return this.m_settings;
      }
      
      public function get MinZoomHeight() : Number
      {
         return this.m_settings.minZoomHeight;
      }
      
      public function set MinZoomHeight(param1:Number) : void
      {
         this.m_settings.minZoomHeight = param1;
      }
      
      public function get CamEaseFactor() : Number
      {
         return this.m_settings.camEaseFactor;
      }
      
      public function set CamEaseFactor(param1:Number) : void
      {
         this.m_settings.camEaseFactor = param1;
      }
      
      public function get PanSpeedCap() : Number
      {
         return this.m_settings.panSpeedCap;
      }
      
      public function set PanSpeedCap(param1:Number) : void
      {
         this.m_settings.panSpeedCap = param1;
      }
      
      public function get ZoomSpeedCap() : Number
      {
         return this.m_settings.zoomSpeedCap;
      }
      
      public function set ZoomSpeedCap(param1:Number) : void
      {
         this.m_settings.zoomSpeedCap = param1;
      }
      
      public function forceSetMode(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<MovieClip> = null;
         var _loc4_:int = 0;
         _loc2_ = int(this.m_mode);
         this.m_mode = param1;
         if(_loc2_ === ZOOM_MODE)
         {
            _loc3_ = new Vector.<MovieClip>();
            _loc4_ = 0;
            while(_loc4_ < GameController.stageData.Players.length)
            {
               if(GameController.stageData.Players[_loc4_] != null && !GameController.stageData.Players[_loc4_].StandBy)
               {
                  _loc3_.push(GameController.stageData.Players[_loc4_].MC);
               }
               _loc4_++;
            }
            if(GameController.stageData.ItemsRef.CurrentSmashBall != null)
            {
               _loc3_.push(GameController.stageData.ItemsRef.CurrentSmashBall.ItemInstance);
            }
            GameController.stageData.CamRef.deleteTargets(_loc3_);
            _loc3_ = _loc3_.slice(0,1);
            GameController.stageData.CamRef.addTargets(_loc3_);
         }
         if(this.m_mode === ZOOM_MODE)
         {
            this.deleteAllTargets();
            this.addTarget(GameController.stageData.Players[0].MC);
         }
      }
      
      public function die() : void
      {
         this.killBGs();
         this.deleteAllTargets();
         if(this.m_cam != null && Boolean(this.m_cam.parent))
         {
            this.m_cam.parent.removeChild(this.m_cam);
         }
         if(Boolean(this.m_bg_holder) && Boolean(this.m_bg_holder.parent))
         {
            this.m_bg_holder.parent.removeChild(this.m_bg_holder);
         }
         if(Boolean(this.m_fg_holder) && Boolean(this.m_fg_holder.parent))
         {
            this.m_fg_holder.parent.removeChild(this.m_fg_holder);
         }
         this.m_dead = true;
      }
      
      public function changeBG(param1:Vector.<VcamBGSettings>) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:VcamBG = null;
         if(!this.BG_CONTAINER)
         {
            return;
         }
         if(this.m_bg_holder == null)
         {
            this.m_bg_holder = new MovieClip();
            this.BG_CONTAINER.addChildAt(this.m_bg_holder,0);
         }
         if(this.m_fg_holder == null)
         {
            this.m_fg_holder = new MovieClip();
            this.BG_CONTAINER.addChild(this.m_fg_holder);
         }
         while(this.m_backgrounds.length > 0)
         {
            this.m_backgrounds[0].dispose();
            this.m_backgrounds.splice(0,1);
         }
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = new VcamBG(ResourceManager.getLibraryMC(param1[_loc2_].linkage_id),param1[_loc2_]);
            _loc3_.settings.width_override = param1[_loc2_].width_override || _loc3_.sprite.width;
            _loc3_.settings.height_override = param1[_loc2_].height_override || _loc3_.sprite.height;
            if(_loc3_.settings.foreground)
            {
               this.m_fg_holder.addChild(_loc3_.sprite);
               this.m_backgrounds.push(_loc3_);
            }
            else
            {
               this.m_bg_holder.addChild(_loc3_.sprite);
               this.m_backgrounds.push(_loc3_);
            }
            if(_loc3_.settings.autoPanMultiplier)
            {
               _loc3_.settings.xPanMultiplier = (_loc3_.settings.width_override - Main.Width) / 2 / _loc3_.settings.width_override;
               _loc3_.settings.yPanMultiplier = (_loc3_.settings.height_override - Main.Height) / 2 / _loc3_.settings.height_override;
            }
            _loc3_.sprite.x = Main.Width / 2;
            _loc3_.sprite.y = Main.Height / 2;
            _loc3_.centX = _loc3_.sprite.x;
            _loc3_.centY = _loc3_.sprite.y;
            if(_loc3_.settings.horizontalScroll && _loc3_.settings.mode !== VcamBGSettings.BOUNDS_MODE)
            {
               _loc3_.horizontalScrollPair.push(ResourceManager.getLibraryMC(param1[_loc2_].linkage_id));
               _loc3_.horizontalScrollPair.push(ResourceManager.getLibraryMC(param1[_loc2_].linkage_id));
               _loc3_.horizontalScrollPair[0].x -= _loc3_.sprite.width;
               _loc3_.horizontalScrollPair[1].x += _loc3_.sprite.width;
               if(_loc3_.settings.foreground)
               {
                  this.m_fg_holder.addChild(_loc3_.horizontalScrollPair[0]);
                  this.m_fg_holder.addChild(_loc3_.horizontalScrollPair[1]);
               }
               else
               {
                  this.m_bg_holder.addChild(_loc3_.horizontalScrollPair[0]);
                  this.m_bg_holder.addChild(_loc3_.horizontalScrollPair[1]);
               }
            }
            if(_loc3_.settings.verticalScroll && _loc3_.settings.mode !== VcamBGSettings.BOUNDS_MODE)
            {
               _loc3_.verticalScrollPair.push(ResourceManager.getLibraryMC(param1[_loc2_].linkage_id));
               _loc3_.verticalScrollPair.push(ResourceManager.getLibraryMC(param1[_loc2_].linkage_id));
               _loc3_.verticalScrollPair[0].y -= _loc3_.sprite.height;
               _loc3_.verticalScrollPair[1].y += _loc3_.sprite.height;
               if(_loc3_.settings.foreground)
               {
                  this.m_fg_holder.addChild(_loc3_.verticalScrollPair[0]);
                  this.m_fg_holder.addChild(_loc3_.verticalScrollPair[1]);
               }
               else
               {
                  this.m_bg_holder.addChild(_loc3_.verticalScrollPair[0]);
                  this.m_bg_holder.addChild(_loc3_.verticalScrollPair[1]);
               }
            }
            _loc2_++;
         }
         this.fixBG();
      }
      
      public function killBGs() : void
      {
         this.pauseBG();
         while(this.m_backgrounds.length > 0)
         {
            this.m_backgrounds[0].dispose();
            this.m_backgrounds[0] = null;
            this.m_backgrounds.splice(0,1);
         }
      }
      
      public function set Mode(param1:int) : void
      {
         this.m_mode = param1;
         if(this.m_mode < 0)
         {
            this.m_mode = Vcam.STAGE_MODE;
            this.maxZoomOut();
            this.fixBG();
         }
         else if(this.m_mode > 2)
         {
            this.m_mode = Vcam.NORMAL_MODE;
         }
      }
      
      public function fixBG() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.m_backgrounds.length)
         {
            this.m_backgrounds[_loc1_].sprite.x = Main.Width / 2;
            this.m_backgrounds[_loc1_].sprite.y = Main.Height / 2;
            this.m_backgrounds[_loc1_].centX = this.m_backgrounds[_loc1_].sprite.x;
            this.m_backgrounds[_loc1_].centY = this.m_backgrounds[_loc1_].sprite.y;
            this.m_backgrounds[_loc1_].diffX = (this.m_backgrounds[_loc1_].settings.width_override - Main.Width - 10) / 2;
            this.m_backgrounds[_loc1_].diffY = (this.m_backgrounds[_loc1_].settings.height_override - Main.Height - 10) / 2;
            _loc1_++;
         }
      }
      
      public function camControl() : void
      {
         if(!this.m_cam || !this.m_cam.parent || this.m_mode === LOCK_MODE)
         {
            return;
         }
         var _loc1_:Number = this.sX / this.m_cam.width;
         var _loc2_:Number = this.sY / this.m_cam.height;
         this.m_cam.parent.x = this.cX - this.m_cam.x * _loc1_;
         this.m_cam.parent.y = this.cY - this.m_cam.y * _loc2_;
         this.m_cam.parent.scaleX = _loc1_;
         this.m_cam.parent.scaleY = _loc2_;
      }
      
      private function resetStage() : void
      {
         this.m_cam.parent.scaleX = 1;
         this.m_cam.parent.scaleY = 1;
         this.m_cam.parent.x = this.oX;
         this.m_cam.parent.y = this.oY;
      }
      
      private function getPositions() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:MovieClip = null;
         var _loc3_:Vector.<Point> = null;
         var _loc4_:* = 0;
         if(this.m_targets.length > 0)
         {
            this.m_xbounds = new Array();
            this.m_ybounds = new Array();
         }
         var _loc5_:Rectangle = new Rectangle();
         var _loc6_:Vector.<MovieClip> = this.m_forcedTargets.length > 0 ? this.m_forcedTargets : (this.m_focusMCs.length > 0 ? this.m_focusMCs : this.m_targets);
         for(_loc1_ in _loc6_)
         {
            _loc2_ = _loc6_[_loc1_];
            _loc3_ = new Vector.<Point>();
            if(!(this.m_focusMCs.length > 0 && this.m_focusMCs.indexOf(_loc2_) < 0 || !this.m_stageFocus.IsComplete))
            {
               if(_loc2_)
               {
                  if(_loc2_.camOverride)
                  {
                     _loc5_.x = _loc2_.camOverride.x;
                     _loc5_.y = _loc2_.camOverride.y;
                     _loc5_.width = _loc2_.camOverride.width;
                     _loc5_.height = _loc2_.camOverride.height;
                     if(_loc2_.transform.matrix.a < 0)
                     {
                        _loc5_.x = -_loc5_.x - _loc2_.camOverride.width;
                     }
                  }
                  else
                  {
                     if(_loc2_.cam_width)
                     {
                        if(_loc2_.transform.matrix.a < 0)
                        {
                           _loc5_.x = -_loc2_.cam_width / 2;
                           _loc5_.width = _loc2_.cam_width;
                           if(_loc2_.cam_x_offset !== undefined)
                           {
                              _loc5_.x -= _loc2_.cam_x_offset;
                           }
                        }
                        else
                        {
                           _loc5_.x = -_loc2_.cam_width / 2;
                           _loc5_.width = _loc2_.cam_width;
                           if(_loc2_.cam_x_offset !== undefined)
                           {
                              _loc5_.x += _loc2_.cam_x_offset;
                           }
                        }
                     }
                     if(_loc2_.cam_height)
                     {
                        _loc5_.y = -_loc2_.cam_height;
                        _loc5_.height = _loc2_.cam_height;
                        if(_loc2_.cam_y_offset !== undefined)
                        {
                           _loc5_.y += _loc2_.cam_y_offset;
                        }
                     }
                  }
                  _loc5_.x *= Utils.fastAbs(_loc2_.scaleX);
                  _loc5_.y *= Utils.fastAbs(_loc2_.scaleY);
                  _loc5_.width *= Utils.fastAbs(_loc2_.scaleX);
                  _loc5_.height *= Utils.fastAbs(_loc2_.scaleY);
                  _loc3_.push(new Point(_loc5_.x,_loc5_.y));
                  _loc3_.push(new Point(_loc5_.x + _loc5_.width,_loc5_.y));
                  _loc3_.push(new Point(_loc5_.x + _loc5_.width,_loc5_.y + _loc5_.height));
                  _loc3_.push(new Point(_loc5_.x,_loc5_.y + _loc5_.height));
                  _loc4_ = 0;
                  while(_loc4_ < _loc3_.length)
                  {
                     if(_loc2_ != null)
                     {
                        if(_loc2_.x + _loc3_[_loc4_].x < this.m_mainTerrain.x)
                        {
                           this.m_xbounds.push(this.m_mainTerrain.x + this.STAGE.x);
                        }
                        else if(_loc2_.x + _loc3_[_loc4_].x > this.m_mainTerrain.x + this.m_mainTerrain.width)
                        {
                           this.m_xbounds.push(this.m_mainTerrain.x + this.m_mainTerrain.width + this.STAGE.x);
                        }
                        else
                        {
                           this.m_xbounds.push(_loc2_.x + _loc3_[_loc4_].x + this.STAGE.x);
                        }
                        if(_loc2_.y + _loc3_[_loc4_].y < this.m_mainTerrain.y)
                        {
                           this.m_ybounds.push(this.m_mainTerrain.y + this.STAGE.y);
                        }
                        else if(_loc2_.y + _loc3_[_loc4_].y > this.m_mainTerrain.y + this.m_mainTerrain.height)
                        {
                           this.m_ybounds.push(this.m_mainTerrain.y + this.m_mainTerrain.height + this.STAGE.y);
                        }
                        else
                        {
                           this.m_ybounds.push(_loc2_.y + _loc3_[_loc4_].y + this.STAGE.y);
                        }
                     }
                     _loc4_++;
                  }
               }
            }
         }
         if(this.m_focusMCs.length > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < this.m_focusTimers.length)
            {
               --this.m_focusTimers[_loc4_];
               if(this.m_focusTimers[_loc4_] < 0 || !this.m_focusMCs[_loc4_].parent)
               {
                  this.m_focusMCs.splice(_loc4_,1);
                  this.m_focusTimers.splice(_loc4_,1);
                  _loc4_--;
               }
               _loc4_++;
            }
         }
         _loc4_ = 0;
         while(_loc4_ < this.m_timedTargets.length)
         {
            --this.m_timedTargetTimers[_loc4_];
            if(this.m_timedTargetTimers[_loc4_] <= 0)
            {
               this.deleteTimedTarget(this.m_timedTargets[_loc4_]);
               _loc4_--;
            }
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < this.m_timedTargetPoints.length)
         {
            --this.m_timedTargetPointTimers[_loc4_];
            if(this.m_timedTargetPointTimers[_loc4_] <= 0)
            {
               this.deleteTimedTargetPoint(this.m_timedTargetPoints[_loc4_]);
               _loc4_--;
            }
            else
            {
               if(this.m_timedTargetPoints[_loc4_].x < this.m_mainTerrain.x)
               {
                  this.m_xbounds.push(this.m_mainTerrain.x + this.STAGE.x);
               }
               else if(this.m_timedTargetPoints[_loc4_].x > this.m_mainTerrain.x + this.m_mainTerrain.width)
               {
                  this.m_xbounds.push(this.m_mainTerrain.x + this.m_mainTerrain.width + this.STAGE.x);
               }
               else
               {
                  this.m_xbounds.push(this.m_timedTargetPoints[_loc4_].x + this.STAGE.x);
               }
               if(this.m_timedTargetPoints[_loc4_].y < this.m_mainTerrain.y)
               {
                  this.m_ybounds.push(this.m_mainTerrain.y + this.STAGE.y);
               }
               else if(this.m_timedTargetPoints[_loc4_].y > this.m_mainTerrain.y + this.m_mainTerrain.height)
               {
                  this.m_ybounds.push(this.m_mainTerrain.y + this.m_mainTerrain.height + this.STAGE.y);
               }
               else
               {
                  this.m_ybounds.push(this.m_timedTargetPoints[_loc4_].y + this.STAGE.y);
               }
            }
            _loc4_++;
         }
         if(!this.m_stageFocus.IsComplete)
         {
            this.m_stageFocus.tick();
            this.m_xbounds.push(this.m_mainTerrain.x + this.STAGE.x);
            this.m_xbounds.push(this.m_mainTerrain.x + this.m_mainTerrain.width + this.STAGE.x);
            this.m_ybounds.push(this.m_mainTerrain.y + this.STAGE.y);
            this.m_ybounds.push(this.m_mainTerrain.y + this.m_mainTerrain.height + this.STAGE.y);
         }
         this.m_xbounds.sort(Array.NUMERIC);
         this.m_ybounds.sort(Array.NUMERIC);
      }
      
      public function targetCenterStage() : void
      {
         this.m_xbounds.push(this.m_mainTerrain.x + this.m_mainTerrain.width / 2);
         this.m_ybounds.push(this.m_mainTerrain.y + this.m_mainTerrain.height / 2);
      }
      
      public function targetSelf() : void
      {
         this.m_xbounds.push(this.m_cam.x);
         this.m_ybounds.push(this.m_cam.y);
      }
      
      public function setStageFocus(param1:int) : void
      {
         this.m_stageFocus.reset();
         this.m_stageFocus.MaxTime = param1;
      }
      
      public function removeStageFocus() : void
      {
         this.m_stageFocus.finish();
      }
      
      public function addZoomFocus(param1:MovieClip, param2:int) : void
      {
         if(param1 != null && this.m_focusMCs.indexOf(param1) < 0)
         {
            this.m_focusMCs.push(param1);
            this.m_focusTimers.push(param2);
         }
      }
      
      public function removeZoomFocus(param1:MovieClip) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:int = int(this.m_focusMCs.indexOf(param1));
         if(_loc2_ >= 0)
         {
            this.m_focusMCs.splice(_loc2_,1);
            this.m_focusTimers.splice(_loc2_,1);
         }
      }
      
      public function removeAllZoomFocus() : void
      {
         while(this.m_focusMCs.length > 0)
         {
            this.m_focusMCs.splice(0,1);
            this.m_focusTimers.splice(0,1);
         }
      }
      
      public function addTarget(param1:MovieClip) : void
      {
         if(param1 != null && this.m_targets.indexOf(param1) < 0)
         {
            this.m_targets.push(param1);
         }
      }
      
      public function addTargets(param1:Vector.<MovieClip>) : void
      {
         var _loc2_:* = undefined;
         for(_loc2_ in param1)
         {
            if(param1[_loc2_] != null && this.m_targets.indexOf(param1[_loc2_]) < 0)
            {
               this.m_targets.push(param1[_loc2_]);
            }
         }
      }
      
      public function addTimedTarget(param1:MovieClip, param2:int) : void
      {
         var _loc3_:int = int(this.m_timedTargets.indexOf(param1));
         if(_loc3_ < 0)
         {
            this.addTarget(param1);
            this.m_timedTargets.push(param1);
            this.m_timedTargetTimers.push(param2);
         }
         else
         {
            this.m_timedTargetTimers[_loc3_] = param2;
         }
      }
      
      public function addTimedTargetPoint(param1:Point, param2:int) : void
      {
         var _loc3_:int = int(this.m_timedTargetPoints.indexOf(param1));
         if(_loc3_ < 0)
         {
            this.m_timedTargetPoints.push(param1);
            this.m_timedTargetPointTimers.push(param2);
         }
         else
         {
            this.m_timedTargetPointTimers[_loc3_] = param2;
         }
      }
      
      public function addForcedTarget(param1:MovieClip) : void
      {
         var _loc2_:int = int(this.m_forcedTargets.indexOf(param1));
         if(_loc2_ < 0)
         {
            this.m_forcedTargets.push(param1);
         }
      }
      
      public function hasTarget(param1:MovieClip) : Boolean
      {
         return this.m_targets.indexOf(param1) >= 0;
      }
      
      public function hasTargets(param1:Vector.<MovieClip>) : Boolean
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:Boolean = false;
         for(_loc2_ in param1)
         {
            for(_loc3_ in this.m_targets)
            {
               if(this.m_targets[_loc3_] != null && this.m_targets[_loc3_] == param1[_loc2_])
               {
                  _loc4_ = true;
               }
            }
            if(!_loc4_)
            {
               return false;
            }
         }
         return true;
      }
      
      public function deleteTarget(param1:MovieClip) : void
      {
         if(param1 != null && this.m_targets.indexOf(param1) >= 0)
         {
            this.m_targets.splice(this.m_targets.indexOf(param1),1);
         }
      }
      
      public function deleteTargets(param1:Vector.<MovieClip>) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         for(_loc2_ in param1)
         {
            _loc3_ = int(this.m_targets.indexOf(param1[_loc2_]));
            if(_loc3_ >= 0)
            {
               this.m_targets.splice(_loc3_,1);
            }
         }
      }
      
      public function deleteTimedTarget(param1:MovieClip) : void
      {
         var _loc2_:int = int(this.m_timedTargets.indexOf(param1));
         if(_loc2_ >= 0)
         {
            this.deleteTarget(param1);
            this.m_timedTargets.splice(_loc2_,1);
            this.m_timedTargetTimers.splice(_loc2_,1);
         }
      }
      
      public function deleteForcedTarget(param1:MovieClip) : void
      {
         var _loc2_:int = int(this.m_forcedTargets.indexOf(param1));
         if(_loc2_ >= 0)
         {
            this.m_forcedTargets.splice(_loc2_,1);
         }
      }
      
      public function deleteTimedTargetPoint(param1:Point) : void
      {
         var _loc2_:int = int(this.m_timedTargetPoints.indexOf(param1));
         if(_loc2_ >= 0)
         {
            this.m_timedTargetPoints.splice(_loc2_,1);
            this.m_timedTargetPointTimers.splice(_loc2_,1);
         }
      }
      
      public function deleteAllTargets() : void
      {
         this.m_targets.splice(0,this.m_targets.length);
      }
      
      public function followTargets() : void
      {
         if(this.m_xbounds.length == 0 || this.m_xbounds.length == 0)
         {
         }
         this.m_xtarget = this.m_xbounds[0] + Math.sqrt(Math.pow(this.m_xbounds[0] - this.m_xbounds[this.m_xbounds.length - 1],2)) / 2;
         this.m_ytarget = this.m_ybounds[0] + Math.sqrt(Math.pow(this.m_ybounds[0] - this.m_ybounds[this.m_ybounds.length - 1],2)) / 2;
         this.m_xspeed = (this.m_xtarget - this.m_cam.x) / this.m_settings.camEaseFactor;
         this.m_yspeed = (this.m_ytarget - this.m_cam.y) / this.m_settings.camEaseFactor;
         if(Utils.fastAbs(this.m_xspeed) < 1 && Utils.fastAbs(this.m_yspeed) < 1)
         {
            this.m_xspeed = 0;
            this.m_yspeed = 0;
         }
         if(this.m_xspeed != 0 && this.m_settings.panSpeedCap !== 0)
         {
            this.m_xspeed = this.m_xspeed > 0 ? Math.min(this.m_xspeed,this.m_settings.panSpeedCap) : Math.max(this.m_xspeed,-this.m_settings.panSpeedCap);
         }
         if(this.m_yspeed != 0 && this.m_settings.panSpeedCap !== 0)
         {
            this.m_yspeed = this.m_yspeed > 0 ? Math.min(this.m_yspeed,this.m_settings.panSpeedCap) : Math.max(this.m_yspeed,-this.m_settings.panSpeedCap);
         }
         this.m_cam.x += this.m_xspeed;
         this.m_cam.y += this.m_yspeed;
         this.forceInBounds();
         this.syncPositions();
      }
      
      public function forceTarget() : void
      {
         if(this.m_xbounds.length == 0 || this.m_xbounds.length == 0)
         {
         }
         this.m_xtarget = this.m_xbounds[0] + Math.sqrt(Math.pow(this.m_xbounds[0] - this.m_xbounds[this.m_xbounds.length - 1],2)) / 2;
         this.m_ytarget = this.m_ybounds[0] + Math.sqrt(Math.pow(this.m_ybounds[0] - this.m_ybounds[this.m_ybounds.length - 1],2)) / 2;
         this.m_xspeed = 0;
         this.m_yspeed = 0;
         this.m_cam.x = this.m_xtarget;
         this.m_cam.y = this.m_ytarget;
         this.forceInBounds();
         this.syncPositions();
      }
      
      public function zoom() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(this.m_xbounds.length == 0 || this.m_xbounds.length == 0)
         {
         }
         if(this.m_ybounds.length > 0)
         {
            _loc1_ = Number(this.m_settings.minZoomHeight);
            _loc2_ = _loc1_ * (this.m_settings.width / this.m_settings.height);
            _loc3_ = this.m_xbounds[this.m_xbounds.length - 1] - this.m_xbounds[0];
            _loc4_ = this.m_ybounds[this.m_ybounds.length - 1] - this.m_ybounds[0];
            if(_loc3_ < _loc2_)
            {
               _loc3_ = _loc2_;
            }
            if(_loc4_ < _loc1_)
            {
               _loc4_ = _loc1_;
            }
            if(_loc3_ / _loc4_ > this.m_settings.width / this.m_settings.height)
            {
               _loc4_ = _loc3_ * (this.m_settings.height / this.m_settings.width);
            }
            else
            {
               _loc3_ = _loc4_ * (this.m_settings.width / this.m_settings.height);
            }
            _loc2_ = (_loc3_ - this.m_cam.width) / this.m_settings.camZoomFactor;
            _loc1_ = (_loc4_ - this.m_cam.height) / this.m_settings.camZoomFactor;
            if(_loc2_ > this.m_settings.zoomSpeedCap && this.m_settings.zoomSpeedCap !== 0)
            {
               _loc2_ = Number(this.m_settings.zoomSpeedCap);
               _loc1_ = _loc2_ * (this.m_settings.height / this.m_settings.width);
            }
            if(_loc1_ > this.m_settings.zoomSpeedCap && this.m_settings.zoomSpeedCap !== 0)
            {
               _loc1_ = Number(this.m_settings.zoomSpeedCap);
               _loc2_ = _loc1_ * (this.m_settings.width / this.m_settings.height);
            }
            if(Utils.fastAbs(_loc2_) < 1 && Utils.fastAbs(_loc1_) < 1)
            {
               _loc2_ = 0;
               _loc1_ = 0;
            }
         }
         if(this.m_cam.width + _loc2_ < this.m_mainTerrain.width && this.m_cam.height + _loc1_ < this.m_mainTerrain.height)
         {
            this.m_cam.width += _loc2_;
            this.m_cam.height += _loc1_;
            this.syncPositions();
         }
      }
      
      public function zoomIn() : void
      {
         if(this.m_cam.width > this.m_settings.width / 10)
         {
            this.m_cam.width += -15 * 1;
            this.m_cam.height += -15 * 0.5625;
            this.forceInBounds();
            this.syncPositions();
            this.camControl();
         }
      }
      
      public function zoomOut() : void
      {
         if(this.m_cam.height < this.m_mainTerrain.height)
         {
            this.m_cam.width += 15 * 1;
            this.m_cam.height += 15 * 0.5625;
            this.forceInBounds();
            this.syncPositions();
            this.camControl();
         }
      }
      
      public function shake(param1:Number) : void
      {
         this.m_shakeSpeed = param1;
         if(this.m_shakeSpeed > 20)
         {
            this.m_shakeSpeed = 20;
         }
      }
      
      public function lightFlash(param1:Boolean = true) : void
      {
         GameController.stageData.lightFlash(param1);
      }
      
      private function effects() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(this.m_shakeSpeed > 0)
         {
            _loc1_ = Math.round(Utils.safeRandom() * (this.m_shakeSpeed * 2) - this.m_shakeSpeed);
            _loc2_ = Math.round(Utils.safeRandom() * (this.m_shakeSpeed * 2) - this.m_shakeSpeed);
            this.m_cam.x += _loc1_;
            this.m_cam.y += _loc2_;
            this.syncPositions();
            --this.m_shakeSpeed;
         }
      }
      
      public function forceInBounds() : void
      {
         if(!this.m_stageFocus.IsComplete)
         {
            return;
         }
         var _loc1_:Number = Main.Width / Main.Height;
         if(this.m_cam.height > this.m_mainTerrain.height)
         {
            this.m_cam.height = this.m_mainTerrain.height;
            this.m_cam.width = this.m_mainTerrain.height * _loc1_;
         }
         if(this.m_cam.width > this.m_mainTerrain.width)
         {
            this.m_cam.width = this.m_mainTerrain.width;
            this.m_cam.height = this.m_mainTerrain.width * (1 / _loc1_);
         }
         if(this.CornerX < this.m_mainTerrain.x + this.STAGE.x)
         {
            this.CornerX = this.m_mainTerrain.x + this.STAGE.x;
         }
         if(this.CornerX + this.m_cam.width > this.m_mainTerrain.x + this.m_mainTerrain.width + this.STAGE.x)
         {
            this.CornerX = this.m_mainTerrain.x + this.m_mainTerrain.width - this.m_cam.width + this.STAGE.x;
         }
         if(this.CornerY < this.m_mainTerrain.y + this.STAGE.y)
         {
            this.CornerY = this.m_mainTerrain.y + this.STAGE.y;
         }
         if(this.CornerY + this.m_cam.height > this.m_mainTerrain.y + this.m_mainTerrain.height + this.STAGE.y)
         {
            this.CornerY = this.m_mainTerrain.y + this.m_mainTerrain.height - this.m_cam.height + this.STAGE.y;
         }
      }
      
      public function syncPositions() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.m_backgrounds.length)
         {
            if(this.m_backgrounds[_loc2_].settings.mode === VcamBGSettings.PAN_MODE)
            {
               if(this.m_backgrounds[_loc2_].settings.xPanMultiplier != 0 && !this.m_backgrounds[_loc2_].settings.horizontalPanLock)
               {
                  if(!this.m_backgrounds[_loc2_].settings.horizontalScroll)
                  {
                     this.m_backgrounds[_loc2_].sprite.x = this.m_backgrounds[_loc2_].centX;
                     _loc1_ = this.m_backgrounds[_loc2_].settings.xPanMultiplier < 0 ? -1 : 1;
                     this.m_backgrounds[_loc2_].sprite.x += _loc1_ * (this.m_mainTerrain.x + this.STAGE.x + this.m_mainTerrain.width / 2 - this.m_cam.x) * Utils.fastAbs(this.m_backgrounds[_loc2_].settings.xPanMultiplier);
                  }
                  else
                  {
                     this.m_backgrounds[_loc2_].sprite.x = this.m_backgrounds[_loc2_].centX;
                     _loc1_ = this.m_backgrounds[_loc2_].settings.xPanMultiplier < 0 ? -1 : 1;
                     this.m_backgrounds[_loc2_].sprite.x += _loc1_ * (this.m_mainTerrain.x + this.STAGE.x + this.m_mainTerrain.width / 2 - this.m_cam.x) * Utils.fastAbs(this.m_backgrounds[_loc2_].settings.xPanMultiplier) % this.m_backgrounds[_loc2_].sprite.width;
                     this.m_backgrounds[_loc2_].horizontalScrollPair[0].sprite.x = this.m_backgrounds[_loc2_].sprite.x - this.m_backgrounds[_loc2_].settings.width_override[_loc2_];
                     this.m_backgrounds[_loc2_].horizontalScrollPair[1].sprite.x = this.m_backgrounds[_loc2_].sprite.x + this.m_backgrounds[_loc2_].settings.width_override[_loc2_];
                  }
               }
               if(this.m_backgrounds[_loc2_].settings.yPanMultiplier != 0 && !this.m_backgrounds[_loc2_].settings.verticalPanLock)
               {
                  if(!this.m_backgrounds[_loc2_].settings.verticalScroll)
                  {
                     this.m_backgrounds[_loc2_].sprite.y = this.m_backgrounds[_loc2_].centY;
                     _loc1_ = this.m_backgrounds[_loc2_].settings.yPanMultiplier < 0 ? -1 : 1;
                     this.m_backgrounds[_loc2_].sprite.y += _loc1_ * (this.m_mainTerrain.y + this.STAGE.y + this.m_mainTerrain.height / 2 - this.m_cam.y) * Utils.fastAbs(this.m_backgrounds[_loc2_].settings.yPanMultiplier);
                  }
                  else
                  {
                     this.m_backgrounds[_loc2_].sprite.y = this.m_backgrounds[_loc2_].centY;
                     _loc1_ = this.m_backgrounds[_loc2_].settings.yPanMultiplier < 0 ? -1 : 1;
                     this.m_backgrounds[_loc2_].sprite.y += _loc1_ * (this.m_mainTerrain.y + this.STAGE.y + this.m_mainTerrain.height / 2 - this.m_cam.y) * Utils.fastAbs(this.m_backgrounds[_loc2_].settings.yPanMultiplier) % this.m_backgrounds[_loc2_].sprite.height;
                     this.m_backgrounds[_loc2_].verticalScrollPair[0].sprite.y = this.m_backgrounds[_loc2_].sprite.y - this.m_backgrounds[_loc2_].settings.height_override[_loc2_];
                     this.m_backgrounds[_loc2_].verticalScrollPair[1].sprite.y = this.m_backgrounds[_loc2_].sprite.y + this.m_backgrounds[_loc2_].settings.height_override[_loc2_];
                  }
               }
               if(this.m_backgrounds[_loc2_].settings.horizontalScroll)
               {
                  this.m_backgrounds[_loc2_].horizontalScrollPair[0].y = this.m_backgrounds[_loc2_].sprite.y;
                  this.m_backgrounds[_loc2_].horizontalScrollPair[1].y = this.m_backgrounds[_loc2_].sprite.y;
               }
               if(this.m_backgrounds[_loc2_].settings.verticalScroll)
               {
                  this.m_backgrounds[_loc2_].verticalScrollPair[0].x = this.m_backgrounds[_loc2_].sprite.x;
                  this.m_backgrounds[_loc2_].verticalScrollPair[1].x = this.m_backgrounds[_loc2_].sprite.x;
               }
            }
            else if(this.m_backgrounds[_loc2_].settings.mode === VcamBGSettings.BOUNDS_MODE)
            {
               if(this.m_backgrounds[_loc2_].diffX > 0 && !this.m_backgrounds[_loc2_].settings.horizontalPanLock)
               {
                  this.m_backgrounds[_loc2_].sprite.x = this.m_backgrounds[_loc2_].centX + (this.m_mainTerrain.x + this.STAGE.x + this.m_mainTerrain.width / 2 - this.m_cam.x) / this.m_mainTerrain.width * this.m_backgrounds[_loc2_].diffX / (this.m_backgrounds.length - _loc2_);
               }
               if(this.m_backgrounds[_loc2_].diffY > 0 && !this.m_backgrounds[_loc2_].settings.verticalPanLock)
               {
                  this.m_backgrounds[_loc2_].sprite.y = this.m_backgrounds[_loc2_].centY + (this.m_mainTerrain.y + this.STAGE.y + this.m_mainTerrain.height / 2 - this.m_cam.y) / this.m_mainTerrain.height * this.m_backgrounds[_loc2_].diffY / (this.m_backgrounds.length - _loc2_);
               }
            }
            _loc2_++;
         }
      }
      
      public function panLeft(param1:Number = 15) : void
      {
         if(this.CornerX > this.m_mainTerrain.x + this.STAGE.x)
         {
            this.m_cam.x -= param1;
            this.syncPositions();
            this.camControl();
         }
      }
      
      public function panRight(param1:Number = 15) : void
      {
         if(this.CornerX + this.m_cam.width < this.m_mainTerrain.x + this.STAGE.x + this.m_mainTerrain.width)
         {
            this.m_cam.x += param1;
            this.syncPositions();
            this.camControl();
         }
      }
      
      public function panUp(param1:Number = 15) : void
      {
         if(this.CornerY > this.m_mainTerrain.y + this.STAGE.y)
         {
            this.m_cam.y -= param1;
            this.syncPositions();
            this.camControl();
         }
      }
      
      public function panDown(param1:Number = 15) : void
      {
         if(this.CornerY + this.m_cam.height < this.m_mainTerrain.y + this.STAGE.y + this.m_mainTerrain.height)
         {
            this.m_cam.y += param1;
            this.syncPositions();
            this.camControl();
         }
      }
      
      public function maxZoomOut() : void
      {
         this.m_cam.height = this.m_mainTerrain.height;
         this.m_cam.width = this.m_cam.height * (this.m_settings.width / this.m_settings.height);
         this.m_cam.x = this.m_mainTerrain.x + this.m_mainTerrain.width / 2 + this.STAGE.x;
         this.m_cam.y = this.m_mainTerrain.y + this.m_mainTerrain.height / 2 + this.STAGE.y;
      }
      
      private function checkMode() : void
      {
         if(this.m_mode == Vcam.STAGE_MODE)
         {
            this.maxZoomOut();
         }
         else if(this.m_mode == Vcam.ZOOM_MODE)
         {
            this.m_cam.width = this.m_settings.width / 3;
            this.m_cam.height = this.m_settings.height / 3;
         }
         else if(this.m_mode == Vcam.FREE_MODE)
         {
            if(Boolean(SaveData.Controllers[3].IsDown(SaveData.Controllers[3]._BUTTON2)) && !SaveData.Controllers[3].IsDown(SaveData.Controllers[3]._BUTTON1))
            {
               this.zoomIn();
            }
            else if(Boolean(SaveData.Controllers[3].IsDown(SaveData.Controllers[3]._BUTTON1)) && !SaveData.Controllers[3].IsDown(SaveData.Controllers[3]._BUTTON2))
            {
               this.zoomOut();
            }
            if(SaveData.Controllers[3].IsDown(SaveData.Controllers[3]._LEFT) !== SaveData.Controllers[3].IsDown(SaveData.Controllers[3]._RIGHT))
            {
               if(SaveData.Controllers[3].IsDown(SaveData.Controllers[3]._LEFT))
               {
                  if(this.m_xspeed > 0)
                  {
                     this.m_xspeed = 0;
                  }
                  this.panLeft(this.m_cam.scaleX * -this.m_xspeed);
                  this.m_xspeed -= FREE_CAM_ACCEL;
                  if(this.m_xspeed < -FREE_CAM_MAX_SPEED)
                  {
                     this.m_xspeed = -FREE_CAM_MAX_SPEED;
                  }
               }
               else if(SaveData.Controllers[3].IsDown(SaveData.Controllers[3]._RIGHT))
               {
                  if(this.m_xspeed < 0)
                  {
                     this.m_xspeed = 0;
                  }
                  this.panRight(this.m_cam.scaleX * this.m_xspeed);
                  this.m_xspeed += FREE_CAM_ACCEL;
                  if(this.m_xspeed > FREE_CAM_MAX_SPEED)
                  {
                     this.m_xspeed = FREE_CAM_MAX_SPEED;
                  }
               }
            }
            else
            {
               this.m_xspeed = 0;
            }
            if(SaveData.Controllers[3].IsDown(SaveData.Controllers[3]._DOWN) !== SaveData.Controllers[3].IsDown(SaveData.Controllers[3]._UP))
            {
               if(SaveData.Controllers[3].IsDown(SaveData.Controllers[3]._DOWN))
               {
                  if(this.m_yspeed < 0)
                  {
                     this.m_yspeed = 0;
                  }
                  this.panDown(this.m_cam.scaleX * this.m_yspeed);
                  this.m_yspeed += FREE_CAM_ACCEL;
                  if(this.m_yspeed > FREE_CAM_MAX_SPEED)
                  {
                     this.m_yspeed = FREE_CAM_MAX_SPEED;
                  }
               }
               else if(SaveData.Controllers[3].IsDown(SaveData.Controllers[3]._UP))
               {
                  if(this.m_yspeed > 0)
                  {
                     this.m_yspeed = 0;
                  }
                  this.panUp(this.m_cam.scaleX * -this.m_yspeed);
                  this.m_yspeed -= FREE_CAM_ACCEL;
                  if(this.m_yspeed < -FREE_CAM_MAX_SPEED)
                  {
                     this.m_yspeed = -FREE_CAM_MAX_SPEED;
                  }
               }
            }
            else
            {
               this.m_yspeed = 0;
            }
         }
      }
      
      public function pauseBG() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.m_backgrounds.length)
         {
            this.m_backgrounds[_loc1_].sprite.stop();
            Utils.recursiveMovieClipPlay(this.m_backgrounds[_loc1_].sprite,false,false);
            _loc1_++;
         }
      }
      
      public function playBG() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.m_backgrounds.length)
         {
            this.m_backgrounds[_loc1_].sprite.play();
            Utils.recursiveMovieClipPlay(this.m_backgrounds[_loc1_].sprite,true,false);
            _loc1_++;
         }
      }
      
      public function showBGs() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.m_backgrounds.length)
         {
            this.m_backgrounds[_loc1_].sprite.visible = true;
            _loc1_++;
         }
      }
      
      public function hideBGs() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.m_backgrounds.length)
         {
            this.m_backgrounds[_loc1_].sprite.visible = false;
            _loc1_++;
         }
      }
      
      public function gotoAndPlayBG(param1:String) : void
      {
         var _loc2_:int = 0;
         if(param1 != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.m_backgrounds.length)
            {
               Utils.tryToGotoAndPlay(this.m_backgrounds[_loc2_].sprite,param1);
               _loc2_++;
            }
         }
      }
      
      public function nextFrameBG() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.m_backgrounds.length)
         {
            Utils.advanceFrame(this.m_backgrounds[_loc1_].sprite);
            Utils.recursiveMovieClipPlay(this.m_backgrounds[_loc1_].sprite,true);
            _loc1_++;
         }
      }
      
      public function darken() : void
      {
         GameController.stageData.HudRef.darkenCamera();
      }
      
      public function killDarkener(param1:Boolean = false) : void
      {
         if(param1)
         {
            GameController.stageData.HudRef.killCameraDarkener();
         }
         else
         {
            GameController.stageData.HudRef.brightenCamera();
         }
      }
      
      public function PERFORMALL() : void
      {
         if(!this.m_dead)
         {
            this.camControl();
            if(this.m_mode == Vcam.STAGE_MODE)
            {
               this.checkMode();
               return;
            }
            this.getPositions();
            if(this.m_mode !== FREE_MODE)
            {
               this.zoom();
               this.followTargets();
            }
            this.checkMode();
            this.effects();
         }
      }
   }
}


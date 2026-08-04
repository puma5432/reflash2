package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import flash.display.*;
   import flash.geom.*;
   
   public class HitBoxAnimation
   {
      
      private static var m_animationsList:Array = new Array();
      
      public static const HIT_BOX_MAP:Object = {
         "attackBox":HitBoxSprite.ATTACK,
         "hitBox":HitBoxSprite.HIT,
         "grabBox":HitBoxSprite.GRAB,
         "touchBox":HitBoxSprite.TOUCH,
         "hand":HitBoxSprite.HAND,
         "range":HitBoxSprite.RANGE,
         "absorbBox":HitBoxSprite.ABSORB,
         "counterBox":HitBoxSprite.COUNTER,
         "shieldBox":HitBoxSprite.SHIELD,
         "shieldAttackBox":HitBoxSprite.SHIELDATTACK,
         "shieldProjectileBox":HitBoxSprite.SHIELDPROJECTILE,
         "reverseBox":HitBoxSprite.REVERSE,
         "catchBox":HitBoxSprite.CATCH,
         "ledgeBox":HitBoxSprite.LEDGE,
         "camBox":HitBoxSprite.CAM,
         "homing":HitBoxSprite.HOMING,
         "pLockBox":HitBoxSprite.PLOCK,
         "hatBox":HitBoxSprite.HAT,
         "itemBox":HitBoxSprite.ITEM,
         "eggBox":HitBoxSprite.EGG,
         "freezeBox":HitBoxSprite.FREEZE,
         "starBox":HitBoxSprite.STAR,
         "customBox":HitBoxSprite.CUSTOM
      };
      
      private var m_name:String;
      
      private var m_totalHitboxes:int;
      
      private var m_attackBoxes:Vector.<HitBoxSprite>;
      
      private var m_hitBoxes:Vector.<HitBoxSprite>;
      
      private var m_grabBoxes:Vector.<HitBoxSprite>;
      
      private var m_touchBoxes:Vector.<HitBoxSprite>;
      
      private var m_handBoxes:Vector.<HitBoxSprite>;
      
      private var m_rangeBoxes:Vector.<HitBoxSprite>;
      
      private var m_absorbBoxes:Vector.<HitBoxSprite>;
      
      private var m_counterBoxes:Vector.<HitBoxSprite>;
      
      private var m_shieldBoxes:Vector.<HitBoxSprite>;
      
      private var m_shieldAttackBoxes:Vector.<HitBoxSprite>;
      
      private var m_shieldProjectileBoxes:Vector.<HitBoxSprite>;
      
      private var m_reverseBoxes:Vector.<HitBoxSprite>;
      
      private var m_catchBoxes:Vector.<HitBoxSprite>;
      
      private var m_ledgeBoxes:Vector.<HitBoxSprite>;
      
      private var m_camBoxes:Vector.<HitBoxSprite>;
      
      private var m_homingBoxes:Vector.<HitBoxSprite>;
      
      private var m_pLockBoxes:Vector.<HitBoxSprite>;
      
      private var m_itemBoxes:Vector.<HitBoxSprite>;
      
      private var m_hatBoxes:Vector.<HitBoxSprite>;
      
      private var m_eggBoxes:Vector.<HitBoxSprite>;
      
      private var m_freezeBoxes:Vector.<HitBoxSprite>;
      
      private var m_starBoxes:Vector.<HitBoxSprite>;
      
      private var m_customBoxes:Vector.<HitBoxSprite>;
      
      private var m_masterBoxes:Vector.<HitBoxSprite>;
      
      private var m_attackFrames:Array;
      
      private var m_hitFrames:Array;
      
      private var m_grabFrames:Array;
      
      private var m_touchFrames:Array;
      
      private var m_handFrames:Array;
      
      private var m_rangeFrames:Array;
      
      private var m_absorbFrames:Array;
      
      private var m_counterFrames:Array;
      
      private var m_shieldFrames:Array;
      
      private var m_shieldAttackFrames:Array;
      
      private var m_shieldProjectileFrames:Array;
      
      private var m_reverseFrames:Array;
      
      private var m_catchFrames:Array;
      
      private var m_ledgeFrames:Array;
      
      private var m_camFrames:Array;
      
      private var m_homingFrames:Array;
      
      private var m_pLockFrames:Array;
      
      private var m_itemFrames:Array;
      
      private var m_hatFrames:Array;
      
      private var m_eggFrames:Array;
      
      private var m_freezeFrames:Array;
      
      private var m_starFrames:Array;
      
      private var m_customFrames:Array;
      
      private var m_masterFrames:Array;
      
      private var m_totalFrames:int;
      
      public function HitBoxAnimation(param1:String)
      {
         super();
         this.m_name = param1;
         m_animationsList[param1] = this;
         this.m_totalHitboxes = 0;
         this.m_attackBoxes = new Vector.<HitBoxSprite>();
         this.m_hitBoxes = new Vector.<HitBoxSprite>();
         this.m_grabBoxes = new Vector.<HitBoxSprite>();
         this.m_touchBoxes = new Vector.<HitBoxSprite>();
         this.m_handBoxes = new Vector.<HitBoxSprite>();
         this.m_rangeBoxes = new Vector.<HitBoxSprite>();
         this.m_absorbBoxes = new Vector.<HitBoxSprite>();
         this.m_counterBoxes = new Vector.<HitBoxSprite>();
         this.m_shieldBoxes = new Vector.<HitBoxSprite>();
         this.m_shieldAttackBoxes = new Vector.<HitBoxSprite>();
         this.m_shieldProjectileBoxes = new Vector.<HitBoxSprite>();
         this.m_reverseBoxes = new Vector.<HitBoxSprite>();
         this.m_catchBoxes = new Vector.<HitBoxSprite>();
         this.m_ledgeBoxes = new Vector.<HitBoxSprite>();
         this.m_camBoxes = new Vector.<HitBoxSprite>();
         this.m_homingBoxes = new Vector.<HitBoxSprite>();
         this.m_pLockBoxes = new Vector.<HitBoxSprite>();
         this.m_itemBoxes = new Vector.<HitBoxSprite>();
         this.m_hatBoxes = new Vector.<HitBoxSprite>();
         this.m_eggBoxes = new Vector.<HitBoxSprite>();
         this.m_freezeBoxes = new Vector.<HitBoxSprite>();
         this.m_starBoxes = new Vector.<HitBoxSprite>();
         this.m_customBoxes = new Vector.<HitBoxSprite>();
         this.m_masterBoxes = new Vector.<HitBoxSprite>();
         this.m_attackFrames = new Array();
         this.m_hitFrames = new Array();
         this.m_grabFrames = new Array();
         this.m_touchFrames = new Array();
         this.m_handFrames = new Array();
         this.m_rangeFrames = new Array();
         this.m_absorbFrames = new Array();
         this.m_counterFrames = new Array();
         this.m_shieldFrames = new Array();
         this.m_shieldAttackFrames = new Array();
         this.m_shieldProjectileFrames = new Array();
         this.m_reverseFrames = new Array();
         this.m_catchFrames = new Array();
         this.m_ledgeFrames = new Array();
         this.m_camFrames = new Array();
         this.m_homingFrames = new Array();
         this.m_pLockFrames = new Array();
         this.m_itemFrames = new Array();
         this.m_hatFrames = new Array();
         this.m_eggFrames = new Array();
         this.m_freezeFrames = new Array();
         this.m_starFrames = new Array();
         this.m_customFrames = new Array();
         this.m_masterFrames = new Array();
      }
      
      public static function get AnimationsList() : Array
      {
         return m_animationsList;
      }
      
      public static function get HitBoxTypes() : Vector.<Object>
      {
         var _loc1_:Vector.<Object> = new Vector.<Object>();
         _loc1_.push({
            "type":HitBoxSprite.ATTACK,
            "name":"attackBox"
         });
         _loc1_.push({
            "type":HitBoxSprite.HIT,
            "name":"hitBox"
         });
         _loc1_.push({
            "type":HitBoxSprite.GRAB,
            "name":"grabBox"
         });
         _loc1_.push({
            "type":HitBoxSprite.TOUCH,
            "name":"touchBox"
         });
         _loc1_.push({
            "type":HitBoxSprite.HAND,
            "name":"hand"
         });
         _loc1_.push({
            "type":HitBoxSprite.RANGE,
            "name":"range"
         });
         _loc1_.push({
            "type":HitBoxSprite.ABSORB,
            "name":"absorbBox"
         });
         _loc1_.push({
            "type":HitBoxSprite.COUNTER,
            "name":"counterBox"
         });
         _loc1_.push({
            "type":HitBoxSprite.SHIELD,
            "name":"shieldBox"
         });
         _loc1_.push({
            "type":HitBoxSprite.SHIELDATTACK,
            "name":"shieldAttackBox"
         });
         _loc1_.push({
            "type":HitBoxSprite.SHIELDPROJECTILE,
            "name":"shieldProjectileBox"
         });
         _loc1_.push({
            "type":HitBoxSprite.REVERSE,
            "name":"reverseBox"
         });
         _loc1_.push({
            "type":HitBoxSprite.CATCH,
            "name":"catchBox"
         });
         _loc1_.push({
            "type":HitBoxSprite.LEDGE,
            "name":"ledgeBox"
         });
         _loc1_.push({
            "type":HitBoxSprite.CAM,
            "name":"camBox"
         });
         _loc1_.push({
            "type":HitBoxSprite.HOMING,
            "name":"homing"
         });
         _loc1_.push({
            "type":HitBoxSprite.PLOCK,
            "name":"pLockBox"
         });
         _loc1_.push({
            "type":HitBoxSprite.HAT,
            "name":"hatBox"
         });
         _loc1_.push({
            "type":HitBoxSprite.ITEM,
            "name":"itemBox"
         });
         _loc1_.push({
            "type":HitBoxSprite.EGG,
            "name":"eggBox"
         });
         _loc1_.push({
            "type":HitBoxSprite.FREEZE,
            "name":"freezeBox"
         });
         _loc1_.push({
            "type":HitBoxSprite.STAR,
            "name":"starBox"
         });
         _loc1_.push({
            "type":HitBoxSprite.CUSTOM,
            "name":"customBox"
         });
         return _loc1_;
      }
      
      public static function createHitBoxAnimation(param1:String, param2:MovieClip, param3:DisplayObject, param4:Object = null) : HitBoxAnimation
      {
         var _loc5_:* = undefined;
         var _loc6_:Object = null;
         var _loc7_:Rectangle = null;
         var _loc8_:HitBoxSprite = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:Array = null;
         var _loc16_:MovieClip = null;
         var _loc19_:Rectangle = null;
         if(m_animationsList[param1])
         {
            return m_animationsList[param1];
         }
         var _loc9_:HitBoxAnimation = new HitBoxAnimation(param1);
         var _loc17_:MovieClip = new MovieClip();
         _loc17_.graphics.beginFill(16711680,0);
         _loc17_.graphics.drawCircle(0,0,1);
         _loc17_.graphics.endFill();
         var _loc18_:Vector.<String> = new Vector.<String>();
         for(_loc5_ in param4)
         {
            _loc18_.push(_loc5_);
         }
         _loc10_ = 0;
         while(_loc10_ < param2.totalFrames)
         {
            _loc19_ = null;
            param2.gotoAndStop(_loc10_ + 1);
            _loc11_ = 0;
            while(_loc11_ < param2.numChildren)
            {
               _loc16_ = param2.getChildAt(_loc11_) as MovieClip;
               if(Boolean(_loc16_) && Boolean(_loc16_.name) && Boolean(_loc16_.name.match(/^[a-zA-Z]+(?:\d+)?$/i)))
               {
                  _loc13_ = _loc16_.name;
                  _loc15_ = _loc13_.match(/^[a-zA-Z]+/i);
                  _loc14_ = _loc15_ ? _loc15_[0] : "";
                  if(Boolean(_loc14_) && HIT_BOX_MAP[_loc14_] !== undefined)
                  {
                     _loc15_ = _loc13_.match(/(?:\d+)$/i);
                     _loc12_ = _loc15_ ? int(parseInt(_loc15_[0])) : 1;
                     if(_loc12_ > 0)
                     {
                        if(Main.DEBUG)
                        {
                           if(!param2.getChildByName(_loc14_))
                           {
                              MenuController.debugConsole.alert("Warning! A hit box was found in " + param1 + " named " + _loc13_ + " without a preceeding " + _loc14_);
                           }
                        }
                        _loc6_ = _loc18_.indexOf(_loc13_) >= 0 ? param4[_loc13_] : null;
                        param2.addChild(_loc17_);
                        _loc17_.x = _loc16_.x;
                        _loc17_.y = _loc16_.y;
                        _loc7_ = _loc17_.getRect(param3);
                        _loc8_ = new HitBoxSprite(HIT_BOX_MAP[_loc14_],_loc16_.getBounds(param3),_loc16_.circular == true,_loc6_,new Point(_loc7_.x,_loc7_.y),new Point(_loc16_.scaleX,_loc16_.scaleY),_loc16_.rotation,_loc16_.transform.matrix.clone(),param2.getChildIndex(_loc16_),_loc12_);
                        param2.removeChild(_loc17_);
                        if(_loc9_.addHitBox(_loc10_ + 1,_loc8_))
                        {
                           _loc8_.Name = _loc13_;
                        }
                        if(!_loc19_)
                        {
                           _loc19_ = _loc8_.BoundingBox.clone();
                           _loc19_.width = _loc19_.x + _loc19_.width;
                           _loc19_.height = _loc19_.y + _loc19_.height;
                        }
                        else
                        {
                           _loc19_.x = Math.min(_loc19_.x,_loc8_.x);
                           _loc19_.y = Math.min(_loc19_.y,_loc8_.y);
                           _loc19_.width = Math.max(_loc19_.width,_loc8_.x + _loc8_.width);
                           _loc19_.height = Math.max(_loc19_.height,_loc8_.y + _loc8_.height);
                        }
                     }
                  }
               }
               _loc11_++;
            }
            if(_loc19_)
            {
               _loc9_.addHitBox(_loc10_ + 1,new HitBoxSprite(HitBoxSprite.MASTER,new Rectangle(_loc19_.x,_loc19_.y,_loc19_.width - _loc19_.x,_loc19_.height - _loc19_.y)));
            }
            _loc10_++;
         }
         if(_loc17_.parent)
         {
            _loc17_.parent.removeChild(_loc17_);
         }
         _loc17_.graphics.clear();
         _loc17_ = null;
         return _loc9_;
      }
      
      public function get Name() : String
      {
         return this.m_name;
      }
      
      public function get TotalHitboxes() : int
      {
         return this.m_totalHitboxes;
      }
      
      public function get AttackBoxes() : Vector.<HitBoxSprite>
      {
         return this.m_attackBoxes;
      }
      
      public function addHitBox(param1:int, param2:HitBoxSprite) : Boolean
      {
         var _loc4_:int = 0;
         var _loc6_:Vector.<HitBoxSprite> = null;
         var _loc7_:Array = null;
         var _loc3_:Boolean = true;
         var _loc5_:int = -1;
         if(param2.Type == HitBoxSprite.ATTACK)
         {
            _loc6_ = this.m_attackBoxes;
            _loc7_ = this.m_attackFrames;
         }
         else if(param2.Type == HitBoxSprite.HIT)
         {
            _loc6_ = this.m_hitBoxes;
            _loc7_ = this.m_hitFrames;
         }
         else if(param2.Type == HitBoxSprite.GRAB)
         {
            _loc6_ = this.m_grabBoxes;
            _loc7_ = this.m_grabFrames;
         }
         else if(param2.Type == HitBoxSprite.TOUCH)
         {
            _loc6_ = this.m_touchBoxes;
            _loc7_ = this.m_touchFrames;
         }
         else if(param2.Type == HitBoxSprite.HAND)
         {
            _loc6_ = this.m_handBoxes;
            _loc7_ = this.m_handFrames;
         }
         else if(param2.Type == HitBoxSprite.RANGE)
         {
            _loc6_ = this.m_rangeBoxes;
            _loc7_ = this.m_rangeFrames;
         }
         else if(param2.Type == HitBoxSprite.ABSORB)
         {
            _loc6_ = this.m_absorbBoxes;
            _loc7_ = this.m_absorbFrames;
         }
         else if(param2.Type == HitBoxSprite.COUNTER)
         {
            _loc6_ = this.m_counterBoxes;
            _loc7_ = this.m_counterFrames;
         }
         else if(param2.Type == HitBoxSprite.SHIELD)
         {
            _loc6_ = this.m_shieldBoxes;
            _loc7_ = this.m_shieldFrames;
         }
         else if(param2.Type == HitBoxSprite.SHIELDATTACK)
         {
            _loc6_ = this.m_shieldAttackBoxes;
            _loc7_ = this.m_shieldAttackFrames;
         }
         else if(param2.Type == HitBoxSprite.SHIELDPROJECTILE)
         {
            _loc6_ = this.m_shieldProjectileBoxes;
            _loc7_ = this.m_shieldProjectileFrames;
         }
         else if(param2.Type == HitBoxSprite.REVERSE)
         {
            _loc6_ = this.m_reverseBoxes;
            _loc7_ = this.m_reverseFrames;
         }
         else if(param2.Type == HitBoxSprite.CATCH)
         {
            _loc6_ = this.m_catchBoxes;
            _loc7_ = this.m_catchFrames;
         }
         else if(param2.Type == HitBoxSprite.LEDGE)
         {
            _loc6_ = this.m_ledgeBoxes;
            _loc7_ = this.m_ledgeFrames;
         }
         else if(param2.Type == HitBoxSprite.CAM)
         {
            _loc6_ = this.m_camBoxes;
            _loc7_ = this.m_camFrames;
         }
         else if(param2.Type == HitBoxSprite.HOMING)
         {
            _loc6_ = this.m_homingBoxes;
            _loc7_ = this.m_homingFrames;
         }
         else if(param2.Type == HitBoxSprite.PLOCK)
         {
            _loc6_ = this.m_pLockBoxes;
            _loc7_ = this.m_pLockFrames;
         }
         else if(param2.Type == HitBoxSprite.ITEM)
         {
            _loc6_ = this.m_itemBoxes;
            _loc7_ = this.m_itemFrames;
         }
         else if(param2.Type == HitBoxSprite.HAT)
         {
            _loc6_ = this.m_hatBoxes;
            _loc7_ = this.m_hatFrames;
         }
         else if(param2.Type == HitBoxSprite.EGG)
         {
            _loc6_ = this.m_eggBoxes;
            _loc7_ = this.m_eggFrames;
         }
         else if(param2.Type == HitBoxSprite.FREEZE)
         {
            _loc6_ = this.m_freezeBoxes;
            _loc7_ = this.m_freezeFrames;
         }
         else if(param2.Type == HitBoxSprite.STAR)
         {
            _loc6_ = this.m_starBoxes;
            _loc7_ = this.m_starFrames;
         }
         else if(param2.Type == HitBoxSprite.CUSTOM)
         {
            _loc6_ = this.m_customBoxes;
            _loc7_ = this.m_customFrames;
         }
         else if(param2.Type == HitBoxSprite.MASTER)
         {
            _loc6_ = this.m_masterBoxes;
            _loc7_ = this.m_masterFrames;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc6_.length)
         {
            if(_loc6_[_loc4_].equals(param2))
            {
               _loc5_ = _loc4_;
               _loc3_ = false;
               break;
            }
            _loc4_++;
         }
         if(_loc5_ < 0)
         {
            _loc6_.push(param2);
            _loc5_ = _loc6_.length - 1;
         }
         if(!_loc7_[param1])
         {
            _loc7_[param1] = new Array();
         }
         if(param2.Order < 0 || _loc7_[param1].length <= 0)
         {
            _loc7_[param1].push(_loc6_[_loc5_]);
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < _loc7_[param1].length)
            {
               if(_loc7_[param1][_loc4_].Order > _loc6_[_loc5_].Order)
               {
                  _loc7_[param1].splice(_loc4_,0,_loc6_[_loc5_]);
                  _loc4_ = -1;
                  break;
               }
               _loc4_++;
            }
            if(_loc4_ >= 0)
            {
               _loc7_[param1].push(_loc6_[_loc5_]);
            }
         }
         if(_loc3_)
         {
            ++this.m_totalHitboxes;
         }
         return _loc3_;
      }
      
      public function getHitBoxes(param1:int, param2:uint) : Array
      {
         if(param2 == HitBoxSprite.ATTACK)
         {
            if(!this.m_attackFrames[param1])
            {
               return null;
            }
            return this.m_attackFrames[param1];
         }
         if(param2 == HitBoxSprite.HIT)
         {
            if(!this.m_hitFrames[param1])
            {
               return null;
            }
            return this.m_hitFrames[param1];
         }
         if(param2 == HitBoxSprite.GRAB)
         {
            if(!this.m_grabFrames[param1])
            {
               return null;
            }
            return this.m_grabFrames[param1];
         }
         if(param2 == HitBoxSprite.TOUCH)
         {
            if(!this.m_touchFrames[param1])
            {
               return null;
            }
            return this.m_touchFrames[param1];
         }
         if(param2 == HitBoxSprite.HAND)
         {
            if(!this.m_handFrames[param1])
            {
               return null;
            }
            return this.m_handFrames[param1];
         }
         if(param2 == HitBoxSprite.RANGE)
         {
            if(!this.m_rangeFrames[param1])
            {
               return null;
            }
            return this.m_rangeFrames[param1];
         }
         if(param2 == HitBoxSprite.ABSORB)
         {
            if(!this.m_absorbFrames[param1])
            {
               return null;
            }
            return this.m_absorbFrames[param1];
         }
         if(param2 == HitBoxSprite.COUNTER)
         {
            if(!this.m_counterFrames[param1])
            {
               return null;
            }
            return this.m_counterFrames[param1];
         }
         if(param2 == HitBoxSprite.SHIELD)
         {
            if(!this.m_shieldFrames[param1])
            {
               return null;
            }
            return this.m_shieldFrames[param1];
         }
         if(param2 == HitBoxSprite.SHIELDATTACK)
         {
            if(!this.m_shieldAttackFrames[param1])
            {
               return null;
            }
            return this.m_shieldAttackFrames[param1];
         }
         if(param2 == HitBoxSprite.SHIELDPROJECTILE)
         {
            if(!this.m_shieldProjectileFrames[param1])
            {
               return null;
            }
            return this.m_shieldProjectileFrames[param1];
         }
         if(param2 == HitBoxSprite.REVERSE)
         {
            if(!this.m_reverseFrames[param1])
            {
               return null;
            }
            return this.m_reverseFrames[param1];
         }
         if(param2 == HitBoxSprite.CATCH)
         {
            if(!this.m_catchFrames[param1])
            {
               return null;
            }
            return this.m_catchFrames[param1];
         }
         if(param2 == HitBoxSprite.LEDGE)
         {
            if(!this.m_ledgeFrames[param1])
            {
               return null;
            }
            return this.m_ledgeFrames[param1];
         }
         if(param2 == HitBoxSprite.CAM)
         {
            if(!this.m_camFrames[param1])
            {
               return null;
            }
            return this.m_camFrames[param1];
         }
         if(param2 == HitBoxSprite.HOMING)
         {
            if(!this.m_homingFrames[param1])
            {
               return null;
            }
            return this.m_homingFrames[param1];
         }
         if(param2 == HitBoxSprite.PLOCK)
         {
            if(!this.m_pLockFrames[param1])
            {
               return null;
            }
            return this.m_pLockFrames[param1];
         }
         if(param2 == HitBoxSprite.ITEM)
         {
            if(!this.m_itemFrames[param1])
            {
               return null;
            }
            return this.m_itemFrames[param1];
         }
         if(param2 == HitBoxSprite.HAT)
         {
            if(!this.m_hatFrames[param1])
            {
               return null;
            }
            return this.m_hatFrames[param1];
         }
         if(param2 == HitBoxSprite.EGG)
         {
            if(!this.m_eggFrames[param1])
            {
               return null;
            }
            return this.m_eggFrames[param1];
         }
         if(param2 == HitBoxSprite.FREEZE)
         {
            if(!this.m_freezeFrames[param1])
            {
               return null;
            }
            return this.m_freezeFrames[param1];
         }
         if(param2 == HitBoxSprite.STAR)
         {
            if(!this.m_starFrames[param1])
            {
               return null;
            }
            return this.m_starFrames[param1];
         }
         if(param2 == HitBoxSprite.CUSTOM)
         {
            if(!this.m_customFrames[param1])
            {
               return null;
            }
            return this.m_customFrames[param1];
         }
         if(param2 == HitBoxSprite.MASTER)
         {
            if(!this.m_masterFrames[param1])
            {
               return null;
            }
            return this.m_masterFrames[param1];
         }
         return null;
      }
      
      public function getAllHitBoxesOfType(param1:uint) : Vector.<HitBoxSprite>
      {
         if(param1 == HitBoxSprite.ATTACK)
         {
            return this.m_attackBoxes;
         }
         if(param1 == HitBoxSprite.HIT)
         {
            return this.m_hitBoxes;
         }
         if(param1 == HitBoxSprite.GRAB)
         {
            return this.m_grabBoxes;
         }
         if(param1 == HitBoxSprite.TOUCH)
         {
            return this.m_touchBoxes;
         }
         if(param1 == HitBoxSprite.HAND)
         {
            return this.m_handBoxes;
         }
         if(param1 == HitBoxSprite.RANGE)
         {
            return this.m_rangeBoxes;
         }
         if(param1 == HitBoxSprite.ABSORB)
         {
            return this.m_absorbBoxes;
         }
         if(param1 == HitBoxSprite.COUNTER)
         {
            return this.m_counterBoxes;
         }
         if(param1 == HitBoxSprite.SHIELD)
         {
            return this.m_shieldBoxes;
         }
         if(param1 == HitBoxSprite.SHIELDATTACK)
         {
            return this.m_shieldAttackBoxes;
         }
         if(param1 == HitBoxSprite.SHIELDPROJECTILE)
         {
            return this.m_shieldProjectileBoxes;
         }
         if(param1 == HitBoxSprite.REVERSE)
         {
            return this.m_reverseBoxes;
         }
         if(param1 == HitBoxSprite.CATCH)
         {
            return this.m_catchBoxes;
         }
         if(param1 == HitBoxSprite.LEDGE)
         {
            return this.m_ledgeBoxes;
         }
         if(param1 == HitBoxSprite.CAM)
         {
            return this.m_camBoxes;
         }
         if(param1 == HitBoxSprite.HOMING)
         {
            return this.m_homingBoxes;
         }
         if(param1 == HitBoxSprite.PLOCK)
         {
            return this.m_pLockBoxes;
         }
         if(param1 == HitBoxSprite.ITEM)
         {
            return this.m_itemBoxes;
         }
         if(param1 == HitBoxSprite.HAT)
         {
            return this.m_hatBoxes;
         }
         if(param1 == HitBoxSprite.EGG)
         {
            return this.m_eggBoxes;
         }
         if(param1 == HitBoxSprite.FREEZE)
         {
            return this.m_freezeBoxes;
         }
         if(param1 == HitBoxSprite.STAR)
         {
            return this.m_starBoxes;
         }
         if(param1 == HitBoxSprite.CUSTOM)
         {
            return this.m_customBoxes;
         }
         if(param1 == HitBoxSprite.MASTER)
         {
            return this.m_masterBoxes;
         }
         return new Vector.<HitBoxSprite>();
      }
   }
}


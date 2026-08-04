package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.desktop.*;
   import flash.display.MovieClip;
   
   public class HitBoxManager
   {
      
      private static var m_hitBoxManagerList:Object = {};
      
      private var m_name:String;
      
      private var m_hitBoxAnimationList:Vector.<HitBoxAnimation>;
      
      private var m_hitBoxAnimationIndexes:Array;
      
      private var m_hasHitBoxes:Boolean;
      
      public function HitBoxManager(param1:String)
      {
         super();
         this.m_name = param1;
         m_hitBoxManagerList[param1] = this;
         this.m_hasHitBoxes = false;
         this.m_hitBoxAnimationList = new Vector.<HitBoxAnimation>();
         this.m_hitBoxAnimationIndexes = new Array();
      }
      
      public static function getOrCreate(param1:String) : HitBoxManager
      {
         var _loc2_:HitBoxManager = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:MovieClip = null;
         if(HitBoxManager.HitBoxManageList[param1] != null)
         {
            return HitBoxManager.HitBoxManageList[param1];
         }
         _loc2_ = new HitBoxManager(param1);
         _loc3_ = 0;
         _loc4_ = 0;
         _loc5_ = ResourceManager.getLibraryMC(param1);
         if(!_loc5_)
         {
            if(MenuController.debugConsole)
            {
               MenuController.debugConsole.alert("Warning, cannot find MovieClip with linkage id \'" + param1 + "\' so hitbox data could not be loaded!");
            }
         }
         _loc3_ = 0;
         while(Boolean(_loc5_) && _loc3_ < _loc5_.totalFrames)
         {
            _loc5_.gotoAndStop(_loc3_ + 1);
            if(_loc5_)
            {
               if(_loc5_.stance)
               {
                  Utils.removeActionScript(_loc5_.stance);
                  _loc2_.addHitBoxAnimation(HitBoxAnimation.createHitBoxAnimation(param1 + "_" + _loc5_.currentLabel,_loc5_.stance,_loc5_));
               }
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function clearCache() : void
      {
         m_hitBoxManagerList = {};
         HitBoxAnimation.AnimationsList.splice(0,HitBoxAnimation.AnimationsList.length);
      }
      
      public static function get HitBoxManageList() : Object
      {
         return m_hitBoxManagerList;
      }
      
      public static function dump() : String
      {
         var _loc1_:* = undefined;
         var _loc2_:HitBoxManager = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector.<HitBoxSprite> = null;
         var _loc6_:int = 0;
         var _loc7_:String = "";
         var _loc8_:Vector.<Object> = HitBoxAnimation.HitBoxTypes;
         for(_loc1_ in m_hitBoxManagerList)
         {
            _loc7_ += "Manager " + _loc1_ + ":\r\n";
            _loc7_ += "--------------------------------";
            _loc2_ = m_hitBoxManagerList[_loc1_];
            _loc3_ = 0;
            while(_loc3_ < _loc2_.HitBoxAnimationList.length)
            {
               _loc7_ += "Animation " + _loc2_.HitBoxAnimationList[_loc3_].Name + ":\r\n";
               _loc4_ = 0;
               while(_loc4_ < _loc8_.length)
               {
                  _loc5_ = _loc2_.HitBoxAnimationList[_loc3_].getAllHitBoxesOfType(_loc8_[_loc4_].type);
                  _loc6_ = 0;
                  while(_loc6_ < _loc5_.length)
                  {
                     _loc7_ += "Hitbox { name:" + _loc8_[_loc4_].name + " rect: " + _loc5_[_loc6_].BoundingBox + " }\r\n";
                     _loc6_++;
                  }
                  _loc4_++;
               }
               _loc3_++;
            }
         }
         Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,_loc7_);
         return _loc7_;
      }
      
      public function get HasHitBoxes() : Boolean
      {
         return this.m_hasHitBoxes;
      }
      
      public function get HitBoxAnimationList() : Vector.<HitBoxAnimation>
      {
         return this.m_hitBoxAnimationList;
      }
      
      public function addHitBoxAnimation(param1:HitBoxAnimation) : void
      {
         this.m_hitBoxAnimationList.push(param1);
         this.m_hitBoxAnimationIndexes[param1.Name] = this.m_hitBoxAnimationList.length - 1;
         if(param1.TotalHitboxes)
         {
            this.m_hasHitBoxes = true;
         }
      }
      
      public function getHitBoxAnimation(param1:String) : HitBoxAnimation
      {
         return this.m_hitBoxAnimationIndexes[param1] !== undefined ? this.m_hitBoxAnimationList[this.m_hitBoxAnimationIndexes[param1]] : null;
      }
   }
}


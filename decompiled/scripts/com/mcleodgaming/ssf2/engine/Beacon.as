package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.api.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   import flash.text.*;
   
   public class Beacon extends InteractiveSprite
   {
      
      private var m_neighbors:Vector.<Beacon>;
      
      private var m_bid:int;
      
      private var m_visited:Boolean;
      
      private var z:String;
      
      public function Beacon(param1:MovieClip, param2:StageData, param3:int)
      {
         m_baseStats = new InteractiveSpriteStats();
         m_apiInstance = new SSF2Beacon(param2.BASE_CLASSES.SSF2Beacon,this);
         super(param1,param2,false);
         m_sprite.visible = false;
         this.m_neighbors = new Vector.<Beacon>();
         this.m_bid = param3;
         this.m_visited = false;
         this.z = "guid" + Utils.getUID();
         m_apiInstance.initialize();
      }
      
      public static function nextNeighbor(param1:Vector.<Beacon>, param2:Array, param3:Number, param4:Number) : Number
      {
         if(param1 != null && param3 >= 0 && param3 < param1.length && param4 < param1.length)
         {
            param4++;
            while(param4 < param1.length)
            {
               if(param4 != param3 && param2[param3][param4] != int.MAX_VALUE)
               {
                  return param4;
               }
               param4++;
            }
         }
         return param1.length;
      }
      
      public function get Z() : String
      {
         return this.z;
      }
      
      public function get BID() : int
      {
         return this.m_bid;
      }
      
      public function get Neighbors() : Vector.<Beacon>
      {
         return this.m_neighbors;
      }
      
      public function get Visited() : Boolean
      {
         return this.m_visited;
      }
      
      public function set Visited(param1:Boolean) : void
      {
         this.m_visited = param1;
      }
      
      public function addPotentialNeighbor(param1:Beacon) : Boolean
      {
         var _loc2_:Boolean = false;
         if(this != param1)
         {
            if(checkLinearPath(param1))
            {
               _loc2_ = true;
               this.m_neighbors.push(param1);
            }
         }
         return _loc2_;
      }
      
      public function traceNeighbors() : void
      {
         var _loc1_:TextField = new TextField();
         _loc1_.text = this.z;
         m_sprite.addChild(_loc1_);
      }
   }
}


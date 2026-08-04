package com.mcleodgaming.ssf2.controllers
{
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class NewsMenuHand extends SelectHand
   {
      
      public var topBoundPush:Function;
      
      public var bottomBoundPush:Function;
      
      public function NewsMenuHand(param1:MovieClip, param2:Vector.<NewsButton>, param3:Function)
      {
         var _loc5_:int = 0;
         var _loc4_:Vector.<HandButton> = new Vector.<HandButton>();
         while(_loc5_ < param2.length)
         {
            _loc4_.push(param2[_loc5_]);
            _loc5_++;
         }
         super(param1,_loc4_,param3);
         START_POSITION.x = -246;
         START_POSITION.y = -132;
         BOUNDS_RECT.x = -287;
         BOUNDS_RECT.y = -145;
         BOUNDS_RECT.width = 585;
         BOUNDS_RECT.height = 300;
         resetPosition();
      }
      
      override protected function checkControls(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(m_hand.y <= BOUNDS_RECT.y && this.topBoundPush !== null)
         {
            _loc2_ = 0;
            while(_loc2_ < m_players.length)
            {
               if(m_players[_loc2_].IsDown(m_players[_loc2_]._UP))
               {
                  this.topBoundPush();
                  break;
               }
               _loc2_++;
            }
         }
         else if(m_hand.y >= BOUNDS_RECT.y + BOUNDS_RECT.height && this.bottomBoundPush !== null)
         {
            _loc2_ = 0;
            while(_loc2_ < m_players.length)
            {
               if(m_players[_loc2_].IsDown(m_players[_loc2_]._DOWN))
               {
                  this.bottomBoundPush();
                  break;
               }
               _loc2_++;
            }
         }
         super.checkControls(param1);
      }
      
      override protected function checkBounds(param1:DisplayObject, param2:DisplayObject = null) : Boolean
      {
         return super.checkBounds(param1,param1.parent.parent);
      }
   }
}


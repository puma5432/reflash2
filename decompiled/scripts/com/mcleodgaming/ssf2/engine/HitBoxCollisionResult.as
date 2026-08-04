package com.mcleodgaming.ssf2.engine
{
   public class HitBoxCollisionResult
   {
      
      private var m_firstHitBox:HitBoxSprite;
      
      private var m_secondHitBox:HitBoxSprite;
      
      private var m_overlapHitBox:HitBoxSprite;
      
      public function HitBoxCollisionResult(param1:HitBoxSprite, param2:HitBoxSprite, param3:HitBoxSprite)
      {
         super();
         this.m_firstHitBox = param1;
         this.m_secondHitBox = param2;
         this.m_overlapHitBox = param3;
      }
      
      public function get FirstHitBox() : HitBoxSprite
      {
         return this.m_firstHitBox;
      }
      
      public function get SecondHitBox() : HitBoxSprite
      {
         return this.m_secondHitBox;
      }
      
      public function get OverlapHitBox() : HitBoxSprite
      {
         return this.m_overlapHitBox;
      }
   }
}


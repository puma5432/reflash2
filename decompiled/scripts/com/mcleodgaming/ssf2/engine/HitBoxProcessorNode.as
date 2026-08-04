package com.mcleodgaming.ssf2.engine
{
   public class HitBoxProcessorNode
   {
      
      private var m_selfSprite:InteractiveSprite;
      
      private var m_otherSprite:InteractiveSprite;
      
      private var m_hboxResult:HitBoxCollisionResult;
      
      private var m_callback:Function;
      
      private var m_handled:Boolean;
      
      public function HitBoxProcessorNode(param1:InteractiveSprite, param2:InteractiveSprite, param3:HitBoxCollisionResult, param4:Function)
      {
         super();
         this.m_selfSprite = param1;
         this.m_otherSprite = param2;
         this.m_hboxResult = param3;
         this.m_callback = param4;
         this.m_handled = false;
      }
      
      public function run() : void
      {
         if(!this.m_handled && !this.m_selfSprite.SkipAttackProcessing)
         {
            this.m_callback(this.m_otherSprite,this.m_hboxResult);
            this.m_handled = true;
         }
      }
   }
}


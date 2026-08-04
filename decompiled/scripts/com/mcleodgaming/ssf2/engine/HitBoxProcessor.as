package com.mcleodgaming.ssf2.engine
{
   public class HitBoxProcessor
   {
      
      protected var m_reactions:Vector.<Vector.<HitBoxProcessorNode>> = new Vector.<Vector.<HitBoxProcessorNode>>();
      
      public function HitBoxProcessor()
      {
         super();
         this.m_reactions = new Vector.<Vector.<HitBoxProcessorNode>>();
      }
      
      public function process() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.m_reactions.length)
         {
            _loc1_ = 0;
            while(_loc1_ < this.m_reactions[_loc2_].length)
            {
               this.m_reactions[_loc2_][_loc1_].run();
               _loc1_++;
            }
            this.m_reactions[_loc2_].splice(0,this.m_reactions[_loc2_].length);
            _loc2_++;
         }
      }
      
      public function queue(param1:HitBoxProcessorNode, param2:int) : void
      {
         if(param2 >= this.m_reactions.length)
         {
            while(param2 >= this.m_reactions.length)
            {
               this.m_reactions.push(new Vector.<HitBoxProcessorNode>());
            }
         }
         this.m_reactions[param2].push(param1);
      }
   }
}


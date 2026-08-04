package com.mcleodgaming.ssf2.assists
{
   import com.mcleodgaming.ssf2.enemies.Enemy;
   import com.mcleodgaming.ssf2.enemies.EnemyStats;
   import com.mcleodgaming.ssf2.engine.StageData;
   
   public class AssistTrophy extends Enemy
   {
      
      public function AssistTrophy(param1:EnemyStats, param2:StageData, param3:Number, param4:Number, param5:int = -1)
      {
         super(param1,param2,param3,param4,param5);
         STAGEDATA.playSpecificSound("assist_open");
      }
      
      override protected function move() : void
      {
         if(!m_collision.ground && !isHitStunOrParalysis())
         {
            m_attemptToMove(m_xSpeed,0);
            m_attemptToMove(0,m_ySpeed);
         }
         else if(!isHitStunOrParalysis())
         {
            applyGroundInfluence();
            if(m_ySpeed < 0)
            {
               unnattachFromGround();
               m_attemptToMove(0,m_ySpeed);
            }
            else
            {
               m_sprite.x += m_xSpeed;
               attachToGround();
            }
         }
      }
      
      override public function fadeOut() : void
      {
         if(!m_fadeTimer.IsComplete)
         {
            super.fadeOut();
            if(m_fadeTimer.CurrentTime == m_fadeTimer.MaxTime - 9)
            {
               STAGEDATA.playSpecificSound("assist_vanish");
               attachEffect("enemy_disappear");
            }
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
   }
}


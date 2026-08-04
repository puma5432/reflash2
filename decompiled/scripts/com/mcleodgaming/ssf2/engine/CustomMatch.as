package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.api.*;
   import com.mcleodgaming.ssf2.controllers.Game;
   
   public class CustomMatch
   {
      
      private var m_apiInstance:SSF2CustomMatch;
      
      private var m_game:Game;
      
      public function CustomMatch(param1:Game, param2:Object = null)
      {
         super();
         if(!param2)
         {
            param2 = {};
         }
         this.m_apiInstance = new SSF2CustomMatch(param2.classAPI,this);
         this.m_game = this.m_apiInstance.matchSetup(param1);
         this.m_game.CustomMatchObj = this;
         this.m_game.CustomModeObj = param1.CustomModeObj;
         this.m_game.ReplayDataObj = param1.CustomModeObj.InitialGameSettings.ReplayDataObj;
         if(this.m_game.ReplayDataObj)
         {
            this.m_game.LevelData.randSeed = this.m_game.ReplayDataObj.MatchSettings.randSeed;
         }
      }
      
      public function get APIInstance() : SSF2CustomMatch
      {
         return this.m_apiInstance;
      }
      
      public function getGameSettings() : Game
      {
         return this.m_game;
      }
      
      public function update() : void
      {
         if(this.m_apiInstance)
         {
            this.m_apiInstance.update();
         }
      }
   }
}


package com.mcleodgaming.ssf2.modes
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.api.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.CustomMatch;
   import com.mcleodgaming.ssf2.menus.*;
   import com.mcleodgaming.ssf2.net.*;
   import com.mcleodgaming.ssf2.util.*;
   
   public class CustomMode
   {
      
      protected var m_initialGameSettings:Game;
      
      protected var m_currentGame:Game;
      
      protected var m_apiInstance:SSF2CustomMode;
      
      protected var m_previousMenu:Menu;
      
      protected var m_modeSettings:Object;
      
      protected var m_stats:Object;
      
      protected var m_stub:Boolean;
      
      public function CustomMode(param1:Game, param2:Object, param3:Object = null, param4:Boolean = false)
      {
         super();
         this.m_initialGameSettings = param1;
         this.m_modeSettings = param2;
         this.m_stats = param3;
         this.m_stub = param4;
         if(!this.m_stats)
         {
            this.m_stats = {};
         }
         this.m_apiInstance = new SSF2CustomMode(this.m_stats.classAPI,this);
         this.m_apiInstance.initialize();
      }
      
      public function get APIInstance() : SSF2CustomMode
      {
         return this.m_apiInstance;
      }
      
      public function get ModeSettings() : Object
      {
         return this.m_modeSettings;
      }
      
      public function get InitialGameSettings() : Game
      {
         return this.m_initialGameSettings;
      }
      
      public function get GameInstance() : Game
      {
         return this.m_currentGame;
      }
      
      public function get PreviousMenu() : Menu
      {
         return this.m_previousMenu;
      }
      
      public function set PreviousMenu(param1:Menu) : void
      {
         this.m_previousMenu = param1;
      }
      
      public function retry() : void
      {
         this.m_apiInstance = new SSF2CustomMode(this.m_stats.classAPI,this);
         this.m_apiInstance.initialize();
      }
      
      public function startMatch(param1:CustomMatch) : void
      {
         var _loc2_:int = 0;
         this.m_currentGame = param1.getGameSettings();
         this.m_currentGame.GameMode = this.m_initialGameSettings.GameMode;
         if(this.m_stub)
         {
            return;
         }
         if(MultiplayerManager.Connected)
         {
            return;
         }
         GameController.isStarted = true;
         this.m_currentGame.LevelData.randSeed = this.m_currentGame.ReplayDataObj ? Number(this.m_currentGame.ReplayDataObj.MatchSettings.randSeed) : Number(Utils.randomInteger(1,1000));
         Utils.setRandSeed(this.m_currentGame.LevelData.randSeed);
         Utils.shuffleRandom();
         Main.prepRandomCharacters(this.m_currentGame.PlayerSettings.length);
         ResourceManager.queueResources([this.m_currentGame.LevelData.stage]);
         if(param1.getGameSettings().LevelData.musicOverride)
         {
            ResourceManager.queueResources([param1.getGameSettings().LevelData.musicOverride]);
         }
         trace("Match settings:",JSON.stringify(this.m_currentGame.PlayerSettings));
         while(_loc2_ < this.m_currentGame.PlayerSettings.length)
         {
            if(Boolean(this.m_currentGame.PlayerSettings[_loc2_] && this.m_currentGame.PlayerSettings[_loc2_].exist) && Boolean(this.m_currentGame.PlayerSettings[_loc2_].character != null) && this.m_currentGame.PlayerSettings[_loc2_].character != "xp")
            {
               ResourceManager.queueResources([this.m_currentGame.PlayerSettings[_loc2_].character == "random" ? Main.RandCharList[_loc2_].StatsName : this.m_currentGame.PlayerSettings[_loc2_].character]);
            }
            _loc2_++;
         }
         MenuController.loadingMenu.show();
         ResourceManager.load({"oncomplete":this.startCustomMatch});
      }
      
      public function startCustomMatch(param1:* = null) : void
      {
         MenuController.disposeAllMenus();
         GameController.startMatch(this.m_currentGame);
      }
      
      public function saveModeData(param1:Object) : Boolean
      {
         return false;
      }
      
      public function endMode(param1:Object) : void
      {
         var data:Object = param1;
         MenuController.removeAllMenus();
         UnlockController.checkUnlocks();
         UnlockController.nextMenuFunc = function():void
         {
            if(m_previousMenu)
            {
               if(m_previousMenu is VaultMenu)
               {
                  MenuController.vaultMenu.show();
               }
               else
               {
                  m_previousMenu.show();
               }
            }
            else
            {
               MenuController.titleMenu.show();
            }
         };
         if(UnlockController.pendingUnlockFights.length > 0)
         {
            MenuController.preUnlockMenu.show();
         }
         else if(UnlockController.pendingUnlockScreens.length > 0)
         {
            MenuController.postUnlockMenu.show();
         }
         else if(this.m_previousMenu)
         {
            if(this.m_previousMenu is VaultMenu)
            {
               MenuController.vaultMenu.show();
            }
            else
            {
               this.m_previousMenu.show();
            }
         }
         else
         {
            MenuController.titleMenu.show();
         }
      }
   }
}


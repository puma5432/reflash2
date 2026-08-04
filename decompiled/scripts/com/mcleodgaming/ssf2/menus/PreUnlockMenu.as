package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   
   public class PreUnlockMenu extends Menu
   {
      
      private var ready:Boolean;
      
      private var m_keyLetGo:Boolean;
      
      private var tempRandSeed:Number;
      
      public function PreUnlockMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_preunlock");
         m_subMenu.stop();
         this.ready = false;
         m_container.addChild(m_subMenu);
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         this.m_keyLetGo = false;
         this.tempRandSeed = 0;
      }
      
      override public function makeEvents() : void
      {
         if(m_showCount == 0)
         {
            findSubMenuButtons();
         }
         super.makeEvents();
         m_subMenu.addEventListener(MouseEvent.CLICK,this.CLICKED);
         m_subMenu.addEventListener(Event.ENTER_FRAME,this.startMatch);
         this.m_keyLetGo = false;
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.removeEventListener(MouseEvent.CLICK,this.CLICKED);
         m_subMenu.removeEventListener(Event.ENTER_FRAME,this.startMatch);
      }
      
      private function CLICKED(param1:MouseEvent) : void
      {
         if(m_subMenu.challenger_mc.currentFrame >= m_subMenu.challenger_mc.totalFrames)
         {
            this.ready = true;
         }
      }
      
      override public function show() : void
      {
         SoundQueue.instance.stopMusic();
         SoundQueue.instance.stopAllSounds();
         SoundQueue.instance.setLoopFunction(SoundQueue.instance.loopMusic);
         m_subMenu.gotoAndStop(UnlockController.pendingUnlockFights[0].ID);
         m_subMenu.challenger_mc.gotoAndPlay(1);
         SoundQueue.instance.playSoundEffect("menu_challenger");
         super.show();
      }
      
      private function startMatch(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         _loc2_ = 0;
         while(_loc2_ < SaveData.Controllers.length && !this.ready && m_subMenu.challenger_mc.currentFrame >= m_subMenu.challenger_mc.totalFrames)
         {
            if(SaveData.Controllers[_loc2_] != null)
            {
               if(SaveData.Controllers[_loc2_].IsDown(SaveData.Controllers[_loc2_]._BUTTON2))
               {
                  if(this.m_keyLetGo)
                  {
                     this.ready = true;
                  }
                  _loc3_ = true;
               }
            }
            _loc2_++;
         }
         if(!_loc3_)
         {
            this.m_keyLetGo = true;
         }
         if(this.ready)
         {
            this.killEvents();
            SoundQueue.instance.stopAllSounds();
            SoundQueue.instance.playSoundEffect("menu_select");
            this.tempRandSeed = Utils.randomInteger(1,1000);
            Utils.setRandSeed(this.tempRandSeed);
            Utils.shuffleRandom();
            Main.prepRandomCharacters(1);
            _loc2_ = 0;
            while(_loc2_ < UnlockController.pendingUnlockFights[0].FilesArray.length)
            {
               ResourceManager.queueResources([UnlockController.pendingUnlockFights[0].FilesArray[_loc2_]]);
               _loc2_++;
            }
            ResourceManager.queueResources([GameController.currentGame.PlayerSettings[0].character == "random" ? Main.RandCharList[0].StatsName : GameController.currentGame.PlayerSettings[0].character]);
            ResourceManager.load({"oncomplete":this.begin});
            this.ready = false;
         }
      }
      
      private function begin(param1:* = null) : void
      {
         removeSelf();
         SoundQueue.instance.stopAllSounds();
         SoundQueue.instance.stopMusic();
         GameController.tmpGame = GameController.currentGame;
         GameController.currentGame = UnlockController.matchSetup(UnlockController.pendingUnlockFights[0]);
         GameController.currentGame.LevelData.randSeed = this.tempRandSeed;
         Utils.setRandSeed(this.tempRandSeed);
         Utils.shuffleRandom();
         Main.prepRandomCharacters(1);
         SoundQueue.instance.setLoopFunction(SoundQueue.instance.loopMusic);
         MenuController.disposeAllMenus();
         GameController.startMatch();
      }
   }
}


package com.mcleodgaming.ssf2.controllers
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.modapi.*;
   import com.mcleodgaming.ssf2.net.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.events.*;
   
   public class StageButton extends HandButton
   {
      
      protected var m_currentGame:Game;
      
      protected var m_stageID:String;
      
      protected var m_hiddenStagesList:Vector.<String>;
      
      protected var m_loadingMask:MovieClip;
      
      protected var m_selectHand:SelectHand;
      
      public function StageButton(param1:Game, param2:MovieClip, param3:String, param4:SelectHand = null)
      {
         var _loc5_:int = 0;
         super(param2);
         this.m_currentGame = param1;
         this.m_stageID = param3;
         this.m_selectHand = param4;
         this.m_hiddenStagesList = new Vector.<String>();
         this.m_hiddenStagesList.push("xpstage");
         this.m_hiddenStagesList.push("mushroomkingdom3");
         this.m_hiddenStagesList.push("skyworld");
         this.m_hiddenStagesList.push("castlesiege");
         while(_loc5_ < this.m_hiddenStagesList.length)
         {
            if(!Main.DEBUG && param3 == this.m_hiddenStagesList[_loc5_])
            {
               m_button.visible = false;
               break;
            }
            _loc5_++;
         }
         this.m_loadingMask = ResourceManager.getLibraryMC("loadingMask");
         this.m_loadingMask.x = Main.Width / 2;
         this.m_loadingMask.y = Main.Height / 2;
      }
      
      public function setSelectHand(param1:SelectHand) : void
      {
         this.m_selectHand = param1;
      }
      
      public function get StageID() : String
      {
         return this.m_stageID;
      }
      
      public function setCurrentGame(param1:Game) : void
      {
         this.m_currentGame = param1;
      }
      
      override protected function button_ROLLOVER(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         SoundQueue.instance.playSoundEffect("menu_hover");
         if(MenuController.stageSelectMenu.SubMenu.stage_sample.previewer.getChildByName("mc") != null)
         {
            Utils.tryToGotoAndStop(MovieClip(MenuController.stageSelectMenu.SubMenu.stage_sample.previewer.getChildByName("mc")),this.m_stageID == "random" ? "random" : this.m_stageID);
            _loc2_ = "Untitled";
            if(this.m_stageID === "random")
            {
               _loc2_ = "Random";
            }
            else if(this.m_stageID === "xpstage")
            {
               _loc2_ = "Expansion Stage";
            }
            else
            {
               _loc3_ = ResourceManager.getResourceByID("mappings").getProp("metadata").stage;
               if(_loc3_[this.m_stageID])
               {
                  _loc2_ = _loc3_[this.m_stageID].name || "";
               }
               else
               {
                  _loc2_ = "Untitled";
               }
            }
            MenuController.stageSelectMenu.SubMenu.stage_sample.stage_txt.text = _loc2_;
         }
      }
      
      override protected function button_CLICK(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(!GameController.isStarted)
         {
            if(this.m_stageID !== "random" && !ResourceManager.getResourceByID(this.m_stageID).FileName)
            {
               SoundQueue.instance.playSoundEffect("menu_error");
               return;
            }
            SoundQueue.instance.playSoundEffect("menu_crowd");
            SoundQueue.instance.playSoundEffect("menu_selectstage");
            GameController.isStarted = true;
            this.m_currentGame.LevelData.stage = this.m_stageID === "random" ? StageSetting.getRandomStage(false,false,this.m_currentGame.GameMode !== Mode.TRAINING) : this.m_stageID;
            ModAPI.triggerMenuRumble(Boolean(this.m_selectHand) && this.m_selectHand.lastControllerIndex >= 0 ? this.m_selectHand.lastControllerIndex : 0);
            m_button.removeEventListener(MouseEvent.ROLL_OVER,this.button_ROLLOVER);
            m_button.removeEventListener(MouseEvent.CLICK,this.button_CLICK);
            m_button.removeEventListener(MouseEvent.ROLL_OUT,this.button_ROLLOUT);
            if(this.m_currentGame.GameMode === Mode.ONLINE)
            {
               MultiplayerManager.toWaitingRoom(this.m_currentGame,this.startGame);
            }
            else
            {
               Main.Root.addChild(this.m_loadingMask);
               this.m_currentGame.LevelData.randSeed = Utils.randomInteger(1,1000);
               Utils.setRandSeed(this.m_currentGame.LevelData.randSeed);
               Utils.shuffleRandom();
               Main.prepRandomCharacters(this.m_currentGame.PlayerSettings.length);
               ResourceManager.queueResources([this.m_currentGame.LevelData.stage]);
               _loc2_ = 1;
               while(_loc2_ <= this.m_currentGame.PlayerSettings.length)
               {
                  if(Boolean(this.m_currentGame.PlayerSettings[_loc2_ - 1] && this.m_currentGame.PlayerSettings[_loc2_ - 1].exist) && Boolean(this.m_currentGame.PlayerSettings[_loc2_ - 1].character != null) && this.m_currentGame.PlayerSettings[_loc2_ - 1].character != "xp")
                  {
                     ResourceManager.queueResources([this.m_currentGame.PlayerSettings[_loc2_ - 1].character == "random" ? Main.RandCharList[_loc2_ - 1].StatsName : this.m_currentGame.PlayerSettings[_loc2_ - 1].character]);
                  }
                  _loc2_++;
               }
               ResourceManager.load({"oncomplete":this.startGame});
            }
         }
      }
      
      override protected function button_ROLLOUT(param1:MouseEvent) : void
      {
         if(!GameController.isStarted)
         {
            Utils.tryToGotoAndStop(MovieClip(MenuController.stageSelectMenu.SubMenu.stage_sample.previewer.getChildByName("mc")),"paused");
            MenuController.stageSelectMenu.SubMenu.stage_sample.stage_txt.text = "";
         }
      }
      
      public function startGame(param1:* = null) : void
      {
         if(this.m_loadingMask.parent != null)
         {
            Main.Root.removeChild(this.m_loadingMask);
         }
         MenuController.disposeAllMenus();
         GameController.startMatch(this.m_currentGame);
      }
   }
}


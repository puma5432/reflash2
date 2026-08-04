package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.api.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.menus.HudMenu;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   
   public class GameTimer
   {
      
      private var m_apiInstance:SSF2GameTimer;
      
      private var ROOT:MovieClip;
      
      private var HUD:HudMenu;
      
      private var STAGEDATA:StageData;
      
      private var m_endGameOptions:Object;
      
      private var m_timer:MovieClip;
      
      private var m_startingTime:Number;
      
      private var m_currentTime:Number;
      
      private var m_on:Boolean;
      
      private var m_countdown:Boolean;
      
      public function GameTimer(param1:Object, param2:StageData)
      {
         super();
         this.m_apiInstance = new SSF2GameTimer(null,this);
         this.STAGEDATA = param2;
         this.ROOT = this.STAGEDATA.RootRef;
         this.HUD = this.STAGEDATA.HudRef;
         this.m_timer = this.HUD.SubMenu[param1["instanceName"]];
         this.m_countdown = param1["countdown"];
         this.m_startingTime = this.m_countdown ? param1["startAt"] * 60 * 30 : 0;
         this.m_currentTime = this.m_startingTime;
         this.m_on = false;
         this.m_endGameOptions = {
            "exit":true,
            "immediate":false,
            "slowMo":false,
            "matchResults":false
         };
      }
      
      public function get APIInstance() : SSF2GameTimer
      {
         return this.m_apiInstance;
      }
      
      public function get TimeMC() : MovieClip
      {
         return this.m_timer;
      }
      
      public function get CountDown() : Boolean
      {
         return this.m_countdown;
      }
      
      public function get CurrentTime() : int
      {
         return this.m_currentTime;
      }
      
      public function set CountDown(param1:Boolean) : void
      {
         this.m_countdown = param1;
      }
      
      public function setEndGameOptions(param1:Object) : void
      {
         var _loc2_:* = undefined;
         for(_loc2_ in param1)
         {
            this.m_endGameOptions[_loc2_] = param1[_loc2_];
         }
      }
      
      public function setCurrentTime(param1:Number) : void
      {
         if(this.m_countdown)
         {
            this.m_startingTime = param1;
         }
         else
         {
            this.m_startingTime = 0;
         }
         this.m_currentTime = param1;
      }
      
      private function updateDisplay() : void
      {
         this.m_currentTime += this.m_countdown ? -1 : 1;
         this.updateTextFields();
         if(this.m_currentTime < 0)
         {
            this.Stop();
            if(ModeFeatures.hasFeature(ModeFeatures.IS_CUSTOM,this.STAGEDATA.GameRef.GameMode))
            {
               this.STAGEDATA.prepareEndGameCustom(this.m_endGameOptions);
            }
            else
            {
               this.STAGEDATA.SoundQueueRef.playVoiceEffect("narrator_time");
               this.STAGEDATA.prepareEndGame(this.m_endGameOptions);
            }
         }
      }
      
      public function updateTextFields() : void
      {
         this.m_timer.display.text = Utils.framesToMinutesString(this.m_currentTime) + ":" + Utils.framesToSecondsString(this.m_currentTime);
         if(this.m_currentTime > 0 && Boolean(this.m_countdown) && this.m_currentTime <= 30 * 5)
         {
            if(this.STAGEDATA.GameRef.GameMode !== Mode.HOME_RUN_CONTEST)
            {
               this.m_timer.visible = false;
            }
            if(this.m_currentTime % 30 === 0)
            {
               this.STAGEDATA.stopNarratorSpeech();
               this.STAGEDATA.SoundQueueRef.playVoiceEffect("narrator_countdown" + parseInt(Utils.framesToSecondsString(this.m_currentTime)));
               if(this.m_currentTime === 30 * 5 && Boolean(this.STAGEDATA.GameRef.LevelData.showEndCountdown))
               {
                  this.STAGEDATA.startCountdown();
               }
            }
         }
         this.m_timer.display_ms.text = Utils.framesToMillisecondsString(this.m_currentTime);
         if(this.m_currentTime <= 0)
         {
            this.m_timer.display.text = "0:00";
            this.m_timer.display_ms.text = "00";
         }
      }
      
      public function Start() : void
      {
         this.m_on = true;
         this.updateTextFields();
      }
      
      public function Stop() : void
      {
         this.m_on = false;
         this.updateTextFields();
      }
      
      public function Restart() : void
      {
         this.m_currentTime = this.m_startingTime;
         this.updateTextFields();
      }
      
      public function PERFORMALL() : void
      {
         if(this.m_on)
         {
            this.updateDisplay();
         }
      }
   }
}


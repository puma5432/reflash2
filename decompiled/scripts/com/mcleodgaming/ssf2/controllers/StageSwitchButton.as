package com.mcleodgaming.ssf2.controllers
{
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class StageSwitchButton extends HandButton
   {
      
      private var m_stageID:String;
      
      private var m_extraClickFunc:Function;
      
      public function StageSwitchButton(param1:MovieClip, param2:String)
      {
         super(param1);
         this.m_stageID = param2;
         this.m_extraClickFunc = null;
      }
      
      public function get ID() : String
      {
         return this.m_stageID;
      }
      
      public function setClickFunc(param1:Function) : void
      {
         this.m_extraClickFunc = param1;
      }
      
      override protected function button_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         var _loc2_:Boolean = m_button.currentFrameLabel == "on";
         m_button.gotoAndStop(_loc2_ ? "off" : "on");
         SaveData.VSStageDataObj[this.m_stageID] = !_loc2_;
         if(this.m_extraClickFunc != null)
         {
            this.m_extraClickFunc(this);
         }
      }
      
      public function getStatus() : Boolean
      {
         return m_button.currentFrameLabel == "on";
      }
      
      public function setStatus(param1:Boolean) : void
      {
         m_button.gotoAndStop(param1 ? "on" : "off");
         if(param1)
         {
            delete SaveData.VSStageDataObj[this.m_stageID];
         }
         else
         {
            SaveData.VSStageDataObj[this.m_stageID] = false;
         }
      }
   }
}


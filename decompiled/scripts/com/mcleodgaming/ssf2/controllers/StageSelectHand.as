package com.mcleodgaming.ssf2.controllers
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.events.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   import flash.events.*;
   
   public class StageSelectHand extends SelectHand
   {
      
      protected var m_spaceLetGo:Boolean;
      
      protected var m_stageButtons:Vector.<StageButton>;
      
      public function StageSelectHand(param1:MovieClip, param2:Vector.<StageButton>, param3:Function)
      {
         var _loc5_:int = 0;
         this.m_stageButtons = param2;
         var _loc4_:Vector.<HandButton> = new Vector.<HandButton>();
         while(_loc5_ < this.m_stageButtons.length)
         {
            _loc4_.push(this.m_stageButtons[_loc5_]);
            _loc5_++;
         }
         super(param1,_loc4_,param3);
         this.m_spaceLetGo = false;
         var _loc6_:Object = ResourceManager.getResourceByID("mappings").getProp("metadata");
         var _loc7_:Object = _loc6_.stage_select_screen;
         START_POSITION.x = _loc7_.hand_start.x;
         START_POSITION.y = _loc7_.hand_start.y;
         BOUNDS_RECT.x = _loc7_.hand_bounds.x;
         BOUNDS_RECT.y = _loc7_.hand_bounds.y;
         BOUNDS_RECT.width = _loc7_.hand_bounds.width;
         BOUNDS_RECT.height = _loc7_.hand_bounds.height;
      }
      
      override public function makeEvents() : void
      {
         this.m_spaceLetGo = false;
         super.makeEvents();
         Main.Root.stage.addEventListener(KeyboardEvent.KEY_UP,this.releaseKey);
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         Main.Root.stage.removeEventListener(KeyboardEvent.KEY_UP,this.releaseKey);
      }
      
      protected function releaseKey(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 32)
         {
            this.m_spaceLetGo = true;
         }
      }
      
      override protected function checkHit(param1:Event) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Boolean = param1 is KeyboardEvent || param1 is GamepadEvent;
         var _loc6_:Boolean = param1 is KeyboardEvent && (param1 as KeyboardEvent).keyCode == 32;
         if(!_loc6_)
         {
            this.m_spaceLetGo = true;
         }
         _loc4_ = 0;
         while(_loc4_ < m_players.length)
         {
            if(!m_players[_loc4_].IsDown(m_players[_loc4_]._BUTTON2) && !m_players[_loc4_].IsDown(m_players[_loc4_]._START))
            {
               m_selectLetGo[_loc4_] = true;
            }
            if(!m_players[_loc4_].IsDown(m_players[_loc4_]._BUTTON1))
            {
               m_backLetGo[_loc4_] = true;
            }
            _loc4_++;
         }
         if(m_targetMC.root == null)
         {
            this.killEvents();
         }
         else if(!GameController.isStarted)
         {
            _loc2_ = false;
            _loc3_ = 0;
            while(_loc3_ < this.m_stageButtons.length && !_loc2_)
            {
               _loc4_ = 0;
               while(_loc4_ < m_players.length)
               {
                  if(Boolean(m_backLetGo[_loc4_]) && m_players[_loc4_].IsDown(m_players[_loc4_]._BUTTON1))
                  {
                     m_backLetGo[_loc4_] = false;
                     this.killEvents();
                     m_backFunc(null);
                     return;
                  }
                  _loc4_++;
               }
               if(checkBounds(this.m_stageButtons[_loc3_].ButtonInstance) && m_hand.visible)
               {
                  if(m_rollOverID != _loc3_)
                  {
                     if(m_rollOverID != -1)
                     {
                        this.m_stageButtons[m_rollOverID].rollout();
                        this.m_stageButtons[m_rollOverID].mouseout();
                     }
                     this.m_stageButtons[_loc3_].rollover();
                     this.m_stageButtons[_loc3_].mouseover();
                  }
                  m_rollOverID = _loc3_;
                  _loc2_ = true;
                  _loc4_ = 0;
                  while(_loc4_ < m_players.length && _loc5_)
                  {
                     if(m_players[_loc4_].IsDown(m_players[_loc4_]._BUTTON2) || m_players[_loc4_].IsDown(m_players[_loc4_]._START))
                     {
                        if(this.m_stageButtons[_loc3_].StageID !== "random" && (!ResourceManager.getResourceByID(this.m_stageButtons[_loc3_].StageID) || !ResourceManager.getResourceByID(this.m_stageButtons[_loc3_].StageID).FileName))
                        {
                           SoundQueue.instance.playSoundEffect("menu_error");
                           return;
                        }
                        this.killEvents();
                        this.m_stageButtons[_loc3_].click();
                        return;
                     }
                     _loc4_++;
                  }
               }
               _loc3_++;
            }
            evaluateExtraButtons();
            if(!_loc2_)
            {
               if(m_rollOverID != -1)
               {
                  this.m_stageButtons[m_rollOverID].rollout();
               }
               m_rollOverID = -1;
            }
            _loc3_ = 0;
            while(_loc3_ < this.m_stageButtons.length && !_loc2_ && _loc5_)
            {
               if(this.m_stageButtons[_loc3_].StageID == "random")
               {
                  _loc4_ = 0;
                  while(_loc4_ < m_players.length)
                  {
                     if(m_players[_loc4_].IsDown(m_players[_loc4_]._START) || _loc6_)
                     {
                        this.killEvents();
                        this.m_stageButtons[_loc3_].rollover();
                        this.m_stageButtons[_loc3_].click();
                        return;
                     }
                     _loc4_++;
                  }
               }
               _loc3_++;
            }
         }
         if(_loc6_)
         {
            this.m_spaceLetGo = false;
         }
      }
   }
}


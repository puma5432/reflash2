package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.mgn.events.*;
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.api.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.modapi.*;
   import com.mcleodgaming.ssf2.net.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.events.*;
   import flash.media.SoundChannel;
   import flash.utils.*;
   
   public class MatchResultsMenu extends Menu
   {
      
      private var skipLevel:int;
      
      private var winnerIs:SoundChannel;
      
      private var winnerChar:Character;
      
      private var m_backKey:Boolean;
      
      private var m_backKeyLetGo:Boolean;
      
      private var m_onlineFinishResendTimer:FrameTimer;
      
      private var m_playerSymbols:Array;
      
      public function MatchResultsMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_matchresults");
         m_subMenu.stop();
         this.skipLevel = 0;
         this.winnerIs = null;
         this.winnerChar = null;
         this.m_onlineFinishResendTimer = new FrameTimer(30 * 10);
         this.m_playerSymbols = new Array();
         m_container.addChild(m_subMenu);
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         this.m_backKey = false;
         this.m_backKeyLetGo = false;
         this.reset();
      }
      
      override public function show() : void
      {
         var _loc1_:Object = null;
         super.show();
         if(Config.enable_match_results)
         {
            this.displayMatchResults();
         }
         else
         {
            if(Boolean(GameController.stageData.OnlineMode) && Boolean(MultiplayerManager.Connected))
            {
               _loc1_ = GameController.stageData.getPlayerByID(MultiplayerManager.PlayerID).getPlayerSettings().exportSettings();
               _loc1_.results = GameController.stageData.getPlayerByID(MultiplayerManager.PlayerID).getMatchResults().exportData();
               MultiplayerManager.sendMatchFinishedSignal({"player_data":_loc1_});
            }
            this.gotoCharScreen(null);
         }
      }
      
      override public function makeEvents() : void
      {
         if(m_showCount == 0)
         {
            findSubMenuButtons();
         }
         m_subMenu.replaySave_btn.buttonMode = true;
         m_subMenu.replaySave_btn.useHandCursor = true;
         m_subMenu.replaySave_btn.visible = !GameController.stageData.ReplayMode;
         super.makeEvents();
         m_subMenu.back_btn.addEventListener(MouseEvent.CLICK,this.gotoCharScreen);
         m_subMenu.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         m_subMenu.stage.addEventListener(MouseEvent.CLICK,this.checkClick);
         m_subMenu.replaySave_btn.addEventListener(MouseEvent.CLICK,this.saveReplay);
         this.m_backKey = false;
         this.m_backKeyLetGo = false;
         SoundQueue.instance.enableDuplicateSupressor();
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.back_btn.removeEventListener(MouseEvent.CLICK,this.gotoCharScreen);
         m_subMenu.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         m_subMenu.stage.removeEventListener(MouseEvent.CLICK,this.checkClick);
         m_subMenu.replaySave_btn.removeEventListener(MouseEvent.CLICK,this.saveReplay);
         SoundQueue.instance.disableDuplicateSupressor();
      }
      
      public function reset() : void
      {
         this.skipLevel = 0;
         m_subMenu.gotoAndPlay(1);
         SaveData.saveGame();
      }
      
      private function saveReplay(param1:MouseEvent) : void
      {
         GameController.stageData.ReplayDataObj.Name = Utils.generateReplaySaveFileName(GameController.stageData);
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTF(GameController.stageData.ReplayDataObj.exportReplay());
         _loc2_.compress();
         Utils.saveFile(_loc2_,GameController.stageData.ReplayDataObj.Name + ".ssfrec");
      }
      
      private function skipAhead() : Boolean
      {
         var _loc1_:int = 0;
         if(this.skipLevel == 0)
         {
            m_subMenu.gotoAndPlay(Boolean(GameController.stageData.NoContest) && Boolean(Utils.hasLabel(m_subMenu,"skipNoContest")) ? "skipNoContest" : "skip");
            this.skipLevel = 1;
            _loc1_ = 0;
            while(_loc1_ < this.m_playerSymbols.length)
            {
               if(Boolean(this.m_playerSymbols[_loc1_].mc) && Boolean(this.m_playerSymbols[_loc1_].mc.stance))
               {
                  if(Boolean(this.m_playerSymbols[_loc1_].shadow) && Boolean(this.m_playerSymbols[_loc1_].shadow.stance))
                  {
                     Utils.tryToGotoAndStop(this.m_playerSymbols[_loc1_].shadow.stance,"skip");
                  }
                  if(Boolean(this.m_playerSymbols[_loc1_].charMC) && Boolean(this.m_playerSymbols[_loc1_].charMC.stance))
                  {
                     Utils.tryToGotoAndStop(this.m_playerSymbols[_loc1_].charMC.stance,"skip");
                  }
               }
               _loc1_++;
            }
            return true;
         }
         if(this.skipLevel == 1)
         {
            m_subMenu.gotoAndStop(Boolean(GameController.stageData.NoContest) && Boolean(Utils.hasLabel(m_subMenu,"skipNoContest2")) ? "skipNoContest2" : "skip2");
            this.skipLevel = 2;
            return true;
         }
         return false;
      }
      
      private function checkClick(param1:MouseEvent) : void
      {
         this.skipAhead();
      }
      
      private function updatePalettes() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Character = null;
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         while(_loc4_ < this.m_playerSymbols.length)
         {
            _loc1_ = this.m_playerSymbols[_loc4_].mc;
            _loc2_ = this.m_playerSymbols[_loc4_].player;
            _loc3_ = ResourceManager.getCostume(_loc2_.StatsName,Utils.getColorString(_loc2_.Team),_loc2_.getPlayerSetting("costume"));
            Utils.recursiveMovieClipPlay(_loc1_,true,false);
            if(_loc3_)
            {
               Utils.replacePalette(_loc1_,_loc3_.paletteSwap,2);
               if(this.m_playerSymbols[_loc4_].charMC)
               {
                  Utils.replacePalette(this.m_playerSymbols[_loc4_].charMC,_loc3_.paletteSwap,2);
               }
            }
            _loc4_++;
         }
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         if(m_subMenu.currentLabel === "skip2" || m_subMenu.currentLabel === "skipNoContest2")
         {
            this.skipLevel = 2;
         }
         else if(m_subMenu.currentLabel === "skip" || m_subMenu.currentLabel === "skipNoContest")
         {
            this.skipLevel = 1;
         }
         _loc2_ = 0;
         while(_loc2_ < SaveData.Controllers.length)
         {
            if(SaveData.Controllers[_loc2_] != null)
            {
               if(SaveData.Controllers[_loc2_].IsDown(SaveData.Controllers[_loc2_]._BUTTON2))
               {
                  this.m_backKey = true;
                  if(this.m_backKeyLetGo)
                  {
                     this.m_backKeyLetGo = false;
                     if(!this.skipAhead())
                     {
                        this.gotoCharScreen(null);
                     }
                  }
                  _loc3_ = true;
               }
            }
            _loc2_++;
         }
         if(!_loc3_)
         {
            this.m_backKeyLetGo = true;
            this.m_backKey = false;
         }
         SoundQueue.instance.clearSurpressor();
         _loc2_ = 0;
         while(_loc2_ < this.m_playerSymbols.length)
         {
            if(Boolean(this.m_playerSymbols[_loc2_].mc) && Boolean(this.m_playerSymbols[_loc2_].mc.stance))
            {
               if(Boolean(this.m_playerSymbols[_loc2_].shadow) && Boolean(this.m_playerSymbols[_loc2_].shadow.stance) && this.m_playerSymbols[_loc2_].mc.stance.currentFrame !== this.m_playerSymbols[_loc2_].shadow.stance.currentFrame)
               {
                  this.m_playerSymbols[_loc2_].shadow.stance.gotoAndStop(this.m_playerSymbols[_loc2_].mc.stance.currentFrame);
               }
               if(Boolean(this.m_playerSymbols[_loc2_].charMC) && Boolean(this.m_playerSymbols[_loc2_].charMC.stance) && this.m_playerSymbols[_loc2_].mc.stance.currentFrame !== this.m_playerSymbols[_loc2_].charMC.stance.currentFrame)
               {
                  this.m_playerSymbols[_loc2_].charMC.stance.gotoAndStop(this.m_playerSymbols[_loc2_].mc.stance.currentFrame);
               }
            }
            _loc2_++;
         }
         this.updatePalettes();
      }
      
      private function gotoCharScreen(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         SoundQueue.instance.stopMusic();
         SoundQueue.instance.setLoopFunction(SoundQueue.instance.loopMusic);
         this.killEvents();
         if(this.winnerIs != null && Boolean(this.winnerIs.hasEventListener(Event.SOUND_COMPLETE)))
         {
            this.winnerIs.removeEventListener(Event.SOUND_COMPLETE,this.sayWinner);
         }
         removeSelf();
         m_subMenu.gotoAndStop(1);
         if(Boolean(GameController.stageData.OnlineMode) || GameController.currentGame.GameMode === Mode.ONLINE_WAITING_ROOM)
         {
            removeSelf();
            m_subMenu.gotoAndStop(1);
            if(MultiplayerManager.Connected)
            {
               MenuController.pleaseWaitMenu.show();
               Main.Root.stage.addEventListener(Event.ENTER_FRAME,this.waitForPlayers);
            }
            else
            {
               GameController.stageData.deactivateCharacters();
               GameController.destroyStageData();
               SSF2API.deinit();
               removeSelf();
               MenuController.mainMenu.show();
            }
         }
         else
         {
            GameController.stageData.deactivateCharacters();
            SSF2API.deinit();
            ModAPI.deinit();
            UnlockController.checkUnlocks();
            UnlockController.nextMenuFunc = function():void
            {
               if(ModeFeatures.hasFeature(ModeFeatures.IS_CUSTOM,GameController.stageData.GameRef.GameMode))
               {
                  GameController.currentGame.CustomModeObj.endMode(null);
               }
               else
               {
                  MenuController.vsMenu.show();
               }
            };
            if(GameController.stageData.ReplayMode)
            {
               removeSelf();
               m_subMenu.gotoAndStop(1);
               GameController.destroyStageData();
               MenuController.vaultMenu.show();
            }
            else if(UnlockController.pendingUnlockFights.length > 0)
            {
               MenuController.preUnlockMenu.show();
            }
            else if(UnlockController.pendingUnlockScreens.length > 0)
            {
               MenuController.postUnlockMenu.show();
            }
            else
            {
               removeSelf();
               m_subMenu.gotoAndStop(1);
               if(ModeFeatures.hasFeature(ModeFeatures.IS_CUSTOM,GameController.stageData.GameRef.GameMode))
               {
                  GameController.currentGame.CustomModeObj.endMode(null);
                  GameController.destroyStageData();
               }
               else
               {
                  GameController.destroyStageData();
                  MenuController.vsMenu.show();
               }
            }
         }
      }
      
      private function waitForPlayers(param1:Event) : void
      {
         if(!MultiplayerManager.RoomKey)
         {
            Main.Root.stage.removeEventListener(Event.ENTER_FRAME,this.waitForPlayers);
            MenuController.pleaseWaitMenu.removeSelf();
            GameController.stageData.deactivateCharacters();
            GameController.destroyStageData();
            SSF2API.deinit();
            ModAPI.deinit();
            MultiplayerManager.resetMasterFrame();
            MultiplayerManager.restoreOriginalGameSettings(MenuController.CurrentCharacterSelectMenu.GameObj);
            MenuController.onlineMenu.show();
            SoundQueue.instance.playMusic("menumusic",0);
         }
         else if(!MultiplayerManager.MatchReady)
         {
            Main.Root.stage.removeEventListener(Event.ENTER_FRAME,this.waitForPlayers);
            if(MultiplayerManager.IsHost)
            {
               MGNEventManager.dispatcher.addEventListener(MGNEvent.UNLOCK_ROOM,this.onlineModeReady);
               MGNEventManager.dispatcher.addEventListener(MGNEvent.ERROR_UNLOCK_ROOM,this.onlineModeReady);
               MultiplayerManager.unlockRoom();
            }
            else
            {
               this.onlineModeReady();
            }
         }
      }
      
      private function onlineModeReady(param1:* = null) : void
      {
         MGNEventManager.dispatcher.removeEventListener(MGNEvent.UNLOCK_ROOM,this.onlineModeReady);
         MGNEventManager.dispatcher.removeEventListener(MGNEvent.ERROR_UNLOCK_ROOM,this.onlineModeReady);
         MenuController.pleaseWaitMenu.removeSelf();
         GameController.stageData.deactivateCharacters();
         GameController.destroyStageData();
         SSF2API.deinit();
         ModAPI.deinit();
         MultiplayerManager.resetMasterFrame();
         MultiplayerManager.restoreOriginalGameSettings(MenuController.CurrentCharacterSelectMenu.GameObj);
         if(Boolean(MultiplayerManager.IsHost) && MultiplayerManager.RoomData.matchSettings.gameMode === Mode.ONLINE_ARENA)
         {
            MenuController.arenaCharacterSelectMenu.show();
         }
         else
         {
            MenuController.onlineCharacterMenu.show();
         }
      }
      
      private function sayWinner(param1:Event) : void
      {
         this.winnerChar = GameController.stageData.getFirstWinner();
         switch(this.winnerChar.Team)
         {
            case -1:
               SoundQueue.instance.playVoiceEffect("narrator_" + this.winnerChar.StatsName);
               break;
            case 1:
               SoundQueue.instance.playVoiceEffect("narrator_redteam");
               break;
            case 2:
               SoundQueue.instance.playVoiceEffect("narrator_greenteam");
               break;
            case 3:
               SoundQueue.instance.playVoiceEffect("narrator_blueteam");
         }
      }
      
      private function saveRecords() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         if(GameController.stageData.NoContest)
         {
            ++SaveData.MatchResets;
         }
         else
         {
            if(GameController.stageData.GameRef.UsingTime)
            {
               ++SaveData.TimeMatchTotal;
            }
            else
            {
               ++SaveData.StockMatchTotal;
            }
            _loc1_ = new Array();
            _loc2_ = 1;
            while(_loc2_ <= GameController.stageData.Players.length)
            {
               if(GameController.stageData.getPlayerByID(_loc2_) != null && _loc1_.indexOf(GameController.stageData.getPlayerByID(_loc2_).StatsName) < 0)
               {
                  SaveData.Records.vs.matches[GameController.stageData.getPlayerByID(_loc2_).StatsName] = SaveData.Records.vs.matches[GameController.stageData.getPlayerByID(_loc2_).StatsName] || 0;
                  ++SaveData.Records.vs.matches[GameController.stageData.getPlayerByID(_loc2_).StatsName];
                  _loc1_.push(GameController.stageData.getPlayerByID(_loc2_).StatsName);
               }
               _loc2_++;
            }
            SaveData.Records.vs.playContestants += _loc1_.length;
            _loc1_ = new Array();
            _loc2_ = 1;
            while(_loc2_ <= GameController.stageData.Players.length)
            {
               if(GameController.stageData.getPlayerByID(_loc2_) != null && GameController.stageData.getPlayerByID(_loc2_).getMatchResults().Rank == 1 && _loc1_.indexOf(GameController.stageData.getPlayerByID(_loc2_).StatsName) < 0)
               {
                  SaveData.Records.vs.wins[GameController.stageData.getPlayerByID(_loc2_).StatsName] = SaveData.Records.vs.wins[GameController.stageData.getPlayerByID(_loc2_).StatsName] || 0;
                  ++SaveData.Records.vs.wins[GameController.stageData.getPlayerByID(_loc2_).StatsName];
                  _loc1_.push(GameController.stageData.getPlayerByID(_loc2_).StatsName);
               }
               _loc2_++;
            }
            SaveData.Records.vs.stages[GameController.stageData.GameRef.LevelData.stage] = SaveData.Records.vs.stages[GameController.stageData.GameRef.LevelData.stage] || 0;
            ++SaveData.Records.vs.stages[GameController.stageData.GameRef.LevelData.stage];
            SaveData.VSPlayTime += GameController.stageData.ElapsedFrames;
            ++SaveData.Records.vs.matchTotal;
            if(GameController.stageData.GameRef.LevelData.teams)
            {
               ++SaveData.Records.vs.teamMatchTotal;
            }
            else
            {
               ++SaveData.Records.vs.ffaMatchTotal;
            }
         }
      }
      
      private function drawPlayer(param1:int) : void
      {
         var _loc2_:Character = null;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         var _loc7_:MovieClip = null;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:MovieClip = null;
         if(ResourceManager.getResourceByID("mappings").getProp("metadata").match_results_screen)
         {
            this.drawPlayerV2(param1);
            return;
         }
         if(m_subMenu["p" + param1 + "Pose"])
         {
            _loc2_ = GameController.stageData.getPlayerByID(param1);
            _loc3_ = _loc2_.getMatchResults().Rank;
            _loc4_ = m_subMenu["p" + param1 + "Results"] as MovieClip;
            _loc5_ = null;
            _loc6_ = ResourceManager.getLibraryMC(_loc2_.LinkageName);
            _loc7_ = _loc4_["charAnim"].addChild(_loc6_);
            _loc7_.player_id = _loc2_.ID;
            _loc7_.gotoAndStop(_loc3_ == 1 && !GameController.stageData.NoContest ? "win" : "lose");
            _loc4_.charName.text = _loc2_.DisplayName;
            _loc4_.placeNum.text = GameController.stageData.NoContest ? "-" : _loc3_;
            _loc2_.updateColorFilter(_loc7_,_loc2_.Team,_loc2_.CostumeName,_loc2_.CostumeID);
            if(GameController.stageData.NoContest)
            {
               this.m_playerSymbols.push({
                  "mc":_loc7_,
                  "player":_loc2_,
                  "shadow":null,
                  "charMC":null
               });
            }
            else if(_loc3_ === 1 && !GameController.stageData.NoContest)
            {
               _loc8_ = int(this.getTeamSlot(param1,_loc2_.Team));
               _loc9_ = 1;
               _loc10_ = null;
               if(GameController.stageData.GameRef.LevelData.teams)
               {
                  _loc9_ = _loc8_;
                  _loc10_ = m_subMenu["p" + _loc8_ + "Pose"].addChild(ResourceManager.getLibraryMC(_loc2_.LinkageName));
                  _loc10_.player_id = _loc2_.ID;
                  Utils.setColorFilter(_loc10_,{
                     "brightness":-1000,
                     "alphaMultiplier":0.25
                  });
                  _loc10_.transform.matrix.c = Math.tan(Utils.toRadians(30));
                  _loc5_ = m_subMenu["p" + _loc8_ + "Pose"].addChild(ResourceManager.getLibraryMC(_loc2_.LinkageName));
                  _loc5_.player_id = _loc2_.ID;
               }
               else
               {
                  _loc9_ = 1;
                  _loc10_ = m_subMenu["p" + _loc8_ + "Pose"].addChild(ResourceManager.getLibraryMC(_loc2_.LinkageName));
                  _loc10_.player_id = _loc2_.ID;
                  Utils.setColorFilter(_loc10_,{
                     "brightness":-1000,
                     "alphaMultiplier":0.25
                  });
                  _loc10_.transform.matrix.c = Math.tan(Utils.toRadians(30));
                  _loc5_ = m_subMenu["p" + _loc8_ + "Pose"].addChild(ResourceManager.getLibraryMC(_loc2_.LinkageName));
                  _loc5_.player_id = _loc2_.ID;
               }
               _loc5_.gotoAndStop("win");
               _loc5_.scaleX = 2.5 * (1 / _loc9_);
               _loc5_.scaleY = 2.5 * (1 / _loc9_);
               this.m_playerSymbols.push({
                  "mc":_loc7_,
                  "player":_loc2_,
                  "shadow":_loc10_,
                  "charMC":_loc5_
               });
               _loc10_.gotoAndStop("win");
               _loc10_.scaleX = 2.5 * (1 / _loc9_);
               _loc10_.scaleY = -0.3 * 2.5 * (1 / _loc9_);
               _loc2_.updateColorFilter(_loc5_,_loc2_.Team,_loc2_.CostumeName,_loc2_.CostumeID);
               if(_loc5_.stance)
               {
                  Utils.removeActionScript(_loc5_.stance);
               }
               if(_loc10_.stance)
               {
                  Utils.removeActionScript(_loc10_.stance);
               }
            }
            else
            {
               this.m_playerSymbols.push({
                  "mc":_loc7_,
                  "player":_loc2_,
                  "shadow":null,
                  "charMC":null
               });
            }
         }
      }
      
      private function drawPlayerV2(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc6_:Character = null;
         var _loc3_:Object = ResourceManager.getResourceByID("mappings").getProp("metadata").match_results_screen;
         var _loc4_:Character = GameController.stageData.getPlayerByID(param1);
         var _loc5_:int = _loc4_.getMatchResults().Rank;
         var _loc7_:int = 1;
         _loc2_ = 1;
         while(_loc2_ <= GameController.stageData.Players.length && !GameController.stageData.NoContest)
         {
            _loc6_ = GameController.stageData.getPlayerByID(_loc2_);
            if(Boolean(_loc6_) && Boolean(_loc6_ != _loc4_) && _loc6_.getMatchResults().Rank < _loc5_)
            {
               _loc7_++;
            }
            _loc2_++;
         }
         _loc2_ = 1;
         while(_loc2_ <= GameController.stageData.Players.length)
         {
            _loc6_ = GameController.stageData.getPlayerByID(_loc2_);
            if(Boolean(_loc6_) && (Boolean(GameController.stageData.NoContest) || _loc6_.getMatchResults().Rank == _loc5_))
            {
               if(_loc6_ === _loc4_)
               {
                  break;
               }
               _loc7_++;
            }
            _loc2_++;
         }
         var _loc8_:MovieClip = m_subMenu["p" + param1 + "Results"] as MovieClip;
         var _loc9_:MovieClip = m_subMenu.playerContainer["p" + _loc7_ + "Pose"] as MovieClip;
         var _loc10_:String = _loc5_ == 1 && !GameController.stageData.NoContest ? "win" : "lose";
         var _loc11_:Object = GameController.stageData.NoContest ? _loc3_["no_contest_" + _loc7_] : (GameController.stageData.GameRef.LevelData.teams ? _loc3_["teammate_" + _loc7_] : _loc3_["rank_" + _loc7_]);
         _loc8_.charName.text = _loc4_.DisplayName;
         _loc8_.placeNum.text = GameController.stageData.NoContest ? "-" : _loc5_;
         var _loc12_:MovieClip = ResourceManager.getLibraryMC(_loc4_.LinkageName);
         var _loc13_:MovieClip = _loc8_["charAnim"].addChild(_loc12_);
         _loc13_.player_id = _loc4_.ID;
         _loc13_.gotoAndStop(_loc10_);
         _loc4_.updateColorFilter(_loc13_,_loc4_.Team,_loc4_.CostumeName,_loc4_.CostumeID);
         if(!GameController.stageData.NoContest && Boolean(GameController.stageData.GameRef.LevelData.teams) && _loc5_ !== 1 && !_loc3_.show_losing_team)
         {
            this.m_playerSymbols.push({
               "mc":_loc13_,
               "player":_loc4_,
               "shadow":null,
               "charMC":null
            });
            return;
         }
         var _loc14_:MovieClip = _loc9_.addChild(ResourceManager.getLibraryMC(_loc4_.LinkageName)) as MovieClip;
         _loc14_.player_id = _loc4_.ID;
         _loc14_.gotoAndStop(_loc10_);
         _loc4_.updateColorFilter(_loc14_,_loc4_.Team,_loc4_.CostumeName,_loc4_.CostumeID);
         var _loc15_:MovieClip = _loc9_.addChild(ResourceManager.getLibraryMC(_loc4_.LinkageName)) as MovieClip;
         _loc15_.player_id = _loc4_.ID;
         Utils.setColorFilter(_loc15_,{
            "brightness":-1000,
            "alphaMultiplier":0.25
         });
         _loc15_.transform.matrix.c = Math.tan(Utils.toRadians(30));
         _loc15_.gotoAndStop(_loc10_);
         this.m_playerSymbols.push({
            "mc":_loc13_,
            "player":_loc4_,
            "shadow":_loc15_,
            "charMC":_loc14_
         });
         _loc9_.x = _loc11_.x;
         _loc9_.y = _loc11_.y;
         _loc9_.scaleX = _loc11_.scaleX;
         _loc9_.scaleY = _loc11_.scaleY;
         _loc15_.scaleY = -0.3;
         if("visible" in _loc11_)
         {
            _loc9_.visible = _loc11_.visible;
         }
         if(_loc14_.stance)
         {
            Utils.removeActionScript(_loc14_.stance);
         }
         if(_loc15_.stance)
         {
            Utils.removeActionScript(_loc15_.stance);
         }
      }
      
      private function getTeamSlot(param1:int, param2:int) : int
      {
         var _loc4_:int = 0;
         var _loc3_:int = 1;
         while(_loc4_ < GameController.stageData.Players.length)
         {
            if(Boolean(GameController.stageData.getPlayerByID(_loc4_)) && Boolean(GameController.stageData.getPlayerByID(_loc4_).Team === param2) && GameController.stageData.getPlayerByID(_loc4_).ID === param1)
            {
               break;
            }
            if(Boolean(GameController.stageData.getPlayerByID(_loc4_)) && Boolean(GameController.stageData.getPlayerByID(_loc4_).Team === param2) && GameController.stageData.getPlayerByID(_loc4_).ID !== param1)
            {
               _loc3_++;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function displayMatchResults() : void
      {
         var _loc1_:String = null;
         var _loc2_:Number = NaN;
         var _loc3_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:MovieClip = null;
         var _loc4_:Game = GameController.stageData.GameRef;
         GameController.stageData.activateCharacters();
         SSF2API.init(GameController.stageData);
         ModAPI.init(GameController.stageData);
         SoundQueue.instance.stopMusic();
         m_subMenu.matchInfo.modeDetails.text = GameController.stageData.NoContest ? "NO CONTEST" : "VERSUS";
         Utils.fitText(m_subMenu.matchInfo.modeDetails,20);
         var _loc8_:String = "";
         if(ModeFeatures.hasFeature(ModeFeatures.IS_CUSTOM,GameController.stageData.GameRef.GameMode))
         {
            _loc8_ = GameController.stageData.GameRef.CustomModeObj.APIInstance.getSummary();
         }
         else
         {
            _loc8_ = _loc4_.UsingLives ? _loc4_.Lives + "-stock" : "Timed Match";
            _loc8_ += " / " + ResourceManager.getResourceByID("mappings").getProp("metadata").stage[_loc4_.LevelData.stage].name;
         }
         m_subMenu.matchInfo.matchDetails.text = _loc8_;
         if(!GameController.stageData.NoContest)
         {
            if(ModeFeatures.hasFeature(ModeFeatures.SAVE_RECORDS,_loc4_.GameMode))
            {
               this.saveRecords();
            }
            this.winnerIs = SoundQueue.instance.getSoundObject(SoundQueue.instance.playVoiceEffect("narrator_winner")).Channel;
            this.winnerIs.addEventListener(Event.SOUND_COMPLETE,this.sayWinner);
            _loc1_ = GameController.stageData.getFirstWinner().SoundData["winTheme"];
            if(ResourceManager.getLibrarySound(_loc1_) != null)
            {
               SoundQueue.instance.setNextMusic("battle_results",2140);
               SoundQueue.instance.setLoopFunction(SoundQueue.instance.nextMusic);
               SoundQueue.instance.playMusic(_loc1_,0);
            }
            else
            {
               SoundQueue.instance.stopMusic();
               SoundQueue.instance.playMusic("battle_results",2140);
            }
            _loc5_ = 1;
            while(_loc5_ <= GameController.stageData.Players.length)
            {
               this.populateMatchResults(_loc5_);
               _loc5_++;
            }
            _loc6_ = 1;
            if(GameController.stageData.getTeams().length == 1)
            {
               _loc6_ = 1;
               while(_loc6_ <= GameController.stageData.Players.length)
               {
                  if(GameController.stageData.getPlayerByID(_loc6_) != null)
                  {
                     trace("Place No. " + GameController.stageData.getPlayerByID(_loc6_).getMatchResults().Rank + " is player #" + _loc6_);
                     this.drawPlayer(_loc6_);
                  }
                  _loc6_++;
               }
            }
            else
            {
               _loc6_ = 1;
               while(_loc6_ <= GameController.stageData.Players.length)
               {
                  if(GameController.stageData.getPlayerByID(_loc6_) != null)
                  {
                     trace("Player #" + _loc6_ + " who is on Team " + GameController.stageData.getPlayerByID(_loc6_).Team + "is in Place No. " + GameController.stageData.getPlayerByID(_loc6_).getMatchResults().Rank);
                     this.drawPlayer(_loc6_);
                  }
                  _loc6_++;
               }
            }
         }
         else
         {
            m_subMenu.gotoAndPlay(Utils.hasLabel(m_subMenu,"noContest") ? "noContest" : "skip");
            if(m_subMenu["winnerText"])
            {
               m_subMenu["winnerText"].visible = false;
            }
            this.skipLevel = 1;
            _loc2_ = 1;
            while(_loc2_ <= GameController.stageData.Players.length)
            {
               this.populateMatchResults(_loc2_);
               _loc2_++;
            }
            SoundQueue.instance.playVoiceEffect("narrator_nocontest");
            _loc6_ = 1;
            while(_loc6_ <= GameController.stageData.Players.length)
            {
               if(GameController.stageData.getPlayerByID(_loc6_) != null)
               {
                  trace("Player #" + _loc6_ + " who is on Team " + GameController.stageData.getPlayerByID(_loc6_).Team + "is in Place No. " + GameController.stageData.getPlayerByID(_loc6_).getMatchResults().Rank);
                  this.drawPlayer(_loc6_);
               }
               _loc6_++;
            }
         }
         if(Boolean(GameController.stageData.OnlineMode) && Boolean(MultiplayerManager.Connected))
         {
            _loc3_ = GameController.stageData.getPlayerByID(MultiplayerManager.PlayerID).getPlayerSettings().exportSettings();
            _loc3_.results = GameController.stageData.getPlayerByID(MultiplayerManager.PlayerID).getMatchResults().exportData();
            MultiplayerManager.sendMatchFinishedSignal({"player_data":_loc3_});
         }
         this.updatePalettes();
      }
      
      public function populateMatchResults(param1:int) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:MovieClip = null;
         if(GameController.stageData.getPlayerByID(param1) != null)
         {
            _loc2_ = "KO List for player " + param1 + ": ";
            _loc3_ = 0;
            while(_loc3_ < GameController.stageData.getPlayerByID(param1).getMatchResults().KOList.length)
            {
               _loc2_ += GameController.stageData.getPlayerByID(param1).getMatchResults().KOList[_loc3_] + " ";
               _loc3_++;
            }
            trace(_loc2_);
            _loc2_ = "Killer List for player " + param1 + ": ";
            _loc4_ = 0;
            while(_loc4_ < GameController.stageData.getPlayerByID(param1).getMatchResults().KillerList.length)
            {
               _loc2_ += GameController.stageData.getPlayerByID(param1).getMatchResults().KillerList[_loc4_] + " ";
               _loc4_++;
            }
            trace(_loc2_);
            if(!m_subMenu["p" + param1 + "Results"])
            {
               return;
            }
            _loc5_ = m_subMenu["p" + param1 + "Results"] as MovieClip;
            if(!GameController.stageData.getPlayerByID(param1).IsHuman)
            {
               _loc5_.gotoAndStop("cpu");
            }
            else if(GameController.stageData.GameRef.LevelData.teams)
            {
               _loc5_.gotoAndStop("p" + Utils.convertTeamToColor(param1,GameController.stageData.getPlayerByID(param1).Team));
            }
            else
            {
               _loc5_.gotoAndStop("p" + param1);
            }
            _loc5_.playerNum.text = "P" + param1;
            _loc5_.score.text = GameController.stageData.getPlayerByID(param1).getMatchResults().Score >= 0 ? "+" + GameController.stageData.getPlayerByID(param1).getMatchResults().Score : GameController.stageData.getPlayerByID(param1).getMatchResults().Score;
            _loc5_.kos.text = GameController.stageData.getPlayerByID(param1).getMatchResults().KOs;
            _loc5_.falls.text = GameController.stageData.getPlayerByID(param1).getMatchResults().Falls;
            _loc5_.sds.text = GameController.stageData.getPlayerByID(param1).getMatchResults().SelfDestructs;
            _loc5_.dmgGiven.text = Math.floor(GameController.stageData.getPlayerByID(param1).getMatchResults().DamageGiven) + "%";
            _loc5_.dmgTaken.text = Math.floor(GameController.stageData.getPlayerByID(param1).getMatchResults().DamageTaken) + "%";
            _loc5_.pitch.text = Math.floor(GameController.stageData.getPlayerByID(param1).getMatchResults().FastestPitch) + "pps";
            _loc5_.speed.text = Math.floor(GameController.stageData.getPlayerByID(param1).getMatchResults().TopSpeed) + "pps";
            _loc5_.drought.text = Math.floor(GameController.stageData.getPlayerByID(param1).getMatchResults().LongestDrought / 30) + "s";
            _loc5_.visible = true;
         }
      }
   }
}


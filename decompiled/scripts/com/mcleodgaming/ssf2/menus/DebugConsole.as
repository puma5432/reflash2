package com.mcleodgaming.ssf2.menus
{
   import com.adobe.utils.*;
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.interfaces.*;
   import com.mcleodgaming.ssf2.items.*;
   import com.mcleodgaming.ssf2.net.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.events.*;
   import flash.system.*;
   import flash.text.TextField;
   import flash.utils.*;
   
   public class DebugConsole extends Menu implements IDebugConsole
   {
      
      public static var DISABLE_OFFSCREEN_BUBBLE:Boolean = false;
      
      public static var globalHash:Object = {};
      
      private var MAX_HISTORY:int = 25;
      
      private var m_enabled:Boolean;
      
      private var m_input:TextField;
      
      private var m_output:TextField;
      
      private var m_history:Array;
      
      private var m_historyIndex:int;
      
      private var m_commands:Array;
      
      private var m_function:Function;
      
      private var m_enterReleased:Boolean;
      
      private var m_upReleased:Boolean;
      
      private var m_downReleased:Boolean;
      
      private var m_controlsCapture:Boolean;
      
      private var m_onlineCapture:Boolean;
      
      private var m_pingCapture:Boolean;
      
      private var m_attackStateCapture:Boolean;
      
      private var m_disableKeyCapture:Boolean;
      
      private var m_knockbackCapture:Boolean;
      
      private var m_alerts:Boolean;
      
      public function DebugConsole()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("debug_console");
         this.m_input = m_subMenu.input;
         this.m_output = m_subMenu.output;
         this.m_output.text = "";
         this.m_historyIndex = 0;
         this.m_history = new Array("");
         this.m_commands = new Array();
         this.m_commands["clear"] = this.clear;
         this.m_commands["exit"] = this.exit;
         this.m_commands["close"] = this.exit;
         this.m_commands["alpha"] = this.alpha;
         this.m_commands["unfocus"] = this.unfocus;
         this.m_commands["capture"] = this.capture;
         this.m_commands["print"] = this.print;
         this.m_commands["generate"] = this.generate;
         this.m_commands["debug"] = this.debug;
         this.m_commands["config"] = this.config;
         this.m_commands["hack"] = this.hack;
         this.m_commands["encrypt"] = this.encrypt;
         this.m_commands["decrypt"] = this.decrypt;
         this.m_commands["bgmcheck"] = this.bgmcheck;
         m_container.addChild(m_subMenu);
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height;
         var _loc1_:Shape = new Shape();
         _loc1_.graphics.beginFill(251920232);
         _loc1_.graphics.drawRect(0,0,m_subMenu.width,m_subMenu.height);
         _loc1_.graphics.endFill();
         _loc1_.y = Main.Height - 140;
         m_container.addChild(_loc1_);
         m_subMenu.mask = _loc1_;
         this.m_enabled = false;
         this.m_enterReleased = true;
         this.m_upReleased = true;
         this.m_downReleased = true;
         this.m_alerts = false;
         this.m_controlsCapture = false;
         this.m_onlineCapture = false;
         this.m_pingCapture = false;
         this.m_disableKeyCapture = true;
         this.m_attackStateCapture = false;
         this.m_knockbackCapture = false;
         if(Main.DEBUG)
         {
            Main.Root.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.toggleDebugConsole);
         }
      }
      
      public function get ControlsCapture() : Boolean
      {
         return this.m_controlsCapture;
      }
      
      public function get DisableKeyCapture() : Boolean
      {
         return this.m_disableKeyCapture;
      }
      
      public function get OnlineCapture() : Boolean
      {
         return this.m_onlineCapture;
      }
      
      public function get PingCapture() : Boolean
      {
         return this.m_pingCapture;
      }
      
      public function get AttackStateCapture() : Boolean
      {
         return this.m_attackStateCapture;
      }
      
      public function get KnockbackCapture() : Boolean
      {
         return this.m_knockbackCapture;
      }
      
      public function get Alerts() : Boolean
      {
         return this.m_alerts;
      }
      
      public function set Alerts(param1:Boolean) : void
      {
         this.m_alerts = param1;
      }
      
      override public function makeEvents() : void
      {
         super.makeEvents();
         Main.Root.addEventListener(Event.ADDED,moveToFront);
         Main.Root.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.submitCommand);
         Main.Root.stage.addEventListener(KeyboardEvent.KEY_UP,this.resetKeys);
      }
      
      override public function show() : void
      {
         Main.setFocus(this.m_input);
         super.show();
         if(m_container.parent)
         {
            m_container.parent.setChildIndex(m_container,m_container.parent.numChildren - 1);
         }
         if(this.m_disableKeyCapture)
         {
            Key.endCapture();
         }
         this.m_historyIndex = 0;
         this.clearInput();
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         Main.Root.removeEventListener(Event.ADDED,moveToFront);
         Main.Root.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.submitCommand);
         Main.Root.stage.removeEventListener(KeyboardEvent.KEY_UP,this.resetKeys);
      }
      
      override public function removeSelf() : void
      {
         super.removeSelf();
         this.m_enterReleased = true;
         this.m_upReleased = true;
         this.m_downReleased = true;
         m_subMenu.alpha = 1;
         Main.fixFocus();
         if(this.m_disableKeyCapture)
         {
            Key.beginCapture(Main.Root.stage);
         }
      }
      
      public function forceShow() : void
      {
         if(!this.m_enabled)
         {
            this.show();
            this.m_enabled = true;
         }
      }
      
      private function toggleDebugConsole(param1:KeyboardEvent) : void
      {
         if(!Main.DEBUGAUTHED)
         {
            return;
         }
         if(param1.keyCode == 192)
         {
            if(this.m_enabled)
            {
               this.removeSelf();
               this.m_enabled = !this.m_enabled;
            }
            else if(Main.DEBUG)
            {
               this.show();
               this.m_enabled = !this.m_enabled;
            }
         }
      }
      
      private function resetKeys(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 13 && !this.m_enterReleased)
         {
            this.m_enterReleased = true;
         }
         if(param1.keyCode == 38 && !this.m_upReleased)
         {
            this.m_upReleased = true;
         }
         if(param1.keyCode == 40 && !this.m_downReleased)
         {
            this.m_downReleased = true;
         }
      }
      
      private function submitCommand(param1:KeyboardEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:String = null;
         if(param1.keyCode == 13 && Boolean(this.m_enterReleased))
         {
            this.m_enterReleased = false;
            _loc2_ = this.cleanString(this.m_input.text);
            if(_loc2_ == "")
            {
               this.writeLine("-No command entered");
            }
            else
            {
               this.m_history[0] = _loc2_;
               this.m_history.unshift("");
               if(this.m_history.length > this.MAX_HISTORY)
               {
                  this.m_history.pop();
               }
               _loc3_ = _loc2_.split(" ");
               _loc4_ = _loc3_[0].toLowerCase();
               _loc3_.splice(0,1);
               if(this.m_commands[_loc4_] != null)
               {
                  this.m_commands[_loc4_].apply(null,_loc3_);
               }
               else
               {
                  this.writeLine("Command \'" + _loc4_ + "\' not found");
               }
            }
            this.clearInput();
            this.m_historyIndex = 0;
         }
         else if(param1.keyCode == 38 && Boolean(this.m_upReleased))
         {
            if(this.m_history.length > 0 && this.m_historyIndex < this.m_history.length - 1)
            {
               ++this.m_historyIndex;
               this.m_input.text = this.m_history[this.m_historyIndex];
               this.cursorToEnd();
            }
         }
         else if(param1.keyCode == 40 && Boolean(this.m_downReleased))
         {
            if(this.m_history.length > 0 && this.m_historyIndex > 0)
            {
               --this.m_historyIndex;
               this.m_input.text = this.m_history[this.m_historyIndex];
               this.cursorToEnd();
            }
         }
      }
      
      private function writeLine(param1:String) : void
      {
         this.m_output.appendText(param1 + "\n");
         this.m_output.scrollV = this.m_output.numLines;
      }
      
      private function cleanString(param1:String) : String
      {
         while(param1.indexOf("  ") >= 0)
         {
            param1 = param1.replace("  "," ");
         }
         while(param1.indexOf("\n") >= 0)
         {
            param1 = param1.replace("\n","");
         }
         while(param1.indexOf("\r") >= 0)
         {
            param1 = param1.replace("\r","");
         }
         return StringUtil.trim(param1);
      }
      
      private function cursorToEnd() : void
      {
         this.m_input.setSelection(this.m_input.text.length,this.m_input.text.length);
      }
      
      private function clearInput() : void
      {
         this.m_input.text = "";
      }
      
      private function exit(... rest) : void
      {
         this.removeSelf();
         this.m_enabled = false;
      }
      
      private function clear(... rest) : void
      {
         this.m_output.text = "";
      }
      
      private function alpha(... rest) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Array = new Array();
         while(rest.length > 0 && rest[0].charAt(0) == "-")
         {
            _loc3_.push(rest[0]);
            rest.splice(0,1);
         }
         var _loc4_:String = "Error, alpha expects args [0-1.0]";
         if(rest.length == 0)
         {
            this.writeLine(_loc4_);
         }
         else if(isNaN(parseFloat(rest[0])))
         {
            this.writeLine(_loc4_);
         }
         else
         {
            _loc2_ = Number(parseFloat(rest[0]));
            _loc2_ = Math.min(_loc2_,1);
            _loc2_ = Math.max(_loc2_,0);
            this.writeLine("alpha set to " + _loc2_);
            m_subMenu.alpha = _loc2_;
         }
      }
      
      private function unfocus(... rest) : void
      {
         Main.fixFocus();
      }
      
      private function capture(... rest) : void
      {
         var _loc2_:Array = new Array();
         while(rest.length > 0 && rest[0].charAt(0) == "-")
         {
            _loc2_.push(rest[0]);
            rest.splice(0,1);
         }
         var _loc3_:String = "Error, capture expects args [controls | keyboard | online | attack | ping]";
         if(rest.length == 0)
         {
            this.writeLine(_loc3_);
         }
         else if(/^controls$/i.test(rest[0]))
         {
            if(this.m_controlsCapture)
            {
               this.m_controlsCapture = false;
               this.writeLine("controls capture stopped");
            }
            else
            {
               if(Boolean(GameController.stageData) && Boolean(GameController.stageData.getPlayerByID(1)))
               {
                  GameController.stageData.getPlayerByID(1).clearAttackControlsArr();
               }
               this.m_controlsCapture = true;
               this.writeLine("controls capture started for player 1");
            }
         }
         else if(/^online$/i.test(rest[0]))
         {
            if(this.m_onlineCapture)
            {
               this.m_onlineCapture = false;
               this.writeLine("online capture stopped");
            }
            else
            {
               this.m_onlineCapture = true;
               this.writeLine("online capture started");
            }
         }
         else if(/^ping$/i.test(rest[0]))
         {
            if(this.m_pingCapture)
            {
               this.m_pingCapture = false;
               this.writeLine("ping capture stopped");
            }
            else
            {
               this.m_pingCapture = true;
               this.writeLine("ping capture started");
            }
         }
         else if(/^keyboard$/i.test(rest[0]))
         {
            this.m_disableKeyCapture = Key.CaptureStarted;
            if(this.m_disableKeyCapture)
            {
               this.writeLine("key capture blocked.");
               Key.endCapture();
            }
            else
            {
               this.writeLine("key capture unblocked.");
               Key.beginCapture(Main.Root.stage);
            }
         }
         else if(/^attack$/i.test(rest[0]))
         {
            this.m_attackStateCapture = !this.m_attackStateCapture;
            if(this.m_attackStateCapture)
            {
               this.writeLine("attack capture started");
            }
            else
            {
               this.writeLine("attack capture ended");
            }
         }
         else if(/^knockback$/i.test(rest[0]))
         {
            this.m_knockbackCapture = !this.m_knockbackCapture;
            if(this.m_knockbackCapture)
            {
               this.writeLine("knockback capture started");
            }
            else
            {
               this.writeLine("knockback capture ended");
            }
         }
         else
         {
            this.writeLine(_loc3_);
         }
      }
      
      private function generate(... rest) : void
      {
         var _loc2_:ItemData = null;
         var _loc3_:int = 0;
         var _loc4_:Item = null;
         var _loc5_:Array = new Array();
         while(rest.length > 0 && rest[0].charAt(0) == "-")
         {
            _loc5_.push(rest[0]);
            rest.splice(0,1);
         }
         var _loc6_:String = "Error, generate expects args [assist | item | pokemon]";
         if(rest.length == 0)
         {
            this.writeLine(_loc6_);
         }
         else if(!GameController.stageData || Boolean(GameController.stageData.GameEnded))
         {
            this.writeLine("Error, no game detected for generate command");
         }
         else if(/^assist$/i.test(rest[0]))
         {
            if(rest.length <= 1 || Boolean(isNaN(parseInt(rest[1]))))
            {
               this.writeLine("Errror parsing assist ID ##");
            }
            else
            {
               rest[1] = Math.max(0,parseInt(rest[1]));
               _loc4_ = GameController.stageData.ItemsRef.generateItemObj(GameController.stageData.ItemsRef.getItemByLinkage("assistTrophy"));
               if(_loc4_)
               {
                  if(_loc5_.indexOf("-rare") >= 0)
                  {
                     GameController.stageData.ItemsRef.AssistClass = GameController.stageData.AssistsRare[Math.min(GameController.stageData.AssistsRare.length - 1,rest[1])];
                  }
                  else
                  {
                     GameController.stageData.ItemsRef.AssistClass = GameController.stageData.Assists[Math.min(GameController.stageData.Assists.length - 1,rest[1])];
                  }
                  _loc4_.X = GameController.stageData.getPlayerByID(1).X + (GameController.stageData.getPlayerByID(1).FacingForward ? 8 : -8);
                  _loc4_.Y = GameController.stageData.getPlayerByID(1).Y - GameController.stageData.getPlayerByID(1).Height;
                  this.writeLine("Generated assist ID#" + rest[1] + " @ (x:" + _loc4_.X + ", y:" + _loc4_.Y + ")");
               }
               else
               {
                  this.writeLine("Error, failed to assist ID#" + rest[1]);
               }
            }
         }
         else if(/^item$/i.test(rest[0]))
         {
            if(rest.length <= 1 || Boolean(isNaN(parseInt(rest[1]))))
            {
               this.writeLine("Errror parsing item ID ##");
            }
            else
            {
               rest[1] = Math.max(0,parseInt(rest[1]));
               _loc2_ = new ItemData();
               _loc2_.importData(ItemsListData.DATA[Math.min(ItemsListData.DATA.length - 1,rest[1])]);
               _loc4_ = GameController.stageData.ItemsRef.generateItemObj(_loc2_);
               if(_loc4_)
               {
                  if(GameController.stageData.getPlayerByID(1))
                  {
                     _loc4_.X = GameController.stageData.getPlayerByID(1).X + (GameController.stageData.getPlayerByID(1).FacingForward ? 8 : -8);
                     _loc4_.Y = GameController.stageData.getPlayerByID(1).Y - GameController.stageData.getPlayerByID(1).Height;
                  }
                  this.writeLine("Generated item ID#" + rest[1] + " @ (x:" + _loc4_.X + ", y:" + _loc4_.Y + ")");
               }
               else
               {
                  this.writeLine("Error, failed to item ID#" + rest[1]);
               }
            }
         }
         else if(/^pokemon$/i.test(rest[0]))
         {
            if(rest.length <= 1 || Boolean(isNaN(parseInt(rest[1]))))
            {
               this.writeLine("Errror parsing pokemon ID ##");
            }
            else
            {
               rest[1] = Math.max(0,parseInt(rest[1]));
               _loc4_ = GameController.stageData.ItemsRef.generateItemObj(GameController.stageData.ItemsRef.getItemByLinkage(_loc5_.indexOf("-rare") >= 0 ? "masterball" : "pokeball"));
               if(_loc4_)
               {
                  if(_loc5_.indexOf("-rare") >= 0)
                  {
                     GameController.stageData.ItemsRef.PokemonClass = GameController.stageData.PokemonsRare[Math.min(GameController.stageData.PokemonsRare.length - 1,rest[1])];
                  }
                  else
                  {
                     GameController.stageData.ItemsRef.PokemonClass = GameController.stageData.Pokemons[Math.min(GameController.stageData.Pokemons.length - 1,rest[1])];
                  }
                  _loc4_.X = GameController.stageData.getPlayerByID(1).X + (GameController.stageData.getPlayerByID(1).FacingForward ? 8 : -8);
                  _loc4_.Y = GameController.stageData.getPlayerByID(1).Y - GameController.stageData.getPlayerByID(1).Height;
                  this.writeLine("Generated pokemon ID#" + rest[1] + " @ (x:" + _loc4_.X + ", y:" + _loc4_.Y + ")");
               }
               else
               {
                  this.writeLine("Error, failed to pokemon ID#" + rest[1]);
               }
            }
         }
         else
         {
            this.writeLine(_loc6_);
         }
      }
      
      private function print(... rest) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Array = new Array();
         while(rest.length > 0 && rest[0].charAt(0) == "-")
         {
            _loc7_.push(rest[0]);
            rest.splice(0,1);
         }
         var _loc8_:String = "Error, print expects flags [-assist | -item | -online | -pokemon | -version | -ping | -dat | -events]";
         if(_loc7_.length == 0)
         {
            this.writeLine(_loc8_);
         }
         else
         {
            if(_loc7_[0] == "-assist")
            {
               this.writeLine("[See assist Main.as]");
            }
            if(_loc7_[0] == "-item")
            {
               this.writeLine("[Items]");
               _loc2_ = 0;
               while(_loc2_ < ItemsListData.DATA.length)
               {
                  _loc3_ = ItemsListData.DATA[_loc2_].displayName;
                  this.writeLine(_loc2_ + " - " + _loc3_);
                  _loc2_++;
               }
            }
            if(_loc7_.indexOf("-online") >= 0)
            {
               if(!GameController.stageData)
               {
                  this.writeLine("Error, no match detected");
               }
               else if(!GameController.stageData.LogText)
               {
                  this.writeLine("Log data is empty. Must enable capture via \'capture online\' command and start a match.");
               }
               else
               {
                  this.writeLine("[BEGIN LOG]");
                  this.writeLine(GameController.stageData.LogText);
                  this.writeLine("[END LOG]");
               }
            }
            if(_loc7_.indexOf("-pokemon") >= 0)
            {
               this.writeLine("[See pokemon Main.as");
            }
            if(_loc7_.indexOf("-version") >= 0)
            {
               this.writeLine("SSF2 Version: " + Version.Major + "." + Version.Minor + "." + Version.Build + "." + Version.Revision);
               this.writeLine("ActionScript Version: " + Main.Root.loaderInfo.actionScriptVersion);
               this.writeLine("SWF Version: " + Main.Root.loaderInfo.swfVersion);
            }
            if(_loc7_.indexOf("-ping") >= 0)
            {
               this.writeLine("Current Average Ping: " + MultiplayerManager.Ping + " ms");
            }
            if(_loc7_.indexOf("-dat") >= 0)
            {
               this.writeDatScript();
            }
            if(_loc7_.indexOf("-datrenamer") >= 0)
            {
               this.writeDatRenamer();
            }
            if(_loc7_[0] == "-events")
            {
               if(GameController.stageData)
               {
                  _loc4_ = [];
                  _loc5_ = 0;
                  _loc6_ = 0;
                  while(_loc6_ < GameController.stageData.Players.length)
                  {
                     if(GameController.stageData.Players[_loc6_] != null)
                     {
                        _loc4_.push("P" + GameController.stageData.Players[_loc6_].ID + ": " + GameController.stageData.Players[_loc6_].EventManagerObj.Count);
                        _loc5_ += GameController.stageData.Players[_loc6_].EventManagerObj.Count;
                     }
                     _loc6_++;
                  }
                  this.writeLine("Player events: " + _loc5_ + " (" + _loc4_.join(", ") + ")");
                  _loc5_ = 0;
                  _loc6_ = 0;
                  while(_loc6_ < GameController.stageData.Projectiles.length)
                  {
                     _loc5_ += GameController.stageData.Projectiles[_loc6_].EventManagerObj.Count;
                     _loc6_++;
                  }
                  this.writeLine("Projectile events: " + _loc5_);
                  _loc5_ = 0;
                  _loc6_ = 0;
                  while(_loc6_ < GameController.stageData.Enemies.length)
                  {
                     _loc5_ += GameController.stageData.Enemies[_loc6_].EventManagerObj.Count;
                     _loc6_++;
                  }
                  this.writeLine("Enemy events: " + _loc5_);
                  _loc5_ = 0;
                  _loc6_ = 0;
                  while(_loc6_ < GameController.stageData.ItemsRef.ItemsInUse.length)
                  {
                     if(GameController.stageData.ItemsRef.ItemsInUse[_loc6_])
                     {
                        _loc5_ += GameController.stageData.ItemsRef.ItemsInUse[_loc6_].EventManagerObj.Count;
                     }
                     _loc6_++;
                  }
                  this.writeLine("Item events: " + _loc5_);
                  this.writeLine("Match events: " + GameController.stageData.EventManagerObj.Count);
               }
               else
               {
                  this.writeLine("Cannot print events, no game is active");
               }
            }
         }
      }
      
      private function debug(... rest) : void
      {
         var _loc2_:Array = new Array();
         while(rest.length > 0 && rest[0].charAt(0) == "-")
         {
            _loc2_.push(rest[0]);
            rest.splice(0,1);
         }
         var _loc3_:String = "Error, debug expects args [off]";
         if(rest.length == 0)
         {
            this.writeLine(_loc3_);
         }
         else if(/^off$/i.test(rest[0]))
         {
            this.writeLine("Debug mode has been disabled.");
            Main.turnOffDebug();
         }
         else
         {
            this.writeLine(_loc3_);
         }
      }
      
      private function config(... rest) : void
      {
         var _loc2_:Array = new Array();
         while(rest.length > 0 && rest[0].charAt(0) == "-")
         {
            _loc2_.push(rest[0]);
            rest.splice(0,1);
         }
         var _loc3_:String = "Error, config expects args [alerts | fps | airDodge | global | flushcache]";
         if(rest.length == 0)
         {
            this.writeLine(_loc3_);
         }
         else if(/^airDodge$/i.test(rest[0]))
         {
            if(rest.length <= 1)
            {
               this.writeLine("Error parsing config airDodge value (Expects [brawl | melee | ultimate | solo | double | vsolo | vdouble ])");
            }
            else if(!GameController.stageData)
            {
               this.writeLine("Error, match must be initialized to change config airDodge value");
            }
            else if(/^brawl$/i.test(rest[1]))
            {
               GameController.stageData.AirDodge = "brawl";
               this.writeLine("Brawl air dodging has been enabled");
            }
            else if(/^melee$/i.test(rest[1]))
            {
               GameController.stageData.AirDodge = "melee";
               this.writeLine("Melee air dodging has been enabled");
            }
            else if(/^ultimate$/i.test(rest[1]))
            {
               GameController.stageData.AirDodge = "ultimate";
               this.writeLine("Ultimate air dodging has been enabled");
            }
            else if(/^solo$/i.test(rest[1]))
            {
               GameController.stageData.AirDodge = "solo";
               this.writeLine("Ultimate air dodging + Solo Wavedash has been enabled");
            }
            else if(/^double$/i.test(rest[1]))
            {
               GameController.stageData.AirDodge = "double";
               this.writeLine("Ultimate air dodging + Double Wavedash has been enabled");
            }
            else if(/^vsolo$/i.test(rest[1]))
            {
               GameController.stageData.AirDodge = "vsolo";
               this.writeLine("Ultimate air dodging + Variable Solo Wavedash has been enabled");
            }
            else if(/^vdouble$/i.test(rest[1]))
            {
               GameController.stageData.AirDodge = "vdouble";
               this.writeLine("Ultimate air dodging + Variable Double Wavedash has been enabled");
            }
            else
            {
               this.writeLine("Error, invalid config airDodge value provided (Expects [brawl | melee | ultimate | solo | double | vsolo | vdouble])");
            }
         }
         else if(/^fps$/i.test(rest[0]))
         {
            if(rest.length <= 1)
            {
               this.writeLine("Error parsing config fps value (Expects [1-120])");
            }
            else if(rest.length <= 1 || Boolean(isNaN(parseInt(rest[1]))))
            {
               this.writeLine("Error, invalid config fps value provided (Expects [1-120])");
            }
            else
            {
               rest[1] = Math.max(0,parseInt(rest[1]));
               if(rest[1] < 1 || rest[1] > 120)
               {
                  this.writeLine("Error, invalid config fps value provided (Expects [1-120])");
               }
               else
               {
                  this.writeLine("Game FPS has been set to " + rest[1]);
                  Main.Root.stage.frameRate = rest[1];
               }
            }
         }
         else if(/^alerts$/i.test(rest[0]))
         {
            if(rest.length <= 1)
            {
               this.writeLine("Error parsing config alerts value (Expects [true | false])");
            }
            else if(/^true$/i.test(rest[1]))
            {
               this.m_alerts = true;
               this.writeLine("Alerts have been enabled");
            }
            else if(/^false$/i.test(rest[1]))
            {
               this.m_alerts = false;
               this.writeLine("Alerts have been disabled");
            }
            else
            {
               this.writeLine("Error, invalid config alerts value provided (Expects [true | false])");
            }
         }
         else if(/^global$/i.test(rest[0]))
         {
            if(rest.length <= 1)
            {
               this.writeLine("Error parsing config global var name (Expects {varname}))");
            }
            else if(rest.length <= 2)
            {
               this.writeLine("Retrieved config global var: " + rest[1] + " = " + DebugConsole.globalHash[rest[1]]);
            }
            else
            {
               if(/^true$/i.test(rest[2]) || /^false$/i.test(rest[2]))
               {
                  DebugConsole.globalHash[rest[1]] = /^true$/i.test(rest[2]);
               }
               else if(!isNaN(parseFloat(rest[2])))
               {
                  DebugConsole.globalHash[rest[1]] = parseFloat(rest[2]) === parseInt(rest[2]) ? parseFloat(rest[2]) : parseInt(rest[2]);
               }
               else
               {
                  DebugConsole.globalHash[rest[1]] = rest[2].match(/^"(.*?)"$/) ? rest[2].replace(/^"(.*?)"$/,"$1") : rest[2];
               }
               this.writeLine("Assigned config global var: " + rest[1] + " = " + DebugConsole.globalHash[rest[1]]);
            }
         }
         else if(/^flushcache$/i.test(rest[0]))
         {
            ResourceManager.flushUnusedResources();
            HitBoxManager.clearCache();
            this.writeLine("All resources that are not required and not currently in the loading queue have been unloaded, and hitbox cache has been cleared. Garbage collection has been requested.");
            System.gc();
         }
         else
         {
            this.writeLine(_loc3_);
         }
      }
      
      private function encrypt(... rest) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:Character = null;
         var _loc6_:Array = new Array();
         while(rest.length > 0 && rest[0].charAt(0) == "-")
         {
            _loc6_.push(rest[0]);
            rest.splice(0,1);
         }
         var _loc7_:String = "Error, encrypt expects a single solid string (no spaces) followed by an encryption key (no spaces) . (e.g. encrypt mytext mykey)";
         if(rest.length == 0)
         {
            this.writeLine(_loc7_);
         }
         else if(rest.length == 1 || rest.length > 2)
         {
            this.writeLine("Error, encrypt expects an encryption key to follow the text to encrypt (no spaces)");
         }
         else
         {
            this.writeLine("Key: " + rest[1]);
            this.writeLine("Input: " + rest[0]);
            this.writeLine("Encypted text:");
            this.writeLine(Utils.e(rest[0],rest[1]));
         }
      }
      
      private function decrypt(... rest) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:Character = null;
         var _loc6_:Array = new Array();
         while(rest.length > 0 && rest[0].charAt(0) == "-")
         {
            _loc6_.push(rest[0]);
            rest.splice(0,1);
         }
         var _loc7_:String = "Error, decrypt expects a single solid string (no spaces) followed by a decryption key (no spaces). (e.g. decrypt mytext mykey)";
         if(rest.length == 0)
         {
            this.writeLine(_loc7_);
         }
         else if(rest.length == 1 || rest.length > 2)
         {
            this.writeLine("Error, decrypt expects a decryption key to follow the text to decrypt (no spaces)");
         }
         else
         {
            this.writeLine("Key: " + rest[1]);
            this.writeLine("Input: " + rest[0]);
            this.writeLine("Decypted text:");
            this.writeLine(Utils.d(rest[0],rest[1]));
         }
      }
      
      private function bgmcheck(... rest) : void
      {
         var all:Boolean;
         var manifest:Object;
         var extendedMetaData:Object;
         var music:Vector.<Resource>;
         var j:int = 0;
         var k:int = 0;
         var stages:Vector.<Resource> = null;
         var res:Resource = null;
         var args:Array = rest;
         var i:* = undefined;
         j = 0;
         k = 0;
         var flags:Array = new Array();
         while(args.length > 0 && args[0].charAt(0) == "-")
         {
            flags.push(args[0]);
            args.splice(0,1);
         }
         if(flags.length != 1 || !(flags.indexOf("-public") >= 0 || flags.indexOf("-all") >= 0))
         {
            this.writeLine("Error, bgmcheck expects single flag -public or -all");
            return;
         }
         all = flags.indexOf("-all") >= 0;
         manifest = Utils.cloneObject(ResourceManager.manifestJSONData);
         extendedMetaData = Utils.cloneObject(ResourceManager.getResourceByID("mappings").getProp("metadata_dev"));
         stages = new Vector.<Resource>();
         music = new Vector.<Resource>();
         for(i in manifest.stage)
         {
            if(!(i in extendedMetaData.stage))
            {
               res = ResourceManager.getResourceByID(i);
               if(res)
               {
                  if(res.Type === Resource.STAGE)
                  {
                     if(!res.ID)
                     {
                        this.writeLine("Warning: bgmcheck stage resource \'" + i + "\' does not have valid resource id");
                     }
                     else if(!res.FileName)
                     {
                        this.writeLine("Warning: bgmcheck stage resource \'" + i + "\' does not have valid file name");
                     }
                     else
                     {
                        stages.push(res);
                        ResourceManager.queueResources([res.ID]);
                     }
                  }
               }
               else
               {
                  this.writeLine("Warning: bgmcheck could not find stage id: " + i);
               }
            }
         }
         for(i in manifest.music)
         {
            if(!(i in extendedMetaData.music))
            {
               res = ResourceManager.getResourceByID(i);
               if(res)
               {
                  if(res.Type === Resource.MUSIC)
                  {
                     if(!res.ID)
                     {
                        this.writeLine("Warning: bgmcheck music resource \'" + i + "\' does not have valid resource id");
                     }
                     else if(!res.FileName)
                     {
                        this.writeLine("Warning: bgmcheck music resource \'" + i + "\' does not have valid file name");
                     }
                     else
                     {
                        music.push(res);
                     }
                  }
               }
               else
               {
                  this.writeLine("Warning: bgmcheck could not find music id: " + i);
               }
            }
         }
         if(flags.indexOf("-all") >= 0)
         {
            this.writeLine("Checking all mappings for missing bgms...");
            for(i in extendedMetaData.stage)
            {
               res = ResourceManager.getResourceByID(i);
               if(res)
               {
                  if(res.Type === Resource.STAGE)
                  {
                     if(!res.ID)
                     {
                        this.writeLine("Warning: bgmcheck stage resource \'" + i + "\' does not have valid resource id");
                     }
                     else if(!res.FileName)
                     {
                        this.writeLine("Warning: bgmcheck stage resource \'" + i + "\' does not have valid resource id");
                     }
                     else
                     {
                        stages.push(res);
                        ResourceManager.queueResources([res.ID]);
                     }
                  }
               }
               else
               {
                  this.writeLine("Warning: bgmcheck could not find stage id: " + i);
               }
            }
            for(i in extendedMetaData.music)
            {
               res = ResourceManager.getResourceByID(i);
               if(res)
               {
                  if(res.Type === Resource.MUSIC)
                  {
                     if(!res.ID)
                     {
                        this.writeLine("Warning: bgmcheck music resource \'" + i + "\' does not have valid resource id");
                     }
                     else if(!res.FileName)
                     {
                        this.writeLine("Warning: bgmcheck music resource \'" + i + "\' does not have valid resource id");
                     }
                     else
                     {
                        music.push(res);
                     }
                  }
               }
               else
               {
                  this.writeLine("Warning: music could not find stage id: " + i);
               }
            }
         }
         else
         {
            this.writeLine("Checking public mappings for missing bgms...");
         }
         ResourceManager.DISABLE_MUSIC_AUTO_LOAD = true;
         ResourceManager.load({
            "oncomplete":function():void
            {
               var _loc1_:* = undefined;
               var _loc2_:* = undefined;
               ResourceManager.DISABLE_MUSIC_AUTO_LOAD = false;
               writeLine("All stages have been loaded, checking for bgm id inconsistencies w/ mappings...");
               j = 0;
               while(j < stages.length)
               {
                  _loc1_ = stages[j];
                  _loc2_ = _loc1_.getProp("music") ? _loc1_.getProp("music") : [];
                  if(_loc2_.length <= 0)
                  {
                     writeLine("Warning: No music tracks listed in stage \'" + _loc1_.ID + "\'");
                  }
                  else
                  {
                     k = 0;
                     while(k < _loc2_.length)
                     {
                        if(!ResourceManager.getResourceByID(_loc2_[k].id))
                        {
                           writeLine("Warning: Track \'" + _loc2_[k].id + "\' for stage \'" + _loc1_.ID + "\' was not found in mappings");
                        }
                        ++k;
                     }
                  }
                  ++j;
               }
               writeLine("bgmcheck completed");
            },
            "onerror":function():void
            {
               writeLine("Error loading the following stages:");
               j = 0;
               while(j < stages.length)
               {
                  if(stages[j].HasError)
                  {
                     writeLine(stages[j].CurrentFileName);
                  }
                  ++j;
               }
            }
         });
      }
      
      private function hack(... rest) : void
      {
         var error:String;
         var date:Date = null;
         var year:String = null;
         var month:String = null;
         var day:String = null;
         var replayData:ByteArray = null;
         var replayTimer:Timer = null;
         var replayFunc:Function = null;
         var events:Array = null;
         var chargeValue:Number = NaN;
         var i:int = 0;
         var success:Boolean = false;
         var character:Character = null;
         var args:Array = rest;
         var j:* = undefined;
         var flags:Array = new Array();
         while(args.length > 0 && args[0].charAt(0) == "-")
         {
            flags.push(args[0]);
            args.splice(0,1);
         }
         error = "Error, hack expects args [fstimer | special | replay | unlocks | collisions | hud | bubble | camera | fsmeter]";
         if(args.length == 0)
         {
            this.writeLine(error);
         }
         else if(/^fstimer$/i.test(args[0]))
         {
            if(args.length <= 1)
            {
               this.writeLine("Error parsing hack fstimer value (Expects [##])");
            }
            else if(!GameController.stageData)
            {
               this.writeLine("Error, match must be initialized to change hack fstimer value");
            }
            else if(args.length <= 1 || Boolean(isNaN(parseInt(args[1]))))
            {
               this.writeLine("Error, invalid hack fstimer value provided (Expects [##])");
            }
            else
            {
               success = false;
               args[1] = Math.max(0,parseInt(args[1]));
               i = 0;
               while(i < GameController.stageData.Players.length)
               {
                  character = GameController.stageData.Players[i];
                  if(Boolean(character) && character.TransformedSpecial)
                  {
                     character.transformTimerExtend(args[1]);
                     success = true;
                  }
                  i += 1;
               }
               this.writeLine(success ? "Characters have been granted an additional " + args[1] + " frame(s) of final form time" : "Error, no character is currently in final form");
            }
         }
         else if(/^special$/i.test(args[0]))
         {
            if(args.length <= 1)
            {
               this.writeLine("Error, hack special value (Expects [mini, mega, slow, lightning, vampire, vengeance, freeze, egg, dramatic, turbo, light, heavy, invisible, metal, ssf1])");
            }
            else if(args.length <= 2 || args[2] != "off" && args[2] != "on")
            {
               this.writeLine("Error reading command for hack special " + args[1] + " (Expects [ on | off ]");
            }
            else if(!GameController.currentGame)
            {
               this.writeLine("Error, could not run hack special, no game setup has be initiated.");
            }
            else
            {
               switch(args[1])
               {
                  case "mini":
                     GameController.currentGame.LevelData.specialModes = SpecialMode.setModeEnabled(GameController.currentGame.LevelData.specialModes,SpecialMode.MINI,/^on$/i.test(args[2]));
                     break;
                  case "mega":
                     GameController.currentGame.LevelData.specialModes = SpecialMode.setModeEnabled(GameController.currentGame.LevelData.specialModes,SpecialMode.MEGA,/^on$/i.test(args[2]));
                     break;
                  case "slow":
                     GameController.currentGame.LevelData.specialModes = SpecialMode.setModeEnabled(GameController.currentGame.LevelData.specialModes,SpecialMode.SLOW,/^on$/i.test(args[2]));
                     break;
                  case "lightning":
                     GameController.currentGame.LevelData.specialModes = SpecialMode.setModeEnabled(GameController.currentGame.LevelData.specialModes,SpecialMode.LIGHTNING,/^on$/i.test(args[2]));
                     break;
                  case "vampire":
                     GameController.currentGame.LevelData.specialModes = SpecialMode.setModeEnabled(GameController.currentGame.LevelData.specialModes,SpecialMode.VAMPIRE,/^on$/i.test(args[2]));
                     break;
                  case "vengeance":
                     GameController.currentGame.LevelData.specialModes = SpecialMode.setModeEnabled(GameController.currentGame.LevelData.specialModes,SpecialMode.VENGEANCE,/^on$/i.test(args[2]));
                     break;
                  case "freeze":
                     GameController.currentGame.LevelData.specialModes = SpecialMode.setModeEnabled(GameController.currentGame.LevelData.specialModes,SpecialMode.FREEZE,/^on$/i.test(args[2]));
                     break;
                  case "egg":
                     GameController.currentGame.LevelData.specialModes = SpecialMode.setModeEnabled(GameController.currentGame.LevelData.specialModes,SpecialMode.EGG,/^on$/i.test(args[2]));
                     break;
                  case "dramatic":
                     GameController.currentGame.LevelData.specialModes = SpecialMode.setModeEnabled(GameController.currentGame.LevelData.specialModes,SpecialMode.DRAMATIC,/^on$/i.test(args[2]));
                     break;
                  case "turbo":
                     GameController.currentGame.LevelData.specialModes = SpecialMode.setModeEnabled(GameController.currentGame.LevelData.specialModes,SpecialMode.TURBO,/^on$/i.test(args[2]));
                     break;
                  case "invisible":
                     GameController.currentGame.LevelData.specialModes = SpecialMode.setModeEnabled(GameController.currentGame.LevelData.specialModes,SpecialMode.INVISIBLE,/^on$/i.test(args[2]));
                     break;
                  case "light":
                     GameController.currentGame.LevelData.specialModes = SpecialMode.setModeEnabled(GameController.currentGame.LevelData.specialModes,SpecialMode.LIGHT,/^on$/i.test(args[2]));
                     break;
                  case "heavy":
                     GameController.currentGame.LevelData.specialModes = SpecialMode.setModeEnabled(GameController.currentGame.LevelData.specialModes,SpecialMode.HEAVY,/^on$/i.test(args[2]));
                     break;
                  case "ssf1":
                     GameController.currentGame.LevelData.specialModes = SpecialMode.setModeEnabled(GameController.currentGame.LevelData.specialModes,SpecialMode.SSF1,/^on$/i.test(args[2]));
                     break;
                  default:
                     this.writeLine("Error parsing hack special flag (Expects [mini, mega, slow, lightning, vampire, vengeance, freeze, egg, dramatic, turbo, light, heavy, invisible, metal, ssf1]");
                     return;
               }
               this.writeLine("Hacked special flag " + args[1] + " to \"" + args[2] + "\"");
            }
         }
         else if(/^replay$/i.test(args[0]))
         {
            if(args.length <= 1)
            {
               this.writeLine("Error, hack replay value (Expects [save | load])");
            }
            else if(/^save$/i.test(args[1]))
            {
               if(!GameController.stageData)
               {
                  this.writeLine("Error, cannot save replay unless a match has been started.");
               }
               else
               {
                  date = new Date();
                  year = "" + date.getFullYear();
                  month = date.getMonth() < 9 ? "0" + (date.getMonth() + 1) : "" + (date.getMonth() + 1);
                  day = date.getDate() < 9 ? "0" + (date.getDate() + 1) : "" + (date.getDate() + 1);
                  replayData = new ByteArray();
                  replayData.writeUTF(GameController.stageData.ReplayDataObj.exportReplay());
                  replayData.compress();
                  Utils.saveFile(replayData,GameController.stageData.ReplayDataObj.Name + "." + year + "-" + month + "-" + day + ".v" + Version.getVersion() + ".ssfrec");
               }
            }
            else if(/^load$/i.test(args[1]))
            {
               if(Boolean(GameController.stageData) && !GameController.stageData.GameEnded)
               {
                  this.writeLine("Error, cannot load replay mid-match.");
               }
               else
               {
                  this.writeLine("Choose a replay file load");
                  Utils.openFile("SSF2 Replay File (*.ssfrec)","*.ssfrec");
                  replayTimer = new Timer(20);
                  replayFunc = function(param1:TimerEvent):void
                  {
                     var _loc2_:ByteArray = null;
                     var _loc3_:ReplayData = null;
                     var _loc4_:uint = 0;
                     if(Utils.finishedLoading)
                     {
                        replayTimer.removeEventListener(TimerEvent.TIMER,replayFunc);
                        replayTimer.stop();
                        if(Utils.openSuccess)
                        {
                           _loc2_ = Utils.fileRef.data;
                           _loc2_.uncompress();
                           _loc3_ = new ReplayData(Main.MAXPLAYERS);
                           _loc3_.importReplay(_loc2_.readUTF());
                           if(_loc3_.VersionNumber != Version.getVersion() && ReplayData.COMPATIBLE_VERSIONS.indexOf(_loc3_.VersionNumber) < 0)
                           {
                              writeLine("Error, incompatible version number. Received version\t" + _loc3_.VersionNumber + " (Expecting " + Version.getVersion() + ")");
                           }
                           else
                           {
                              writeLine(_loc3_.exportReplay());
                              _loc4_ = uint(_loc3_.GameMode);
                              switch(_loc4_)
                              {
                                 case Mode.ONLINE:
                                    _loc4_ = uint(Mode.VS);
                                    break;
                                 case Mode.ONLINE_ARENA:
                                    _loc4_ = uint(Mode.ARENA);
                              }
                              GameController.currentGame = new Game(Main.MAXPLAYERS,_loc4_);
                              GameController.currentGame.ReplayDataObj = _loc3_;
                              MenuController.removeAllMenus();
                              MenuController.CurrentCharacterSelectMenu.initReplay();
                           }
                        }
                        else
                        {
                           writeLine("Error, there was a problem loading the replay file");
                        }
                     }
                  };
                  replayTimer.addEventListener(TimerEvent.TIMER,replayFunc);
                  replayTimer.start();
               }
            }
            else
            {
               this.writeLine("Error, hack replay value (Expects [save | load])");
            }
         }
         else if(/^unlocks$/i.test(args[0]))
         {
            if(args.length <= 1)
            {
               this.writeLine("Error, hack unlocks value (Expects [on | off | partial])");
            }
            else if(/^on$/i.test(args[1]))
            {
               for(j in SaveData.Unlocks)
               {
                  if(SaveData.Unlocks[j] is Boolean)
                  {
                     SaveData.Unlocks[j] = true;
                  }
               }
               SaveData.saveGame();
               this.writeLine("All unlockables have been unlocked.");
            }
            else if(/^off$/i.test(args[1]))
            {
               for(j in SaveData.Unlocks)
               {
                  if(SaveData.Unlocks[j] is Boolean)
                  {
                     SaveData.Unlocks[j] = false;
                  }
               }
               SaveData.saveGame();
               this.writeLine("All unlockables have been locked.");
            }
            else if(/^partial$/i.test(args[1]))
            {
               for(j in SaveData.Unlocks)
               {
                  if(SaveData.Unlocks[j] is Boolean)
                  {
                     SaveData.Unlocks[j] = false;
                  }
               }
               UnlockController.getUnlockableByID(Unlockable.THE_WORLD_THAT_NEVER_WAS).TriggerUnlock = true;
               UnlockController.getUnlockableByID(Unlockable.SKY_PILLAR).TriggerUnlock = true;
               UnlockController.getUnlockableByID(Unlockable.KRAZOA_PALACE).TriggerUnlock = true;
               UnlockController.getUnlockableByID(Unlockable.URBAN_CHAMPION).TriggerUnlock = true;
               SaveData.Records.vs.stages.konohavillage = 14;
               SaveData.Records.classic.wins.naruto = {"score":123456};
               SaveData.Records.vs.ffaMatchTotal = 14;
               UnlockController.getUnlockableByID(Unlockable.WORLD_TOURNAMENT).TriggerUnlock = true;
               SaveData.Unlocks.waterKOs = 19;
               SaveData.Records.classic.wins.jigglypuff = {"score":123456};
               SaveData.Unlocks.linkHyrule64Condition = true;
               SaveData.Unlocks.zeldaHyrule64Condition = true;
               SaveData.Unlocks.linkHyrule64Condition = true;
               SaveData.Unlocks.zeldaHyrule64Condition = true;
               SaveData.Unlocks.ghostNessSDs = 2;
               UnlockController.getUnlockableByID(Unlockable.METAL_CAVERN).TriggerUnlock = true;
               SaveData.Records.vs.matchTotal = 99;
               SaveData.Records.vs.matches.sandbag = 0;
               SaveData.Unlocks.eventAllStar01 = true;
               SaveData.Unlocks.events11_20 = true;
               SaveData.Unlocks.eventAllStar06 = true;
               SaveData.Unlocks.events21_30 = true;
               SaveData.Unlocks.eventAllStar07 = true;
               SaveData.Unlocks.events31_33 = true;
               SaveData.Unlocks.eventAllStar08 = true;
               SaveData.Unlocks.events34_40 = true;
               SaveData.Unlocks.eventAllStar09 = true;
               SaveData.Unlocks.events41_46 = true;
               SaveData.Unlocks.eventAllStarBeta = true;
               SaveData.Unlocks.events47_51 = false;
               SaveData.Unlocks.eventsARank = false;
               SaveData.Unlocks.eventsSRank = false;
               events = ResourceManager.getResourceByID("event_mode").getProp("eventList");
               i = 0;
               while(i < events.length)
               {
                  SaveData.Records.events.wins[events[i].id] = {
                     "rank":"S",
                     "score":0,
                     "scoreType":"time",
                     "fps":30
                  };
                  i += 1;
               }
               UnlockController.getUnlockableByID(Unlockable.ALTERNATE_TRACKS).TriggerUnlock = true;
               SaveData.saveGame();
               this.writeLine("All unlockable conditions have been partially satisfied.");
            }
            else
            {
               this.writeLine("Error, hack unlocks value (Expects [on | off | partial])");
            }
         }
         else if(/^hud$/i.test(args[0]))
         {
            if(args.length <= 1)
            {
               this.writeLine("Error, hack hud value (Expects [on | off])");
            }
            else if(/^on$/i.test(args[1]))
            {
               if(GameController.stageData)
               {
                  GameController.stageData.HudRef.Container.alpha = 1;
                  GameController.stageData.FPSTimer.MC.visible = true;
                  GameController.constantDebugger.Container.visible = true;
                  this.writeLine("HUD enabled.");
               }
               else
               {
                  this.writeLine("A game must be active to toggle hud.");
               }
            }
            else if(/^off$/i.test(args[1]))
            {
               if(GameController.stageData)
               {
                  GameController.stageData.HudRef.Container.alpha = 0;
                  GameController.stageData.FPSTimer.MC.visible = false;
                  GameController.constantDebugger.Container.visible = false;
                  this.writeLine("HUD disabled");
               }
               else
               {
                  this.writeLine("A game must be active to toggle hud.");
               }
            }
            else
            {
               this.writeLine("Error, hack hud value (Expects [on | off])");
            }
         }
         else if(/^bubble$/i.test(args[0]))
         {
            if(args.length <= 1)
            {
               this.writeLine("Error, hack bubble value (Expects [on | off])");
            }
            else if(/^on$/i.test(args[1]))
            {
               DebugConsole.DISABLE_OFFSCREEN_BUBBLE = false;
               if(GameController.stageData)
               {
                  i = 0;
                  while(i < GameController.stageData.Characters.length)
                  {
                     GameController.stageData.Characters[i].OffScreenIndicatorEnabled = true;
                     i += 1;
                  }
                  this.writeLine("Offscreen bubbles enabled.");
               }
            }
            else if(/^off$/i.test(args[1]))
            {
               DebugConsole.DISABLE_OFFSCREEN_BUBBLE = true;
               if(GameController.stageData)
               {
                  i = 0;
                  while(i < GameController.stageData.Characters.length)
                  {
                     GameController.stageData.Characters[i].OffScreenIndicatorEnabled = false;
                     i += 1;
                  }
                  this.writeLine("Offscreen bubbles disabled.");
               }
            }
            else
            {
               this.writeLine("Error, hack bubble value (Expects [on | off])");
            }
         }
         else if(/^camera$/i.test(args[0]))
         {
            if(args.length <= 1)
            {
               this.writeLine("Error, hack camera value (Expects [normal | stage | zoom | free | lock])");
            }
            else if(/^normal$/i.test(args[1]))
            {
               if(GameController.stageData)
               {
                  GameController.stageData.CamRef.forceSetMode(Vcam.NORMAL_MODE);
                  this.writeLine("Camera set to normal mode.");
               }
               else
               {
                  this.writeLine("A game must be active to toggle camera.");
               }
            }
            else if(/^stage$/i.test(args[1]))
            {
               if(GameController.stageData)
               {
                  GameController.stageData.CamRef.forceSetMode(Vcam.STAGE_MODE);
                  this.writeLine("Camera set to stage mode.");
               }
               else
               {
                  this.writeLine("A game must be active to toggle camera.");
               }
            }
            else if(/^zoom$/i.test(args[1]))
            {
               if(GameController.stageData)
               {
                  GameController.stageData.CamRef.forceSetMode(Vcam.ZOOM_MODE);
                  this.writeLine("Camera set to normal mode.");
               }
               else
               {
                  this.writeLine("A game must be active to toggle camera.");
               }
            }
            else if(/^free$/i.test(args[1]))
            {
               if(GameController.stageData)
               {
                  GameController.stageData.CamRef.forceSetMode(Vcam.FREE_MODE);
                  this.writeLine("Camera set to free mode.");
               }
               else
               {
                  this.writeLine("A game must be active to toggle camera.");
               }
            }
            else if(/^lock$/i.test(args[1]))
            {
               if(GameController.stageData)
               {
                  GameController.stageData.CamRef.forceSetMode(Vcam.LOCK_MODE);
                  this.writeLine("Camera set to lock mode.");
               }
               else
               {
                  this.writeLine("A game must be active to toggle camera.");
               }
            }
            else
            {
               this.writeLine("Error, hack camera value (Expects [normal | stage | zoom | free | lock])");
            }
         }
         else if(/^fsmeter$/i.test(args[0]))
         {
            if(!GameController.stageData)
            {
               this.writeLine("Error, match must be initialized to change hack fsmeter value");
            }
            else if(args.length >= 2)
            {
               if(!/^\d++(\.\d++)?$/i.test(args[1]))
               {
                  this.writeLine("Error, hack fsmeter value (Expects a Number between 0.0 and 1.0)");
               }
               else
               {
                  chargeValue = Number(parseFloat(args[1]));
                  if(chargeValue < 0 || chargeValue > 1)
                  {
                     this.writeLine("Error, hack fsmeter value (Expects a Number between 0.0 and 1.0)");
                  }
                  else
                  {
                     i = 0;
                     while(i < GameController.stageData.Players.length)
                     {
                        character = GameController.stageData.Players[i];
                        if(character)
                        {
                           character.FinalSmashMeterCharge = chargeValue;
                        }
                        i += 1;
                     }
                     this.writeLine("Final smash meter charge has been set to " + chargeValue + " on all player slots");
                  }
               }
            }
            else
            {
               i = 0;
               while(i < GameController.stageData.Players.length)
               {
                  character = GameController.stageData.Players[i];
                  if(character)
                  {
                     character.updateCharacterStats({"finalSmashMeter":!character.CharacterStats.FinalSmashMeter});
                     success = character.CharacterStats.FinalSmashMeter;
                  }
                  i += 1;
               }
               this.writeLine(success ? "Final smash meter behavior has been enabled on all player slots" : "Final smash meter behavior has been disabled on all player slots");
            }
         }
      }
      
      public function alert(param1:String) : void
      {
         if(Boolean(Main.DEBUG) && Boolean(this.m_alerts))
         {
            if(!(GameController.currentGame && (GameController.currentGame.GameMode == Mode.ONLINE || GameController.currentGame.GameMode == Mode.ONLINE_ARENA || GameController.currentGame.GameMode == Mode.ONLINE_WAITING_ROOM)))
            {
               this.forceShow();
            }
            this.writeLine(param1);
         }
      }
      
      public function writeEndAttackControls(param1:String) : void
      {
         if(this.m_controlsCapture)
         {
            this.writeLine(param1);
         }
      }
      
      public function writeTextData(param1:String) : void
      {
         this.writeLine(param1);
      }
      
      private function writeDatScript() : void
      {
         var tempManifest:Object;
         var engineManifest:Object;
         var buffer:String = null;
         var first:int = 0;
         var second:int = 0;
         var tp:int = 0;
         var b:int = 0;
         buffer = "";
         var bulkTrace:Function = function(param1:String):void
         {
            buffer += param1;
            buffer += "\n";
         };
         var names:Array = new Array(ResourceManager.pool.length);
         b = 0;
         while(b < ResourceManager.pool.length)
         {
            names[b] = b;
            b += 1;
         }
         b = 1000;
         while(b > 0)
         {
            b--;
            first = int(Utils.randomInteger(0,names.length - 1));
            second = int(Utils.randomInteger(0,names.length - 1));
            tp = int(names[first]);
            names[first] = names[second];
            names[second] = tp;
         }
         bulkTrace(":: ------------- BEGIN make_dat_files.bat -------------");
         b = 0;
         while(b < ResourceManager.pool.length)
         {
            if(ResourceManager.pool[b].ID !== "targettest_sheik")
            {
               if(ResourceManager.pool[b].ID !== "sheik")
               {
                  if(ResourceManager.pool[b].EncryptedFileName)
                  {
                     if(ResourceManager.pool[b].Type == Resource.CHARACTER)
                     {
                        bulkTrace("ren ..\\..\\build\\data\\character\\" + ResourceManager.pool[b].FileName + " DAT" + names[b] + ".ssf");
                     }
                     else if(ResourceManager.pool[b].Type == Resource.STAGE)
                     {
                        bulkTrace("ren ..\\..\\build\\data\\stage\\" + ResourceManager.pool[b].FileName + " DAT" + names[b] + ".ssf");
                     }
                     else if(ResourceManager.pool[b].Type == Resource.MISC)
                     {
                        bulkTrace("ren ..\\..\\build\\data\\misc\\" + ResourceManager.pool[b].FileName + " DAT" + names[b] + ".ssf");
                     }
                     else if(ResourceManager.pool[b].Type == Resource.EXTRA)
                     {
                        bulkTrace("ren ..\\..\\build\\data\\misc\\" + ResourceManager.pool[b].FileName + " DAT" + names[b] + ".ssf");
                     }
                     else if(ResourceManager.pool[b].Type == Resource.MENU)
                     {
                        bulkTrace("ren ..\\..\\build\\data\\menu\\" + ResourceManager.pool[b].FileName + " DAT" + names[b] + ".ssf");
                     }
                     else if(ResourceManager.pool[b].Type == Resource.AUDIO)
                     {
                        bulkTrace("ren ..\\..\\build\\data\\sound\\" + ResourceManager.pool[b].FileName + " DAT" + names[b] + ".ssf");
                     }
                     else if(ResourceManager.pool[b].Type == Resource.MUSIC)
                     {
                        bulkTrace("ren ..\\..\\build\\data\\sound\\" + ResourceManager.pool[b].FileName + " DAT" + names[b] + ".ssf");
                     }
                     else if(ResourceManager.pool[b].Type == Resource.MODE)
                     {
                        bulkTrace("ren ..\\..\\build\\data\\modes\\" + ResourceManager.pool[b].FileName + " DAT" + names[b] + ".ssf");
                     }
                  }
               }
            }
            b += 1;
         }
         bulkTrace("move ..\\..\\build\\data\\character\\DAT*.ssf ..\\..\\build\\data\\");
         bulkTrace("move ..\\..\\build\\data\\stage\\DAT*.ssf ..\\..\\build\\data\\");
         bulkTrace("move ..\\..\\build\\data\\misc\\DAT*.ssf ..\\..\\build\\data\\");
         bulkTrace("move ..\\..\\build\\data\\menu\\DAT*.ssf ..\\..\\build\\data\\");
         bulkTrace("move ..\\..\\build\\data\\sound\\DAT*.ssf ..\\..\\build\\data\\");
         bulkTrace("move ..\\..\\build\\data\\modes\\DAT*.ssf ..\\..\\build\\data\\");
         bulkTrace(":: ------------- END make_dat_files.bat -------------");
         bulkTrace("\n");
         bulkTrace(":: ------------- BEGIN unmake_dat_files.bat -------------");
         bulkTrace("mkdir ..\\..\\build\\data\\character");
         bulkTrace("mkdir ..\\..\\build\\data\\stage");
         bulkTrace("mkdir ..\\..\\build\\data\\misc");
         bulkTrace("mkdir ..\\..\\build\\data\\menu");
         bulkTrace("mkdir ..\\..\\build\\data\\sound");
         bulkTrace("mkdir ..\\..\\build\\data\\modes");
         b = 0;
         while(b < ResourceManager.pool.length)
         {
            if(ResourceManager.pool[b].ID !== "targettest_sheik")
            {
               if(ResourceManager.pool[b].ID !== "sheik")
               {
                  if(ResourceManager.pool[b].EncryptedFileName)
                  {
                     if(ResourceManager.pool[b].Type == Resource.CHARACTER)
                     {
                        bulkTrace("move ..\\..\\build\\data\\" + "DAT" + names[b] + ".ssf ..\\..\\build\\data\\character\\");
                        bulkTrace("ren ..\\..\\build\\data\\character\\" + "DAT" + names[b] + ".ssf " + ResourceManager.pool[b].FileName);
                     }
                     else if(ResourceManager.pool[b].Type == Resource.STAGE)
                     {
                        bulkTrace("move ..\\..\\build\\data\\" + "DAT" + names[b] + ".ssf ..\\..\\build\\data\\stage\\");
                        bulkTrace("ren ..\\..\\build\\data\\stage\\" + "DAT" + names[b] + ".ssf " + ResourceManager.pool[b].FileName);
                     }
                     else if(ResourceManager.pool[b].Type == Resource.MISC)
                     {
                        bulkTrace("move ..\\..\\build\\data\\" + "DAT" + names[b] + ".ssf ..\\..\\build\\data\\misc\\");
                        bulkTrace("ren ..\\..\\build\\data\\misc\\" + "DAT" + names[b] + ".ssf " + ResourceManager.pool[b].FileName);
                     }
                     else if(ResourceManager.pool[b].Type == Resource.EXTRA)
                     {
                        bulkTrace("move ..\\..\\build\\data\\" + "DAT" + names[b] + ".ssf ..\\..\\build\\data\\misc\\");
                        bulkTrace("ren ..\\..\\build\\data\\misc\\" + "DAT" + names[b] + ".ssf " + ResourceManager.pool[b].FileName);
                     }
                     else if(ResourceManager.pool[b].Type == Resource.MENU)
                     {
                        bulkTrace("move ..\\..\\build\\data\\" + "DAT" + names[b] + ".ssf ..\\..\\build\\data\\menu\\");
                        bulkTrace("ren ..\\..\\build\\data\\menu\\" + "DAT" + names[b] + ".ssf " + ResourceManager.pool[b].FileName);
                     }
                     else if(ResourceManager.pool[b].Type == Resource.AUDIO)
                     {
                        bulkTrace("move ..\\..\\build\\data\\" + "DAT" + names[b] + ".ssf ..\\..\\build\\data\\sound\\");
                        bulkTrace("ren ..\\..\\build\\data\\sound\\" + "DAT" + names[b] + ".ssf " + ResourceManager.pool[b].FileName);
                     }
                     else if(ResourceManager.pool[b].Type == Resource.MUSIC)
                     {
                        bulkTrace("move ..\\..\\build\\data\\" + "DAT" + names[b] + ".ssf ..\\..\\build\\data\\sound\\");
                        bulkTrace("ren ..\\..\\build\\data\\sound\\" + "DAT" + names[b] + ".ssf " + ResourceManager.pool[b].FileName);
                     }
                     else if(ResourceManager.pool[b].Type == Resource.MODE)
                     {
                        bulkTrace("move ..\\..\\build\\data\\" + "DAT" + names[b] + ".ssf ..\\..\\build\\data\\modes\\");
                        bulkTrace("ren ..\\..\\build\\data\\modes\\" + "DAT" + names[b] + ".ssf " + ResourceManager.pool[b].FileName);
                     }
                  }
               }
            }
            b += 1;
         }
         bulkTrace(":: ------------- END unmake_dat_files.bat -------------");
         bulkTrace("\n");
         bulkTrace("// ------------- BEGIN mappings -------------");
         bulkTrace("// Note: This is only the data that is loaded on-demand (characters, stages, music, etc.). Don\'t overwrite entire mappings with this!");
         tempManifest = Utils.cloneObject(ResourceManager.manifestJSONData);
         b = 0;
         while(b < ResourceManager.pool.length)
         {
            if(ResourceManager.pool[b].EncryptedFileName)
            {
               if(ResourceManager.pool[b].Type == Resource.CHARACTER)
               {
                  tempManifest.character[ResourceManager.pool[b].ID].file_pub = "DAT" + names[b] + ".ssf";
               }
               else if(ResourceManager.pool[b].Type == Resource.STAGE)
               {
                  tempManifest.stage[ResourceManager.pool[b].ID].file_pub = "DAT" + names[b] + ".ssf";
               }
               else if(ResourceManager.pool[b].Type == Resource.MISC)
               {
                  tempManifest.misc[ResourceManager.pool[b].ID].file_pub = "DAT" + names[b] + ".ssf";
               }
               else if(ResourceManager.pool[b].Type == Resource.EXTRA)
               {
                  tempManifest.extra[ResourceManager.pool[b].ID].file_pub = "DAT" + names[b] + ".ssf";
               }
               else if(ResourceManager.pool[b].Type == Resource.MENU)
               {
                  tempManifest.menu[ResourceManager.pool[b].ID].file_pub = "DAT" + names[b] + ".ssf";
               }
               else if(ResourceManager.pool[b].Type == Resource.AUDIO)
               {
                  tempManifest.audio[ResourceManager.pool[b].ID].file_pub = "DAT" + names[b] + ".ssf";
               }
               else if(ResourceManager.pool[b].Type == Resource.MUSIC)
               {
                  tempManifest.music[ResourceManager.pool[b].ID].file_pub = "DAT" + names[b] + ".ssf";
               }
               else if(ResourceManager.pool[b].Type == Resource.MODE)
               {
                  tempManifest.modes[ResourceManager.pool[b].ID].file_pub = "DAT" + names[b] + ".ssf";
               }
            }
            b += 1;
         }
         engineManifest = {
            "modes":tempManifest.modes,
            "menu":tempManifest.menu,
            "misc":tempManifest.misc,
            "audio":tempManifest.audio
         };
         delete tempManifest.modes;
         delete tempManifest.menu;
         delete tempManifest.misc;
         delete tempManifest.audio;
         tempManifest.character.sheik.file_pub = tempManifest.character.zelda.file_pub;
         bulkTrace(JSON.stringify(tempManifest,null,"  "));
         bulkTrace("// ------------- END mappings -------------");
         bulkTrace("\n");
         bulkTrace("// ------------- BEGIN manifest -------------");
         bulkTrace("// Note: This is in-engine only!");
         bulkTrace(JSON.stringify(engineManifest,null,"  "));
         bulkTrace("// ------------- END manifest -------------");
         this.writeLine(buffer);
      }
      
      private function writeDatRenamer() : void
      {
         var buffer:String = null;
         var res:Object = null;
         var allDirs:Array = null;
         var dir:String = null;
         var obfuscated:String = null;
         var subdir:String = null;
         buffer = "";
         var bulkTrace:Function = function(param1:String):void
         {
            buffer += param1 + "\n";
         };
         var getObfuscatedName:Function = function(param1:Object):String
         {
            var _loc3_:Object = null;
            var _loc2_:String = null;
            switch(param1.Type)
            {
               case Resource.CHARACTER:
                  _loc3_ = ResourceManager.manifestJSONData.character[param1.ID];
                  if(_loc3_)
                  {
                     _loc2_ = _loc3_.file_pub;
                  }
                  break;
               case Resource.STAGE:
                  _loc3_ = ResourceManager.manifestJSONData.stage[param1.ID];
                  if(_loc3_)
                  {
                     _loc2_ = _loc3_.file_pub;
                  }
                  break;
               case Resource.MISC:
                  _loc3_ = ResourceManager.manifestJSONData.misc[param1.ID];
                  if(_loc3_)
                  {
                     _loc2_ = _loc3_.file_pub;
                  }
                  break;
               case Resource.EXTRA:
                  _loc3_ = ResourceManager.manifestJSONData.extra[param1.ID];
                  if(_loc3_)
                  {
                     _loc2_ = _loc3_.file_pub;
                  }
                  break;
               case Resource.MENU:
                  _loc3_ = ResourceManager.manifestJSONData.menu[param1.ID];
                  if(_loc3_)
                  {
                     _loc2_ = _loc3_.file_pub;
                  }
                  break;
               case Resource.AUDIO:
                  _loc3_ = ResourceManager.manifestJSONData.audio[param1.ID];
                  if(_loc3_)
                  {
                     _loc2_ = _loc3_.file_pub;
                  }
                  break;
               case Resource.MUSIC:
                  _loc3_ = ResourceManager.manifestJSONData.music[param1.ID];
                  if(_loc3_)
                  {
                     _loc2_ = _loc3_.file_pub;
                  }
                  break;
               case Resource.MODE:
                  _loc3_ = ResourceManager.manifestJSONData.modes[param1.ID];
                  if(_loc3_)
                  {
                     _loc2_ = _loc3_.file_pub;
                  }
            }
            return _loc2_;
         };
         bulkTrace(":: ------------- BEGIN make_dat_files.bat -------------");
         for each(res in ResourceManager.pool)
         {
            if(!(!res.EncryptedFileName || res.ID === "sheik" || res.ID === "targettest_sheik"))
            {
               obfuscated = getObfuscatedName(res);
               if(obfuscated)
               {
                  subdir = "";
                  switch(res.Type)
                  {
                     case Resource.CHARACTER:
                        subdir = "character";
                        break;
                     case Resource.STAGE:
                        subdir = "stage";
                        break;
                     case Resource.MISC:
                     case Resource.EXTRA:
                        subdir = "misc";
                        break;
                     case Resource.MENU:
                        subdir = "menu";
                        break;
                     case Resource.AUDIO:
                     case Resource.MUSIC:
                        subdir = "sound";
                        break;
                     case Resource.MODE:
                        subdir = "modes";
                  }
                  bulkTrace("ren ..\\..\\build\\data\\" + subdir + "\\" + res.FileName + " " + obfuscated);
               }
            }
         }
         allDirs = ["character","stage","misc","menu","sound","modes"];
         for each(dir in allDirs)
         {
            bulkTrace("move ..\\..\\build\\data\\" + dir + "\\DAT*.ssf ..\\..\\build\\data\\");
         }
         bulkTrace(":: ------------- END make_dat_files.bat -------------\n");
         bulkTrace(":: ------------- BEGIN unmake_dat_files.bat -------------");
         for each(dir in allDirs)
         {
            bulkTrace("mkdir ..\\..\\build\\data\\" + dir);
         }
         for each(res in ResourceManager.pool)
         {
            if(!(!res.EncryptedFileName || res.ID === "sheik" || res.ID === "targettest_sheik"))
            {
               obfuscated = getObfuscatedName(res);
               if(obfuscated)
               {
                  subdir = "";
                  switch(res.Type)
                  {
                     case Resource.CHARACTER:
                        subdir = "character";
                        break;
                     case Resource.STAGE:
                        subdir = "stage";
                        break;
                     case Resource.MISC:
                     case Resource.EXTRA:
                        subdir = "misc";
                        break;
                     case Resource.MENU:
                        subdir = "menu";
                        break;
                     case Resource.AUDIO:
                     case Resource.MUSIC:
                        subdir = "sound";
                        break;
                     case Resource.MODE:
                        subdir = "modes";
                  }
                  bulkTrace("move ..\\..\\build\\data\\" + obfuscated + " ..\\..\\build\\data\\" + subdir + "\\");
                  bulkTrace("ren ..\\..\\build\\data\\" + subdir + "\\" + obfuscated + " " + res.FileName);
               }
            }
         }
         bulkTrace(":: ------------- END unmake_dat_files.bat -------------");
         this.writeLine(buffer);
      }
   }
}


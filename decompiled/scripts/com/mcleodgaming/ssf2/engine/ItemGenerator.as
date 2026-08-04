package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.api.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.events.*;
   import com.mcleodgaming.ssf2.items.*;
   import com.mcleodgaming.ssf2.platforms.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   import flash.geom.*;
   
   public class ItemGenerator
   {
      
      private var ROOT:MovieClip;
      
      private var STAGE:MovieClip;
      
      private var STAGEPARENT:MovieClip;
      
      private var STAGEDATA:StageData;
      
      private var m_frequency:int;
      
      private var m_checkEvery:Number;
      
      private var m_chance:Number;
      
      private var m_timer:Number;
      
      private var m_itemsInUse:Vector.<Item>;
      
      private var m_itemIndex:Number;
      
      private var m_item:Vector.<ItemData>;
      
      private var m_itemID:Number;
      
      private var m_sizeRatio:Number;
      
      private var m_lastItem:Item;
      
      private var m_initTimer:Number;
      
      private var m_terrains:Vector.<Platform>;
      
      private var m_platforms:Vector.<Platform>;
      
      private var m_itemGens:Vector.<MovieClip>;
      
      private var m_itemsList:Vector.<ItemData>;
      
      private var m_fullItemsList:Vector.<ItemData>;
      
      private var m_itemCount:int;
      
      private var m_hiddenItemsList:Vector.<String>;
      
      private var m_smashBallReady:FrameTimer;
      
      private var m_suddenDeathBombTimer:FrameTimer;
      
      private var m_smashBallDisabled:Boolean;
      
      private var m_pokemonClass:Class;
      
      private var m_assistClass:Class;
      
      public function ItemGenerator(param1:Object, param2:StageData)
      {
         var _loc3_:ItemData = null;
         var _loc4_:ItemData = null;
         var _loc5_:int = 0;
         var _loc11_:MovieClip = null;
         var _loc12_:int = 0;
         super();
         this.STAGEDATA = param2;
         this.ROOT = this.STAGEDATA.RootRef;
         this.STAGE = this.STAGEDATA.StageRef;
         this.STAGEPARENT = this.STAGEDATA.StageParentRef;
         this.m_sizeRatio = param1["sizeRatio"];
         this.m_itemGens = param2.getItemGens();
         this.m_itemsInUse = new Vector.<Item>();
         if(!Config.enable_items)
         {
            this.Frequency = ItemSettings.FREQUENCY_OFF;
         }
         else
         {
            this.Frequency = param1["frequency"];
         }
         while(_loc5_ < this.MAXITEMS)
         {
            this.m_itemsInUse[_loc5_] = null;
            _loc5_++;
         }
         var _loc6_:Number = Number(this.m_sizeRatio);
         var _loc7_:Array = ItemsListData.DATA;
         var _loc8_:Object = ResourceManager.getResourceByID("mappings").getProp("metadata");
         var _loc9_:Array = _loc8_.item_switch_screen.rows;
         var _loc10_:Array = Utils.flatten(_loc9_ as Array);
         this.m_hiddenItemsList = new Vector.<String>();
         this.m_itemsList = new Vector.<ItemData>();
         this.m_fullItemsList = new Vector.<ItemData>();
         while(_loc12_ < _loc7_.length)
         {
            if(this.m_hiddenItemsList.indexOf(_loc7_[_loc12_].statsName) < 0)
            {
               if(!(!ItemsListData.getItemByID(_loc7_[_loc12_].statsName) || _loc10_.indexOf(_loc7_[_loc12_].statsName) < 0 || this.STAGEDATA.GameRef.LevelData.unlocks[_loc7_[_loc12_].statsName] === false && (!Main.DEBUG || Boolean(this.STAGEDATA.ReplayMode) || Boolean(this.STAGEDATA.OnlineMode))))
               {
                  if((this.STAGEDATA.GameRef.Items.items[_loc7_[_loc12_].statsName] === undefined || Boolean(ModeFeatures.hasFeature(ModeFeatures.FORCE_ITEM_AVAILABILITY,this.STAGEDATA.GameRef.GameMode))) && Boolean(Config.enable_items))
                  {
                     _loc4_ = new ItemData();
                     _loc4_.importData(_loc7_[_loc12_]);
                     this.m_itemsList.push(_loc4_);
                  }
                  _loc3_ = new ItemData();
                  _loc3_.importData(_loc7_[_loc12_]);
                  this.m_fullItemsList.push(_loc3_);
                  if(!HitBoxAnimation.AnimationsList[_loc3_.LinkageID])
                  {
                     _loc11_ = ResourceManager.getLibraryMC(_loc3_.LinkageID);
                     if(_loc11_)
                     {
                        Utils.removeActionScript(_loc11_);
                        HitBoxAnimation.createHitBoxAnimation(_loc3_.LinkageID,_loc11_,_loc11_);
                     }
                  }
               }
            }
            _loc12_++;
         }
         this.m_item = this.getItemTypes(param1["itemData"]);
         this.m_lastItem = null;
         this.m_itemIndex = 0;
         this.m_itemID = 0;
         this.m_timer = 0;
         this.m_initTimer = 0;
         this.m_itemCount = 0;
         this.m_terrains = this.STAGEDATA.Terrains;
         this.m_platforms = this.STAGEDATA.Platforms;
         this.m_smashBallDisabled = true;
         this.getTerrainData();
         this.m_smashBallReady = new FrameTimer(5);
         this.m_smashBallReady.CurrentTime = this.m_smashBallReady.MaxTime;
         this.m_suddenDeathBombTimer = new FrameTimer(15);
         this.m_pokemonClass = null;
         this.m_assistClass = null;
      }
      
      public function getTerrainData() : void
      {
      }
      
      public function testTerrainWithCoord(param1:Number, param2:Number) : Platform
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < this.m_terrains.length && Boolean(this.m_terrains[_loc3_].hitTestPoint(param1,param2,true)))
         {
            _loc3_++;
         }
         if(_loc3_ < this.m_terrains.length && Boolean(this.m_terrains[_loc3_].hitTestPoint(param1,param2,true)))
         {
            return this.m_terrains[_loc3_];
         }
         return null;
      }
      
      private function checkItem() : void
      {
         this.m_smashBallReady.tick();
         this.checkDeadItems();
         if(this.m_chance > 0)
         {
            ++this.m_timer;
            if(this.m_timer > this.m_checkEvery * 30)
            {
               this.m_timer = 0;
               if(Utils.random() < this.m_chance)
               {
                  this.generateItem();
               }
            }
         }
      }
      
      public function checkDeadItems() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.m_itemsInUse.length)
         {
            if(this.m_itemsInUse[_loc1_] != null && Boolean(this.m_itemsInUse[_loc1_].Dead))
            {
               this.killItem(_loc1_);
            }
            else if(this.m_itemsInUse[_loc1_] != null && this.m_itemsInUse[_loc1_].LinkageID == "smashball")
            {
            }
            _loc1_++;
         }
      }
      
      public function totalOfItemName(param1:String) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < this.m_itemsInUse.length)
         {
            if(Boolean(this.m_itemsInUse[_loc3_]) && this.m_itemsInUse[_loc3_].LinkageID == param1)
            {
               _loc2_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function totalOfItemStatsName(param1:String) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < this.m_itemsInUse.length)
         {
            if(Boolean(this.m_itemsInUse[_loc3_]) && this.m_itemsInUse[_loc3_].ItemStats.StatsName == param1)
            {
               _loc2_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function totalOfItem(param1:Class) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < this.m_itemsInUse.length)
         {
            if(Boolean(this.m_itemsInUse[_loc3_]) && this.m_itemsInUse[_loc3_] is param1)
            {
               _loc2_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function makeItem(param1:Number, param2:Number, param3:Boolean = false, param4:Boolean = true) : Item
      {
         var _loc5_:int = 0;
         var _loc6_:Array = new Array();
         if(param3)
         {
            _loc5_ = 0;
            while(_loc5_ < this.m_itemsList.length)
            {
               _loc6_.push(this.m_itemsList[_loc5_]);
               _loc5_++;
            }
         }
         else
         {
            _loc5_ = 0;
            while(_loc5_ < this.m_fullItemsList.length)
            {
               _loc6_.push(this.m_fullItemsList[_loc5_]);
               _loc5_++;
            }
         }
         if(_loc6_.length > 0 && Boolean(this.generateItemObj(_loc6_[Utils.randomInteger(0,_loc6_.length - 1)],1337,1337,false,param4)))
         {
            this.m_lastItem.ItemInstance.x = param1;
            this.m_lastItem.ItemInstance.y = param2;
            if(this.m_lastItem.ItemStats.StatsName !== "smashball")
            {
               this.m_lastItem.setYSpeed(-8);
            }
            return this.m_lastItem;
         }
         return null;
      }
      
      private function generateItem() : Boolean
      {
         if(this.generateItemNum(Utils.randomInteger(0,this.m_item.length - 1)))
         {
            this.playGlobalSound("item_spawn");
            return true;
         }
         return false;
      }
      
      public function getItemByLinkage(param1:String, param2:Boolean = false) : ItemData
      {
         var _loc3_:int = 0;
         if(param2)
         {
            _loc3_ = 0;
            while(_loc3_ < this.m_itemsList.length)
            {
               if(this.m_itemsList[_loc3_].LinkageID == param1 || this.m_itemsList[_loc3_].StatsName == param1)
               {
                  return this.m_itemsList[_loc3_];
               }
               _loc3_++;
            }
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < this.m_fullItemsList.length)
            {
               if(this.m_fullItemsList[_loc3_].LinkageID == param1 || this.m_fullItemsList[_loc3_].StatsName == param1)
               {
                  return this.m_fullItemsList[_loc3_];
               }
               _loc3_++;
            }
         }
         return null;
      }
      
      public function generateItemObj(param1:ItemData, param2:Number = 1337, param3:Number = -1337, param4:Boolean = false, param5:Boolean = true) : Item
      {
         var _loc6_:Class = null;
         var _loc7_:MovieClip = null;
         if(Boolean(param1 && this.m_itemIndex < this.m_itemsInUse.length) && (Boolean(this.m_itemGens.length > 0 || param2 != 1337 && param3 != -1337)) && (Boolean(this.validateItemObj(param1)) || param4))
         {
            this.killItem(this.m_itemIndex);
            ++this.m_itemCount;
            _loc6_ = param1.ClassID != null ? Main.getClassByName(param1.ClassID) : Item;
            this.m_lastItem = new _loc6_(param1,this.m_itemIndex,this.STAGEDATA);
            ++this.m_itemID;
            this.m_itemsInUse[this.m_itemIndex] = this.m_lastItem;
            this.STAGEDATA.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.GAME_ITEM_CREATED,{
               "item":this.m_lastItem.APIInstance.instance,
               "auto":false
            }));
            if(param2 != 1337 && param3 != -1337)
            {
               this.m_lastItem.ItemInstance.x = param2;
               this.m_lastItem.ItemInstance.y = param3;
               while(this.testTerrainWithCoord(this.m_lastItem.ItemInstance.x,this.m_lastItem.ItemInstance.y))
               {
                  --this.m_lastItem.ItemInstance.y;
               }
            }
            else if(!this.m_lastItem.IsSmashBall)
            {
               _loc7_ = this.m_itemGens[Math.round(Utils.random() * (this.m_itemGens.length - 1))];
               this.m_lastItem.ItemInstance.x = Utils.random() * (_loc7_.x + _loc7_.width - _loc7_.x) + _loc7_.x;
               this.m_lastItem.ItemInstance.y = _loc7_.y;
               while(this.testTerrainWithCoord(this.m_lastItem.ItemInstance.x,this.m_lastItem.ItemInstance.y))
               {
                  --this.m_lastItem.ItemInstance.y;
               }
            }
            if(param5)
            {
               this.m_lastItem.attachEffect(this.m_lastItem.ItemStats.SpawnEffect);
            }
            this.incrementItemSlot();
            return this.m_lastItem;
         }
         return null;
      }
      
      public function generateItemNum(param1:Number, param2:Number = 1337, param3:Number = -1337, param4:Boolean = false) : Boolean
      {
         var _loc5_:ItemData = null;
         var _loc6_:Class = null;
         var _loc7_:MovieClip = null;
         if(this.m_itemIndex < this.m_itemsInUse.length && (this.m_itemGens.length > 0 || param2 != 1337 && param3 != -1337) && (Boolean(this.validateItemNum(param1)) || param4))
         {
            _loc5_ = this.m_item[param1];
            if(_loc5_.LinkageID == "capsule_ex" && Utils.random() > 0.25)
            {
               _loc5_ = this.getItemByLinkage("capsule");
            }
            _loc6_ = _loc5_.ClassID != null ? Main.getClassByName(_loc5_.ClassID) : Item;
            ++this.m_itemCount;
            this.m_lastItem = new _loc6_(_loc5_,this.m_itemIndex,this.STAGEDATA);
            this.STAGEDATA.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.GAME_ITEM_CREATED,{
               "item":this.m_lastItem.APIInstance.instance,
               "auto":true
            }));
            ++this.m_itemID;
            if(param2 != 1337 && param3 != -1337)
            {
               this.m_lastItem.ItemInstance.x = param2;
               this.m_lastItem.ItemInstance.y = param3;
               while(this.testTerrainWithCoord(this.m_lastItem.ItemInstance.x,this.m_lastItem.ItemInstance.y))
               {
                  --this.m_lastItem.ItemInstance.y;
               }
            }
            else if(!this.m_lastItem.IsSmashBall)
            {
               _loc7_ = this.m_itemGens[Math.round(Utils.random() * (this.m_itemGens.length - 1))];
               this.m_lastItem.ItemInstance.x = Utils.random() * (_loc7_.x + _loc7_.width - _loc7_.x) + _loc7_.x;
               this.m_lastItem.ItemInstance.y = _loc7_.y;
               while(this.testTerrainWithCoord(this.m_lastItem.ItemInstance.x,this.m_lastItem.ItemInstance.y))
               {
                  --this.m_lastItem.ItemInstance.y;
               }
            }
            this.m_lastItem.attachEffect(this.m_lastItem.ItemStats.SpawnEffect);
            this.m_itemsInUse[this.m_itemIndex] = this.m_lastItem;
            this.incrementItemSlot();
            return true;
         }
         return false;
      }
      
      public function getRandomLocation() : Point
      {
         return new Point(Utils.random() * (this.STAGEDATA.SmashBallBounds.x + this.STAGEDATA.SmashBallBounds.width - this.STAGEDATA.SmashBallBounds.x) + this.STAGEDATA.SmashBallBounds.x,Utils.random() * (this.STAGEDATA.SmashBallBounds.y + this.STAGEDATA.SmashBallBounds.height - this.STAGEDATA.SmashBallBounds.y) + this.STAGEDATA.SmashBallBounds.y);
      }
      
      private function incrementItemSlot() : void
      {
         ++this.m_itemIndex;
         if(this.m_itemIndex >= this.MAXITEMS)
         {
            this.m_itemIndex = 0;
         }
         if(this.m_itemIndex < this.m_item.length && this.m_item[this.m_itemIndex] != null && this.m_item[this.m_itemIndex].LinkageID == "smashball")
         {
            ++this.m_itemIndex;
            if(this.m_itemIndex >= this.MAXITEMS)
            {
               this.m_itemIndex = 0;
            }
         }
      }
      
      private function validateItemNum(param1:Number) : Boolean
      {
         return param1 >= 0 && param1 < this.m_item.length && Boolean(this.validateItemObj(this.m_item[param1]));
      }
      
      private function validateItemObj(param1:ItemData) : Boolean
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Boolean = true;
         if(param1 == null || param1.SpawnLimit >= 0 && this.totalOfItemStatsName(param1.StatsName) >= param1.SpawnLimit)
         {
            return false;
         }
         if(param1.LinkageID == "smashball")
         {
            for(_loc2_ in this.m_itemsInUse)
            {
               if(this.m_itemsInUse[_loc2_] != null && this.m_itemsInUse[_loc2_].ItemStats.StatsName == "smashball")
               {
                  _loc5_ = false;
               }
            }
            _loc3_ = 0;
            while(_loc3_ < this.STAGEDATA.Characters.length)
            {
               if(Boolean(this.STAGEDATA.Characters[_loc3_].UsingFinalSmash) || Boolean(this.STAGEDATA.Characters[_loc3_].HasFinalSmash))
               {
                  _loc5_ = false;
               }
               _loc3_++;
            }
            if(!this.m_smashBallReady.IsComplete)
            {
               _loc5_ = false;
            }
            if(!this.m_smashBallDisabled)
            {
               _loc5_ = false;
            }
         }
         if(_loc5_ && this.m_itemsInUse[this.m_itemIndex] != null)
         {
            _loc4_ = this.m_itemIndex + 1;
            if(_loc4_ >= this.MAXITEMS)
            {
               _loc4_ = 0;
            }
            while(this.m_itemIndex != _loc4_ && this.m_itemsInUse[_loc4_] != null)
            {
               _loc4_++;
               if(_loc4_ >= this.MAXITEMS)
               {
                  _loc4_ = 0;
               }
            }
            if(this.m_itemIndex == _loc4_)
            {
               _loc5_ = false;
            }
            else
            {
               this.m_itemIndex = _loc4_;
            }
         }
         return _loc5_;
      }
      
      public function get SmashBallDisabled() : Boolean
      {
         return this.m_smashBallDisabled;
      }
      
      public function set SmashBallDisabled(param1:Boolean) : void
      {
         this.m_smashBallDisabled = param1;
      }
      
      public function get Frequency() : int
      {
         return this.m_chance;
      }
      
      public function set Frequency(param1:int) : void
      {
         this.m_frequency = param1;
         switch(param1)
         {
            case 1:
               this.m_checkEvery = 10;
               this.m_chance = 0.1;
               break;
            case 2:
               this.m_checkEvery = 10;
               this.m_chance = 0.25;
               break;
            case 3:
               this.m_checkEvery = 10;
               this.m_chance = 0.5;
               break;
            case 4:
               this.m_checkEvery = 5;
               this.m_chance = 0.25;
               break;
            case 5:
               this.m_checkEvery = 5;
               this.m_chance = 0.5;
               break;
            case 6:
               this.m_checkEvery = 4;
               this.m_chance = 0.65;
               break;
            case 7:
               this.m_checkEvery = 4;
               this.m_chance = 0.75;
               break;
            case 8:
               this.m_checkEvery = 3;
               this.m_chance = 1;
               break;
            default:
               this.m_checkEvery = 0;
               this.m_chance = 0;
         }
      }
      
      public function get MAXITEMS() : Number
      {
         return 30;
      }
      
      public function get ItemsList() : Vector.<ItemData>
      {
         return this.m_itemsList;
      }
      
      public function get FullItemsList() : Vector.<ItemData>
      {
         return this.m_fullItemsList;
      }
      
      public function get ItemsInUse() : Vector.<Item>
      {
         return this.m_itemsInUse;
      }
      
      public function get CanMakeItem() : Boolean
      {
         return this.m_itemCount < this.MAXITEMS;
      }
      
      public function get SmashBallReady() : FrameTimer
      {
         return this.m_smashBallReady;
      }
      
      public function get CurrentSmashBall() : Item
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         while(_loc2_ < this.STAGEDATA.Characters.length)
         {
            if(Boolean(this.STAGEDATA.Characters[_loc2_].UsingFinalSmash) || Boolean(this.STAGEDATA.Characters[_loc2_].HasFinalSmash))
            {
               return null;
            }
            _loc2_++;
         }
         for(_loc1_ in this.m_itemsInUse)
         {
            if(this.m_itemsInUse[_loc1_] != null && this.m_itemsInUse[_loc1_].ItemStats.StatsName == "smashball")
            {
               return this.m_itemsInUse[_loc1_];
            }
         }
         return null;
      }
      
      public function get PlayerUsingSmashBall() : Character
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.STAGEDATA.Characters.length)
         {
            if(this.STAGEDATA.Characters[_loc1_].UsingFinalSmash)
            {
               return this.STAGEDATA.Characters[_loc1_];
            }
            _loc1_++;
         }
         return null;
      }
      
      public function get PlayerHasSmashBall() : Character
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.STAGEDATA.Characters.length)
         {
            if(this.STAGEDATA.Characters[_loc1_].HasFinalSmash)
            {
               return this.STAGEDATA.Characters[_loc1_];
            }
            _loc1_++;
         }
         return null;
      }
      
      public function get AssistClass() : Class
      {
         return this.m_assistClass;
      }
      
      public function set AssistClass(param1:Class) : void
      {
         this.m_assistClass = param1;
      }
      
      public function get PokemonClass() : Class
      {
         return this.m_pokemonClass;
      }
      
      public function set PokemonClass(param1:Class) : void
      {
         this.m_pokemonClass = param1;
      }
      
      public function addCustomItem(param1:ItemData) : void
      {
         this.m_itemsList.push(param1);
         this.m_fullItemsList.push(param1);
      }
      
      public function getItemData(param1:int) : Item
      {
         if(param1 >= 0 && param1 < this.MAXITEMS)
         {
            return this.m_itemsInUse[param1];
         }
         return null;
      }
      
      public function getItemByUID(param1:int) : Item
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.m_itemsInUse.length)
         {
            if(Boolean(this.m_itemsInUse[_loc2_]) && this.m_itemsInUse[_loc2_].UID == param1)
            {
               return this.m_itemsInUse[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getItemByMC(param1:MovieClip) : Item
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.m_itemsInUse.length)
         {
            if(Boolean(this.m_itemsInUse[_loc2_]) && (this.m_itemsInUse[_loc2_].MC == param1 || this.m_itemsInUse[_loc2_].Stance != null && this.m_itemsInUse[_loc2_].Stance == param1))
            {
               return this.m_itemsInUse[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function killItem(param1:Number) : void
      {
         if(this.m_itemsInUse[param1] != null)
         {
            this.m_itemsInUse[param1].destroy();
            this.m_itemsInUse[param1] = null;
            --this.m_itemCount;
         }
      }
      
      public function killAllItems() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.m_itemsInUse.length)
         {
            if(this.m_itemsInUse[_loc1_] != null)
            {
               this.m_itemsInUse[_loc1_].destroy();
               this.m_itemsInUse[_loc1_] = null;
            }
            _loc1_++;
         }
      }
      
      private function getItemTypes(param1:Object) : Vector.<ItemData>
      {
         return this.m_itemsList;
      }
      
      public function playGlobalSound(param1:String) : void
      {
         this.STAGEDATA.SoundQueueRef.playSoundEffect(param1);
      }
      
      private function checkSuddenDeathBombs() : void
      {
         var _loc1_:ItemData = null;
         var _loc2_:Item = null;
         if(Boolean(this.STAGEDATA.GameRef.SuddenDeath) && this.STAGEDATA.ElapsedFrames >= 60 * 10)
         {
            this.m_suddenDeathBombTimer.tick();
            if(this.m_suddenDeathBombTimer.IsComplete)
            {
               this.m_suddenDeathBombTimer.reset();
               _loc1_ = new ItemData();
               _loc1_.importData(ItemsListData.getItemByID("bobomb"));
               _loc2_ = this.generateItemObj(_loc1_);
               _loc2_.Toss(_loc2_.X,_loc2_.Y,0,0);
            }
         }
      }
      
      public function PERFORMALL() : void
      {
         this.checkSuddenDeathBombs();
         this.checkItem();
      }
   }
}


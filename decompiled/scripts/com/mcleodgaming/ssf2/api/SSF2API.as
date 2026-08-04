package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.enemies.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.items.*;
   import com.mcleodgaming.ssf2.menus.*;
   import com.mcleodgaming.ssf2.modes.CustomMode;
   import com.mcleodgaming.ssf2.platforms.BitmapCollisionBoundary;
   import com.mcleodgaming.ssf2.platforms.Platform;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.geom.*;
   
   public class SSF2API
   {
      
      private static var _api:StageData;
      
      public static const VERSION_MAJOR:int = 0;
      
      public static const VERSION_MINOR:int = 56;
      
      public static const VERSION_REVISION:int = 0;
      
      public function SSF2API()
      {
         super();
      }
      
      public static function init(param1:StageData) : void
      {
         _api = param1;
         trace("SSF2 API Interface Version " + SSF2API.VERSION_MAJOR + "." + SSF2API.VERSION_MINOR + "." + SSF2API.VERSION_REVISION + " has been initialized.");
      }
      
      public static function deinit() : void
      {
         _api = null;
         trace("SSF2 API Interface deactivated.");
      }
      
      public static function getAPIVersion() : String
      {
         return VERSION_MAJOR + "." + VERSION_MINOR + "." + VERSION_REVISION;
      }
      
      public static function signal(param1:int, param2:Object = null) : void
      {
      }
      
      public static function getUID() : int
      {
         return Utils.getUID();
      }
      
      public static function getPlayer(param1:*) : *
      {
         var _loc2_:MovieClip = null;
         var _loc3_:SSF2GameObject = null;
         var _loc4_:InteractiveSprite = null;
         if(!isReady())
         {
            return null;
         }
         var _loc5_:int = -1;
         if(param1 is MovieClip)
         {
            _loc2_ = MovieClip(param1);
            if(_loc2_.player_id != undefined)
            {
               _loc5_ = int(_loc2_.player_id);
            }
            else if(Boolean(_loc2_.parent) && Boolean(_loc2_.parent is MovieClip) && MovieClip(_loc2_.parent).player_id != undefined)
            {
               _loc5_ = int(MovieClip(_loc2_.parent).player_id);
            }
            else
            {
               _loc4_ = _api.getPlayerByMC(_loc2_);
            }
            if(_loc4_)
            {
               _loc3_ = _loc4_.APIInstance;
            }
         }
         else if(param1 is int || param1 is Number)
         {
            _loc5_ = param1;
         }
         else if(param1 is Character)
         {
            _loc5_ = int(Character(param1).ID);
         }
         if(_loc5_ > -1)
         {
            _loc3_ = _api.getPlayerByID(_loc5_).APIInstance;
         }
         return _loc3_ ? _loc3_.instance : null;
      }
      
      public static function getCharacter(param1:*) : *
      {
         var _loc2_:MovieClip = null;
         var _loc3_:SSF2GameObject = null;
         var _loc4_:InteractiveSprite = null;
         if(!isReady())
         {
            return null;
         }
         var _loc5_:int = -1;
         if(param1 is MovieClip)
         {
            _loc2_ = MovieClip(param1);
            if(_loc2_.uid != undefined)
            {
               _loc5_ = int(_loc2_.uid);
            }
            else if(Boolean(_loc2_.parent) && Boolean(_loc2_.parent is MovieClip) && MovieClip(_loc2_.parent).uid != undefined)
            {
               _loc5_ = int(MovieClip(_loc2_.parent).uid);
            }
            else
            {
               _loc4_ = _api.getCharacterByMC(_loc2_);
            }
            if(_loc4_)
            {
               _loc3_ = _loc4_.APIInstance;
            }
         }
         else if(param1 is int || param1 is Number)
         {
            _loc5_ = param1;
         }
         else if(param1 is Character)
         {
            _loc5_ = int(Character(param1).UID);
         }
         if(_loc5_ > -1)
         {
            _loc4_ = _api.getCharacterByUID(_loc5_);
            if(_loc4_)
            {
               _loc3_ = _loc4_.APIInstance;
            }
         }
         return _loc3_ ? _loc3_.instance : null;
      }
      
      public static function getPlayers() : Array
      {
         var _loc2_:int = 0;
         if(!isReady())
         {
            return [];
         }
         var _loc1_:Array = [];
         while(_loc2_ < _api.Players.length)
         {
            if(_api.Players[_loc2_])
            {
               _loc1_.push(_api.Players[_loc2_].APIInstance.instance);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public static function getCharacters() : Array
      {
         var _loc2_:int = 0;
         if(!isReady())
         {
            return [];
         }
         var _loc1_:Array = [];
         while(_loc2_ < _api.Characters.length)
         {
            _loc1_.push(_api.Characters[_loc2_].APIInstance.instance);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public static function getProjectile(param1:*) : *
      {
         var _loc2_:MovieClip = null;
         var _loc3_:SSF2GameObject = null;
         var _loc4_:InteractiveSprite = null;
         if(!isReady())
         {
            return null;
         }
         var _loc5_:int = -1;
         if(param1 is MovieClip)
         {
            _loc2_ = MovieClip(param1);
            if(_loc2_.uid != undefined)
            {
               _loc5_ = int(_loc2_.uid);
            }
            else if(Boolean(_loc2_.parent) && Boolean(_loc2_.parent is MovieClip) && MovieClip(_loc2_.parent).uid != undefined)
            {
               _loc5_ = int(MovieClip(_loc2_.parent).uid);
            }
            else
            {
               _loc4_ = _api.getProjectileByMC(_loc2_);
            }
            if(_loc4_)
            {
               _loc3_ = _loc4_.APIInstance;
            }
         }
         else if(param1 is int || param1 is Number)
         {
            _loc5_ = param1;
         }
         else if(param1 is Projectile)
         {
            _loc5_ = int(Projectile(param1).UID);
         }
         if(_loc5_ > -1)
         {
            _loc4_ = _api.getProjectile(_loc5_);
            if(_loc4_)
            {
               _loc3_ = _loc4_.APIInstance;
            }
         }
         return _loc3_ ? _loc3_.instance : null;
      }
      
      public static function getProjectiles() : Array
      {
         var _loc3_:int = 0;
         if(!isReady())
         {
            return [];
         }
         var _loc1_:Array = new Array();
         var _loc2_:Vector.<Projectile> = _api.getProjectiles();
         while(_loc3_ < _loc2_.length)
         {
            if(Boolean(_loc2_[_loc3_]) && Boolean(_loc2_[_loc3_].APIInstance) && Boolean(_loc2_[_loc3_].APIInstance.instance))
            {
               _loc1_.push(_loc2_[_loc3_].APIInstance.instance);
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public static function getItem(param1:*) : *
      {
         var _loc2_:MovieClip = null;
         var _loc3_:SSF2GameObject = null;
         var _loc4_:InteractiveSprite = null;
         if(!isReady())
         {
            return null;
         }
         var _loc5_:int = -1;
         if(param1 is MovieClip)
         {
            _loc2_ = MovieClip(param1);
            if(_loc2_.uid != undefined)
            {
               _loc5_ = int(_loc2_.uid);
            }
            else if(Boolean(_loc2_.parent) && Boolean(_loc2_.parent is MovieClip) && MovieClip(_loc2_.parent).uid != undefined)
            {
               _loc5_ = int(MovieClip(_loc2_.parent).uid);
            }
            else
            {
               _loc4_ = _api.getItemByMC(_loc2_);
            }
            if(_loc4_)
            {
               _loc3_ = _loc4_.APIInstance;
            }
         }
         else if(param1 is int || param1 is Number)
         {
            _loc5_ = param1;
         }
         else if(param1 is Item)
         {
            _loc5_ = int(Item(param1).UID);
         }
         if(_loc5_ > -1)
         {
            _loc4_ = _api.getItem(_loc5_);
            if(_loc4_)
            {
               _loc3_ = _loc4_.APIInstance;
            }
         }
         return _loc3_ ? _loc3_.instance : null;
      }
      
      public static function getItems() : Array
      {
         var _loc2_:int = 0;
         if(!isReady())
         {
            return [];
         }
         var _loc1_:Array = [];
         while(_loc2_ < _api.ItemsRef.ItemsInUse.length)
         {
            if(Boolean(_api.ItemsRef.ItemsInUse[_loc2_]) && Boolean(_api.ItemsRef.ItemsInUse[_loc2_].APIInstance))
            {
               _loc1_.push(_api.ItemsRef.ItemsInUse[_loc2_].APIInstance.instance);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public static function getEnemy(param1:*) : *
      {
         var _loc2_:MovieClip = null;
         var _loc3_:SSF2GameObject = null;
         var _loc4_:InteractiveSprite = null;
         if(!isReady())
         {
            return null;
         }
         var _loc5_:int = -1;
         if(param1 is MovieClip)
         {
            _loc2_ = MovieClip(param1);
            if(_loc2_.uid != undefined)
            {
               _loc5_ = int(_loc2_.uid);
            }
            else if(Boolean(_loc2_.parent) && Boolean(_loc2_.parent is MovieClip) && MovieClip(_loc2_.parent).uid != undefined)
            {
               _loc5_ = int(MovieClip(_loc2_.parent).uid);
            }
            else
            {
               _loc4_ = _api.getEnemyByMC(_loc2_);
            }
            if(_loc4_)
            {
               _loc3_ = _loc4_.APIInstance;
            }
         }
         else if(param1 is int || param1 is Number)
         {
            _loc5_ = param1;
         }
         else if(param1 is Enemy)
         {
            _loc5_ = int(Enemy(param1).UID);
         }
         else if(param1 is String)
         {
            _loc4_ = _api.getEnemyByInstanceName(param1);
            if(_loc4_)
            {
               _loc3_ = _loc4_.APIInstance;
            }
         }
         if(_loc5_ > -1)
         {
            _loc4_ = _api.getEnemy(_loc5_);
            if(_loc4_)
            {
               _loc3_ = _loc4_.APIInstance;
            }
         }
         return _loc3_ ? _loc3_.instance : null;
      }
      
      public static function getEnemies() : Array
      {
         var _loc2_:int = 0;
         var _loc1_:Array = new Array();
         while(_loc2_ < _api.Enemies.length)
         {
            _loc1_.push(_api.Enemies[_loc2_].APIInstance.instance);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public static function getTarget(param1:*) : *
      {
         var _loc2_:MovieClip = null;
         var _loc3_:SSF2GameObject = null;
         var _loc4_:InteractiveSprite = null;
         if(!isReady())
         {
            return null;
         }
         var _loc5_:int = -1;
         if(param1 is MovieClip)
         {
            _loc2_ = MovieClip(param1);
            if(_loc2_.uid != undefined)
            {
               _loc5_ = int(_loc2_.uid);
            }
            else if(Boolean(_loc2_.parent) && Boolean(_loc2_.parent is MovieClip) && MovieClip(_loc2_.parent).uid != undefined)
            {
               _loc5_ = int(MovieClip(_loc2_.parent).uid);
            }
            else
            {
               _loc4_ = _api.getTargetByMC(_loc2_);
            }
            if(_loc4_)
            {
               _loc3_ = _loc4_.APIInstance;
            }
         }
         else if(param1 is int || param1 is Number)
         {
            _loc5_ = param1;
         }
         else if(param1 is TargetTestTarget)
         {
            _loc5_ = int(TargetTestTarget(param1).UID);
         }
         if(_loc5_ > -1)
         {
            _loc4_ = _api.getTargetByUID(_loc5_);
            if(_loc4_)
            {
               _loc3_ = _loc4_.APIInstance;
            }
         }
         return _loc3_ ? _loc3_.instance : null;
      }
      
      public static function getTargets() : Array
      {
         var _loc2_:int = 0;
         if(!isReady())
         {
            return [];
         }
         var _loc1_:Array = [];
         while(_loc2_ < _api.Targets.length)
         {
            if(Boolean(_api.Targets[_loc2_]) && Boolean(_api.Targets[_loc2_].APIInstance))
            {
               _loc1_.push(_api.Targets[_loc2_].APIInstance.instance);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public static function getStage() : *
      {
         if(!isReady())
         {
            return null;
         }
         return _api.APIInstance.instance;
      }
      
      public static function getCollisionBoundary(param1:*) : *
      {
         var _loc2_:BitmapCollisionBoundary = null;
         if(!isReady())
         {
            return null;
         }
         if(param1 is MovieClip)
         {
            _loc2_ = _api.getCollisionBoundaryByMC(param1);
         }
         else if(param1 is String)
         {
            _loc2_ = _api.getCollisionBoundaryByInstanceName(param1);
         }
         return Boolean(_loc2_) && Boolean(_loc2_.APIInstance) ? _loc2_.APIInstance.instance : null;
      }
      
      public static function getPlatform(param1:*) : *
      {
         var _loc2_:Platform = null;
         if(!isReady())
         {
            return null;
         }
         if(param1 is MovieClip)
         {
            _loc2_ = _api.getPlatformByMC(param1);
         }
         else if(param1 is String)
         {
            _loc2_ = _api.getPlatformByInstanceName(param1);
         }
         return Boolean(_loc2_) && Boolean(_loc2_.APIInstance) ? _loc2_.APIInstance.instance : null;
      }
      
      public static function getPlatforms(param1:Object = null) : Array
      {
         var _loc3_:int = 0;
         param1 ||= {};
         param1.terrains = typeof param1.terrains !== "undefined" ? param1.terrains : true;
         param1.platforms = typeof param1.platforms !== "undefined" ? param1.platforms : true;
         if(!isReady())
         {
            return [];
         }
         var _loc2_:Array = [];
         if(param1.terrains)
         {
            _loc3_ = 0;
            while(_loc3_ < _api.Terrains.length)
            {
               if(_api.Terrains[_loc3_].APIInstance)
               {
                  _loc2_.push(_api.Terrains[_loc3_].APIInstance.instance);
               }
               _loc3_++;
            }
         }
         if(param1.platforms)
         {
            _loc3_ = 0;
            while(_loc3_ < _api.Platforms.length)
            {
               if(_api.Platforms[_loc3_].APIInstance)
               {
                  _loc2_.push(_api.Platforms[_loc3_].APIInstance.instance);
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public static function getPlatformBetweenPoints(param1:Point, param2:Point, param3:Object) : *
      {
         var _loc4_:Platform = _api.getPlatformBetweenPoints(param1,param2,param3);
         return Boolean(_loc4_) && Boolean(_loc4_.APIInstance) ? _loc4_.APIInstance.instance : null;
      }
      
      public static function getCamBounds() : MovieClip
      {
         if(!isReady())
         {
            return null;
         }
         return _api.getCamBounds();
      }
      
      public static function getDeathBounds() : MovieClip
      {
         if(!isReady())
         {
            return null;
         }
         return _api.getDeathBounds();
      }
      
      public static function hitTestGround(param1:Number, param2:Number, param3:Object = null) : *
      {
         var platform:Platform;
         var x:Number = param1;
         var y:Number = param2;
         var options:Object = param3;
         if(!isReady())
         {
            return null;
         }
         options ||= {};
         options.terrain = typeof options.terrain !== "undefined" ? options.terrain : true;
         options.platforms = typeof options.platforms !== "undefined" ? options.platforms : true;
         options.ignoreFallthrough = typeof options.ignoreFallthrough !== "undefined" ? options.ignoreFallthrough : false;
         options.ignoreList = options.ignoreList || [];
         if(options.ignoreList)
         {
            options.ignoreList = options.ignoreList.map(function(param1:*, param2:int, param3:Array):*
            {
               return param1.$ext.getAPI().owner;
            });
         }
         else
         {
            options.ignoreList = [];
         }
         platform = _api.testGroundWithCoord(x,y,options);
         if(Boolean(platform) && Boolean(platform.APIInstance))
         {
            return platform.APIInstance.instance;
         }
         return null;
      }
      
      public static function hitTestGroundBetweenPoints(param1:Point, param2:Point, param3:Object = null) : *
      {
         var platform:Platform;
         var p1:Point = param1;
         var p2:Point = param2;
         var options:Object = param3;
         if(!isReady())
         {
            return null;
         }
         options ||= {};
         options.terrain = typeof options.terrain !== "undefined" ? options.terrain : true;
         options.platforms = typeof options.platforms !== "undefined" ? options.platforms : true;
         options.ignoreFallthrough = typeof options.ignoreFallthrough !== "undefined" ? options.ignoreFallthrough : false;
         options.ignoreList = options.ignoreList || [];
         if(options.ignoreList)
         {
            options.ignoreList = options.ignoreList.map(function(param1:*, param2:int, param3:Array):*
            {
               return param1.$ext.getAPI().owner;
            });
         }
         else
         {
            options.ignoreList = [];
         }
         platform = _api.checkLinearPathBetweenPoints(p1,p2,options);
         if(Boolean(platform) && Boolean(platform.APIInstance))
         {
            return platform.APIInstance.instance;
         }
         return null;
      }
      
      public static function lightFlash(param1:Boolean = true) : void
      {
         if(!isReady())
         {
            return;
         }
         _api.lightFlash(param1);
      }
      
      public static function setCamStageFocus(param1:int) : void
      {
         if(!isReady())
         {
            return;
         }
         _api.CamRef.setStageFocus(param1);
      }
      
      public static function removeCamStageFocus() : void
      {
         if(!isReady())
         {
            return;
         }
         _api.CamRef.removeStageFocus();
      }
      
      public static function print(param1:String) : void
      {
         if(Boolean(Main.DEBUG) && Boolean(MenuController.debugConsole))
         {
            MenuController.debugConsole.writeTextData(param1);
            trace(param1);
         }
      }
      
      public static function addEventListener(param1:String, param2:Function, param3:Object = null) : void
      {
         if(!isReady())
         {
            return;
         }
         _api.addEventListener(param1,param2,param3);
      }
      
      public static function hasEventListener(param1:String, param2:Function = null) : Boolean
      {
         return _api.hasEventListener(param1,param2);
      }
      
      public static function removeEventListener(param1:String, param2:Function) : void
      {
         if(!isReady())
         {
            return;
         }
         _api.removeEventListener(param1,param2);
      }
      
      public static function playMusic(param1:String, param2:int) : void
      {
         SoundQueue.instance.playMusic(param1,param2);
      }
      
      public static function stopMusic() : void
      {
         SoundQueue.instance.stopMusic();
      }
      
      public static function getCurrentMusicInfo() : Object
      {
         return {
            "linkage":SoundQueue.instance.CurrentSongID,
            "loop":SoundQueue.instance.LoopLocation,
            "position":(SoundQueue.instance.CurrentSong ? SoundQueue.instance.CurrentSong.position : -1)
         };
      }
      
      public static function playSound(param1:*, param2:Boolean = false) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:SoundObject = null;
         if(param1 is Array)
         {
            return SoundQueue.instance.playChainedAudio(param1,param2);
         }
         if(param2)
         {
            return SoundQueue.instance.playVoiceEffect(param1);
         }
         return SoundQueue.instance.playSoundEffect(param1);
      }
      
      public static function stopSound(param1:int) : void
      {
         SoundQueue.instance.stopSound(param1);
      }
      
      public static function shakeCamera(param1:int) : void
      {
         if(!isReady())
         {
            return;
         }
         _api.shakeCamera(param1);
      }
      
      public static function matchGo() : void
      {
         if(!isReady())
         {
            return;
         }
         if(_api.StageEvent)
         {
            _api.StageEvent = false;
            if(_api.GameRef.UsingTime)
            {
               _api.TimerRef.Start();
            }
         }
      }
      
      public static function matchGoComplete() : void
      {
         if(!isReady())
         {
            return;
         }
         if(Boolean(_api.HudRef) && Boolean(_api.GameRef.HudDisplay))
         {
            _api.HudRef.toggleMainDisplay(true);
         }
         if(_api.GameRef.UsingTime)
         {
            _api.TimerRef.TimeMC.visible = true;
         }
      }
      
      public static function random() : Number
      {
         if(!isReady())
         {
            return 0;
         }
         return Utils.random();
      }
      
      public static function randomInteger(param1:int, param2:int) : int
      {
         if(!isReady())
         {
            return 0;
         }
         return Utils.randomInteger(param1,param2);
      }
      
      public static function safeRandom() : Number
      {
         if(!isReady())
         {
            return 0;
         }
         return Utils.safeRandom();
      }
      
      public static function safeRandomInteger(param1:int, param2:int) : int
      {
         if(!isReady())
         {
            return 0;
         }
         return Utils.safeRandomInteger(param1,param2);
      }
      
      public static function fixBG() : void
      {
         if(!isReady())
         {
            return;
         }
         _api.fixBG();
      }
      
      public static function attachEffect(param1:*, param2:Object = null) : MovieClip
      {
         return _api.attachEffect(param1,param2);
      }
      
      public static function attachEffectOverlay(param1:*, param2:Object = null) : MovieClip
      {
         return _api.attachEffectOverlay(param1,param2);
      }
      
      public static function calculateChargeDamage(param1:Object) : Number
      {
         return _api.calculateChargeDamage(param1);
      }
      
      public static function calculateSelfHitStun(param1:Number, param2:Number) : Number
      {
         return Utils.calculateSelfHitStun(param1,param2);
      }
      
      public static function calculateKnockback(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Boolean) : Number
      {
         return Utils.calculateKnockback(param1,param2,param3,param4,param5,param6,param7,_api.GameRef.DamageRatio,1);
      }
      
      public static function calculateKnockbackVelocity(param1:Number) : Number
      {
         return Utils.calculateVelocity(param1);
      }
      
      public static function getTimestamp() : Date
      {
         return _api.getTimestamp();
      }
      
      public static function isHazardsOn() : Boolean
      {
         return Boolean(_api) && Boolean(_api.HazardsOn);
      }
      
      public static function generateItem(param1:String, param2:Number, param3:Number, param4:Boolean = false) : *
      {
         if(!isReady())
         {
            return null;
         }
         return _api.generateItemAPI(param1,param2,param3,param4);
      }
      
      public static function getRandomAssist() : Class
      {
         if(!isReady())
         {
            return null;
         }
         return _api.getRandomAssist();
      }
      
      public static function getRandomPokemon() : Class
      {
         if(!isReady())
         {
            return null;
         }
         return _api.getRandomPokemon();
      }
      
      public static function spawnAssist(param1:Class, param2:* = null) : *
      {
         if(!param1)
         {
            throw new Error("Error, could not spawn unspecified Assist class");
         }
         if(!isReady())
         {
            return null;
         }
         return _api.spawnAssistAPI(param1,param2 ? param2.$ext.getAPI().owner : null).APIInstance.instance;
      }
      
      public static function spawnPokemon(param1:Class, param2:* = null) : *
      {
         if(!param1)
         {
            throw new Error("Error, could not spawn unspecified Pokemon class");
         }
         if(!isReady())
         {
            return null;
         }
         return _api.spawnPokemonAPI(param1,param2 ? param2.$ext.getAPI().owner : null).APIInstance.instance;
      }
      
      public static function spawnCharacter(param1:Class) : *
      {
         if(!param1)
         {
            throw new Error("Error, could not spawn unspecified Character class");
         }
         return _api.spawnCharacterAPI(param1).APIInstance.instance;
      }
      
      public static function spawnEnemy(param1:*) : *
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         if(!param1)
         {
            throw new Error("Error, could not spawn unspecified Enemy class");
         }
         if(param1 is Class)
         {
            return _api.spawnEnemyAPI(param1).APIInstance.instance;
         }
         if(param1 is String)
         {
            _loc2_ = ResourceManager.getResourceByID("enemies").getProp("metadata").enemy_list;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               if(_loc2_[_loc3_].name === param1)
               {
                  return _api.spawnEnemyAPI(_loc2_[_loc3_].classAPI).APIInstance.instance;
               }
               _loc3_++;
            }
         }
         return null;
      }
      
      public static function spawnItem(param1:Class) : *
      {
         if(!param1)
         {
            throw new Error("Error, could not spawn unspecified Item class");
         }
         return _api.spawnItemAPI(param1).APIInstance.instance;
      }
      
      public static function spawnProjectile(param1:Class, param2:* = null) : *
      {
         if(!param1)
         {
            throw new Error("Error, could not spawn unspecified Projectile class");
         }
         return _api.spawnProjectileAPI(param1,param2 ? param2.$ext.getAPI().owner : null).APIInstance.instance;
      }
      
      public static function spawnCollisionBoundary(param1:Class) : *
      {
         if(!param1)
         {
            throw new Error("Error, could not spawn unspecified CollisionBoundary class");
         }
         return _api.spawnCollisionBoundaryAPI(param1).APIInstance.instance;
      }
      
      public static function spawnPlatform(param1:Class, param2:Boolean = true) : *
      {
         if(!param1)
         {
            throw new Error("Error, could not spawn unspecified Platform class");
         }
         return _api.spawnPlatformAPI(param1,param2).APIInstance.instance;
      }
      
      public static function hitboxTest(param1:*, param2:uint, param3:*, param4:uint) : Array
      {
         var _loc5_:int = 0;
         var _loc6_:InteractiveSprite = param1 ? param1.$ext.getAPI().owner : null;
         var _loc7_:InteractiveSprite = param3 ? param3.$ext.getAPI().owner : null;
         var _loc8_:Vector.<HitBoxCollisionResult> = InteractiveSprite.hitTest(_loc6_,_loc7_,param2,param4);
         var _loc9_:Array = [];
         if(_loc8_)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc8_.length)
            {
               _loc9_.push(_loc8_[_loc5_].OverlapHitBox.BoundingBox.clone());
               _loc5_++;
            }
         }
         return _loc9_;
      }
      
      public static function getQualitySettings() : Object
      {
         return _api.getQualitySettings();
      }
      
      public static function isReady() : Boolean
      {
         return Boolean(_api) && Boolean(_api.ActiveScripts);
      }
      
      public static function currentActiveFinalSmash() : *
      {
         var _loc1_:Character = _api.ItemsRef.PlayerUsingSmashBall;
         return Boolean(_loc1_) && Boolean(_loc1_.APIInstance) ? _loc1_.APIInstance.instance : null;
      }
      
      public static function getSmashBallInstance() : *
      {
         var _loc1_:Item = _api.ItemsRef.CurrentSmashBall;
         return Boolean(_loc1_) && Boolean(_loc1_.APIInstance) ? _loc1_.APIInstance.instance : null;
      }
      
      public static function enableSmashBallSpawn(param1:Boolean) : void
      {
         _api.ItemsRef.SmashBallDisabled = param1;
      }
      
      public static function isSmashBallSpawnEnabled() : Boolean
      {
         return _api.ItemsRef.SmashBallDisabled;
      }
      
      public static function isDebug() : Boolean
      {
         return Main.DEBUG;
      }
      
      public static function addHUDDetection(param1:MovieClip) : void
      {
         _api.HudRef.addHUDDetection(param1);
      }
      
      public static function removeHUDDetection(param1:MovieClip) : void
      {
         _api.HudRef.removeHUDDetection(param1);
      }
      
      public static function addTimedCameraTarget(param1:*, param2:int) : void
      {
         if(param1 is MovieClip)
         {
            _api.CamRef.addTimedTarget(param1,param2);
         }
         else if(param1 is Point)
         {
            _api.CamRef.addTimedTargetPoint(param1,param2);
         }
         else if("$ext" in param1 && param1.$ext.getAPI().owner is InteractiveSprite)
         {
            _api.CamRef.addTimedTarget(InteractiveSprite(param1).MC,param2);
         }
      }
      
      public static function removeTimedCameraTarget(param1:*) : void
      {
         if(param1 is MovieClip)
         {
            _api.CamRef.deleteTimedTarget(param1);
         }
         else if(param1 is Point)
         {
            _api.CamRef.deleteTimedTargetPoint(param1);
         }
         else if("$ext" in param1 && param1.$ext.getAPI().owner is InteractiveSprite)
         {
            _api.CamRef.deleteTimedTarget(InteractiveSprite(param1).MC);
         }
      }
      
      public static function hasFeature(param1:uint) : Boolean
      {
         if(!isReady())
         {
            return false;
         }
         return ModeFeatures.hasFeature(param1,_api.GameRef.GameMode);
      }
      
      public static function getItemFrequency() : int
      {
         if(!isReady())
         {
            return ItemSettings.FREQUENCY_OFF;
         }
         return _api.ItemsRef.Frequency;
      }
      
      public static function setItemFrequency(param1:int) : void
      {
         if(!isReady())
         {
            return;
         }
         _api.ItemsRef.Frequency = param1;
      }
      
      public static function addCustomItem(param1:Object) : void
      {
         if(!isReady())
         {
            return;
         }
         var _loc2_:ItemData = new ItemData();
         _loc2_.importData(param1);
         _api.ItemsRef.addCustomItem(_loc2_);
      }
      
      public static function getAvailableItemList() : Array
      {
         var _loc3_:int = 0;
         var _loc1_:Vector.<ItemData> = _api.ItemsRef.ItemsList;
         var _loc2_:Array = [];
         while(_loc3_ < _loc1_.length)
         {
            if(Boolean(_loc1_[_loc3_]) && Boolean(_loc1_[_loc3_].ClassAPI))
            {
               _loc2_.push(_loc1_[_loc3_].ClassAPI);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function getMatchSettings() : Object
      {
         if(!isReady())
         {
            return {};
         }
         return _api.GameRef.LevelData.exportSettings();
      }
      
      public static function getGameSettings() : Object
      {
         if(!isReady())
         {
            return null;
         }
         return _api.GameRef.exportSettings();
      }
      
      public static function getElapsedFrames() : int
      {
         if(!isReady())
         {
            return 0;
         }
         return _api.ElapsedPlayableFrames;
      }
      
      public static function generateUID() : int
      {
         if(!isReady())
         {
            return 0;
         }
         return Utils.getUID();
      }
      
      public static function getRandomItemSpawnLocation() : Point
      {
         if(!isReady())
         {
            return null;
         }
         return _api.ItemsRef.getRandomLocation();
      }
      
      public static function isFSCutscenePlaying() : Boolean
      {
         if(!isReady())
         {
            return false;
         }
         return _api.FSCutscene ? true : false;
      }
      
      public static function createCustomMatch(param1:Class, param2:*, param3:Object) : *
      {
         var _loc4_:Game = new Game();
         _loc4_.importSettings(param3);
         _loc4_.CustomModeObj = param2.$ext.getAPI().owner;
         var _loc5_:CustomMatch = new CustomMatch(_loc4_,{"classAPI":param1});
         return _loc5_.APIInstance.instance;
      }
      
      public static function createCustomMenu(param1:Class) : *
      {
         var _loc2_:CustomAPIMenu = new CustomAPIMenu({"classAPI":param1});
         return _loc2_.APIInstance.instance;
      }
      
      public static function getRandomCharacterID(param1:Boolean = true) : String
      {
         return Stats.getRandomCharacter(param1).StatsName;
      }
      
      public static function getRandomStageID(param1:Boolean = true, param2:Boolean = true) : String
      {
         return StageSetting.getRandomStage(false,!param2);
      }
      
      public static function isGameStarted() : Boolean
      {
         if(!isReady())
         {
            return false;
         }
         return !_api.StageEvent;
      }
      
      public static function isGameEnded() : Boolean
      {
         return _api.GameEnded;
      }
      
      public static function endGame(param1:Object = null) : void
      {
         if(!isReady())
         {
            return;
         }
         _api.prepareEndGameCustom(param1);
      }
      
      public static function getMCByLinkageName(param1:String) : MovieClip
      {
         return ResourceManager.getLibraryMC(param1);
      }
      
      public static function getCharacterStats(param1:String) : Object
      {
         var _loc2_:CharacterData = Stats.getStats(param1);
         if(_loc2_)
         {
            return _loc2_.exportData();
         }
         return null;
      }
      
      public static function queueResources(param1:Array) : void
      {
         ResourceManager.queueResources(param1);
      }
      
      public static function loadResources(param1:Object) : void
      {
         ResourceManager.load(param1);
      }
      
      public static function getGameTimer() : *
      {
         return _api.TimerRef.APIInstance;
      }
      
      public static function getCamera() : *
      {
         return _api.CamRef.APIInstance;
      }
      
      public static function freezeInputs(param1:Boolean) : void
      {
         _api.FreezeKeys = param1;
      }
      
      public static function getItemStatsList(param1:Boolean = true, param2:Boolean = true) : Array
      {
         return ItemsListData.getItemStatsList(param1,param2);
      }
      
      public static function getRandomItemStats(param1:Boolean = true, param2:Boolean = true) : Object
      {
         return ItemsListData.getRandomItemStats(param1,param2);
      }
      
      public static function getAverageFPS() : Number
      {
         if(!isReady())
         {
            return 0;
         }
         return _api.getFPS();
      }
      
      public static function setFrameRate(param1:Number) : void
      {
         if(!isReady() || Boolean(_api.GameEnded))
         {
            return;
         }
         Main.Root.stage.frameRate = param1;
      }
      
      public static function getAssistTrophyStatsList(param1:String = "common") : Array
      {
         var _loc4_:int = 0;
         var _loc2_:Array = ResourceManager.getAssistStatsData()[param1];
         var _loc3_:Array = [];
         while(_loc4_ < _loc2_.length)
         {
            _loc3_.push(_loc2_[_loc4_]);
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function getPokemonStatsList(param1:String = "common") : Array
      {
         var _loc4_:int = 0;
         var _loc2_:Array = ResourceManager.getPokemonStatsData()[param1];
         var _loc3_:Array = [];
         while(_loc4_ < _loc2_.length)
         {
            _loc3_.push(_loc2_[_loc4_]);
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function getGlobalVar(param1:String) : *
      {
         return DebugConsole.globalHash[param1];
      }
      
      public static function setGlobalVar(param1:String, param2:*) : void
      {
         DebugConsole.globalHash[param1] = param2;
      }
      
      public static function getSnapshot(param1:Object = null) : BitmapData
      {
         Main.Root.graphics.beginFill(0,1);
         Main.Root.graphics.drawRect(0,0,Main.Width,Main.Height);
         _api.HudRef.Container.alpha = 0;
         var _loc2_:BitmapData = _api.getSnapshot(param1);
         _api.HudRef.Container.alpha = 1;
         Main.Root.graphics.clear();
         return _loc2_;
      }
      
      public static function getTargetTestSaveData(param1:String, param2:String) : Object
      {
         return SaveData.getTargetTestData(param1,param2);
      }
      
      public static function getManifest() : Object
      {
         return Utils.cloneObject(ResourceManager.manifestJSONData);
      }
      
      public static function getCustomMode() : *
      {
         var _loc1_:CustomMode = _api.GameRef.CustomModeObj;
         if(_loc1_)
         {
            return _loc1_.APIInstance.instance;
         }
         return null;
      }
      
      public static function getGameMode() : int
      {
         if(!isReady())
         {
            return Mode.NULL;
         }
         return _api.GameRef.GameMode;
      }
      
      public static function getCustomMatch() : *
      {
         var _loc1_:CustomMatch = _api.GameRef.CustomMatchObj;
         if(_loc1_)
         {
            return _loc1_.APIInstance.instance;
         }
         return null;
      }
      
      public static function getUnlockableData() : Object
      {
         return isReady() ? Utils.cloneObject(_api.GameRef.LevelData.unlocks) : Utils.cloneObject(SaveData.Unlocks);
      }
      
      public static function triggerUnlock(param1:String) : Boolean
      {
         var _loc2_:Unlockable = UnlockController.getUnlockableByID(param1);
         if(_loc2_)
         {
            _loc2_.TriggerUnlock = true;
            return true;
         }
         return false;
      }
      
      public static function getCostumeData(param1:String, param2:int, param3:int = -1) : Object
      {
         return ResourceManager.getCostume(param1,Utils.getColorString(param2),param3);
      }
      
      public static function getMetalCostume(param1:String) : Object
      {
         return ResourceManager.getMetalCostume(param1);
      }
      
      public static function getWinners() : Array
      {
         if(!isReady())
         {
            return null;
         }
         return _api.getWinners();
      }
      
      public static function getLosers() : Array
      {
         if(!isReady())
         {
            return null;
         }
         return _api.getLosers();
      }
   }
}


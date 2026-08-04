package com.mcleodgaming.ssf2.util
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.api.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.sbxmod.paletteMaker.*;
   import flash.display.*;
   import flash.media.*;
   import flash.utils.*;
   
   public class ResourceManager
   {
      
      private static var _isFinishedInterval:uint;
      
      private static var _loadOptions:Object;
      
      private static var _loadIndex:int;
      
      private static const manifestJSON:Class = ResourceManager_manifestJSON;
      
      public static const manifestJSONData:Object = JSON.parse(Base64.decode(new String(new ResourceManager.manifestJSON())));
      
      public static const FN_PATTERN:RegExp = /(.*?)\((.*?)\)/g;
      
      public static const LOAD_DELAY:int = 50;
      
      public static var pool:Vector.<Resource> = new Vector.<Resource>();
      
      public static var poolHash:Object = {};
      
      public static var resources:Vector.<Resource> = new Vector.<Resource>();
      
      public static var resourcesHash:Object = {};
      
      public static var queue:Vector.<Resource> = new Vector.<Resource>();
      
      public static var queueHash:Object = {};
      
      public static var multimode:Boolean = true;
      
      public static var optimizeMemory:Boolean = true;
      
      public static var FORCE_ENABLE_ALT_TRACKS:Boolean = false;
      
      public static var DISABLE_MUSIC_AUTO_LOAD:Boolean = false;
      
      public static var resourceCache:Object = {};
      
      private static var m_expansionData:Vector.<Vector.<Object>> = new Vector.<Vector.<Object>>();
      
      private static var m_expansionCostumeData:Array = new Array();
      
      private static var m_expansionMetalCostumeData:Array = new Array();
      
      public function ResourceManager()
      {
         super();
      }
      
      public static function init() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:String = null;
         var _loc4_:Object = null;
         var _loc6_:Resource = null;
         var _loc7_:Resource = null;
         var _loc3_:Object = ResourceManager.manifestJSONData;
         var _loc5_:Resource = new Resource("menu_news",null,null,"dfc43fc4-2d45-49c3-bb3c-8c05be73ec81",Resource.MENU);
         addResource(_loc5_);
         for(_loc1_ in _loc3_.character)
         {
            _loc4_ = _loc3_.character[_loc1_];
            addResource(new Resource(_loc1_,_loc4_.file,_loc4_.file_pub,_loc4_.guid,Resource.CHARACTER));
         }
         for(_loc1_ in _loc3_.stage)
         {
            _loc4_ = _loc3_.stage[_loc1_];
            addResource(new Resource(_loc1_,_loc4_.file,_loc4_.file_pub,_loc4_.guid,Resource.STAGE));
         }
         for(_loc1_ in _loc3_.misc)
         {
            _loc4_ = _loc3_.misc[_loc1_];
            addResource(new Resource(_loc1_,_loc4_.file,_loc4_.file_pub,_loc4_.guid,Resource.MISC));
         }
         for(_loc1_ in _loc3_.extra)
         {
            _loc4_ = _loc3_.extra[_loc1_];
            addResource(new Resource(_loc1_,_loc4_.file,_loc4_.file_pub,_loc4_.guid,Resource.EXTRA));
         }
         for(_loc1_ in _loc3_.menu)
         {
            _loc4_ = _loc3_.menu[_loc1_];
            addResource(new Resource(_loc1_,_loc4_.file,_loc4_.file_pub,_loc4_.guid,Resource.MENU));
         }
         for(_loc1_ in _loc3_.audio)
         {
            _loc4_ = _loc3_.audio[_loc1_];
            addResource(new Resource(_loc1_,_loc4_.file,_loc4_.file_pub,_loc4_.guid,Resource.AUDIO));
         }
         for(_loc1_ in _loc3_.music)
         {
            _loc4_ = _loc3_.music[_loc1_];
            addResource(new Resource(_loc1_,_loc4_.file,_loc4_.file_pub,_loc4_.guid,Resource.MUSIC));
         }
         for(_loc1_ in _loc3_.modes)
         {
            _loc4_ = _loc3_.modes[_loc1_];
            addResource(new Resource(_loc1_,_loc4_.file,_loc4_.file_pub,_loc4_.guid,Resource.MODE));
         }
         for(_loc1_ in _loc3_.character_xp)
         {
            _loc4_ = _loc3_.character_xp[_loc1_];
            _loc6_ = new Resource(_loc1_,_loc4_.file,_loc4_.file_pub,_loc4_.guid,Resource.CHARACTER_EXPANSION);
            _loc6_.SoftFail = true;
            addResource(_loc6_);
         }
         for(_loc1_ in _loc3_.stage_xp)
         {
            _loc4_ = _loc3_.stage_xp[_loc1_];
            _loc6_ = new Resource(_loc1_,_loc4_.file,_loc4_.file_pub,_loc4_.guid,Resource.STAGE_EXPANSION);
            _loc6_.SoftFail = true;
            addResource(_loc6_);
         }
         _loc2_ = Math.random().toString().replace(/\./g,"");
         _loc5_.SoftFail = true;
         _loc5_.UrlOverride = "https://www.supersmashflash.com/flash?f=games/ssf2news121.swf&" + _loc2_;
         _loc7_ = new Resource("vcontent","menu_palette_maker.ssf","menu_palette_maker.ssf","67fbc775-2290-45d4-bb43-d02b5d48705f",Resource.MENU);
         addResource(_loc7_);
      }
      
      public static function get TotalExpansions() : Number
      {
         return m_expansionData.length;
      }
      
      public static function clearResourceCache() : void
      {
         ResourceManager.resourceCache = {};
      }
      
      private static function cacheLibrary(param1:Resource) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Object = param1.getProp("resources");
         if(param1.getProp("audio"))
         {
            MenuController.debugConsole.alert("Warning: Deprecated \"audio\" prop found in resource \"" + param1.ID + "\". Please remove!");
         }
         if(_loc2_)
         {
            if(_loc2_.movieclips)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc2_.movieclips.length)
               {
                  ResourceManager.getLibraryClass(_loc2_.movieclips[_loc3_]);
                  _loc3_++;
               }
            }
            if(_loc2_.sounds)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc2_.sounds.length)
               {
                  ResourceManager.getLibraryClass(_loc2_.sounds[_loc3_]);
                  _loc3_++;
               }
            }
         }
      }
      
      public static function isRequiredResourceType(param1:int) : Boolean
      {
         return param1 === Resource.MENU || param1 === Resource.MISC || param1 === Resource.AUDIO || param1 === Resource.MODE || param1 === Resource.CHARACTER_EXPANSION || param1 === Resource.STAGE_EXPANSION;
      }
      
      public static function addResource(param1:Resource) : void
      {
         if(param1.ID === "put_id_here")
         {
            return;
         }
         if(!param1)
         {
            trace("[ResourceManager] Null resource provided!!!.");
         }
         else if(!param1.ID)
         {
            trace("[ResourceManager] Error, resource requires an ID in order to be stored.");
         }
         else if(ResourceManager.poolHash[param1.ID])
         {
            trace("[ResourceManager] Error, resource " + param1.ID + " has already been added");
         }
         else
         {
            ResourceManager.poolHash[param1.ID] = param1;
            ResourceManager.pool.push(param1);
            trace("[ResourceManager] Added resource: " + param1.ID);
            if(param1.Loaded && !resourcesHash[param1.ID])
            {
               ResourceManager.resourcesHash[param1.ID] = param1;
               ResourceManager.resources.push(param1);
            }
         }
      }
      
      public static function queueResources(param1:Array) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            if(!ResourceManager.poolHash[param1[_loc2_]])
            {
               trace("[ResourceManager] Resource could not be found: " + param1[_loc2_]);
            }
            else if(!ResourceManager.queueHash[param1[_loc2_]])
            {
               if(param1[_loc2_] === "sheik")
               {
                  if(!ResourceManager.queueHash["zelda"])
                  {
                     queueResources(["zelda"]);
                  }
                  return;
               }
               ResourceManager.queueHash[param1[_loc2_]] = ResourceManager.poolHash[param1[_loc2_]];
               ResourceManager.queue.push(ResourceManager.poolHash[param1[_loc2_]]);
               trace("[ResourceManager] Queued resource: " + param1[_loc2_]);
            }
            _loc2_++;
         }
      }
      
      public static function queueRequiredResources() : void
      {
         var _loc1_:Resource = null;
         var _loc2_:int = 0;
         while(_loc2_ < ResourceManager.pool.length)
         {
            _loc1_ = ResourceManager.pool[_loc2_];
            if(Boolean(ResourceManager.isRequiredResourceType(_loc1_.Type)) && !ResourceManager.resourcesHash[_loc1_.ID] && !ResourceManager.queueHash[_loc1_.ID])
            {
               ResourceManager.queueHash[_loc1_.ID] = _loc1_;
               ResourceManager.queue.push(_loc1_);
               trace("[ResourceManager] Queued resource: " + _loc1_.ID);
            }
            _loc2_++;
         }
      }
      
      public static function flushAllResources(param1:Boolean = false) : void
      {
         var _loc2_:Resource = null;
         var _loc3_:* = 0;
         while(_loc3_ < ResourceManager.resources.length)
         {
            _loc2_ = ResourceManager.resources[_loc3_];
            if(!ResourceManager.isRequiredResourceType(_loc2_.Type) || param1)
            {
               unloadResource(_loc2_);
               _loc3_--;
               trace("[ResourceManager] Unloaded resource: " + _loc2_.ID);
            }
            _loc3_++;
         }
      }
      
      public static function flushUnusedResources() : void
      {
         var _loc1_:Resource = null;
         var _loc2_:* = 0;
         while(_loc2_ < ResourceManager.resources.length)
         {
            _loc1_ = ResourceManager.resources[_loc2_];
            if(!ResourceManager.isRequiredResourceType(_loc1_.Type) && !ResourceManager.queueHash[_loc1_.ID])
            {
               unloadResource(_loc1_);
               _loc2_--;
               trace("[ResourceManager] Unloaded resource: " + _loc1_.ID);
            }
            _loc2_++;
         }
      }
      
      public static function flushLoadQueue() : void
      {
         var _loc1_:Resource = null;
         var _loc2_:* = 0;
         while(_loc2_ < ResourceManager.queue.length)
         {
            _loc1_ = ResourceManager.queue[_loc2_];
            ResourceManager.queueHash[_loc1_.ID] = null;
            ResourceManager.queue[_loc2_] = null;
            ResourceManager.queue.splice(_loc2_--,1);
            trace("[ResourceManager] Removed resource from loading queue: " + _loc1_.ID);
            _loc2_++;
         }
      }
      
      public static function pruneLoadQueue() : void
      {
         var _loc1_:Resource = null;
         var _loc2_:* = 0;
         while(_loc2_ < ResourceManager.queue.length)
         {
            _loc1_ = ResourceManager.queue[_loc2_];
            if(_loc1_.Loaded)
            {
               if(!ResourceManager.resourcesHash[_loc1_.ID])
               {
                  ResourceManager.resourcesHash[_loc1_.ID] = _loc1_;
                  ResourceManager.resources.push(_loc1_);
               }
               ResourceManager.queueHash[_loc1_.ID] = null;
               ResourceManager.queue[_loc2_] = null;
               ResourceManager.queue.splice(_loc2_--,1);
               trace("[ResourceManager] Removed already loaded resource from loading queue: " + _loc1_.ID);
            }
            _loc2_++;
         }
      }
      
      private static function checkMissingEmptyFrameOnes() : void
      {
         var _loc1_:int = 0;
         while(Boolean(MenuController.debugConsole) && Boolean(!Main.preloader) && _loc1_ < ResourceManager.resources.length)
         {
            if(ResourceManager.resources[_loc1_].numChildren > 0)
            {
               MenuController.debugConsole.alert("Warning! Loaded resource " + ResourceManager.resources[_loc1_].ID + " contains contents on the timeline on frame 1. Must always insert a blank frame first at the root of an SSF2 resource SWF to prevent MovieClip content from potentially playing in the background and causing desyncs!");
            }
            _loc1_++;
         }
      }
      
      public static function load(param1:Object) : void
      {
         var checkFinished:Function = null;
         var i:int = 0;
         var checkProgress:Function = null;
         var options:Object = param1;
         ResourceManager.unloadOldResources();
         if(ResourceManager._isFinishedInterval)
         {
            if(ResourceManager._loadOptions.onerror)
            {
               ResourceManager._loadOptions.onerror();
            }
            clearInterval(ResourceManager._isFinishedInterval);
            ResourceManager._isFinishedInterval = 0;
         }
         ResourceManager._loadOptions = options || {};
         ResourceManager._loadIndex = 0;
         if(ResourceManager.multimode)
         {
            checkFinished = function():void
            {
               if(typeof ResourceManager._loadOptions.onprogress == "function")
               {
                  ResourceManager._loadOptions.onprogress(ResourceManager.getLoadPercentage());
               }
               if(ResourceManager.isFullyLoaded())
               {
                  ResourceManager.flushLoadQueue();
                  clearInterval(ResourceManager._isFinishedInterval);
                  ResourceManager._isFinishedInterval = 0;
                  if(typeof ResourceManager._loadOptions.oncomplete == "function")
                  {
                     checkMissingEmptyFrameOnes();
                     ResourceManager._loadOptions.oncomplete();
                  }
                  trace("[ResourceManager] Finished loading all resources.");
               }
            };
            i = 0;
            while(i < ResourceManager.queue.length)
            {
               trace("[ResourceManager] Started loading resource: ",ResourceManager.queue[i].ID);
               if(Boolean(ResourceManager.queue[i].Loaded) && ResourceManager.queue[i].Type === Resource.STAGE)
               {
                  ResourceManager.checkMusicToLoad(ResourceManager.queue[i]);
               }
               ResourceManager.queue[i].load(handleLoaded,handleLoaded);
               i += 1;
            }
            ResourceManager._isFinishedInterval = setInterval(checkFinished,100);
         }
         else
         {
            checkProgress = function():void
            {
               if(typeof ResourceManager._loadOptions.onprogress == "function")
               {
                  ResourceManager._loadOptions.onprogress(ResourceManager.getLoadPercentage());
               }
            };
            ResourceManager._isFinishedInterval = setInterval(checkProgress,100);
            setTimeout(function():void
            {
               ResourceManager.loadNext();
            },LOAD_DELAY);
         }
      }
      
      public static function checkMusicToLoad(param1:Resource) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         if(param1.Type === Resource.STAGE)
         {
            if(Boolean(param1.getProp("music")) && Boolean(param1.getProp("music").length))
            {
               Main.prepRandomMusic(Utils.safeRandomInteger(0,param1.getProp("music").length - 1));
               _loc3_ = param1.getProp("music")[Main.RandMusicIndex].id;
               if(Boolean(ResourceManager.getResourceByID(_loc3_)) && Boolean(!ResourceManager.getResourceByID(_loc3_,true)) && !ResourceManager.queueHash[_loc3_])
               {
                  ResourceManager.queueResources([_loc3_]);
                  if(ResourceManager.multimode)
                  {
                     Resource(ResourceManager.queueHash[_loc3_]).load(handleLoaded,handleLoaded);
                  }
               }
            }
         }
      }
      
      private static function handleLoaded(param1:Resource) : void
      {
         var res:Resource = param1;
         if(ResourceManager.multimode)
         {
            if(res.Loaded)
            {
               ResourceManager.resources.push(res);
               ResourceManager.resourcesHash[res.ID] = res;
               ResourceManager.cacheLibrary(res);
               trace("[ResourceManager] Loaded: ",res.ID);
               if(!ResourceManager.validateResource(res))
               {
                  unloadResource(res);
               }
               else
               {
                  checkMusicToLoad(res);
               }
            }
            else if(res.HasError && res.SoftFail)
            {
               unloadResource(res);
            }
            else if(res.HasError)
            {
               if(typeof ResourceManager._loadOptions.onerror == "function")
               {
                  ResourceManager._loadOptions.onerror();
               }
               trace("[ResourceManager] An error has occured while loading resource: ",res.ID);
            }
         }
         else if(ResourceManager.queue[ResourceManager._loadIndex].Loaded)
         {
            ResourceManager.resources.push(res);
            ResourceManager.resourcesHash[res.ID] = res;
            ResourceManager.cacheLibrary(res);
            trace("[ResourceManager] Loaded: ",res);
            ++ResourceManager._loadIndex;
            if(!ResourceManager.validateResource(res))
            {
               unloadResource(res);
            }
            else
            {
               checkMusicToLoad(res);
            }
            setTimeout(function():void
            {
               ResourceManager.loadNext();
            },LOAD_DELAY);
         }
         else if(Boolean(ResourceManager.queue[ResourceManager._loadIndex].HasError) && Boolean(ResourceManager.queue[ResourceManager._loadIndex].SoftFail))
         {
            unloadResource(ResourceManager.queue[ResourceManager._loadIndex]);
            ++ResourceManager._loadIndex;
            ResourceManager.loadNext();
         }
         else if(ResourceManager.queue[ResourceManager._loadIndex].HasError)
         {
            if(typeof ResourceManager._loadOptions.onerror == "function")
            {
               ResourceManager._loadOptions.onerror();
            }
            trace("[ResourceManager] An error has occured while loading resource: ",ResourceManager.queue[ResourceManager._loadIndex].ID);
            ++ResourceManager._loadIndex;
            ResourceManager.loadNext();
         }
      }
      
      private static function loadNext() : void
      {
         if(ResourceManager._loadIndex < ResourceManager.queue.length)
         {
            trace("[ResourceManager] Started loading resource: ",ResourceManager.queue[ResourceManager._loadIndex].ID);
            if(Boolean(ResourceManager.queue[ResourceManager._loadIndex].Loaded) && ResourceManager.queue[ResourceManager._loadIndex].Type === Resource.STAGE)
            {
               ResourceManager.checkMusicToLoad(ResourceManager.queue[ResourceManager._loadIndex]);
            }
            if(ResourceManager.queue[ResourceManager._loadIndex].Loaded)
            {
               ++ResourceManager._loadIndex;
               loadNext();
            }
            else
            {
               ResourceManager.queue[ResourceManager._loadIndex].load(handleLoaded,handleLoaded);
            }
         }
         else
         {
            clearInterval(ResourceManager._isFinishedInterval);
            ResourceManager._isFinishedInterval = 0;
            if(ResourceManager.isFullyLoaded())
            {
               ResourceManager.flushLoadQueue();
               checkMissingEmptyFrameOnes();
               if(typeof ResourceManager._loadOptions.oncomplete == "function")
               {
                  ResourceManager._loadOptions.oncomplete();
               }
               trace("[ResourceManager] Finished loading all resources.");
            }
            else
            {
               trace("[ResourceManager] Unable to load all resources.");
            }
         }
      }
      
      public static function getLoadPercentage() : Number
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < ResourceManager.queue.length)
         {
            if(Boolean(ResourceManager.queue[_loc3_].HasError) && Boolean(ResourceManager.queue[_loc3_].SoftFail))
            {
               _loc1_ += 100;
            }
            else
            {
               _loc1_ += ResourceManager.queue[_loc3_].PercentLoaded;
            }
            _loc3_++;
         }
         return ResourceManager.queue.length <= 0 ? 100 : _loc1_ / (ResourceManager.queue.length - _loc2_);
      }
      
      public static function isFullyLoaded() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < ResourceManager.queue.length)
         {
            if(!ResourceManager.queue[_loc1_].Loaded && !(Boolean(ResourceManager.queue[_loc1_].HasError) && Boolean(ResourceManager.queue[_loc1_].SoftFail)))
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      private static function validateResource(param1:Resource) : Boolean
      {
         var apiFunc:Function = null;
         var cls:Class = null;
         var diff:int = 0;
         var versionStr:String = null;
         var characters:Array = null;
         var expansionChars:Array = null;
         var expansionCostume:Array = null;
         var expansionMetalCostume:Array = null;
         var j:int = 0;
         var resource:Resource = param1;
         if(Boolean(resource.MC) && "initAPI" in resource.MC)
         {
            apiFunc = resource.MC["initAPI"] as Function;
            cls = apiFunc(SSF2API);
            if("BASE_CLASSES" in cls)
            {
               resource.MetaData.BASE_CLASSES = cls.BASE_CLASSES;
            }
            else
            {
               resource.MetaData.BASE_CLASSES = {};
            }
            diff = int(Version.compare(SSF2API.VERSION_MAJOR,SSF2API.VERSION_MINOR,SSF2API.VERSION_REVISION,cls.VERSION_MAJOR,cls.VERSION_MINOR,cls.VERSION_REVISION));
            versionStr = Boolean(cls["getAPIVersion"] as Function) ? (cls["getAPIVersion"] as Function)() : "(unknown)";
            if(diff > 0)
            {
               if(SSF2API.VERSION_MAJOR !== cls.VERSION_MAJOR || SSF2API.VERSION_MINOR !== cls.VERSION_MINOR || cls.VERSION_MAJOR === 0 && cls.VERSION_MINOR === 3 && cls.VERSION_REVISION < 22)
               {
                  if(Boolean(Main.DEBUG) && Boolean(MenuController.debugConsole) && Boolean(MenuController.debugConsole.Alerts))
                  {
                     MenuController.debugConsole.alert("[Warning] API for resource \"" + resource.FileName + "\" is older than the game engine\'s API Interface. Please recompile resource. (v" + versionStr + " < v" + SSF2API.getAPIVersion() + ")");
                  }
               }
            }
            else if(diff < 0)
            {
               if(Boolean(Main.DEBUG) && Boolean(MenuController.debugConsole) && Boolean(MenuController.debugConsole.Alerts))
               {
                  MenuController.debugConsole.alert("[Warning] API for resource \"" + resource.FileName + "\" is newer than the engine\'s API Interface. Please update game engine. (v" + versionStr + " > v" + SSF2API.getAPIVersion() + ")");
               }
            }
         }
         if(Boolean(resource.MC) && "initModAPI" in resource.MC)
         {
            try
            {
               apiFunc = resource.MC["initModAPI"] as Function;
               apiFunc(SSF2API);
               trace("[ResourceManager] Initialized ModAPI for resource: " + resource.ID);
            }
            catch(error:Error)
            {
               trace("[ResourceManager] Warning: Error initializing ModAPI for " + resource.ID + ": " + error.message);
            }
         }
         if(resource.getProp("id"))
         {
            if(ResourceManager.getResourceByID(resource.getProp("id")) == null)
            {
               trace("ERROR, no matching ID for global " + resource.getProp("id"));
               unloadResource(resource);
               return false;
            }
            if(!resource.getProp("guid"))
            {
               trace("ERROR, no GUID for " + resource.getProp("id"));
               return false;
            }
            if(resource.getProp("guid") != ResourceManager.getResourceByID(resource.getProp("id")).PassKey)
            {
               trace("ERROR in validation for " + resource.getProp("id") + " with key " + resource.getProp("guid"));
               return false;
            }
            resource.Type = ResourceManager.getResourceByID(resource.getProp("id")).Type;
            if(resource.Type != Resource.STAGE)
            {
               if(resource.Type == Resource.CHARACTER)
               {
                  characters = resource.getProp("characters") || null;
                  if(!characters)
                  {
                     trace("ERROR writing stats for " + resource.getProp("id") + " with key " + resource.getProp("guid"));
                     return false;
                  }
                  j = 0;
                  while(j < characters.length)
                  {
                     Stats.writeStats(characters[j]);
                     j++;
                  }
               }
            }
         }
         else if(resource.getProp("expansion"))
         {
            expansionChars = resource.getProp("characters");
            expansionCostume = resource.getProp("costume_data");
            expansionMetalCostume = resource.getProp("metal_costume_data");
            if(Boolean(expansionChars) && resource.FileName.indexOf("test") == 0)
            {
               m_expansionData.push(new Vector.<Object>());
               j = 0;
               while(j < expansionChars.length)
               {
                  m_expansionData[m_expansionData.length - 1].push(expansionChars[j]);
                  if(Boolean(expansionCostume) && Boolean(expansionCostume[j]))
                  {
                     ResourceManager.m_expansionCostumeData[expansionChars[j]["cData"]["statsName"]] = expansionCostume[j];
                  }
                  if(Boolean(expansionMetalCostume) && Boolean(expansionMetalCostume[j]))
                  {
                     ResourceManager.m_expansionMetalCostumeData[expansionChars[j]["cData"]["statsName"]] = expansionMetalCostume[j];
                  }
                  j++;
               }
            }
            else if(!resource.getProp("stage"))
            {
               trace("ERROR, no association for " + resource.Location);
               unloadResource(resource);
               return false;
            }
         }
         return true;
      }
      
      public static function unloadResource(param1:Resource) : void
      {
         var key:* = undefined;
         var apiFunc:Function = null;
         var res:Resource = param1;
         var i:int = int(ResourceManager.resources.indexOf(res));
         if(i >= 0)
         {
            if(Boolean(res.MC) && "deinitAPI" in res.MC)
            {
               apiFunc = res.MC["deinitAPI"] as Function;
               apiFunc();
            }
            if(Boolean(res.MC) && "deinitModAPI" in res.MC)
            {
               try
               {
                  apiFunc = res.MC["deinitModAPI"] as Function;
                  apiFunc();
                  trace("[ResourceManager] Deinitialized ModAPI for resource: " + res.ID);
               }
               catch(error:Error)
               {
                  trace("[ResourceManager] Warning: Error deinitializing ModAPI for " + res.ID + ": " + error.message);
               }
            }
            res.unload();
            ResourceManager.resourcesHash[res.ID] = null;
            ResourceManager.resources[i] = null;
            ResourceManager.resources.splice(i,1);
            for(key in ResourceManager.resourceCache)
            {
               if(Boolean(ResourceManager.resourceCache[key]) && ResourceManager.resourceCache[key].src === res.ID)
               {
                  ResourceManager.resourceCache[key] = null;
               }
            }
            if(res.Type === Resource.CHARACTER)
            {
               Stats.clearStats(res.ID);
            }
         }
      }
      
      private static function getOldestResourceByType(param1:int) : Resource
      {
         var _loc2_:int = 0;
         while(_loc2_ < ResourceManager.resources.length)
         {
            if(ResourceManager.resources[_loc2_].Type === param1)
            {
               return ResourceManager.resources[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      private static function unloadOldResources() : void
      {
         var _loc1_:* = undefined;
         var _loc6_:int = 0;
         var _loc2_:int = !Main.LOCALHOST ? 12 : 2;
         var _loc3_:int = !Main.LOCALHOST ? 10 : 1;
         var _loc4_:int = !Main.LOCALHOST ? 16 : (Main.DEBUG ? 6 : 1);
         var _loc5_:Object = {};
         while(_loc6_ < ResourceManager.resources.length)
         {
            if(!_loc5_[ResourceManager.resources[_loc6_].Type])
            {
               _loc5_[ResourceManager.resources[_loc6_].Type] = 0;
            }
            ++_loc5_[ResourceManager.resources[_loc6_].Type];
            _loc6_++;
         }
         for(_loc1_ in _loc5_)
         {
            switch(_loc1_)
            {
               case Resource.CHARACTER:
                  while(_loc5_[_loc1_] > _loc2_)
                  {
                     ResourceManager.unloadResource(ResourceManager.getOldestResourceByType(Resource.CHARACTER));
                     --_loc5_[_loc1_];
                  }
                  break;
               case Resource.STAGE:
                  if(_loc5_[_loc1_] > _loc3_)
                  {
                     ResourceManager.unloadResource(ResourceManager.getOldestResourceByType(Resource.STAGE));
                     --_loc5_[_loc1_];
                  }
                  break;
               case Resource.MUSIC:
                  if(_loc5_[_loc1_] > _loc4_)
                  {
                     ResourceManager.unloadResource(ResourceManager.getOldestResourceByType(Resource.MUSIC));
                     --_loc5_[_loc1_];
                  }
            }
         }
      }
      
      private static function promoteResource(param1:Resource) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = -1;
         while(_loc3_ < ResourceManager.resources.length)
         {
            if(ResourceManager.resources[_loc3_] === param1)
            {
               _loc2_ = _loc3_;
               return;
            }
            _loc3_++;
         }
         if(_loc2_ >= 0)
         {
            ResourceManager.resources.splice(_loc2_,1);
            ResourceManager.resources.push(param1);
         }
      }
      
      public static function getResourceByID(param1:String, param2:Boolean = false) : Resource
      {
         if(Boolean(ResourceManager.poolHash[param1]) && !(param2 && !ResourceManager.poolHash[param1].Loaded))
         {
            return ResourceManager.poolHash[param1];
         }
         return null;
      }
      
      public static function getLibraryMC(param1:String) : MovieClip
      {
         var _loc2_:Class = ResourceManager.getLibraryClass(param1);
         if(_loc2_)
         {
            return new _loc2_() as MovieClip;
         }
         return null;
      }
      
      public static function getLibraryClass(param1:String) : Class
      {
         var _loc2_:Class = null;
         var _loc3_:String = "root";
         var _loc4_:Number = 0;
         if(ResourceManager.resourceCache[param1])
         {
            return resourceCache[param1].ref;
         }
         if(Main.Root.loaderInfo.applicationDomain.hasDefinition(param1))
         {
            _loc2_ = Main.Root.loaderInfo.applicationDomain.getDefinition(param1) as Class;
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < ResourceManager.resources.length)
            {
               if(Boolean(ResourceManager.resources[_loc4_].Loaded) && Boolean(ResourceManager.resources[_loc4_]) && Boolean(ResourceManager.resources[_loc4_].MC))
               {
                  if(ResourceManager.resources[_loc4_].MC.loaderInfo.applicationDomain.hasDefinition(param1))
                  {
                     _loc2_ = ResourceManager.resources[_loc4_].MC.loaderInfo.applicationDomain.getDefinition(param1) as Class;
                     _loc3_ = resources[_loc4_].ID;
                     break;
                  }
                  if(ResourceManager.resources[_loc4_].MC[param1])
                  {
                     _loc2_ = ResourceManager.resources[_loc4_].MC[param1] as Class;
                     _loc3_ = resources[_loc4_].ID;
                     break;
                  }
               }
               _loc4_++;
            }
         }
         if(_loc2_)
         {
            ResourceManager.resourceCache[param1] = {
               "ref":_loc2_,
               "src":_loc3_
            };
         }
         return _loc2_;
      }
      
      public static function getLibrarySound(param1:String) : Sound
      {
         var _loc2_:Class = ResourceManager.getLibraryClass(param1);
         if(_loc2_)
         {
            return new _loc2_() as Sound;
         }
         return null;
      }
      
      public static function getPokemonStatsData() : Object
      {
         return getResourceByID("pokemon").getProp("pokemon");
      }
      
      public static function getAssistStatsData() : Object
      {
         return getResourceByID("assists").getProp("assists");
      }
      
      public static function getItemStats() : Array
      {
         var _loc1_:Array = getResourceByID("items").MC.getItemStats();
         return _loc1_ || null;
      }
      
      public static function getAllCostumes(param1:String, param2:String, param3:Boolean = false) : Array
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:Array = [];
         var _loc7_:Array = [];
         _loc7_[param1] = getResourceByID("misc").getProp("metadata").costume_data[param1].concat(PaletteMakerUtils.getCostume(param1));
         if(_loc7_ != null)
         {
            if(Boolean(_loc7_) && _loc7_[param1] != null)
            {
               _loc4_ = null;
               _loc5_ = 0;
               while(_loc5_ < _loc7_[param1].length)
               {
                  if(param2 != null)
                  {
                     if(Boolean(_loc7_[param1][_loc5_]) && Boolean(_loc7_[param1][_loc5_]["team"]) && _loc7_[param1][_loc5_]["team"] == param2)
                     {
                        _loc6_.push(_loc7_[param1][_loc5_]);
                        break;
                     }
                  }
                  else if(!_loc7_[param1][_loc5_]["team"])
                  {
                     if(!(Boolean(_loc7_[param1][_loc5_]["base"]) && !param3))
                     {
                        _loc6_.push(_loc7_[param1][_loc5_]);
                     }
                  }
                  _loc5_++;
               }
            }
         }
         return _loc6_;
      }
      
      public static function getCostumeCount(param1:String) : int
      {
         var _loc2_:int = 0;
         var _loc3_:* = 0;
         var _loc4_:Array = [];
         _loc4_[param1] = getResourceByID("misc").getProp("metadata").costume_data[param1].concat(PaletteMakerUtils.getCostume(param1));
         if(_loc4_ != null)
         {
            if(Boolean(_loc4_) && _loc4_[param1] != null)
            {
               _loc3_ = int(_loc4_[param1].length);
               _loc2_ = 0;
               while(_loc2_ < _loc4_[param1].length)
               {
                  if(Boolean(_loc4_[param1][_loc2_]["base"]) || Boolean(_loc4_[param1][_loc2_]["team"]))
                  {
                     _loc3_--;
                  }
                  _loc2_++;
               }
            }
         }
         return int(_loc3_ + 1);
      }
      
      public static function getCostume(param1:String, param2:String, param3:int = -1) : Object
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc6_:Array = [];
         _loc6_[param1] = getResourceByID("misc").getProp("metadata").costume_data[param1].concat(PaletteMakerUtils.getCostume(param1));
         var _loc9_:int = getCostumeCount(param1);
         if(_loc6_ != null)
         {
            if(Boolean(_loc6_) && _loc6_[param1] != null)
            {
               _loc4_ = null;
               if(param3 >= _loc9_ - 1)
               {
                  param3 = -1;
               }
               _loc5_ = 0;
               while(_loc5_ < _loc6_[param1].length)
               {
                  if(param2 != null)
                  {
                     if(Boolean(_loc6_[param1][_loc5_]) && Boolean(_loc6_[param1][_loc5_]["team"]) && _loc6_[param1][_loc5_]["team"] == param2)
                     {
                        _loc8_ = _loc6_[param1][_loc5_];
                        break;
                     }
                  }
                  else if(!_loc6_[param1][_loc5_]["team"])
                  {
                     if(!(param3 >= 0 && Boolean(_loc6_[param1][_loc5_]["base"])))
                     {
                        if(param3 == _loc7_)
                        {
                           _loc8_ = _loc6_[param1][_loc5_];
                           break;
                        }
                        if(param3 === -1 && Boolean(_loc6_[param1][_loc5_]["base"]))
                        {
                           _loc8_ = _loc6_[param1][_loc5_];
                           break;
                        }
                        _loc7_++;
                     }
                  }
                  _loc5_++;
               }
            }
         }
         return Utils.cloneObject(_loc8_);
      }
      
      public static function getMetalCostume(param1:String) : Object
      {
         var _loc2_:Object = getResourceByID("misc").getProp("metadata").metal_costume_data;
         if(Boolean(_loc2_) && Boolean(_loc2_[param1]))
         {
            return _loc2_[param1];
         }
         if(_loc2_["default"])
         {
            return _loc2_["default"];
         }
         return null;
      }
      
      public static function getExpansionCharacter(param1:int) : Vector.<Object>
      {
         return param1 >= 0 && param1 < m_expansionData.length && m_expansionData.length > 0 ? m_expansionData[param1] : null;
      }
      
      public static function getExpansionCharacterObject(param1:int, param2:Number) : Object
      {
         return param1 >= 0 && param1 < m_expansionData.length && m_expansionData.length > 0 && param2 >= 0 && param2 < m_expansionData[param1].length ? m_expansionData[param1][param2] : null;
      }
      
      public static function getNextExpansionCharacter(param1:Number) : Number
      {
         param1 += 1;
         if(param1 >= m_expansionData.length)
         {
            param1 = 0;
         }
         return param1;
      }
      
      public static function getPrevExpansionCharacter(param1:Number) : Number
      {
         param1--;
         if(param1 < m_expansionData.length)
         {
            param1 = m_expansionData.length - 1;
         }
         return param1;
      }
      
      public static function appendExpansionCostumes() : void
      {
         var _loc3_:String = null;
         var _loc1_:Array = getResourceByID("misc").getProp("metadata").costume_data;
         var _loc2_:Object = getResourceByID("misc").getProp("metadata").metal_costume_data;
         for(_loc3_ in ResourceManager.m_expansionCostumeData)
         {
            _loc1_[_loc3_] = ResourceManager.m_expansionCostumeData[_loc3_];
         }
         for(_loc3_ in ResourceManager.m_expansionMetalCostumeData)
         {
            _loc2_[_loc3_] = ResourceManager.m_expansionMetalCostumeData[_loc3_];
         }
      }
   }
}


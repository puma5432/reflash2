package com.mcleodgaming.ssf2.util
{
   import com.mcleodgaming.ssf2.*;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.system.*;
   import flash.utils.*;
   
   public class Resource
   {
      
      private static const DIRECTORY_CHAR:String = "data/character/";
      
      private static const DIRECTORY_STAGE:String = "data/stage/";
      
      private static const DIRECTORY_MENU:String = "data/menu/";
      
      private static const DIRECTORY_AUDIO:String = "data/sound/";
      
      private static const DIRECTORY_MISC:String = "data/misc/";
      
      private static const DIRECTORY_MODES:String = "data/modes/";
      
      private static const DIRECTORY_CHAR_ENCRYPTED:String = "data/";
      
      private static const DIRECTORY_STAGE_ENCRYPTED:String = "data/";
      
      private static const DIRECTORY_MENU_ENCRYPTED:String = "data/";
      
      private static const DIRECTORY_AUDIO_ENCRYPTED:String = "data/";
      
      private static const DIRECTORY_MISC_ENCRYPTED:String = "data/";
      
      private static const DIRECTORY_MODES_ENCRYPTED:String = "data/";
      
      private static const URL_PROTOCOL:String = "https://";
      
      private static const URL_HOST:String = "cdn.supersmashflash.com";
      
      private static const URL_DIRECTORY:String = "/ssf2/433c66e550884701aad475c2ff8a27fb5/";
      
      public static const NULL:int = -1;
      
      public static const MISC:int = 0;
      
      public static const CHARACTER:int = 1;
      
      public static const STAGE:int = 2;
      
      public static const AUDIO:int = 3;
      
      public static const MENU:int = 4;
      
      public static const CHARACTER_EXPANSION:int = 5;
      
      public static const STAGE_EXPANSION:int = 6;
      
      public static const EXTRA:int = 7;
      
      public static const MUSIC:int = 8;
      
      public static const MODE:int = 9;
      
      private var m_id:String;
      
      private var m_fileName:String;
      
      private var m_encryptedFileName:String;
      
      private var m_passKey:String;
      
      private var m_loader:Loader;
      
      private var m_loaderContext:LoaderContext;
      
      private var m_urlRequest:URLRequest;
      
      private var m_urlLoader:URLLoader;
      
      private var m_type:int;
      
      private var m_loaded:Boolean;
      
      private var m_softFail:Boolean;
      
      private var m_percentLoaded:Number;
      
      private var m_loadFunction:Function;
      
      private var m_errorFunction:Function;
      
      private var m_startDelay:FrameTimer;
      
      private var m_metadata:Object;
      
      private var m_errored:Boolean;
      
      private var m_movie:MovieClip;
      
      private var m_urlOverride:String;
      
      public var numChildren:int = 0;
      
      public function Resource(param1:String, param2:String, param3:String, param4:String, param5:int)
      {
         super();
         if(param5 < -1 || param5 > 9)
         {
            trace("Error importing type...");
            this.m_type = -1;
         }
         else
         {
            this.m_type = param5;
         }
         this.m_id = param1;
         this.m_fileName = param2;
         this.m_encryptedFileName = param3;
         this.m_passKey = param4;
         this.m_type = param5;
         this.m_loadFunction = null;
         this.m_errorFunction = null;
         this.m_percentLoaded = 0;
         this.m_softFail = false;
         this.m_loaded = false;
         this.m_loader = new Loader();
         this.m_loaderContext = null;
         this.m_urlRequest = null;
         this.m_urlLoader = null;
         this.m_movie = null;
         this.m_startDelay = new FrameTimer(3);
         this.m_metadata = {};
         this.m_errored = false;
         this.m_urlOverride = null;
      }
      
      public function get ID() : String
      {
         return this.m_id;
      }
      
      public function get CurrentFileName() : String
      {
         return Main.ENCRYPTED ? this.m_encryptedFileName : this.m_fileName;
      }
      
      public function get FileName() : String
      {
         return this.m_fileName;
      }
      
      public function get Location() : String
      {
         if(this.m_urlOverride)
         {
            return this.m_urlOverride;
         }
         var _loc1_:String = "";
         if(!Main.LOCALHOST)
         {
            _loc1_ = Resource.URL_PROTOCOL + Resource.URL_HOST + Resource.URL_DIRECTORY;
         }
         if(this.m_type == Resource.MISC || this.m_type == Resource.EXTRA)
         {
            if(Main.ENCRYPTED)
            {
               return _loc1_ + Resource.DIRECTORY_MISC_ENCRYPTED + this.m_encryptedFileName;
            }
            return _loc1_ + Resource.DIRECTORY_MISC + this.m_fileName;
         }
         if(this.m_type == Resource.AUDIO || this.m_type == Resource.MUSIC)
         {
            if(Main.ENCRYPTED)
            {
               return _loc1_ + Resource.DIRECTORY_AUDIO_ENCRYPTED + this.m_encryptedFileName;
            }
            return _loc1_ + Resource.DIRECTORY_AUDIO + this.m_fileName;
         }
         if(this.m_type == Resource.CHARACTER || this.m_type == Resource.CHARACTER_EXPANSION)
         {
            if(Main.ENCRYPTED)
            {
               return _loc1_ + Resource.DIRECTORY_CHAR_ENCRYPTED + this.m_encryptedFileName;
            }
            return _loc1_ + Resource.DIRECTORY_CHAR + this.m_fileName;
         }
         if(this.m_type == Resource.STAGE || this.m_type == Resource.STAGE_EXPANSION)
         {
            if(Main.ENCRYPTED)
            {
               return _loc1_ + Resource.DIRECTORY_STAGE_ENCRYPTED + this.m_encryptedFileName;
            }
            return _loc1_ + Resource.DIRECTORY_STAGE + this.m_fileName;
         }
         if(this.m_type == Resource.MENU)
         {
            if(Main.ENCRYPTED)
            {
               return _loc1_ + Resource.DIRECTORY_MENU_ENCRYPTED + this.m_encryptedFileName;
            }
            return _loc1_ + Resource.DIRECTORY_MENU + this.m_fileName;
         }
         if(this.m_type == Resource.MODE)
         {
            if(Main.ENCRYPTED)
            {
               return _loc1_ + Resource.DIRECTORY_MODES_ENCRYPTED + this.m_encryptedFileName;
            }
            return _loc1_ + Resource.DIRECTORY_MODES + this.m_fileName;
         }
         return null;
      }
      
      public function get EncryptedFileName() : String
      {
         return this.m_encryptedFileName;
      }
      
      public function get PassKey() : String
      {
         return this.m_passKey;
      }
      
      public function get Type() : int
      {
         return this.m_type;
      }
      
      public function set Type(param1:int) : void
      {
         this.m_type = param1;
      }
      
      public function get MetaData() : Object
      {
         return this.m_metadata;
      }
      
      public function get MC() : MovieClip
      {
         return this.m_movie;
      }
      
      public function get Loaded() : Boolean
      {
         return this.m_loaded;
      }
      
      public function set Loaded(param1:Boolean) : void
      {
         this.m_loaded = param1;
         if(this.m_loaded)
         {
            this.m_startDelay.finish();
            this.m_percentLoaded = 100;
         }
         else
         {
            this.m_percentLoaded = 0;
         }
      }
      
      public function get SoftFail() : Boolean
      {
         return this.m_softFail;
      }
      
      public function set SoftFail(param1:Boolean) : void
      {
         this.m_softFail = param1;
      }
      
      public function get UrlOverride() : String
      {
         return this.m_urlOverride;
      }
      
      public function set UrlOverride(param1:String) : void
      {
         this.m_urlOverride = param1;
      }
      
      public function get PercentLoaded() : Number
      {
         return this.m_percentLoaded;
      }
      
      public function get HasError() : Boolean
      {
         return this.m_errored;
      }
      
      public function getProp(param1:String) : *
      {
         if(Boolean(this.MC) && "getProp" in this.MC)
         {
            if(this.m_id === "mappings" && Boolean(param1.match(/metadata|metadata_original|metadata_dev/)))
            {
               if(this.m_metadata["mp" + param1])
               {
                  return this.m_metadata["mp" + param1];
               }
               this.m_metadata["mp" + param1] = JSON.parse(Base64.decode(Utils.d(Base64.decode(this.MC.getProp(param1)),"b7d60849-fa99-4514-b41e-16693ce7acc0")));
               return this.m_metadata["mp" + param1];
            }
            return this.MC.getProp(param1);
         }
         return null;
      }
      
      public function load(param1:Function = null, param2:Function = null) : void
      {
         this.m_startDelay.reset();
         this.m_loadFunction = param1;
         this.m_errorFunction = param2;
         if(!this.m_loaded)
         {
            this.m_urlRequest = new URLRequest(this.Location);
            this.m_urlLoader = new URLLoader();
            this.m_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
            if(this.m_loadFunction == null)
            {
               this.m_startDelay.finish();
            }
            this.m_urlLoader.addEventListener(Event.COMPLETE,this.initialLoadComplete);
            this.m_urlLoader.addEventListener(ProgressEvent.PROGRESS,this.loadProgress);
            this.m_urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.initialLoadError);
            this.m_urlLoader.load(this.m_urlRequest);
         }
         else if(this.m_loadFunction == null)
         {
            this.m_startDelay.finish();
            Main.Root.addEventListener(Event.ENTER_FRAME,this.finalFuncs);
         }
      }
      
      private function loadProgress(param1:ProgressEvent) : void
      {
         this.m_percentLoaded = param1.bytesLoaded / param1.bytesTotal * 100;
         if(this.m_percentLoaded > 100 || Boolean(isNaN(this.m_percentLoaded)))
         {
            this.m_percentLoaded = 0;
         }
      }
      
      private function initialLoadError(param1:IOErrorEvent) : void
      {
         trace("Failed to load resource in " + this.Location);
         this.m_urlLoader.removeEventListener(Event.COMPLETE,this.initialLoadComplete);
         this.m_urlLoader.removeEventListener(ProgressEvent.PROGRESS,this.loadProgress);
         this.m_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.initialLoadError);
         this.m_errored = true;
         if(this.m_errorFunction != null)
         {
            this.m_errorFunction(this);
         }
         this.m_loadFunction = null;
         this.m_errorFunction = null;
      }
      
      private function loadError(param1:IOErrorEvent) : void
      {
         this.m_errored = true;
         trace("Failed to read resource in " + this.Location);
         this.m_loader.unloadAndStop(true);
         this.m_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.loadError);
         this.m_loader.contentLoaderInfo.removeEventListener(Event.INIT,this.loadComplete);
         this.m_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.loadComplete);
         if(this.m_errorFunction != null)
         {
            this.m_errorFunction(this);
         }
         this.m_loadFunction = null;
         this.m_errorFunction = null;
      }
      
      private function initialLoadComplete(param1:Event) : void
      {
         var e:Event = param1;
         this.m_urlLoader.removeEventListener(Event.COMPLETE,this.initialLoadComplete);
         this.m_urlLoader.removeEventListener(ProgressEvent.PROGRESS,this.loadProgress);
         this.m_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.initialLoadError);
         setTimeout(function():void
         {
            var _loc1_:ByteArray = null;
            var _loc2_:int = 0;
            var _loc3_:int = 0;
            var _loc4_:int = 0;
            var _loc5_:ByteArray = m_urlLoader.data as ByteArray;
            _loc1_ = new ByteArray();
            try
            {
               _loc5_.uncompress(CompressionAlgorithm.ZLIB);
               _loc2_ = _loc5_.readInt();
               _loc3_ = _loc5_.readInt();
               _loc4_ = 0;
               while(_loc4_ < _loc3_)
               {
                  _loc5_.readInt();
                  _loc4_ += 1;
               }
               _loc1_.writeBytes(_loc5_,_loc5_.position,_loc2_);
               _loc5_ = _loc1_;
               _loc1_ = null;
            }
            catch(err:*)
            {
            }
            m_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,loadError);
            m_loader.contentLoaderInfo.addEventListener(Event.INIT,loadComplete);
            m_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComplete);
            m_loaderContext = new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain));
            m_loaderContext.allowCodeImport = true;
            m_loader.loadBytes(_loc5_,m_loaderContext);
         },50);
      }
      
      private function loadComplete(param1:Event) : void
      {
         this.m_movie = this.m_loader.content as MovieClip;
         this.m_movie.visible = false;
         Utils.recursiveMovieClipPlay(this.MC,false);
         this.numChildren = this.m_movie.numChildren;
         trace("Successfully loaded " + this.Location);
         this.m_loaded = true;
         this.m_percentLoaded = 100;
         this.m_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.loadError);
         this.m_loader.contentLoaderInfo.removeEventListener(Event.INIT,this.loadComplete);
         this.m_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.loadComplete);
         if(this.m_loadFunction != null)
         {
            this.m_loadFunction(this);
            this.m_loadFunction = null;
         }
      }
      
      private function finalFuncs(param1:*) : void
      {
         this.m_startDelay.tick();
         if(this.m_startDelay.IsComplete)
         {
            if(this.m_loadFunction != null)
            {
               this.m_loadFunction(param1);
               this.m_loadFunction = null;
            }
            Main.Root.removeEventListener(Event.ENTER_FRAME,this.finalFuncs);
         }
      }
      
      public function getLoader() : Loader
      {
         return this.m_loader;
      }
      
      public function unload(param1:Boolean = false) : void
      {
         if(this.m_loaded)
         {
            if(this.m_type != Resource.STAGE_EXPANSION && this.m_type != Resource.CHARACTER_EXPANSION)
            {
               trace("[Unloaded SWF] " + this.FileName);
               this.m_errored = param1;
               this.m_loaded = false;
               this.m_loader.unloadAndStop(true);
               this.m_loader = new Loader();
               this.m_loaderContext = null;
               this.m_movie = null;
               this.m_percentLoaded = 0;
               this.m_loadFunction = null;
               this.m_errorFunction = null;
               this.m_urlRequest = null;
               this.m_urlLoader = null;
               this.m_metadata = {};
            }
         }
      }
   }
}


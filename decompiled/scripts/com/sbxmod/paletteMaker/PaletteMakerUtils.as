package com.sbxmod.paletteMaker
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filesystem.*;
   import flash.geom.ColorTransform;
   import flash.net.*;
   import flash.utils.*;
   
   public class PaletteMakerUtils
   {
      
      public static const DEFAULT_COSTUME_NAME:String = "In-Game";
      
      private static const COSTUME_FOLDER:File = File.documentsDirectory.resolvePath("SSF2 Custom Colors");
      
      private static const COSTUME_FILE_EXTENSION:String = ".json";
      
      private static const paletteMakerLoadingScreen:MovieClip = ResourceManager.getLibraryMC("paletteMakerLoadingScreen");
      
      private static var costumesDictionary:flash.utils.Dictionary = new Dictionary();
      
      public function PaletteMakerUtils()
      {
         super();
      }
      
      public static function init() : void
      {
         var _loc1_:Object = ResourceManager.getResourceByID("mappings").getProp("metadata");
         var _loc2_:Object = _loc1_.character_select_screen.rows;
         var _loc3_:Array = Utils.flatten(_loc2_ as Array);
         trace("[PaletteMakerUtils] Importing costumes...");
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            loadCostumeFile(_loc3_[_loc4_]);
            _loc4_++;
         }
      }
      
      public static function loadCostumeFile(param1:String, param2:Object = null) : void
      {
         var loader:URLLoader;
         var costumeFile:URLRequest = null;
         var statsName:String = param1;
         var options:Object = param2;
         unloadCostumeFile(statsName);
         costumeFile = new URLRequest(COSTUME_FOLDER.url + "/" + statsName + COSTUME_FILE_EXTENSION);
         loader = new URLLoader();
         loader.addEventListener(Event.COMPLETE,function(param1:Event):void
         {
            var costumeData:Array = null;
            var e:Event = param1;
            try
            {
               costumeData = JSON.parse(e.target.data) as Array;
               costumesDictionary[statsName] = costumeData;
               if(Boolean(options) && options.onComplete != null)
               {
                  options.onComplete();
               }
               trace("[PaletteMakerUtils] Successful loaded",costumeFile.url);
            }
            catch(e:Error)
            {
               if(Boolean(options) && options.onParseError != null)
               {
                  options.onParseError();
               }
               trace("[PaletteMakerUtils] Parse error in",costumeFile.url);
            }
         });
         loader.addEventListener(IOErrorEvent.IO_ERROR,function(param1:IOErrorEvent):void
         {
            if(Boolean(options) && options.onError != null)
            {
               options.onError();
            }
            trace("[PaletteMakerUtils] Error while loading",costumeFile.url);
         });
         loader.load(costumeFile);
      }
      
      public static function getCostume(param1:String) : Array
      {
         if(!costumesDictionary[param1])
         {
            return [];
         }
         return costumesDictionary[param1];
      }
      
      public static function unloadCostumeFile(param1:String) : void
      {
         if(costumesDictionary[param1])
         {
            delete costumesDictionary[param1];
            trace("[PaletteMakerUtils] Unloaded",param1,"costume file!");
         }
      }
      
      public static function getStockIcon(param1:String, param2:Boolean = false) : MovieClip
      {
         var _loc3_:MovieClip = ResourceManager.getLibraryMC(param1 + "_stock");
         if(_loc3_)
         {
            if(param2)
            {
               Utils.setColorFilterCharacter(_loc3_,-1,param1,-1,false);
            }
            return _loc3_;
         }
         return ResourceManager.getLibraryMC("random_stock");
      }
      
      public static function getSeriesIcon(param1:String) : MovieClip
      {
         return ResourceManager.getLibraryMC(Stats.getStats(param1).SeriesIcon) || ResourceManager.getLibraryMC("smash_icon");
      }
      
      public static function getPixelArt(param1:String, param2:Boolean = false) : MovieClip
      {
         var _loc3_:MovieClip = ResourceManager.getLibraryMC(param1 + "_charselect");
         if(_loc3_)
         {
            if(param2)
            {
               Utils.setColorFilterCharacter(_loc3_,-1,param1,-1,false);
            }
            return _loc3_;
         }
         return ResourceManager.getLibraryMC("rand_mc");
      }
      
      public static function getCharsCompatibleWithCostumes() : Array
      {
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc1_:Array = [];
         var _loc2_:Object = ResourceManager.getResourceByID("mappings").getProp("metadata");
         var _loc3_:Object = _loc2_.character_select_screen.rows;
         var _loc4_:Array = Utils.flatten(_loc3_ as Array);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc6_ = _loc4_[_loc5_];
            if(_loc6_ !== "random")
            {
               _loc7_ = ResourceManager.getCostume(_loc6_,null,1);
               if(Boolean(_loc7_) && "paletteSwap" in _loc7_)
               {
                  _loc1_.push(_loc6_);
               }
            }
            _loc5_++;
         }
         return _loc1_;
      }
      
      public static function isCharRegistered(param1:String) : Boolean
      {
         if(param1 in ResourceManager.getResourceByID("mappings").getProp("metadata").character)
         {
            return true;
         }
         return false;
      }
      
      public static function saveCostume(param1:String, param2:String, param3:Object) : void
      {
         var file:File;
         var stream:FileStream;
         var replaced:Boolean;
         var i:int;
         var list:Array = null;
         var content:String = null;
         var item:Object = null;
         var statsName:String = param1;
         var costumeName:String = param2;
         var paletteData:Object = param3;
         var folder:File = COSTUME_FOLDER;
         delete paletteData["team"];
         delete paletteData["base"];
         paletteData["profile"] = costumeName;
         if(!folder.exists)
         {
            folder.createDirectory();
         }
         file = folder.resolvePath(statsName + COSTUME_FILE_EXTENSION);
         stream = new FileStream();
         if(file.exists)
         {
            stream.open(file,FileMode.READ);
            content = stream.readUTFBytes(stream.bytesAvailable);
            stream.close();
            try
            {
               list = JSON.parse(content) as Array;
            }
            catch(e:Error)
            {
               list = [];
            }
         }
         else
         {
            list = [];
         }
         replaced = false;
         i = 0;
         while(i < list.length)
         {
            item = list[i];
            if(item.profile == paletteData.profile)
            {
               list[i] = paletteData;
               replaced = true;
               break;
            }
            i++;
         }
         if(!replaced)
         {
            list.push(paletteData);
         }
         stream.open(file,FileMode.WRITE);
         stream.writeUTFBytes(stringifyPretty(list));
         stream.close();
      }
      
      public static function deleteCostumes(param1:String, param2:Array) : void
      {
         var file:File;
         var stream:FileStream;
         var content:String;
         var newList:Array;
         var list:Array = null;
         var item:Object = null;
         var statsName:String = param1;
         var costumeNames:Array = param2;
         var folder:File = COSTUME_FOLDER;
         if(!folder.exists)
         {
            return;
         }
         file = folder.resolvePath(statsName + COSTUME_FILE_EXTENSION);
         if(!file.exists)
         {
            return;
         }
         stream = new FileStream();
         stream.open(file,FileMode.READ);
         content = stream.readUTFBytes(stream.bytesAvailable);
         stream.close();
         try
         {
            list = JSON.parse(content) as Array;
         }
         catch(e:Error)
         {
            list = [];
         }
         newList = [];
         for each(item in list)
         {
            if(costumeNames.indexOf(item.profile) == -1)
            {
               newList.push(item);
            }
         }
         stream.open(file,FileMode.WRITE);
         stream.writeUTFBytes(stringifyPretty(newList));
         stream.close();
      }
      
      private static function checkFileExistence(param1:String) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         var _loc2_:File = File.applicationDirectory.resolvePath(param1);
         return _loc2_.exists;
      }
      
      public static function openWinExplorer(param1:String = null) : void
      {
         var _loc2_:File = null;
         if(checkFileExistence(param1))
         {
            _loc2_ = File.applicationDirectory.resolvePath(param1);
            _loc2_.openWithDefaultApplication();
         }
      }
      
      public static function pickBestColor(param1:Array) : uint
      {
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc2_:Number = 128;
         var _loc3_:uint = uint(param1[0]);
         var _loc4_:Number = 9999;
         for each(_loc5_ in param1)
         {
            _loc6_ = _loc5_ >> 16 & 0xFF;
            _loc7_ = _loc5_ >> 8 & 0xFF;
            _loc8_ = _loc5_ & 0xFF;
            _loc9_ = 0.299 * _loc6_ + 0.587 * _loc7_ + 0.114 * _loc8_;
            if(_loc9_ >= 90 && _loc9_ <= 180)
            {
               return _loc5_;
            }
            _loc10_ = Math.abs(_loc9_ - _loc2_);
            if(_loc10_ < _loc4_)
            {
               _loc4_ = _loc10_;
               _loc3_ = _loc5_;
            }
         }
         return _loc3_;
      }
      
      public static function showPaletteMakerLoadingScreen(param1:String, param2:Boolean) : void
      {
         if(!paletteMakerLoadingScreen)
         {
            return;
         }
         if(Boolean(param1) && param2)
         {
            Main.Root.parent.addChild(paletteMakerLoadingScreen);
            paletteMakerLoadingScreen.gotoAndPlay(1);
            MovieClip(paletteMakerLoadingScreen.series).addChild(getSeriesIcon(param1));
         }
         else if(!param2)
         {
            paletteMakerLoadingScreen.gotoAndPlay(34);
         }
      }
      
      public static function setTint(param1:MovieClip, param2:uint) : void
      {
         var _loc3_:ColorTransform = param1.transform.colorTransform;
         _loc3_.color = param2;
         param1.transform.colorTransform = _loc3_;
      }
      
      public static function fadeIn(param1:MovieClip, param2:int) : void
      {
         var startTime:int = 0;
         var onEnterFrame:* = undefined;
         var mc:MovieClip = param1;
         var duration:int = param2;
         onEnterFrame = function(param1:Event):void
         {
            var _loc2_:int = getTimer() - startTime;
            var _loc3_:Number = Math.min(_loc2_ / duration,1);
            mc.alpha = _loc3_;
            if(_loc3_ >= 1)
            {
               mc.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
            }
         };
         mc.alpha = 0;
         startTime = int(getTimer());
         mc.addEventListener(Event.ENTER_FRAME,onEnterFrame);
      }
      
      public static function ensureFront(param1:DisplayObject, param2:DisplayObject) : void
      {
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:DisplayObjectContainer = null;
         if(param1.parent != null && param2.parent != null)
         {
            param1.parent.swapChildren(param1,param1.parent.getChildAt(param1.parent.numChildren - 1));
            param2.parent.swapChildren(param2,param2.parent.getChildAt(param2.parent.numChildren - 1));
            _loc3_ = param1.parent;
            _loc4_ = param2.parent;
            if(_loc3_.parent != null && _loc4_.parent != null)
            {
               _loc3_.parent.swapChildren(_loc3_,_loc3_.parent.getChildAt(_loc3_.parent.numChildren - 1));
               _loc4_.parent.swapChildren(_loc4_,_loc4_.parent.getChildAt(_loc4_.parent.numChildren - 1));
            }
         }
      }
      
      public static function removeAllChildrenMC(param1:MovieClip) : MovieClip
      {
         if(param1.numChildren > 0)
         {
            while(param1.numChildren > 0)
            {
               param1.removeChildAt(0);
            }
         }
         return param1;
      }
      
      private static function stringifyPretty(param1:*, param2:String = " ", param3:int = 0) : String
      {
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:* = undefined;
         var _loc9_:Array = null;
         var _loc10_:String = null;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc4_:String = "";
         var _loc5_:String = "";
         _loc6_ = 0;
         while(_loc6_ < param3)
         {
            _loc5_ += param2;
            _loc6_++;
         }
         if(param1 is Array)
         {
            _loc7_ = param1 as Array;
            _loc4_ += "[";
            _loc6_ = 0;
            while(_loc6_ < _loc7_.length)
            {
               _loc8_ = _loc7_[_loc6_];
               if(_loc8_ is Number || _loc8_ is int || _loc8_ is uint)
               {
                  _loc4_ += "\"0x" + uint(_loc8_).toString(16).toUpperCase() + "\"";
               }
               else if(_loc8_ is String)
               {
                  _loc4_ += "\"" + _loc8_ + "\"";
               }
               else
               {
                  _loc4_ += "\n" + _loc5_ + param2 + stringifyPretty(_loc8_,param2,param3 + 1);
               }
               if(_loc6_ < _loc7_.length - 1)
               {
                  _loc4_ += ",";
                  if(_loc8_ is Number || _loc8_ is int || _loc8_ is uint || _loc8_ is String)
                  {
                     _loc4_ += " ";
                  }
                  else
                  {
                     _loc4_ += "\n";
                  }
               }
               _loc6_++;
            }
            if(_loc7_.length > 0 && (_loc7_[_loc7_.length - 1] is Number || _loc7_[_loc7_.length - 1] is String || _loc7_[_loc7_.length - 1] is int || _loc7_[_loc7_.length - 1] is uint))
            {
               _loc4_ += "]";
            }
            else
            {
               _loc4_ += "\n" + _loc5_ + "]";
            }
         }
         else if(param1 is Object)
         {
            _loc9_ = [];
            for(_loc10_ in param1)
            {
               _loc9_.push(_loc10_);
            }
            if(_loc9_.indexOf("profile") != -1)
            {
               _loc9_.splice(_loc9_.indexOf("profile"),1);
               _loc9_.unshift("profile");
            }
            if(_loc9_.length == 0)
            {
               _loc4_ += "{}";
            }
            else
            {
               _loc4_ += "{\n";
               _loc11_ = 0;
               while(_loc11_ < _loc9_.length)
               {
                  _loc12_ = _loc9_[_loc11_];
                  _loc4_ += _loc5_ + param2 + "\"" + _loc12_ + "\": ";
                  if(_loc12_ == "profile")
                  {
                     _loc4_ += "\"" + String(param1[_loc12_]) + "\"";
                  }
                  else
                  {
                     _loc4_ += stringifyPretty(param1[_loc12_],param2,param3 + 1);
                  }
                  if(_loc11_ < _loc9_.length - 1)
                  {
                     _loc4_ += ",";
                  }
                  _loc4_ += "\n";
                  _loc11_++;
               }
               _loc4_ += _loc5_ + "}";
            }
         }
         else if(param1 is String)
         {
            _loc4_ += "\"" + param1 + "\"";
         }
         else if(param1 is Number || param1 is int || param1 is uint)
         {
            _loc4_ += "\"0x" + uint(param1).toString(16).toUpperCase() + "\"";
         }
         else
         {
            _loc4_ += String(param1);
         }
         return _loc4_;
      }
   }
}


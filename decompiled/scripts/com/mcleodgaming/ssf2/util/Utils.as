package com.mcleodgaming.ssf2.util
{
   import com.adobe.images.*;
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.items.*;
   import fl.motion.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.*;
   
   public class Utils
   {
      
      private static var rndm:Rndm;
      
      private static var safeRndm:Rndm;
      
      private static var origSeed:Number;
      
      private static var lastRandom:Number;
      
      private static var lastSafeRandom:Number;
      
      public static var fileRef:FileReference;
      
      public static var VELOCITY_SCALE:Number = 3.488;
      
      public static var WEIGHT2_BASE:Number = 0.051;
      
      public static var KEY_ARR:Object = getKeysArray(false);
      
      public static var KEY_ARR_SHORT:Object = getKeysArray(true);
      
      public static const EMPTY_PALETTE_SWAP:Object = {
         "colors":[],
         "replacements":[]
      };
      
      private static var UID:int = 0;
      
      private static var paletteRect:Rectangle = new Rectangle();
      
      private static var palettePoint:Point = new Point();
      
      private static var KEY:String = "b0cb1f1f-bc82-40bc-a1d7-1a2d16a6e8d1";
      
      public static var openSuccess:Boolean = false;
      
      public static var saveSuccess:Boolean = false;
      
      public static var finishedLoading:Boolean = false;
      
      public static var cancelled:Boolean = false;
      
      init();
      
      public function Utils()
      {
         super();
      }
      
      public static function init() : void
      {
      }
      
      public static function initializeUtilsClass() : void
      {
         Utils.rndm = new Rndm();
         Utils.safeRndm = new Rndm();
         origSeed = Math.round(Math.random() * 1000000 + 1);
         Utils.setRandSeed(origSeed);
         trace("Utils class initialized w/ seed of " + origSeed);
      }
      
      public static function resetUID() : void
      {
         Utils.UID = 0;
      }
      
      public static function getUID() : int
      {
         if(Utils.UID >= int.MAX_VALUE)
         {
            Utils.UID = 0;
         }
         return Utils.UID++;
      }
      
      public static function get LastRandom() : Number
      {
         return lastRandom;
      }
      
      public static function get LastSafeRandom() : Number
      {
         return lastSafeRandom;
      }
      
      public static function fastAbs(param1:Number) : Number
      {
         return param1 > 0 ? param1 : -param1;
      }
      
      public static function getSign(param1:Number) : Number
      {
         return param1 > 0 ? 1 : -1;
      }
      
      public static function framesToMinutesString(param1:int, param2:Number = 30) : String
      {
         var _loc3_:int = int(param1 / (param2 * 60));
         return _loc3_ + "";
      }
      
      public static function framesToSecondsString(param1:int, param2:Number = 30) : String
      {
         var _loc3_:int = int(param1 / (param2 * 60));
         var _loc4_:int = int((param1 - _loc3_ * param2 * 60) / param2);
         return _loc4_ < 10 ? "0" + _loc4_ : _loc4_ + "";
      }
      
      public static function framesToMillisecondsString(param1:int, param2:Number = 30) : String
      {
         var _loc3_:int = int(param1 / (param2 * 60));
         var _loc4_:int = int((param1 - _loc3_ * param2 * 60) / param2);
         var _loc5_:int = int((param1 - _loc3_ * param2 * 60 - _loc4_ * param2) / param2 * 100);
         return _loc5_ < 10 ? "0" + _loc5_ : _loc5_ + "";
      }
      
      public static function framesToTimeString(param1:int) : String
      {
         return Utils.framesToMinutesString(param1) + ":" + Utils.framesToSecondsString(param1) + " \'" + Utils.framesToMillisecondsString(param1);
      }
      
      public static function generateReplaySaveFileName(param1:StageData) : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc12_:int = 0;
         var _loc4_:Date = new Date();
         var _loc5_:String = "" + _loc4_.getFullYear();
         var _loc6_:String = _loc4_.getMonth() < 9 ? "0" + (_loc4_.getMonth() + 1) : "" + (_loc4_.getMonth() + 1);
         var _loc7_:String = _loc4_.getDate() < 9 ? "0" + (_loc4_.getDate() + 1) : "" + (_loc4_.getDate() + 1);
         var _loc8_:String = _loc4_.getHours() < 13 ? "" + _loc4_.getHours() : "" + (_loc4_.getHours() - 12);
         var _loc9_:String = "" + _loc4_.getMinutes();
         var _loc10_:String = _loc4_.getHours() < 12 ? "AM" : "PM";
         if(_loc4_.getMinutes() < 10)
         {
            _loc9_ = "0" + _loc9_;
         }
         var _loc11_:Array = [];
         while(_loc12_ < param1.Players.length)
         {
            if(param1.Players[_loc12_])
            {
               _loc2_ = "";
               _loc3_ = Stats.getStats(param1.Players[_loc12_].getPlayerSettings().character).DisplayName;
               if(param1.Players[_loc12_].IsHuman)
               {
                  if(param1.Players[_loc12_].getPlayerSettings().name)
                  {
                     _loc2_ = param1.Players[_loc12_].getPlayerSettings().name;
                  }
                  else
                  {
                     _loc2_ = "P" + (_loc12_ + 1);
                  }
               }
               else
               {
                  _loc2_ = "CPU Lvl " + param1.Players[_loc12_].getPlayerSettings().level;
               }
               _loc2_ = _loc2_.replace(/^[^a-zA-Z_]+|[^a-zA-Z_0-9\s\-]+/g,"");
               _loc3_ = _loc3_.replace(/&/g,"and");
               _loc3_ = _loc3_.replace(/^[^a-zA-Z_]+|[^a-zA-Z_0-9\s\-]+/g,"");
               _loc11_.push(_loc2_ + " (" + _loc3_ + ")");
            }
            _loc12_++;
         }
         var _loc13_:String = "";
         if(param1.GameRef.GameMode === Mode.VS)
         {
            _loc13_ = "Versus";
         }
         else if(param1.GameRef.GameMode === Mode.ONLINE)
         {
            _loc13_ = "VersusOnline";
         }
         else if(param1.GameRef.GameMode === Mode.ARENA)
         {
            _loc13_ = "Arena";
         }
         else if(param1.GameRef.GameMode === Mode.ONLINE_ARENA)
         {
            _loc13_ = "ArenaOnline";
         }
         else if(param1.GameRef.GameMode === Mode.TARGET_TEST)
         {
            _loc13_ = "BTT ";
            _loc13_ += param1.GameRef.LevelData.customModeID;
         }
         else if(param1.GameRef.GameMode === Mode.HOME_RUN_CONTEST)
         {
            _loc13_ = param1.GameRef.LevelData.customModeID;
         }
         else if(param1.GameRef.GameMode === Mode.MULTIMAN)
         {
            _loc13_ = "Multiman";
            if(param1.GameRef.LevelData.customModeID == "man10")
            {
               _loc13_ += "10";
            }
            else if(param1.GameRef.LevelData.customModeID == "man100")
            {
               _loc13_ += "100";
            }
            else if(param1.GameRef.LevelData.customModeID == "min3")
            {
               _loc13_ += "3Min";
            }
            else if(param1.GameRef.LevelData.customModeID == "endless")
            {
               _loc13_ += "Endless";
            }
            else if(param1.GameRef.LevelData.customModeID == "cruel")
            {
               _loc13_ += "Cruel";
            }
         }
         else if(param1.GameRef.GameMode === Mode.CRYSTAL_SMASH)
         {
            _loc13_ = "CrystalSmash ";
            _loc13_ += param1.GameRef.LevelData.customModeID;
         }
         else if(param1.GameRef.GameMode === Mode.RACE_TO_THE_FINISH)
         {
            _loc13_ = "RaceToTheFinish";
         }
         if(_loc13_)
         {
            _loc13_ += " - ";
         }
         return _loc5_ + "-" + _loc6_ + "-" + _loc7_ + " " + _loc8_ + "." + _loc9_ + " " + _loc10_ + " - " + _loc13_ + _loc11_.join(" vs ");
      }
      
      public static function toRadians(param1:Number) : Number
      {
         return param1 * (Math.PI / 180);
      }
      
      public static function toDegrees(param1:Number) : Number
      {
         return param1 * (180 / Math.PI);
      }
      
      public static function getDistanceFrom(param1:InteractiveSprite, param2:InteractiveSprite) : Number
      {
         if(param1 == null || param2 == null)
         {
            return 0;
         }
         return Math.sqrt(Math.pow(param1.X - param2.X,2) + Math.pow(param1.Y - param2.Y,2));
      }
      
      public static function getDistance(param1:Point, param2:Point) : Number
      {
         if(param1 == null || param2 == null)
         {
            return 0;
         }
         return Math.sqrt(Math.pow(param1.x - param2.x,2) + Math.pow(param1.y - param2.y,2));
      }
      
      public static function calculateXSpeed(param1:Number, param2:Number) : Number
      {
         return param1 * Math.cos(param2 * Math.PI / 180);
      }
      
      public static function calculateYSpeed(param1:Number, param2:Number) : Number
      {
         return param1 * Math.sin(param2 * Math.PI / 180);
      }
      
      public static function calculateSpeed(param1:Number, param2:Number) : Number
      {
         return Math.sqrt(Math.pow(param1,2) + Math.pow(param2,2));
      }
      
      public static function calculateHeightDiff(param1:Number, param2:Number = 45, param3:Number = 10) : Number
      {
         if(param1 > param3)
         {
            param1 = param3;
         }
         return Utils.fastAbs(param1 * Math.tan(Utils.toRadians(Utils.forceBase360(param2))));
      }
      
      public static function calculateBounceSpeed(param1:Number, param2:Number, param3:Number) : Number
      {
         var _loc6_:int = 0;
         param1 = Number(Utils.fastAbs(param1));
         param2 = Number(Utils.fastAbs(param2));
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc7_:Number = -param1;
         while(_loc7_ < 0)
         {
            _loc4_ += _loc7_;
            _loc7_ += param2;
         }
         _loc5_ = _loc4_ * param3;
         _loc7_ = -param1;
         _loc4_ = 0;
         while(_loc4_ > _loc5_ && _loc7_ < 0)
         {
            _loc6_++;
            _loc4_ += _loc7_;
            _loc7_ += param2;
         }
         return _loc7_ - param2 * _loc6_;
      }
      
      public static function getSpeedCap(param1:Number, param2:Number) : Number
      {
         if(param1 < 0)
         {
            return param2;
         }
         return param1;
      }
      
      public static function swapLocations(param1:DisplayObject, param2:DisplayObject) : void
      {
         var _loc3_:int = param1.x;
         var _loc4_:int = param1.y;
         param1.x = param2.x;
         param1.y = param2.y;
         param2.x = _loc3_;
         param2.y = _loc4_;
      }
      
      public static function swapDepths(param1:DisplayObject, param2:DisplayObject) : void
      {
         if(param1 != null && param2 != null && param1.parent == param2.parent && param1.parent != null)
         {
            param1.parent.swapChildren(param1,param2);
         }
      }
      
      public static function tryToGotoAndPlay(param1:MovieClip, param2:*, param3:Boolean = false) : void
      {
         if(param2 is int || param2 is Number)
         {
            if(param2 > 0 && param2 <= param1.totalFrames)
            {
               param1.gotoAndPlay(param2);
            }
         }
         else if(param2 is String)
         {
            if(Utils.hasLabel(param1,param2,param3))
            {
               param1.gotoAndPlay(param2);
            }
         }
      }
      
      public static function tryToGotoAndStop(param1:MovieClip, param2:*, param3:Boolean = false) : void
      {
         if(!param1)
         {
            return;
         }
         if(param2 is int || param2 is Number)
         {
            if(param2 > 0 && param2 <= param1.totalFrames)
            {
               param1.gotoAndStop(param2);
            }
         }
         else if(param2 is String)
         {
            if(Utils.hasLabel(param1,param2,param3))
            {
               param1.gotoAndStop(param2);
            }
         }
      }
      
      public static function getFileNameFromURL(param1:String) : String
      {
         var _loc2_:int = param1.lastIndexOf("/");
         if(_loc2_ == param1.length - 1)
         {
            param1 = param1.substr(0,param1.length - 1);
         }
         _loc2_ = param1.lastIndexOf("/");
         if(_loc2_ < 0 || _loc2_ == param1.length - 1)
         {
            return param1;
         }
         return param1.substr(_loc2_ + 1);
      }
      
      public static function getColorString(param1:int) : String
      {
         return param1 == 1 ? "red" : (param1 == 2 ? "green" : (param1 == 3 ? "blue" : null));
      }
      
      public static function getCostumeObject(param1:Object = null) : Object
      {
         var _loc2_:* = undefined;
         param1 = param1 ? Utils.cloneObject(param1) : {};
         var _loc3_:Object = new Object();
         _loc3_.hue = 0;
         _loc3_.saturation = 0;
         _loc3_.brightness = 0;
         _loc3_.contrast = 0;
         _loc3_.redMultiplier = 1;
         _loc3_.greenMultiplier = 1;
         _loc3_.blueMultiplier = 1;
         _loc3_.alphaMultiplier = 1;
         _loc3_.redOffset = 0;
         _loc3_.greenOffset = 0;
         _loc3_.blueOffset = 0;
         _loc3_.alphaOffset = 0;
         for(_loc2_ in _loc3_)
         {
            if(param1[_loc2_] === undefined)
            {
               param1[_loc2_] = _loc3_[_loc2_];
            }
         }
         return param1;
      }
      
      public static function setColorFilterCharacter(param1:MovieClip, param2:int, param3:String, param4:int = -1, param5:Boolean = false, param6:Boolean = false) : void
      {
         var _loc7_:String = Utils.getColorString(param2);
         var _loc8_:Object = ResourceManager.getCostume(param3,_loc7_,param4);
         if(_loc8_ == null)
         {
            _loc8_ = Utils.getCostumeObject();
         }
         if(_loc8_ != null)
         {
            Utils.setColorFilter(param1,_loc8_);
         }
         Utils.replacePalette(param1,param5 ? _loc8_.paletteSwapPA : _loc8_.paletteSwap,2,true,param6);
      }
      
      public static function setColorFilter(param1:DisplayObject, param2:Object) : void
      {
         var _loc3_:AdjustColor = null;
         var _loc4_:Array = null;
         if(!param1 || !param2)
         {
            param1.filters = null;
            return;
         }
         param2 = Utils.getCostumeObject(param2);
         var _loc5_:Array = [];
         if(!(param2.hue == 0 && param2.saturation == 0 && param2.brightness == 0 && param2.contrast == 0))
         {
            _loc3_ = new AdjustColor();
            _loc3_.hue = Number(param2.hue) || 0;
            _loc3_.saturation = Number(param2.saturation) || 0;
            _loc3_.brightness = Number(param2.brightness) || 0;
            _loc3_.contrast = Number(param2.contrast) || 0;
            _loc5_.push(new ColorMatrixFilter(_loc3_.CalculateFinalFlatArray()));
         }
         if(!(param2.redMultiplier == 1 && param2.greenMultiplier == 1 && param2.blueMultiplier == 1 && param2.alphaMultiplier == 1 && param2.redOffset == 0 && param2.greenOffset == 0 && param2.blueOffset == 0 && param2.alphaOffset == 0))
         {
            _loc4_ = new Array();
            _loc4_ = _loc4_.concat([param2.redMultiplier,0,0,0,param2.redOffset]);
            _loc4_ = _loc4_.concat([0,param2.greenMultiplier,0,0,param2.greenOffset]);
            _loc4_ = _loc4_.concat([0,0,param2.blueMultiplier,0,param2.blueOffset]);
            _loc4_ = _loc4_.concat([0,0,0,param2.alphaMultiplier || 1,param2.alphaOffset]);
            _loc5_.push(new ColorMatrixFilter(_loc4_));
         }
         param1.filters = _loc5_;
      }
      
      public static function setTint(param1:DisplayObject, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number) : void
      {
         var _loc10_:ColorTransform = new ColorTransform();
         _loc10_.redMultiplier = param2;
         _loc10_.greenMultiplier = param3;
         _loc10_.blueMultiplier = param4;
         _loc10_.alphaMultiplier = param5;
         _loc10_.redOffset = param6;
         _loc10_.greenOffset = param7;
         _loc10_.blueOffset = param8;
         _loc10_.alphaOffset = param9;
         param1.transform.colorTransform = _loc10_;
      }
      
      public static function setBrightness(param1:MovieClip, param2:Number) : void
      {
         if(Math.abs(param2) > 100)
         {
            param2 = param2 > 0 ? 100 : -100;
         }
         var _loc3_:ColorTransform = new ColorTransform();
         _loc3_.redOffset = param2 * 2.55;
         _loc3_.greenOffset = param2 * 2.55;
         _loc3_.blueOffset = param2 * 2.55;
         param1.transform.colorTransform = _loc3_;
      }
      
      public static function extractAlpha(param1:int) : int
      {
         return (param1 & 0xFF000000) >> 24;
      }
      
      public static function extractRed(param1:int) : int
      {
         return (param1 & 0xFF0000) >> 16;
      }
      
      public static function extractGreen(param1:int) : int
      {
         return (param1 & 0xFF00) >> 8;
      }
      
      public static function extractBlue(param1:int) : int
      {
         return param1 & 0xFF;
      }
      
      public static function convertTeamToColor(param1:int, param2:int) : int
      {
         var _loc3_:int = -1;
         if(param2 > 0)
         {
            switch(param2)
            {
               case 1:
                  _loc3_ = 1;
                  break;
               case 2:
                  _loc3_ = 4;
                  break;
               case 3:
                  _loc3_ = 2;
            }
         }
         else
         {
            switch(param1)
            {
               case 1:
                  _loc3_ = 1;
                  break;
               case 2:
                  _loc3_ = 2;
                  break;
               case 3:
                  _loc3_ = 3;
                  break;
               case 4:
                  _loc3_ = 4;
            }
         }
         return _loc3_;
      }
      
      public static function replacePalette(param1:MovieClip, param2:Object, param3:int = 1, param4:Boolean = false, param5:Boolean = false) : void
      {
         var _loc6_:int = 0;
         var _loc7_:Bitmap = null;
         if((Boolean(param2) || Boolean(param4)) && Boolean(param1))
         {
            _loc6_ = 0;
            _loc7_ = null;
            _loc6_ = 0;
            while(_loc6_ < param1.numChildren)
            {
               if(param1.getChildAt(_loc6_) is Bitmap)
               {
                  _loc7_ = param1.getChildAt(_loc6_) as Bitmap;
                  if(param4)
                  {
                     if(!param1.__cachedPalette || !param1.__cachedPalette[_loc7_.bitmapData])
                     {
                        param1.__cachedPalette = param1.__cachedPalette || new flash.utils.Dictionary(true);
                        param1.__cachedPalette[_loc7_.bitmapData] = _loc7_.bitmapData.clone();
                     }
                     else
                     {
                        _loc7_.bitmapData.draw(param1.__cachedPalette[_loc7_.bitmapData]);
                     }
                  }
                  if(param2)
                  {
                     Utils.replacePaletteHelper(_loc7_.bitmapData,param2);
                  }
                  _loc7_.smoothing = param5;
               }
               else if(param1.getChildAt(_loc6_) is MovieClip && param3 > 0)
               {
                  Utils.replacePalette(param1.getChildAt(_loc6_) as MovieClip,param2,param3 - 1,param4,param5);
               }
               _loc6_++;
            }
         }
      }
      
      public static function replacePaletteHelper(param1:BitmapData, param2:Object) : void
      {
         var _loc3_:int = 0;
         Utils.paletteRect.width = param1.width;
         Utils.paletteRect.height = param1.height;
         while(_loc3_ < param2.colors.length)
         {
            if(param2.colors[_loc3_] != param2.replacements[_loc3_])
            {
               param1.threshold(param1,Utils.paletteRect,Utils.palettePoint,"==",param2.colors[_loc3_],param2.replacements[_loc3_],4294967295,true);
            }
            _loc3_++;
         }
      }
      
      public static function saveSnapShot(param1:MovieClip) : void
      {
         var _loc2_:BitmapData = Utils.getSnapshot(param1);
         var _loc3_:ByteArray = PNGEncoder.encode(_loc2_);
         Utils.saveFile(_loc3_,"New SSF2 Screenshot.png");
         _loc2_.dispose();
         _loc2_ = null;
      }
      
      public static function getSnapshot(param1:MovieClip) : BitmapData
      {
         var _loc2_:BitmapData = new BitmapData(Main.Width,Main.Height);
         _loc2_.draw(param1);
         return _loc2_;
      }
      
      public static function removeActionScript(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.totalFrames)
         {
            param1.addFrameScript(_loc2_,null);
            _loc2_++;
         }
      }
      
      public static function setRandSeed(param1:Number) : void
      {
         Utils.rndm.seed = param1;
         Utils.safeRndm.seed = param1;
         trace("Rand seed set to: " + param1);
      }
      
      public static function random() : Number
      {
         var _loc1_:Number = Number(Utils.rndm.nextDouble());
         lastRandom = _loc1_;
         return _loc1_;
      }
      
      public static function randomInteger(param1:int, param2:int) : int
      {
         return Math.floor(Utils.random() * (param2 - param1 + 1)) + param1;
      }
      
      public static function shuffleRandom() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 100)
         {
            random();
            safeRandom();
            _loc1_++;
         }
      }
      
      public static function safeRandom() : Number
      {
         var _loc1_:Number = Number(Utils.safeRndm.nextDouble());
         lastSafeRandom = _loc1_;
         return _loc1_;
      }
      
      public static function safeRandomInteger(param1:int, param2:int) : int
      {
         return Math.floor(Utils.safeRandom() * (param2 - param1 + 1)) + param1;
      }
      
      public static function randomizeArray(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_.push(_loc2_);
            _loc2_++;
         }
         while(_loc3_.length)
         {
            _loc4_.push(param1[_loc3_.splice(Utils.randomInteger(0,_loc3_.length - 1),1)[0]]);
         }
         _loc2_ = 0;
         while(_loc2_ < _loc4_.length)
         {
            param1[_loc2_] = _loc4_[_loc2_];
            _loc2_++;
         }
      }
      
      public static function hasLabel(param1:MovieClip, param2:String, param3:Boolean = false) : Boolean
      {
         var _loc4_:FrameLabel = null;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         if(param1 == null)
         {
            return false;
         }
         if(param3)
         {
            if(param1.__cachedLabels)
            {
               return Boolean(param1.__cachedLabels[param2]);
            }
            param1.__cachedLabels = {};
         }
         while(_loc6_ < param1.currentLabels.length)
         {
            _loc4_ = param1.currentLabels[_loc6_];
            if(param2 == _loc4_.name)
            {
               _loc5_ = true;
            }
            if(param3)
            {
               param1.__cachedLabels[_loc4_.name] = true;
            }
            else if(_loc5_)
            {
               return true;
            }
            _loc6_++;
         }
         return _loc5_;
      }
      
      public static function fitText(param1:TextField, param2:Number, param3:Number = 1) : void
      {
         var _loc4_:TextFormat = param1.getTextFormat();
         _loc4_.size = param2;
         param1.setTextFormat(_loc4_);
         while(param1.numLines > param3)
         {
            _loc4_.size = Number(_loc4_.size) - 1;
            param1.setTextFormat(_loc4_);
         }
         param1.setTextFormat(_loc4_);
      }
      
      public static function recursiveMovieClipPlay(param1:MovieClip, param2:Boolean, param3:Boolean = false) : void
      {
         var _loc4_:int = 0;
         while(param1 != null && _loc4_ < param1.numChildren)
         {
            if(param1.getChildAt(_loc4_) is MovieClip)
            {
               recursiveMovieClipPlayChildren(MovieClip(param1.getChildAt(_loc4_)),param2,param3);
            }
            _loc4_++;
         }
      }
      
      private static function recursiveMovieClipPlayChildren(param1:MovieClip, param2:Boolean, param3:Boolean = false) : void
      {
         var _loc4_:int = 0;
         if(param1.bypassTicker)
         {
            return;
         }
         if(!param2)
         {
            param1.stop();
         }
         else if(param3)
         {
            param1.play();
         }
         else if(param1.currentFrame == param1.totalFrames)
         {
            param1.gotoAndStop(1);
         }
         else
         {
            param1.nextFrame();
         }
         while(_loc4_ < param1.numChildren)
         {
            if(param1.getChildAt(_loc4_) is MovieClip)
            {
               recursiveMovieClipPlayChildren(MovieClip(param1.getChildAt(_loc4_)),param2,param3);
            }
            _loc4_++;
         }
      }
      
      public static function advanceFrame(param1:MovieClip) : void
      {
         var mc:MovieClip = param1;
         if(!mc)
         {
            return;
         }
         if(mc.bypassTicker)
         {
            return;
         }
         if(mc.currentFrame == mc.totalFrames && mc.totalFrames > 1)
         {
            mc.gotoAndStop(1);
         }
         else
         {
            try
            {
               mc.nextFrame();
            }
            catch(e:*)
            {
               trace("hhe");
            }
            mc.stop();
         }
      }
      
      public static function getControlsAngle(param1:Object) : Number
      {
         if(Boolean(param1.UP) && Boolean(!param1.DOWN) && Boolean(param1.LEFT) && !param1.RIGHT)
         {
            return 135;
         }
         if(Boolean(param1.UP && !param1.DOWN) && Boolean(!param1.LEFT) && Boolean(param1.RIGHT))
         {
            return 45;
         }
         if(Boolean(!param1.UP) && Boolean(param1.DOWN) && Boolean(param1.LEFT) && !param1.RIGHT)
         {
            return 225;
         }
         if(Boolean(!param1.UP && param1.DOWN) && Boolean(!param1.LEFT) && Boolean(param1.RIGHT))
         {
            return 315;
         }
         if(Boolean(param1.UP && !param1.DOWN) && Boolean(!param1.LEFT) && !param1.RIGHT)
         {
            return 90;
         }
         if(Boolean(!param1.UP && param1.DOWN) && Boolean(!param1.LEFT) && !param1.RIGHT)
         {
            return 270;
         }
         if(Boolean(!param1.UP && !param1.DOWN) && Boolean(param1.LEFT) && !param1.RIGHT)
         {
            return 180;
         }
         if(!param1.UP && !param1.DOWN && !param1.LEFT && Boolean(param1.RIGHT))
         {
            return 0;
         }
         return -1;
      }
      
      public static function forceBase360(param1:Number) : Number
      {
         while(param1 < 0)
         {
            param1 += 360;
         }
         while(param1 >= 360)
         {
            param1 -= 360;
         }
         return param1;
      }
      
      public static function calculateDifferenceBetweenAngles(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = param2 - param1;
         while(_loc3_ < -180)
         {
            _loc3_ += 360;
         }
         while(_loc3_ > 180)
         {
            _loc3_ -= 360;
         }
         return _loc3_;
      }
      
      public static function rotatePointAroundOrigin(param1:Point, param2:Number) : Point
      {
         var _loc3_:Point = new Point();
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         if(param2 != 0)
         {
            _loc4_ = Number(Utils.toRadians(Utils.getAngleBetween(_loc3_,param1)));
            _loc5_ = Number(Point.distance(_loc3_,param1));
            param1.copyFrom(Point.polar(_loc5_,_loc4_ + Utils.toRadians(param2)));
            param1.y *= -1;
         }
         return param1;
      }
      
      public static function rotateRectangleAroundOrigin(param1:Rectangle, param2:Number) : Rectangle
      {
         var _loc4_:Point = null;
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         var _loc7_:Point = null;
         var _loc3_:Point = new Point();
         var _loc8_:Number = 0;
         var _loc9_:Number = 0;
         var _loc10_:Number = 0;
         var _loc11_:Number = 0;
         var _loc12_:Number = 0;
         var _loc13_:Number = 0;
         var _loc14_:Number = 0;
         var _loc15_:Number = 0;
         var _loc16_:Number = 0;
         var _loc17_:Number = 0;
         var _loc18_:Number = 0;
         var _loc19_:Number = 0;
         if(param2 != 0)
         {
            _loc4_ = new Point(param1.x,param1.y);
            _loc5_ = new Point(param1.x + param1.width,param1.y);
            _loc6_ = new Point(param1.x + param1.width,param1.y + param1.height);
            _loc7_ = new Point(param1.x,param1.y + param1.height);
            _loc12_ = Number(Utils.toRadians(Utils.getAngleBetween(_loc3_,_loc4_)));
            _loc13_ = Number(Utils.toRadians(Utils.getAngleBetween(_loc3_,_loc5_)));
            _loc14_ = Number(Utils.toRadians(Utils.getAngleBetween(_loc3_,_loc6_)));
            _loc15_ = Number(Utils.toRadians(Utils.getAngleBetween(_loc3_,_loc7_)));
            _loc16_ = Number(Point.distance(_loc3_,_loc4_));
            _loc17_ = Number(Point.distance(_loc3_,_loc5_));
            _loc18_ = Number(Point.distance(_loc3_,_loc6_));
            _loc19_ = Number(Point.distance(_loc3_,_loc7_));
            _loc4_ = Point.polar(_loc16_,_loc12_ + Utils.toRadians(param2));
            _loc5_ = Point.polar(_loc17_,_loc13_ + Utils.toRadians(param2));
            _loc6_ = Point.polar(_loc18_,_loc14_ + Utils.toRadians(param2));
            _loc7_ = Point.polar(_loc19_,_loc15_ + Utils.toRadians(param2));
            _loc4_.y *= -1;
            _loc5_.y *= -1;
            _loc6_.y *= -1;
            _loc7_.y *= -1;
            _loc8_ = Math.min(_loc4_.x,_loc5_.x,_loc6_.x,_loc7_.x);
            _loc9_ = Math.min(_loc4_.y,_loc5_.y,_loc6_.y,_loc7_.y);
            _loc10_ = Math.max(_loc4_.x,_loc5_.x,_loc6_.x,_loc7_.x);
            _loc11_ = Math.max(_loc4_.y,_loc5_.y,_loc6_.y,_loc7_.y);
            param1.x = _loc8_;
            param1.y = _loc9_;
            param1.width = _loc10_ - _loc8_;
            param1.height = _loc11_ - _loc9_;
         }
         return param1;
      }
      
      public static function rotateRectangleAroundOriginPoints(param1:Rectangle, param2:Number, param3:Point, param4:Point) : Vector.<Point>
      {
         var _loc6_:Point = null;
         var _loc7_:Point = null;
         var _loc8_:Point = null;
         var _loc9_:Point = null;
         var _loc5_:Point = new Point();
         var _loc10_:Number = 0;
         var _loc11_:Number = 0;
         var _loc12_:Number = 0;
         var _loc13_:Number = 0;
         var _loc14_:Number = 0;
         var _loc15_:Number = 0;
         var _loc16_:Number = 0;
         var _loc17_:Number = 0;
         var _loc18_:Number = 0;
         var _loc19_:Number = 0;
         var _loc20_:Number = 0;
         var _loc21_:Number = 0;
         _loc6_ = new Point(param1.x,param1.y);
         _loc7_ = new Point(param1.x + param1.width,param1.y);
         _loc8_ = new Point(param1.x + param1.width,param1.y + param1.height);
         _loc9_ = new Point(param1.x,param1.y + param1.height);
         _loc6_.x *= param3.x;
         _loc6_.y *= param3.y;
         _loc7_.x *= param3.x;
         _loc7_.y *= param3.y;
         _loc8_.x *= param3.x;
         _loc8_.y *= param3.y;
         _loc9_.x *= param3.x;
         _loc9_.y *= param3.y;
         if(param2 != 0)
         {
            _loc14_ = Number(Utils.toRadians(Utils.getAngleBetween(_loc5_,_loc6_)));
            _loc15_ = Number(Utils.toRadians(Utils.getAngleBetween(_loc5_,_loc7_)));
            _loc16_ = Number(Utils.toRadians(Utils.getAngleBetween(_loc5_,_loc8_)));
            _loc17_ = Number(Utils.toRadians(Utils.getAngleBetween(_loc5_,_loc9_)));
            _loc18_ = Number(Point.distance(_loc5_,_loc6_));
            _loc19_ = Number(Point.distance(_loc5_,_loc7_));
            _loc20_ = Number(Point.distance(_loc5_,_loc8_));
            _loc21_ = Number(Point.distance(_loc5_,_loc9_));
            _loc6_ = Point.polar(_loc18_,_loc14_ + Utils.toRadians(param2));
            _loc7_ = Point.polar(_loc19_,_loc15_ + Utils.toRadians(param2));
            _loc8_ = Point.polar(_loc20_,_loc16_ + Utils.toRadians(param2));
            _loc9_ = Point.polar(_loc21_,_loc17_ + Utils.toRadians(param2));
            _loc6_.y *= -1;
            _loc7_.y *= -1;
            _loc8_.y *= -1;
            _loc9_.y *= -1;
         }
         _loc6_.offset(param4.x,param4.y);
         _loc7_.offset(param4.x,param4.y);
         _loc8_.offset(param4.x,param4.y);
         _loc9_.offset(param4.x,param4.y);
         var _loc22_:Vector.<Point> = new Vector.<Point>();
         _loc22_.push(_loc6_);
         _loc22_.push(_loc7_);
         _loc22_.push(_loc8_);
         _loc22_.push(_loc9_);
         return _loc22_;
      }
      
      public static function rotateAroundCenter(param1:MovieClip, param2:Boolean, param3:Number) : void
      {
      }
      
      public static function testRectangleToPoint(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : Boolean
      {
         if(param3 == 0)
         {
            return Math.abs(param4 - param6) < param1 / 2 && Math.abs(param5 - param7) < param2 / 2;
         }
         var _loc8_:Number = Math.cos(param3) * param6 - Math.sin(param3) * param7;
         var _loc9_:Number = Math.cos(param3) * param7 + Math.sin(param3) * param6;
         var _loc10_:Number = Math.cos(param3) * param4 - Math.sin(param3) * param5;
         var _loc11_:Number = Math.cos(param3) * param5 + Math.sin(param3) * param4;
         return Math.abs(_loc10_ - _loc8_) < param1 / 2 && Math.abs(_loc11_ - _loc9_) < param2 / 2;
      }
      
      public static function testCircleToSegment(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : Boolean
      {
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = Math.sqrt(Math.pow(param4 - param6,2) + Math.pow(param5 - param7,2));
         if(_loc11_ == 0)
         {
            _loc8_ = Math.sqrt(Math.pow(param1 - param4,2) + Math.pow(param2 - param5,2));
            return _loc8_ < param3;
         }
         var _loc12_:Number = ((param1 - param4) * (param6 - param4) + (param2 - param5) * (param7 - param5)) / (_loc11_ * _loc11_);
         if(_loc12_ < 0)
         {
            _loc8_ = Math.sqrt(Math.pow(param1 - param4,2) + Math.pow(param2 - param5,2));
         }
         else if(_loc12_ > 1)
         {
            _loc8_ = Math.sqrt(Math.pow(param1 - param6,2) + Math.pow(param2 - param7,2));
         }
         else
         {
            _loc9_ = param4 + _loc12_ * (param6 - param4);
            _loc10_ = param5 + _loc12_ * (param7 - param5);
            _loc8_ = Math.sqrt(Math.pow(param1 - _loc9_,2) + Math.pow(param2 - _loc10_,2));
         }
         return _loc8_ < param3;
      }
      
      public static function testRectangleToCircle(param1:Vector.<Point>, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Boolean
      {
         return Boolean(Utils.testRectangleToPoint(param2,param3,0,param4,param5,param6,param7)) || Boolean(Utils.testCircleToSegment(param6,param7,param8,param1[0].x,param1[0].y,param1[1].x,param1[1].y)) || Boolean(Utils.testCircleToSegment(param6,param7,param8,param1[1].x,param1[1].y,param1[2].x,param1[2].y)) || Boolean(Utils.testCircleToSegment(param6,param7,param8,param1[2].x,param1[2].y,param1[3].x,param1[3].y)) || Boolean(Utils.testCircleToSegment(param6,param7,param8,param1[3].x,param1[3].y,param1[0].x,param1[0].y));
      }
      
      public static function getVelocityVector(param1:Number, param2:Number) : Point
      {
         var _loc3_:Point = new Point();
         _loc3_.x = param1 * Math.cos(param2 * Math.PI / 180);
         _loc3_.y = param1 * Math.sin(param2 * Math.PI / 180);
         return _loc3_;
      }
      
      public static function getAngleBetween(param1:Point, param2:Point) : Number
      {
         return Utils.forceBase360(Math.atan2(-(param2.y - param1.y),param2.x - param1.x) * 180 / Math.PI);
      }
      
      public static function calculateCamShake(param1:AttackDamage) : Number
      {
         return Math.floor((Math.floor(0.25 * param1.Damage + 0.75 * (0.001 * (Math.abs(param1.Power) * (param1.Power > 0 ? param1.KBConstant : 1))) - 5) + 3) / 2);
      }
      
      public static function calculateAttackDirection(param1:AttackDamage, param2:InteractiveSprite) : Number
      {
         var _loc3_:Boolean = true;
         var _loc4_:Boolean = param1.IsForward;
         var _loc5_:Number = 0;
         if(param1.Direction == -1)
         {
            _loc5_ = Math.round(Utils.random() * 360);
         }
         else if(param1.Direction == -2)
         {
            _loc5_ = Math.round(Utils.random() * (150 - 60)) + 60;
         }
         else if(param1.Direction == -3)
         {
            _loc5_ = param1.XLoc < param2.X ? 75 : 115;
            _loc4_ = param1.XLoc < param2.X;
            _loc3_ = false;
         }
         else if(param1.Direction == -4)
         {
            _loc5_ = param1.XLoc < param2.X ? 20 : 160;
            _loc4_ = param1.XLoc < param2.X;
            _loc3_ = false;
         }
         else if(param1.Direction == -5)
         {
            _loc5_ = param1.XLoc < param2.X ? 160 : 20;
            _loc4_ = param1.XLoc < param2.X;
            _loc3_ = false;
         }
         else if(param1.Direction == -6)
         {
            _loc5_ = param1.YLoc < param2.Y ? 115 : 75;
            _loc4_ = param1.XLoc < param2.X;
            _loc3_ = false;
         }
         else if(param1.Direction == -7)
         {
            _loc5_ = param1.YLoc < param2.Y ? 90 : 270;
         }
         else if(param1.Direction == -8)
         {
            _loc5_ = Number(Utils.getAngleBetween(new Point(param2.X,param2.Y),new Point(param2.X + param2.netXSpeed(),param2.Y + param2.netYSpeed())));
            _loc3_ = false;
         }
         else if(param1.Direction == -9 && Boolean(param1.Owner))
         {
            if(param1.Owner is Projectile)
            {
               if(Projectile(param1.Owner).XSpeed != 0 || Projectile(param1.Owner).YSpeed != 0)
               {
                  _loc5_ = Number(Utils.getAngleBetween(new Point(param2.X,param2.Y),new Point(param2.X + Projectile(param1.Owner).XSpeed,param2.Y + Projectile(param1.Owner).YSpeed)));
               }
            }
            else if(param1.Owner is Item)
            {
               if(Item(param1.Owner).XSpeed != 0 || Item(param1).YSpeed != 0)
               {
                  _loc5_ = Number(Utils.getAngleBetween(new Point(param2.X,param2.Y),new Point(param2.X + Item(param1).XSpeed,param2.Y + Item(param1).YSpeed)));
               }
            }
            else if(param1.Owner)
            {
               if(param1.Owner.netXSpeed() != 0 || param1.Owner.netYSpeed() != 0)
               {
                  _loc5_ = Number(Utils.getAngleBetween(new Point(param2.X,param2.Y),new Point(param2.X + param2.netXSpeed(),param2.Y + param2.netYSpeed())));
               }
               else
               {
                  _loc5_ = Number(Utils.getAngleBetween(new Point(param2.X,param2.Y),new Point(param2.X + param1.Owner.netXSpeed(),param2.Y + param1.Owner.netYSpeed())));
               }
            }
            _loc3_ = false;
         }
         else
         {
            _loc5_ = param1.Direction;
         }
         if(!_loc4_ && _loc3_)
         {
            _loc5_ = 180 - _loc5_;
         }
         return Utils.forceBase360(_loc5_);
      }
      
      public static function calculateReversedAngle(param1:Number, param2:AttackDamage, param3:InteractiveSprite) : Number
      {
         var _loc4_:Boolean = false;
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         if(param2.ReversableAngle && param2.Direction >= 0)
         {
            _loc4_ = param2.Direction > 90 && param2.Direction < 270;
            _loc5_ = Number(Utils.calculateXSpeed(1,param1));
            _loc6_ = -Utils.calculateYSpeed(1,param1);
            if(param3.getX() < param2.XLoc || param3.getX() > param2.XLoc)
            {
               _loc5_ = param3.getX() > param2.XLoc ? Number(Utils.fastAbs(_loc5_)) : -Utils.fastAbs(_loc5_);
               if(_loc4_)
               {
                  _loc5_ *= -1;
               }
               param1 = Number(Utils.getAngleBetween(new Point(),new Point(_loc5_,_loc6_)));
            }
         }
         return param1;
      }
      
      public static function calculateChargeDamage(param1:AttackDamage, param2:Number = -1) : Number
      {
         var _loc3_:Number = param2 >= 0 ? param2 : param1.Damage;
         if(param1.SizeStatus != 0)
         {
            _loc3_ *= param1.SizeStatus == 1 ? 1.25 : 0.75;
         }
         if(param1.ChargeTimeMax > 0 && !param1.IgnoreChargeDamage)
         {
            _loc3_ *= (1 + param1.ChargeTime / param1.ChargeTimeMax * 0.4) * param1.ChargeDamageMultiplier;
         }
         return _loc3_;
      }
      
      public static function calculateHitlag(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = Math.floor(param1 * 0.4 * (Main.FRAMERATE / 60));
         if(param2 < 0)
         {
            if(param2 < 0)
            {
               param2 *= -1;
            }
            _loc3_ = _loc4_;
            return Math.ceil(_loc3_ * param2);
         }
         return Math.round(param2);
      }
      
      public static function calculateRebound(param1:Number) : int
      {
         return (6.6 + Math.floor(param1) * 0.558) * 2;
      }
      
      public static function calculateKnockback(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Boolean, param8:Number, param9:Number) : Number
      {
         var _loc10_:Number = 1;
         var _loc11_:Number = 0;
         if(param4 > 999)
         {
            param4 = 999;
         }
         if(param3 != 0)
         {
            if(param2 <= 0)
            {
               param2 *= -1;
            }
            _loc11_ = ((param3 * 10 * 0.05 + 1) * _loc10_ * 1.4 * (200 / (param6 + 100)) + 18) * (param1 * 0.01) + param2;
         }
         else
         {
            _loc11_ = (((param5 + param4) * 0.1 + param4 * (param5 + param4) * 0.05) * _loc10_ * 1.4 * (200 / (param6 + 100)) + 18) * (param1 * 0.01) + param2;
         }
         if(param7)
         {
            _loc11_ *= 1.2;
         }
         _loc11_ *= param8;
         return _loc11_ * param9;
      }
      
      public static function calculateVelocity(param1:Number) : Number
      {
         var _loc2_:Number = 0;
         return param1 * 0.03 * Utils.VELOCITY_SCALE;
      }
      
      public static function calculateKnockbackFromVelocity(param1:Number) : Number
      {
         return param1 / (0.03 * Utils.VELOCITY_SCALE);
      }
      
      public static function calculateHitStun(param1:Number, param2:Number, param3:Boolean, param4:Boolean) : Number
      {
         if(param1 >= 0)
         {
            return param1;
         }
         var _loc5_:Number = param3 ? 1.5 : 1;
         var _loc6_:Number = param4 ? 2 / 3 : 1;
         return Math.ceil(_loc6_ * (Math.floor(_loc5_ * (param2 / 3 + 3)) / 2) * (-1 * param1) + 0.5);
      }
      
      public static function calculateSelfHitStun(param1:Number, param2:Number) : Number
      {
         if(param1 >= 0)
         {
            return param1;
         }
         return Math.floor(-param1 * ((param2 / 3 + 3) / 2));
      }
      
      public static function calculateGrabLength(param1:Number) : int
      {
         return (90 + param1 * 1.7) / 2;
      }
      
      public static function calculatePummelTime(param1:int) : int
      {
         return param1 / 13 * 3;
      }
      
      public static function getClass(param1:Object) : Class
      {
         return Class(getDefinitionByName(getQualifiedClassName(param1)));
      }
      
      public static function dijkstra(param1:StageData, param2:Vector.<Beacon>, param3:Array, param4:Beacon, param5:Beacon) : Array
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         param1.markBeaconsUnvisited();
         var _loc11_:* = int(param2.length);
         var _loc12_:Array = new Array(param2.length);
         var _loc13_:Array = new Array(param2.length);
         var _loc14_:Array = new Array(param2.length);
         _loc6_ = 0;
         while(_loc6_ < param2.length)
         {
            _loc12_[_loc6_] = int.MAX_VALUE;
            _loc13_[_loc6_] = -1;
            _loc14_[_loc6_] = -1;
            _loc6_++;
         }
         _loc12_[param4.BID] = 0;
         _loc10_ = param4.BID;
         while(_loc11_ > 0)
         {
            _loc8_ = -1;
            _loc9_ = int.MAX_VALUE;
            _loc6_ = 0;
            while(_loc6_ < param2.length)
            {
               if(param2[_loc6_].Visited == false && _loc12_[_loc6_] < _loc9_)
               {
                  _loc9_ = int(_loc12_[_loc6_]);
                  _loc8_ = _loc6_;
               }
               _loc6_++;
            }
            if(_loc9_ == int.MAX_VALUE || _loc8_ == -1)
            {
               break;
            }
            param2[_loc8_].Visited = true;
            _loc11_--;
            _loc7_ = int(Beacon.nextNeighbor(param1.getBeacons(),param1.getAdjMatrix(),_loc8_,-1));
            while(_loc7_ < param2.length)
            {
               if(param2[_loc7_].Visited == false && _loc12_[_loc7_] > _loc9_ + param3[_loc8_][_loc7_])
               {
                  _loc12_[_loc7_] = _loc9_ + param3[_loc8_][_loc7_];
                  _loc13_[_loc7_] = _loc8_;
                  _loc10_ = _loc7_;
               }
               _loc7_ = int(Beacon.nextNeighbor(param1.getBeacons(),param1.getAdjMatrix(),_loc8_,_loc7_));
            }
         }
         return _loc13_;
      }
      
      public static function getPath(param1:Vector.<Beacon>, param2:Array, param3:Number, param4:Number) : Vector.<Beacon>
      {
         var _loc5_:Vector.<Beacon> = new Vector.<Beacon>();
         _loc5_.push(param1[param4]);
         while(param4 != param3)
         {
            _loc5_.push(param1[param2[param4]]);
            param4 = Number(param2[param4]);
         }
         return _loc5_;
      }
      
      public static function getClosetBeaconTo(param1:StageData, param2:MovieClip) : Beacon
      {
         var _loc3_:Beacon = null;
         var _loc4_:Beacon = null;
         var _loc8_:int = 0;
         var _loc5_:Number = int.MAX_VALUE;
         var _loc6_:Number = 0;
         var _loc7_:Vector.<Beacon> = param1.getBeacons();
         while(_loc8_ < _loc7_.length)
         {
            _loc6_ = Math.sqrt(Math.pow(_loc7_[_loc8_].X - param2.x,2) + Math.pow(_loc7_[_loc8_].Y - param2.y,2));
            if(_loc6_ < _loc5_ && param1.beaconNeighborCount(_loc7_[_loc8_].BID) > 0)
            {
               _loc5_ = _loc6_;
               _loc3_ = _loc7_[_loc8_];
            }
            _loc8_++;
         }
         return _loc3_;
      }
      
      public static function get WeightBase() : Number
      {
         return 3.78 * 2.6455;
      }
      
      private static function xor(param1:String) : String
      {
         var _loc2_:String = KEY;
         var _loc3_:String = new String();
         var _loc4_:Number = 0;
         while(_loc4_ < param1.length)
         {
            if(_loc4_ > _loc2_.length - 1)
            {
               _loc2_ += _loc2_;
            }
            _loc3_ += String.fromCharCode(param1.charCodeAt(_loc4_) ^ _loc2_.charCodeAt(_loc4_));
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function encrypt(param1:String) : String
      {
         var _loc2_:String = param1;
         return Base64.encode(Utils.xor(_loc2_));
      }
      
      public static function decrypt(param1:String) : String
      {
         var _loc2_:String = param1;
         return Utils.xor(Base64.decode(_loc2_));
      }
      
      public static function openFile(param1:String = "SSF2 Save File (*.ssfsav)", param2:String = "*.ssfsav") : void
      {
         Utils.openSuccess = false;
         Utils.finishedLoading = false;
         Utils.cancelled = false;
         fileRef = new FileReference();
         fileRef.addEventListener(Event.SELECT,Utils.onFileSelected);
         fileRef.addEventListener(Event.CANCEL,Utils.onCancel);
         fileRef.addEventListener(IOErrorEvent.IO_ERROR,Utils.onIOError);
         fileRef.addEventListener(SecurityErrorEvent.SECURITY_ERROR,Utils.onSecurityError);
         fileRef.addEventListener(ProgressEvent.PROGRESS,onProgress);
         fileRef.addEventListener(Event.COMPLETE,onComplete);
         var _loc3_:FileFilter = new FileFilter(param1,param2);
         fileRef.browse([_loc3_]);
      }
      
      private static function killFileOpenEvents() : void
      {
         fileRef.removeEventListener(ProgressEvent.PROGRESS,onProgress);
         fileRef.removeEventListener(Event.COMPLETE,onComplete);
         fileRef.removeEventListener(Event.CANCEL,Utils.onCancel);
         fileRef.removeEventListener(IOErrorEvent.IO_ERROR,Utils.onIOError);
         fileRef.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,Utils.onSecurityError);
      }
      
      private static function onFileSelected(param1:Event) : void
      {
         fileRef.addEventListener(ProgressEvent.PROGRESS,onProgress);
         fileRef.addEventListener(Event.COMPLETE,onComplete);
         fileRef.load();
         fileRef.removeEventListener(Event.SELECT,Utils.onFileSelected);
      }
      
      private static function onProgress(param1:ProgressEvent) : void
      {
         trace("Loaded " + param1.bytesLoaded + " of " + param1.bytesTotal + " bytes.");
      }
      
      private static function onComplete(param1:Event) : void
      {
         trace("File was successfully loaded.");
         Utils.finishedLoading = true;
         Utils.openSuccess = true;
         killFileOpenEvents();
      }
      
      private static function onCancel(param1:Event) : void
      {
         trace("The browse request was canceled by the user.");
         Utils.cancelled = true;
         Utils.openSuccess = false;
         Utils.finishedLoading = true;
         killFileOpenEvents();
      }
      
      private static function onIOError(param1:IOErrorEvent) : void
      {
         trace("There was an IO Error.");
         Utils.openSuccess = false;
         Utils.finishedLoading = true;
         killFileOpenEvents();
      }
      
      private static function onSecurityError(param1:Event) : void
      {
         trace("There was a security error.");
         Utils.openSuccess = false;
         Utils.finishedLoading = true;
         killFileOpenEvents();
      }
      
      public static function saveFile(param1:ByteArray, param2:String) : void
      {
         Utils.saveSuccess = false;
         Utils.finishedLoading = false;
         Utils.cancelled = false;
         fileRef = new FileReference();
         fileRef.addEventListener(Event.SELECT,onSaveFileSelected);
         fileRef.addEventListener(IOErrorEvent.IO_ERROR,Utils.onSaveIOError);
         fileRef.addEventListener(SecurityErrorEvent.SECURITY_ERROR,Utils.onSaveSecurityError);
         fileRef.addEventListener(ProgressEvent.PROGRESS,onSaveProgress);
         fileRef.addEventListener(Event.COMPLETE,onSaveComplete);
         fileRef.save(param1,param2);
         fileRef.removeEventListener(Event.SELECT,onSaveFileSelected);
      }
      
      private static function killSaveEvents() : void
      {
         fileRef.removeEventListener(ProgressEvent.PROGRESS,onSaveProgress);
         fileRef.removeEventListener(Event.COMPLETE,onSaveComplete);
         fileRef.removeEventListener(Event.CANCEL,onSaveCancel);
         fileRef.removeEventListener(IOErrorEvent.IO_ERROR,Utils.onSaveIOError);
         fileRef.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,Utils.onSaveSecurityError);
      }
      
      private static function onSaveFileSelected(param1:Event) : void
      {
         fileRef.addEventListener(ProgressEvent.PROGRESS,onSaveProgress);
         fileRef.addEventListener(Event.COMPLETE,onSaveComplete);
         fileRef.addEventListener(Event.CANCEL,onSaveCancel);
      }
      
      private static function onSaveProgress(param1:ProgressEvent) : void
      {
         trace("Saved " + param1.bytesLoaded + " of " + param1.bytesTotal + " bytes.");
      }
      
      private static function onSaveComplete(param1:Event) : void
      {
         trace("File saved.");
         Utils.finishedLoading = true;
         Utils.saveSuccess = true;
         killSaveEvents();
      }
      
      private static function onSaveCancel(param1:Event) : void
      {
         trace("The save request was canceled by the user.");
         Utils.cancelled = true;
         Utils.finishedLoading = true;
         Utils.saveSuccess = false;
         killSaveEvents();
      }
      
      private static function onSaveIOError(param1:IOErrorEvent) : void
      {
         trace("There was an IO Error.");
         Utils.finishedLoading = true;
         Utils.saveSuccess = false;
         killSaveEvents();
      }
      
      private static function onSaveSecurityError(param1:Event) : void
      {
         trace("There was a security error.");
         Utils.finishedLoading = true;
         Utils.saveSuccess = false;
         killSaveEvents();
      }
      
      public static function loadDataFile(param1:String) : void
      {
         var _loc2_:URLLoader = new URLLoader();
         _loc2_.dataFormat = URLLoaderDataFormat.BINARY;
         _loc2_.addEventListener(Event.COMPLETE,onLoaded);
         _loc2_.load(new URLRequest(param1));
         Utils.finishedLoading = false;
      }
      
      private static function onLoaded(param1:Event) : void
      {
         trace("Loaded");
         Utils.finishedLoading = true;
      }
      
      public static function flatten(param1:Array) : Array
      {
         var _loc3_:int = 0;
         var _loc2_:Array = [];
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] is Array)
            {
               _loc2_ = _loc2_.concat(Utils.flatten(param1[_loc3_]));
            }
            else
            {
               _loc2_.push(param1[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function union(param1:Array) : Array
      {
         var _loc2_:* = 0;
         var _loc4_:int = 0;
         var _loc3_:Array = param1.slice(0);
         while(_loc4_ < _loc3_.length)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc3_.length)
            {
               if(_loc2_ !== _loc4_ && _loc3_[_loc4_] === param1[_loc2_])
               {
                  _loc3_.splice(_loc2_--,1);
               }
               _loc2_++;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function cloneObject(param1:Object) : Object
      {
         return JSON.parse(JSON.stringify(param1));
      }
      
      public static function bulkRemoveMC(param1:Array) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            if(Boolean(param1[_loc2_]) && Boolean(param1[_loc2_] is MovieClip) && Boolean(MovieClip(param1[_loc2_]).parent))
            {
               MovieClip(param1[_loc2_]).parent.removeChild(param1[_loc2_]);
            }
            _loc2_++;
         }
      }
      
      private static function getKeysArray(param1:Boolean) : Object
      {
         var _loc2_:Object = {};
         if(param1)
         {
            _loc2_[0] = "n/a";
            _loc2_[65] = "A";
            _loc2_[66] = "B";
            _loc2_[67] = "C";
            _loc2_[68] = "D";
            _loc2_[69] = "E";
            _loc2_[70] = "F";
            _loc2_[71] = "G";
            _loc2_[72] = "H";
            _loc2_[73] = "I";
            _loc2_[74] = "J";
            _loc2_[75] = "K";
            _loc2_[76] = "L";
            _loc2_[77] = "M";
            _loc2_[78] = "N";
            _loc2_[79] = "O";
            _loc2_[80] = "P";
            _loc2_[81] = "Q";
            _loc2_[82] = "R";
            _loc2_[83] = "S";
            _loc2_[84] = "T";
            _loc2_[85] = "U";
            _loc2_[86] = "V";
            _loc2_[87] = "W";
            _loc2_[88] = "X";
            _loc2_[89] = "Y";
            _loc2_[90] = "Z";
            _loc2_[48] = "0";
            _loc2_[49] = "1";
            _loc2_[50] = "2";
            _loc2_[51] = "3";
            _loc2_[52] = "4";
            _loc2_[53] = "5";
            _loc2_[54] = "6";
            _loc2_[55] = "7";
            _loc2_[56] = "8";
            _loc2_[57] = "9";
            _loc2_[96] = "Nm0";
            _loc2_[97] = "Nm1";
            _loc2_[98] = "Nm2";
            _loc2_[99] = "Nm3";
            _loc2_[100] = "Nm4";
            _loc2_[101] = "Nm5";
            _loc2_[102] = "Nm6";
            _loc2_[103] = "Nm7";
            _loc2_[104] = "Nm8";
            _loc2_[105] = "Nm9";
            _loc2_[106] = "*";
            _loc2_[107] = "+";
            _loc2_[13] = "Ent";
            _loc2_[109] = "-";
            _loc2_[110] = ".";
            _loc2_[111] = "/";
            _loc2_[112] = "F1";
            _loc2_[113] = "F2";
            _loc2_[114] = "F3";
            _loc2_[115] = "F4";
            _loc2_[116] = "F5";
            _loc2_[117] = "F6";
            _loc2_[118] = "F7";
            _loc2_[119] = "F8";
            _loc2_[120] = "F9";
            _loc2_[122] = "F11";
            _loc2_[123] = "F12";
            _loc2_[124] = "F13";
            _loc2_[125] = "F14";
            _loc2_[126] = "F15";
            _loc2_[8] = "Back";
            _loc2_[9] = "Tab";
            _loc2_[12] = "Clr";
            _loc2_[16] = "Shft";
            _loc2_[20] = "Caps";
            _loc2_[27] = "Esc";
            _loc2_[32] = "Spc";
            _loc2_[33] = "PUp";
            _loc2_[34] = "PDw";
            _loc2_[35] = "End";
            _loc2_[36] = "Hme";
            _loc2_[37] = "Larr";
            _loc2_[38] = "Uarr";
            _loc2_[39] = "RArr";
            _loc2_[40] = "DArr";
            _loc2_[45] = "Ins";
            _loc2_[46] = "Del";
            _loc2_[47] = "Help";
            _loc2_[144] = "NLck";
            _loc2_[186] = ";:";
            _loc2_[187] = "=+";
            _loc2_[188] = ",";
            _loc2_[189] = "-_";
            _loc2_[190] = ".";
            _loc2_[191] = "/?";
            _loc2_[192] = "`~";
            _loc2_[219] = "[{";
            _loc2_[220] = "|";
            _loc2_[221] = "]}";
            _loc2_[222] = "\"\'";
         }
         else
         {
            _loc2_[0] = "None";
            _loc2_[65] = "A";
            _loc2_[66] = "B";
            _loc2_[67] = "C";
            _loc2_[68] = "D";
            _loc2_[69] = "E";
            _loc2_[70] = "F";
            _loc2_[71] = "G";
            _loc2_[72] = "H";
            _loc2_[73] = "I";
            _loc2_[74] = "J";
            _loc2_[75] = "K";
            _loc2_[76] = "L";
            _loc2_[77] = "M";
            _loc2_[78] = "N";
            _loc2_[79] = "O";
            _loc2_[80] = "P";
            _loc2_[81] = "Q";
            _loc2_[82] = "R";
            _loc2_[83] = "S";
            _loc2_[84] = "T";
            _loc2_[85] = "U";
            _loc2_[86] = "V";
            _loc2_[87] = "W";
            _loc2_[88] = "X";
            _loc2_[89] = "Y";
            _loc2_[90] = "Z";
            _loc2_[48] = "0";
            _loc2_[49] = "1";
            _loc2_[50] = "2";
            _loc2_[51] = "3";
            _loc2_[52] = "4";
            _loc2_[53] = "5";
            _loc2_[54] = "6";
            _loc2_[55] = "7";
            _loc2_[56] = "8";
            _loc2_[57] = "9";
            _loc2_[96] = "Numpad 0";
            _loc2_[97] = "Numpad 1";
            _loc2_[98] = "Numpad 2";
            _loc2_[99] = "Numpad 3";
            _loc2_[100] = "Numpad 4";
            _loc2_[101] = "Numpad 5";
            _loc2_[102] = "Numpad 6";
            _loc2_[103] = "Numpad 7";
            _loc2_[104] = "Numpad 8";
            _loc2_[105] = "Numpad 9";
            _loc2_[106] = "*";
            _loc2_[107] = "+";
            _loc2_[13] = "Enter";
            _loc2_[109] = "-";
            _loc2_[110] = ".";
            _loc2_[111] = "/";
            _loc2_[112] = "F1";
            _loc2_[113] = "F2";
            _loc2_[114] = "F3";
            _loc2_[115] = "F4";
            _loc2_[116] = "F5";
            _loc2_[117] = "F6";
            _loc2_[118] = "F7";
            _loc2_[119] = "F8";
            _loc2_[120] = "F9";
            _loc2_[122] = "F11";
            _loc2_[123] = "F12";
            _loc2_[124] = "F13";
            _loc2_[125] = "F14";
            _loc2_[126] = "F15";
            _loc2_[8] = "Backspace";
            _loc2_[9] = "Tab";
            _loc2_[12] = "Clear";
            _loc2_[16] = "Shift";
            _loc2_[20] = "Caps Lock";
            _loc2_[27] = "Esc";
            _loc2_[32] = "Space";
            _loc2_[33] = "Page Up";
            _loc2_[34] = "Page Down";
            _loc2_[35] = "End";
            _loc2_[36] = "Home";
            _loc2_[37] = "Left Arrow";
            _loc2_[38] = "Up Arrow";
            _loc2_[39] = "Right Arrow";
            _loc2_[40] = "Down Arrow";
            _loc2_[45] = "Insert";
            _loc2_[46] = "Delete";
            _loc2_[47] = "Help";
            _loc2_[144] = "Num Lock";
            _loc2_[186] = ";:";
            _loc2_[187] = "=+";
            _loc2_[188] = ",";
            _loc2_[189] = "-_";
            _loc2_[190] = ".";
            _loc2_[191] = "/?";
            _loc2_[192] = "`~";
            _loc2_[219] = "[{";
            _loc2_[220] = "|";
            _loc2_[221] = "]}";
            _loc2_[222] = "\"\'";
         }
         return _loc2_;
      }
      
      public static function copyObject(param1:Object) : Object
      {
         return JSON.parse(JSON.stringify(param1));
      }
      
      public static function e(param1:String, param2:String = "") : String
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc9_:int = 0;
         var _loc8_:String = "";
         while(_loc9_ < param1.length)
         {
            _loc3_ = param1.substr(_loc9_,1);
            _loc4_ = param2.substr(_loc9_ % param2.length - 1,1);
            _loc5_ = _loc3_.charCodeAt(0);
            _loc6_ = _loc4_.charCodeAt(0);
            _loc7_ = _loc5_ + _loc6_;
            _loc3_ = String.fromCharCode(_loc7_);
            _loc8_ += _loc3_;
            _loc9_++;
         }
         return Base64.encode(_loc8_);
      }
      
      public static function d(param1:String, param2:String = "") : String
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc9_:int = 0;
         var _loc8_:String = "";
         param1 = Base64.decode(param1);
         while(_loc9_ < param1.length)
         {
            _loc3_ = param1.substr(_loc9_,1);
            _loc4_ = param2.substr(_loc9_ % param2.length - 1,1);
            _loc5_ = _loc3_.charCodeAt(0);
            _loc6_ = _loc4_.charCodeAt(0);
            _loc7_ = _loc5_ - _loc6_;
            _loc3_ = String.fromCharCode(_loc7_);
            _loc8_ += _loc3_;
            _loc9_++;
         }
         return _loc8_;
      }
   }
}


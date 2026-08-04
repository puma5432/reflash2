package com.mcleodgaming.ssf2.modapi
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.api.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.Character;
   import com.mcleodgaming.ssf2.engine.StageData;
   import com.mcleodgaming.ssf2.input.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   
   public class ModAPI
   {
      
      private static var _api:StageData;
      
      public static const VERSION_MAJOR:int = 0;
      
      public static const VERSION_MINOR:int = 3;
      
      public static const VERSION_REVISION:int = 0;
      
      private static var _isInitialized:Boolean = false;
      
      public function ModAPI()
      {
         super();
      }
      
      public static function init(param1:StageData) : void
      {
         trace("[ENGINE ModAPI] init() called with api=" + param1);
         _api = param1;
         _isInitialized = true;
         trace("[ENGINE ModAPI] init() - _api assigned, _isInitialized = true");
         trace("SSF2 Mod API Version " + VERSION_MAJOR + "." + VERSION_MINOR + "." + VERSION_REVISION + " initialized.");
      }
      
      public static function deinit() : void
      {
         trace("[ENGINE ModAPI] deinit() called");
         _api = null;
         _isInitialized = false;
         trace("[ENGINE ModAPI] deinit() - _api cleared, _isInitialized = false");
         trace("ModAPI deactivated.");
      }
      
      public static function getAPIVersion() : String
      {
         return VERSION_MAJOR + "." + VERSION_MINOR + "." + VERSION_REVISION;
      }
      
      public static function isReady() : Boolean
      {
         return Boolean(_api) && Boolean(_isInitialized) && Boolean(_api.ActiveScripts);
      }
      
      public static function print(param1:String) : void
      {
         if(Boolean(Main.DEBUG) && Boolean(MenuController.debugConsole))
         {
            MenuController.debugConsole.writeTextData("[ModAPI] " + param1);
         }
      }
      
      public static function getEngineAPI() : StageData
      {
         if(!isReady())
         {
            print("Warning: Attempted to access engine API while ModAPI not initialized");
            return null;
         }
         return _api;
      }
      
      public static function getSSF2API() : Class
      {
         return SSF2API;
      }
      
      public static function playMusicWithFadeOut(param1:String, param2:Number, param3:Number = 2000) : void
      {
         if(!isReady())
         {
            print("Error: Cannot play music with fade-out - ModAPI not ready");
            return;
         }
         SoundQueue.instance.playMusicWithFadeOut(param1,param2,param3);
      }
      
      public static function startImmediateFadeOut(param1:Number = 2000) : void
      {
         if(!isReady())
         {
            return;
         }
         SoundQueue.instance.startImmediateFadeOut(param1);
      }
      
      public static function isMusicFadingOut() : Boolean
      {
         if(!isReady())
         {
            return false;
         }
         return SoundQueue.instance.isFadeOutEnabled();
      }
      
      public static function playPitchShiftedEffect(param1:String, param2:Number = 1, param3:Number = 1) : Boolean
      {
         if(!isReady())
         {
            print("Error: Cannot play pitch-shifted effect - ModAPI not ready");
            return false;
         }
         return SoundQueue.instance.playPitchShiftedEffect(param1,param2,param3);
      }
      
      public static function updatePitchShift(param1:Number) : void
      {
         if(!isReady())
         {
            return;
         }
         SoundQueue.instance.updatePitchShift(param1);
      }
      
      public static function updatePitchShiftVolume(param1:Number) : void
      {
         if(!isReady())
         {
            return;
         }
         SoundQueue.instance.updatePitchShiftVolume(param1);
      }
      
      public static function stopPitchShiftedEffect() : void
      {
         if(!isReady())
         {
            return;
         }
         SoundQueue.instance.stopPitchShiftedEffect();
      }
      
      public static function isPitchShiftedEffectPlaying() : Boolean
      {
         if(!isReady())
         {
            return false;
         }
         return SoundQueue.instance.isPitchShiftedEffectPlaying();
      }
      
      public static function rumbleController(param1:*, param2:Number, param3:Number, param4:int) : void
      {
         var _loc5_:int = 0;
         var _loc8_:MovieClip = null;
         if(!isReady())
         {
            return;
         }
         if(param1 is SSF2Character)
         {
            _loc5_ = int(SSF2Character(param1).getUID());
         }
         else if(param1 is MovieClip)
         {
            _loc8_ = MovieClip(param1);
            if(_loc8_.uid != undefined)
            {
               _loc5_ = int(_loc8_.uid);
            }
            else
            {
               if(!(Boolean(_loc8_.parent) && _loc8_.parent.uid != undefined))
               {
                  print("Warning: Cannot resolve UID from MovieClip " + _loc8_);
                  return;
               }
               _loc5_ = int(_loc8_.parent.uid);
            }
         }
         else
         {
            _loc5_ = int(param1);
         }
         var _loc6_:Character = _api.getCharacterByUID(_loc5_);
         if(!_loc6_)
         {
            print("Warning: Character with UID " + _loc5_ + " not found for rumble");
            return;
         }
         var _loc7_:int = _loc6_.ID;
         if(_loc7_ <= 0)
         {
            return;
         }
         Gamepad.rumbleForPlayer(_loc7_,param2,param3,param4);
      }
      
      public static function stopRumble(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc4_:MovieClip = null;
         if(!isReady())
         {
            return;
         }
         if(param1 is SSF2Character)
         {
            _loc2_ = int(SSF2Character(param1).getUID());
         }
         else if(param1 is MovieClip)
         {
            _loc4_ = MovieClip(param1);
            if(_loc4_.uid != undefined)
            {
               _loc2_ = int(_loc4_.uid);
            }
            else
            {
               if(!(Boolean(_loc4_.parent) && _loc4_.parent.uid != undefined))
               {
                  print("Warning: Cannot resolve UID from MovieClip " + _loc4_);
                  return;
               }
               _loc2_ = int(_loc4_.parent.uid);
            }
         }
         else
         {
            _loc2_ = int(param1);
         }
         var _loc3_:Character = _api.getCharacterByUID(_loc2_);
         if(!_loc3_ || _loc3_.ID <= 0)
         {
            return;
         }
         Gamepad.rumbleForPlayer(_loc3_.ID,0,0,0);
      }
      
      public static function supportsRumble(param1:*) : Boolean
      {
         var _loc2_:int = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:int = 0;
         var _loc6_:Gamepad = null;
         if(!isReady())
         {
            return false;
         }
         if(param1 is SSF2Character)
         {
            _loc2_ = int(SSF2Character(param1).getUID());
         }
         else if(param1 is MovieClip)
         {
            _loc4_ = MovieClip(param1);
            if(_loc4_.uid != undefined)
            {
               _loc2_ = int(_loc4_.uid);
            }
            else
            {
               if(!(Boolean(_loc4_.parent) && _loc4_.parent.uid != undefined))
               {
                  print("Warning: Cannot resolve UID from MovieClip " + _loc4_);
                  return false;
               }
               _loc2_ = int(_loc4_.parent.uid);
            }
         }
         else
         {
            _loc2_ = int(param1);
         }
         var _loc3_:Character = _api.getCharacterByUID(_loc2_);
         if(!_loc3_ || _loc3_.ID <= 0)
         {
            return false;
         }
         try
         {
            _loc5_ = _loc3_.ID - 1;
            if(Boolean(SaveData.Controllers && _loc5_ >= 0) && Boolean(_loc5_ < SaveData.Controllers.length) && Boolean(SaveData.Controllers[_loc5_]))
            {
               _loc6_ = SaveData.Controllers[_loc5_].GamepadInstance;
               if(_loc6_ != null)
               {
                  return _loc6_.supportsRumble();
               }
            }
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public static function isRumbleEnabled() : Boolean
      {
         if(!isReady())
         {
            return false;
         }
         return Gamepad.getGlobalRumbleEnabled();
      }
      
      public static function stopTime(param1:*, param2:int = -1, param3:int = 0, param4:int = 2147483646, param5:Object = null) : void
      {
         var _loc6_:int = 0;
         var _loc8_:MovieClip = null;
         if(!isReady())
         {
            return;
         }
         if(param1 is SSF2Character)
         {
            _loc6_ = int(SSF2Character(param1).getUID());
         }
         else if(param1 is MovieClip)
         {
            _loc8_ = MovieClip(param1);
            if(_loc8_.uid != undefined)
            {
               _loc6_ = int(_loc8_.uid);
            }
            else
            {
               if(!(Boolean(_loc8_.parent) && _loc8_.parent.uid != undefined))
               {
                  print("Warning: Cannot resolve UID from MovieClip " + _loc8_);
                  return;
               }
               _loc6_ = int(_loc8_.parent.uid);
            }
         }
         else
         {
            _loc6_ = int(param1);
         }
         var _loc7_:Character = _api.getCharacterByUID(_loc6_);
         if(!_loc7_)
         {
            return;
         }
         if(param3 < 0)
         {
            return;
         }
         if(param4 >= int.MAX_VALUE)
         {
            return;
         }
         _loc7_.stopTime(param2,param3,param4,param5);
      }
      
      public static function resumeTime(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc4_:MovieClip = null;
         if(!isReady())
         {
            return;
         }
         if(param1 is SSF2Character)
         {
            _loc2_ = int(SSF2Character(param1).getUID());
         }
         else if(param1 is MovieClip)
         {
            _loc4_ = MovieClip(param1);
            if(_loc4_.uid != undefined)
            {
               _loc2_ = int(_loc4_.uid);
            }
            else
            {
               if(!(Boolean(_loc4_.parent) && _loc4_.parent.uid != undefined))
               {
                  print("Warning: Cannot resolve UID from MovieClip " + _loc4_);
                  return;
               }
               _loc2_ = int(_loc4_.parent.uid);
            }
         }
         else
         {
            _loc2_ = int(param1);
         }
         var _loc3_:Character = _api.getCharacterByUID(_loc2_);
         if(!_loc3_)
         {
            return;
         }
         _loc3_.resumeTime();
      }
      
      public static function applyTimeFreeze(param1:*, param2:int = -1) : void
      {
         var _loc3_:int = 0;
         var _loc5_:MovieClip = null;
         if(!isReady())
         {
            return;
         }
         if(param1 is SSF2Character)
         {
            _loc3_ = int(SSF2Character(param1).getUID());
         }
         else if(param1 is MovieClip)
         {
            _loc5_ = MovieClip(param1);
            if(_loc5_.uid != undefined)
            {
               _loc3_ = int(_loc5_.uid);
            }
            else
            {
               if(!(Boolean(_loc5_.parent) && _loc5_.parent.uid != undefined))
               {
                  print("Warning: Cannot resolve UID from MovieClip " + _loc5_);
                  return;
               }
               _loc3_ = int(_loc5_.parent.uid);
            }
         }
         else
         {
            _loc3_ = int(param1);
         }
         var _loc4_:Character = _api.getCharacterByUID(_loc3_);
         if(!_loc4_)
         {
            return;
         }
         if(_api.InTimeStop)
         {
            return;
         }
         _loc4_.applyTimeFreeze(param2);
      }
      
      public static function removeTimeFreeze(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc4_:MovieClip = null;
         if(!isReady())
         {
            return;
         }
         if(param1 is SSF2Character)
         {
            _loc2_ = int(SSF2Character(param1).getUID());
         }
         else if(param1 is MovieClip)
         {
            _loc4_ = MovieClip(param1);
            if(_loc4_.uid != undefined)
            {
               _loc2_ = int(_loc4_.uid);
            }
            else
            {
               if(!(Boolean(_loc4_.parent) && _loc4_.parent.uid != undefined))
               {
                  print("Warning: Cannot resolve UID from MovieClip " + _loc4_);
                  return;
               }
               _loc2_ = int(_loc4_.parent.uid);
            }
         }
         else
         {
            _loc2_ = int(param1);
         }
         var _loc3_:Character = _api.getCharacterByUID(_loc2_);
         if(!_loc3_)
         {
            return;
         }
         if(_api.InTimeStop)
         {
            return;
         }
         _loc3_.removeTimeFreeze();
      }
      
      public static function triggerMenuRumble(param1:int) : void
      {
         var _loc2_:Gamepad = null;
         if(Boolean(Gamepad.getGlobalRumbleEnabled()) && Boolean(SaveData.getRumbleEnabled(param1 + 1)))
         {
            _loc2_ = SaveData.Controllers[param1].GamepadInstance;
            if(_loc2_ != null)
            {
               _loc2_.setRumble(0.4,0.4,100);
            }
         }
      }
      
      public static function stopMenuRumble() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < SaveData.Controllers.length)
         {
            if(Boolean(SaveData.Controllers[_loc1_]) && Boolean(SaveData.Controllers[_loc1_].GamepadInstance))
            {
               SaveData.Controllers[_loc1_].GamepadInstance.setRumble(0,0,1);
            }
            _loc1_++;
         }
      }
   }
}


package com.mcleodgaming.ssf2.audio
{
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   import flash.media.*;
   import flash.utils.*;
   
   public class SoundQueue
   {
      
      public static var instance:SoundQueue = new SoundQueue();
      
      private var m_sounds:Vector.<SoundObject>;
      
      private var m_index:int;
      
      private var m_musicIsPlaying:Boolean;
      
      private var m_musicIsOgg:Boolean;
      
      private var m_musicIsMuted:Boolean;
      
      private var m_currentSong:SoundChannel;
      
      private var m_currentSongID:String;
      
      private var m_queueSize:int;
      
      private var m_nextSongID:String;
      
      private var m_loopLocation:Number;
      
      private var m_loopFunction:Function;
      
      private var m_nextSongLoopLocation:Number;
      
      private var m_suppressorEnabled:Boolean;
      
      private var m_suppressorHash:Object;
      
      private var m_fadeOutEnabled:Boolean;
      
      private var m_fadeOutStartTime:Number;
      
      private var m_fadeOutDuration:Number;
      
      private var m_fadeOutStartVolume:Number;
      
      private var m_songEndTime:Number;
      
      private var m_fadeTimer:Timer;
      
      private var m_fadeSteps:int;
      
      private var m_pitchShiftSound:PitchShiftSound;
      
      public function SoundQueue()
      {
         super();
         this.m_queueSize = 60;
         this.m_sounds = new Vector.<SoundObject>(this.m_queueSize,true);
         this.m_index = 0;
         this.m_musicIsPlaying = false;
         this.m_musicIsMuted = false;
         this.m_musicIsOgg = false;
         this.m_currentSong = null;
         this.m_currentSongID = null;
         this.m_nextSongID = null;
         this.m_nextSongLoopLocation = 0;
         this.m_loopLocation = 0;
         this.m_loopFunction = this.loopMusic;
         this.m_suppressorEnabled = false;
         this.m_suppressorHash = null;
         this.m_fadeOutEnabled = false;
         this.m_fadeOutStartTime = 0;
         this.m_fadeOutDuration = 0;
         this.m_fadeOutStartVolume = 0;
         this.m_songEndTime = 0;
         this.m_fadeTimer = null;
         this.m_fadeSteps = 0;
      }
      
      public function enableDuplicateSupressor() : void
      {
         if(!this.m_suppressorEnabled)
         {
            this.m_suppressorEnabled = true;
         }
      }
      
      public function disableDuplicateSupressor() : void
      {
         if(this.m_suppressorEnabled)
         {
            this.m_suppressorEnabled = false;
            this.m_suppressorHash = null;
         }
      }
      
      public function clearSurpressor() : void
      {
         this.m_suppressorHash = null;
      }
      
      public function nextMusic(param1:Event) : void
      {
         var _loc2_:Boolean = false;
         if(this.m_nextSongID.indexOf(".ogg|") == 0)
         {
            _loc2_ = true;
         }
         var _loc3_:* = null;
         if(_loc2_)
         {
            _loc3_ = new (ResourceManager.getLibraryClass(this.m_nextSongID.substr(5)))();
            this.m_musicIsOgg = true;
         }
         else
         {
            _loc3_ = ResourceManager.getLibrarySound(this.m_nextSongID);
            this.m_musicIsOgg = false;
         }
         if(_loc3_ != null)
         {
            if(!this.m_musicIsOgg)
            {
               this.m_currentSong.removeEventListener(Event.SOUND_COMPLETE,this.nextMusic);
               this.m_currentSong = _loc3_.play(0,0,new SoundTransform(this.m_musicIsMuted ? 0 : Number(SaveData.BGVolumeLevel)));
               this.m_currentSongID = this.m_nextSongID;
               this.m_loopLocation = this.m_nextSongLoopLocation;
               this.m_loopFunction = this.loopMusic;
               if(this.m_currentSong != null)
               {
                  this.m_currentSong.addEventListener(Event.SOUND_COMPLETE,this.m_loopFunction);
                  this.m_musicIsPlaying = true;
               }
            }
         }
      }
      
      public function setNextMusic(param1:String, param2:Number) : void
      {
         this.m_nextSongID = param1;
         this.m_nextSongLoopLocation = param2;
      }
      
      public function get LoopLocation() : Number
      {
         return this.m_loopLocation;
      }
      
      public function get NextSongLoopLocation() : Number
      {
         return this.m_loopLocation;
      }
      
      public function get CurrentSong() : SoundChannel
      {
         return this.m_currentSong;
      }
      
      public function get CurrentSongID() : String
      {
         return this.m_currentSongID;
      }
      
      public function get MusicIsMuted() : Boolean
      {
         return this.m_musicIsMuted;
      }
      
      public function set MusicIsMuted(param1:Boolean) : void
      {
         this.m_musicIsMuted = param1;
         if(this.m_musicIsPlaying)
         {
            this.setMusicVolume(this.m_musicIsMuted ? 0 : Number(SaveData.BGVolumeLevel));
         }
      }
      
      public function setLoopFunction(param1:Function) : void
      {
         this.m_loopFunction = param1;
      }
      
      public function getSoundObject(param1:int) : SoundObject
      {
         return param1 >= 0 && param1 < this.m_sounds.length && this.m_sounds[param1] != null ? this.m_sounds[param1] : null;
      }
      
      public function playMusic(param1:String, param2:Number) : void
      {
         var _loc3_:Array = null;
         var _loc4_:* = undefined;
         var _loc5_:Boolean = false;
         if(!param1)
         {
            this.stopMusic();
            return;
         }
         if(param1 === "menumusic")
         {
            if(this.m_currentSongID === "menumusic1" || this.m_currentSongID === "menumusic2" || this.m_currentSongID === "meleemenu2")
            {
               param1 = this.m_currentSongID;
            }
            else
            {
               _loc3_ = ["menumusic1","menumusic2","meleemenu2"];
               param1 = "menumusic1";
               this.m_loopLocation = 0;
               if(SaveData.Unlocks.alternate_tracks)
               {
                  param1 = _loc3_[Utils.safeRandomInteger(0,2)];
                  if(param1 === "meleemenu2")
                  {
                     this.m_loopLocation = 173;
                  }
               }
            }
         }
         if(param1.indexOf(".ogg|") == 0)
         {
            _loc5_ = true;
         }
         if(param1 == this.m_currentSongID)
         {
            return;
         }
         this.m_loopLocation = param2;
         if(this.m_musicIsPlaying)
         {
            this.stopMusic();
         }
         this.m_fadeOutEnabled = false;
         if(param1 != null)
         {
            _loc4_ = null;
            if(_loc5_)
            {
               _loc4_ = new (ResourceManager.getLibraryClass(param1.substr(5)))();
               this.m_musicIsOgg = true;
            }
            else
            {
               _loc4_ = ResourceManager.getLibrarySound(param1);
               this.m_musicIsOgg = false;
            }
            if(_loc4_ != null)
            {
               if(!this.m_musicIsOgg)
               {
                  this.m_currentSong = _loc4_.play(0,0,new SoundTransform(this.m_musicIsMuted ? 0 : Number(SaveData.BGVolumeLevel)));
                  if(this.m_currentSong != null)
                  {
                     this.m_currentSongID = param1;
                     this.m_currentSong.addEventListener(Event.SOUND_COMPLETE,this.m_loopFunction);
                     this.m_musicIsPlaying = true;
                  }
               }
            }
         }
      }
      
      public function loopMusic(param1:Event) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Sound = null;
         if(this.m_musicIsOgg)
         {
            _loc2_ = new (ResourceManager.getLibraryClass(this.m_currentSongID.substr(5)))();
            if(_loc2_ != null)
            {
            }
         }
         else if(this.m_loopLocation >= 0)
         {
            _loc3_ = ResourceManager.getLibrarySound(this.m_currentSongID);
            if(_loc3_ != null)
            {
               this.m_currentSong.removeEventListener(Event.SOUND_COMPLETE,this.loopMusic);
               this.m_currentSong = _loc3_.play(this.m_loopLocation,0,new SoundTransform(this.m_musicIsMuted ? 0 : Number(this.m_currentSong.soundTransform.volume)));
               if(this.m_currentSong != null)
               {
                  this.m_currentSong.addEventListener(Event.SOUND_COMPLETE,this.m_loopFunction);
                  this.m_musicIsPlaying = true;
               }
            }
         }
         else
         {
            this.m_musicIsPlaying = false;
         }
      }
      
      public function setMusicVolume(param1:Number) : void
      {
         if(!this.m_musicIsOgg)
         {
            if(this.m_currentSong)
            {
               this.m_currentSong.soundTransform = new SoundTransform(param1);
            }
         }
      }
      
      public function stopMusic() : void
      {
         if(this.m_musicIsPlaying)
         {
            if(!this.m_musicIsOgg)
            {
               if(this.m_currentSong)
               {
                  this.m_currentSong.removeEventListener(Event.SOUND_COMPLETE,this.m_loopFunction);
                  this.m_currentSong.stop();
                  this.m_currentSong = null;
               }
            }
            this.m_currentSongID = null;
            this.m_musicIsPlaying = false;
         }
         this.m_fadeOutEnabled = false;
         this.stopFadeTimer();
      }
      
      public function playMusicWithFadeOut(param1:String, param2:Number, param3:Number = 2000) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:Boolean = false;
         if(!param1)
         {
            this.stopMusic();
            return;
         }
         if(param1.indexOf(".ogg|") == 0)
         {
            _loc5_ = true;
         }
         if(param1 == this.m_currentSongID)
         {
            return;
         }
         this.m_loopLocation = -1;
         if(this.m_musicIsPlaying)
         {
            this.stopMusic();
         }
         if(param1 != null)
         {
            _loc4_ = null;
            if(_loc5_)
            {
               _loc4_ = new (ResourceManager.getLibraryClass(param1.substr(5)))();
               this.m_musicIsOgg = true;
            }
            else
            {
               _loc4_ = ResourceManager.getLibrarySound(param1);
               this.m_musicIsOgg = false;
            }
            if(_loc4_ != null)
            {
               if(!this.m_musicIsOgg)
               {
                  this.m_currentSong = _loc4_.play(0,0,new SoundTransform(this.m_musicIsMuted ? 0 : Number(SaveData.BGVolumeLevel)));
                  if(this.m_currentSong != null)
                  {
                     this.m_currentSongID = param1;
                     this.m_currentSong.addEventListener(Event.SOUND_COMPLETE,this.stopMusic);
                     this.m_musicIsPlaying = true;
                     this.m_songEndTime = param2;
                     this.m_fadeOutDuration = param3;
                     this.m_fadeOutStartTime = param2 - param3;
                     this.m_fadeOutStartVolume = this.m_musicIsMuted ? 0 : Number(SaveData.BGVolumeLevel);
                     this.m_fadeOutEnabled = true;
                     this.startFadeOutTimer();
                  }
               }
            }
         }
      }
      
      public function startImmediateFadeOut(param1:Number = 2000) : void
      {
         if(!this.m_musicIsPlaying || !this.m_currentSong)
         {
            return;
         }
         this.stopFadeTimer();
         this.m_fadeOutDuration = param1;
         this.m_fadeOutStartTime = this.m_currentSong.position;
         this.m_fadeOutStartVolume = this.m_musicIsMuted ? 0 : Number(SaveData.BGVolumeLevel);
         this.m_songEndTime = this.m_currentSong.position + param1;
         this.m_fadeOutEnabled = true;
         this.m_fadeSteps = 0;
         var _loc2_:int = 50;
         this.m_fadeTimer = new Timer(_loc2_,Math.ceil(param1 / _loc2_));
         this.m_fadeTimer.addEventListener(TimerEvent.TIMER,this.onFadeTimerTick);
         this.m_fadeTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onFadeComplete);
         this.m_fadeTimer.start();
      }
      
      private function startFadeOutTimer() : void
      {
         if(this.m_fadeTimer)
         {
            this.m_fadeTimer.stop();
            this.m_fadeTimer.removeEventListener(TimerEvent.TIMER,this.onFadeTimerTick);
            this.m_fadeTimer = null;
         }
         var _loc1_:Number = Number(this.m_fadeOutStartTime);
         var _loc2_:Timer = new Timer(_loc1_,1);
         _loc2_.addEventListener(TimerEvent.TIMER_COMPLETE,this.onFadeStart);
         _loc2_.start();
      }
      
      private function onFadeStart(param1:TimerEvent) : void
      {
         param1.target.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onFadeStart);
         if(!this.m_fadeOutEnabled || !this.m_musicIsPlaying)
         {
            return;
         }
         this.m_fadeSteps = 0;
         var _loc2_:int = 50;
         this.m_fadeTimer = new Timer(_loc2_,Math.ceil(this.m_fadeOutDuration / _loc2_));
         this.m_fadeTimer.addEventListener(TimerEvent.TIMER,this.onFadeTimerTick);
         this.m_fadeTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onFadeComplete);
         this.m_fadeTimer.start();
      }
      
      private function onFadeTimerTick(param1:TimerEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(!this.m_fadeOutEnabled || !this.m_musicIsPlaying)
         {
            this.stopFadeTimer();
            return;
         }
         if(this.m_currentSong)
         {
            _loc2_ = Number(this.m_currentSong.position);
            if(_loc2_ >= this.m_fadeOutStartTime)
            {
               _loc3_ = (_loc2_ - this.m_fadeOutStartTime) / this.m_fadeOutDuration;
               _loc3_ = Math.min(_loc3_,1);
               _loc4_ = this.m_fadeOutStartVolume * (1 - _loc3_);
               if(!this.m_musicIsMuted)
               {
                  this.setMusicVolume(_loc4_);
               }
            }
         }
      }
      
      private function onFadeComplete(param1:TimerEvent) : void
      {
         this.stopFadeTimer();
         if(this.m_musicIsPlaying)
         {
            this.stopMusic();
         }
      }
      
      private function stopFadeTimer() : void
      {
         if(this.m_fadeTimer)
         {
            this.m_fadeTimer.stop();
            this.m_fadeTimer.removeEventListener(TimerEvent.TIMER,this.onFadeTimerTick);
            this.m_fadeTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onFadeComplete);
            this.m_fadeTimer = null;
         }
      }
      
      public function playSoundEffect(param1:String, param2:Number = 1) : int
      {
         var _loc3_:SoundObject = null;
         var _loc4_:Number = NaN;
         if(Boolean(this.m_suppressorHash) && Boolean(this.m_suppressorHash[param1]))
         {
            return -1;
         }
         if(this.m_suppressorEnabled)
         {
            this.m_suppressorHash = this.m_suppressorHash || {};
            this.m_suppressorHash[param1] = true;
         }
         var _loc5_:Sound = ResourceManager.getLibrarySound(param1);
         if(_loc5_ == null)
         {
            _loc5_ = ResourceManager.getLibrarySound(param1);
         }
         if(_loc5_ != null)
         {
            if(this.m_sounds[this.m_index] != null && this.m_sounds[this.m_index] != undefined)
            {
               this.m_sounds[this.m_index].stop();
            }
            if(_loc5_ != null)
            {
               if(this.m_sounds[this.m_index] != null)
               {
                  if(!this.m_sounds[this.m_index].IsFinished)
                  {
                     this.m_sounds[this.m_index].stop();
                  }
                  this.m_sounds[this.m_index] = null;
               }
               _loc3_ = new SoundObject();
               _loc3_.play(_loc5_,SaveData.SEVolumeLevel * param2,param1);
               if(!_loc3_.IsError)
               {
                  this.m_sounds[this.m_index] = _loc3_;
                  _loc4_ = Number(this.m_index);
                  ++this.m_index;
                  if(this.m_index > this.m_queueSize - 1)
                  {
                     this.m_index = 0;
                  }
                  return _loc4_;
               }
               return -1;
            }
            return -1;
         }
         return -1;
      }
      
      public function playVoiceEffect(param1:String, param2:Number = 1) : int
      {
         var _loc3_:SoundObject = null;
         var _loc4_:Number = NaN;
         if(Boolean(this.m_suppressorHash) && Boolean(this.m_suppressorHash[param1]))
         {
            return -1;
         }
         if(this.m_suppressorEnabled)
         {
            this.m_suppressorHash = this.m_suppressorHash || {};
            this.m_suppressorHash[param1] = true;
         }
         var _loc5_:Sound = ResourceManager.getLibrarySound(param1);
         if(_loc5_ == null)
         {
            _loc5_ = ResourceManager.getLibrarySound(param1);
         }
         if(_loc5_ != null)
         {
            if(this.m_sounds[this.m_index] != null && this.m_sounds[this.m_index] != undefined)
            {
               this.m_sounds[this.m_index].stop();
            }
            if(_loc5_ != null)
            {
               if(this.m_sounds[this.m_index] != null)
               {
                  if(!this.m_sounds[this.m_index].IsFinished)
                  {
                     this.m_sounds[this.m_index].stop();
                  }
                  this.m_sounds[this.m_index] = null;
               }
               _loc3_ = new SoundObject();
               _loc3_.play(_loc5_,SaveData.VAVolumeLevel * param2,param1);
               if(!_loc3_.IsError)
               {
                  this.m_sounds[this.m_index] = _loc3_;
                  _loc4_ = Number(this.m_index);
                  ++this.m_index;
                  if(this.m_index > this.m_queueSize - 1)
                  {
                     this.m_index = 0;
                  }
                  return _loc4_;
               }
               return -1;
            }
            return -1;
         }
         return -1;
      }
      
      public function updateVolumeLevel() : void
      {
         if(this.m_currentSong)
         {
            this.m_currentSong.soundTransform = new SoundTransform(this.m_musicIsMuted ? 0 : Number(SaveData.BGVolumeLevel));
         }
      }
      
      public function stopSound(param1:int) : void
      {
         if(param1 >= 0 && this.m_sounds[param1] != null)
         {
            this.m_sounds[param1].stop();
         }
      }
      
      public function stopAllSounds() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.m_sounds.length)
         {
            if(this.m_sounds[_loc1_] != null)
            {
               this.m_sounds[_loc1_].stop();
               this.m_sounds[_loc1_] = null;
            }
            _loc1_++;
         }
      }
      
      public function pauseAllSounds() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.m_sounds.length)
         {
            if(this.m_sounds[_loc1_] != null && !this.m_sounds[_loc1_].IsFinished)
            {
               this.m_sounds[_loc1_].pause();
            }
            _loc1_++;
         }
      }
      
      public function unpauseAllSounds() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.m_sounds.length)
         {
            if(this.m_sounds[_loc1_] != null && !this.m_sounds[_loc1_].IsFinished)
            {
               this.m_sounds[_loc1_].unpause();
            }
            _loc1_++;
         }
      }
      
      public function playChainedAudio(param1:Array, param2:Boolean = false) : int
      {
         var _loc3_:int = 0;
         var _loc4_:SoundObject = null;
         var _loc5_:int = 0;
         if(param1 != null && param1.length > 0)
         {
            _loc3_ = param2 ? this.playVoiceEffect(param1[0]) : this.playSoundEffect(param1[0]);
            if(_loc3_ >= 0)
            {
               _loc4_ = this.getSoundObject(_loc3_);
               _loc5_ = 1;
               while(_loc5_ < param1.length)
               {
                  if(param1[_loc5_] is Function)
                  {
                     _loc4_.queueFunction(param1[_loc5_]);
                  }
                  else
                  {
                     _loc4_.queueSound(ResourceManager.getLibrarySound(param1[_loc5_]),param2 ? Number(SaveData.VAVolumeLevel) : Number(SaveData.SEVolumeLevel),param1[_loc5_]);
                  }
                  _loc5_++;
               }
               return _loc3_;
            }
         }
         return -1;
      }
      
      public function playPitchShiftedEffect(param1:String, param2:Number = 1, param3:Number = 1) : Boolean
      {
         var _loc4_:Sound = ResourceManager.getLibrarySound(param1);
         if(_loc4_ == null)
         {
            return false;
         }
         if(this.m_pitchShiftSound)
         {
            this.m_pitchShiftSound.stop();
         }
         this.m_pitchShiftSound = new PitchShiftSound();
         this.m_pitchShiftSound.loadSound(_loc4_);
         this.m_pitchShiftSound.play(param2,SaveData.SEVolumeLevel * param3);
         return true;
      }
      
      public function updatePitchShift(param1:Number) : void
      {
         if(Boolean(this.m_pitchShiftSound) && Boolean(this.m_pitchShiftSound.IsPlaying))
         {
            this.m_pitchShiftSound.PitchShift = param1;
         }
      }
      
      public function updatePitchShiftVolume(param1:Number) : void
      {
         if(Boolean(this.m_pitchShiftSound) && Boolean(this.m_pitchShiftSound.IsPlaying))
         {
            this.m_pitchShiftSound.Volume = param1;
         }
      }
      
      public function stopPitchShiftedEffect() : void
      {
         if(this.m_pitchShiftSound)
         {
            this.m_pitchShiftSound.stop();
            this.m_pitchShiftSound = null;
         }
      }
      
      public function isPitchShiftedEffectPlaying() : Boolean
      {
         return Boolean(this.m_pitchShiftSound) && Boolean(this.m_pitchShiftSound.IsPlaying);
      }
      
      public function isFadeOutEnabled() : Boolean
      {
         return this.m_fadeOutEnabled;
      }
   }
}


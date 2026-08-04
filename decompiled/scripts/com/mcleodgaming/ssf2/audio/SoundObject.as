package com.mcleodgaming.ssf2.audio
{
   import flash.events.*;
   import flash.media.*;
   
   public class SoundObject
   {
      
      private var m_name:String;
      
      private var m_sound:Sound;
      
      private var m_channel:SoundChannel;
      
      private var m_volume:Number;
      
      private var m_isPlaying:Boolean;
      
      private var m_isFinished:Boolean;
      
      private var m_currentPosition:Number;
      
      private var m_error:Boolean;
      
      private var m_queuedObjects:Vector.<Object>;
      
      private var m_loopFunction:Function;
      
      public function SoundObject()
      {
         super();
         this.m_name = null;
         this.m_channel = null;
         this.m_sound = null;
         this.m_isPlaying = false;
         this.m_isFinished = false;
         this.m_currentPosition = 0;
         this.m_error = false;
         this.m_queuedObjects = new Vector.<Object>();
         this.m_loopFunction = null;
      }
      
      public function get Channel() : SoundChannel
      {
         return this.m_channel;
      }
      
      public function get SoundInstance() : Sound
      {
         return this.m_sound;
      }
      
      public function get LoopFunction() : Function
      {
         return this.m_loopFunction;
      }
      
      public function set LoopFunction(param1:Function) : void
      {
         this.m_loopFunction = param1;
      }
      
      public function get Volume() : Number
      {
         return this.m_volume;
      }
      
      public function get IsPlaying() : Boolean
      {
         return this.m_isPlaying;
      }
      
      public function get IsFinished() : Boolean
      {
         return this.m_isFinished;
      }
      
      public function get CurrentPosition() : Number
      {
         return this.m_currentPosition;
      }
      
      public function get IsError() : Boolean
      {
         return this.m_error;
      }
      
      public function get Name() : String
      {
         return this.m_name;
      }
      
      public function play(param1:Sound, param2:Number, param3:String) : void
      {
         if(param1 != null)
         {
            param2 = Math.min(1,param2);
            param2 = Math.max(0,param2);
            if(this.m_channel)
            {
               this.m_channel.stop();
            }
            this.m_sound = null;
            this.m_sound = param1;
            this.m_volume = param2;
            this.m_name = param3;
            this.m_channel = this.m_sound.play(0,0,new SoundTransform(this.m_volume));
            if(this.m_channel == null)
            {
               this.m_error = true;
               this.m_isFinished = true;
            }
            else
            {
               this.m_channel.addEventListener(Event.SOUND_COMPLETE,this.finish);
               this.m_isPlaying = true;
            }
         }
      }
      
      public function restart(param1:Event = null) : void
      {
         if(this.m_loopFunction != null)
         {
            this.m_channel.removeEventListener(Event.SOUND_COMPLETE,this.m_loopFunction);
         }
         if(this.m_channel)
         {
            this.m_channel.stop();
         }
         this.m_channel = this.m_sound.play(0,0,new SoundTransform(this.m_volume));
         this.m_channel.addEventListener(Event.SOUND_COMPLETE,this.m_loopFunction);
         this.m_isPlaying = true;
         this.m_isFinished = false;
      }
      
      public function pause() : void
      {
         if(this.m_isPlaying)
         {
            this.m_channel.removeEventListener(Event.SOUND_COMPLETE,this.finish);
            this.m_isPlaying = false;
            this.m_currentPosition = this.m_channel.position;
            this.m_channel.stop();
         }
      }
      
      public function unpause() : void
      {
         if(!this.m_isFinished)
         {
            if(this.m_loopFunction != null)
            {
               this.m_channel.removeEventListener(Event.SOUND_COMPLETE,this.m_loopFunction);
            }
            this.m_channel = this.m_sound.play(this.m_currentPosition,0,new SoundTransform(this.m_volume));
            if(this.m_channel != null)
            {
               this.m_channel.addEventListener(Event.SOUND_COMPLETE,this.finish);
               if(this.m_loopFunction != null)
               {
                  this.m_channel.addEventListener(Event.SOUND_COMPLETE,this.m_loopFunction);
               }
               this.m_isPlaying = true;
            }
            else
            {
               this.m_isFinished = true;
            }
         }
      }
      
      public function stop() : void
      {
         if(this.m_isPlaying)
         {
            this.m_channel.removeEventListener(Event.SOUND_COMPLETE,this.finish);
            this.m_channel.stop();
            this.m_isPlaying = false;
            this.m_isFinished = true;
         }
      }
      
      private function finish(param1:Event) : void
      {
         this.m_channel.removeEventListener(Event.SOUND_COMPLETE,this.finish);
         this.m_isFinished = true;
         this.m_isPlaying = false;
         if(this.m_queuedObjects.length > 0)
         {
            if(this.m_queuedObjects[0].sound is Function)
            {
               this.m_queuedObjects[0].sound();
            }
            else if(this.m_queuedObjects[0].sound is Sound)
            {
               this.play(this.m_queuedObjects[0].sound,this.m_queuedObjects[0].volume,this.m_queuedObjects[0].name);
            }
            this.m_queuedObjects.splice(0,1);
         }
      }
      
      public function queueSound(param1:Sound, param2:Number, param3:String) : void
      {
         var _loc4_:Object = new Object();
         _loc4_.sound = param1;
         _loc4_.volume = param2;
         _loc4_.name = param3;
         this.m_queuedObjects.push(_loc4_);
      }
      
      public function queueFunction(param1:Function) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.sound = param1;
         this.m_queuedObjects.push(_loc2_);
      }
   }
}


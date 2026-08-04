package com.mcleodgaming.ssf2.audio
{
   import flash.events.*;
   import flash.media.*;
   import flash.utils.*;
   
   public class PitchShiftSound
   {
      
      private var m_sourceSound:Sound;
      
      private var m_dynamicSound:Sound;
      
      private var m_channel:SoundChannel;
      
      private var m_sampleData:ByteArray;
      
      private var m_samplePosition:Number;
      
      private var m_pitchShift:Number;
      
      private var m_volume:Number;
      
      private var m_isPlaying:Boolean;
      
      private var m_totalSamples:int;
      
      public function PitchShiftSound()
      {
         super();
         this.m_sourceSound = null;
         this.m_dynamicSound = null;
         this.m_channel = null;
         this.m_sampleData = null;
         this.m_samplePosition = 0;
         this.m_pitchShift = 1;
         this.m_volume = 1;
         this.m_isPlaying = false;
         this.m_totalSamples = 0;
      }
      
      public function get IsPlaying() : Boolean
      {
         return this.m_isPlaying;
      }
      
      public function get PitchShift() : Number
      {
         return this.m_pitchShift;
      }
      
      public function set PitchShift(param1:Number) : void
      {
         this.m_pitchShift = Math.max(0.05,Math.min(3,param1));
      }
      
      public function get Volume() : Number
      {
         return this.m_volume;
      }
      
      public function set Volume(param1:Number) : void
      {
         this.m_volume = Math.max(0,Math.min(1,param1));
         if(this.m_channel)
         {
            this.m_channel.soundTransform = new SoundTransform(this.m_volume);
         }
      }
      
      public function loadSound(param1:Sound) : void
      {
         if(this.m_isPlaying)
         {
            this.stop();
         }
         this.m_sourceSound = param1;
         this.m_sampleData = new ByteArray();
         this.m_totalSamples = this.m_sourceSound.extract(this.m_sampleData,int.MAX_VALUE,0);
         this.m_sampleData.position = 0;
      }
      
      public function play(param1:Number = 1, param2:Number = 1) : void
      {
         if(!this.m_sourceSound || !this.m_sampleData)
         {
            return;
         }
         if(this.m_isPlaying)
         {
            this.stop();
         }
         this.m_pitchShift = Math.max(0.05,Math.min(3,param1));
         this.m_volume = Math.max(0,Math.min(1,param2));
         this.m_samplePosition = 0;
         this.m_dynamicSound = new Sound();
         this.m_dynamicSound.addEventListener(SampleDataEvent.SAMPLE_DATA,this.onSampleData);
         this.m_channel = this.m_dynamicSound.play(0,0,new SoundTransform(this.m_volume));
         this.m_isPlaying = true;
      }
      
      public function stop() : void
      {
         if(this.m_channel)
         {
            this.m_channel.stop();
            this.m_channel = null;
         }
         if(this.m_dynamicSound)
         {
            this.m_dynamicSound.removeEventListener(SampleDataEvent.SAMPLE_DATA,this.onSampleData);
            this.m_dynamicSound = null;
         }
         this.m_isPlaying = false;
      }
      
      private function onSampleData(param1:SampleDataEvent) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc2_:int = 8192;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = int(this.m_samplePosition);
            if(_loc4_ * 8 >= this.m_sampleData.length)
            {
               while(_loc3_ < _loc2_)
               {
                  param1.data.writeFloat(0);
                  param1.data.writeFloat(0);
                  _loc3_++;
               }
               this.stop();
               return;
            }
            this.m_sampleData.position = _loc4_ * 8;
            _loc5_ = 0;
            _loc6_ = 0;
            if(this.m_sampleData.bytesAvailable >= 8)
            {
               _loc5_ = Number(this.m_sampleData.readFloat());
               _loc6_ = Number(this.m_sampleData.readFloat());
               if(this.m_samplePosition % 1 != 0 && this.m_sampleData.bytesAvailable >= 8)
               {
                  _loc7_ = Number(this.m_sampleData.readFloat());
                  _loc8_ = Number(this.m_sampleData.readFloat());
                  _loc9_ = this.m_samplePosition % 1;
                  _loc5_ += (_loc7_ - _loc5_) * _loc9_;
                  _loc6_ += (_loc8_ - _loc6_) * _loc9_;
               }
            }
            param1.data.writeFloat(_loc5_);
            param1.data.writeFloat(_loc6_);
            this.m_samplePosition += this.m_pitchShift;
            _loc3_++;
         }
      }
   }
}


package com.iam2bam.ane.nativejoystick.intern
{
   import com.iam2bam.ane.nativejoystick.*;
   import com.iam2bam.ane.nativejoystick.event.*;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.external.*;
   import flash.utils.*;
   
   public class NativeJoystickMgr extends EventDispatcher
   {
      
      private static var _mgr:NativeJoystickMgr;
      
      public static const TRACE_SILENT:uint = 0;
      
      public static const TRACE_NORMAL:uint = 1;
      
      public static const TRACE_VERBOSE:uint = 2;
      
      public static const TRACE_DIAGNOSE:uint = 3;
      
      public static const DEF_POLL_INTERVAL:Number = 33;
      
      private static const VERSION:String = "1.11";
      
      private const STR_UPDATEJOYSTICKS:String = "updateJoysticks";
      
      public var dispatchAlreadyPlugged:Boolean = true;
      
      private var _ectx:ExtensionContext;
      
      private var _pollInterval:Number;
      
      private var _traceLevel:uint;
      
      private var _detectIntervalMillis:uint;
      
      private var _tmrPoll:Timer;
      
      private var _data:Vector.<NativeJoystickData>;
      
      private var _maxDevs:int;
      
      private var _analogThreshold:Number = 0.1;
      
      public function NativeJoystickMgr()
      {
         super();
         try
         {
            this._traceLevel = 1;
            this._maxDevs = -1;
            this._pollInterval = 33;
            this._ectx = ExtensionContext.createExtensionContext("com.iam2bam.ane.nativejoystick",null);
            this._maxDevs = parseInt(this._ectx.call("getMaxDevices").toString());
            this._data = new Vector.<NativeJoystickData>(this._maxDevs,true);
            trace("NativeJoystick extension by 2bam.com - v" + this.version);
            if("1.11" != this.version)
            {
               trace("NativeJoystick dll/ane version mismatch: DLL v" + this.version + " ANE v" + "1.11");
            }
            this.detectIntervalMillis = 300;
            this._tmrPoll = new Timer(this._pollInterval);
            this._tmrPoll.addEventListener("timer",this.onTimerPoll,false,0,true);
            this._tmrPoll.start();
            this.updateJoysticks();
         }
         catch(error:Error)
         {
            trace("NativeJoystickMgr: error creating extension context");
            trace(error.errorID,error.name,error.message);
         }
      }
      
      public static function instance() : NativeJoystickMgr
      {
         if(!_mgr)
         {
            _mgr = new NativeJoystickMgr();
         }
         return _mgr;
      }
      
      public static function dispose() : void
      {
         if(_mgr)
         {
            _mgr._ectx.dispose();
            _mgr._tmrPoll.stop();
            _mgr = null;
         }
      }
      
      public function isPlugged(param1:uint) : Boolean
      {
         if(param1 < 0 || param1 >= this._maxDevs)
         {
            return false;
         }
         return this._data[param1] != null ? Boolean(this._data[param1].detected) && Boolean(this._data[param1].curr.plugged) : false;
      }
      
      public function getData(param1:uint) : NativeJoystickData
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(param1 > this._maxDevs)
         {
            return null;
         }
         var _loc2_:NativeJoystickData = this._data[param1];
         if(!_loc2_)
         {
            _loc3_ = new NativeJoystickData(param1);
            _loc4_ = _loc3_;
            _loc2_ = _loc4_;
            this._data[param1] = _loc3_;
         }
         return _loc2_;
      }
      
      public function get pollInterval() : Number
      {
         return this._pollInterval;
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         var _loc7_:* = 0;
         var _loc6_:* = null;
         var _loc8_:* = null;
         super.addEventListener(param1,param2,param3,param4,param5);
         if(this.dispatchAlreadyPlugged && param1 == "NJOYPlugged")
         {
            _loc7_ = int(this._maxDevs - 1);
            while(_loc7_ >= 0)
            {
               _loc8_ = this._data[_loc7_];
               if(!(!_loc8_ || !_loc8_.curr.plugged))
               {
                  this._ectx.call("getCapabilities",_loc7_,_loc8_.caps);
                  _loc8_.curr.reset(_loc8_.caps,true);
                  _loc8_.prev.reset(_loc8_.caps,false);
                  if(!_loc6_)
                  {
                     _loc6_ = new NativeJoystickEvent("NJOYPlugged");
                  }
                  _loc6_.index = _loc7_;
                  if(!_loc8_.joystick)
                  {
                     _loc8_.joystick = new NativeJoystick(_loc7_);
                  }
                  _loc6_.joystick = _loc8_.joystick;
                  param2(_loc6_);
               }
               _loc7_--;
            }
         }
      }
      
      public function set pollInterval(param1:Number) : void
      {
         this._pollInterval = param1;
         if(param1 <= 0)
         {
            if(this._tmrPoll)
            {
               this._tmrPoll.stop();
            }
         }
         else
         {
            if(param1 < 20)
            {
               trace("RadNativeJoystickMgr: A pollInterval of less than 20 ms is not recommended (default and suggested value is 33 ms)");
            }
            if(this._tmrPoll)
            {
               this._tmrPoll.delay = param1;
               if(!this._tmrPoll.running)
               {
                  this._tmrPoll.start();
                  this.updateJoysticks();
               }
            }
         }
      }
      
      public function reloadDriverConfig() : void
      {
         this._ectx.call("reloadDriverConfig");
      }
      
      private function createEvent(param1:String, param2:NativeJoystickData) : NativeJoystickEvent
      {
         var _loc3_:NativeJoystickEvent = new NativeJoystickEvent(param1);
         _loc3_.index = param2.index;
         if(!param2.joystick)
         {
            param2.joystick = new NativeJoystick(param2.index);
         }
         _loc3_.joystick = param2.joystick;
         return _loc3_;
      }
      
      private function onTimerPoll(param1:TimerEvent) : void
      {
         var _loc2_:* = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc16_:* = undefined;
         var _loc17_:* = undefined;
         var _loc18_:* = undefined;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc26_:* = undefined;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc10_:* = null;
         var _loc22_:* = null;
         this.updateJoysticks();
         var _loc23_:Boolean = hasEventListener("NJOYButtonDown");
         var _loc24_:Boolean = hasEventListener("NJOYButtonUp");
         var _loc25_:Boolean = hasEventListener("NJOYAxisMove");
         _loc2_ = int(this._maxDevs - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = this._data[_loc2_];
            if(!(!_loc3_ || !_loc3_.detected))
            {
               _loc4_ = _loc3_.caps;
               if(_loc4_)
               {
                  _loc5_ = uint(_loc3_.curr.buttons);
                  _loc6_ = uint(_loc3_.prev.buttons);
                  _loc26_ = _loc5_ & ~_loc6_;
                  _loc3_.buttonsJP = _loc26_;
                  _loc7_ = _loc26_;
                  _loc26_ = ~_loc5_ & _loc6_;
                  _loc3_.buttonsJR = _loc26_;
                  _loc8_ = _loc26_;
                  if(_loc23_ || _loc24_)
                  {
                     if(!_loc23_)
                     {
                        _loc7_ = 0;
                     }
                     if(!_loc24_)
                     {
                        _loc8_ = 0;
                     }
                     _loc11_ = 1;
                     _loc12_ = int(_loc4_.numButtons);
                     _loc9_ = 0;
                     while(_loc9_ < _loc12_)
                     {
                        if(_loc7_ & _loc11_)
                        {
                           _loc10_ = this.createEvent("NJOYButtonDown",_loc3_);
                           _loc10_.buttonIndex = _loc9_;
                           dispatchEvent(_loc10_);
                        }
                        else if(_loc8_ & _loc11_)
                        {
                           _loc10_ = this.createEvent("NJOYButtonUp",_loc3_);
                           _loc10_.buttonIndex = _loc9_;
                           dispatchEvent(_loc10_);
                        }
                        _loc11_ <<= 1;
                        _loc9_++;
                     }
                  }
                  _loc13_ = 8;
                  _loc14_ = _loc3_.curr.axes;
                  _loc15_ = _loc3_.prev.axes;
                  _loc16_ = _loc4_.axesRange;
                  _loc17_ = _loc4_.hasAxis;
                  _loc18_ = _loc3_.curr.axesRaw;
                  _loc9_ = 0;
                  while(_loc9_ < _loc13_)
                  {
                     _loc20_ = Number(_loc15_[_loc9_]);
                     if(_loc17_[_loc9_])
                     {
                        _loc19_ = 2 * _loc18_[_loc9_] / _loc16_[_loc9_] - 1;
                        _loc14_[_loc9_] = _loc19_;
                        if(-this._analogThreshold < _loc19_ && _loc19_ < this._analogThreshold)
                        {
                           _loc19_ = 0;
                        }
                        if(-this._analogThreshold < _loc20_ && _loc20_ < this._analogThreshold)
                        {
                           _loc20_ = 0;
                        }
                        _loc21_ = _loc19_ - _loc20_;
                        if(_loc25_ && _loc21_ != 0)
                        {
                           _loc10_ = this.createEvent("NJOYAxisMove",_loc3_);
                           _loc10_.axisIndex = _loc9_;
                           _loc10_.axisValue = _loc19_;
                           _loc10_.axisDelta = _loc21_;
                           dispatchEvent(_loc10_);
                        }
                     }
                     _loc9_++;
                  }
                  if(_loc3_.curr.plugged != _loc3_.prev.plugged)
                  {
                     if(_loc3_.curr.plugged)
                     {
                        _loc22_ = "NJOYPlugged";
                        this._ectx.call("getCapabilities",_loc2_,_loc3_.caps);
                        _loc3_.curr.reset(_loc3_.caps,true);
                        _loc3_.prev.reset(_loc3_.caps,false);
                        if(this._traceLevel >= 1)
                        {
                           trace("[NJOY] Joystick #" + _loc3_.index + " plugged.");
                        }
                        if(this._traceLevel >= 2)
                        {
                           trace("[NJOY] Caps for joystick #" + _loc2_);
                           trace(_loc3_.caps + "\n");
                        }
                     }
                     else if(!_loc3_.detected)
                     {
                        _loc22_ = "NJOYUnplugged";
                        if(this._traceLevel >= 2)
                        {
                           trace("[NJOY] Joystick #" + _loc3_.index + " unplugged w/errors");
                        }
                     }
                     else
                     {
                        _loc22_ = "NJOYUnplugged";
                        if(this._traceLevel >= 2)
                        {
                           trace("[NJOY] Joystick #" + _loc3_.index + " unplugged");
                        }
                     }
                     if(hasEventListener(_loc22_))
                     {
                        dispatchEvent(this.createEvent(_loc22_,_loc3_));
                     }
                  }
               }
            }
            _loc2_--;
         }
      }
      
      public function get traceLevel() : uint
      {
         return this._traceLevel;
      }
      
      public function set traceLevel(param1:uint) : void
      {
         if(this._traceLevel != param1)
         {
            this._traceLevel = param1;
            this._ectx.call("setTraceLevel",param1);
         }
      }
      
      public function get detectIntervalMillis() : uint
      {
         return this._detectIntervalMillis;
      }
      
      public function set detectIntervalMillis(param1:uint) : void
      {
         if(this._detectIntervalMillis != param1)
         {
            this._detectIntervalMillis = param1;
            this._ectx.call("setDetectDelay",param1);
         }
      }
      
      public function get version() : String
      {
         var _loc1_:Object = this._ectx.call("getVersion");
         return _loc1_ ? _loc1_.toString() : null;
      }
      
      public function getCapabilities(param1:uint, param2:NativeJoystickCaps) : void
      {
         this._ectx.call("getCapabilities",param1,param2);
      }
      
      public function updateJoysticks() : void
      {
         this._ectx.call("updateJoysticks",this._data);
      }
      
      public function get maxJoysticks() : int
      {
         return this._maxDevs;
      }
      
      public function get analogThreshold() : Number
      {
         return this._analogThreshold;
      }
      
      public function set analogThreshold(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(param1 > 1)
         {
            param1 = 1;
         }
         this._analogThreshold = param1;
      }
   }
}


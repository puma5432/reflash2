package com.iam2bam.ane.nativejoystick.intern
{
   import com.iam2bam.ane.nativejoystick.*;
   
   public class NativeJoystickCaps
   {
      
      public var oemName:String;
      
      public var hasAxis:Vector.<Boolean>;
      
      public var axesRange:Vector.<uint>;
      
      public var hasPOV4Dir:Boolean;
      
      public var hasPOV4Cont:Boolean;
      
      public var numAxes:uint;
      
      public var numButtons:uint;
      
      public var miscProductName:String;
      
      public var miscProductID:uint;
      
      public var miscManufacturerID:uint;
      
      public var miscOSDriver:String;
      
      public var miscOSRegKey:String;
      
      public function NativeJoystickCaps()
      {
         var _loc1_:int = 0;
         super();
         this.hasAxis = new Vector.<Boolean>(8,true);
         this.axesRange = new Vector.<uint>(8,true);
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            this.axesRange[_loc1_] = 1;
            this.hasAxis[_loc1_] = false;
            _loc1_++;
         }
      }
      
      public function get hasX() : Boolean
      {
         return this.hasAxis[0];
      }
      
      public function get hasY() : Boolean
      {
         return this.hasAxis[1];
      }
      
      public function get hasZ() : Boolean
      {
         return this.hasAxis[2];
      }
      
      public function get hasR() : Boolean
      {
         return this.hasAxis[3];
      }
      
      public function get hasU() : Boolean
      {
         return this.hasAxis[4];
      }
      
      public function get hasV() : Boolean
      {
         return this.hasAxis[5];
      }
      
      public function get hasPOV() : Boolean
      {
         return this.hasPOV4Dir || this.hasPOV4Cont;
      }
      
      private function varToString(param1:String) : String
      {
         return "\t" + param1 + "=" + this[param1] + "/" + this[param1].length + "\n";
      }
      
      public function toString() : String
      {
         var _loc1_:int = 0;
         var _loc2_:String = "";
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            if(this.hasAxis[_loc1_])
            {
               _loc2_ += "\t\tAxis #" + _loc1_ + " " + NativeJoystick.AXIS_NAMES[_loc1_] + " (0.." + this.axesRange[_loc1_] + ")\n";
            }
            _loc1_++;
         }
         return "[RadNativeJoystickCaps(\n" + this.varToString("oemName") + this.varToString("hasPOV4Dir") + this.varToString("hasPOV4Cont") + this.varToString("numButtons") + this.varToString("numAxes") + _loc2_ + this.varToString("miscProductName") + this.varToString("miscProductID") + this.varToString("miscManufacturerID") + this.varToString("miscOSDriver") + this.varToString("miscOSRegKey") + "]";
      }
   }
}


package com.mcleodgaming.ssf2.util
{
   public class DataSettings
   {
      
      public var controls:Boolean;
      
      public var options:Boolean;
      
      public var records:Boolean;
      
      public var unlocks:Boolean;
      
      public var saveFileVersion:String;
      
      public function DataSettings(param1:Boolean = true, param2:Boolean = true, param3:Boolean = true, param4:Boolean = true)
      {
         super();
         this.controls = param1;
         this.options = param2;
         this.records = param3;
         this.unlocks = param4;
         this.saveFileVersion = null;
      }
   }
}


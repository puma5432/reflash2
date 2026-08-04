package com.mcleodgaming.ssf2.interfaces
{
   public interface IDebugConsole
   {
      
      function get ControlsCapture() : Boolean;
      
      function get OnlineCapture() : Boolean;
      
      function get PingCapture() : Boolean;
      
      function get AttackStateCapture() : Boolean;
      
      function get KnockbackCapture() : Boolean;
      
      function get Alerts() : Boolean;
      
      function set Alerts(param1:Boolean) : void;
      
      function makeEvents() : void;
      
      function show() : void;
      
      function killEvents() : void;
      
      function removeSelf() : void;
      
      function forceShow() : void;
      
      function alert(param1:String) : void;
      
      function writeEndAttackControls(param1:String) : void;
      
      function writeTextData(param1:String) : void;
   }
}


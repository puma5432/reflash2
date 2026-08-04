package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.menus.CustomAPIMenu;
   import flash.display.MovieClip;
   
   public class SSF2CustomMenu extends SSF2BaseAPIObject
   {
      
      protected var _ownerCasted:CustomAPIMenu;
      
      public function SSF2CustomMenu(param1:Class, param2:CustomAPIMenu)
      {
         super(param1,param2);
         this._ownerCasted = param2;
      }
      
      public function getMC() : MovieClip
      {
         return this._ownerCasted.Container;
      }
      
      public function show() : void
      {
         this._ownerCasted.show();
      }
      
      public function remove() : void
      {
         this._ownerCasted.removeSelf();
      }
      
      public function setCustomInputMapping(param1:Object) : void
      {
         this._ownerCasted.CustomInputMapping = param1;
      }
   }
}


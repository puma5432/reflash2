package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.api.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   
   public class CustomAPIMenu extends Menu
   {
      
      private var m_apiInstance:SSF2CustomMenu;
      
      private var m_menuInputNodes:Object;
      
      private var m_customMenuInputMapping:Object;
      
      public function CustomAPIMenu(param1:Object = null)
      {
         super();
         if(!param1)
         {
            param1 = {};
         }
         this.m_menuInputNodes = {};
         this.m_customMenuInputMapping = null;
         this.m_apiInstance = new SSF2CustomMenu(param1.classAPI,this);
         this.m_apiInstance.initialize();
      }
      
      public function get APIInstance() : SSF2CustomMenu
      {
         return this.m_apiInstance;
      }
      
      public function set CustomInputMapping(param1:Object) : void
      {
         this.m_customMenuInputMapping = param1;
      }
      
      private function menuNodeHelper(param1:Object, param2:Array) : Array
      {
         var _loc4_:int = 0;
         var _loc3_:Array = [];
         param1 ||= [];
         param2 ||= [];
         while(_loc4_ < param2.length)
         {
            if(param1[param2[_loc4_]])
            {
               _loc3_.push(param1[param2[_loc4_]]);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      override public function show() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:MenuMapperNode = null;
         if(m_showCount == 0)
         {
            findSubMenuButtons();
         }
         super.show();
         resetAllButtons();
         if(this.m_customMenuInputMapping)
         {
            this.m_menuInputNodes = {};
            _loc2_ = null;
            for(_loc1_ in this.m_customMenuInputMapping)
            {
               this.m_menuInputNodes[_loc1_] = new MenuMapperNode(this.m_customMenuInputMapping[_loc1_].button);
            }
            for(_loc1_ in this.m_customMenuInputMapping)
            {
               (this.m_menuInputNodes[_loc1_] as MenuMapperNode).updateNodes(this.menuNodeHelper(this.m_menuInputNodes,this.m_customMenuInputMapping[_loc1_].upNodes),this.menuNodeHelper(this.m_menuInputNodes,this.m_customMenuInputMapping[_loc1_].downNodes),this.menuNodeHelper(this.m_menuInputNodes,this.m_customMenuInputMapping[_loc1_].leftNodes),this.menuNodeHelper(this.m_menuInputNodes,this.m_customMenuInputMapping[_loc1_].rightNodes),this.m_customMenuInputMapping[_loc1_].onOver || null,this.m_customMenuInputMapping[_loc1_].onOut || null,this.m_customMenuInputMapping[_loc1_].onPress || null,this.m_customMenuInputMapping[_loc1_].onBack || null,this.m_customMenuInputMapping[_loc1_].onUp || null,this.m_customMenuInputMapping[_loc1_].onDown || null,this.m_customMenuInputMapping[_loc1_].onLeft || null,this.m_customMenuInputMapping[_loc1_].onRight || null);
               if(this.m_customMenuInputMapping[_loc1_].selected)
               {
                  _loc2_ = this.m_menuInputNodes[_loc1_];
               }
            }
            m_menuMapper = new MenuMapper(_loc2_);
            m_menuMapper.init();
            setMenuMappingFocus();
         }
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,manageMenuMappings);
         MenuController.customMenus.push(this);
      }
      
      override public function removeSelf() : void
      {
         super.removeSelf();
         var _loc1_:int = int(MenuController.customMenus.indexOf(this));
         if(_loc1_ >= 0)
         {
            MenuController.customMenus.splice(_loc1_,1);
         }
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,manageMenuMappings);
         this.m_menuInputNodes = null;
         m_menuMapper = null;
      }
   }
}


package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.items.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   
   public class ItemSwitchMenu extends Menu
   {
      
      private var selectHand:ItemSwitchHand;
      
      private var buttonList:Vector.<ItemButton>;
      
      private var m_itemMCHash:Object;
      
      private var m_disabledItemHash:Object;
      
      private var m_itemTable:DisplayObjectTable;
      
      public function ItemSwitchMenu()
      {
         var _loc1_:MovieClip = null;
         var _loc2_:MovieClip = null;
         var _loc3_:* = 0;
         var _loc4_:int = 0;
         this.buttonList = new Vector.<ItemButton>();
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_itemswitch");
         m_backgroundID = "space";
         this.buttonList = new Vector.<ItemButton>();
         var _loc5_:Object = ItemsListData.OBJECTS;
         var _loc6_:Object = ResourceManager.getResourceByID("mappings").getProp("metadata");
         var _loc7_:Array = _loc6_.item_switch_screen.rows;
         var _loc8_:Array = Utils.flatten(_loc7_ as Array);
         this.m_itemMCHash = {};
         this.m_disabledItemHash = {};
         _loc3_ = 0;
         while(_loc3_ < this.ItemSwitchIconsMC.numChildren)
         {
            if(this.ItemSwitchIconsMC.getChildAt(_loc3_) is MovieClip)
            {
               _loc1_ = MovieClip(this.ItemSwitchIconsMC.getChildAt(_loc3_));
               _loc1_.parent.removeChild(_loc1_);
               _loc3_--;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc8_.length)
         {
            _loc1_ = MovieClip(ResourceManager.getLibraryMC(_loc8_[_loc3_] + "_item_switch"));
            _loc1_.gotoAndStop(1);
            _loc1_.itemID = _loc1_.itemID || _loc8_[_loc3_];
            if(_loc5_[_loc1_.itemID])
            {
               this.m_itemMCHash[_loc1_.itemID] = _loc1_;
               this.ItemSwitchIconsMC.addChild(_loc1_);
               this.buttonList.push(new ItemButton(_loc1_,_loc1_.itemID));
            }
            else if(_loc8_[_loc3_] === "allitems")
            {
               m_subMenu.allitems_btn = _loc1_;
               this.ItemSwitchIconsMC.addChild(_loc1_);
            }
            else
            {
               _loc1_.visible = false;
               this.ItemSwitchIconsMC.addChild(_loc1_);
               this.m_disabledItemHash[_loc1_.itemID] = _loc1_;
            }
            _loc3_++;
         }
         this.selectHand = new ItemSwitchHand(m_subMenu,this.buttonList,this.back_CLICK);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.allitems_btn);
         this.selectHand.addClickEventClipHitTest(m_subMenu.bg_top.back_btn);
         this.selectHand.addClickEventClipHitTest(m_subMenu.bg_top.home_btn);
         this.selectHand.addClickEventClipHitTest(m_subMenu.iarrow_l);
         this.selectHand.addClickEventClipHitTest(m_subMenu.iarrow_r);
         m_container.addChild(m_subMenu);
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         this.m_itemTable = new DisplayObjectTable(new Rectangle(_loc6_.item_switch_screen.position.x,_loc6_.item_switch_screen.position.y,_loc6_.item_switch_screen.icon_size.width,_loc6_.item_switch_screen.icon_size.height));
         this.m_itemTable.insertObject(0,m_subMenu.allitems_btn);
         _loc3_ = 0;
         while(_loc3_ < _loc7_.length)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc7_[_loc3_].length)
            {
               _loc2_ = this.m_itemMCHash[_loc7_[_loc3_][_loc4_]] || this.m_disabledItemHash[_loc7_[_loc3_][_loc4_]] || null;
               if(_loc2_)
               {
                  this.m_itemTable.insertObject(_loc3_,_loc2_);
               }
               _loc4_++;
            }
            _loc3_++;
         }
         this.updateItems();
         this.checkAllBtn();
      }
      
      public function get ItemSwitchIconsMC() : MovieClip
      {
         return m_subMenu.itemButtons;
      }
      
      private function itemInMappings(param1:Array, param2:String) : Boolean
      {
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_].indexOf(param2) >= 0)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      override public function makeEvents() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_ROLL_OVER);
         for(_loc1_ in this.buttonList)
         {
            this.buttonList[_loc1_].makeEvents();
            this.buttonList[_loc1_].ButtonInstance.addEventListener(MouseEvent.MOUSE_OVER,this.i_MOUSE_OVER);
            this.buttonList[_loc1_].ButtonInstance.addEventListener(MouseEvent.MOUSE_OUT,this.clearDesc);
            this.buttonList[_loc1_].ButtonInstance.addEventListener(MouseEvent.CLICK,this.checkAllBtn);
         }
         m_subMenu.allitems_btn.addEventListener(MouseEvent.CLICK,this.allitems_CLICK);
         m_subMenu.allitems_btn.addEventListener(MouseEvent.MOUSE_OVER,this.allitems_MOUSE_OVER);
         if(Boolean(m_subMenu.iarrow_l) && Boolean(m_subMenu.iarrow_r))
         {
            m_subMenu.iarrow_l.addEventListener(MouseEvent.CLICK,this.iarrow_l_CLICK);
            m_subMenu.iarrow_r.addEventListener(MouseEvent.CLICK,this.iarrow_r_CLICK);
            m_subMenu.iarrow_l.addEventListener(MouseEvent.MOUSE_OVER,this.iarrow_l_MOUSE_OVER);
            m_subMenu.iarrow_r.addEventListener(MouseEvent.MOUSE_OVER,this.iarrow_r_MOUSE_OVER);
         }
         m_subMenu.bg_top.home_btn.addEventListener(MouseEvent.CLICK,this.home_CLICK);
         this.selectHand.makeEvents();
         if(!Main.DEBUG)
         {
            for(_loc2_ in this.m_itemMCHash)
            {
               if(SaveData.Unlocks[_loc2_] === false)
               {
                  this.m_itemMCHash[_loc2_].visible = false;
               }
            }
         }
         this.m_itemTable.spaceObjects();
         this.updateFields();
      }
      
      override public function killEvents() : void
      {
         var _loc1_:* = undefined;
         super.killEvents();
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_ROLL_OVER);
         for(_loc1_ in this.buttonList)
         {
            this.buttonList[_loc1_].ButtonInstance.removeEventListener(MouseEvent.MOUSE_OVER,this.i_MOUSE_OVER);
            this.buttonList[_loc1_].ButtonInstance.removeEventListener(MouseEvent.MOUSE_OUT,this.clearDesc);
            this.buttonList[_loc1_].ButtonInstance.removeEventListener(MouseEvent.CLICK,this.checkAllBtn);
            this.buttonList[_loc1_].killEvents();
         }
         m_subMenu.allitems_btn.removeEventListener(MouseEvent.CLICK,this.allitems_CLICK);
         m_subMenu.allitems_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.allitems_MOUSE_OVER);
         if(Boolean(m_subMenu.iarrow_l) && Boolean(m_subMenu.iarrow_r))
         {
            m_subMenu.iarrow_l.removeEventListener(MouseEvent.CLICK,this.iarrow_l_CLICK);
            m_subMenu.iarrow_r.removeEventListener(MouseEvent.CLICK,this.iarrow_r_CLICK);
            m_subMenu.iarrow_l.removeEventListener(MouseEvent.MOUSE_OVER,this.iarrow_l_MOUSE_OVER);
            m_subMenu.iarrow_r.removeEventListener(MouseEvent.MOUSE_OVER,this.iarrow_r_MOUSE_OVER);
         }
         m_subMenu.bg_top.home_btn.removeEventListener(MouseEvent.CLICK,this.home_CLICK);
         this.selectHand.killEvents();
      }
      
      private function back_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_back");
         removeSelf();
      }
      
      private function back_ROLL_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function updateItems() : void
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this.m_itemMCHash)
         {
            this.m_itemMCHash[_loc1_].gotoAndStop(SaveData.getItemStatus(_loc1_) ? "on" : "off");
         }
      }
      
      private function clearDesc(param1:MouseEvent) : void
      {
         m_subMenu.item_name.text = "";
         m_subMenu.item_desc.text = "";
      }
      
      private function i_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         m_subMenu.item_name.text = _loc2_.itemName || "";
         m_subMenu.item_desc.text = _loc2_.itemDescription || "";
         Utils.fitText(m_subMenu.item_name,14);
      }
      
      private function allitems_CLICK(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         SoundQueue.instance.playSoundEffect("menu_select");
         var _loc3_:Boolean = m_subMenu.allitems_btn.currentFrameLabel == "on";
         m_subMenu.allitems_btn.gotoAndStop(_loc3_ ? "off" : "on");
         for(_loc2_ in this.buttonList)
         {
            this.buttonList[_loc2_].setStatus(_loc3_);
         }
         if(_loc3_)
         {
            SaveData.ItemDataObj = {};
            for(_loc2_ in this.m_disabledItemHash)
            {
               SaveData.ItemDataObj[_loc2_] = false;
            }
         }
         else
         {
            SaveData.ItemDataObj = {};
            for(_loc2_ in this.m_itemMCHash)
            {
               SaveData.ItemDataObj[_loc2_] = false;
            }
            for(_loc2_ in this.m_disabledItemHash)
            {
               SaveData.ItemDataObj[_loc2_] = false;
            }
         }
      }
      
      private function allitems_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      public function checkAllBtn(param1:Event = null) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Boolean = false;
         for(_loc2_ in this.buttonList)
         {
            if(!this.buttonList[_loc2_].getStatus())
            {
               _loc3_ = true;
            }
         }
         m_subMenu.allitems_btn.gotoAndStop(!_loc3_ ? "off" : "on");
      }
      
      private function iarrow_l_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         SaveData.toggleItemFrequency(false);
         this.updateFields();
      }
      
      private function iarrow_r_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         SaveData.toggleItemFrequency(true);
         this.updateFields();
      }
      
      private function updateFields() : void
      {
         if(m_subMenu.itemFreqTxt)
         {
            switch(SaveData.ItemFrequency)
            {
               case 1:
                  m_subMenu.itemFreqTxt.text = "Very Low";
                  break;
               case 2:
                  m_subMenu.itemFreqTxt.text = "Low";
                  break;
               case 3:
                  m_subMenu.itemFreqTxt.text = "Medium";
                  break;
               case 4:
                  m_subMenu.itemFreqTxt.text = "High";
                  break;
               case 5:
                  m_subMenu.itemFreqTxt.text = "Very High";
                  break;
               default:
                  m_subMenu.itemFreqTxt.text = "Off";
            }
         }
      }
      
      private function iarrow_l_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function iarrow_r_MOUSE_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function home_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_back");
         SoundQueue.instance.stopMusic();
         if(MenuController.CurrentCharacterSelectMenu)
         {
            MenuController.CurrentCharacterSelectMenu.resetScreen();
         }
         GameController.currentGame = null;
         MenuController.disposeAllMenus(true);
         MenuController.titleMenu.show();
      }
   }
}


package com.mcleodgaming.ssf2.controllers
{
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   import flash.events.*;
   
   public class ItemButton extends HandButton
   {
      
      private var m_itemName:String;
      
      public function ItemButton(param1:MovieClip, param2:String)
      {
         super(param1);
         this.m_itemName = param2;
      }
      
      public function get ItemID() : String
      {
         return this.m_itemName;
      }
      
      override protected function button_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         var _loc2_:Boolean = m_button.currentFrameLabel == "on";
         m_button.gotoAndStop(_loc2_ ? "off" : "on");
         var _loc3_:Array = this.m_itemName.split("|");
         var _loc4_:Number = 0;
         while(_loc4_ < _loc3_.length)
         {
            SaveData.ItemDataObj[_loc3_[_loc4_]] = !_loc2_;
            if(SaveData.ItemDataObj[_loc3_[_loc4_]])
            {
               delete SaveData.ItemDataObj[_loc3_[_loc4_]];
            }
            _loc4_++;
         }
         MenuController.itemSwitchMenu.checkAllBtn();
      }
      
      override protected function button_ROLLOVER(param1:MouseEvent) : void
      {
         m_button.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
      }
      
      override protected function button_ROLLOUT(param1:MouseEvent) : void
      {
         m_button.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
      }
      
      public function getStatus() : Boolean
      {
         return m_button.currentFrameLabel == "on";
      }
      
      public function setStatus(param1:Boolean) : void
      {
         m_button.gotoAndStop(param1 ? "on" : "off");
         var _loc2_:Array = this.m_itemName.split("|");
         var _loc3_:Number = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(param1)
            {
               delete SaveData.ItemDataObj[_loc2_[_loc3_]];
            }
            else
            {
               SaveData.ItemDataObj[_loc2_[_loc3_]] = false;
            }
            _loc3_++;
         }
      }
   }
}


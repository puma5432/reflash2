package com.mcleodgaming.ssf2.controllers
{
   import flash.display.MovieClip;
   import flash.events.*;
   
   public class DataButton extends HandButton
   {
      
      public function DataButton(param1:MovieClip)
      {
         super(param1);
      }
      
      override protected function button_ROLLOVER(param1:MouseEvent) : void
      {
         m_button.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
      }
      
      override protected function button_CLICK(param1:MouseEvent) : void
      {
         m_button.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
      }
      
      override protected function button_ROLLOUT(param1:MouseEvent) : void
      {
         m_button.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
      }
   }
}


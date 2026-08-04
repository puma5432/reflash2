package com.mcleodgaming.ssf2.util
{
   import flash.display.DisplayObject;
   import flash.events.*;
   import flash.ui.*;
   
   public class MouseTracker
   {
      
      private static var m_disabled:Boolean = false;
      
      private static var m_targetObject:DisplayObject = null;
      
      private static var m_captureStarted:Boolean = false;
      
      private static var m_leftClick:Boolean = false;
      
      private static var m_autoHide:Boolean = false;
      
      private static var m_autoHideTimer:int = 30 * 1;
      
      private static var m_targetHideObject:DisplayObject = null;
      
      init();
      
      public function MouseTracker()
      {
         super();
      }
      
      public static function init() : void
      {
      }
      
      public static function initializeMouseClass() : void
      {
         trace("Mouse class initialized");
      }
      
      public static function setAutoHide(param1:DisplayObject, param2:Boolean) : void
      {
         if(m_autoHide != param2)
         {
            if(m_autoHide)
            {
               m_targetHideObject.removeEventListener(Event.ENTER_FRAME,checkShow);
               m_targetHideObject.removeEventListener(MouseEvent.MOUSE_MOVE,checkHide);
               m_targetHideObject = null;
               m_autoHide = false;
            }
            else
            {
               m_targetHideObject = param1;
               m_targetHideObject.addEventListener(Event.ENTER_FRAME,checkShow);
               m_targetHideObject.addEventListener(MouseEvent.MOUSE_MOVE,checkHide);
               m_autoHide = true;
               m_autoHideTimer = 30 * 1;
            }
            m_autoHide = param2;
         }
      }
      
      private static function checkHide(param1:MouseEvent) : void
      {
         if(m_autoHide)
         {
            m_autoHideTimer = 30 * 1;
            Mouse.show();
         }
      }
      
      private static function checkShow(param1:Event) : void
      {
         if(m_autoHideTimer > 0)
         {
            --m_autoHideTimer;
            if(m_autoHideTimer <= 0)
            {
               Mouse.hide();
            }
         }
      }
      
      public static function beginCapture(param1:DisplayObject) : void
      {
         if(param1 != null)
         {
            if(m_captureStarted)
            {
               endCapture();
            }
            m_targetObject = param1;
            m_targetObject.addEventListener(MouseEvent.MOUSE_DOWN,MouseTracker.mouseDown);
            m_targetObject.addEventListener(MouseEvent.MOUSE_UP,MouseTracker.mouseUp);
            m_targetObject.addEventListener(MouseEvent.MOUSE_MOVE,MouseTracker.mouseMove);
            m_targetObject.addEventListener(Event.DEACTIVATE,MouseTracker.disable);
            m_targetObject.addEventListener(Event.ACTIVATE,MouseTracker.enable);
            m_captureStarted = true;
            trace("Mouse class activated");
         }
         else
         {
            trace("Error, null target passed to Mouse.as");
         }
      }
      
      public static function endCapture() : void
      {
         if(m_captureStarted)
         {
            m_targetObject.removeEventListener(MouseEvent.MOUSE_DOWN,MouseTracker.mouseDown);
            m_targetObject.removeEventListener(MouseEvent.MOUSE_UP,MouseTracker.mouseUp);
            m_targetObject.removeEventListener(MouseEvent.MOUSE_MOVE,MouseTracker.mouseMove);
            m_targetObject.removeEventListener(Event.DEACTIVATE,MouseTracker.disable);
            m_targetObject.removeEventListener(Event.ACTIVATE,MouseTracker.enable);
            m_targetObject = null;
            m_captureStarted = false;
            m_leftClick = false;
            trace("Mouse class deactivated");
         }
         else
         {
            trace("Warning, attempt to end capture when it was never started");
         }
      }
      
      public static function mouseDown(param1:MouseEvent) : void
      {
         m_leftClick = true;
      }
      
      public static function mouseUp(param1:MouseEvent) : void
      {
         m_leftClick = false;
      }
      
      public static function mouseMove(param1:MouseEvent) : void
      {
      }
      
      public static function disable(param1:Event) : void
      {
         m_disabled = true;
      }
      
      public static function enable(param1:Event) : void
      {
         m_disabled = false;
      }
      
      public static function get CaptureStarted() : Boolean
      {
         return m_captureStarted;
      }
      
      public static function get IsDown() : Boolean
      {
         return m_leftClick;
      }
      
      public static function get X() : Number
      {
         return m_targetObject.mouseX;
      }
      
      public static function get Y() : Number
      {
         return m_targetObject.mouseY;
      }
      
      public static function getAngle(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         if(MouseTracker.X > param1 && MouseTracker.Y < param2)
         {
            _loc4_ = Math.atan2(Math.abs(MouseTracker.Y - param2),Math.abs(MouseTracker.X - param1));
            _loc3_ = 90 - _loc4_ * 180 / Math.PI;
         }
         else if(MouseTracker.X < param1 && MouseTracker.Y < param2)
         {
            _loc4_ = Math.atan2(Math.abs(MouseTracker.Y - param2),Math.abs(MouseTracker.X - param1));
            _loc3_ = 270 + _loc4_ * 180 / Math.PI;
         }
         else if(MouseTracker.X < param1 && MouseTracker.Y > param2)
         {
            _loc4_ = Math.atan2(Math.abs(MouseTracker.Y - param2),Math.abs(MouseTracker.X - param1));
            _loc3_ = 270 - _loc4_ * 180 / Math.PI;
         }
         else if(MouseTracker.X > param1 && MouseTracker.Y > param2)
         {
            _loc4_ = Math.atan2(Math.abs(MouseTracker.Y - param2),Math.abs(MouseTracker.X - param1));
            _loc3_ = 90 + _loc4_ * 180 / Math.PI;
         }
         return _loc3_;
      }
   }
}


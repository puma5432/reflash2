package com.sbxmod.paletteMaker
{
   import flash.display.*;
   import flash.events.*;
   
   public class ColorSquare extends Sprite
   {
      
      public static var allowMultipleSelection:Boolean = true;
      
      public static var selectedBoxes:Array = [];
      
      private static var bulkClearing:Boolean = false;
      
      private static var isDragging:Boolean = false;
      
      private static var dragActionSelect:Boolean = true;
      
      public var colorValue:*;
      
      private var triangle:Sprite;
      
      private var borderSprite:Sprite;
      
      private var index:int;
      
      private var m_boxSize:Number;
      
      private var m_isSelected:Boolean = false;
      
      private var cornerRadius:Number = 5;
      
      public function ColorSquare(param1:uint, param2:Number, param3:int)
      {
         super();
         this.colorValue = param1;
         this.m_boxSize = param2;
         this.index = param3;
         graphics.clear();
         graphics.beginFill(param1,1);
         graphics.drawRoundRect(0,0,param2,param2,this.cornerRadius,this.cornerRadius);
         graphics.endFill();
         buttonMode = true;
         useHandCursor = true;
         this.borderSprite = new Sprite();
         addChild(this.borderSprite);
         this.triangle = new Sprite();
         addChild(this.triangle);
         this.makeEvents();
      }
      
      public static function deselectAll() : void
      {
         var _loc1_:ColorSquare = null;
         bulkClearing = true;
         for each(_loc1_ in selectedBoxes)
         {
            _loc1_.setSelected(false);
         }
         bulkClearing = false;
         selectedBoxes.length = 0;
      }
      
      public function selectBox_DOWN(param1:MouseEvent) : void
      {
         dragActionSelect = !this.m_isSelected;
         this.setSelected(dragActionSelect);
         isDragging = true;
      }
      
      private function selectBox_OVER(param1:MouseEvent) : void
      {
         if(isDragging)
         {
            this.setSelected(dragActionSelect);
         }
      }
      
      private function selectBox_UP(param1:MouseEvent) : void
      {
         isDragging = false;
      }
      
      private function makeEvents() : void
      {
         addEventListener(MouseEvent.MOUSE_DOWN,this.selectBox_DOWN);
         addEventListener(MouseEvent.MOUSE_OVER,this.selectBox_OVER);
         addEventListener(MouseEvent.MOUSE_UP,this.selectBox_UP);
      }
      
      public function killEvents() : void
      {
         removeEventListener(MouseEvent.MOUSE_DOWN,this.selectBox_DOWN);
         removeEventListener(MouseEvent.MOUSE_OVER,this.selectBox_OVER);
         removeEventListener(MouseEvent.MOUSE_UP,this.selectBox_UP);
      }
      
      public function setSelected(param1:Boolean) : void
      {
         this.m_isSelected = param1;
         this.drawSelectionBorder();
         if(!bulkClearing)
         {
            this.updateSelectionList();
         }
      }
      
      public function updateIndicator(param1:uint) : void
      {
         this.drawTriangle(param1);
      }
      
      private function updateSelectionList() : void
      {
         var _loc1_:int = 0;
         if(this.m_isSelected)
         {
            if(selectedBoxes.indexOf(this) == -1)
            {
               selectedBoxes.push(this);
            }
         }
         else
         {
            _loc1_ = selectedBoxes.indexOf(this);
            if(_loc1_ != -1)
            {
               selectedBoxes.splice(_loc1_,1);
            }
         }
         this.drawSelectionBorder();
      }
      
      public function getSelectedColor() : Array
      {
         return selectedBoxes;
      }
      
      private function drawSelectionBorder() : void
      {
         this.borderSprite.graphics.clear();
         if(this.m_isSelected)
         {
            this.borderSprite.graphics.lineStyle(1.5,16777215,0.9);
            this.borderSprite.graphics.drawRoundRect(0,0,this.m_boxSize,this.m_boxSize,this.cornerRadius,this.cornerRadius);
         }
         setChildIndex(this.borderSprite,numChildren - 1);
      }
      
      public function drawTriangle(param1:*) : void
      {
         this.triangle.graphics.clear();
         this.triangle.graphics.beginFill(param1);
         var _loc2_:Number = this.m_boxSize / 2;
         this.triangle.graphics.drawRoundRect(0,_loc2_,this.m_boxSize,_loc2_,this.cornerRadius,this.cornerRadius);
         this.triangle.graphics.endFill();
         setChildIndex(this.triangle,numChildren - 2);
      }
   }
}


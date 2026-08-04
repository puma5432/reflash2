package com.mcleodgaming.ssf2.menus
{
   import flash.display.MovieClip;
   
   public class MenuMapperNode
   {
      
      private var m_up:Array;
      
      private var m_down:Array;
      
      private var m_left:Array;
      
      private var m_right:Array;
      
      private var m_pressFunction:Function;
      
      private var m_hoverFunction:Function;
      
      private var m_outFunction:Function;
      
      private var m_backFunction:Function;
      
      private var m_upFunction:Function;
      
      private var m_downFunction:Function;
      
      private var m_leftFunction:Function;
      
      private var m_rightFunction:Function;
      
      public var preFunctionMode:Boolean;
      
      public var clip:MovieClip;
      
      public function MenuMapperNode(param1:MovieClip, param2:Array = null, param3:Array = null, param4:Array = null, param5:Array = null, param6:Function = null, param7:Function = null, param8:Function = null, param9:Function = null, param10:Function = null, param11:Function = null, param12:Function = null, param13:Function = null)
      {
         super();
         this.clip = param1;
         this.m_up = param2;
         this.m_down = param3;
         this.m_left = param4;
         this.m_right = param5;
         this.m_hoverFunction = param6;
         this.m_outFunction = param7;
         this.m_upFunction = param10;
         this.m_downFunction = param11;
         this.m_leftFunction = param12;
         this.m_rightFunction = param13;
         this.m_pressFunction = param8;
         this.m_backFunction = param9;
         this.preFunctionMode = true;
      }
      
      public function get Up() : Array
      {
         return this.m_up;
      }
      
      public function set Up(param1:Array) : void
      {
         this.m_up = param1;
      }
      
      public function get Down() : Array
      {
         return this.m_down;
      }
      
      public function set Down(param1:Array) : void
      {
         this.m_down = param1;
      }
      
      public function get Left() : Array
      {
         return this.m_left;
      }
      
      public function set Left(param1:Array) : void
      {
         this.m_left = param1;
      }
      
      public function get Right() : Array
      {
         return this.m_right;
      }
      
      public function set Right(param1:Array) : void
      {
         this.m_right = param1;
      }
      
      public function hoverFunction() : void
      {
         if(this.m_hoverFunction != null)
         {
            this.m_hoverFunction(null);
         }
      }
      
      public function outFunction() : void
      {
         if(this.m_outFunction != null)
         {
            this.m_outFunction(null);
         }
      }
      
      public function pressFunction() : void
      {
         if(this.m_pressFunction != null)
         {
            this.m_pressFunction(null);
         }
      }
      
      public function backFunction() : void
      {
         if(this.m_backFunction != null)
         {
            this.m_backFunction(null);
         }
      }
      
      public function upFunction() : void
      {
         if(this.m_upFunction != null)
         {
            this.m_upFunction(null);
         }
      }
      
      public function downFunction() : void
      {
         if(this.m_downFunction != null)
         {
            this.m_downFunction(null);
         }
      }
      
      public function leftFunction() : void
      {
         if(this.m_leftFunction != null)
         {
            this.m_leftFunction(null);
         }
      }
      
      public function rightFunction() : void
      {
         if(this.m_rightFunction != null)
         {
            this.m_rightFunction(null);
         }
      }
      
      public function pushToFront(param1:MenuMapperNode) : void
      {
         var _loc2_:int = 0;
         if(param1 == null)
         {
            return;
         }
         if(this.m_up)
         {
            _loc2_ = int(this.m_up.indexOf(param1));
            if(_loc2_ >= 0)
            {
               param1 = this.m_up[_loc2_];
               this.m_up.splice(_loc2_,1);
               this.m_up.unshift(param1);
            }
         }
         if(this.m_down)
         {
            _loc2_ = int(this.m_down.indexOf(param1));
            if(_loc2_ >= 0)
            {
               param1 = this.m_down[_loc2_];
               this.m_down.splice(_loc2_,1);
               this.m_down.unshift(param1);
            }
         }
         if(this.m_left)
         {
            _loc2_ = int(this.m_left.indexOf(param1));
            if(_loc2_ >= 0)
            {
               param1 = this.m_left[_loc2_];
               this.m_left.splice(_loc2_,1);
               this.m_left.unshift(param1);
            }
         }
         if(this.m_right)
         {
            _loc2_ = int(this.m_right.indexOf(param1));
            if(_loc2_ >= 0)
            {
               param1 = this.m_right[_loc2_];
               this.m_right.splice(_loc2_,1);
               this.m_right.unshift(param1);
            }
         }
      }
      
      public function updateNodes(param1:Array = null, param2:Array = null, param3:Array = null, param4:Array = null, param5:Function = null, param6:Function = null, param7:Function = null, param8:Function = null, param9:Function = null, param10:Function = null, param11:Function = null, param12:Function = null) : void
      {
         this.m_up = null;
         this.m_down = null;
         this.m_left = null;
         this.m_right = null;
         this.m_up = param1;
         this.m_down = param2;
         this.m_left = param3;
         this.m_right = param4;
         this.m_hoverFunction = param5;
         this.m_outFunction = param6;
         this.m_upFunction = param9;
         this.m_downFunction = param10;
         this.m_leftFunction = param11;
         this.m_rightFunction = param12;
         this.m_pressFunction = param7;
         this.m_backFunction = param8;
      }
      
      public function dispose() : void
      {
         this.m_up = null;
         this.m_down = null;
         this.m_left = null;
         this.m_right = null;
      }
   }
}


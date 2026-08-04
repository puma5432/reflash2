package com.mcleodgaming.ssf2.util
{
   public class Dictionary
   {
      
      private var m_keys:Array;
      
      private var m_values:Array;
      
      private var m_type:Class;
      
      public function Dictionary(param1:Class)
      {
         super();
         this.m_keys = new Array();
         this.m_values = new Array();
         if(param1 == null)
         {
            this.m_type = Object;
         }
         else
         {
            this.m_type = param1;
         }
      }
      
      public function get length() : int
      {
         return this.m_keys.length;
      }
      
      public function get Keys() : Array
      {
         var _loc2_:int = 0;
         var _loc1_:Array = new Array();
         while(_loc2_ < this.m_keys.length)
         {
            _loc1_.push(this.m_keys[_loc2_]);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function get Values() : Array
      {
         var _loc2_:int = 0;
         var _loc1_:Array = new Array();
         while(_loc2_ < this.m_values.length)
         {
            _loc1_.push(this.m_values[_loc2_]);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function push(param1:String, param2:*) : Boolean
      {
         if(!(param2 is Object))
         {
            trace("Error, attempt to add an Object that does not match the defined type: " + this.m_type);
            return false;
         }
         if(!this.containsKey(param1))
         {
            this.m_keys.push(param1);
            this.m_values.push(param2);
         }
         else
         {
            trace("Warning, attempted to provide a duplicate key \"" + param1 + "\". This key\'s value has been replaced by the new Object.");
            this.m_values[this.m_keys.indexOf(param1)] = param2;
         }
         return true;
      }
      
      public function pop() : *
      {
         if(this.m_keys.length > 0)
         {
            return this.remove(this.m_keys[this.m_keys.length - 1]);
         }
         return null;
      }
      
      public function remove(param1:String) : *
      {
         var _loc2_:int = int(this.m_keys.indexOf(param1));
         if(_loc2_ < 0)
         {
            trace("Error removing key: " + param1);
            return null;
         }
         var _loc3_:* = this.m_values[_loc2_];
         this.m_values[_loc2_] = null;
         this.m_values.splice(_loc2_,1);
         this.m_keys.splice(_loc2_,1);
         return _loc3_;
      }
      
      public function getValue(param1:*) : String
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:int = int(this.m_values.indexOf(param1));
         if(_loc2_ < 0)
         {
            return null;
         }
         return this.m_keys[_loc2_];
      }
      
      public function getKey(param1:String) : *
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.m_keys.length)
         {
            if(this.m_keys[_loc2_] == param1)
            {
               return this.m_values[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function setKey(param1:String, param2:*) : void
      {
         var _loc3_:int = 0;
         if(this.containsKey(param1))
         {
            _loc3_ = int(this.m_keys.indexOf(param1));
            if(!(param2 is this.m_type))
            {
               trace("Error, attempt to add an Object that does not match the defined type: " + this.m_type);
               return;
            }
            this.m_values[_loc3_] = null;
            this.m_values[_loc3_] = param2;
         }
         else
         {
            this.push(param1,param2);
         }
      }
      
      public function containsKey(param1:String) : Boolean
      {
         return this.getKey(param1) != null;
      }
      
      public function containsValue(param1:*) : Boolean
      {
         return this.getValue(param1) != null;
      }
      
      public function clear() : void
      {
         this.m_keys.splice(0);
         this.m_values.splice(0);
      }
   }
}


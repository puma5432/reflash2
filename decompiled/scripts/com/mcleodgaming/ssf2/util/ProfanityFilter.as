package com.mcleodgaming.ssf2.util
{
   public class ProfanityFilter
   {
      
      private static var _instance:ProfanityFilter;
      
      private static const wordfilter:Class = ProfanityFilter_wordfilter;
      
      public static const wordfilterData:Object = JSON.parse(new String(new ProfanityFilter.wordfilter())) as Object;
      
      private var list:Array;
      
      private var placeHolder:String;
      
      public function ProfanityFilter(param1:* = null)
      {
         var _loc2_:int = 0;
         super();
         param1 ||= {};
         this.placeHolder = param1.placeHolder || "***";
         this.list = JSON.parse(JSON.stringify(wordfilterData.words)) as Array;
         while(_loc2_ < this.list.length)
         {
            this.list[_loc2_] = this.list[_loc2_].replace(/i/gi,"(i|l|1|!|¡|\\|)+");
            _loc2_++;
         }
      }
      
      public static function get instance() : ProfanityFilter
      {
         if(!_instance)
         {
            _instance = new ProfanityFilter();
         }
         return _instance;
      }
      
      public function isProfane(param1:String) : Boolean
      {
         return this.clean(param1) ? true : false;
      }
      
      public function clean(param1:String) : String
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.list.length)
         {
            param1 = param1.replace(new RegExp(this.list[_loc2_],"ig"),this.placeHolder);
            _loc2_++;
         }
         return param1;
      }
   }
}


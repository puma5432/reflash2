package com.mcleodgaming.ssf2.util
{
   public class CountryRegionData
   {
      
      private static const countryRegionDataJSON:Class = CountryRegionData_countryRegionDataJSON;
      
      public static const data:Object = JSON.parse(new String(new CountryRegionData.countryRegionDataJSON())) as Object;
      
      public function CountryRegionData()
      {
         super();
      }
      
      public static function getCountryName(param1:String) : String
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         while(_loc3_ < CountryRegionData.data.length)
         {
            _loc2_ = CountryRegionData.data[_loc3_];
            if(_loc2_.countryShortCode === param1)
            {
               return _loc2_.countryName;
            }
            _loc3_++;
         }
         return "";
      }
      
      public static function getRegionName(param1:String, param2:String) : String
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         while(_loc6_ < CountryRegionData.data.length)
         {
            _loc3_ = CountryRegionData.data[_loc6_];
            if(_loc3_.countryShortCode === param1)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc3_.regions.length)
               {
                  _loc5_ = _loc3_.regions[_loc4_];
                  if(_loc5_.shortCode === param2)
                  {
                     return _loc5_.name;
                  }
                  _loc4_++;
               }
               break;
            }
            _loc6_++;
         }
         return "";
      }
      
      public static function getLocationClean(param1:String, param2:String) : String
      {
         var _loc3_:String = getCountryName(param1);
         var _loc4_:String = getRegionName(param1,param2);
         if(!_loc3_)
         {
            return "Unknown";
         }
         if(!_loc4_)
         {
            return _loc3_;
         }
         return _loc3_ + "/" + _loc4_;
      }
   }
}


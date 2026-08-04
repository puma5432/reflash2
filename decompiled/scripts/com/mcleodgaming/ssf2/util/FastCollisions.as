package com.mcleodgaming.ssf2.util
{
   public class FastCollisions
   {
      
      public function FastCollisions()
      {
         super();
      }
      
      public static function rectangles(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Number, param12:Number, param13:Number, param14:Number, param15:Number, param16:Number) : Boolean
      {
         if(!isProjectedAxisCollision(param1,param2,param3,param4,param9,param10,param11,param12,param13,param14,param15,param16))
         {
            return false;
         }
         if(!isProjectedAxisCollision(param3,param4,param5,param6,param9,param10,param11,param12,param13,param14,param15,param16))
         {
            return false;
         }
         if(!isProjectedAxisCollision(param9,param10,param11,param12,param1,param2,param3,param4,param5,param6,param7,param8))
         {
            return false;
         }
         if(!isProjectedAxisCollision(param11,param12,param13,param14,param1,param2,param3,param4,param5,param6,param7,param8))
         {
            return false;
         }
         return true;
      }
      
      public static function isProjectedAxisCollision(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Number, param12:Number) : Boolean
      {
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         if(param1 == param3)
         {
            _loc13_ = _loc14_ = _loc15_ = _loc16_ = param1;
            _loc17_ = param6;
            _loc18_ = param8;
            _loc19_ = param10;
            _loc20_ = param12;
            if(param2 > param4)
            {
               if(_loc17_ > param2 && _loc18_ > param2 && _loc19_ > param2 && _loc20_ > param2 || _loc17_ < param4 && _loc18_ < param4 && _loc19_ < param4 && _loc20_ < param4)
               {
                  return false;
               }
            }
            else if(_loc17_ > param4 && _loc18_ > param4 && _loc19_ > param4 && _loc20_ > param4 || _loc17_ < param2 && _loc18_ < param2 && _loc19_ < param2 && _loc20_ < param2)
            {
               return false;
            }
            return true;
         }
         if(param2 == param4)
         {
            _loc13_ = param5;
            _loc14_ = param7;
            _loc15_ = param9;
            _loc16_ = param11;
            _loc17_ = _loc18_ = _loc19_ = _loc20_ = param2;
         }
         else
         {
            _loc21_ = (param2 - param4) / (param1 - param3);
            _loc22_ = 1 / _loc21_;
            _loc23_ = param3 * _loc21_ - param4;
            _loc24_ = 1 / (_loc21_ + _loc22_);
            _loc13_ = (param6 + _loc23_ + param5 * _loc22_) * _loc24_;
            _loc14_ = (param8 + _loc23_ + param7 * _loc22_) * _loc24_;
            _loc15_ = (param10 + _loc23_ + param9 * _loc22_) * _loc24_;
            _loc16_ = (param12 + _loc23_ + param11 * _loc22_) * _loc24_;
            _loc17_ = param6 + (param5 - _loc13_) * _loc22_;
            _loc18_ = param8 + (param7 - _loc14_) * _loc22_;
            _loc19_ = param10 + (param9 - _loc15_) * _loc22_;
            _loc20_ = param12 + (param11 - _loc16_) * _loc22_;
         }
         if(param1 > param3)
         {
            if(_loc13_ > param1 && _loc14_ > param1 && _loc15_ > param1 && _loc16_ > param1 || _loc13_ < param3 && _loc14_ < param3 && _loc15_ < param3 && _loc16_ < param3)
            {
               return false;
            }
         }
         else if(_loc13_ > param3 && _loc14_ > param3 && _loc15_ > param3 && _loc16_ > param3 || _loc13_ < param1 && _loc14_ < param1 && _loc15_ < param1 && _loc16_ < param1)
         {
            return false;
         }
         return true;
      }
   }
}


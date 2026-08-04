package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.util.*;
   
   public class Stats
   {
      
      private static var m_expansions:Vector.<Vector.<CharacterData>>;
      
      private static var m_expansionObjects:Vector.<Vector.<Object>>;
      
      private static var m_statObjects:Object = {};
      
      public function Stats()
      {
         super();
      }
      
      public static function init() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = ResourceManager.getResourceByID("mappings").getProp("metadata");
         for(_loc1_ in _loc4_.character)
         {
            Stats.writeStats({"cData":{
               "statsName":_loc1_,
               "displayName":_loc4_.character[_loc1_].name,
               "seriesIcon":_loc4_.character[_loc1_].seriesIcon || null
            }});
         }
         for(_loc1_ in _loc4_.character)
         {
            ResourceManager.addResource(new Resource(_loc1_,_loc4_.character[_loc1_].file,_loc4_.character[_loc1_].file_pub,_loc4_.character[_loc1_].guid,Resource.CHARACTER));
            ResourceManager.manifestJSONData.character[_loc1_] = _loc4_.character[_loc1_];
         }
         for(_loc1_ in _loc4_.stage)
         {
            ResourceManager.addResource(new Resource(_loc1_,_loc4_.stage[_loc1_].file,_loc4_.stage[_loc1_].file_pub,_loc4_.stage[_loc1_].guid,Resource.STAGE));
            ResourceManager.manifestJSONData.stage[_loc1_] = _loc4_.stage[_loc1_];
         }
         for(_loc1_ in _loc4_.music)
         {
            ResourceManager.addResource(new Resource(_loc1_,_loc4_.music[_loc1_].file,_loc4_.music[_loc1_].file_pub,_loc4_.music[_loc1_].guid,Resource.MUSIC));
            ResourceManager.manifestJSONData.music[_loc1_] = _loc4_.music[_loc1_];
         }
         for(_loc1_ in _loc4_.extra)
         {
            ResourceManager.addResource(new Resource(_loc1_,_loc4_.extra[_loc1_].file,_loc4_.extra[_loc1_].file_pub,_loc4_.extra[_loc1_].guid,Resource.EXTRA));
            ResourceManager.manifestJSONData.extra[_loc1_] = _loc4_.extra[_loc1_];
         }
         Stats.m_expansions = new Vector.<Vector.<CharacterData>>();
         Stats.m_expansionObjects = new Vector.<Vector.<Object>>();
         while(ResourceManager.getExpansionCharacter(_loc2_) != null)
         {
            _loc3_ = 0;
            m_expansions[_loc2_] = new Vector.<CharacterData>();
            m_expansionObjects[_loc2_] = new Vector.<Object>();
            while(ResourceManager.getExpansionCharacterObject(_loc2_,_loc3_) != null)
            {
               if(!Stats.loadExpansionData(_loc2_,ResourceManager.getExpansionCharacterObject(_loc2_,_loc3_)))
               {
                  trace("[Stats] Failed loading expansion id No. " + _loc2_);
               }
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      public static function writeStats(param1:Object) : void
      {
         param1 ||= {};
         var _loc2_:String = param1.cData ? param1.cData.statsName : null;
         if(_loc2_)
         {
            if(Stats.m_statObjects[_loc2_] == undefined)
            {
               Stats.m_statObjects[_loc2_] = new Object();
            }
            if(param1.cData)
            {
               Stats.m_statObjects[_loc2_].cData = param1.cData;
            }
            if(param1.aData)
            {
               Stats.m_statObjects[_loc2_].aData = param1.aData;
            }
            if(param1.pData)
            {
               Stats.m_statObjects[_loc2_].pData = param1.pData;
            }
            if(param1.iData)
            {
               Stats.m_statObjects[_loc2_].iData = param1.iData;
            }
         }
      }
      
      public static function getStats(param1:String, param2:Number = -1) : CharacterData
      {
         if(param2 >= 0)
         {
            return Stats.getExpansionData(param2,param1);
         }
         return createCharacterDataFrom(Stats.m_statObjects[param1]);
      }
      
      public static function getFreshStats(param1:String, param2:Number = -1) : CharacterData
      {
         if(param2 >= 0)
         {
            return createCharacterDataFrom(Stats.getExpansionObject(param2,param1));
         }
         return createCharacterDataFrom(Stats.m_statObjects[param1]);
      }
      
      public static function clearStats(param1:String) : void
      {
         m_statObjects[param1] = {"cData":{
            "displayName":m_statObjects[param1].cData.displayName,
            "seriesIcon":m_statObjects[param1].cData.seriesIcon,
            "statsName":m_statObjects[param1].cData.statsName
         }};
      }
      
      private static function loadExpansionData(param1:int, param2:Object) : Boolean
      {
         var parameters:Object = null;
         var statObject:Object = null;
         var exp:CharacterData = null;
         var id:int = param1;
         var expObj:Object = param2;
         try
         {
            parameters = expObj;
            statObject = {
               "cData":parameters.cData,
               "aData":parameters.aData,
               "pData":parameters.pData,
               "iData":parameters.iData
            };
            exp = Stats.createCharacterDataFrom(statObject);
            Stats.m_expansions[id].push(exp);
            Stats.m_expansionObjects[id].push(statObject);
            trace("[Stats] Successfully loaded expansion id No. " + id + " as " + parameters.cData.statsName);
         }
         catch(error:Error)
         {
            trace("[Stats] Error loading expansion data");
            trace("[Stats]",error.getStackTrace());
            return false;
         }
         return true;
      }
      
      private static function createCharacterDataFrom(param1:Object) : CharacterData
      {
         var _loc2_:Object = null;
         var _loc3_:CharacterData = new CharacterData();
         param1 ||= {};
         var _loc4_:Object = param1.cData || {};
         var _loc5_:Object = param1.aData || {};
         var _loc6_:Object = param1.pData || {};
         var _loc7_:Object = param1.iData || {};
         if(Stats.m_statObjects[_loc4_.statsName] != null)
         {
            _loc2_ = Stats.m_statObjects[_loc4_.statsName];
            _loc3_.importData(_loc2_.cData);
            _loc3_.importAttacks(_loc2_.aData);
            _loc3_.addProjectiles(_loc2_.pData);
            _loc3_.addItems(_loc2_.iData);
         }
         else if(param1.aData != null)
         {
            _loc3_.importData(_loc4_);
            _loc3_.importAttacks(_loc5_);
            _loc3_.addProjectiles(_loc6_);
            _loc3_.addItems(_loc7_);
         }
         else
         {
            _loc3_.importData(_loc4_);
         }
         return _loc3_;
      }
      
      private static function getExpansionData(param1:Number, param2:String = null) : CharacterData
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(param1 < 0 || param1 >= Stats.m_expansions.length || Stats.m_expansions.length == 0)
         {
            return null;
         }
         if(param2 != null && param2 != "xp")
         {
            _loc3_ = param1;
            while(_loc3_ < Stats.m_expansions.length)
            {
               _loc4_ = 0;
               while(_loc4_ < Stats.m_expansions[_loc3_].length)
               {
                  if(Stats.m_expansions[_loc3_][_loc4_].StatsName == param2)
                  {
                     if(Stats.m_expansions[_loc3_][_loc4_].StatsName == param2)
                     {
                        return Stats.m_expansions[_loc3_][_loc4_];
                     }
                  }
                  _loc4_++;
               }
               _loc3_++;
            }
            return null;
         }
         return Stats.m_expansions[param1][0];
      }
      
      private static function getExpansionObject(param1:Number, param2:String = null) : Object
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(param1 < 0 || param1 >= Stats.m_expansionObjects.length || Stats.m_expansionObjects.length == 0)
         {
            return null;
         }
         if(param2 != null && param2 != "xp")
         {
            _loc3_ = param1;
            while(_loc3_ < Stats.m_expansionObjects.length)
            {
               _loc4_ = 0;
               while(_loc4_ < Stats.m_expansionObjects[_loc3_].length)
               {
                  if(Stats.m_expansionObjects[_loc3_][_loc4_].cData.statsName == param2)
                  {
                     if(Stats.m_expansionObjects[_loc3_][_loc4_].cData.statsName == param2)
                     {
                        return Stats.m_expansionObjects[_loc3_][_loc4_];
                     }
                  }
                  _loc4_++;
               }
               _loc3_++;
            }
            return null;
         }
         return Stats.m_expansionObjects[param1][0];
      }
      
      public static function getRandomCharacter(param1:Boolean = true) : CharacterData
      {
         var _loc2_:Array = getCharacterList(param1);
         var _loc3_:String = _loc2_[Utils.randomInteger(0,_loc2_.length - 1)];
         return Stats.getStats(_loc3_);
      }
      
      public static function getCharacterList(param1:Boolean = true, param2:Boolean = true) : Array
      {
         var _loc6_:int = 0;
         var _loc3_:Array = new Array();
         var _loc4_:Object = ResourceManager.getResourceByID("mappings").getProp("metadata");
         var _loc5_:Array = _loc4_.random_characters.characters;
         while(_loc6_ < _loc5_.length)
         {
            if(Boolean(Main.DEBUG) || !param1 || param1 && SaveData.Unlocks[_loc5_[_loc6_]] !== false)
            {
               _loc3_.push(_loc5_[_loc6_]);
            }
            _loc6_++;
         }
         return _loc3_;
      }
   }
}


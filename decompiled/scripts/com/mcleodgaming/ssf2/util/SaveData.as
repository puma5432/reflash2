package com.mcleodgaming.ssf2.util
{
   import com.mcleodgaming.mgn.net.*;
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.Game;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.input.*;
   import flash.events.NetStatusEvent;
   import flash.filesystem.*;
   import flash.net.SharedObject;
   import flash.utils.*;
   
   public class SaveData
   {
      
      private static var m_sharedObject:SharedObject;
      
      private static var m_localObject:Object;
      
      public static var Controllers:Vector.<Controller>;
      
      private static var _lastPowerCheck:Date;
      
      private static const m_currentSaveFileName:String = "ssf2_beta_1_4_0.dat";
      
      private static const m_previousSaveFileNames:Array = ["ssf2_beta.dat","ssf2_beta_1_1.dat","ssf2_beta_1_2.dat","ssf2_beta_1_2_1.dat","ssf2_beta_1_2_2.dat","ssf2_beta_1_2_3.dat","ssf2_beta_1_2_4.dat","ssf2_beta_1_2_5.dat","ssf2_beta_1_3_0.dat","ssf2_beta_1_3_1.dat"];
      
      private static const m_saveFileFriendlyNamesList:Array = [{
         "pattern":/^ssf2_beta(?:\.dat)?$/,
         "value":"SSF2 Beta 1.0.*"
      },{
         "pattern":/^ssf2_beta_1_1(?:\.dat)?$/,
         "value":"SSF2 Beta 1.1.*"
      },{
         "pattern":/^ssf2_beta_1_2(?:\.dat)?$/,
         "value":"SSF2 Beta 1.2.0.*"
      },{
         "pattern":/^ssf2_beta_1_2_1(?:\.dat)?$/,
         "value":"SSF2 Beta 1.2.1.*"
      },{
         "pattern":/^ssf2_beta_1_2_2(?:\.dat)?$/,
         "value":"SSF2 Beta 1.2.2.*"
      },{
         "pattern":/^ssf2_beta_1_2_3(?:\.dat)?$/,
         "value":"SSF2 Beta 1.2.3.*"
      },{
         "pattern":/^ssf2_beta_1_2_4(?:\.dat)?$/,
         "value":"SSF2 Beta 1.2.4.*"
      },{
         "pattern":/^ssf2_beta_1_2_5(?:\.dat)?$/,
         "value":"SSF2 Beta 1.2.5.*"
      },{
         "pattern":/^ssf2_beta_1_3_\d+(?:\.dat)?$/,
         "value":"SSF2 Beta 1.3.0.*"
      },{
         "pattern":/^ssf2_beta_1_4_\d+(?:\.dat)?$/,
         "value":"SSF2 Beta 1.4.0.*"
      }];
      
      public static var corrupted:Boolean = false;
      
      public static var rumbleEnabled:Object = null;
      
      init();
      
      public function SaveData()
      {
         super();
      }
      
      public static function saveDataFileToFriendlyName(param1:String) : String
      {
         var _loc2_:int = 0;
         while(_loc2_ < SaveData.m_saveFileFriendlyNamesList.length)
         {
            if(SaveData.m_saveFileFriendlyNamesList[_loc2_].pattern.test(param1))
            {
               return SaveData.m_saveFileFriendlyNamesList[_loc2_].value;
            }
            _loc2_++;
         }
         return param1;
      }
      
      public static function init() : void
      {
         _lastPowerCheck = new Date();
      }
      
      public static function initializeSaveData(param1:Boolean = true) : void
      {
         var _loc2_:int = 0;
         trace("SaveData initialized");
         loadGame(param1);
         Gamepad.setGlobalRumbleEnabled(Boolean(SaveData.getRumbleEnabled(1)) || Boolean(SaveData.getRumbleEnabled(2)) || Boolean(SaveData.getRumbleEnabled(3)) || Boolean(SaveData.getRumbleEnabled(4)));
         trace("[RUMBLE DEBUG] Player 1 rumble enabled: " + SaveData.getRumbleEnabled(1));
         trace("[RUMBLE DEBUG] Player 2 rumble enabled: " + SaveData.getRumbleEnabled(2));
         trace("[RUMBLE DEBUG] Player 3 rumble enabled: " + SaveData.getRumbleEnabled(3));
         trace("[RUMBLE DEBUG] Player 4 rumble enabled: " + SaveData.getRumbleEnabled(4));
         trace("[RUMBLE DEBUG] Global rumble enabled: " + Gamepad.getGlobalRumbleEnabled());
         if(m_localObject.game == undefined || m_localObject.game.exists == undefined || m_localObject.game.exists == false)
         {
            m_localObject.game = SaveDataMigrations.migrate(SaveDataMigrations.getInitialData());
            ProtocolSetting.tcpIP = m_localObject.game.options.tcpIP;
            ProtocolSetting.tcpPort = m_localObject.game.options.tcpPort;
            ProtocolSetting.udpIP = m_localObject.game.options.udpIP;
            ProtocolSetting.udpPort = m_localObject.game.options.udpPort;
            SaveData.Controllers = new Vector.<Controller>();
            _loc2_ = 0;
            while(_loc2_ < Main.MAXPLAYERS)
            {
               switch(_loc2_)
               {
                  case 0:
                     SaveData.Controllers.push(new Controller(_loc2_ + 1,{
                        "UP":87,
                        "DOWN":83,
                        "LEFT":65,
                        "RIGHT":68,
                        "BUTTON1":79,
                        "BUTTON2":80,
                        "GRAB":85,
                        "START":8,
                        "TAUNT":49,
                        "SHIELD":73,
                        "JUMP":0,
                        "JUMP2":0,
                        "C_UP":0,
                        "C_DOWN":0,
                        "C_LEFT":0,
                        "C_RIGHT":0,
                        "DASH":0,
                        "AUTO_DASH":0,
                        "DT_DASH":1,
                        "TAP_JUMP":1
                     }));
                     break;
                  case 1:
                     SaveData.Controllers.push(new Controller(_loc2_ + 1,{
                        "UP":38,
                        "DOWN":40,
                        "LEFT":37,
                        "RIGHT":39,
                        "BUTTON1":98,
                        "BUTTON2":99,
                        "GRAB":101,
                        "START":96,
                        "TAUNT":100,
                        "SHIELD":97,
                        "JUMP":0,
                        "JUMP2":0,
                        "C_UP":0,
                        "C_DOWN":0,
                        "C_LEFT":0,
                        "C_RIGHT":0,
                        "DASH":0,
                        "AUTO_DASH":0,
                        "DT_DASH":1,
                        "TAP_JUMP":1
                     }));
                     break;
                  default:
                     SaveData.Controllers.push(new Controller(_loc2_ + 1,{
                        "UP":0,
                        "DOWN":0,
                        "LEFT":0,
                        "RIGHT":0,
                        "BUTTON1":0,
                        "BUTTON2":0,
                        "GRAB":0,
                        "START":0,
                        "TAUNT":0,
                        "SHIELD":0,
                        "JUMP":0,
                        "JUMP2":0,
                        "C_UP":0,
                        "C_DOWN":0,
                        "C_LEFT":0,
                        "C_RIGHT":0,
                        "DASH":0,
                        "AUTO_DASH":0,
                        "DT_DASH":1,
                        "TAP_JUMP":1
                     }));
               }
               m_localObject.game.controlSettings["player" + (_loc2_ + 1)] = SaveData.Controllers[_loc2_].getControls();
               _loc2_++;
            }
            saveGame();
         }
         else
         {
            SaveDataMigrations.migrate(m_localObject.game);
            ++m_localObject.game.records.misc.powerCount;
            ProtocolSetting.tcpIP = m_localObject.game.options.tcpIP;
            ProtocolSetting.tcpPort = m_localObject.game.options.tcpPort;
            ProtocolSetting.udpIP = m_localObject.game.options.udpIP;
            ProtocolSetting.udpPort = m_localObject.game.options.udpPort;
            SaveData.Controllers = new Vector.<Controller>();
            _loc2_ = 0;
            while(_loc2_ < Main.MAXPLAYERS)
            {
               SaveData.Controllers.push(new Controller(_loc2_ + 1,{
                  "UP":0,
                  "DOWN":0,
                  "LEFT":0,
                  "RIGHT":0,
                  "BUTTON1":0,
                  "BUTTON2":0,
                  "GRAB":0,
                  "START":0,
                  "TAUNT":0,
                  "SHIELD":0,
                  "JUMP":0,
                  "JUMP2":0,
                  "C_UP":0,
                  "C_DOWN":0,
                  "C_LEFT":0,
                  "C_RIGHT":0,
                  "DASH":0,
                  "AUTO_DASH":0,
                  "DT_DASH":1,
                  "TAP_JUMP":1
               }));
               if(m_localObject.game.controlSettings["player" + (_loc2_ + 1)])
               {
                  SaveData.Controllers[_loc2_].setControls(m_localObject.game.controlSettings["player" + (_loc2_ + 1)]);
               }
               _loc2_++;
            }
         }
      }
      
      private static function onStatus(param1:NetStatusEvent) : void
      {
         if(param1.info.level == "error")
         {
            trace("You need to allow the Flash Player enough memory in order to save your game. Right click the game, go to \"Settings\", click the Folder icon, and allow unlimited save space.");
         }
      }
      
      public static function eraseGame() : void
      {
         var saveFile:File = null;
         saveFile = File.applicationStorageDirectory.resolvePath(m_currentSaveFileName);
         try
         {
            if(saveFile.exists)
            {
               saveFile.deleteFile();
            }
         }
         catch(e:*)
         {
            trace("Problem deleting data...");
         }
         initializeSaveData(false);
         SoundQueue.instance.updateVolumeLevel();
         Main.setFullScreenMode(SaveData.Quality.fullscreen_quality);
         Main.Root.stage.quality = SaveData.Quality.display_quality;
      }
      
      public static function saveGame() : void
      {
         var savedata:String;
         var saveFile:File = null;
         var bArr:ByteArray = null;
         var fileWriter:FileStream = null;
         var timeDiff:int = int((new Date().getTime() - _lastPowerCheck.getTime()) / 1000 * Main.FRAMERATE);
         _lastPowerCheck = new Date();
         SaveData.PowerTime += timeDiff;
         savedata = JSON.stringify(m_localObject);
         saveFile = File.applicationStorageDirectory.resolvePath(m_currentSaveFileName);
         try
         {
            bArr = new ByteArray();
            bArr.writeUTFBytes(Base64.encode(JSON.stringify(m_localObject)));
            bArr.compress();
            fileWriter = new FileStream();
            fileWriter.open(saveFile,FileMode.WRITE);
            fileWriter.writeBytes(bArr);
            fileWriter.close();
         }
         catch(e:*)
         {
            trace("Problem saving data...");
         }
         trace("Save Data Updated");
      }
      
      private static function importSaveFile(param1:String) : Boolean
      {
         var saveFile:File = null;
         var bArr:ByteArray = null;
         var fileReader:FileStream = null;
         var file:String = param1;
         saveFile = File.applicationStorageDirectory.resolvePath(file);
         if(saveFile.exists)
         {
            try
            {
               bArr = new ByteArray();
               fileReader = new FileStream();
               fileReader.open(saveFile,FileMode.READ);
               fileReader.readBytes(bArr);
               fileReader.close();
               bArr.uncompress();
               try
               {
                  m_localObject = JSON.parse(Base64.decode(bArr.readUTFBytes(bArr.length)));
                  return true;
               }
               catch(e:*)
               {
                  bArr.position = 0;
                  m_localObject = JSON.parse(Base64.decode(bArr.readUTF()));
                  return true;
               }
            }
            catch(e:*)
            {
               m_localObject = {};
               SaveData.corrupted = true;
            }
         }
         return false;
      }
      
      public static function loadGame(param1:Boolean = true) : void
      {
         var _loc2_:File = null;
         var _loc3_:* = 0;
         _loc2_ = File.applicationStorageDirectory.resolvePath(m_currentSaveFileName);
         if(!_loc2_.exists)
         {
            _loc3_ = int(SaveData.m_previousSaveFileNames.length - 1);
            while(_loc3_ >= 0 && !SaveData.corrupted && param1)
            {
               if(importSaveFile(SaveData.m_previousSaveFileNames[_loc3_]))
               {
                  return;
               }
               _loc3_--;
            }
            m_localObject = {};
         }
         else
         {
            importSaveFile(m_currentSaveFileName);
         }
      }
      
      public static function getExistingOldSaveFileNames() : Vector.<String>
      {
         var _loc1_:String = null;
         var _loc3_:int = 0;
         var _loc2_:Vector.<String> = new Vector.<String>();
         while(_loc3_ < SaveData.m_previousSaveFileNames.length)
         {
            _loc1_ = SaveData.m_previousSaveFileNames[_loc3_];
            if(File.applicationStorageDirectory.resolvePath(_loc1_).exists)
            {
               _loc2_.push(_loc1_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function getSavedVSOptions() : Object
      {
         return m_localObject.game.options;
      }
      
      public static function setSavedVSOptions(param1:Game) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         m_localObject.game.options.teamDamage = param1.LevelData.teamDamage;
         m_localObject.game.options.VS_Time = param1.LevelData.time;
         m_localObject.game.options.VS_DamageRatio = param1.LevelData.damageRatio;
         m_localObject.game.options.VS_FinalSmashMeter = param1.LevelData.finalSmashMeter;
         m_localObject.game.options.VS_ScoreDisplay = param1.LevelData.scoreDisplay;
         m_localObject.game.options.VS_HudDisplay = param1.LevelData.hudDisplay;
         m_localObject.game.options.VS_PauseEnabled = param1.LevelData.pauseEnabled;
         m_localObject.game.options.VS_DisplayPlayer = param1.LevelData.showPlayerID;
         m_localObject.game.options.VS_Lives = param1.LevelData.lives;
         m_localObject.game.options.VS_StartDamage = param1.LevelData.startDamage;
         m_localObject.game.options.VS_ItemFreq = param1.Items.frequency;
         m_localObject.game.options.VS_UsingLives = param1.LevelData.usingLives;
         m_localObject.game.options.VS_UsingTime = param1.LevelData.usingTime;
         m_localObject.game.options.VS_StartStamina = param1.LevelData.startStamina;
         m_localObject.game.options.VS_UsingStamina = param1.LevelData.usingStamina;
         m_localObject.game.options.arenaScore = param1.LevelData.scoreLimit;
         while(_loc3_ < param1.PlayerSettings.length)
         {
            m_localObject.game.options["VS_CPULevel" + (_loc3_ + 1)] = param1.PlayerSettings[_loc3_].level;
            _loc3_++;
         }
         m_localObject.game.options.VS_Items = {};
         for(_loc2_ in param1.Items.items)
         {
            if(param1.Items.items[_loc2_] === false)
            {
               m_localObject.game.options.VS_Items[_loc2_] = param1.Items.items[_loc2_];
            }
         }
      }
      
      public static function get RawLocalObject() : Object
      {
         return m_localObject;
      }
      
      public static function get UsingTime() : Boolean
      {
         return m_localObject.game.options.VS_UsingTime;
      }
      
      public static function get UsingLives() : Boolean
      {
         return m_localObject.game.options.VS_UsingLives;
      }
      
      public static function get UsingStamina() : Boolean
      {
         return m_localObject.game.options.VS_UsingStamina;
      }
      
      public static function get ShowPlayerID() : Boolean
      {
         return m_localObject.game.options.VS_DisplayPlayer;
      }
      
      public static function get DamageRatio() : Number
      {
         return m_localObject.game.options.VS_DamageRatio;
      }
      
      public static function get StartDamage() : Number
      {
         return m_localObject.game.options.VS_StartDamage;
      }
      
      public static function get StartStamina() : Number
      {
         return m_localObject.game.options.VS_StartStamina;
      }
      
      public static function get Time() : Number
      {
         return m_localObject.game.options.VS_Time as Number;
      }
      
      public static function get Lives() : Number
      {
         return m_localObject.game.options.VS_Lives;
      }
      
      public static function get ItemDataObj() : Object
      {
         return m_localObject.game.options.VS_Items;
      }
      
      public static function set ItemDataObj(param1:Object) : void
      {
         m_localObject.game.options.VS_Items = param1;
      }
      
      public static function get VSStageDataObj() : Object
      {
         return m_localObject.game.options.VS_Stages;
      }
      
      public static function get ItemFrequency() : Number
      {
         return m_localObject.game.options.VS_ItemFreq;
      }
      
      public static function toggleTime(param1:Boolean) : void
      {
         m_localObject.game.options.VS_Time = param1 ? m_localObject.game.options.VS_Time + 1 : m_localObject.game.options.VS_Time - 1;
         if(m_localObject.game.options.VS_Time <= 0)
         {
            m_localObject.game.options.VS_Time = 99;
         }
         else if(m_localObject.game.options.VS_Time > 99)
         {
            m_localObject.game.options.VS_Time = 1;
         }
      }
      
      public static function toggleStock(param1:Boolean) : void
      {
         m_localObject.game.options.VS_Lives = param1 ? m_localObject.game.options.VS_Lives + 1 : m_localObject.game.options.VS_Lives - 1;
         if(m_localObject.game.options.VS_Lives <= 0)
         {
            m_localObject.game.options.VS_Lives = 99;
         }
         else if(m_localObject.game.options.VS_Lives > 99)
         {
            m_localObject.game.options.VS_Lives = 1;
         }
      }
      
      public static function toggleDamageRatio(param1:Boolean) : void
      {
         m_localObject.game.options.VS_DamageRatio = param1 ? m_localObject.game.options.VS_DamageRatio + 0.1 : m_localObject.game.options.VS_DamageRatio - 0.1;
         if(m_localObject.game.options.VS_DamageRatio > 2)
         {
            m_localObject.game.options.VS_DamageRatio = 2;
         }
         else if(m_localObject.game.options.VS_DamageRatio < 0.5)
         {
            m_localObject.game.options.VS_DamageRatio = 0.5;
         }
         m_localObject.game.options.VS_DamageRatio = Math.round(m_localObject.game.options.VS_DamageRatio * 10) / 10;
      }
      
      public static function toggleItemFrequency(param1:Boolean) : void
      {
         m_localObject.game.options.VS_ItemFreq = param1 ? m_localObject.game.options.VS_ItemFreq + 1 : m_localObject.game.options.VS_ItemFreq - 1;
         if(m_localObject.game.options.VS_ItemFreq > 5)
         {
            m_localObject.game.options.VS_ItemFreq = 5;
         }
         else if(m_localObject.game.options.VS_ItemFreq < 0)
         {
            m_localObject.game.options.VS_ItemFreq = 0;
         }
      }
      
      public static function setStartDamage(param1:Number) : void
      {
         m_localObject.game.options.VS_StartDamage = param1;
         if(m_localObject.game.options.VS_StartDamage > 999)
         {
            m_localObject.game.options.VS_StartDamage = 0;
         }
         else if(m_localObject.game.options.VS_StartDamage < 0)
         {
            m_localObject.game.options.VS_StartDamage = 999;
         }
      }
      
      public static function setStartStamina(param1:Number) : void
      {
         m_localObject.game.options.VS_StartStamina = param1;
         if(m_localObject.game.options.VS_StartStamina > 999)
         {
            m_localObject.game.options.VS_StartStamina = 1;
         }
         else if(m_localObject.game.options.VS_StartStamina < 1)
         {
            m_localObject.game.options.VS_StartStamina = 999;
         }
      }
      
      public static function toggleUsingTime() : void
      {
         m_localObject.game.options.VS_UsingTime = !m_localObject.game.options.VS_UsingTime;
         if(!m_localObject.game.options.VS_UsingLives && !m_localObject.game.options.VS_UsingTime)
         {
            m_localObject.game.options.VS_UsingLives = true;
         }
      }
      
      public static function toggleUsingLives() : void
      {
         m_localObject.game.options.VS_UsingLives = !m_localObject.game.options.VS_UsingLives;
         if(!m_localObject.game.options.VS_UsingTime && !m_localObject.game.options.VS_UsingLives)
         {
            m_localObject.game.options.VS_UsingTime = true;
         }
      }
      
      public static function toggleUsingStamina() : void
      {
         m_localObject.game.options.VS_UsingStamina = !SaveData.UsingStamina;
      }
      
      public static function toggleShowPlayerID() : void
      {
         m_localObject.game.options.VS_DisplayPlayer = !m_localObject.game.options.VS_DisplayPlayer;
      }
      
      public static function toggleHazards() : void
      {
         m_localObject.game.options.hazards = !m_localObject.game.options.hazards;
      }
      
      public static function toggleTeamDamage() : void
      {
         m_localObject.game.options.teamDamage = !m_localObject.game.options.teamDamage;
      }
      
      public static function exportSaveData(param1:DataSettings = null) : void
      {
         var str:String;
         var bArr:ByteArray;
         var saveFile:File = null;
         var tempBArr:ByteArray = null;
         var fileReader:FileStream = null;
         var data:Object = null;
         var dataSettings:DataSettings = param1;
         var settings:DataSettings = dataSettings ? dataSettings : new DataSettings();
         if(dataSettings.saveFileVersion)
         {
            saveFile = File.applicationStorageDirectory.resolvePath(dataSettings.saveFileVersion);
            if(!saveFile.exists)
            {
               return;
            }
            try
            {
               tempBArr = new ByteArray();
               fileReader = new FileStream();
               fileReader.open(saveFile,FileMode.READ);
               fileReader.readBytes(tempBArr);
               fileReader.close();
               tempBArr.uncompress();
               try
               {
                  data = JSON.parse(Base64.decode(tempBArr.readUTFBytes(tempBArr.length)));
               }
               catch(e:*)
               {
                  tempBArr.position = 0;
                  data = JSON.parse(Base64.decode(tempBArr.readUTF()));
               }
            }
            catch(e:*)
            {
               return;
            }
         }
         else
         {
            data = Utils.cloneObject(m_localObject);
         }
         if(!settings.records)
         {
            delete data.game.records;
         }
         if(!settings.options)
         {
            delete data.game.options;
            delete data.game.quality;
         }
         if(!settings.unlocks)
         {
            delete data.game.unlocks;
         }
         if(!settings.controls)
         {
            delete data.game.gamepads;
            delete data.game.portInputs;
            delete data.game.controlSettings;
         }
         str = "";
         str = JSON.stringify(data);
         bArr = new ByteArray();
         bArr.writeUTFBytes(str);
         bArr.compress();
         Utils.saveFile(bArr,"New SSF2 Save.ssfsav");
      }
      
      public static function importSaveData(param1:String, param2:DataSettings = null) : Boolean
      {
         var data:Object = null;
         var playerNumSplit:Array = null;
         var pid:int = 0;
         var dataStr:String = param1;
         var dataSettings:DataSettings = param2;
         var k:* = undefined;
         var settings:DataSettings = dataSettings ? dataSettings : new DataSettings();
         var success:Boolean = true;
         try
         {
            data = JSON.parse(dataStr);
            if(!data.game || !data.game.migration)
            {
               return false;
            }
            data.game = SaveDataMigrations.migrate(data.game);
         }
         catch(e:*)
         {
            return false;
         }
         if(settings.records)
         {
            if(data.game.records)
            {
               m_localObject.game.records = data.game.records;
               trace("Imported records: " + JSON.stringify(data.game.records));
            }
         }
         if(settings.options)
         {
            if(data.game.options)
            {
               m_localObject.game.options = data.game.options;
               trace("Imported options: " + JSON.stringify(data.game.options));
            }
            if(data.game.quality)
            {
               m_localObject.game.quality = data.game.quality;
               trace("Imported quality settings: " + JSON.stringify(data.game.quality));
            }
         }
         if(settings.unlocks)
         {
            if(data.game.unlocks)
            {
               m_localObject.game.unlocks = data.game.unlocks;
               trace("Imported unlocks: " + JSON.stringify(data.game.unlocks));
            }
         }
         if(settings.controls)
         {
            if(data.game.gamepads)
            {
               m_localObject.game.gamepads = data.game.gamepads;
               trace("Imported gamepads: " + JSON.stringify(data.game.gamepads));
            }
            if(data.game.portInputs)
            {
               m_localObject.game.portInputs = data.game.portInputs;
               trace("Imported port inputs: " + JSON.stringify(data.game.portInputs));
            }
            if(data.game.controlSettings)
            {
               m_localObject.game.controlSettings = data.game.controlSettings;
               for(k in m_localObject.game.controlSettings)
               {
                  playerNumSplit = k.split("player");
                  if(playerNumSplit.length === 2 && !isNaN(parseInt(playerNumSplit[1])))
                  {
                     pid = int(parseInt(playerNumSplit[1]));
                     if(pid <= SaveData.Controllers.length)
                     {
                        SaveData.Controllers[pid - 1].setControls(m_localObject.game.controlSettings[k]);
                     }
                  }
               }
               trace("Imported control settings: " + JSON.stringify(data.game.controlSettings));
            }
         }
         SoundQueue.instance.updateVolumeLevel();
         Main.setFullScreenMode(SaveData.Quality.fullscreen_quality);
         Main.Root.stage.quality = SaveData.Quality.display_quality;
         SaveData.saveGame();
         return success;
      }
      
      public static function getItemStatus(param1:String) : Boolean
      {
         var _loc2_:Array = param1.split("|");
         return m_localObject.game.options.VS_Items[_loc2_[0]] !== false;
      }
      
      public static function getStageStatus(param1:String) : Boolean
      {
         return m_localObject.game.options.VS_Stages[param1] !== false;
      }
      
      public static function getNameSettings(param1:String) : Object
      {
         var _loc2_:* = undefined;
         var _loc3_:Object = Names;
         if(!_loc3_)
         {
            return null;
         }
         for(_loc2_ in _loc3_)
         {
            if(_loc3_[_loc2_].name == Base64.encode(param1))
            {
               return _loc3_[_loc2_];
            }
         }
         return null;
      }
      
      public static function createNameSettings(param1:String) : void
      {
         if(getNameSettings(param1))
         {
            return;
         }
         Names[Base64.encode(param1)] = {};
         Names[Base64.encode(param1)].name = Base64.encode(param1);
         Names[Base64.encode(param1)].controls = {};
         Names[Base64.encode(param1)].randCharacters = {};
      }
      
      public static function deleteNameSettings(param1:String) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Object = Names;
         if(!_loc3_)
         {
            return;
         }
         for(_loc2_ in _loc3_)
         {
            if(_loc3_[_loc2_].name == Base64.decode(param1))
            {
               _loc3_[_loc2_] = null;
               delete _loc3_[_loc2_];
               return;
            }
         }
      }
      
      public static function reimportNamedPlayerControls(param1:int, param2:String) : void
      {
         var _loc3_:Object = SaveData.Gamepads[SaveData.Controllers[param1 - 1].GamepadInstance.Name].ports["port" + SaveData.Controllers[param1 - 1].GamepadInstance.Port];
         var _loc4_:Object = SaveData.Gamepads[SaveData.Controllers[param1 - 1].GamepadInstance.Name].names[param2];
         if(!_loc4_ && Boolean(_loc3_))
         {
            _loc4_ = Utils.cloneObject(_loc3_);
            SaveData.Gamepads[SaveData.Controllers[param1 - 1].GamepadInstance.Name].names[param2] = _loc4_;
         }
         else if(!_loc4_)
         {
            _loc4_ = SaveData.Gamepads[SaveData.Controllers[param1 - 1].GamepadInstance.Name].names[param2] = {};
         }
         SaveData.Controllers[param1 - 1]._TAP_JUMP = _loc4_.TAP_JUMP;
         SaveData.Controllers[param1 - 1]._AUTO_DASH = _loc4_.AUTO_DASH;
         SaveData.Controllers[param1 - 1]._DT_DASH = _loc4_.DT_DASH;
         SaveData.Controllers[param1 - 1].GamepadInstance.importControls(_loc4_);
      }
      
      public static function reimportSlottedPlayerControls(param1:int) : void
      {
         var _loc2_:Object = SaveData.Gamepads[SaveData.Controllers[param1 - 1].GamepadInstance.Name].ports["port" + SaveData.Controllers[param1 - 1].GamepadInstance.Port];
         if(SaveData.Controllers[param1 - 1].GamepadInstance)
         {
            SaveData.Controllers[param1 - 1].GamepadInstance.importControls(_loc2_);
         }
         else
         {
            SaveData.Controllers[param1 - 1].setControls(SaveData.ControlSettings["player" + param1]);
         }
         SaveData.Controllers[param1 - 1]._TAP_JUMP = SaveData.ControlSettings["player" + param1].TAP_JUMP;
         SaveData.Controllers[param1 - 1]._AUTO_DASH = SaveData.ControlSettings["player" + param1].AUTO_DASH;
         SaveData.Controllers[param1 - 1]._DT_DASH = SaveData.ControlSettings["player" + param1].DT_DASH;
      }
      
      public static function getTargetTestData(param1:String, param2:String) : Object
      {
         if(param1 == null || param2 == null)
         {
            return null;
         }
         if(param2 === "sheik")
         {
            param2 = "zelda";
         }
         if(Boolean(Records.targets.wins[param1]) && Boolean(Records.targets.wins[param1][param2]))
         {
            return Utils.cloneObject(Records.targets.wins[param1][param2]);
         }
         return null;
      }
      
      public static function setTargetTestData(param1:String, param2:String, param3:Object) : void
      {
         if(param2 === "sheik")
         {
            param2 = "zelda";
         }
         if(!Records.targets.wins[param1])
         {
            Records.targets.wins[param1] = {};
         }
         Records.targets.wins[param1][param2] = param3;
      }
      
      public static function getCrystalSmashData(param1:String, param2:String) : Object
      {
         if(param1 == null || param2 == null)
         {
            return null;
         }
         if(param2 === "sheik")
         {
            param2 = "zelda";
         }
         if(Boolean(Records.crystals.wins[param1]) && Boolean(Records.crystals.wins[param1][param2]))
         {
            return Utils.cloneObject(Records.crystals.wins[param1][param2]);
         }
         return null;
      }
      
      public static function setCrystalSmashData(param1:String, param2:String, param3:Object) : void
      {
         if(param2 === "sheik")
         {
            param2 = "zelda";
         }
         if(!Records.crystals.wins[param1])
         {
            Records.crystals.wins[param1] = {};
         }
         Records.crystals.wins[param1][param2] = param3;
      }
      
      public static function getRaceToTheFinishData(param1:String, param2:String) : Object
      {
         if(param1 == null || param2 == null)
         {
            return null;
         }
         if(param2 === "sheik")
         {
            param2 = "zelda";
         }
         if(Boolean(Records.racetothefinish.wins[param1]) && Boolean(Records.racetothefinish.wins[param1][param2]))
         {
            return Utils.cloneObject(Records.racetothefinish.wins[param1][param2]);
         }
         return null;
      }
      
      public static function setRaceToTheFinishData(param1:String, param2:String, param3:Object) : void
      {
         if(param2 === "sheik")
         {
            param2 = "zelda";
         }
         if(!Records.racetothefinish.wins[param1])
         {
            Records.racetothefinish.wins[param1] = {};
         }
         Records.racetothefinish.wins[param1][param2] = param3;
      }
      
      public static function getClassicModeData(param1:String) : Object
      {
         if(param1 == null)
         {
            return null;
         }
         if(param1 === "sheik")
         {
            param1 = "zelda";
         }
         if(Records.classic.wins[param1])
         {
            return Utils.cloneObject(Records.classic.wins[param1]);
         }
         return null;
      }
      
      public static function setClassicModeData(param1:String, param2:Object) : void
      {
         if(param1 === "sheik")
         {
            param1 = "zelda";
         }
         Records.classic.wins[param1] = param2;
      }
      
      public static function getAllStarModeData(param1:String) : Object
      {
         if(param1 == null)
         {
            return null;
         }
         if(param1 === "sheik")
         {
            param1 = "zelda";
         }
         if(Records.allstar.wins[param1])
         {
            return Utils.cloneObject(Records.allstar.wins[param1]);
         }
         return null;
      }
      
      public static function setAllStarModeData(param1:String, param2:Object) : void
      {
         if(param1 === "sheik")
         {
            param1 = "zelda";
         }
         Records.allstar.wins[param1] = param2;
      }
      
      public static function getMultiManModeData(param1:String, param2:String) : Object
      {
         if(param2 == null)
         {
            return null;
         }
         if(param2 === "sheik")
         {
            param2 = "zelda";
         }
         if(Boolean(Records.multiman.modes[param1]) && Boolean(Records.multiman.modes[param1][param2]))
         {
            return Utils.cloneObject(Records.multiman.modes[param1][param2]);
         }
         return null;
      }
      
      public static function setMultiManModeData(param1:String, param2:String, param3:Object) : void
      {
         if(param2 === "sheik")
         {
            param2 = "zelda";
         }
         if(!Records.multiman.modes[param1])
         {
            Records.multiman.modes[param1] = {};
         }
         Records.multiman.modes[param1][param2] = param3;
      }
      
      public static function getHRCModeData(param1:String, param2:String) : Object
      {
         if(param2 == null || param1 == null)
         {
            return null;
         }
         if(param2 === "sheik")
         {
            param2 = "zelda";
         }
         if(Boolean(Records.hrc.wins[param1]) && Boolean(Records.hrc.wins[param1][param2]))
         {
            return Utils.cloneObject(Records.hrc.wins[param1][param2]);
         }
         return null;
      }
      
      public static function setHRCModeData(param1:String, param2:String, param3:Object) : void
      {
         if(param2 === "sheik")
         {
            param2 = "zelda";
         }
         if(!Records.hrc.wins[param1])
         {
            Records.hrc.wins[param1] = {};
         }
         Records.hrc.wins[param1][param2] = param3;
      }
      
      public static function setP2PSettings(param1:String, param2:int, param3:String, param4:int) : void
      {
         m_localObject.game.options.udpIP = param1;
         m_localObject.game.options.udpPort = param2;
         m_localObject.game.options.tcpIP = param3;
         m_localObject.game.options.tcpPort = param4;
         ProtocolSetting.udpPort = param2;
         ProtocolSetting.udpIP = param1;
         ProtocolSetting.tcpPort = param4;
         ProtocolSetting.tcpIP = param3;
      }
      
      public static function getP2PSettings() : Object
      {
         return {
            "udpIP":m_localObject.game.options.udpIP,
            "udpPort":m_localObject.game.options.udpPort,
            "tcpIP":m_localObject.game.options.tcpIP,
            "tcpPort":m_localObject.game.options.tcpPort
         };
      }
      
      public static function get FinalFormMusic() : Boolean
      {
         return m_localObject.game.options.finalFormMusic as Boolean;
      }
      
      public static function set FinalFormMusic(param1:Boolean) : void
      {
         m_localObject.game.options.finalFormMusic = param1;
      }
      
      public static function get ControlSettings() : Object
      {
         return m_localObject.game.controlSettings;
      }
      
      public static function set ControlSettings(param1:Object) : void
      {
         m_localObject.game.controlSettings = param1;
      }
      
      public static function get Hazards() : Boolean
      {
         return m_localObject.game.options.hazards as Boolean;
      }
      
      public static function set Hazards(param1:Boolean) : void
      {
         m_localObject.game.options.hazards = param1;
      }
      
      public static function get ReplayAutoSave() : Boolean
      {
         return m_localObject.game.options.replayAutoSave as Boolean;
      }
      
      public static function set ReplayAutoSave(param1:Boolean) : void
      {
         m_localObject.game.options.replayAutoSave = param1;
      }
      
      public static function get TeamDamage() : Boolean
      {
         return m_localObject.game.options.teamDamage as Boolean;
      }
      
      public static function set TeamDamage(param1:Boolean) : void
      {
         m_localObject.game.options.teamDamage = param1;
      }
      
      public static function get FinalSmashMeter() : Boolean
      {
         return m_localObject.game.options.VS_FinalSmashMeter as Boolean;
      }
      
      public static function set FinalSmashMeter(param1:Boolean) : void
      {
         m_localObject.game.options.VS_FinalSmashMeter = param1;
      }
      
      public static function get ScoreDisplay() : Boolean
      {
         return m_localObject.game.options.VS_ScoreDisplay as Boolean;
      }
      
      public static function set ScoreDisplay(param1:Boolean) : void
      {
         m_localObject.game.options.VS_ScoreDisplay = param1;
      }
      
      public static function get HudDisplay() : Boolean
      {
         return m_localObject.game.options.VS_HudDisplay as Boolean;
      }
      
      public static function set HudDisplay(param1:Boolean) : void
      {
         m_localObject.game.options.VS_HudDisplay = param1;
      }
      
      public static function get PauseEnabled() : Boolean
      {
         return m_localObject.game.options.VS_PauseEnabled as Boolean;
      }
      
      public static function set PauseEnabled(param1:Boolean) : void
      {
         m_localObject.game.options.VS_PauseEnabled = param1;
      }
      
      public static function get SEVolumeLevel() : Number
      {
         return m_localObject.game.options.SEvolumeLevel as Number;
      }
      
      public static function set SEVolumeLevel(param1:Number) : void
      {
         m_localObject.game.options.SEvolumeLevel = param1;
      }
      
      public static function get VAVolumeLevel() : Number
      {
         return m_localObject.game.options.VAvolumeLevel as Number;
      }
      
      public static function set VAVolumeLevel(param1:Number) : void
      {
         m_localObject.game.options.VAvolumeLevel = param1;
      }
      
      public static function get BGVolumeLevel() : Number
      {
         return m_localObject.game.options.BGvolumeLevel as Number;
      }
      
      public static function set BGVolumeLevel(param1:Number) : void
      {
         m_localObject.game.options.BGvolumeLevel = param1;
      }
      
      public static function get PowerCount() : Number
      {
         return m_localObject.game.records.misc.powerCount as Number;
      }
      
      public static function set PowerCount(param1:Number) : void
      {
         m_localObject.game.records.misc.powerCount = param1;
      }
      
      public static function get PowerTime() : Number
      {
         return m_localObject.game.records.misc.powerTime as Number;
      }
      
      public static function set PowerTime(param1:Number) : void
      {
         m_localObject.game.records.misc.powerTime = param1;
      }
      
      public static function get PlayTime() : Number
      {
         return m_localObject.game.records.misc.playTime as Number;
      }
      
      public static function set PlayTime(param1:Number) : void
      {
         m_localObject.game.records.misc.playTime = param1;
      }
      
      public static function get VSPlayTime() : Number
      {
         return m_localObject.game.records.vs.playTime as Number;
      }
      
      public static function set VSPlayTime(param1:Number) : void
      {
         m_localObject.game.records.vs.playTime = param1;
      }
      
      public static function get TimeMatchTotal() : Number
      {
         return m_localObject.game.records.vs.timeMatchTotal as Number;
      }
      
      public static function set TimeMatchTotal(param1:Number) : void
      {
         m_localObject.game.records.vs.timeMatchTotal = param1;
      }
      
      public static function get StockMatchTotal() : Number
      {
         return m_localObject.game.records.vs.stockMatchTotal as Number;
      }
      
      public static function set StockMatchTotal(param1:Number) : void
      {
         m_localObject.game.records.vs.stockMatchTotal = param1;
      }
      
      public static function get VSCPULevel1() : Number
      {
         return m_localObject.game.options.VS_CPULevel1 as Number;
      }
      
      public static function get VSCPULevel2() : Number
      {
         return m_localObject.game.options.VS_CPULevel2 as Number;
      }
      
      public static function get VSCPULevel3() : Number
      {
         return m_localObject.game.options.VS_CPULevel3 as Number;
      }
      
      public static function get VSCPULevel4() : Number
      {
         return m_localObject.game.options.VS_CPULevel4 as Number;
      }
      
      public static function set VSCPULevel1(param1:Number) : void
      {
         m_localObject.game.options.VS_CPULevel1 = param1;
      }
      
      public static function set VSCPULevel2(param1:Number) : void
      {
         m_localObject.game.options.VS_CPULevel2 = param1;
      }
      
      public static function set VSCPULevel3(param1:Number) : void
      {
         m_localObject.game.options.VS_CPULevel3 = param1;
      }
      
      public static function set VSCPULevel4(param1:Number) : void
      {
         m_localObject.game.options.VS_CPULevel4 = param1;
      }
      
      public static function get MatchResets() : Number
      {
         return m_localObject.game.records.misc.matchResets as Number;
      }
      
      public static function set MatchResets(param1:Number) : void
      {
         m_localObject.game.records.misc.matchResets = param1;
      }
      
      public static function get RememberMe() : String
      {
         return m_localObject.game.options.rememberMe ? m_localObject.game.options.rememberMe as String : null;
      }
      
      public static function set RememberMe(param1:String) : void
      {
         m_localObject.game.options.rememberMe = param1;
      }
      
      public static function get Quality() : Object
      {
         return m_localObject.game.quality;
      }
      
      public static function get Names() : Object
      {
         return m_localObject.game.options.names as Object;
      }
      
      public static function get AirDodge() : String
      {
         return m_localObject.game.options.airDodge as String;
      }
      
      public static function set AirDodge(param1:String) : void
      {
         m_localObject.game.options.airDodge = param1;
      }
      
      public static function get Records() : Object
      {
         return m_localObject.game.records;
      }
      
      public static function get Unlocks() : Object
      {
         return m_localObject.game.unlocks as Object;
      }
      
      public static function get Gamepads() : Object
      {
         return m_localObject.game.gamepads as Object;
      }
      
      public static function get PortInputs() : Object
      {
         return m_localObject.game.portInputs as Object;
      }
      
      public static function getGamepadInputData(param1:String, param2:int, param3:String, param4:String) : Object
      {
         SaveData.Gamepads[param1] = SaveData.Gamepads[param1] || {
            "names":{},
            "ports":{}
         };
         SaveData.Gamepads[param1][param2 > 0 ? "ports" : "names"][param3] = SaveData.Gamepads[param1][param2 > 0 ? "ports" : "names"][param3] || {};
         SaveData.Gamepads[param1][param2 > 0 ? "ports" : "names"][param3][param4] = SaveData.Gamepads[param1][param2 > 0 ? "ports" : "names"][param3][param4] || {
            "inputs":[],
            "inputsInverse":[],
            "deadZone":Gamepad.DEADZONE_DEFAULT,
            "dashZone":Gamepad.DASHZONE_DEFAULT
         };
         return SaveData.Gamepads[param1][param2 > 0 ? "ports" : "names"][param3][param4];
      }
      
      public static function get Once() : Object
      {
         return m_localObject.game.once;
      }
      
      public static function getRumbleEnabled(param1:int = 1) : Boolean
      {
         var _loc2_:Boolean = false;
         if(rumbleEnabled == null)
         {
            rumbleEnabled = {
               "player1":true,
               "player2":true,
               "player3":true,
               "player4":true
            };
            if(Boolean(m_localObject) && Boolean(m_localObject.game) && Boolean(m_localObject.game.options) && m_localObject.game.options.rumbleEnabled !== undefined)
            {
               if(typeof m_localObject.game.options.rumbleEnabled === "boolean")
               {
                  _loc2_ = Boolean(m_localObject.game.options.rumbleEnabled);
                  rumbleEnabled = {
                     "player1":_loc2_,
                     "player2":_loc2_,
                     "player3":_loc2_,
                     "player4":_loc2_
                  };
               }
               else if(typeof m_localObject.game.options.rumbleEnabled === "object")
               {
                  rumbleEnabled = m_localObject.game.options.rumbleEnabled;
               }
            }
         }
         return rumbleEnabled["player" + param1] !== undefined ? Boolean(rumbleEnabled["player" + param1]) : true;
      }
      
      public static function setRumbleEnabled(param1:Boolean, param2:int = 1) : void
      {
         if(rumbleEnabled == null)
         {
            getRumbleEnabled(param2);
         }
         rumbleEnabled["player" + param2] = param1;
         if(Boolean(m_localObject) && Boolean(m_localObject.game) && Boolean(m_localObject.game.options))
         {
            m_localObject.game.options.rumbleEnabled = rumbleEnabled;
         }
         var _loc3_:Boolean = false;
         var _loc4_:int = 1;
         while(_loc4_ <= 4)
         {
            if(getRumbleEnabled(_loc4_))
            {
               _loc3_ = true;
               break;
            }
            _loc4_++;
         }
         Gamepad.setGlobalRumbleEnabled(_loc3_);
      }
   }
}


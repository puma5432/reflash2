package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.util.*;
   import fl.controls.CheckBox;
   import fl.controls.ComboBox;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.ByteArray;
   
   public class DataMenu extends Menu
   {
      
      private var m_optionsCheckbox:CheckBox;
      
      private var m_controlsCheckbox:CheckBox;
      
      private var m_recordsCheckbox:CheckBox;
      
      private var m_unlocksCheckbox:CheckBox;
      
      private var m_exportOldSavesDropdown:ComboBox;
      
      private var m_autoSaveReplaysCheckbox:CheckBox;
      
      private var selectHand:SelectHand;
      
      public function DataMenu()
      {
         var _loc2_:int = 0;
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_data");
         m_backgroundID = "space";
         m_container.addChild(m_subMenu);
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         this.m_optionsCheckbox = m_subMenu.options;
         this.m_controlsCheckbox = m_subMenu.controls;
         this.m_recordsCheckbox = m_subMenu.records;
         this.m_unlocksCheckbox = m_subMenu.unlocks;
         this.m_autoSaveReplaysCheckbox = m_subMenu.replayAutoSave;
         this.m_exportOldSavesDropdown = m_subMenu.prevSaveFilesList;
         var _loc1_:Vector.<String> = SaveData.getExistingOldSaveFileNames();
         while(_loc2_ < _loc1_.length)
         {
            this.m_exportOldSavesDropdown.addItem({
               "label":SaveData.saveDataFileToFriendlyName(_loc1_[_loc2_]),
               "value":_loc1_[_loc2_]
            });
            _loc2_++;
         }
         if(_loc1_.length > 0)
         {
            this.m_exportOldSavesDropdown.selectedItem = this.m_exportOldSavesDropdown.getItemAt(0);
         }
         this.m_optionsCheckbox.selected = true;
         this.m_controlsCheckbox.selected = true;
         this.m_recordsCheckbox.selected = true;
         this.m_unlocksCheckbox.selected = true;
         this.m_autoSaveReplaysCheckbox.selected = true;
         var _loc3_:Vector.<HandButton> = new Vector.<HandButton>();
         _loc3_.push(new DataButton(m_subMenu.exportdata_btn));
         _loc3_.push(new DataButton(m_subMenu.importdata_btn));
         _loc3_.push(new DataButton(m_subMenu.cleardata_btn));
         _loc3_.push(new DataButton(m_subMenu.dataDialog.back_btn));
         _loc3_.push(new DataButton(m_subMenu.dataDialog.cleardata_btn));
         _loc3_.push(new DataButton(m_subMenu.exportOldSaves_btn));
         this.selectHand = new SelectHand(m_subMenu,_loc3_,this.back_CLICK_mainfromdata);
         this.selectHand.addClickEventClipCheckBounds(this.m_optionsCheckbox);
         this.selectHand.addClickEventClipCheckBounds(this.m_controlsCheckbox);
         this.selectHand.addClickEventClipCheckBounds(this.m_recordsCheckbox);
         this.selectHand.addClickEventClipCheckBounds(this.m_unlocksCheckbox);
         this.selectHand.addClickEventClipCheckBounds(this.m_autoSaveReplaysCheckbox);
         this.selectHand.addClickEventClipHitTest(m_subMenu.bg_top.home_btn);
         this.selectHand.addClickEventClipHitTest(m_subMenu.bg_top.back_btn);
         this.selectHand.setAutoKillEvents(false);
      }
      
      override public function makeEvents() : void
      {
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         resetAllButtons();
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK_mainfromdata);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.MOUSE_OVER,this.back_ROLL_OVER_mainfromdata);
         m_subMenu.exportdata_btn.addEventListener(MouseEvent.CLICK,this.exportdata_CLICK);
         m_subMenu.exportdata_btn.addEventListener(MouseEvent.MOUSE_OVER,this.exportdata_ROLL_OVER);
         m_subMenu.exportdata_btn.addEventListener(MouseEvent.MOUSE_OUT,this.exportdata_ROLL_OUT);
         m_subMenu.importdata_btn.addEventListener(MouseEvent.CLICK,this.importdata_CLICK);
         m_subMenu.importdata_btn.addEventListener(MouseEvent.MOUSE_OVER,this.importdata_ROLL_OVER);
         m_subMenu.importdata_btn.addEventListener(MouseEvent.MOUSE_OUT,this.importdata_ROLL_OUT);
         m_subMenu.cleardata_btn.addEventListener(MouseEvent.CLICK,this.cleardata_CLICK);
         m_subMenu.cleardata_btn.addEventListener(MouseEvent.MOUSE_OVER,this.cleardata_ROLL_OVER);
         m_subMenu.cleardata_btn.addEventListener(MouseEvent.MOUSE_OUT,this.cleardata_ROLL_OUT);
         m_subMenu.exportOldSaves_btn.addEventListener(MouseEvent.CLICK,this.exportOldSaves_CLICK);
         m_subMenu.exportOldSaves_btn.addEventListener(MouseEvent.MOUSE_OVER,this.exportOldSaves_ROLL_OVER);
         m_subMenu.exportOldSaves_btn.addEventListener(MouseEvent.MOUSE_OUT,this.exportOldSaves_ROLL_OUT);
         m_subMenu.bg_top.home_btn.addEventListener(MouseEvent.CLICK,this.home_CLICK);
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,manageMenuMappings);
         this.m_autoSaveReplaysCheckbox.selected = SaveData.ReplayAutoSave;
         this.m_autoSaveReplaysCheckbox.addEventListener(MouseEvent.CLICK,this.autoSaveReplays_CLICK);
         this.m_autoSaveReplaysCheckbox.addEventListener(MouseEvent.MOUSE_OVER,this.autoSaveReplays_ROLL_OVER);
         this.m_autoSaveReplaysCheckbox.addEventListener(MouseEvent.MOUSE_OUT,this.autoSaveReplays_ROLL_OUT);
         this.selectHand.makeEvents();
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         this.selectHand.killEvents();
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK_mainfromdata);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.back_ROLL_OVER_mainfromdata);
         m_subMenu.exportdata_btn.removeEventListener(MouseEvent.CLICK,this.exportdata_CLICK);
         m_subMenu.exportdata_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.exportdata_ROLL_OVER);
         m_subMenu.exportdata_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.exportdata_ROLL_OUT);
         m_subMenu.importdata_btn.removeEventListener(MouseEvent.CLICK,this.importdata_CLICK);
         m_subMenu.importdata_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.importdata_ROLL_OVER);
         m_subMenu.importdata_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.importdata_ROLL_OUT);
         m_subMenu.cleardata_btn.removeEventListener(MouseEvent.CLICK,this.cleardata_CLICK);
         m_subMenu.cleardata_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.cleardata_ROLL_OVER);
         m_subMenu.cleardata_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.cleardata_ROLL_OUT);
         m_subMenu.exportOldSaves_btn.removeEventListener(MouseEvent.CLICK,this.exportOldSaves_CLICK);
         m_subMenu.exportOldSaves_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.exportOldSaves_ROLL_OVER);
         m_subMenu.exportOldSaves_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.exportOldSaves_ROLL_OUT);
         m_subMenu.bg_top.home_btn.removeEventListener(MouseEvent.CLICK,this.home_CLICK);
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,manageMenuMappings);
         this.m_autoSaveReplaysCheckbox.removeEventListener(MouseEvent.CLICK,this.autoSaveReplays_CLICK);
         this.m_autoSaveReplaysCheckbox.removeEventListener(MouseEvent.MOUSE_OVER,this.autoSaveReplays_ROLL_OVER);
         this.m_autoSaveReplaysCheckbox.removeEventListener(MouseEvent.MOUSE_OUT,this.autoSaveReplays_ROLL_OUT);
      }
      
      private function back_CLICK_mainfromdata(param1:MouseEvent) : void
      {
         if(MovieClip(m_subMenu.dataDialog).currentLabel != "wait")
         {
            if(MovieClip(m_subMenu.dataDialog).currentLabel == "clear")
            {
               this.back_CLICK_data(null);
            }
            else if(MovieClip(m_subMenu.dataDialog).currentLabel == "import")
            {
               this.back_CLICK_data(null);
            }
            m_subMenu.dataDialog.gotoAndStop("wait");
         }
         else
         {
            removeSelf();
            SoundQueue.instance.playSoundEffect("menu_back");
            MenuController.mainMenu.show();
         }
      }
      
      private function back_ROLL_OVER_mainfromdata(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function exportdata_ROLL_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Export game data and settings to a file.";
      }
      
      private function exportdata_ROLL_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function exportdata_CLICK(param1:MouseEvent) : void
      {
         if(MovieClip(m_subMenu.dataDialog).currentLabel == "wait")
         {
            SoundQueue.instance.playSoundEffect("menu_select");
            m_subMenu.desc_txt.text = "";
            SaveData.exportSaveData(new DataSettings(this.m_controlsCheckbox.selected,this.m_optionsCheckbox.selected,this.m_recordsCheckbox.selected,this.m_unlocksCheckbox.selected));
         }
      }
      
      private function importdata_ROLL_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Import game data and settings from a file.";
      }
      
      private function importdata_ROLL_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function importdata_CLICK(param1:MouseEvent) : void
      {
         if(MovieClip(m_subMenu.dataDialog).currentLabel == "wait")
         {
            SoundQueue.instance.playSoundEffect("menu_select");
            m_subMenu.desc_txt.text = "";
            Utils.openFile();
            m_subMenu.dataDialog.gotoAndStop("import");
            m_subMenu.dataDialog.useHandCursor = false;
            m_subMenu.dataDialog.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK_data);
            m_subMenu.dataDialog.back_btn.addEventListener(MouseEvent.MOUSE_OVER,this.back_ROLL_OVER_data);
            m_subMenu.dataDialog.addEventListener(Event.ENTER_FRAME,this.waitForImport);
            m_subMenu.dataDialog.back_btn.visible = false;
         }
      }
      
      private function back_CLICK_data(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_back");
         m_subMenu.dataDialog.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK_data);
         m_subMenu.dataDialog.back_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.back_ROLL_OVER_data);
         m_subMenu.dataDialog.removeEventListener(Event.ENTER_FRAME,this.waitForImport);
         m_subMenu.dataDialog.gotoAndStop("wait");
      }
      
      private function back_ROLL_OVER_data(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function waitForImport(param1:Event) : void
      {
         var dataStr:String = null;
         var bArr:ByteArray = null;
         var e:Event = param1;
         if(Utils.finishedLoading)
         {
            m_subMenu.dataDialog.removeEventListener(Event.ENTER_FRAME,this.waitForImport);
            m_subMenu.dataDialog.back_btn.visible = true;
            if(Utils.openSuccess)
            {
               SaveData.saveGame();
               dataStr = null;
               bArr = Utils.fileRef.data;
               trace("Decompressing...");
               bArr.uncompress();
               trace("Decrypting...");
               try
               {
                  dataStr = bArr.readUTFBytes(bArr.length);
                  JSON.parse(dataStr);
               }
               catch(e:*)
               {
                  bArr.position = 0;
                  dataStr = bArr.readUTF();
                  JSON.parse(dataStr);
               }
               trace("Original String: " + dataStr);
               if(!SaveData.importSaveData(dataStr,new DataSettings(this.m_controlsCheckbox.selected,this.m_optionsCheckbox.selected,this.m_recordsCheckbox.selected,this.m_unlocksCheckbox.selected)))
               {
                  SaveData.loadGame();
                  m_subMenu.dataDialog.results.text = "There was an error importing the game data.";
               }
               else
               {
                  m_subMenu.dataDialog.results.text = "Game data loaded successfully.";
                  SoundQueue.instance.updateVolumeLevel();
               }
            }
            else if(Utils.cancelled)
            {
               m_subMenu.dataDialog.results.text = "Import Cancelled.";
            }
            else
            {
               m_subMenu.dataDialog.results.text = "There was an error loading the game data.";
            }
         }
      }
      
      private function cleardata_ROLL_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Erase all game data and settings.";
      }
      
      private function cleardata_ROLL_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function cleardata_CLICK(param1:MouseEvent) : void
      {
         if(MovieClip(m_subMenu.dataDialog).currentLabel == "wait")
         {
            SoundQueue.instance.playSoundEffect("menu_select");
            m_subMenu.desc_txt.text = "";
            m_subMenu.dataDialog.gotoAndStop("clear");
            m_subMenu.dataDialog.blocker.useHandCursor = false;
            m_subMenu.dataDialog.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK_cleardata);
            m_subMenu.dataDialog.back_btn.addEventListener(MouseEvent.MOUSE_OVER,this.back_ROLL_OVER_cleardata);
            m_subMenu.dataDialog.cleardata_btn.addEventListener(MouseEvent.CLICK,this.clear_CLICK);
            m_subMenu.dataDialog.cleardata_btn.addEventListener(MouseEvent.MOUSE_OVER,this.clear_ROLL_OVER);
            m_subMenu.dataDialog.back_btn.visible = true;
         }
      }
      
      private function autoSaveReplays_ROLL_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Automatically save replays to your User folder (Under SSF2Replays/[VersionNumber])";
      }
      
      private function autoSaveReplays_ROLL_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function autoSaveReplays_CLICK(param1:MouseEvent) : void
      {
         SaveData.ReplayAutoSave = !SaveData.ReplayAutoSave;
         this.m_autoSaveReplaysCheckbox.selected = SaveData.ReplayAutoSave;
         SaveData.saveGame();
      }
      
      private function exportOldSaves_ROLL_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Export old save files found on your machine (which you can re-import to restore/migrate old data).";
      }
      
      private function exportOldSaves_ROLL_OUT(param1:MouseEvent) : void
      {
         m_subMenu.desc_txt.text = "";
      }
      
      private function exportOldSaves_CLICK(param1:MouseEvent) : void
      {
         var _loc2_:DataSettings = null;
         if(MovieClip(m_subMenu.dataDialog).currentLabel == "wait" && Boolean(this.m_exportOldSavesDropdown.selectedItem))
         {
            SoundQueue.instance.playSoundEffect("menu_select");
            m_subMenu.desc_txt.text = "";
            _loc2_ = new DataSettings(this.m_controlsCheckbox.selected,this.m_optionsCheckbox.selected,this.m_recordsCheckbox.selected,this.m_unlocksCheckbox.selected);
            _loc2_.saveFileVersion = this.m_exportOldSavesDropdown.selectedItem.value;
            SaveData.exportSaveData(_loc2_);
         }
      }
      
      private function back_CLICK_cleardata(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_back");
         m_subMenu.dataDialog.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK_cleardata);
         m_subMenu.dataDialog.back_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.back_ROLL_OVER_cleardata);
         m_subMenu.dataDialog.cleardata_btn.removeEventListener(MouseEvent.CLICK,this.clear_CLICK);
         m_subMenu.dataDialog.cleardata_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.clear_ROLL_OVER);
         m_subMenu.dataDialog.gotoAndStop("wait");
      }
      
      private function back_ROLL_OVER_cleardata(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function clear_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.stopMusic();
         SoundQueue.instance.playSoundEffect("menu_back");
         m_subMenu.dataDialog.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK_cleardata);
         m_subMenu.dataDialog.back_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.back_ROLL_OVER_cleardata);
         m_subMenu.dataDialog.cleardata_btn.removeEventListener(MouseEvent.CLICK,this.clear_CLICK);
         m_subMenu.dataDialog.cleardata_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.clear_ROLL_OVER);
         m_subMenu.dataDialog.gotoAndStop("wait");
         SaveData.eraseGame();
         removeSelf();
         MenuController.disposeAllMenus(true);
         MenuController.titleMenu.show();
      }
      
      private function clear_ROLL_OVER(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function home_CLICK(param1:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_back");
         SoundQueue.instance.stopMusic();
         MenuController.disposeAllMenus(true);
         MenuController.titleMenu.show();
      }
   }
}


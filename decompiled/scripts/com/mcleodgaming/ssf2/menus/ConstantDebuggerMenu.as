package com.mcleodgaming.ssf2.menus
{
   import com.adobe.utils.*;
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.*;
   
   public class ConstantDebuggerMenu extends Menu
   {
      
      private var hidden:Boolean;
      
      public function ConstantDebuggerMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_constantdebugger");
         this.hidden = true;
         m_container.addChild(m_subMenu);
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         m_subMenu.visible = Boolean(Main.DEBUG) && !Main.LAZYDEBUG;
         m_subMenu.stuff.visible = false;
         m_subMenu.cpubox.visible = false;
         m_subMenu.tabChildren = false;
         m_subMenu.tabEnabled = false;
      }
      
      override public function makeEvents() : void
      {
         if(m_showCount == 0)
         {
            findSubMenuButtons();
         }
         super.makeEvents();
         m_subMenu.showhide_btn.addEventListener(MouseEvent.CLICK,this.showhide_btn_CLICK);
         m_subMenu.cpubox.addEventListener(Event.ENTER_FRAME,this.cpubox_ENTER_FRAME);
         m_subMenu.stuff.set_btn.addEventListener(MouseEvent.CLICK,this.set_btn_CLICK);
         m_subMenu.stuff.hit_btn.addEventListener(MouseEvent.CLICK,this.hit_btn_CLICK);
         m_subMenu.stuff.setvscale_btn.addEventListener(MouseEvent.CLICK,this.setvscale_btn_CLICK);
         m_subMenu.stuff.ghitlag_btn.addEventListener(MouseEvent.CLICK,this.ghitlag_btn_CLICK);
         m_subMenu.stuff.attack.addEventListener(Event.CHANGE,this.attack_CHANGE);
         this.setvscale_btn_CLICK(null);
         this.attack_CHANGE(null);
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.showhide_btn.removeEventListener(MouseEvent.CLICK,this.showhide_btn_CLICK);
         m_subMenu.cpubox.removeEventListener(Event.ENTER_FRAME,this.cpubox_ENTER_FRAME);
         m_subMenu.stuff.set_btn.removeEventListener(MouseEvent.CLICK,this.set_btn_CLICK);
         m_subMenu.stuff.hit_btn.removeEventListener(MouseEvent.CLICK,this.hit_btn_CLICK);
         m_subMenu.stuff.ghitlag_btn.removeEventListener(MouseEvent.CLICK,this.ghitlag_btn_CLICK);
         m_subMenu.stuff.setvscale_btn.removeEventListener(MouseEvent.CLICK,this.setvscale_btn_CLICK);
         m_subMenu.stuff.attack.removeEventListener(Event.CHANGE,this.attack_CHANGE);
      }
      
      public function reset() : void
      {
         m_subMenu.tabChildren = false;
         m_subMenu.tabEnabled = false;
         m_subMenu.cpubox.visible = false;
      }
      
      public function updateVisibility() : void
      {
         m_subMenu.visible = Boolean(Main.DEBUG) && !Main.LAZYDEBUG;
      }
      
      private function initiateConstantDebugger(param1:MouseEvent) : void
      {
         m_subMenu.stuff.visible = !this.hidden;
      }
      
      private function showhide_btn_CLICK(param1:MouseEvent) : void
      {
         this.hidden = !this.hidden;
         m_subMenu.stuff.visible = !this.hidden;
      }
      
      private function cpubox_ENTER_FRAME(param1:Event) : void
      {
         if(GameController.stageData != null && GameController.stageData.getPlayerByID(2) != null && m_subMenu.cpubox != null)
         {
            m_subMenu.cpubox.text = GameController.stageData.getPlayerByID(2).getAI() != null ? GameController.stageData.getPlayerByID(2).getAI().ActionText : "No AI detected";
         }
      }
      
      private function ghitlag_btn_CLICK(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         m_subMenu.stuff.ghitlag.text = StringUtil.trim(m_subMenu.stuff.ghitlag.text);
         if(GameController.stageData != null && (m_subMenu.stuff.ghitlag.text == "" || !isNaN(parseFloat(m_subMenu.stuff.ghitlag.text))))
         {
            _loc2_ = 0;
            while(_loc2_ < GameController.stageData.Players.length)
            {
               if(GameController.stageData.Players[_loc2_])
               {
                  GameController.stageData.Players[_loc2_].HitLagHack = m_subMenu.stuff.ghitlag.text == "" ? Number.MAX_VALUE : Number(parseFloat(m_subMenu.stuff.ghitlag.text));
               }
               _loc2_++;
            }
         }
         Main.fixFocus();
      }
      
      private function attack_CHANGE(param1:Event) : void
      {
         if(GameController.stageData.getPlayerByID(1) != null && m_subMenu.stuff.attack.text != "" && Boolean(GameController.stageData.getPlayerByID(1).AttackDataObj.getAttack(m_subMenu.stuff.attack.text)))
         {
            m_subMenu.stuff.direct.text = GameController.stageData.getPlayerByID(1).getAttack(m_subMenu.stuff.attack.text,1);
            m_subMenu.stuff.kbconst.text = GameController.stageData.getPlayerByID(1).getAttack(m_subMenu.stuff.attack.text,2);
            m_subMenu.stuff.power.text = GameController.stageData.getPlayerByID(1).getAttack(m_subMenu.stuff.attack.text,3);
            m_subMenu.stuff.hitstun.text = GameController.stageData.getPlayerByID(1).getAttack(m_subMenu.stuff.attack.text,4);
            m_subMenu.stuff.selfhitstun.text = GameController.stageData.getPlayerByID(1).getAttack(m_subMenu.stuff.attack.text,5);
            m_subMenu.stuff.hitlag.text = GameController.stageData.getPlayerByID(1).getAttack(m_subMenu.stuff.attack.text,6);
            m_subMenu.stuff.priority.text = GameController.stageData.getPlayerByID(1).getAttack(m_subMenu.stuff.attack.text,7);
            m_subMenu.stuff.damage.text = GameController.stageData.getPlayerByID(1).getAttack(m_subMenu.stuff.attack.text,8);
            m_subMenu.stuff.weightKB.text = GameController.stageData.getPlayerByID(1).getAttack(m_subMenu.stuff.attack.text,9);
         }
         else
         {
            m_subMenu.stuff.direct.text = "";
            m_subMenu.stuff.kbconst.text = "";
            m_subMenu.stuff.power.text = "";
            m_subMenu.stuff.hitstun.text = "";
            m_subMenu.stuff.selfhitstun.text = "";
            m_subMenu.stuff.hitlag.text = "";
            m_subMenu.stuff.priority.text = "";
            m_subMenu.stuff.damage.text = "";
            m_subMenu.stuff.weightKB.text = "";
         }
         m_subMenu.stuff.blarg.visible = false;
      }
      
      private function setvscale_btn_CLICK(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         m_subMenu.stuff.vscale.text = StringUtil.trim(m_subMenu.stuff.vscale.text);
         if(GameController.stageData != null && m_subMenu.stuff.vscale != "" && !isNaN(parseFloat(m_subMenu.stuff.vscale.text)))
         {
            Utils.VELOCITY_SCALE = parseFloat(m_subMenu.stuff.vscale.text);
         }
         else
         {
            m_subMenu.stuff.vscale.text = "" + Utils.VELOCITY_SCALE;
         }
         Main.fixFocus();
      }
      
      private function set_btn_CLICK(param1:MouseEvent) : void
      {
         if(GameController.stageData.getPlayerByID(1) != null && m_subMenu.stuff.attack.text != "" && m_subMenu.stuff.direct.text != "" && m_subMenu.stuff.kbconst.text != "" && m_subMenu.stuff.power.text != "")
         {
            GameController.stageData.getPlayerByID(1).modifyAttack(m_subMenu.stuff.attack.text,1,Number(m_subMenu.stuff.direct.text));
            GameController.stageData.getPlayerByID(1).modifyAttack(m_subMenu.stuff.attack.text,2,Number(m_subMenu.stuff.kbconst.text));
            GameController.stageData.getPlayerByID(1).modifyAttack(m_subMenu.stuff.attack.text,3,Number(m_subMenu.stuff.power.text));
            GameController.stageData.getPlayerByID(1).modifyAttack(m_subMenu.stuff.attack.text,4,Number(m_subMenu.stuff.hitstun.text));
            GameController.stageData.getPlayerByID(1).modifyAttack(m_subMenu.stuff.attack.text,5,Number(m_subMenu.stuff.selfhitstun.text));
            GameController.stageData.getPlayerByID(1).modifyAttack(m_subMenu.stuff.attack.text,6,Number(m_subMenu.stuff.hitlag.text));
            GameController.stageData.getPlayerByID(1).modifyAttack(m_subMenu.stuff.attack.text,7,Number(m_subMenu.stuff.priority.text));
            GameController.stageData.getPlayerByID(1).modifyAttack(m_subMenu.stuff.attack.text,8,Number(m_subMenu.stuff.damage.text));
            GameController.stageData.getPlayerByID(1).modifyAttack(m_subMenu.stuff.attack.text,9,Number(m_subMenu.stuff.weightKB.text));
         }
         Main.fixFocus();
         m_subMenu.stuff.blarg.visible = false;
      }
      
      private function hit_btn_CLICK(param1:MouseEvent) : void
      {
         InteractiveSprite.SHOW_HITBOXES = !InteractiveSprite.SHOW_HITBOXES;
         Main.fixFocus();
      }
   }
}


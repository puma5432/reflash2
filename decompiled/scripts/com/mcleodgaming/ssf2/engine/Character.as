package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.*;
   import com.mcleodgaming.ssf2.api.*;
   import com.mcleodgaming.ssf2.assists.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.enemies.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.input.*;
   import com.mcleodgaming.ssf2.items.*;
   import com.mcleodgaming.ssf2.menus.*;
   import com.mcleodgaming.ssf2.net.*;
   import com.mcleodgaming.ssf2.platforms.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.*;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.*;
   
   public class Character extends InteractiveSprite
   {
      
      public static var HEAVY_KNOCKBACK_THRESHOLD:Number = 2.4 * Utils.VELOCITY_SCALE;
      
      public static var HEAVY_KNOCKBACK_HITLAG_THRESHOLD:Number = 32 / 2;
      
      private static var CROWD_AWE_KNOCKBACK_THRESHOLD:Number = 35;
      
      private const MAX_STOCK_ICONS:Number = 5;
      
      private var m_preFrameInfo:String;
      
      private var m_freezePlayback:Boolean;
      
      private var m_hitLagHack:Number = Infinity;
      
      private var SDI_BASE:Number = 6;
      
      private var MAX_DI_CHANGE:Number = 23;
      
      private var DI_CAP:Number = 17;
      
      private var PAUSE_CAM_MAX_SPEED:Number = 15;
      
      private var PAUSE_CAM_ACCEL:Number = 4;
      
      private var m_characterStats:CharacterData;
      
      private var m_playerSettings:PlayerSetting;
      
      private var m_expansion_id:int;
      
      private var m_transformingSpecial:Boolean;
      
      private var m_transformedSpecial:Boolean;
      
      private var m_transformTime:int;
      
      private var m_transformLimit:int;
      
      private var m_finalSmashMeterCharge:Number;
      
      private var m_finalSmashMeterReady:Boolean;
      
      private var m_finalSmashCutinMC:MovieClip;
      
      private var m_matchResults:MatchResults;
      
      private var m_droughtTimer:int;
      
      private var m_justHit:Boolean;
      
      private var m_justHitTimer:int;
      
      private var m_key:Controller;
      
      private var m_pauseCamXSpeed:Number;
      
      private var m_pauseCamYSpeed:Number;
      
      private var m_starKOTimer:FrameTimer;
      
      private var m_starKOMC:MovieClip;
      
      private var m_screenKO:Boolean;
      
      private var m_starKOHolder:MovieClip;
      
      private var m_screenKOHolder:MovieClip;
      
      private var m_crowdAwe:Boolean;
      
      private var m_originalSizeRatio:Number;
      
      private var m_sizeStatus:int;
      
      private var m_sizeStatusPermanent:Boolean;
      
      private var m_sizeStatusTimer:FrameTimer;
      
      private var m_isMetal:Boolean;
      
      private var m_lives:int;
      
      private var m_lastLivesTextNum:int;
      
      private var m_usingLives:Boolean;
      
      private var m_jumpSpeedMidairDelay:FrameTimer;
      
      private var m_jumpStartup:FrameTimer;
      
      private var m_jumpJustChambered:Boolean;
      
      private var m_jumpSpeedList:Array;
      
      private var m_jumpEffectTimer:FrameTimer;
      
      private var m_preJumpState:uint;
      
      private var m_initialAirDodgeAngle:Number;
      
      private var m_waveLand:Boolean;
      
      private var m_waveDashPenalty:Number;
      
      private var m_airDodgeCount:int;
      
      private var m_skidTimer:int;
      
      private var m_jumpTimer:int;
      
      private var m_shortHop:Boolean;
      
      private var m_jumpJustLetGo:Boolean;
      
      private var m_attackHovering:Boolean;
      
      private var m_canHover:Boolean;
      
      private var m_midAirHoverTime:FrameTimer;
      
      private var m_midAirJumpConstantTime:FrameTimer;
      
      private var m_midAirJumpConstantDelay:FrameTimer;
      
      private var m_rocketSpeed:Number;
      
      private var m_rocketRotation:Boolean;
      
      private var m_rocketDecay:Number;
      
      private var m_rocketAngle:Number;
      
      private var m_smashTimer:int;
      
      private var m_smashTimerUp:int;
      
      private var m_smashTimerSide:int;
      
      private var m_smashTimerDown:int;
      
      private var m_upSpecialTimer:int;
      
      private var m_specialTurnTimer:FrameTimer;
      
      private var m_specialTurnRight:Boolean;
      
      private var m_runningSpeedLevel:Boolean;
      
      private var m_speedTimer:int;
      
      private var m_speedLetGo:Boolean;
      
      private var m_dashReady:Boolean;
      
      private var m_speedFacingForward:Boolean;
      
      private var m_norm_xSpeed:Number;
      
      private var m_max_xSpeed:Number;
      
      private var m_glideAngle:Number;
      
      private var m_glideMaxHeight:Number;
      
      private var m_glideDelay:int;
      
      private var m_glideReady:Boolean;
      
      private var m_flyingRight:Boolean;
      
      private var m_flyingUp:Boolean;
      
      private var m_windBoxHit:Boolean;
      
      private var m_hasArced:Boolean;
      
      private var m_forcedCrash:Boolean;
      
      private var m_tumbledCrash:Boolean;
      
      private var m_jabResets:int;
      
      private var m_jabResetTimer:FrameTimer;
      
      private var m_fallTiltTimer:FrameTimer;
      
      private var m_fallTiltRight:Boolean;
      
      private var m_forceTumbleFall:Boolean;
      
      private var m_hitLag:int;
      
      private var m_hitLagCancelTimer:FrameTimer;
      
      private var m_hitLagCanCancelWithJump:Boolean;
      
      private var m_hitLagCanCancelWithUpB:Boolean;
      
      private var m_hitLagStunTimer:FrameTimer;
      
      private var m_hitLagLandDelay:FrameTimer;
      
      private var m_hitsDealtCounter:int;
      
      private var m_hitsReceivedCounter:int;
      
      private var m_smashDIAmount:Number;
      
      private var m_smashDISelf:Boolean;
      
      private var m_smashDIDirection:Number;
      
      private var m_smashDIDirectionCStick:Number;
      
      private var m_canDI:Boolean;
      
      private var m_techLetGo:Boolean;
      
      private var m_techTimer:FrameTimer;
      
      private var m_techDelay:FrameTimer;
      
      private var m_techReady:Boolean;
      
      private var m_justTechedTimer:FrameTimer;
      
      private var m_canTech:Boolean;
      
      private var m_canWallTech:Boolean;
      
      private var m_canBounce:Boolean;
      
      private var m_hasBounced:Boolean;
      
      private var m_stunTimer:int;
      
      private var m_dizzyTimer:int;
      
      private var m_stunCancelTimer:FrameTimer;
      
      private var m_dizzyShield:Boolean;
      
      private var m_pitfallTimer:int;
      
      private var m_ricochetCount:FrameTimer;
      
      private var m_ricochetTimer:FrameTimer;
      
      private var m_ricochetX:FrameTimer;
      
      private var m_ricochetY:FrameTimer;
      
      private var m_invisibleTimer:FrameTimer;
      
      private var m_invincibleBrightness:Number;
      
      private var m_invincibleUp:Boolean;
      
      private var m_disableHurtFallOff:Boolean;
      
      private var m_jumpCount:int;
      
      private var m_bufferedAttackJump:Boolean;
      
      private var m_jumpSpeedBuffer:Number;
      
      private var m_multiJumpDelay:FrameTimer;
      
      private var m_lastCrouchTimer:int;
      
      private var m_crouchLength:int;
      
      private var m_crouchFrame:int;
      
      private var m_wallJumpCount:int;
      
      private var m_wallStickTime:FrameTimer;
      
      private var m_wallClingDelay:FrameTimer;
      
      private var m_shieldTimer:int;
      
      private var m_shieldType:String;
      
      private var m_shieldPower:Number;
      
      private var m_shield_originalWidth:Number;
      
      private var m_shield_originalHeight:Number;
      
      private var m_shieldDelay:int;
      
      private var m_shieldDelayTimer:FrameTimer;
      
      private var m_shieldStartTimer:int;
      
      private var m_shieldDropLag:FrameTimer;
      
      private var m_previousAttack:String;
      
      private var m_lastHitStun:int;
      
      private var m_attackDelay:int;
      
      private var m_attackIDIncremented:Boolean;
      
      private var m_heldControlsBuffer:Array;
      
      private var m_pressedControlsBuffer:Array;
      
      private var m_heldControls:ControlsObject;
      
      private var m_pressedControls:ControlsObject;
      
      private var m_heldKeyHistory:ControlsObject;
      
      private var m_cStickUse:Boolean;
      
      private var m_c_buffered_down:Boolean;
      
      private var m_c_buffered_left:Boolean;
      
      private var m_c_buffered_right:Boolean;
      
      private var m_tap_jump:Boolean;
      
      private var m_auto_dash:Boolean;
      
      private var m_dt_dash:Boolean;
      
      private var m_walkTimer:int;
      
      private var m_hitForceVisible:Boolean;
      
      private var m_caughtInvincibility:Boolean;
      
      private var m_tetherCount:int;
      
      private var m_pauseLetGo:Boolean;
      
      private var m_pauseFreeze:Boolean;
      
      private var m_pauseTimer:int;
      
      private var m_zLetGo:Boolean;
      
      private var m_ledge:MovieClip;
      
      private var m_ledgeHangTimer:FrameTimer;
      
      private var m_lastLedge:MovieClip;
      
      private var m_ledgeDelay:FrameTimer;
      
      private var m_rollTimer:int;
      
      private var m_currentRollSpeed:Number;
      
      private var m_recoveryAmount:int;
      
      private var m_justFellThroughPlatform:Boolean;
      
      private var m_fallthroughPlatform:Platform;
      
      private var m_fallthroughTimer:FrameTimer;
      
      private var m_blinkTimer:int;
      
      private var m_blinkOn:Boolean;
      
      private var m_calcAngles:Boolean;
      
      private var m_player:MovieClip;
      
      private var m_human:Boolean;
      
      private var m_attachedFPS:MovieClip;
      
      private var m_attachedReticule:MovieClip;
      
      private var m_usingSpecialAttack:Boolean;
      
      private var m_lastSFX:int;
      
      private var m_lastVFX:int;
      
      private var m_staleMovesArr:Array;
      
      private var m_staleMoveVals:Array;
      
      private var m_projectile:Vector.<Projectile>;
      
      private var m_lastProjectile:int;
      
      private var m_item:Item;
      
      private var m_item2:Item;
      
      private var m_itemJustPickedUp:Boolean;
      
      private var m_itemPrePickup:Item;
      
      private var m_ledges:Array;
      
      private var m_grabbed:Vector.<Character>;
      
      private var m_walls:Vector.<BitmapCollisionBoundary>;
      
      private var m_outsideCameraBounds:Boolean;
      
      private var m_outsideMainTerrain:Boolean;
      
      private var m_grabTimer:int;
      
      private var m_pummelTimer:int;
      
      private var m_justPummeled:Boolean;
      
      private var m_grabberID:int;
      
      private var m_caughtLock:Boolean;
      
      private var m_internalGrabLock:Boolean;
      
      private var m_grabCancelled:Boolean;
      
      private var m_initTimer:int;
      
      private var m_ignoreTauntAudio:Boolean;
      
      private var m_showPlayerID:Boolean;
      
      private var m_turnTimer:FrameTimer;
      
      private var m_frozenTimer:int;
      
      private var m_sleepingTimer:int;
      
      private var m_eggTimer:int;
      
      private var m_dustTimer:FrameTimer;
      
      private var m_currentPower:String;
      
      private var m_kirbyLastGrabbed:int;
      
      private var m_charIsFull:Boolean;
      
      private var m_holdTimer:int;
      
      private var m_starTimer:int;
      
      private var m_justReleased:Boolean;
      
      private var m_kirbyDamageCounter:int;
      
      private var m_itemDamageCounter:int;
      
      private var m_lastYPosition:Number;
      
      private var m_forceRight:Boolean;
      
      private var m_forceTimer:int;
      
      private var m_getUpTimer:FrameTimer;
      
      private var m_crashTimer:FrameTimer;
      
      private var m_revivalTimer:int;
      
      private var m_revivalInvincibility:FrameTimer;
      
      private var m_respawnDelay:FrameTimer;
      
      private var m_standby:Boolean;
      
      private var m_comboTimer:FrameTimer;
      
      private var m_comboCount:int;
      
      private var m_comboID:int;
      
      private var m_comboDamage:Number;
      
      private var m_comboDamageTotal:Number;
      
      private var m_damageIncreaseInterval:FrameTimer;
      
      private var m_poisonIncrease:int;
      
      private var m_poisonIncreaseInterval:FrameTimer;
      
      private var m_poisonIncreaseTime:FrameTimer;
      
      private var m_offscreenDamageTimer:FrameTimer;
      
      private var m_offScreenBubble:MovieClip;
      
      private var m_offScreenIndicatorEnabled:Boolean;
      
      private var m_poisonEffect:MovieClip;
      
      private var m_pitfallEffect:MovieClip;
      
      private var m_healEffect:MovieClip;
      
      private var m_burnSmoke:MovieClip;
      
      private var m_darknessSmoke:MovieClip;
      
      private var m_auraSmoke:MovieClip;
      
      private var m_warioWareIcon:MovieClip;
      
      private var m_starmanInvincibility:MovieClip;
      
      private var m_hatMC:MovieClip;
      
      private var m_hatHolder:MovieClip;
      
      private var m_shieldHolderMC:MovieClip;
      
      private var m_chargeGlowHolderMC:MovieClip;
      
      private var m_fsGlowHolderMC:MovieClip;
      
      private var m_pidHolderMC:MovieClip;
      
      private var m_pidHolderNameMC:MovieClip;
      
      private var m_kirbyStarMC:MovieClip;
      
      private var m_yoshiEggMC:MovieClip;
      
      private var m_freezeMC:MovieClip;
      
      private var m_lastFrameInterrupt:String;
      
      private var m_lastFrameInterruptState:int;
      
      private var m_lastFrameInterruptSmashTimer:int;
      
      private var m_burnSmokeTimer:FrameTimer;
      
      private var m_darknessSmokeTimer:FrameTimer;
      
      private var m_auraSmokeTimer:FrameTimer;
      
      private var m_shockEffectTimer:FrameTimer;
      
      private var m_poisonTintTimer:FrameTimer;
      
      private var m_injureFlashTimer:FrameTimer;
      
      private var m_warioWareIconTimer:FrameTimer;
      
      private var m_starmanInvincibilityTimer:FrameTimer;
      
      private var m_forceTransformTime:FrameTimer;
      
      private var m_safeToEndAttack:Boolean;
      
      private var m_lastAttackUsedTurbo:String;
      
      private var m_invisiblePulseTimer:FrameTimer;
      
      private var m_invisiblePulseToggle:Boolean;
      
      private var m_invisiblePulseCount:int;
      
      private var m_costume:int;
      
      private var CPU:AI;
      
      private var m_attackControlsArr:Vector.<int>;
      
      private var dragging:Boolean;
      
      private var m_frozenInTime:Boolean;
      
      private var m_frozenInTimeTimer:int;
      
      public function Character(param1:CharacterData, param2:PlayerSetting, param3:StageData)
      {
         var _loc5_:int = 0;
         m_baseStats = this.m_characterStats = param1;
         if(this.m_characterStats.PlayerID > 0)
         {
            param3.addPlayer(this.m_characterStats.PlayerID,this);
         }
         param3.addCharacter(this);
         this.m_playerSettings = param2;
         m_apiInstance = new SSF2Character(this.m_characterStats.ClassAPI,this);
         if(!this.m_playerSettings.character)
         {
            this.m_characterStats.importData(m_apiInstance.getOwnStats());
            this.m_characterStats.importAttacks(m_apiInstance.getAttackStats());
            this.m_characterStats.addProjectiles(m_apiInstance.getProjectileStats());
            this.m_characterStats.addItems(m_apiInstance.getItemStats());
         }
         else if(this.m_playerSettings.character)
         {
            this.m_characterStats.importData({
               "attackRatio":this.m_playerSettings.attackRatio,
               "damageRatio":this.m_playerSettings.damageRatio,
               "unlimitedFinal":this.m_playerSettings.unlimitedFinal,
               "startDamage":this.m_playerSettings.startDamage,
               "finalSmashMeter":this.m_playerSettings.finalSmashMeter
            });
         }
         var _loc4_:MovieClip = ResourceManager.getLibraryMC(this.m_characterStats.LinkageID);
         super(_loc4_,param3);
         m_player_id = this.m_characterStats.PlayerID;
         m_state = CState.IDLE;
         _loc4_.player_id = m_player_id;
         _loc4_.uid = m_uid;
         m_sprite.x = this.m_playerSettings.x_start;
         m_sprite.y = this.m_playerSettings.y_start;
         m_sizeRatio = param3.GameRef.SizeRatio;
         this.m_originalSizeRatio = m_sizeRatio;
         m_sprite.width *= m_sizeRatio;
         m_sprite.height *= m_sizeRatio;
         this.m_costume = this.m_playerSettings.costume;
         this.m_jumpSpeedMidairDelay = new FrameTimer(1);
         this.m_jumpStartup = new FrameTimer(0);
         this.m_jumpJustChambered = false;
         this.m_jumpSpeedList = new Array();
         this.m_jumpEffectTimer = new FrameTimer(6);
         this.m_preJumpState = CState.IDLE;
         this.m_initialAirDodgeAngle = 0;
         this.m_waveLand = false;
         this.m_waveDashPenalty = 0;
         this.m_airDodgeCount = 0;
         this.m_skidTimer = 0;
         this.m_kirbyLastGrabbed = -1;
         this.m_glideAngle = 0;
         this.m_glideMaxHeight = 0;
         this.m_glideDelay = 0;
         this.m_glideReady = false;
         this.m_attachedReticule = null;
         this.m_attachedFPS = null;
         this.m_damageIncreaseInterval = new FrameTimer(30);
         this.m_wallStickTime = new FrameTimer(0);
         this.m_wallJumpCount = 0;
         this.m_wallClingDelay = new FrameTimer(10);
         this.m_shieldDropLag = new FrameTimer(7);
         this.m_disableHurtFallOff = false;
         this.m_outsideCameraBounds = false;
         this.m_outsideMainTerrain = false;
         this.m_tap_jump = false;
         this.m_auto_dash = false;
         this.m_dt_dash = false;
         this.m_walkTimer = 0;
         this.m_shieldStartTimer = 0;
         m_facingForward = true;
         this.m_speedFacingForward = true;
         this.m_tetherCount = 0;
         if(!this.m_playerSettings.facingRight)
         {
            m_faceLeft();
            this.m_speedFacingForward = false;
         }
         this.m_usingLives = STAGEDATA.GameRef.LevelData.usingLives;
         this.m_showPlayerID = STAGEDATA.GameRef.ShowPlayerID;
         m_team_id = this.m_playerSettings.team;
         this.m_lives = this.m_playerSettings.lives;
         this.m_lastLivesTextNum = -1;
         this.m_expansion_id = this.m_playerSettings.character == "xp" ? int(this.m_playerSettings.expansion) : -1;
         this.m_human = this.m_playerSettings.human;
         this.m_matchResults = new MatchResults(m_player_id);
         this.m_matchResults.StockRemaining = this.m_lives;
         this.m_midAirHoverTime = new FrameTimer(0);
         this.m_midAirJumpConstantTime = new FrameTimer(0);
         this.m_midAirJumpConstantTime.CurrentTime = 0;
         this.m_midAirJumpConstantDelay = new FrameTimer(0);
         this.m_forceTransformTime = new FrameTimer(0);
         this.m_safeToEndAttack = true;
         this.m_offscreenDamageTimer = new FrameTimer(30);
         m_shadowEffect = new MovieClip();
         this.m_offScreenBubble = new MovieClip();
         this.m_offScreenIndicatorEnabled = !DebugConsole.DISABLE_OFFSCREEN_BUBBLE;
         this.m_poisonEffect = ResourceManager.getLibraryMC("poison_effect");
         this.m_pitfallEffect = ResourceManager.getLibraryMC("pitfall_dirt");
         this.m_healEffect = ResourceManager.getLibraryMC("effect_heal");
         this.m_burnSmoke = ResourceManager.getLibraryMC("burn_smoke");
         this.m_darknessSmoke = ResourceManager.getLibraryMC("darkness_smoke");
         this.m_auraSmoke = ResourceManager.getLibraryMC("aura_smoke");
         this.m_warioWareIcon = ResourceManager.getLibraryMC("wariowareResultsIcon");
         this.m_starmanInvincibility = ResourceManager.getLibraryMC("effect_heal");
         this.m_yoshiEggMC = ResourceManager.getLibraryMC("egg_mc");
         this.m_kirbyStarMC = ResourceManager.getLibraryMC("star_mc");
         this.m_freezeMC = ResourceManager.getLibraryMC("freeze_mc");
         Utils.setColorFilter(this.m_starmanInvincibility,{
            "hue":-59,
            "saturation":34,
            "brightness":0,
            "contrast":25
         });
         this.m_hatMC = new MovieClip();
         this.m_hatHolder = null;
         this.m_shieldType = this.m_characterStats.ShieldType;
         this.m_shieldHolderMC = ResourceManager.getLibraryMC(this.m_shieldType);
         if(!this.m_shieldHolderMC)
         {
            this.m_shieldHolderMC = ResourceManager.getLibraryMC("shield1");
         }
         this.m_chargeGlowHolderMC = null;
         this.m_pidHolderMC = ResourceManager.getLibraryMC("pid_mc");
         this.m_pidHolderNameMC = MovieClip(this.m_pidHolderMC.addChildAt(new MovieClip(),0));
         if(Boolean(this.m_playerSettings.name) && Boolean(this.m_human))
         {
            this.m_pidHolderMC.pname.text = this.m_playerSettings.name;
            this.m_pidHolderMC.pid.text = "";
            this.m_pidHolderNameMC.graphics.clear();
            this.m_pidHolderNameMC.graphics.beginFill(0,0.5);
            this.m_pidHolderNameMC.graphics.drawRect(-this.m_pidHolderMC.pname.textWidth / 2 - 3,this.m_pidHolderMC.pname.y,this.m_pidHolderMC.pname.textWidth + 6,this.m_pidHolderMC.pname.height);
            this.m_pidHolderNameMC.graphics.endFill();
         }
         else
         {
            this.m_pidHolderNameMC.graphics.clear();
         }
         Utils.tryToGotoAndStop(this.m_pidHolderMC,"p" + Utils.convertTeamToColor(m_player_id,ModeFeatures.hasFeature(ModeFeatures.IGNORE_TEAM_COSTUME,STAGEDATA.GameRef.GameMode) ? -1 : m_team_id));
         Utils.tryToGotoAndStop(this.m_pidHolderMC.arrow,"p" + Utils.convertTeamToColor(m_player_id,ModeFeatures.hasFeature(ModeFeatures.IGNORE_TEAM_COSTUME,STAGEDATA.GameRef.GameMode) ? -1 : m_team_id));
         this.m_fsGlowHolderMC = ResourceManager.getLibraryMC("finalsmash_standby");
         this.m_warioWareIconTimer = new FrameTimer(20);
         this.m_warioWareIconTimer.finish();
         this.m_burnSmokeTimer = new FrameTimer(75);
         this.m_burnSmokeTimer.finish();
         this.m_darknessSmokeTimer = new FrameTimer(75);
         this.m_darknessSmokeTimer.finish();
         this.m_auraSmokeTimer = new FrameTimer(75);
         this.m_auraSmokeTimer.finish();
         this.m_injureFlashTimer = new FrameTimer(3);
         this.m_injureFlashTimer.finish();
         this.m_shockEffectTimer = new FrameTimer(10);
         this.m_shockEffectTimer.finish();
         this.m_poisonTintTimer = new FrameTimer(12);
         this.m_poisonTintTimer.finish();
         this.m_starmanInvincibilityTimer = new FrameTimer(30 * 10);
         this.m_starmanInvincibilityTimer.finish();
         this.m_currentRollSpeed = 0;
         this.m_starKOTimer = new FrameTimer(90);
         this.m_starKOTimer.finish();
         this.m_screenKO = false;
         this.m_starKOHolder = ResourceManager.getLibraryMC("starkoholder");
         this.m_starKOHolder.uid = m_uid;
         this.m_starKOHolder.stop();
         this.m_screenKOHolder = ResourceManager.getLibraryMC("screenkoholder");
         this.m_screenKOHolder.uid = m_uid;
         this.m_screenKOHolder.stop();
         this.m_lastFrameInterrupt = null;
         this.m_lastFrameInterruptState = CState.IDLE;
         this.m_lastFrameInterruptSmashTimer = 0;
         this.m_sizeStatus = 0;
         this.m_sizeStatusPermanent = false;
         this.m_sizeStatusTimer = new FrameTimer(30 * 10);
         this.m_isMetal = false;
         this.m_sizeStatusTimer.finish();
         this.m_crowdAwe = false;
         this.m_attackHovering = false;
         this.m_canHover = true;
         this.m_rocketSpeed = 0;
         this.m_rocketRotation = false;
         this.m_rocketDecay = 0;
         this.m_rocketAngle = 0;
         this.m_droughtTimer = 0;
         this.m_recoveryAmount = 0;
         this.m_justHit = false;
         this.m_justHitTimer = 5;
         this.resetJustHitTimer();
         this.m_hitLag = -1;
         this.m_hitLagCancelTimer = new FrameTimer(9);
         this.m_hitLagStunTimer = new FrameTimer(12);
         this.m_hitLagLandDelay = new FrameTimer(15);
         this.m_hitLagStunTimer.finish();
         this.m_hitLagCanCancelWithJump = false;
         this.m_hitLagCanCancelWithUpB = false;
         this.m_hitsDealtCounter = 0;
         this.m_hitsReceivedCounter = 0;
         this.m_techTimer = new FrameTimer(10);
         this.m_techDelay = new FrameTimer(10);
         this.m_smashDIAmount = 18;
         this.m_smashDISelf = false;
         this.m_smashDIDirection = -1;
         this.m_smashDIDirectionCStick = -1;
         this.m_canDI = true;
         this.m_techReady = false;
         this.m_justTechedTimer = new FrameTimer(3);
         this.m_justTechedTimer.finish();
         this.m_techLetGo = false;
         this.m_canTech = false;
         this.m_canWallTech = true;
         this.m_canBounce = false;
         this.m_hasBounced = false;
         this.m_revivalTimer = 0;
         this.m_revivalInvincibility = new FrameTimer(75);
         this.m_revivalInvincibility.finish();
         this.m_respawnDelay = new FrameTimer(30);
         this.m_getUpTimer = new FrameTimer(110);
         this.m_crashTimer = new FrameTimer(13);
         this.m_forceRight = true;
         this.m_forceTimer = 0;
         this.m_currentPower = null;
         this.m_charIsFull = false;
         this.m_poisonIncrease = 0;
         this.m_poisonIncreaseInterval = new FrameTimer(15);
         this.m_poisonIncreaseTime = new FrameTimer(300);
         this.m_rollTimer = 0;
         this.m_starTimer = 0;
         this.m_item = null;
         this.m_item2 = null;
         this.m_itemJustPickedUp = false;
         this.m_itemPrePickup = null;
         this.m_justReleased = false;
         this.m_kirbyDamageCounter = -1;
         this.m_itemDamageCounter = -1;
         this.m_lastYPosition = m_sprite.y;
         this.m_lastAttackUsedTurbo = null;
         this.m_invisiblePulseTimer = new FrameTimer(10);
         this.m_invisiblePulseToggle = false;
         this.m_invisiblePulseCount = 0;
         this.m_grabTimer = 0;
         this.m_pummelTimer = 0;
         this.m_justPummeled = false;
         this.m_eggTimer = 0;
         this.m_projectile = new Vector.<Projectile>();
         while(_loc5_ < this.m_characterStats.MaxProjectile)
         {
            this.m_projectile[_loc5_] = null;
            _loc5_++;
         }
         this.m_lastProjectile = 0;
         this.m_turnTimer = new FrameTimer(5);
         this.m_frozenTimer = 0;
         this.m_sleepingTimer = 0;
         this.m_grabberID = -1;
         this.m_internalGrabLock = false;
         this.m_grabCancelled = false;
         this.m_caughtLock = false;
         this.m_justFellThroughPlatform = false;
         this.m_fallthroughPlatform = null;
         this.m_fallthroughTimer = new FrameTimer(30);
         this.m_fallthroughTimer.finish();
         this.m_transformingSpecial = false;
         this.m_transformedSpecial = false;
         this.m_usingSpecialAttack = false;
         this.m_transformTime = 0;
         this.m_transformLimit = 0;
         this.m_finalSmashMeterCharge = 0;
         this.m_finalSmashMeterReady = false;
         this.m_finalSmashCutinMC = null;
         this.m_blinkTimer = 0;
         this.m_blinkOn = false;
         this.m_invisibleTimer = new FrameTimer(1);
         this.m_invisibleTimer.finish();
         this.m_holdTimer = 0;
         this.m_invincibleBrightness = 25;
         this.m_invincibleUp = true;
         this.m_attackIDIncremented = false;
         this.m_previousAttack = null;
         this.m_lastHitStun = 0;
         this.m_attackDelay = 0;
         this.m_stunTimer = 0;
         this.m_dizzyTimer = 0;
         this.m_stunCancelTimer = new FrameTimer(10);
         this.m_dizzyShield = false;
         this.m_pitfallTimer = 0;
         this.m_ricochetTimer = new FrameTimer(3);
         this.m_ricochetCount = new FrameTimer(5);
         this.m_ricochetX = new FrameTimer(2);
         this.m_ricochetY = new FrameTimer(2);
         this.m_ricochetX.finish();
         this.m_ricochetY.finish();
         this.m_dustTimer = new FrameTimer(1);
         this.m_staleMovesArr = [null,null,null,null,null,null,null,null,null];
         this.m_staleMoveVals = [0.1,0.09,0.08,0.07,0.06,0.05,0.04,0.03,0.02];
         this.m_key = STAGEDATA.getControllerNum(m_player_id);
         this.m_heldControlsBuffer = new Array();
         this.m_pressedControlsBuffer = new Array();
         this.m_heldControls = new ControlsObject();
         this.m_pressedControls = new ControlsObject();
         this.m_heldKeyHistory = new ControlsObject();
         this.m_lastSFX = -1;
         this.m_lastVFX = -1;
         m_xSpeed = 0;
         m_ySpeed = 0;
         this.m_jumpCount = this.m_characterStats.MaxJump;
         this.m_cStickUse = false;
         this.m_pauseLetGo = true;
         this.m_zLetGo = true;
         this.m_pauseTimer = 0;
         this.m_bufferedAttackJump = false;
         this.m_jumpSpeedBuffer = 0;
         this.m_multiJumpDelay = new FrameTimer(2);
         this.m_c_buffered_down = false;
         this.m_c_buffered_left = false;
         this.m_c_buffered_right = false;
         m_collision.ground = true;
         m_currentPlatform = null;
         this.m_ledge = null;
         this.m_ledgeHangTimer = new FrameTimer(4 * 30);
         this.m_lastLedge = null;
         this.m_ledgeDelay = new FrameTimer(15);
         Utils.hasLabel(m_sprite,"edgelean",true);
         this.m_calcAngles = true;
         this.resetSpeedLevel();
         this.m_speedLetGo = false;
         this.m_dashReady = true;
         this.m_jumpTimer = 0;
         this.m_shortHop = false;
         this.m_jumpJustLetGo = false;
         this.m_smashTimer = 0;
         this.m_smashTimerUp = 0;
         this.m_smashTimerSide = 0;
         this.m_smashTimerDown = 0;
         this.m_upSpecialTimer = 0;
         this.m_specialTurnTimer = new FrameTimer(3);
         this.m_specialTurnTimer.finish();
         this.m_specialTurnRight = false;
         this.m_lastCrouchTimer = 0;
         this.m_crouchLength = 0;
         this.m_crouchFrame = -1;
         this.setState(CState.IDLE);
         this.m_windBoxHit = false;
         this.m_hasArced = false;
         this.m_forceTumbleFall = false;
         this.m_forcedCrash = false;
         this.m_tumbledCrash = false;
         this.m_jabResets = 0;
         this.m_jabResetTimer = new FrameTimer(30);
         this.m_fallTiltTimer = new FrameTimer(15);
         this.m_fallTiltTimer.finish();
         this.m_fallTiltRight = true;
         this.m_shieldTimer = 0;
         this.m_pauseFreeze = false;
         m_damage = this.m_characterStats.Stamina > 0 ? Number(this.m_characterStats.Stamina) : Number(this.m_characterStats.StartDamage);
         this.m_shieldPower = 100;
         this.m_shield_originalWidth = 0;
         this.m_shield_originalHeight = 0;
         this.m_shieldDelay = 0;
         this.m_shieldDelayTimer = new FrameTimer(1);
         this.m_flyingRight = false;
         this.m_flyingUp = false;
         this.m_comboTimer = new FrameTimer(1);
         this.m_comboCount = 0;
         this.m_comboID = 0;
         this.m_comboDamage = 0;
         this.m_comboDamageTotal = 0;
         this.m_hitForceVisible = true;
         this.m_caughtInvincibility = false;
         this.m_standby = false;
         this.m_attackControlsArr = new Vector.<int>();
         this.m_ledges = new Array();
         this.m_grabbed = new Vector.<Character>();
         this.m_walls = new Vector.<BitmapCollisionBoundary>();
         this.m_initTimer = 0;
         this.m_preFrameInfo = "";
         this.m_freezePlayback = false;
         this.m_pauseCamXSpeed = 0;
         this.m_pauseCamYSpeed = 0;
         if(!this.m_human)
         {
            this.CPU = new AI(this.m_playerSettings.level,this,STAGEDATA);
            if(this.m_characterStats.StatsName === "sandbag" && !this.m_human && STAGEDATA.GameRef.GameMode === Mode.ONLINE_WAITING_ROOM && Boolean(STAGEDATA.CamBounds))
            {
               this.CPU.ForcedAction = CPUState.FORCE_DO_NOTHING;
            }
         }
         this.reapplyCostume();
         this.setStats(this.m_characterStats);
         if(!this.m_human)
         {
            this.CPU.refreshRecoveryAttackList();
            this.CPU.refreshDisabledAttackList();
         }
         this.setVisibility(false);
         if(this.m_characterStats.AlternateStatsID != null)
         {
            buildHitBoxData(this.m_characterStats.AlternateStatsID,false);
         }
         if(this.m_characterStats.LinkageID2 != null)
         {
            buildHitBoxData(this.m_characterStats.LinkageID2,false);
         }
         if(this.m_characterStats.LinkageIDSpecial != null)
         {
            buildHitBoxData(this.m_characterStats.LinkageIDSpecial,false);
         }
         buildHitBoxData(this.m_characterStats.LinkageID);
         if(Main.DEBUG)
         {
            verifiyHitBoxData();
         }
         this.generatePummelData();
         m_attackData.getAttack("star").importAttackData({"attackBoxes":{"attackBox":{
            "atk_id":m_attack.AttackID,
            "damage":8,
            "kbConstant":100,
            "weightKB":110,
            "power":0,
            "direction":45,
            "hitStun":1,
            "hitLag":5,
            "effect_id":"effect_swordSlash",
            "effectSound":"sw_brawl_hit_M",
            "reversableAngle":false,
            "isForward":!m_facingForward
         }}});
         this.setDamage(m_damage);
         this.getTerrainData();
         this.setState(CState.IDLE);
         applyPalette(m_sprite);
         this.applySpecialModeEffects();
         if(this.m_standby)
         {
            this.StandBy = false;
            this.StandBy = true;
         }
         else
         {
            this.setVisibility(true);
         }
         if(this.m_characterStats.StatsName === "sandbag" && !this.m_human && STAGEDATA.GameRef.GameMode === Mode.ONLINE_WAITING_ROOM && Boolean(STAGEDATA.CamBounds))
         {
            m_sprite.x = 408;
            m_sprite.y = 280;
            this.m_playerSettings.importSettings({
               "x_respawn":STAGEDATA.CamBounds.x + STAGEDATA.CamBounds.width / 2,
               "y_respawn":STAGEDATA.CamBounds.y + STAGEDATA.CamBounds.height / 2,
               "x_start":STAGEDATA.CamBounds.x + STAGEDATA.CamBounds.width / 2,
               "y_start":STAGEDATA.CamBounds.y + STAGEDATA.CamBounds.height / 2
            });
         }
         this.m_frozenInTime = false;
         this.m_frozenInTimeTimer = 0;
      }
      
      private function blahd(param1:MouseEvent) : void
      {
         m_sprite.startDrag();
         this.dragging = true;
      }
      
      private function blahd2(param1:MouseEvent) : void
      {
         m_sprite.stopDrag();
         this.dragging = false;
      }
      
      private function ugh(param1:Event) : void
      {
         trace(testTerrainWithCoord(MouseTracker.X,MouseTracker.Y));
      }
      
      public function getStateInfo() : String
      {
         return "{" + "x:" + m_sprite.x + ", y:" + m_sprite.y + ", state:" + CState.toString(m_state) + ", stanceFrame#:" + (HasStance ? m_sprite.stance.currentFrame : "err") + ", onGround:" + m_collision.ground + ", attackingFrame:" + (inState(CState.ATTACKING) && Boolean(m_attack.Frame) ? m_attack.Frame : "null") + ", preFrameInfo: " + this.m_preFrameInfo + ", postFrameInfo: " + this.getFrameData() + ", controlBits: " + this.m_key.getControlsObject().controls + " }";
      }
      
      override public function get CurrentAnimation() : HitBoxAnimation
      {
         return m_hitBoxManager == null ? null : (m_hitBoxManager.HitBoxAnimationList.length <= 0 || !m_currentAnimationID ? null : m_hitBoxManager.getHitBoxAnimation(this.m_characterStats.LinkageID + "_" + m_currentAnimationID));
      }
      
      override protected function checkShowHitBoxes() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Rectangle = null;
         var _loc3_:int = 0;
         var _loc4_:Point = null;
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         var _loc7_:Point = null;
         var _loc8_:MovieClip = null;
         var _loc9_:MovieClip = null;
         super.checkShowHitBoxes();
         if(InteractiveSprite.SHOW_HITBOXES)
         {
            HITBOXES_WAS_ON = true;
            _loc1_ = null;
            _loc2_ = null;
            _loc3_ = 0;
            _loc4_ = new Point();
            _loc5_ = new Point();
            _loc6_ = new Point();
            _loc7_ = new Point();
            _loc8_ = m_sprite.getChildByName("hBoxHolder") ? MovieClip(m_sprite.getChildByName("hBoxHolder")) : null;
            if(inState(CState.SHIELDING))
            {
               _loc1_ = this.ShieldHitBoxes;
               if(Boolean(_loc1_) && _loc1_.length > 0)
               {
                  if(!_loc8_)
                  {
                     _loc8_ = new MovieClip();
                     _loc8_.name = "hBoxHolder";
                     m_sprite.addChild(_loc8_);
                  }
                  _loc3_ = 0;
                  while(_loc3_ < _loc1_.length)
                  {
                     _loc2_ = _loc1_[_loc3_].BoundingBox;
                     _loc8_.graphics.beginFill(16738740,0.25);
                     _loc8_.graphics.drawCircle(_loc2_.x + _loc2_.width / 2,_loc2_.y + _loc2_.height / 2,_loc2_.width / 2);
                     _loc8_.graphics.endFill();
                     _loc8_.parent.setChildIndex(_loc8_,_loc8_.parent.numChildren - 1);
                     _loc3_++;
                  }
               }
            }
         }
         else if(HITBOXES_WAS_ON)
         {
            _loc9_ = m_sprite.getChildByName("hBoxHolder") ? MovieClip(m_sprite.getChildByName("hBoxHolder")) : null;
            if(_loc9_)
            {
               _loc9_.graphics.clear();
            }
            HITBOXES_WAS_ON = false;
         }
      }
      
      private function generatePummelData() : void
      {
         var _loc1_:AttackObject = null;
         if(!m_attackData.getAttack("grab"))
         {
            _loc1_ = new AttackObject("grab");
            _loc1_.importAttackData({"refreshRate":5});
            _loc1_.AttackBoxes["attackBox"] = new AttackDamage(m_player_id,this);
            _loc1_.AttackBoxes["attackBox"].importAttackDamageData({
               "team_id":m_team_id,
               "damage":this.m_characterStats.GrabDamage,
               "hasEffect":false,
               "bypassNonGrabbed":true,
               "effectSound":this.m_characterStats.Sounds["pummel"]
            });
            m_attackData.setAttack("grab",_loc1_);
         }
      }
      
      public function modifyAttack(param1:String, param2:Number, param3:Number) : void
      {
         if(m_attackData.getAttack(param1) != null)
         {
            switch(param2)
            {
               case 1:
                  m_attackData.getAttack(param1).AttackBoxes["attackBox"].Direction = param3;
                  break;
               case 2:
                  m_attackData.getAttack(param1).AttackBoxes["attackBox"].KBConstant = param3;
                  break;
               case 3:
                  m_attackData.getAttack(param1).AttackBoxes["attackBox"].Power = param3;
                  break;
               case 4:
                  m_attackData.getAttack(param1).AttackBoxes["attackBox"].HitStun = param3;
                  break;
               case 5:
                  m_attackData.getAttack(param1).AttackBoxes["attackBox"].SelfHitStun = param3;
                  break;
               case 6:
                  m_attackData.getAttack(param1).AttackBoxes["attackBox"].HitLag = param3;
                  break;
               case 7:
                  m_attackData.getAttack(param1).AttackBoxes["attackBox"].Priority = param3;
                  break;
               case 8:
                  m_attackData.getAttack(param1).AttackBoxes["attackBox"].Damage = param3;
                  break;
               case 9:
                  m_attackData.getAttack(param1).AttackBoxes["attackBox"].WeightKB = param3;
            }
         }
      }
      
      public function getAttack(param1:String, param2:Number) : *
      {
         if(m_attackData.getAttack(param1) == null)
         {
            return null;
         }
         switch(param2)
         {
            case 1:
               return m_attackData.getAttack(param1).AttackBoxes["attackBox"].Direction;
            case 2:
               return m_attackData.getAttack(param1).AttackBoxes["attackBox"].KBConstant;
            case 3:
               return m_attackData.getAttack(param1).AttackBoxes["attackBox"].Power;
            case 4:
               return m_attackData.getAttack(param1).AttackBoxes["attackBox"].HitStun;
            case 5:
               return m_attackData.getAttack(param1).AttackBoxes["attackBox"].SelfHitStun;
            case 6:
               return m_attackData.getAttack(param1).AttackBoxes["attackBox"].HitLag;
            case 7:
               return m_attackData.getAttack(param1).AttackBoxes["attackBox"].Priority;
            case 8:
               return m_attackData.getAttack(param1).AttackBoxes["attackBox"].Damage;
            case 9:
               return m_attackData.getAttack(param1).AttackBoxes["attackBox"].WeightKB;
            default:
               return;
         }
      }
      
      public function getFrameData() : String
      {
         return HasStance ? m_sprite.currentFrame + ":" + m_sprite.stance.currentFrame : m_sprite.currentFrame + ":" + "nullstance";
      }
      
      public function getAI() : AI
      {
         return this.CPU;
      }
      
      public function getTerrainData() : void
      {
         this.m_ledges = new Array(STAGEDATA.getLedges_L(),STAGEDATA.getLedges_R());
         m_terrains = STAGEDATA.Terrains;
         m_platforms = STAGEDATA.Platforms;
         this.m_walls = STAGEDATA.getWalls();
      }
      
      public function grabAPI(param1:int, param2:Boolean = true, param3:Boolean = false, param4:Boolean = false) : Boolean
      {
         var _loc5_:Boolean = false;
         var _loc6_:Character = STAGEDATA.getCharacterByUID(param1);
         if(Boolean(_loc6_) && _loc6_.Grabbed.indexOf(_loc6_) < 0)
         {
            _loc5_ = this.Capture(param1,param2,param3,param4);
            if(_loc5_)
            {
               _loc6_.Grabbed.push(this);
               _loc6_.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.CHAR_GRAB,{
                  "caller":_loc6_.APIInstance.instance,
                  "grabbed":m_apiInstance.instance
               }));
            }
         }
         else if(param1 == -1)
         {
            _loc5_ = this.Capture(param1,param2,param3,param4);
         }
         if(Boolean(!_loc5_) && Boolean(_loc6_) && _loc6_.Grabbed.indexOf(_loc6_) >= 0)
         {
            return true;
         }
         return _loc5_;
      }
      
      public function Capture(param1:int, param2:Boolean = true, param3:Boolean = false, param4:Boolean = false) : Boolean
      {
         if(Boolean(this.m_charIsFull) || Boolean(this.m_standby) || Boolean(this.m_caughtLock) || this.IsCaught || inState(CState.STAMINA_KO) || m_damage <= 0 && m_baseStats.Stamina > 0 || Invincible && !(inState(CState.ATTACKING) && m_attack.ForceGrabbable) || !this.m_revivalInvincibility.IsComplete || !this.m_starmanInvincibilityTimer.IsComplete || this.Dead || this.Hanging || this.Frozen || this.UsingFinalSmash || Boolean(this.m_usingSpecialAttack) && (this.m_characterStats.SpecialType == 2 || this.m_characterStats.SpecialType == 3) || this.Egg || inState(CState.BARREL) || !this.m_characterStats.CanBeGrabbed)
         {
            return false;
         }
         this.m_caughtLock = param4;
         this.m_grabberID = param1;
         var _loc5_:Character = this.m_grabberID >= 0 && Boolean(STAGEDATA.getCharacterByUID(this.m_grabberID)) ? STAGEDATA.getCharacterByUID(this.m_grabberID) : null;
         m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.CHAR_GRABBED,{
            "caller":this.APIInstance.instance,
            "grabber":(_loc5_ ? _loc5_.APIInstance.instance : null)
         }));
         m_knockbackStackingTimer.reset();
         this.stopActionShot();
         this.turnOffInvincibility();
         this.m_hitForceVisible = param2;
         this.m_caughtInvincibility = param3;
         if(inState(CState.SHIELDING))
         {
            this.m_deactivateShield();
         }
         this.grabReleaseOpponent();
         this.m_jumpStartup.reset();
         this.m_attackHovering = false;
         m_attack.Rocket = false;
         this.m_midAirJumpConstantTime.finish();
         if(inState(CState.FLYING))
         {
            this.killAllSpeeds();
            this.resetRotation();
            Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
         }
         if(inState(CState.GLIDING))
         {
            m_xSpeed = 0;
            m_ySpeed = 0;
         }
         if(inState(CState.ATTACKING))
         {
            if(m_attackData.getAttack(m_attack.Frame).ChargeRetain)
            {
               m_attackData.getAttack(m_attack.Frame).ChargeTime = 0;
            }
            this.killAllSpeeds();
            if(inState(CState.ATTACKING) && m_attack.Frame != null && this.getCurrentProjectile() != null && this.getCurrentProjectile().Visible && !this.getCurrentProjectile().Dead)
            {
               this.getCurrentProjectile().endControl();
            }
            this.resetRotation();
            Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
            this.updateItemHolding();
            this.forceEndAttack();
            this.setState(CState.IDLE);
         }
         if(STAGEPARENT.getChildByName("energy" + m_player_id) != null)
         {
            STAGEPARENT.removeChild(STAGEPARENT.getChildByName("energy" + m_player_id));
         }
         if(this.m_usingSpecialAttack)
         {
            this.m_usingSpecialAttack = false;
         }
         if(this.HasFinalSmash)
         {
            this.m_fsGlowHolderMC.visible = false;
         }
         this.setState(CState.CAUGHT);
         this.playHurtFrame();
         m_skipAttackProcessing = true;
         return true;
      }
      
      public function Uncapture() : void
      {
         this.m_caughtInvincibility = false;
         this.m_caughtLock = false;
         this.m_hitForceVisible = true;
         Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
         if(this.HasFinalSmash)
         {
            this.m_fsGlowHolderMC.visible = true;
         }
         if(!inState(CState.STAMINA_KO))
         {
            this.setState(CState.IDLE);
         }
      }
      
      public function Caught() : Boolean
      {
         return inState(CState.CAUGHT);
      }
      
      public function Struggle(param1:int = 4) : int
      {
         var _loc2_:int = 0;
         if(Boolean(this.m_pressedControls.UP) || Boolean(this.m_pressedControls.DOWN) || Boolean(this.m_pressedControls.LEFT) || Boolean(this.m_pressedControls.RIGHT))
         {
            _loc2_ += param1;
         }
         if(Boolean(this.m_pressedControls.C_UP) || Boolean(this.m_pressedControls.C_DOWN) || Boolean(this.m_pressedControls.C_LEFT) || Boolean(this.m_pressedControls.C_RIGHT))
         {
            _loc2_ += param1;
         }
         if(this.m_pressedControls.BUTTON2)
         {
            _loc2_ += param1;
         }
         if(this.m_pressedControls.BUTTON1)
         {
            _loc2_ += param1;
         }
         return _loc2_;
      }
      
      public function destroy(param1:SSF2Event = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(STAGEDATA.Characters.indexOf(this) >= 0)
         {
            if(inState(CState.CAUGHT))
            {
               _loc2_ = 0;
               while(_loc2_ < STAGEDATA.Characters.length)
               {
                  _loc3_ = STAGEDATA.Characters[_loc2_].Grabbed.indexOf(this);
                  if(_loc3_ >= 0)
                  {
                     STAGEDATA.Characters[_loc2_].releaseOpponent(_loc3_);
                  }
                  _loc2_++;
               }
            }
            if(this.m_finalSmashCutinMC)
            {
               if(!this.m_finalSmashCutinMC.parent)
               {
                  this.m_finalSmashCutinMC = null;
                  STAGEDATA.CamRef.deleteForcedTarget(m_sprite);
                  --STAGEDATA.FSCutins;
               }
            }
            m_skipAttackCollisionTests = true;
            m_skipAttackProcessing = true;
            this.setState(CState.DEAD);
            this.removeFromCamera();
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.CHAR_DESTROYED,{"caller":this.APIInstance.instance}));
            if(m_sprite.parent)
            {
               m_sprite.parent.removeChild(m_sprite);
            }
            removeAllTempEvents();
            flushTimers();
            Utils.bulkRemoveMC([m_shadowEffect,m_reflectionEffect,this.m_starKOHolder,this.m_screenKOHolder,this.m_burnSmoke,this.m_darknessSmoke,this.m_auraSmoke,this.m_pitfallEffect,this.m_poisonEffect,this.m_healEffect,this.m_shockEffectTimer]);
            if(Boolean(this.m_hatMC) && Boolean(this.m_hatMC.parent))
            {
               this.m_hatMC.parent.removeChild(this.m_hatMC);
            }
            STAGEDATA.removeCharacter(this);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         while(Boolean(this.m_offScreenBubble) && this.m_offScreenBubble.numChildren > 0)
         {
            if(this.m_offScreenBubble.getChildAt(0) is Bitmap)
            {
               (this.m_offScreenBubble.getChildAt(0) as Bitmap).bitmapData.dispose();
               (this.m_offScreenBubble.getChildAt(0) as Bitmap).bitmapData = null;
            }
            this.m_offScreenBubble.removeChild(this.m_offScreenBubble.getChildAt(0));
         }
      }
      
      public function getMatchResults() : MatchResults
      {
         return this.m_matchResults;
      }
      
      public function updateRanksProxy() : void
      {
         if(ModeFeatures.hasFeature(ModeFeatures.IS_CUSTOM,STAGEDATA.GameRef.GameMode))
         {
            STAGEDATA.updateRanks();
         }
      }
      
      public function resetDroughtTimer() : void
      {
         if(this.m_matchResults.LongestDrought < this.m_droughtTimer && !STAGEDATA.GameEnded)
         {
            this.m_matchResults.LongestDrought = this.m_droughtTimer;
         }
         this.m_droughtTimer = 0;
      }
      
      override public function setState(param1:uint) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = param1 != m_state;
         var _loc4_:uint = m_state;
         if(param1 == CState.IDLE && !inState(CState.IDLE))
         {
            _loc2_ = true;
            if(!m_collision.ground)
            {
               this.resetRotation();
               this.m_fallTiltTimer.reset();
               param1 = uint(CState.JUMP_FALLING);
            }
            this.turnOffInvincibility();
            this.m_dashReady = true;
         }
         else if(param1 == CState.LAND)
         {
            this.turnOffInvincibility();
         }
         if(Boolean(this.isBufferableState(_loc4_)) && !this.isBufferableState(param1))
         {
            if(m_collision.ground && (Boolean(this.m_heldControls.LEFT) || Boolean(this.m_heldControls.RIGHT) || Boolean(this.m_heldControls.SHIELD) || Boolean(this.m_heldControls.SHIELD2) || Boolean(this.m_heldControls.DOWN) && !(_loc4_ === CState.ATTACKING && this.m_previousAttack === "crouch_attack")))
            {
            }
            this.validateControlsBuffer();
         }
         m_state = param1;
         if(_loc4_ === CState.EGG && !inState(CState.EGG))
         {
            this.egg(false);
         }
         if(_loc4_ === CState.ATTACKING && m_attack.IASA)
         {
            m_attack.IASA = false;
         }
         if(_loc3_)
         {
            this.m_grabCancelled = false;
            if(inState(CState.IDLE) && m_collision.ground && Boolean(this.checkItemInterrupt("idle",1)))
            {
               return;
            }
            if(inState(CState.JUMP_FALLING) && Boolean(this.checkItemInterrupt("fall",1)))
            {
               return;
            }
         }
         if(_loc2_)
         {
            this.checkEdgeLean();
         }
         if(_loc3_)
         {
            m_framesSinceLastState = 0;
            if(m_intangible && !inState(CState.CRASH_GETUP) && !inState(CState.TECH_ROLL) && !inState(CState.TECH_GROUND) && !inState(CState.AIR_DODGE) && !inState(CState.LEDGE_HANG))
            {
               this.setIntangibility(false);
            }
            this.m_controlFrames();
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.STATE_CHANGE,{
               "caller":this.APIInstance.instance,
               "fromState":_loc4_,
               "toState":m_state
            }));
            if(m_state != CState.ATTACKING && m_state != CState.ITEM_TOSS)
            {
               flushTimers();
               removeAllTempEvents();
            }
            if(m_state == CState.LAND)
            {
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.CHAR_LAND,{"caller":this.APIInstance.instance}));
            }
            if(_loc4_ == CState.ATTACKING && !inState(CState.ATTACKING) && !this.m_charIsFull)
            {
               this.grabReleaseOpponent();
            }
            if(!inState(CState.CAUGHT))
            {
               this.m_caughtLock = false;
            }
         }
      }
      
      public function starmanEffect(param1:int = 300) : void
      {
         this.m_starmanInvincibilityTimer.reset();
         this.m_starmanInvincibilityTimer.MaxTime = param1;
         toggleEffect(this.m_starmanInvincibility,true);
         this.m_starmanInvincibility.x = m_sprite.x;
         this.m_starmanInvincibility.y = m_sprite.y - m_height * m_sizeRatio / 2;
      }
      
      public function warioWareEffect(param1:Boolean, param2:Boolean) : void
      {
         var _loc3_:Vector.<ItemData> = null;
         var _loc4_:Vector.<ItemData> = null;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc8_:int = int(this.m_sizeStatus);
         if(Boolean(this.m_warioWareIcon && !inState(CState.DEAD) && !inState(CState.STAMINA_KO) && !this.m_standby && !inState(CState.REVIVAL)) && Boolean(!inState(CState.STAR_KO)) && !inState(CState.SCREEN_KO))
         {
            toggleEffect(this.m_warioWareIcon,true);
            this.m_warioWareIcon.x = m_sprite.x;
            this.m_warioWareIcon.y = m_sprite.y - m_height * m_sizeRatio / 2;
            this.m_warioWareIconTimer.reset();
            this.m_warioWareIcon.gotoAndStop(param1 ? "win" : "lose");
            if(param2 && param1)
            {
               _loc3_ = new Vector.<ItemData>();
               _loc4_ = ModeFeatures.hasFeature(ModeFeatures.FORCE_ITEM_AVAILABILITY,STAGEDATA.GameRef.GameMode) ? STAGEDATA.ItemsRef.FullItemsList : STAGEDATA.ItemsRef.ItemsList;
               _loc5_ = 0;
               while(_loc5_ < _loc4_.length)
               {
                  _loc7_ = _loc4_[_loc5_].LinkageID;
                  if(_loc7_ == "smashball" && !STAGEDATA.ItemsRef.CurrentSmashBall || _loc7_ == "homerunbat" || _loc7_ == "pokeball" || _loc7_ == "assistTrophy" || _loc7_ == "spinyShell")
                  {
                     _loc3_.push(_loc4_[_loc5_]);
                  }
                  _loc5_++;
               }
               _loc6_ = Number(Utils.random());
               if(_loc6_ < 0.3333)
               {
                  this.setSizeStatus(1);
                  if(_loc8_ != this.m_sizeStatus)
                  {
                     STAGEDATA.playSpecificSound("mushroom_grow");
                  }
               }
               else if(_loc6_ < 0.66666)
               {
                  this.recover(50);
               }
               else if(_loc6_ >= 0.6666)
               {
                  this.starmanEffect(10 * 30);
               }
               else if(_loc6_ == 4)
               {
                  STAGEDATA.ItemsRef.generateItemObj(_loc3_[Utils.randomInteger(0,_loc3_.length - 1)],m_sprite.x,m_sprite.y - m_height / 2);
               }
            }
         }
      }
      
      public function setMetalStatus(param1:Boolean, param2:Boolean = true) : void
      {
         var _loc3_:Object = null;
         if(param1 !== this.m_isMetal)
         {
            this.m_isMetal = param1;
            if(this.m_isMetal)
            {
               _loc3_ = ResourceManager.getMetalCostume(this.m_characterStats.StatsName);
               Utils.setColorFilter(m_sprite,_loc3_);
               if(_loc3_)
               {
                  this.setPaletteSwap(_loc3_.paletteSwap || null,_loc3_.paletteSwapPA || null);
               }
               m_gravity = this.m_characterStats.Gravity * 1.25;
               m_max_ySpeed = this.m_characterStats.MaxYSpeed * 2;
               this.m_max_xSpeed = this.m_characterStats.MaxXSpeed * 0.95;
               this.m_norm_xSpeed = this.m_characterStats.NormalXSpeed * 0.95;
            }
            else if(!SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.METAL))
            {
               this.reapplyCostume();
               applyPalette(m_healthBoxMC.charHead);
               m_gravity = this.m_characterStats.Gravity;
               m_max_ySpeed = this.m_characterStats.MaxYSpeed;
               this.m_max_xSpeed = this.m_characterStats.MaxXSpeed;
               this.m_norm_xSpeed = this.m_characterStats.NormalXSpeed;
            }
            if(param2)
            {
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.CHAR_METAL_CHANGE,{
                  "caller":this.APIInstance.instance,
                  "isMetal":this.m_isMetal
               }));
            }
         }
      }
      
      public function getMetalStatus() : Boolean
      {
         return this.m_isMetal;
      }
      
      private function reapplyCostume() : void
      {
         updateColorFilter(m_sprite,ModeFeatures.hasFeature(ModeFeatures.IGNORE_TEAM_COSTUME,STAGEDATA.GameRef.GameMode) ? -1 : m_team_id,this.CostumeName,this.CostumeID);
      }
      
      public function get HitLagHack() : Number
      {
         return this.m_hitLagHack;
      }
      
      public function set HitLagHack(param1:Number) : void
      {
         this.m_hitLagHack = param1;
      }
      
      public function get OffScreenIndicatorEnabled() : Boolean
      {
         return this.m_offScreenIndicatorEnabled;
      }
      
      public function set OffScreenIndicatorEnabled(param1:Boolean) : void
      {
         this.m_offScreenIndicatorEnabled = param1;
      }
      
      public function get ZLetGo() : Boolean
      {
         return this.m_zLetGo;
      }
      
      public function set ZLetGo(param1:Boolean) : void
      {
         this.m_zLetGo = param1;
      }
      
      public function get PauseLetGo() : Boolean
      {
         return this.m_pauseLetGo;
      }
      
      public function set PauseLetGo(param1:Boolean) : void
      {
         this.m_pauseLetGo = param1;
      }
      
      public function get HoldJump() : Boolean
      {
         return this.m_characterStats.HoldJump;
      }
      
      public function get CanHover() : Boolean
      {
         return this.m_canHover;
      }
      
      public function get MidAirHover() : int
      {
         return this.m_characterStats.MidAirHover;
      }
      
      public function get AttackHovering() : Boolean
      {
         return inState(CState.ATTACKING) && Boolean(this.m_attackHovering);
      }
      
      public function get HasMidAirJumps() : Boolean
      {
         if(this.m_jumpSpeedList)
         {
            return this.m_jumpCount < this.m_jumpSpeedList.length;
         }
         return this.m_jumpCount < this.m_characterStats.MaxJump;
      }
      
      public function get CurrentMidairJumpSpeed() : Number
      {
         if(this.m_jumpSpeedList)
         {
            if(this.m_jumpCount < this.m_jumpSpeedList.length)
            {
               return -this.m_jumpSpeedList[this.m_jumpCount];
            }
            return -this.m_jumpSpeedList[this.m_jumpSpeedList.length - 1];
         }
         return -this.m_characterStats.JumpSpeedMidAir;
      }
      
      public function get CostumeID() : int
      {
         return this.m_costume;
      }
      
      public function set CostumeID(param1:int) : void
      {
         this.m_costume = param1;
      }
      
      public function setCostumeAPI(param1:int, param2:int = -1) : void
      {
         this.CostumeID = param1;
         this.reapplyCostume();
         if(this.m_starKOMC)
         {
            applyPalette(this.m_starKOMC);
         }
         this.redrawHealthBox();
      }
      
      public function get CostumeName() : String
      {
         return this.m_transformedSpecial ? this.m_characterStats.NormalStatsID : this.m_characterStats.StatsName;
      }
      
      public function get CpuAI() : AI
      {
         return this.CPU;
      }
      
      public function get State() : uint
      {
         return m_state;
      }
      
      public function get CanBarrel() : Boolean
      {
         return this.m_characterStats.CanBarrel;
      }
      
      public function get IsTeching() : Boolean
      {
         return inState(CState.TECH_ROLL) || inState(CState.TECH_GROUND);
      }
      
      public function get Frozen() : Boolean
      {
         return inState(CState.FROZEN);
      }
      
      public function get Pitfall() : Boolean
      {
         return inState(CState.PITFALL);
      }
      
      public function get DisplayName() : String
      {
         return this.m_characterStats.DisplayName;
      }
      
      public function get SoundData() : Array
      {
         return this.m_characterStats.Sounds;
      }
      
      public function get ExpansionID() : Number
      {
         return this.m_expansion_id;
      }
      
      public function get IsCaught() : Boolean
      {
         return inState(CState.CAUGHT);
      }
      
      public function get StatsName() : String
      {
         return this.m_characterStats.NormalStatsID;
      }
      
      public function get CurrentStatsName() : String
      {
         return this.m_characterStats.StatsName;
      }
      
      public function get StandBy() : Boolean
      {
         return this.m_standby;
      }
      
      public function set StandBy(param1:Boolean) : void
      {
         var _loc2_:Vector.<MovieClip> = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector.<MovieClip> = null;
         var _loc6_:Boolean = Boolean(this.m_standby);
         this.m_standby = param1;
         if(Boolean(this.m_standby) && !_loc6_)
         {
            if(inState(CState.SHIELDING))
            {
               this.m_deactivateShield();
            }
            if(inState(CState.FROZEN))
            {
               this.freeze(false);
            }
            if(inState(CState.EGG))
            {
               this.egg(false);
            }
            if(inState(CState.CAUGHT))
            {
               _loc3_ = 0;
               while(_loc3_ < STAGEDATA.Characters.length)
               {
                  _loc4_ = STAGEDATA.Characters[_loc3_].Grabbed.indexOf(this);
                  if(_loc4_ >= 0)
                  {
                     STAGEDATA.Characters[_loc3_].releaseOpponent(_loc4_);
                  }
                  _loc3_++;
               }
            }
            m_sprite.x = this.m_playerSettings.x_start;
            m_sprite.y = this.m_playerSettings.y_start;
            this.forceOnGround();
            this.reset();
            _loc2_ = new Vector.<MovieClip>();
            _loc2_.push(m_sprite);
            STAGEDATA.CamRef.deleteTargets(_loc2_);
            this.setVisibility(false);
            showHealthBoxes(false);
            this.m_recoveryAmount = 0;
            this.hideAllEffects();
            this.m_screenKO = false;
            if(this.m_pidHolderMC.parent)
            {
               this.m_pidHolderMC.parent.removeChild(this.m_pidHolderMC);
            }
            if(!this.m_human)
            {
               this.CPU.resetControlOverrides();
            }
            this.m_revivalInvincibility.finish();
            this.m_starmanInvincibilityTimer.finish();
            this.turnOffInvincibility();
            this.setState(CState.ENTRANCE);
            this.setState(CState.IDLE);
            if(this.m_starKOMC)
            {
               this.m_starKOMC.visible = false;
            }
            this.m_burnSmokeTimer.finish();
            this.m_darknessSmokeTimer.finish();
            this.m_auraSmokeTimer.finish();
            this.m_shockEffectTimer.finish();
            this.m_poisonTintTimer.finish();
            this.m_injureFlashTimer.finish();
            this.m_starmanInvincibilityTimer.finish();
            if(this.m_starKOHolder.visible)
            {
               this.m_starKOHolder.visible = false;
               this.m_starKOHolder.gotoAndStop(1);
            }
            if(this.m_screenKOHolder.visible)
            {
               this.m_screenKOHolder.visible = false;
               this.m_screenKOHolder.gotoAndStop(1);
            }
            if(!this.m_playerSettings.facingRight)
            {
               m_faceLeft();
            }
         }
         else if(!this.m_standby && _loc6_)
         {
            if(!(CAM.Mode == Vcam.ZOOM_MODE && m_player_id > 1))
            {
               _loc5_ = new Vector.<MovieClip>();
               _loc5_.push(m_sprite);
               STAGEDATA.CamRef.addTargets(_loc5_);
            }
            this.setVisibility(true);
            showHealthBoxes(true);
         }
      }
      
      public function get ControlSettings() : Controller
      {
         return this.m_key;
      }
      
      public function get Revival() : Boolean
      {
         return currentFrameIs("revival");
      }
      
      public function get DizzyShield() : Boolean
      {
         return this.m_dizzyShield;
      }
      
      public function get HitBox() : MovieClip
      {
         return m_sprite.stance.hitBox;
      }
      
      public function get AirDodge() : Boolean
      {
         return inState(CState.AIR_DODGE);
      }
      
      public function get SidestepDodge() : Boolean
      {
         return inState(CState.SIDESTEP_DODGE);
      }
      
      public function get AttackForward() : Boolean
      {
         return m_attack.IsForward;
      }
      
      public function get UsingFinalSmash() : Boolean
      {
         if(Boolean(this.m_usingSpecialAttack) || Boolean(this.m_transformedSpecial) || Boolean(this.m_transformingSpecial))
         {
            return true;
         }
         return false;
      }
      
      public function get TransformedSpecial() : Boolean
      {
         return this.m_transformedSpecial;
      }
      
      public function get TransformingFinalSmash() : Boolean
      {
         if(Boolean(this.m_usingSpecialAttack) && Boolean(this.m_transformingSpecial))
         {
            return true;
         }
         return false;
      }
      
      public function get AttackingFinalSmash() : Boolean
      {
         if(Boolean(this.m_usingSpecialAttack) && this.m_characterStats.SpecialType > 0)
         {
            return true;
         }
         return false;
      }
      
      public function get HasSmashBall() : Boolean
      {
         return this.m_item2 != null;
      }
      
      public function get HasFinalSmash() : Boolean
      {
         return this.m_item2 != null || Boolean(this.m_finalSmashMeterReady);
      }
      
      public function get HoldingItem() : Boolean
      {
         return this.m_item != null;
      }
      
      public function get WarningCollision() : Boolean
      {
         return m_collision.lbound_lower || m_collision.lbound_upper || m_collision.rbound_lower || m_collision.rbound_upper;
      }
      
      public function get Gliding() : Boolean
      {
         return inState(CState.GLIDING);
      }
      
      public function get ItemObj() : Item
      {
         return this.m_item;
      }
      
      public function set ItemObj(param1:*) : void
      {
         this.m_item = param1;
      }
      
      public function get FinalSmashMeterCharge() : Number
      {
         return this.m_finalSmashMeterCharge;
      }
      
      public function set FinalSmashMeterCharge(param1:Number) : void
      {
         if(!this.m_characterStats.FinalSmashMeter)
         {
            return;
         }
         if(param1 > 1)
         {
            param1 = 1;
         }
         else if(param1 < 0)
         {
            param1 = 0;
         }
         if(Boolean(m_healthBoxMC) && !this.m_transformedSpecial)
         {
            m_healthBoxMC.fsmeter.bar.scaleX = param1;
         }
         this.m_finalSmashMeterCharge = param1;
         if(param1 === 1 && !this.m_finalSmashMeterReady)
         {
            this.m_finalSmashMeterReady = true;
            this.m_fsGlowHolderMC.scaleX = m_sizeRatio;
            this.m_fsGlowHolderMC.scaleY = m_sizeRatio;
            this.m_fsGlowHolderMC.x = m_sprite.x;
            this.m_fsGlowHolderMC.y = m_sprite.y;
            this.playGlobalSound("smashball_break");
            toggleEffect(this.m_fsGlowHolderMC,true);
            if(m_healthBoxMC)
            {
               m_healthBoxMC.fsmeter.bar.gotoAndPlay("full");
               m_healthBoxMC.fsmeter.fullcharge.gotoAndPlay("on");
            }
         }
         else if(param1 < 1 && Boolean(this.m_finalSmashMeterReady))
         {
            this.m_finalSmashMeterReady = false;
            toggleEffect(this.m_fsGlowHolderMC,false);
            if(m_healthBoxMC)
            {
               m_healthBoxMC.fsmeter.bar.gotoAndPlay("fill");
               m_healthBoxMC.fsmeter.fullcharge.gotoAndPlay("off");
            }
         }
      }
      
      public function get FinalSmashMeterCharged() : Boolean
      {
         return this.m_finalSmashMeterReady;
      }
      
      public function get Injured() : Boolean
      {
         return inState(CState.INJURED);
      }
      
      public function get Flying() : Boolean
      {
         return inState(CState.FLYING);
      }
      
      public function get Crashed() : Boolean
      {
         return inState(CState.CRASH_LAND) || inState(CState.CRASH_GETUP);
      }
      
      public function get SmashDISelf() : Boolean
      {
         return this.m_smashDISelf;
      }
      
      public function set SmashDISelf(param1:Boolean) : void
      {
         this.m_smashDISelf = param1;
      }
      
      public function get FlyingRight() : Boolean
      {
         return this.m_flyingRight;
      }
      
      public function get FlyingUp() : Boolean
      {
         return this.m_flyingUp;
      }
      
      public function get KirbyPower() : String
      {
         if(this.m_characterStats.LinkageID == "kirby")
         {
            return this.m_currentPower;
         }
         return this.m_characterStats.Power;
      }
      
      public function get KirbyHatMC() : MovieClip
      {
         return this.m_hatMC;
      }
      
      public function set KirbyPower(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Character = null;
         var _loc4_:* = undefined;
         if(this.m_characterStats.LinkageID == "kirby")
         {
            if(param1 != null)
            {
               _loc2_ = 0;
               while(_loc2_ < STAGEDATA.Characters.length)
               {
                  _loc3_ = STAGEDATA.Characters[_loc2_];
                  if(_loc3_.KirbyPower == param1)
                  {
                     for(_loc4_ in _loc3_.AttackDataObj.ProjectilesArray)
                     {
                        if(!m_attackData.getProjectile(_loc4_))
                        {
                           m_attackData.addProjectile(_loc4_,_loc3_.AttackDataObj.ProjectilesArray[_loc4_]);
                        }
                     }
                     break;
                  }
                  _loc2_++;
               }
            }
            this.m_currentPower = param1;
            this.m_kirbyDamageCounter = 45;
            if(STAGEDATA.getCharacterByUID(this.m_kirbyLastGrabbed) != null && STAGEDATA.getCharacterByUID(this.m_kirbyLastGrabbed).LinkageName == "kirby")
            {
               STAGEDATA.getCharacterByUID(this.m_kirbyLastGrabbed).releaseKirbyPower();
            }
         }
         else
         {
            this.m_characterStats.Power = param1;
         }
      }
      
      public function get CharacterStats() : CharacterData
      {
         return this.m_characterStats;
      }
      
      public function get LinkageName() : String
      {
         return this.m_characterStats.LinkageID;
      }
      
      public function get LinkageNameSpecial() : String
      {
         return this.m_characterStats.LinkageIDSpecial;
      }
      
      public function get Ledge() : MovieClip
      {
         return this.m_ledge;
      }
      
      public function get Hanging() : Boolean
      {
         return inState(CState.LEDGE_HANG);
      }
      
      public function get AttackDelay() : int
      {
         return this.m_attackDelay;
      }
      
      public function set AttackDelay(param1:int) : void
      {
         this.m_attackDelay = param1;
      }
      
      public function get JumpCount() : int
      {
         return this.m_jumpCount;
      }
      
      public function set JumpCount(param1:int) : void
      {
         this.m_jumpCount = param1;
      }
      
      public function get MaxJump() : int
      {
         return this.m_characterStats.MaxJump;
      }
      
      public function get ShieldPower() : Number
      {
         return this.m_shieldPower;
      }
      
      public function get ShieldStartTimer() : Number
      {
         return this.m_shieldStartTimer;
      }
      
      public function get PerfectShield() : Boolean
      {
         return inState(CState.SHIELDING) && this.m_shieldStartTimer < 1;
      }
      
      public function get IsHuman() : Boolean
      {
         return this.m_human;
      }
      
      public function get Shielding() : Boolean
      {
         return inState(CState.SHIELDING);
      }
      
      public function get Grabbing() : Boolean
      {
         return inState(CState.GRABBING);
      }
      
      public function get Dodging() : Boolean
      {
         return inState(CState.DODGE_ROLL) || inState(CState.SIDESTEP_DODGE) || inState(CState.AIR_DODGE);
      }
      
      public function get Grabbed() : Vector.<Character>
      {
         return this.m_grabbed;
      }
      
      public function get GrabberID() : int
      {
         return this.m_grabberID;
      }
      
      public function get Rolling() : Boolean
      {
         return inState(CState.ROLL);
      }
      
      public function get RollingUp() : Boolean
      {
         return inState(CState.LEDGE_ROLL);
      }
      
      public function get ClimbingUp() : Boolean
      {
         return inState(CState.LEDGE_CLIMB);
      }
      
      public function get Dead() : Boolean
      {
         return inState(CState.DEAD);
      }
      
      public function get FacingRight() : Boolean
      {
         return m_facingForward;
      }
      
      public function get HitLag() : int
      {
         return this.m_hitLag;
      }
      
      public function set HitLag(param1:int) : void
      {
         this.m_hitLag = param1;
      }
      
      public function set FlyingRight(param1:Boolean) : void
      {
         this.m_flyingRight = param1;
      }
      
      public function set FlyingUp(param1:Boolean) : void
      {
         this.m_flyingUp = param1;
      }
      
      public function get XVelocity() : Number
      {
         return 0;
      }
      
      public function set XVelocity(param1:Number) : void
      {
      }
      
      public function get YVelocity() : Number
      {
         return 0;
      }
      
      public function set YVelocity(param1:Number) : void
      {
      }
      
      public function get Terrain() : Vector.<Platform>
      {
         return m_terrains;
      }
      
      public function get Platforms() : Vector.<Platform>
      {
         return m_platforms;
      }
      
      public function get ProjectileArray() : Vector.<Projectile>
      {
         return this.m_projectile;
      }
      
      public function get CharIsFull() : Boolean
      {
         return this.m_charIsFull;
      }
      
      public function get Combo() : Number
      {
         return this.m_comboCount;
      }
      
      public function get ComboDamage() : Number
      {
         return this.m_comboDamage;
      }
      
      public function get SpecialType() : int
      {
         return this.m_characterStats.SpecialType;
      }
      
      public function get ComboDamageTotal() : Number
      {
         return this.m_comboDamageTotal;
      }
      
      override public function get PickupHitBoxes() : Array
      {
         if(!this.inFreeState(CFreeState.ATTACKING | CFreeState.DODGING) || inState(CState.ATTACKING) && m_attack.ExecTime > 0)
         {
            return [];
         }
         var _loc1_:Point = CurrentScale;
         var _loc2_:Number = m_width * _loc1_.x;
         var _loc3_:Number = m_height * _loc1_.y;
         var _loc4_:Rectangle = new Rectangle();
         _loc4_.width = _loc2_ * 1.5;
         _loc4_.height = _loc3_ / 2;
         _loc4_.x = -_loc4_.width * 3 / 8;
         _loc4_.y = -_loc4_.height;
         var _loc5_:HitBoxSprite = new HitBoxSprite(HitBoxSprite.PICKUP,_loc4_,false,null);
         return new Array(_loc5_);
      }
      
      override public function get ShieldHitBoxes() : Array
      {
         var _loc1_:Rectangle = null;
         var _loc2_:HitBoxSprite = null;
         if(inState(CState.SHIELDING))
         {
            if(this.m_characterStats.CustomShield)
            {
               return HasHitBox ? this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.SHIELD) : super.ShieldHitBoxes;
            }
            _loc1_ = new Rectangle();
            _loc1_.width = 55 * (this.m_shieldPower / 100 * (this.m_characterStats.MaxShieldSize - this.m_characterStats.MinShieldSize) + this.m_characterStats.MinShieldSize);
            _loc1_.height = 55 * (this.m_shieldPower / 100 * (this.m_characterStats.MaxShieldSize - this.m_characterStats.MinShieldSize) + this.m_characterStats.MinShieldSize);
            _loc1_.x = -_loc1_.width / 2 + this.m_characterStats.ShieldXOffset * m_sizeRatio;
            _loc1_.y = -m_height / 3 * m_sizeRatio - _loc1_.height / 2 + this.m_characterStats.ShieldYOffset * m_sizeRatio;
            _loc1_.y -= 8.4;
            _loc2_ = new HitBoxSprite(HitBoxSprite.SHIELD,_loc1_,true,null);
            return new Array(_loc2_);
         }
         return super.ShieldHitBoxes;
      }
      
      override public function get StarHitBoxes() : Array
      {
         var _loc1_:Rectangle = null;
         var _loc2_:HitBoxSprite = null;
         if(inState(CState.KIRBY_STAR))
         {
            _loc1_ = new Rectangle();
            _loc1_.width = 35;
            _loc1_.height = 35;
            _loc1_.x = -_loc1_.width / 2;
            _loc1_.y = -m_height * m_sizeRatio;
            _loc2_ = new HitBoxSprite(HitBoxSprite.ATTACK,_loc1_,true,null);
            _loc2_.Name = "attackBox";
            return new Array(_loc2_);
         }
         return null;
      }
      
      override public function get EggHitBoxes() : Array
      {
         var _loc1_:Rectangle = null;
         var _loc2_:HitBoxSprite = null;
         if(inState(CState.EGG))
         {
            _loc1_ = new Rectangle();
            _loc1_.width = 30;
            _loc1_.height = 50;
            _loc1_.x = -_loc1_.width / 2;
            _loc1_.y = -_loc1_.height + 10;
            _loc2_ = new HitBoxSprite(HitBoxSprite.EGG,_loc1_,true,null);
            return new Array(_loc2_);
         }
         return null;
      }
      
      override public function get FreezeHitBoxes() : Array
      {
         var _loc1_:Rectangle = null;
         var _loc2_:HitBoxSprite = null;
         if(inState(CState.FROZEN))
         {
            _loc1_ = new Rectangle();
            _loc1_.width = 85;
            _loc1_.height = 65;
            _loc1_.x = -_loc1_.width / 2;
            _loc1_.y = -m_height * m_sizeRatio;
            _loc2_ = new HitBoxSprite(HitBoxSprite.FREEZE,_loc1_,true,null);
            return new Array(_loc2_);
         }
         return null;
      }
      
      public function usingMidAirJumpConstant() : Boolean
      {
         return this.m_midAirJumpConstantTime.MaxTime > 0 && !this.m_midAirJumpConstantTime.IsComplete;
      }
      
      public function inFreeState(param1:uint = 0) : Boolean
      {
         var _loc2_:Boolean = (param1 & CFreeState.ATTACKING) > 0 ? false : inState(CState.ATTACKING);
         _loc2_ = _loc2_ && (param1 & CFreeState.NON_IASA) > 0 && m_attack.IASA ? true : _loc2_ && !m_attack.IASA;
         var _loc3_:Boolean = (param1 & CFreeState.GRABBING) > 0 ? false : inState(CState.GRABBING);
         var _loc4_:Boolean = (param1 & CFreeState.SWALLOWING) > 0 ? false : Boolean(this.m_charIsFull);
         var _loc5_:Boolean = (param1 & CFreeState.SHIELDING) > 0 ? false : inState(CState.SHIELDING);
         var _loc6_:Boolean = (param1 & CFreeState.INJURED) > 0 ? false : !(!inState(CState.INJURED) && !inState(CState.FLYING));
         var _loc7_:Boolean = (param1 & CFreeState.DISABLED) > 0 ? false : inState(CState.DISABLED);
         var _loc8_:Boolean = (param1 & CFreeState.DODGING) > 0 ? false : inState(CState.DODGE_ROLL) || inState(CState.SIDESTEP_DODGE) || inState(CState.AIR_DODGE);
         var _loc9_:Boolean = (param1 & CFreeState.GLIDING) > 0 ? false : inState(CState.GLIDING);
         var _loc10_:Boolean = (param1 & CFreeState.TURNING) > 0 ? false : inState(CState.TURN);
         var _loc11_:Boolean = (param1 & CFreeState.JUMP_CHAMBER) > 0 ? false : this.isJumpChambering();
         var _loc12_:Boolean = (param1 & CFreeState.SKIDDING) > 0 ? false : this.isSkidding();
         var _loc13_:Boolean = (param1 & CFreeState.TOSSING) > 0 ? false : inState(CState.ITEM_TOSS);
         var _loc14_:Boolean = (param1 & CFreeState.TRANSFORMING_FS) > 0 ? false : Boolean(this.m_transformingSpecial);
         var _loc15_:Boolean = (param1 & CFreeState.USING_FS) > 0 ? false : Boolean(this.m_usingSpecialAttack);
         return !this.m_standby && !inState(CState.DEAD) && !inState(CState.STAMINA_KO) && !_loc6_ && !_loc7_ && !_loc2_ && !_loc5_ && !_loc8_ && !inState(CState.LEDGE_HANG) && !inState(CState.LEDGE_ROLL) && !inState(CState.LEDGE_CLIMB) && !inState(CState.STUNNED) && !inState(CState.DIZZY) && !inState(CState.PITFALL) && !inState(CState.WALL_CLING) && !inState(CState.SLEEP) && !_loc14_ && !_loc15_ && !inState(CState.TAUNT) && !inState(CState.FROZEN) && !inState(CState.CAUGHT) && !inState(CState.BARREL) && !inState(CState.EGG) && !this.isLanding() && !_loc11_ && !inState(CState.ROLL) && !_loc3_ && !_loc4_ && !inState(CState.KIRBY_STAR) && !inState(CState.REVIVAL) && !_loc13_ && !inState(CState.CRASH_LAND) && !inState(CState.CRASH_GETUP) && !inState(CState.STAR_KO) && !inState(CState.SCREEN_KO) && !_loc9_ && !_loc10_ && !inState(CState.TECH_GROUND) && !inState(CState.TECH_ROLL) && !_loc12_ && !inState(CState.SHIELD_DROP) && !inState(CState.ITEM_PICKUP) && !inState(CState.LOCKED);
      }
      
      public function get OnKirbyFrame() : Boolean
      {
         return Boolean(this.m_currentPower != null && this.m_characterStats.LinkageID == "kirby" && (m_attack.Frame == "kirby" || m_attack.Frame == "kirby_air"));
      }
      
      public function get Disabled() : Boolean
      {
         return inState(CState.DISABLED);
      }
      
      public function get AttachedFSCutscene() : MovieClip
      {
         return this.m_attachedFPS;
      }
      
      public function get AttachedReticule() : MovieClip
      {
         return this.m_attachedReticule;
      }
      
      public function get StarKOMC() : MovieClip
      {
         return this.m_starKOMC;
      }
      
      public function get ScreenKO() : Boolean
      {
         return this.m_screenKO;
      }
      
      public function get ScreenKOHolder() : MovieClip
      {
         return this.m_screenKOHolder;
      }
      
      public function get Egg() : Boolean
      {
         return inState(CState.EGG);
      }
      
      public function get SizeStatus() : int
      {
         return this.m_sizeStatus;
      }
      
      public function get SizeStatusPermanent() : Boolean
      {
         return this.m_sizeStatusPermanent;
      }
      
      public function set SizeStatusPermanent(param1:Boolean) : void
      {
         this.m_sizeStatusPermanent = param1;
      }
      
      public function get OriginalSizeRatio() : Number
      {
         return this.m_originalSizeRatio;
      }
      
      public function set OriginalSizeRatio(param1:Number) : void
      {
         this.m_originalSizeRatio = param1;
      }
      
      public function get FreezePlayback() : Boolean
      {
         return this.m_freezePlayback;
      }
      
      public function set FreezePlayback(param1:Boolean) : void
      {
         this.m_freezePlayback = param1;
      }
      
      public function get GrabCancelled() : Boolean
      {
         return this.m_grabCancelled;
      }
      
      public function set GrabCancelled(param1:Boolean) : void
      {
         this.m_grabCancelled = param1;
      }
      
      public function lockSizeStatus(param1:Boolean) : void
      {
         this.m_sizeStatusPermanent = param1;
      }
      
      override public function resetCameraBox() : void
      {
         m_sprite.cam_width = this.m_characterStats.CamWidth;
         m_sprite.cam_height = this.m_characterStats.CamHeight;
         m_sprite.cam_x_offset = this.m_characterStats.CamXOffset;
         m_sprite.cam_y_offset = this.m_characterStats.CamYOffset;
      }
      
      override public function attachHealthBox(param1:String, param2:String, param3:String, param4:int = -1, param5:String = null, param6:int = -1) : void
      {
         super.attachHealthBox(param1,param2,param3,param4,param5,param6);
         this.m_lastLivesTextNum = -1;
         this.updateLivesDisplay();
         if(STAGEDATA.GameRef.ScoreDisplay && Boolean(m_healthBoxMC.score))
         {
            m_healthBoxMC.score.text = "" + this.m_matchResults.Score;
            m_healthBoxMC.score.visible = true;
            m_healthBoxMC.scoreLabel.visible = true;
         }
         if(m_healthBoxMC.icon.getChildByName("icon"))
         {
            if(!(param4 > 0 && !ModeFeatures.hasFeature(ModeFeatures.IGNORE_TEAM_COSTUME,STAGEDATA.GameRef.GameMode)))
            {
               if(!this.m_human)
               {
                  Utils.setTint(m_healthBoxMC.icon,1,1,1,1,0,0,0,0);
               }
            }
         }
         if(!ModeFeatures.hasFeature(ModeFeatures.IGNORE_TEAM_COSTUME,STAGEDATA.GameRef.GameMode))
         {
            if(param4 < 0)
            {
               if(!this.m_human)
               {
                  Utils.tryToGotoAndStop(m_healthBoxMC.damageBox,"team-1");
                  Utils.tryToGotoAndStop(m_healthBoxMC.damageStrike,"team-1");
               }
            }
         }
         if(!this.m_characterStats.FinalSmashMeter && !this.m_transformedSpecial)
         {
            m_healthBoxMC.fsmeter.visible = false;
         }
         else
         {
            m_healthBoxMC.fsmeter.visible = true;
         }
         if(this.m_finalSmashMeterCharge >= 1)
         {
            m_healthBoxMC.fsmeter.bar.gotoAndPlay("full");
            m_healthBoxMC.fsmeter.fullcharge.gotoAndPlay("on");
         }
         else
         {
            m_healthBoxMC.fsmeter.bar.gotoAndPlay("fill");
            m_healthBoxMC.fsmeter.fullcharge.gotoAndPlay("off");
         }
      }
      
      override public function getLinkageID() : String
      {
         return this.m_characterStats.LinkageID;
      }
      
      public function getForceTransformTime() : int
      {
         return this.m_forceTransformTime.MaxTime - this.m_forceTransformTime.CurrentTime;
      }
      
      public function jumpFullyReleased() : Boolean
      {
         return this.jumpIsPressed();
      }
      
      public function jumpIsPressed() : Boolean
      {
         return Boolean(this.m_pressedControls.JUMP) || Boolean(this.m_pressedControls.JUMP2) || Boolean(this.m_pressedControls.JUMP3);
      }
      
      public function jumpIsHeld() : Boolean
      {
         return Boolean(this.m_heldControls.JUMP) || Boolean(this.m_heldControls.JUMP2) || Boolean(this.m_heldControls.JUMP3);
      }
      
      public function shieldIsPressed() : Boolean
      {
         return Boolean(this.m_pressedControls.SHIELD) || Boolean(this.m_pressedControls.SHIELD2);
      }
      
      public function shieldIsHeld() : Boolean
      {
         return Boolean(this.m_heldControls.SHIELD) || Boolean(this.m_heldControls.SHIELD2) ? true : false;
      }
      
      override public function recover(param1:int) : Boolean
      {
         if(m_damage == 0)
         {
            return false;
         }
         if(this.m_recoveryAmount <= 0)
         {
            this.m_healEffect.x = m_sprite.x;
            this.m_healEffect.y = m_sprite.y;
            toggleEffect(this.m_healEffect,true);
         }
         this.m_recoveryAmount += param1;
         return true;
      }
      
      private function checkRecovery() : void
      {
         if(this.m_recoveryAmount > 0)
         {
            healDamage(1);
            Utils.advanceFrame(this.m_healEffect);
            --this.m_recoveryAmount;
            this.m_healEffect.x = m_sprite.x;
            this.m_healEffect.y = m_sprite.y;
            if(m_baseStats.Stamina > 0 && m_damage >= m_baseStats.Stamina)
            {
               m_damage = m_baseStats.Stamina;
               this.m_recoveryAmount = 0;
            }
            else if(m_damage <= 0)
            {
               m_damage = 0;
               this.m_recoveryAmount = 0;
            }
         }
         if(this.m_recoveryAmount <= 0)
         {
            toggleEffect(this.m_healEffect,false);
         }
      }
      
      private function checkOffScreenBubble() : void
      {
         var _loc1_:Rectangle = null;
         var _loc2_:Rectangle = null;
         var _loc3_:BitmapData = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Matrix = null;
         var _loc7_:Bitmap = null;
         var _loc8_:Matrix = null;
         var _loc9_:MovieClip = null;
         if(Boolean(this.m_outsideCameraBounds) && HasStance && Boolean(this.m_offScreenIndicatorEnabled) && Boolean(ModeFeatures.hasFeature(ModeFeatures.OFFSCREEN_BUBBLE,STAGEDATA.GameRef.GameMode)))
         {
            _loc9_ = this.m_pidHolderMC;
            _loc9_.pid.visible = false;
            _loc1_ = m_sprite.getBounds(m_sprite);
            _loc2_ = m_sprite.getBounds(m_sprite.parent);
            _loc3_ = new BitmapData(Math.round(_loc1_.width + 0.5),Math.round(_loc1_.height + 0.5),true,1127270);
            _loc4_ = false;
            _loc5_ = false;
            _loc6_ = new Matrix();
            _loc6_.tx = -_loc1_.x;
            _loc6_.ty = -_loc1_.y;
            _loc4_ = !m_facingForward;
            _loc5_ = false;
            _loc3_.draw(m_sprite,_loc6_,null,null,null,false);
            if(m_paletteSwapData)
            {
               Utils.replacePaletteHelper(_loc3_,m_paletteSwapData);
            }
            while(this.m_offScreenBubble.numChildren > 0)
            {
               if(this.m_offScreenBubble.getChildAt(0) is Bitmap)
               {
                  (this.m_offScreenBubble.getChildAt(0) as Bitmap).bitmapData.dispose();
                  (this.m_offScreenBubble.getChildAt(0) as Bitmap).bitmapData = null;
               }
               this.m_offScreenBubble.removeChild(this.m_offScreenBubble.getChildAt(0));
            }
            _loc7_ = new Bitmap(_loc3_);
            _loc8_ = new Matrix();
            if(_loc4_)
            {
               _loc8_.a = -1;
            }
            if(_loc5_)
            {
               _loc8_.d = -1;
            }
            _loc8_.tx = _loc4_ ? -_loc1_.x : _loc1_.x;
            _loc8_.ty = _loc5_ ? -_loc1_.y : _loc1_.y;
            _loc8_.scale(0.4,0.4);
            _loc8_.rotate(Utils.toRadians(Utils.forceBase360(!m_facingForward ? -CurrentRotation : -CurrentRotation)));
            _loc7_.transform.matrix = _loc8_;
            _loc7_.y -= m_height * 0.2;
            this.m_offScreenBubble.addChild(_loc7_);
            _loc9_.offScreenBubble.visible = true;
            if(!this.m_offScreenBubble.parent)
            {
               _loc9_.offScreenBubble.bmpImage.addChild(this.m_offScreenBubble);
            }
         }
         else if(this.m_offScreenBubble.parent)
         {
            _loc9_ = this.m_pidHolderMC;
            _loc9_.pid.visible = true;
            _loc9_.offScreenBubble.visible = false;
            toggleEffect(this.m_offScreenBubble,false);
         }
         else
         {
            this.m_pidHolderMC.pid.visible = true;
         }
      }
      
      override protected function hideAllEffects() : void
      {
         super.hideAllEffects();
         toggleEffect(this.m_burnSmoke,false);
         toggleEffect(this.m_darknessSmoke,false);
         toggleEffect(this.m_auraSmoke,false);
         toggleEffect(this.m_healEffect,false);
         toggleEffect(this.m_poisonEffect,false);
         toggleEffect(this.m_pitfallEffect,false);
         toggleEffect(this.m_warioWareIcon,false);
         toggleEffect(this.m_starmanInvincibility,false);
         toggleEffect(this.m_offScreenBubble,false);
         toggleEffect(this.m_chargeGlowHolderMC,false);
         toggleEffect(this.m_fsGlowHolderMC,false);
         toggleEffect(this.m_kirbyStarMC,false);
         this.m_burnSmokeTimer.finish();
         this.m_darknessSmokeTimer.finish();
         this.m_auraSmokeTimer.finish();
      }
      
      override protected function checkReflection(param1:Number = 1) : void
      {
         if(Boolean(STAGEDATA.ReflectionsRef) && HasStance)
         {
            if(inState(CState.CAUGHT) || inState(CState.BARREL))
            {
               toggleEffect(m_reflectionEffect,false);
            }
            else
            {
               super.checkReflection();
            }
         }
      }
      
      override protected function checkShadow(param1:Number = 1) : void
      {
         if(Boolean(STAGEDATA.LightSource) && Boolean(STAGEDATA.ShadowsRef) && HasStance)
         {
            if(inState(CState.CAUGHT) || inState(CState.BARREL))
            {
               toggleEffect(m_shadowEffect,false);
            }
            else
            {
               super.checkShadow(this.m_sizeStatus == 0 ? param1 : (this.m_sizeStatus > 0 ? 2 : 0.5));
            }
         }
      }
      
      public function increaseComboCount(param1:AttackDamage, param2:Number, param3:Boolean = false) : void
      {
         if(param1.HasEffect || param3)
         {
            if(this.m_comboID != param2)
            {
               this.m_comboCount = 0;
               this.m_comboDamageTotal = 0;
            }
            this.m_comboID = param2;
            ++this.m_comboCount;
            this.m_comboTimer.reset();
            this.m_comboDamage = Utils.calculateChargeDamage(param1);
            this.m_comboDamageTotal += this.m_comboDamage;
         }
      }
      
      override public function dealDamage(param1:Number) : void
      {
         if(!STAGEDATA.GameEnded)
         {
            this.m_matchResults.DamageTaken += param1;
         }
         if(Boolean(this.m_characterStats.FinalSmashMeter) && !this.m_usingSpecialAttack && !this.m_transformedSpecial)
         {
            this.FinalSmashMeterCharge += param1 / 200;
         }
         super.dealDamage(param1);
      }
      
      private function m_pushAwayOpponents() : void
      {
         var _loc1_:Vector.<HitBoxCollisionResult> = null;
         var _loc2_:Character = null;
         var _loc3_:int = 0;
         while(_loc3_ < STAGEDATA.Characters.length)
         {
            _loc1_ = null;
            _loc2_ = STAGEDATA.Characters[_loc3_];
            if(!(_loc2_ === this || !m_collision.ground || !_loc2_.CollisionObj.ground || !InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster,null,true).length))
            {
               if(InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.HIT,HitBoxSprite.HIT,reactionMaster,null,true).length > 0)
               {
                  if(inState(CState.LEDGE_ROLL) || inState(CState.LEDGE_CLIMB) || inState(CState.ATTACKING) && m_attack.Frame == "ledge_attack")
                  {
                     _loc2_.pushAway(m_facingForward);
                  }
                  else if(m_sprite.x < _loc2_.X)
                  {
                     _loc2_.pushAway(true);
                  }
                  else
                  {
                     _loc2_.pushAway(false);
                  }
               }
            }
            _loc3_++;
         }
      }
      
      public function m_pushAwayItems() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Vector.<HitBoxCollisionResult> = null;
         var _loc3_:Item = null;
         var _loc4_:Rectangle = null;
         var _loc5_:Rectangle = null;
         if(m_collision.ground)
         {
            _loc1_ = 0;
            while(_loc1_ < STAGEDATA.ItemsRef.ItemsInUse.length)
            {
               _loc2_ = null;
               _loc3_ = STAGEDATA.ItemsRef.ItemsInUse[_loc1_];
               if(!(!_loc3_ || _loc3_.Dead || _loc3_.PickedUp || !_loc3_.Ground || !InteractiveSprite.hitTest(this,_loc3_,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster).length))
               {
                  _loc4_ = _loc3_.BoundsRect;
                  _loc5_ = BoundsRect;
                  _loc4_.x += _loc3_.X;
                  _loc4_.y += _loc3_.Y;
                  _loc5_.x += m_sprite.x;
                  _loc5_.y += m_sprite.y;
                  if(_loc4_.intersects(_loc5_))
                  {
                     if(m_sprite.x > _loc3_.X)
                     {
                        _loc3_.pushAway(false);
                     }
                     else if(m_sprite.x < _loc3_.X)
                     {
                        _loc3_.pushAway(true);
                     }
                     else if(m_sprite.x == _loc3_.X)
                     {
                        if(_loc3_.ItemStats.PushCharacters)
                        {
                           this.pushAway(false);
                        }
                        _loc3_.pushAway(true);
                     }
                  }
               }
               _loc1_++;
            }
         }
      }
      
      public function pushAway(param1:Boolean, param2:int = 1) : void
      {
         if(m_collision.ground && !inState(CState.LEDGE_HANG) && !this.m_standby && !inState(CState.INJURED) && !inState(CState.CROUCH) && !inState(CState.FLYING) && !inState(CState.ATTACKING) && !inState(CState.STUNNED) && !inState(CState.DIZZY) && !inState(CState.PITFALL) && !inState(CState.WALL_CLING) && !inState(CState.SLEEP) && !this.m_transformingSpecial && !this.m_usingSpecialAttack && !inState(CState.SHIELDING) && !inState(CState.DODGE_ROLL) && !inState(CState.AIR_DODGE) && !inState(CState.SIDESTEP_DODGE) && !inState(CState.TAUNT) && !inState(CState.FROZEN) && !inState(CState.CAUGHT) && !inState(CState.BARREL) && !this.isLandingOrSkiddingOrChambering() && !inState(CState.LEDGE_ROLL) && !inState(CState.TECH_GROUND) && !inState(CState.TECH_ROLL) && !inState(CState.LEDGE_CLIMB) && !inState(CState.GRABBING) && !inState(CState.KIRBY_STAR) && m_xSpeed == 0 && !this.m_charIsFull && !isIntangible())
         {
            if(param1 && !m_collision.rightSide)
            {
               this.m_attemptToMove(param2,0);
            }
            else if(!param1 && !m_collision.leftSide)
            {
               this.m_attemptToMove(-param2,0);
            }
         }
      }
      
      public function pushAwayFromWalls() : void
      {
         if(!inState(CState.FLYING) && !m_collision.ground && Boolean(testTerrainWithCoord(m_sprite.x - m_width / 2 * m_sizeRatio,m_sprite.y - m_height * m_sizeRatio)))
         {
            this.m_attemptToMove(6 - m_xSpeed / 2,0);
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.HIT_WALL,{
               "caller":this.APIInstance.instance,
               "left":m_xSpeed < 0,
               "right":m_xSpeed > 0,
               "top":false
            }));
         }
         if(!inState(CState.FLYING) && !m_collision.ground && Boolean(testTerrainWithCoord(m_sprite.x + m_width / 2 * m_sizeRatio,m_sprite.y - m_height * m_sizeRatio)))
         {
            this.m_attemptToMove(-6 - m_xSpeed / 2,0);
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.HIT_WALL,{
               "caller":this.APIInstance.instance,
               "left":m_xSpeed < 0,
               "right":m_xSpeed > 0,
               "top":false
            }));
         }
      }
      
      public function getCharacterStat(param1:String) : *
      {
         return this.m_characterStats.getVar(param1);
      }
      
      public function getPlayerSetting(param1:String) : *
      {
         return this.m_playerSettings.getVar(param1);
      }
      
      public function updateCharacterStats(param1:Object) : void
      {
         this.m_characterStats.importData(param1);
         if(param1)
         {
            if(param1.linkage_id)
            {
               this.setStats(this.m_characterStats);
            }
            else if(Boolean(param1.seriesIcon) || Boolean(param1.displayName) || Boolean(param1.thumbnail))
            {
               this.redrawHealthBox();
            }
            this.syncStats();
         }
      }
      
      public function updatePlayerSettings(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Object = {
            "level":true,
            "damageRatio":true,
            "attackRatio":true,
            "x_start":true,
            "y_start":true,
            "x_respawn":true,
            "y_respawn":true,
            "unlimitedFinal":true,
            "finalSmashMeter":true,
            "startDamage":true
         };
         var _loc4_:Array = [];
         for(_loc2_ in param1)
         {
            if(!_loc3_[_loc2_])
            {
               _loc4_.push(_loc2_);
            }
         }
         while(_loc4_.length > 0)
         {
            delete param1[_loc4_[0]];
            _loc4_.splice(0,1);
         }
         this.m_playerSettings.importSettings(param1);
         if(Boolean(param1.level) && Boolean(this.CPU))
         {
            this.CPU = new AI(this.m_playerSettings.level,this,STAGEDATA);
         }
         this.m_characterStats.importData({
            "attackRatio":this.m_playerSettings.attackRatio,
            "damageRatio":this.m_playerSettings.damageRatio,
            "unlimitedFinal":this.m_playerSettings.unlimitedFinal,
            "startDamage":this.m_playerSettings.startDamage,
            "finalSmashMeter":this.m_playerSettings.finalSmashMeter
         });
      }
      
      public function getActiveProjectiles(param1:int, param2:int) : Vector.<Projectile>
      {
         var _loc4_:int = 0;
         var _loc3_:Vector.<Projectile> = new Vector.<Projectile>();
         while(_loc4_ < this.m_projectile.length)
         {
            if(this.m_projectile[_loc4_] != null && !this.m_projectile[_loc4_].Dead && (this.m_projectile[_loc4_].ID != param1 && !(param2 > 0 && this.m_projectile[_loc4_].TeamID > 0 && this.m_projectile[_loc4_].TeamID == param2) || Boolean(this.m_projectile[_loc4_].WasReversed)))
            {
               _loc3_.push(this.m_projectile[_loc4_]);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function getCurrentProjectile() : Projectile
      {
         if(this.m_lastProjectile >= 0 && this.m_lastProjectile < this.m_projectile.length)
         {
            return this.m_projectile[this.m_lastProjectile];
         }
         return null;
      }
      
      public function getCurrentProjectileAPI() : *
      {
         if(this.m_lastProjectile >= 0 && this.m_lastProjectile < this.m_projectile.length && Boolean(this.m_projectile[this.m_lastProjectile]))
         {
            return this.m_projectile[this.m_lastProjectile].APIInstance.instance;
         }
         return null;
      }
      
      public function getProjectile(param1:Number) : Projectile
      {
         if(param1 >= 0 && param1 < this.m_projectile.length)
         {
            return this.m_projectile[param1];
         }
         return null;
      }
      
      override public function getProjectiles() : Array
      {
         var _loc2_:int = 0;
         var _loc1_:Array = new Array();
         while(_loc2_ < this.m_projectile.length)
         {
            if(Boolean(this.m_projectile[_loc2_]) && !this.m_projectile[_loc2_].Dead)
            {
               _loc1_.push(this.m_projectile[_loc2_]);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function getProjectileLimit(param1:String) : Number
      {
         var _loc3_:int = 0;
         var _loc2_:Number = 0;
         while(_loc3_ < this.m_projectile.length)
         {
            if(this.m_projectile[_loc3_] != null && !this.m_projectile[_loc3_].inState(PState.DEAD) && (Boolean(this.m_projectile[_loc3_].LinkageID == param1) || Boolean(this.m_projectile[_loc3_].getProjectileStat("statsName") && this.m_projectile[_loc3_].getProjectileStat("statsName") == param1)))
            {
               _loc2_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      protected function updateLivesDisplay() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         if(Boolean(m_healthBoxMC && !inState(CState.DEAD)) && Boolean(this.m_usingLives) && this.m_lastLivesTextNum !== this.m_lives)
         {
            m_healthBoxMC.lives.text = this.m_lives > 0 ? "x" + this.m_lives : "";
            this.m_lastLivesTextNum = this.m_lives;
            if(Boolean(Config.enable_new_stock_counter) && Boolean(m_healthBoxMC.stockiconsingle))
            {
               _loc1_ = 0;
               while(_loc1_ < this.MAX_STOCK_ICONS)
               {
                  _loc3_ = m_healthBoxMC.getChildByName("stockicon" + _loc1_) as MovieClip;
                  if(Boolean(_loc3_) && _loc3_.numChildren > 0)
                  {
                     _loc3_.removeChildAt(0);
                  }
                  _loc1_++;
               }
               if(m_healthBoxMC.stockiconsingle.numChildren > 0)
               {
                  m_healthBoxMC.stockiconsingle.removeChildAt(0);
               }
               if(this.m_lives <= this.MAX_STOCK_ICONS)
               {
                  _loc1_ = 0;
                  while(_loc1_ < this.m_lives)
                  {
                     _loc3_ = m_healthBoxMC.getChildByName("stockicon" + _loc1_) as MovieClip;
                     if(_loc3_)
                     {
                        Utils.setBrightness(_loc3_,-15 * (this.m_lives - (_loc1_ + 1)));
                        _loc2_ = ResourceManager.getLibraryMC(this.m_characterStats.StatsName + "_stock");
                        if(!_loc2_)
                        {
                           m_healthBoxMC.lives.visible = true;
                           m_healthBoxMC.lives.x = 44;
                           m_healthBoxMC.lives.y = -18.6;
                           return;
                        }
                        _loc3_.addChild(_loc2_);
                        applyPalette(_loc2_);
                        Utils.replacePalette(_loc2_,m_paletteSwapData || Utils.EMPTY_PALETTE_SWAP,2,false,true);
                     }
                     _loc1_++;
                  }
                  m_healthBoxMC.lives.visible = false;
               }
               else
               {
                  m_healthBoxMC.lives.visible = true;
                  _loc3_ = m_healthBoxMC.getChildByName("stockiconsingle") as MovieClip;
                  _loc2_ = ResourceManager.getLibraryMC(this.m_characterStats.StatsName + "_stock");
                  if(!_loc2_)
                  {
                     m_healthBoxMC.lives.x = 44;
                     m_healthBoxMC.lives.y = -18.6;
                     return;
                  }
                  _loc3_.addChild(_loc2_);
                  applyPalette(_loc2_);
                  Utils.replacePalette(_loc2_,m_paletteSwapData,2,false,true);
               }
            }
            else
            {
               m_healthBoxMC.lives.x = 44;
               m_healthBoxMC.lives.y = -18.6;
            }
         }
      }
      
      private function applySpecialModeEffects() : void
      {
         if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.MINI))
         {
            this.setSizeStatus(-1);
            this.m_sizeStatusPermanent = true;
         }
         else if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.MEGA))
         {
            this.setSizeStatus(1);
            this.m_sizeStatusPermanent = true;
         }
         if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.METAL))
         {
            this.setMetalStatus(true);
         }
         if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.LIGHT))
         {
            m_gravity /= 2;
            m_max_ySpeed /= 2;
         }
         else if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.HEAVY))
         {
            m_gravity *= 2;
            m_max_ySpeed *= 2;
         }
      }
      
      public function forceOnGround() : void
      {
         this.m_pressedControls.DOWN = false;
         var _loc1_:Number = 0;
         while(!(m_currentPlatform = STAGEDATA.testGroundWithCoord(m_sprite.x,m_sprite.y + 1)) && _loc1_ < 400)
         {
            ++m_sprite.y;
            _loc1_++;
         }
         if(!m_currentPlatform)
         {
            trace("what happened?");
            m_sprite.y = this.m_playerSettings.y_start;
         }
         else
         {
            m_collision.ground = true;
            attachToGround();
         }
      }
      
      private function m_checkInvincible() : void
      {
         if(this.isInvincible() || isIntangible())
         {
            ++this.m_blinkTimer;
            setBrightness(this.m_invincibleBrightness);
            this.m_invincibleBrightness += this.m_invincibleUp ? 3 : -3;
            this.m_invincibleUp = Boolean(this.m_invincibleUp) && this.m_invincibleBrightness >= 50 ? false : (!this.m_invincibleUp && this.m_invincibleBrightness <= 15 ? true : Boolean(this.m_invincibleUp));
         }
      }
      
      private function m_checkStun() : void
      {
         if(inState(CState.STUNNED))
         {
            this.m_stunCancelTimer.tick();
            if(!m_collision.ground && Boolean(this.m_stunCancelTimer.IsComplete))
            {
               this.setState(CState.TUMBLE_FALL);
            }
            else if(m_collision.ground)
            {
               this.m_stunCancelTimer.finish();
               --this.m_stunTimer;
               if(this.m_stunTimer <= 0)
               {
                  this.m_stunTimer = 0;
                  this.setState(CState.IDLE);
               }
            }
         }
      }
      
      private function m_checkDizzy() : void
      {
         var _loc1_:int = 0;
         if(inState(CState.DIZZY))
         {
            this.m_stunCancelTimer.tick();
            if(!m_collision.ground && Boolean(this.m_stunCancelTimer.IsComplete) && !this.m_dizzyShield)
            {
               this.setState(CState.TUMBLE_FALL);
            }
            else if(m_collision.ground)
            {
               this.m_stunCancelTimer.finish();
               --this.m_dizzyTimer;
               if(!this.m_dizzyShield)
               {
                  _loc1_ = this.Struggle(3);
                  this.m_dizzyTimer -= _loc1_ > 0 ? _loc1_ : 1;
               }
               if(this.m_dizzyTimer <= 0)
               {
                  this.m_dizzyTimer = 0;
                  this.setState(CState.IDLE);
               }
            }
         }
      }
      
      private function m_checkPitfall() : void
      {
         var _loc1_:int = 0;
         if(inState(CState.PITFALL))
         {
            _loc1_ = this.Struggle(3);
            this.m_pitfallTimer -= _loc1_ > 0 ? _loc1_ : 1;
            this.m_pitfallEffect.x = m_sprite.x;
            this.m_pitfallEffect.y = m_sprite.y;
            if(this.m_pitfallTimer <= 0)
            {
               this.pitFallRelease();
               toggleEffect(this.m_pitfallEffect,false);
            }
         }
      }
      
      private function pitFallRelease() : void
      {
         this.m_pitfallTimer = 0;
         this.unnattachFromGround();
         m_ySpeed = -this.m_characterStats.JumpSpeed / 2;
         this.setState(CState.IDLE);
      }
      
      public function freeze(param1:Boolean, param2:int = -1) : void
      {
         if(inState(CState.BARREL))
         {
            return;
         }
         if(param1)
         {
            if(this.m_grabbed.length > 0)
            {
               this.grabReleaseOpponent();
            }
            if(inState(CState.CAUGHT) && this.m_grabberID >= 0)
            {
               STAGEDATA.getCharacterByUID(this.m_grabberID).setState(CState.IDLE);
            }
            this.setState(CState.FROZEN);
            toggleEffect(this.m_freezeMC,true);
            this.m_freezeMC.x = m_sprite.x;
            this.m_freezeMC.y = m_sprite.y;
            this.m_freezeMC.rotation = m_sprite.rotation;
            this.m_freezeMC.scaleX = m_sprite.scaleX;
            this.m_freezeMC.scaleY = m_sprite.scaleY;
            this.m_frozenTimer = param2;
            this.resetRotation();
            this.killAllSpeeds(false,true);
            Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
         }
         else if(!param1)
         {
            this.m_frozenTimer = 0;
            this.setState(CState.INJURED);
            toggleEffect(this.m_freezeMC,false);
            this.unnattachFromGround();
            m_yKnockback = -10;
            resetKnockbackDecay();
            this.m_hitLag = this.calculateHitLag(10,-1);
         }
      }
      
      private function m_checkFrozen() : void
      {
         var _loc1_:int = 0;
         if(inState(CState.FROZEN))
         {
            if(!m_collision.ground)
            {
               m_sprite.rotation += m_facingForward ? -2 : 2;
            }
            --this.m_frozenTimer;
            _loc1_ = this.Struggle();
            this.m_frozenTimer -= _loc1_;
            if(_loc1_ > 0)
            {
               m_sprite.stance.x += Utils.random() > 0.5 ? -1 : 1;
               m_sprite.stance.y += Utils.random() > 0.5 ? -1 : 1;
            }
            if(this.m_frozenTimer <= 0)
            {
               this.freeze(false);
               this.attachEffect("freeze_break");
            }
         }
      }
      
      private function m_checkSleeping() : void
      {
         var _loc1_:int = 0;
         if(inState(CState.SLEEP))
         {
            this.m_stunCancelTimer.tick();
            if(!m_collision.ground && Boolean(this.m_stunCancelTimer.IsComplete))
            {
               this.setState(CState.TUMBLE_FALL);
            }
            else if(m_collision.ground)
            {
               this.m_stunCancelTimer.finish();
               --this.m_sleepingTimer;
               _loc1_ = this.Struggle(3);
               this.m_sleepingTimer -= _loc1_ > 0 ? _loc1_ : 1;
               if(this.m_sleepingTimer <= 0)
               {
                  this.m_sleepingTimer = 0;
                  this.setState(CState.IDLE);
               }
            }
         }
      }
      
      public function egg(param1:Boolean, param2:int = -1) : void
      {
         if(inState(CState.BARREL))
         {
            return;
         }
         if(param1)
         {
            if(this.m_grabbed.length > 0)
            {
               this.grabReleaseOpponent();
            }
            if(inState(CState.CAUGHT) && this.m_grabberID >= 0)
            {
               STAGEDATA.getCharacterByUID(this.m_grabberID).setState(CState.IDLE);
            }
            this.setState(CState.EGG);
            this.m_yoshiEggMC.x = m_sprite.x;
            this.m_yoshiEggMC.y = m_sprite.y;
            this.m_yoshiEggMC.stance.gotoAndStop("idle");
            toggleEffect(this.m_yoshiEggMC,true);
            if(param2 > -1)
            {
               this.m_eggTimer = param2;
            }
            else
            {
               this.m_eggTimer = Math.round(90 + Math.floor(m_damage / 2.5)) / 2;
               if(this.m_eggTimer > 210)
               {
                  this.m_eggTimer = 210;
               }
            }
            this.resetRotation();
            Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
            this.unnattachFromGround();
         }
         else if(!param1)
         {
            this.setVisibility(true);
            toggleEffect(this.m_yoshiEggMC,false);
            this.m_eggTimer = 0;
            this.unnattachFromGround();
            m_ySpeed = -this.m_characterStats.JumpSpeed / 2;
            this.setState(CState.IDLE);
         }
      }
      
      private function m_checkEgg() : void
      {
         var _loc1_:int = 0;
         if(inState(CState.EGG))
         {
            this.setVisibility(false);
            --this.m_eggTimer;
            _loc1_ = this.Struggle();
            this.m_eggTimer -= _loc1_;
            if(this.m_eggTimer < 12 && this.m_yoshiEggMC.stance.currentLabel !== "break")
            {
               this.m_yoshiEggMC.stance.gotoAndStop("break");
            }
            else if(_loc1_ > 0 && this.m_yoshiEggMC.stance.currentLabel !== "mash" && this.m_yoshiEggMC.stance.currentLabel !== "break")
            {
               this.m_yoshiEggMC.stance.gotoAndStop("mash");
            }
            if(this.m_yoshiEggMC.stance.currentLabel !== "break")
            {
               this.m_yoshiEggMC.gotoAndPlay(Math.min(this.m_yoshiEggMC.stance.currentFrame + _loc1_,this.m_yoshiEggMC.stance.totalFrames));
            }
            if(this.m_eggTimer <= 0)
            {
               this.egg(false);
               this.attachEffect("yoshi_egg_break");
            }
         }
      }
      
      override public function resetRotation() : void
      {
         if(!inState(CState.FROZEN))
         {
            super.resetRotation();
            this.updateItemHolding();
         }
      }
      
      override public function setRotation(param1:Number) : void
      {
         super.setRotation(param1);
         this.updateItemHolding();
      }
      
      public function getTetherCount() : int
      {
         return this.m_tetherCount;
      }
      
      private function resetSpeedLevel() : void
      {
         this.m_runningSpeedLevel = false;
         this.m_speedTimer = 0;
      }
      
      private function resetBufferedCStick() : void
      {
         this.m_c_buffered_down = false;
         this.m_c_buffered_left = false;
         this.m_c_buffered_right = false;
      }
      
      private function alternateBlink() : void
      {
         if(this.m_blinkOn)
         {
            setBrightness(0);
         }
         else
         {
            setBrightness(-35);
         }
         this.m_blinkOn = !this.m_blinkOn;
         this.m_blinkTimer = 0;
      }
      
      override public function setVisibility(param1:Boolean) : void
      {
         super.setVisibility(param1);
         this.m_burnSmoke.visible = param1;
         this.m_darknessSmoke.visible = param1;
         this.m_auraSmoke.visible = param1;
         this.m_poisonEffect.visible = param1;
         this.m_healEffect.visible = param1;
         if(this.m_warioWareIcon)
         {
            this.m_warioWareIcon.visible = param1;
         }
         this.m_starmanInvincibility.visible = param1;
         this.m_hatMC.visible = param1;
         if(this.m_item)
         {
            this.m_item.setVisibility(param1);
         }
         if(this.m_fsGlowHolderMC)
         {
            this.m_fsGlowHolderMC.visible = param1;
         }
         if(this.m_chargeGlowHolderMC)
         {
            this.m_chargeGlowHolderMC.visible = param1;
         }
      }
      
      override public function setDamage(param1:Number) : void
      {
         var _loc2_:Number = m_damage;
         if(m_baseStats.Stamina > 0)
         {
            if(m_damage > 0 && param1 <= 0 && (this.isGrabbedByFinalSmash() || this.UsingFinalSmash))
            {
               param1 = 0.1;
            }
            else if(param1 >= m_baseStats.Stamina)
            {
               m_damage = m_baseStats.Stamina;
            }
         }
         super.setDamage(param1);
         if(m_baseStats.Stamina <= 0 && m_damage > this.m_matchResults.PeakDamage && !STAGEDATA.GameEnded)
         {
            this.m_matchResults.PeakDamage = m_damage;
         }
      }
      
      public function reset() : void
      {
         var _loc4_:MovieClip = null;
         var _loc5_:String = null;
         var _loc6_:Vector.<MovieClip> = null;
         var _loc1_:Vector.<MovieClip> = new Vector.<MovieClip>();
         _loc1_.push(m_sprite);
         STAGEDATA.CamRef.deleteTargets(_loc1_);
         this.setVisibility(false);
         if(!this.m_sizeStatusPermanent)
         {
            m_sizeRatio = this.m_originalSizeRatio;
         }
         if(this.m_sizeStatus != 0)
         {
            this.setSizeStatus(0);
         }
         if(Boolean(this.m_isMetal) && !SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.METAL))
         {
            this.setMetalStatus(false);
         }
         this.hideAllEffects();
         this.m_chargeGlowHolderMC = null;
         this.m_burnSmokeTimer.finish();
         this.m_darknessSmokeTimer.finish();
         this.m_auraSmokeTimer.finish();
         this.m_starmanInvincibilityTimer.finish();
         this.m_burnSmokeTimer.finish();
         this.m_darknessSmokeTimer.finish();
         this.m_auraSmokeTimer.finish();
         this.m_wallStickTime.MaxTime = this.m_characterStats.WallStick;
         this.m_wallClingDelay;
         m_attackData.resetDisabledAttacks();
         this.turnOffInvincibility();
         this.stopActionShot();
         this.releaseOpponent();
         this.m_crowdAwe = false;
         this.m_lastLedge = null;
         this.m_revivalTimer = 150;
         this.m_respawnDelay.reset();
         this.resetStaleMoves();
         this.m_waveLand = false;
         this.m_waveDashPenalty = 0;
         if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
         {
            this.m_respawnDelay.finish();
         }
         this.m_recoveryAmount = 0;
         if(m_healthBoxMC)
         {
            m_healthBoxMC.damageMC_holder.visible = false;
            m_healthBoxMC.percent_mc.damage.visible = false;
         }
         this.m_justReleased = false;
         this.m_jumpStartup.reset();
         this.setDamage(STAGEDATA.GameRef.GameMode == Mode.TRAINING && m_player_id > 1 ? Number(GameController.hud.CpuDamage) : (this.m_characterStats.Stamina > 0 ? Number(this.m_characterStats.Stamina) : Number(this.m_characterStats.StartDamage)));
         this.m_charIsFull = false;
         this.setState(CState.IDLE);
         this.m_shieldPower = 100;
         this.m_poisonIncreaseTime.reset();
         this.m_poisonIncrease = 0;
         if(Boolean(this.m_usingSpecialAttack) || Boolean(this.m_transformedSpecial))
         {
            if(this.m_characterStats.FinalSmashMeter)
            {
               this.FinalSmashMeterCharge = 0;
            }
            this.killFSCutscene();
            if(this.m_transformedSpecial)
            {
               STAGEDATA.ItemsRef.SmashBallReady.CurrentTime = STAGEDATA.ItemsRef.SmashBallReady.MaxTime;
            }
            STAGEDATA.brightenCamera();
         }
         else if(this.m_characterStats.FinalSmashMeter)
         {
            if(this.m_item2)
            {
               this.FinalSmashMeterCharge = 0;
            }
            else if(m_player_id > 0 && Boolean(this.m_finalSmashMeterReady))
            {
               STAGEDATA.updateRanks();
               if(this.m_matchResults.Rank > 1 || STAGEDATA.GameRef.GameMode == Mode.TRAINING)
               {
                  this.FinalSmashMeterCharge *= 0.9;
               }
               else
               {
                  this.FinalSmashMeterCharge *= 0.6;
               }
            }
            else if(this.m_finalSmashMeterReady)
            {
               this.FinalSmashMeterCharge *= 0.6;
            }
         }
         this.m_usingSpecialAttack = false;
         m_facingForward = true;
         this.m_glideReady = true;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         if(this.m_transformedSpecial)
         {
            this.replaceCharacter(this.m_characterStats.DeathSwitchID != null ? this.m_characterStats.DeathSwitchID : this.m_characterStats.NormalStatsID,"fall");
            if(Boolean(m_healthBoxMC) && !this.m_characterStats.FinalSmashMeter)
            {
               m_healthBoxMC.fsmeter.visible = false;
            }
         }
         else if(this.m_characterStats.DeathSwitchID != null)
         {
            this.replaceCharacter(this.m_characterStats.DeathSwitchID,"fall");
            if(Boolean(m_healthBoxMC) && !this.m_characterStats.FinalSmashMeter)
            {
               m_healthBoxMC.fsmeter.visible = false;
            }
         }
         m_attackData.resetDisabledAttacks();
         m_faceRight();
         this.m_currentPower = null;
         this.m_transformingSpecial = false;
         this.m_transformedSpecial = false;
         this.m_crouchFrame = -1;
         this.m_deactivateShield();
         this.m_ledge = null;
         m_collision.ground = false;
         m_collision.lbound_lower = false;
         m_collision.rbound_lower = false;
         m_collision.lbound_upper = false;
         m_collision.rbound_upper = false;
         Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
         this.resetRotation();
         this.resetChargedAttacks();
         m_attack.Rocket = false;
         m_attackData.resetCharges();
         this.removeChargeGlow();
         this.killAllSpeeds();
         this.m_jumpCount = 0;
         this.m_airDodgeCount = 0;
         this.m_canHover = true;
         this.m_midAirJumpConstantTime.finish();
         this.m_comboCount = 0;
         if(this.m_item != null)
         {
            STAGEDATA.ItemsRef.killItem(this.m_item.Slot);
            this.m_item = null;
         }
         if(STAGEPARENT.getChildByName("energy" + m_player_id) != null)
         {
            STAGEPARENT.removeChild(STAGEPARENT.getChildByName("energy" + m_player_id));
         }
         if(this.m_item2 != null)
         {
            this.m_item2.destroy();
            this.m_item2 = null;
         }
         if(!this.m_human)
         {
            this.CPU.resetControlOverrides();
         }
         m_currentPlatform = null;
      }
      
      public function turnOffInvincibility() : void
      {
         m_invincible = false;
         m_intangible = false;
         setBrightness(0);
      }
      
      public function setHumanControl(param1:Boolean, param2:Number) : void
      {
         this.m_playerSettings.level = param2;
         if(param1)
         {
            this.CPU = null;
            this.m_human = true;
         }
         else
         {
            this.CPU = new AI(this.m_playerSettings.level,this,STAGEDATA);
            this.CPU.refreshRecoveryAttackList();
            this.m_human = false;
         }
      }
      
      private function compactControlsBuffer() : void
      {
         var _loc2_:* = 0;
         var _loc1_:int = ControlsObject.TAP_JUMP | ControlsObject.DT_DASH | ControlsObject.AUTO_DASH;
         while(_loc2_ < this.m_pressedControlsBuffer.length)
         {
            if(ControlsObject.getControls(this.m_pressedControlsBuffer[_loc2_],_loc1_) === 0)
            {
               this.m_pressedControlsBuffer.splice(_loc2_,1);
               this.m_heldControlsBuffer.splice(_loc2_,1);
               _loc2_--;
            }
            _loc2_++;
         }
      }
      
      private function clearControlsBuffer() : void
      {
         this.m_pressedControlsBuffer.splice(0);
         this.m_heldControlsBuffer.splice(0);
      }
      
      private function controlsBufferContains(param1:int) : Boolean
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.m_pressedControlsBuffer.length)
         {
            if((this.m_pressedControlsBuffer[_loc3_] & param1) > 0)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      private function isBufferableState(param1:uint) : Boolean
      {
         return param1 === CState.ATTACKING && !m_attack.IASA || param1 === CState.LAND || param1 === CState.JUMP_CHAMBER || param1 === CState.LEDGE_ROLL || param1 === CState.LEDGE_CLIMB || param1 === CState.TECH_GROUND || param1 === CState.TECH_ROLL || param1 === CState.ROLL || param1 === CState.DODGE_ROLL || param1 === CState.AIR_DODGE || param1 === CState.CRASH_GETUP || param1 === CState.SHIELD_DROP || param1 === CState.HEAVY_LAND || param1 === CState.SKID || param1 === CState.ITEM_TOSS || param1 === CState.INJURED || param1 === CState.FLYING || param1 === CState.SHIELDING && !this.m_shieldDelayTimer.IsComplete || param1 === CState.GRABBING && !this.m_grabbed.length || param1 === CState.LEDGE_HANG && this.m_ledgeHangTimer.CurrentTime <= 4;
      }
      
      private function updateControlsBuffer() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:ControlsObject = this.m_human ? this.m_key.getControlsObject() : this.CPU.ControlsObj;
         if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
         {
            _loc2_.SHIELD = false;
            _loc2_.SHIELD2 = false;
            _loc2_.GRAB = false;
            _loc2_.BUTTON2 = _loc2_.BUTTON2 || _loc2_.BUTTON1 || _loc2_.C_UP || _loc2_.C_DOWN || _loc2_.C_LEFT || _loc2_.C_RIGHT;
            _loc2_.C_UP = false;
            _loc2_.C_DOWN = false;
            _loc2_.C_LEFT = false;
            _loc2_.C_RIGHT = false;
         }
         var _loc3_:int = ControlsObject.TAP_JUMP | ControlsObject.DT_DASH | ControlsObject.AUTO_DASH;
         this.m_heldControls.controls = _loc2_.controls;
         var _loc4_:int = int(ControlsObject.getControls(this.m_heldControls.controls,_loc3_));
         if(this.isBufferableState(m_state))
         {
            if(!m_collision.ground && (inState(CState.INJURED) || inState(CState.FLYING)))
            {
               _loc3_ |= ControlsObject.BUTTON1;
               _loc3_ |= ControlsObject.BUTTON2;
               _loc3_ |= ControlsObject.GRAB;
            }
            if(inState(CState.SHIELDING) && !this.m_shieldDelayTimer.IsComplete)
            {
               _loc3_ |= ControlsObject.LEFT;
               _loc3_ |= ControlsObject.RIGHT;
               _loc3_ |= ControlsObject.DOWN;
               if(this.m_lastHitStun > 5)
               {
                  _loc1_ = Boolean(this.controlsBufferContains(ControlsObject.GRAB));
                  this.pruneControlsBuffer(ControlsObject.GRAB | (!_loc1_ ? ControlsObject.JUMP : 0) | (!_loc1_ ? ControlsObject.JUMP : 0));
                  if(_loc1_)
                  {
                     _loc3_ |= ControlsObject.JUMP;
                     _loc3_ |= ControlsObject.JUMP2;
                     _loc3_ |= ControlsObject.JUMP3;
                  }
               }
            }
         }
         else
         {
            this.compactControlsBuffer();
         }
         var _loc5_:int = int(ControlsObject.getControls(_loc2_.controls,_loc3_));
         var _loc6_:int = ControlsObject.UP & _loc4_ | ControlsObject.DOWN & _loc4_ | ControlsObject.LEFT & _loc4_ | ControlsObject.RIGHT & _loc4_;
         var _loc7_:int = 5;
         if(STAGEDATA.OnlineMode)
         {
            _loc7_ -= MultiplayerManager.INPUT_BUFFER;
         }
         else if(STAGEDATA.ReplayMode)
         {
            _loc7_ -= STAGEDATA.GameRef.LevelData.inputBuffer;
         }
         if(this.m_pressedControlsBuffer.length > _loc7_)
         {
            this.m_pressedControlsBuffer.pop();
            this.m_heldControlsBuffer.pop();
         }
         if(this.isBufferableState(m_state))
         {
            if(!((_loc4_ & (ControlsObject.BUTTON1 | ControlsObject.BUTTON2)) > 0 || (_loc6_ & _loc5_) > 0))
            {
               _loc6_ = 0;
            }
         }
         _loc5_ |= _loc6_;
         var _loc8_:int = this.m_heldKeyHistory.controls ^ _loc5_;
         var _loc9_:int = _loc8_ & this.m_heldKeyHistory.controls;
         _loc5_ = _loc8_ ^ _loc9_;
         this.m_heldControls.controls = _loc4_ | (_loc2_.TAP_JUMP ? ControlsObject.TAP_JUMP : 0) | (_loc2_.AUTO_DASH ? ControlsObject.AUTO_DASH : 0) | (_loc2_.DT_DASH ? ControlsObject.DT_DASH : 0);
         this.m_pressedControls.controls = _loc5_ | (_loc2_.TAP_JUMP ? ControlsObject.TAP_JUMP : 0) | (_loc2_.AUTO_DASH ? ControlsObject.AUTO_DASH : 0) | (_loc2_.DT_DASH ? ControlsObject.DT_DASH : 0);
         this.m_pressedControlsBuffer.unshift(_loc5_);
         this.m_heldControlsBuffer.unshift(this.m_heldControls.controls);
         this.m_heldKeyHistory.controls = this.m_heldControls.controls;
         if(m_player_id === 1)
         {
         }
         if(this.m_pressedControlsBuffer.length !== this.m_heldControlsBuffer.length)
         {
            trace("Warning: Buffers are out of sync!!");
         }
      }
      
      private function pruneControlsBuffer(param1:int = 0) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         param1 |= ControlsObject.TAP_JUMP;
         param1 |= ControlsObject.DT_DASH;
         param1 |= ControlsObject.AUTO_DASH;
         while(_loc3_ < this.m_pressedControlsBuffer.length)
         {
            this.m_pressedControlsBuffer[_loc3_] = ControlsObject.getControls(this.m_pressedControlsBuffer[_loc3_],param1);
            this.m_heldControlsBuffer[_loc3_] = ControlsObject.getControls(this.m_heldControlsBuffer[_loc3_],param1);
            _loc3_++;
         }
      }
      
      private function validateControlsBuffer() : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         _loc3_ |= ControlsObject.TAP_JUMP;
         _loc3_ |= ControlsObject.DT_DASH;
         _loc3_ |= ControlsObject.AUTO_DASH;
         var _loc4_:int = ControlsObject.UP | ControlsObject.DOWN | ControlsObject.LEFT | ControlsObject.RIGHT;
         while(_loc6_ < this.m_pressedControlsBuffer.length)
         {
            _loc2_ = int(ControlsObject.getControls(this.m_pressedControlsBuffer[_loc6_],_loc3_));
            if(_loc2_ - (_loc4_ & _loc2_) > 0)
            {
               _loc5_ = true;
               break;
            }
            _loc6_++;
         }
         if(!_loc5_)
         {
            this.clearControlsBuffer();
         }
      }
      
      private function processControlsBuffer() : void
      {
         var _loc1_:Object = {};
         if(!this.isBufferableState(m_state))
         {
            if(this.m_pressedControlsBuffer.length)
            {
               this.m_pressedControls.controls = this.m_pressedControlsBuffer[this.m_pressedControlsBuffer.length - 1];
               this.m_heldControls.controls = this.m_heldControlsBuffer[this.m_heldControlsBuffer.length - 1];
               if(!(inState(CState.SHIELDING) && this.m_shieldTimer < 1))
               {
                  this.m_pressedControlsBuffer.pop();
                  this.m_heldControlsBuffer.pop();
               }
            }
         }
      }
      
      private function m_getKey() : void
      {
         if(!STAGEDATA.FreezeKeys && !STAGEDATA.StageEvent)
         {
            if(this.m_human)
            {
               if(STAGEDATA.OnlineMode || STAGEDATA.ReplayMode)
               {
                  this.updateControlsBuffer();
                  this.processControlsBuffer();
                  this.m_tap_jump = this.m_key.getControlsObject().TAP_JUMP == 1;
                  this.m_auto_dash = this.m_key.getControlsObject().AUTO_DASH == 1;
                  this.m_dt_dash = this.m_key.getControlsObject().DT_DASH == 1;
               }
               else
               {
                  this.m_key.getControlsObject().controls = this.m_key.getControlStatus().controls;
                  this.updateControlsBuffer();
                  this.processControlsBuffer();
                  this.m_tap_jump = this.m_key._TAP_JUMP == 1;
                  this.m_auto_dash = this.m_key._AUTO_DASH == 1;
                  this.m_dt_dash = this.m_key._DT_DASH == 1;
               }
            }
            else if(!STAGEDATA.Paused && !STAGEDATA.FSCutscene && STAGEDATA.FSCutins <= 0)
            {
               this.CPU.getAction();
               this.updateControlsBuffer();
               this.processControlsBuffer();
               this.m_tap_jump = false;
               this.m_auto_dash = false;
               this.m_dt_dash = false;
            }
         }
         else if(!STAGEDATA.StageEvent)
         {
            this.m_pressedControls.LEFT = false;
            this.m_pressedControls.RIGHT = false;
            this.m_pressedControls.UP = false;
            this.m_pressedControls.DOWN = false;
            this.m_pressedControls.BUTTON1 = false;
            this.m_pressedControls.BUTTON2 = false;
            this.m_pressedControls.GRAB = false;
            this.m_pressedControls.JUMP = false;
            this.m_pressedControls.TAUNT = false;
            this.m_pressedControls.START = Boolean(this.m_human) && Boolean(this.m_key) ? (this.m_key.IsDown(this.m_key._START) ? true : false) : false;
            this.m_pressedControls.JUMP2 = false;
            this.m_pressedControls.C_UP = false;
            this.m_pressedControls.C_DOWN = false;
            this.m_pressedControls.C_LEFT = false;
            this.m_pressedControls.C_RIGHT = false;
            this.m_pressedControls.SHIELD = false;
            this.m_pressedControls.SHIELD2 = false;
            this.m_pressedControls.DASH = false;
            this.m_heldControls.LEFT = false;
            this.m_heldControls.RIGHT = false;
            this.m_heldControls.UP = false;
            this.m_heldControls.DOWN = false;
            this.m_heldControls.BUTTON1 = false;
            this.m_heldControls.BUTTON2 = false;
            this.m_heldControls.GRAB = false;
            this.m_heldControls.JUMP = false;
            this.m_heldControls.TAUNT = false;
            this.m_heldControls.START = Boolean(this.m_human) && Boolean(this.m_key) ? (this.m_key.IsDown(this.m_key._START) ? true : false) : false;
            this.m_heldControls.JUMP2 = false;
            this.m_heldControls.C_UP = false;
            this.m_heldControls.C_DOWN = false;
            this.m_heldControls.C_LEFT = false;
            this.m_heldControls.C_RIGHT = false;
            this.m_heldControls.SHIELD = false;
            this.m_heldControls.SHIELD2 = false;
            this.m_heldControls.DASH = false;
         }
         else
         {
            this.m_pressedControls.LEFT = false;
            this.m_pressedControls.RIGHT = false;
            this.m_pressedControls.UP = false;
            this.m_pressedControls.DOWN = false;
            this.m_pressedControls.BUTTON1 = false;
            this.m_pressedControls.BUTTON2 = false;
            this.m_pressedControls.GRAB = false;
            this.m_pressedControls.JUMP = false;
            this.m_pressedControls.TAUNT = false;
            this.m_pressedControls.START = false;
            this.m_pressedControls.JUMP2 = false;
            this.m_pressedControls.C_UP = false;
            this.m_pressedControls.C_DOWN = false;
            this.m_pressedControls.C_LEFT = false;
            this.m_pressedControls.C_RIGHT = false;
            this.m_pressedControls.SHIELD = false;
            this.m_pressedControls.SHIELD2 = false;
            this.m_pressedControls.DASH = false;
            this.m_heldControls.LEFT = false;
            this.m_heldControls.RIGHT = false;
            this.m_heldControls.UP = false;
            this.m_heldControls.DOWN = false;
            this.m_heldControls.BUTTON1 = false;
            this.m_heldControls.BUTTON2 = false;
            this.m_heldControls.GRAB = false;
            this.m_heldControls.JUMP = false;
            this.m_heldControls.TAUNT = false;
            this.m_heldControls.START = false;
            this.m_heldControls.JUMP2 = false;
            this.m_heldControls.C_UP = false;
            this.m_heldControls.C_DOWN = false;
            this.m_heldControls.C_LEFT = false;
            this.m_heldControls.C_RIGHT = false;
            this.m_heldControls.SHIELD = false;
            this.m_heldControls.SHIELD2 = false;
            this.m_heldControls.DASH = false;
         }
      }
      
      private function checkDoubleTap(param1:Number) : Boolean
      {
         var _loc2_:Boolean = false;
         switch(param1)
         {
            case 0:
               if(!m_collision.ground)
               {
                  return false;
               }
               if(Boolean(this.m_auto_dash) && !this.m_heldControls.DASH && !(inState(CState.WALK) && this.m_heldControls.RIGHT !== this.m_heldControls.LEFT))
               {
                  return true;
               }
               if(this.m_auto_dash)
               {
                  return false;
               }
               if(!this.m_dt_dash && Boolean(this.m_heldControls.DASH) && this.m_heldControls.LEFT != this.m_heldControls.RIGHT && (inState(CState.IDLE) || inState(CState.WALK) && this.m_walkTimer <= 1 || inState(CState.DASH) || inState(CState.RUN)))
               {
                  return true;
               }
               if(!this.m_dt_dash)
               {
                  return false;
               }
               if(Boolean(this.m_dt_dash) && Boolean(this.m_heldControls.DASH) && this.m_heldControls.LEFT != this.m_heldControls.RIGHT && (inState(CState.IDLE) || inState(CState.WALK) && this.m_walkTimer <= 1))
               {
                  return true;
               }
               if(!this.m_heldControls.RIGHT && !this.m_heldControls.LEFT && Utils.fastAbs(m_xSpeed) < this.m_max_xSpeed)
               {
                  this.m_speedLetGo = true;
               }
               if(inState(CState.WALK))
               {
                  this.m_speedTimer = 0;
               }
               else
               {
                  ++this.m_speedTimer;
               }
               if((Boolean(this.m_heldControls.RIGHT) || Boolean(this.m_heldControls.LEFT)) && inState(CState.RUN))
               {
                  _loc2_ = true;
               }
               if(inState(CState.TURN) || inState(CState.DASH))
               {
                  _loc2_ = true;
               }
               if(this.m_speedTimer < 6 && (inState(CState.IDLE) || inState(CState.WALK) || inState(CState.SKID)) && this.m_heldControls.RIGHT != this.m_heldControls.LEFT && Boolean(this.m_speedLetGo) && (Boolean(this.m_heldControls.RIGHT) && m_facingForward || Boolean(this.m_heldControls.LEFT) && !m_facingForward))
               {
                  this.m_speedLetGo = false;
                  _loc2_ = true;
               }
               break;
            case 1:
               _loc2_ = false;
               if(this.m_lastCrouchTimer > 6 && !inState(CState.CROUCH))
               {
                  this.m_lastCrouchTimer = 0;
               }
               if(inState(CState.CROUCH) && this.m_lastCrouchTimer == 0)
               {
                  this.m_lastCrouchTimer = 1;
               }
               if(this.m_lastCrouchTimer > 0 && !inState(CState.CROUCH) && !this.m_heldControls.DOWN)
               {
                  ++this.m_lastCrouchTimer;
               }
               if(this.m_lastCrouchTimer > 0 && !inState(CState.CROUCH) && Boolean(this.m_heldControls.DOWN))
               {
                  this.m_lastCrouchTimer = 0;
                  _loc2_ = true;
               }
               if(inState(CState.CROUCH) && Boolean(this.m_heldControls.DOWN) && Boolean(this.m_heldControls.DASH))
               {
                  _loc2_ = true;
               }
         }
         return _loc2_;
      }
      
      private function initDash(param1:Boolean) : void
      {
         if(inState(CState.ATTACKING))
         {
            this.forceEndAttack();
         }
         this.m_dashReady = false;
         this.m_speedTimer = 0;
         if(param1)
         {
            m_faceRight();
         }
         else
         {
            m_faceLeft();
         }
         var _loc2_:Number = this.m_characterStats.AccelStartDash >= 0 ? Number(this.m_characterStats.AccelStartDash) : Number(this.m_characterStats.AccelStart);
         m_xSpeed = param1 ? _loc2_ * this.m_max_xSpeed : -_loc2_ * this.m_max_xSpeed;
         this.setState(CState.DASH);
         this.stancePlayFrame("dash");
         this.attachRunEffect();
      }
      
      override protected function checkPlatformBounce() : void
      {
         if(Boolean(m_currentPlatform) && m_currentPlatform.bounce_speed > 0)
         {
            Utils.tryToGotoAndStop(m_currentPlatform.Container,"bounce");
            m_ySpeed = -m_currentPlatform.bounce_speed;
            this.unnattachFromGround();
            if(this.m_grabbed.length > 0)
            {
               this.setState(CState.JUMP_RISING);
               this.releaseOpponent();
            }
         }
      }
      
      private function inPreventFallOffState() : Boolean
      {
         return inState(CState.ATTACKING) && !m_attack.CanFallOff && !SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1) || inState(CState.GRABBING) || inState(CState.SHIELDING) || inState(CState.SHIELD_DROP) || inState(CState.TECH_ROLL) || inState(CState.DODGE_ROLL) || inState(CState.CRASH_GETUP) || inState(CState.ROLL) || inState(CState.SIDESTEP_DODGE) || inState(CState.LEDGE_ROLL);
      }
      
      private function m_charRun() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         if(!inState(CState.WALK))
         {
            this.m_walkTimer = 0;
         }
         else
         {
            ++this.m_walkTimer;
         }
         if(!isHitStunOrParalysis())
         {
            applyGroundInfluence();
            this.checkPlatformBounce();
         }
         var _loc10_:Number = m_xSpeed;
         if(Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1)) && currentFrameIs("run") && m_xSpeed === 0)
         {
            this.m_controlFrames();
         }
         if(!isHitStunOrParalysis() && !inState(CState.GLIDING))
         {
            _loc1_ = Number(this.m_norm_xSpeed);
            _loc2_ = Number(this.m_max_xSpeed);
            _loc3_ = Number(this.m_characterStats.MaxJumpSpeed);
            if(this.m_sizeStatus != 0)
            {
               this.m_norm_xSpeed *= this.m_sizeStatus == 1 ? 2 : 0.5;
               this.m_max_xSpeed *= this.m_sizeStatus == 1 ? 2 : 0.5;
               this.m_characterStats.MaxJumpSpeed *= this.m_sizeStatus == 1 ? 2 : 0.5;
            }
            if(!inState(CState.ATTACKING))
            {
               if(this.m_forceTimer > 0)
               {
                  this.m_heldControls.RIGHT = this.m_forceRight;
                  this.m_heldControls.LEFT = !this.m_forceRight;
                  --this.m_forceTimer;
               }
            }
            _loc4_ = Boolean(this.m_runningSpeedLevel);
            this.m_runningSpeedLevel = Boolean(this.checkDoubleTap(0)) && !(this.HoldingItem && !this.m_item.ItemStats.CanRunWith) ? true : false;
            _loc5_ = _loc4_ != this.m_runningSpeedLevel;
            _loc6_ = m_xSpeed > 0;
            if(Boolean(this.m_charIsFull) && this.m_grabbed.length > 0)
            {
               this.resetSpeedLevel();
               this.m_grabbed[0].X = m_sprite.x;
               this.m_grabbed[0].Y = m_sprite.y;
            }
            if(inState(CState.DASH) || inState(CState.TURN))
            {
               this.m_runningSpeedLevel = true;
               _loc5_ = false;
            }
            if(inState(CState.TURN) && m_sprite.stance.currentLabel != "turn")
            {
               this.m_dashReady = false;
               this.m_turnTimer.reset();
               this.setState(CState.RUN);
               if(m_facingForward)
               {
                  m_faceLeft();
                  if(Boolean(this.m_runningSpeedLevel) && this.m_heldControls.LEFT !== this.m_heldControls.RIGHT && Boolean(this.m_heldControls.RIGHT))
                  {
                     this.m_dashReady = true;
                  }
               }
               else
               {
                  m_faceRight();
                  if(Boolean(this.m_runningSpeedLevel) && this.m_heldControls.LEFT !== this.m_heldControls.RIGHT && Boolean(this.m_heldControls.LEFT))
                  {
                     this.m_dashReady = true;
                  }
               }
            }
            if(inState(CState.DASH))
            {
               if(!this.m_heldControls.LEFT && !this.m_heldControls.RIGHT)
               {
                  this.m_dashReady = true;
               }
               if(m_sprite.stance.currentLabel != "dash")
               {
                  this.m_dashReady = false;
                  this.setState(CState.RUN);
               }
               else if(Boolean(this.m_runningSpeedLevel) && this.m_heldControls.LEFT != this.m_heldControls.RIGHT && (Boolean(this.m_heldControls.LEFT) && m_facingForward || Boolean(this.m_heldControls.RIGHT) && !m_facingForward))
               {
                  if(m_facingForward)
                  {
                     m_faceLeft();
                  }
                  else
                  {
                     m_faceRight();
                  }
                  this.setState(CState.DASH_INIT);
                  m_xSpeed = 0;
               }
            }
            else if(inState(CState.DASH_INIT))
            {
               this.initDash(m_facingForward);
            }
            if(inState(CState.SKID))
            {
               ++this.m_skidTimer;
               if(!this.m_heldControls.LEFT && !this.m_heldControls.RIGHT)
               {
                  this.m_dashReady = true;
               }
               if(_loc5_ && Boolean(this.m_runningSpeedLevel) && this.m_heldControls.LEFT != this.m_heldControls.RIGHT && (Boolean(this.m_heldControls.LEFT) && !m_facingForward || Boolean(this.m_heldControls.RIGHT) && m_facingForward))
               {
               }
            }
            else
            {
               this.m_skidTimer = 0;
            }
            if(inState(CState.RUN) && !this.m_runningSpeedLevel && !SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
            {
               this.m_speedLetGo = false;
               this.resetSpeedLevel();
               this.m_dashReady = true;
               this.resetSmashTimers();
               this.m_dashReady = true;
               this.setState(CState.SKID);
            }
            if(Boolean(this.m_heldControls.RIGHT) && (!this.m_heldControls.LEFT || Boolean(this.m_heldControls.LEFT) && m_facingForward) && this.inFreeState(CFreeState.SWALLOWING | CFreeState.DISABLED | CFreeState.TOSSING | (!(STAGEDATA.AirDodge.match(/melee|solo|vsolo|double|vdouble/) && inState(CState.AIR_DODGE)) ? CFreeState.DODGING : 0)) && !inState(CState.DASH_INIT) && !inState(CState.DODGE_ROLL) && !inState(CState.SIDESTEP_DODGE) && (!inState(CState.CROUCH) || inState(CState.CROUCH) && this.m_characterStats.CrouchWalkSpeed > 0) && !inState(CState.TURN) && !(inState(CState.ITEM_TOSS) && m_collision.ground))
            {
               if(!m_collision.ground)
               {
                  m_xSpeed += m_xSpeed < this.m_characterStats.MaxJumpSpeed ? this.m_characterStats.AccelRateAir : 0;
                  if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
                  {
                     if(!m_facingForward)
                     {
                        m_faceRight();
                     }
                  }
                  else if(m_xSpeed !== _loc10_ && m_xSpeed > this.m_characterStats.MaxJumpSpeed)
                  {
                     m_xSpeed = this.m_characterStats.MaxJumpSpeed;
                  }
                  else if(m_xSpeed > this.m_characterStats.MaxJumpSpeed)
                  {
                  }
               }
               else if(!inState(CState.EGG))
               {
                  if(!this.m_runningSpeedLevel)
                  {
                     if(m_xSpeed == 0)
                     {
                        if(!inState(CState.CROUCH))
                        {
                           m_xSpeed = this.m_characterStats.AccelStart * this.m_norm_xSpeed;
                        }
                     }
                     else if(inState(CState.WALK))
                     {
                        if(m_xSpeed < this.m_norm_xSpeed)
                        {
                           m_xSpeed += this.m_characterStats.AccelRate * m_currentPlatform.accel_friction;
                           if(m_xSpeed > this.m_norm_xSpeed)
                           {
                              m_xSpeed = this.m_norm_xSpeed;
                           }
                        }
                        else
                        {
                           decel(this.m_characterStats.DecelRate);
                           if(m_xSpeed < this.m_norm_xSpeed)
                           {
                              m_xSpeed = this.m_norm_xSpeed;
                           }
                        }
                     }
                  }
                  else if(!inState(CState.CROUCH))
                  {
                     if(Boolean(this.m_dashReady) && Boolean(this.m_runningSpeedLevel) && !inState(CState.DASH) && !inState(CState.ITEM_TOSS) && Utils.fastAbs(m_xSpeed) < this.m_max_xSpeed)
                     {
                        this.initDash(true);
                     }
                     else
                     {
                        m_xSpeed += m_xSpeed < this.m_max_xSpeed ? this.m_characterStats.AccelRate * m_currentPlatform.accel_friction : 0;
                        if(m_xSpeed > this.m_max_xSpeed)
                        {
                           if(!(Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1)) && inState(CState.ATTACKING)))
                           {
                              decel(this.m_characterStats.DecelRate);
                           }
                           if(m_xSpeed < this.m_max_xSpeed)
                           {
                              m_xSpeed = this.m_max_xSpeed;
                           }
                        }
                     }
                  }
                  if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
                  {
                     if(!m_facingForward)
                     {
                        m_faceRight();
                     }
                  }
                  if(Boolean(this.m_turnTimer.IsComplete) && inState(CState.RUN) && (!_loc6_ && !m_facingForward) && (Boolean(Utils.hasLabel(m_sprite.stance,"turn")) && m_sprite.stance.currentLabel != "turn"))
                  {
                     this.setState(CState.TURN);
                     this.stancePlayFrame("turn");
                  }
                  else if(inState(CState.RUN) && Utils.fastAbs(m_xSpeed) > this.m_norm_xSpeed && !m_facingForward && !Utils.hasLabel(m_sprite.stance,"turn"))
                  {
                     m_xSpeed = this.m_characterStats.AccelStart * -this.m_norm_xSpeed;
                  }
               }
               if(inState(CState.CROUCH))
               {
                  if(m_xSpeed > this.m_characterStats.CrouchWalkSpeed)
                  {
                     decel(this.m_characterStats.DecelRate);
                  }
                  else if(m_xSpeed < this.m_characterStats.CrouchWalkSpeed)
                  {
                     m_xSpeed = Math.min(this.m_characterStats.CrouchWalkSpeed,m_xSpeed + this.m_characterStats.AccelRate);
                  }
               }
               else if(m_collision.ground && !inState(CState.FLYING) && !inState(CState.INJURED) && !inState(CState.AIR_DODGE) && !inState(CState.TURN) && !inState(CState.DASH) && !inState(CState.ITEM_TOSS))
               {
                  if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
                  {
                     this.setState(CState.RUN);
                  }
                  else if(!(inState(CState.ATTACKING) && m_attack.IASA && this.m_pressedControls.LEFT === this.m_pressedControls.RIGHT))
                  {
                     this.setState(!this.m_runningSpeedLevel ? uint(CState.WALK) : uint(CState.RUN));
                  }
                  this.m_speedLetGo = false;
               }
            }
            else if(Boolean(this.m_heldControls.LEFT) && (!this.m_heldControls.RIGHT || Boolean(this.m_heldControls.RIGHT) && !m_facingForward) && this.inFreeState(CFreeState.SWALLOWING | CFreeState.DISABLED | CFreeState.TOSSING | (!(STAGEDATA.AirDodge.match(/melee|solo|vsolo|double|vdouble/) && inState(CState.AIR_DODGE)) ? CFreeState.DODGING : 0)) && !inState(CState.DASH_INIT) && !inState(CState.DODGE_ROLL) && !inState(CState.SIDESTEP_DODGE) && (!inState(CState.CROUCH) || inState(CState.CROUCH) && this.m_characterStats.CrouchWalkSpeed > 0) && !inState(CState.TURN) && !(inState(CState.ITEM_TOSS) && m_collision.ground))
            {
               if(!m_collision.ground)
               {
                  if(!inState(CState.DISABLED) && Boolean(this.m_runningSpeedLevel))
                  {
                     m_xSpeed -= m_xSpeed > -this.m_characterStats.MaxJumpSpeed ? this.m_characterStats.AccelRateAir : 0;
                  }
                  else
                  {
                     m_xSpeed -= m_xSpeed > -this.m_characterStats.MaxJumpSpeed ? this.m_characterStats.AccelRateAir : 0;
                  }
                  if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
                  {
                     if(m_facingForward)
                     {
                        m_faceLeft();
                     }
                  }
                  else if(m_xSpeed !== _loc10_ && m_xSpeed < -this.m_characterStats.MaxJumpSpeed)
                  {
                     m_xSpeed = -this.m_characterStats.MaxJumpSpeed;
                  }
                  else if(m_xSpeed < -this.m_characterStats.MaxJumpSpeed)
                  {
                  }
               }
               else if(!inState(CState.EGG))
               {
                  if(!this.m_runningSpeedLevel)
                  {
                     if(m_xSpeed == 0)
                     {
                        if(!inState(CState.CROUCH))
                        {
                           m_xSpeed = this.m_characterStats.AccelStart * -this.m_norm_xSpeed;
                        }
                     }
                     else if(inState(CState.WALK))
                     {
                        if(m_xSpeed > -this.m_norm_xSpeed)
                        {
                           m_xSpeed -= this.m_characterStats.AccelRate * m_currentPlatform.accel_friction;
                           if(m_xSpeed < -this.m_norm_xSpeed)
                           {
                              m_xSpeed = -this.m_norm_xSpeed;
                           }
                        }
                        else
                        {
                           decel(this.m_characterStats.DecelRate);
                           if(m_xSpeed > -this.m_norm_xSpeed)
                           {
                              m_xSpeed = -this.m_norm_xSpeed;
                           }
                        }
                     }
                  }
                  else if(!inState(CState.CROUCH))
                  {
                     if(Boolean(this.m_dashReady) && Boolean(this.m_runningSpeedLevel) && !inState(CState.DASH) && !inState(CState.ITEM_TOSS) && Utils.fastAbs(m_xSpeed) < this.m_max_xSpeed)
                     {
                        this.initDash(false);
                     }
                     else
                     {
                        m_xSpeed -= m_xSpeed > -this.m_max_xSpeed ? this.m_characterStats.AccelRate * m_currentPlatform.accel_friction : 0;
                        if(m_xSpeed < -this.m_max_xSpeed)
                        {
                           if(!(Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1)) && inState(CState.ATTACKING)))
                           {
                              decel(this.m_characterStats.DecelRate);
                           }
                           if(m_xSpeed > -this.m_max_xSpeed)
                           {
                              m_xSpeed = -this.m_max_xSpeed;
                           }
                        }
                     }
                  }
                  if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
                  {
                     if(m_facingForward)
                     {
                        faceLeft();
                     }
                  }
                  if(Boolean(this.m_turnTimer.IsComplete) && inState(CState.RUN) && (_loc6_ && m_facingForward) && (Boolean(Utils.hasLabel(m_sprite.stance,"turn")) && m_sprite.stance.currentLabel != "turn"))
                  {
                     this.setState(CState.TURN);
                     this.stancePlayFrame("turn");
                  }
                  else if(inState(CState.RUN) && Utils.fastAbs(m_xSpeed) > this.m_norm_xSpeed && m_facingForward && !Utils.hasLabel(m_sprite.stance,"turn"))
                  {
                     m_xSpeed = this.m_characterStats.AccelStart * this.m_norm_xSpeed;
                  }
               }
               if(inState(CState.CROUCH))
               {
                  if(m_xSpeed < -this.m_characterStats.CrouchWalkSpeed)
                  {
                     decel(this.m_characterStats.DecelRate);
                  }
                  else if(m_xSpeed > -this.m_characterStats.CrouchWalkSpeed)
                  {
                     m_xSpeed = Math.max(-this.m_characterStats.CrouchWalkSpeed,m_xSpeed - this.m_characterStats.AccelRate);
                  }
               }
               else if(m_collision.ground && !inState(CState.FLYING) && !inState(CState.INJURED) && !inState(CState.AIR_DODGE) && !inState(CState.TURN) && !inState(CState.DASH) && !inState(CState.ITEM_TOSS))
               {
                  if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
                  {
                     this.setState(CState.RUN);
                  }
                  else if(!(inState(CState.ATTACKING) && m_attack.IASA && this.m_pressedControls.LEFT === this.m_pressedControls.RIGHT))
                  {
                     this.setState(!this.m_runningSpeedLevel ? uint(CState.WALK) : uint(CState.RUN));
                  }
                  this.m_speedLetGo = false;
               }
            }
            else if(m_collision.ground && !inState(CState.LEDGE_ROLL) && !inState(CState.DASH_INIT) && !inState(CState.ROLL) && !inState(CState.TECH_ROLL) && !inState(CState.DODGE_ROLL) && (!inState(CState.FLYING) || Boolean(this.m_hasBounced)) && !inState(CState.INJURED) && !inState(CState.ATTACKING))
            {
               if(m_xSpeed != 0)
               {
                  if(!(Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1)) && inState(CState.ATTACKING)))
                  {
                     decel(this.m_characterStats.DecelRate);
                  }
               }
            }
            if(!inState(CState.BARREL) && !inState(CState.CAUGHT) && (!inState(CState.FLYING) || Boolean(this.m_hasBounced)) && !inState(CState.INJURED))
            {
               if(inState(CState.CROUCH) && this.m_characterStats.CrouchWalkSpeed > 0 && this.m_crouchLength >= 3 && currentFrameIs("crouch"))
               {
                  if(m_xSpeed !== 0 && this.m_heldControls.LEFT != this.m_heldControls.RIGHT)
                  {
                     if(getStanceVar("moving",false))
                     {
                        Utils.tryToGotoAndStop(Stance,"walking");
                     }
                  }
                  else if(getStanceVar("moving",true))
                  {
                     Utils.tryToGotoAndStop(Stance,"crouching");
                  }
               }
               _loc7_ = inState(CState.TURN) || inState(CState.RUN) && (m_facingForward && m_xSpeed < 0 || !m_facingForward && m_xSpeed > 0);
               _loc8_ = Number(Utils.fastAbs(m_xSpeed));
               _loc9_ = _loc8_ < 5 ? 10 : _loc8_ * 2;
               if(m_xSpeed != 0 && !(Boolean(this.inPreventFallOffState()) && m_collision.ground && this.willFallOffRange(m_sprite.x + m_xSpeed,m_sprite.y,_loc9_)))
               {
                  this.m_attemptToMove(m_xSpeed,0);
               }
               if(m_collision.ground && !this.m_runningSpeedLevel && !(inState(CState.ATTACKING) && (m_attack.Frame == "a_forward" || m_attack.IsThrow)) && !inState(CState.GRABBING))
               {
                  this.resetRotation();
                  Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
               }
               if(m_collision.ground && !inState(CState.CAUGHT) && !inState(CState.BARREL))
               {
                  attachToGround();
               }
               else if(!m_collision.ground && !inState(CState.CAUGHT) && m_xSpeed != 0 && !inState(CState.ATTACKING) && !inState(CState.BARREL) && !this.m_heldControls.LEFT && !this.m_heldControls.RIGHT)
               {
                  if(!(Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1)) && inState(CState.ATTACKING)))
                  {
                     decel(this.m_characterStats.DecelRateAir);
                  }
               }
            }
            if(inState(CState.LEDGE_HANG) && this.m_ledgeHangTimer.CurrentTime > 4)
            {
               if(Boolean(this.m_pressedControls.LEFT) && !this.m_heldControls.RIGHT && m_facingForward)
               {
                  m_ySpeed = 0;
                  this.unnattachFromLedge();
                  this.setState(CState.IDLE);
               }
               if(!this.m_heldControls.LEFT && Boolean(this.m_pressedControls.RIGHT) && !m_facingForward)
               {
                  m_ySpeed = 0;
                  this.unnattachFromLedge();
                  this.setState(CState.IDLE);
               }
            }
            this.m_norm_xSpeed = _loc1_;
            this.m_max_xSpeed = _loc2_;
            this.m_characterStats.MaxJumpSpeed = _loc3_;
            if(inState(CState.SKID) && this.m_skidTimer < 2 && (Boolean(this.m_heldControls.LEFT) && _loc6_ && m_facingForward || Boolean(this.m_heldControls.RIGHT) && !_loc6_ && !m_facingForward))
            {
               this.setState(CState.TURN);
               Utils.tryToGotoAndStop(Stance,"turn");
            }
         }
         if(m_collision.ground && (inState(CState.WALK) || inState(CState.RUN)) && !this.m_heldControls.LEFT && !this.m_heldControls.RIGHT && this.inFreeState(CFreeState.SWALLOWING))
         {
            if(inState(CState.RUN) && Utils.fastAbs(m_xSpeed) < this.m_max_xSpeed && !SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
            {
               this.m_speedLetGo = false;
               this.resetSpeedLevel();
               this.m_dashReady = true;
               this.resetSmashTimers();
               this.m_dashReady = true;
               this.setState(CState.SKID);
            }
            else if(!this.m_runningSpeedLevel || m_xSpeed == 0)
            {
               this.m_dashReady = true;
               this.setState(CState.IDLE);
            }
         }
         else if(inState(CState.RUN) && this.m_heldControls.RIGHT != this.m_heldControls.LEFT)
         {
            if(Boolean(this.m_heldControls.RIGHT) && !m_facingForward)
            {
               m_faceRight();
               this.setState(CState.WALK);
               this.m_runningSpeedLevel = false;
            }
            if(Boolean(this.m_heldControls.LEFT) && m_facingForward)
            {
               m_faceLeft();
               this.setState(CState.WALK);
               this.m_runningSpeedLevel = false;
            }
         }
      }
      
      public function jumpChamber() : void
      {
         if(inState(CState.ATTACKING))
         {
            this.forceEndAttack();
         }
         this.m_preJumpState = m_state;
         this.m_crouchFrame = -1;
         this.m_jumpStartup.reset();
         this.m_shortHop = false;
         this.m_jumpSpeedBuffer = m_xSpeed;
         if(inState(CState.TURN))
         {
            if(m_facingForward)
            {
               m_faceLeft();
            }
            else
            {
               m_faceRight();
            }
         }
         var _loc1_:Object = this.getControls();
         this.setState(CState.JUMP_CHAMBER);
         this.resetBufferedCStick();
         this.m_jumpJustChambered = true;
         if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
         {
            this.initGroundJump();
         }
      }
      
      public function initGroundJump() : void
      {
         var _loc1_:Number = NaN;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc2_:Platform = m_currentPlatform;
         if(inState(CState.ATTACKING))
         {
            this.forceEndAttack();
         }
         if(Utils.fastAbs(this.m_jumpSpeedBuffer) > Utils.fastAbs(m_xSpeed) && this.m_jumpSpeedBuffer != 0)
         {
            m_xSpeed = this.m_jumpSpeedBuffer;
            this.m_jumpSpeedBuffer = 0;
         }
         this.m_jumpSpeedMidairDelay.reset();
         m_collision.ground = false;
         while(Boolean(this.testGroundWithCoord(m_sprite.x,m_sprite.y + 1)) && _loc4_ < 40)
         {
            _loc4_++;
            --m_sprite.y;
         }
         if(_loc4_ >= 40)
         {
            m_sprite.y += _loc4_;
         }
         m_yKnockback = 0;
         if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
         {
            m_ySpeed = this.m_heldControls.DOWN ? -this.m_characterStats.ShortHopSpeed : -this.m_characterStats.JumpSpeed;
         }
         else
         {
            m_ySpeed = Boolean(this.m_charIsFull) || Boolean(this.m_shortHop) ? -this.m_characterStats.ShortHopSpeed : -this.m_characterStats.JumpSpeed;
         }
         if(this.m_sizeStatus != 0)
         {
            m_ySpeed *= this.m_sizeStatus == 1 ? 1.1 : 0.9;
         }
         m_xSpeed += m_currentPlatform ? m_currentPlatform.x_influence : 0;
         if(Utils.fastAbs(m_xSpeed) > this.m_max_xSpeed)
         {
            m_xSpeed = m_xSpeed > 0 ? Number(this.m_max_xSpeed) : -this.m_max_xSpeed;
         }
         this.playCharacterSound("jump");
         this.resetRotation();
         Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
         this.attachJumpEffect();
         this.m_jumpEffectTimer.reset();
         this.m_jumpStartup.reset();
         this.setState(CState.JUMP_RISING);
         if(Boolean(Utils.hasLabel(m_sprite.stance,"backflip")) && (m_facingForward && Boolean(this.m_heldControls.LEFT) || !m_facingForward && Boolean(this.m_heldControls.RIGHT)))
         {
            this.stancePlayFrame("backflip");
         }
         else if(HasStance && Boolean(Utils.hasLabel(m_sprite.stance,"jump")))
         {
            this.stancePlayFrame("jump");
         }
         _loc3_ = currentFrameIs("jump");
         if(_loc3_)
         {
         }
         this.m_ledge = null;
         this.m_lastLedge = null;
         this.m_crouchFrame = -1;
         if((this.m_preJumpState === CState.DASH || this.m_preJumpState === CState.RUN || this.m_preJumpState === CState.TURN && (Boolean(this.m_heldControls.RIGHT) && m_facingForward || Boolean(this.m_heldControls.LEFT) && !m_facingForward)) && this.m_heldControls.RIGHT !== this.m_heldControls.LEFT)
         {
            if(Boolean(this.m_heldControls.RIGHT) && !m_facingForward)
            {
               m_xSpeed = this.m_characterStats.AccelRateAir;
               if(m_xSpeed > this.m_characterStats.MaxJumpSpeed)
               {
                  m_xSpeed = this.m_characterStats.MaxJumpSpeed;
               }
            }
            else if(Boolean(this.m_heldControls.LEFT) && m_facingForward)
            {
               m_xSpeed = -this.m_characterStats.AccelRateAir;
               if(m_xSpeed < -this.m_characterStats.MaxJumpSpeed)
               {
                  m_xSpeed = -this.m_characterStats.MaxJumpSpeed;
               }
            }
            else
            {
               m_xSpeed *= this.m_characterStats.GroundToAirMultiplier;
            }
         }
         else
         {
            m_xSpeed *= this.m_characterStats.GroundToAirMultiplier;
         }
         if(Boolean(this.m_heldControls.DOWN) && this.jumpIsHeld())
         {
            if(Boolean(this.m_canHover) && this.m_characterStats.MidAirHover > 0 && !inState(CState.HOVER) && !inState(CState.ATTACKING) && !inState(CState.DISABLED))
            {
               this.initHover();
               this.m_attemptToMove(0,-3);
            }
         }
         this.compactControlsBuffer();
         this.processControlsBuffer();
         this.m_charShield();
         if(Boolean(_loc2_) && _loc2_ is MovingPlatform)
         {
            _loc1_ = MovingPlatform(_loc2_).Y - MovingPlatform(_loc2_).PreviousY;
            if(MovingPlatform(_loc2_).conserve_horizontal_momentum)
            {
               m_xSpeed += MovingPlatform(_loc2_).X - MovingPlatform(_loc2_).PreviousX;
            }
            if(Boolean(MovingPlatform(_loc2_).conserve_upward_momentum) && _loc1_ < 0)
            {
               m_ySpeed += _loc1_;
            }
            if(Boolean(MovingPlatform(_loc2_).conserve_downward_momentum) && _loc1_ > 0)
            {
               m_ySpeed += _loc1_;
            }
         }
      }
      
      public function initMidairJump() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Number = NaN;
         if(inState(CState.ATTACKING))
         {
            this.forceEndAttack();
         }
         if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
         {
            this.m_jumpSpeedBuffer = m_xSpeed;
            this.initGroundJump();
            ++this.m_jumpCount;
            return;
         }
         _loc1_ = false;
         this.m_hitLagCanCancelWithJump = false;
         this.m_hitLagCanCancelWithUpB = false;
         this.m_jumpSpeedMidairDelay.reset();
         _loc2_ = -this.m_characterStats.JumpSpeedMidAir;
         if(this.m_jumpSpeedList)
         {
            if(this.m_jumpCount < this.m_jumpSpeedList.length)
            {
               _loc2_ = -this.m_jumpSpeedList[this.m_jumpCount];
            }
            else
            {
               _loc2_ = -this.m_jumpSpeedList[this.m_jumpSpeedList.length - 1];
            }
         }
         if(!(this.m_midAirJumpConstantDelay.MaxTime > 0 && this.m_midAirJumpConstantTime.MaxTime > 0))
         {
            m_ySpeed = _loc2_;
         }
         else if(m_ySpeed < 0)
         {
            m_ySpeed = 0;
         }
         if(this.m_sizeStatus != 0)
         {
            m_ySpeed *= this.m_sizeStatus == 1 ? 1.1 : 0.9;
         }
         if(this.m_heldControls.LEFT === this.m_heldControls.RIGHT)
         {
            m_xSpeed *= 0.3;
         }
         else if(this.m_heldControls.LEFT !== this.m_heldControls.RIGHT && (Boolean(this.m_heldControls.RIGHT) && m_xSpeed < 0 || Boolean(this.m_heldControls.LEFT) && m_xSpeed > 0))
         {
            m_xSpeed = 0;
            if(this.m_heldControls.RIGHT)
            {
               m_xSpeed = this.m_characterStats.AccelRateAir;
               if(m_xSpeed > this.m_characterStats.MaxJumpSpeed)
               {
                  m_xSpeed = this.m_characterStats.MaxJumpSpeed;
               }
            }
            else if(this.m_heldControls.LEFT)
            {
               m_xSpeed = -this.m_characterStats.AccelRateAir;
               if(m_xSpeed < -this.m_characterStats.MaxJumpSpeed)
               {
                  m_xSpeed = -this.m_characterStats.MaxJumpSpeed;
               }
            }
         }
         m_yKnockback = 0;
         resetKnockbackDecay();
         this.playCharacterSound("jump_midair");
         this.m_multiJumpDelay.reset();
         ++this.m_jumpCount;
         this.resetRotation();
         Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
         this.m_lastLedge = null;
         if(this.m_midAirJumpConstantTime.MaxTime > 0)
         {
            this.m_midAirJumpConstantTime.reset();
         }
         if(this.m_midAirJumpConstantDelay.MaxTime > 0)
         {
            this.m_midAirJumpConstantDelay.reset();
         }
         if(Boolean(this.m_characterStats.MidAirTurn) && Boolean(this.m_heldControls.RIGHT) && !m_facingForward)
         {
            m_faceRight();
            m_facingForward = true;
         }
         else if(Boolean(this.m_characterStats.MidAirTurn) && Boolean(this.m_heldControls.LEFT) && m_facingForward)
         {
            m_faceLeft();
            m_facingForward = false;
         }
         if(!this.m_characterStats.HoldJump)
         {
            this.attachJumpMidairEffect();
            this.m_jumpEffectTimer.finish();
         }
         _loc1_ = currentFrameIs("jump_midair");
         if(_loc1_)
         {
            this.restartStance();
         }
         this.setState(CState.JUMP_MIDAIR_RISING);
      }
      
      private function initHover() : void
      {
         this.resetRotation();
         m_ySpeed = 0;
         this.m_midAirHoverTime.reset();
         this.m_midAirHoverTime.MaxTime = this.m_characterStats.MidAirHover;
         this.m_midAirJumpConstantTime.finish();
         this.m_canHover = false;
         this.setState(CState.HOVER);
      }
      
      private function m_charJump() : void
      {
         var _loc1_:Boolean = false;
         this.m_multiJumpDelay.tick();
         this.m_jumpSpeedMidairDelay.tick();
         if(m_collision.ground && this.jumpIsPressed())
         {
            ++this.m_jumpTimer;
         }
         else
         {
            _loc1_ = !this.m_jumpJustLetGo && this.m_jumpTimer != 0;
            this.m_jumpJustLetGo = this.m_jumpTimer != 0;
            if(!_loc1_)
            {
               this.m_jumpTimer = 0;
            }
         }
         if(this.jumpIsPressed())
         {
            this.m_jumpTimer = 0;
         }
         if(inState(CState.JUMP_CHAMBER))
         {
            if(!this.m_jumpJustChambered)
            {
               this.m_jumpStartup.tick();
            }
            if(!this.jumpIsHeld())
            {
               this.m_shortHop = true;
            }
            if(!this.jumpIsHeld() || Boolean(this.m_jumpStartup.IsComplete))
            {
               this.m_jumpJustLetGo = true;
            }
            else
            {
               this.m_jumpJustLetGo = false;
            }
            if(this.m_jumpStartup.IsComplete)
            {
               this.initGroundJump();
            }
         }
         else
         {
            this.resetBufferedCStick();
         }
         if(this.inFreeState(CFreeState.SWALLOWING | CFreeState.TURNING | CFreeState.SKIDDING) && !inState(CState.DASH_INIT) && !(this.HoldingItem && !this.m_item.CanJumpWith) && this.m_jumpCount < this.m_characterStats.MaxJump && (Boolean(this.m_jumpSpeedMidairDelay.IsComplete) || Boolean(this.m_characterStats.HoldJump)) && this.jumpIsPressed() && m_collision.ground)
         {
            if(this.m_jumpStartup.MaxTime == 0)
            {
               this.initGroundJump();
            }
            else
            {
               this.jumpChamber();
            }
         }
         else if(this.jumpIsHeld() && this.inFreeState() && m_ySpeed > 0 && m_ySpeed - m_gravity <= 0 && Boolean(this.m_canHover) && this.m_characterStats.MidAirHover > 0 && !m_collision.ground && !(this.HoldingItem && !this.m_item.CanJumpWith) && !this.isLandingOrSkiddingOrChambering() && !this.m_charIsFull && !inState(CState.HOVER) && !inState(CState.DISABLED))
         {
            this.initHover();
         }
         else if(this.jumpIsHeld() && Boolean(this.m_heldControls.DOWN) && this.inFreeState() && Boolean(this.m_canHover) && this.m_characterStats.MidAirHover > 0 && !m_collision.ground && !(this.HoldingItem && !this.m_item.CanJumpWith) && !this.isLandingOrSkiddingOrChambering() && !this.m_charIsFull && !inState(CState.HOVER))
         {
            this.initHover();
         }
         else if(this.jumpIsPressed() && !m_collision.ground && !(Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1)) && m_ySpeed < 0) && !(this.HoldingItem && !this.m_item.CanJumpWith) && this.m_jumpCount < this.m_characterStats.MaxJump && (Boolean(this.m_jumpSpeedMidairDelay.IsComplete) || Boolean(this.m_characterStats.HoldJump) && this.m_jumpCount > 1 && getStanceVar("done",true)) && this.inFreeState() && !this.isLandingOrSkiddingOrChambering() && !inState(CState.HOVER) && !(this.m_jumpCount > 2 && !this.m_multiJumpDelay.IsComplete))
         {
            this.initMidairJump();
         }
         else if(inState(CState.LEDGE_HANG) && this.jumpIsPressed() && this.m_ledgeHangTimer.CurrentTime > 4)
         {
            this.m_shortHop = false;
            this.turnOffInvincibility();
            this.initGroundJump();
         }
         this.m_jumpJustChambered = false;
      }
      
      override public function checkMovingPlatforms(param1:MovingPlatform) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(m_collision.ground && m_currentPlatform != null && m_currentPlatform == param1 || inState(CState.LEDGE_HANG) && this.m_ledge != null && param1.LedgeList.indexOf(this.m_ledge) >= 0)
         {
            _loc2_ = param1.X - param1.PreviousX;
            _loc3_ = param1.Y - param1.PreviousY;
            if(inState(CState.LEDGE_HANG) && Utils.fastAbs(_loc3_) > 400)
            {
               this.unnattachFromLedge();
               this.setState(CState.IDLE);
               this.m_ledge = null;
               this.m_lastLedge = null;
               return;
            }
            if(inState(CState.CAUGHT))
            {
               return;
            }
            if(!this.testGroundWithCoord(m_sprite.x + _loc2_,m_sprite.y + _loc3_))
            {
               safeMove(0,_loc3_);
               safeMove(_loc2_,0);
            }
            else
            {
               this.m_attemptToMove(0,_loc3_);
               this.m_attemptToMove(_loc2_,0);
            }
            if(!inState(CState.LEDGE_HANG))
            {
               this.m_fsGlowHolderMC.x = m_sprite.x;
               this.m_fsGlowHolderMC.y = m_sprite.y;
            }
            else
            {
               _loc4_ = Number(Point.distance(new Point(this.m_ledge.x,this.m_ledge.y),new Point(m_sprite.x,m_sprite.y)));
               if(_loc4_ > 500)
               {
                  this.unnattachFromLedge();
                  this.setState(CState.IDLE);
                  this.m_ledge = null;
                  this.m_lastLedge = null;
                  return;
               }
               m_sprite.x = this.m_ledge.x;
               m_sprite.y = this.m_ledge.y;
            }
         }
      }
      
      private function initGrab(param1:Boolean = false) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Boolean = false;
         if(this.checkItemInterrupt("grab",1))
         {
            return;
         }
         if(inState(CState.DASH) && m_xSpeed != 0)
         {
            m_xSpeed = m_xSpeed > 0 ? Number(this.m_max_xSpeed) : -this.m_max_xSpeed;
         }
         if(inState(CState.ATTACKING))
         {
            this.forceEndAttack();
         }
         this.clearControlsBuffer();
         m_attack.Frame = "grab";
         _loc2_ = m_state;
         _loc3_ = _loc2_ === CState.ATTACKING && m_attack.Frame === "a_forward";
         this.setState(CState.GRABBING);
         if(_loc2_ == CState.SHIELDING)
         {
            this.m_deactivateShield();
         }
         if(Boolean(this.m_characterStats.TetherGrab) && !m_collision.ground)
         {
            ++this.m_tetherCount;
            this.stancePlayFrame("tether");
         }
         else if((_loc2_ == CState.DASH || _loc3_ || _loc2_ == CState.TURN || _loc2_ == CState.RUN) && Boolean(Utils.hasLabel(m_sprite.stance,"dashgrab")))
         {
            this.stancePlayFrame("dashgrab");
         }
         this.resetSpeedLevel();
         this.m_crouchFrame = -1;
         this.m_grabbed = new Vector.<Character>();
         m_attack.importAttackStateData({"isAirAttack":this.m_characterStats.TetherGrab && !m_collision.ground});
         m_attack.AttackID = Utils.getUID();
         if(!param1)
         {
            if(_loc2_ == CState.TURN)
            {
               flip();
            }
            else if(_loc2_ == CState.DASH || _loc2_ == CState.RUN || _loc2_ == CState.IDLE || _loc2_ == CState.WALK)
            {
               if(this.m_heldControls.RIGHT)
               {
                  m_faceRight();
               }
               else if(this.m_heldControls.LEFT)
               {
                  m_faceLeft();
               }
            }
         }
      }
      
      private function removeUngrabbedCharacters() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < this.m_grabbed.length)
         {
            if(this.m_grabbed[_loc1_].State != CState.CAUGHT)
            {
               this.m_grabbed.splice(_loc1_,1);
               _loc1_--;
            }
            _loc1_++;
         }
      }
      
      public function grabReleaseOpponent() : void
      {
         var _loc1_:AttackDamage = null;
         var _loc2_:int = 0;
         var _loc3_:Character = null;
         if(this.m_grabbed.length > 0 && !this.m_internalGrabLock)
         {
            _loc1_ = new AttackDamage(m_player_id,this);
            _loc1_.AttackID = Utils.getUID();
            _loc1_.IsForward = m_facingForward;
            _loc1_.Damage = 0;
            _loc1_.Direction = 60;
            _loc1_.XLoc = m_sprite.x;
            _loc1_.YLoc = m_sprite.y;
            _loc1_.Power = 14;
            _loc1_.WeightKB = 40;
            _loc1_.KBConstant = 60;
            _loc1_.DisableHurtSound = true;
            _loc1_.ReversableAngle = false;
            _loc1_.BypassHeavyArmor = true;
            _loc1_.BypassSuperArmor = true;
            _loc1_.BypassLaunchResistance = true;
            _loc2_ = 0;
            while(_loc2_ < this.m_grabbed.length)
            {
               _loc3_ = this.m_grabbed[_loc2_];
               _loc3_.setState(CState.IDLE);
               _loc1_.AttackRatio = 1 / _loc3_.CharacterStats.DamageRatio;
               _loc3_.takeDamage(_loc1_);
               _loc3_.setVisibility(true);
               _loc3_.resetMovement();
               _loc2_++;
            }
            this.releaseOpponent();
         }
      }
      
      public function grabRelease(param1:Boolean = false) : void
      {
         var _loc2_:AttackDamage = null;
         _loc2_ = new AttackDamage(-1,this);
         _loc2_.AttackID = Utils.getUID();
         _loc2_.Damage = 0;
         _loc2_.Direction = 0;
         _loc2_.IsForward = !m_facingForward;
         _loc2_.XLoc = _loc2_.IsForward ? m_sprite.x + 5 : m_sprite.x - 5;
         _loc2_.YLoc = m_sprite.y;
         _loc2_.Power = 7;
         _loc2_.WeightKB = 40;
         _loc2_.KBConstant = 60;
         _loc2_.DisableHurtFallOff = true;
         _loc2_.DisableLastHitUpdate = true;
         _loc2_.DisableHurtSound = true;
         _loc2_.ReversableAngle = false;
         _loc2_.BypassHeavyArmor = true;
         _loc2_.BypassSuperArmor = true;
         _loc2_.BypassLaunchResistance = true;
         _loc2_.AttackRatio = 1 / this.m_characterStats.DamageRatio;
         if(param1)
         {
            _loc2_.HasEffect = false;
         }
         else
         {
            this.setState(CState.IDLE);
         }
         this.takeDamage(_loc2_);
      }
      
      private function m_charGrab() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1)) && !inState(CState.GRABBING))
         {
            return;
         }
         _loc1_ = 0;
         if((inState(CState.SHIELDING) && (Boolean(this.m_pressedControls.BUTTON2) || Boolean(this.m_pressedControls.GRAB)) && Boolean(this.m_shieldDelayTimer.IsComplete) || inState(CState.AIR_DODGE) && Boolean(this.m_pressedControls.BUTTON2) && Boolean(this.m_characterStats.TetherGrab) && this.shieldIsPressed() || !inState(CState.SHIELDING) && Boolean(this.m_pressedControls.GRAB)) && !m_actionShot && this.inFreeState(CFreeState.ATTACKING | CFreeState.SHIELDING | CFreeState.DODGING | CFreeState.TURNING | CFreeState.JUMP_CHAMBER) && (!inState(CState.ATTACKING) || Boolean(this.isInterruptableAttack()) && !m_attack.IsThrow) && !(!m_collision.ground && !this.m_characterStats.TetherGrab) && Boolean(this.m_characterStats.CanThrow) && !inState(CState.DODGE_ROLL) && !inState(CState.SIDESTEP_DODGE))
         {
            if(Boolean(this.m_characterStats.TetherGrab) && !m_collision.ground)
            {
               this.initGrab(true);
            }
            else if(!inState(CState.AIR_DODGE))
            {
               this.initGrab();
            }
         }
         else if(inState(CState.GRABBING))
         {
            if(!(this.m_grabbed.length == 0 && m_collision.ground && !m_attack.IsAirAttack))
            {
               if(this.m_grabbed.length > 0)
               {
                  if(inState(CState.GRABBING) && currentFrameIs("grab") && currentStanceFrameIs("attack"))
                  {
                     this.removeUngrabbedCharacters();
                     this.repositionGrabbedCharacter();
                  }
                  if(m_xSpeed != 0 && !checkLinearPathBetweenPoints(this.m_grabbed[0].Location,new Point(m_sprite.x + (m_facingForward ? m_width / 2 + this.m_grabbed[0].Width - 5 : -m_width / 2 - this.m_grabbed[0].Width + 5),m_sprite.y + this.m_characterStats.KneeYOffset)))
                  {
                     m_xSpeed = 0;
                  }
                  --this.m_grabTimer;
                  this.removeUngrabbedCharacters();
                  _loc1_ = 0;
                  while(_loc1_ < this.m_grabbed.length)
                  {
                     if(this.m_grabbed[_loc1_].State != CState.CAUGHT)
                     {
                        this.m_grabbed.splice(_loc1_,1);
                        _loc1_--;
                     }
                     else
                     {
                        _loc2_ = int(this.m_grabbed[_loc1_].Struggle());
                        this.m_grabTimer -= _loc2_ > 0 ? _loc2_ : 0;
                     }
                     _loc1_++;
                  }
                  if(this.m_grabbed.length == 0)
                  {
                     this.setState(CState.IDLE);
                     return;
                  }
                  if(getStanceVar("xframe","attack"))
                  {
                     ++m_attack.ExecTime;
                     ++m_attack.RefreshRateTimer;
                  }
                  if(getStanceVar("xframe","attack"))
                  {
                     --this.m_pummelTimer;
                  }
                  else
                  {
                     this.m_justPummeled = false;
                  }
                  if(HasTouchBox && this.m_grabbed.length > 0)
                  {
                     this.repositionGrabbedCharacter();
                  }
                  if(this.m_grabTimer <= 0 && inState(CState.GRABBING) && this.m_grabbed.length > 0)
                  {
                     this.grabReleaseOpponent();
                     this.grabRelease();
                  }
                  if(inState(CState.GRABBING) && this.m_grabbed.length > 0 && !currentStanceFrameIs("attack"))
                  {
                     if(Boolean(this.m_pressedControls.RIGHT) && !this.m_pressedControls.LEFT || Boolean(this.m_pressedControls.C_RIGHT) && !this.m_pressedControls.C_LEFT)
                     {
                        this.resetRotation();
                        _loc3_ = "throw_forward";
                        if(!m_facingForward)
                        {
                           _loc3_ = "throw_back";
                        }
                        this.Attack(_loc3_,1);
                     }
                     else if(Boolean(this.m_pressedControls.LEFT) && !this.m_pressedControls.RIGHT || Boolean(this.m_pressedControls.C_LEFT) && !this.m_pressedControls.C_RIGHT)
                     {
                        this.resetRotation();
                        _loc4_ = "throw_forward";
                        if(m_facingForward)
                        {
                           _loc4_ = "throw_back";
                        }
                        this.Attack(_loc4_,1);
                     }
                     else if(Boolean(this.m_pressedControls.DOWN) || Boolean(this.m_pressedControls.C_DOWN))
                     {
                        this.resetRotation();
                        this.Attack("throw_down",1);
                     }
                     else if(Boolean(this.m_pressedControls.UP) || Boolean(this.m_pressedControls.C_UP))
                     {
                        this.resetRotation();
                        this.Attack("throw_up",1);
                     }
                     else if((Boolean(this.m_pressedControls.BUTTON2) || Boolean(this.m_pressedControls.GRAB)) && getStanceVar("xframe","grab"))
                     {
                        this.resetRotation();
                        m_attack.AttackID = Utils.getUID();
                        this.stancePlayFrame("attack");
                        m_attack.ExecTime = 0;
                        this.m_justPummeled = true;
                     }
                  }
               }
            }
         }
      }
      
      private function repositionGrabbedCharacter(param1:int = 0) : void
      {
         var _loc2_:Point = null;
         var _loc3_:Rectangle = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(HasTouchBox && this.m_grabbed.length > 0 && param1 < this.m_grabbed.length)
         {
            _loc2_ = new Point(HitBoxSprite(this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.TOUCH)[0]).centerx * m_sprite.scaleX,HitBoxSprite(this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.TOUCH)[0]).centery * m_sprite.scaleY);
            _loc3_ = new Rectangle(_loc2_.x,_loc2_.y,1,1);
            _loc3_ = Utils.rotateRectangleAroundOrigin(_loc3_,360 - m_sprite.rotation);
            _loc2_.x = m_sprite.x + _loc3_.x;
            _loc2_.y = m_sprite.y + _loc3_.y;
            _loc4_ = _loc2_.x - m_sprite.x;
            _loc5_ = _loc2_.y - m_sprite.y;
            _loc6_ = 0;
            if(checkLinearPathBetweenPoints(this.m_grabbed[param1].Location,new Point(_loc2_.x,_loc2_.y)))
            {
               this.m_grabbed[param1].X = _loc2_.x;
               this.m_grabbed[param1].Y = _loc2_.y;
            }
            else
            {
               this.m_grabbed[param1].X = m_sprite.x;
               this.m_grabbed[param1].Y = m_sprite.y;
               if(_loc5_ < 0 && Boolean(this.m_grabbed[param1].Ground))
               {
                  this.m_grabbed[param1].unnattachFromGround();
               }
               this.m_grabbed[param1].moveSprite(_loc4_,0);
               this.m_grabbed[param1].moveSprite(0,_loc5_);
            }
         }
      }
      
      private function m_charCrouch() : void
      {
         var _loc1_:Boolean = false;
         _loc1_ = Boolean(this.checkDoubleTap(1));
         if(inState(CState.LEDGE_HANG) && Boolean(this.m_pressedControls.DOWN) && this.m_ledgeHangTimer.CurrentTime > 4)
         {
            m_ySpeed = 0;
            this.unnattachFromLedge();
            this.resetRotation();
            this.m_fallTiltTimer.reset();
            this.setState(CState.IDLE);
            this.setState(CState.JUMP_FALLING);
         }
         else if(Boolean(this.m_heldControls.DOWN) && this.inFreeState() && m_collision.ground && !this.isLandingOrSkiddingOrChambering() && !(inState(CState.DASH) && m_framesSinceLastState < 4))
         {
            if(inState(CState.DASH))
            {
               m_xSpeed = m_xSpeed > 0 ? Math.min(this.m_max_xSpeed,m_xSpeed) : (m_xSpeed < 0 ? Math.max(m_xSpeed,-this.m_max_xSpeed) : 0);
            }
            this.setState(CState.CROUCH);
         }
         else if(!inState(CState.ATTACKING))
         {
            this.m_crouchFrame = -1;
         }
         if(this.inFreeState() && m_collision.ground && (_loc1_ && !SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1) || Boolean(this.m_heldControls.DOWN) && this.m_crouchLength >= 15 && Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))) && m_currentPlatform != null && m_currentPlatform.noDropThrough != true && !this.isLandingOrSkiddingOrChambering() && !(inState(CState.ATTACKING) && m_attack.Rocket) && OnPlatform && (this.m_fallthroughPlatform == null || m_currentPlatform !== this.m_fallthroughPlatform))
         {
            this.initFallThrough();
            this.m_crouchFrame = -1;
         }
         if(inState(CState.CROUCH))
         {
            ++this.m_crouchLength;
            if(Boolean(this.m_pressedControls.BUTTON2) && Boolean(this.m_heldControls.DOWN) && this.m_attackDelay <= 0 && !inState(CState.JUMP_CHAMBER))
            {
               this.m_crouchFrame = m_sprite.stance.currentFrame;
               this.Attack("crouch_attack",1);
            }
            else if(!this.m_heldControls.DOWN)
            {
               this.setState(CState.IDLE);
            }
         }
         else if(!(inState(CState.ATTACKING) && m_attack.Frame == "crouch_attack"))
         {
            this.m_crouchLength = 0;
         }
      }
      
      private function initFallThrough() : void
      {
         this.m_justFellThroughPlatform = true;
         this.m_fallthroughPlatform = m_currentPlatform;
         this.unnattachFromGround();
         this.m_fallthroughTimer.reset();
         this.setState(CState.JUMP_FALLING);
      }
      
      private function initShield() : void
      {
         this.grabReleaseOpponent();
         if(this.m_shieldPower < 25)
         {
            this.m_shieldPower = 25;
         }
         this.m_shieldTimer = 0;
         this.m_shieldDelay = 0;
         this.m_resizeShield();
         STAGEDATA.playSpecificSound("shield_brawl");
         this.m_shieldStartTimer = 0;
         if(inState(CState.DASH))
         {
            m_xSpeed = 0;
         }
         this.setState(CState.SHIELDING);
         this.m_activateShield();
      }
      
      public function initDodgeRoll(param1:Boolean = true) : void
      {
         var _loc2_:Boolean = false;
         if(inState(CState.ATTACKING))
         {
            this.forceEndAttack();
         }
         this.m_deactivateShield();
         STAGEDATA.playSpecificSound("roll_brawl");
         _loc2_ = m_facingForward;
         if(param1)
         {
            m_faceLeft();
         }
         else
         {
            m_faceRight();
         }
         this.m_rollTimer = Math.max(1,this.m_characterStats.DodgeStartup + 1);
         this.setState(CState.DODGE_ROLL);
         if(_loc2_ && Boolean(this.m_heldControls.RIGHT) || !_loc2_ && Boolean(this.m_heldControls.LEFT))
         {
            if(Utils.hasLabel(m_sprite.stance,"forward"))
            {
               this.stancePlayFrame("forward");
            }
         }
         this.killAllSpeeds();
      }
      
      private function initSideStepDodge() : void
      {
         if(inState(CState.ATTACKING))
         {
            this.forceEndAttack();
         }
         this.m_deactivateShield();
         STAGEDATA.playSpecificSound("brawl_dodge");
         this.setState(CState.SIDESTEP_DODGE);
         this.setIntangibility(true);
      }
      
      public function isPlayer() : Boolean
      {
         return m_player_id > 0;
      }
      
      private function initAirDodge() : void
      {
         var _loc1_:Number = NaN;
         if(inState(CState.ATTACKING))
         {
            this.forceEndAttack();
         }
         STAGEDATA.playSpecificSound("brawl_dodge");
         this.m_midAirJumpConstantTime.finish();
         this.setState(CState.AIR_DODGE);
         _loc1_ = 1;
         if(STAGEDATA.AirDodge.match(/melee|solo|vsolo|double|vdouble/))
         {
            ++this.m_airDodgeCount;
            this.m_initialAirDodgeAngle = Utils.getControlsAngle(this.getControls());
            if(STAGEDATA.AirDodge.match(/double|vdouble/))
            {
               if(this.m_initialAirDodgeAngle === 0)
               {
                  this.m_initialAirDodgeAngle = 345;
               }
               else if(this.m_initialAirDodgeAngle === 180)
               {
                  this.m_initialAirDodgeAngle = 195;
               }
            }
            this.killAllSpeeds();
            if(this.m_initialAirDodgeAngle >= 0)
            {
               stackKnockback(this.m_characterStats.AirDodgeSpeed * _loc1_,this.m_initialAirDodgeAngle,m_xKnockback,m_yKnockback);
            }
         }
         else if(STAGEDATA.AirDodge.match(/ultimate/))
         {
            ++this.m_airDodgeCount;
            this.m_initialAirDodgeAngle = Utils.getControlsAngle(this.getControls());
            if(this.m_initialAirDodgeAngle >= 0)
            {
               this.killAllSpeeds();
               if(this.m_waveDashPenalty > 0)
               {
                  _loc1_ -= 0.8 * (this.m_waveDashPenalty / 100);
               }
               this.m_waveDashPenalty += 25;
               if(this.m_waveDashPenalty > 100)
               {
                  this.m_waveDashPenalty = 100;
               }
               stackKnockback(this.m_characterStats.AirDodgeSpeed * _loc1_,this.m_initialAirDodgeAngle,m_xKnockback,m_yKnockback);
               moveSprite(Utils.calculateXSpeed(10,this.m_initialAirDodgeAngle - 180),-Utils.calculateYSpeed(10,this.m_initialAirDodgeAngle - 180));
            }
         }
      }
      
      private function m_charShield() : void
      {
         if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
         {
            return;
         }
         if(inState(CState.SHIELDING) && m_collision.ground && !isHitStunOrParalysis() && Boolean(this.m_shieldDelayTimer.IsComplete) && OnPlatform && !m_currentPlatform.noDropThrough && this.m_shieldTimer > 0 && Boolean(this.m_heldControls.DASH) && Boolean(this.m_heldControls.DOWN))
         {
            this.m_deactivateShield();
            this.initFallThrough();
         }
         if(Boolean(this.m_justTechedTimer.IsComplete) && !m_collision.ground && this.shieldIsPressed() && this.inFreeState(CFreeState.ATTACKING) && !(this.HoldingItem && !this.m_item.CanShieldWith) && !this.isLandingOrSkiddingOrChambering() && Boolean(this.m_characterStats.CanDodge) && !inState(CState.TUMBLE_FALL) && !this.isNonInterruptableAttack() && !(STAGEDATA.AirDodge.match(/ultimate|solo|vsolo|double|vdouble/) && this.m_airDodgeCount > 0))
         {
            this.initAirDodge();
         }
         if(inState(CState.SIDESTEP_DODGE) && !m_collision.ground)
         {
            this.setState(CState.TUMBLE_FALL);
         }
         if(this.shieldIsHeld() && m_collision.ground && this.inFreeState() && !(this.HoldingItem && !this.m_item.CanShieldWith) && !this.isLandingOrSkiddingOrChambering() && !inState(CState.TUMBLE_FALL) && Boolean(this.m_characterStats.CanShield))
         {
            this.initShield();
         }
         else if(!this.shieldIsHeld() && inState(CState.SHIELDING) && !isHitStunOrParalysis() && Boolean(this.m_shieldDelayTimer.IsComplete) && this.m_shieldTimer > 0)
         {
            this.m_deactivateShield();
            this.m_shieldDropLag.reset();
            this.setState(CState.SHIELD_DROP);
            if(Utils.hasLabel(Stance,"shielddrop"))
            {
               this.stancePlayFrame("shielddrop");
            }
         }
         if(inState(CState.SHIELDING) || inState(CState.DODGE_ROLL) || inState(CState.AIR_DODGE) || inState(CState.SIDESTEP_DODGE))
         {
            ++this.m_shieldDelay;
         }
         if(inState(CState.SHIELDING))
         {
            if(!(this.HoldingItem && !this.m_item.CanJumpWith) && this.m_jumpCount < this.m_characterStats.MaxJump && (Boolean(this.m_jumpSpeedMidairDelay.IsComplete) || Boolean(this.m_characterStats.HoldJump) && getStanceVar("done",true)) && this.jumpIsPressed() && m_collision.ground && this.m_shieldTimer > 0 && Boolean(this.m_shieldDelayTimer.IsComplete))
            {
               this.m_deactivateShield();
               this.jumpChamber();
               this.compactControlsBuffer();
            }
            else if(Boolean(this.m_pressedControls.LEFT) && !this.m_pressedControls.RIGHT && Boolean(this.m_characterStats.CanDodge) && !this.m_pressedControls.GRAB && Boolean(this.m_shieldDelayTimer.IsComplete) && !isHitStunOrParalysis() && m_collision.ground)
            {
               this.initDodgeRoll(false);
            }
            else if(Boolean(this.m_pressedControls.RIGHT) && !this.m_pressedControls.LEFT && !inState(CState.DODGE_ROLL) && !inState(CState.AIR_DODGE) && !inState(CState.SIDESTEP_DODGE) && Boolean(this.m_characterStats.CanDodge) && !this.m_pressedControls.GRAB && Boolean(this.m_shieldDelayTimer.IsComplete) && !isHitStunOrParalysis() && m_collision.ground)
            {
               this.initDodgeRoll(true);
            }
            else if(Boolean(this.m_pressedControls.DOWN) && Boolean(this.m_characterStats.CanDodge) && !this.m_pressedControls.GRAB && Boolean(this.m_shieldDelayTimer.IsComplete) && !isHitStunOrParalysis() && m_collision.ground)
            {
               this.initSideStepDodge();
            }
         }
         if(inState(CState.SHIELD_DROP))
         {
            this.m_shieldDropLag.tick();
            if(this.m_shieldDropLag.IsComplete)
            {
               this.setState(CState.IDLE);
            }
         }
         if(!inState(CState.SHIELDING))
         {
            if(this.m_shieldPower < 100 && !inState(CState.DODGE_ROLL) && !inState(CState.AIR_DODGE) && !inState(CState.SIDESTEP_DODGE) && !inState(CState.GRABBING))
            {
               this.m_shieldPower += 0.14 * 2;
            }
         }
      }
      
      private function m_activateShield() : void
      {
         if(!this.m_characterStats.CustomShield)
         {
            this.m_shieldHolderMC.scaleX = m_sizeRatio * this.m_characterStats.ShieldScale;
            this.m_shieldHolderMC.scaleY = m_sizeRatio * this.m_characterStats.ShieldScale;
            this.m_shieldHolderMC.x = m_facingForward ? m_sprite.x + this.m_characterStats.ShieldXOffset * m_sizeRatio : m_sprite.x - this.m_characterStats.ShieldXOffset * m_sizeRatio;
            this.m_shieldHolderMC.y = m_sprite.y - m_height / 3 * m_sizeRatio + this.m_characterStats.ShieldYOffset * m_sizeRatio;
            this.m_shield_originalWidth = this.m_shieldHolderMC.width;
            this.m_shield_originalHeight = this.m_shieldHolderMC.height;
            this.m_resizeShield();
            STAGE.addChild(this.m_shieldHolderMC);
         }
      }
      
      private function m_deactivateShield() : void
      {
         if(this.m_shieldHolderMC.parent)
         {
            this.m_shieldHolderMC.parent.removeChild(this.m_shieldHolderMC);
         }
      }
      
      private function m_resizeShield() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(!this.m_characterStats.CustomShield)
         {
            this.m_shieldHolderMC.width = this.m_shield_originalWidth * (this.m_shieldPower / 100 * (this.m_characterStats.MaxShieldSize - this.m_characterStats.MinShieldSize) + this.m_characterStats.MinShieldSize);
            this.m_shieldHolderMC.height = this.m_shield_originalHeight * (this.m_shieldPower / 100 * (this.m_characterStats.MaxShieldSize - this.m_characterStats.MinShieldSize) + this.m_characterStats.MinShieldSize);
            this.m_shieldHolderMC.x = m_facingForward ? m_sprite.x + this.m_characterStats.ShieldXOffset * m_sizeRatio : m_sprite.x - this.m_characterStats.ShieldXOffset * m_sizeRatio;
            this.m_shieldHolderMC.y = m_sprite.y - m_height / 3 * m_sizeRatio + this.m_characterStats.ShieldYOffset * m_sizeRatio;
         }
         else if(this.m_characterStats.CustomShield)
         {
            if(currentFrameIs("defend") && HasStance)
            {
               _loc1_ = int(m_sprite.stance.totalFrames);
               _loc2_ = 0;
               if("startup" in m_sprite.stance)
               {
                  if(!m_sprite.stance.startup)
                  {
                     _loc2_ = this.m_characterStats.CustomShieldStartup + 1 + Math.ceil((1 - this.m_shieldPower / 100) * (_loc1_ - this.m_characterStats.CustomShieldStartup));
                     if(_loc2_ >= 1 && _loc2_ <= _loc1_)
                     {
                        m_sprite.stance.gotoAndStop(_loc2_);
                     }
                  }
               }
               else
               {
                  _loc2_ = Math.ceil((1 - this.m_shieldPower / 100) * _loc1_);
                  if(_loc2_ >= 1 && _loc2_ <= _loc1_)
                  {
                     m_sprite.stance.gotoAndStop(_loc2_);
                  }
               }
            }
         }
      }
      
      private function m_breakShield() : void
      {
         var _loc1_:AttackDamage = null;
         this.m_deactivateShield();
         this.setState(CState.IDLE);
         _loc1_ = new AttackDamage(m_player_id,this);
         _loc1_.importAttackDamageData({
            "power":this.m_characterStats.ShieldBreakPower,
            "kbConstant":this.m_characterStats.ShieldBreakKBConstant,
            "weightKB":this.m_characterStats.ShieldBreakWeightKB,
            "atk_id":-1,
            "isForward":!m_facingForward,
            "direction":90,
            "dizzy":90,
            "xloc":m_sprite.x,
            "yloc":m_sprite.y,
            "hurtSelf":true,
            "bypassHeavyArmor":true
         });
         this.killAllSpeeds();
         this.m_shieldPower = 60;
         this.takeDamage(_loc1_);
         this.playGlobalSound("shieldbreak");
         if(Boolean(this.m_human) && this.ID > 0)
         {
            Gamepad.rumbleOnShieldBreak(this.ID);
         }
         this.m_dizzyShield = true;
         this.setInvincibility(true);
         this.m_revivalInvincibility.reset();
         this.m_revivalInvincibility.CurrentTime = this.m_revivalInvincibility.MaxTime - 15;
      }
      
      private function removeChargeGlow() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:* = undefined;
         if(this.m_chargeGlowHolderMC == null)
         {
            return;
         }
         _loc1_ = false;
         for(_loc2_ in m_attack.ChargedAttacks)
         {
            if(!_loc1_ && Boolean(this.attackIsCharged(_loc2_)))
            {
               _loc1_ = true;
            }
         }
         if(!_loc1_)
         {
            toggleEffect(this.m_chargeGlowHolderMC,false);
            this.m_chargeGlowHolderMC = null;
         }
      }
      
      override public function isInvincible() : Boolean
      {
         return inState(CState.ATTACKING) && getStanceVar("canHurt",false) || m_invincible || inState(CState.ATTACKING) && m_attack.Invincible || !this.m_revivalInvincibility.IsComplete || !this.m_starmanInvincibilityTimer.IsComplete ? true : false;
      }
      
      public function initRoll(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         STAGEDATA.playSpecificSound("roll_brawl");
         _loc2_ = m_facingForward;
         if(param1)
         {
            m_faceLeft();
         }
         else
         {
            m_faceRight();
         }
         this.m_rollTimer = Math.max(1,this.m_characterStats.GetupRollDelay);
         this.setState(CState.ROLL);
         if(_loc2_ && Boolean(this.m_heldControls.RIGHT) || !_loc2_ && Boolean(this.m_heldControls.LEFT))
         {
            if(Utils.hasLabel(m_sprite.stance,"forward"))
            {
               this.stancePlayFrame("forward");
            }
         }
      }
      
      private function initTechRoll(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         this.killAllSpeeds();
         STAGEDATA.playSpecificSound("roll_brawl");
         _loc2_ = m_facingForward;
         if(param1)
         {
            m_faceLeft();
         }
         else
         {
            m_faceRight();
         }
         this.m_rollTimer = Math.max(1,this.m_characterStats.TechRollDelay);
         this.setState(CState.TECH_ROLL);
         if(_loc2_ && Boolean(this.m_heldControls.RIGHT) || !_loc2_ && Boolean(this.m_heldControls.LEFT))
         {
            if(Utils.hasLabel(m_sprite.stance,"forward"))
            {
               this.stancePlayFrame("forward");
            }
         }
         this.m_justTechedTimer.reset();
      }
      
      private function m_charRoll() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(inState(CState.LEDGE_HANG) && this.shieldIsPressed() && this.m_ledgeHangTimer.CurrentTime > 4)
         {
            this.m_ledgeHangTimer.reset();
            this.m_rollTimer = Math.max(1,this.m_characterStats.ClimbRollDelay);
            m_sprite.x += m_facingForward ? 4 : -4;
            m_sprite.y += 5;
            _loc1_ = 0;
            while(!testTerrainWithCoord(m_sprite.x,m_sprite.y) && _loc1_ < 10)
            {
               m_sprite.x += m_facingForward ? 1 : -1;
               _loc1_++;
            }
            if(_loc1_ >= 10)
            {
               m_sprite.x -= m_facingForward ? _loc1_ : -_loc1_;
            }
            attachToGround();
            this.setState(CState.LEDGE_ROLL);
         }
         else if(inState(CState.LEDGE_HANG) && (m_facingForward && Boolean(this.m_pressedControls.RIGHT) || !m_facingForward && Boolean(this.m_pressedControls.LEFT)) && this.m_ledgeHangTimer.CurrentTime > 4)
         {
            this.m_ledgeHangTimer.reset();
            m_sprite.x += m_facingForward ? 4 : -4;
            m_sprite.y += 5;
            _loc1_ = 0;
            while(!testTerrainWithCoord(m_sprite.x,m_sprite.y) && _loc1_ < 10)
            {
               m_sprite.x += m_facingForward ? 2 : -2;
               _loc1_++;
            }
            if(_loc1_ >= 10)
            {
               m_sprite.x -= m_facingForward ? _loc1_ : -_loc1_;
            }
            m_collision.ground = true;
            this.m_groundCollisionTest();
            this.setState(CState.LEDGE_CLIMB);
         }
         else if(m_collision.ground && inState(CState.CRASH_LAND) && this.m_pressedControls.RIGHT != this.m_pressedControls.LEFT && Boolean(this.m_crashTimer.IsComplete))
         {
            this.initRoll(this.m_pressedControls.RIGHT);
         }
         else if((inState(CState.LEDGE_ROLL) || inState(CState.ROLL)) && !isHitStunOrParalysis())
         {
            attachToGround();
            --this.m_rollTimer;
            if(this.m_rollTimer == 0)
            {
               m_xSpeed = m_facingForward ? Number(this.m_characterStats.RollSpeed) : -this.m_characterStats.RollSpeed;
               this.m_currentRollSpeed = m_xSpeed;
               if(inState(CState.ROLL))
               {
                  m_xSpeed *= -1;
                  this.m_currentRollSpeed = m_xSpeed;
               }
            }
            else if(this.m_rollTimer < 0)
            {
               m_xSpeed = this.m_currentRollSpeed;
               if(m_currentPlatform)
               {
                  m_xSpeed = m_xSpeed < 0 ? -Math.abs(-m_xSpeed * this.m_characterStats.RollDecay * m_currentPlatform.accel_friction) : m_xSpeed * this.m_characterStats.RollDecay * m_currentPlatform.accel_friction;
               }
               else
               {
                  m_xSpeed = m_xSpeed < 0 ? -Math.abs(-m_xSpeed * this.m_characterStats.RollDecay) : m_xSpeed * this.m_characterStats.RollDecay;
               }
               this.m_currentRollSpeed = m_xSpeed;
               this.m_currentRollSpeed = Math.round(m_xSpeed * 10) / 10;
               if(inState(CState.ROLL) && Utils.fastAbs(this.m_currentRollSpeed) < 0.5)
               {
                  m_xSpeed = 0;
               }
            }
         }
         else if(inState(CState.TECH_ROLL) && !isHitStunOrParalysis())
         {
            attachToGround();
            --this.m_rollTimer;
            if(this.m_rollTimer == 0)
            {
               m_xSpeed = m_facingForward ? -this.m_characterStats.RollSpeed : Number(this.m_characterStats.RollSpeed);
               this.m_currentRollSpeed = m_xSpeed;
            }
            else
            {
               m_xSpeed = this.m_currentRollSpeed;
               if(m_currentPlatform)
               {
                  m_xSpeed = m_xSpeed < 0 ? -Math.abs(-m_xSpeed * this.m_characterStats.RollDecay * m_currentPlatform.accel_friction) : m_xSpeed * this.m_characterStats.RollDecay * m_currentPlatform.accel_friction;
               }
               else
               {
                  m_xSpeed = m_xSpeed < 0 ? -Math.abs(-m_xSpeed * this.m_characterStats.RollDecay) : m_xSpeed * this.m_characterStats.RollDecay;
               }
               this.m_currentRollSpeed = m_xSpeed;
               this.m_currentRollSpeed = Math.round(m_xSpeed * 10) / 10;
               if(Utils.fastAbs(this.m_currentRollSpeed) < 0.5)
               {
                  m_xSpeed = 0;
               }
            }
         }
         else if(inState(CState.DODGE_ROLL) && !isHitStunOrParalysis())
         {
            attachToGround();
            --this.m_rollTimer;
            if(this.m_rollTimer == 0)
            {
               m_xSpeed = m_facingForward ? -this.m_characterStats.DodgeSpeed : Number(this.m_characterStats.DodgeSpeed);
               this.m_currentRollSpeed = m_xSpeed;
            }
            else
            {
               if(this.m_characterStats.DodgeDecel > 0)
               {
                  this.m_currentRollSpeed = this.m_currentRollSpeed < 0 ? -Math.abs(-this.m_currentRollSpeed * this.m_characterStats.DodgeDecel) : this.m_currentRollSpeed * this.m_characterStats.DodgeDecel;
               }
               else if(this.m_characterStats.DodgeDecel < 0)
               {
                  if(this.m_currentRollSpeed !== 0)
                  {
                     _loc2_ = this.m_currentRollSpeed > 0 ? Number(this.m_characterStats.DodgeDecel) : -this.m_characterStats.DodgeDecel;
                     this.m_currentRollSpeed += _loc2_;
                     if(this.m_currentRollSpeed < 0 && this.m_currentRollSpeed - _loc2_ > 0 || this.m_currentRollSpeed > 0 && this.m_currentRollSpeed - _loc2_ < 0)
                     {
                        this.m_currentRollSpeed = 0;
                     }
                  }
               }
               m_xSpeed = this.m_currentRollSpeed;
               this.m_currentRollSpeed = Math.round(m_xSpeed * 10) / 10;
               if(Utils.fastAbs(this.m_currentRollSpeed) < 0.5)
               {
                  m_xSpeed = 0;
               }
               if(inState(CState.DODGE_ROLL) && this.m_rollTimer > -9 && this.m_rollTimer < 0 && (Boolean(this.m_pressedControls.GRAB) || this.shieldIsHeld() && Boolean(this.m_pressedControls.BUTTON2) || Boolean(this.m_pressedControls.C_UP) || Boolean(this.m_pressedControls.C_DOWN) || Boolean(this.m_pressedControls.C_RIGHT) || Boolean(this.m_pressedControls.C_LEFT)) && Boolean(this.m_item))
               {
                  this.toToss();
               }
            }
         }
      }
      
      private function initLedgeGrab(param1:MovieClip) : void
      {
         var _loc2_:String = null;
         this.attackCollisionTest();
         m_attackCollisionTestsPreProcessed = true;
         _loc2_ = null;
         this.m_jumpSpeedBuffer = 0;
         if(inState(CState.ATTACKING))
         {
            _loc2_ = m_attack.LedgeFrame;
            this.forceEndAttack();
         }
         m_attack.Rocket = false;
         this.m_ledge = param1;
         this.m_ledgeDelay.reset();
         this.m_glideReady = true;
         this.playGlobalSound("common_cliffcatch");
         this.playCharacterSound("ledge_grab");
         if(Boolean(this.m_human) && this.ID > 0)
         {
            Gamepad.rumbleOnLedgeGrab(this.ID);
         }
         setBrightness(0);
         this.resetRotation();
         Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
         if(inState(CState.SHIELDING))
         {
            this.m_deactivateShield();
         }
         if(STAGEPARENT.getChildByName("energy" + m_player_id) != null)
         {
            STAGEPARENT.removeChild(STAGEPARENT.getChildByName("energy" + m_player_id));
         }
         this.m_jumpCount = 0;
         this.m_airDodgeCount = 0;
         this.m_wallJumpCount = 0;
         this.m_wallStickTime.MaxTime = this.m_characterStats.WallStick;
         this.m_midAirJumpConstantTime.finish();
         this.m_canHover = true;
         this.grabReleaseOpponent();
         m_currentPlatform = null;
         m_collision.ground = false;
         this.resetMovement();
         this.clearControlsBuffer();
         this.setIntangibility(true);
         this.setState(CState.LEDGE_HANG);
         if(_loc2_)
         {
            this.stancePlayFrame(_loc2_);
         }
         m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.CHAR_LEDGE_GRAB,{"caller":this.APIInstance.instance}));
      }
      
      private function attachToLedge(param1:Boolean) : void
      {
         var _loc2_:Number = NaN;
         if(this.m_ledge)
         {
            _loc2_ = Number(Point.distance(new Point(this.m_ledge.x,this.m_ledge.y),new Point(m_sprite.x,m_sprite.y)));
            if(_loc2_ > 500)
            {
               this.unnattachFromLedge();
               this.setState(CState.IDLE);
               this.m_ledge = null;
               this.m_lastLedge = null;
               return;
            }
            m_sprite.x = this.m_ledge.x;
            m_sprite.y = this.m_ledge.y;
            if(this.m_chargeGlowHolderMC != null)
            {
               this.m_chargeGlowHolderMC.x = m_sprite.x;
               this.m_chargeGlowHolderMC.y = m_sprite.y + m_height;
            }
            if(this.HasFinalSmash)
            {
               this.m_fsGlowHolderMC.x = m_sprite.x;
               this.m_fsGlowHolderMC.y = m_sprite.y + m_height;
            }
            this.m_ledgeHangTimer.reset();
            this.killAllSpeeds();
            if(param1)
            {
               m_faceRight();
            }
            else
            {
               m_faceLeft();
            }
            this.m_midAirJumpConstantTime.finish();
         }
      }
      
      private function m_charHang() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         if(Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1)) || !this.m_characterStats.CanGrabLedges)
         {
            return;
         }
         _loc1_ = 0;
         _loc2_ = 0;
         _loc3_ = false;
         if(!inState(CState.LEDGE_HANG) && !inState(CState.LEDGE_ROLL) && !inState(CState.LEDGE_CLIMB) && !this.m_ledgeDelay.IsComplete)
         {
            this.m_ledgeDelay.tick();
            if(this.m_ledgeDelay.IsComplete)
            {
               this.m_lastLedge = null;
            }
         }
         if(!this.m_heldControls.DOWN && Boolean(this.m_ledgeDelay.IsComplete) && !m_collision.ground && !this.m_standby && !(this.HoldingItem && !this.m_item.CanHangWith) && this.inFreeState(CFreeState.ATTACKING | CFreeState.DISABLED) && !(!inState(CState.ATTACKING) && m_ySpeed < 0))
         {
            _loc1_ = 0;
            while(_loc1_ < this.m_ledges[0].length && !inState(CState.LEDGE_HANG))
            {
               _loc3_ = false;
               _loc2_ = 0;
               while(_loc2_ < STAGEDATA.Characters.length && !_loc3_)
               {
                  if(STAGEDATA.Characters[_loc2_].Ledge == this.m_ledges[0][_loc1_])
                  {
                     _loc3_ = true;
                  }
                  _loc2_++;
               }
               if(!_loc3_ && (m_sprite.x < this.m_ledges[0][_loc1_].x || inState(CState.ATTACKING) && m_attack.CanGrabInverseLedges) && this.m_lastLedge != this.m_ledges[0][_loc1_] && !(inState(CState.GRABBING) && !m_facingForward) && !(inState(CState.ATTACKING) && !m_facingForward && m_attack.FacedLedgesOnly && m_sprite.x > this.m_ledges[0][_loc1_].x))
               {
                  if(HasHand && HitBoxSprite.hitTestArray(this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.HAND),HitBoxAnimation(this.m_ledges[0][_loc1_].hitBoxAnim).getHitBoxes(1,HitBoxSprite.LEDGE),Location,new Point(this.m_ledges[0][_loc1_].x,this.m_ledges[0][_loc1_].y),!m_facingForward,false,CurrentScale,new Point(1,1),CurrentRotation,0).length > 0)
                  {
                     this.initLedgeGrab(this.m_ledges[0][_loc1_]);
                     _loc1_--;
                  }
               }
               _loc1_++;
            }
            if(inState(CState.LEDGE_HANG))
            {
               this.attachToLedge(true);
            }
            else
            {
               _loc1_ = 0;
               while(_loc1_ < this.m_ledges[1].length && !inState(CState.LEDGE_HANG))
               {
                  _loc3_ = false;
                  _loc2_ = 0;
                  while(_loc2_ < STAGEDATA.Characters.length && !_loc3_)
                  {
                     if(STAGEDATA.Characters[_loc2_].Ledge == this.m_ledges[1][_loc1_])
                     {
                        _loc3_ = true;
                     }
                     _loc2_++;
                  }
                  if(!_loc3_ && (m_sprite.x > this.m_ledges[1][_loc1_].x || inState(CState.ATTACKING) && m_attack.CanGrabInverseLedges) && this.m_lastLedge != this.m_ledges[1][_loc1_] && !(inState(CState.GRABBING) && m_facingForward) && !(inState(CState.ATTACKING) && m_facingForward && m_attack.FacedLedgesOnly && m_sprite.x < this.m_ledges[1][_loc1_].x))
                  {
                     if(HasHand && HitBoxSprite.hitTestArray(this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.HAND),HitBoxAnimation(this.m_ledges[1][_loc1_].hitBoxAnim).getHitBoxes(1,HitBoxSprite.LEDGE),Location,new Point(this.m_ledges[1][_loc1_].x,this.m_ledges[1][_loc1_].y),!m_facingForward,false,CurrentScale,new Point(1,1),CurrentRotation,0).length > 0)
                     {
                        this.initLedgeGrab(this.m_ledges[1][_loc1_]);
                        _loc1_--;
                     }
                  }
                  _loc1_++;
               }
               if(inState(CState.LEDGE_HANG))
               {
                  this.attachToLedge(false);
               }
            }
         }
      }
      
      override public function unnattachFromGround() : void
      {
         var _loc1_:Platform = null;
         var _loc2_:Number = NaN;
         _loc1_ = m_currentPlatform;
         super.unnattachFromGround();
         if(Boolean(_loc1_) && _loc1_ is MovingPlatform)
         {
            _loc2_ = MovingPlatform(_loc1_).Y - MovingPlatform(_loc1_).PreviousY;
            if(MovingPlatform(_loc1_).conserve_horizontal_momentum)
            {
               m_xSpeed += MovingPlatform(_loc1_).X - MovingPlatform(_loc1_).PreviousX;
            }
            if(Boolean(MovingPlatform(_loc1_).conserve_upward_momentum) && _loc2_ < 0)
            {
               m_ySpeed += _loc2_;
            }
            if(Boolean(MovingPlatform(_loc1_).conserve_downward_momentum) && _loc2_ > 0)
            {
               m_ySpeed += _loc2_;
            }
         }
      }
      
      private function unnattachFromLedge() : void
      {
         if(this.m_ledge != null)
         {
            m_sprite.y += m_height * 1.25 * m_sizeRatio;
            m_sprite.x += m_facingForward ? -m_width * m_sizeRatio : m_width * m_sizeRatio;
            this.m_lastLedge = this.m_ledge;
            this.m_ledge = null;
         }
      }
      
      private function m_checkTeching() : void
      {
         var _loc1_:Boolean = false;
         if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
         {
            return;
         }
         if(this.m_canTech)
         {
            if(this.m_techReady)
            {
               _loc1_ = Boolean(this.m_techTimer.IsComplete);
               this.m_techTimer.tick();
               if(Boolean(this.m_techTimer.IsComplete) && _loc1_)
               {
                  this.m_techReady = false;
               }
               else if(Boolean(this.m_techLetGo) && this.shieldIsPressed())
               {
                  this.m_techReady = false;
                  this.m_canTech = false;
                  this.m_techDelay.reset();
                  this.m_techLetGo = false;
               }
               if(Boolean(this.m_techReady) && !this.shieldIsPressed())
               {
                  this.m_techLetGo = true;
               }
            }
            else if(this.m_techDelay.IsComplete)
            {
               if(Boolean(this.m_techLetGo) && this.shieldIsPressed())
               {
                  this.m_techLetGo = false;
                  this.m_techReady = true;
                  this.m_techTimer.reset();
                  this.m_techDelay.reset();
               }
               else if(!this.shieldIsPressed())
               {
                  this.m_techLetGo = true;
               }
            }
            else
            {
               this.m_techDelay.tick();
            }
         }
         else
         {
            this.m_techDelay.tick();
            if(this.m_techDelay.IsComplete)
            {
               this.m_canTech = true;
               this.m_techDelay.reset();
            }
         }
      }
      
      override public function willFallOffRange(param1:Number, param2:Number, param3:int = 5, param4:int = 85) : Boolean
      {
         if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
         {
            return false;
         }
         return super.willFallOffRange(param1,param2,param3,param4);
      }
      
      override protected function decel_knockback() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         if(m_xKnockback == 0 && m_yKnockback == 0)
         {
            return;
         }
         _loc1_ = m_xKnockback > 0;
         _loc2_ = m_yKnockback < 0;
         if(m_xKnockback != 0)
         {
            m_xKnockback += m_xKnockbackDecay;
         }
         if(m_yKnockback != 0)
         {
            m_yKnockback += m_yKnockbackDecay;
         }
         if(_loc1_ && m_xKnockback < 0 || !_loc1_ && m_xKnockback > 0 || Utils.fastAbs(m_xKnockback) < 0.0001)
         {
            m_xKnockback = 0;
         }
         if(_loc2_ && m_yKnockback > 0 || !_loc2_ && m_yKnockback < 0 || Utils.fastAbs(m_yKnockback) < 0.0001)
         {
            m_yKnockback = 0;
         }
      }
      
      protected function playHurtFrame(param1:String = null) : void
      {
         if(inState(CState.INJURED) || inState(CState.CAUGHT))
         {
            if(param1)
            {
               this.stancePlayFrame(param1);
            }
            else
            {
               this.stancePlayFrame("hurt" + Utils.randomInteger(1,this.m_characterStats.HurtFrames));
            }
         }
      }
      
      override protected function m_forces() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:MovieClip = null;
         if(!inState(CState.CAUGHT) && !inState(CState.BARREL) && !isHitStunOrParalysis() && !inState(CState.DEAD))
         {
            if(inKnockback() && m_collision.ground && m_yKnockback > 0)
            {
               m_yKnockback = 0;
            }
            if(!(m_collision.ground && (inState(CState.FLYING) || inState(CState.INJURED)) && Boolean(this.m_disableHurtFallOff) && this.willFallOffRange(m_sprite.x + m_xKnockback,m_sprite.y)) && !(inState(CState.ATTACKING) && !m_attack.CanFallOff && !SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1) && this.willFallOffRange(m_sprite.x + m_xKnockback,m_sprite.y)))
            {
               this.m_attemptToMove(m_xKnockback,0);
            }
            this.m_attemptToMove(0,m_yKnockback);
            this.decel_knockback();
            if(Main.FRAMERATE == 30)
            {
               if(!(m_collision.ground && (inState(CState.FLYING) || inState(CState.INJURED)) && Boolean(this.m_disableHurtFallOff) && this.willFallOffRange(m_sprite.x + m_xKnockback,m_sprite.y)) && !(inState(CState.ATTACKING) && !m_attack.CanFallOff && !SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1) && this.willFallOffRange(m_sprite.x + m_xKnockback,m_sprite.y)))
               {
                  this.m_attemptToMove(m_xKnockback,0);
               }
               this.m_attemptToMove(0,m_yKnockback);
               this.decel_knockback();
            }
            if(inState(CState.FLYING) || inState(CState.INJURED))
            {
               if(!isHitStunOrParalysis() && inState(CState.INJURED))
               {
                  this.m_hitLagLandDelay.tick();
               }
               if(this.netYSpeed(false,false) >= 0 && !this.m_hasArced)
               {
                  this.m_dustTimer.finish();
                  this.m_hasArced = true;
               }
               if(inState(CState.FLYING) && Boolean(this.m_calcAngles) && currentFrameIs("flying"))
               {
                  _loc1_ = Number(Utils.getAngleBetween(new Point(0,0),new Point(this.netXSpeed(),this.netYSpeed())));
                  _loc2_ = Number(Utils.forceBase360(!m_facingForward ? -_loc1_ : -_loc1_ + 180));
                  m_sprite.rotation = _loc2_;
               }
               if(this.m_hitLag <= 0 && !isHitStunOrParalysis() && !(inState(CState.INJURED) && !this.m_hitLagLandDelay.IsComplete && !this.m_forceTumbleFall))
               {
                  if(Boolean(this.m_forceTumbleFall) && m_collision.ground)
                  {
                     this.initiateCrash();
                  }
                  else if((inState(CState.FLYING) || Boolean(this.m_forceTumbleFall)) && !m_collision.ground)
                  {
                     this.resetRotation();
                     this.m_fallTiltTimer.reset();
                     this.setState(CState.TUMBLE_FALL);
                  }
                  else
                  {
                     this.setState(CState.IDLE);
                  }
                  this.resetRotation();
                  this.m_hitLagLandDelay.reset();
               }
            }
            if(inState(CState.FLYING) && inKnockback() && Boolean(this.m_starKOTimer.IsComplete) && !this.m_dustTimer.IsComplete)
            {
               _loc3_ = this.netXSpeed();
               _loc4_ = this.netYSpeed();
               this.m_dustTimer.tick();
               if(Boolean(STAGEDATA.getQualitySettings().knockback_smoke) && Math.sqrt(Math.pow(_loc4_,2) + Math.pow(_loc3_,2)) >= 2)
               {
                  _loc5_ = STAGEDATA.attachEffectOverlay("dust");
                  _loc5_.width *= m_sizeRatio;
                  _loc5_.height *= m_sizeRatio;
                  if(Utils.safeRandom() > 0.5)
                  {
                     _loc5_.scaleX *= -1;
                  }
                  _loc5_.x = OverlayX + Utils.safeRandomInteger(-8,8);
                  _loc5_.y = OverlayY + Utils.safeRandomInteger(-8,8);
                  _loc5_.rotation = Utils.safeRandomInteger(0,360);
                  _loc5_.alpha = 0.5;
               }
            }
         }
      }
      
      public function isLandingOrSkiddingOrChambering() : Boolean
      {
         return this.isLanding() || this.isSkidding() || this.isJumpChambering() || inState(CState.TECH_GROUND) || inState(CState.TECH_ROLL);
      }
      
      public function isLanding() : Boolean
      {
         return inState(CState.LAND) || inState(CState.HEAVY_LAND);
      }
      
      public function isSkidding() : Boolean
      {
         return inState(CState.SKID);
      }
      
      public function isJumpChambering() : Boolean
      {
         return inState(CState.JUMP_CHAMBER);
      }
      
      public function isStandby() : Boolean
      {
         return this.m_standby;
      }
      
      public function releaseLedge() : void
      {
         if(inState(CState.LEDGE_HANG))
         {
            this.unnattachFromLedge();
            this.setState(CState.IDLE);
         }
         this.m_ledge = null;
         this.m_lastLedge = null;
      }
      
      public function releaseOpponent(param1:int = -1) : void
      {
         var _loc2_:int = 0;
         if(this.m_internalGrabLock)
         {
            return;
         }
         if(this.m_grabbed.length > 0)
         {
            if(param1 >= 0)
            {
               this.m_grabbed[param1].Uncapture();
               this.m_grabbed[param1].setVisibility(true);
               this.m_grabbed.splice(param1,1);
               this.m_justReleased = false;
            }
            else
            {
               _loc2_ = 0;
               while(_loc2_ < this.m_grabbed.length)
               {
                  if(Boolean(this.m_grabbed[_loc2_].Caught()) && !this.m_grabbed[_loc2_].StandBy)
                  {
                     this.m_grabbed[_loc2_].Uncapture();
                     this.m_grabbed[_loc2_].setVisibility(true);
                  }
                  _loc2_++;
               }
               this.m_justReleased = false;
               while(this.m_grabbed.length > 0)
               {
                  this.m_grabbed.splice(0,1);
               }
            }
         }
         if(this.m_grabbed.length == 0 && inState(CState.GRABBING))
         {
            this.setState(CState.IDLE);
         }
      }
      
      public function shootOutOpponent() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Character = null;
         if(this.m_grabbed.length > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < this.m_grabbed.length)
            {
               _loc2_ = this.m_grabbed[_loc1_];
               _loc2_.setVisibility(true);
               _loc2_.Uncapture();
               if(this.m_characterStats.LinkageID == "kirby")
               {
                  _loc2_.shootingStar(m_facingForward,m_uid);
                  _loc2_.dealDamage(10 * Math.min(this.totalMoveDecay("kirby_star_spit"),10));
                  this.queueMove("kirby_star_spit");
               }
               _loc1_++;
            }
            this.m_grabbed = new Vector.<Character>();
         }
      }
      
      public function shootingStar(param1:Boolean, param2:Number) : void
      {
         var shootRight:Boolean = param1;
         var otherPlayerID:Number = param2;
         this.m_starTimer = 13;
         this.playFrame("star");
         this.resetSpeedLevel();
         if(!shootRight)
         {
            m_faceRight();
         }
         else
         {
            m_faceLeft();
         }
         this.killAllSpeeds();
         m_attack.simpleReset();
         m_attack.importAttackStateData({
            "refreshRate":50,
            "canFallOff":true,
            "isForward":!m_facingForward
         });
         m_attack.IsAirAttack = !m_collision.ground;
         m_attack.AttackType = 1;
         m_attack.Frame = "star";
         this.setIntangibility(true);
         this.checkLinkedProjectiles();
         this.setState(CState.KIRBY_STAR);
         this.setVisibility(false);
         toggleEffect(this.m_kirbyStarMC,true);
         this.m_kirbyStarMC.x = m_sprite.x;
         this.m_kirbyStarMC.y = m_sprite.y;
         updateAttackBoxStats(1,{
            "team_id":STAGEDATA.getCharacterByUID(otherPlayerID).Team,
            "otherPlayerID":otherPlayerID
         });
         STAGEDATA.getCharacterByUID(otherPlayerID).stackAttackID(m_attack.AttackID);
         createTimer(1,6,function():void
         {
            setXSpeed(m_facingForward ? -15 : 15);
         });
      }
      
      private function m_charFall() : void
      {
         var _loc1_:Number = NaN;
         if(!m_collision.ground && !isHitStunOrParalysis() && !inState(CState.LEDGE_HANG) && !inState(CState.CAUGHT) && !inState(CState.BARREL) && !inState(CState.LEDGE_ROLL) && !inState(CState.ROLL) && !inState(CState.REVIVAL) && !inState(CState.KIRBY_STAR) && !inState(CState.GLIDING) && !(inState(CState.ATTACKING) && m_attack.Rocket) && Boolean(this.m_starKOTimer.IsComplete) && !inState(CState.WALL_CLING) && !inState(CState.REVIVAL) && !inState(CState.DEAD) && !(STAGEDATA.AirDodge.match(/melee|solo|vsolo|double|vdouble/) && inState(CState.AIR_DODGE)))
         {
            _loc1_ = m_ySpeed;
            if(!inState(CState.FLYING) && !inState(CState.INJURED))
            {
               if(m_ySpeed < m_max_ySpeed)
               {
                  if(!(inState(CState.HOVER) || Boolean(this.m_attackHovering) || !this.m_midAirJumpConstantTime.IsComplete))
                  {
                     if(inState(CState.EGG))
                     {
                        m_ySpeed += m_gravity * 0.75;
                     }
                     else
                     {
                        m_ySpeed += m_gravity;
                     }
                     if(m_ySpeed >= m_max_ySpeed)
                     {
                        m_ySpeed = m_max_ySpeed;
                     }
                  }
               }
            }
            else if(m_ySpeed < m_max_ySpeed)
            {
               m_ySpeed = Math.min(m_ySpeed + m_gravity,m_max_ySpeed);
            }
            if(!SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1) && !this.m_justFellThroughPlatform && Boolean(this.m_pressedControls.DOWN) && m_ySpeed < this.m_characterStats.FastFallSpeed && (m_ySpeed > 0 || this.netYSpeed(true,false) > 0) && !(inState(CState.ATTACKING) && !m_attack.AllowFastFall) && !inState(CState.HOVER) && !this.m_attackHovering && Boolean(this.m_midAirJumpConstantTime.IsComplete) && !inState(CState.STUNNED) && !inState(CState.FROZEN) && !inState(CState.DIZZY) && !inState(CState.PITFALL) && !inState(CState.WALL_CLING) && !inState(CState.SLEEP) && !inState(CState.FLYING) && !inState(CState.INJURED) && !inState(CState.EGG))
            {
               m_ySpeed = this.m_characterStats.FastFallSpeed;
               if(!(inState(CState.ATTACKING) && m_attack.AirEase >= 0 && !inState(CState.HOVER) && !this.m_attackHovering && !inState(CState.HOVER) && Boolean(this.m_midAirJumpConstantTime.IsComplete)))
               {
                  this.attachEffect("effect_fastFall");
               }
            }
            if(inState(CState.ATTACKING) && m_attack.AirEase >= 0 && !inState(CState.HOVER) && !this.m_attackHovering && !inState(CState.HOVER) && Boolean(this.m_midAirJumpConstantTime.IsComplete))
            {
               if(m_ySpeed >= m_attack.AirEase)
               {
                  m_ySpeed = m_attack.AirEase;
               }
            }
            if(inState(CState.ATTACKING) && Boolean(this.m_justHit) && m_attack.HitEase != 0 && !this.m_attackHovering && !inState(CState.HOVER) && Boolean(this.m_midAirJumpConstantTime.IsComplete))
            {
               if(m_attack.HitEase > 0 && m_ySpeed > m_attack.HitEase)
               {
                  m_ySpeed = m_attack.HitEase;
               }
               else if(m_attack.HitEase < 0 && m_ySpeed > m_attack.HitEase)
               {
                  m_ySpeed = m_attack.HitEase;
               }
            }
            if(inState(CState.EGG))
            {
               if(m_ySpeed > m_max_ySpeed * 0.5)
               {
                  m_ySpeed = m_max_ySpeed * 0.5;
               }
            }
            if(Boolean(this.m_canHover) && !inState(CState.FLYING) && !inState(CState.INJURED) && this.m_characterStats.MidAirHover > 0 && this.inFreeState() && !inState(CState.HOVER) && (_loc1_ < 0 && m_ySpeed >= 0) && this.jumpIsHeld())
            {
               this.initHover();
            }
            this.m_attemptToMove(0,m_ySpeed);
            if(inState(CState.SHIELDING))
            {
               this.m_deactivateShield();
               this.m_crouchFrame = -1;
               this.resetRotation();
               this.m_fallTiltTimer.reset();
               this.setState(CState.TUMBLE_FALL);
            }
            if(inState(CState.DISABLED))
            {
               ++this.m_blinkTimer;
               if(this.m_blinkTimer >= 2)
               {
                  this.alternateBlink();
               }
            }
            if(Boolean(this.m_glideReady) && !inState(CState.DISABLED) && !inState(CState.FLYING) && !inState(CState.INJURED) && this.jumpIsPressed() && this.m_jumpCount > 0 && !inState(CState.ATTACKING) && this.m_characterStats.GlideSpeed > 0 && !inState(CState.GLIDING) && m_ySpeed > 0)
            {
               this.startGlide();
            }
         }
         else if(!inState(CState.FLYING) && !inState(CState.INJURED) && !inState(CState.ATTACKING) && !isHitStunOrParalysis() && !inState(CState.GLIDING) && Boolean(this.m_midAirJumpConstantTime.IsComplete))
         {
            m_ySpeed = 0;
         }
      }
      
      public function startGlide() : void
      {
         if(!m_collision.ground && !isHitStunOrParalysis() && !inState(CState.LEDGE_HANG) && !this.m_usingSpecialAttack && !inState(CState.CAUGHT) && !inState(CState.BARREL) && !inState(CState.LOCKED) && !inState(CState.LEDGE_ROLL) && !inState(CState.TECH_GROUND) && !inState(CState.TECH_ROLL) && !inState(CState.ROLL) && !inState(CState.REVIVAL) && !inState(CState.FLYING) && !inState(CState.INJURED) && !inState(CState.GLIDING))
         {
            this.forceEndAttack();
            this.m_glideMaxHeight = m_sprite.y;
            this.m_glideAngle = 20;
            this.m_glideDelay = 0;
            this.m_glideReady = false;
            this.setState(CState.GLIDING);
            this.stancePlayFrame("glide");
         }
      }
      
      private function m_charGlide() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(inState(CState.GLIDING))
         {
            if(this.m_glideDelay < 10)
            {
               ++this.m_glideDelay;
            }
            if(this.m_glideDelay >= 10)
            {
               if(Boolean(this.m_heldControls.UP) && !this.m_heldControls.DOWN && this.m_glideAngle > -70)
               {
                  this.m_glideAngle -= 10;
               }
               else if(Boolean(this.m_heldControls.DOWN) && !this.m_heldControls.UP && this.m_glideAngle < 70)
               {
                  this.m_glideAngle += 10;
               }
            }
            _loc1_ = m_sprite.x;
            _loc2_ = m_sprite.y;
            m_xSpeed = (m_facingForward ? this.m_characterStats.GlideSpeed : -this.m_characterStats.GlideSpeed) * Math.cos(this.m_glideAngle * Math.PI / 180);
            m_ySpeed = this.m_characterStats.GlideSpeed * Math.sin(this.m_glideAngle * Math.PI / 180);
            this.m_attemptToMove(m_xSpeed,0);
            this.m_attemptToMove(0,m_ySpeed);
            if(Utils.fastAbs(m_sprite.x - _loc1_) < 0.5)
            {
               ++this.m_glideDelay;
            }
            m_sprite.rotation = m_facingForward ? Number(this.m_glideAngle) : -this.m_glideAngle;
            if(m_sprite.y < this.m_glideMaxHeight || this.m_glideDelay > 40)
            {
               m_sprite.y = _loc2_;
               m_ySpeed = 0;
               this.resetRotation();
               this.m_fallTiltTimer.reset();
               Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
               this.setState(CState.JUMP_FALLING);
               if(this.m_jumpCount >= this.m_characterStats.MaxJump)
               {
                  this.setState(CState.DISABLED);
               }
            }
         }
      }
      
      private function m_charWallCling() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Rectangle = null;
         var _loc3_:Boolean = false;
         this.m_wallClingDelay.tick();
         this.m_wallClingDelay.reset();
         if(inState(CState.WALL_CLING))
         {
            if(this.jumpIsPressed() || Boolean(this.m_heldControls.RIGHT) && m_facingForward || Boolean(this.m_heldControls.LEFT) && !m_facingForward)
            {
               if(this.m_characterStats.WallJump)
               {
                  m_ySpeed = -this.m_characterStats.JumpSpeedMidAir;
                  this.m_wallStickTime.MaxTime -= Math.round(this.m_wallStickTime.MaxTime / 2);
                  if(this.m_wallStickTime.MaxTime < 1)
                  {
                     this.m_wallStickTime.MaxTime = 1;
                  }
                  if(m_facingForward)
                  {
                     m_xSpeed = this.m_characterStats.MaxJumpSpeed / 2;
                  }
                  else
                  {
                     m_xSpeed = -this.m_characterStats.MaxJumpSpeed / 2;
                  }
                  this.setState(CState.JUMP_MIDAIR_RISING);
               }
               else
               {
                  this.setState(CState.JUMP_FALLING);
               }
               this.m_wallClingDelay.reset();
            }
            else
            {
               this.m_wallStickTime.tick();
               if(this.m_wallStickTime.IsComplete)
               {
                  this.m_wallStickTime.MaxTime -= Math.round(this.m_wallStickTime.MaxTime / 2);
                  this.setState(CState.JUMP_FALLING);
                  this.m_wallClingDelay.reset();
               }
            }
         }
         else if(this.inFreeState() && (Boolean(this.m_characterStats.WallJump) || this.m_characterStats.WallStick > 0) && HasHitBox)
         {
            _loc1_ = 0;
            while(_loc1_ < this.m_walls.length)
            {
               _loc2_ = BoundsRect;
               _loc3_ = Boolean(this.m_walls[_loc1_].hitTestRect(BoundsRect));
               if(_loc3_ && (this.m_characterStats.WallStick > 0 || (m_sprite.x > this.m_walls[_loc1_].X && this.jumpIsPressed() || Boolean(this.m_heldControls.RIGHT)) && m_xSpeed <= 0 || m_sprite.x < this.m_walls[_loc1_].X + this.m_walls[_loc1_].Width && ((this.jumpIsPressed() || Boolean(this.m_heldControls.LEFT)) && m_xSpeed <= 0)))
               {
                  if(this.m_characterStats.WallStick <= 0 && Boolean(this.m_characterStats.WallJump) && m_ySpeed >= 0)
                  {
                     m_ySpeed = -this.m_characterStats.JumpSpeedMidAir * Math.pow(0.9,this.m_wallJumpCount);
                     if(this.m_characterStats.WallStick == 0)
                     {
                        ++this.m_wallJumpCount;
                     }
                     if(m_sprite.x > this.m_walls[_loc1_].X && (this.jumpIsPressed() || Boolean(this.m_heldControls.RIGHT)))
                     {
                        m_xSpeed = this.m_characterStats.MaxJumpSpeed / 2;
                        m_faceRight();
                     }
                     else
                     {
                        m_xSpeed = -this.m_characterStats.MaxJumpSpeed / 2;
                        m_faceLeft();
                     }
                     this.setState(CState.JUMP_MIDAIR_RISING);
                     break;
                  }
                  if(this.m_characterStats.WallStick > 0 && (m_sprite.x > this.m_walls[_loc1_].X && Boolean(this.m_heldControls.LEFT) || m_sprite.x < this.m_walls[_loc1_].X + this.m_walls[_loc1_].Width && Boolean(this.m_heldControls.RIGHT)) && Boolean(this.m_wallClingDelay.IsComplete))
                  {
                     if(m_sprite.x > this.m_walls[_loc1_].X)
                     {
                        m_faceRight();
                     }
                     else
                     {
                        m_faceLeft();
                     }
                     this.setState(CState.WALL_CLING);
                     this.m_wallStickTime.reset();
                     break;
                  }
               }
               _loc1_++;
            }
         }
      }
      
      private function resetSmashTimers() : void
      {
         this.m_smashTimer = 0;
         this.m_smashTimerUp = 0;
         this.m_smashTimerDown = 0;
         this.m_smashTimerSide = 0;
         this.m_upSpecialTimer = 0;
      }
      
      private function killSmashTimers() : void
      {
         this.m_smashTimer = 99;
         this.m_smashTimerUp = 99;
         this.m_smashTimerDown = 99;
         this.m_smashTimerSide = 99;
         this.m_upSpecialTimer = 99;
      }
      
      private function neutralSpecialFlipCheck(param1:String) : void
      {
         if(Boolean(!this.m_specialTurnTimer.IsComplete && param1 && m_attackData.getAttack(param1)) && Boolean(!m_attackData.getAttack(param1).IsDisabled) && m_attackData.getAttack(param1).Enabled)
         {
            if(!m_facingForward && Boolean(this.m_specialTurnRight))
            {
               m_faceRight();
            }
            else if(m_facingForward && !this.m_specialTurnRight)
            {
               m_faceLeft();
            }
         }
      }
      
      private function attackFlipCheck(param1:String) : void
      {
         if(Boolean(param1 && m_attackData.getAttack(param1)) && Boolean(!m_attackData.getAttack(param1).IsDisabled) && m_attackData.getAttack(param1).Enabled)
         {
            if(Boolean(this.m_heldControls.RIGHT) && !m_facingForward)
            {
               m_faceRight();
            }
            else if(Boolean(this.m_heldControls.LEFT) && m_facingForward)
            {
               m_faceLeft();
            }
         }
      }
      
      private function attackButtonsHeld() : Boolean
      {
         return (Boolean(this.m_heldControls.BUTTON2) || Boolean(this.m_heldControls.GRAB)) && m_attack.AttackType == 1 || Boolean(this.m_heldControls.BUTTON1) && m_attack.AttackType == 2;
      }
      
      private function attackButtonsPressed() : Boolean
      {
         return (Boolean(this.m_heldControls.BUTTON2) || Boolean(this.m_heldControls.GRAB)) && m_attack.AttackType == 1 || Boolean(this.m_pressedControls.BUTTON1) && m_attack.AttackType == 2;
      }
      
      private function m_charAttack() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:Character = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Platform = null;
         var _loc10_:Boolean = false;
         var _loc11_:Vector.<HitBoxCollisionResult> = null;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Point = null;
         var _loc17_:Point = null;
         var _loc18_:Point = null;
         var _loc19_:int = 0;
         _loc1_ = 0;
         var _loc20_:Boolean = inState(CState.ATTACKING);
         if(Boolean(this.m_heldControls.LEFT) || Boolean(this.m_heldControls.RIGHT))
         {
            this.m_specialTurnRight = Boolean(this.m_heldControls.RIGHT) && !this.m_heldControls.LEFT ? true : (Boolean(this.m_heldControls.LEFT) && !this.m_heldControls.RIGHT ? false : Boolean(this.m_specialTurnRight));
            this.m_specialTurnTimer.reset();
         }
         if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
         {
            this.killSmashTimers();
         }
         if(this.m_finalSmashCutinMC)
         {
            if(!this.m_finalSmashCutinMC.parent)
            {
               this.m_finalSmashCutinMC = null;
               STAGEDATA.CamRef.deleteForcedTarget(m_sprite);
               --STAGEDATA.FSCutins;
            }
         }
         if(!(this.HoldingItem && !this.m_item.CanAttackWith) && Boolean(this.m_charIsFull) && this.m_attackDelay <= 0 && !this.isLandingOrSkiddingOrChambering())
         {
            if(this.m_pressedControls.BUTTON2)
            {
               this.m_charIsFull = false;
               this.m_justReleased = true;
               this.Attack("b",1);
            }
            else if((Boolean(this.m_pressedControls.BUTTON1) || Boolean(this.m_pressedControls.DOWN)) && !SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
            {
               this.m_charIsFull = false;
               this.m_justReleased = true;
               this.Attack("b",2);
            }
         }
         else if(inState(CState.ATTACKING) && this.m_grabbed.length > 0 && this.m_currentPower == null && this.m_characterStats.LinkageID == "kirby" && (m_attack.Frame == "b" || m_attack.Frame == "b_air") && Boolean(this.m_justReleased))
         {
            if(currentStanceFrameIs("sucking"))
            {
               if(m_attack.AttackType == 2)
               {
                  this.setStanceVar("power",this.m_grabbed[0].KirbyPower);
                  _loc2_ = 0;
                  while(_loc2_ < this.m_grabbed.length)
                  {
                     this.m_grabbed[_loc2_].dealDamage(6);
                     _loc2_++;
                  }
                  this.stancePlayFrame("swallow");
               }
               else
               {
                  this.stancePlayFrame("spit");
               }
            }
         }
         if(this.HoldingItem && currentFrameIs("a"))
         {
         }
         if(this.inFreeState(CFreeState.ATTACKING | CFreeState.GLIDING | CFreeState.JUMP_CHAMBER) && !m_delayPlayback && !this.isNonInterruptableAttack() && this.m_attackDelay <= 0 && !(this.HoldingItem && !this.m_item.CanAttackWith))
         {
            if(m_collision.ground)
            {
               if(inState(CState.CROUCH) && !this.m_heldControls.UP)
               {
                  if(Boolean(this.m_pressedControls.BUTTON2) || Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1)) && Boolean(this.m_heldControls.BUTTON2))
                  {
                     if((Boolean(this.m_heldControls.DOWN) || Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1)) && Boolean(this.m_heldControls.DOWN)) && !this.m_heldControls.LEFT && !this.m_heldControls.RIGHT && this.m_smashTimer < 4 && this.m_crouchLength < 3 && Utils.fastAbs(m_xSpeed) < 0.5)
                     {
                        this.Attack("a_down",1);
                     }
                  }
                  else if((Boolean(this.m_pressedControls.BUTTON1) || Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1)) && Boolean(this.m_heldControls.BUTTON1)) && !inState(CState.JUMP_CHAMBER))
                  {
                     if(this.m_heldControls.LEFT !== this.m_heldControls.RIGHT)
                     {
                        if(this.m_heldControls.UP)
                        {
                           this.attackFlipCheck("b_up");
                           this.Attack("b_up",2);
                        }
                        else if(this.m_heldControls.DOWN)
                        {
                           this.attackFlipCheck("b_down");
                           this.Attack("b_down",2);
                        }
                        else
                        {
                           this.attackFlipCheck("b_forward");
                           this.Attack("b_forward",2);
                        }
                     }
                     else if(this.m_heldControls.DOWN)
                     {
                        this.Attack("b_down",2);
                     }
                     else if(this.HasFinalSmash && !this.m_transformingSpecial && !STAGEDATA.ItemsRef.PlayerUsingSmashBall)
                     {
                        this.m_useFinalSmash();
                     }
                     else
                     {
                        this.Attack("b",2);
                     }
                  }
                  else if(Boolean(this.m_pressedControls.C_UP) && !this.m_pressedControls.C_DOWN || Boolean(this.m_pressedControls.C_DOWN) && !this.m_pressedControls.C_UP || Boolean(this.m_pressedControls.C_LEFT) && !this.m_pressedControls.C_RIGHT || Boolean(this.m_pressedControls.C_RIGHT) && !this.m_pressedControls.C_LEFT)
                  {
                     if(this.m_pressedControls.C_UP)
                     {
                        this.Attack("a_up",1,true);
                     }
                     else if(this.m_pressedControls.C_LEFT)
                     {
                        if(inState(CState.DASH))
                        {
                           m_xSpeed = 0;
                        }
                        m_faceLeft();
                        this.Attack("a_forwardsmash",1,true);
                     }
                     else if(this.m_pressedControls.C_RIGHT)
                     {
                        if(inState(CState.DASH))
                        {
                           m_xSpeed = 0;
                        }
                        m_faceRight();
                        this.Attack("a_forwardsmash",1,true);
                     }
                     else if(this.m_pressedControls.C_DOWN)
                     {
                        this.Attack("a_down",1,true);
                     }
                  }
               }
               else if(Boolean(this.m_pressedControls.BUTTON2) || Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1)) && Boolean(this.m_heldControls.BUTTON2))
               {
                  if(Boolean(this.m_heldControls.UP) && !(inState(CState.JUMP_CHAMBER) && (Boolean(this.m_heldControls.LEFT) || Boolean(this.m_heldControls.RIGHT))) && this.m_smashTimer < 4)
                  {
                     if(inState(CState.DASH) && Utils.fastAbs(m_xSpeed) > this.m_max_xSpeed)
                     {
                        m_xSpeed = m_xSpeed > 0 ? Number(this.m_max_xSpeed) : -this.m_max_xSpeed;
                     }
                     this.Attack("a_up",1);
                  }
                  else if(this.m_heldControls.UP)
                  {
                     if(inState(CState.DASH) && m_xSpeed != 0)
                     {
                        m_xSpeed = m_xSpeed > 0 ? Number(this.m_max_xSpeed) : -this.m_max_xSpeed;
                     }
                     this.Attack("a_up_tilt",1);
                  }
                  else if(this.m_heldControls.RIGHT != this.m_heldControls.LEFT && this.m_smashTimer < 5 && (!inState(CState.DASH) || m_framesSinceLastState <= 2) && !inState(CState.JUMP_CHAMBER))
                  {
                     if(inState(CState.DASH))
                     {
                        m_xSpeed = 0;
                     }
                     this.attackFlipCheck("a_forwardsmash");
                     this.Attack("a_forwardsmash",1);
                  }
                  else if(!inState(CState.JUMP_CHAMBER) && (Boolean(this.m_heldControls.LEFT) && !this.m_heldControls.RIGHT && !m_facingForward || Boolean(this.m_heldControls.RIGHT) && !this.m_heldControls.LEFT && m_facingForward))
                  {
                     if(!this.m_runningSpeedLevel && !inState(CState.DASH))
                     {
                        this.Attack("a_forward_tilt",1);
                     }
                     else if(Boolean(this.m_runningSpeedLevel) || inState(CState.DASH))
                     {
                        this.Attack("a_forward",1);
                     }
                  }
                  else if(this.m_smashTimer < 4 && Boolean(this.m_heldControls.DOWN) && !inState(CState.DASH) && !inState(CState.JUMP_CHAMBER))
                  {
                     this.Attack("a_down",1);
                  }
                  else if(!inState(CState.DASH))
                  {
                     if(!inState(CState.JUMP_CHAMBER))
                     {
                        if(this.m_heldControls.LEFT != this.m_heldControls.RIGHT)
                        {
                           if(this.m_heldControls.LEFT)
                           {
                              faceLeft();
                           }
                           else
                           {
                              faceRight();
                           }
                           this.Attack("a_forward_tilt",1);
                        }
                        else if(this.m_heldControls.DOWN)
                        {
                           this.Attack("crouch_attack",1);
                        }
                        else
                        {
                           this.Attack("a",1);
                        }
                     }
                  }
               }
               else if((Boolean(this.m_pressedControls.BUTTON1) || Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1)) && Boolean(this.m_heldControls.BUTTON1)) && !inState(CState.JUMP_CHAMBER))
               {
                  if(this.m_heldControls.LEFT !== this.m_heldControls.RIGHT)
                  {
                     if(this.m_heldControls.UP)
                     {
                        if(inState(CState.DASH) && m_xSpeed != 0)
                        {
                           m_xSpeed = m_xSpeed > 0 ? Number(this.m_max_xSpeed) : -this.m_max_xSpeed;
                        }
                        this.attackFlipCheck("b_up");
                        this.Attack("b_up",2);
                     }
                     else if(Boolean(this.m_heldControls.DOWN) && !inState(CState.DASH))
                     {
                        this.attackFlipCheck("b_down");
                        this.Attack("b_down",2);
                     }
                     else
                     {
                        if(inState(CState.DASH))
                        {
                           m_xSpeed = m_xSpeed > 0 ? Number(this.m_max_xSpeed) : (m_xSpeed < 0 ? -this.m_max_xSpeed : 0);
                        }
                        this.attackFlipCheck("b_forward");
                        this.Attack("b_forward",2);
                     }
                  }
                  else if(Boolean(this.m_heldControls.DOWN) && !this.m_heldControls.UP && !inState(CState.DASH))
                  {
                     this.Attack("b_down",2);
                  }
                  else if(Boolean(this.m_heldControls.UP) && !this.m_heldControls.DOWN && !inState(CState.DASH))
                  {
                     this.Attack("b_up",2);
                  }
                  else if(this.HasFinalSmash && !this.m_transformingSpecial && !STAGEDATA.ItemsRef.PlayerUsingSmashBall)
                  {
                     this.m_useFinalSmash();
                  }
                  else if(!inState(CState.DASH))
                  {
                     this.Attack("b",2);
                  }
               }
               else if((Boolean(this.m_pressedControls.BUTTON1) || Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1)) && Boolean(this.m_heldControls.BUTTON1)) && inState(CState.JUMP_CHAMBER))
               {
                  if(this.m_heldControls.UP)
                  {
                     this.attackFlipCheck("b_up");
                     this.Attack("b_up",2);
                  }
               }
               else if(Boolean(this.m_pressedControls.C_UP) || Boolean(this.m_pressedControls.C_DOWN) || Boolean(this.m_pressedControls.C_LEFT) || Boolean(this.m_pressedControls.C_RIGHT))
               {
                  if((!inState(CState.DASH) || m_framesSinceLastState <= 2) && !inState(CState.RUN))
                  {
                     if(Boolean(this.m_pressedControls.C_LEFT) && !inState(CState.JUMP_CHAMBER))
                     {
                        if(inState(CState.DASH))
                        {
                           this.Attack("a_forward",1);
                        }
                        else
                        {
                           m_faceLeft();
                           this.Attack("a_forwardsmash",1,true);
                        }
                     }
                     else if(Boolean(this.m_pressedControls.C_RIGHT) && !inState(CState.JUMP_CHAMBER))
                     {
                        if(inState(CState.DASH))
                        {
                           this.Attack("a_forward",1);
                        }
                        else
                        {
                           m_faceRight();
                           this.Attack("a_forwardsmash",1,true);
                        }
                     }
                     else if(this.m_pressedControls.C_UP)
                     {
                        if(inState(CState.DASH) && Utils.fastAbs(m_xSpeed) > this.m_max_xSpeed)
                        {
                           m_xSpeed = m_xSpeed > 0 ? Number(this.m_max_xSpeed) : -this.m_max_xSpeed;
                        }
                        this.Attack("a_up",1,true);
                     }
                     else if(Boolean(this.m_pressedControls.C_DOWN) && !inState(CState.JUMP_CHAMBER))
                     {
                        if(inState(CState.DASH))
                        {
                           this.Attack("a_forward",1);
                        }
                        else
                        {
                           this.Attack("a_down",1,true);
                        }
                     }
                  }
                  else if((Boolean(this.m_runningSpeedLevel) || inState(CState.DASH)) && Boolean(this.m_pressedControls.C_UP) && !this.m_pressedControls.C_LEFT && !this.m_pressedControls.C_DOWN && !this.m_pressedControls.C_RIGHT)
                  {
                     if(inState(CState.DASH) && Utils.fastAbs(m_xSpeed) > this.m_max_xSpeed)
                     {
                        m_xSpeed = m_xSpeed > 0 ? Number(this.m_max_xSpeed) : -this.m_max_xSpeed;
                     }
                     this.Attack("a_up",1,true);
                  }
                  else if((Boolean(this.m_runningSpeedLevel) || inState(CState.DASH)) && (Boolean(this.m_pressedControls.C_RIGHT) || Boolean(this.m_pressedControls.C_LEFT) || Boolean(this.m_pressedControls.C_DOWN)))
                  {
                     this.Attack("a_forward",1);
                  }
               }
            }
            else if((Boolean(this.m_pressedControls.BUTTON2) || Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1)) && Boolean(this.m_heldControls.BUTTON2) || Boolean(this.m_pressedControls.GRAB) && !this.m_characterStats.TetherGrab) && !this.m_pressedControls.BUTTON1 || (Boolean(this.m_c_buffered_down) || Boolean(this.m_c_buffered_left) || Boolean(this.m_c_buffered_right)))
            {
               if(Boolean(this.m_heldControls.DOWN) && !this.m_c_buffered_left && !this.m_c_buffered_right || Boolean(this.m_c_buffered_down))
               {
                  this.Attack("a_air_down",1);
               }
               else if((Boolean(this.m_heldControls.LEFT) && !this.m_heldControls.RIGHT && !this.m_c_buffered_left && !this.m_c_buffered_right && !this.m_c_buffered_down || inState(CState.GLIDING) && !m_facingForward || Boolean(this.m_c_buffered_left) && !m_facingForward) && !m_facingForward || (!this.m_heldControls.LEFT && Boolean(this.m_heldControls.RIGHT) && !this.m_c_buffered_left && !this.m_c_buffered_right && !this.m_c_buffered_down || inState(CState.GLIDING) && m_facingForward || Boolean(this.m_c_buffered_right) && m_facingForward) && m_facingForward)
               {
                  this.Attack("a_air_forward",1);
               }
               else if(Boolean(this.m_heldControls.LEFT) && !this.m_heldControls.RIGHT && m_facingForward && !this.m_c_buffered_left && !this.m_c_buffered_right && !this.m_c_buffered_down || Boolean(this.m_heldControls.RIGHT) && !this.m_heldControls.LEFT && !m_facingForward && !this.m_c_buffered_left && !this.m_c_buffered_right && !this.m_c_buffered_down || Boolean(this.m_c_buffered_left) && m_facingForward || Boolean(this.m_c_buffered_right) && !m_facingForward)
               {
                  this.Attack("a_air_backward",1);
               }
               else if(Boolean(this.m_heldControls.UP) && !this.m_c_buffered_left && !this.m_c_buffered_right && !this.m_c_buffered_down)
               {
                  this.Attack("a_air_up",1);
               }
               else
               {
                  this.Attack("a_air",1);
               }
            }
            else if((Boolean(this.m_pressedControls.BUTTON1) || Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1)) && Boolean(this.m_heldControls.BUTTON1)) && !inState(CState.GLIDING))
            {
               if(Boolean(this.m_heldControls.LEFT) && !this.m_heldControls.RIGHT || Boolean(this.m_heldControls.RIGHT) && !this.m_heldControls.LEFT)
               {
                  if(this.m_heldControls.UP)
                  {
                     this.attackFlipCheck("b_up_air");
                     this.Attack("b_up_air",2);
                  }
                  else if(this.m_heldControls.DOWN)
                  {
                     this.attackFlipCheck("b_down_air");
                     this.Attack("b_down_air",2);
                  }
                  else
                  {
                     this.attackFlipCheck("b_forward_air");
                     this.Attack("b_forward_air",2);
                  }
               }
               else if(this.m_heldControls.DOWN)
               {
                  this.Attack("b_down_air",2);
               }
               else if(this.m_heldControls.UP)
               {
                  this.Attack("b_up_air",2);
               }
               else if(this.HasFinalSmash && !this.m_transformingSpecial && m_attackData.getAttack("special").CanUseInAir && !STAGEDATA.ItemsRef.PlayerUsingSmashBall)
               {
                  this.m_useFinalSmash();
               }
               else
               {
                  this.neutralSpecialFlipCheck("b_air");
                  this.Attack("b_air",2);
               }
            }
            else if(Boolean(this.m_pressedControls.C_UP) || Boolean(this.m_pressedControls.C_DOWN) || Boolean(this.m_pressedControls.C_LEFT) || Boolean(this.m_pressedControls.C_RIGHT))
            {
               if(!inState(CState.JUMP_CHAMBER) && !inState(CState.DASH) && !inState(CState.RUN))
               {
                  if(Boolean(this.m_pressedControls.C_LEFT) && !this.m_pressedControls.C_RIGHT)
                  {
                     if(m_facingForward)
                     {
                        this.Attack("a_air_backward",1,true);
                     }
                     else
                     {
                        this.Attack("a_air_forward",1,true);
                     }
                  }
                  else if(!this.m_pressedControls.C_LEFT && Boolean(this.m_pressedControls.C_RIGHT))
                  {
                     if(m_facingForward)
                     {
                        this.Attack("a_air_forward",1,true);
                     }
                     else
                     {
                        this.Attack("a_air_backward",1,true);
                     }
                  }
                  else if(Boolean(this.m_pressedControls.C_UP) && !this.m_pressedControls.C_DOWN)
                  {
                     this.Attack("a_air_up",1,true);
                  }
                  else if(!this.m_pressedControls.C_UP && Boolean(this.m_pressedControls.C_DOWN))
                  {
                     this.Attack("a_air_down",1,true);
                  }
               }
            }
         }
         if(inState(CState.ATTACKING))
         {
            if(inState(CState.ATTACKING) && m_attackData.getAttack(m_attack.Frame).ChargeRetain)
            {
               if((Boolean(this.attackIsCharged(m_attack.Frame)) || (Boolean(this.attackButtonsPressed()) && m_attack.ExecTime > 0 && !m_attack.MustCharge || !m_attackData.getAttack(m_attack.Frame).ChargeInAir && m_attack.IsAirAttack) || Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))) && !currentStanceFrameIs("attack") && !currentStanceFrameIs("attack2") && !currentStanceFrameIs(undefined))
               {
                  m_attack.ChargeTime = m_attackData.getAttack(m_attack.Frame).ChargeTime;
                  this.playFrame(m_attack.Frame);
                  if(m_attack.Frame == "item")
                  {
                     this.updateItemHolding();
                  }
                  if(this.attackIsCharged(m_attack.Frame))
                  {
                     if(!(this.HoldingItem && currentFrameIs("item")))
                     {
                        this.stancePlayFrame(Utils.hasLabel(m_sprite.stance,"attack2") ? "attack2" : "attack");
                     }
                  }
                  else if(!(this.HoldingItem && currentFrameIs("item")))
                  {
                     this.stancePlayFrame("attack");
                  }
                  this.unsetCharge(m_attack.Frame);
                  this.removeChargeGlow();
                  if(STAGEPARENT.getChildByName("energy" + m_player_id) != null)
                  {
                     STAGEPARENT.removeChild(STAGEPARENT.getChildByName("energy" + m_player_id));
                  }
               }
               else if(m_attackData.getAttack(m_attack.Frame).ChargeTime < m_attackData.getAttack(m_attack.Frame).ChargeTimeMax && !this.attackIsCharged(m_attack.Frame) && currentStanceFrameIs("charging") && !currentStanceFrameIs("attack") && !currentStanceFrameIs("attack2") && !(!m_attackData.getAttack(m_attack.Frame).ChargeInAir && m_attack.IsAirAttack))
               {
                  this.incrementCharge(m_attack.Frame,m_attack.LinkCharge);
                  if(STAGEPARENT.getChildByName("energy" + m_player_id) != null && MovieClip(STAGEPARENT.getChildByName("energy" + m_player_id)).percentage != null)
                  {
                     MovieClip(STAGEPARENT.getChildByName("energy" + m_player_id)).percentage.scaleX = m_attackData.getAttack(m_attack.Frame).ChargeTime / m_attackData.getAttack(m_attack.Frame).ChargeTimeMax;
                     STAGEPARENT.getChildByName("energy" + m_player_id).x = m_sprite.x + STAGE.x;
                     STAGEPARENT.getChildByName("energy" + m_player_id).y = m_sprite.y + STAGE.y;
                  }
               }
               if(inState(CState.ATTACKING) && m_attackData.getAttack(m_attack.Frame).ChargeTime >= m_attackData.getAttack(m_attack.Frame).ChargeTimeMax && !this.attackIsCharged(m_attack.Frame) && !currentStanceFrameIs("attack") && !currentStanceFrameIs("attack2") && !(!m_attackData.getAttack(m_attack.Frame).ChargeInAir && m_attack.IsAirAttack))
               {
                  this.setCharge(m_attack.Frame,m_attack.LinkCharge);
                  if(!m_attackData.getAttack(m_attack.Frame).ForceUseAtMaxCharge)
                  {
                     if(this.m_chargeGlowHolderMC == null)
                     {
                        if(m_attackData.getAttack(m_attack.Frame).CustomChargeGlow != null)
                        {
                           this.m_chargeGlowHolderMC = ResourceManager.getLibraryMC(m_attackData.getAttack(m_attack.Frame).CustomChargeGlow != null ? m_attackData.getAttack(m_attack.Frame).CustomChargeGlow : "charge_glow");
                        }
                        else
                        {
                           this.m_chargeGlowHolderMC = new MovieClip();
                        }
                        this.m_chargeGlowHolderMC.x = m_sprite.x;
                        this.m_chargeGlowHolderMC.y = m_sprite.y;
                        toggleEffect(this.m_chargeGlowHolderMC,true);
                     }
                  }
                  if(STAGEPARENT.getChildByName("energy" + m_player_id) != null)
                  {
                     STAGEPARENT.removeChild(STAGEPARENT.getChildByName("energy" + m_player_id));
                  }
                  this.endAttack();
               }
               else if(inState(CState.ATTACKING) && this.shieldIsPressed() && !currentStanceFrameIs("attack") && !currentStanceFrameIs("attack2") && inState(CState.ATTACKING))
               {
                  if(STAGEPARENT.getChildByName("energy" + m_player_id) != null)
                  {
                     STAGEPARENT.removeChild(STAGEPARENT.getChildByName("energy" + m_player_id));
                  }
                  this.endAttack();
               }
               else if(inState(CState.ATTACKING) && this.m_pressedControls.LEFT != this.m_pressedControls.RIGHT && !currentStanceFrameIs("attack") && !currentStanceFrameIs("attack2") && inState(CState.ATTACKING) && m_collision.ground)
               {
                  this.endAttack();
                  if(STAGEPARENT.getChildByName("energy" + m_player_id) != null)
                  {
                     STAGEPARENT.removeChild(STAGEPARENT.getChildByName("energy" + m_player_id));
                  }
                  this.initDodgeRoll(this.m_pressedControls.RIGHT);
               }
            }
            else if(inState(CState.ATTACKING) && m_attackData.getAttack(m_attack.Frame).ChargeTimeMax > 0)
            {
               if(m_attackData.getAttack(m_attack.Frame).ChargeTime <= 3 && Boolean(this.m_cStickUse) && !currentStanceFrameIs("attack") && !currentStanceFrameIs("attack2") && (Boolean(this.m_heldControls.BUTTON2) && m_attack.AttackType == 1 || Boolean(this.m_heldControls.BUTTON1) && m_attack.AttackType == 2 || Boolean(this.m_heldControls.GRAB)))
               {
                  this.playGlobalSound("chargeclick");
                  this.m_cStickUse = false;
               }
               if((m_attackData.getAttack(m_attack.Frame).ChargeTime >= m_attackData.getAttack(m_attack.Frame).ChargeTimeMax || !this.attackButtonsHeld() && currentStanceFrameIs("charging") && !this.m_cStickUse || Boolean(this.m_cStickUse) && currentStanceFrameIs("charging") || Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))) && !(m_attack.HoldRepeat && Boolean(this.attackButtonsHeld()) && !m_attackData.getAttack(m_attack.Frame).ForceUseAtMaxCharge) && !currentStanceFrameIs("attack") && !currentStanceFrameIs("attack2"))
               {
                  if(this.HoldingItem && currentFrameIs("item") && !currentStanceFrameIs("finish") && !currentStanceFrameIs("attack"))
                  {
                     m_attack.ChargeTime = m_attackData.getAttack(m_attack.Frame).ChargeTime;
                  }
                  else if(!currentStanceFrameIs("attack") && !currentStanceFrameIs("attack2") && !currentStanceFrameIs("finish"))
                  {
                     m_attack.ChargeTime = m_attackData.getAttack(m_attack.Frame).ChargeTime;
                     if(m_attackData.getAttack(m_attack.Frame).ChargeTime >= m_attackData.getAttack(m_attack.Frame).ChargeTimeMax && Boolean(Utils.hasLabel(m_sprite.stance,"attack2")))
                     {
                        this.stancePlayFrame("attack2");
                     }
                     else
                     {
                        this.stancePlayFrame("attack");
                     }
                  }
               }
               else if(m_attackData.getAttack(m_attack.Frame).ChargeTime < m_attackData.getAttack(m_attack.Frame).ChargeTimeMax && currentStanceFrameIs("charging") && !currentStanceFrameIs("attack") && !currentStanceFrameIs("attack2"))
               {
                  this.incrementCharge(m_attack.Frame,m_attack.LinkCharge);
               }
               if(m_attackData.getAttack(m_attack.Frame).ComboMax >= 1 && currentStanceFrameIs("attack"))
               {
                  if(m_attackData.getAttack(m_attack.Frame).ComboMax >= 1)
                  {
                     if(m_attack.ComboTotal < m_attack.ComboMax)
                     {
                        if(!m_attack.ForceComboContinue && (Boolean(this.attackButtonsPressed()) || m_attack.HoldRepeat && Boolean(this.attackButtonsHeld())) && getStanceVar("handled",false))
                        {
                           ++m_attack.ComboTotal;
                           this.setStanceVar("continuePlaying",true);
                           this.setStanceVar("handled",true);
                        }
                        else if(m_attack.ForceComboContinue && Boolean(this.attackButtonsPressed()) && getStanceVar("handled",false))
                        {
                           ++m_attack.ComboTotal;
                           this.setStanceVar("continuePlaying",true);
                           this.setStanceVar("handled",true);
                           if(m_attack.NextComboFrame != null)
                           {
                              this.stancePlayFrame(m_attack.NextComboFrame);
                           }
                           else
                           {
                              this.stancePlayFrame("combo" + m_attack.ComboTotal);
                           }
                        }
                     }
                  }
               }
            }
            else if(inState(CState.ATTACKING) && m_attackData.getAttack(m_attack.Frame).ComboMax >= 1)
            {
               if(!m_attack.ForceComboContinue && (Boolean(this.attackButtonsPressed()) || m_attack.HoldRepeat && Boolean(this.attackButtonsHeld())) && getStanceVar("handled",false))
               {
                  ++m_attack.ComboTotal;
                  if(!this.m_pressedControls.DOWN)
                  {
                  }
                  this.setStanceVar("continuePlaying",true);
                  this.setStanceVar("handled",true);
               }
               else if(m_attack.ForceComboContinue && Boolean(this.attackButtonsPressed()) && getStanceVar("handled",false))
               {
                  ++m_attack.ComboTotal;
                  this.setStanceVar("continuePlaying",true);
                  this.setStanceVar("handled",true);
                  if(m_attack.NextComboFrame != null)
                  {
                     this.stancePlayFrame(m_attack.NextComboFrame);
                  }
                  else
                  {
                     this.stancePlayFrame("combo" + m_attack.ComboTotal);
                  }
               }
            }
            else if(inState(CState.ATTACKING))
            {
               if(m_attack.SecondaryAttack != null && (!m_attack.HoldRepeat && Boolean(this.attackButtonsPressed()) || m_attack.HoldRepeat && Boolean(this.attackButtonsPressed())))
               {
                  this.stancePlayFrame(m_attack.SecondaryAttack);
                  m_attack.SecondaryAttack = null;
               }
            }
         }
         if(inState(CState.ATTACKING) && Boolean(this.m_usingSpecialAttack))
         {
            if(this.m_characterStats.SpecialType == 1)
            {
               if(HasTouchBox)
               {
                  _loc1_ = 0;
                  while(_loc1_ < this.m_grabbed.length)
                  {
                     this.repositionGrabbedCharacter(_loc1_);
                     _loc1_++;
                  }
               }
            }
            else if(this.m_characterStats.SpecialType == 2 || this.m_characterStats.SpecialType == 3)
            {
               if(m_attack.ExecTime == 1)
               {
                  _loc3_ = m_sprite.x;
                  _loc4_ = m_sprite.y;
                  _loc5_ = 0;
                  while(_loc5_ < STAGEDATA.Characters.length)
                  {
                     _loc6_ = STAGEDATA.Characters[_loc5_];
                     if(_loc6_ !== this)
                     {
                        _loc7_ = (m_sprite.x + _loc6_.X) / 2;
                        _loc8_ = (m_sprite.y - m_height + _loc6_.Y) / 2;
                        _loc9_ = m_currentPlatform;
                        _loc10_ = this.testGroundWithCoord(_loc7_,_loc8_) != null;
                        _loc11_ = null;
                        m_currentPlatform = _loc9_;
                        if(HasRange && !_loc6_.StandBy && !_loc6_.IsCaught && !_loc6_.inState(CState.CRASH_GETUP) && !_loc6_.inState(CState.CRASH_LAND) && !_loc6_.Invincible && !_loc6_.Dead && !_loc6_.Hanging && !_loc6_.AirDodge && !_loc6_.SidestepDodge && (_loc11_ = HitBoxSprite.hitTestArray(this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.RANGE),_loc6_.CurrentAnimation.getHitBoxes(_loc6_.CurrentFrameNum,HitBoxSprite.HIT),Location,_loc6_.Location,!m_facingForward,!_loc6_.FacingForward,CurrentScale,_loc6_.CurrentScale,CurrentRotation,_loc6_.CurrentRotation)).length > 0 && !(_loc6_.Team == m_team_id && m_team_id > 0) && !_loc10_ && !_loc6_.UsingFinalSmash)
                        {
                           _loc6_.Capture(m_uid);
                           this.m_grabbed.push(_loc6_);
                           m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.CHAR_GRAB,{
                              "caller":this.APIInstance.instance,
                              "grabbed":_loc6_.APIInstance.instance
                           }));
                           _loc12_ = m_sprite.x;
                           _loc13_ = m_sprite.y;
                           _loc12_ *= m_sizeRatio;
                           _loc13_ *= m_sizeRatio;
                           if(Boolean(this.m_characterStats.FSMagnet) && (m_facingForward && m_sprite.x < _loc6_.X || !m_facingForward && m_sprite.x > _loc6_.X))
                           {
                              _loc3_ = _loc6_.X;
                              _loc4_ = _loc6_.Y;
                           }
                           _loc6_.MC.x += (m_sprite.x + _loc12_ - _loc6_.X) / 10;
                           _loc6_.MC.y += (m_sprite.y + _loc13_ - _loc6_.Y) / 10;
                        }
                     }
                     _loc5_++;
                  }
                  if(this.m_characterStats.FSMagnet)
                  {
                     m_sprite.x = _loc3_;
                     m_sprite.y = _loc4_;
                     _loc1_ = 0;
                     while(_loc1_ < this.m_grabbed.length)
                     {
                        this.m_grabbed[_loc1_].X = m_sprite.x;
                        this.m_grabbed[_loc1_].Y = m_sprite.y;
                        _loc1_++;
                     }
                  }
                  if(this.m_grabbed.length > 0)
                  {
                     m_xSpeed = 0;
                     m_ySpeed = 0;
                  }
               }
               else if(m_attack.ExecTime > 1)
               {
                  _loc1_ = 0;
                  while(_loc1_ < this.m_grabbed.length)
                  {
                     if(!HasTouchBox && Math.sqrt(Math.pow(m_sprite.x - this.m_grabbed[_loc1_].X,2) + Math.pow(m_sprite.y - this.m_grabbed[_loc1_].Y,2)) > 2)
                     {
                        _loc14_ = 0;
                        _loc15_ = 0;
                        _loc14_ *= m_sizeRatio;
                        _loc15_ *= m_sizeRatio;
                        this.m_grabbed[_loc1_].MC.x += (m_sprite.x + _loc14_ - this.m_grabbed[_loc1_].X) / 10;
                        this.m_grabbed[_loc1_].MC.y += (m_sprite.y + _loc15_ - this.m_grabbed[_loc1_].Y) / 10;
                     }
                     else
                     {
                        this.repositionGrabbedCharacter(_loc1_);
                     }
                     _loc1_++;
                  }
               }
            }
            else if(this.m_characterStats.SpecialType == 4)
            {
               --this.m_transformLimit;
               if(this.m_transformLimit > 0)
               {
                  if(getStanceVar("canTarget",true))
                  {
                     if(this.m_attachedReticule == null)
                     {
                        this.m_attachedReticule = STAGEDATA.attachUniqueMovieHUD(this.m_characterStats.LinkageID + "_targetreticule");
                        _loc17_ = new Point(Main.Width / 2,Main.Height / 2);
                        this.m_attachedReticule.x = STAGEDATA.HudForegroundRef.globalToLocal(_loc17_).x;
                        this.m_attachedReticule.y = STAGEDATA.HudForegroundRef.globalToLocal(_loc17_).y;
                     }
                     if(!m_attackData.getAttack("special").LockXTarget)
                     {
                        if(Boolean(this.m_heldControls.RIGHT) && !this.m_heldControls.LEFT)
                        {
                           this.m_attachedReticule.x += 8;
                        }
                        else if(Boolean(this.m_heldControls.LEFT) && !this.m_heldControls.RIGHT)
                        {
                           this.m_attachedReticule.x -= 8;
                        }
                     }
                     if(!m_attackData.getAttack("special").LockYTarget)
                     {
                        if(Boolean(this.m_heldControls.UP) && !this.m_heldControls.DOWN)
                        {
                           this.m_attachedReticule.y -= 8;
                        }
                        else if(Boolean(this.m_heldControls.DOWN) && !this.m_heldControls.UP)
                        {
                           this.m_attachedReticule.y += 8;
                        }
                     }
                     _loc16_ = STAGEDATA.HudForegroundRef.localToGlobal(new Point(this.m_attachedReticule.x,this.m_attachedReticule.y));
                     if(_loc16_.x < 0)
                     {
                        _loc16_.x = 0;
                     }
                     if(_loc16_.x > Main.Width)
                     {
                        _loc16_.x = Main.Width;
                     }
                     if(_loc16_.y < 0)
                     {
                        _loc16_.y = 0;
                     }
                     if(_loc16_.y > Main.Height)
                     {
                        _loc16_.y = Main.Height;
                     }
                     _loc16_ = STAGEDATA.HudForegroundRef.globalToLocal(_loc16_);
                     this.m_attachedReticule.x = _loc16_.x;
                     this.m_attachedReticule.y = _loc16_.y;
                  }
                  if(getStanceVar("canShoot",true))
                  {
                     _loc18_ = new Point(this.m_attachedReticule.x,this.m_attachedReticule.y);
                     if(this.m_heldControls.BUTTON2)
                     {
                        this.stancePlayFrame("standard_attack");
                        Utils.tryToGotoAndStop(this.m_attachedFPS,"standard_attack");
                        _loc18_ = STAGEDATA.HudForegroundRef.localToGlobal(_loc18_);
                        _loc18_ = STAGE.globalToLocal(_loc18_);
                        this.fireProjectile("fs_proj_1",_loc18_.x,_loc18_.y,true);
                     }
                     else if(this.m_heldControls.BUTTON1)
                     {
                        this.stancePlayFrame("special_attack");
                        Utils.tryToGotoAndStop(this.m_attachedFPS,"special_attack");
                        _loc18_ = STAGEDATA.HudForegroundRef.localToGlobal(_loc18_);
                        _loc18_ = STAGE.globalToLocal(_loc18_);
                        this.fireProjectile("fs_proj_2",_loc18_.x,_loc18_.y,true);
                     }
                  }
               }
               else if(this.m_attachedReticule != null)
               {
                  this.stancePlayFrame("end");
                  Utils.tryToGotoAndStop(this.m_attachedFPS,"end");
                  this.m_attachedFPS = null;
                  if(this.m_attachedReticule.parent)
                  {
                     STAGEDATA.HudForegroundRef.removeChild(this.m_attachedReticule);
                  }
                  this.m_attachedReticule = null;
                  STAGEDATA.brightenCamera();
               }
            }
            else if(this.m_characterStats.SpecialType == 5)
            {
               --this.m_transformLimit;
            }
            else if(this.m_characterStats.SpecialType == 6)
            {
               if(STAGEDATA.FSCutscene)
               {
                  --this.m_transformLimit;
                  if(this.m_transformLimit < 0)
                  {
                     this.killFSCutscene();
                  }
               }
            }
         }
         this.performAttackChecks();
      }
      
      private function updateCutscenePlaceholders() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         _loc1_ = 0;
         _loc2_ = null;
         if(Boolean(this.m_attachedFPS) && Boolean(this.m_attachedFPS["p1"]))
         {
            _loc3_ = 0;
            while(_loc3_ < this.m_grabbed.length)
            {
               if(this.m_attachedFPS.initialized)
               {
                  _loc2_ = this.m_attachedFPS["p" + (_loc1_ + 1) + "holder"];
                  _loc2_.gotoAndStop(this.m_grabbed[_loc3_].CurrentFrame);
                  if(_loc2_.stance)
                  {
                     _loc2_.stance.gotoAndStop(this.m_grabbed[_loc3_].Stance.currentFrame);
                  }
                  this.m_grabbed[_loc3_].applyPalette(_loc2_);
                  if(this.m_grabbed[_loc3_].PaletteSwapData)
                  {
                     Utils.replacePalette(_loc2_,this.m_grabbed[_loc3_].PaletteSwapData,2);
                  }
               }
               else if(this.m_grabbed[_loc3_].HasStance)
               {
                  _loc2_ = ResourceManager.getLibraryMC(this.m_grabbed[_loc3_].LinkageName);
                  _loc2_.uid = this.m_grabbed[_loc3_].UID;
                  _loc2_.gotoAndStop(this.m_grabbed[_loc3_].CurrentFrame);
                  if(_loc2_.stance)
                  {
                     _loc2_.stance.gotoAndStop(this.m_grabbed[_loc3_].Stance.currentFrame);
                  }
                  this.m_grabbed[_loc3_].applyPalette(_loc2_);
                  if(this.m_grabbed[_loc3_].PaletteSwapData)
                  {
                     Utils.replacePalette(_loc2_,this.m_grabbed[_loc3_].PaletteSwapData,2);
                  }
                  _loc2_.bypassTicker = true;
                  if(this.m_attachedFPS["p" + (_loc1_ + 1)])
                  {
                     this.m_attachedFPS["p" + (_loc1_ + 1)].addChild(_loc2_);
                  }
                  else
                  {
                     this.m_attachedFPS["p1"].addChild(_loc2_);
                  }
                  this.m_attachedFPS["p" + (_loc1_ + 1) + "holder"] = _loc2_;
               }
               _loc3_++;
               _loc1_ = (_loc1_ + 1) % 4;
            }
            this.m_attachedFPS.initialized = true;
         }
      }
      
      public function triggerFSCutscene() : void
      {
         var _loc1_:Point = null;
         var _loc2_:int = 0;
         if(!STAGEDATA.FSCutscene)
         {
            this.m_attachedFPS = STAGEDATA.CutsceneRef.addChild(ResourceManager.getLibraryMC(this.m_characterStats.LinkageID + "_hud")) as MovieClip;
            this.m_attachedFPS.stop();
            Utils.recursiveMovieClipPlay(this.m_attachedFPS,false);
            STAGEDATA.FSCutscene = this.m_attachedFPS;
            this.m_attachedFPS.uid = m_uid;
            _loc1_ = new Point(Main.Width / 2,Main.Height);
            this.m_attachedFPS.x = STAGEDATA.CutsceneRef.globalToLocal(_loc1_).x;
            this.m_attachedFPS.y = STAGEDATA.CutsceneRef.globalToLocal(_loc1_).y;
            this.unnattachFromGround();
            this.updateCutscenePlaceholders();
            if(this.m_grabbed.length > 0)
            {
               _loc2_ = 0;
               while(_loc2_ < this.m_grabbed.length)
               {
                  this.repositionGrabbedCharacter(_loc2_);
                  _loc2_++;
               }
            }
         }
      }
      
      public function killFSCutscene() : void
      {
         if(STAGEDATA.FSCutscene)
         {
            STAGEDATA.FSCutscene = null;
            if(Boolean(this.m_attachedFPS) && Boolean(this.m_attachedFPS.parent))
            {
               this.m_attachedFPS.parent.removeChild(this.m_attachedFPS);
            }
            this.m_attachedFPS = null;
         }
      }
      
      private function performAttackChecks() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Boolean = false;
         var _loc5_:Number = NaN;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:Number = NaN;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         var _loc13_:Boolean = false;
         var _loc14_:Boolean = false;
         var _loc15_:Boolean = false;
         var _loc16_:Number = NaN;
         var _loc17_:Vector.<HitBoxCollisionResult> = null;
         var _loc18_:Character = null;
         var _loc19_:Item = null;
         var _loc20_:TargetTestTarget = null;
         _loc1_ = 0;
         _loc2_ = m_xSpeed;
         if(inState(CState.ATTACKING) && (currentFrameIs("stand") || currentFrameIs("fall")) && m_attack.ExecTime > 1)
         {
            this.forceEndAttack();
         }
         if(inState(CState.ATTACKING) && !m_collision.ground && m_attack.CancelWhenAirborne && (!m_attack.IsAirAttack || m_attack.IsAirAttack && m_attack.HasLanded))
         {
            this.forceEndAttack();
         }
         if(inState(CState.ATTACKING) && m_attack.Rotate)
         {
            _loc3_ = Number(Utils.getAngleBetween(new Point(),new Point(m_xSpeed,m_ySpeed)));
            _loc3_ = Number(Utils.forceBase360(m_facingForward ? -_loc3_ : -_loc3_ + 180));
            m_sprite.rotation = _loc3_;
         }
         if(inState(CState.ATTACKING) && (!m_collision.ground && m_attack.AllowControl || m_collision.ground && m_attack.AllowControl && m_attack.AllowControlGround || Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))))
         {
            if(m_collision.ground)
            {
               if(Boolean(this.m_heldControls.RIGHT) && !this.m_heldControls.LEFT)
               {
                  if(m_attack.XSpeedAccel != 0)
                  {
                     m_xSpeed += m_xSpeed < Utils.getSpeedCap(m_attack.XSpeedCap,this.m_characterStats.MaxJumpSpeed) ? m_attack.XSpeedAccel : 0;
                  }
                  else
                  {
                     m_xSpeed += m_xSpeed < Utils.getSpeedCap(m_attack.XSpeedCap,this.m_characterStats.MaxJumpSpeed) ? this.m_characterStats.AccelRate * m_currentPlatform.accel_friction : 0;
                  }
                  if(m_xSpeed !== _loc2_ && m_xSpeed > Utils.getSpeedCap(m_attack.XSpeedCap,this.m_characterStats.MaxJumpSpeed))
                  {
                     m_xSpeed = Utils.getSpeedCap(m_attack.XSpeedCap,this.m_characterStats.MaxJumpSpeed);
                  }
                  else if(m_xSpeed > Utils.getSpeedCap(m_attack.XSpeedCap,this.m_characterStats.MaxJumpSpeed))
                  {
                     if(m_attack.XSpeedDecay == 0)
                     {
                        decel(this.m_characterStats.DecelRate);
                     }
                     else
                     {
                        decel(m_attack.XSpeedDecay);
                     }
                  }
                  if(!(m_collision.ground && !m_attack.CanFallOff && !SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1) && !this.willFallOffRange(m_sprite.x + m_xSpeed,m_sprite.y)))
                  {
                     this.m_attemptToMove(m_xSpeed,0);
                  }
               }
               else if(Boolean(this.m_heldControls.LEFT) && !this.m_heldControls.RIGHT)
               {
                  if(m_attack.XSpeedAccel != 0)
                  {
                     m_xSpeed -= m_xSpeed > -Utils.getSpeedCap(m_attack.XSpeedCap,this.m_characterStats.MaxJumpSpeed) ? m_attack.XSpeedAccel : 0;
                  }
                  else
                  {
                     m_xSpeed -= m_xSpeed > -Utils.getSpeedCap(m_attack.XSpeedCap,this.m_characterStats.MaxJumpSpeed) ? this.m_characterStats.AccelRate * m_currentPlatform.accel_friction : 0;
                  }
                  if(m_xSpeed !== _loc2_ && m_xSpeed < -Utils.getSpeedCap(m_attack.XSpeedCap,this.m_characterStats.MaxJumpSpeed))
                  {
                     m_xSpeed = -Utils.getSpeedCap(m_attack.XSpeedCap,this.m_characterStats.MaxJumpSpeed);
                  }
                  else if(m_xSpeed < -Utils.getSpeedCap(m_attack.XSpeedCap,this.m_characterStats.MaxJumpSpeed))
                  {
                     if(m_attack.XSpeedDecay == 0)
                     {
                        decel(this.m_characterStats.DecelRate);
                     }
                     else
                     {
                        decel(m_attack.XSpeedDecay);
                     }
                  }
                  if(!(m_collision.ground && !m_attack.CanFallOff && !SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1) && !this.willFallOffRange(m_sprite.x + m_xSpeed,m_sprite.y)))
                  {
                     this.m_attemptToMove(m_xSpeed,0);
                  }
               }
            }
            else if(Boolean(this.m_heldControls.RIGHT) && !this.m_heldControls.LEFT)
            {
               if(m_attack.XSpeedAccelAir != 0)
               {
                  m_xSpeed += m_xSpeed < Utils.getSpeedCap(m_attack.XSpeedCap,this.m_characterStats.MaxJumpSpeed) ? m_attack.XSpeedAccelAir : 0;
               }
               else
               {
                  m_xSpeed += m_xSpeed < Utils.getSpeedCap(m_attack.XSpeedCap,this.m_characterStats.MaxJumpSpeed) ? this.m_characterStats.AccelRateAir : 0;
               }
               if(m_xSpeed !== _loc2_ && m_xSpeed > Utils.getSpeedCap(m_attack.XSpeedCap,this.m_characterStats.MaxJumpSpeed))
               {
                  m_xSpeed = Utils.getSpeedCap(m_attack.XSpeedCap,this.m_characterStats.MaxJumpSpeed);
               }
               else if(m_xSpeed > Utils.getSpeedCap(m_attack.XSpeedCap,this.m_characterStats.MaxJumpSpeed))
               {
                  if(m_attack.XSpeedDecayAir != 0)
                  {
                     decel(m_attack.XSpeedDecayAir);
                  }
               }
            }
            else if(Boolean(this.m_heldControls.LEFT) && !this.m_heldControls.RIGHT)
            {
               if(m_attack.XSpeedAccelAir != 0)
               {
                  m_xSpeed -= m_xSpeed > -Utils.getSpeedCap(m_attack.XSpeedCap,this.m_characterStats.MaxJumpSpeed) ? m_attack.XSpeedAccelAir : 0;
               }
               else
               {
                  m_xSpeed -= m_xSpeed > -Utils.getSpeedCap(m_attack.XSpeedCap,this.m_characterStats.MaxJumpSpeed) ? this.m_characterStats.AccelRateAir : 0;
               }
               if(m_xSpeed !== _loc2_ && m_xSpeed < -Utils.getSpeedCap(m_attack.XSpeedCap,this.m_characterStats.MaxJumpSpeed))
               {
                  m_xSpeed = -Utils.getSpeedCap(m_attack.XSpeedCap,this.m_characterStats.MaxJumpSpeed);
               }
               else if(m_xSpeed < -Utils.getSpeedCap(m_attack.XSpeedCap,this.m_characterStats.MaxJumpSpeed))
               {
                  if(m_attack.XSpeedDecayAir != 0)
                  {
                     decel(m_attack.XSpeedDecayAir);
                  }
               }
            }
            if(m_attack.XSpeedCap >= 0 && Utils.fastAbs(m_xSpeed) > m_attack.XSpeedCap)
            {
               m_xSpeed = m_xSpeed > 0 ? m_attack.XSpeedCap : -m_attack.XSpeedCap;
            }
         }
         if(inState(CState.ATTACKING) && m_collision.ground && (m_attack.AllowJump || Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))) && (this.jumpIsPressed() || Boolean(this.m_bufferedAttackJump)) && !isHitStunOrParalysis())
         {
            if(m_attack.JumpCancelAttack || Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1)))
            {
               this.clearControlsBuffer();
               this.forceEndAttack();
               this.resetSmashTimers();
               this.jumpChamber();
            }
            else
            {
               this.unnattachFromGround();
               m_ySpeed = this.m_heldControls.DOWN ? -this.m_characterStats.JumpSpeed * 0.6 : -this.m_characterStats.JumpSpeed;
               if(this.m_charIsFull)
               {
                  m_ySpeed /= 2;
               }
               this.resetRotation();
               Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
               this.attachJumpEffect();
               this.m_jumpEffectTimer.reset();
            }
         }
         else if(inState(CState.ATTACKING) && !m_collision.ground && Boolean(this.m_jumpSpeedMidairDelay.IsComplete) && m_attack.AllowDoubleJump && this.m_jumpCount < this.m_characterStats.MaxJump && (this.jumpIsPressed() || Boolean(this.m_bufferedAttackJump)) && !isHitStunOrParalysis())
         {
            this.m_jumpSpeedMidairDelay.reset();
            ++this.m_jumpCount;
            this.unnattachFromGround();
            m_ySpeed = -this.m_characterStats.JumpSpeedMidAir;
            if(this.m_charIsFull)
            {
               m_ySpeed /= 2;
            }
            this.resetRotation();
            Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
            if(this.m_midAirJumpConstantTime.MaxTime > 0)
            {
               this.m_midAirJumpConstantTime.reset();
            }
            if(m_attack.DoubleJumpCancelAttack && !(this.m_jumpCount > 2 && !this.m_multiJumpDelay.IsComplete))
            {
               this.clearControlsBuffer();
               this.forceEndAttack();
               this.initMidairJump();
            }
         }
         if(inState(CState.ATTACKING) && this.jumpIsPressed() && m_actionShot && !m_paralysis && m_attack.AllowJump && m_collision.ground && this.m_jumpCount < this.m_characterStats.MaxJump)
         {
            this.m_bufferedAttackJump = true;
         }
         if(inState(CState.ATTACKING) && m_attack.AllowRun)
         {
            if(m_collision.ground && getStanceVar("action","standing") && (m_xSpeed != 0 || this.m_heldControls.RIGHT != this.m_heldControls.LEFT))
            {
               this.stancePlayFrame("moving");
            }
            else if(m_collision.ground && getStanceVar("action","moving") && m_xSpeed == 0)
            {
               this.stancePlayFrame("standing");
            }
            else if(m_attack.AllowJump && !m_collision.ground && m_attack.IsAirAttack)
            {
               if(getStanceVar("action","rising") && m_ySpeed > 0)
               {
                  this.stancePlayFrame("falling");
               }
            }
            _loc4_ = m_xSpeed > 0;
            if(!m_collision.ground && this.m_heldControls.RIGHT != this.m_heldControls.LEFT)
            {
               if(this.m_heldControls.RIGHT)
               {
                  if(m_attack.XSpeedAccelAir != 0)
                  {
                     m_xSpeed += m_xSpeed < Utils.getSpeedCap(m_attack.XSpeedCap,this.m_characterStats.MaxJumpSpeed) ? m_attack.XSpeedAccelAir : 0;
                  }
                  else
                  {
                     m_xSpeed += m_xSpeed < Utils.getSpeedCap(m_attack.XSpeedCap,this.m_characterStats.MaxJumpSpeed) ? this.m_characterStats.AccelRateAir : 0;
                  }
               }
               else if(m_attack.XSpeedAccelAir != 0)
               {
                  m_xSpeed -= m_xSpeed > -Utils.getSpeedCap(m_attack.XSpeedCap,this.m_characterStats.MaxJumpSpeed) ? m_attack.XSpeedAccelAir : 0;
               }
               else
               {
                  m_xSpeed -= m_xSpeed > -Utils.getSpeedCap(m_attack.XSpeedCap,this.m_characterStats.MaxJumpSpeed) ? this.m_characterStats.AccelRateAir : 0;
               }
            }
            else if(m_collision.ground && this.m_heldControls.RIGHT != this.m_heldControls.LEFT)
            {
               if(m_attack.XSpeedAccel != 0)
               {
                  if(this.m_heldControls.RIGHT)
                  {
                     m_xSpeed += m_xSpeed < Utils.getSpeedCap(m_attack.XSpeedCap,this.m_characterStats.MaxJumpSpeed) ? m_attack.XSpeedAccel : 0;
                  }
                  else
                  {
                     m_xSpeed -= m_xSpeed > -Utils.getSpeedCap(m_attack.XSpeedCap,this.m_characterStats.MaxJumpSpeed) ? m_attack.XSpeedAccel : 0;
                  }
               }
               else if(this.m_heldControls.RIGHT)
               {
                  m_xSpeed += m_xSpeed < Utils.getSpeedCap(m_attack.XSpeedCap,this.m_characterStats.MaxJumpSpeed) ? this.m_characterStats.AccelRate * m_currentPlatform.accel_friction : 0;
               }
               else
               {
                  m_xSpeed -= m_xSpeed > -Utils.getSpeedCap(m_attack.XSpeedCap,this.m_characterStats.MaxJumpSpeed) ? this.m_characterStats.AccelRate * m_currentPlatform.accel_friction : 0;
               }
               if(!_loc4_ && m_xSpeed > 0 || _loc4_ && m_xSpeed < 0)
               {
                  m_xSpeed = this.m_heldControls.RIGHT ? this.m_characterStats.AccelStart * this.m_norm_xSpeed : this.m_characterStats.AccelStart * -this.m_norm_xSpeed;
                  if(Boolean(Utils.hasLabel(m_sprite.stance,"turn")) && m_sprite.stance.currentLabel != "turn")
                  {
                     this.stancePlayFrame("turn");
                  }
               }
            }
            if(m_attack.XSpeedCap >= 0 && Utils.fastAbs(m_xSpeed) > m_attack.XSpeedCap)
            {
               m_xSpeed = m_xSpeed > 0 ? m_attack.XSpeedCap : -m_attack.XSpeedCap;
            }
            else if(Utils.fastAbs(m_xSpeed) > m_attack.XSpeedCap)
            {
               m_xSpeed = m_xSpeed > 0 ? m_attack.XSpeedCap : -m_attack.XSpeedCap;
            }
            this.resetRotation();
            Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
            if(m_collision.ground && !inState(CState.CAUGHT) && !inState(CState.BARREL))
            {
               attachToGround();
            }
         }
         if(inState(CState.ATTACKING) && !(this.m_heldControls.LEFT != this.m_heldControls.RIGHT && (!m_collision.ground && m_attack.AllowControl || m_collision.ground && m_attack.AllowControl && m_attack.AllowControlGround || m_attack.AllowRun || Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1)))))
         {
            if(m_collision.ground)
            {
               if(m_attack.XSpeedDecay == 0)
               {
                  decel(this.m_characterStats.DecelRate);
               }
               else
               {
                  decel(m_attack.XSpeedDecay);
               }
            }
            else if(!(Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1)) && inState(CState.ATTACKING)))
            {
               if(m_attack.XSpeedDecayAir == 0)
               {
                  decel(this.m_characterStats.DecelRateAir);
               }
               else
               {
                  decel(m_attack.XSpeedDecayAir);
               }
            }
         }
         if(inState(CState.ATTACKING) && (m_attack.AllowTurn && m_sprite.stance.currentLabel != "turn" || Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))))
         {
            if(Boolean(this.m_heldControls.RIGHT) && !this.m_heldControls.LEFT && !m_facingForward)
            {
               m_faceRight();
               m_attack.IsForward = true;
               if(Boolean(Utils.hasLabel(m_sprite.stance,"turn")) && m_sprite.stance.currentLabel != "turn")
               {
                  this.stancePlayFrame("turn");
               }
               if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
               {
                  this.forceEndAttack();
               }
            }
            else if(Boolean(this.m_heldControls.LEFT) && !this.m_heldControls.RIGHT && m_facingForward)
            {
               m_faceLeft();
               m_attack.IsForward = false;
               if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
               {
                  this.forceEndAttack();
               }
            }
         }
         if(inState(CState.ATTACKING) && m_attack.LinkFrames)
         {
            if(!m_collision.ground && !m_attack.IsAirAttack)
            {
               m_attack.IsAirAttack = true;
               _loc5_ = m_attackData.getAttack(m_attack.Frame).ChargeTime;
               m_attack.Frame += "_air";
               m_attackData.getAttack(m_attack.Frame).OverrideMap.clear();
               m_attackData.setAttackVar(m_attack.Frame,"chargetime",_loc5_);
               m_attack.LinkCharge = m_attackData.getAttack(m_attack.Frame).LinkCharge;
               _loc6_ = HasStance ? m_sprite.stance.xframeLink || null : null;
               _loc7_ = HasStance ? m_sprite.stance.xframe || null : null;
               this.playFrame(m_attack.Frame);
               if(HasStance && _loc6_ != null)
               {
                  this.stancePlayFrame(_loc6_);
               }
               if(Boolean(_loc7_) && HasStance)
               {
                  m_sprite.stance.xframe = _loc7_;
               }
            }
            else if(m_collision.ground && m_attack.IsAirAttack)
            {
               m_attack.IsAirAttack = false;
               _loc8_ = m_attackData.getAttack(m_attack.Frame).ChargeTime;
               m_attack.Frame = m_attack.Frame.substring(0,m_attack.Frame.lastIndexOf("_"));
               m_attackData.getAttack(m_attack.Frame).OverrideMap.clear();
               m_attackData.setAttackVar(m_attack.Frame,"chargetime",_loc8_);
               m_attack.LinkCharge = m_attackData.getAttack(m_attack.Frame).LinkCharge;
               _loc9_ = HasStance ? m_sprite.stance.xframeLink : null;
               _loc10_ = HasStance ? m_sprite.stance.xframe || null : null;
               this.playFrame(m_attack.Frame);
               if(HasStance && _loc9_ != null)
               {
                  this.stancePlayFrame(_loc9_);
               }
               if(Boolean(_loc10_) && HasStance)
               {
                  m_sprite.stance.xframe = _loc10_;
               }
            }
         }
         if(inState(CState.ATTACKING))
         {
            m_attack.XLoc = MC.x;
            m_attack.YLoc = MC.y;
            if(m_attack.Cancel && Boolean(this.attackButtonsPressed()) && getStanceVar("waiting",true))
            {
               m_ySpeed = m_collision.ground ? 0 : -4;
               m_attack.Cancel = false;
               m_attack.WasCancelled = true;
               this.stancePlayFrame("finish");
            }
            if(m_attack.AirCancel && (Boolean(this.m_pressedControls.BUTTON2) || Boolean(this.m_pressedControls.C_UP) || Boolean(this.m_pressedControls.GRAB) || Boolean(this.m_pressedControls.C_DOWN) || Boolean(this.m_pressedControls.C_LEFT) || Boolean(this.m_pressedControls.C_RIGHT)) && !m_collision.ground)
            {
               _loc11_ = Boolean(this.m_heldControls.C_UP) || Boolean(this.m_heldControls.C_DOWN) || Boolean(this.m_heldControls.C_LEFT) || Boolean(this.m_heldControls.C_RIGHT);
               _loc12_ = Boolean(this.m_heldControls.UP) && !_loc11_ || Boolean(this.m_heldControls.C_UP);
               _loc13_ = Boolean(this.m_heldControls.DOWN) && !_loc11_ || Boolean(this.m_heldControls.C_DOWN);
               _loc14_ = Boolean(this.m_heldControls.LEFT) && !_loc11_ || Boolean(this.m_heldControls.C_LEFT);
               _loc15_ = Boolean(this.m_heldControls.RIGHT) && !_loc11_ || Boolean(this.m_heldControls.C_RIGHT);
               if(_loc14_ && !_loc15_ && !m_facingForward || _loc15_ && !_loc14_ && m_facingForward)
               {
                  if(m_attack.DisableJump)
                  {
                     this.m_jumpCount = this.m_characterStats.MaxJump;
                  }
                  this.Attack("a_air_forward",1);
               }
               else if(_loc14_ && !_loc15_ && m_facingForward || _loc15_ && !_loc14_ && !m_facingForward)
               {
                  if(m_attack.DisableJump)
                  {
                     this.m_jumpCount = this.m_characterStats.MaxJump;
                  }
                  this.Attack("a_air_backward",1);
               }
               else if(_loc13_)
               {
                  if(m_attack.DisableJump)
                  {
                     this.m_jumpCount = this.m_characterStats.MaxJump;
                  }
                  this.Attack("a_air_down",1);
               }
               else if(_loc12_)
               {
                  if(m_attack.DisableJump)
                  {
                     this.m_jumpCount = this.m_characterStats.MaxJump;
                  }
                  this.Attack("a_air_up",1);
               }
               else
               {
                  if(m_attack.DisableJump)
                  {
                     this.m_jumpCount = this.m_characterStats.MaxJump;
                  }
                  this.Attack("a_air",1);
               }
            }
            else if(m_attack.AirCancelSpecial && Boolean(this.m_pressedControls.BUTTON1) && !m_collision.ground)
            {
               if(this.m_heldControls.UP)
               {
                  if(m_attack.DisableJump)
                  {
                     this.m_jumpCount = this.m_characterStats.MaxJump;
                  }
                  this.Attack("b_up_air",2);
               }
               else if(this.m_heldControls.DOWN)
               {
                  if(m_attack.DisableJump)
                  {
                     this.m_jumpCount = this.m_characterStats.MaxJump;
                  }
                  this.Attack("b_down_air",2);
               }
               else if(Boolean(this.m_heldControls.LEFT) && !this.m_heldControls.RIGHT && !m_facingForward || Boolean(this.m_heldControls.RIGHT) && !this.m_heldControls.LEFT && m_facingForward)
               {
                  if(m_attack.DisableJump)
                  {
                     this.m_jumpCount = this.m_characterStats.MaxJump;
                  }
                  this.Attack("b_forward_air",2);
               }
               else if(Boolean(this.m_heldControls.LEFT) && !this.m_heldControls.RIGHT && m_facingForward || Boolean(this.m_heldControls.RIGHT) && !this.m_heldControls.LEFT && !m_facingForward)
               {
                  if(m_facingForward)
                  {
                     m_faceLeft();
                  }
                  else
                  {
                     m_faceRight();
                  }
                  if(m_attack.DisableJump)
                  {
                     this.m_jumpCount = this.m_characterStats.MaxJump;
                  }
                  this.Attack("b_forward_air",2);
               }
               else
               {
                  if(m_attack.DisableJump)
                  {
                     this.m_jumpCount = this.m_characterStats.MaxJump;
                  }
                  this.neutralSpecialFlipCheck("b_air");
                  this.Attack("b_air",2);
               }
            }
            if(HasHoming)
            {
               if(m_attack.HomingTarget == null)
               {
                  _loc16_ = 99999999;
                  _loc17_ = null;
                  _loc18_ = null;
                  _loc19_ = null;
                  _loc20_ = null;
                  m_attack.HomingTarget = null;
                  _loc1_ = 0;
                  while(_loc1_ < STAGEDATA.ItemsRef.MAXITEMS && m_attack.HomingTarget == null)
                  {
                     _loc19_ = STAGEDATA.ItemsRef.ItemsInUse[_loc1_];
                     if(_loc19_ != null && _loc19_.MC.hitBox != null && _loc19_.IsSmashBall && (_loc17_ = HitBoxSprite.hitTestArray(this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.HOMING),_loc19_.CurrentAnimation.getHitBoxes(_loc19_.CurrentFrameNum,HitBoxSprite.HIT),Location,_loc19_.Location,!m_facingForward,!_loc19_.FacingForward,CurrentScale,_loc19_.CurrentScale,CurrentRotation,_loc19_.CurrentRotation)).length > 0)
                     {
                        m_attack.HomingTarget = _loc19_;
                        m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.HOMING_TARGET,{
                           "caller":this.APIInstance.instance,
                           "target":_loc19_.APIInstance.instance,
                           "type":"Item"
                        }));
                     }
                     _loc1_++;
                  }
                  _loc1_ = 0;
                  while(_loc1_ < STAGEDATA.Characters.length)
                  {
                     _loc18_ = STAGEDATA.Characters[_loc1_];
                     if(_loc18_ != this && !_loc18_.StandBy && !_loc18_.Revival && !_loc18_.AirDodge && _loc18_.HasHitBox && !_loc18_.Dead && !_loc18_.Invincible && (m_attack.HomingTarget == null || this.getDistanceFrom(m_attack.HomingTarget.X,m_attack.HomingTarget.Y) < _loc16_) && (_loc17_ = HitBoxSprite.hitTestArray(this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.HOMING),_loc18_.CurrentAnimation.getHitBoxes(_loc18_.CurrentFrameNum,HitBoxSprite.HIT),Location,_loc18_.Location,!m_facingForward,!_loc18_.FacingForward,CurrentScale,_loc18_.CurrentScale,CurrentRotation,_loc18_.CurrentRotation)).length > 0)
                     {
                        m_attack.HomingTarget = _loc18_;
                        _loc16_ = Number(this.getDistanceFrom(m_attack.HomingTarget.X,m_attack.HomingTarget.Y));
                        m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.HOMING_TARGET,{
                           "caller":this.APIInstance.instance,
                           "target":_loc18_.APIInstance.instance,
                           "type":"Character"
                        }));
                     }
                     _loc1_++;
                  }
                  _loc1_ = 0;
                  while(_loc1_ < STAGEDATA.Targets.length)
                  {
                     _loc20_ = STAGEDATA.Targets[_loc1_];
                     if(_loc20_.inState(TState.IDLE) && (m_attack.HomingTarget == null || this.getDistanceFrom(m_attack.HomingTarget.X,m_attack.HomingTarget.Y) < _loc16_) && (_loc17_ = HitBoxSprite.hitTestArray(this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.HOMING),_loc20_.CurrentAnimation.getHitBoxes(_loc20_.CurrentFrameNum,HitBoxSprite.HIT),Location,_loc20_.Location,!m_facingForward,!_loc20_.FacingForward,CurrentScale,_loc20_.CurrentScale,CurrentRotation,_loc20_.CurrentRotation)).length > 0)
                     {
                        m_attack.HomingTarget = _loc20_;
                        _loc16_ = Number(this.getDistanceFrom(m_attack.HomingTarget.X,m_attack.HomingTarget.Y));
                        m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.HOMING_TARGET,{
                           "caller":this,
                           "target":_loc20_,
                           "type":"Target"
                        }));
                     }
                     _loc1_++;
                  }
               }
            }
            if(inState(CState.ATTACKING) && m_attack.Frame == "item")
            {
               this.updateItemHolding();
            }
         }
      }
      
      private function attachCeilingBounceEffect(param1:Boolean, param2:Boolean) : void
      {
         var _loc3_:MovieClip = null;
         if(STAGEDATA.getQualitySettings().global_effects)
         {
            _loc3_ = STAGEDATA.attachEffectOverlay("ground_bounce");
            _loc3_.rotation = 180;
            _loc3_.width *= m_sizeRatio;
            _loc3_.height *= m_sizeRatio;
            _loc3_.x = OverlayX;
            _loc3_.y = OverlayY - m_height;
            if(param2)
            {
               _loc3_.rotation += param1 ? 45 : -45;
            }
         }
      }
      
      private function attachGroundBounceEffect() : void
      {
         var _loc1_:MovieClip = null;
         if(STAGEDATA.getQualitySettings().global_effects)
         {
            _loc1_ = STAGEDATA.attachEffectOverlay("ground_bounce");
            _loc1_.width *= m_sizeRatio;
            _loc1_.height *= m_sizeRatio;
            _loc1_.x = OverlayX;
            _loc1_.y = OverlayY;
         }
      }
      
      private function attachWallBounceEffect(param1:Boolean, param2:Boolean) : void
      {
         var _loc3_:MovieClip = null;
         if(STAGEDATA.getQualitySettings().global_effects)
         {
            _loc3_ = STAGEDATA.attachEffectOverlay("ground_bounce");
            _loc3_.rotation = !param1 ? 90 : 270;
            _loc3_.width *= m_sizeRatio;
            _loc3_.height *= m_sizeRatio;
            _loc3_.x = OverlayX + (!this.m_flyingRight ? -m_width / 2 * m_sizeRatio : m_width / 2 * m_sizeRatio);
            _loc3_.y = OverlayY - m_height / 2;
            if(param2)
            {
               _loc3_.rotation += param1 ? 45 : -45;
            }
         }
      }
      
      private function attachJumpEffect() : void
      {
         var _loc1_:MovieClip = null;
         if(STAGEDATA.getQualitySettings().global_effects)
         {
            _loc1_ = STAGEDATA.attachEffectOverlay("effect_jump");
            _loc1_.width *= m_sizeRatio;
            _loc1_.height *= m_sizeRatio;
            _loc1_.alpha = 0.75;
            if(!m_facingForward)
            {
               _loc1_.scaleX = -Utils.fastAbs(_loc1_.scaleX);
            }
            _loc1_.x = OverlayX;
            _loc1_.y = OverlayY;
         }
      }
      
      private function attachJumpMidairEffect() : void
      {
         var _loc1_:MovieClip = null;
         if(STAGEDATA.getQualitySettings().global_effects)
         {
            _loc1_ = STAGEDATA.attachEffectOverlay("effect_doublejump");
            _loc1_.width *= m_sizeRatio;
            _loc1_.height *= m_sizeRatio;
            _loc1_.alpha = 0.75;
            if(!m_facingForward)
            {
               _loc1_.scaleX = -Utils.fastAbs(_loc1_.scaleX);
            }
            _loc1_.x = OverlayX;
            _loc1_.y = OverlayY;
         }
      }
      
      private function attachRunEffect() : void
      {
         var _loc1_:MovieClip = null;
         if(STAGEDATA.getQualitySettings().global_effects)
         {
            _loc1_ = STAGEDATA.attachEffectOverlay("effect_run");
            _loc1_.width *= m_sizeRatio;
            _loc1_.height *= m_sizeRatio;
            _loc1_.alpha = 0.75;
            if(!m_facingForward)
            {
               _loc1_.scaleX *= -1;
            }
            _loc1_.x = OverlayX;
            _loc1_.y = OverlayY;
         }
      }
      
      private function attachLandEffect() : void
      {
         var _loc1_:MovieClip = null;
         if(STAGEDATA.getQualitySettings().global_effects)
         {
            _loc1_ = STAGEDATA.attachEffectOverlay("effect_land");
            _loc1_.width *= m_sizeRatio;
            _loc1_.height *= m_sizeRatio;
            _loc1_.alpha = 0.75;
            if(!m_facingForward)
            {
               _loc1_.scaleX *= -1;
            }
            _loc1_.x = OverlayX;
            _loc1_.y = OverlayY;
         }
      }
      
      private function forceEndAttack() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:AttackObject = null;
         var _loc4_:int = 0;
         if(!this.m_safeToEndAttack)
         {
            return;
         }
         this.m_safeToEndAttack = false;
         if(inState(CState.SHIELDING) || inState(CState.SHIELD_DROP) || inState(CState.DODGE_ROLL) || inState(CState.SIDESTEP_DODGE))
         {
            this.m_deactivateShield();
            this.setIntangibility(false);
         }
         _loc1_ = m_state;
         _loc2_ = uint(CState.IDLE);
         _loc3_ = m_attackData.getAttack(m_attack.Frame);
         this.turnOffInvincibility();
         if(inState(CState.ATTACKING))
         {
            if(_loc3_)
            {
               _loc3_.OverrideMap.clear();
            }
            this.killSmashTimers();
            if(!m_collision.ground)
            {
               if(this.m_attackHovering)
               {
                  _loc2_ = uint(CState.HOVER);
               }
               else
               {
                  _loc2_ = uint(CState.JUMP_FALLING);
               }
            }
            else
            {
               this.m_attackHovering = false;
            }
            if(this.m_usingSpecialAttack)
            {
               this.killFSCutscene();
               if(this.m_item2 != null)
               {
                  this.m_item2.destroy();
                  this.m_item2 = null;
               }
               if(!this.m_transformedSpecial)
               {
                  this.FinalSmashMeterCharge = 0;
                  this.m_finalSmashMeterReady = false;
               }
               this.releaseOpponent();
               STAGEDATA.brightenCamera();
            }
            this.m_justReleased = false;
            if(m_attack.Rocket)
            {
               m_attack.Rocket = false;
            }
            if(m_attack.Frame == "item" && this.m_item != null)
            {
               this.m_item.CurrentAttackState.IsAttacking = false;
            }
            if(!this.m_charIsFull)
            {
               this.releaseOpponent();
            }
            this.m_attackDelay = m_attack.AttackDelay;
            if(!m_collision.ground && m_attack.DisableJump)
            {
               this.m_jumpCount = this.m_characterStats.MaxJump;
            }
            m_attack.Frame = null;
            if(Boolean(this.m_usingSpecialAttack) && (this.m_characterStats.SpecialType == 2 || this.m_characterStats.SpecialType == 3))
            {
               this.releaseOpponent();
            }
            this.m_usingSpecialAttack = false;
            if(STAGEPARENT.getChildByName("energy" + m_player_id) != null)
            {
               STAGEPARENT.removeChild(STAGEPARENT.getChildByName("energy" + m_player_id));
            }
            m_attack.Rocket = false;
            if(m_attack.CancelSoundOnEnd)
            {
               this.stopSoundID(this.m_lastSFX);
               this.m_lastSFX = -1;
            }
            if(m_attack.CancelVoiceOnEnd)
            {
               this.stopSoundID(this.m_lastVFX);
               this.m_lastVFX = -1;
            }
         }
         this.resetRotation();
         if(inState(CState.SHIELDING))
         {
            this.m_deactivateShield();
         }
         if(inState(CState.LEDGE_ROLL))
         {
            _loc4_ = 0;
            while(_loc4_ < 10 && !m_collision.ground)
            {
               ++m_sprite.y;
               m_collision.ground = (m_currentPlatform = this.testGroundWithCoord(m_sprite.x,m_sprite.y + 1)) != null;
               _loc4_++;
            }
            if(!m_collision.ground)
            {
               m_sprite.y -= 10;
            }
         }
         else if(inState(CState.ROLL) || inState(CState.DODGE_ROLL) || inState(CState.LEDGE_ROLL))
         {
            m_xSpeed = 0;
         }
         if(inState(CState.ITEM_TOSS))
         {
            if(Boolean(this.m_attackHovering) && !m_collision.ground)
            {
               _loc2_ = uint(CState.HOVER);
            }
            else
            {
               this.m_attackHovering = false;
               _loc2_ = uint(CState.IDLE);
            }
         }
         if(inState(CState.CRASH_GETUP) && this.m_dizzyTimer > 0)
         {
            _loc2_ = uint(CState.DIZZY);
         }
         this.m_attackHovering = false;
         this.m_ledge = null;
         this.m_lastLedge = null;
         this.resetCameraBox();
         m_sprite.camOverride = null;
         if(Boolean(_loc1_ === CState.CAUGHT) && Boolean(this.m_grabberID) && Boolean(STAGEDATA.getCharacterByUID(this.m_grabberID)))
         {
            STAGEDATA.getCharacterByUID(this.m_grabberID).grabRelease();
         }
         if(_loc1_ === CState.ATTACKING || _loc1_ === CState.ITEM_TOSS)
         {
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.CHAR_ATTACK_COMPLETE,{"caller":this.APIInstance.instance}));
         }
         if(m_state === _loc1_)
         {
            if(Boolean(STAGEDATA.AirDodge.match(/melee/)) && inState(CState.AIR_DODGE))
            {
               this.setState(CState.DISABLED);
            }
            else if(!inState(CState.DISABLED) && !inState(CState.DIZZY) && !inState(CState.FROZEN) && !inState(CState.STUNNED) && !this.m_attackHovering)
            {
               this.setState(_loc2_);
            }
         }
         this.m_safeToEndAttack = true;
      }
      
      private function getDistanceFrom(param1:Number, param2:Number) : Number
      {
         return Math.sqrt(Math.pow(param1 - m_sprite.x,2) + Math.pow(param2 - m_sprite.y,2));
      }
      
      private function checkLinkedProjectiles() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.m_projectile.length)
         {
            if(this.m_projectile[_loc1_] != null)
            {
               if(!this.m_projectile[_loc1_].Dead && Boolean(this.m_projectile[_loc1_].ProjectileAttackObj.LinkAttackID))
               {
                  this.m_projectile[_loc1_].Attack.AttackID = m_attack.AttackID;
               }
            }
            _loc1_++;
         }
      }
      
      private function checkSyncedProjectiles() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.m_projectile.length && HasPLockBox)
         {
            if(this.m_projectile[_loc1_] != null)
            {
               if(!this.m_projectile[_loc1_].Dead && Boolean(this.m_projectile[_loc1_].ProjectileAttackObj.LockTrajectory))
               {
                  this.m_projectile[_loc1_].syncPosition();
               }
            }
            _loc1_++;
         }
      }
      
      private function checkDeadProjectiles() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.m_projectile.length)
         {
            if(this.m_projectile[_loc1_] != null && Boolean(this.m_projectile[_loc1_].Dead))
            {
               this.m_projectile[_loc1_] = null;
            }
            _loc1_++;
         }
      }
      
      public function destroyAllProjectiles() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.m_characterStats.MaxProjectile && _loc1_ < this.m_projectile.length)
         {
            if(this.m_projectile[_loc1_] != null)
            {
               this.m_projectile[_loc1_].destroy();
               this.m_projectile[_loc1_] = null;
            }
            _loc1_++;
         }
      }
      
      private function getIndexOfOldestProjectile(param1:String) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = -1;
         _loc3_ = 0;
         while(_loc3_ < this.m_characterStats.MaxProjectile && _loc3_ < this.m_projectile.length)
         {
            if(this.m_projectile[_loc3_] != null && this.m_projectile[_loc3_].ProjectileAttackObj.StatsName == param1 && (_loc2_ < 0 || this.m_projectile[_loc3_].Time > this.m_projectile[_loc2_].Time))
            {
               _loc2_ = _loc3_;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function fireProjectile(param1:*, param2:Number = 0, param3:Number = 0, param4:Boolean = false, param5:Object = null) : Projectile
      {
         var _loc6_:Projectile = null;
         var _loc7_:ProjectileAttack = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         _loc6_ = null;
         _loc7_ = null;
         _loc8_ = 0;
         if(param1 as String)
         {
            _loc7_ = m_attackData.getProjectile(param1);
         }
         else
         {
            _loc7_ = new ProjectileAttack();
            _loc7_.importData(param1);
         }
         if(!param5)
         {
            param5 = {};
         }
         if(_loc7_ != null)
         {
            _loc8_ = 0;
            while(_loc8_ < this.m_characterStats.MaxProjectile && _loc8_ < this.m_projectile.length && !_loc6_)
            {
               if((this.m_projectile[_loc8_] == null || Boolean(this.m_projectile[_loc8_].inState(PState.DEAD)) || _loc7_.LimitOverwrite) && _loc7_.StatsName != null && (this.getProjectileLimit(_loc7_.StatsName) < _loc7_.Limit || _loc7_.LimitOverwrite))
               {
                  _loc9_ = _loc8_;
                  if(_loc7_.LimitOverwrite && this.getProjectileLimit(_loc7_.StatsName) >= _loc7_.Limit)
                  {
                     _loc8_ = int(this.getIndexOfOldestProjectile(_loc7_.StatsName));
                     if(_loc8_ < 0)
                     {
                        return null;
                     }
                     this.m_projectile[_loc8_].destroy();
                     this.m_projectile[_loc8_] = null;
                  }
                  else if(_loc7_.LimitOverwrite)
                  {
                     _loc8_ = int(this.getIndexOfOldestProjectile(_loc7_.StatsName));
                     _loc10_ = 0;
                     while(_loc10_ < this.m_projectile.length)
                     {
                        if(this.m_projectile[_loc10_] == null)
                        {
                           _loc8_ = _loc10_;
                           break;
                        }
                        _loc10_++;
                     }
                     if(_loc8_ < 0)
                     {
                        return null;
                     }
                     if(this.m_projectile[_loc8_])
                     {
                        this.m_projectile[_loc8_].destroy();
                     }
                  }
                  this.m_projectile[_loc8_] = new Projectile({
                     "owner":this,
                     "player_id":m_player_id,
                     "x_start":m_sprite.x,
                     "y_start":m_sprite.y,
                     "sizeRatio":m_sizeRatio,
                     "facingForward":m_facingForward,
                     "chargetime":param5.chargetime || m_attack.ChargeTime,
                     "chargetime_max":param5.chargetime_max || m_attack.ChargeTimeMax,
                     "frame":_loc7_.StatsName + "_proj",
                     "staleMultiplier":this.totalMoveDecay(_loc7_.StatsName + "_proj"),
                     "sizeStatus":this.m_sizeStatus,
                     "terrains":m_terrains,
                     "platforms":m_platforms,
                     "team_id":m_team_id,
                     "volume_sfx":this.m_characterStats.VolumeSFX,
                     "volume_vfx":this.m_characterStats.VolumeVFX
                  },_loc7_,STAGEDATA);
                  _loc6_ = this.m_projectile[_loc8_];
                  this.checkLinkedProjectiles();
                  this.m_lastProjectile = _loc8_;
                  if(param2 != 0 || param3 != 0)
                  {
                     if(param4)
                     {
                        this.m_projectile[_loc8_].X = param2;
                        this.m_projectile[_loc8_].Y = param3;
                        this.m_projectile[_loc8_].safeMove(0,_loc7_.YOffset * m_sizeRatio);
                        this.m_projectile[_loc8_].safeMove(m_facingForward ? _loc7_.XOffset * m_sizeRatio : -_loc7_.XOffset * m_sizeRatio,0);
                     }
                     else
                     {
                        this.m_projectile[_loc8_].safeMove(0,param3 * m_sizeRatio);
                        this.m_projectile[_loc8_].safeMove(m_facingForward ? param2 : -param2,0);
                        this.m_projectile[_loc8_].safeMove(0,_loc7_.YOffset * m_sizeRatio);
                        this.m_projectile[_loc8_].safeMove(m_facingForward ? _loc7_.XOffset * m_sizeRatio : -_loc7_.XOffset * m_sizeRatio,0);
                     }
                  }
                  else
                  {
                     this.m_projectile[_loc8_].safeMove(0,_loc7_.YOffset * m_sizeRatio);
                     this.m_projectile[_loc8_].safeMove(m_facingForward ? _loc7_.XOffset * m_sizeRatio : -_loc7_.XOffset * m_sizeRatio,0);
                  }
                  break;
               }
               _loc8_++;
            }
         }
         return _loc6_;
      }
      
      public function rocketCharacter(param1:Number, param2:Number, param3:Number, param4:Boolean) : void
      {
         if(this.m_characterStats.StatsName == "samus")
         {
            if(inState(CState.LEDGE_CLIMB) || inState(CState.LEDGE_HANG) || inState(CState.LEDGE_ROLL) || inState(CState.GRABBING) || inState(CState.INJURED) || inState(CState.FLYING))
            {
               return;
            }
            if(!(!inState(CState.ATTACKING) || m_attack.Frame.indexOf("b_down") >= 0))
            {
               return;
            }
            if(param2 > 180 && param2 < 360)
            {
               param2 = Number(Utils.forceBase360(90 + (270 - param2)));
            }
            if(inState(CState.SHIELDING))
            {
               this.m_deactivateShield();
               this.setState(CState.IDLE);
            }
            else if(inState(CState.DODGE_ROLL) || inState(CState.SIDESTEP_DODGE))
            {
               this.setState(CState.IDLE);
            }
            if(!this.forceAttack("b_down_air"))
            {
               return;
            }
         }
         else if(this.m_characterStats.StatsName == "ness")
         {
            this.endAttack();
            this.setState(CState.IDLE);
            if(!this.forceAttack("b_up_air"))
            {
               return;
            }
         }
         if(inState(CState.SHIELDING))
         {
            this.m_deactivateShield();
         }
         param2 = Number(Utils.forceBase360(param2));
         this.m_rocketSpeed = param1;
         this.m_rocketAngle = param2;
         this.m_rocketRotation = param4;
         this.m_rocketDecay = param3;
         if(m_collision.ground && (this.m_rocketAngle >= 260 && this.m_rocketAngle <= 280))
         {
            this.endAttack();
            this.resetRotation();
            this.toBounce();
         }
         else
         {
            if(m_collision.ground && (this.m_rocketAngle > 180 && this.m_rocketAngle < 360))
            {
               this.m_rocketAngle = this.m_rocketAngle < 270 ? 180 : 0;
               this.resetRotation();
            }
            m_attack.Rocket = true;
            if(param4)
            {
               if(this.m_rocketAngle <= 90 && this.m_rocketAngle >= 0 || this.m_rocketAngle >= 270 && this.m_rocketAngle < 360)
               {
                  m_faceRight();
               }
               else
               {
                  m_faceLeft();
               }
            }
            if(this.m_rocketAngle < 180 && this.m_rocketAngle > 0)
            {
               this.unnattachFromGround();
            }
            if(Utils.hasLabel(Stance,"rocket"))
            {
               this.stancePlayFrame("rocket");
            }
            m_xSpeed = Utils.calculateXSpeed(this.m_rocketSpeed,this.m_rocketAngle);
            m_ySpeed = -Utils.calculateYSpeed(this.m_rocketSpeed,this.m_rocketAngle);
         }
      }
      
      private function fixRocketRotation() : void
      {
         var _loc1_:Number = NaN;
         if(this.m_rocketRotation)
         {
            _loc1_ = Number(this.m_rocketAngle);
            _loc1_ = Number(Utils.forceBase360(m_facingForward ? -this.m_rocketAngle : -this.m_rocketAngle + 180));
            m_sprite.rotation = _loc1_;
         }
      }
      
      private function checkRocket() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(inState(CState.ATTACKING) && m_attack.Rocket)
         {
            this.fixRocketRotation();
            this.m_attemptToMove(m_xSpeed,0);
            this.m_attemptToMove(0,m_ySpeed);
            if(this.m_rocketDecay >= 0)
            {
               decel(Utils.fastAbs(Utils.calculateXSpeed(this.m_rocketDecay,this.m_rocketAngle)));
               decel_air(Utils.fastAbs(Utils.calculateYSpeed(this.m_rocketDecay,this.m_rocketAngle)));
            }
            else
            {
               decel(-Utils.fastAbs(Utils.calculateXSpeed(this.m_rocketDecay,this.m_rocketAngle)));
               decel_air(-Utils.fastAbs(Utils.calculateYSpeed(this.m_rocketDecay,this.m_rocketAngle)));
            }
            if(this.testGroundWithCoord(m_sprite.x,m_sprite.y + 1))
            {
               if(this.m_rocketAngle > 200 && this.m_rocketAngle < 340)
               {
                  m_attack.Rocket = false;
                  _loc1_ = m_xSpeed;
                  _loc2_ = m_ySpeed;
                  this.toBounce();
                  m_xSpeed = _loc1_ / 2;
                  m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.CHAR_ROCKET_COMPLETE,{"caller":this.APIInstance.instance}));
               }
               else if(this.m_rocketAngle >= 160 && (this.m_rocketAngle >= 340 || this.m_rocketAngle <= 20))
               {
                  this.resetRotation();
               }
            }
         }
      }
      
      private function resetItemDamageCounter() : void
      {
         this.m_itemDamageCounter = 36;
      }
      
      private function m_checkItem() : void
      {
         var _loc1_:Item = null;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         if(Boolean(this.m_transformedSpecial) && this.m_item2 != null)
         {
            this.m_item2.destroy();
            this.m_item2 = null;
         }
         if(this.m_item2 != null && Boolean(this.m_item2.Dead))
         {
            this.m_item2.destroy();
            this.m_item2 = null;
         }
         this.m_itemJustPickedUp = false;
         _loc1_ = null;
         if(!(m_bypassCollisionTesting || !m_hitBoxManager.HasHitBoxes || Boolean(this.m_standby)))
         {
            _loc2_ = 0;
            while(_loc2_ < STAGEDATA.ItemsRef.MAXITEMS)
            {
               _loc1_ = STAGEDATA.ItemsRef.getItemData(_loc2_);
               if(_loc1_ != null && !(_loc1_.PickedUp && _loc1_.getHolder() == this))
               {
                  InteractiveSprite.hitTest(this,_loc1_,HitBoxSprite.PICKUP,HitBoxSprite.CATCH,this.reactionCatch,null,true);
               }
               _loc2_++;
            }
         }
      }
      
      public function checkItemDeath() : void
      {
         if(this.m_item != null && Boolean(this.m_item.Dead))
         {
            this.m_item = null;
            this.updateItemHolding();
         }
      }
      
      public function tossItem(param1:Number) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Point = null;
         var _loc6_:Boolean = false;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Array = null;
         var _loc10_:HitBoxSprite = null;
         if(!this.m_item || !this.m_item.ItemStats.CanToss)
         {
            return;
         }
         _loc2_ = false;
         _loc3_ = this.m_item.TossSpeed * this.m_characterStats.TiltTossMultiplier;
         _loc4_ = -1;
         _loc5_ = new Point(0,0);
         _loc6_ = m_sprite.stance.transform.matrix.a < 0;
         if(HasItemBox)
         {
            _loc9_ = this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.ITEM);
            if(_loc9_.length > 0)
            {
               _loc10_ = _loc9_[0];
               _loc5_.x = _loc10_.xreg * m_sprite.scaleX;
               _loc5_.y = _loc10_.yreg * m_sprite.scaleY;
            }
         }
         if(!m_facingForward)
         {
            param1 = Number(Utils.forceBase360(180 - param1));
         }
         if(inState(CState.HOVER))
         {
            this.m_attackHovering = true;
         }
         if(this.m_lastFrameInterrupt)
         {
            if(getStanceVar("backToss",true))
            {
               param1 = m_facingForward ? 105 : 75;
               _loc2_ = true;
               _loc3_ = this.m_item.TossSpeed * this.m_characterStats.TiltTossMultiplier;
               if(!m_collision.ground)
               {
                  _loc3_ = 0;
               }
            }
            else if(this.m_lastFrameInterruptState === CState.DASH_INIT || this.m_lastFrameInterruptState === CState.DASH || this.m_lastFrameInterruptSmashTimer < 4 && ["a_air","a"].indexOf(this.m_lastFrameInterrupt) < 0)
            {
               _loc3_ = this.m_item.TossSpeed * this.m_characterStats.SmashTossMultiplier;
               _loc4_ = (this.m_item.getAttackBoxStat(1,"damage") || -3) + 2;
            }
         }
         if(m_sprite.stance.currentLabel === "toss_back")
         {
            if(m_facingForward)
            {
               this.m_item.faceLeft();
            }
            else
            {
               this.m_item.faceRight();
            }
         }
         else if(m_facingForward)
         {
            this.m_item.faceRight();
         }
         else
         {
            this.m_item.faceLeft();
         }
         _loc7_ = Number(Utils.calculateXSpeed(_loc3_,param1));
         _loc8_ = -Utils.calculateYSpeed(_loc3_,param1);
         if((param1 <= 45 || param1 >= 315) && m_xSpeed > 0)
         {
            param1 = Number(Utils.getAngleBetween(new Point(),new Point(_loc7_ + m_xSpeed,_loc8_)));
            _loc3_ = Number(Utils.calculateSpeed(_loc7_ + m_xSpeed,_loc8_));
         }
         else if(param1 >= 135 && param1 <= 225 && m_xSpeed < 0)
         {
            param1 = Number(Utils.getAngleBetween(new Point(),new Point(_loc7_ + m_xSpeed,_loc8_)));
            _loc3_ = Number(Utils.calculateSpeed(_loc7_ + m_xSpeed,_loc8_));
         }
         else if(param1 > 45 && param1 < 135 && m_ySpeed < 0)
         {
            param1 = Number(Utils.getAngleBetween(new Point(),new Point(_loc7_,_loc8_ + m_ySpeed)));
            _loc3_ = Number(Utils.calculateSpeed(_loc7_,_loc8_ + m_ySpeed));
         }
         else if(param1 > 225 && param1 < 315 && m_ySpeed > 0)
         {
            param1 = Number(Utils.getAngleBetween(new Point(),new Point(_loc7_,_loc8_ + m_ySpeed)));
            _loc3_ = Number(Utils.calculateSpeed(_loc7_,_loc8_ + m_ySpeed));
         }
         this.m_item.Toss(m_sprite.x + _loc5_.x,m_sprite.y + _loc5_.y,_loc3_,param1,_loc2_);
         if(_loc4_ > 0)
         {
            this.m_item.updateAttackBoxStats(1,{"damage":_loc4_});
         }
         this.resetSpeedLevel();
         if(_loc6_)
         {
            this.m_item.MC.scaleX *= -1;
            this.m_item.MC.scaleY *= -1;
         }
         this.m_item = null;
         this.playGlobalSound(_loc2_ ? "itemdrop" : "item_throw");
      }
      
      public function tossItemOld(param1:Number, param2:Number, param3:Boolean = false) : void
      {
         var _loc4_:Point = null;
         var _loc5_:Boolean = false;
         var _loc6_:Array = null;
         var _loc7_:HitBoxSprite = null;
         if(!this.m_item || !this.m_item.ItemStats.CanToss)
         {
            return;
         }
         _loc4_ = new Point(0,0);
         _loc5_ = m_sprite.stance.transform.matrix.a < 0;
         if(HasItemBox)
         {
            _loc6_ = this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.ITEM);
            if(_loc6_.length > 0)
            {
               _loc7_ = _loc6_[0];
               _loc4_.x = _loc7_.xreg * m_sprite.scaleX;
               _loc4_.y = _loc7_.yreg * m_sprite.scaleY;
            }
         }
         if(!param3)
         {
            if(param2 < 90 || param2 > 270)
            {
               m_faceRight();
            }
            else if(param2 > 90 && param2 < 270)
            {
               m_faceLeft();
            }
         }
         if(!m_facingForward)
         {
            param2 = Number(Utils.forceBase360(180 - param2));
         }
         if(inState(CState.HOVER))
         {
            this.m_attackHovering = true;
         }
         this.m_item.Toss(m_sprite.x + _loc4_.x,m_sprite.y + _loc4_.y,param3 && !m_collision.ground ? 0 : param1,param2,param3);
         this.resetSpeedLevel();
         if(_loc5_)
         {
            this.m_item.MC.scaleX *= -1;
            this.m_item.MC.scaleY *= -1;
         }
         this.m_item = null;
         this.playGlobalSound(param3 ? "itemdrop" : "item_throw");
      }
      
      private function m_useFinalSmash() : void
      {
         var _loc1_:Point = null;
         var _loc2_:Point = null;
         if(this.m_characterStats.SpecialType == 0 && !this.m_transformedSpecial)
         {
            if(this.m_item2 != null)
            {
               this.m_item2.destroy();
               this.m_item2 = null;
            }
            if(m_healthBoxMC)
            {
               m_healthBoxMC.fsmeter.bar.gotoAndPlay("empty");
               m_healthBoxMC.fsmeter.fullcharge.gotoAndPlay("off");
            }
            this.m_transformingSpecial = true;
            this.playFrame("special");
            toggleEffect(this.m_fsGlowHolderMC,false);
            this.SpecialAttack();
         }
         else if(this.m_characterStats.SpecialType == 0 && Boolean(this.m_transformedSpecial))
         {
            if(this.m_item2 != null)
            {
               this.m_item2.destroy();
               this.m_item2 = null;
            }
            if(m_healthBoxMC)
            {
               m_healthBoxMC.fsmeter.bar.gotoAndPlay("fill");
               m_healthBoxMC.fsmeter.fullcharge.gotoAndPlay("off");
            }
         }
         else if(this.m_characterStats.SpecialType == 1 || this.m_characterStats.SpecialType == 2 || this.m_characterStats.SpecialType == 3)
         {
            if(this.m_item2 != null)
            {
               this.m_item2.destroy();
               this.m_item2 = null;
            }
            if(m_healthBoxMC)
            {
               m_healthBoxMC.fsmeter.bar.gotoAndPlay("fill");
               m_healthBoxMC.fsmeter.fullcharge.gotoAndPlay("off");
            }
            toggleEffect(this.m_fsGlowHolderMC,false);
            this.SpecialAttack();
         }
         else if(this.m_characterStats.SpecialType == 4)
         {
            if(this.m_item2 != null)
            {
               this.m_item2.destroy();
               this.m_item2 = null;
            }
            if(m_healthBoxMC)
            {
               m_healthBoxMC.fsmeter.bar.gotoAndPlay("fill");
               m_healthBoxMC.fsmeter.fullcharge.gotoAndPlay("off");
            }
            this.m_attachedReticule = null;
            this.playFrame("special");
            toggleEffect(this.m_fsGlowHolderMC,false);
            this.m_transformLimit = this.m_characterStats.FSTimer;
            this.SpecialAttack();
            this.m_attachedFPS = STAGEDATA.attachUniqueMovieHUD(this.m_characterStats.LinkageID + "_hud");
            this.m_attachedFPS.stop();
            Utils.recursiveMovieClipPlay(this.m_attachedFPS,false);
            this.m_attachedFPS.uid = m_uid;
            _loc1_ = new Point(Main.Width / 2,Main.Height);
            this.m_attachedFPS.x = STAGEDATA.HudForegroundRef.globalToLocal(_loc1_).x;
            this.m_attachedFPS.y = STAGEDATA.HudForegroundRef.globalToLocal(_loc1_).y;
            this.unnattachFromGround();
         }
         else if(this.m_characterStats.SpecialType == 5)
         {
            if(this.m_item2 != null)
            {
               this.m_item2.destroy();
               this.m_item2 = null;
            }
            if(m_healthBoxMC)
            {
               m_healthBoxMC.fsmeter.bar.gotoAndPlay("fill");
               m_healthBoxMC.fsmeter.fullcharge.gotoAndPlay("off");
            }
            this.playFrame("special");
            toggleEffect(this.m_fsGlowHolderMC,false);
            this.m_transformLimit = this.m_characterStats.FSTimer;
            this.SpecialAttack();
            this.m_attachedFPS = STAGEDATA.attachUniqueMovieHUD(this.m_characterStats.LinkageID + "_hud");
            this.m_attachedFPS.stop();
            Utils.recursiveMovieClipPlay(this.m_attachedFPS,false);
            this.m_attachedFPS.uid = m_uid;
            _loc2_ = new Point(Main.Width / 2,Main.Height);
            this.m_attachedFPS.x = STAGEDATA.HudForegroundRef.globalToLocal(_loc2_).x;
            this.m_attachedFPS.y = STAGEDATA.HudForegroundRef.globalToLocal(_loc2_).y;
            this.unnattachFromGround();
         }
         else if(this.m_characterStats.SpecialType == 6)
         {
            if(this.m_item2 != null)
            {
               this.m_item2.destroy();
               this.m_item2 = null;
            }
            if(m_healthBoxMC)
            {
               m_healthBoxMC.fsmeter.bar.gotoAndPlay("fill");
               m_healthBoxMC.fsmeter.fullcharge.gotoAndPlay("off");
            }
            this.playFrame("special");
            toggleEffect(this.m_fsGlowHolderMC,false);
            this.m_transformLimit = this.m_characterStats.FSTimer;
            this.SpecialAttack();
         }
      }
      
      private function updateItemHolding() : void
      {
         var _loc1_:Rectangle = null;
         var _loc2_:Number = NaN;
         _loc1_ = new Rectangle(0,0,1,1);
         _loc2_ = 0;
         if(this.HoldingItem)
         {
            if(HasItemBox)
            {
               this.m_item.setVisibility(m_sprite.visible);
               this.m_item.MC.x = HitBoxSprite(this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.ITEM)[0]).xreg * m_sprite.scaleX;
               this.m_item.MC.y = HitBoxSprite(this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.ITEM)[0]).yreg * m_sprite.scaleY;
               this.m_item.MC.scaleX = 1;
               this.m_item.MC.scaleY = 1;
               if(m_facingForward)
               {
                  this.m_item.faceRight();
               }
               else
               {
                  this.m_item.faceLeft();
               }
               _loc2_ = m_facingForward ? Number(HitBoxSprite(this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.ITEM)[0]).rotation) : -HitBoxSprite(this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.ITEM)[0]).rotation;
               this.m_item.MC.scaleX *= HitBoxSprite(this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.ITEM)[0]).scaleX;
               this.m_item.MC.scaleY *= HitBoxSprite(this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.ITEM)[0]).scaleY;
               this.m_item.MC.rotation = _loc2_ + m_sprite.stance.rotation + m_sprite.rotation;
               if(HasStance)
               {
                  if(m_sprite.stance.transform.matrix.a < 0)
                  {
                     this.m_item.MC.scaleX *= -1;
                     this.m_item.MC.scaleY *= -1;
                  }
               }
               _loc1_.x = this.m_item.MC.x;
               _loc1_.y = this.m_item.MC.y;
               _loc1_ = Utils.rotateRectangleAroundOrigin(_loc1_,360 - m_sprite.rotation);
               this.m_item.MC.x = m_sprite.x + _loc1_.x;
               this.m_item.MC.y = m_sprite.y + _loc1_.y;
               if(HitBoxSprite(this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.ITEM)[0]).depth == 0 && Depth < this.m_item.Depth)
               {
                  Utils.swapDepths(m_sprite,this.m_item.MC);
               }
               else if(HitBoxSprite(this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.ITEM)[0]).depth != 0 && Depth > this.m_item.Depth)
               {
                  Utils.swapDepths(m_sprite,this.m_item.MC);
               }
               this.m_item.MC.alpha = m_sprite.alpha;
            }
            else
            {
               this.m_item.X = m_sprite.x;
               this.m_item.Y = m_sprite.y - m_height / 2;
            }
         }
         if(this.m_currentPower != null && HasHatBox)
         {
            if(this.m_hatHolder == null)
            {
               this.m_hatHolder = ResourceManager.getLibraryMC("hat_" + this.m_currentPower);
               if(this.m_hatHolder)
               {
                  while(this.m_hatMC.numChildren > 0)
                  {
                     this.m_hatMC.removeChildAt(0);
                  }
                  this.m_hatMC.addChild(this.m_hatHolder);
                  STAGE.addChild(this.m_hatMC);
               }
            }
            if(!this.m_hatHolder)
            {
               return;
            }
            this.m_hatMC.x = HitBoxSprite(this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.HAT)[0]).xreg * m_sprite.scaleX;
            this.m_hatMC.y = HitBoxSprite(this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.HAT)[0]).yreg * m_sprite.scaleY;
            this.m_hatMC.scaleX = m_sprite.scaleX;
            this.m_hatMC.scaleY = m_sprite.scaleY;
            this.m_hatMC.rotation = m_sprite.rotation;
            _loc2_ = m_facingForward ? Number(HitBoxSprite(this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.HAT)[0]).rotation) : -HitBoxSprite(this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.HAT)[0]).rotation;
            this.m_hatMC.scaleX *= HitBoxSprite(this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.HAT)[0]).scaleX;
            this.m_hatMC.scaleY *= HitBoxSprite(this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.HAT)[0]).scaleY;
            this.m_hatMC.rotation = _loc2_ + m_sprite.stance.rotation + m_sprite.stance.rotation;
            if(HasStance)
            {
               this.m_hatMC.scaleX *= m_sprite.stance.scaleX;
               this.m_hatMC.scaleY *= m_sprite.stance.scaleY;
               if(m_sprite.stance.transform.matrix.a < 0)
               {
                  this.m_hatMC.scaleX *= -1;
                  this.m_hatMC.scaleY *= -1;
               }
            }
            if(HitBoxSprite(this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.HAT)[0]).transform.a < 0)
            {
               this.m_hatMC.scaleY *= -1;
            }
            _loc1_.x = this.m_hatMC.x;
            _loc1_.y = this.m_hatMC.y;
            _loc1_ = Utils.rotateRectangleAroundOrigin(_loc1_,360 - m_sprite.rotation);
            this.m_hatMC.x = m_sprite.x + _loc1_.x;
            this.m_hatMC.y = m_sprite.y + _loc1_.y;
            if(!this.m_hatMC.parent)
            {
               STAGE.addChild(this.m_hatMC);
            }
            if(HitBoxSprite(this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.HAT)[0]).depth == 0 && Depth < this.m_hatMC.parent.getChildIndex(this.m_hatMC))
            {
               Utils.swapDepths(m_sprite,this.m_hatMC);
            }
            else if(HitBoxSprite(this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.HAT)[0]).depth != 0 && Depth > this.m_hatMC.parent.getChildIndex(this.m_hatMC))
            {
               Utils.swapDepths(m_sprite,this.m_hatMC);
            }
         }
         else if(this.m_currentPower == null || !HasHatBox)
         {
            if(this.m_hatHolder)
            {
               while(this.m_hatMC.numChildren > 0)
               {
                  this.m_hatMC.removeChildAt(0);
               }
               this.m_hatHolder = null;
            }
         }
      }
      
      public function killItem(param1:Number) : void
      {
         if(this.m_item != null)
         {
            STAGEDATA.ItemsRef.killItem(this.m_item.Slot);
            this.m_item = null;
         }
      }
      
      public function dropItem(param1:Boolean = false) : void
      {
         var _loc2_:Boolean = false;
         if(this.m_item != null)
         {
            _loc2_ = m_sprite.stance.transform.matrix.a < 0;
            this.m_item.Drop(param1);
            if(_loc2_)
            {
               this.m_item.MC.scaleX *= -1;
               this.m_item.MC.scaleY *= -1;
            }
            this.m_item = null;
         }
      }
      
      override public function updatePaletteSwap() : void
      {
         super.updatePaletteSwap();
         if(Boolean(m_paletteSwapData) && HasStance)
         {
            Utils.replacePalette(this.m_starKOMC,m_paletteSwapData,2);
            Utils.replacePalette(this.m_screenKOHolder,m_paletteSwapData);
            Utils.replacePalette(m_reflectionEffect,m_paletteSwapData);
         }
         this.updateLivesDisplay();
      }
      
      override public function setPaletteSwap(param1:Object, param2:Object) : void
      {
         this.m_lastLivesTextNum = -1;
         super.setPaletteSwap(param1,param2);
      }
      
      override public function updateColorFilterAPI(param1:Object) : void
      {
         if(param1 == null)
         {
            param1 = Utils.getCostumeObject();
         }
         super.updateColorFilterAPI(param1);
         if(param1 != null && Boolean(this.m_starKOMC))
         {
            Utils.setColorFilter(this.m_starKOMC,param1);
            this.redrawHealthBox();
         }
      }
      
      public function replaceCharacter(param1:String, param2:String = null, param3:String = null) : void
      {
         var _loc4_:CharacterData = null;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Vector.<MovieClip> = null;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:Array = null;
         var _loc12_:MovieClip = null;
         this.setIntangibility(false);
         if(this.m_sizeStatus != 0)
         {
            this.setSizeStatus(0);
         }
         _loc4_ = Stats.getStats(param1,this.m_expansion_id);
         _loc5_ = m_sprite.xframe;
         if(this.m_grabbed.length > 0)
         {
            this.grabReleaseOpponent();
            this.grabRelease();
         }
         _loc6_ = m_sprite.x;
         _loc7_ = m_sprite.y;
         _loc8_ = new Vector.<MovieClip>();
         _loc8_.push(m_sprite);
         _loc9_ = CAM.hasTargets(_loc8_);
         if(_loc9_)
         {
            CAM.deleteTargets(_loc8_);
         }
         _loc10_ = m_sprite.visible;
         _loc11_ = m_sprite.filters;
         m_sprite.filters = null;
         m_sprite.parent.removeChild(m_sprite);
         _loc12_ = ResourceManager.getLibraryMC(_loc4_.LinkageID);
         _loc12_.name = "p" + m_player_id;
         _loc12_.player_id = m_player_id;
         _loc12_.character_id = m_uid;
         _loc12_.ACTIVE = true;
         m_sprite = MovieClip(STAGE.addChild(_loc12_));
         m_sprite.filters = _loc11_;
         Utils.hasLabel(m_sprite,"edgelean",true);
         if(_loc9_)
         {
            _loc8_ = new Vector.<MovieClip>();
            _loc8_.push(m_sprite);
            CAM.addTargets(_loc8_);
         }
         m_sprite.x = _loc6_;
         m_sprite.y = _loc7_;
         if(inState(CState.CAUGHT))
         {
            this.setVisibility(_loc10_);
         }
         this.resetChargedAttacks();
         m_attack.Rocket = false;
         m_attackData.resetCharges();
         toggleEffect(this.m_chargeGlowHolderMC,false);
         this.m_chargeGlowHolderMC = null;
         if(STAGEPARENT.getChildByName("energy" + m_player_id) != null)
         {
            STAGEPARENT.removeChild(STAGEPARENT.getChildByName("energy" + m_player_id));
         }
         this.setStats(_loc4_);
         if(!m_facingForward)
         {
            m_faceLeft();
         }
         else
         {
            m_faceRight();
         }
         if(_loc5_ != null && param2 == null)
         {
            this.playFrame(_loc5_);
            m_attack.Frame = _loc5_;
            if(param3 != null)
            {
               this.stancePlayFrame(param3);
            }
         }
         else if(param2 != null)
         {
            this.playFrame(param2);
            m_attack.Frame = param2;
            if(param3 != null)
            {
               this.stancePlayFrame(param3);
            }
         }
         if(HasStance)
         {
         }
         this.m_deactivateShield();
         if(!inState(CState.ATTACKING))
         {
            this.setState(m_collision.ground ? uint(CState.IDLE) : uint(CState.JUMP_FALLING));
         }
         this.reapplyCostume();
         this.applySpecialModeEffects();
         if(this.m_isMetal)
         {
            this.setMetalStatus(false,false);
            this.setMetalStatus(true,false);
         }
         m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.CHAR_TRANSFORM,{"caller":this.APIInstance.instance}));
      }
      
      public function activateFinalForm() : void
      {
         var _loc1_:CharacterData = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Vector.<MovieClip> = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:MovieClip = null;
         if(this.m_transformingSpecial)
         {
            this.setIntangibility(false);
            if(this.m_sizeStatus != 0)
            {
               this.setSizeStatus(0);
            }
            _loc1_ = Stats.getStats(this.m_characterStats.SpecialStatsID,this.m_expansion_id);
            this.releaseOpponent();
            STAGEDATA.brightenCamera();
            if(this.m_item2 != null)
            {
               this.m_item2.destroy();
               this.m_item2 = null;
            }
            this.m_transformingSpecial = false;
            this.m_transformedSpecial = true;
            this.m_transformTime = 0;
            this.m_transformLimit = this.m_characterStats.FSTimer;
            this.m_finalSmashMeterReady = false;
            if(m_healthBoxMC)
            {
               m_healthBoxMC.fsmeter.visible = true;
            }
            _loc2_ = m_sprite.x;
            _loc3_ = m_sprite.y;
            _loc4_ = new Vector.<MovieClip>();
            _loc4_.push(m_sprite);
            _loc5_ = CAM.hasTargets(_loc4_);
            if(_loc5_)
            {
               CAM.deleteTargets(_loc4_);
            }
            _loc6_ = m_sprite.visible;
            m_sprite.parent.removeChild(m_sprite);
            _loc7_ = ResourceManager.getLibraryMC(_loc1_.LinkageID);
            _loc7_.name = "p" + m_player_id;
            _loc7_.player_id = m_player_id;
            _loc7_.character_id = m_uid;
            _loc7_.ACTIVE = true;
            m_sprite = MovieClip(STAGE.addChild(_loc7_));
            Utils.hasLabel(m_sprite,"edgelean",true);
            if(_loc5_)
            {
               _loc4_ = new Vector.<MovieClip>();
               _loc4_.push(m_sprite);
               CAM.addTargets(_loc4_);
            }
            m_sprite.x = _loc2_;
            m_sprite.y = _loc3_;
            this.setSizeStatus(0);
            if(inState(CState.CAUGHT))
            {
               this.setVisibility(_loc6_);
            }
            this.playFrame("special");
            this.resetChargedAttacks();
            m_attackData.resetCharges();
            toggleEffect(this.m_chargeGlowHolderMC,false);
            this.m_chargeGlowHolderMC = null;
            toggleEffect(this.m_fsGlowHolderMC,false);
            this.setStats(_loc1_);
            if(!m_facingForward)
            {
               m_faceLeft();
            }
            else
            {
               m_faceRight();
            }
            if(this.m_isMetal)
            {
               this.setMetalStatus(false,false);
               this.setMetalStatus(true,false);
            }
         }
      }
      
      private function redrawHealthBox() : void
      {
         if(m_healthBoxMC)
         {
            this.attachHealthBox(this.m_playerSettings.name ? this.m_playerSettings.name.toUpperCase() : this.m_characterStats.DisplayName.toUpperCase(),this.m_characterStats.Thumbnail,this.m_characterStats.SeriesIcon,m_team_id,this.CostumeName,this.CostumeID);
         }
      }
      
      override protected function syncStats() : void
      {
         m_attack.AttackRatio = this.m_characterStats.AttackRatio;
         m_gravity = this.m_characterStats.Gravity;
         m_max_ySpeed = this.m_characterStats.MaxYSpeed;
         this.m_max_xSpeed = this.m_characterStats.MaxXSpeed;
         this.m_norm_xSpeed = this.m_characterStats.NormalXSpeed;
         if(m_healthBoxMC)
         {
            if(!this.m_characterStats.FinalSmashMeter && !this.m_transformedSpecial)
            {
               m_healthBoxMC.fsmeter.visible = false;
            }
            else
            {
               m_healthBoxMC.fsmeter.visible = true;
            }
         }
      }
      
      private function setStats(param1:CharacterData) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         _loc2_ = Number(this.m_characterStats.Stamina);
         _loc3_ = Boolean(this.m_characterStats.FinalSmashMeter);
         if(param1 !== this.m_characterStats)
         {
            this.m_characterStats.importData(param1.exportData());
         }
         if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
         {
            this.m_characterStats.importData({
               "accel_start":0.5,
               "accel_start_dash":-1,
               "accel_rate":0.8,
               "accel_rate_air":0.5,
               "decel_rate":-0.5,
               "decel_rate_air":-0.5
            });
         }
         this.m_characterStats.importData({
            "attackRatio":this.m_playerSettings.attackRatio,
            "damageRatio":this.m_playerSettings.damageRatio,
            "unlimitedFinal":this.m_playerSettings.unlimitedFinal,
            "startDamage":this.m_playerSettings.startDamage,
            "stamina":_loc2_,
            "finalSmashMeter":_loc3_
         });
         this.resetStaleMoves();
         this.m_jumpStartup.MaxTime = param1.JumpStartup;
         this.m_jumpStartup.reset();
         _loc4_ = param1.JumpSpeedList;
         while(Boolean(_loc4_) && _loc4_.indexOf(" ") >= 0)
         {
            _loc4_ = _loc4_.replace(" ","");
         }
         _loc5_ = param1.JumpSpeedList ? _loc4_.split(",") : null;
         this.m_jumpSpeedList = null;
         this.m_jumpSpeedList = new Array();
         _loc6_ = 0;
         while(_loc5_ != null && _loc6_ < _loc5_.length)
         {
            _loc5_[_loc6_] = isNaN(parseFloat(_loc5_[_loc6_])) ? 0 : parseFloat(_loc5_[_loc6_]);
            _loc6_++;
         }
         this.m_jumpSpeedList = _loc5_;
         m_gravity = param1.Gravity;
         this.m_norm_xSpeed = param1.NormalXSpeed;
         this.m_max_xSpeed = param1.MaxXSpeed;
         m_max_ySpeed = param1.MaxYSpeed;
         m_attackData = param1.Attacks;
         m_attackData.Owner = this;
         buildHitBoxData(param1.LinkageID);
         if(Main.DEBUG)
         {
            verifiyHitBoxData();
         }
         this.generatePummelData();
         if(Boolean(m_attackData.getAttack("grab")) && m_attackData.getAttack("grab").AttackBoxes.length > 0)
         {
            m_attackData.getAttack("grab").AttackBoxes[0].importAttackData({
               "team_id":m_team_id,
               "refreshRate":3,
               "damage":param1.GrabDamage,
               "hasEffect":false,
               "bypassNonGrabbed":true,
               "effectSound":param1.Sounds["pummel"],
               "staleMultiplier":this.totalMoveDecay("grab")
            });
         }
         this.m_wallStickTime.MaxTime = param1.WallStick;
         this.m_forceTransformTime = new FrameTimer(param1.ForceTransformTime);
         if(Stats.getStats(param1.ForceTransformID,this.m_expansion_id) == null)
         {
            this.m_forceTransformTime.MaxTime = 0;
         }
         this.m_midAirHoverTime.MaxTime = param1.MidAirHover;
         this.m_midAirJumpConstantTime.MaxTime = param1.MidAirJumpConstant;
         this.m_midAirJumpConstantDelay.MaxTime = param1.MidAirJumpConstantDelay;
         this.m_damageIncreaseInterval.MaxTime = param1.DamageIncreaseInterval;
         m_sprite.scaleX = m_sprite.scaleX > 0 ? m_sizeRatio : -m_sizeRatio;
         m_sprite.scaleY = m_sprite.scaleY > 0 ? m_sizeRatio : -m_sizeRatio;
         m_width = param1.Width;
         m_height = param1.Height;
         this.resetCameraBox();
         m_sprite.camOverride = null;
         if(this.m_item != null && !param1.CanHoldItems)
         {
            this.m_item.destroy();
         }
         m_attackData.resetDisabledAttacks();
         this.redrawHealthBox();
         if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.LIGHT))
         {
            m_gravity /= 2;
            m_max_ySpeed /= 2;
         }
         else if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.HEAVY))
         {
            m_gravity *= 2;
            m_max_ySpeed *= 2;
         }
         if(!this.m_human)
         {
            this.CPU.refreshRecoveryAttackList();
            this.CPU.refreshDisabledAttackList();
         }
         this.syncStats();
      }
      
      private function checkItemInterrupt(param1:String, param2:Number, param3:Boolean = false) : Boolean
      {
         var _loc4_:uint = 0;
         var _loc5_:Boolean = false;
         _loc4_ = m_state;
         if(Boolean(this.m_item) && this.m_item.FrameInterrupt != null)
         {
            _loc5_ = ["a_air","a_air_up","a_air_down","a_air_forward","a_air_backward"].indexOf(param1) >= 0;
            if(!(_loc5_ && Boolean(this.m_itemJustPickedUp)) && Boolean(this.m_item.FrameInterrupt({
               "cStick":param3,
               "targetFrame":param1,
               "zair":this.m_pressedControls.GRAB && !this.m_characterStats.TetherGrab && _loc5_,
               "character":this.APIInstance.instance
            })))
            {
               this.m_lastFrameInterrupt = param1;
               this.m_lastFrameInterruptState = _loc4_;
               this.m_lastFrameInterruptSmashTimer = this.m_smashTimer;
               return true;
            }
         }
         return false;
      }
      
      public function Attack(param1:String, param2:Number, param3:Boolean = false) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:AttackObject = null;
         var _loc6_:MovieClip = null;
         if(param2 === 2 && !this.m_characterStats.CanUseSpecials)
         {
            return;
         }
         if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
         {
            if(param2 === 2)
            {
               return;
            }
            if(param1 === "a" || param1 === "a_air")
            {
               param1 = param1 === "a" ? "b" : "b_air";
               param2 = 2;
               param3 = false;
            }
         }
         _loc4_ = false;
         _loc5_ = m_attackData.getAttack(param1);
         this.clearControlsBuffer();
         if(_loc5_.IsDisabled)
         {
            return;
         }
         if(!inState(CState.HOVER) && !(Boolean(this.m_itemJustPickedUp) && (param1 === "a_forward" || param1 === "a_air")) && Boolean(this.checkItemInterrupt(param1,1,param3)))
         {
            return;
         }
         if(inState(CState.ATTACKING))
         {
            if(this.isInterruptableAttack())
            {
               if(param1 === this.m_lastAttackUsedTurbo || param1 + "_air" === this.m_lastAttackUsedTurbo || param1 === this.m_lastAttackUsedTurbo + "_air")
               {
                  return;
               }
               if(m_attack.Rocket)
               {
                  m_attack.Rocket = false;
                  m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.CHAR_ROCKET_COMPLETE,{"caller":this.APIInstance.instance}));
                  this.resetRotation();
               }
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.CHAR_ATTACK_CANCELLED,{"caller":this.APIInstance.instance}));
               m_actionShot = false;
               this.grabReleaseOpponent();
            }
            flushTimers();
            removeAllTempEvents();
            _loc4_ = true;
         }
         this.m_cStickUse = param3;
         var _loc7_:Boolean = m_collision.ground;
         if(!_loc5_.IsDisabled && _loc5_.Enabled)
         {
            if(_loc5_ != null)
            {
               _loc5_.LastUsedPrevious = _loc5_.LastUsed;
               _loc5_.LastUsed = 0;
               if(param1 == "b" || param1 == "b_air")
               {
                  m_attackData.getAttack(param1 == "b" ? "b_air" : "b").LastUsedPrevious = m_attackData.getAttack(param1 == "b" ? "b_air" : "b").LastUsed;
                  m_attackData.getAttack(param1 == "b" ? "b_air" : "b").LastUsed = 0;
               }
               else if(param1 == "b_up" || param1 == "b_up_air")
               {
                  m_attackData.getAttack(param1 == "b_up" ? "b_up_air" : "b_up").LastUsedPrevious = m_attackData.getAttack(param1 == "b_up" ? "b_up_air" : "b_up").LastUsed;
                  m_attackData.getAttack(param1 == "b_up" ? "b_up_air" : "b_up").LastUsed = 0;
               }
               else if(param1 == "b_forward" || param1 == "b_forward_air")
               {
                  m_attackData.getAttack(param1 == "b_forward" ? "b_forward_air" : "b").LastUsedPrevious = m_attackData.getAttack(param1 == "b_forward" ? "b_forward_air" : "b").LastUsed;
                  m_attackData.getAttack(param1 == "b_forward" ? "b_forward_air" : "b").LastUsed = 0;
               }
               else if(param1 == "b_down" || param1 == "b_down_air")
               {
                  m_attackData.getAttack(param1 == "b_down" ? "b_down_air" : "b_down").LastUsedPrevious = m_attackData.getAttack(param1 == "b_down" ? "b_down_air" : "b_down").LastUsed;
                  m_attackData.getAttack(param1 == "b_down" ? "b_down_air" : "b_down").LastUsed = 0;
               }
            }
            if(!this.jumpIsPressed() && !(this.jumpIsHeld() || Boolean(this.m_tap_jump) && Boolean(this.m_heldControls.UP)) && (m_ySpeed < 0 || this.m_midAirJumpConstantTime.MaxTime > 0 && !this.m_midAirJumpConstantTime.IsComplete))
            {
               if(_loc5_.JumpCancel && this.m_jumpCount == 0 && !m_collision.ground)
               {
                  m_ySpeed = 0;
                  this.m_midAirJumpConstantTime.finish();
               }
               else if(_loc5_.DoubleJumpCancel && this.m_jumpCount > 0 && !m_collision.ground)
               {
                  if(m_ySpeed < 0)
                  {
                     this.m_midAirJumpConstantDelay.finish();
                     this.m_midAirJumpConstantTime.finish();
                  }
                  else
                  {
                     m_ySpeed = 0;
                     this.m_midAirJumpConstantTime.finish();
                  }
               }
            }
            m_attack.RefreshRateTimer = 1;
            m_attack.RefreshRateReady = false;
            m_attack.SizeStatus = this.m_sizeStatus;
            this.m_attackIDIncremented = true;
            m_attack.ForceFallThrough = _loc5_.ForceFallThrough;
            m_attack.MaintainSpeed = _loc5_.MaintainSpeed;
            m_attack.FacedLedgesOnly = _loc5_.FacedLedgesOnly;
            m_attack.LedgeFrame = _loc5_.LedgeFrame;
            m_attack.IgnorePlatformInfluence = _loc5_.IgnorePlatformInfluence;
            m_attack.IASA = _loc5_.IASA;
            m_attack.GrabBehind = _loc5_.GrabBehind;
            _loc5_.OverrideMap.clear();
            _loc5_.ReenableTimerCount = _loc5_.ReenableTimer;
            if(m_collision.ground && !m_attack.MaintainSpeed)
            {
               this.resetSpeedLevel();
            }
            if(_loc5_.ChargeClick && !this.m_cStickUse)
            {
               this.playGlobalSound("chargeclick");
            }
            if(_loc5_.Flip)
            {
               if(m_facingForward)
               {
                  m_faceLeft();
               }
               else
               {
                  m_faceRight();
               }
            }
            m_attack.IsTurning = false;
            m_attack.IsAccelerating = false;
            m_attack.HoldRepeat = _loc5_.HoldRepeat;
            m_attack.AttackType = param2;
            if(!_loc5_.ConserveJumpConstant)
            {
               if(!this.m_midAirJumpConstantTime.IsComplete)
               {
                  m_ySpeed = 0;
               }
               this.m_midAirJumpConstantTime.finish();
            }
            this.m_bufferedAttackJump = false;
            m_attack.AirEase = _loc5_.AirEase;
            m_attack.XSpeedCap = _loc5_.XSpeedCap;
            m_attack.IsForward = m_facingForward;
            m_attack.StaleMultiplier = this.totalMoveDecay(param1);
            m_attack.Invincible = _loc5_.Invincible;
            m_attack.SuperArmor = _loc5_.SuperArmor;
            m_attack.HeavyArmor = _loc5_.HeavyArmor;
            m_attack.LaunchResistance = _loc5_.LaunchResistance;
            m_attack.XSpeedAccel = _loc5_.XSpeedAccel;
            m_attack.XSpeedAccelAir = _loc5_.XSpeedAccelAir;
            m_attack.XSpeedDecay = _loc5_.XSpeedDecay;
            m_attack.XSpeedDecayAir = _loc5_.XSpeedDecayAir;
            m_attack.ComboTotal = 0;
            m_attack.ComboMax = _loc5_.ComboMax;
            m_attack.ForceComboContinue = _loc5_.ForceComboContinue;
            m_attack.ForceGrabbable = _loc5_.ForceGrabbable;
            m_attack.NextComboFrame = null;
            m_attack.AttackID = Utils.getUID();
            m_attack.ID = Utils.getUID();
            this.checkLinkedProjectiles();
            m_attack.Frame = param1;
            m_attack.ExecTime = 0;
            m_attack.SecondaryAttack = _loc5_.SecondaryAttack;
            m_attack.HasClanked = false;
            m_attack.RefreshRate = _loc5_.RefreshRate;
            m_attack.HomingSpeed = _loc5_.HomingSpeed;
            m_attack.HomingTarget = null;
            m_attack.ChargeTimeMax = _loc5_.ChargeTimeMax;
            m_attack.LinkCharge = _loc5_.LinkCharge;
            m_attack.AllowControl = _loc5_.AllowControl;
            m_attack.AllowControlGround = _loc5_.AllowControlGround;
            m_attack.AllowJump = _loc5_.AllowJump;
            m_attack.AllowFastFall = _loc5_.AllowFastFall;
            m_attack.AllowRun = _loc5_.AllowRun;
            m_attack.AllowTurn = _loc5_.AllowTurn;
            m_attack.AllowFullInterrupt = _loc5_.AllowFullInterrupt;
            m_attack.AllowDoubleJump = _loc5_.AllowDoubleJump;
            m_attack.LinkFrames = _loc5_.LinkFrames;
            m_attack.Cancel = _loc5_.Cancel;
            m_attack.CancelWhenAirborne = _loc5_.CancelWhenAirborne;
            m_attack.HasLanded = m_collision.ground;
            m_attack.Rotate = _loc5_.Rotate;
            m_attack.CancelSoundOnEnd = _loc5_.CancelSoundOnEnd;
            m_attack.CancelVoiceOnEnd = _loc5_.CancelVoiceOnEnd;
            m_attack.WasCancelled = false;
            m_attack.XLoc = MC.x;
            m_attack.YLoc = MC.y;
            m_attack.DisableJump = _loc5_.DisableJump;
            m_attack.JumpCancelAttack = _loc5_.JumpCancelAttack;
            m_attack.DoubleJumpCancelAttack = _loc5_.DoubleJumpCancelAttack;
            m_attack.AttackDelay = _loc5_.AttackDelay;
            m_attack.IsThrow = param1.substring(0,6) == "throw_";
            m_attack.ChargeInAir = _loc5_.ChargeInAir;
            m_attack.MustCharge = _loc5_.MustCharge;
            m_attack.CanFallOff = _loc5_.CanFallOff;
            m_attack.CanGrabInverseLedges = _loc5_.CanGrabInverseLedges;
            m_attack.CanBeAbsorbed = _loc5_.CanBeAbsorbed;
            m_attack.AirCancel = _loc5_.AirCancel;
            m_attack.AirCancelSpecial = _loc5_.AirCancelSpecial;
            m_attack.IsAirAttack = !m_collision.ground;
            this.resetRotation();
            Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
            if(_loc5_.ResetMovement)
            {
               m_xSpeed = 0;
               m_ySpeed = 0;
            }
            if(!_loc5_.ChargeRetain)
            {
               _loc5_.ChargeTime = 0;
            }
            else if(_loc5_.UseChargeBar && STAGEPARENT.getChildByName("energy" + m_player_id) == null)
            {
               _loc6_ = ResourceManager.getLibraryMC("energy");
               _loc6_.name = "energy" + m_player_id;
               STAGEPARENT.addChild(_loc6_);
               STAGEPARENT.getChildByName("energy" + m_player_id).x = m_sprite.x + STAGE.x;
               STAGEPARENT.getChildByName("energy" + m_player_id).y = m_sprite.y + STAGE.y;
               STAGEPARENT.getChildByName("energy" + m_player_id).width = STAGEPARENT.getChildByName("energy" + m_player_id).width * m_sizeRatio;
               STAGEPARENT.getChildByName("energy" + m_player_id).height = STAGEPARENT.getChildByName("energy" + m_player_id).height * m_sizeRatio;
            }
            this.m_attackHovering = inState(CState.HOVER) && m_attack.IsAirAttack && param2 == 1;
            this.setState(CState.ATTACKING);
            if(Boolean(this.m_human) && this.ID > 0)
            {
               Gamepad.rumbleOnAttack(this.ID,param1);
            }
            if(_loc4_)
            {
               this.playFrame(param1);
            }
            if(_loc5_.JumpFrame != null)
            {
               this.stancePlayFrame(_loc5_.JumpFrame);
            }
            else if(HasStance && Stance.currentFrame !== 1 && m_previousAnimation === m_currentAnimationID)
            {
               this.stancePlayFrame(1);
            }
            this.m_previousAttack = m_attack.Frame;
            if(Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.TURBO)) && m_attack.Frame !== "special")
            {
               addEventListener(SSF2Event.ATTACK_HIT,this.allowTurboCancel);
               addEventListener(SSF2Event.ATTACK_HIT_SHIELD,this.allowTurboCancel);
               addEventListener(SSF2Event.ATTACK_HIT_POWER_SHIELD,this.allowTurboCancel);
               addEventListener(SSF2Event.CHAR_GRAB,this.allowTurboCancel);
            }
         }
         if(_loc4_)
         {
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.CHAR_ATTACK_CHANGED,{"caller":this.APIInstance.instance}));
         }
      }
      
      private function SpecialAttack() : void
      {
         var _loc1_:AttackObject = null;
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         if(inState(CState.ATTACKING))
         {
            this.forceEndAttack();
         }
         this.m_forceTransformTime.MaxTime = 0;
         m_attack.SizeStatus = this.m_sizeStatus;
         var _loc5_:Boolean = m_collision.ground;
         m_attack.Frame = "special";
         _loc1_ = m_attackData.getAttack(m_attack.Frame);
         m_attack.IsAirAttack = !m_collision.ground;
         MC.rotation = 0;
         Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
         this.m_attackIDIncremented = true;
         if(_loc1_.Flip)
         {
            if(m_facingForward)
            {
               m_faceLeft();
            }
            else
            {
               m_faceRight();
            }
         }
         if(!this.jumpIsPressed() && !(this.jumpIsHeld() || Boolean(this.m_tap_jump) && Boolean(this.m_heldControls.UP)) && (m_ySpeed < 0 || this.m_midAirJumpConstantTime.MaxTime > 0 && !this.m_midAirJumpConstantTime.IsComplete))
         {
            if(_loc1_.JumpCancel && this.m_jumpCount == 0)
            {
               m_ySpeed = 0;
               this.m_midAirJumpConstantTime.finish();
            }
            else if(_loc1_.DoubleJumpCancel && this.m_jumpCount > 0 && !m_collision.ground)
            {
               m_ySpeed = 0;
               this.m_midAirJumpConstantTime.finish();
            }
         }
         this.m_bufferedAttackJump = false;
         m_attack.FacedLedgesOnly = _loc1_.FacedLedgesOnly;
         m_attack.LedgeFrame = _loc1_.LedgeFrame;
         m_attack.IgnorePlatformInfluence = _loc1_.IgnorePlatformInfluence;
         m_attack.IASA = _loc1_.IASA;
         m_attack.GrabBehind = _loc1_.GrabBehind;
         m_attack.ComboTotal = 0;
         m_attack.ChargeTime = _loc1_.ChargeTime;
         m_attack.ChargeTimeMax = _loc1_.ChargeTimeMax;
         m_attack.LinkCharge = _loc1_.LinkCharge;
         m_attack.ComboMax = _loc1_.ComboMax;
         m_attack.ForceComboContinue = _loc1_.ForceComboContinue;
         m_attack.IsThrow = false;
         _loc1_.OverrideMap.clear();
         _loc1_.ReenableTimerCount = _loc1_.ReenableTimer;
         m_attack.ForceFallThrough = _loc1_.ForceFallThrough;
         m_attack.MaintainSpeed = _loc1_.MaintainSpeed;
         m_attack.IsForward = m_facingForward;
         m_attack.Rocket = false;
         STAGEDATA.ItemsRef.SmashBallReady.reset();
         STAGEDATA.ItemsRef.SmashBallReady.MaxTime = this.m_characterStats.FSTimer;
         m_attack.RefreshRateTimer = 1;
         m_attack.RefreshRateReady = false;
         m_attack.IsTurning = false;
         m_attack.IsAccelerating = false;
         m_attack.Invincible = _loc1_.Invincible;
         m_attack.SuperArmor = _loc1_.SuperArmor;
         m_attack.HeavyArmor = _loc1_.HeavyArmor;
         m_attack.LaunchResistance = _loc1_.LaunchResistance;
         m_attack.XSpeedAccel = _loc1_.XSpeedAccel;
         m_attack.XSpeedAccelAir = _loc1_.XSpeedAccelAir;
         m_attack.XSpeedDecay = _loc1_.XSpeedDecay;
         m_attack.XSpeedDecayAir = _loc1_.XSpeedDecayAir;
         m_attack.HoldRepeat = false;
         m_attack.AttackType = 2;
         m_attack.AttackID = Utils.getUID();
         m_attack.ID = Utils.getUID();
         this.checkLinkedProjectiles();
         m_attack.HomingTarget = null;
         m_attack.HomingSpeed = _loc1_.HomingSpeed;
         m_attack.DisableJump = _loc1_.DisableJump;
         m_attack.JumpCancelAttack = _loc1_.JumpCancelAttack;
         m_attack.DoubleJumpCancelAttack = _loc1_.DoubleJumpCancelAttack;
         m_attack.ChargeInAir = _loc1_.ChargeInAir;
         m_attack.AirEase = _loc1_.AirEase;
         m_attack.XSpeedCap = _loc1_.XSpeedCap;
         m_attack.RefreshRate = _loc1_.RefreshRate;
         m_attack.ExecTime = -1;
         m_attack.SecondaryAttack = _loc1_.SecondaryAttack;
         m_attack.HasClanked = false;
         m_attack.AllowControl = _loc1_.AllowControl;
         m_attack.AllowControlGround = _loc1_.AllowControlGround;
         m_attack.AllowJump = _loc1_.AllowJump;
         m_attack.AllowFastFall = _loc1_.AllowFastFall;
         m_attack.AllowRun = _loc1_.AllowRun;
         m_attack.AllowTurn = _loc1_.AllowTurn;
         m_attack.AllowFullInterrupt = _loc1_.AllowFullInterrupt;
         m_attack.AllowDoubleJump = _loc1_.AllowDoubleJump;
         m_attack.LinkFrames = _loc1_.LinkFrames;
         m_attack.Cancel = _loc1_.Cancel;
         m_attack.CancelWhenAirborne = _loc1_.CancelWhenAirborne;
         m_attack.HasLanded = m_collision.ground;
         m_attack.CancelSoundOnEnd = _loc1_.CancelSoundOnEnd;
         m_attack.CancelVoiceOnEnd = _loc1_.CancelVoiceOnEnd;
         m_attack.Rotate = _loc1_.Rotate;
         m_attack.WasCancelled = false;
         m_attack.XLoc = MC.x;
         m_attack.YLoc = MC.y;
         m_attack.AttackDelay = _loc1_.AttackDelay;
         this.m_usingSpecialAttack = true;
         m_attack.CanFallOff = _loc1_.CanFallOff;
         m_attack.CanGrabInverseLedges = _loc1_.CanGrabInverseLedges;
         m_attack.CanBeAbsorbed = _loc1_.CanBeAbsorbed;
         m_attack.AirCancel = _loc1_.AirCancel;
         m_attack.AirCancelSpecial = _loc1_.AirCancelSpecial;
         STAGEDATA.darkenCamera();
         if(Boolean(this.m_human) && this.ID > 0 && this.HasFinalSmash)
         {
            Gamepad.rumbleOnFinalSmash(this.ID);
         }
         if(_loc1_.ResetMovement)
         {
            m_xSpeed = 0;
            m_ySpeed = 0;
         }
         if(!_loc1_.ChargeRetain)
         {
            _loc1_.ChargeTime = 0;
         }
         else if(_loc1_.UseChargeBar && STAGEPARENT.getChildByName("energy" + m_player_id) == null)
         {
            _loc2_ = ResourceManager.getLibraryMC("energy");
            _loc2_.name = "energy" + m_player_id;
            STAGEPARENT.addChild(_loc2_);
            STAGEPARENT.getChildByName("energy" + m_player_id).x = m_sprite.x + STAGE.x;
            STAGEPARENT.getChildByName("energy" + m_player_id).y = m_sprite.y + STAGE.y;
            STAGEPARENT.getChildByName("energy" + m_player_id).width = STAGEPARENT.getChildByName("energy" + m_player_id).width * m_sizeRatio;
            STAGEPARENT.getChildByName("energy" + m_player_id).height = STAGEPARENT.getChildByName("energy" + m_player_id).height * m_sizeRatio;
         }
         this.m_previousAttack = m_attack.Frame;
         if(this.m_characterStats.FinalSmashCutin)
         {
            _loc3_ = ResourceManager.getLibraryMC("finalsmash_cutin");
            if(_loc3_)
            {
               _loc3_.x = 1.65 - 320;
               _loc3_.y = 10 - 180;
               _loc4_ = this.m_characterStats.FinalSmashCutin ? ResourceManager.getLibraryMC(this.m_characterStats.FinalSmashCutin) : null;
               if(!_loc4_)
               {
                  _loc4_ = ResourceManager.getLibraryMC("char_fs_cutin_template");
               }
               if(_loc4_)
               {
                  STAGEDATA.HudForegroundRef.addChild(_loc3_);
                  if(!this.m_human)
                  {
                     _loc3_.cutinbox.gotoAndStop("cpu");
                  }
                  else if(m_player_id > 0)
                  {
                     _loc3_.cutinbox.gotoAndStop("p" + m_player_id);
                  }
                  else
                  {
                     _loc3_.cutinbox.gotoAndStop("cpu");
                  }
                  _loc3_.cutinbox.pa.placeholder.addChild(_loc4_);
                  STAGEDATA.CamRef.addForcedTarget(m_sprite);
                  ++STAGEDATA.FSCutins;
                  this.m_finalSmashCutinMC = _loc3_;
                  if(m_paletteSwapData)
                  {
                     Utils.replacePalette(_loc4_,m_paletteSwapPAData,2);
                  }
               }
            }
         }
         this.setState(CState.ATTACKING);
         if(Boolean(this.m_human) && this.ID > 0)
         {
            Gamepad.rumbleOnAttack(this.ID,"special");
         }
         if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.TURBO))
         {
            addEventListener(SSF2Event.ATTACK_HIT,this.allowTurboCancel);
            addEventListener(SSF2Event.ATTACK_HIT_SHIELD,this.allowTurboCancel);
            addEventListener(SSF2Event.ATTACK_HIT_POWER_SHIELD,this.allowTurboCancel);
            addEventListener(SSF2Event.CHAR_GRAB,this.allowTurboCancel);
         }
      }
      
      private function allowTurboCancel(param1:SSF2Event) : void
      {
         var _loc2_:AttackObject = null;
         var _loc3_:String = null;
         _loc2_ = m_attackData.getAttack(m_attack.Frame);
         if(!_loc2_)
         {
            return;
         }
         _loc3_ = _loc2_.ParentAttack || m_attack.Frame;
         if(this.m_lastAttackUsedTurbo != _loc3_ && this.m_lastAttackUsedTurbo + "_air" != _loc3_ && this.m_lastAttackUsedTurbo != _loc3_ + "_air" && !inState(CState.GRABBING) && !(Boolean(param1.data) && Boolean(param1.data.attackBoxData) && !param1.data.attackBoxData.allowTurboInterrupt))
         {
            this.setAttackEnabled(true,this.m_lastAttackUsedTurbo);
            this.setAttackEnabled(false,_loc3_);
            updateAttackStats({
               "allowJump":true,
               "allowDoubleJump":true,
               "airCancel":true,
               "airCancelSpecial":true,
               "allowFullInterrupt":true,
               "jumpCancelAttack":true,
               "doubleJumpCancelAttack":true
            });
            removeEventListener(SSF2Event.ATTACK_HIT,this.allowTurboCancel);
            removeEventListener(SSF2Event.ATTACK_HIT_SHIELD,this.allowTurboCancel);
            removeEventListener(SSF2Event.ATTACK_HIT_POWER_SHIELD,this.allowTurboCancel);
            addEventListener(SSF2Event.CHAR_ATTACK_COMPLETE,this.reenableOnEnd);
            addEventListener(SSF2Event.CHAR_HURT,this.reenableOnEnd);
            addEventListener(SSF2Event.CHAR_GRABBED,this.reenableOnEnd);
            this.m_lastAttackUsedTurbo = _loc3_;
         }
      }
      
      private function reenableOnEnd(param1:* = null) : void
      {
         if(this.m_lastAttackUsedTurbo)
         {
            this.setAttackEnabled(true,this.m_lastAttackUsedTurbo);
         }
         if(inState(CState.ATTACKING) && m_attack.IsThrow)
         {
            this.grabReleaseOpponent();
         }
         this.m_lastAttackUsedTurbo = null;
      }
      
      private function checkTurbo() : void
      {
         if(Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.TURBO)) && Boolean(this.m_lastAttackUsedTurbo))
         {
            this.setAttackEnabled(true,this.m_lastAttackUsedTurbo);
            this.m_lastAttackUsedTurbo = null;
         }
      }
      
      public function hitBoxAttackTest(param1:String, param2:String) : AttackDamage
      {
         var _loc3_:AttackDamage = null;
         var _loc4_:AttackObject = null;
         _loc3_ = new AttackDamage(m_player_id,this);
         _loc4_ = m_attackData.getAttack(param1);
         if(_loc4_)
         {
            if(_loc4_.AttackBoxes[param2])
            {
               _loc3_.importAttackDamageData(_loc4_.AttackBoxes[param2]);
               _loc3_.importAttackDamageData({
                  "id":m_attack.ID,
                  "atk_id":m_attack.AttackID,
                  "team_id":m_team_id
               });
            }
         }
         return _loc3_;
      }
      
      override public function reactionShield(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         var _loc3_:AttackDamage = null;
         _loc3_ = m_attackData.getAttackBoxData(m_attackCache.Frame,param2.FirstHitBox.Name).syncState(m_attackCache);
         if(param1 as Character)
         {
            if(_loc3_.BypassShield && param1.takeDamage(_loc3_,param2.OverlapHitBox))
            {
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_CONNECT,{
                  "caller":this.APIInstance.instance,
                  "receiver":param1.APIInstance.instance,
                  "attackBoxData":_loc3_.exportAttackDamageData()
               }));
               this.handleHit(param1,_loc3_,param2);
               return true;
            }
            if(Character(param1).takeShieldDamage(_loc3_,param2.OverlapHitBox))
            {
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_CONNECT_SHIELD,{
                  "caller":this.APIInstance.instance,
                  "receiver":param1.APIInstance.instance,
                  "attackBoxData":_loc3_.exportAttackDamageData()
               }));
               this.m_smashDISelf = true;
               startActionShot(Utils.calculateSelfHitStun(_loc3_.SelfHitStun,Utils.calculateChargeDamage(_loc3_)));
               m_attack.RefreshRateReady = true;
               m_eventManager.dispatchEvent(new SSF2Event(Character(param1).PerfectShield ? SSF2Event.ATTACK_HIT_POWER_SHIELD : SSF2Event.ATTACK_HIT_SHIELD,{
                  "caller":this.APIInstance.instance,
                  "receiver":param1.APIInstance.instance,
                  "attackBoxData":_loc3_.exportAttackDamageData()
               }));
               return true;
            }
         }
         return false;
      }
      
      override public function reactionShieldAttack(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         var _loc3_:AttackDamage = null;
         _loc3_ = m_attackData.getAttackBoxData(m_attackCache.Frame,param2.FirstHitBox.Name).syncState(m_attackCache);
         if(_loc3_.Priority < 7 && _loc3_.Priority > -1 && param1.validateHit(_loc3_,true))
         {
            this.attachEffect("effect_cancel",Boolean(param2) && Boolean(param2.OverlapHitBox) ? {
               "x":param2.OverlapHitBox.centerx,
               "y":param2.OverlapHitBox.centery,
               "absolute":true
            } : null);
            this.endAttack();
            param1.pushBackSlightly(param1.X > m_sprite.x);
            return true;
         }
         return false;
      }
      
      override public function reactionAbsorb(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         var _loc3_:AttackDamage = null;
         _loc3_ = m_attackData.getAttackBoxData(m_attackCache.Frame,param2.FirstHitBox.Name).syncState(m_attackCache);
         if(m_attack.CanBeAbsorbed && param1.HasAbsorbBox && param1.validateHit(_loc3_,true))
         {
            if(param1.recover(Utils.calculateChargeDamage(_loc3_,_loc3_.AbsorbDamage)))
            {
               param1.stackAttackID(_loc3_.AttackID);
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.CHAR_ABSORB,{
                  "caller":this.APIInstance.instance,
                  "projectile":param1.APIInstance.instance,
                  "attackBoxData":_loc3_.exportAttackDamageData()
               }));
               return true;
            }
         }
         return false;
      }
      
      override public function reactionGrab(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         var _loc3_:Character = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         _loc3_ = null;
         if(inState(CState.CAUGHT) || inState(CState.INJURED) || inState(CState.FLYING) || inState(CState.LEDGE_HANG) || (param1.inState(CState.CAUGHT) || param1.isIntangible()) || Boolean(this.m_grabCancelled) || inState(CState.LAND) || inState(CState.HEAVY_LAND))
         {
            return false;
         }
         if(inState(CState.GRABBING) && Boolean(param1 as Character))
         {
            _loc3_ = Character(param1);
            if(this.m_grabbed.length <= 0 && (!_loc3_.Invincible || _loc3_.inState(CState.ATTACKING) && _loc3_.AttackStateData.ForceGrabbable) && !_loc3_.Dead && !_loc3_.Revival && !_loc3_.Caught() && _loc3_.Grabbed.length <= 0 && !_loc3_.Frozen && !(_loc3_.Team == m_team_id && m_team_id > 0 && !STAGEDATA.TeamDamage) && !_loc3_.UsingFinalSmash && !_loc3_.StandBy && !_loc3_.inState(CState.CRASH_LAND) && !_loc3_.inState(CState.KIRBY_STAR) && !_loc3_.Egg && !_loc3_.Frozen && !_loc3_.Pitfall && checkLinearPathBetweenPoints(new Point(m_sprite.x,m_sprite.y - m_sprite.height / 2),new Point(_loc3_.X,_loc3_.Y - _loc3_.Height / 2)))
            {
               if(_loc3_.inState(CState.CRASH_LAND) || !_loc3_.Capture(m_uid))
               {
                  return false;
               }
               this.playGlobalSound("grab");
               this.stancePlayFrame("grabbed");
               m_attack.AttackID = Utils.getUID();
               m_attack.ID = Utils.getUID();
               this.checkLinkedProjectiles();
               this.m_grabbed = new Vector.<Character>();
               this.m_grabbed.push(_loc3_);
               if(Boolean(this.m_human) && this.ID > 0)
               {
                  Gamepad.rumbleOnGrab(this.ID);
               }
               if(Boolean(_loc3_.m_human) && _loc3_.ID > 0)
               {
                  Gamepad.rumbleOnGrabbed(_loc3_.ID);
               }
               this.m_grabTimer = _loc3_.CharacterStats.Stamina > 0 ? int(Utils.calculateGrabLength(_loc3_.CharacterStats.Stamina - _loc3_.getDamage())) : int(Utils.calculateGrabLength(_loc3_.getDamage()));
               this.m_pummelTimer = Utils.calculatePummelTime(this.m_grabTimer);
               this.m_justPummeled = false;
               _loc3_.FaceForward(!m_facingForward);
               if(HasTouchBox)
               {
                  this.repositionGrabbedCharacter();
               }
               if(_loc3_.Depth > this.Depth)
               {
                  swapDepths(_loc3_);
               }
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.CHAR_GRAB,{
                  "caller":this.APIInstance.instance,
                  "grabbed":_loc3_.APIInstance.instance
               }));
               return true;
            }
         }
         else if(!inState(CState.GRABBING) && Boolean(param1 as Character))
         {
            _loc3_ = Character(param1);
            if((this.m_grabbed.length == 0 || Boolean(this.m_usingSpecialAttack) && (this.m_characterStats.SpecialType == 6 || this.m_characterStats.SpecialType === 1)) && !(!this.m_usingSpecialAttack && !checkLinearPathBetweenPoints(new Point(m_sprite.x,m_sprite.y - m_height / 2),new Point(param1.X,param1.Y - param1.Height / 2))) && !(Boolean(this.m_usingSpecialAttack) && (this.m_characterStats.SpecialType == 2 || this.m_characterStats.SpecialType == 3) && !checkLinearPathBetweenPoints(new Point(m_sprite.x,m_sprite.y - m_height / 2),new Point(param1.X,param1.Y - param1.Height / 2))) && (!_loc3_.Invincible || _loc3_.inState(CState.ATTACKING) && _loc3_.AttackStateData.ForceGrabbable) && !_loc3_.Dead && !_loc3_.Revival && !_loc3_.Caught() && !_loc3_.Frozen && !(_loc3_.Team == m_team_id && m_team_id > 0 && !STAGEDATA.TeamDamage) && !_loc3_.UsingFinalSmash && !_loc3_.StandBy && !_loc3_.inState(CState.CRASH_LAND) && !_loc3_.inState(CState.KIRBY_STAR) && !_loc3_.Egg && !_loc3_.Pitfall)
            {
               if(_loc3_.inState(CState.CRASH_LAND) || !_loc3_.Capture(m_uid))
               {
                  return false;
               }
               this.m_grabbed.push(_loc3_);
               _loc4_ = m_sprite.x;
               _loc5_ = m_sprite.y;
               _loc4_ *= m_sizeRatio;
               _loc5_ *= m_sizeRatio;
               if(this.m_characterStats.LinkageID == "kirby" && (m_attack.Frame == "b" || m_attack.Frame == "b_air") && this.m_currentPower == null)
               {
                  this.m_kirbyLastGrabbed = _loc3_.UID;
                  _loc6_ = m_sprite.x;
                  _loc7_ = m_sprite.y;
                  _loc6_ *= m_sizeRatio;
                  _loc7_ *= m_sizeRatio;
                  this.m_grabbed[0].MC.x += (m_sprite.x + _loc6_ - this.m_grabbed[0].X) / 6;
                  this.m_grabbed[0].MC.y = m_sprite.y;
                  this.updateItemHolding();
                  this.m_charIsFull = true;
                  this.m_holdTimer = 60;
                  this.m_grabbed[0].setVisibility(false);
                  if(inState(CState.ATTACKING))
                  {
                     m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.CHAR_ATTACK_COMPLETE,{"caller":this.APIInstance.instance}));
                     flushTimers();
                     removeAllTempEvents();
                  }
                  this.setState(CState.IDLE);
               }
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.CHAR_GRAB,{
                  "caller":this.APIInstance.instance,
                  "grabbed":_loc3_.APIInstance.instance
               }));
               return true;
            }
         }
         return false;
      }
      
      public function reactionGrabClank(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         if(inState(CState.GRABBING) && param1.inState(CState.GRABBING) && param1 is Character && !attackIDArrayContains(param1.AttackStateData.AttackID) && !param1.attackIDArrayContains(m_attack.AttackID) && (m_facingForward && !param1.FacingForward && m_sprite.x < param1.X || !m_facingForward && param1.FacingForward && m_sprite.x > param1.X))
         {
            stackAttackID(param1.AttackStateData.AttackID);
            param1.stackAttackID(m_attack.AttackID);
            this.dealDamage(2);
            Character(param1).dealDamage(2);
            initDelayPlayback(true);
            param1.initDelayPlayback(true);
            this.GrabCancelled = true;
            Character(param1).GrabCancelled = true;
            startActionShot(2);
            param1.startActionShot(2);
            this.attachEffect("effect_cancel",Boolean(param2) && Boolean(param2.OverlapHitBox) ? {
               "x":param2.OverlapHitBox.centerx,
               "y":param2.OverlapHitBox.centery,
               "absolute":true
            } : null);
            CAM.shake(15);
            this.grabRelease();
            Character(param1).grabRelease();
            return true;
         }
         return false;
      }
      
      override public function reactionReverse(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         if(Boolean(param1 as Projectile) || Boolean(param1 as Item))
         {
            if(param1.reverse(m_player_id,m_team_id,m_facingForward))
            {
               param1.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.REVERSE,{
                  "caller":param1.APIInstance.instance,
                  "opponent":this.APIInstance.instance,
                  "attackBoxData":null
               }));
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.REVERSE_HIT,{
                  "caller":this.APIInstance.instance,
                  "opponent":param1.APIInstance.instance,
                  "attackBoxData":null
               }));
            }
         }
         return false;
      }
      
      override public function reactionClank(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         var _loc3_:AttackDamage = null;
         var _loc4_:AttackDamage = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         if(!(param1 as Character && (Boolean(this.m_usingSpecialAttack) && this.m_characterStats.SpecialType == 3 && m_attack.ExecTime > 1 && Boolean(Character(param1).Caught()))))
         {
            _loc3_ = m_attackData.getAttackBoxData(m_attackCache.Frame,param2.FirstHitBox.Name).syncState(m_attackCache);
            _loc4_ = param1.AttackDataObj.getAttackBoxData(param1.AttackStateData.Frame,param2.SecondHitBox.Name).syncState(param1.AttackCache);
            _loc5_ = Number(Utils.calculateChargeDamage(_loc3_));
            _loc6_ = Number(Utils.calculateChargeDamage(_loc4_));
            _loc7_ = _loc3_.Damage === 0 && _loc3_.ReverseProjectile && param1 is Projectile || _loc3_.Damage === 0 && _loc3_.ReverseItem && param1 is Item || _loc3_.Damage === 0 && _loc3_.ReverseCharacter && param1 is Character;
            _loc8_ = _loc3_.Damage === 0 && Boolean(_loc3_.HitStunProjectile) && param1 is Projectile;
            if(Boolean(!_loc3_.HasEffect || !_loc4_.HasEffect || _loc3_.IsAirAttack || _loc4_.IsAirAttack || this.isInvincible() || param1.isInvincible() || _loc3_.IsThrow || _loc4_.IsThrow || !m_collision.ground || m_attack.HasClanked || m_skipAttackProcessing || param1 is Character && !param1.CollisionObj.ground || _loc3_.Owner && _loc4_.Owner && _loc3_.Owner.ID === _loc4_.Owner.ID || _loc3_.Owner && _loc4_.Owner && _loc3_.Owner.Team === _loc4_.Owner.Team && STAGEDATA.TeamDamage || !this.validateHit(_loc4_) || !(param1 is Projectile) && !param1.validateHit(_loc3_) || param1 is Projectile && !Projectile(param1).validateHitClank(_loc3_)) || Boolean(_loc7_) || _loc8_)
            {
               return false;
            }
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_COLLIDE,{
               "caller":this.APIInstance.instance,
               "receiver":param1.APIInstance.instance,
               "callerAttackBoxData":_loc3_.exportAttackDamageData(),
               "receiverAttackBoxData":_loc4_.exportAttackDamageData()
            }));
            param1.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_COLLIDE,{
               "caller":param1.APIInstance.instance,
               "receiver":this.APIInstance.instance,
               "callerAttackBoxData":_loc4_.exportAttackDamageData(),
               "receiverAttackBoxData":_loc3_.exportAttackDamageData()
            }));
            if(Utils.fastAbs(_loc5_ - _loc6_) < 8 && _loc3_.Priority != -1 && _loc4_.Priority != -1)
            {
               if(param1.SkipAttackProcessing || param1.AttackStateData.HasClanked || param1 is Item && !Item(param1).PickedUp)
               {
                  return false;
               }
               if(m_hurtInterrupt != null && Boolean(m_hurtInterrupt({
                  "target":(param1.APIInstance ? param1.APIInstance.instance : null),
                  "attackBoxData":_loc4_,
                  "collisionRect":param2.OverlapHitBox.BoundingBox
               })))
               {
                  return false;
               }
               if(param1.HurtInterrupt != null && Boolean(param1.HurtInterrupt({
                  "target":(m_apiInstance ? m_apiInstance.instance : null),
                  "attackBoxData":_loc3_,
                  "collisionRect":param2.OverlapHitBox.BoundingBox
               })))
               {
                  return false;
               }
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_CLANK,{
                  "caller":this.APIInstance.instance,
                  "receiver":param1.APIInstance.instance,
                  "callerAttackBoxData":_loc3_.exportAttackDamageData(),
                  "receiverAttackBoxData":_loc4_.exportAttackDamageData()
               }));
               param1.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_CLANK,{
                  "caller":param1.APIInstance.instance,
                  "receiver":this.APIInstance.instance,
                  "callerAttackBoxData":_loc4_.exportAttackDamageData(),
                  "receiverAttackBoxData":_loc3_.exportAttackDamageData()
               }));
               this.playReflectSound();
               this.attachEffect("effect_cancel",Boolean(param2) && Boolean(param2.OverlapHitBox) ? {
                  "x":param2.OverlapHitBox.centerx,
                  "y":param2.OverlapHitBox.centery,
                  "absolute":true
               } : null);
               CAM.shake(15);
               if(param1 is Character)
               {
                  this.clang(_loc4_,param2);
               }
               else
               {
                  startActionShot(Utils.calculateSelfHitStun(_loc3_.SelfHitStun,Utils.calculateChargeDamage(_loc3_)));
                  this.m_smashDISelf = true;
                  m_attack.HasClanked = true;
               }
               param1.clang(_loc3_,param2);
               return true;
            }
            if(_loc5_ - _loc6_ >= 8 && _loc3_.Priority != -1 && _loc4_.Priority != -1)
            {
               if(param1.SkipAttackProcessing || param1.AttackStateData.HasClanked)
               {
                  return false;
               }
               if(m_hurtInterrupt != null && Boolean(m_hurtInterrupt({
                  "target":(param1.APIInstance ? param1.APIInstance.instance : null),
                  "attackBoxData":_loc4_,
                  "collisionRect":param2.OverlapHitBox.BoundingBox
               })))
               {
                  return false;
               }
               if(param1.HurtInterrupt != null && Boolean(param1.HurtInterrupt({
                  "target":(m_apiInstance ? m_apiInstance.instance : null),
                  "attackBoxData":_loc3_,
                  "collisionRect":param2.OverlapHitBox.BoundingBox
               })))
               {
                  return false;
               }
               param1.attachEffect("effect_cancel",Boolean(param2) && Boolean(param2.OverlapHitBox) ? {
                  "x":param2.OverlapHitBox.centerx,
                  "y":param2.OverlapHitBox.centery,
                  "absolute":true
               } : null);
               param1.cancelAttack(_loc3_,param2);
               return true;
            }
            if(_loc5_ - _loc6_ <= -8 && _loc3_.Priority != -1 && _loc4_.Priority != -1)
            {
               if(param1.SkipAttackProcessing || param1.AttackStateData.HasClanked)
               {
                  return false;
               }
               if(m_hurtInterrupt != null && Boolean(m_hurtInterrupt({
                  "target":(param1.APIInstance ? param1.APIInstance.instance : null),
                  "attackBoxData":_loc4_,
                  "collisionRect":param2.OverlapHitBox.BoundingBox
               })))
               {
                  return false;
               }
               if(param1.HurtInterrupt != null && Boolean(param1.HurtInterrupt({
                  "target":(m_apiInstance ? m_apiInstance.instance : null),
                  "attackBoxData":_loc3_,
                  "collisionRect":param2.OverlapHitBox.BoundingBox
               })))
               {
                  return false;
               }
               if(param1 is Projectile)
               {
                  return false;
               }
               this.cancelAttack(_loc4_,param2);
               return true;
            }
         }
         return false;
      }
      
      override public function clang(param1:AttackDamage, param2:HitBoxCollisionResult) : void
      {
         var _loc3_:Number = NaN;
         initDelayPlayback(true);
         m_skipAttackCollisionTests = true;
         resetKnockback();
         m_xSpeed = 0;
         m_ySpeed = 0;
         stackAttackID(param1.AttackID);
         startActionShot(Utils.calculateSelfHitStun(param1.HitStun,param1.Damage));
         m_attack.HasClanked = true;
         _loc3_ = Number(Utils.calculateChargeDamage(param1));
         this.cancelAttack(param1,param2);
         if(param1.Rebound)
         {
            this.grabRelease(true);
            this.m_hitLag = Utils.calculateRebound(_loc3_);
         }
      }
      
      override public function handleHit(param1:InteractiveSprite, param2:AttackDamage, param3:HitBoxCollisionResult) : void
      {
         m_attack.RefreshRateReady = true;
         m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_HIT,{
            "caller":this.APIInstance.instance,
            "receiver":param1.APIInstance.instance,
            "attackBoxData":param2.exportAttackDamageData()
         }));
         this.incrementHitsDealtCounter();
         if(!param2.IsThrow && param1.Depth > this.Depth)
         {
            swapDepths(param1);
         }
         if(param1 is Character)
         {
            if(!staleIDArrayContains(param2.ID))
            {
               this.queueMove(param2.Frame);
               stackStaleID(param2.ID);
            }
            param2.StaleMultiplier = this.totalMoveDecay(param2.Frame);
            this.increaseComboCount(param2,param1.UID);
         }
         m_attack.HomingTarget = null;
         this.m_smashDISelf = true;
         if(!inState(CState.GRABBING))
         {
            startActionShot(Utils.calculateSelfHitStun(param2.SelfHitStun,Utils.calculateChargeDamage(param2)));
         }
         if(Boolean(param2.ReverseCharacter) && Boolean(param1 as Character) || Boolean(param2.ReverseProjectile) && Boolean(param1 as Projectile) || Boolean(param2.ReverseItem) && Boolean(param1 as Item))
         {
            if(param1.reverse(param2.PlayerID,param2.TeamID,param2.IsForward))
            {
               param1.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.REVERSE,{
                  "caller":param1.APIInstance.instance,
                  "opponent":this.APIInstance.instance,
                  "attackBoxData":param2.exportAttackDamageData()
               }));
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.REVERSE_HIT,{
                  "caller":this.APIInstance.instance,
                  "opponent":param1.APIInstance.instance,
                  "attackBoxData":param2.exportAttackDamageData()
               }));
            }
         }
         this.resetJustHitTimer();
      }
      
      override public function cancelAttack(param1:AttackDamage, param2:HitBoxCollisionResult) : void
      {
         this.toIdle();
         this.grabRelease();
         m_skipAttackCollisionTests = true;
         m_skipAttackProcessing = true;
         m_attack.HasClanked = true;
      }
      
      override public function reactionAttackReverse(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         var _loc3_:AttackDamage = null;
         _loc3_ = m_attackData.getAttackBoxData(m_attackCache.Frame,param2.FirstHitBox.Name).syncState(m_attackCache);
         if(Boolean(_loc3_.ReverseProjectile) && Boolean(param1 as Projectile) && param1.reverse(m_player_id,m_team_id,m_facingForward))
         {
            param1.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.REVERSE,{
               "caller":param1.APIInstance.instance,
               "opponent":this.APIInstance.instance,
               "attackBoxData":null
            }));
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.REVERSE_HIT,{
               "caller":this.APIInstance.instance,
               "opponent":param1.APIInstance.instance,
               "attackBoxData":null
            }));
         }
         else if(Boolean(_loc3_.ReverseItem) && Boolean(param1 as Item) && param1.reverse(m_player_id,m_team_id,m_facingForward))
         {
            param1.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.REVERSE,{
               "caller":param1.APIInstance.instance,
               "opponent":this.APIInstance.instance,
               "attackBoxData":null
            }));
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.REVERSE_HIT,{
               "caller":this.APIInstance.instance,
               "opponent":param1.APIInstance.instance,
               "attackBoxData":null
            }));
         }
         return false;
      }
      
      override public function reactionHit(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         var _loc3_:AttackDamage = null;
         if(Boolean(param1 as Character) && Boolean(param1.inState(CState.EGG)) && param2.SecondHitBox.Type == HitBoxSprite.HIT)
         {
            return false;
         }
         if(Boolean(param1 as Character) && Boolean(param1.inState(CState.FROZEN)) && param2.SecondHitBox.Type == HitBoxSprite.HIT)
         {
            return false;
         }
         _loc3_ = m_attackData.getAttackBoxData(m_attackCache.Frame,param2.FirstHitBox.Name).syncState(m_attackCache);
         if(param1.takeDamage(_loc3_,param2.OverlapHitBox))
         {
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_CONNECT,{
               "caller":this.APIInstance.instance,
               "receiver":param1.APIInstance.instance,
               "attackBoxData":_loc3_.exportAttackDamageData()
            }));
            this.handleHit(param1,_loc3_,param2);
            if(Boolean(this.m_human) && this.ID > 0)
            {
               Gamepad.rumbleOnHit(this.ID,_loc3_.Damage,_loc3_.Power);
            }
            return true;
         }
         if(param1.validateHit(_loc3_,true) && param1.isInvincible())
         {
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_CONNECT,{
               "caller":this.APIInstance.instance,
               "receiver":param1.APIInstance.instance,
               "attackBoxData":_loc3_.exportAttackDamageData()
            }));
            m_attack.RefreshRateReady = true;
            param1.stackAttackID(m_attack.AttackID);
            this.m_smashDISelf = true;
            startActionShot(Utils.calculateSelfHitStun(_loc3_.SelfHitStun,Utils.calculateChargeDamage(_loc3_)));
            m_attack.HomingTarget = null;
            if(Boolean(param1 as Character) && !Character(param1).DizzyShield)
            {
               param1.attachEffect("effect_cancel",Boolean(param2) && Boolean(param2.OverlapHitBox) ? {
                  "x":param2.OverlapHitBox.centerx,
                  "y":param2.OverlapHitBox.centery,
                  "absolute":true
               } : null);
            }
            return true;
         }
         return false;
      }
      
      override public function reactionCounter(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         var _loc3_:AttackDamage = null;
         _loc3_ = param1.AttackDataObj.getAttackBoxData(param1.AttackStateData.Frame,param2.SecondHitBox.Name).syncState(param1.AttackCache);
         if(_loc3_.Damage > 0 && this.validateHit(_loc3_,true))
         {
            m_counterAttackData = _loc3_.exportAttackDamageData();
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.CHAR_COUNTER,{
               "caller":this.APIInstance.instance,
               "receiver":param1.APIInstance.instance,
               "attackBoxData":m_counterAttackData
            }));
            return true;
         }
         return false;
      }
      
      override public function reactionCatch(param1:InteractiveSprite, param2:HitBoxCollisionResult) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         if(!(param1 as Item))
         {
            return false;
         }
         _loc3_ = this.inFreeState(CFreeState.ATTACKING | CFreeState.DODGING) && Boolean(this.m_characterStats.CanHoldItems) && !inState(CState.DODGE_ROLL) && !inState(CState.ITEM_PICKUP);
         _loc4_ = Boolean(this.m_pressedControls.BUTTON2) || this.shieldIsPressed() && inState(CState.AIR_DODGE) || inState(CState.AIR_DODGE) && m_framesSinceLastState <= 1;
         this.m_itemPrePickup = Item(param1);
         if(!this.m_itemJustPickedUp && !this.m_itemPrePickup.Dead && Boolean(this.m_itemPrePickup.CanPickup) && this.m_item == null && !this.m_itemPrePickup.PickedUp && _loc4_ && _loc3_)
         {
            return this.itemPickupAnimationCheck();
         }
         return false;
      }
      
      private function itemPickupAnimationCheck() : Boolean
      {
         if(m_collision.ground && this.inFreeState())
         {
            if((Boolean(this.m_heldControls.LEFT) || Boolean(this.m_heldControls.RIGHT) || Boolean(this.m_heldControls.C_LEFT) || Boolean(this.m_heldControls.C_RIGHT)) && Boolean(this.m_pressedControls.BUTTON2) && (Boolean(this.m_runningSpeedLevel) || inState(CState.DASH)))
            {
               this.Attack("a_forward",1);
               return this.pickupItem();
            }
            this.setState(CState.ITEM_PICKUP);
            return false;
         }
         return this.pickupItem();
      }
      
      public function pickupItem() : Boolean
      {
         var _loc1_:Boolean = false;
         if(!this.m_itemPrePickup || Boolean(this.m_itemPrePickup.Dead) || Boolean(this.m_itemPrePickup.PickedUp) || !this.m_itemPrePickup.CanPickup)
         {
            return false;
         }
         _loc1_ = inState(CState.ITEM_PICKUP) || (Boolean(this.m_pressedControls.BUTTON2) || this.shieldIsPressed() && inState(CState.AIR_DODGE) || inState(CState.AIR_DODGE) && m_framesSinceLastState <= 1);
         if(this.m_itemPrePickup.ItemStats.Type === "carryable" && !(this.m_itemPrePickup.ReleaseTimer < 7 && this.m_itemPrePickup.PreviousHolder === this && Boolean(this.m_itemPrePickup.WasZDropped)))
         {
            this.m_item = this.m_itemPrePickup;
            this.m_item.PickedUp = true;
            this.m_item.resetTime();
            this.resetItemDamageCounter();
            this.m_item.CurrentAttackState.IsAttacking = false;
            this.m_item.SetPlayer(m_uid);
            this.updateItemHolding();
            this.playGlobalSound("pickup");
            if(Boolean(this.m_human) && this.ID > 0)
            {
               Gamepad.rumbleOnItemPickup(this.ID);
            }
            this.updateItemHolding();
            this.m_itemJustPickedUp = true;
            if(m_collision.ground && !inState(CState.ITEM_PICKUP) && this.inFreeState())
            {
               if((Boolean(this.m_heldControls.LEFT) || Boolean(this.m_heldControls.RIGHT) || Boolean(this.m_heldControls.C_LEFT) || Boolean(this.m_heldControls.C_RIGHT)) && Boolean(this.m_pressedControls.BUTTON2) && (Boolean(this.m_runningSpeedLevel) || inState(CState.DASH)))
               {
                  this.Attack("a_forward",1);
               }
               else if(!inState(CState.ITEM_PICKUP))
               {
                  this.setState(CState.ITEM_PICKUP);
               }
            }
            return true;
         }
         if(Boolean(this.m_itemPrePickup.ItemStats.Type === "consumable" && _loc1_) && Boolean(this.m_itemPrePickup.FrameInterrupt) && Boolean(this.m_itemPrePickup.FrameInterrupt({"character":this.APIInstance.instance})))
         {
            this.m_itemJustPickedUp = true;
            if(m_collision.ground && !inState(CState.ITEM_PICKUP) && this.inFreeState())
            {
               if((Boolean(this.m_heldControls.LEFT) || Boolean(this.m_heldControls.RIGHT) || Boolean(this.m_heldControls.C_LEFT) || Boolean(this.m_heldControls.C_RIGHT)) && Boolean(this.m_pressedControls.BUTTON2) && (Boolean(this.m_runningSpeedLevel) || inState(CState.DASH)))
               {
                  this.Attack("a_forward",1);
               }
               else if(!inState(CState.ITEM_PICKUP))
               {
                  this.setState(CState.ITEM_PICKUP);
               }
            }
            return true;
         }
         return false;
      }
      
      override public function attackCollisionTest() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Character = null;
         var _loc3_:Enemy = null;
         var _loc4_:Item = null;
         var _loc5_:TargetTestTarget = null;
         var _loc6_:Projectile = null;
         var _loc7_:Vector.<HitBoxCollisionResult> = null;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         var _loc10_:Array = null;
         if(m_bypassCollisionTesting || !m_hitBoxManager.HasHitBoxes || Boolean(this.m_standby) || m_attackCollisionTestsPreProcessed)
         {
            return;
         }
         _loc1_ = 0;
         _loc2_ = null;
         _loc3_ = null;
         _loc4_ = null;
         _loc5_ = null;
         _loc6_ = null;
         if(!inState(CState.ATTACKING) && Boolean(m_attackData.getAttack(m_currentAnimationID)))
         {
            m_attack.Frame = m_currentAnimationID;
         }
         if(this.m_justHit)
         {
            --this.m_justHitTimer;
            if(this.m_justHitTimer == 0)
            {
               this.m_justHit = false;
            }
         }
         m_attackCache.syncState(m_attack);
         _loc1_ = 0;
         while(_loc1_ < STAGEDATA.ItemsRef.MAXITEMS)
         {
            _loc4_ = STAGEDATA.ItemsRef.getItemData(_loc1_);
            if(_loc4_ != null && !(_loc4_.PickedUp && _loc4_.getHolder() == this))
            {
               if(InteractiveSprite.hitTest(this,_loc4_,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster).length)
               {
                  InteractiveSprite.hitTest(this,_loc4_,HitBoxSprite.COUNTER,HitBoxSprite.ATTACK,this.reactionCounter,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc4_,HitBoxSprite.ATTACK,HitBoxSprite.ATTACK,this.reactionAttackReverse,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc4_,HitBoxSprite.ATTACK,HitBoxSprite.HIT,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc4_,HitBoxSprite.REVERSE,HitBoxSprite.HIT,this.reactionReverse,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc4_,HitBoxSprite.REVERSE,HitBoxSprite.ATTACK,this.reactionReverse,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc4_,HitBoxSprite.CATCH,HitBoxSprite.HIT,this.reactionCatch,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc4_,HitBoxSprite.CATCH,HitBoxSprite.CATCH,this.reactionCatch,STAGEDATA.HitBoxProcessorInstance);
               }
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < STAGEDATA.Characters.length)
         {
            _loc2_ = STAGEDATA.Characters[_loc1_];
            if(_loc2_ != null && _loc2_ != this && !_loc2_.StandBy && !_loc2_.Dead && !_loc2_.inState(CState.STAR_KO) && !_loc2_.inState(CState.SCREEN_KO) && !_loc2_.inState(CState.REVIVAL))
            {
               InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.ATTACK,HitBoxSprite.SHIELD,this.reactionShield,STAGEDATA.HitBoxProcessorInstance);
               if(InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.MASTER,HitBoxSprite.MASTER).length)
               {
                  InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.COUNTER,HitBoxSprite.ATTACK,this.reactionCounter,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.ATTACK,HitBoxSprite.ATTACK,this.reactionClank,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.GRAB,HitBoxSprite.GRAB,this.reactionGrabClank,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.ATTACK,HitBoxSprite.SHIELDATTACK,this.reactionShieldAttack,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.ATTACK,HitBoxSprite.HIT,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.STAR,HitBoxSprite.HIT,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.ATTACK,HitBoxSprite.EGG,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.ATTACK,HitBoxSprite.FREEZE,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc2_,HitBoxSprite.GRAB,HitBoxSprite.HIT,this.reactionGrab,STAGEDATA.HitBoxProcessorInstance);
               }
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < STAGEDATA.Enemies.length)
         {
            _loc3_ = STAGEDATA.Enemies[_loc1_];
            if(_loc3_ != null)
            {
               if(InteractiveSprite.hitTest(this,_loc3_,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster).length)
               {
                  InteractiveSprite.hitTest(this,_loc3_,HitBoxSprite.COUNTER,HitBoxSprite.ATTACK,this.reactionCounter,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc3_,HitBoxSprite.STAR,HitBoxSprite.HIT,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc3_,HitBoxSprite.ATTACK,HitBoxSprite.HIT,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
               }
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < STAGEDATA.Targets.length)
         {
            _loc5_ = STAGEDATA.Targets[_loc1_];
            if(_loc5_ != null)
            {
               InteractiveSprite.hitTest(this,_loc5_,HitBoxSprite.ATTACK,HitBoxSprite.HIT,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < STAGEDATA.Projectiles.length)
         {
            _loc6_ = STAGEDATA.Projectiles[_loc1_];
            if(_loc6_ != null)
            {
               if(InteractiveSprite.hitTest(this,_loc6_,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster).length)
               {
                  InteractiveSprite.hitTest(this,_loc6_,HitBoxSprite.COUNTER,HitBoxSprite.ATTACK,this.reactionCounter,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc6_,HitBoxSprite.ATTACK,HitBoxSprite.ATTACK,this.reactionAttackReverse,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc6_,HitBoxSprite.ATTACK,HitBoxSprite.ATTACK,this.reactionClank,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc6_,HitBoxSprite.STAR,HitBoxSprite.HIT,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc6_,HitBoxSprite.ATTACK,HitBoxSprite.HIT,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc6_,HitBoxSprite.REVERSE,HitBoxSprite.ATTACK,this.reactionReverse,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,_loc6_,HitBoxSprite.REVERSE,HitBoxSprite.HIT,this.reactionReverse,STAGEDATA.HitBoxProcessorInstance);
               }
            }
            _loc1_++;
         }
         this.removeUngrabbedCharacters();
         if(inState(CState.ATTACKING) && this.m_grabbed.length > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < this.m_grabbed.length)
            {
               this.repositionGrabbedCharacter(_loc1_);
               _loc1_++;
            }
         }
         if(HasMC)
         {
            m_sprite.stop();
            Utils.recursiveMovieClipPlay(m_sprite,false);
         }
      }
      
      public function setLivesEnabled(param1:Boolean) : void
      {
         this.m_usingLives = param1;
         if(this.m_usingLives)
         {
            this.m_lastLivesTextNum = -1;
            this.updateLivesDisplay();
         }
         else
         {
            m_healthBoxMC.lives.text = "";
         }
      }
      
      public function grantFinalSmash() : Boolean
      {
         var _loc1_:Item = null;
         if(!this.m_item2)
         {
            _loc1_ = STAGEDATA.ItemsRef.generateItemObj(STAGEDATA.ItemsRef.getItemByLinkage("smashball"),m_sprite.x,m_sprite.y,true);
            return this.grantSmashBall(_loc1_);
         }
         return false;
      }
      
      public function grantSmashBall(param1:Item) : Boolean
      {
         if(!this.m_item2)
         {
            if(this.m_finalSmashMeterReady)
            {
               param1.destroy();
               return false;
            }
            this.m_item2 = param1;
            this.m_item2.SetPlayer(m_uid);
            this.m_item2.PickedUp = true;
            this.m_fsGlowHolderMC.scaleX = m_sizeRatio;
            this.m_fsGlowHolderMC.scaleY = m_sizeRatio;
            this.m_fsGlowHolderMC.x = m_sprite.x;
            this.m_fsGlowHolderMC.y = m_sprite.y;
            toggleEffect(this.m_fsGlowHolderMC,true);
            if(this.m_characterStats.FinalSmashMeter)
            {
               this.m_finalSmashMeterCharge = 1;
            }
            return true;
         }
         return false;
      }
      
      public function releaseSmashBall() : Boolean
      {
         if(this.m_item2)
         {
            this.m_item2.PickedUp = false;
            this.m_item2 = null;
            toggleEffect(this.m_fsGlowHolderMC,false);
            if(this.m_characterStats.FinalSmashMeter)
            {
               this.FinalSmashMeterCharge = 0;
            }
            return true;
         }
         return false;
      }
      
      public function giveItem(param1:Item) : void
      {
         if(this.m_item != null)
         {
            this.m_item.destroy();
         }
         this.m_item = param1;
         this.m_item.SetPlayer(m_uid);
      }
      
      public function resetJustHitTimer() : void
      {
         this.m_justHit = true;
         this.m_justHitTimer = 5;
      }
      
      public function resetJumps() : void
      {
         this.m_jumpCount = 0;
      }
      
      public function getPlayerSettings() : PlayerSetting
      {
         return this.m_playerSettings;
      }
      
      public function getCPULevel() : int
      {
         return this.m_playerSettings.level;
      }
      
      public function getCPUAction() : int
      {
         if(!this.CPU)
         {
            return -1;
         }
         return this.CPU.Action;
      }
      
      public function getCPUForcedAction() : int
      {
         if(!this.CPU)
         {
            return -1;
         }
         return this.CPU.ForcedAction;
      }
      
      public function getCPUTargetAPI() : *
      {
         if(Boolean(this.m_human) || !this.CPU || !this.CPU.CurrentTarget)
         {
            return null;
         }
         return this.CPU.CurrentTarget.PlayerSprite ? this.CPU.CurrentTarget.PlayerSprite.APIInstance.instance : null;
      }
      
      public function setCPUAttackQueue(param1:String) : void
      {
         if(Boolean(this.m_human) || !this.CPU)
         {
            return;
         }
         this.CPU.addToAttackQueue(param1);
      }
      
      public function importCPUControls(param1:Array) : void
      {
         if(this.CPU)
         {
            this.CPU.importControlOverrides(param1);
         }
      }
      
      public function resetCPUControls() : void
      {
         if(this.CPU)
         {
            this.CPU.resetControlOverrides();
         }
      }
      
      public function usingCPUControls() : Boolean
      {
         return !this.m_human && this.CPU && Boolean(this.CPU.ControlOverrides) && this.CPU.ControlOverrides.length > 0;
      }
      
      public function isForcedCrash() : Boolean
      {
         return this.m_forcedCrash;
      }
      
      public function isRecovering() : Boolean
      {
         return this.m_recoveryAmount > 0;
      }
      
      override public function forceAttack(param1:String, param2:* = null, param3:Boolean = false) : Boolean
      {
         if(this.inFreeState(CFreeState.ATTACKING | CFreeState.GRABBING) && param1 != null)
         {
            disableDelayPlayback();
            if(param1 === "special")
            {
               if(this.m_characterStats.SpecialType === 0)
               {
                  this.m_transformingSpecial = true;
               }
               this.SpecialAttack();
            }
            else
            {
               this.Attack(param1,param3 ? 2 : 1);
            }
            if(inState(CState.ATTACKING))
            {
               if(param2 !== null)
               {
                  this.stancePlayFrame(param2);
               }
               if(!HasTouchBox && this.m_grabbed.length > 0)
               {
                  this.releaseOpponent();
               }
               else if(this.m_grabbed.length > 0)
               {
                  this.repositionGrabbedCharacter();
               }
               return true;
            }
         }
         return false;
      }
      
      public function getSizeStatus() : int
      {
         return this.m_sizeStatus;
      }
      
      public function getCurrentKirbyPower() : String
      {
         return this.m_currentPower;
      }
      
      public function getExecTime() : int
      {
         return m_attack.ExecTime;
      }
      
      public function getCurrentAttackFrame() : String
      {
         return m_attack.Frame;
      }
      
      public function stealStock() : void
      {
         --this.m_lives;
         this.updateLivesDisplay();
      }
      
      public function getLives() : int
      {
         return this.m_lives;
      }
      
      public function setLives(param1:int) : void
      {
         this.m_lives = param1;
         this.updateLivesDisplay();
      }
      
      public function getControls(param1:Boolean = false) : Object
      {
         var _loc2_:Object = null;
         _loc2_ = {};
         _loc2_["UP"] = param1 ? this.m_pressedControls.UP : this.m_heldControls.UP;
         _loc2_["DOWN"] = param1 ? this.m_pressedControls.DOWN : this.m_heldControls.DOWN;
         _loc2_["LEFT"] = param1 ? this.m_pressedControls.LEFT : this.m_heldControls.LEFT;
         _loc2_["RIGHT"] = param1 ? this.m_pressedControls.RIGHT : this.m_heldControls.RIGHT;
         _loc2_["JUMP"] = param1 ? this.jumpIsPressed() : this.jumpIsHeld();
         _loc2_["BUTTON1"] = param1 ? this.m_pressedControls.BUTTON1 : this.m_heldControls.BUTTON1;
         _loc2_["BUTTON2"] = param1 ? this.m_pressedControls.BUTTON2 : this.m_heldControls.BUTTON2;
         _loc2_["GRAB"] = param1 ? this.m_pressedControls.GRAB : this.m_heldControls.GRAB;
         _loc2_["START"] = param1 ? this.m_pressedControls.START : this.m_heldControls.START;
         _loc2_["TAUNT"] = param1 ? this.m_pressedControls.TAUNT : this.m_heldControls.TAUNT;
         _loc2_["SHIELD"] = param1 ? this.m_pressedControls.SHIELD : this.shieldIsHeld();
         _loc2_["JUMP2"] = param1 ? this.m_pressedControls.JUMP2 : this.m_heldControls.JUMP2;
         _loc2_["C_UP"] = param1 ? this.m_pressedControls.C_UP : this.m_heldControls.C_UP;
         _loc2_["C_DOWN"] = param1 ? this.m_pressedControls.C_DOWN : this.m_heldControls.C_DOWN;
         _loc2_["C_LEFT"] = param1 ? this.m_pressedControls.C_LEFT : this.m_heldControls.C_LEFT;
         _loc2_["C_RIGHT"] = param1 ? this.m_pressedControls.C_RIGHT : this.m_heldControls.C_RIGHT;
         _loc2_["DASH"] = param1 ? this.m_pressedControls.DASH : this.m_heldControls.DASH;
         _loc2_["TAP_JUMP"] = this.m_tap_jump;
         _loc2_["AUTO_DASH"] = this.m_auto_dash;
         _loc2_["DT_DASH"] = this.m_dt_dash;
         _loc2_["SHIELD2"] = param1 ? this.m_pressedControls.SHIELD2 : this.m_heldControls.SHIELD2;
         _loc2_["JUMP3"] = param1 ? this.m_pressedControls.JUMP3 : this.m_heldControls.JUMP3;
         return _loc2_;
      }
      
      public function getControlBitsAPI(param1:Boolean = false) : int
      {
         return param1 ? int(this.m_pressedControls.controls) : int(this.m_heldControls.controls);
      }
      
      public function getLastUsed(param1:String = null) : int
      {
         if(m_attackData.getAttack(param1 != null ? param1 : m_attack.Frame) != null)
         {
            return m_attackData.getAttack(param1 != null ? param1 : m_attack.Frame).LastUsedPrevious;
         }
         return -1;
      }
      
      public function getHitsDealtCounter() : int
      {
         return this.m_hitsDealtCounter;
      }
      
      public function resetHitsDealtCounter() : void
      {
         this.m_hitsDealtCounter = 0;
      }
      
      public function getHitsReceivedCounter() : int
      {
         return this.m_hitsReceivedCounter;
      }
      
      public function resetHitsReceivedCounter() : void
      {
         this.m_hitsReceivedCounter = 0;
      }
      
      public function generateItem(param1:String, param2:Boolean = false, param3:Boolean = true, param4:Boolean = false) : Item
      {
         var _loc5_:int = 0;
         var _loc6_:Item = null;
         var _loc7_:Point = null;
         var _loc8_:Character = null;
         _loc5_ = 0;
         _loc7_ = new Point(m_sprite.x,m_sprite.y - 10);
         if(HasItemBox)
         {
            _loc7_.x = m_sprite.x + HitBoxSprite(this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.ITEM)[0]).xreg * m_sprite.scaleX;
            _loc7_.y = m_sprite.y + HitBoxSprite(this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.ITEM)[0]).yreg * m_sprite.scaleY;
         }
         if(param3)
         {
            if(this.m_characterStats.StatsName === "kirby" && Boolean(this.m_currentPower))
            {
               _loc5_ = 0;
               while(_loc5_ < STAGEDATA.Players.length)
               {
                  _loc8_ = STAGEDATA.Players[_loc5_];
                  if(Boolean(_loc8_) && _loc8_.StatsName === this.m_currentPower)
                  {
                     _loc6_ = STAGEDATA.ItemsRef.generateItemObj(_loc8_.AttackDataObj.getItem(param1),_loc7_.x,_loc7_.y);
                     break;
                  }
                  _loc5_++;
               }
            }
            _loc6_ ||= STAGEDATA.ItemsRef.generateItemObj(m_attackData.getItem(param1),_loc7_.x,_loc7_.y);
         }
         else if(param1 === "random")
         {
            _loc6_ = STAGEDATA.ItemsRef.makeItem(_loc7_.x,_loc7_.y);
         }
         else
         {
            _loc6_ = STAGEDATA.ItemsRef.generateItemObj(STAGEDATA.ItemsRef.getItemByLinkage(param1,!param4),_loc7_.x,_loc7_.y);
         }
         if(_loc6_ != null)
         {
            _loc6_.OriginalPlayerID = m_player_id;
            if(param2 && this.m_item == null)
            {
               this.m_item = _loc6_;
               this.m_item.PickedUp = true;
               this.m_item.SetPlayer(m_uid);
               this.m_item.inheritPalette();
               this.updateItemHolding();
            }
         }
         return _loc6_;
      }
      
      public function generateCharacterItem(param1:String, param2:String, param3:Boolean = false) : Item
      {
         var _loc4_:int = 0;
         var _loc5_:Item = null;
         var _loc6_:Point = null;
         var _loc7_:Character = null;
         if(param2 == null)
         {
            return null;
         }
         _loc4_ = 0;
         _loc6_ = new Point(m_sprite.x,m_sprite.y - 10);
         if(HasItemBox)
         {
            _loc6_.x = m_sprite.x + HitBoxSprite(this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.ITEM)[0]).xreg * m_sprite.scaleX;
            _loc6_.y = m_sprite.y + HitBoxSprite(this.CurrentAnimation.getHitBoxes(CurrentFrameNum,HitBoxSprite.ITEM)[0]).yreg * m_sprite.scaleY;
         }
         _loc4_ = 0;
         while(_loc4_ < STAGEDATA.Players.length)
         {
            _loc7_ = STAGEDATA.Players[_loc4_];
            if(_loc7_ != null && _loc7_.StatsName === param2)
            {
               _loc5_ = STAGEDATA.ItemsRef.generateItemObj(_loc7_.AttackDataObj.getItem(param1),_loc6_.x,_loc6_.y);
               break;
            }
            _loc4_++;
         }
         if(_loc5_ != null)
         {
            _loc5_.OriginalPlayerID = m_player_id;
            if(param3 && this.m_item == null)
            {
               this.m_item = _loc5_;
               this.m_item.PickedUp = true;
               this.m_item.SetPlayer(m_uid);
               this.updateItemHolding();
            }
         }
         return _loc5_;
      }
      
      public function removeItem() : void
      {
         if(this.m_item != null)
         {
            STAGEDATA.ItemsRef.killItem(this.m_item.Slot);
            this.m_item = null;
         }
      }
      
      public function maxOutJumps() : void
      {
         this.m_jumpCount = this.m_characterStats.MaxJump;
      }
      
      public function setAttackEnabled(param1:Boolean, param2:String = null, param3:int = -1) : void
      {
         if(param2 == null && inState(CState.ATTACKING))
         {
            param2 = m_attack.Frame;
         }
         if(param2 != null && m_attackData.getAttack(param2) != null)
         {
            m_attackData.getAttack(param2).IsDisabled = !param1;
            if(!param1)
            {
               m_attackData.getAttack(param2).ReenableTimerCount = param3 < 0 ? m_attackData.getAttack(param2).ReenableTimer : param3;
            }
         }
      }
      
      public function setLastUsed(param1:String, param2:int) : void
      {
         if(param1 != null && m_attackData.getAttack(param1) != null)
         {
            m_attackData.getAttack(param1).LastUsedPrevious = param2;
            m_attackData.getAttack(param1).LastUsed = param2;
         }
      }
      
      override public function setXSpeed(param1:Number, param2:Boolean = true) : void
      {
         if(inState(CState.STAR_KO) || inState(CState.SCREEN_KO))
         {
            return;
         }
         super.setXSpeed(param1,param2);
      }
      
      override public function setYSpeed(param1:Number) : void
      {
         if(inState(CState.STAR_KO) || inState(CState.SCREEN_KO))
         {
            return;
         }
         if(param1 != 0)
         {
            this.m_attackHovering = false;
         }
         super.setYSpeed(param1);
      }
      
      public function setSizeStatus(param1:int) : void
      {
         if(this.m_characterStats.StatusEffectImmunity)
         {
            return;
         }
         if(this.m_sizeStatusPermanent)
         {
            return;
         }
         if(this.m_sizeStatus == 1)
         {
            if(param1 == 1)
            {
               this.m_sizeStatusTimer.reset();
               return;
            }
            if(param1 == -1)
            {
               param1 = 0;
            }
         }
         else if(this.m_sizeStatus == -1)
         {
            if(param1 == -1)
            {
               this.m_sizeStatusTimer.reset();
               return;
            }
            if(param1 == 1)
            {
               param1 = 0;
            }
         }
         if(param1 == 1)
         {
            m_sizeRatio = this.m_originalSizeRatio * 2;
            m_sprite.scaleX = m_sprite.scaleX > 0 ? m_sizeRatio : -m_sizeRatio;
            m_sprite.scaleY = m_sprite.scaleY > 0 ? m_sizeRatio : -m_sizeRatio;
            this.m_sizeStatus = param1;
            m_attack.SizeStatus = this.m_sizeStatus;
            this.m_sizeStatusTimer.reset();
            if(this.m_grabbed.length > 0)
            {
               this.grabReleaseOpponent();
               this.grabRelease();
            }
            if(!inState(CState.ENTRANCE) && !this.m_usingSpecialAttack && !this.isGrabbedByFinalSmash())
            {
               this.endAttack();
            }
            this.killAllSpeeds();
         }
         else if(param1 == -1)
         {
            m_sizeRatio = this.m_originalSizeRatio / 2;
            m_sprite.scaleX = m_sprite.scaleX > 0 ? m_sizeRatio : -m_sizeRatio;
            m_sprite.scaleY = m_sprite.scaleY > 0 ? m_sizeRatio : -m_sizeRatio;
            this.m_sizeStatus = param1;
            this.m_sizeStatusTimer.reset();
            m_attack.SizeStatus = this.m_sizeStatus;
            if(this.m_grabbed.length > 0)
            {
               this.grabReleaseOpponent();
               this.grabRelease();
            }
            if(!inState(CState.ENTRANCE) && !this.m_usingSpecialAttack && !this.isGrabbedByFinalSmash())
            {
               this.endAttack();
            }
            this.killAllSpeeds();
         }
         else if(param1 == 0)
         {
            m_sizeRatio = this.m_originalSizeRatio;
            m_sprite.scaleX = m_sprite.scaleX > 0 ? m_sizeRatio : -m_sizeRatio;
            m_sprite.scaleY = m_sprite.scaleY > 0 ? m_sizeRatio : -m_sizeRatio;
            this.m_sizeStatus = param1;
            this.m_sizeStatusTimer.finish();
            m_attack.SizeStatus = this.m_sizeStatus;
         }
         m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.CHAR_SIZE_CHANGE,{
            "caller":this.APIInstance.instance,
            "sizeStatus":this.m_sizeStatus
         }));
      }
      
      override public function removeFromCamera() : void
      {
      }
      
      public function getInvincibility() : Boolean
      {
         return m_invincible;
      }
      
      public function getIntangibility() : Boolean
      {
         return m_intangible;
      }
      
      public function setInvisibilityTimer(param1:int) : void
      {
         this.m_invisibleTimer.reset();
         this.m_invisibleTimer.MaxTime = param1;
         this.setVisibility(false);
      }
      
      override public function setInvincibility(param1:Boolean) : void
      {
         super.setInvincibility(param1);
         if(!param1 && !m_intangible)
         {
            this.turnOffInvincibility();
         }
      }
      
      override public function setIntangibility(param1:Boolean) : void
      {
         super.setIntangibility(param1);
         if(!param1 && !m_invincible)
         {
            this.turnOffInvincibility();
         }
      }
      
      public function getShieldPower() : Number
      {
         return this.m_shieldPower / 100;
      }
      
      public function getSmashTimer() : int
      {
         return this.m_smashTimer;
      }
      
      public function getGrabbedOpponentAPI() : *
      {
         return this.m_grabbed.length == 0 ? null : this.m_grabbed[0].APIInstance.instance;
      }
      
      public function getItemAPI() : *
      {
         return this.m_item ? this.m_item.APIInstance.instance : null;
      }
      
      public function getTeammates() : Array
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         _loc1_ = new Array();
         _loc2_ = 0;
         while(_loc2_ < STAGEDATA.Characters.length)
         {
            if(m_team_id > 0 && m_team_id == STAGEDATA.Characters[_loc2_].Team && STAGEDATA.Characters[_loc2_] != this)
            {
               _loc1_.push(STAGEDATA.Characters[_loc2_]);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getTeammatesAPI() : Array
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         _loc1_ = new Array();
         _loc2_ = 0;
         while(_loc2_ < STAGEDATA.Characters.length)
         {
            if(m_team_id > 0 && m_team_id == STAGEDATA.Characters[_loc2_].Team && STAGEDATA.Characters[_loc2_] != this)
            {
               _loc1_.push(STAGEDATA.Characters[_loc2_].APIInstance.instance);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function gotoGrabbedCharacter() : void
      {
         if(this.m_grabbed.length > 0)
         {
            m_sprite.x = this.m_grabbed[0].X;
            m_sprite.y = this.m_grabbed[0].Y;
         }
      }
      
      public function damageSelf(param1:int) : void
      {
         this.dealDamage(param1);
      }
      
      public function isRocketing() : Boolean
      {
         return inState(CState.ATTACKING) && m_attack.Rocket;
      }
      
      override public function forceHitStun(param1:int, param2:Number = -1) : void
      {
         if(param2 > 0)
         {
            this.m_smashDIAmount = this.SDI_BASE * param2;
         }
         startActionShot(param1);
      }
      
      public function forceGrabbedHurtFrame(param1:String) : void
      {
         var _loc2_:int = 0;
         if(this.m_grabbed.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.m_grabbed.length)
            {
               if(Boolean(this.m_grabbed[_loc2_].HasStance) && Boolean(Utils.hasLabel(this.m_grabbed[_loc2_].MC.stance,param1)))
               {
                  this.m_grabbed[_loc2_].playHurtFrame(param1);
               }
               _loc2_++;
            }
            this.updateCutscenePlaceholders();
         }
      }
      
      public function shakeCamera(param1:int) : void
      {
         CAM.shake(param1);
      }
      
      public function swapDepthsWithGrabbedOpponent(param1:Boolean) : void
      {
         if(this.m_grabbed.length > 0 && Boolean(this.m_grabbed[0].IsCaught))
         {
            if(param1 && Depth < this.m_grabbed[0].Depth)
            {
               swapDepths(this.m_grabbed[0]);
            }
            else if(!param1 && Depth > this.m_grabbed[0].Depth)
            {
               swapDepths(this.m_grabbed[0]);
            }
         }
      }
      
      public function resetMovement(param1:* = null) : void
      {
         m_xSpeed = 0;
         m_ySpeed = 0;
         if(Boolean(param1) && param1 is SSF2Event)
         {
            m_eventManager.removeEventListener(SSF2Event(param1).type,this.resetMovement);
         }
      }
      
      public function isCPU() : Boolean
      {
         return !this.m_human;
      }
      
      public function switchAttackData(param1:String, param2:String, param3:* = null) : void
      {
         if(inState(CState.ATTACKING) && m_attackData.getAttack(param2) != null)
         {
            m_attackData.setAttack(param1,m_attackData.getAttack(param2).Clone());
            if(!this.m_human)
            {
               this.CPU.refreshRecoveryAttackList();
               this.CPU.refreshDisabledAttackList();
            }
         }
      }
      
      public function switchAttack(param1:String, param2:* = null) : void
      {
         if(param1 != null && m_attackData.getAttack(param1) != null)
         {
            m_attack.Frame = param1;
            m_attackData.getAttack(param1).OverrideMap.clear();
            this.playFrame(m_attack.Frame);
            if(param2 !== null)
            {
               this.stancePlayFrame(param2);
            }
         }
      }
      
      public function clearAttackControlsArr() : void
      {
         while(this.m_attackControlsArr.length > 0)
         {
            this.m_attackControlsArr.splice(0,1);
         }
      }
      
      public function endAttack(param1:String = null, param2:String = null) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         if(Boolean(m_player_id == 1 && inState(CState.ATTACKING) && Main.DEBUG) && Boolean(MenuController.debugConsole) && Boolean(MenuController.debugConsole.ControlsCapture))
         {
            _loc4_ = "[ ";
            _loc5_ = 0;
            while(_loc5_ < this.m_attackControlsArr.length)
            {
               if(_loc5_ != 0)
               {
                  _loc4_ += ", ";
               }
               _loc4_ += "" + this.m_attackControlsArr[_loc5_];
               _loc5_++;
            }
            _loc4_ += " ]";
            MenuController.debugConsole.writeEndAttackControls(_loc4_);
            this.clearAttackControlsArr();
         }
         _loc3_ = uint(CState.IDLE);
         if(param1 != null)
         {
            _loc6_ = new Array();
            _loc6_["stand"] = CState.IDLE;
            _loc6_["walk"] = CState.WALK;
            _loc6_["run"] = CState.RUN;
            _loc6_["jump"] = CState.JUMP_RISING;
            _loc6_["jump_midair"] = CState.JUMP_MIDAIR_RISING;
            _loc6_["fall"] = CState.JUMP_FALLING;
            _loc6_["land"] = CState.LAND;
            _loc6_["crouch"] = CState.CROUCH;
            _loc6_["falling"] = CState.TUMBLE_FALL;
            if(!_loc6_[param1])
            {
               _loc3_ = uint(_loc6_[param1]);
            }
            else
            {
               param1 = null;
            }
         }
         else
         {
            param1 = null;
         }
         if(m_collision.ground)
         {
            this.forceEndAttack();
            if(param1)
            {
               this.setState(_loc3_);
            }
            this.m_checkTaunt();
            if(HasStance && param2 != null)
            {
               this.stancePlayFrame(param2);
            }
         }
         else
         {
            this.forceEndAttack();
            if(HasStance && param2 != null)
            {
               this.stancePlayFrame(param2);
            }
         }
         this.checkEdgeLean();
         this.updateTint();
         this.m_lastFrameInterrupt = null;
      }
      
      public function endFinalForm() : void
      {
         var _loc1_:String = null;
         var _loc2_:Boolean = false;
         if(this.m_transformedSpecial)
         {
            this.m_transformTime = this.m_transformLimit;
            STAGEDATA.ItemsRef.SmashBallReady.CurrentTime = STAGEDATA.ItemsRef.SmashBallReady.MaxTime;
            if(Boolean(m_healthBoxMC) && !this.m_characterStats.FinalSmashMeter)
            {
               m_healthBoxMC.fsmeter.visible = false;
            }
            _loc1_ = this.m_characterStats.Power;
            _loc2_ = m_sprite.visible;
            if(STAGEPARENT.getChildByName("energy" + m_player_id) != null)
            {
               STAGEPARENT.removeChild(STAGEPARENT.getChildByName("energy" + m_player_id));
            }
            this.setState(CState.IDLE);
            this.m_transformedSpecial = false;
            this.replaceCharacter(this.m_characterStats.NormalStatsID,null,null);
            this.setVisibility(_loc2_);
            if(this.m_characterStats.FinalSmashMeter)
            {
               this.FinalSmashMeterCharge = 0;
               this.m_finalSmashMeterReady = false;
               if(m_healthBoxMC)
               {
                  m_healthBoxMC.fsmeter.bar.gotoAndPlay("fill");
                  m_healthBoxMC.fsmeter.fullcharge.gotoAndPlay("off");
               }
            }
         }
      }
      
      public function transformTimerExtend(param1:Number) : void
      {
         this.m_transformTime -= param1;
      }
      
      override public function stopActionShot(param1:Boolean = true, param2:Boolean = true) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(!param1 && !param2)
         {
            return;
         }
         if(isHitStunOrParalysis())
         {
            if(param1)
            {
               m_actionShot = false;
            }
            if(param2)
            {
               if(m_paralysis)
               {
                  m_maxParalysisTime.reset();
               }
               m_paralysis = false;
            }
            this.m_controlFrames();
            if(inState(CState.FLYING) || inState(CState.INJURED))
            {
               _loc3_ = Number(Utils.calculateSpeed(m_xKnockback,m_yKnockback));
               _loc4_ = Number(Utils.getAngleBetween(new Point(0,0),new Point(m_xKnockback,m_yKnockback)));
               _loc5_ = Number(this.calculateDI(_loc4_));
               m_xKnockback = Utils.calculateXSpeed(_loc3_,_loc5_);
               m_yKnockback = -Utils.calculateYSpeed(_loc3_,_loc5_);
               resetKnockbackDecay();
            }
         }
      }
      
      public function playReflectSound() : void
      {
         this.playGlobalSound("reflected");
      }
      
      public function queueMove(param1:String) : void
      {
         var _loc2_:* = 0;
         _loc2_ = int(this.m_staleMovesArr.length - 1);
         while(_loc2_ > 0)
         {
            if(_loc2_ > 0)
            {
               this.m_staleMovesArr[_loc2_] = this.m_staleMovesArr[_loc2_ - 1];
            }
            _loc2_--;
         }
         this.m_staleMovesArr[0] = param1;
      }
      
      public function resetStaleMoves() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.m_staleMovesArr.length)
         {
            this.m_staleMovesArr[_loc1_] = null;
            _loc1_++;
         }
      }
      
      public function totalMoveDecay(param1:String) : Number
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         if(ModeFeatures.hasFeature(ModeFeatures.IGNORE_STALE_DECAY,STAGEDATA.GameRef.GameMode))
         {
            return 1;
         }
         _loc2_ = 0;
         _loc3_ = 0;
         _loc4_ = 0;
         while(_loc4_ != -1)
         {
            _loc4_ = int(this.m_staleMovesArr.indexOf(param1,_loc3_));
            if(_loc4_ >= 0)
            {
               _loc3_ = _loc4_ + 1;
               _loc2_ += this.m_staleMoveVals[_loc4_];
            }
         }
         if(_loc2_ == 0)
         {
            return 1.05;
         }
         return 1 - _loc2_;
      }
      
      override public function reverse(param1:int, param2:int, param3:Boolean) : Boolean
      {
         if(this.m_forceTimer <= 0)
         {
            if(inState(CState.ATTACKING))
            {
               m_attack.IsForward = !m_attack.IsForward;
            }
            m_xSpeed *= -1;
            this.m_jumpSpeedBuffer *= -1;
            m_xKnockback *= -1;
            resetKnockbackDecay();
            this.m_flyingRight = !this.m_flyingRight;
            if(m_facingForward)
            {
               m_faceLeft();
            }
            else
            {
               m_faceRight();
            }
            if(!inState(CState.ATTACKING) && m_xSpeed != 0)
            {
               this.m_forceRight = m_facingForward;
               this.m_forceTimer = 8;
            }
            return true;
         }
         return false;
      }
      
      public function calculateHitLag(param1:Number, param2:Number) : int
      {
         return Utils.calculateHitlag(param1,param2);
      }
      
      override protected function validateBypass(param1:AttackDamage) : Boolean
      {
         if(param1.BypassGrabbed && inState(CState.CAUGHT))
         {
            return false;
         }
         if(param1.BypassNonGrabbed && !inState(CState.CAUGHT))
         {
            return false;
         }
         if(Boolean(param1.Owner as Projectile && param1.BypassNonLatched) && Boolean(Projectile(param1.Owner).Latched) && Projectile(param1.Owner).LatchID == this)
         {
            return false;
         }
         return true;
      }
      
      override public function validateHit(param1:AttackDamage, param2:Boolean = false, param3:Boolean = false) : Boolean
      {
         if(Boolean(!super.validateHit(param1,param2,param3) || inState(CState.REVIVAL) || inState(CState.KIRBY_STAR) || this.m_standby || inState(CState.BARREL) || inState(CState.CAUGHT) && !param1.HasEffect && this.m_grabberID > 0 && param1.Owner && STAGEDATA.getCharacterByUID(this.m_grabberID).ID !== param1.Owner.ID) || Boolean(this.m_usingSpecialAttack) || Boolean(this.m_usingSpecialAttack) && this.m_characterStats.SpecialType == 3 && m_attack.ExecTime > 1 && !(param1.Owner as Character && Character(param1.Owner).Caught()))
         {
            return false;
         }
         return true;
      }
      
      private function calculateDIOld(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         if(!this.m_canDI)
         {
            return param2;
         }
         _loc3_ = param2;
         _loc4_ = Number(Utils.getControlsAngle(this.getControls()));
         _loc5_ = Number(Utils.getControlsAngle({
            "UP":this.m_pressedControls.C_UP,
            "DOWN":this.m_pressedControls.C_DOWN,
            "LEFT":this.m_pressedControls.C_LEFT,
            "RIGHT":this.m_pressedControls.C_RIGHT
         }));
         _loc6_ = _loc4_ >= 0 && _loc5_ >= 0 ? _loc4_ + _loc5_ / 2 : (_loc4_ >= 0 ? _loc4_ : (_loc5_ >= 0 ? _loc5_ : -1));
         if(Utils.forceBase360(_loc3_ - _loc6_) >= 180 - this.MAX_DI_CHANGE && Utils.forceBase360(_loc3_ - _loc6_) <= 180 + this.MAX_DI_CHANGE)
         {
            return _loc3_;
         }
         if(_loc6_ >= 0)
         {
            _loc7_ = param1 * 0.325 * Math.cos(_loc6_ * Math.PI / 180);
            _loc8_ = param1 * 0.325 * Math.sin(_loc6_ * Math.PI / 180);
            _loc9_ = param1 * Math.cos(param2 * Math.PI / 180);
            _loc10_ = param1 * Math.sin(param2 * Math.PI / 180);
            _loc3_ = Math.atan2(_loc10_ + _loc8_,_loc9_ + _loc7_) * 180 / Math.PI;
         }
         return _loc3_;
      }
      
      private function calculateDI(param1:Number) : Number
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(this.m_canDI)
         {
            _loc2_ = Number(Utils.getControlsAngle(this.getControls()));
            _loc3_ = Number(Utils.getControlsAngle({
               "UP":this.m_pressedControls.C_UP,
               "DOWN":this.m_pressedControls.C_DOWN,
               "LEFT":this.m_pressedControls.C_LEFT,
               "RIGHT":this.m_pressedControls.C_RIGHT
            }));
            _loc4_ = _loc2_ >= 0 && _loc3_ >= 0 ? _loc2_ - (_loc2_ - _loc3_) / 2 : (_loc2_ >= 0 ? _loc2_ : (_loc3_ >= 0 ? _loc3_ : -1));
            if(_loc4_ >= 0)
            {
               while(param1 - _loc4_ <= -180)
               {
                  _loc4_ -= 360;
               }
               while(param1 - _loc4_ >= 180)
               {
                  _loc4_ += 360;
               }
               if(param1 - _loc4_ < -90)
               {
                  return param1 + Math.min((param1 - _loc4_ + 180) / 90 * this.MAX_DI_CHANGE,this.DI_CAP);
               }
               if(param1 - _loc4_ > 90)
               {
                  return param1 - Math.min(-((param1 - _loc4_ - 180) / 90) * this.MAX_DI_CHANGE,this.DI_CAP);
               }
               return param1 - (param1 - _loc4_ >= 0 ? 1 : -1) * Math.min(Utils.fastAbs((param1 - _loc4_) / 90 * this.MAX_DI_CHANGE),this.DI_CAP);
            }
            return param1;
         }
         return param1;
      }
      
      public function killAllSpeeds(param1:Boolean = false, param2:Boolean = false) : void
      {
         if(!param1)
         {
            m_xSpeed = 0;
            m_ySpeed = 0;
         }
         if(!param2)
         {
            m_xKnockback = 0;
            m_yKnockback = 0;
         }
      }
      
      override public function netXSpeed(param1:Boolean = false, param2:Boolean = false) : Number
      {
         var _loc3_:Number = NaN;
         _loc3_ = 0;
         if(!param1)
         {
            _loc3_ += m_xSpeed;
         }
         if(!param2)
         {
            _loc3_ += m_xKnockback;
            if(Main.FRAMERATE == 30 && m_xKnockback != 0)
            {
               _loc3_ += m_xKnockback - m_xKnockbackDecay;
            }
         }
         return _loc3_;
      }
      
      override public function netYSpeed(param1:Boolean = false, param2:Boolean = false) : Number
      {
         var _loc3_:Number = NaN;
         _loc3_ = 0;
         if(!param1)
         {
            _loc3_ += m_ySpeed;
         }
         if(!param2)
         {
            _loc3_ += m_yKnockback;
            if(Main.FRAMERATE == 30 && m_yKnockback != 0)
            {
               _loc3_ += m_yKnockback - m_yKnockbackDecay;
            }
         }
         return _loc3_;
      }
      
      public function getPoison() : Object
      {
         return {
            "damage":this.m_poisonIncrease,
            "interval":this.m_poisonIncreaseInterval.MaxTime,
            "length":this.m_poisonIncreaseTime.MaxTime,
            "remaining":this.m_poisonIncreaseTime.MaxTime - this.m_poisonIncreaseTime.CurrentTime
         };
      }
      
      public function setPoison(param1:int, param2:int = 15, param3:int = 300) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         _loc4_ = 0;
         _loc5_ = 0;
         if(this.m_poisonIncrease > 0)
         {
            _loc4_ = this.m_poisonIncrease * Math.floor((this.m_poisonIncreaseTime.MaxTime - this.m_poisonIncreaseTime.CurrentTime) / this.m_poisonIncreaseInterval.MaxTime);
            _loc5_ = param1 * Math.floor(param3 / param2);
         }
         if(param1 === 0)
         {
            this.m_poisonIncreaseTime.reset();
            this.m_poisonIncrease = 0;
            toggleEffect(this.m_poisonEffect,false);
         }
         else if(_loc4_ <= 0 || _loc5_ > _loc4_)
         {
            this.m_poisonIncrease = param1;
            this.m_poisonIncreaseInterval.MaxTime = param2;
            this.m_poisonIncreaseTime.MaxTime = param3;
            this.m_poisonTintTimer.reset();
            toggleEffect(this.m_poisonEffect,true);
            this.m_poisonEffect.gotoAndStop(1);
            this.m_poisonEffect.x = m_sprite.x;
            this.m_poisonEffect.y = m_sprite.y;
         }
      }
      
      public function isGrabbedByFinalSmash() : Boolean
      {
         return inState(CState.CAUGHT) && this.m_grabberID > 0 && Boolean(STAGEDATA.getCharacterByUID(this.m_grabberID)) && STAGEDATA.getCharacterByUID(this.m_grabberID).UsingFinalSmash;
      }
      
      override public function takeDamage(param1:AttackDamage, param2:HitBoxSprite = null) : Boolean
      {
         var _loc3_:Character = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:uint = 0;
         var _loc7_:Boolean = false;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Boolean = false;
         var _loc16_:Boolean = false;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Boolean = false;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Boolean = false;
         var _loc30_:Boolean = false;
         var _loc31_:Boolean = false;
         var _loc32_:Number = NaN;
         var _loc33_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc35_:Number = NaN;
         var _loc36_:Number = NaN;
         var _loc37_:MovieClip = null;
         var _loc38_:MovieClip = null;
         var _loc39_:Number = NaN;
         var _loc40_:Number = NaN;
         var _loc41_:Boolean = false;
         var _loc42_:MovieClip = null;
         var _loc43_:int = 0;
         if(!this.validateHit(param1,false,true))
         {
            return false;
         }
         _loc3_ = null;
         _loc4_ = this.isGrabbedByFinalSmash() && param1.Owner.UID !== this.m_grabberID;
         _loc5_ = param1.Owner && param1.Owner is Character && param1.Owner.inState(CState.ATTACKING) && Character(param1.Owner).AttackStateData.Frame === "special";
         _loc6_ = m_state;
         _loc7_ = true;
         _loc8_ = 0;
         _loc9_ = m_damage;
         _loc10_ = 0;
         _loc11_ = 0;
         _loc12_ = m_xKnockback;
         _loc13_ = m_yKnockback;
         _loc14_ = Number(Utils.calculateSpeed(_loc12_,_loc13_));
         _loc15_ = false;
         _loc16_ = true;
         _loc17_ = 0;
         _loc18_ = 0;
         _loc19_ = param1.SizeStatus == 0 ? 1 : (param1.SizeStatus > 0 ? 2 : 0.5);
         _loc20_ = this.m_isMetal ? 2.8 : 1;
         _loc21_ = inState(CState.FLYING);
         if(!_loc4_ && !_loc5_)
         {
            if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.FREEZE))
            {
               param1.Freeze = 90;
            }
            else if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.EGG))
            {
               param1.Egg = true;
            }
         }
         _loc22_ = param1.Damage <= 0 ? 0 : Number(Utils.calculateChargeDamage(param1));
         _loc23_ = m_baseStats.Stamina > 0 ? Number(Utils.calculateVelocity(Utils.calculateKnockback(param1.KBConstant,param1.Power,param1.WeightKB,0,0,this.m_characterStats.Weight1 * _loc20_,inState(CState.ATTACKING) && (currentStanceFrameIs("charging") && m_attack.AttackType === 1),this.m_characterStats.DamageRatio,param1.AttackRatio))) : Number(Utils.calculateVelocity(Utils.calculateKnockback(param1.KBConstant,param1.Power,param1.WeightKB,_loc22_,_loc9_,this.m_characterStats.Weight1 * _loc20_,inState(CState.ATTACKING) && (currentStanceFrameIs("charging") && m_attack.AttackType === 1),this.m_characterStats.DamageRatio,param1.AttackRatio)));
         if(this.m_sizeStatus != 0)
         {
            _loc23_ *= this.m_sizeStatus == 1 ? 0.75 : 1.5;
         }
         if(HasStance && Boolean(m_sprite.stance.heavyArmor))
         {
            _loc27_ = Number(m_sprite.stance.heavyArmor);
         }
         _loc24_ = Number(Utils.calculateVelocity(Utils.calculateKnockback(param1.KBConstant,param1.Power,0,0,0,this.m_characterStats.Weight1 * _loc20_,false,1,1)));
         _loc25_ = param1.BypassLaunchResistance ? 0 : (Boolean(this.m_isMetal) && param1.IsThrow ? 0 : (inState(CState.ATTACKING) && m_attack.LaunchResistance > 0 ? m_attack.LaunchResistance : (this.m_characterStats.LaunchResistance > 0 ? Number(this.m_characterStats.LaunchResistance) : (this.m_isMetal ? 5 : 0))));
         _loc26_ = _loc25_ > 0 ? _loc23_ - _loc25_ : 0;
         _loc27_ = Boolean(this.m_isMetal) && param1.IsThrow ? 0 : (_loc25_ > 0 ? -_loc25_ : Number(this.m_characterStats.HeavyArmor));
         if((Boolean(m_paralysis || inState(CState.CAUGHT) && this.m_grabberID >= 0 && param1.Owner && param1.Owner.UID == this.m_grabberID && STAGEDATA.getCharacterByUID(this.m_grabberID).Grabbed.indexOf(this) >= 0 && !(param1.Owner is Character) || inState(CState.CAUGHT) && this.m_grabberID >= 0 && param1.Owner && param1.Owner.UID != this.m_grabberID && STAGEDATA.getCharacterByUID(this.m_grabberID).Grabbed.indexOf(this) >= 0 && _loc23_ < Character.HEAVY_KNOCKBACK_THRESHOLD && !(STAGEDATA.getCharacterByUID(this.m_grabberID).UsingFinalSmash && STAGEDATA.getCharacterByUID(this.m_grabberID).SpecialType == 6)) || Boolean(inState(CState.PITFALL))) && !param1.ForceTumbleFall)
         {
            _loc27_ = -Character.HEAVY_KNOCKBACK_THRESHOLD;
         }
         if(param1.Paralysis > 0 && m_paralysis || inState(CState.EGG) || inState(CState.ATTACKING) && (m_attack.SuperArmor && !param1.BypassSuperArmor || m_attack.HeavyArmor != 0 && !param1.BypassHeavyArmor && !(param1.IsThrow && Boolean(this.m_isMetal)) && (m_attack.HeavyArmor > 0 && _loc22_ <= m_attack.HeavyArmor || m_attack.HeavyArmor < 0 && _loc23_ <= -m_attack.HeavyArmor)) || _loc27_ != 0 && !param1.BypassHeavyArmor && !(param1.IsThrow && Boolean(this.m_isMetal)) && (_loc27_ > 0 && _loc22_ <= _loc27_ || _loc27_ < 0 && _loc23_ <= -_loc27_))
         {
            if(_loc25_ <= 0 || _loc25_ > 0 && _loc26_ <= 0)
            {
               _loc15_ = true;
               _loc16_ = param1.HasEffect;
               _loc17_ = param1.Power;
               _loc18_ = param1.KBConstant;
               param1.Power = 0;
               param1.KBConstant = 0;
               param1.HasEffect = false;
               param1.Paralysis = -1;
            }
         }
         if(param1.HasEffect && !isIntangible())
         {
            if(m_hurtInterrupt != null && Boolean(m_hurtInterrupt({
               "target":(Boolean(param1.Owner) && Boolean(param1.Owner.APIInstance) ? param1.Owner.APIInstance.instance : null),
               "attackBoxData":param1.exportAttackDamageData(),
               "collisionRect":(param2 ? param2.BoundingBox : null)
            })))
            {
               if(_loc15_)
               {
                  param1.HasEffect = _loc16_;
                  param1.Power = _loc17_;
                  param1.KBConstant = _loc18_;
               }
               return false;
            }
            if(!inState(CState.INJURED) && !inState(CState.FLYING) && !inState(CState.CAUGHT))
            {
               initDelayPlayback(false);
            }
            this.m_disableHurtFallOff = param1.DisableHurtFallOff;
            setBrightness(0);
            if(!this.m_human)
            {
               this.CPU.resetControlOverrides();
            }
            ++this.m_hitsReceivedCounter;
            this.resetSmashTimers();
            this.m_usingSpecialAttack = false;
            _loc28_ = 0;
            if(this.m_grabbed.length > 0)
            {
               this.grabReleaseOpponent();
            }
            if(param1.IsThrow)
            {
               this.Uncapture();
               this.unnattachFromGround();
            }
            this.m_hitLagStunTimer.reset();
            if(STAGEPARENT.getChildByName("energy" + m_player_id) != null)
            {
               STAGEPARENT.removeChild(STAGEPARENT.getChildByName("energy" + m_player_id));
            }
            if(_loc6_ === CState.CAUGHT && Boolean(this.m_hitForceVisible))
            {
               this.setVisibility(true);
            }
            if(Boolean(_loc6_ === CState.CAUGHT && this.m_grabberID >= 0) && Boolean(STAGEDATA.getCharacterByUID(this.m_grabberID)) && !_loc4_)
            {
               _loc3_ = STAGEDATA.getCharacterByUID(this.m_grabberID);
               if(_loc3_.Grabbed.indexOf(this) >= 0)
               {
                  _loc3_.releaseOpponent(_loc3_.Grabbed.indexOf(this));
                  if(!param1.IsThrow && param1.Owner !== _loc3_ && !(param1.Owner is Projectile && Projectile(param1.Owner).getOwner() === _loc3_ && !Projectile(param1.Owner).WasReversed))
                  {
                     _loc3_.grabRelease();
                  }
               }
            }
            if(inState(CState.SHIELDING))
            {
               this.m_deactivateShield();
            }
            this.m_smashDIAmount = this.SDI_BASE * param1.SDIDistance;
            this.m_jumpStartup.reset();
            this.m_charIsFull = false;
            this.m_justReleased = false;
            if(inState(CState.LEDGE_HANG))
            {
               this.unnattachFromLedge();
            }
            this.m_ledge = null;
            this.m_lastLedge = null;
            _loc29_ = inState(CState.DIZZY);
            this.m_dizzyTimer = 0;
            _loc30_ = inState(CState.PITFALL);
            toggleEffect(this.m_pitfallEffect,false);
            this.m_stunTimer = 0;
            this.m_sleepingTimer = 0;
            this.m_midAirJumpConstantTime.finish();
            if(m_attack.CancelSoundOnEnd)
            {
               this.stopSoundID(this.m_lastSFX);
               this.m_lastSFX = -1;
            }
            if(m_attack.CancelVoiceOnEnd)
            {
               this.stopSoundID(this.m_lastVFX);
               this.m_lastVFX = -1;
            }
            if(inState(CState.ATTACKING) && m_attackData.getAttack(m_attack.Frame).ChargeRetain)
            {
               m_attackData.getAttack(m_attack.Frame).ChargeTime = 0;
            }
            if(inState(CState.ATTACKING) && !m_collision.ground && m_attack.DisableJump)
            {
               this.m_jumpCount = this.m_characterStats.MaxJump;
            }
            m_attack.Rocket = false;
            if(inState(CState.LEDGE_HANG))
            {
            }
            this.m_crouchFrame = -1;
            this.m_canWallTech = true;
            _loc10_ = 0;
            _loc8_ = param1.Damage <= 0 ? 0 : Number(Utils.calculateChargeDamage(param1));
            _loc8_ *= param1.StaleMultiplier;
            if(inState(CState.FROZEN))
            {
               _loc8_ /= 2;
            }
            if(param1.Damage > 0 && _loc8_ <= 0)
            {
               _loc8_ = 1;
            }
            if(_loc8_ != 0)
            {
               throbDamageCounter();
            }
            if(!STAGEDATA.GameEnded)
            {
               this.m_matchResults.DamageTaken += _loc8_;
            }
            if(this.m_recoveryAmount > 0)
            {
               this.m_recoveryAmount -= _loc8_;
               if(this.m_recoveryAmount <= 0)
               {
                  _loc8_ = -this.m_recoveryAmount;
                  this.m_recoveryAmount = 0;
               }
               else
               {
                  _loc8_ = 0;
               }
            }
            if(this.m_characterStats.CanReceiveDamage)
            {
               this.dealDamage(_loc8_);
            }
            if(Boolean(this.m_human) && this.ID > 0)
            {
               Gamepad.rumbleOnDamage(this.ID,_loc8_,_loc10_);
            }
            this.m_kirbyDamageCounter -= _loc8_;
            this.m_itemDamageCounter -= _loc8_;
            if(!m_attack.DisableLastHitUpdate)
            {
               m_lastHitID = param1.PlayerID;
               m_lastHitObject = param1;
            }
            if(m_lastHitID > 0)
            {
               STAGEDATA.getPlayerByID(m_lastHitID).getMatchResults().DamageGiven = STAGEDATA.getPlayerByID(m_lastHitID).getMatchResults().DamageGiven + _loc8_;
               STAGEDATA.getPlayerByID(m_lastHitID).resetDroughtTimer();
               if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.VAMPIRE))
               {
                  STAGEDATA.getPlayerByID(m_lastHitID).recover(_loc8_ / 2);
               }
               else if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.VENGEANCE))
               {
                  STAGEDATA.getPlayerByID(m_lastHitID).dealDamage(_loc8_ / 2);
                  STAGEDATA.getPlayerByID(m_lastHitID).throbDamageCounter();
               }
            }
            if(param1.Owner is Character && Boolean(Character(param1.Owner).CharacterStats.FinalSmashMeter) && !Character(param1.Owner).UsingFinalSmash && !Character(param1.Owner).TransformedSpecial)
            {
               Character(param1.Owner).FinalSmashMeterCharge = Character(param1.Owner).FinalSmashMeterCharge + _loc8_ / 500;
            }
            else if(param1.Owner is Projectile && Projectile(param1.Owner).getOwner() is Character && Boolean(Character(Projectile(param1.Owner).getOwner()).CharacterStats.FinalSmashMeter))
            {
               Character(Projectile(param1.Owner).getOwner()).FinalSmashMeterCharge = Character(Projectile(param1.Owner).getOwner()).FinalSmashMeterCharge + _loc8_ / 500;
            }
            if(param1.AttackID != -1)
            {
               stackAttackID(param1.AttackID);
            }
            this.m_smashDISelf = false;
            if(m_paralysis)
            {
               this.stopActionShot(false,true);
               startActionShot(Utils.calculateHitStun(param1.HitStun,_loc8_,param1.Shock,_loc6_ == CState.CROUCH));
            }
            else
            {
               startActionShot(Utils.calculateHitStun(param1.HitStun,_loc8_,param1.Shock,_loc6_ == CState.CROUCH),param1.Paralysis);
               this.m_lastHitStun = m_actionTimer;
            }
            this.checkDI();
            if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
            {
               _loc11_ = m_damage * 1.1;
            }
            else if(this.m_characterStats.Stamina > 0)
            {
               _loc11_ = Number(Utils.calculateKnockback(param1.KBConstant,param1.Power,param1.WeightKB,0,0,this.m_characterStats.Weight1 * _loc20_,inState(CState.ATTACKING) && (currentStanceFrameIs("charging") && m_attack.AttackType === 1),this.m_characterStats.DamageRatio,param1.AttackRatio));
            }
            else
            {
               _loc11_ = Number(Utils.calculateKnockback(param1.KBConstant,param1.Power,param1.WeightKB,_loc22_,_loc9_,this.m_characterStats.Weight1 * _loc20_,inState(CState.ATTACKING) && (currentStanceFrameIs("charging") && m_attack.AttackType === 1),this.m_characterStats.DamageRatio,param1.AttackRatio));
            }
            if(inState(CState.FROZEN))
            {
               _loc11_ /= 4;
            }
            _loc10_ = _loc26_ > 0 ? _loc26_ : Number(Utils.calculateVelocity(_loc11_));
            _loc11_ = _loc26_ > 0 ? Number(Utils.calculateKnockbackFromVelocity(_loc10_)) : _loc11_;
            if(!this.m_characterStats.CanReceiveKnockback)
            {
               _loc10_ = 0;
            }
            if(this.m_sizeStatus != 0)
            {
               _loc10_ *= this.m_sizeStatus == 1 ? 0.75 : 1.5;
            }
            _loc31_ = inState(CState.CRASH_LAND);
            this.m_forceTumbleFall = !inState(CState.CRASH_LAND) && (_loc10_ >= Character.HEAVY_KNOCKBACK_THRESHOLD || param1.ForceTumbleFall);
            _loc32_ = this.calculateHitLag(_loc11_,param1.HitLag);
            this.m_hitLag = this.m_hitLag <= 0 || _loc32_ > this.m_hitLag ? int(_loc32_) : int(this.m_hitLag);
            if(this.m_forceTumbleFall)
            {
               this.m_hitLagLandDelay.finish();
            }
            if(_loc10_ < Character.HEAVY_KNOCKBACK_THRESHOLD || this.m_hitLag < Character.HEAVY_KNOCKBACK_HITLAG_THRESHOLD)
            {
               if(!param1.DisableHurtSound)
               {
                  if(!inState(CState.CAUGHT) && Utils.random() > 0.6)
                  {
                     this.playCharacterSound("hurt");
                  }
               }
               if(!inState(CState.FROZEN) && !inState(CState.CAUGHT) && !inState(CState.STAMINA_KO))
               {
                  this.setState(CState.INJURED);
               }
               if(param1.Power >= 1000)
               {
                  CAM.shake(6);
               }
            }
            else
            {
               if(!param1.DisableHurtSound)
               {
                  if(!inState(CState.CAUGHT) && !inState(CState.FLYING) && _loc10_ > 24)
                  {
                     this.playCharacterSound("hurtBad");
                  }
                  else
                  {
                     this.playCharacterSound("hurt");
                  }
               }
               if(!inState(CState.FLYING))
               {
                  this.m_ricochetTimer.reset();
                  this.m_ricochetCount.reset();
                  this.m_ricochetX.finish();
                  this.m_ricochetY.finish();
               }
               if(!inState(CState.FROZEN) && !inState(CState.STAMINA_KO) && !_loc4_)
               {
                  this.setState(CState.FLYING);
               }
               if(m_damage >= 100 && inState(CState.FLYING))
               {
                  this.m_crowdAwe = true;
               }
               if(_loc10_ > 35 && !inState(CState.CAUGHT))
               {
                  STAGEDATA.lightFlash(false);
               }
               CAM.shake(12);
            }
            if(Boolean(this.m_item) && (this.m_itemDamageCounter <= 0 || _loc10_ >= Character.HEAVY_KNOCKBACK_THRESHOLD && inState(CState.FLYING) && Utils.random() < 0.25))
            {
               this.dropItem(true);
            }
            if(param1.CamShake > 0)
            {
               CAM.shake(param1.CamShake);
            }
            if(Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.DRAMATIC)) && _loc10_ > Character.HEAVY_KNOCKBACK_THRESHOLD / 4)
            {
               _loc33_ = Number(Utils.calculateHitStun(param1.HitStun,Utils.calculateChargeDamage(param1),param1.Shock,_loc6_ == CState.CROUCH));
               _loc34_ = Number(Utils.calculateSelfHitStun(param1.SelfHitStun,Utils.calculateChargeDamage(param1)));
               param1.HitStun = _loc33_ + 2 * _loc33_;
               param1.SelfHitStun = _loc34_ + 2 * _loc34_;
               if(param1.Owner is Character)
               {
                  STAGEDATA.CamRef.addZoomFocus(param1.Owner.MC,param1.SelfHitStun);
               }
               STAGEDATA.CamRef.forceTarget();
               startActionShot(param1.HitStun);
               this.m_lastHitStun = m_actionTimer;
            }
            _loc28_ = Number(Utils.calculateReversedAngle(Utils.calculateAttackDirection(param1,this),param1,this));
            if(m_collision.ground)
            {
               if(_loc28_ > 180 && _loc28_ < 360)
               {
                  if(!(param1.ForceTumbleFall && !param1.MeteorBounce))
                  {
                     if(_loc28_ >= 260 && _loc28_ <= 280)
                     {
                        this.m_hitLag = Math.round(this.m_hitLag * 1.2);
                        if(inState(CState.FLYING) && !param1.IsThrow && Boolean(param1.MeteorSFX))
                        {
                           STAGEDATA.playSpecificSound(param1.MeteorSFX);
                        }
                     }
                     _loc28_ = 360 - _loc28_;
                  }
                  this.attachGroundBounceEffect();
               }
            }
            _loc28_ = Number(Utils.forceBase360(_loc28_));
            if((inState(CState.FLYING) || inState(CState.INJURED)) && param1.HitStun == 0)
            {
               _loc28_ = Number(this.calculateDI(_loc28_));
            }
            this.m_canDI = param1.CanDI;
            if(_loc31_ && !inState(CState.STAMINA_KO) && inState(CState.INJURED) && _loc8_ < 7 && param1.Pitfall <= 0 && param1.Sleep <= 0 && param1.Stun <= 0 && param1.Dizzy <= 0 && this.m_jabResets < 3)
            {
               this.initiateCrash();
               this.m_forcedCrash = true;
               ++this.m_jabResets;
               this.m_jabResetTimer.reset();
               this.m_crashTimer.reset();
               this.m_getUpTimer.reset();
               this.stancePlayFrame(1);
               _loc35_ = Number(Utils.calculateXSpeed(_loc10_,_loc28_));
               _loc36_ = -Utils.calculateYSpeed(_loc10_,_loc28_);
               _loc35_ /= 2;
               _loc36_ = 0;
               _loc28_ = Number(Utils.getAngleBetween(new Point(0,0),new Point(_loc35_,_loc36_)));
               _loc10_ = Number(Utils.calculateSpeed(_loc35_,_loc36_));
            }
            if(param1.Direction >= 250 && param1.Direction <= 290)
            {
               if(m_collision.ground)
               {
                  this.m_hitLagCanCancelWithJump = false;
                  this.m_hitLagCanCancelWithUpB = false;
                  _loc10_ *= 0.8;
               }
               else
               {
                  this.m_hitLagCanCancelWithJump = true;
                  this.m_hitLagCanCancelWithUpB = true;
                  this.m_hitLagCancelTimer.reset();
               }
            }
            else
            {
               this.m_hitLagCanCancelWithJump = false;
               this.m_hitLagCanCancelWithUpB = false;
            }
            if(!m_collision.ground && inState(CState.FLYING) && _loc28_ >= 200 && _loc28_ <= 340 && !param1.IsThrow && Boolean(param1.MeteorSFX))
            {
               STAGEDATA.playSpecificSound(param1.MeteorSFX);
               if(Boolean(this.m_human) && this.ID > 0)
               {
                  Gamepad.rumbleOnMeteor(this.ID);
               }
            }
            this.killAllSpeeds();
            if(param1.Dizzy > 0 && (_loc29_ || !m_collision.ground) && !this.m_characterStats.StatusEffectImmunity)
            {
               _loc10_ = 0;
            }
            applyKnockbackSpeed(_loc10_,_loc28_);
            if(Boolean(MenuController.debugConsole) && Boolean(MenuController.debugConsole.AttackStateCapture))
            {
               MenuController.debugConsole.writeTextData(param1.AttackBoxName + ": { weight1: " + this.m_characterStats.Weight1 * _loc20_ + ", angle: " + _loc28_ + ", attackDamage: " + param1.Damage + ", receiverDamage: " + _loc9_ + ", calculatedDamage: " + _loc8_ + ", kbc: " + param1.KBConstant + ", power: " + param1.Power + ", weightKB: " + param1.WeightKB + ", knockback: " + _loc11_ + ", velocity: " + _loc10_ + ", hitlag: " + this.m_hitLag + ", chargetime: " + param1.ChargeTime + ", chargetime_max: " + param1.ChargeTimeMax + " }");
            }
            if(!inState(CState.CAUGHT) && !_loc31_)
            {
               if(Utils.fastAbs(m_xKnockback) > 0.01)
               {
                  if(!m_facingForward && _loc28_ > 90 && _loc28_ < 270)
                  {
                     m_faceRight();
                  }
                  else if(m_facingForward && (_loc28_ >= 0 && _loc28_ < 90 || _loc28_ > 270 && _loc28_ <= 360))
                  {
                     m_faceLeft();
                  }
               }
               else if(param1.IsForward)
               {
                  m_faceLeft();
               }
               else
               {
                  m_faceRight();
               }
            }
            if(!_loc31_ && !inState(CState.STAMINA_KO) && (m_collision.ground && m_yKnockback >= 0) && !(param1.ForceTumbleFall && !param1.MeteorBounce))
            {
               if(m_actionShot && !m_paralysis && inState(CState.FLYING) && !_loc4_)
               {
                  this.m_forcedCrash = false;
                  this.setState(CState.CRASH_LAND);
                  this.stancePlayFrame("dead");
                  this.m_canWallTech = false;
               }
            }
            if(param1.Pitfall > 0 && !inState(CState.STUNNED) && !inState(CState.FROZEN) && !inState(CState.DIZZY) && !_loc30_ && !inState(CState.SLEEP) && !inState(CState.EGG) && !inState(CState.STAMINA_KO) && m_collision.ground && !_loc4_ && !this.m_characterStats.StatusEffectImmunity)
            {
               this.m_pitfallTimer = param1.Pitfall + 0.6 * m_damage;
               this.resetRotation();
               Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
               this.killAllSpeeds();
               if(inState(CState.CAUGHT) && !inState(CState.STAMINA_KO) && this.m_grabberID >= 0)
               {
                  STAGEDATA.getCharacterByUID(this.m_grabberID).setState(CState.IDLE);
               }
               this.setState(CState.PITFALL);
               this.stopActionShot();
               toggleEffect(this.m_pitfallEffect,true);
               this.m_pitfallEffect.x = m_sprite.x;
               this.m_pitfallEffect.y = m_sprite.y;
            }
            if(!_loc31_ && m_yKnockback < 0 && m_collision.ground && !inState(CState.PITFALL) && !inState(CState.CAUGHT))
            {
               this.unnattachFromGround();
            }
            this.m_canBounce = param1.MeteorBounce && (_loc28_ >= 200 && _loc28_ <= 340);
            this.m_hasBounced = false;
            if(param1.EffectSound != null)
            {
               this.playGlobalSound(param1.EffectSound);
            }
            if(param1.Stun > 0 && !inState(CState.STUNNED) && !inState(CState.FROZEN) && !inState(CState.DIZZY) && !inState(CState.PITFALL) && !inState(CState.SLEEP) && !inState(CState.EGG) && !inState(CState.STAMINA_KO) && !inState(CState.BARREL) && !_loc4_ && !this.m_characterStats.StatusEffectImmunity)
            {
               this.setState(CState.STUNNED);
               this.m_stunCancelTimer.reset();
               this.m_stunTimer = param1.Stun;
               this.resetRotation();
               Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
               this.killAllSpeeds(false,true);
            }
            if(param1.Dizzy > 0 && !inState(CState.STUNNED) && !inState(CState.FROZEN) && !inState(CState.DIZZY) && !inState(CState.PITFALL) && !inState(CState.SLEEP) && !inState(CState.EGG) && !(_loc29_ && !m_collision.ground) && !inState(CState.STAMINA_KO) && !inState(CState.BARREL) && !_loc4_ && !this.m_characterStats.StatusEffectImmunity)
            {
               this.setState(CState.DIZZY);
               this.m_stunCancelTimer.reset();
               this.m_dizzyTimer = param1.Dizzy + 0.6 * m_damage;
               this.resetRotation();
               Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
               this.killAllSpeeds(false,true);
               this.m_dizzyShield = Boolean(param1.Owner) && param1.Owner is Character && Boolean(Character(param1.Owner).UsingFinalSmash);
            }
            if(param1.Freeze > 0 && !inState(CState.STUNNED) && !inState(CState.FROZEN) && !inState(CState.DIZZY) && !inState(CState.PITFALL) && !inState(CState.SLEEP) && !inState(CState.EGG) && !_loc4_ && !this.m_characterStats.StatusEffectImmunity)
            {
               this.freeze(true,param1.Freeze);
            }
            if(param1.Sleep > 0 && !inState(CState.STUNNED) && !inState(CState.FROZEN) && !inState(CState.DIZZY) && !inState(CState.PITFALL) && !inState(CState.SLEEP) && !inState(CState.EGG) && !inState(CState.STAMINA_KO) && !inState(CState.BARREL) && !_loc4_ && !this.m_characterStats.StatusEffectImmunity)
            {
               this.setState(CState.SLEEP);
               this.m_stunCancelTimer.reset();
               this.m_sleepingTimer = param1.Sleep + 2 * m_damage;
               this.resetRotation();
               Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
               this.killAllSpeeds(false,true);
            }
            if(param1.Egg > 0 && !inState(CState.STUNNED) && !inState(CState.FROZEN) && !inState(CState.DIZZY) && !inState(CState.PITFALL) && !inState(CState.SLEEP) && !inState(CState.EGG) && !inState(CState.STAMINA_KO) && !this.m_characterStats.StatusEffectImmunity)
            {
               this.egg(true);
            }
            if(param1.Poison > 0 && !this.m_characterStats.StatusEffectImmunity)
            {
               this.setPoison(param1.Poison,param1.PoisonInterval,param1.PoisonLength);
            }
            if(inState(CState.FROZEN))
            {
               if(Utils.fastAbs(m_xKnockback) > 5)
               {
                  m_xKnockback = m_xKnockback > 0 ? 5 : -5;
               }
               if(m_yKnockback > 10)
               {
                  m_yKnockback = 10;
               }
            }
            if(param1.EffectID != null && param1.EffectID != null && Boolean(STAGEDATA.getQualitySettings().hit_effects))
            {
               _loc37_ = attachHurtEffect(param1.EffectID,param2,{
                  "scaleX":(0.25 + 0.75 * Math.min(param1.Damage / 16,1)) * _loc19_,
                  "scaleY":(0.25 + 0.75 * Math.min(param1.Damage / 16,1)) * _loc19_
               });
               if(_loc37_)
               {
                  _loc37_.rotation = param1.IsForward ? 180 - _loc28_ : -_loc28_;
               }
            }
            if(this.m_characterStats.LinkageID == "kirby" && this.m_currentPower != null && this.m_kirbyDamageCounter <= 0)
            {
               this.playGlobalSound("kirby_losepower");
               this.resetChargedAttacks();
               m_attackData.resetCharges();
               this.removeChargeGlow();
               this.m_currentPower = null;
               _loc38_ = STAGEDATA.attachEffectOverlay("kirby_powerstar");
               if(HasHatBox)
               {
                  m_sprite.stance.hatBox.visible = false;
               }
               _loc38_.width *= m_sizeRatio;
               _loc38_.height *= m_sizeRatio;
               if(!m_facingForward)
               {
                  _loc38_.scaleX *= -1;
               }
               _loc38_.x = OverlayX;
               _loc38_.y = OverlayY - 10 * m_sizeRatio;
            }
            if(inState(CState.INJURED) || isHitStunOrParalysis() && !_loc31_)
            {
               if(param1.Shock)
               {
                  this.resetRotation();
                  Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
                  if(HasStance)
                  {
                     this.playHurtFrame("shock");
                  }
                  else
                  {
                     this.playHurtFrame();
                  }
                  this.m_shockEffectTimer.reset();
               }
               else if(param1.Burn)
               {
                  this.resetRotation();
                  Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
                  this.playHurtFrame();
                  this.m_burnSmokeTimer.reset();
                  if(this.m_burnSmoke.parent == null)
                  {
                     toggleEffect(this.m_burnSmoke,true);
                     this.m_burnSmoke.x = m_sprite.x;
                     this.m_burnSmoke.y = m_sprite.y;
                  }
               }
               else if(param1.Darkness)
               {
                  this.resetRotation();
                  Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
                  this.playHurtFrame();
                  this.m_darknessSmokeTimer.reset();
                  if(this.m_darknessSmoke.parent == null)
                  {
                     toggleEffect(this.m_darknessSmoke,true);
                     this.m_darknessSmoke.x = m_sprite.x;
                     this.m_darknessSmoke.y = m_sprite.y;
                  }
               }
               else if(param1.Aura)
               {
                  this.resetRotation();
                  Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
                  this.playHurtFrame();
                  this.m_auraSmokeTimer.reset();
                  if(this.m_auraSmoke.parent == null)
                  {
                     toggleEffect(this.m_auraSmoke,true);
                     this.m_auraSmoke.x = m_sprite.x;
                     this.m_auraSmoke.y = m_sprite.y;
                  }
               }
               else
               {
                  this.resetRotation();
                  Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
                  if(!inState(CState.CRASH_LAND) && !inState(CState.CRASH_GETUP))
                  {
                     this.playHurtFrame();
                  }
               }
               this.updateItemHolding();
            }
            if(_loc15_)
            {
               param1.HasEffect = _loc16_;
               param1.Power = _loc17_;
               param1.KBConstant = _loc18_;
            }
            if(m_yKnockback < 0)
            {
               this.m_hasArced = false;
            }
            else
            {
               this.m_hasArced = true;
            }
            if(Boolean(this.m_forceTumbleFall) && inState(CState.INJURED) && !inState(CState.STAMINA_KO) && !_loc4_)
            {
               this.setState(CState.FLYING);
            }
            if(m_lastHitID > 0 && Utils.fastAbs(_loc10_) > STAGEDATA.getPlayerByID(m_lastHitID).getMatchResults().FastestPitch)
            {
               STAGEDATA.getPlayerByID(m_lastHitID).getMatchResults().FastestPitch = Utils.fastAbs(_loc10_);
            }
            if(Utils.fastAbs(_loc10_) > this.m_matchResults.TopSpeed && !STAGEDATA.GameEnded)
            {
               this.m_matchResults.TopSpeed = Utils.fastAbs(_loc10_);
            }
            this.m_dustTimer.reset();
            this.m_dustTimer.MaxTime = this.calculateHitLag(_loc11_,-0.9);
            this.m_injureFlashTimer.reset();
            setTint(0.8,0.8,0.8,1,51,51,51,0);
            _loc7_ = false;
            if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
            {
               _loc39_ = Number(Utils.calculateXSpeed(_loc10_,_loc28_));
               _loc40_ = -Utils.calculateYSpeed(_loc10_,_loc28_);
               m_xKnockback += _loc39_;
               m_yKnockback = _loc40_;
               this.m_hitLag = _loc32_;
            }
            else if(_loc14_ !== 0 && param1.StackKnockback && (m_knockbackStackingTimer.IsComplete || m_knockbackStacked || param1.IgnoreKnockbackStackingTimer))
            {
               _loc7_ = true;
               stackKnockback(_loc10_,_loc28_,_loc12_,_loc13_);
               if(_loc10_ >= Character.HEAVY_KNOCKBACK_THRESHOLD || this.m_hitLag >= Character.HEAVY_KNOCKBACK_HITLAG_THRESHOLD)
               {
                  if(!inState(CState.FROZEN) && !inState(CState.STAMINA_KO) && !_loc4_)
                  {
                     this.setState(CState.FLYING);
                  }
               }
            }
            else
            {
               this.m_hitLag = _loc32_;
            }
            m_knockbackStacked = true;
            resetKnockbackDecay();
            m_knockbackStackingTimer.reset();
            this.m_ricochetX.finish();
            this.m_ricochetY.finish();
            if(Boolean(MenuController.debugConsole) && Boolean(MenuController.debugConsole.KnockbackCapture))
            {
               MenuController.debugConsole.writeTextData(param1.AttackBoxName + ": { xKnockbackVelocity: " + m_xKnockback + ", yKnockbackVelocity: " + m_yKnockback + ", angle: " + Utils.getAngleBetween(new Point(),new Point(m_xKnockback,m_yKnockback)) + ", stacked: " + _loc7_ + " }");
            }
            if(m_lastHitID > 0 && !(param1.Owner is Enemy))
            {
               if(STAGEDATA.getPlayerByID(m_lastHitID).getDamage() >= 100 && inState(CState.FLYING) && Utils.random() > 0.5 && netSpeed() > 35)
               {
                  STAGEDATA.startCrowdChant(m_lastHitID);
               }
            }
            if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.INVISIBLE))
            {
               this.m_invisiblePulseCount = 8;
               this.m_invisiblePulseToggle = true;
               this.m_invisiblePulseTimer.reset();
               this.m_invisiblePulseTimer.MaxTime = Utils.randomInteger(1,8);
            }
            if(netSpeed(true) > CROWD_AWE_KNOCKBACK_THRESHOLD && inState(CState.FLYING) && !_loc21_)
            {
               STAGEDATA.playSpecificVoice(["crowd_cheer_s","crowd_cheer_m","crowd_cheer_l"][Utils.randomInteger(0,2)]);
            }
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.CHAR_HURT,{
               "caller":this.APIInstance.instance,
               "opponent":(param1.Owner ? param1.Owner.APIInstance.instance : null),
               "attackBoxData":param1.exportAttackDamageData(),
               "collisionRect":(param2 ? param2.BoundingBox : null)
            }));
            if(param1.Burn && param1.Freeze <= 0 && inState(CState.FROZEN))
            {
               this.freeze(false);
               this.attachEffect("freeze_break");
            }
            return true;
         }
         if(!param1.HasEffect && !inState(CState.LEDGE_HANG) && !inState(CState.LEDGE_CLIMB) && !inState(CState.LEDGE_ROLL) && !(inState(CState.ATTACKING) && m_attack.Frame == "ledge_attack") && !(isIntangible() && param1.Damage > 0) && !(this.m_characterStats.WindArmor > 0 && _loc24_ <= this.m_characterStats.WindArmor))
         {
            if(m_hurtInterrupt != null && Boolean(m_hurtInterrupt({
               "target":(Boolean(param1.Owner) && Boolean(param1.Owner.APIInstance) ? param1.Owner.APIInstance.instance : null),
               "attackBoxData":param1.exportAttackDamageData(),
               "collisionRect":(param2 ? param2.BoundingBox : null)
            })))
            {
               if(_loc15_)
               {
                  param1.HasEffect = _loc16_;
                  param1.Power = _loc17_;
                  param1.KBConstant = _loc18_;
               }
               return false;
            }
            startActionShot(-1,param1.Paralysis);
            this.m_windBoxHit = true;
            _loc8_ = param1.Damage <= 0 || this.isInvincible() || isIntangible() ? 0 : Number(Utils.calculateChargeDamage(param1));
            _loc8_ *= param1.StaleMultiplier;
            if(inState(CState.FROZEN))
            {
               _loc8_ /= 2;
            }
            if(param1.Damage > 0 && _loc8_ <= 0)
            {
            }
            if(_loc8_ != 0)
            {
               throbDamageCounter();
            }
            if(!STAGEDATA.GameEnded)
            {
               this.m_matchResults.DamageTaken += _loc8_;
            }
            if(this.m_recoveryAmount > 0)
            {
               this.m_recoveryAmount -= _loc8_;
               if(this.m_recoveryAmount <= 0)
               {
                  _loc8_ = -this.m_recoveryAmount;
                  this.m_recoveryAmount = 0;
               }
               else
               {
                  _loc8_ = 0;
               }
            }
            if(this.m_characterStats.CanReceiveDamage)
            {
               this.dealDamage(_loc8_);
            }
            if(!m_attack.DisableLastHitUpdate)
            {
               m_lastHitID = param1.PlayerID;
               m_lastHitObject = param1;
            }
            if(m_lastHitID > 0)
            {
               STAGEDATA.getPlayerByID(m_lastHitID).getMatchResults().DamageGiven = STAGEDATA.getPlayerByID(m_lastHitID).getMatchResults().DamageGiven + _loc8_;
               STAGEDATA.getPlayerByID(m_lastHitID).resetDroughtTimer();
               if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.VAMPIRE))
               {
                  STAGEDATA.getPlayerByID(m_lastHitID).recover(_loc8_ / 2);
               }
               else if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.VENGEANCE))
               {
                  STAGEDATA.getPlayerByID(m_lastHitID).dealDamage(_loc8_ / 2);
                  STAGEDATA.getPlayerByID(m_lastHitID).throbDamageCounter();
               }
            }
            if(param1.AttackID != -1)
            {
               stackAttackID(param1.AttackID);
            }
            if(param1.EffectSound != null)
            {
               this.playGlobalSound(param1.EffectSound);
            }
            _loc41_ = false;
            if(!inState(CState.LEDGE_HANG) && !inState(CState.LEDGE_ROLL) && !inState(CState.LEDGE_HANG) && param1.Power != 0 && !inState(CState.PITFALL) && !(inState(CState.ATTACKING) && m_attack.IsThrow) && !inState(CState.CAUGHT))
            {
               _loc41_ = true;
               _loc28_ = Number(Utils.calculateReversedAngle(Utils.calculateAttackDirection(param1,this),param1,this));
               if(m_collision.ground)
               {
                  if(_loc28_ > 180 && _loc28_ < 360)
                  {
                     _loc28_ = 360 - _loc28_;
                  }
               }
               _loc28_ = Number(Utils.forceBase360(_loc28_));
               _loc11_ = Number(Utils.calculateKnockback(param1.KBConstant,param1.Power,0,0,0,this.m_characterStats.Weight1 * _loc20_,false,1,1));
               if(inState(CState.FROZEN))
               {
                  _loc11_ /= 4;
               }
               _loc10_ = Number(Utils.calculateVelocity(_loc11_));
               m_xKnockback = Utils.calculateXSpeed(_loc10_,_loc28_);
               m_yKnockback = -Utils.calculateYSpeed(_loc10_,_loc28_);
               if(Boolean(MenuController.debugConsole) && Boolean(MenuController.debugConsole.AttackStateCapture))
               {
                  MenuController.debugConsole.writeTextData(param1.AttackBoxName + " (wind): { weight1: " + this.m_characterStats.Weight1 * _loc20_ + ", angle: " + _loc28_ + ", attackDamage: " + param1.Damage + ", receiverDamage: " + _loc9_ + ", calculatedDamage: " + _loc8_ + ", kbc: " + param1.KBConstant + ", power: " + param1.Power + ", weightKB: " + param1.WeightKB + ", knockback: " + _loc11_ + ", velocity: " + _loc10_ + ", hitlag: " + this.m_hitLag + ", chargetime: " + param1.ChargeTime + ", chargetime_max: " + param1.ChargeTimeMax + " }");
               }
               if(m_collision.ground && m_yKnockback < -Utils.calculateVelocity(20))
               {
                  this.unnattachFromGround();
               }
               if(this.m_sizeStatus != 0)
               {
                  _loc10_ *= this.m_sizeStatus == 1 ? 0.75 : 1.5;
               }
               this.m_forceTumbleFall = param1.ForceTumbleFall;
            }
            if(!this.isInvincible() && !isIntangible() && param1.Stun > 0 && !inState(CState.STUNNED) && !inState(CState.FROZEN) && !inState(CState.DIZZY) && !inState(CState.PITFALL) && !inState(CState.SLEEP) && !inState(CState.EGG) && !inState(CState.STAMINA_KO) && !inState(CState.BARREL) && !_loc4_ && !this.m_characterStats.StatusEffectImmunity)
            {
               if(_loc6_ === CState.CAUGHT && Boolean(this.m_hitForceVisible))
               {
                  this.setVisibility(true);
               }
               if(this.m_grabbed.length > 0)
               {
                  this.grabReleaseOpponent();
               }
               this.setState(CState.STUNNED);
               this.m_stunCancelTimer.reset();
               this.m_stunTimer = param1.Stun;
               this.resetRotation();
               this.killAllSpeeds(false,true);
               Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
            }
            if(!this.isInvincible() && !isIntangible() && param1.Dizzy > 0 && !inState(CState.STUNNED) && !inState(CState.FROZEN) && !inState(CState.DIZZY) && !inState(CState.PITFALL) && !inState(CState.SLEEP) && !inState(CState.EGG) && !inState(CState.STAMINA_KO) && !inState(CState.BARREL) && !_loc4_ && !this.m_characterStats.StatusEffectImmunity)
            {
               if(_loc6_ === CState.CAUGHT && Boolean(this.m_hitForceVisible))
               {
                  this.setVisibility(true);
               }
               if(this.m_grabbed.length > 0)
               {
                  this.grabReleaseOpponent();
               }
               this.setState(CState.DIZZY);
               this.m_stunCancelTimer.reset();
               this.m_dizzyTimer = param1.Dizzy + 0.6 * m_damage;
               this.resetRotation();
               Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
               this.killAllSpeeds(false,true);
               this.m_dizzyShield = Boolean(param1.Owner) && param1.Owner is Character && Boolean(Character(param1.Owner).UsingFinalSmash);
            }
            if(!this.isInvincible() && !isIntangible() && param1.Freeze > 0 && !inState(CState.STUNNED) && !inState(CState.FROZEN) && !inState(CState.DIZZY) && !inState(CState.PITFALL) && !inState(CState.SLEEP) && !inState(CState.EGG) && !inState(CState.STAMINA_KO) && !_loc4_ && !this.m_characterStats.StatusEffectImmunity)
            {
               if(_loc6_ === CState.CAUGHT && Boolean(this.m_hitForceVisible))
               {
                  this.setVisibility(true);
               }
               this.freeze(true,param1.Freeze);
            }
            if(param1.Sleep > 0 && !inState(CState.STUNNED) && !inState(CState.FROZEN) && !inState(CState.DIZZY) && !inState(CState.PITFALL) && !inState(CState.SLEEP) && !inState(CState.EGG) && !inState(CState.STAMINA_KO) && !inState(CState.BARREL) && !_loc4_ && !this.m_characterStats.StatusEffectImmunity)
            {
               if(_loc6_ === CState.CAUGHT && Boolean(this.m_hitForceVisible))
               {
                  this.setVisibility(true);
               }
               if(this.m_grabbed.length > 0)
               {
                  this.grabReleaseOpponent();
               }
               this.setState(CState.SLEEP);
               this.m_stunCancelTimer.reset();
               this.m_sleepingTimer = param1.Sleep + 2 * m_damage;
               this.resetRotation();
               this.killAllSpeeds(false,true);
               Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
            }
            if(!this.isInvincible() && !isIntangible() && param1.Egg > 0 && !inState(CState.STUNNED) && !inState(CState.FROZEN) && !inState(CState.DIZZY) && !inState(CState.PITFALL) && !inState(CState.SLEEP) && !inState(CState.EGG) && !inState(CState.STAMINA_KO) && !_loc4_ && !this.m_characterStats.StatusEffectImmunity)
            {
               if(_loc6_ === CState.CAUGHT && Boolean(this.m_hitForceVisible))
               {
                  this.setVisibility(true);
               }
               this.egg(true);
            }
            if(!this.isInvincible() && !isIntangible() && param1.Pitfall > 0 && !inState(CState.STUNNED) && !inState(CState.FROZEN) && !inState(CState.DIZZY) && !inState(CState.PITFALL) && !inState(CState.SLEEP) && !inState(CState.EGG) && m_collision.ground && !inState(CState.STAMINA_KO) && !_loc4_ && !this.m_characterStats.StatusEffectImmunity)
            {
               if(this.m_grabbed.length > 0)
               {
                  this.grabReleaseOpponent();
               }
               if(_loc6_ === CState.CAUGHT && Boolean(this.m_hitForceVisible))
               {
                  this.setVisibility(true);
               }
               if(inState(CState.CAUGHT) && this.m_grabberID >= 0)
               {
                  STAGEDATA.getCharacterByUID(this.m_grabberID).setState(CState.IDLE);
               }
               this.setState(CState.PITFALL);
               this.m_pitfallTimer = param1.Pitfall + 0.6 * m_damage;
               this.resetRotation();
               Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
               this.killAllSpeeds();
               this.stopActionShot();
               toggleEffect(this.m_pitfallEffect,true);
               this.m_pitfallEffect.x = m_sprite.x;
               this.m_pitfallEffect.y = m_sprite.y;
            }
            if(!this.isInvincible() && !isIntangible() && param1.Poison > 0 && !this.m_characterStats.StatusEffectImmunity)
            {
               this.setPoison(param1.Poison,param1.PoisonInterval,param1.PoisonLength);
            }
            if(param1.EffectID != null && param1.EffectID != null && Boolean(STAGEDATA.getQualitySettings().hit_effects))
            {
               _loc42_ = attachHurtEffect(this.isInvincible() ? "effect_cancel" : param1.EffectID,param2,{
                  "scaleX":(0.25 + 0.75 * Math.min(param1.Damage / 16,1)) * _loc19_,
                  "scaleY":(0.25 + 0.75 * Math.min(param1.Damage / 16,1)) * _loc19_
               });
               if(_loc42_)
               {
                  _loc42_.rotation = param1.IsForward ? 180 - _loc28_ : -_loc28_;
               }
            }
            if(_loc15_)
            {
               param1.HasEffect = _loc16_;
               param1.Power = _loc17_;
               param1.KBConstant = _loc18_;
            }
            if(inState(CState.CAUGHT) && HasStance && param1.PlayerID > 0 && this.m_grabberID == STAGEDATA.getPlayerByID(param1.PlayerID).UID)
            {
               if(!(HasStance && Stance.currentLabel === "downed"))
               {
                  this.playHurtFrame();
               }
            }
            _loc7_ = false;
            if(!(_loc12_ == 0 && _loc13_ == 0) && param1.StackKnockback && _loc41_)
            {
               _loc7_ = true;
               stackKnockback(_loc10_,_loc28_,_loc12_,_loc13_);
            }
            resetKnockbackDecay();
            if(Boolean(MenuController.debugConsole) && Boolean(MenuController.debugConsole.KnockbackCapture))
            {
               MenuController.debugConsole.writeTextData(param1.AttackBoxName + ": { xKnockbackVelocity: " + m_xKnockback + ", yKnockbackVelocity: " + m_yKnockback + ", angle: " + Utils.getAngleBetween(new Point(),new Point(m_xKnockback,m_yKnockback)) + ", stacked: " + _loc7_ + " }");
            }
            if(inState(CState.CAUGHT) && param1.Owner is Character && param1.Owner.inState(CState.GRABBING) && Character(param1.Owner).Grabbed.indexOf(this) >= 0)
            {
               this.m_injureFlashTimer.reset();
               setTint(0.8,0.8,0.8,1,51,51,51,0);
               throbDamageCounter();
            }
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.CHAR_WIND,{
               "caller":this.APIInstance.instance,
               "opponent":(param1.Owner ? param1.Owner.APIInstance.instance : null),
               "attackBoxData":param1.exportAttackDamageData(),
               "collisionRect":(param2 ? param2.BoundingBox : null)
            }));
            if(param1.Burn && param1.Freeze <= 0 && inState(CState.FROZEN))
            {
               this.freeze(false);
               this.attachEffect("freeze_break");
            }
            return true;
         }
         if(_loc15_)
         {
            param1.HasEffect = _loc16_;
            param1.Power = _loc17_;
            param1.KBConstant = _loc18_;
         }
         return false;
      }
      
      public function takeShieldDamage(param1:AttackDamage, param2:HitBoxSprite = null) : Boolean
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Boolean = false;
         var _loc9_:Number = NaN;
         if(!param1 || this.isInvincible() || !inState(CState.SHIELDING) || Boolean(this.m_standby) || Boolean(this.m_usingSpecialAttack) || !this.m_characterStats.CanReceiveHits || Boolean(this.m_usingSpecialAttack) && this.m_characterStats.SpecialType == 3 && m_attack.ExecTime > 1 && !(param1.Owner as Character && Character(param1.Owner).Caught()) || !this.validateBypass(param1) || !validateOnlyAffects(param1) || attackIDArrayContains(param1.AttackID) || !param1.HurtSelfShield && param1.PlayerID == m_player_id && m_player_id > 0 || !param1.HurtSelfShield && m_team_id == param1.TeamID && m_team_id > 0 && !STAGEDATA.TeamDamage)
         {
            return false;
         }
         _loc3_ = this.m_isMetal ? 2.8 : 1;
         _loc4_ = param1.Damage <= 0 ? 0 : Number(Utils.calculateChargeDamage(param1));
         var _loc10_:Number = this.m_characterStats.Stamina > 0 ? Number(Utils.calculateVelocity(Utils.calculateKnockback(param1.KBConstant,param1.Power,param1.WeightKB,0,0,this.m_characterStats.Weight1 * _loc3_,false,this.m_characterStats.DamageRatio,param1.AttackRatio))) : Number(Utils.calculateVelocity(Utils.calculateKnockback(param1.KBConstant,param1.Power,param1.WeightKB,_loc4_,m_damage,this.m_characterStats.Weight1 * _loc3_,false,this.m_characterStats.DamageRatio,param1.AttackRatio)));
         _loc5_ = 0;
         _loc6_ = 0;
         if(!isIntangible())
         {
            if(m_hurtInterrupt != null && Boolean(m_hurtInterrupt({
               "target":(Boolean(param1.Owner) && Boolean(param1.Owner.APIInstance) ? param1.Owner.APIInstance.instance : null),
               "attackBoxData":param1.exportAttackDamageData(),
               "collisionRect":(param2 ? param2.BoundingBox : null)
            })))
            {
               return false;
            }
            ++this.m_hitsReceivedCounter;
            if(!m_attack.DisableLastHitUpdate)
            {
               m_lastHitID = param1.PlayerID;
               m_lastHitObject = param1;
            }
            if(param1.AttackID != -1)
            {
               stackAttackID(param1.AttackID);
            }
            _loc5_ = Number(Utils.calculateChargeDamage(param1,param1.ShieldDamage));
            _loc5_ *= param1.StaleMultiplier;
            if(_loc5_ <= 0 && param1.Damage > 0)
            {
               _loc5_ = 1;
            }
            if(param1.HasEffect || Boolean(!param1.HasEffect) && Boolean(param1.Owner as Projectile))
            {
               if(this.m_shieldStartTimer < 1)
               {
                  this.playGlobalSound("shieldhit_strong");
                  STAGEDATA.lightFlash(false);
               }
               else
               {
                  this.playGlobalSound(param1.ShieldSound);
               }
               if(Boolean(this.m_human) && this.ID > 0)
               {
                  Gamepad.rumbleOnShieldHit(this.ID);
               }
            }
            if(!this.PerfectShield)
            {
               this.m_shieldPower -= _loc5_ * 0.7 * 2;
               _loc6_ = Number(Utils.calculateAttackDirection(param1,this));
               _loc7_ = Math.min(20,this.m_characterStats.Stamina > 0 ? Number(Utils.calculateVelocity(Utils.calculateKnockback(param1.KBConstant,param1.Power,param1.WeightKB,0,0,this.m_characterStats.Weight1 * _loc3_,false,this.m_characterStats.DamageRatio,param1.AttackRatio))) : Number(Utils.calculateVelocity(Utils.calculateKnockback(param1.KBConstant,param1.Power,param1.WeightKB,_loc4_,m_damage,this.m_characterStats.Weight1 * _loc3_,false,this.m_characterStats.DamageRatio,param1.AttackRatio))));
               m_xKnockback = Utils.calculateXSpeed(_loc7_ * 0.35,_loc6_);
               m_yKnockback = 0;
               if(param1.ReversableAngle && param1.Direction >= 0)
               {
                  _loc8_ = param1.Direction > 90 && param1.Direction < 270;
                  if(m_sprite.x < param1.XLoc || m_sprite.x > param1.XLoc)
                  {
                     m_xKnockback = m_sprite.x > param1.XLoc ? Number(Utils.fastAbs(m_xKnockback)) : -Utils.fastAbs(m_xKnockback);
                     if(_loc8_)
                     {
                        m_xKnockback *= -1;
                     }
                  }
                  _loc6_ = Number(Utils.getAngleBetween(new Point(),new Point(m_xKnockback,m_yKnockback)));
               }
               resetKnockbackDecay();
            }
            if(param1.HasEffect)
            {
               this.attachEffect(this.m_characterStats.CustomShield ? "effect_cancel" : this.m_shieldType + "_hit",{
                  "x":m_sprite.x,
                  "y":m_sprite.y - m_height / 3 * m_sizeRatio * this.m_characterStats.ShieldScale,
                  "absolute":true,
                  "scaleX":(this.PerfectShield ? 1 : 0.5 * this.m_characterStats.ShieldScale),
                  "scaleY":(this.PerfectShield ? 1 : 0.5 * this.m_characterStats.ShieldScale)
               });
            }
            if(param1.Owner as Item)
            {
               if(Item(param1.Owner) != null && !Item(param1.Owner).Dead)
               {
                  if(this.PerfectShield && Boolean(Item(param1.Owner).CanBeReversed))
                  {
                     Item(param1.Owner).reverse(m_player_id,m_team_id,!Item(param1.Owner).FacingForward);
                  }
               }
            }
            if(param1.Owner as Projectile)
            {
               if(!Projectile(param1.Owner).Dead)
               {
                  if(this.PerfectShield)
                  {
                     Projectile(param1.Owner).reverse(m_player_id,m_team_id,!Projectile(param1.Owner).FacingForward);
                  }
               }
            }
            this.m_smashDISelf = false;
            if(param1.HasEffect)
            {
               _loc9_ = Number(Utils.calculateHitStun(param1.HitStun,_loc5_,param1.Shock,false));
               if(!this.PerfectShield)
               {
                  this.m_shieldDelayTimer.reset();
                  this.m_shieldDelayTimer.MaxTime = Math.floor(Math.round((Utils.calculateChargeDamage(param1) + 4.45) / 2.235) * param1.ShieldStunMultiplier / 2);
                  this.m_lastHitStun = this.m_shieldDelayTimer.MaxTime;
                  startActionShot(_loc9_);
               }
            }
            m_eventManager.dispatchEvent(new SSF2Event(this.PerfectShield ? SSF2Event.CHAR_POWER_SHIELD_HIT : SSF2Event.CHAR_SHIELD_HIT,{
               "caller":this.APIInstance.instance,
               "opponent":param1.Owner.APIInstance.instance,
               "attackBoxData":param1.exportAttackDamageData()
            }));
            return true;
         }
         return false;
      }
      
      private function performGroundTech() : void
      {
         this.killAllSpeeds(true,false);
         m_xKnockback *= 0.5;
         m_yKnockback = 0;
         resetKnockbackDecay();
         this.m_canTech = false;
         this.m_techReady = false;
         this.m_techTimer.reset();
         this.m_techDelay.reset();
         this.m_hitLag = -1;
         this.resetRotation();
         if(this.getMetalStatus())
         {
            STAGEDATA.playSpecificSound("metal_land_m");
         }
         else
         {
            STAGEDATA.playSpecificSound("tech_sfx");
         }
         if(this.m_heldControls.RIGHT != this.m_heldControls.LEFT)
         {
            this.initTechRoll(this.m_heldControls.RIGHT);
            this.setState(CState.TECH_ROLL);
         }
         else
         {
            this.setState(CState.TECH_GROUND);
            if(Boolean(this.m_human) && this.ID > 0)
            {
               Gamepad.rumbleOnTech(this.ID);
            }
         }
         this.m_smashDISelf = true;
      }
      
      private function performWallTech(param1:Boolean) : void
      {
         this.setState(CState.IDLE);
         if(param1)
         {
            this.m_flyingUp = !this.m_flyingUp;
         }
         else
         {
            this.m_flyingRight = !this.m_flyingRight;
         }
         this.killAllSpeeds();
         this.m_canTech = false;
         this.m_techReady = false;
         this.m_techTimer.reset();
         this.m_techDelay.reset();
         if(this.getMetalStatus())
         {
            STAGEDATA.playSpecificSound("metal_land_m");
         }
         else
         {
            STAGEDATA.playSpecificSound("tech_sfx");
         }
         this.resetRotation();
         if(param1)
         {
            this.techEffect(0,-m_height);
         }
         else
         {
            this.techEffect(m_facingForward ? -m_width / 2 : m_width / 2,m_height / 2);
         }
         this.m_justTechedTimer.reset();
      }
      
      private function techEffect(param1:Number = 0, param2:Number = 0) : void
      {
         var _loc3_:MovieClip = null;
         _loc3_ = STAGEDATA.attachEffectOverlay("tech_effect");
         _loc3_.scaleX = 0.5;
         _loc3_.scaleY = 0.5;
         _loc3_.x = OverlayX + param1 * m_sizeRatio;
         _loc3_.y = OverlayY + param2 * m_sizeRatio;
      }
      
      override protected function m_groundCollisionTest() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         _loc1_ = false;
         _loc2_ = inState(CState.ATTACKING);
         _loc3_ = m_collision.ground;
         if(!isHitStunOrParalysis() && !inState(CState.LEDGE_HANG) && !inState(CState.CAUGHT) && !inState(CState.BARREL) && !inState(CState.REVIVAL) && !inState(CState.STAR_KO) && !inState(CState.SCREEN_KO) && !(Boolean(this.m_usingSpecialAttack) && (this.m_characterStats.SpecialType == 4 || this.m_characterStats.SpecialType == 5)))
         {
            if(inState(CState.CRASH_LAND))
            {
               this.groundBounceCheck();
            }
            else if(inState(CState.FLYING) && m_collision.ground && this.netYSpeed() >= 0 && !isHitStunOrParalysis())
            {
               this.groundBounceCheck();
            }
            else if(inState(CState.INJURED) && m_collision.ground && this.netYSpeed() >= 0 && Boolean(this.m_hitLagStunTimer.IsComplete) && !isHitStunOrParalysis())
            {
               this.setState(CState.IDLE);
               m_yKnockback = 0;
               this.resetRotation();
            }
            if(m_collision.ground && this.netYSpeed() >= 0)
            {
               attachToGround();
            }
            else if(!m_collision.ground)
            {
               pushOutOfGround();
            }
            _loc4_ = (m_currentPlatform = this.testGroundWithCoord(m_sprite.x,m_sprite.y + 1)) != null;
            if(_loc4_)
            {
               attachToGround();
            }
            if(!m_collision.ground && _loc4_ && this.netYSpeed() < 0 || inState(CState.LEDGE_HANG))
            {
               _loc4_ = false;
               m_currentPlatform = null;
               m_collision.ground = false;
            }
            if(!m_collision.ground && _loc4_ && !inState(CState.KIRBY_STAR))
            {
               if(inState(CState.ATTACKING))
               {
                  m_attack.HasLanded = true;
               }
               _loc1_ = true;
               attachToGround();
               if(!inState(CState.LEDGE_ROLL) && !inState(CState.LEDGE_CLIMB) && !(inState(CState.ATTACKING) && m_attack.Frame == "ledge_attack"))
               {
                  this.attachLandEffect();
               }
               this.updateItemHolding();
               if(!this.m_heldControls.LEFT && !this.m_heldControls.RIGHT && !inState(CState.ATTACKING) && !inState(CState.INJURED) && !inState(CState.FLYING) && !inState(CState.CAUGHT) && !inState(CState.BARREL) && !inState(CState.FROZEN) && !inState(CState.STUNNED) && !inState(CState.DIZZY) && !inState(CState.CRASH_GETUP) && !inState(CState.CRASH_LAND) && !inState(CState.TUMBLE_FALL) && !inState(CState.EGG) && !inState(CState.KIRBY_STAR) && !inState(CState.LEDGE_ROLL))
               {
                  m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.CHAR_LAND,{"caller":this.APIInstance.instance}));
               }
               this.groundBounceCheck();
               if(!inState(CState.FLYING))
               {
                  m_ySpeed = 0;
               }
               m_yKnockback = 0;
            }
            if(m_collision.ground && !_loc4_)
            {
               if(!inState(CState.ATTACKING))
               {
                  if(m_xSpeed > this.m_characterStats.MaxJumpSpeed)
                  {
                     m_xSpeed = this.m_characterStats.MaxJumpSpeed;
                  }
                  else if(m_xSpeed < -this.m_characterStats.MaxJumpSpeed)
                  {
                     m_xSpeed = -this.m_characterStats.MaxJumpSpeed;
                  }
               }
               if(inState(CState.PITFALL))
               {
                  this.pitFallRelease();
               }
            }
            m_collision.ground = _loc4_;
            if(m_collision.ground)
            {
               this.m_glideReady = true;
            }
            this.testJumpCount();
            if(m_collision.ground)
            {
               if(!this.testGroundWithCoord(m_sprite.x,m_sprite.y + 1))
               {
                  attachToGround();
               }
            }
            if(!this.m_human)
            {
               updateWarningCollision();
            }
            if(m_collision.ground)
            {
               if(inState(CState.DISABLED))
               {
                  setBrightness(0);
                  this.setState(CState.HEAVY_LAND);
               }
            }
            if(m_collision.ground && inState(CState.AIR_DODGE))
            {
               this.turnOffInvincibility();
            }
            if(_loc3_ && !m_collision.ground && (inState(CState.IDLE) || inState(CState.CRASH_GETUP) || inState(CState.CRASH_LAND)) && inKnockback())
            {
               if(inState(CState.CRASH_GETUP))
               {
                  this.setIntangibility(false);
               }
               if(inState(CState.IDLE))
               {
                  this.setState(CState.JUMP_FALLING);
               }
               else
               {
                  this.setState(CState.TUMBLE_FALL);
               }
            }
            if(_loc3_ && !m_collision.ground && this.isLanding())
            {
               this.setState(CState.JUMP_FALLING);
            }
            if(!m_collision.ground && inState(CState.SHIELDING))
            {
               this.m_deactivateShield();
               this.setState(CState.TUMBLE_FALL);
            }
            if(inState(CState.IDLE) || this.isLanding() || inState(CState.WALK) || inState(CState.JUMP_RISING) || inState(CState.JUMP_MIDAIR_RISING) || inState(CState.JUMP_FALLING) || inState(CState.RUN) || inState(CState.DASH) || inState(CState.TURN) || inState(CState.SKID) || inState(CState.HOVER) || inState(CState.CROUCH))
            {
               this.checkGroundStateChange();
            }
         }
         if(!m_collision.ground && inState(CState.GRABBING) && !inState(CState.ATTACKING) && !currentStanceFrameIs("tether"))
         {
            this.grabReleaseOpponent();
            this.setState(CState.JUMP_FALLING);
         }
         if(m_collision.ground && !_loc3_)
         {
            if(inState(CState.STAMINA_KO))
            {
               this.m_controlFrames();
            }
            this.clearControlsBuffer();
         }
         if(_loc3_ && !m_collision.ground)
         {
            if(inState(CState.STAMINA_KO))
            {
               this.m_controlFrames();
            }
            if(inState(CState.DIZZY))
            {
               this.m_dizzyShield = false;
            }
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.GROUND_LEAVE,{"caller":this.APIInstance.instance}));
         }
         if(_loc1_)
         {
            if(_loc2_ && !m_attack.LinkFrames)
            {
               initDelayPlayback(true);
               this.attackCollisionTest();
               m_attackCollisionTestsPreProcessed = true;
            }
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.GROUND_TOUCH,{"caller":this.APIInstance.instance}));
         }
         if(!inState(CState.LAND))
         {
            this.m_waveLand = false;
         }
         else if(Boolean(this.m_waveLand) && Boolean(STAGEDATA.AirDodge.match(/vsolo|vdouble/)))
         {
            if(m_xKnockback > 0 && this.m_heldControls.LEFT != this.m_heldControls.RIGHT && Boolean(this.m_heldControls.LEFT) || m_xKnockback < 0 && this.m_heldControls.LEFT != this.m_heldControls.RIGHT && Boolean(this.m_heldControls.RIGHT))
            {
               this.decel_knockback();
            }
         }
      }
      
      public function touchingLowerWarningBounds(param1:int, param2:int) : Boolean
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         _loc3_ = 0;
         while(_loc3_ < m_warningBounds_lower[0].length)
         {
            if(m_warningBounds_lower[0][_loc3_].hitTestPoint(param1,param2,true))
            {
               return true;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < m_warningBounds_lower[1].length)
         {
            if(m_warningBounds_lower[1][_loc3_].hitTestPoint(param1,param2,true))
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function touchingUpperWarningBounds(param1:int, param2:int) : Boolean
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         _loc3_ = 0;
         while(_loc3_ < m_warningBounds_upper[0].length)
         {
            if(m_warningBounds_upper[0][_loc3_].hitTestPoint(param1,param2,true))
            {
               return true;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < m_warningBounds_upper[1].length)
         {
            if(m_warningBounds_upper[1][_loc3_].hitTestPoint(param1,param2,true))
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function calculateAICollision(param1:Number, param2:Number) : void
      {
         m_collision.leftSide = param1 < 0 && !inState(CState.LEDGE_HANG) && m_collision.ground && !inState(CState.FLYING) && !inState(CState.INJURED) && Boolean(testTerrainWithCoord(m_sprite.x + param1 - 9 - m_width / 2,m_sprite.y + param2 - 35));
         m_collision.rightSide = param1 > 0 && !inState(CState.LEDGE_HANG) && m_collision.ground && !inState(CState.FLYING) && !inState(CState.INJURED) && Boolean(testTerrainWithCoord(m_sprite.x + param1 + 9 + m_height / 2,m_sprite.y + param2 - 35));
      }
      
      override public function m_attemptToMove(param1:Number, param2:Number) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Point = null;
         var _loc5_:Platform = null;
         var _loc6_:Boolean = false;
         var _loc7_:Number = NaN;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:int = 0;
         var _loc13_:Boolean = false;
         var _loc14_:Number = NaN;
         var _loc15_:Boolean = false;
         if(inState(CState.STAR_KO) || inState(CState.SCREEN_KO))
         {
            return;
         }
         if(inState(CState.PITFALL))
         {
            param1 = 0;
         }
         if(!(param1 == 0 && param2 == 0))
         {
            _loc3_ = 0;
            m_collision.leftSide = param1 < 0 && !inState(CState.LEDGE_HANG) && m_collision.ground && !inState(CState.FLYING) && !inState(CState.INJURED) && Boolean(testTerrainWithCoord(m_sprite.x + param1 - 11,m_sprite.y + param2 - 35));
            m_collision.rightSide = param1 > 0 && !inState(CState.LEDGE_HANG) && m_collision.ground && !inState(CState.FLYING) && !inState(CState.INJURED) && Boolean(testTerrainWithCoord(m_sprite.x + param1 + 11,m_sprite.y + param2 - 35));
            if(!isHitStunOrParalysis() && !inState(CState.LEDGE_ROLL) && !inState(CState.LEDGE_HANG) && !(m_collision.ground && !inState(CState.FLYING) && !inState(CState.INJURED)))
            {
               _loc4_ = Location.clone();
               _loc5_ = moveSprite(param1,param2);
               _loc6_ = _loc5_ != null;
               _loc7_ = Number(Utils.getAngleBetween(new Point(_loc4_.x,_loc4_.y),new Point(m_sprite.x,m_sprite.y)));
               if(_loc6_ && !(_loc7_ >= 225 && _loc7_ <= 315) && !(m_sprite.x == _loc4_.x && m_sprite.y == _loc4_.y))
               {
                  m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.HIT_WALL,{
                     "caller":this.APIInstance.instance,
                     "left":_loc7_ < 225 && _loc7_ > 135,
                     "right":_loc7_ < 45 && _loc7_ >= 0 || _loc7_ <= 360 && _loc7_ > 315,
                     "top":_loc7_ >= 45 && _loc7_ >= 135
                  }));
               }
               if(m_collision.rightSide && param1 > 0 || m_collision.leftSide && param1 < 0)
               {
                  m_sprite.x = _loc4_.x;
               }
               _loc8_ = this.netYSpeed() < 0;
               if(_loc6_ && param2 >= 0)
               {
                  this.m_groundCollisionTest();
               }
               _loc8_ = _loc8_ != this.netYSpeed() < 0;
               if(_loc6_ && !m_collision.ground && param2 > 0 && inState(CState.FLYING) && this.netYSpeed() >= 0)
               {
                  _loc9_ = (m_currentPlatform = this.testGroundWithCoord(m_sprite.x,m_sprite.y + 1)) != null;
                  this.groundBounceCheck();
               }
               this.repositionGrabbedCharacter();
               if(_loc6_ && (inState(CState.FLYING) || this.isRocketing()) && Utils.fastAbs(param1) > 3 && STAGEDATA.Terrains.indexOf(_loc5_) >= 0 && Boolean(this.m_ricochetX.IsComplete) && Boolean(this.m_ricochetY.IsComplete) && !this.m_ricochetCount.IsComplete)
               {
                  if(Boolean(this.m_techReady) && !isHitStunOrParalysis() && Boolean(this.m_canWallTech) && !this.isRocketing())
                  {
                     this.performWallTech(false);
                  }
                  else if(this.m_ricochetTimer.IsComplete)
                  {
                     this.m_ricochetX.reset();
                     this.m_ricochetCount.tick();
                     _loc10_ = false;
                     if(Boolean(testTerrainWithCoord(m_sprite.x,m_sprite.y - m_height)) && (Boolean(m_xKnockback < 0) && Boolean(testTerrainWithCoord(m_sprite.x - m_width / 2,m_sprite.y - m_height)) || Boolean(m_xKnockback > 0) && Boolean(testTerrainWithCoord(m_sprite.x + m_width / 2,m_sprite.y - m_height))))
                     {
                        this.m_ricochetY.reset();
                        _loc10_ = true;
                     }
                     this.attachWallBounceEffect(m_xKnockback > 0,_loc10_);
                     startActionShot(2);
                     this.m_hitLag = this.calculateHitLag(Utils.calculateKnockbackFromVelocity(Utils.getDistance(new Point(),new Point(m_xKnockback,m_yKnockback))),-0.9);
                  }
               }
               if(_loc6_ && (inState(CState.FLYING) || this.isRocketing()) && Utils.fastAbs(param2) > 2 && STAGEDATA.Terrains.indexOf(_loc5_) >= 0 && !m_collision.ground && param2 < 0 && this.netYSpeed() < 0 && !_loc8_ && Boolean(this.m_ricochetX.IsComplete) && Boolean(this.m_ricochetY.IsComplete) && !this.m_ricochetCount.IsComplete)
               {
                  if(Boolean(this.m_techReady) && !isHitStunOrParalysis() && Boolean(this.m_canWallTech) && !this.isRocketing())
                  {
                     this.performWallTech(true);
                  }
                  else if(this.m_ricochetTimer.IsComplete)
                  {
                     this.m_hasArced = false;
                     this.m_ricochetY.reset();
                     this.m_ricochetCount.tick();
                     _loc11_ = false;
                     if(Boolean(testTerrainWithCoord(m_sprite.x,m_sprite.y - m_height)) && (Boolean(m_xKnockback > 0) && Boolean(testTerrainWithCoord(m_sprite.x + m_width / 2,m_sprite.y - m_height)) || Boolean(m_xKnockback < 0) && Boolean(testTerrainWithCoord(m_sprite.x - m_width / 2,m_sprite.y - m_height))))
                     {
                        this.m_ricochetX.reset();
                        _loc11_ = true;
                     }
                     this.attachCeilingBounceEffect(m_xKnockback > 0,_loc11_);
                     startActionShot(2);
                     this.m_hitLag = this.calculateHitLag(Utils.calculateKnockbackFromVelocity(Utils.getDistance(new Point(),new Point(m_xKnockback,m_yKnockback))),-0.9);
                  }
               }
            }
            else if(!isHitStunOrParalysis())
            {
               _loc12_ = Utils.fastAbs(param1) >= 10 || Utils.fastAbs(param2) >= 10 ? 10 : 5;
               _loc13_ = false;
               _loc14_ = m_sprite.x + param1;
               _loc15_ = false;
               param1 /= _loc12_;
               param2 /= _loc12_;
               _loc3_ = 0;
               while(_loc3_ < _loc12_)
               {
                  m_collision.leftSide = param1 < 0 && !inState(CState.LEDGE_HANG) && m_collision.ground && !inState(CState.FLYING) && !inState(CState.INJURED) && Boolean(testTerrainWithCoord(m_sprite.x + param1 - this.m_characterStats.KneeXOffset,m_sprite.y + param2 + this.m_characterStats.KneeYOffset));
                  m_collision.rightSide = param1 > 0 && !inState(CState.LEDGE_HANG) && m_collision.ground && !inState(CState.FLYING) && !inState(CState.INJURED) && Boolean(testTerrainWithCoord(m_sprite.x + param1 + this.m_characterStats.KneeXOffset,m_sprite.y + param2 + this.m_characterStats.KneeYOffset));
                  if(!_loc13_ && param1 != 0 && (m_collision.rightSide || m_collision.leftSide))
                  {
                     _loc13_ = true;
                     m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.HIT_WALL,{
                        "caller":this.APIInstance.instance,
                        "left":m_collision.leftSide,
                        "right":m_collision.rightSide,
                        "top":false
                     }));
                  }
                  if(param2 < 0 && !testTerrainWithCoord(m_sprite.x,m_sprite.y + param2))
                  {
                     m_sprite.y += param2;
                  }
                  if(param1 != 0 && !(Boolean(this.inPreventFallOffState()) && this.willFallOffRange(m_sprite.x + param1,m_sprite.y,10)))
                  {
                     m_sprite.x += !(m_collision.rightSide && param1 > 0 || m_collision.leftSide && param1 < 0) ? param1 : 0;
                  }
                  else
                  {
                     _loc15_ = true;
                  }
                  if(param2 > 0 && !testTerrainWithCoord(m_sprite.x,m_sprite.y + param2))
                  {
                     m_sprite.y += param2;
                  }
                  if(!m_collision.leftSide && !m_collision.rightSide)
                  {
                     attachToGround();
                  }
                  this.repositionGrabbedCharacter();
                  if((Utils.fastAbs(param1) > 10 || Utils.fastAbs(param2) > 10) && runExtraHitTests(m_sprite.x,m_sprite.y))
                  {
                     _loc15_ = true;
                     break;
                  }
                  _loc3_++;
               }
               if(!_loc15_ && param1 !== 0 && !testTerrainWithCoord(_loc14_,m_sprite.y) && !this.willFallOffRange(_loc14_,m_sprite.y,10))
               {
                  m_sprite.x = _loc14_;
                  attachToGround();
               }
            }
            this.repositionEffects();
         }
      }
      
      private function repositionEffects() : void
      {
         if(this.m_chargeGlowHolderMC != null && !inState(CState.LEDGE_HANG))
         {
            this.m_chargeGlowHolderMC.x = m_sprite.x;
            this.m_chargeGlowHolderMC.y = m_sprite.y;
            if(Boolean(m_sprite.parent) && Boolean(this.m_chargeGlowHolderMC.parent) && this.m_chargeGlowHolderMC.parent.getChildIndex(this.m_chargeGlowHolderMC) < m_sprite.parent.getChildIndex(m_sprite))
            {
               Utils.swapDepths(m_sprite,this.m_chargeGlowHolderMC);
            }
         }
         if(this.HasFinalSmash && !inState(CState.LEDGE_HANG))
         {
            this.m_fsGlowHolderMC.x = m_sprite.x;
            this.m_fsGlowHolderMC.y = m_sprite.y;
            if(Boolean(m_sprite.parent) && Boolean(this.m_fsGlowHolderMC.parent) && this.m_fsGlowHolderMC.parent.getChildIndex(this.m_fsGlowHolderMC) < m_sprite.parent.getChildIndex(m_sprite))
            {
               Utils.swapDepths(m_sprite,this.m_fsGlowHolderMC);
            }
         }
      }
      
      override public function testGroundWithCoord(param1:Number, param2:Number) : Platform
      {
         var _loc3_:int = 0;
         var _loc4_:Platform = null;
         _loc3_ = 0;
         _loc3_ = 0;
         while(_loc3_ < m_terrains.length && (!m_terrains[_loc3_].hitTestPoint(param1,param2,true) || m_terrains[_loc3_].fallthrough == true || m_terrains[_loc3_].shouldIgnore(this) || m_selfPlatform == m_terrains[_loc3_]))
         {
            _loc3_++;
         }
         if(_loc3_ < m_terrains.length && m_terrains[_loc3_].hitTestPoint(param1,param2,true))
         {
            _loc4_ = this.testPlatformWithCoord(param1,param2);
            if(_loc4_)
            {
               return _loc4_;
            }
            return m_terrains[_loc3_];
         }
         _loc3_ = 0;
         while(_loc3_ < m_platforms.length && (!m_platforms[_loc3_].hitTestPoint(param1,param2,true) || m_platforms[_loc3_].fallthrough == true || m_platforms[_loc3_].shouldIgnore(this) || m_selfPlatform == m_platforms[_loc3_]))
         {
            _loc3_++;
         }
         if(_loc3_ < m_platforms.length && m_platforms[_loc3_].hitTestPoint(param1,param2,true) && (this.m_fallthroughPlatform == null || m_platforms[_loc3_] !== this.m_fallthroughPlatform) && this.netYSpeed() >= 0 && !(inState(CState.ATTACKING) && m_attack.ForceFallThrough && !m_platforms[_loc3_].noDropThrough) && (!this.m_heldControls.DOWN || !(Boolean(this.m_heldControls.DOWN) && !SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1) && !m_collision.ground && !inState(CState.ATTACKING) && m_platforms[_loc3_].noDropThrough != true)) && !(inState(CState.ATTACKING) && m_attack.Rocket && this.m_rocketAngle > 0 && this.m_rocketAngle < 180))
         {
            return m_platforms[_loc3_];
         }
         return null;
      }
      
      override public function testPlatformWithCoord(param1:Number, param2:Number) : Platform
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         _loc3_ = 0;
         while(_loc3_ < m_platforms.length && (!m_platforms[_loc3_].hitTestPoint(param1,param2,true) || m_platforms[_loc3_].fallthrough == true || m_platforms[_loc3_].shouldIgnore(this) || m_selfPlatform == m_platforms[_loc3_]))
         {
            _loc3_++;
         }
         if(_loc3_ < m_platforms.length && m_platforms[_loc3_].hitTestPoint(param1,param2,true) && (this.m_fallthroughPlatform == null || m_platforms[_loc3_] !== this.m_fallthroughPlatform) && this.netYSpeed() >= 0 && !(inState(CState.ATTACKING) && m_attack.ForceFallThrough && !m_platforms[_loc3_].noDropThrough) && (!this.m_heldControls.DOWN || !(Boolean(this.m_heldControls.DOWN) && !SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1) && !m_collision.ground && !inState(CState.ATTACKING) && m_platforms[_loc3_].noDropThrough != true)) && !(inState(CState.ATTACKING) && m_attack.Rocket && this.m_rocketAngle > 0 && this.m_rocketAngle < 180) && !(Boolean(m_currentPlatform) && m_currentPlatform !== m_platforms[_loc3_] && m_platforms.indexOf(m_currentPlatform) >= 0))
         {
            return m_platforms[_loc3_];
         }
         return null;
      }
      
      override protected function testCoordCollision(param1:Number, param2:Number) : Boolean
      {
         if(m_currentPlatform != null && m_currentPlatform.hitTestPoint(param1,param2,true) && m_currentPlatform.fallthrough != true && !m_currentPlatform.shouldIgnore(this) && !(OnPlatform && this.netYSpeed() < 0))
         {
            return true;
         }
         return false;
      }
      
      private function testJumpCount() : void
      {
         if(m_collision.ground && !inState(CState.TUMBLE_FALL))
         {
            if(Boolean(this.m_crowdAwe) && !inState(CState.CRASH_LAND) && !inState(CState.CRASH_GETUP) && this.m_jumpCount >= this.m_characterStats.MaxJump)
            {
               if(STAGEDATA.CrowdChantID < 0)
               {
                  STAGEDATA.playSpecificVoice(["crowd_gasp_s","crowd_gasp_m","crowd_gasp_l"][Utils.randomInteger(0,2)]);
               }
            }
            this.resetJumps();
            this.m_midAirJumpConstantTime.finish();
            this.m_canHover = true;
            this.m_lastLedge = null;
            this.m_wallJumpCount = 0;
            this.m_wallStickTime.MaxTime = this.m_characterStats.WallStick;
            this.m_crowdAwe = false;
            this.m_tetherCount = 0;
            this.m_airDodgeCount = 0;
         }
      }
      
      private function triggerTaunts() : void
      {
         if(Boolean(m_lastHitID != m_player_id && m_lastHitID > 0) && Boolean(STAGEDATA.getPlayerByID(m_lastHitID)) && !(m_team_id > 0 && STAGEDATA.getPlayerByID(m_lastHitID).Team == m_team_id))
         {
            if(STAGEDATA.getPlayerByID(m_lastHitID).isCPU())
            {
               STAGEDATA.getPlayerByID(m_lastHitID).CPU.triggerTaunt();
            }
         }
      }
      
      private function m_checkDeath() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Vector.<Character> = null;
         _loc1_ = 0;
         _loc2_ = null;
         if(Boolean(!inState(CState.DEAD) && !inState(CState.CAUGHT) && !inState(CState.BARREL) && !inState(CState.STAR_KO) && !inState(CState.SCREEN_KO) && !inState(CState.BARREL) && this.m_starKOTimer.IsComplete && !inState(CState.REVIVAL)) && Boolean(STAGEDATA.DeathBounds) && (m_sprite.x < STAGEDATA.DeathBounds.x || m_sprite.x > STAGEDATA.DeathBounds.x + STAGEDATA.DeathBounds.width || m_sprite.y < STAGEDATA.DeathBounds.y && !STAGEDATA.DisableCeilingDeath && !inState(CState.GRABBING) && (inState(CState.FLYING) || inState(CState.INJURED) || m_collision.ground || Boolean(this.m_windBoxHit) || inState(CState.TUMBLE_FALL) || inState(CState.DIZZY) || inState(CState.STUNNED) || inState(CState.EGG) || inState(CState.FROZEN)) || m_sprite.y > STAGEDATA.DeathBounds.y + STAGEDATA.DeathBounds.height && !STAGEDATA.DisableFallDeath))
         {
            if(m_sprite.y < STAGEDATA.DeathBounds.y && !this.m_usingSpecialAttack && !SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1) && Boolean(this.m_characterStats.CanStarKO) && (STAGEDATA.StarKOEnabled || STAGEDATA.ScreenKOEnabled))
            {
               _loc2_ = new Vector.<Character>();
               _loc1_ = 0;
               while(_loc1_ < this.m_grabbed.length)
               {
                  _loc2_.push(this.m_grabbed[_loc1_]);
                  _loc1_++;
               }
               this.releaseOpponent();
               _loc1_ = 0;
               while(_loc1_ < _loc2_.length)
               {
                  if(!_loc2_[0].inState(CState.STAR_KO) && !_loc2_[0].inState(CState.SCREEN_KO) && !_loc2_[0].inState(CState.DEAD))
                  {
                     _loc2_[_loc1_].killCharacterStarKO();
                  }
                  _loc1_++;
               }
               this.triggerTaunts();
               this.killCharacterStarKO();
            }
            else
            {
               this.killCharacterDeathBounds();
            }
         }
         if(m_baseStats.Stamina > 0 && !inState(CState.DEAD) && !inState(CState.STAMINA_KO) && !this.StandBy && m_damage <= 0)
         {
            if(STAGEDATA.GameRef.UsingTime && !STAGEDATA.GameRef.UsingLives || STAGEDATA.GameRef.UsingLives && this.m_lives > 1)
            {
               if(this.m_grabbed.length > 0)
               {
                  this.releaseOpponent();
               }
               if(inState(CState.CAUGHT) && this.m_grabberID > 0 && Boolean(STAGEDATA.getCharacterByUID(this.m_grabberID)))
               {
                  STAGEDATA.getCharacterByUID(this.m_grabberID).grabRelease();
               }
               this.playGlobalSound("deathExplosion");
               this.attachEffect("stamina_ko_explosion",{"y":-this.m_characterStats.Height / 2});
               this.killCharacter(true);
            }
            else
            {
               if(this.m_grabbed.length > 0)
               {
                  this.releaseOpponent();
               }
               if(inState(CState.CAUGHT) && this.m_grabberID > 0 && Boolean(STAGEDATA.getCharacterByUID(this.m_grabberID)))
               {
                  STAGEDATA.getCharacterByUID(this.m_grabberID).grabRelease();
               }
               if(inState(CState.EGG))
               {
                  this.egg(false);
               }
               if(inState(CState.FROZEN))
               {
                  this.freeze(false);
               }
               if(inState(CState.SHIELDING))
               {
                  this.m_deactivateShield();
               }
               this.setVisibility(true);
               this.hideAllEffects();
               this.updateMatchStatistics();
               this.loseLife();
               if(inState(CState.STAMINA_KO))
               {
                  this.playCharacterSound("starko");
               }
            }
         }
         this.m_windBoxHit = false;
      }
      
      public function scorePoint(param1:Boolean) : void
      {
         var _loc2_:MovieClip = null;
         if(m_healthBoxMC)
         {
            _loc2_ = MovieClip(m_healthBoxMC.addChild(ResourceManager.getLibraryMC("scoreAnim_mc")));
            Utils.tryToGotoAndStop(_loc2_.score,(param1 ? "p" : "m") + Utils.convertTeamToColor(m_player_id,m_team_id));
            _loc2_.x = 19;
            _loc2_.y = -34;
         }
      }
      
      private function updateMatchStatistics() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Character = null;
         if(!STAGEDATA.GameEnded)
         {
            if(m_lastHitID <= 0)
            {
               ++this.m_matchResults.SelfDestructs;
               if(ModeFeatures.hasFeature(ModeFeatures.SAVE_RECORDS,STAGEDATA.GameRef.GameMode))
               {
                  _loc1_ = ResourceManager.getCostume(this.m_characterStats.StatsName,Utils.getColorString(m_team_id),this.m_costume);
                  if(Boolean(this.m_characterStats.StatsName === "ness") && (Boolean(_loc1_ && _loc1_.metadata && _loc1_.metadata.ghost)) && Boolean(this.m_human))
                  {
                     ++SaveData.Unlocks.ghostNessSDs;
                  }
               }
               this.m_matchResults.KillerList.push(0);
               --this.m_matchResults.Score;
               if(Boolean(STAGEDATA.GameRef.ScoreDisplay) && Boolean(m_healthBoxMC) && Boolean(m_healthBoxMC.score))
               {
                  m_healthBoxMC.score.text = "" + this.m_matchResults.Score;
               }
               if(STAGEDATA.GameRef.UsingTime)
               {
                  this.scorePoint(false);
               }
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.CHAR_SELF_DESTRUCT,{"caller":this.APIInstance.instance}));
            }
            else if(m_lastHitID > 0)
            {
               _loc2_ = STAGEDATA.getPlayerByID(m_lastHitID);
               ++this.m_matchResults.Falls;
               this.m_matchResults.KillerList.push(m_lastHitID);
               --this.m_matchResults.Score;
               if(Boolean(STAGEDATA.GameRef.ScoreDisplay) && Boolean(m_healthBoxMC) && Boolean(m_healthBoxMC.score))
               {
                  m_healthBoxMC.score.text = "" + this.m_matchResults.Score;
               }
               if(STAGEDATA.GameRef.UsingTime)
               {
                  this.scorePoint(false);
               }
               if(!(m_team_id > 0 && _loc2_.Team == m_team_id) && m_lastHitID != m_player_id)
               {
                  ++_loc2_.getMatchResults().KOs;
                  _loc2_.getMatchResults().KOList.push(m_player_id);
                  ++_loc2_.getMatchResults().Score;
                  if(Boolean(STAGEDATA.GameRef.ScoreDisplay) && Boolean(_loc2_.HealthBox) && Boolean(_loc2_.HealthBox.score))
                  {
                     _loc2_.HealthBox.score.text = "" + _loc2_.getMatchResults().Score;
                  }
                  _loc2_.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.CHAR_KO_POINT,{
                     "caller":_loc2_.APIInstance.instance,
                     "victim":this.APIInstance.instance
                  }));
                  if(_loc2_.getDamage() >= 100 && Utils.random() > 0.25)
                  {
                     STAGEDATA.startCrowdChant(_loc2_.ID);
                  }
                  else
                  {
                     STAGEDATA.playSpecificVoice(["crowd_clap_s","crowd_clap_m","crowd_clap_l"][Utils.safeRandomInteger(0,2)]);
                  }
                  if(STAGEDATA.GameRef.UsingTime)
                  {
                     _loc2_.scorePoint(true);
                  }
               }
            }
         }
      }
      
      private function loseLife(param1:Boolean = false) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:* = undefined;
         var _loc7_:Character = null;
         var _loc8_:Boolean = false;
         var _loc9_:Number = NaN;
         var _loc10_:* = undefined;
         if(this.m_usingLives)
         {
            --this.m_lives;
            if(!STAGEDATA.GameEnded)
            {
               this.m_matchResults.StockRemaining = this.m_lives;
            }
            this.updateLivesDisplay();
            if(this.m_lives <= 0)
            {
               if(m_baseStats.Stamina > 0 && !param1)
               {
                  this.setState(CState.STAMINA_KO);
               }
               else
               {
                  this.reset();
                  this.setState(CState.DEAD);
                  this.setVisibility(false);
               }
               if(m_healthBoxMC)
               {
                  showHealthBoxes(false);
               }
               _loc2_ = new Array();
               _loc3_ = false;
               _loc4_ = 0;
               while(_loc4_ < STAGEDATA.Players.length)
               {
                  _loc7_ = STAGEDATA.Players[_loc4_];
                  if(Boolean(_loc7_ && _loc7_ != this && !_loc7_.Dead) && Boolean(!_loc7_.inState(CState.STAMINA_KO)) && !(_loc7_.Team == m_team_id && m_team_id > 0))
                  {
                     if(_loc7_.Team > 0 && _loc2_["t" + _loc7_.Team] == null || _loc7_.Team == -1 && _loc2_["t0"] == null)
                     {
                        if(_loc7_.Team == -1)
                        {
                           _loc2_["t0"] = 1;
                        }
                        else
                        {
                           _loc2_["t" + _loc7_.Team] = 1;
                        }
                     }
                     else if(_loc7_.Team == -1)
                     {
                        ++_loc2_["t0"];
                     }
                     else
                     {
                        ++_loc2_["t" + _loc7_.Team];
                     }
                  }
                  else if(Boolean(_loc7_ && !_loc7_.Dead && !_loc7_.inState(CState.STAMINA_KO)) && Boolean(_loc7_.Team == m_team_id) && m_team_id > 0)
                  {
                     _loc3_ = true;
                  }
                  _loc4_++;
               }
               _loc5_ = 0;
               for(_loc6_ in _loc2_)
               {
                  _loc5_++;
               }
               if(!ModeFeatures.hasFeature(ModeFeatures.IS_CUSTOM,STAGEDATA.GameRef.GameMode))
               {
                  if(_loc5_ == 1)
                  {
                     _loc8_ = false;
                     _loc9_ = 0;
                     for(_loc10_ in _loc2_)
                     {
                        if(_loc10_ == "t0")
                        {
                           _loc8_ = true;
                           _loc9_ = Number(_loc2_[_loc10_]);
                        }
                     }
                     if(_loc8_ && _loc9_ <= 1 && !STAGEDATA.GameEnded)
                     {
                        if(ModeFeatures.hasFeature(ModeFeatures.ALLOW_NARRATOR_GAME,STAGEDATA.GameRef.GameMode))
                        {
                           STAGEDATA.playSpecificVoice("narrator_game");
                        }
                        STAGEDATA.prepareEndGameCharacter(STAGEDATA.GameRef.UsingStamina && !param1);
                     }
                     else if(!_loc8_ && !_loc3_ && !STAGEDATA.GameEnded)
                     {
                        if(ModeFeatures.hasFeature(ModeFeatures.ALLOW_NARRATOR_GAME,STAGEDATA.GameRef.GameMode))
                        {
                           STAGEDATA.playSpecificVoice("narrator_game");
                        }
                        STAGEDATA.prepareEndGameCharacter(STAGEDATA.GameRef.UsingStamina && !param1);
                     }
                  }
                  else if(_loc5_ == 0 && !STAGEDATA.GameEnded)
                  {
                     if(ModeFeatures.hasFeature(ModeFeatures.ALLOW_NARRATOR_GAME,STAGEDATA.GameRef.GameMode))
                     {
                        STAGEDATA.playSpecificVoice("narrator_game");
                     }
                     STAGEDATA.prepareEndGameCharacter(STAGEDATA.GameRef.UsingStamina && !param1);
                  }
               }
               if(!ModeFeatures.hasFeature(ModeFeatures.IS_CUSTOM,STAGEDATA.GameRef.GameMode) && !STAGEDATA.GameEnded && !STAGEDATA.EndTrigger && Boolean(ModeFeatures.hasFeature(ModeFeatures.ALLOW_NARRATOR_CPU_DEFEATED,STAGEDATA.GameRef.GameMode)))
               {
                  STAGEDATA.playNarratorSpeech([this.m_human ? "narrator_player" + m_player_id : "narrator_cpu","narrator_defeated"]);
               }
            }
         }
      }
      
      public function killCharacterDeathBounds() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:Vector.<Character> = null;
         var _loc4_:MovieClip = null;
         var _loc5_:Number = NaN;
         _loc1_ = 0;
         _loc2_ = "";
         if(m_team_id > 0 && !ModeFeatures.hasFeature(ModeFeatures.IGNORE_TEAM_COSTUME,STAGEDATA.GameRef.GameMode))
         {
            if(m_team_id == 1)
            {
               _loc2_ += "_p1";
            }
            if(m_team_id == 2)
            {
               _loc2_ += "_p4";
            }
            if(m_team_id == 3)
            {
               _loc2_ += "_p2";
            }
         }
         else if(this.m_human)
         {
            _loc2_ += "_p" + m_player_id;
         }
         if(STAGEDATA.CamBounds)
         {
            _loc4_ = STAGEDATA.attachEffectOverlay("deathMC" + _loc2_);
            _loc5_ = 80;
            if(m_sprite.x < STAGEDATA.CamBounds.x)
            {
               _loc4_.rotation = 90;
               _loc4_.x = STAGEDATA.CamBounds.x + STAGE.x - _loc5_;
               _loc4_.y = m_sprite.y + STAGE.y;
            }
            else if(m_sprite.x > STAGEDATA.CamBounds.x + STAGEDATA.CamBounds.width)
            {
               _loc4_.rotation = 270;
               _loc4_.x = STAGEDATA.CamBounds.x + STAGEDATA.CamBounds.width + STAGE.x + _loc5_;
               _loc4_.y = m_sprite.y + STAGE.y;
            }
            else if(m_sprite.y < STAGEDATA.CamBounds.y)
            {
               _loc4_.rotation = 180;
               _loc4_.x = m_sprite.x + STAGE.x;
               _loc4_.y = STAGEDATA.CamBounds.y + STAGE.y;
            }
            else
            {
               _loc4_.x = m_sprite.x + STAGE.x;
               _loc4_.y = STAGEDATA.CamBounds.y + STAGEDATA.CamBounds.height + STAGE.y;
               if(ModeFeatures.hasFeature(ModeFeatures.SAVE_RECORDS,STAGEDATA.GameRef.GameMode))
               {
                  if(["gangplankgalleon","lakeofrage","planetnamek","fairyglade"].indexOf(STAGEDATA.GameRef.LevelData.stage) >= 0)
                  {
                     ++SaveData.Unlocks.waterKOs;
                  }
               }
            }
            _loc4_.scaleX = 1.2;
            _loc4_.scaleY = 1.2;
         }
         STAGEDATA.CamRef.addTimedTargetPoint(new Point(m_sprite.x,m_sprite.y),this.m_respawnDelay.MaxTime);
         if(Boolean(STAGEDATA.CamBounds) && (Boolean(m_sprite.y < STAGEDATA.CamBounds.y + 100 || m_sprite.y > STAGEDATA.CamBounds.y + STAGEDATA.CamBounds.height - 160)) && (m_sprite.x < STAGEDATA.CamBounds.x + 100 || m_sprite.x > STAGEDATA.CamBounds.x + STAGEDATA.CamBounds.width - 100))
         {
            _loc4_.rotation = Utils.forceBase360(90 - Utils.getAngleBetween(new Point(m_sprite.x,m_sprite.y),new Point(STAGEDATA.CamBounds.x + STAGEDATA.CamBounds.width / 2,STAGEDATA.CamBounds.y + STAGEDATA.CamBounds.height / 2)));
         }
         this.playGlobalSound("deathExplosion");
         this.triggerTaunts();
         _loc3_ = new Vector.<Character>();
         _loc1_ = 0;
         while(_loc1_ < this.m_grabbed.length)
         {
            _loc3_.push(this.m_grabbed[_loc1_]);
            _loc1_++;
         }
         this.releaseOpponent();
         _loc1_ = 0;
         while(_loc1_ < _loc3_.length)
         {
            _loc3_[_loc1_].killCharacter(true,true);
            _loc1_++;
         }
         this.killCharacter(true,true);
      }
      
      public function killCharacter(param1:Boolean = true, param2:Boolean = false) : void
      {
         var _loc3_:Vector.<MovieClip> = null;
         if(!inState(CState.DEAD))
         {
            if(inState(CState.EGG))
            {
               this.egg(false);
            }
            if(inState(CState.FROZEN))
            {
               this.freeze(false);
            }
            if(inState(CState.SHIELDING))
            {
               this.m_deactivateShield();
            }
            _loc3_ = new Vector.<MovieClip>();
            _loc3_.push(m_sprite);
            if(STAGEDATA.GameRef.GameMode != Mode.TARGET_TEST)
            {
               CAM.deleteTargets(_loc3_);
            }
            this.grabReleaseOpponent();
            this.setVisibility(false);
            this.hideAllEffects();
            if(param1)
            {
               CAM.shake(10);
               this.playFrame("fall");
               this.playCharacterSound("dead");
               if(this.m_pidHolderMC.parent)
               {
                  this.m_pidHolderMC.parent.removeChild(this.m_pidHolderMC);
               }
            }
            this.updateMatchStatistics();
            this.loseLife(param2);
            if(Boolean(this.m_human) && this.ID > 0)
            {
               Gamepad.rumbleOnKO(this.ID);
            }
            if(STAGEDATA.CrowdChantID == m_player_id)
            {
               STAGEDATA.stopCrowdChant();
               STAGEDATA.playSpecificVoice("crowd_clap_s");
            }
            if(!inState(CState.DEAD) && STAGEDATA.GameRef.GameMode != Mode.TARGET_TEST)
            {
               this.reset();
               m_sprite.x = this.m_playerSettings.x_respawn;
               m_sprite.y = this.m_playerSettings.y_respawn;
               this.setInvincibility(true);
               this.setState(CState.REVIVAL);
               if(this.m_characterStats.StatsName === "sandbag" && !this.m_human && STAGEDATA.GameRef.GameMode === Mode.ONLINE_WAITING_ROOM && Boolean(STAGEDATA.CamBounds))
               {
                  this.StandBy = true;
                  this.StandBy = false;
               }
            }
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.CHAR_KO_DEATH,{"caller":this.APIInstance.instance}));
         }
      }
      
      public function killCharacterStarKO() : void
      {
         var _loc1_:Point = null;
         var _loc2_:Boolean = false;
         var _loc3_:* = undefined;
         var _loc4_:Number = NaN;
         var _loc5_:Vector.<MovieClip> = null;
         if(!inState(CState.DEAD))
         {
            if(inState(CState.EGG))
            {
               this.egg(false);
            }
            if(inState(CState.FROZEN))
            {
               this.freeze(false);
            }
            this.resetMovement();
            this.m_recoveryAmount = 0;
            toggleEffect(this.m_healEffect,false);
            if(this.m_item2 != null)
            {
               this.m_item2.destroy();
               this.m_item2 = null;
            }
            if(this.m_item != null)
            {
               this.m_item.destroy();
               this.m_item = null;
            }
            toggleEffect(this.m_fsGlowHolderMC,false);
            this.playFrame("falling");
            if(this.m_pidHolderMC.parent)
            {
               this.m_pidHolderMC.parent.removeChild(this.m_pidHolderMC);
            }
            this.releaseOpponent();
            this.setVisibility(false);
            _loc1_ = new Point();
            _loc2_ = false;
            _loc3_ = 0;
            while(_loc3_ < STAGEDATA.Players.length)
            {
               if(Boolean(STAGEDATA.Players[_loc3_]) && Boolean(STAGEDATA.Players[_loc3_] != this) && STAGEDATA.Players[_loc3_].ScreenKO)
               {
                  _loc2_ = true;
               }
               _loc3_++;
            }
            if(!STAGEDATA.StarKOEnabled || Utils.random() < 0.25 && !_loc2_)
            {
               if(_loc2_)
               {
                  this.killCharacterDeathBounds();
               }
               else
               {
                  this.m_starKOTimer.reset();
                  this.m_starKOTimer.MaxTime = 60;
                  _loc1_ = new Point(CAM.MainTerrain.x + CAM.MainTerrain.width / 2,CAM.MainTerrain.y);
                  _loc1_ = STAGE.localToGlobal(_loc1_);
                  _loc1_ = STAGEPARENT.globalToLocal(_loc1_);
                  this.m_screenKOHolder.x = _loc1_.x;
                  this.m_screenKOHolder.y = _loc1_.y;
                  this.m_screenKOHolder.gotoAndStop(1);
                  this.m_screenKOHolder.visible = true;
                  this.m_screenKO = true;
                  this.setState(CState.SCREEN_KO);
                  if(Boolean(this.m_human) && this.ID > 0)
                  {
                     Gamepad.rumbleOnStarKO(this.ID);
                  }
                  if(Boolean(this.m_starKOMC) && Boolean(this.m_starKOMC.parent))
                  {
                     this.m_starKOMC.parent.removeChild(this.m_starKOMC);
                  }
                  this.m_starKOMC = null;
                  this.m_starKOMC = ResourceManager.getLibraryMC(this.m_characterStats.LinkageID);
                  this.m_starKOMC.uid = m_uid;
                  MovieClip(this.m_screenKOHolder.getChildByName("char")).addChild(this.m_starKOMC);
                  Utils.tryToGotoAndStop(this.m_starKOMC,"falling");
                  Utils.tryToGotoAndStop(this.m_starKOMC,"screenko");
                  if(STAGEDATA.getQualitySettings().fullscreen_quality === 1 && Boolean(Main.isFullscreen))
                  {
                     this.m_starKOMC.filters = [];
                  }
                  else if(this.m_starKOMC)
                  {
                     applyPalette(this.m_starKOMC);
                  }
                  Utils.recursiveMovieClipPlay(this.m_starKOMC,false);
                  STAGEPARENT.addChild(this.m_screenKOHolder);
               }
            }
            else
            {
               this.m_starKOTimer.reset();
               this.m_starKOTimer.MaxTime = 90;
               _loc4_ = m_sprite.x;
               if(m_sprite.x < CAM.MainTerrain.x)
               {
                  m_sprite.x = CAM.MainTerrain.x + 150;
               }
               else if(m_sprite.x > CAM.MainTerrain.x + CAM.MainTerrain.width)
               {
                  m_sprite.x = CAM.MainTerrain.x + CAM.MainTerrain.width - 150;
               }
               else
               {
                  m_sprite.x += Utils.randomInteger(-50,50);
               }
               _loc1_ = new Point(m_sprite.x,CAM.MainTerrain.y - m_height * 0.5);
               m_sprite.y = CAM.MainTerrain.y;
               _loc1_ = STAGE.localToGlobal(_loc1_);
               _loc1_ = STAGEPARENT.globalToLocal(_loc1_);
               this.m_starKOHolder.x = _loc1_.x;
               this.m_starKOHolder.y = _loc1_.y;
               this.m_starKOHolder.y += m_height * 0.5;
               this.m_starKOHolder.gotoAndStop(1);
               this.m_starKOHolder.visible = true;
               this.m_screenKO = false;
               this.setState(CState.STAR_KO);
               if(Boolean(this.m_starKOMC) && Boolean(this.m_starKOMC.parent))
               {
                  this.m_starKOMC.parent.removeChild(this.m_starKOMC);
               }
               this.m_starKOMC = null;
               this.m_starKOMC = ResourceManager.getLibraryMC(this.m_characterStats.LinkageID);
               this.m_starKOMC.uid = m_uid;
               MovieClip(this.m_starKOHolder.getChildByName("char")).addChild(this.m_starKOMC);
               Utils.tryToGotoAndStop(this.m_starKOMC,"falling");
               Utils.tryToGotoAndStop(this.m_starKOMC,"starko");
               applyPalette(this.m_starKOMC);
               Utils.recursiveMovieClipPlay(this.m_starKOMC,false);
               if(STAGEDATA.GameRef.LevelData.stage === "butterbuilding")
               {
                  STAGEPARENT.addChildAt(this.m_starKOHolder,0);
               }
               else
               {
                  STAGEPARENT.addChildAt(this.m_starKOHolder,STAGE.parent.getChildIndex(STAGE));
               }
            }
            if(this.m_starKOTimer.MaxTime == 90 && CAM.Mode == Vcam.NORMAL_MODE)
            {
               _loc5_ = new Vector.<MovieClip>();
               _loc5_.push(m_sprite);
               STAGEDATA.CamRef.addTargets(_loc5_);
            }
            this.m_respawnDelay.reset();
            this.setInvincibility(true);
         }
      }
      
      private function m_flipDirection() : void
      {
         if(this.inFreeState(CFreeState.SWALLOWING | CFreeState.NON_IASA) && !inState(CState.CROUCH) && !inState(CState.DASH) && !inState(CState.DASH_INIT) && !inState(CState.TURN) && m_collision.ground && !this.isLandingOrSkiddingOrChambering())
         {
            if(Boolean(this.m_heldControls.RIGHT) && !m_facingForward && !this.m_heldControls.LEFT)
            {
               m_faceRight();
               m_facingForward = true;
            }
            else if(Boolean(this.m_heldControls.LEFT) && m_facingForward && !this.m_heldControls.RIGHT)
            {
               m_faceLeft();
               m_facingForward = false;
            }
         }
      }
      
      private function adjustTags(param1:Point) : void
      {
         var _loc2_:Point = null;
         _loc2_ = STAGE.localToGlobal(new Point(param1.x,param1.y));
         this.m_pidHolderMC.x = _loc2_.x;
         this.m_pidHolderMC.y = _loc2_.y;
      }
      
      private function m_checkBounds() : void
      {
         var _loc1_:Point = null;
         var _loc2_:Point = null;
         var _loc3_:Boolean = false;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         _loc1_ = null;
         _loc2_ = null;
         _loc3_ = Boolean(this.m_outsideMainTerrain);
         _loc4_ = m_width / 2;
         _loc5_ = -m_width / 2;
         _loc6_ = -m_height;
         _loc7_ = 0;
         _loc4_ *= m_sizeRatio;
         _loc6_ *= m_sizeRatio;
         _loc4_ *= m_sizeRatio;
         _loc7_ *= m_sizeRatio;
         this.m_outsideMainTerrain = Boolean(STAGEDATA.CamBounds) && (m_sprite.x + _loc4_ < STAGEDATA.CamBounds.x || m_sprite.x + _loc5_ > STAGEDATA.CamBounds.x + STAGEDATA.CamBounds.width || m_sprite.y + _loc6_ < STAGEDATA.CamBounds.y || m_sprite.y + _loc7_ > STAGEDATA.CamBounds.y + STAGEDATA.CamBounds.height);
         this.m_outsideCameraBounds = Boolean(STAGEDATA.CamBounds) && (OverlayX + _loc4_ < STAGEDATA.CamRef.CornerX || OverlayX + _loc5_ > STAGEDATA.CamRef.CornerX + STAGEDATA.CamRef.Width || OverlayY + _loc7_ < STAGEDATA.CamRef.CornerY || OverlayY + _loc6_ > STAGEDATA.CamRef.CornerY + STAGEDATA.CamRef.Height);
         if(!this.m_pidHolderMC.parent && !inState(CState.REVIVAL) && !inState(CState.DEAD) && !inState(CState.STAR_KO) && !inState(CState.SCREEN_KO) && !STAGEDATA.StageEvent && !STAGEDATA.FreezeKeys)
         {
            if(Boolean(this.m_offScreenIndicatorEnabled) && m_player_id > 0 && (Boolean(this.m_outsideCameraBounds) || Boolean((this.m_showPlayerID || this.m_playerSettings.name) && !inState(CState.DEAD) && !inState(CState.REVIVAL))))
            {
               this.m_pidHolderMC.pid.text = Boolean(this.m_showPlayerID) && !this.m_playerSettings.name ? "P" + m_player_id : "";
               this.m_pidHolderMC.offScreenBubble.visible = false;
               this.m_pidHolderMC.x = m_sprite.x;
               this.m_pidHolderMC.y = m_sprite.y - m_height - 20;
               this.m_pidHolderMC.scaleX = 1;
               this.m_pidHolderMC.scaleY = 1;
               this.m_pidHolderMC.width *= m_sizeRatio;
               this.m_pidHolderMC.height *= m_sizeRatio;
               _loc1_ = STAGE.localToGlobal(new Point(this.m_pidHolderMC.x,this.m_pidHolderMC.y));
               _loc2_ = STAGE.localToGlobal(new Point(m_sprite.x,m_sprite.y - m_height));
               this.m_pidHolderMC.arrow.rotation = 270 - Utils.getAngleBetween(_loc1_,_loc2_);
               STAGEDATA.TagsRef.addChild(this.m_pidHolderMC);
               this.adjustTags(new Point(this.m_pidHolderMC.x,this.m_pidHolderMC.y));
            }
         }
         if(this.m_pidHolderMC.parent)
         {
            if(!this.m_outsideCameraBounds && (STAGEDATA.StageEvent || !this.m_showPlayerID && !this.m_playerSettings.name))
            {
               this.m_pidHolderMC.parent.removeChild(this.m_pidHolderMC);
            }
            else if(OverlayX > STAGEDATA.CamRef.CornerX && OverlayX < STAGEDATA.CamRef.CornerX + STAGEDATA.CamRef.Width && OverlayY > STAGEDATA.CamRef.CornerY && OverlayY < STAGEDATA.CamRef.CornerY + STAGEDATA.CamRef.Height && Boolean(this.m_showPlayerID))
            {
               this.m_pidHolderMC.x = m_sprite.x;
               this.m_pidHolderMC.y = m_sprite.y - m_height - 20;
               _loc1_ = STAGE.localToGlobal(new Point(this.m_pidHolderMC.x,this.m_pidHolderMC.y));
               _loc2_ = STAGE.localToGlobal(new Point(m_sprite.x,m_sprite.y - m_height));
               this.m_pidHolderMC.arrow.rotation = 270 - Utils.getAngleBetween(_loc1_,_loc2_);
               this.adjustTags(new Point(this.m_pidHolderMC.x,this.m_pidHolderMC.y));
            }
            else
            {
               this.m_pidHolderMC.x = m_sprite.x;
               this.m_pidHolderMC.y = m_sprite.y - m_sizeRatio * 70;
               if(OverlayX < STAGEDATA.CamRef.X - STAGEDATA.CamRef.Width / 2 + 25)
               {
                  this.m_pidHolderMC.x = STAGEDATA.CamRef.X - STAGEDATA.CamRef.Width / 2 + 50 - STAGE.x;
               }
               else if(OverlayX > STAGEDATA.CamRef.X + STAGEDATA.CamRef.Width / 2 - 25)
               {
                  this.m_pidHolderMC.x = STAGEDATA.CamRef.X + STAGEDATA.CamRef.Width / 2 - 50 - STAGE.x;
               }
               if(OverlayY - m_sizeRatio * m_height / 2 < STAGEDATA.CamRef.Y - STAGEDATA.CamRef.Height / 2 + 25)
               {
                  this.m_pidHolderMC.y = STAGEDATA.CamRef.Y - STAGEDATA.CamRef.Height / 2 + 100 - STAGE.y;
               }
               else if(OverlayY - m_sizeRatio * m_height > STAGEDATA.CamRef.Y + STAGEDATA.CamRef.Height / 2 - 25)
               {
                  this.m_pidHolderMC.y = STAGEDATA.CamRef.Y + STAGEDATA.CamRef.Height / 2 - 25 - STAGE.y;
               }
               _loc1_ = STAGE.localToGlobal(new Point(this.m_pidHolderMC.x,this.m_pidHolderMC.y));
               _loc2_ = STAGE.localToGlobal(new Point(m_sprite.x,m_sprite.y - m_height));
               this.m_pidHolderMC.arrow.rotation = 270 - Utils.getAngleBetween(_loc1_,_loc2_);
               this.adjustTags(new Point(this.m_pidHolderMC.x,this.m_pidHolderMC.y));
            }
         }
         if(Boolean(this.m_outsideMainTerrain) && Boolean(ModeFeatures.hasFeature(ModeFeatures.OFFSCREEN_DAMAGE,STAGEDATA.GameRef.GameMode)))
         {
            if(!_loc3_ || Boolean(this.m_standby) || inState(CState.STAR_KO) || inState(CState.SCREEN_KO) || inState(CState.DEAD))
            {
               this.m_offscreenDamageTimer.reset();
            }
            this.m_offscreenDamageTimer.tick();
            if(this.m_offscreenDamageTimer.IsComplete)
            {
               this.damageSelf(1);
               throbDamageCounter();
               this.m_offscreenDamageTimer.reset();
            }
         }
      }
      
      private function setVar(param1:String, param2:*) : void
      {
         m_sprite[param1] = param2;
      }
      
      public function setStanceVar(param1:String, param2:*) : void
      {
         if(HasStance)
         {
            m_sprite.stance[param1] = param2;
         }
         else
         {
            trace("Stance var missing? " + param1 + "-" + param2);
         }
      }
      
      override public function playFrame(param1:String) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         if(m_delayPlayback)
         {
            m_delayPlayBackAnimation = param1;
            m_delayPlayBackFrame = null;
            return;
         }
         m_delayPlayBackAnimation = null;
         m_delayPlayBackFrame = null;
         if(HasStance)
         {
            m_sprite.stance.stop();
         }
         _loc2_ = !currentFrameIs(param1);
         _loc3_ = m_sprite.xframe != null && param1 == m_sprite.xframe;
         if(!currentFrameIs(param1))
         {
            m_currentAnimationID = param1;
            m_previousAnimation = CurrentFrame;
            m_sprite.gotoAndStop(param1);
         }
         if(_loc3_)
         {
         }
         if(_loc2_)
         {
            this.updateItemHolding();
            this.updatePaletteSwap();
            refreshAttackID();
            this.checkReflection();
         }
      }
      
      override public function stancePlayFrame(param1:*) : void
      {
         if(m_delayPlayback)
         {
            m_delayPlayBackFrame = param1;
            return;
         }
         if(HasStance && (param1 is Number || param1 is String))
         {
            m_sprite.stance.gotoAndStop(param1);
            this.updatePaletteSwap();
            this.checkReflection();
         }
      }
      
      private function restartStance() : void
      {
         if(HasStance)
         {
            m_sprite.stance.gotoAndStop(1);
         }
      }
      
      private function m_checkFinalForm() : void
      {
         if(this.m_transformedSpecial)
         {
            if(this.m_transformTime >= this.m_transformLimit)
            {
               this.endFinalForm();
            }
            else
            {
               if(!currentFrameIs("special") && !this.m_characterStats.UnlimitedFinal)
               {
                  ++this.m_transformTime;
               }
               if(m_healthBoxMC)
               {
                  m_healthBoxMC.fsmeter.bar.scaleX = (this.m_transformLimit - this.m_transformTime) / this.m_transformLimit;
               }
            }
         }
      }
      
      private function resetChargedAttacks() : void
      {
         var _loc1_:* = undefined;
         for(_loc1_ in m_attack.ChargedAttacks)
         {
            m_attack.ChargedAttacks[_loc1_] = null;
         }
      }
      
      private function attackIsCharged(param1:String) : Boolean
      {
         var _loc2_:AttackObject = null;
         _loc2_ = m_attackData.getAttack(param1);
         if(m_attack.ChargedAttacks[param1])
         {
            return true;
         }
         if(Boolean(_loc2_) && Boolean(_loc2_.LinkCharge) && Boolean(m_attack.ChargedAttacks[_loc2_.LinkCharge]))
         {
            return true;
         }
         return false;
      }
      
      private function setCharge(param1:String, param2:String = null) : void
      {
         m_attack.ChargedAttacks[param1] = true;
         if(param2)
         {
            m_attack.ChargedAttacks[param2] = true;
         }
      }
      
      private function incrementHitsDealtCounter() : void
      {
         ++this.m_hitsDealtCounter;
      }
      
      private function incrementCharge(param1:String, param2:String = null) : void
      {
         var _loc3_:Number = NaN;
         ++m_attackData.getAttack(param1).ChargeTime;
         if(Boolean(this.m_human) && this.ID > 0)
         {
            _loc3_ = m_attackData.getAttack(param1).ChargeTime / m_attackData.getAttack(param1).ChargeTimeMax * 100;
            if(_loc3_ >= 25 && _loc3_ < 50)
            {
               Gamepad.rumbleForPlayer(this.ID,0.3,0.4,150);
            }
            else if(_loc3_ >= 50 && _loc3_ < 75)
            {
               Gamepad.rumbleForPlayer(this.ID,0.4,0.4,130);
            }
            else if(_loc3_ >= 75 && _loc3_ < 100)
            {
               Gamepad.rumbleForPlayer(this.ID,0.5,0.4,110);
            }
            else if(_loc3_ >= 100)
            {
               Gamepad.rumbleForPlayer(this.ID,0.7,0.5,90);
            }
         }
         m_attack.ChargeTime = m_attackData.getAttack(param1).ChargeTime;
         if(param2)
         {
            ++m_attackData.getAttack(param2).ChargeTime;
         }
      }
      
      private function unsetCharge(param1:String) : void
      {
         var _loc2_:AttackObject = null;
         var _loc3_:AttackObject = null;
         _loc2_ = m_attackData.getAttack(param1);
         _loc3_ = _loc2_ ? m_attackData.getAttack(_loc2_.LinkCharge) : null;
         if(_loc2_)
         {
            m_attack.ChargedAttacks[param1] = false;
            _loc2_.ChargeTime = 0;
         }
         if(_loc3_)
         {
            m_attack.ChargedAttacks[_loc3_.Name] = false;
            _loc3_.ChargeTime = 0;
         }
      }
      
      private function releaseKirbyPower(param1:Boolean = false) : void
      {
         var _loc2_:MovieClip = null;
         if(this.m_currentPower != null)
         {
            m_attack.ChargedAttacks = new Object();
            m_attackData.resetCharges();
            this.removeChargeGlow();
            this.m_currentPower = null;
            if(HasHatBox)
            {
               m_sprite.stance.hatBox.visible = false;
            }
            if(param1)
            {
               _loc2_ = STAGEDATA.attachEffectOverlay("kirby_powerstar");
               _loc2_.width *= m_sizeRatio;
               _loc2_.height *= m_sizeRatio;
               if(!m_facingForward)
               {
                  _loc2_.scaleX *= -1;
               }
               _loc2_.x = OverlayX;
               _loc2_.y = OverlayY - 10 * m_sizeRatio;
               this.playGlobalSound("kirby_losepower");
            }
         }
      }
      
      private function initTaunt() : void
      {
         if(inState(CState.ATTACKING))
         {
            this.forceEndAttack();
         }
         this.setState(CState.TAUNT);
         if(!this.m_heldControls.UP && !this.m_heldControls.DOWN && !this.m_heldControls.LEFT && !this.m_heldControls.RIGHT)
         {
            if(Utils.hasLabel(Stance,"taunt_neutral"))
            {
               this.stancePlayFrame("taunt_neutral");
            }
         }
         else if(Boolean(this.m_heldControls.UP) || Boolean(this.m_heldControls.DOWN))
         {
            if(Utils.hasLabel(Stance,"taunt_updown"))
            {
               this.stancePlayFrame("taunt_updown");
            }
         }
         else if(Boolean(this.m_heldControls.LEFT) || Boolean(this.m_heldControls.RIGHT))
         {
            if(Utils.hasLabel(Stance,"taunt_side"))
            {
               this.stancePlayFrame("taunt_side");
            }
         }
         this.m_crouchFrame = -1;
         if(this.m_characterStats.LinkageID == "kirby")
         {
            this.releaseKirbyPower(true);
         }
      }
      
      public function forceTaunt() : void
      {
         if(!inState(CState.DEAD) && !inState(CState.STAMINA_KO) && !STAGEDATA.Paused && !STAGEDATA.FSCutscene && STAGEDATA.FSCutins <= 0 && !STAGEDATA.StageEvent && !this.m_standby)
         {
            if(this.inFreeState(CFreeState.ATTACKING | CFreeState.USING_FS) && !(Boolean(this.m_usingSpecialAttack) && (this.m_characterStats.SpecialType !== 0 || currentFrameIs("special"))) && !this.isNonInterruptableAttack(CFreeState.USING_FS) && m_collision.ground && !this.isLandingOrSkiddingOrChambering() && Boolean(this.m_characterStats.CanTaunt))
            {
               this.initTaunt();
            }
         }
      }
      
      private function m_checkTaunt() : void
      {
         if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
         {
            return;
         }
         if(!m_collision.ground && inState(CState.TAUNT))
         {
            this.setState(CState.IDLE);
         }
         if(Boolean(this.m_pressedControls.TAUNT) && this.inFreeState(CFreeState.ATTACKING) && !this.isNonInterruptableAttack() && m_collision.ground && !this.isLandingOrSkiddingOrChambering() && Boolean(this.m_characterStats.CanTaunt))
         {
            this.initTaunt();
         }
      }
      
      private function isNonInterruptableAttack(param1:uint = 0) : Boolean
      {
         return inState(CState.ATTACKING | param1) && !m_attack.AllowFullInterrupt && !m_attack.IASA;
      }
      
      private function isInterruptableAttack(param1:uint = 0) : Boolean
      {
         return inState(CState.ATTACKING | param1) && (m_attack.AllowFullInterrupt || m_attack.IASA);
      }
      
      private function getLastYPosition() : void
      {
         this.m_lastYPosition = m_sprite.y - this.netYSpeed();
      }
      
      public function updateMatchResults() : void
      {
         if(!inState(CState.DEAD) && !inState(CState.STAMINA_KO) && !STAGEDATA.GameEnded)
         {
            ++this.m_matchResults.SurvivalTime;
            ++this.m_droughtTimer;
            this.m_matchResults.DamageRemaining = m_damage;
         }
      }
      
      private function checkHitLag() : void
      {
         if(!isHitStunOrParalysis() && this.m_hitLag > 0)
         {
            --this.m_hitLag;
            this.m_hitLagStunTimer.tick();
            if(m_collision.ground && inState(CState.INJURED) && this.netYSpeed() >= 0 && !this.m_hitLagLandDelay.IsComplete)
            {
               this.m_hitLag = 0;
            }
         }
         else if(!isHitStunOrParalysis() && this.m_hitLag <= 0)
         {
            this.m_hitLagLandDelay.finish();
         }
         if(!isHitStunOrParalysis())
         {
            if(this.m_hitLag > 0 && !this.m_hitLagCancelTimer.IsComplete && !m_collision.ground)
            {
               if(Boolean(this.m_hitLagCanCancelWithJump) && this.jumpIsPressed())
               {
                  this.m_hitLagCanCancelWithJump = false;
               }
               if(Boolean(this.m_hitLagCanCancelWithUpB) && Boolean(this.m_heldControls.UP) && Boolean(this.m_heldControls.BUTTON1))
               {
                  this.m_hitLagCanCancelWithUpB = false;
               }
               this.m_hitLagCancelTimer.tick();
            }
            if(this.m_hitLag > 0 && Boolean(this.m_hitLagCancelTimer.IsComplete) && (inState(CState.INJURED) || inState(CState.FLYING)) && !m_collision.ground)
            {
               if(Boolean(this.m_hitLagCanCancelWithUpB) && Boolean(this.m_heldControls.UP) && Boolean(this.m_heldControls.BUTTON1) && !(this.HoldingItem && !this.m_item.CanAttackWith))
               {
                  m_yKnockback = 0;
                  resetKnockbackDecay();
                  this.setState(CState.IDLE);
                  this.Attack("b_up_air",2);
                  this.m_hitLagCanCancelWithUpB = false;
                  this.clearControlsBuffer();
               }
               else if(Boolean(this.m_hitLagCanCancelWithJump) && this.jumpIsPressed() && !m_collision.ground && !(this.HoldingItem && !this.m_item.CanJumpWith) && this.m_jumpCount < this.m_characterStats.MaxJump && (Boolean(this.m_jumpSpeedMidairDelay.IsComplete) || Boolean(this.m_characterStats.HoldJump)) && !(this.m_jumpCount > 2 && !this.m_multiJumpDelay.IsComplete))
               {
                  this.initMidairJump();
                  this.m_hitLagCanCancelWithJump = false;
               }
            }
         }
      }
      
      private function positionEffects() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         _loc1_ = inState(CState.LEDGE_HANG) ? m_sprite.x : m_sprite.x;
         _loc2_ = inState(CState.LEDGE_HANG) ? m_sprite.y + m_height : m_sprite.y;
         if(this.m_poisonIncrease > 0)
         {
            this.m_poisonEffect.x = _loc1_ - m_width / 3 * m_sizeRatio;
            this.m_poisonEffect.y = _loc2_ - m_height * m_sizeRatio;
            if(Boolean(m_sprite.parent) && Boolean(this.m_poisonEffect.parent) && this.m_poisonEffect.parent.getChildIndex(this.m_poisonEffect) < m_sprite.parent.getChildIndex(m_sprite))
            {
               Utils.swapDepths(m_sprite,this.m_poisonEffect);
            }
         }
         if(!this.m_burnSmokeTimer.IsComplete)
         {
            this.m_burnSmoke.x = _loc1_;
            this.m_burnSmoke.y = _loc2_ - m_height * m_sizeRatio / 2;
            if(Boolean(m_sprite.parent) && Boolean(this.m_burnSmoke.parent) && this.m_burnSmoke.parent.getChildIndex(this.m_burnSmoke) < m_sprite.parent.getChildIndex(m_sprite))
            {
               Utils.swapDepths(m_sprite,this.m_burnSmoke);
            }
         }
         if(!this.m_darknessSmokeTimer.IsComplete)
         {
            this.m_darknessSmoke.x = _loc1_;
            this.m_darknessSmoke.y = _loc2_ - m_height * m_sizeRatio / 2;
            if(Boolean(m_sprite.parent) && Boolean(this.m_darknessSmoke.parent) && this.m_darknessSmoke.parent.getChildIndex(this.m_darknessSmoke) < m_sprite.parent.getChildIndex(m_sprite))
            {
               Utils.swapDepths(m_sprite,this.m_darknessSmoke);
            }
         }
         if(!this.m_auraSmokeTimer.IsComplete)
         {
            this.m_auraSmoke.x = _loc1_;
            this.m_auraSmoke.y = _loc2_ - m_height * m_sizeRatio / 2;
            if(Boolean(m_sprite.parent) && Boolean(this.m_auraSmoke.parent) && this.m_auraSmoke.parent.getChildIndex(this.m_auraSmoke) < m_sprite.parent.getChildIndex(m_sprite))
            {
               Utils.swapDepths(m_sprite,this.m_auraSmoke);
            }
         }
         if(Boolean(this.m_warioWareIcon) && !this.m_warioWareIconTimer.IsComplete)
         {
            this.m_warioWareIcon.x = _loc1_;
            this.m_warioWareIcon.y = _loc2_ - m_height / 2;
            if(Boolean(m_sprite.parent) && Boolean(this.m_warioWareIcon.parent) && this.m_warioWareIcon.parent.getChildIndex(this.m_warioWareIcon) < m_sprite.parent.getChildIndex(m_sprite))
            {
               Utils.swapDepths(m_sprite,this.m_warioWareIcon);
            }
         }
         if(!this.m_starmanInvincibilityTimer.IsComplete)
         {
            this.m_starmanInvincibility.x = _loc1_;
            this.m_starmanInvincibility.y = _loc2_ - m_height * m_sizeRatio / 2;
            if(Boolean(m_sprite.parent) && Boolean(this.m_starmanInvincibility.parent) && this.m_starmanInvincibility.parent.getChildIndex(this.m_starmanInvincibility) < m_sprite.parent.getChildIndex(m_sprite))
            {
               Utils.swapDepths(m_sprite,this.m_starmanInvincibility);
            }
         }
         if(inState(CState.KIRBY_STAR))
         {
            this.m_kirbyStarMC.x = m_sprite.x;
            this.m_kirbyStarMC.y = m_sprite.y;
         }
         if(inState(CState.EGG))
         {
            this.m_yoshiEggMC.x = m_sprite.x;
            this.m_yoshiEggMC.y = m_sprite.y;
         }
         if(inState(CState.FROZEN))
         {
            this.m_freezeMC.x = m_sprite.x;
            this.m_freezeMC.y = m_sprite.y;
            this.m_freezeMC.rotation = m_sprite.rotation;
         }
         this.repositionEffects();
      }
      
      private function checkFrameControl() : void
      {
         if(inState(CState.JUMP_RISING) || inState(CState.JUMP_MIDAIR_RISING))
         {
            if(m_ySpeed >= -5 && getStanceVar("done",true) && !(this.m_midAirJumpConstantTime.MaxTime > 0 && !this.m_midAirJumpConstantTime.IsComplete))
            {
               this.resetRotation();
               this.m_fallTiltTimer.reset();
               Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
               this.setState(CState.JUMP_FALLING);
            }
         }
         if(inState(CState.DIZZY))
         {
            if(!m_collision.ground)
            {
               this.playFrame("falling");
            }
            else if(currentFrameIs("falling"))
            {
               this.initiateCrash();
               this.m_forcedCrash = true;
               this.m_crashTimer.reset();
               this.m_getUpTimer.reset();
            }
            else if(!currentFrameIs("crash"))
            {
               this.playFrame("dizzy");
            }
         }
         if((inState(CState.CRASH_LAND) || inState(CState.CRASH_GETUP) || inState(CState.ROLL) || inState(CState.TECH_ROLL) || inState(CState.TECH_GROUND)) && !m_collision.ground)
         {
            if(inState(CState.ROLL) || inState(CState.TECH_ROLL))
            {
               m_xSpeed = 0;
            }
            this.setState(CState.IDLE);
         }
         if(inState(CState.AIR_DODGE))
         {
            if(m_collision.ground)
            {
               if(!(m_currentPlatform != null && m_currentPlatform.accel_friction != 1))
               {
                  this.killAllSpeeds(false,true);
               }
               this.playFrame("land");
               this.setState(CState.LAND);
               if(Boolean(this.m_human) && this.ID > 0)
               {
                  Gamepad.rumbleOnLand(this.ID,Math.abs(m_ySpeed + m_yKnockback));
               }
               Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
               this.m_waveLand = true;
            }
         }
         if(inState(CState.TUMBLE_FALL))
         {
            if(m_collision.ground)
            {
               this.initiateCrash();
            }
         }
         if(inState(CState.SHIELDING))
         {
            this.m_resizeShield();
         }
      }
      
      override protected function checkTimers() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         super.checkTimers();
         this.m_jumpJustChambered = false;
         this.m_justFellThroughPlatform = false;
         if(inState(CState.CAUGHT))
         {
            m_knockbackStackingTimer.reset();
         }
         if(!this.m_invisibleTimer.IsComplete)
         {
            this.m_invisibleTimer.tick();
            if(this.m_invisibleTimer.IsComplete)
            {
               this.setVisibility(true);
            }
         }
         if(!inState(CState.CRASH_GETUP) && !inState(CState.CRASH_LAND))
         {
            if(!this.m_jabResetTimer.IsComplete)
            {
               this.m_jabResetTimer.tick();
               if(this.m_jabResetTimer.IsComplete)
               {
                  this.m_jabResets = 0;
               }
            }
         }
         if(Boolean(this.m_characterStats.FinalSmashMeter) && !this.m_finalSmashMeterReady && !this.m_transformedSpecial && !this.m_usingSpecialAttack)
         {
            this.FinalSmashMeterCharge += 1 / ((9 * 60 + 16) * 30);
         }
         this.m_starKOTimer.tick();
         if(!this.m_injureFlashTimer.IsComplete)
         {
            this.m_injureFlashTimer.tick();
            if(this.m_injureFlashTimer.IsComplete)
            {
               setTint(1,1,1,1,0,0,0,0);
            }
         }
         if(inState(CState.FLYING))
         {
            if(Boolean(this.m_ricochetX.IsComplete) && Boolean(this.m_ricochetY.IsComplete))
            {
               this.m_ricochetTimer.tick();
            }
            _loc5_ = !this.m_ricochetX.IsComplete;
            _loc6_ = !this.m_ricochetY.IsComplete;
            this.m_ricochetX.tick();
            this.m_ricochetY.tick();
            if(_loc5_ && Boolean(this.m_ricochetX.IsComplete))
            {
               m_xKnockback *= -0.85;
               if(!(_loc6_ && Boolean(this.m_ricochetY.IsComplete)))
               {
                  m_yKnockback *= 0.85;
               }
               if(m_xKnockback > 0)
               {
                  faceRight();
               }
               else if(m_xKnockback < 0)
               {
                  faceLeft();
               }
               if(m_ySpeed > 0)
               {
                  m_ySpeed = 0;
               }
               resetKnockbackDecay();
            }
            if(_loc6_ && Boolean(this.m_ricochetY.IsComplete))
            {
               if(!(_loc5_ && Boolean(this.m_ricochetX.IsComplete)))
               {
                  m_xKnockback *= 0.85;
               }
               m_yKnockback *= -0.85;
               m_ySpeed = 0;
               resetKnockbackDecay();
               if(this.isRocketing())
               {
                  this.m_rocketAngle = Utils.forceBase360(-this.m_rocketAngle);
                  this.fixRocketRotation();
               }
            }
         }
         if(inState(CState.TUMBLE_FALL) || inState(CState.JUMP_FALLING))
         {
            if(this.m_heldControls.RIGHT != this.m_heldControls.LEFT)
            {
               if(Boolean(this.m_heldControls.RIGHT) && !this.m_fallTiltRight)
               {
                  m_sprite.rotation *= 0.5;
                  if(Utils.fastAbs(m_sprite.rotation) <= 1)
                  {
                     this.resetRotation();
                     this.m_fallTiltTimer.reset();
                     this.m_fallTiltRight = true;
                  }
               }
               else if(Boolean(this.m_heldControls.LEFT) && Boolean(this.m_fallTiltRight))
               {
                  m_sprite.rotation *= 0.5;
                  if(Utils.fastAbs(m_sprite.rotation) <= 1)
                  {
                     this.resetRotation();
                     this.m_fallTiltTimer.reset();
                     this.m_fallTiltRight = false;
                  }
               }
               else
               {
                  this.m_fallTiltTimer.tick();
                  _loc7_ = inState(CState.TUMBLE_FALL) ? 30 : 6;
                  if(inState(CState.JUMP_FALLING))
                  {
                     this.m_fallTiltTimer.tick();
                     this.m_fallTiltTimer.tick();
                  }
                  m_sprite.rotation = _loc7_ * (this.m_fallTiltTimer.CurrentTime / this.m_fallTiltTimer.MaxTime);
                  if(!this.m_fallTiltRight)
                  {
                     m_sprite.rotation *= -1;
                  }
               }
            }
            else if(Utils.fastAbs(m_sprite.rotation) > 1)
            {
               m_sprite.rotation *= 0.5;
               if(Utils.fastAbs(m_sprite.rotation) <= 1)
               {
                  m_sprite.rotation = 0;
               }
            }
         }
         if(Boolean(m_player_id == 1 && Main.DEBUG) && Boolean(MenuController.debugConsole) && Boolean(MenuController.debugConsole.ControlsCapture))
         {
            _loc8_ = int(this.m_key.getControlsObject().controls);
            if(this.m_attackControlsArr.length == 0 || this.m_attackControlsArr.length > 1 && _loc8_ != this.m_attackControlsArr[this.m_attackControlsArr.length - 2])
            {
               this.m_attackControlsArr.push(_loc8_);
               this.m_attackControlsArr.push(0);
            }
            ++this.m_attackControlsArr[this.m_attackControlsArr.length - 1];
         }
         this.m_fallthroughTimer.tick();
         if(Boolean(this.m_fallthroughTimer.IsComplete) || m_ySpeed < 0)
         {
            this.m_fallthroughTimer.finish();
            this.m_fallthroughPlatform = null;
         }
         if(!this.m_starmanInvincibilityTimer.IsComplete)
         {
            this.m_starmanInvincibilityTimer.tick();
            Utils.advanceFrame(this.m_starmanInvincibility);
            if(this.m_starmanInvincibilityTimer.IsComplete)
            {
               toggleEffect(this.m_starmanInvincibility,false);
               setBrightness(0);
            }
         }
         _loc1_ = Boolean(this.m_revivalInvincibility.IsComplete);
         this.m_revivalInvincibility.tick();
         if(Boolean(this.m_revivalInvincibility.IsComplete) && !_loc1_ && Boolean(this.m_starmanInvincibilityTimer.IsComplete))
         {
            setBrightness(0);
         }
         _loc2_ = 0;
         _loc3_ = 0;
         ++this.m_shieldStartTimer;
         this.m_getUpTimer.tick();
         this.m_crashTimer.tick();
         if(inState(CState.CRASH_LAND))
         {
            if(Boolean(this.m_getUpTimer.IsComplete) || (Boolean(this.m_pressedControls.UP) || Boolean(this.m_forcedCrash)) && Boolean(this.m_crashTimer.IsComplete))
            {
               this.setState(CState.CRASH_GETUP);
               this.stancePlayFrame("getup");
            }
            else if(m_collision.ground && !testTerrainWithCoord(m_sprite.x,m_sprite.y - 1))
            {
               if(Boolean(this.m_crashTimer.IsComplete) && (Boolean(this.m_pressedControls.BUTTON2) || Boolean(this.m_pressedControls.BUTTON1) || Boolean(this.m_pressedControls.C_UP) || Boolean(this.m_pressedControls.C_DOWN) || Boolean(this.m_pressedControls.C_LEFT) || Boolean(this.m_pressedControls.C_RIGHT)))
               {
                  this.Attack("getup_attack",1);
               }
            }
         }
         if(!isHitStunOrParalysis())
         {
            ++this.m_shieldTimer;
            if(!this.m_shieldDelayTimer.IsComplete)
            {
               this.m_shieldDelayTimer.tick();
               if(inState(CState.SHIELDING) && Boolean(this.m_shieldDelayTimer.IsComplete))
               {
                  if(!this.m_heldControls.SHIELD && !this.m_heldControls.SHIELD2 || (Boolean(this.m_heldControls.LEFT) || Boolean(this.m_heldControls.RIGHT) || Boolean(this.m_heldControls.DOWN)))
                  {
                     this.clearControlsBuffer();
                  }
               }
            }
         }
         this.m_turnTimer.tick();
         this.m_specialTurnTimer.tick();
         m_attackData.incrementAttackTimers(this);
         if(this.m_characterStats.DamageIncrease > 0)
         {
            this.m_damageIncreaseInterval.tick();
            if(this.m_damageIncreaseInterval.IsComplete)
            {
               this.dealDamage(this.m_characterStats.DamageIncrease);
               this.m_damageIncreaseInterval.reset();
            }
         }
         if(!this.m_poisonTintTimer.IsComplete)
         {
            setTint(0.31,1,0.65,1,0,25,0,0);
            this.m_poisonTintTimer.tick();
            if(this.m_poisonTintTimer.IsComplete)
            {
               setTint(1,1,1,1,0,0,0,0);
            }
         }
         if(this.m_poisonIncrease > 0)
         {
            this.m_poisonIncreaseInterval.tick();
            if(this.m_poisonIncreaseInterval.IsComplete)
            {
               if(!this.isInvincible())
               {
                  this.dealDamage(this.m_poisonIncrease);
                  throbDamageCounter();
               }
               this.m_poisonIncreaseInterval.reset();
            }
            this.m_poisonIncreaseTime.tick();
            if(this.m_poisonIncreaseTime.IsComplete)
            {
               this.m_poisonIncreaseTime.reset();
               this.m_poisonIncrease = 0;
               toggleEffect(this.m_poisonEffect,false);
            }
         }
         if(Boolean(this.m_warioWareIcon) && !this.m_warioWareIconTimer.IsComplete)
         {
            this.m_warioWareIconTimer.tick();
            Utils.advanceFrame(this.m_warioWareIcon);
            if(this.m_warioWareIconTimer.IsComplete)
            {
               toggleEffect(this.m_warioWareIcon,false);
            }
         }
         if(!this.m_shockEffectTimer.IsComplete)
         {
            setTint(0.82,0.82,0.82,1,9,0,46,0);
            this.m_shockEffectTimer.tick();
            if(this.m_shockEffectTimer.IsComplete)
            {
               setTint(1,1,1,1,0,0,0,0);
            }
         }
         if(!this.m_burnSmokeTimer.IsComplete)
         {
            Utils.advanceFrame(this.m_burnSmoke);
            this.m_burnSmokeTimer.tick();
            if(this.m_burnSmokeTimer.CurrentTime < 60)
            {
               setTint(0.79,0.63,0.63,1,57,0,0,0);
            }
            else if(this.m_burnSmokeTimer.CurrentTime == 60)
            {
               setTint(1,1,1,1,0,0,0,0);
            }
            if(this.m_burnSmokeTimer.IsComplete)
            {
               if(this.m_burnSmoke.parent != null)
               {
                  this.m_burnSmoke.parent.removeChild(this.m_burnSmoke);
               }
            }
         }
         if(!this.m_darknessSmokeTimer.IsComplete)
         {
            Utils.advanceFrame(this.m_darknessSmoke);
            this.m_darknessSmokeTimer.tick();
            if(this.m_darknessSmokeTimer.CurrentTime < 60)
            {
               setTint(0.75,0.75,0.75,1,15,2,21,0);
            }
            else if(this.m_darknessSmokeTimer.CurrentTime == 60)
            {
               setTint(1,1,1,1,0,0,0,0);
            }
            if(this.m_darknessSmokeTimer.IsComplete)
            {
               if(this.m_darknessSmoke.parent != null)
               {
                  this.m_darknessSmoke.parent.removeChild(this.m_darknessSmoke);
               }
            }
         }
         if(!this.m_auraSmokeTimer.IsComplete)
         {
            Utils.advanceFrame(this.m_auraSmoke);
            this.m_auraSmokeTimer.tick();
            if(this.m_auraSmokeTimer.CurrentTime < 60)
            {
               setTint(0.75,0.75,0.75,1,0,36,89,0);
            }
            else if(this.m_auraSmokeTimer.CurrentTime == 60)
            {
               setTint(1,1,1,1,0,0,0,0);
            }
            if(this.m_auraSmokeTimer.IsComplete)
            {
               if(this.m_auraSmoke.parent != null)
               {
                  this.m_auraSmoke.parent.removeChild(this.m_auraSmoke);
               }
            }
         }
         if(inState(CState.KIRBY_STAR))
         {
            --this.m_starTimer;
            if(this.m_starTimer < 0)
            {
               this.setIntangibility(false);
               this.endAttack();
               this.unnattachFromGround();
               this.killAllSpeeds(false,false);
               m_ySpeed = -12;
               toggleEffect(this.m_kirbyStarMC,false);
               this.setVisibility(true);
               this.resetRotation();
               this.m_fallTiltTimer.reset();
               this.setState(CState.JUMP_FALLING);
            }
            else
            {
               m_xSpeed = m_facingForward ? -15 : 15;
            }
         }
         --this.m_holdTimer;
         if(Boolean(this.m_charIsFull) && this.m_grabbed.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.m_grabbed.length)
            {
               _loc9_ = int(this.m_grabbed[_loc2_].Struggle());
               this.m_holdTimer -= _loc9_ > 0 ? _loc9_ : 0;
               _loc2_++;
            }
            if(this.m_holdTimer < 0)
            {
               this.m_holdTimer = 0;
            }
         }
         if(this.m_holdTimer <= 0 && Boolean(this.m_charIsFull))
         {
            if(this.m_grabbed.length > 0)
            {
               _loc3_ = 0;
               while(_loc3_ < this.m_grabbed.length)
               {
                  this.m_grabbed[_loc3_].setVisibility(true);
                  this.m_grabbed[_loc3_].Uncapture();
                  this.m_grabbed[_loc3_].unnattachFromGround();
                  this.m_grabbed[_loc3_].setYSpeed(-8);
                  _loc3_++;
               }
               this.m_grabbed = new Vector.<Character>();
               m_xSpeed = m_facingForward ? -9 : 9;
               this.restartStance();
            }
            this.m_charIsFull = false;
         }
         if(this.m_attackDelay > 0)
         {
            --this.m_attackDelay;
         }
         if(this.m_sizeStatus != 0 && !this.m_sizeStatusPermanent)
         {
            this.m_sizeStatusTimer.tick();
            if(this.m_sizeStatusTimer.IsComplete)
            {
               this.setSizeStatus(0);
            }
         }
         if(this.m_forceTransformTime.MaxTime > 0 && !inState(CState.SCREEN_KO) && !inState(CState.STAR_KO) && !inState(CState.DEAD) && !inState(CState.STAMINA_KO) && !inState(CState.REVIVAL) && !this.m_standby)
         {
            this.m_forceTransformTime.tick();
            if(this.m_forceTransformTime.IsComplete)
            {
               if(inState(CState.ATTACKING))
               {
                  this.forceEndAttack();
               }
               this.replaceCharacter(this.m_characterStats.ForceTransformID);
            }
         }
         if(inState(CState.LEDGE_HANG))
         {
            this.m_ledgeHangTimer.tick();
            if(this.m_ledgeHangTimer.CurrentTime >= 14)
            {
               this.turnOffInvincibility();
            }
            if(this.m_ledgeHangTimer.IsComplete)
            {
               m_ySpeed = 0;
               this.unnattachFromLedge();
               this.setState(CState.IDLE);
            }
            if(inState(CState.LEDGE_HANG) && (Boolean(this.m_pressedControls.BUTTON2) || Boolean(this.m_pressedControls.BUTTON1) || (Boolean(this.m_pressedControls.C_UP) || Boolean(this.m_pressedControls.C_DOWN) || Boolean(this.m_pressedControls.C_LEFT) || Boolean(this.m_pressedControls.C_RIGHT))) && this.m_ledgeHangTimer.CurrentTime > 4)
            {
               this.m_ledgeHangTimer.reset();
               m_sprite.x += m_facingForward ? 1 : -1;
               _loc10_ = 0;
               while(!this.testGroundWithCoord(m_sprite.x,m_sprite.y) && _loc10_ > 15)
               {
                  m_sprite.x += m_facingForward ? 1 : -1;
                  _loc10_ += 1;
               }
               if(_loc10_ >= 15)
               {
                  m_sprite.x -= m_facingForward ? _loc10_ : -_loc10_;
               }
               this.m_groundCollisionTest();
               this.Attack("ledge_attack",1);
            }
         }
         if(inState(CState.SHIELDING))
         {
            if(this.m_shieldDelay > 5 && !isHitStunOrParalysis() && Boolean(this.m_shieldDelayTimer.IsComplete))
            {
               this.m_shieldPower -= 0.56 * 2;
            }
            this.m_resizeShield();
            if(this.m_shieldPower <= 0)
            {
               this.m_breakShield();
            }
         }
         if(!this.m_heldControls.UP && !this.m_heldControls.DOWN && !this.m_heldControls.LEFT && !this.m_heldControls.RIGHT && !this.m_heldControls.BUTTON2 && !this.m_heldControls.BUTTON1 && !this.isLanding() && !this.isSkidding())
         {
            this.m_smashTimer = 0;
         }
         else
         {
            ++this.m_smashTimer;
         }
         if(!this.m_heldControls.UP && !this.m_heldControls.BUTTON2 && !this.m_heldControls.BUTTON1 && !this.isLanding() && !this.isSkidding())
         {
            this.m_smashTimerUp = 0;
         }
         else
         {
            ++this.m_smashTimerUp;
         }
         if(!this.m_heldControls.DOWN && !this.m_heldControls.BUTTON2 && !this.m_heldControls.BUTTON1 && !this.isLanding() && !this.isSkidding())
         {
            this.m_smashTimerDown = 0;
         }
         else
         {
            ++this.m_smashTimerDown;
         }
         if(!this.m_heldControls.RIGHT && !this.m_heldControls.LEFT && !this.m_heldControls.BUTTON2 && !this.m_heldControls.BUTTON1 && !this.isLanding() && !this.isSkidding())
         {
            this.m_smashTimerSide = 0;
         }
         else
         {
            ++this.m_smashTimerSide;
         }
         if(!this.m_heldControls.UP && !this.m_heldControls.BUTTON1 && !this.isLanding() && !this.isSkidding())
         {
            this.m_upSpecialTimer = 0;
         }
         else
         {
            ++this.m_smashTimerSide;
         }
         if(this.isLanding())
         {
            this.killSmashTimers();
         }
         if(inState(CState.HOVER) || Boolean(this.m_attackHovering))
         {
            this.m_midAirHoverTime.tick();
            if(Boolean(this.m_midAirHoverTime.IsComplete) || !this.m_heldControls.UP && !this.jumpIsHeld())
            {
               if(!this.m_attackHovering)
               {
                  this.setState(CState.IDLE);
               }
               this.m_attackHovering = false;
            }
         }
         this.m_midAirJumpConstantDelay.tick();
         if(Boolean(this.m_midAirJumpConstantDelay.IsComplete) && !m_actionShot)
         {
            this.m_midAirJumpConstantTime.tick();
         }
         _loc4_ = -this.m_characterStats.JumpSpeedMidAir;
         if(this.m_jumpSpeedList)
         {
            if(this.m_jumpCount < this.m_jumpSpeedList.length)
            {
               _loc4_ = -this.m_jumpSpeedList[this.m_jumpCount];
            }
            else
            {
               _loc4_ = -this.m_jumpSpeedList[this.m_jumpSpeedList.length - 1];
            }
         }
         if(!this.m_midAirJumpConstantTime.IsComplete && Boolean(this.m_midAirJumpConstantDelay.IsComplete) && !isHitStunOrParalysis())
         {
            if(this.m_characterStats.MidAirJumpConstantAccel != 0)
            {
               m_ySpeed -= this.m_characterStats.MidAirJumpConstantAccel;
               if(m_ySpeed < _loc4_)
               {
                  m_ySpeed = _loc4_;
               }
            }
            else
            {
               m_ySpeed = _loc4_;
            }
         }
         if(!this.m_jumpEffectTimer.IsComplete)
         {
            this.m_jumpEffectTimer.tick();
            if(this.m_jumpEffectTimer.CurrentTime % 2 == 0)
            {
               this.attachJumpEffect();
            }
         }
         if(inState(CState.ATTACKING))
         {
            if(!isHitStunOrParalysis())
            {
               ++m_attack.ExecTime;
               ++m_attack.RefreshRateTimer;
            }
            if(!this.m_attackIDIncremented && m_attack.RefreshRate > 0 && m_attack.RefreshRateReady && m_attack.RefreshRateTimer % m_attack.RefreshRate == 0)
            {
               m_attack.AttackID = Utils.getUID();
               this.checkLinkedProjectiles();
               this.m_attackIDIncremented = true;
            }
            else if(!isHitStunOrParalysis())
            {
               this.m_attackIDIncremented = false;
            }
         }
         if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.INVISIBLE))
         {
            if(!this.m_invisiblePulseToggle)
            {
               this.setAlpha(0);
            }
            this.m_invisiblePulseTimer.tick();
            if(this.m_invisiblePulseTimer.IsComplete)
            {
               if(!this.m_invisiblePulseToggle)
               {
                  this.m_invisiblePulseToggle = true;
                  this.m_invisiblePulseTimer.reset();
                  this.m_invisiblePulseTimer.MaxTime = Utils.randomInteger(1,8);
                  this.setAlpha(Utils.random() * 0.65);
                  this.m_invisiblePulseCount = Utils.randomInteger(1,8);
               }
               else
               {
                  --this.m_invisiblePulseCount;
                  if(this.m_invisiblePulseCount <= 0)
                  {
                     this.m_invisiblePulseCount = 0;
                     this.m_invisiblePulseToggle = false;
                     this.m_invisiblePulseTimer.reset();
                     this.m_invisiblePulseTimer.MaxTime = Utils.randomInteger(20,90);
                  }
                  else
                  {
                     this.m_invisiblePulseTimer.reset();
                     this.m_invisiblePulseTimer.MaxTime = Utils.randomInteger(1,8);
                     this.setAlpha(Utils.random() * 0.65);
                  }
               }
            }
         }
         if(this.m_waveDashPenalty > 0 && !inState(CState.AIR_DODGE) && !inState(CState.LAND))
         {
            --this.m_waveDashPenalty;
            if(this.m_waveDashPenalty <= 0)
            {
               this.m_waveDashPenalty = 0;
            }
         }
         this.m_justTechedTimer.tick();
      }
      
      public function groundBounceCheck() : void
      {
         if(Boolean(inState(CState.CRASH_LAND) && this.m_tumbledCrash && Stance && Stance.currentFrame <= 2) && Boolean(this.shieldIsPressed()) && !isHitStunOrParalysis())
         {
            this.performGroundTech();
            this.techEffect();
         }
         else if((inState(CState.FLYING) || inState(CState.TUMBLE_FALL)) && Boolean(this.m_canTech) && !this.m_hasBounced && Boolean(this.m_techReady) && !isHitStunOrParalysis())
         {
            this.performGroundTech();
            this.techEffect();
         }
         else if(inState(CState.FLYING) && Boolean(this.m_canBounce) && this.netYSpeed() >= m_max_ySpeed - 1)
         {
            this.toBounce();
         }
         else if(inState(CState.FLYING) || inState(CState.TUMBLE_FALL))
         {
            this.initiateCrash();
         }
      }
      
      public function initiateCrash() : void
      {
         this.m_forcedCrash = false;
         if(inState(CState.FLYING) || inState(CState.TUMBLE_FALL))
         {
            this.m_tumbledCrash = true;
         }
         else
         {
            this.m_tumbledCrash = false;
         }
         if(!inState(CState.CRASH_LAND) && !inState(CState.CRASH_GETUP))
         {
            this.m_crashTimer.reset();
            this.m_getUpTimer.reset();
         }
         if(!m_collision.ground)
         {
            m_currentPlatform = getPlatformBetweenPoints(Location,new Point(Location.x,Location.y + 20));
            if(m_currentPlatform != null)
            {
               attachToGround();
            }
         }
         this.m_hitLagCanCancelWithJump = false;
         this.m_hitLagCanCancelWithUpB = false;
         if(inState(CState.FLYING))
         {
            this.setState(CState.CRASH_LAND);
            this.stancePlayFrame("bounce");
         }
         else
         {
            this.setState(CState.CRASH_LAND);
         }
         this.m_crowdAwe = false;
         this.updateItemHolding();
         this.resetRotation();
      }
      
      private function checkEdgeLean() : void
      {
         var _loc1_:Boolean = false;
         if(inState(CState.IDLE))
         {
            _loc1_ = m_collision.ground && m_xSpeed == 0 && checkLinearPathBetweenPoints(new Point(m_facingForward ? m_sprite.x + 5 : m_sprite.x - 5,m_sprite.y + 2),new Point(m_facingForward ? m_sprite.x + 5 : m_sprite.x - 5,m_sprite.y + 20),true,m_currentPlatform);
            if(_loc1_ && Boolean(Utils.hasLabel(m_sprite,"edgelean",true)))
            {
               this.playFrame("edgelean");
            }
            else
            {
               this.playFrame("stand");
            }
         }
      }
      
      private function checkFatKirby() : void
      {
         if(this.m_charIsFull)
         {
            if(inState(CState.IDLE))
            {
               this.playFrame("stand");
               if(getStanceVar("fatstand",false))
               {
                  this.stancePlayFrame("fatstand");
               }
            }
            else if(inState(CState.WALK))
            {
               this.playFrame("walk");
               if(Boolean(this.m_charIsFull) && getStanceVar("normalwalk",true))
               {
                  this.stancePlayFrame("startwalk2");
               }
            }
            else if(inState(CState.JUMP_RISING))
            {
               this.playFrame("jump");
               if(getStanceVar("fatjump",false))
               {
                  this.stancePlayFrame("fatjump");
               }
            }
            else if(inState(CState.JUMP_FALLING))
            {
               this.playFrame("fall");
               if(getStanceVar("fatfall",false))
               {
                  this.stancePlayFrame("fatfall");
               }
            }
            else if(inState(CState.LAND) || inState(CState.HEAVY_LAND))
            {
               if(currentFrameIs("land"))
               {
                  this.playFrame("land");
               }
               else if(currentFrameIs("heavyland"))
               {
                  this.playFrame("heavyland");
               }
               else if(inState(CState.HEAVY_LAND))
               {
                  this.playFrame("heavyland");
               }
               else
               {
                  this.playFrame("land");
               }
               if(getStanceVar("fatland",false))
               {
                  this.stancePlayFrame("fatland");
                  this.attachLandEffect();
                  if(!(m_currentPlatform != null && m_currentPlatform.accel_friction != 1))
                  {
                     m_xSpeed = 0;
                  }
               }
            }
         }
      }
      
      private function checkGroundStateChange() : void
      {
         if(!m_collision.ground)
         {
            if(inState(CState.IDLE) || inState(CState.RUN) || inState(CState.WALK) || inState(CState.SKID) || inState(CState.JUMP_CHAMBER) || this.isLanding() || inState(CState.SKID) || inState(CState.CROUCH) || inState(CState.TURN) || inState(CState.DASH))
            {
               if(!inState(CState.ATTACKING))
               {
                  if(m_xSpeed > this.m_characterStats.MaxJumpSpeed)
                  {
                     m_xSpeed = this.m_characterStats.MaxJumpSpeed;
                  }
                  else if(m_xSpeed < -this.m_characterStats.MaxJumpSpeed)
                  {
                     m_xSpeed = -this.m_characterStats.MaxJumpSpeed;
                  }
               }
               if(inState(CState.TURN))
               {
                  flip();
               }
               this.setState(CState.JUMP_FALLING);
               this.resetRotation();
               this.m_fallTiltTimer.reset();
            }
         }
         else if(inState(CState.JUMP_RISING) || inState(CState.JUMP_MIDAIR_RISING) || inState(CState.JUMP_FALLING) || inState(CState.HOVER) || Boolean(this.m_attackHovering))
         {
            this.resetRotation();
            this.setState(CState.LAND);
            if(Boolean(this.m_human) && this.ID > 0)
            {
               Gamepad.rumbleOnLand(this.ID,Math.abs(m_ySpeed + m_yKnockback));
            }
         }
      }
      
      override protected function m_controlFrames() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Boolean = false;
         if(this.m_charIsFull)
         {
            this.checkFatKirby();
         }
         else if(inState(CState.ENTRANCE))
         {
            this.playFrame("entrance");
         }
         else if(inState(CState.DISABLED))
         {
            if(Utils.hasLabel(m_sprite,"helpless"))
            {
               this.playFrame("helpless");
            }
            else
            {
               this.playFrame("fall");
            }
         }
         else if(inState(CState.IDLE))
         {
            if(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1))
            {
               if(m_xSpeed !== 0)
               {
                  this.playFrame("run");
               }
               else
               {
                  this.playFrame("stand");
               }
            }
            else
            {
               this.playFrame("stand");
            }
            this.resetRotation();
            Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
         }
         else if(inState(CState.DASH_INIT))
         {
            this.playFrame("stand");
         }
         else if(inState(CState.RUN) || inState(CState.DASH) || inState(CState.TURN))
         {
            _loc1_ = currentFrameIs("run");
            this.playFrame("run");
            if(inState(CState.RUN) && !_loc1_ && HasStance && Boolean(Utils.hasLabel(m_sprite.stance,"run")))
            {
               this.stancePlayFrame("run");
            }
         }
         else if(inState(CState.WALK))
         {
            this.playFrame("walk");
         }
         else if(inState(CState.SKID))
         {
            this.playFrame("skid");
         }
         else if(inState(CState.LAND) || inState(CState.HEAVY_LAND))
         {
            if(currentFrameIs("land"))
            {
               this.playFrame("land");
            }
            else if(currentFrameIs("heavyland"))
            {
               this.playFrame("heavyland");
            }
            else if(inState(CState.HEAVY_LAND))
            {
               this.playFrame("heavyland");
            }
            else
            {
               this.playFrame("land");
            }
         }
         else if(inState(CState.HOVER))
         {
            this.playFrame("jump_midair");
            if(HasStance && m_sprite.stance.currentLabel != "hover" && m_currentAnimationID == "jump_midair" && Boolean(Utils.hasLabel(m_sprite.stance,"hover")))
            {
               this.stancePlayFrame("hover");
            }
         }
         else if(inState(CState.JUMP_RISING) || inState(CState.JUMP_MIDAIR_RISING) || inState(CState.JUMP_CHAMBER))
         {
            if(inState(CState.JUMP_RISING) || inState(CState.JUMP_CHAMBER))
            {
               this.playFrame("jump");
            }
            else if(inState(CState.JUMP_MIDAIR_RISING))
            {
               this.playFrame("jump_midair");
            }
         }
         else if(inState(CState.JUMP_FALLING))
         {
            this.playFrame("fall");
         }
         else if(inState(CState.KIRBY_STAR))
         {
            this.playFrame("hurt");
         }
         else if(inState(CState.ATTACKING))
         {
            if(!currentFrameIs(m_attack.Frame) && m_attack.Frame != null)
            {
               this.playFrame(m_attack.Frame);
            }
         }
         else if(inState(CState.REVIVAL))
         {
            this.playFrame("revival");
         }
         else if(inState(CState.CRASH_LAND))
         {
            this.playFrame("crash");
         }
         else if(inState(CState.CRASH_GETUP))
         {
            this.playFrame("crash");
         }
         else if(inState(CState.STAMINA_KO))
         {
            if(m_collision.ground)
            {
               this.playFrame("crash");
            }
            else
            {
               this.playFrame("falling");
            }
         }
         else if(inState(CState.ROLL))
         {
            this.playFrame("roll");
         }
         else if(inState(CState.TECH_ROLL))
         {
            this.playFrame("tech_roll");
         }
         else if(inState(CState.TECH_GROUND))
         {
            this.playFrame("tech_ground");
         }
         else if(inState(CState.INJURED) || inState(CState.CAUGHT) || inState(CState.FLYING) || inState(CState.LOCKED))
         {
            if(inState(CState.FLYING))
            {
               if(isHitStunOrParalysis())
               {
                  this.resetRotation();
                  Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
                  this.playFrame("hurt");
               }
               else
               {
                  this.playFrame("flying");
                  _loc2_ = Number(Utils.getAngleBetween(new Point(0,0),new Point(this.netXSpeed(),this.netYSpeed())));
                  _loc3_ = Number(Utils.forceBase360(!m_facingForward ? -_loc2_ : -_loc2_ + 180));
                  m_sprite.rotation = _loc3_;
               }
            }
            else if(!currentFrameIs("hurt") || m_delayPlayback)
            {
               this.resetRotation();
               Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
               this.playFrame("hurt");
            }
         }
         else if(inState(CState.STUNNED))
         {
            if(!m_collision.ground)
            {
               this.playFrame("falling");
            }
            else
            {
               this.playFrame("stunned");
            }
         }
         else if(inState(CState.DIZZY))
         {
            if(!m_collision.ground)
            {
               this.playFrame("falling");
            }
            else
            {
               this.playFrame("dizzy");
            }
         }
         else if(inState(CState.LEDGE_ROLL))
         {
            this.playFrame("rollup");
         }
         else if(inState(CState.LEDGE_CLIMB))
         {
            this.playFrame("climbup");
         }
         else if(inState(CState.LEDGE_HANG))
         {
            this.playFrame("hang");
         }
         else if(inState(CState.DODGE_ROLL))
         {
            this.playFrame("dodgeroll");
         }
         else if(inState(CState.SIDESTEP_DODGE))
         {
            this.playFrame("sidestep");
         }
         else if(inState(CState.AIR_DODGE))
         {
            this.playFrame("airdodge");
         }
         else if(inState(CState.ITEM_TOSS))
         {
            if(!currentFrameIs("toss") && !currentFrameIs("toss_air"))
            {
               if(!m_collision.ground && Boolean(Utils.hasLabel(m_sprite,"toss_air",true)))
               {
                  this.playFrame("toss_air");
               }
               else
               {
                  this.playFrame("toss");
               }
            }
         }
         else if(inState(CState.ITEM_PICKUP))
         {
            this.playFrame("item_pickup");
         }
         else if(inState(CState.GRABBING))
         {
            this.playFrame("grab");
         }
         else if(inState(CState.CROUCH))
         {
            _loc4_ = currentFrameIs("crouch");
            this.playFrame("crouch");
            if(!_loc4_ && this.m_crouchFrame > 0)
            {
               Utils.tryToGotoAndStop(m_sprite.stance,this.m_crouchFrame);
            }
         }
         else if(inState(CState.SHIELDING))
         {
            this.playFrame("defend");
            this.m_resizeShield();
         }
         else if(inState(CState.SHIELD_DROP))
         {
            this.playFrame("defend");
         }
         else if(inState(CState.TAUNT))
         {
            this.playFrame("taunt");
         }
         else if(inState(CState.TUMBLE_FALL) && !isHitStunOrParalysis())
         {
            Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
            if(m_collision.ground)
            {
               this.initiateCrash();
            }
            else
            {
               Utils.rotateAroundCenter(m_sprite.stance,m_facingForward,0);
               this.playFrame("falling");
            }
         }
         else if(inState(CState.FROZEN))
         {
            this.playFrame("hurt");
         }
         else if(inState(CState.SLEEP))
         {
            if(!m_collision.ground)
            {
               this.playFrame("falling");
            }
            else
            {
               this.playFrame("sleep");
            }
         }
         else if(inState(CState.PITFALL))
         {
            this.playFrame("pitfall");
         }
         else if(inState(CState.EGG))
         {
            this.playFrame("hurt");
         }
         else if(inState(CState.WALL_CLING))
         {
            this.playFrame("wallstick");
         }
      }
      
      private function stopSoundID(param1:int) : void
      {
         var _loc2_:SoundObject = null;
         if(param1 >= 0)
         {
            _loc2_ = STAGEDATA.SoundQueueRef.getSoundObject(param1);
            if(_loc2_.IsPlaying && _loc2_.IsPlaying)
            {
               _loc2_.stop();
            }
         }
      }
      
      public function playAttackSound(param1:Number = -1) : int
      {
         var _loc2_:Array = null;
         if(m_attack.Frame != null)
         {
            _loc2_ = m_attackData.getAttack(m_attack.Frame).AttackSounds;
            if(param1 === -1)
            {
               if(_loc2_[param1 - 1].length)
               {
                  return this.m_lastSFX = STAGEDATA.playSpecificSound(_loc2_[Utils.randomInteger(0,_loc2_.length - 1)],this.m_characterStats.VolumeSFX);
               }
            }
            else if(_loc2_[param1 - 1] != null)
            {
               return this.m_lastSFX = STAGEDATA.playSpecificSound(_loc2_[param1 - 1],this.m_characterStats.VolumeSFX);
            }
         }
         return -1;
      }
      
      public function playVoiceSound(param1:Number = -1) : int
      {
         var _loc2_:Array = null;
         if(!this.m_isMetal && m_attack.Frame != null)
         {
            _loc2_ = m_attackData.getAttack(m_attack.Frame).AttackVoices;
            if(param1 === -1)
            {
               if(_loc2_[param1 - 1].length)
               {
                  return this.m_lastVFX = STAGEDATA.playSpecificVoice(_loc2_[Utils.randomInteger(0,_loc2_.length - 1)],this.m_characterStats.VolumeVFX);
               }
            }
            else if(_loc2_[param1 - 1] != null)
            {
               return this.m_lastVFX = STAGEDATA.playSpecificVoice(_loc2_[param1 - 1],this.m_characterStats.VolumeVFX);
            }
         }
         return -1;
      }
      
      public function playCharacterSound(param1:String) : int
      {
         if(!this.m_isMetal && this.m_characterStats.Sounds[param1] != null && this.m_characterStats.Sounds[param1] != undefined)
         {
            return STAGEDATA.playSpecificVoice(this.m_characterStats.Sounds[param1 + "2"] != null ? (Utils.random() > 0.5 ? this.m_characterStats.Sounds[param1 + "2"] : this.m_characterStats.Sounds[param1]) : this.m_characterStats.Sounds[param1],this.m_characterStats.VolumeVFX);
         }
         return -1;
      }
      
      public function toHelpless(param1:* = null) : void
      {
         this.forceEndAttack();
         if(!m_collision.ground)
         {
            this.setState(CState.DISABLED);
            this.m_blinkOn = false;
            this.m_blinkTimer = 2;
         }
      }
      
      public function toLand(param1:* = null) : void
      {
         this.forceEndAttack();
         this.setState(CState.LAND);
         m_ySpeed = 0;
      }
      
      public function toHeavyLand(param1:* = null) : void
      {
         this.forceEndAttack();
         this.setState(CState.HEAVY_LAND);
         m_ySpeed = 0;
      }
      
      public function toIdle(param1:* = null) : void
      {
         this.forceEndAttack();
         this.setState(CState.IDLE);
      }
      
      public function toGrabbing(param1:* = null) : void
      {
         if(this.m_grabbed.length === 1)
         {
            this.m_internalGrabLock = true;
            this.forceEndAttack();
            this.m_internalGrabLock = false;
            if(this.m_grabbed.length)
            {
               m_attack.Frame = "grab";
               this.setState(CState.GRABBING);
               this.m_grabTimer = Utils.calculateGrabLength(this.m_grabbed[0].CharacterStats.Stamina > 0 ? this.m_grabbed[0].CharacterStats.Stamina - this.m_grabbed[0].getDamage() : Number(this.m_grabbed[0].getDamage()));
               this.m_pummelTimer = Utils.calculatePummelTime(this.m_grabTimer);
               this.m_justPummeled = false;
               this.stancePlayFrame("grabbed");
               m_attack.AttackID = Utils.getUID();
               m_attack.ID = Utils.getUID();
               this.checkLinkedProjectiles();
            }
         }
      }
      
      public function toBounce(param1:* = null) : void
      {
         var _loc2_:Number = NaN;
         this.forceEndAttack();
         this.setState(CState.FLYING);
         resetKnockbackDecay();
         m_ySpeed = -12;
         this.unnattachFromGround();
         this.attachGroundBounceEffect();
         this.m_canBounce = false;
         this.m_hasBounced = true;
         this.m_hitLagCanCancelWithJump = false;
         this.m_hitLagCanCancelWithUpB = false;
         this.m_hitLagCancelTimer.reset();
         this.m_hitLag = 0;
         _loc2_ = -12;
         while(_loc2_ < 12 && m_gravity > 0)
         {
            ++this.m_hitLag;
            _loc2_ += m_gravity;
         }
      }
      
      public function toCrashLand(param1:* = null) : void
      {
         this.forceEndAttack();
         this.initiateCrash();
      }
      
      public function toToss(param1:* = null) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:Number = NaN;
         var _loc9_:String = null;
         var _loc10_:Number = NaN;
         if(!this.m_item || !this.m_item.ItemStats.CanToss)
         {
            return;
         }
         _loc3_ = false;
         _loc4_ = false;
         _loc5_ = false;
         _loc6_ = false;
         _loc7_ = inState(CState.DODGE_ROLL);
         _loc8_ = m_xSpeed;
         if(inState(CState.SHIELDING) || inState(CState.SHIELD_DROP) || inState(CState.DODGE_ROLL) || inState(CState.SIDESTEP_DODGE))
         {
            this.m_deactivateShield();
            this.setIntangibility(false);
         }
         if(Boolean(this.m_pressedControls.C_UP) || Boolean(this.m_pressedControls.C_DOWN) || Boolean(this.m_pressedControls.C_LEFT) || Boolean(this.m_pressedControls.C_RIGHT))
         {
            _loc3_ = Boolean(this.m_pressedControls.C_UP);
            _loc4_ = Boolean(this.m_pressedControls.C_DOWN);
            _loc5_ = Boolean(this.m_pressedControls.C_LEFT);
            _loc6_ = Boolean(this.m_pressedControls.C_RIGHT);
         }
         else if(Boolean(this.m_heldControls.UP) || Boolean(this.m_heldControls.DOWN) || Boolean(this.m_heldControls.LEFT) || Boolean(this.m_heldControls.RIGHT))
         {
            _loc3_ = Boolean(this.m_heldControls.UP);
            _loc4_ = Boolean(this.m_heldControls.DOWN);
            _loc5_ = Boolean(this.m_heldControls.LEFT);
            _loc6_ = Boolean(this.m_heldControls.RIGHT);
         }
         if(inState(CState.ATTACKING))
         {
            this.forceEndAttack();
         }
         m_xSpeed = _loc8_;
         if(_loc7_)
         {
            if(m_facingForward)
            {
               if(!_loc6_)
               {
                  faceLeft();
                  _loc5_ = true;
               }
            }
            else if(!_loc5_)
            {
               faceRight();
               _loc6_ = true;
            }
         }
         if(Utils.hasLabel(m_sprite,"toss",true))
         {
            _loc9_ = "";
            if(Boolean(this.m_pressedControls.GRAB) && !(!this.m_item.CanBackToss && m_collision.ground) && !(_loc3_ != _loc4_ || _loc5_ != _loc6_))
            {
               this.tossItemOld(8,105,true);
               this.setState(CState.IDLE);
               return;
            }
            if(_loc6_ != _loc5_)
            {
               if(!m_collision.ground)
               {
                  if(_loc3_)
                  {
                     _loc9_ = _loc3_ ? "toss_forward" : "toss_down";
                  }
                  else
                  {
                     _loc9_ = _loc6_ && !m_facingForward || _loc5_ && m_facingForward ? "toss_back" : "toss_forward";
                  }
               }
               else if(_loc3_ != _loc4_)
               {
                  _loc9_ = _loc3_ ? "toss_up" : "toss_down";
               }
               else
               {
                  _loc9_ = _loc6_ && !m_facingForward || _loc5_ && m_facingForward ? "toss_back" : "toss_forward";
               }
            }
            else if(_loc3_ != _loc4_)
            {
               _loc9_ = _loc3_ ? "toss_up" : "toss_down";
            }
            else
            {
               _loc9_ = "toss_forward";
            }
            this.setState(CState.ITEM_TOSS);
            this.stancePlayFrame(_loc9_);
            this.setStanceVar("backToss",_loc2_);
            if(_loc9_ === "toss_back")
            {
               addEventListener(SSF2Event.CHAR_ATTACK_COMPLETE,flip);
            }
         }
         else if(Boolean(this.m_pressedControls.GRAB) && !(!this.m_item.CanBackToss && m_collision.ground) && !(_loc3_ != _loc4_ || _loc5_ != _loc6_))
         {
            this.tossItemOld(8,105,true);
            this.setState(CState.IDLE);
         }
         else
         {
            _loc10_ = this.m_heldControls.UP ? 90 : (_loc4_ ? 270 : (_loc6_ !== _loc5_ ? (_loc6_ ? 20 : 160) : (m_facingForward ? 20 : 160)));
            this.tossItemOld(20,_loc10_);
            this.setState(CState.IDLE);
         }
         if(!m_collision.ground && !this.jumpIsPressed() && !(this.jumpIsHeld() || Boolean(this.m_tap_jump) && Boolean(this.m_heldControls.UP)) && (m_ySpeed < 0 || this.m_midAirJumpConstantTime.MaxTime > 0 && !this.m_midAirJumpConstantTime.IsComplete))
         {
            if(m_ySpeed < 0)
            {
               this.m_midAirJumpConstantDelay.finish();
               this.m_midAirJumpConstantTime.finish();
            }
            else
            {
               m_ySpeed = 0;
               this.m_midAirJumpConstantTime.finish();
            }
         }
      }
      
      public function toFlying(param1:* = null) : void
      {
         this.forceEndAttack();
         this.setState(CState.FLYING);
      }
      
      public function toBarrel(param1:* = null) : void
      {
         if(inState(CState.BARREL))
         {
            return;
         }
         this.forceEndAttack();
         this.setState(CState.BARREL);
      }
      
      public function playGlobalSound(param1:String) : int
      {
         return STAGEDATA.playSpecificSound(param1,this.m_characterStats.VolumeSFX);
      }
      
      private function m_checkRevival() : void
      {
         var _loc1_:Vector.<MovieClip> = null;
         var _loc2_:Boolean = false;
         var _loc3_:MovieClip = null;
         var _loc4_:Vector.<MovieClip> = null;
         if(inState(CState.STAR_KO) || inState(CState.SCREEN_KO))
         {
            if(this.m_starKOTimer.IsComplete)
            {
               if(inState(CState.SCREEN_KO))
               {
                  this.m_screenKO = false;
               }
               else if(inState(CState.STAR_KO))
               {
                  _loc1_ = new Vector.<MovieClip>();
                  _loc1_.push(m_sprite);
                  STAGEDATA.CamRef.deleteTargets(_loc1_);
               }
               this.killCharacter(false,true);
            }
            else
            {
               this.m_starKOHolder.visible = true;
               this.m_screenKOHolder.visible = true;
            }
         }
         else if(inState(CState.REVIVAL))
         {
            _loc2_ = Boolean(this.m_respawnDelay.IsComplete);
            this.m_respawnDelay.tick();
            if(Boolean(this.m_respawnDelay.IsComplete) && !_loc2_)
            {
               this.restartStance();
            }
            if(this.m_respawnDelay.IsComplete)
            {
               if(!m_sprite.visible)
               {
                  _loc4_ = new Vector.<MovieClip>();
                  _loc4_.push(m_sprite);
                  if(!(CAM.Mode == Vcam.ZOOM_MODE && m_player_id > 1))
                  {
                     STAGEDATA.CamRef.addTargets(_loc4_);
                  }
                  this.restartStance();
               }
               this.setVisibility(true);
               showHealthBoxes(true);
               _loc3_ = null;
               if(this.m_revivalTimer < 0)
               {
                  if(this.m_characterStats.RevivalEffect != null)
                  {
                     _loc3_ = STAGEDATA.attachEffectOverlay(this.m_characterStats.RevivalEffect);
                     if(!m_facingForward)
                     {
                        _loc3_.scaleX *= -1;
                     }
                     _loc3_.width *= m_sizeRatio;
                     _loc3_.height *= m_sizeRatio;
                     _loc3_.x = OverlayX;
                     _loc3_.y = OverlayY;
                  }
                  this.setState(CState.IDLE);
               }
               else
               {
                  this.m_revivalInvincibility.reset();
                  if(!currentFrameIs("revival") || Boolean(SpecialMode.modeEnabled(STAGEDATA.GameRef.LevelData.specialModes,SpecialMode.SSF1)))
                  {
                     this.setState(CState.IDLE);
                  }
                  else if(this.m_revivalTimer >= 120)
                  {
                     if(this.m_revivalTimer == 150)
                     {
                        m_sprite.y -= 30 * m_sizeRatio;
                        this.setAlpha(0);
                     }
                     this.m_attemptToMove(0,m_sizeRatio);
                     this.setAlpha(m_sprite.alpha + 4);
                  }
                  else if(Boolean(this.m_heldControls.LEFT) || Boolean(this.m_heldControls.RIGHT) || Boolean(this.m_heldControls.BUTTON2) || Boolean(this.m_heldControls.BUTTON1) || Boolean(this.m_heldControls.UP) || Boolean(this.m_heldControls.DOWN) || Boolean(this.m_heldControls.GRAB) || Boolean(this.m_heldControls.SHIELD) || Boolean(this.m_heldControls.SHIELD2) || Boolean(this.m_heldControls.C_UP) || Boolean(this.m_heldControls.C_DOWN) || Boolean(this.m_heldControls.C_LEFT) || Boolean(this.m_heldControls.C_RIGHT))
                  {
                     if(this.m_characterStats.RevivalEffect != null)
                     {
                        _loc3_ = STAGEDATA.attachEffectOverlay(this.m_characterStats.RevivalEffect);
                        if(!m_facingForward)
                        {
                           _loc3_.scaleX *= -1;
                        }
                        _loc3_.width *= m_sizeRatio;
                        _loc3_.height *= m_sizeRatio;
                        _loc3_.x = OverlayX;
                        _loc3_.y = OverlayY;
                     }
                     this.setState(CState.IDLE);
                  }
                  --this.m_revivalTimer;
               }
            }
            else
            {
               this.setVisibility(false);
            }
         }
      }
      
      public function suddenDeathRespawn() : void
      {
         var _loc1_:Vector.<MovieClip> = null;
         this.setVisibility(false);
         _loc1_ = new Vector.<MovieClip>();
         _loc1_.push(m_sprite);
         STAGEDATA.CamRef.addTargets(_loc1_);
         this.playFrame("stand");
         m_sprite.x = this.m_playerSettings.x_start;
         m_sprite.y = this.m_playerSettings.y_start;
         this.forceOnGround();
         this.setVisibility(true);
         showHealthBoxes(true);
         this.m_lives = 1;
         this.updateLivesDisplay();
         this.m_usingLives = true;
      }
      
      private function checkDI() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Boolean = false;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         _loc1_ = 0;
         _loc2_ = false;
         if(!(inState(CState.TECH_GROUND) || inState(CState.TECH_ROLL)) && !m_paralysis && !this.m_smashDISelf && (isHitStunOrParalysis() || inState(CState.SHIELDING) && !this.m_shieldDelayTimer.IsComplete) && !inState(CState.CAUGHT) && !inState(CState.BARREL) && !inState(CState.CRASH_GETUP) && !inState(CState.CRASH_LAND) && !inState(CState.DEAD) && !inState(CState.STAMINA_KO))
         {
            _loc3_ = Number(Utils.getControlsAngle(this.getControls()));
            if(this.m_smashDIDirection !== _loc3_ && _loc3_ !== -1)
            {
               _loc1_ = Number(Utils.getAngleBetween(new Point(),new Point(m_xKnockback,m_yKnockback)));
               if(Boolean(this.m_pressedControls.UP) && !this.m_pressedControls.DOWN && !inState(CState.SHIELDING) && !(_loc1_ <= 20 || _loc1_ >= 160))
               {
                  this.m_smashDIDirection = _loc3_;
                  _loc2_ = Boolean(this.m_techReady) && Boolean(this.m_canWallTech) && Boolean(testTerrainWithCoord(m_sprite.x,m_sprite.y - m_height / 2 - this.m_smashDIAmount));
                  if(m_collision.ground)
                  {
                     this.unnattachFromGround();
                  }
                  super.m_attemptToMove(0,-this.m_smashDIAmount);
                  if(_loc2_)
                  {
                     this.performWallTech(true);
                     return;
                  }
               }
               else if(Boolean(this.m_pressedControls.DOWN) && !this.m_pressedControls.UP && !inState(CState.SHIELDING))
               {
                  this.m_smashDIDirection = _loc3_;
                  super.m_attemptToMove(0,this.m_smashDIAmount);
               }
               if(Boolean(this.m_pressedControls.LEFT) && !this.m_pressedControls.RIGHT)
               {
                  this.m_smashDIDirection = _loc3_;
                  _loc2_ = Boolean(this.m_techReady) && Boolean(this.m_canWallTech) && Boolean(testTerrainWithCoord(m_sprite.x - this.m_smashDIAmount,m_sprite.y - m_height / 2));
                  super.m_attemptToMove(-this.m_smashDIAmount,0);
                  this.m_groundCollisionTest();
                  if(!m_collision.ground)
                  {
                     if(_loc2_)
                     {
                        this.performWallTech(false);
                        return;
                     }
                  }
               }
               else if(Boolean(this.m_pressedControls.RIGHT) && !this.m_pressedControls.LEFT)
               {
                  this.m_smashDIDirection = _loc3_;
                  _loc2_ = Boolean(this.m_techReady) && Boolean(this.m_canWallTech) && Boolean(testTerrainWithCoord(m_sprite.x + this.m_smashDIAmount,m_sprite.y - m_height / 2));
                  super.m_attemptToMove(this.m_smashDIAmount,0);
                  this.m_groundCollisionTest();
                  if(!m_collision.ground)
                  {
                     if(_loc2_)
                     {
                        this.performWallTech(false);
                        return;
                     }
                  }
               }
            }
            else if(_loc3_ === -1)
            {
               this.m_smashDIDirection = -1;
            }
            _loc4_ = Number(Utils.getControlsAngle({
               "UP":this.m_pressedControls.C_UP,
               "DOWN":this.m_pressedControls.C_DOWN,
               "LEFT":this.m_pressedControls.C_LEFT,
               "RIGHT":this.m_pressedControls.C_RIGHT
            }));
            if(this.m_smashDIDirectionCStick !== _loc4_ && _loc4_ !== -1)
            {
               _loc1_ = Number(Utils.getAngleBetween(new Point(),new Point(m_xKnockback,m_yKnockback)));
               if(Boolean(this.m_pressedControls.C_UP) && !this.m_pressedControls.C_DOWN && !inState(CState.SHIELDING) && !(_loc1_ <= 20 || _loc1_ >= 160))
               {
                  this.m_smashDIDirectionCStick = _loc4_;
                  _loc2_ = Boolean(this.m_techReady) && Boolean(this.m_canWallTech) && Boolean(testTerrainWithCoord(m_sprite.x,m_sprite.y - this.m_smashDIAmount));
                  if(m_collision.ground)
                  {
                     this.unnattachFromGround();
                  }
                  super.m_attemptToMove(0,-this.m_smashDIAmount);
                  if(_loc2_)
                  {
                     this.performWallTech(true);
                     return;
                  }
               }
               else if(Boolean(this.m_pressedControls.C_DOWN) && !this.m_pressedControls.C_UP && !inState(CState.SHIELDING))
               {
                  this.m_smashDIDirectionCStick = _loc4_;
                  super.m_attemptToMove(0,this.m_smashDIAmount);
               }
               if(Boolean(this.m_pressedControls.C_LEFT) && !this.m_pressedControls.C_RIGHT)
               {
                  this.m_smashDIDirectionCStick = _loc4_;
                  _loc2_ = Boolean(this.m_techReady) && Boolean(this.m_canWallTech) && Boolean(testTerrainWithCoord(m_sprite.x - this.m_smashDIAmount,m_sprite.y));
                  super.m_attemptToMove(-this.m_smashDIAmount,0);
                  if(m_collision.ground)
                  {
                     attachToGround();
                  }
                  if(_loc2_)
                  {
                     this.performWallTech(false);
                     return;
                  }
               }
               else if(Boolean(this.m_pressedControls.C_RIGHT) && !this.m_pressedControls.C_LEFT)
               {
                  this.m_smashDIDirectionCStick = _loc4_;
                  _loc2_ = Boolean(this.m_techReady) && Boolean(this.m_canWallTech) && Boolean(testTerrainWithCoord(m_sprite.x + this.m_smashDIAmount,m_sprite.y));
                  super.m_attemptToMove(this.m_smashDIAmount,0);
                  if(m_collision.ground)
                  {
                     attachToGround();
                  }
                  if(_loc2_)
                  {
                     this.performWallTech(false);
                  }
               }
            }
            else if(_loc4_ === -1)
            {
               this.m_smashDIDirectionCStick = -1;
            }
         }
      }
      
      override protected function checkHitStun() : void
      {
         if(isHitStunOrParalysis())
         {
            if(m_actionShot)
            {
               --m_actionTimer;
               --m_hitStunTimer;
               if(m_actionTimer < 0)
               {
                  if(m_paralysis)
                  {
                     m_actionShot = false;
                  }
                  else
                  {
                     if(!this.m_smashDISelf && !inState(CState.CAUGHT) && !inState(CState.BARREL))
                     {
                        this.checkDI();
                     }
                     this.stopActionShot();
                  }
               }
               else if(m_hitStunTimer <= 0)
               {
                  m_hitStunTimer = 2;
                  m_hitStunToggle = !m_hitStunToggle;
                  if(HasStance)
                  {
                     m_sprite.stance.x += m_hitStunToggle ? 2 : -2;
                  }
               }
            }
            else if(m_paralysis)
            {
               --m_paralysisTimer;
               --m_hitStunTimer;
               if(m_paralysisTimer < 0)
               {
                  if(!this.m_smashDISelf && !inState(CState.CAUGHT) && !inState(CState.BARREL))
                  {
                     this.checkDI();
                  }
                  this.stopActionShot();
               }
               else if(m_hitStunTimer <= 0)
               {
                  m_hitStunTimer = 2;
                  m_hitStunToggle = !m_hitStunToggle;
                  if(HasStance)
                  {
                     m_sprite.stance.x += m_hitStunToggle ? 2 : -2;
                  }
               }
            }
         }
         if(isHitStunOrParalysis() && m_hitStunTimer <= 0 && this.m_hitLag > 0 && currentFrameIs("hurt"))
         {
            if(m_hitStunTimer <= 0)
            {
               m_hitStunTimer = 2;
               m_hitStunToggle = !m_hitStunToggle;
               if(HasStance)
               {
                  m_sprite.stance.x += m_hitStunToggle ? 2 : -2;
               }
            }
         }
      }
      
      public function FaceForward(param1:Boolean) : void
      {
         if(param1)
         {
            m_faceRight();
            m_facingForward = true;
         }
         else
         {
            m_faceLeft();
            m_facingForward = false;
         }
         m_facingForward = param1;
      }
      
      private function setAlpha(param1:Number) : void
      {
         if(param1 > 1)
         {
            param1 = 1;
         }
         else if(param1 < 0)
         {
            param1 = 0;
         }
         m_sprite.alpha = param1;
         if(this.m_hatMC)
         {
            this.m_hatMC.alpha = m_sprite.alpha;
         }
      }
      
      private function updateTint() : void
      {
         if(m_team_id > 0 && !ModeFeatures.hasFeature(ModeFeatures.IGNORE_TEAM_COSTUME,STAGEDATA.GameRef.GameMode) && m_sprite.filters == null)
         {
            switch(m_team_id)
            {
               case 1:
                  setTint(1,1,1,1,90,0,0,0);
                  break;
               case 2:
                  setTint(1,1,1,1,0,90,0,0);
                  break;
               case 3:
                  setTint(1,1,1,1,0,0,90,0);
                  break;
               case 4:
                  setTint(1,1,1,1,90,72,0,0);
            }
         }
      }
      
      public function advanceAllEffects() : void
      {
         this.m_yoshiEggMC.stance.nextFrame();
         if(this.m_poisonEffect.parent)
         {
            Utils.advanceFrame(this.m_poisonEffect);
         }
      }
      
      public function pauseAllEffects() : void
      {
         if(this.m_starKOMC != null && this.m_starKOMC.parent != null && this.m_starKOMC.parent.parent != null && this.m_starKOMC.root != null && Boolean(this.m_starKOMC.stance))
         {
            MovieClip(this.m_starKOMC.parent.parent).stop();
            this.m_starKOMC.stance.stop();
         }
         this.m_pidHolderMC.visible = false;
         if(this.m_chargeGlowHolderMC != null)
         {
            Utils.recursiveMovieClipPlay(this.m_chargeGlowHolderMC,false,true);
            this.m_chargeGlowHolderMC.stop();
         }
         Utils.recursiveMovieClipPlay(this.m_shieldHolderMC,false,true);
         this.m_shieldHolderMC.stop();
         if(this.HasFinalSmash)
         {
            this.m_fsGlowHolderMC.stop();
            Utils.recursiveMovieClipPlay(this.m_fsGlowHolderMC,false,true);
         }
         if(this.m_warioWareIcon)
         {
            this.m_warioWareIcon.stop();
         }
         this.m_poisonEffect.stop();
         this.m_pitfallEffect.stop();
         this.m_burnSmoke.stop();
         this.m_darknessSmoke.stop();
         this.m_auraSmoke.stop();
         this.m_starmanInvincibility.stop();
         this.m_healEffect.stop();
         if(this.m_offScreenBubble)
         {
            this.m_offScreenBubble.visible = false;
         }
      }
      
      public function playAllEffects() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         if(this.m_chargeGlowHolderMC != null)
         {
            Utils.recursiveMovieClipPlay(this.m_chargeGlowHolderMC,true,true);
            this.m_chargeGlowHolderMC.play();
         }
         if(this.HasFinalSmash)
         {
            this.m_fsGlowHolderMC.play();
            Utils.recursiveMovieClipPlay(this.m_fsGlowHolderMC,true,true);
         }
         if(this.m_starKOMC != null && this.m_starKOMC.parent != null && this.m_starKOMC.parent.parent != null && this.m_starKOMC.root != null && Boolean(this.m_starKOMC.stance))
         {
            if(Boolean(this.m_screenKO) && this.m_starKOMC != null)
            {
               this.m_starKOMC.visible = true;
               this.m_screenKOHolder.visible = true;
            }
            _loc1_ = 0;
            while(_loc1_ < STAGEDATA.Players.length)
            {
               if(Boolean(STAGEDATA.Players[_loc1_] && STAGEDATA.Players[_loc1_] != this) && Boolean(STAGEDATA.Players[_loc1_].ScreenKO) && STAGEDATA.Players[_loc1_].StarKOMC != null)
               {
                  STAGEDATA.Players[_loc1_].StarKOMC.visible = true;
                  STAGEDATA.Players[_loc1_].ScreenKOHolder.visible = true;
               }
               _loc1_++;
            }
            MovieClip(this.m_starKOMC.parent.parent).nextFrame();
            Utils.recursiveMovieClipPlay(this.m_starKOMC.stance,true);
         }
         Utils.recursiveMovieClipPlay(this.m_shieldHolderMC,true,true);
         this.m_shieldHolderMC.play();
         this.m_pidHolderMC.visible = true;
         if(this.m_warioWareIcon)
         {
            this.m_warioWareIcon.play();
         }
         this.m_poisonEffect.play();
         this.m_pitfallEffect.play();
         this.m_burnSmoke.play();
         this.m_darknessSmoke.play();
         this.m_auraSmoke.play();
         this.m_starmanInvincibility.play();
         this.m_healEffect.play();
         if(this.m_offScreenBubble)
         {
            this.m_offScreenBubble.visible = true;
         }
      }
      
      private function checkPause() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Character = null;
         var _loc3_:Character = null;
         _loc1_ = 0;
         _loc2_ = null;
         if(Boolean(this.m_human) && Boolean(ModeFeatures.hasFeature(ModeFeatures.ALLOW_STOCK_STEAL,STAGEDATA.GameRef.GameMode)) && !STAGEDATA.Paused && m_team_id > 0 && STAGEDATA.GameRef.UsingLives && this.m_lives <= 0 && Boolean(this.m_pressedControls.START))
         {
            _loc1_ = 0;
            while(_loc1_ <= STAGEDATA.Players.length)
            {
               _loc3_ = STAGEDATA.getPlayerByID(_loc1_);
               if(Boolean(_loc3_ && _loc3_ && _loc3_.ID != m_player_id && _loc3_.Team == m_team_id && !_loc3_.Dead && _loc3_.getLives() > 1) && Boolean(!(_loc2_ && _loc2_.getLives() > _loc3_.getLives())) && !((_loc3_.inState(CState.SCREEN_KO) || _loc3_.inState(CState.STAR_KO)) && _loc3_.getLives() <= 1))
               {
                  _loc2_ = _loc3_;
               }
               _loc1_++;
            }
            if(_loc2_)
            {
               _loc2_.stealStock();
               ++this.m_lives;
               m_sprite.x = this.m_playerSettings.x_respawn;
               m_sprite.y = this.m_playerSettings.y_respawn;
               this.reset();
               this.setInvincibility(true);
               this.setState(CState.REVIVAL);
               this.m_pauseLetGo = false;
               showHealthBoxes(true);
               this.updateLivesDisplay();
            }
         }
         if(Boolean(this.m_key) && !this.m_key.IsDown(this.m_key._START))
         {
            this.m_pauseLetGo = true;
         }
         if(Boolean(this.m_key) && !this.m_key.IsDown(this.m_key._GRAB))
         {
            this.m_zLetGo = true;
         }
      }
      
      private function updateComboValues() : void
      {
         var _loc1_:Character = null;
         _loc1_ = this.m_comboID > 0 ? STAGEDATA.getCharacterByUID(this.m_comboID) : null;
         if(_loc1_ != null)
         {
            if(!(_loc1_.ActionShot || _loc1_.HitLag > 0 || _loc1_.inState(CState.CRASH_GETUP) || _loc1_.inState(CState.CRASH_LAND) || _loc1_.inState(CState.TECH_GROUND) || _loc1_.inState(CState.TECH_ROLL) || _loc1_.inState(CState.ROLL) || _loc1_.inState(CState.CRASH_GETUP) || _loc1_.inState(CState.CAUGHT) || _loc1_.inState(CState.INJURED) || _loc1_.inState(CState.FLYING)))
            {
               if(this.m_comboTimer.IsComplete)
               {
                  this.m_comboCount = 0;
                  this.m_comboID = 0;
                  this.m_comboDamage = 0;
                  this.m_comboDamageTotal = 0;
               }
               else
               {
                  this.m_comboTimer.tick();
               }
            }
         }
      }
      
      private function checkStarKOClips() : void
      {
         if(Boolean(this.m_starKOHolder) && Boolean(this.m_starKOHolder.visible) && this.m_starKOHolder.currentFrame >= this.m_starKOHolder.totalFrames)
         {
            if(Boolean(this.m_starKOMC) && Boolean(this.m_starKOMC.parent))
            {
               this.m_starKOMC.parent.removeChild(this.m_starKOMC);
               this.m_starKOMC = null;
            }
            this.m_starKOHolder.visible = false;
            this.m_starKOHolder.gotoAndStop(1);
         }
         if(Boolean(this.m_screenKOHolder) && Boolean(this.m_screenKOHolder.visible) && this.m_screenKOHolder.currentFrame >= this.m_screenKOHolder.totalFrames)
         {
            if(Boolean(this.m_starKOMC) && Boolean(this.m_starKOMC.parent))
            {
               this.m_starKOMC.parent.removeChild(this.m_starKOMC);
               this.m_starKOMC = null;
            }
            this.m_screenKOHolder.visible = false;
            this.m_screenKOHolder.gotoAndStop(1);
         }
      }
      
      public function pauseControlChecks() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         if(!this.m_pauseFreeze)
         {
            this.m_pauseFreeze = true;
            if(HasStance)
            {
               MC.stance.stop();
            }
            this.pauseAllEffects();
            this.m_pauseLetGo = false;
            this.m_zLetGo = false;
            Utils.recursiveMovieClipPlay(m_sprite.stance,false);
         }
         this.m_getKey();
         _loc1_ = 0;
         if(Boolean(this.m_human) && m_player_id == STAGEDATA.PausedID)
         {
            if(Boolean(this.m_key.getControlStatus().BUTTON2) && !this.m_key.getControlStatus().BUTTON1)
            {
               CAM.zoomIn();
               if(CAM.Height < STAGEDATA.PauseCamHeight)
               {
                  if(Boolean(this.m_screenKO) && this.m_starKOMC != null)
                  {
                     this.m_starKOMC.visible = false;
                     this.m_screenKOHolder.visible = false;
                  }
                  _loc1_ = 0;
                  while(_loc1_ < STAGEDATA.Players.length)
                  {
                     if(Boolean(STAGEDATA.Players[_loc1_] && STAGEDATA.Players[_loc1_] != this) && Boolean(STAGEDATA.Players[_loc1_].ScreenKO) && STAGEDATA.Players[_loc1_].StarKOMC != null)
                     {
                        STAGEDATA.Players[_loc1_].StarKOMC.visible = false;
                        STAGEDATA.Players[_loc1_].ScreenKOHolder.visible = false;
                     }
                     _loc1_++;
                  }
               }
            }
            else if(Boolean(this.m_key.getControlStatus().BUTTON1) && !this.m_key.getControlStatus().BUTTON2)
            {
               CAM.zoomOut();
               if(CAM.Height >= STAGEDATA.PauseCamHeight)
               {
                  if(Boolean(this.m_screenKO) && this.m_starKOMC != null)
                  {
                     this.m_starKOMC.visible = true;
                     this.m_screenKOHolder.visible = true;
                  }
                  _loc1_ = 0;
                  while(_loc1_ < STAGEDATA.Characters.length)
                  {
                     if(Boolean(STAGEDATA.Characters[_loc1_] && STAGEDATA.Characters[_loc1_] != this) && Boolean(STAGEDATA.Characters[_loc1_].ScreenKO) && STAGEDATA.Characters[_loc1_].StarKOMC != null)
                     {
                        STAGEDATA.Characters[_loc1_].StarKOMC.visible = true;
                        STAGEDATA.Characters[_loc1_].ScreenKOHolder.visible = true;
                     }
                     _loc1_++;
                  }
               }
            }
            if(this.m_key.getControlStatus().LEFT !== this.m_key.getControlStatus().RIGHT)
            {
               if(this.m_key.getControlStatus().LEFT)
               {
                  if(this.m_pauseCamXSpeed > 0)
                  {
                     this.m_pauseCamXSpeed = 0;
                  }
                  CAM.panLeft(CAM.CamMC.scaleX * -this.m_pauseCamXSpeed);
                  this.m_pauseCamXSpeed -= this.PAUSE_CAM_ACCEL;
                  if(this.m_pauseCamXSpeed < -this.PAUSE_CAM_MAX_SPEED)
                  {
                     this.m_pauseCamXSpeed = -this.PAUSE_CAM_MAX_SPEED;
                  }
               }
               else if(this.m_key.getControlStatus().RIGHT)
               {
                  if(this.m_pauseCamXSpeed < 0)
                  {
                     this.m_pauseCamXSpeed = 0;
                  }
                  CAM.panRight(CAM.CamMC.scaleX * this.m_pauseCamXSpeed);
                  this.m_pauseCamXSpeed += this.PAUSE_CAM_ACCEL;
                  if(this.m_pauseCamXSpeed > this.PAUSE_CAM_MAX_SPEED)
                  {
                     this.m_pauseCamXSpeed = this.PAUSE_CAM_MAX_SPEED;
                  }
               }
            }
            else
            {
               this.m_pauseCamXSpeed = 0;
            }
            if(this.m_key.getControlStatus().DOWN !== this.m_key.getControlStatus().UP)
            {
               if(this.m_key.getControlStatus().DOWN)
               {
                  if(this.m_pauseCamYSpeed < 0)
                  {
                     this.m_pauseCamYSpeed = 0;
                  }
                  CAM.panDown(CAM.CamMC.scaleX * this.m_pauseCamYSpeed);
                  this.m_pauseCamYSpeed += this.PAUSE_CAM_ACCEL;
                  if(this.m_pauseCamYSpeed > this.PAUSE_CAM_MAX_SPEED)
                  {
                     this.m_pauseCamYSpeed = this.PAUSE_CAM_MAX_SPEED;
                  }
               }
               else if(this.m_key.getControlStatus().UP)
               {
                  if(this.m_pauseCamYSpeed > 0)
                  {
                     this.m_pauseCamYSpeed = 0;
                  }
                  CAM.panUp(CAM.CamMC.scaleX * -this.m_pauseCamYSpeed);
                  this.m_pauseCamYSpeed -= this.PAUSE_CAM_ACCEL;
                  if(this.m_pauseCamYSpeed < -this.PAUSE_CAM_MAX_SPEED)
                  {
                     this.m_pauseCamYSpeed = -this.PAUSE_CAM_MAX_SPEED;
                  }
               }
            }
            else
            {
               this.m_pauseCamYSpeed = 0;
            }
         }
         else if(!STAGEDATA.GameEnded && m_player_id == STAGEDATA.PausedID)
         {
            _loc2_ = Boolean(this.m_key.IsDown(this.m_key._LEFT)) || STAGEDATA.getPlayerByID(1) == null && STAGEDATA.getControllerNum(1).IsDown(STAGEDATA.getControllerNum(1)._LEFT) ? true : false;
            _loc3_ = Boolean(this.m_key.IsDown(this.m_key._RIGHT)) || STAGEDATA.getPlayerByID(1) == null && STAGEDATA.getControllerNum(1).IsDown(STAGEDATA.getControllerNum(1)._RIGHT) ? true : false;
            _loc4_ = Boolean(this.m_key.IsDown(this.m_key._UP)) || STAGEDATA.getPlayerByID(1) == null && STAGEDATA.getControllerNum(1).IsDown(STAGEDATA.getControllerNum(1)._UP) ? true : false;
            _loc5_ = Boolean(this.m_key.IsDown(this.m_key._DOWN)) || STAGEDATA.getPlayerByID(1) == null && STAGEDATA.getControllerNum(1).IsDown(STAGEDATA.getControllerNum(1)._DOWN) ? true : false;
            _loc6_ = Boolean(this.m_key.IsDown(this.m_key._BUTTON1)) || STAGEDATA.getPlayerByID(1) == null && STAGEDATA.getControllerNum(1).IsDown(STAGEDATA.getControllerNum(1)._BUTTON1);
            _loc7_ = Boolean(this.m_key.IsDown(this.m_key._BUTTON2)) || STAGEDATA.getPlayerByID(1) == null && STAGEDATA.getControllerNum(1).IsDown(STAGEDATA.getControllerNum(1)._BUTTON2);
            _loc8_ = this.m_key.IsDown(this.m_key._SHIELD) ? true : false;
            _loc9_ = this.m_key.IsDown(this.m_key._GRAB) ? true : false;
            _loc10_ = STAGEDATA.PausedID == m_player_id ? Boolean(this.m_key.IsDown(this.m_key._START)) || STAGEDATA.getPlayerByID(1) == null && STAGEDATA.getControllerNum(1).IsDown(STAGEDATA.getControllerNum(1)._START) : Boolean(this.m_key.getControlStatus().START);
            if(_loc7_ && !_loc6_)
            {
               CAM.zoomIn();
               if(CAM.Height < STAGEDATA.PauseCamHeight)
               {
                  if(Boolean(this.m_screenKO) && this.m_starKOMC != null)
                  {
                     this.m_starKOMC.visible = false;
                     this.m_screenKOHolder.visible = false;
                  }
                  _loc1_ = 0;
                  while(_loc1_ < STAGEDATA.Characters.length)
                  {
                     if(Boolean(STAGEDATA.Characters[_loc1_] && STAGEDATA.Characters[_loc1_] != this) && Boolean(STAGEDATA.Characters[_loc1_].ScreenKO) && STAGEDATA.Characters[_loc1_].StarKOMC != null)
                     {
                        STAGEDATA.Characters[_loc1_].StarKOMC.visible = false;
                        STAGEDATA.Characters[_loc1_].ScreenKOHolder.visible = false;
                     }
                     _loc1_++;
                  }
               }
            }
            else if(_loc6_ && !_loc7_)
            {
               CAM.zoomOut();
               if(CAM.Height >= STAGEDATA.PauseCamHeight)
               {
                  if(Boolean(this.m_screenKO) && this.m_starKOMC != null)
                  {
                     this.m_starKOMC.visible = true;
                     this.m_screenKOHolder.visible = true;
                  }
                  _loc1_ = 0;
                  while(_loc1_ < STAGEDATA.Characters.length)
                  {
                     if(Boolean(STAGEDATA.Characters[_loc1_] && STAGEDATA.Characters[_loc1_] != this) && Boolean(STAGEDATA.Characters[_loc1_].ScreenKO) && STAGEDATA.Characters[_loc1_].StarKOMC != null)
                     {
                        STAGEDATA.Characters[_loc1_].StarKOMC.visible = false;
                        STAGEDATA.Characters[_loc1_].ScreenKOHolder.visible = false;
                     }
                     _loc1_++;
                  }
               }
            }
            if(_loc2_ !== _loc3_)
            {
               if(_loc2_)
               {
                  if(this.m_pauseCamXSpeed > 0)
                  {
                     this.m_pauseCamXSpeed = 0;
                  }
                  CAM.panLeft(CAM.CamMC.scaleX * -this.m_pauseCamXSpeed);
                  this.m_pauseCamXSpeed -= this.PAUSE_CAM_ACCEL;
                  if(this.m_pauseCamXSpeed < -this.PAUSE_CAM_MAX_SPEED)
                  {
                     this.m_pauseCamXSpeed = -this.PAUSE_CAM_MAX_SPEED;
                  }
               }
               else if(_loc3_)
               {
                  if(this.m_pauseCamXSpeed < 0)
                  {
                     this.m_pauseCamXSpeed = 0;
                  }
                  CAM.panRight(CAM.CamMC.scaleX * this.m_pauseCamXSpeed);
                  this.m_pauseCamXSpeed += this.PAUSE_CAM_ACCEL;
                  if(this.m_pauseCamXSpeed > this.PAUSE_CAM_MAX_SPEED)
                  {
                     this.m_pauseCamXSpeed = this.PAUSE_CAM_MAX_SPEED;
                  }
               }
            }
            else
            {
               this.m_pauseCamXSpeed = 0;
            }
            if(_loc5_ !== _loc4_)
            {
               if(_loc5_)
               {
                  if(this.m_pauseCamYSpeed < 0)
                  {
                     this.m_pauseCamYSpeed = 0;
                  }
                  CAM.panDown(CAM.CamMC.scaleX * this.m_pauseCamYSpeed);
                  this.m_pauseCamYSpeed += this.PAUSE_CAM_ACCEL;
                  if(this.m_pauseCamYSpeed > this.PAUSE_CAM_MAX_SPEED)
                  {
                     this.m_pauseCamYSpeed = this.PAUSE_CAM_MAX_SPEED;
                  }
               }
               else if(_loc4_)
               {
                  if(this.m_pauseCamYSpeed > 0)
                  {
                     this.m_pauseCamYSpeed = 0;
                  }
                  CAM.panUp(CAM.CamMC.scaleX * -this.m_pauseCamYSpeed);
                  this.m_pauseCamYSpeed -= this.PAUSE_CAM_ACCEL;
                  if(this.m_pauseCamYSpeed < -this.PAUSE_CAM_MAX_SPEED)
                  {
                     this.m_pauseCamYSpeed = -this.PAUSE_CAM_MAX_SPEED;
                  }
               }
            }
            else
            {
               this.m_pauseCamYSpeed = 0;
            }
         }
         this.checkPause();
      }
      
      override public function PERFORMALL() : void
      {
         this.PREPERFORM();
         if(!inState(CState.DEAD) && !STAGEDATA.Paused && !((STAGEDATA.FSCutscene || STAGEDATA.FSCutins > 0) && !this.m_usingSpecialAttack && !this.m_finalSmashCutinMC) && !this.m_standby)
         {
            this.tickTime();
            if(!this.IsFrozenInTime)
            {
               this.m_getKey();
               this.checkRecovery();
               this.checkFrameControl();
               this.advanceAllEffects();
               this.checkTimers();
               this.checkHitLag();
               this.m_checkRevival();
            }
            this.m_checkBounds();
            if(!this.IsFrozenInTime)
            {
               this.m_checkDeath();
               this.m_checkInvincible();
               this.m_checkStun();
               this.m_checkDizzy();
               this.m_checkPitfall();
               this.m_checkFrozen();
               this.m_checkSleeping();
               this.m_checkEgg();
               this.m_checkTeching();
               this.m_forces();
               this.m_groundCollisionTest();
               this.m_checkItem();
               this.m_charShield();
               this.m_charGrab();
               this.m_charJump();
               this.m_charAttack();
               this.m_charRoll();
               this.m_charHang();
               this.m_charCrouch();
               this.m_charRun();
               this.m_charWallCling();
               this.m_charFall();
               this.m_charGlide();
               this.m_checkTaunt();
               this.m_pushAwayItems();
               this.m_pushAwayOpponents();
               this.pushAwayFromWalls();
               this.m_checkFinalForm();
               this.m_flipDirection();
               this.checkRocket();
               this.checkDI();
               updateSelfPlatform();
               this.getLastYPosition();
               this.checkFrameControl();
               this.updateTint();
               this.checkHitStun();
            }
            this.updateComboValues();
            this.checkPause();
            this.m_pauseFreeze = false;
            this.checkShowHitBoxes();
            this.positionEffects();
            if(!this.IsFrozenInTime)
            {
               this.checkStarKOClips();
               this.checkSyncedProjectiles();
               this.checkDeadProjectiles();
               this.updateItemHolding();
               updateCamerBox();
            }
         }
         else if(inState(CState.DEAD) || !inState(CState.DEAD) && Boolean(this.m_standby))
         {
            this.tickTime();
            if(!this.m_standby)
            {
               this.m_getKey();
               this.checkPause();
               this.m_pauseFreeze = false;
            }
            this.checkStarKOClips();
         }
         this.POSTPERFORM();
      }
      
      override protected function PREPERFORM() : void
      {
         m_actionTimerUpdatedOnFrame = false;
         if(Boolean(Main.DEBUG) && Boolean(MenuController.debugConsole.OnlineCapture))
         {
            this.m_preFrameInfo = this.getFrameData();
         }
         if(m_started && HasStance && !inState(CState.DEAD) && !this.m_standby && !this.m_freezePlayback && !STAGEDATA.Paused && !((Boolean(STAGEDATA.FSCutscene) || STAGEDATA.FSCutins > 0) && !this.m_usingSpecialAttack) && !isHitStunOrParalysis() && !m_delayPlayback)
         {
            if(!this.IsFrozenInTime)
            {
               Utils.advanceFrame(m_sprite.stance);
               Utils.recursiveMovieClipPlay(m_sprite.stance,true);
            }
         }
         else
         {
            handleDelayPlayback();
         }
         if(Boolean(!STAGEDATA.Paused && !((Boolean(STAGEDATA.FSCutscene) || STAGEDATA.FSCutins > 0) && !this.m_usingSpecialAttack) && m_started && this.m_starKOMC != null && this.m_starKOMC.parent != null && this.m_starKOMC.parent.parent != null && this.m_starKOMC.root != null && this.m_starKOMC.stance) && Boolean(!this.m_freezePlayback) && Boolean(this.m_starKOMC.visible))
         {
            if(!this.IsFrozenInTime)
            {
               MovieClip(this.m_starKOMC.parent.parent).nextFrame();
               Utils.recursiveMovieClipPlay(this.m_starKOMC.stance,true);
               Utils.advanceFrame(this.m_starKOMC.stance);
            }
         }
      }
      
      override protected function POSTPERFORM() : void
      {
         if(!STAGEDATA.Paused && !((Boolean(STAGEDATA.FSCutscene) || STAGEDATA.FSCutins > 0) && !this.m_usingSpecialAttack))
         {
            if(HasStance)
            {
               if(!this.IsFrozenInTime)
               {
                  m_sprite.stance.stop();
                  Utils.recursiveMovieClipPlay(m_sprite.stance,false);
               }
               this.updatePaletteSwap();
               this.checkOffScreenBubble();
               this.checkReflection();
               this.checkShadow();
            }
            if(this.m_starKOMC != null && this.m_starKOMC.parent != null && this.m_starKOMC.parent.parent != null && this.m_starKOMC.root != null && Boolean(this.m_starKOMC.stance))
            {
               if(!this.IsFrozenInTime)
               {
                  MovieClip(this.m_starKOMC.parent.parent).stop();
                  Utils.recursiveMovieClipPlay(this.m_starKOMC.stance,false);
                  this.m_starKOMC.stance.stop();
               }
            }
            m_started = true;
            if(!this.IsFrozenInTime)
            {
               m_apiInstance.update();
            }
         }
         if(!STAGEDATA.Paused && m_player_id > 0 && !STAGEDATA.ReplayMode && Boolean(ModeFeatures.hasFeature(ModeFeatures.ALLOW_REPLAY_RECORD,STAGEDATA.GameRef.GameMode)) && Boolean(this.m_human))
         {
            STAGEDATA.ReplayDataObj.pushControls(m_player_id,this.m_key.getControlsObject().controls);
         }
      }
      
      override public function get IsFrozenInTime() : Boolean
      {
         return this.m_frozenInTime;
      }
      
      public function applyTimeFreeze(param1:int = -1) : void
      {
         this.m_frozenInTime = param1 != 0;
         this.m_frozenInTimeTimer = param1;
      }
      
      public function removeTimeFreeze() : void
      {
         this.m_frozenInTime = false;
         this.m_frozenInTimeTimer = 0;
      }
      
      public function tickTime() : void
      {
         if(this.m_frozenInTime)
         {
            if(this.m_frozenInTimeTimer > 0)
            {
               --this.m_frozenInTimeTimer;
               if(this.m_frozenInTimeTimer == 0)
               {
                  this.removeTimeFreeze();
               }
            }
         }
      }
      
      public function stopTime(param1:int = -1, param2:int = 0, param3:int = 2147483646, param4:Object = null) : void
      {
         var _loc5_:Object = null;
         var _loc6_:* = undefined;
         if(param3 <= 0)
         {
            return;
         }
         _loc5_ = {
            "bypassProjectile":false,
            "bypassEnemy":false
         };
         param4 = param4 == null ? _loc5_ : param4;
         for(_loc6_ in _loc5_)
         {
            if(param4[_loc6_] === undefined)
            {
               param4[_loc6_] = _loc5_[_loc6_];
            }
         }
         this.STAGEDATA.addCharacterTimeStopper(m_uid,param1,param2,param3,param4);
      }
      
      public function resumeTime() : void
      {
         this.STAGEDATA.removeCharacterTimeStopper(m_uid);
      }
      
      public function get TimeFreezeLength() : int
      {
         return this.m_frozenInTimeTimer;
      }
      
      override public function attachEffect(param1:*, param2:Object = null) : MovieClip
      {
         var _loc3_:MovieClip = null;
         _loc3_ = super.attachEffect(param1,param2);
         if(_loc3_)
         {
            _loc3_.uid = m_uid;
         }
         return _loc3_;
      }
      
      override public function attachEffectOverlay(param1:*, param2:Object = null) : MovieClip
      {
         var _loc3_:MovieClip = null;
         _loc3_ = super.attachEffectOverlay(param1,param2);
         if(_loc3_)
         {
            _loc3_.uid = m_uid;
         }
         return _loc3_;
      }
   }
}


//=============================================================================
// ControlledDifficulty_Survival
//=============================================================================
// The core class of CD game (based on Blackout Edition)
//=============================================================================

class CD_Survival extends KFGameInfo_Survival
	config( CombinedCD );

`include(CD_BuildInfo.uci)
`include(CD_Log.uci)
`include(CD_General.uci)

/* ==============================================================================================================================
 *	Original Variables
 * ============================================================================================================================== */

enum ECDWaveInfoStatus
{
	WIS_OK,
	WIS_PARSE_ERROR,
	WIS_SPAWNCYCLE_NOT_MODDED
};

enum ECDZTSpawnMode
{
	ZTSM_UNMODDED,
	ZTSM_CLOCKWORK
};

enum ECDBossChoice
{
	CDBOSS_RANDOM,
	CDBOSS_VOLTER,
	CDBOSS_PATRIARCH,
	CDBOSS_KINGFLESHPOUND,
	CDBOSS_KINGBLOAT,
	CDBOSS_MATRIARCH,
	CDBOSS_ALL,
	CDBOSS_CYST
};

enum ECDAuthLevel
{
	CDAUTH_READ,
	CDAUTH_WRITE
};

struct StructAuthorizedUsers
{
	var string SteamID;
	var string Comment;
};

////////////////////
// Config options //
////////////////////

var config string CohortSize;
var config const array<string> CohortSizeDefs;
var int CohortSizeInt;

var config string MaxMonsters;
var config const array<string> MaxMonstersDefs;
var int MaxMonstersInt;

var config string SpawnMod;
var config const array<string> SpawnModDefs;
var float SpawnModFloat;

var config string SpawnPoll;
var config const array<string> SpawnPollDefs; 
var float SpawnPollFloat;

var config string ZTSpawnMode;
var ECDZTSpawnMode ZTSpawnModeEnum;

var config string ZTSpawnSlowdown;
var config const array<string> ZTSpawnSlowdownDefs;
var float ZTSpawnSlowdownFloat;


var config string AlbinoCrawlers;
var bool AlbinoCrawlersBool;

var config string AlbinoAlphas;
var bool AlbinoAlphasBool;

var config string AlbinoGorefasts;
var bool AlbinoGorefastsBool;

var config string Boss;
var ECDBossChoice BossEnum;

var config string FleshpoundRageSpawns;
var bool FleshpoundRageSpawnsBool;

var config string SpawnCycle;
var config array<string> SpawnCycleDefs;
var array<CD_AIWaveInfo> SpawnCycleWaveInfos;

var config string WaveSizeFakes; 
var config const array<string> WaveSizeFakesDefs; 
var int WaveSizeFakesInt;

var config string BossHPFakes;
var config const array<string> BossHPFakesDefs;
var int BossHPFakesInt;

var config string FleshpoundHPFakes;
var config const array<string> FleshpoundHPFakesDefs;
var int FleshpoundHPFakesInt;

var config string QuarterPoundHPFakes;
var config const array<string> QuarterPoundHPFakesDefs;
var int QuarterPoundHPFakesInt;

var config string ScrakeHPFakes;
var config const array<string> ScrakeHPFakesDefs;
var int ScrakeHPFakesInt;

var config string TrashHPFakes;
var config const array<string> TrashHPFakesDefs;
var int TrashHPFakesInt;

var config array<StructAuthorizedUsers> AuthorizedUsers;
var array<StructAuthorizedUsers> Moderator;

var ECDAuthLevel DefaultAuthLevel;

var config string AutoPause;
var bool bAutoPause;

var config string CountHeadshotsPerPellet;
var bool bCountHeadshotsPerPellet;

var config string EnableReadySystem;
var bool bEnableReadySystem;

var config string TraderTime;
var int TraderTimeInt;

var config string ZedsTeleportCloser;
var bool ZedsTeleportCloserBool;

var config bool bLogControlledDifficulty;

////////////////////////////////////////////////////////////////
// Internal runtime state (no config options below this line) //
////////////////////////////////////////////////////////////////
var array<CD_AIWaveInfo> IniWaveInfos;
var array<sGameMode> CDGameModes;

var CD_DifficultyInfo CDDI;
var CD_ConsolePrinter GameInfo_CDCP;
var CD_SpawnCycleCatalog SpawnCycleCatalog;
var CD_ChatCommander ChatCommander;
var CD_StatsSystem StatsSystem;

var bool AlreadyLoadedIniWaveInfos;
var int PausedRemainingTime;
var int PausedRemainingMinute;
var int DebugExtraProgramPlayers;
var string DynamicSettingsBulletin;

var const float SpawnModEpsilon;
var const float SpawnPollEpsilon;
var const float ZTSpawnSlowdownEpsilon;

/* ==============================================================================================================================
 *	Additional Settings
 * ============================================================================================================================== */

struct PickupSetting
{
	var bool DisableOthers;
	var bool DropLocked;
	var bool DisableLowAmmo;
	var bool bAntiOvercap;
	var PlayerReplicationinfo PRI;
};

struct WeaponDetail
{
	var string WeapName;
	var int UpgradeCount;
	var int WeapCount;
};

struct PlayerInvInfo
{
	var PlayerReplicationInfo PRI;
	var class<KFPerk> Perk;
	var string Skill;
	var array<WeaponDetail> Inv;
};

struct CDSettings
{
	var bool AlbinoAlphas, AlbinoCrawlers, AlbinoGorefasts, DisableRobots;
	var bool DisableSpawners, FPRageSpawns, ZedsTeleportCloser;
	var bool StartwithFullAmmo, StartwithFullArmor, StartwithFullGrenade;
	var int StartingWeapTier, HPFakes;

	StructDefaultProperties
	{
		AlbinoAlphas = true
		AlbinoCrawlers = true
		AlbinoGorefasts = true
		DisableRobots = true
		DisableSpawners = true
		FPRageSpawns = false
		ZedsTeleportCloser = true
		StartwithFullAmmo = true
		StartwithFullArmor = false
		StartwithFullGrenade = true
		StartingWeapTier = 1
		HPFakes = 6
	}
};

var string ReleaseVersion, DebugVersion;
var config string StartwithFullAmmo;
var bool bStartwithFullAmmo;
var config string StartwithFullGrenade;
var bool bStartwithFullGrenade;
var config string StartwithFullArmor;
var bool bStartwithFullArmor;
var config string StartingWeaponTier;
var int StartingWeaponTierInt;
var config string BossDifficulty;
var int BossDifficultyInt;
var config string DisableBossMinions;
var bool bDisableBossMinions;
var config string DisableSpawners;
var bool bDisableSpawners;
var config string DisableRobots;
var bool bDisableRobots;
var config string DisableBoss;
var bool bDisableBoss;

var config bool bLargeLess;
var config bool bSolePerksSystem;
var config int INIVer;
var config int MaxUpgrade;
var config CDSettings DefaultCDSettings;

var CD_AuthorityHandler AuthorityHandler;
var CD_DroppedPickupTracker PickupTracker;
var CD_GameReplicationInfo CDGRI;
var CD_Recorder Recorder;
var CD_SettingManager SettingManager;
var CD_SettingSynchronizer SettingSynchronizer;
var CD_SpawnCycleAnalyzer SpawnCycleAnalyzer;
var CD_TraderItemsHelper TraderHelper;
var CD_ZT_SpawnManager ZTSpawnManager;
var xVotingHandler xMut;

var array<PickupSetting> PickupSettings;
var int DeadBoss;
var int PlayerCountToRec;
var bool bUsedWinMatch;
var bool bShouldRecord;
var bool bIsUTM;
var string HelpURL;

/* ==============================================================================================================================
 *	Initialize
 * ============================================================================================================================== */

delegate int ClampIntCDOption( const out int raw );
delegate float ClampFloatCDOption( const out float raw );
delegate bool StringReferencePredicate( const out string value );

event InitGame( string Options, out string ErrorMessage )
{
 	Super.InitGame( Options, ErrorMessage );
	
	GameModes = CDGameModes;
	bLargeLess = false;

	SpawnCycleCatalog = new class'CD_SpawnCycleCatalog';
	SpawnCycleCatalog.Initialize( AIClassList, GameInfo_CDCP, bLogControlledDifficulty );

	GameInfo_CDCP.Print( "Version " $ `CD_COMMIT_HASH $ " (" $ `CD_AUTHOR_TIMESTAMP $ ") loaded" );
	
	InitConfig();
	SaveConfig();

	if(ParseOption(Options, "EnableLog") != "1")
		DisableLogging();

	SetupGRI();

	SettingManager = new class 'CD_SettingManager';
	SettingManager.Initialize(self, Options);
	ChatCommander = new(self) class'CD_ChatCommander';
	ChatCommander.SetupChatCommands();
	StatsSystem = new(self) class'CD_StatsSystem';
	SpawnCycleAnalyzer = new(self) class'CD_SpawnCycleAnalyzer';
	ZTSpawnManager = new(self) class'CD_ZT_SpawnManager';
	SettingSynchronizer = new(self) class'CD_SettingSynchronizer';
	TraderHelper = Spawn(class'CD_TraderItemsHelper');
	PickupTracker = Spawn(class'CD_DroppedPickupTracker', Self);

	if(WorldInfo.NetMode != NM_Client)
	{
		AuthorityHandler = Spawn(class'CD_AuthorityHandler', self);
		Recorder = Spawn(class'CD_Recorder', self);
	}

	SetupExtraMutator();

	RefreshWebInfo();
	SetTimer(5.0, false, 'CheckMapInfo');
}

private function InitConfig()
{
	if(INIVer < 3)
	{
		MaxUpgrade = 1;
		INIVer = 3;
	}
}

private function DisableLogging()
{
	WorldInfo.ConsoleCommand("SUPPRESS Log");
	WorldInfo.ConsoleCommand("SUPPRESS ScriptLog");
    WorldInfo.ConsoleCommand("SUPPRESS DevNet");
    WorldInfo.ConsoleCommand("SUPPRESS DevOnline");
}

private function SetupGRI()
{
	CDGRI = CD_GameReplicationInfo(MyKFGRI);
	if(CDGRI == none)
		SetTimer(1.f, false, 'SetupGRI');

	else
	{
		CDGRI.MaxUpgrade = MaxUpgrade;
		CDGRI.bEnableSolePerksSystem = bSolePerksSystem;
	}
}

private function SetupExtraMutator(){
	foreach DynamicActors(class'xVotingHandler', xMut)
		break;

	if (xMut == None)
	{
		xMut = Spawn(class'xVotingHandler');
		xMut.CD = self;
	}
}

/**
 * Called everytime any actor spawns
 */
function bool CheckRelevance(Actor Other)
{
	local bool SuperRelevant;
	local KFWeapon KFW;
	local CD_DroppedPickup CDDP;
	local KFAIController KFAIC;

	// If mutator's check returns false, do nothing
	SuperRelevant = super.CheckRelevance(Other);
	if ( !SuperRelevant )
	{
		return SuperRelevant;
	}

	// If actor is weapon, replace its DroppedPickupClass with CD one
	KFW = KFWeapon(Other);
	if(KFW != None && KFW.DroppedPickupClass != class'CD_DroppedPickup')
	{
		KFW.DroppedPickupClass = class'CD_DroppedPickup';
		return SuperRelevant;
	}

	// If actor is dropped pickup, overwrite its life span and pickup tracker
	CDDP = CD_DroppedPickup(Other);
	if (CDDP != None)
	{
		CDDP.PickupTracker = PickupTracker;
		CDDP.Lifespan = MaxInt;
		CDDP.SetTimer(1.f, false, 'RefreshGlowState');
		return SuperRelevant;
	}

	// If actor is AI Zed, change their teleport availability
	KFAIC = KFAIController(Other);
	if ( None != KFAIC )
	{
		KFAIC.bCanTeleportCloser = ZedsTeleportCloserBool;
		`cdlog("Set bCanTeleportCloser="$ ZedsTeleportCloserBool $" on "$ KFAIC, bLogControlledDifficulty);
	}

	return SuperRelevant;
}

function SetGameSpeed( Float T )
{
	GameSpeed = FMax(T, 0.00001);
	WorldInfo.TimeDilation = GameSpeed;
	SetTimer(WorldInfo.TimeDilation, true);
	ZTSpawnManager.HandleZTSpawnMode();
}

/*
 * We override this function to keep it from calling SpawnManager.Update().  CD
 * does that separately through the SpawnManagerWakeup() function.  This
 * separation supports the SpawnPoll setting.
 */
event Timer()
{
	super(KFGameInfo).Timer();

	if ( GameConductor != none )
	{
		GameConductor.TimerUpdate();
	}
}

event PreLogin(string Options, string Address, const UniqueNetId UniqueId, bool bSupportsAuth, out string ErrorMessage)
{
	local bool bSpectator;
	local bool bPerfTesting;

	// Check for an arbitrated match in progress and kick if needed
	if (WorldInfo.NetMode != NM_Standalone && bUsingArbitration && bHasArbitratedHandshakeBegun)
	{
		ErrorMessage = PathName(WorldInfo.Game.GameMessageClass) $ ".ArbitrationMessage";
		return;
	}

	// If this player is banned, reject him
	if (AccessControl != none && AccessControl.IsIDBanned(UniqueId))
	{
		`log(Address@"is banned, rejecting...");
		ErrorMessage = "<Strings:KFGame.KFLocalMessage.BannedFromServerString>";
		return;
	}
	
	bPerfTesting = ( ParseOption( Options, "AutomatedPerfTesting" ) ~= "1" );
	bSpectator = bPerfTesting || ( ParseOption( Options, "SpectatorOnly" ) ~= "1" ) || ( ParseOption( Options, "CauseEvent" ) ~= "FlyThrough" );
	
	if (AccessControl != None)
	{
		AccessControl.PreLogin(Options, Address, UniqueId, bSupportsAuth, ErrorMessage, bSpectator);
	}
}

function GenericPlayerInitialization(Controller C)
{
	local CD_PlayerController CDPC;

	CDPC = CD_PlayerController(C);
	TraderHelper.CheckTraderList();

	super.GenericPlayerInitialization(C);

	if( CDPC != none )
	{
		CDPC.SetTimer(3.f, false, 'DelayedInitialization');

		if(IsStrangeSetting())
			CDPC.SetTimer(4.f, false, 'NotifyUniqueSettings');
	}

	SetTimer(2.f, false, 'RefreshWebInfo');
}

private function bool IsStrangeSetting()
{
	return (AlbinoAlphasBool		!= DefaultCDSettings.AlbinoAlphas ||
			AlbinoCrawlersBool		!= DefaultCDSettings.AlbinoCrawlers ||
			AlbinoGorefastsBool		!= DefaultCDSettings.AlbinoGorefasts ||
			bDisableRobots			!= DefaultCDSettings.DisableRobots ||
			bDisableSpawners		!= DefaultCDSettings.DisableSpawners ||
			FleshpoundRageSpawnsBool!= DefaultCDSettings.FPRageSpawns ||
			StartingWeaponTierInt	!= DefaultCDSettings.StartingWeapTier ||
			bStartwithFullAmmo		!= DefaultCDSettings.StartwithFullAmmo ||
			bStartwithFullArmor		!= DefaultCDSettings.StartwithFullArmor ||
			bStartwithFullGrenade	!= DefaultCDSettings.StartwithFullGrenade ||
			FleshpoundHPFakesInt	!= DefaultCDSettings.HPFakes ||
			ScrakeHPFakesInt		!= DefaultCDSettings.HPFakes ||
			QuarterpoundHPFakesInt	!= DefaultCDSettings.HPFakes ||
			TrashHPFakesInt			!= DefaultCDSettings.HPFakes ||
			ZedsTeleportCloserBool	!= DefaultCDSettings.ZedsTeleportCloser);
}

function Logout( Controller Exiting )
{
	if(PlayerController(Exiting) != none)
	{
		CD_GameReplicationInfo(MyKFGRI).LogoutCheck(PlayerController(Exiting));
		PickupTracker.LogoutCheck(PlayerController(Exiting).PlayerReplicationInfo);
		// TODO: Detect leaving for user stats
	}

	super.Logout(Exiting);
}

/**
 * To display custom zed kill ticker correctly
 */
function BroadcastDeathMessage(Controller Killer, Controller Other, class<DamageType> damageType)
{
	local class killerPawnClass;

	if ( (Killer == Other) || (Killer == None) )
	{
		// suicide
		BroadcastLocalized(self, class'KFLocalMessage_Game', KMT_Suicide, None, Other.PlayerReplicationInfo);
	}
	else if ( Killer.IsA('KFAIController') )
	{
		killerPawnClass = (Killer.Pawn == none)
			? class'KFPawn_Human'
			: class'CD_ZedNameUtils'.static.CheckClassRemap( Killer.Pawn.Class, "CD_Survival.BroadcastDeathMessage", bLogControlledDifficulty );
		BroadcastLocalized(self, class'KFLocalMessage_Game', KMT_Killed, none, Other.PlayerReplicationInfo, killerPawnClass );
	}
	else
	{
		BroadcastLocalized(self, class'KFLocalMessage_PlayerKills', KMT_PlayerKillPlayer, Killer.PlayerReplicationInfo, Other.PlayerReplicationInfo);
	}
}

function InitGameConductor()
{
	super.InitGameConductor();

	`cdlog("WaveSizeFakes in InitGameConductor(): "$ WaveSizeFakes, bLogControlledDifficulty);

	if ( GameConductor.isA( 'CD_DummyGameConductor' ) )
	{
		`cdlog("Checked that GameConductor "$GameConductor$" is an instance of CD_DummyGameConductor (OK)", bLogControlledDifficulty);
	}
	else
	{
		GameInfo_CDCP.Print("WARNING: GameConductor "$GameConductor$" appears to be misconfigured! CD might not work correctly.");
	}
}

function CreateDifficultyInfo(string Options)
{
	super.CreateDifficultyInfo(Options);

	// the preceding call should have initialized DifficultyInfo
	CDDI = CD_DifficultyInfo(DifficultyInfo);

	// log that we're done with the DI (note that CD_DifficultyInfo logs param values in its setters)
	`cdlog("CD_DifficultyInfo ready: " $ CDDI, bLogControlledDifficulty);
}

function ModifyAIDoshValueForPlayerCount( out float ModifiedValue )
{
	local float DoshMod;
	local int LocalNumPlayers;
	local float LocalMaxAIMod;

	LocalNumPlayers = GetNumPlayers();
	// Only pass actual players to GetPlayerNumMaxAIModifier -- it adds fakes internally
	LocalMaxAIMod = DifficultyInfo.GetPlayerNumMaxAIModifier(LocalNumPlayers);

	DoshMod = GetEffectivePlayerCount( LocalNumPlayers ) / LocalMaxAIMod;

	ModifiedValue *= DoshMod;
}

function InitSpawnManager()
{
	super.InitSpawnManager();

	if ( SpawnManager.IsA( 'CD_SpawnManager' ) )
	{
		`cdlog("Checked that SpawnManager "$SpawnManager$" is an instance of CD_SpawnManager (OK)", bLogControlledDifficulty);
	}
	else
	{
		GameInfo_CDCP.Print("WARNING: SpawnManager "$SpawnManager$" appears to be misconfigured! CD might not work correctly.");
	}
}

/**
 * This function is almost the same as the super one
 * but using CD_DifficultyInfo
 * and BossDifficulty setting is applied here.
 */
function SetMonsterDefaults( KFPawn_Monster P )
{
	local float HealthMod;
	local float HeadHealthMod;
	local float TotalSpeedMod, StartingSpeedMod;
	local float DamageMod;
	local int LivingPlayerCount, AIDifficultyInt;
	local int i;

	LivingPlayerCount = GetLivingPlayerCount();

	DamageMod = 1.0;
	HealthMod = 1.0;
	HeadHealthMod = 1.0;

	// Scale health and damage by game conductor values for versus zeds
	if( P.bVersusZed )
	{
		DifficultyInfo.GetVersusHealthModifier(P, LivingPlayerCount, HealthMod, HeadHealthMod);

		HealthMod *= GameConductor.CurrentVersusZedHealthMod;
		HeadHealthMod *= GameConductor.CurrentVersusZedHealthMod;

		// scale damage
		P.DifficultyDamageMod = DamageMod * GameConductor.CurrentVersusZedDamageMod;

		StartingSpeedMod = 1.f;
		TotalSpeedMod = 1.f;
	}
	else
	{
		AIDifficultyInt = P.IsABoss() ? BossDifficultyInt : int(GameDifficulty);

		DifficultyInfo.GetAIHealthModifier(P, AIDifficultyInt, LivingPlayerCount, HealthMod, HeadHealthMod);
		DamageMod = DifficultyInfo.GetAIDamageModifier(P, AIDifficultyInt, bOnePlayerAtStart);

		// scale damage
		P.DifficultyDamageMod = DamageMod;

		StartingSpeedMod = DifficultyInfo.GetAISpeedMod(P, AIDifficultyInt);
		TotalSpeedMod = GameConductor.CurrentAIMovementSpeedMod * StartingSpeedMod;
	}

	// scale movement speed
	P.GroundSpeed = P.default.GroundSpeed * TotalSpeedMod;
	P.SprintSpeed = P.default.SprintSpeed * TotalSpeedMod;

	// Store the difficulty adjusted ground speed to restore if we change it elsewhere
	P.NormalGroundSpeed = P.GroundSpeed;
	P.NormalSprintSpeed = P.SprintSpeed;
	P.InitialGroundSpeedModifier = StartingSpeedMod;

	// Scale health by difficulty
	P.Health = P.default.Health * HealthMod;
	P.HealthMax = ( P.default.HealthMax == 0 )
		? P.default.Health * HealthMod
		: P.default.HealthMax * HealthMod;

	P.ApplySpecialZoneHealthMod(HeadHealthMod);
	P.GameResistancePct = CDDI.GetDamageResistanceModifierForZedType( P, LivingPlayerCount );

	// look for special monster properties that have been enabled by the kismet node
	for (i = 0; i < ArrayCount(SpawnedMonsterProperties); i++)
	{
		// this property is currently enabled
		if (SpawnedMonsterProperties[i] != 0)
		{
			// do the action associated with that property
			switch (EMonsterProperties(i))
			{
				case EMonsterProperties_Enraged:
					P.SetEnraged(true);
					break;
				case EMonsterProperties_Sprinting:
					P.bSprintOverride=true;
					break;
			}
		}
	}
	
	// debug logging
   	`log("==== SetMonsterDefaults for pawn: " @P @"====",bLogAIDefaults);
	`log("HealthMod: " @HealthMod @ "Original Health: " @P.default.Health @" Final Health = " @P.Health, bLogAIDefaults);
	`log("HeadHealthMod: " @HeadHealthMod @ "Original Head Health: " @P.default.HitZones[HZI_HEAD].GoreHealth @" Final Head Health = " @P.HitZones[HZI_HEAD].GoreHealth, bLogAIDefaults);
	`log("GroundSpeedMod: " @TotalSpeedMod @" Final Ground Speed = " @P.GroundSpeed, bLogAIDefaults);
	`log("SprintSpeedMod: " @TotalSpeedMod @" Final Sprint Speed = " @P.SprintSpeed, bLogAIDefaults);
	`log("DamageMod: " @DamageMod @" Final Melee Damage = " @P.MeleeAttackHelper.BaseDamage * DamageMod, bLogAIDefaults);
}

event UpdateAIRemaining()
{
	if ( Role == ROLE_AUTHORITY )
	{
		if ( MyKFGRI != None && SpawnManager != none )
		{
			RefreshMonsterAliveCount();
			MyKFGRI.AIRemaining = Max(0.0f, SpawnManager.WaveTotalAI - NumAISpawnsQueued) + AIAliveCount;
		}
	}
}

function bool AllowWaveCheats()
{
	return true;
}

function RestartPlayer(Controller P)
{
	local CD_Pawn_Human Player;

	super.RestartPlayer(P);

	Player = CD_Pawn_Human(P.Pawn);	
	Player.ModifyInventory(bStartwithFullAmmo, bStartwithFullGrenade, bStartwithFullArmor, StartingWeaponTierInt);
}

function bool PreventDeath(Pawn Killed, Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	local KFWeapon TempWeapon;
	local KFPawn_Human KFP;
	
	KFP = KFPawn_Human(Killed);
	//	DropAllWeapons
	if (Role >= ROLE_Authority && KFP != None && KFP.InvManager != none)
	{
		foreach KFP.InvManager.InventoryActors(class'KFWeapon', TempWeapon)
		{
			if (TempWeapon != none && TempWeapon.bDropOnDeath && TempWeapon.CanThrow())
				KFP.TossInventory(TempWeapon);
		}
	}

	return Super.PreventDeath(Killed, Killer, damageType, HitLocation);
}

/**
 * This function is almost the same as the super one
 * but count the number of killed bosses
 * to handle multiple boss properly.
 */
function BossDied(Controller Killer, optional bool bCheckWaveEnded = true)
{
	local KFPawn_Monster AIP;
	local KFGameReplicationInfo KFGRI;
	local KFPlayerController KFPC;

	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
	{
		if (KFPC != none)
		{
			KFPC.ClientOnBossDied();
		}
	}

	KFPC = KFPlayerController(Killer);

	KFGRI = KFGameReplicationInfo(WorldInfo.GRI);
	if( KFGRI != none && !KFGRI.IsBossWave() )
	{
		return;
	}

 	// Extended zed time for an extra dramatic event
 	if(DeadBoss < 5 && BossEnum == CDBOSS_ALL) DramaticEvent( 1, 3.f );

	// Kill all zeds active zeds when the game ends
	DeadBoss += 1;
	if(DeadBoss == 5 || BossEnum != CDBOSS_ALL)
	{
		foreach WorldInfo.AllPawns(class'KFPawn_Monster', AIP)
		{
			if( AIP.Health > 0 )
			{
				AIP.Died(none , none, AIP.Location);
				DramaticEvent( 1, 6.f );
			}
		}
		if(bCheckWaveEnded)
		{
			CheckWaveEnd( true );
		}
	}
}

function bool PickupQuery(Pawn Other, class<Inventory> ItemClass, Actor Pickup)
{
	local CD_PickupQueryHandler PickupQueryHandler;

	if(Pickup == none)
	{
		return false;
	}

	PickupQueryHandler = new(self) class'CD_PickupQueryHandler';
	PickupQueryHandler.Initialize(Other, Pickup);

	return PickupQueryHandler.PickupQuery() || super.PickupQuery(Other, ItemClass, Pickup);
}

private function bool PickupSettingsAllowed(Pawn Other, Actor Pickup)
{
	local CD_PickupQueryHandler PickupQueryHandler;

	PickupQueryHandler = new(self) class'CD_PickupQueryHandler';
	PickupQueryHandler.Initialize(Other, Pickup);

	return PickupQueryHandler.PickupQuery(true);
}

function Killed( Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> damageType )
{
	local CD_PlayerController CDPC;
	local KFPawn_Monster KFPM;

	CDPC = CD_PlayerController(Killer);
	KFPM = KFPawn_Monster(KilledPawn);

	// Large Kill Sound & Ticker
	if (CDPC != None && KFPM != None && KFPM.bLargeZed)
	{
		CDPC.PlayLargeKillSound();

		if(KFAIController(KilledPlayer) != none && WorldInfo.NetMode != NM_Standalone)
		{
			foreach WorldInfo.AllControllers(class'CD_PlayerController', CDPC)
			{
				if(CDPC != Killer)
					CDPC.ReceiveLargeKillTicker(Killer.PlayerReplicationInfo, KFPM);
			}
		}
	}

	// Player Death Sound
	CDPC = CD_PlayerController(KilledPlayer);

	if(CDPC != none && MyKFGRI.bWaveIsActive && !MyKFGRI.bMatchIsOver && !CDPC.PlayerReplicationinfo.bWaitingPlayer)
	{
		foreach WorldInfo.AllControllers(class'CD_PlayerController', CDPC)
			CDPC.PlayPlayerDeathSound();
	}

	super.Killed(Killer, KilledPlayer, KilledPawn, damageType);
}

/* ==============================================================================================================================
 *	Match Progress & related
 * ============================================================================================================================== */

State TraderOpen
{
	function BeginState( Name PreviousStateName )
	{
		super.BeginState( PreviousStateName );
		CD_SpawnManager( SpawnManager ).WaveEnded();
		SetTimer(0.25, true, 'DecideDash');
		SetTimer(1.f, false, 'RefreshUnglowPickup');
		SetTimer(2.f, false, 'DisplayBriefWaveStatsInChat');
	}

	function EndState( Name NextStateName )
	{
		Ext_KillZeds();
		super.EndState( NextStateName );
		ClearTimer('DecideDash');
		ModTraderDash(false);
		SetTimer(1.f, false, 'RefreshUnglowPickup');
	}

	function CloseTraderTimer()
	{
		local CD_Pawn_DoshDrone DoshDrone;

		if(bDisableBoss && WaveNum == WaveMax-1) 
		{
			WinMatch();
		}
		else
		{
			super.CloseTraderTimer();
			ForEach WorldInfo.AllPawns(class'CD_Pawn_DoshDrone', DoshDrone)
			{
				DoshDrone.SetTurretState(ETS_Detonate);
			}
		}
	}
}

State MatchEnded
{
	function BeginState( Name PreviousStateName )
	{
		super.BeginState(PreviousStateName);
		SetTimer(AARDisplayDelay, false, nameof(ShowResultMenu));
	}
}

function EndOfMatch(bool bVictory)
{
	super.EndOfMatch(bVictory);

	if ( !bVictory && WaveNum < WaveMax )
	{
		CD_SpawnManager( SpawnManager ).WaveEnded();
		SetTimer(2.f, false, 'DisplayBriefWaveStatsInChat');
	}
}

function WaveEnded( EWaveEndCondition WinCondition )
{
	local string CDSettingChangeMessage;

	if(WaveNum == WaveMax - 1 && WinCondition != WEC_TeamWipedOut)
	{
		SaveFinalSettings();
		SetTimer(2.f, false, 'SaveAllUserStats');
		if (bShouldRecord) CDRecord();
		if (bDisableBoss)
		{
			DramaticEvent( 1, 6.f );
			WinMatch();
			SetTimer(2.f, false, 'DisplayBriefWaveStatsInChat');
		}
	}
	else if(WinCondition == WEC_TeamWipedOut)
	{
		SaveFinalSettings();
		SetTimer(2.f, false, 'SaveAllUserStats');
		if(WaveNum == WaveMax)
			xMut.bBossDefeat = true;
	}

	super.WaveEnded( WinCondition );

	if ( ApplyStagedConfig( CDSettingChangeMessage, "<local>CD_Survival.ApplySettingString</local>" ) )
	{
		BroadcastLocalizedEcho( CDSettingChangeMessage );
		RefreshWebInfo();
	}
	
	// AutoPause if it's enabled and game isn't over
	if (bAutoPause && WinCondition != WEC_TeamWipedOut && WinCondition != WEC_GameWon && !bUsedWinMatch)
	{
		BroadcastLocalizedEcho( PauseTraderTime() );
	}
	// Prep Ready System if it's enabled and game isn't over
	if (bEnableReadySystem && WinCondition != WEC_TeamWipedOut && WinCondition != WEC_GameWon && !bUsedWinMatch)
	{
		ChatCommander.UnreadyAllPlayers();
	}
}

function StartWave()
{
	local string CDSettingChangeMessage;

	RefreshWebInfo();

	if ( ApplyStagedConfig( CDSettingChangeMessage, "<local>CD_Survival.ApplySettingString</local>" ) )
	{
		BroadcastLocalizedEcho( CDSettingChangeMessage );
	}	

	ProgramSettingsForNextWave();

	// Restart the SpawnManager's wakeup timer.
	// This synchronizing effect is virtually unnoticeable when SpawnPoll is
	// low (say 1s), but very noticable when it is long (say 30s)
	ZTSpawnManager.SetSpawnManagerTimer();
	SetGameSpeed( WorldInfo.TimeDilation );
	
	super.StartWave();

	PlayerCountToRec = GetLivingPlayerCount();

	// If this is the first wave, print CD's settings
	if ( 1 == WaveNum )
	{
		SetTimer( 2.0f, false, 'DisplayWaveStartMessageInChat' );
	}
	else if ( WaveMax-1 == WaveNum )
	{
		SetTimer( 2.0f, false, 'SetShouldRecord');
	}
	else // If this is a noninitial wave and there are dynamic settings, then print their values
	{
		//SetTimer( 0.5f, false, 'DisplayDynamicSettingSummaryInChat' );
		DisplayDynamicSettingSummaryInChat();
	}

	if(SpawnCycle != "unmodded")
	{
		SetTimer(1.f, false, 'BriefCycleAnalisis');
	}

	DeactivateSpawners(bDisableSpawners);

	if(WaveNum > 1)
		CheckOvercaps();

	if(!bIsUTM)
		LogPlayersPerk();
}

function StartMatch()
{
	super.StartMatch();

	SetTimer(150.f, true, 'DisableDispawnMine');
}

state DebugSuspendWave
{
	ignores CheckWaveEnd;

	function BeginState( Name PreviousStateName )
	{
		DebugKillZeds();
	}

	function EndState( Name NextStateName )
	{
		
	}
}

/* --------------------------------------------------------------------------------------------------------------------------------- */

function LogPlayersPerk()
{
	local CD_PlayerController CDPC;
	local class<KFPerk> Perk;

	foreach WorldInfo.AllControllers(class'CD_PlayerController', CDPC)
	{
		if(CDPC.PlayerReplicationinfo.bOnlySpectator)
			continue;

		Perk = CDPC.GetPerk().GetPerkClass();
		CDPC.SavePerkUseNum(Perk);
	}
}

function SaveAllUserStats()
{
	local int RS;
	local CD_PlayerController CDPC;

	RS = CDGRI.bMatchVictory ? `RS_WIN : `RS_DEFEAT;

	foreach WorldInfo.AllControllers(class'CD_PlayerController', CDPC)
	{
		if(CDPC.PlayerReplicationinfo.bOnlySpectator)
			continue;

		SaveUserStats(CDPC, RS);
	}
}

function SaveUserStats(CD_PlayerController CDPC, int RS)
{
	local CDInfo CI;
	local MatchInfo MI;

	SyncStats(CDPC);

	if(RS > `RS_LEAVE)
	{
		CI.SC = SpawnCycle;
		CI.MM = MaxMonsters;
		CI.CS = CohortSize;
		CI.SP = SpawnPoll;
		CI.WSF = WaveSizeFakes;
		CI.SM = SpawnMod;
		CI.THPF = TrashHPFakes;
		CI.QPHPF = QuarterPoundHPFakes;
		CI.FPHPF = FleshpoundHPFakes;
		CI.SCHPF = ScrakeHPFakes;
		CI.ZTSM = ZTSpawnMode;
		CI.ZTSSD = ZTSpawnSlowdown;
		CI.AA = AlbinoAlphas;
		CI.AC = AlbinoCrawlers;
		CI.AG = AlbinoGorefasts;
		CI.DR = DisableRobots;
		CI.DS = DisableSpawners;
		CI.FPRS = FleshpoundRageSpawns;
		CI.SWFA = StartwithFullAmmo;
		CI.SWFAR = StartwithFullArmor;
		CI.SWFG = StartwithFullGrenade;
		CI.ZTC = ZedsTeleportCloser;

		MI.TimeStamp = TimeStamp();
		MI.PlayerNum = PlayerCountToRec;
		MI.CI = CI;
		if(RS == `RS_DEFEAT) MI.DefeatWave = WaveNum;
	}
	MI.ResultState = RS;
	CDPC.SaveUserStats(MI);
}

private function DisplayBriefWaveStatsInChat()
{
	local string s;
	local CD_PlayerController CDPC;

	s = CD_SpawnManager( SpawnManager ).GetWaveAverageSpawnrate();

	foreach WorldInfo.AllControllers(class'CD_PlayerController', CDPC)
	{
		CDPC.RenderWaveEndSummary(s);
		CDPC.ReceiveWaveEndStats(StatsSystem.GetIndividualPlayerStats(CDPC));
	}
}

function DisplayCycleAnalisisInHUD(string title, string body)
{
	local CD_PlayerController CDPC;

	foreach WorldInfo.AllControllers(class'CD_PlayerController', CDPC)
	{
		SpawnCycleCatalog.ConvertShorterName(title);
		CDPC.RenderObjectiveContainer(title, body);
	}
}

function string PauseTraderTime()
{
	local name GameStateName;

	// Only process these commands in trader time
	GameStateName = GetStateName();
	if ( GameStateName != 'TraderOpen' )
	{
		return "<local>CD_Survival.TraderNotOpenString</local>";
	}

	if ( MyKFGRI.bStopCountDown )
	{
		return "<local>CD_Survival.AlreadyPausedString</local>";
	}

	if ( WorldInfo.NetMode != NM_StandAlone && MyKFGRI.RemainingTime <= 5 )
	{
		return "<local>CD_Survival.LeftTimeErrorString</local>";
	}

	MyKFGRI.bStopCountDown = !MyKFGRI.bStopCountDown;

	if (bAutoPause && MyKFGRI.RemainingTime >= 60)
	{
		PausedRemainingTime = 60;
		PausedRemainingMinute = 0;
	}
	else
	{
		PausedRemainingTime = MyKFGRI.RemainingTime;
		PausedRemainingMinute = MyKFGRI.RemainingMinute;
	}
	
	ClearTimer( 'CloseTraderTimer' );
	`cdlog("Killed CloseTraderTimer", bLogControlledDifficulty);

	`cdlog("MyKFGRI.RemainingTime: "$ MyKFGRI.RemainingTime, bLogControlledDifficulty);
	`cdlog("MyKFGRI.RemainingMinute: "$ MyKFGRI.RemainingMinute, bLogControlledDifficulty);
	`cdlog("MyKFGRI.bStopCountDown: "$ MyKFGRI.bStopCountDown, bLogControlledDifficulty);

	return "<local>CD_Survival.PauseTraderString</local>";
}

function string UnpauseTraderTime()
{
	local name GameStateName;

	// Only process these commands in trader time
	GameStateName = GetStateName();
	if ( GameStateName != 'TraderOpen' )
	{
		return "<local>CD_Survival.TraderNotOpenString</local>";
	}

	if ( !MyKFGRI.bStopCountDown )
	{
		return "<local>CD_Survival.TraderNotPausedString</local>";
	}

	MyKFGRI.bStopCountDown = !MyKFGRI.bStopCountDown;

	MyKFGRI.RemainingTime = PausedRemainingTime;
	MyKFGRI.RemainingMinute = PausedRemainingMinute;
	SetTimer( MyKFGRI.RemainingTime, False, 'CloseTraderTimer' );
	`cdlog("Installed CloseTraderTimer at "$ MyKFGRI.RemainingTime $" (non-recurring)", bLogControlledDifficulty);

	`cdlog("MyKFGRI.RemainingTime: "$ MyKFGRI.RemainingTime, bLogControlledDifficulty);
	`cdlog("MyKFGRI.RemainingMinute: "$ MyKFGRI.RemainingMinute, bLogControlledDifficulty);
	`cdlog("MyKFGRI.bStopCountDown: "$ MyKFGRI.bStopCountDown, bLogControlledDifficulty);

	return "<local>CD_Survival.UnpauseTraderString</local>";
}

private function DisplayWaveStartMessageInChat()
{
	BroadcastCDEcho( "[Controlled Difficulty - " $ `CD_BUILD_TYPE $ "]");
	BroadcastCDEcho( ChatCommander.GetCDInfoChatString( "brief" ) );
}

private function DisplayDynamicSettingSummaryInChat()
{
	if ( DynamicSettingsBulletin != "" )
	{
		BroadcastCDEcho( "[CD - Dynamic Settings]\n" $ DynamicSettingsBulletin );
	}
}

protected function bool ApplyStagedConfig( out string MessageToClients, const string BannerLine )
{
	local array<string> SettingChangeNotifications;
	local string TempString;
	local int i, PendingWaveNum;

	PendingWaveNum = WaveNum + 1;

	for ( i = 0; i < SettingManager.AllSettings.Length; i++ )
	{
		TempString = SettingManager.AllSettings[i].CommitStagedChanges( PendingWaveNum );

		if ( TempString != "" )
		{
			SettingChangeNotifications.AddItem( TempString );
		}
	}

	if ( 0 < SettingChangeNotifications.Length )
	{
		if ( "" != BannerLine )
		{
			SettingChangeNotifications.InsertItem( 0, BannerLine );
		}

		JoinArray(SettingChangeNotifications, MessageToClients, "\n");

		SaveConfig();

		return true;
	}

	return false;
}

function SaveFinalSettings()
{
	local KFPlayerController KFPC;
	local int dmgd, healsg, kills, larg, hu, dmgt;
	local int TempHu;
	local float acc, hsacc;
	local float TempAcc, TempHsacc;
	local string PlayerName;
	local array<ZedKillType> PersonalStats;
	local ZedKillType Status;

	CDGRI.CDFinalParams.SC = SpawnCycle;
	CDGRI.CDFinalParams.MM = MaxMonsters;
	CDGRI.CDFinalParams.CS = CohortSize;
	CDGRI.CDFinalParams.SP = SpawnPoll;
	CDGRI.CDFinalParams.WSF= WaveSizeFakes;
	CDGRI.CDFinalParams.CHSPP = bCountHeadshotsPerPellet;

	foreach WorldInfo.AllControllers(Class'KFPlayerController', KFPC)
	{
		if(KFPC.PlayerReplicationInfo.bOnlySpectator)
			continue;

		PlayerName = KFPC.PlayerReplicationInfo.PlayerName;

		if(dmgd < KFPC.MatchStats.TotalDamageDealt+KFPC.MatchStats.GetDamageDealtInWave())
		{
			dmgd = KFPC.MatchStats.TotalDamageDealt+KFPC.MatchStats.GetDamageDealtInWave();
			CDGRI.DamageDealer.PlayerName = PlayerName;
			CDGRI.DamageDealer.Value = dmgd;
		}

		if(healsg < KFPC.MatchStats.TotalAmountHealGiven + KFPC.MatchStats.GetHealGivenInWave())
		{
			healsg = KFPC.MatchStats.TotalAmountHealGiven + KFPC.MatchStats.GetHealGivenInWave();
			CDGRI.Healer.PlayerName = PlayerName;
			CDGRI.Healer.Value = healsg;
		}

		if(KFPC.ShotsFired == 0) TempAcc = 0;
		else TempAcc = Float(KFPC.ShotsHit)/Float(KFPC.ShotsFired);
		if(acc < TempAcc)
		{
			acc = TempAcc;
			CDGRI.Precision.PlayerName = PlayerName;
			CDGRI.Precision.Value = round(acc*100);
		}

		if(KFPC.ShotsHit == 0) TempHsacc = 0;
		else if(bCountHeadshotsPerPellet) TempHsacc = Float(KFPC.ShotsHitHeadshot)/Float(KFPC.ShotsHit);
		else TempHsacc = Float(KFPC.MatchStats.TotalHeadShots+KFPC.MatchStats.GetHeadShotsInWave())/Float(KFPC.ShotsHit);
		if(hsacc < TempHsacc)
		{
			hsacc = TempHsacc;
			CDGRI.Headpopper.PlayerName = PlayerName;
			CDGRI.Headpopper.Value = round(hsacc*100);
		}

		if(kills < KFPC.PlayerReplicationInfo.Kills)
		{
			kills = KFPC.PlayerReplicationInfo.Kills;
			CDGRI.ZedSlayer.PlayerName = PlayerName;
			CDGRI.ZedSlayer.Value = kills;
		}

		if(larg < KFPC.MatchStats.TotalLargeZedKills)
		{
			larg = KFPC.MatchStats.TotalLargeZedKills;
			CDGRI.LargeKiller.PlayerName = PlayerName;
			CDGRI.LargeKiller.Value = larg;
		}

		PersonalStats = KFPC.MatchStats.ZedKillsArray;
		foreach PersonalStats(Status)
		{
			if(Status.MonsterClass == class'KFGameContent.KFPawn_ZedHusk')
				TempHu = Status.KillCount;
		}
		if(hu < TempHu)
		{
			hu = TempHu;
			CDGRI.HuskKiller.PlayerName = PlayerName;
			CDGRI.HuskKiller.Value = hu;
		}

		if(dmgt < KFPC.MatchStats.TotalDamageTaken + KFPC.MatchStats.GetDamageTakenInWave())
		{
			dmgt = KFPC.MatchStats.TotalDamageTaken + KFPC.MatchStats.GetDamageTakenInWave();
			CDGRI.Guardian.PlayerName = PlayerName;
			CDGRI.Guardian.Value = dmgt;
		}

		CD_PlayerController(KFPC).SyncStats(KFPC.ShotsFired, KFPC.ShotsHit, KFPC.ShotsHitHeadshot);
	}
}

/* ==============================================================================================================================
 *	Something Others
 * ============================================================================================================================== */

final function int GetEffectivePlayerCount( int HumanPlayers )
{
	return 0 < WaveSizeFakesInt ? WaveSizeFakesInt : 1;
}

final function int GetEffectivePlayerCountForZedType( KFPawn_Monster P, int HumanPlayers )
{
	local int FakeValue;
	local string Zed;
	Zed = string(P.LocalizationKey);
	if ( P != none )
	{
		switch (Zed)
		{	
			case "KFPawn_ZedFleshpoundKing":
			case "KFPawn_ZedBloatKing":
			case "KFPawn_ZedPatriarch":
			case "KFPawn_ZedHans":
			case "KFPawn_ZedMatriarch":
				FakeValue = BossHPFakesInt;
				break;

			case "KFPawn_ZedFleshpound":
				FakeValue = FleshpoundHPFakesInt;
				break;

			case "KFPawn_ZedScrake":
				FakeValue = ScrakeHPFakesInt;
				break;

			case "KFPawn_ZedFleshpoundMini":
				FakeValue = QuarterPoundHPFakesInt;
				break;

			default:
				FakeValue = TrashHPFakesInt;
		}
	}
	else
	{
		`cdlog ("Warning - GetEffectivePlayerCountForZedType() was called for none.");
	}

	return max(1, FakeValue);
}

protected function LoadSpawnCycle( const out string OverrideSpawnCycle, out array<CD_AIWaveInfo> OutWaveInfos )
{
	// Assign a spawn definition array to CycleDefs (unless SpawnCycle=unmodded)
	if ( OverrideSpawnCycle == "ini" )
	{
		MaybeLoadIniWaveInfos();

		OutWaveInfos = IniWaveInfos;
	}
	else if ( OverrideSpawnCycle == "unmodded" )
	{
		`cdlog("LoadSpawnCycle: found "$OverrideSpawnCycle$", treating as noop", bLogControlledDifficulty);

		OutWaveInfos.Length = 0;
	}
	else
	{
		SpawnCycleCatalog.ParseSquadCyclePreset( OverrideSpawnCycle, GameLength, OutWaveInfos );
	}
}

private function ProgramSettingsForNextWave()
{
	local int i, NWN;
	local string s;
	local bool DynamicSettingsBulletinStarted;

	NWN = WaveNum + 1;
	DynamicSettingsBulletinStarted = false;
	DynamicSettingsBulletin = "";

	for ( i = 0; i < SettingManager.DynamicSettings.Length; i++ )
	{
		s = SettingManager.DynamicSettings[i].RegulateValue( NWN );
		if ( s != "" )
		{
			if ( DynamicSettingsBulletinStarted )
			{
				DynamicSettingsBulletin $= "\n";
			}
			DynamicSettingsBulletin $= s;
			DynamicSettingsBulletinStarted = true;
		}
	}
}

function bool EpsilonClose( const float a, const float b, const float epsilon )
{
	return a == b || (a < b && b < (a + epsilon)) || (b < a && a < (b + epsilon));
}

function ECDAuthLevel GetAuthorizationLevelForUser( Actor Sender )
{
	local KFPlayerController SubjectPC;

	if ( WorldInfo.NetMode == NM_StandAlone )
	{
		return CDAUTH_WRITE;
	}

	SubjectPC = KFPlayerController( Sender );

	if ( None == SubjectPC )
	{
		`cdlog("Actor "$ Sender $" does not appear to be a KFPlayerController.", bLogControlledDifficulty);
		return DefaultAuthLevel;
	}

	return GetAuthLevelForKFPC(SubjectPC);
}

function ECDAuthLevel GetAuthLevelForKFPC( KFPlayerController SubjectPC )
{
	local KFPlayerReplicationInfo KFPRI;
	local string SteamIdHexString;
	local int SteamIdAccountNumber;
	local string SteamIdSuffix;
	local int i;
	local int SteamIdSuffixLength;

	// NM_StandAlone bypasses authorization.  Multiuser authorization would not be meaningful in solo.
	if ( WorldInfo.NetMode == NM_StandAlone || IsAdmin(SubjectPC))
	{
		return CDAUTH_WRITE;
	}

	KFPRI = KFPlayerReplicationInfo( SubjectPC.PlayerReplicationInfo );

	if ( None == KFPRI )
	{
		`cdlog("Subject player controller "$ SubjectPC $" does not have replication info.", bLogControlledDifficulty);
		return DefaultAuthLevel;
	}

	SteamIdHexString = OnlineSub.UniqueNetIdToString(KFPRI.UniqueId);

	`cdlog("Beginning authorization check for UniqueId=" $ SteamIdHexString $ " (current nickname: "$ KFPRI.PlayerName $")", bLogControlledDifficulty);

	class'CD_StringUtils'.static.HexStringToInt( Right( SteamIdHexString, 8 ), SteamIdAccountNumber );

	if ( -1 == SteamIdAccountNumber )
	{
		`cdlog("Parsing UniqueId=" $ SteamIdHexString $ " as hex failed; not a STEAMID? (current nickname: "$ KFPRI.PlayerName $")", bLogControlledDifficulty);
		return DefaultAuthLevel;
	}

	`cdlog("Unpacked int32 steam account number: " $ SteamIdAccountNumber $ " (current nickname: "$ KFPRI.PlayerName $")", bLogControlledDifficulty); 

	SteamIdSuffix = ":" $ string(SteamIdAccountNumber % 2) $ ":" $ string(SteamIdAccountNumber / 2);
	SteamIdSuffixLength = Len( SteamIdSuffix );

	`cdlog("Formatted account number as STEAMID2-style string: "$ SteamIdSuffix $ " (current nickname: "$ KFPRI.PlayerName $")", bLogControlledDifficulty); 

	for ( i = 0; i < AuthorizedUsers.Length; i++ )
	{
		if ( Len( AuthorizedUsers[i].SteamID ) < SteamIdSuffixLength )
		{
			continue;
		}

		if ( Right( AuthorizedUsers[i].SteamID, SteamIdSuffixLength ) == SteamIdSuffix )
		{
			`cdlog("Found STEAMID2 auth match for " $
			AuthorizedUsers[i].SteamID $ "; granting CDAUTH_WRITE (current nickname: " $ KFPRI.PlayerName $
			", auth comment: " $ AuthorizedUsers[i].Comment $ ")", bLogControlledDifficulty);

			return CDAUTH_WRITE;
		}
	}

	for ( i = 0; i < Moderator.Length; i++ )
	{
		if ( Len( Moderator[i].SteamID ) < SteamIdSuffixLength )
		{
			continue;
		}

		if ( Right( Moderator[i].SteamID, SteamIdSuffixLength ) == SteamIdSuffix )
		{
			return CDAUTH_WRITE;
		}
	}
	
	`cdlog("No STEAMID2 auth match found for current user (current nickname: " $ KFPRI.PlayerName $ ")", bLogControlledDifficulty);

	return DefaultAuthLevel;
}

private function MaybeLoadIniWaveInfos()
{
	if ( !AlreadyLoadedIniWaveInfos )
	{
		AlreadyLoadedIniWaveInfos = true;

		if ( !SpawnCycleCatalog.ParseIniSquadCycle( SpawnCycleDefs, GameLength, IniWaveInfos ) )
		{
			IniWaveInfos.length = 0;
		}
	}
}

function CheckMapInfo()
{
	local KFMapInfo KFMI;
	
	KFMI = KFMapInfo(WorldInfo.GetMapInfo());
	
	if (KFMI == None)
	{
		SetTimer(1.0, false, nameof(CheckMapInfo));
		return;
	}
	
	KFMI.bUseRandomObjectives = false;
}

/* ==============================================================================================================================
 *	Chat Command & Broadcast System
 * ============================================================================================================================== */

function BroadcastTeam( Controller Sender, coerce string Msg, optional name Type ){	Broadcast(Sender, Msg, 'Say'); }

event Broadcast(Actor Sender, coerce string Msg, optional name Type)
{
	super.Broadcast(Sender, Msg, Type);

	if ( Type == 'Say')
	{
		Msg = Locs(Msg);
		ChatCommander.RunCDChatCommandIfAuthorized( Sender, Msg );
	}
}

/* --------------------------------------------------------------------------------------------------------------------------------- */

function BroadcastLocalizedEcho( coerce string MsgStr, optional name EchoType='CDEcho' )
{
	local CD_PlayerController CDPC;

	foreach WorldInfo.AllControllers(class'CD_PlayerController', CDPC)
	{
		CDPC.LocalizedClientMessage(MsgStr, EchoType);
	}
}

function BroadcastEcho( coerce string MsgStr, name Type)
{
	local PlayerController PC;

	foreach WorldInfo.AllControllers(class'PlayerController', PC)
	{
		BroadcastHandler.BroadcastText( None, PC, MsgStr, Type );
	}
}

function BroadcastCDEcho( coerce string MsgStr ){ BroadcastEcho(MsgStr, 'CDEcho'); }
function BroadcastRPWEcho( coerce string MsgStr ){ BroadcastEcho(MsgStr, 'RPWEcho'); }
function BroadcastUMEcho( coerce string MsgStr ){ BroadcastEcho(MsgStr, 'UMEcho'); }
function BroadcastSystem( coerce string MsgStr ){ BroadcastEcho(MsgStr, 'System'); }
function LogToConsole(string MsgStr){ BroadcastEcho(MsgStr, 'Console'); }

function BroadcastPersonalEcho( coerce string MsgStr, name Type , KFPlayerController KFPC)
{
	local CD_PlayerController CDPC;
	CDPC = CD_PlayerController(KFPC);
	CDPC.TeamMessage(None , MsgStr, Type);
}

function BroadcastDifferentEcho( coerce string Lower, coerce string Higher, int RequiredLevel, optional name Type='CDEcho')
{
	local CD_PlayerController CDPC;
	local string MsgStr;

	foreach WorldInfo.AllControllers(class'CD_PlayerController', CDPC)
	{
		if(CDPC.GetCDPRI().AuthorityLevel < RequiredLevel)
			MsgStr = Lower;
		else
			MsgStr = Higher;

		BroadcastPersonalEcho(MsgStr, Type, CDPC);
	}
}

function DisplayCycleAnalisis()
{
	SpawnCycleAnalyzer.TrySCACore(SpawnCycle, WaveNum, WaveSizeFakesInt, false);
}

function BriefCycleAnalisis()
{
	SpawnCycleAnalyzer.TrySCACore(SpawnCycle, WaveNum, WaveSizeFakesInt, true);
}

private function string GetCDVersionChatString()
{
	return  "Build=Combined Edition\nBased=Blackout Edition\nAuthor=あさぴっぴ1020";
}

/* ==============================================================================================================================
 *	Exec functions & related
 * ============================================================================================================================== */

exec function logControlledDifficulty( bool enabled )
{
	bLogControlledDifficulty = enabled;
	if ( SpawnCycleCatalog != None )
	{
		SpawnCycleCatalog.SetLogging( enabled );
	}
	`cdlog("Set bLogControlledDifficulty = "$bLogControlledDifficulty, true);
	SaveConfig();
}

exec function AnalyzeVanillaCycle(int WaveIdx, int PlayerCount, optional int TryNum=1)
{
	SpawnCycleAnalyzer.VanillaAnalyze(WaveIdx, PlayerCount, TryNum);
}
/*
	exec function CDChatHelp()
	{
		ChatCommander.PrintCDChatHelp();
	}

	exec function CDSpawnSummaries( optional string CycleName, optional int AssumedPlayerCount = -255 )
	{
		local array<CD_AIWaveInfo> WaveInfosToSummarize;
		local DifficultyWaveInfo DWS;
		local class<CD_SpawnManager> cdsmClass;
		local ECDWaveInfoStatus wis;
		//local string OutputText;

		wis = GetWaveInfosForConsoleCommand( CycleName, WaveInfosToSummarize );
		//OutputText = "";

		if ( wis == WIS_SPAWNCYCLE_NOT_MODDED )
		{
			GameInfo_CDCP.Print("", false);
			GameInfo_CDCP.Print("Usage: CDSpawnSummaries <optional SpawnCycle name> <optional player count>", false);
			GameInfo_CDCP.Print("", false);
			GameInfo_CDCP.Print("This command displays summary zed counts for a SpawnCycle.", false);
			GameInfo_CDCP.Print("It uses the optional SpawnCycle name param when provided, but otherwise", false);
			GameInfo_CDCP.Print("defaults to whatever SpawnCycle was used to open CD.", false);
			GameInfo_CDCP.Print("", false);
			GameInfo_CDCP.Print("Because the current effective SpawnCycle setting is \"unmodded\",", false);
			GameInfo_CDCP.Print("this command has no effect.  Either open CD with a different SpawnCycle", false);
			GameInfo_CDCP.Print("or invoke this command with the name of a SpawnCycle.", false);
			GameInfo_CDCP.Print("", false);
			GameInfo_CDCP.Print("To see a list of available SpawnCycles, invoke CDSpawnPresets.", false);
			return;
		}
		else if ( wis == WIS_PARSE_ERROR )
		{
			return;
		}

		if ( -255 == AssumedPlayerCount )
		{
			if ( WorldInfo.NetMode == NM_StandAlone )
			{
				AssumedPlayerCount = GetEffectivePlayerCount( 1 );
				//OutputText = "Projecting wave summaries for "$AssumedPlayerCount$" player(s) in current game length...\n";
			}
			else
			{
				GameInfo_CDCP.Print( "Unable to guess player count in netmode "$WorldInfo.NetMode, false );
				GameInfo_CDCP.Print( "Pass a player count as an argument to this console command, e.g.", false );
				GameInfo_CDCP.Print( "> CDSpawnSummaries 2", false );
				return;
			}
		}
		else if ( 0 < AssumedPlayerCount )
		{
			GameInfo_CDCP.Print( "Projecting wave summaries for "$AssumedPlayerCount$" players in current game length...", false );
		}
		else
		{
			GameInfo_CDCP.Print( "Player count argument "$AssumedPlayerCount$" must be positive", false );
			return;
		}

		cdsmClass = class<CD_SpawnManager>( SpawnManagerClasses[GameLength] );
		// No need to instantiate; we just want to check its default 
		// values for about Wave MaxAI 
		DWS = cdsmClass.default.DifficultyWaveSettings[ Min(GameDifficulty, cdsmClass.default.DifficultyWaveSettings.Length-1) ];

		// OutputText $= class'CD_WaveInfoUtils'.static.PrintSpawnSummaries( WaveInfosToSummarize, AssumedPlayerCount,
		// 	GameInfo_CDCP, GameLength, CDDI, DWS );
		//OutputText $= "\n";

		CDConsolePrintLogfileHint();
	}

	exec function CDSpawnDetails( optional string CycleName )
	{
		local array<CD_AIWaveInfo> WaveInfosToSummarize;
		local ECDWaveInfoStatus wis;

		wis = GetWaveInfosForConsoleCommand( CycleName, WaveInfosToSummarize );

		if ( wis == WIS_OK )
		{
			GameInfo_CDCP.Print("Printing abbreviated zed spawn cycles for each wave...", false);

			class'CD_WaveInfoUtils'.static.PrintSpawnDetails( WaveInfosToSummarize, "short", GameInfo_CDCP );

			CDConsolePrintLogfileHint();
		}
		else if ( wis == WIS_SPAWNCYCLE_NOT_MODDED )
		{
			CDPrintSpawnDetailsHelp();
		}
	}

	exec function CDSpawnDetailsVerbose( optional string CycleName )
	{
		local array<CD_AIWaveInfo> WaveInfosToSummarize;
		local ECDWaveInfoStatus wis;

		wis = GetWaveInfosForConsoleCommand( CycleName, WaveInfosToSummarize );

		if ( wis == WIS_OK )
		{
			GameInfo_CDCP.Print("Printing verbose zed spawn cycles for each wave...", false);

			class'CD_WaveInfoUtils'.static.PrintSpawnDetails( WaveInfosToSummarize, "full", GameInfo_CDCP );

			CDConsolePrintLogfileHint();
		}
		else if ( wis == WIS_SPAWNCYCLE_NOT_MODDED )
		{
			CDPrintSpawnDetailsHelp();
		}
	}

	private function CDConsolePrintLogfileHint()
	{
		GameInfo_CDCP.Print(" Need to copy-paste?  CD copies all console output to KF2's logfile, generally:", false);
		GameInfo_CDCP.Print("  <HOME>\\Documents\\My Games\\KillingFloor2\\KFGame\\Logs\\Launch.log", false);
	}

	exec function CDSpawnPresets()
	{
		SpawnCycleCatalog.PrintPresets();

		CDConsolePrintLogfileHint();
	}

	exec function DebugCD_ExtraProgramPlayers( optional int i )
	{
		if ( i == -2147483648 )
		{
			GameInfo_CDCP.Print("DebugExtraProgramPlayers="$DebugExtraProgramPlayers);
		}
		else
		{
			DebugExtraProgramPlayers = i;
			SaveConfig();
			GameInfo_CDCP.Print("Set DebugExtraProgramPlayers="$DebugExtraProgramPlayers);
		}
	}
*/

/* --------------------------------------------------------------------------------------------------------------------------------- */

exec function EndCurrentWave()
{
	Ext_KillZeds();
	WaveEnded(WEC_WaveWon);
}

exec function SetWave(byte NewWaveNum)
{
	if(NewWaveNum > 0)
	{
		super.SetWave(NewWaveNum);
		Ext_KillZeds();
	}
}

exec function WinMatch()
{
	local CD_PlayerController CDPC;

	Ext_KillZeds();
	bUsedWinMatch = true;

	foreach WorldInfo.AllControllers(class'CD_PlayerController', CDPC)
		CDPC.PlayLargeKillSound();
	
	super.WinMatch();
}

//	Toggle SolePerksSystem
exec function SolePerksSystem(bool bEnable)
{
	if(CDGRI != none)
	{
		bSolePerksSystem = bEnable;
		CDGRI.bEnableSolePerksSystem = bEnable;
		CDGRI.SaveConfig();
		BroadcastCDEcho("[Admin] SolePerksSystem:" @ string(CDGRI.bEnableSolePerksSystem));
	}
}

/* --------------------------------------------------------------------------------------------------------------------------------- */

function ECDWaveInfoStatus GetWaveInfosForConsoleCommand( string CycleName, out array<CD_AIWaveInfo> WaveInfos )
{
	WaveInfos.length = 0;

	if ( CycleName == "" )
	{
		CycleName = SpawnCycle;
	}

	PrintScheduleSlug( CycleName );

	if ( CycleName == "unmodded" )
	{
		return WIS_SPAWNCYCLE_NOT_MODDED;
	}

	if ( CycleName == "ini" )
	{
		MaybeLoadIniWaveInfos();

		WaveInfos = IniWaveInfos;
	}
	else if ( !SpawnCycleCatalog.ParseSquadCyclePreset( CycleName, GameLength, WaveInfos ) )
	{
		WaveInfos.length = 0;
	}

	return WaveInfos.length == 0 ? WIS_PARSE_ERROR : WIS_OK;
}

function CDPrintSpawnDetailsHelp()
{
	GameInfo_CDCP.Print("", false);
	GameInfo_CDCP.Print("Usage: CDSpawnDetails(Verbose) <optional SpawnCycle name>", false);
	GameInfo_CDCP.Print("", false);
	GameInfo_CDCP.Print("This command displays precise zed squad composition for a SpawnCycle.", false);
	GameInfo_CDCP.Print("It uses the optional SpawnCycle name param when provided, but otherwise", false);
	GameInfo_CDCP.Print("defaults to whatever SpawnCycle was used to open CD.", false);
	GameInfo_CDCP.Print("", false);
	GameInfo_CDCP.Print("Because the current effective SpawnCycle setting is \"unmodded\",", false);
	GameInfo_CDCP.Print("this command has no effect.  Either open CD with a different SpawnCycle", false);
	GameInfo_CDCP.Print("or invoke this command with the name of a SpawnCycle.", false);
	GameInfo_CDCP.Print("", false);
	GameInfo_CDCP.Print("To see a list of available SpawnCycles, invoke CDSpawnPresets.", false);
}

private function PrintScheduleSlug( string CycleName )
{
	if ( CycleName == "ini" )
	{
		GameInfo_CDCP.Print("Considering SpawnCycle="$CycleName$" (zeds spawn according to the config file)", false);
	}
	else if ( CycleName != "unmodded" )
	{
		GameInfo_CDCP.Print("Considering SpawnCycle="$CycleName$" (if a preset with that name exists)", false);
	}
}

/* ==============================================================================================================================
 *	Additional Contents
 * ============================================================================================================================== */

function DecideDash(){ ModTraderDash(GetStateName() == 'TraderOpen'); }

function ModTraderDash(bool bDash)
{
	local KFPlayerController KFPC;
	local KFPawn Player;

	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
	{
		Player = KFPawn(KFPC.Pawn);
		if(Player!=None)
		{
			if ( bDash && KFWeap_Edged_Knife(Player.Weapon)!=None ) Player.GroundSpeed = 364364.0f;
			else Player.UpdateGroundSpeed();
		}
	}
}

function CC_BeRich(KFPlayerController KFPC)
{
	local KFPlayerReplicationInfo KFPRI;
	KFPRI = KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo);
	if ( KFPRI != None )
	{
		KFPRI.AddDosh( 1000000 );
	}
}

function KFPawn LocatedSpawn(string ZedName, class<KFPawn> SpawnClass, vector SpawnLoc, rotator SpawnRot, optional KFPlayerController KFPC, optional bool AvoidOverride)
{
	local KFPawn KFP;

	KFP = Spawn(SpawnClass, , , SpawnLoc, SpawnRot,,);

	if ( KFP != None )
	{
		if(KFPC.PlayerReplicationinfo.bOnlySpectator)
		{
			if( KFPC.Pawn != none )
           		KFPC.Pawn.Destroy();

            if( KFP.Controller != none )
				KFP.Controller.Destroy();
            
            SetTeam( KFPC, Teams[1] );
            KFPC.Possess( KFP, false );
            KFPC.ServerCamera( 'ThirdPerson' );

            KFP.SetPhysics(PHYS_Falling);

            return KFP;
		}

		else if (KFPawn_Monster(KFP) != none)
		{
			KFPawn_Monster(KFP).bDebug_SpawnedThroughCheat = true;
		}
		KFP.SetPhysics(PHYS_Falling);
		SetMonsterDefaults( KFPawn_Monster(KFP));
        if( KFP.Controller != none && KFAIController(KFP.Controller) != none )
        {
            GetAIDirector().AIList.AddItem( KFAIController(KFP.Controller) );
        }
	}
	else
	{
		GameInfo_CDCP.Print("Failed to spawn! Log: Params readeing:: ZedName = " $ ZedName $ ", SpawnClass = " $ string(SpawnClass) $ ", KFPawn = " $ string(KFP));
	}

	return KFP;
}

function KFPawn CD_SpawnZed(string ZedName, KFPlayerController KFPC, optional float Distance = 200.f)
{
	local class<KFPawn> SpawnClass;
	local vector SpawnLoc;
	local rotator SpawnRot;
	local bool albino, rage, versus;

	albino = SpawnCycleAnalyzer.HandleZedMod(ZedName, "*");
	rage = (!albino && SpawnCycleAnalyzer.HandleZedMod(ZedName, "!"));
	versus = SpawnCycleAnalyzer.HandleZedMod(ZedName, "vs");
	SpawnClass = class'CD_ZedNameUtils'.static.GetZedClassFromName(ZedName, albino, rage, versus);

	if ( KFPC.Pawn != None )
	{
		SpawnLoc = KFPC.Pawn.Location;
		SpawnLoc += Distance * Vector(KFPC.Pawn.Rotation) + vect(0,0,1) * 15;
		SpawnRot.Yaw = KFPC.Pawn.Rotation.Yaw + 32768;
	}
	else 
	{
		SpawnLoc = FindPlayerStart(KFPC).Location;
	}

	return LocatedSpawn(ZedName, SpawnClass, SpawnLoc, SpawnRot, KFPC);
}

function CD_SpawnAI(string ZedName, KFPlayerController KFPC, optional float Distance = 500.f)
{
	local KFPawn Zed;

	Zed = CD_SpawnZed( ZedName, KFPC, Distance);

	if ( Zed != None )
	{
		Zed.SpawnDefaultController();
		if( KFAIController(Zed.Controller) != none )
		{
			KFAIController( Zed.Controller ).SetTeam(1);
		}
	}
}

function Ext_KillZeds()
{
	local KFPawn_Monster AIP;
	ForEach WorldInfo.AllPawns(class'KFPawn_Monster', AIP)
	{
		if ( AIP.Health > 0 && PlayerController(AIP.Controller) == none)
			AIP.Died(none , none, AIP.Location);
	}
}

function DeactivateSpawners(bool bDeactivate)
{
	local KFSpawner Spawner;

	foreach WorldInfo.AllActors( class'KFSpawner', Spawner )
	{
		Spawner.CoolDownTime = bDeactivate ? 2147484000.f : Spawner.default.CoolDownTime;
		Spawner.MaxStayActiveTime = bDeactivate ? 1.f : Spawner.default.MaxStayActiveTime;
		if(bDeactivate) Spawner.DeactivateSpawner();
		else Spawner.ActivateSpawner();
	}
}

function CDRecord()
{
	local string Result;
	local KFPlayerController KFPC;
	local KFPlayerReplicationInfo KFPRI;

	Result = TimeStamp() $ "|" $
			 WorldInfo.GetMapName( true ) $ "|" $
			 SpawnCycle $ "|" $
			 MaxMonsters$ "|" $
			 SearchUniqueSettings() $ "|";

	foreach WorldInfo.AllControllers(Class'KFPlayerController', KFPC)
	{
		if(KFPC.PlayerReplicationInfo.bOnlySpectator || KFPC.PlayerReplicationInfo.bWaitingPlayer) continue;

		KFPRI = KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo);
		if(KFPRI == None) continue;

		Result $= ConvertID(KFPRI.UniqueId) @ ":" @ GetPerkStr(KFPC.GetPerk().GetPerkClass()) $ "|";
	}

	Recorder.RegisterRecord(Result);
}

static function string ConvertID(UniqueNetId ID)
{
	local string IDHexStr;

	IDHexStr = class'OnlineSubsystem'.static.UniqueNetIdToString(ID);
	IDHexStr = Right(IDHexStr, 8);

	return string(class'CD_Object'.static.HexToInt(IDHexStr));
}

function string SearchUniqueSettings()
{
	local string Result;

	Result = "?";

	if(GameLength != GL_Long) Result $= "GameLength=" $ string(GameLength) $ "?";
	if(!AlbinoAlphasBool) Result $= "AlbinoAlphas=False?";
	if(!AlbinoCrawlersBool) Result $= "AlbinoCrawlers=False?";
	if(!AlbinoGorefastsBool) Result $= "AlbinoGorefasts=False?";
	if(!bDisableRobots) Result $= "DisableRobots=False?";
	if(FleshpoundRageSpawnsBool) Result $= "FleshpoundRageSpawns=True?";
	if(StartingWeaponTierInt != 1) Result $= "StartingWeaponTier=" $ StartingWeaponTier $"?";
	if(!bStartwithFullAmmo) Result $= "StartwithFullAmmo=False?";
	if(bStartwithFullArmor) Result $= "StartwithFullArmor=True?";
	if(!bStartwithFullGrenade) Result $= "StartwithFullGrenade=False?";
	if(CohortSizeInt != 0) Result $= "CohortSize=" $ CohortSize $ "?";
	if(WaveSizeFakesInt != 12) Result $= "WaveSizeFakes=" $ WaveSizeFakes $ "?";
	if(SpawnModFloat != 0.f) Result $= "SpawnMod=" $ SpawnMod $ "?";
	if(SpawnPollFloat != 1.f) Result $= "SpawnPoll=" $ SpawnPoll $ "?";
	if(ScrakeHPFakesInt != 6) Result $= "ScrakeHPFakes=" $ ScrakeHPFakes $ "?";
	if(FleshpoundHPFakesInt != 6) Result $= "FleshpoundHPFakes=" $ FleshpoundHPFakes $ "?";
	if(QuarterpoundHPFakesInt != 6) Result $= "QuarterpoundHPFakes=" $ QuarterpoundHPFakes $ "?";
	if(TrashHPFakesInt != 6) Result $= "TrashHPFakes=" $ TrashHPFakes $ "?";
	if(!ZedsTeleportCloserBool) Result $= "ZedTeleportCloser=" $ ZedsTeleportCloserBool $ "?";

	return Result;
}

static function string GetPerkStr(class<KFPerk> Perk)
{
	switch(Perk)
	{
		case class'KFPerk_Berserker':		return "Zerk";
		case class'KFPerk_Commando':		return "Com";
		case class'KFPerk_Support':			return "Sup";
		case class'KFPerk_FieldMedic':		return "Med";
		case class'KFPerk_Firebug':			return "Bug";
		case class'KFPerk_Demolitionist':	return "Demo";
		case class'KFPerk_Gunslinger':		return "GS";
		case class'KFPerk_Sharpshooter':	return "SS";
		case class'KFPerk_Swat':			return "Swat";
		case class'KFPerk_Survivalist':		return "Surv";
		default: return "unknown";
	}
}

function SetShouldRecord()
{
	bShouldRecord = ShouldRecord();
}

function bool ShouldRecord()
{
	local int RefCS;

	RefCS = (CohortSizeInt==0) ? 4 : CohortSizeInt;

	if( ScrakeHPFakesInt < Recorder.RecordConditions.MinHPFakes || FleshpoundHPFakesInt < Recorder.RecordConditions.MinHPFakes || QuarterPoundHPFakesInt < Recorder.RecordConditions.MinHPFakes ||
		SpawnPollFloat > Recorder.RecordConditions.MaxSP || SpawnModFloat > Recorder.RecordConditions.MaxSM || RefCS < Recorder.RecordConditions.MinCS )
		return false;

	return EnoughMMandWSF(PlayerCountToRec);
}

function bool EnoughMMandWSF(int PlayerNum)
{
	if(1 <= PlayerCountToRec && PlayerCountToRec <= 6)
	{
		return (MaxMonstersInt >= Recorder.RecordConditions.MinMM[PlayerCountToRec-1]) && (WaveSizeFakesInt >= Recorder.RecordConditions.MinWSF[PlayerCountToRec-1]);
	}
	return true;
}

function bool IsAdmin(PlayerController PC)
{
	local CD_PlayerController CDPC;

	CDPC = CD_PlayerController(PC);
	return CDPC.GetCDPRI().AuthorityLevel > 3;
}

function CD_BuyAmmo(string Value, KFPlayerController KFPC)
{
	local CD_DroppedPickup Pickup;
	local int i, failed, payment, idx;

	if(!MyKFGRI.bTraderIsOpen)
	{
		BroadcastLocalizedEcho("<local>CD_Survival.TraderNotOpenString</local>");
		return;
	}

	if(PickupTracker != none)
	{
		//	for commando to fill fal
		if(Value == "fal")
		{
			if(AuthorityHandler.bAntiOvercap)
			{
				BroadcastLocalizedEcho("<local>CD_Survival.ErrorPrefix</local>AntiOvercap=true", 'UMEcho');
			}

			//	only for commando
			else if(KFPC.GetPerk().GetPerkClass() != class'KFPerk_Commando')
			{
				BroadcastLocalizedEcho("<local>CD_Survival.ErrorPrefix</local><local>CD_Survival.NotCommandoErrorMsg</local>", 'UMEcho');
				return;
			}

			//	Dropped Weapons
			for(i=0; i<PickupTracker.WeaponPickupRegistry.length; i++)
			{
				//	choose FAL
				if(PickupTracker.WeaponPickupRegistry[i].KFWClass == class'KFWeap_AssaultRifle_FNFal')
				{
					Pickup = PickupTracker.WeaponPickupRegistry[i].KFDP;

					//	skip client anti overcap
					idx = PickupSettings.Find('PRI', Pickup.Instigator.Controller.PlayerReplicationInfo);
					if(idx == INDEX_NONE || PickupSettings[idx].bAntiOvercap)
					{
						continue;
					}

					//	purchase and fill
					CD_BuyAmmo_Core(KFWeapon(Pickup.Inventory), KFPC, failed, payment);
					Pickup.UpdateInformation();
				}
			}
		}

		//	general: buy ammo for own weapons
		else
		{
			//	Dropped Weapons
			for(i=0; i<PickupTracker.WeaponPickupRegistry.length; i++)
			{
				//	choose OWN weapons
				if(PickupTracker.WeaponPickupRegistry[i].OrigOwnerPRI == KFPC.PlayerReplicationInfo)
				{
					Pickup = PickupTracker.WeaponPickupRegistry[i].KFDP;
					CD_BuyAmmo_Core(KFWeapon(Pickup.Inventory), KFPC, failed, payment);
					Pickup.UpdateInformation();
				}
			}
		}

		if ( failed > 0 ) CD_PlayerController(KFPC).LocalizedClientMessage("<local>CD_Survival.DoshShortageString</local>\n<local>CD_Survival.FailCountString</local>" @ string(failed), 'UMEcho');
		else if ( payment == 0 ) CD_PlayerController(KFPC).ShowMessageBar('Game', "<local>CD_Survival.FillNothingMsg</local>", , true);
		else if ( Value == "fal" ) BroadcastLocalizedEcho("<local>CD_Survival.FillFalMsg</local>");
		else CD_PlayerController(KFPC).ShowMessageBar('Game', "<local>CD_Survival.FillSuccessMsg</local>", , true);
	}
}

function CD_BuyAmmo_Core(KFWeapon Weap, KFPlayerController KFPC, out int failed, out int payment)
{
	if(Weap != none)
	{
		if( KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo).Score >= GetPrice(Weap) )
		{
		// pay
			KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo).Score -= GetPrice(Weap);

		// total payment
	        payment += GetPrice(Weap);

		// Modify Magazine Size
			Weap.InitializeAmmoCapacity(/*optional*/, KFPC.GetPerk());

		// fill ammo
			Weap.AmmoCount[0] = Weap.MagazineCapacity[0];
			Weap.AmmoCount[1] = Weap.MagazineCapacity[1];
	        Weap.AddAmmo(Weap.GetMaxAmmoAmount(0));
	        Weap.AddSecondaryAmmo(Weap.GetMaxAmmoAmount(1));        
	    }
	    else failed += 1;
	}
}

static function int GetPrice(KFWeapon W)
{
	local int i, price, ammo, MagPrice;
	local class<KFWeaponDefinition> WeapDef;

	price = 0;
	for(i=0; i<2; i++)
	{
		if(W.class.default.MagazineCapacity[i] <= 0) // Avoid dividing by zero
			continue;

		WeapDef = class<KFDamageType>(W.class.default.InstantHitDamageTypes[3]).default.WeaponDef;
		ammo = W.MagazineCapacity[i] - W.AmmoCount[i] + W.SpareAmmoCapacity[i] - W.SpareAmmoCount[i]; // to buy
		MagPrice = (i==0 ? WeapDef.default.AmmoPricePerMag : WeapDef.default.SecondaryAmmoMagPrice); // Default mag price
		price += ammo * MagPrice / W.class.default.MagazineCapacity[i]; // price to consume
	}

	return Max(price, 0); // Don't return a negative value.
}

private final function CheckOvercaps()
{
	local Inventory Inv;
	local KFPlayerController KFPC;
	local KFDroppedPickup KFDP;
	local KFWeapon KFW;
	local KFPawn Player;
	local int idx;

	//	For Pickup
	foreach DynamicActors(class'KFDroppedPickup', KFDP)
	{
		KFPC = KFPlayerController(KFDP.Instigator.Controller);

		if(!AuthorityHandler.bAntiOvercap)
		{
			idx = PickupSettings.Find('PRI', KFPC.PlayerReplicationInfo);
			if( idx == INDEX_NONE || !PickupSettings[idx].bAntiOvercap )
				continue;
		}

		KFW = KFWeapon(KFDP.Inventory);

		if(KFPC != none && KFW != none)
			CheckOvercap_Core(KFW, KFPC.GetPerk());
	}

	//	For Inventory
	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
	{
		if(!AuthorityHandler.bAntiOvercap)
		{
			idx = PickupSettings.Find('PRI', KFPC.PlayerReplicationInfo);
			if( idx == INDEX_NONE || !PickupSettings[idx].bAntiOvercap )
				continue;
		}

		Player = KFPawn(KFPC.Pawn);

		if(Player != none)
		{
			for(Inv=Player.InvManager.InventoryChain; Inv!=None; Inv=Inv.Inventory)
			{
				KFW = KFWeapon(Inv);

				if(KFW != none)
					CheckOvercap_Core(KFW, KFPC.GetPerk());
			}
		}	
	}
}

private final function CheckOvercap_Core(KFWeapon KFW, KFPerk Perk)
{
	local int OrigMagAmmo, OrigSpareAmmo, MagCapacity, SpareCapacity;

	OrigMagAmmo = KFW.AmmoCount[0];
	OrigSpareAmmo = KFW.SpareAmmoCount[0];
	MagCapacity = KFW.default.MagazineCapacity[0];
	SpareCapacity = KFW.default.SpareAmmoCapacity[0];

	Perk.ModifyMagSizeAndNumber(KFW, MagCapacity);
	Perk.ModifyMaxSpareAmmoAmount(KFW, SpareCapacity);

	KFW.AmmoCount[0] = Min(OrigMagAmmo, MagCapacity);
	KFW.SpareAmmoCount[0] = Min(OrigSpareAmmo, SpareCapacity);
}

function DisableDispawnMine()
{
	local KFProj_Mine_Reconstructor Mine;

	foreach TouchingActors( class'KFProj_Mine_Reconstructor', Mine )
	{
		if(Mine.Lifespan != MaxInt)
			Mine.Lifespan = MaxInt;
	}
}

//	Reflesh → Refresh... :o
function RefreshWebInfo()
{
	if(CDGRI != none)
	{
		CDGRI.CDInfoParams.SC = SpawnCycle;
		CDGRI.CDInfoParams.MM = MaxMonsters;
		CDGRI.CDInfoParams.CS = CohortSize;
		CDGRI.CDInfoParams.SP = SpawnPoll;
		CDGRI.CDInfoParams.WSF = WaveSizeFakes;
		CDGRI.CDInfoParams.SM = SpawnMod;
		CDGRI.CDInfoParams.THPF = TrashHPFakes;
		CDGRI.CDInfoParams.QPHPF = QuarterPoundHPFakes;
		CDGRI.CDInfoParams.FPHPF = FleshpoundHPFakes;
		CDGRI.CDInfoParams.SCHPF = ScrakeHPFakes;
		CDGRI.CDInfoParams.CHSPP = bCountHeadshotsPerPellet;
	}
}

function SpawnDoshDrone(CD_PlayerController CDPC)
{
	local vector StartTrace, EndTrace, RealStartLoc, AimDir;
	local ImpactInfo TestImpact;
	local vector DirA, DirB;
	local Quat Q;
    local CD_Pawn_DoshDrone SpawnedActor;
    local KFWeapon KFW;
    local int SpawnCost;

    if(MyKFGRI.bWaveIsActive)
    {
    	BroadcastLocalizedEcho("<local>CD_Survival.CurrentlyUnavailableMsg</local>");
    	return;
    }

    SpawnCost = class'KFGameContent.KFWeap_AssaultRifle_Doshinegun'.default.DoshCost * (class'CustomWeap_DoshDrone'.default.MagazineCapacity[0] + class'CD_Pawn_DoshDrone'.default.DetonateNumberOfProjectiles);
    if(SpawnCost > CDPC.GetCDPRI().Score)
    {
    	CDPC.ShowLocalizedPopup("<local>CD_Survival.DoshShortageTitle</local>", "<local>CD_Survival.RequiredMsg</local>"@string(SpawnCost)@"Dosh");
    	return;
    }

	KFW = KFWeapon(CDPC.Pawn.Weapon);
	if(KFW == none)
	{
		return;
	}

	StartTrace = KFW.Location; //KFW.GetSafeStartTraceLocation();
	AimDir = Vector(KFW.GetAdjustedAim( StartTrace ));
	RealStartLoc = KFW.GetPhysicalFireStartLoc(AimDir);

	if( StartTrace != RealStartLoc )
	{
		EndTrace = StartTrace + AimDir * KFW.GetTraceRange();
		TestImpact = KFW.CalcWeaponFire( StartTrace, EndTrace );
		DirB = AimDir;
		AimDir = Normal(TestImpact.HitLocation - RealStartLoc);
		DirA = AimDir;
		if ( (DirA dot DirB) < KFW.MaxAimAdjust_Cos )
		{
			Q = QuatFromAxisAndAngle(Normal(DirB cross DirA), KFW.MaxAimAdjust_Angle);
			AimDir = QuatRotateVector(Q,DirB);
		}
	}

	SpawnedActor = Spawn(class'CD_Pawn_DoshDrone', self,, RealStartLoc + (class'KFGameContent.KFWeap_HRG_Warthog'.default.TurretSpawnOffset >> KFW.Rotation), KFW.Rotation,,true);
	
	if( SpawnedActor != none )
	{
		SpawnedActor.OwnerPawn = CDPC.Pawn;
		SpawnedActor.SetPhysics(PHYS_Falling);
		SpawnedActor.Velocity = AimDir * class'KFGameContent.KFWeap_HRG_Warthog'.default.ThrowStrength;
		SpawnedActor.UpdateInstigator(KFW.Instigator);
		SpawnedActor.SetTurretState(ETS_Throw);

		CDPC.GetCDPRI().Score -= SpawnCost;
	}
}

function GetDoshinegun(KFPlayerController KFPC)
{
	local Inventory Inv;
	local KFPlayerReplicationInfo KFPRI;

	KFPRI = KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo);
	if(KFPC == none || KFPC.Pawn == none || KFPRI == none)
		return;

	for(Inv=KFPC.Pawn.InvManager.InventoryChain; Inv!=None; Inv=Inv.Inventory)
	{
		if(Inv.ItemName == class'CustomWeap_AssaultRifle_Doshinegun'.default.ItemName)
		{
			KFPRI.Score += KFWeapon(Inv).Ammocount[0]*class'CustomWeap_AssaultRifle_Doshinegun'.default.DoshCost;
			KFPC.Pawn.InvManager.RemoveFromInventory(Inv);
			return;
		}
	}

	if(GetStateName() == 'TraderOpen' || GetStateName() == 'MatchEnded')
	{
		if(KFPRI.Score>=400)
		{
			KFPRI.Score -= 400;

			if(GetStateName() == 'MatchEnded' && CD_PlayerReplicationInfo(KFPRI).AuthorityLevel > 1)
			{
				KFPC.Pawn.CreateInventory(class'CustomWeap_AssaultRifle_Doshinegun_Kriss');
				for(Inv=KFPC.Pawn.InvManager.InventoryChain; Inv!=None; Inv=Inv.Inventory)
				{
					if(Inv.ItemName == class'KFGameContent.KFWeap_AssaultRifle_Doshinegun'.default.ItemName)
						KFWeapon(Inv).Ammocount[0] = 20;
				}
			}

			else
				KFPC.Pawn.CreateInventory(class'CustomWeap_AssaultRifle_Doshinegun');
		}
		else
		{
			CD_PlayerController(KFPC).ShowLocalizedPopup("<local>CD_Survival.DoshShortageTitle</local>", "<local>CD_Survival.DoshinegunPriceMsg</local>");
		}
	}
	else
	{
		BroadcastLocalizedEcho("<local>CD_Survival.CurrentlyUnavailableMsg</local>");
	}
}

function ShowResultMenu()
{
	local CD_PlayerController CDPC;

	foreach WorldInfo.AllControllers(class'CD_PlayerController', CDPC)
	{
		xMut.ShowMapVote('TeamAward', CDPC);
	}
}

function string SetMaxUpgrade(int Count)
{
	CDGRI.MaxUpgrade = Max(0, Count);
	MaxUpgrade = CDGRI.MaxUpgrade;
	SaveConfig();
	RefreshWebInfo();
	return "MaxUpgradeCount=" $ string(CDGRI.MaxUpgrade);
}

function SetAntiOvercap(bool bAnti)
{
	AuthorityHandler.bAntiOvercap = bAnti;
	AuthorityHandler.SaveConfig();
	SettingSynchronizer.ResynchSettings();
	RefreshWebInfo();
}

function ServerAssignAdmin(CD_PlayerController CDPC)
{
	local bool bCurrentAdmin;
	local string ID;

	bCurrentAdmin = CDPC.PlayerReplicationinfo.bAdmin;

	if(bCurrentAdmin)
	{
		ID = class'CD_Object'.static.GetSteamID(CDPC.GetCDPRI().UniqueId);
		AuthorityHandler.AuthorizeUser(ID, 4);
		SettingSynchronizer.SynchSettings(CDPC);
		CDPC.LocalizedClientMessage("<local>CD_Survival.SavedString</local>\n" $ ID, 'UMEcho');
	}

	else if(IsAdmin(CDPC))
	{
		CDPC.PlayerReplicationinfo.bAdmin = true;
		CDPC.LocalizedClientMessage("<local>CD_Survival.AdminAcceptMsg</local>", 'UMEcho');
	}

	else
		CDPC.LocalizedClientMessage("<local>CD_Survival.AdminDenyMsg</local>", 'UMEcho');
}

function ReceivePickupInfo(CD_PlayerController CDPC, bool bDisableOthers, bool bDropLocked, bool bDisableLow, bool bAntiOvercap)
{
	local PlayerReplicationinfo PRI;
	local int index;
	local PickupSetting PS;

	PRI = CDPC.PlayerReplicationinfo;
	index = PickupSettings.Find('PRI', PRI);

	if(index == INDEX_NONE)
	{
		PS.DisableOthers = bDisableOthers;
		PS.DropLocked = bDropLocked;
		PS.DisableLowAmmo = bDisableLow;
		PS.bAntiOvercap = bAntiOvercap;
		PS.PRI = PRI;
		PickupSettings.AddItem(PS);
	}
	else
	{
		PickupSettings[index].DisableOthers = bDisableOthers;
		PickupSettings[index].DropLocked = bDropLocked;
		PickupSettings[index].DisableLowAmmo = bDisableLow;
		PickupSettings[index].bAntiOvercap = bAntiOvercap;
	}

	SetTimer(1.f, false, 'RefreshUnglowPickup');
}

simulated function ServerPrepareOpenMenu(CD_PlayerController CDPC)
{
	if(CDPC.PlayerReplicationinfo.bWaitingPlayer)
	{
		CDPC.GotoState('Spectating');
		CDPC.ClientGotoState('Spectating');
		CDPC.SetTimer(0.25f, false, 'ShowReadyButton');
	}
}

function RefreshUnglowPickup()
{
	local CD_DroppedPickup CDDP;

	foreach WorldInfo.AllActors(class'CD_DroppedPickup', CDDP)
	{
		CheckUnglowPickup(CDDP);
	}
}

function CheckUnglowPickup(CD_DroppedPickup CDDP)
{
	local CD_Pawn_Human Player;

	foreach WorldInfo.AllPawns(class'CD_Pawn_Human', Player)
	{
		Player.SwitchMaterialGlow(PickupSettingsAllowed(Player, CDDP), CDDP);
	}
}

function CheckUnglowPickupForPlayer(CD_Pawn_Human Player)
{
	local CD_DroppedPickup CDDP;

	foreach WorldInfo.AllActors(class'CD_DroppedPickup', CDDP)
	{
		Player.SwitchMaterialGlow(PickupSettingsAllowed(Player, CDDP), CDDP);
	}
}

exec function ShowCycleOrder(string CycleName)
{
	GameInfo_CDCP.Print( SpawnCycleAnalyzer.SpawnOrderOverview(CycleName) );
}

exec function SetupAspServer(bool Auth, bool Start, bool RPW)
{
	if(Auth)
		AuthorityHandler.SetupAspAuthList();

	if(Start)
		xMut.SetupAspCustomStart();

	if(RPW)
		AuthorityHandler.SetupAspRPW();
}

function SetExtraCommand(string Key, string Response, CD_PlayerController CDPC)
{
	local int i;
	ChatCommander.ExtraCommands.add(1);
	i = ChatCommander.ExtraCommands.length;
	ChatCommander.ExtraCommands[i-1].Key = Key;
	ChatCommander.ExtraCommands[i-1].Res = Response;
	ChatCommander.SaveConfig();
	BroadcastPersonalEcho("!cd" $ Locs(Key) $ "=" $ Response, 'CDEcho', CDPC);
}

function ShowMapVote(name StateName, CD_PlayerController CDPC)
{
	xMut.ShowMapVote(StateName, CDPC);
	SyncStats(CDPC);
}

function SyncStats(CD_PlayerController CDPC)
{
	SynchWeapDmgList(CDPC);
	CDPC.SyncStats(CDPC.ShotsFired, CDPC.ShotsHit, CDPC.ShotsHitHeadshot);
}

function SynchWeapDmgList(CD_PlayerController CDPC)
{
	local int i;

	for(i=0; i<CDPC.MatchStats.WeaponDamageList.length; i++)
	{
		CDPC.SynchWeapDmgList(CDPC.MatchStats.WeaponDamageList[i]);
	}
}

defaultproperties
{	
	ReleaseVersion = "23"
	DebugVersion = "07.13"

// 3 times amount of LateArrivalDosh
	// Short Wave
	LateArrivalStarts(0)={(
		StartingDosh[0]=2100,	//550
		StartingDosh[1]=2550,	//650
		StartingDosh[2]=4950,	//1200
		StartingDosh[3]=6600	//1500
	)}

	// Normal Wave
	LateArrivalStarts(1)={(
		StartingDosh[0]=1800,	//450
		StartingDosh[1]=2400,	//600
		StartingDosh[2]=3000,	//750
		StartingDosh[3]=3300,	//800
		StartingDosh[4]=4500,	//1100
		StartingDosh[5]=6000,	//1400
		StartingDosh[6]=6600,	//1500
		StartingDosh[7]=7200	//1600
	)}

	// Long Wave
	LateArrivalStarts(2)={(
		StartingDosh[0]=1800,	//450
		StartingDosh[1]=2100,	//550
		StartingDosh[2]=3000,	//750
		StartingDosh[3]=3900,	//1000
		StartingDosh[4]=4950,	//1200
		StartingDosh[5]=5400,	//1300
		StartingDosh[6]=6000,	//1400
		StartingDosh[7]=6600,	//1500
		StartingDosh[8]=7200,	//1600
		StartingDosh[9]=7200	//1600
	)}

	MaxRespawnDosh(0)=3500.f // Normal
	MaxRespawnDosh(1)=3100.f // Hard
	MaxRespawnDosh(2)=3400.f // Suicidal  //1550
	MaxRespawnDosh(3)=3100.f // Hell On Earth //1000.0
	
	//HelpURL = "https://w.atwiki.jp/kf2_cd/pages/23.html"
	HelpURL="https://steamcommunity.com/sharedfiles/filedetails/?id=2859078261"

	DefaultPawnClass=Class'CombinedCD2.CD_Pawn_Human'
	GameConductorClass=class'CombinedCD2.CD_DummyGameConductor'
	GameReplicationInfoClass=class'CombinedCD2.CD_GameReplicationInfo'
	DifficultyInfoClass=class'CombinedCD2.CD_DifficultyInfo'
	KFGFxManagerClass=class'CombinedCD2.CD_GFxManager'
	PlayerControllerClass=class'CombinedCD2.CD_PlayerController'
	PlayerReplicationInfoClass=class'CombinedCD2.CD_PlayerReplicationInfo'
	HUDType=class'CD_GFxHudWrapper'

	SpawnManagerClasses(0)=class'CombinedCD2.CD_SpawnManager_Short'
	SpawnManagerClasses(1)=class'CombinedCD2.CD_SpawnManager_Normal'
	SpawnManagerClasses(2)=class'CombinedCD2.CD_SpawnManager_Long'

	Begin Object Class=CD_ConsolePrinter Name=Default_CDCP
	End Object

	GameInfo_CDCP=Default_CDCP
	DefaultAuthLevel=CDAUTH_WRITE

	SpawnModEpsilon=0.0001
	SpawnPollEpsilon=0.0001
	ZTSpawnSlowdownEpsilon=0.0001
	
	CDGameModes.Add((FriendlyName="CD_Survival",ClassNameAndPath="CombinedCD2.CD_Survival",bSoloPlaySupported=True,DifficultyLevels=4,Lengths=4,LocalizeID=0))

    	GameInfoClassAliases.Add((ShortName="CD_Survival", GameClassName="CombinedCD2.CD_Survival"))
}

//=============================================================================
// ControlledDifficulty_Survival
//=============================================================================
// Survival with less bullshit
//=============================================================================
// Because vanilla Survival sucks
//=============================================================================

class CD_Survival extends KFGameInfo_Survival
	config( CombinedCD );

`include(CD_BuildInfo.uci)
`include(CD_Log.uci)

enum ECDWaveInfoStatus
{
	WIS_OK,
	WIS_PARSE_ERROR,
	WIS_SPAWNCYCLE_NOT_MODDED
};

enum ECDFakesMode
{
	FPM_ADD,
	FPM_REPLACE
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

var config string AlbinoStalkers;
var bool AlbinoStalkersBool;

var config string Albinohusks;
var bool AlbinoHusksBool;

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

var config string FakesMode;
var ECDFakesMode FakesModeEnum;

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

var config string WaveEndSummaries;
var bool bWaveEndSummaries;

var config string WeaponTimeout;
var int WeaponTimeoutInt;

var config string ZedsTeleportCloser;
var bool ZedsTeleportCloserBool;

var config bool bLogControlledDifficulty;

////////////////////////////////////////////////////////////////
// Internal runtime state (no config options below this line) //
////////////////////////////////////////////////////////////////

var CD_DynamicSetting BossHPFakesSetting;
var CD_DynamicSetting CohortSizeSetting;
var CD_DynamicSetting WaveSizeFakesSetting;
var CD_DynamicSetting FleshpoundHPFakesSetting;
var CD_DynamicSetting QuarterPoundHPFakesSetting;
var CD_DynamicSetting MaxMonstersSetting;
var CD_DynamicSetting SpawnPollSetting;
var CD_DynamicSetting ScrakeHPFakesSetting;
var CD_DynamicSetting SpawnModSetting;
var CD_DynamicSetting TrashHPFakesSetting;
var CD_DynamicSetting ZTSpawnSlowdownSetting;

var array<CD_DynamicSetting> DynamicSettings;

var CD_BasicSetting AlbinoAlphasSetting;
var CD_BasicSetting AlbinoCrawlersSetting;
var CD_BasicSetting AlbinoGorefastsSetting;
var CD_BasicSetting AlbinoStalkersSetting;
var CD_BasicSetting AlbinoHusksSetting;
var CD_BasicSetting AutoPauseSetting;
var CD_BasicSetting BossSetting;
var CD_BasicSetting CountHeadshotsPerPelletSetting;
var CD_BasicSetting FakesModeSetting;
var CD_BasicSetting FleshpoundRageSpawnsSetting;
var CD_BasicSetting SpawnCycleSetting;
var CD_BasicSetting TraderTimeSetting;
var CD_BasicSetting EnableReadySystemSetting;
var CD_BasicSetting	WaveEndSummariesSetting;
var CD_BasicSetting WeaponTimeoutSetting;
var CD_BasicSetting ZedsTeleportCloserSetting;
var CD_BasicSetting ZTSpawnModeSetting;

var array<CD_BasicSetting> BasicSettings;

var array<CD_Setting> AllSettings;

var array<CD_AIWaveInfo> IniWaveInfos;

var array<sGameMode> CDGameModes;

var bool AlreadyLoadedIniWaveInfos;

var CD_DifficultyInfo CDDI;

var CD_ConsolePrinter GameInfo_CDCP;

var CD_SpawnCycleCatalog SpawnCycleCatalog;

var const float SpawnModEpsilon;

var const float SpawnPollEpsilon;

var const float ZTSpawnSlowdownEpsilon;

var int PausedRemainingTime;
var int PausedRemainingMinute;

var CD_ChatCommander ChatCommander;

var CD_StatsSystem StatsSystem;

var int DebugExtraProgramPlayers;

var string DynamicSettingsBulletin;

/* ==============================================================================================================================
 *	AdditionalSettings
 * ============================================================================================================================== */

var string ReleaseVersion, DebugVersion;
var config string TraderDash;
var bool bTraderDash;
var config string StartwithFullAmmo;
var bool bStartwithFullAmmo;
var config string StartwithFullGrenade;
var bool bStartwithFullGrenade;
var config string StartwithFullArmor;
var bool bStartwithFullArmor;
var config string StartingWeaponTier;
var int StartingWeaponTierInt;
var config string DropAllWeapons;
var bool bDropAllWeapons;
var config string BossDifficulty;
var int BossDifficultyInt;
var config string DisableBossMinions;
var bool bDisableBossMinions;
var config string DisableSpawners;
var bool bDisableSpawners;
var config string DisableRobots;
var bool bDisableRobots;
var config string AutoCycleAnalyze;
var bool bAutoCycleAnalyze;
var config string DisableBoss;
var bool bDisableBoss;

var CD_BasicSetting TraderDashSetting;
var CD_BasicSetting StartwithFullAmmoSetting;
var CD_BasicSetting StartwithFullGrenadeSetting;
var CD_BasicSetting StartwithFullArmorSetting;
var CD_BasicSetting StartingWeaponTierSetting;
var CD_BasicSetting DropAllWeaponsSetting;
var CD_BasicSetting BossDifficultySetting;
var CD_BasicSetting DisableBossMinionsSetting;
var CD_BasicSetting DisableSpawnersSetting;
var CD_BasicSetting DisableRobotsSetting;
var CD_BasicSetting AutoCycleAnalyzeSetting;
var CD_BasicSetting DisableBossSetting;

struct PickupSetting
{
	var bool DisableOthers;
	var bool DropLocked;
	var bool DisableLowAmmo;
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

var config bool bLargeLess;
var config bool DisablePickupMod;
var config bool bSolePerksSystem;
var config int INIVer;
var config int MaxUpgrade;

var array< class<Inventory> > StartingItems;
var array<PickupSetting> PickupSettings;
var int DeadBoss;
var bool bUsedWinMatch;
var bool bShouldRecord;
var string HelpURL;

var CD_AuthorityHandler AuthorityHandler;
var CD_DroppedPickupTracker PickupTracker;
var CD_GameReplicationInfo CDGRI;
var CD_SpawnCycleAnalyzer SpawnCycleAnalyzer;
var CD_TraderItemsHelper TraderHelper;
var CD_Recorder Recorder;
var xVotingHandler xMut;

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

	SetupBasicSettings();
	SetupDynamicSettings();
	SortAllSettingsByName();
	SetupGRI();

	ParseCDGameOptions( Options );

	ChatCommander = new(self) class'CD_ChatCommander';
	ChatCommander.SetupChatCommands();
	StatsSystem = new(self) class'CD_StatsSystem';
	SpawnCycleAnalyzer = new(self) class'CD_SpawnCycleAnalyzer';
	TraderHelper = Spawn(class'CD_TraderItemsHelper');
	PickupTracker = Spawn(class'CD_DroppedPickupTracker', Self);

	if(WorldInfo.NetMode != NM_Client)
	{
		AuthorityHandler = Spawn(class'CD_AuthorityHandler', self);
		Recorder = Spawn(class'CD_Recorder', self);
	}

	foreach DynamicActors(class'xVotingHandler', xMut)
		break;

	if (xMut==None)
	{
		xMut = Spawn(class'xVotingHandler');
		xMut.CD = self;
	}

	RefleshWebInfo();
	SetTimer(5.0, false, 'CheckMapInfo');
}

function InitConfig()
{
	if(INIVer < 3)
	{
		MaxUpgrade = 1;
		INIVer = 3;
	}
}

private function SortAllSettingsByName(){ AllSettings.sort(SettingNameComparator); }

private function int SettingNameComparator( CD_Setting a, CD_Setting b )
{
	local string an, bn;

	an = a.GetOptionName();
	bn = b.GetOptionName();

	if ( an < bn )
	{
		return 1;
	}
	else if ( an > bn )
	{
		return -1;
	}
	return 0;
}

function SetupBasicSettings()
{
	AlbinoAlphasSetting = new(self) class'CD_BasicSetting_AlbinoAlphas';
	RegisterBasicSetting( AlbinoAlphasSetting );

	AlbinoCrawlersSetting = new(self) class'CD_BasicSetting_AlbinoCrawlers';
	RegisterBasicSetting( AlbinoCrawlersSetting );

	AlbinoGorefastsSetting = new(self) class'CD_BasicSetting_AlbinoGorefasts';
	RegisterBasicSetting( AlbinoGorefastsSetting );
	
	AutoCycleAnalyzeSetting = new(self) class'CD_BasicSetting_AutoCycleAnalyze';
	RegisterBasicSetting( AutoCycleAnalyzeSetting );
	
	AutoPauseSetting = new(self) class'CD_BasicSetting_AutoPause';
	RegisterBasicSetting( AutoPauseSetting );
	
	BossSetting = new(self) class'CD_BasicSetting_Boss';
	RegisterBasicSetting( BossSetting );

	BossDifficultySetting = new(self) class'CD_BasicSetting_BossDifficulty';
	RegisterBasicSetting( BossDifficultySetting );

	CountHeadshotsPerPelletSetting = new(self) class'CD_BasicSetting_CountHeadshotsPerPellet';
	RegisterBasicSetting( CountHeadshotsPerPelletSetting );

	DisableBossSetting = new(self) class'CD_BasicSetting_DisableBoss';
	RegisterBasicSetting( DisableBossSetting );

	DisableBossMinionsSetting = new(self) class'CD_BasicSetting_DisableBossMinions';
	RegisterBasicSetting( DisableBossMinionsSetting );

	DisableRobotsSetting = new(self) class'CD_BasicSetting_DisableRobots';
	RegisterBasicSetting( DisableRobotsSetting );

	DisableSpawnersSetting = new(self) class'CD_BasicSetting_DisableSpawners';
	RegisterBasicSetting( DisableSpawnersSetting );

	DropAllWeaponsSetting = new(self) class'CD_BasicSetting_DropAllWeapons';
	RegisterBasicSetting( DropAllWeaponsSetting );

	EnableReadySystemSetting = new(self) class'CD_BasicSetting_EnableReadySystem';
	RegisterBasicSetting( EnableReadySystemSetting );
	
	FakesModeSetting = new(self) class'CD_BasicSetting_FakesMode';
	RegisterBasicSetting( FakesModeSetting );

	FleshpoundRageSpawnsSetting = new(self) class'CD_BasicSetting_FleshpoundRageSpawns';
	RegisterBasicSetting( FleshpoundRageSpawnsSetting );

	StartingWeaponTierSetting = new(self) class'CD_BasicSetting_StartingWeaponTier';
	RegisterBasicSetting( StartingWeaponTierSetting );

	StartwithFullAmmoSetting = new(self) class'CD_BasicSetting_StartwithFullAmmo';
	RegisterBasicSetting( StartwithFullAmmoSetting );

	StartwithFullArmorSetting = new(self) class'CD_BasicSetting_StartwithFullArmor';
	RegisterBasicSetting( StartwithFullArmorSetting );

	StartwithFullGrenadeSetting = new(self) class'CD_BasicSetting_StartwithFullGrenade';
	RegisterBasicSetting( StartwithFullGrenadeSetting );
	
	SpawnCycleSetting = new(self) class'CD_BasicSetting_SpawnCycle';
	RegisterBasicSetting( SpawnCycleSetting );

	TraderDashSetting = new(self) class'CD_BasicSetting_TraderDash';
	RegisterBasicSetting( TraderDashSetting );

	TraderTimeSetting = new(self) class'CD_BasicSetting_TraderTime';
	RegisterBasicSetting( TraderTimeSetting );
	
	WeaponTimeoutSetting = new(self) class'CD_BasicSetting_WeaponTimeout';
	RegisterBasicSetting( WeaponTimeoutSetting );

	ZedsTeleportCloserSetting = new(self) class'CD_BasicSetting_ZedsTeleportCloser';
	RegisterBasicSetting( ZedsTeleportCloserSetting );

	ZTSpawnModeSetting = new(self) class'CD_BasicSetting_ZTSpawnMode';
	RegisterBasicSetting( ZTSpawnModeSetting );
}

function SetupDynamicSettings()
{
	BossHPFakesSetting = new(self) class'CD_DynamicSetting_BossHPFakes';
	BossHPFakesSetting.IniDefsArray = BossHPFakesDefs;
	RegisterDynamicSetting( BossHPFakesSetting );

	CohortSizeSetting = new(self) class'CD_DynamicSetting_CohortSize';
	CohortSizeSetting.IniDefsArray = CohortSizeDefs;
	RegisterDynamicSetting( CohortSizeSetting );

	WaveSizeFakesSetting = new(self) class'CD_DynamicSetting_WaveSizeFakes';
	WaveSizeFakesSetting.IniDefsArray = WaveSizeFakesDefs;
	RegisterDynamicSetting( WaveSizeFakesSetting );

	MaxMonstersSetting = new(self) class'CD_DynamicSetting_MaxMonsters';
	MaxMonstersSetting.IniDefsArray = MaxMonstersDefs;
	RegisterDynamicSetting( MaxMonstersSetting );

	SpawnModSetting = new(self) class'CD_DynamicSetting_SpawnMod';
	SpawnModSetting.IniDefsArray = SpawnModDefs;
	RegisterDynamicSetting( SpawnModSetting );

	SpawnPollSetting = new(self) class'CD_DynamicSetting_SpawnPoll';
	SpawnPollSetting.IniDefsArray = SpawnPollDefs;
	RegisterDynamicSetting( SpawnPollSetting );

	ScrakeHPFakesSetting = new(self) class'CD_DynamicSetting_ScrakeHPFakes';
	ScrakeHPFakesSetting.IniDefsArray = ScrakeHPFakesDefs;
	RegisterDynamicSetting( ScrakeHPFakesSetting );

	FleshpoundHPFakesSetting = new(self) class'CD_DynamicSetting_FleshpoundHPFakes';
	FleshpoundHPFakesSetting.IniDefsArray = FleshpoundHPFakesDefs;
	RegisterDynamicSetting( FleshpoundHPFakesSetting );

	QuarterPoundHPFakesSetting = new(self) class'CD_DynamicSetting_QuarterPoundHPFakes';
	QuarterPoundHPFakesSetting.IniDefsArray = QuarterPoundHPFakesDefs;
	RegisterDynamicSetting( QuarterPoundHPFakesSetting );
	
	TrashHPFakesSetting = new(self) class'CD_DynamicSetting_TrashHPFakes';
	TrashHPFakesSetting.IniDefsArray = TrashHPFakesDefs;
	RegisterDynamicSetting( TrashHPFakesSetting );

	ZTSpawnSlowdownSetting = new(self) class'CD_DynamicSetting_ZTSpawnSlowdown';
	ZTSpawnSlowdownSetting.IniDefsArray = ZTSpawnSlowdownDefs;
	RegisterDynamicSetting( ZTSpawnSlowdownSetting );
}

private function RegisterBasicSetting( const out CD_BasicSetting BasicSetting )
{
	BasicSettings.AddItem( BasicSetting );
	AllSettings.AddItem( BasicSetting );
}

private function RegisterDynamicSetting( const out CD_DynamicSetting DynamicSetting )
{
	DynamicSettings.AddItem( DynamicSetting );
	AllSettings.AddItem( DynamicSetting );
}

private function ParseCDGameOptions( const out string Options )
{
	local int i;

	for ( i = 0; i < AllSettings.Length; i++ )
	{
		AllSettings[i].InitFromOptions( Options );
	}
}

function SetupGRI()
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

/* ==============================================================================================================================
 *	Overridden functions and related ones
 * ============================================================================================================================== */

function bool CheckRelevance(Actor Other)
{
	local KFDroppedPickup Weap;
	local CD_DroppedPickup CDDP;
	local KFAIController KFAIC;
	local KFWeapon KFW;
	local bool SuperRelevant;

	KFW = KFWeapon(Other);

	if(KFW != None && KFW.DroppedPickupClass != class'CD_DroppedPickup')
	{
		KFW.DroppedPickupClass = class'CD_DroppedPickup';
	}

	CDDP = CD_DroppedPickup(Other);
	
	if (CDDP != None)
	{
		CDDP.PickupTracker = PickupTracker;
	}

	SuperRelevant = super.CheckRelevance(Other);

	if ( !SuperRelevant )
	{
		// Early return if this is going to be destroyed anyway
		return SuperRelevant;
	}

	Weap = KFDroppedPickup(Other);

	if ( None != Weap )
	{
		OverrideWeaponLifespan(Weap);
		// nothing else to do on weapons, can return early
		return SuperRelevant;
	}

	KFAIC = KFAIController(Other);

	if ( None != KFAIC )
	{
		KFAIC.bCanTeleportCloser = ZedsTeleportCloserBool;
		`cdlog("Set bCanTeleportCloser="$ ZedsTeleportCloserBool $" on "$ KFAIC, bLogControlledDifficulty);
	}

	return SuperRelevant;
}

private function OverrideWeaponLifespan(KFDroppedPickup Weap)
{
	if ( 0 < WeaponTimeoutInt )
	{
		Weap.Lifespan = WeaponTimeoutInt;
	}
	else if ( 0 == WeaponTimeoutInt )
	{
		Weap.Lifespan = 1;
	}
}

/* --------------------------------------------------------------------------------------------------------------------------------- */

function SetGameSpeed( Float T )
{
	GameSpeed = FMax(T, 0.00001);
	WorldInfo.TimeDilation = GameSpeed;
	SetTimer(WorldInfo.TimeDilation, true);
	if ( ZTSpawnModeEnum == ZTSM_CLOCKWORK )
	{
		// Tweak the dilation (but do not reset)
		TuneSpawnManagerTimer();
	}
	else
	{
		// Restart the timer (but do not tweak the dilation)
		SetSpawnManagerTimer();
	}
}

function SetSpawnManagerTimer( const optional bool ForceReset = true )
{
	if ( ForceReset || !IsTimerActive('SpawnManagerWakeup') )
	{
		// Timer does not exist, set it
		`cdlog("Setting independent SpawnManagerWakeup timer (" $ SpawnPollFloat $")", bLogControlledDifficulty);
		SetTimer(SpawnPollFloat, true, 'SpawnManagerWakeup');
	}
}

function TuneSpawnManagerTimer()
{
	local float LocalDilation;
	local float SlowDivisor;

	LocalDilation = 1.f / WorldInfo.TimeDilation;
	if ( ZedTimeRemaining > 0.f && ZTSpawnSlowdownFloat > 1.f )
	{
		if ( ZedTimeRemaining < ZedTimeBlendOutTime )
		{
			// if zed time is running out, interpolate between [1.0, ZTSS] using the same lerp-alpha-factor that TickZedTime uses
			// When zed time first starts to fade, we will use a divisor slightly less than ZTSS
			// When zed time is on the last tick before it is completely over, we will use a divisor slightly more than 1.0
			// IOW, the divisor decreases towards one as zed time fades out
			// See TickZedTime in KFGameInfo for background
			SlowDivisor = Lerp(1.0, ZTSpawnSlowdownFloat, ZedTimeRemaining / ZedTimeBlendOutTime);
		}
		else
		{
			// if zed time is going strong, just use ZTSS
			SlowDivisor = ZTSpawnSlowdownFloat;
		}

		LocalDilation = LocalDilation / SlowDivisor;

		`cdlog("SpawnManagerWakeup's slowed clockwork timedilation: " $ LocalDilation $ " (ZTSS=" $ SlowDivisor $ ")", bLogControlledDifficulty);
	}
	else
	{
		`cdlog("SpawnManagerWakeup's realtime clockwork timedilation: " $ LocalDilation, bLogControlledDifficulty);
	}

	ModifyTimerTimeDilation('SpawnManagerWakeup', LocalDilation);
}

/*
 * We override this function to keep it from calling SpawnManager.Update().  CD
 * does that separately through the SpawnManagerWakeup() function.  This
 * separation supports the SpawnPoll setting.
 */
/* --------------------------------------------------------------------------------------------------------------------------------- */

event Timer()
{
	super(KFGameInfo).Timer();

	if ( GameConductor != none )
	{
		GameConductor.TimerUpdate();
	}
}

private function SpawnManagerWakeup()
{
	if ( SpawnManager != none )
	{
		SpawnManager.Update();
	}
}

/* --------------------------------------------------------------------------------------------------------------------------------- */

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

/* --------------------------------------------------------------------------------------------------------------------------------- */

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
}

function bool IsStrangeSetting()
{
	return (!AlbinoAlphasBool || !AlbinoCrawlersBool || !AlbinoGorefastsBool || !bDisableRobots || !bDisableSpawners ||
			FleshpoundRageSpawnsBool || StartingWeaponTierInt != 1 || !bStartwithFullAmmo || bStartwithFullArmor || !bStartwithFullGrenade ||
			FleshpoundHPFakesInt != 6 || ScrakeHPFakesInt != 6 || QuarterpoundHPFakesInt != 6 || TrashHPFakesInt != 6 || !ZedsTeleportCloserBool);
}

// Perk, skill, weapon, auth level
function SynchSettings(CD_PlayerController CDPC)
{
	local int i;

	CDPC.ResetSettings();
	CDPC.ReceiveAuthority(AuthorityHandler.GetAuthorityLevel(CDPC));
	CDPC.GetCDPRI().AuthorityLevel = AuthorityHandler.GetAuthorityLevel(CDPC);
	CDPC.ReceiveLevelRestriction(AuthorityHandler.bRequireLv25);

	for(i=0; i<AuthorityHandler.PerkRestrictions.length; i++)
		CDPC.ReceivePerkRestrictions(AuthorityHandler.PerkRestrictions[i]);

	for(i=0; i<AuthorityHandler.SkillRestrictions.length; i++)
		CDPC.ReceiveSkillRestrictions(AuthorityHandler.SkillRestrictions[i]);

	for(i=0; i<AuthorityHandler.WeaponRestrictions.length; i++)
		CDPC.ReceiveWeaponRestrictions(AuthorityHandler.WeaponRestrictions[i]);
}

function ResynchSettings()
{
	local CD_PlayerController CDPC;

    foreach WorldInfo.AllControllers(class'CD_PlayerController', CDPC)
    {
    	SynchSettings(CDPC);
    }
}

function SendAuthList(CD_PlayerController CDPC)
{
	local int i;

	for(i=0; i<AuthorityHandler.AuthorityInfo.length; i++)
	{
		CDPC.ReceiveAuthList(AuthorityHandler.AuthorityInfo[i]);
	}
	CDPC.CompleteAuthList();
}

/* --------------------------------------------------------------------------------------------------------------------------------- */

function Logout( Controller Exiting )
{
	if(PlayerController(Exiting) != none)
	{
		CD_GameReplicationInfo(MyKFGRI).LogoutCheck(PlayerController(Exiting));
		PickupTracker.LogoutCheck(PlayerController(Exiting).PlayerReplicationInfo);
	}

	super.Logout(Exiting);
}

/* --------------------------------------------------------------------------------------------------------------------------------- */

function BroadcastDeathMessage(Controller Killer, Controller Other, class<DamageType> damageType)
{
	local class killerPawnClass;

	if ( (Killer == Other) || (Killer == None) )
	{
		// suicide
		BroadcastLocalized(self, class'KFLocalMessage_Game', KMT_Suicide, None, Other.PlayerReplicationInfo);
	}
	else
	{
		if ( Killer.IsA('KFAIController') )
		{
			if ( Killer.Pawn != none )
			{
				killerPawnClass = class'CD_ZedNameUtils'.static.CheckClassRemap( Killer.Pawn.Class, "CD_Survival.BroadcastDeathMessage", bLogControlledDifficulty );
			}
			else
			{
				killerPawnClass = class'KFPawn_Human';
			}
			BroadcastLocalized(self, class'KFLocalMessage_Game', KMT_Killed, none, Other.PlayerReplicationInfo, killerPawnClass );
		}
		else
		{
			BroadcastLocalized(self, class'KFLocalMessage_PlayerKills', KMT_PlayerKillPlayer, Killer.PlayerReplicationInfo, Other.PlayerReplicationInfo);
		}
	}
}

/* --------------------------------------------------------------------------------------------------------------------------------- */

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

/* --------------------------------------------------------------------------------------------------------------------------------- */

function CreateDifficultyInfo(string Options)
{
	super.CreateDifficultyInfo(Options);

	// the preceding call should have initialized DifficultyInfo
	CDDI = CD_DifficultyInfo(DifficultyInfo);

	// log that we're done with the DI (note that CD_DifficultyInfo logs param values in its setters)
	`cdlog("CD_DifficultyInfo ready: " $ CDDI, bLogControlledDifficulty);
}

/* --------------------------------------------------------------------------------------------------------------------------------- */

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

	`cdlog("DoshCalc: ModifiedValue="$ ModifiedValue $" WaveSizeFakes="$ WaveSizeFakesInt $" FakesMode="$ FakesMode $
	       " RealPlayers="$ LocalNumPlayers $" computed MaxAIDoshDenominator="$ LocalMaxAIMod, bLogControlledDifficulty);
}

/* --------------------------------------------------------------------------------------------------------------------------------- */

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

/* --------------------------------------------------------------------------------------------------------------------------------- */

function SetMonsterDefaults( KFPawn_Monster P )
{
	local float HealthMod;
	local float HeadHealthMod;
	local float TotalSpeedMod, StartingSpeedMod;
	local float DamageMod;
	local int LivingPlayerCount;
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
	else if( P.IsABoss() )
	{
		DifficultyInfo.GetAIHealthModifier(P, BossDifficultyInt, LivingPlayerCount, HealthMod, HeadHealthMod);
		DamageMod = DifficultyInfo.GetAIDamageModifier(P, BossDifficultyInt, bOnePlayerAtStart);

		// scale damage
		P.DifficultyDamageMod = DamageMod;

		StartingSpeedMod = DifficultyInfo.GetAISpeedMod(P, 0);
		TotalSpeedMod = GameConductor.CurrentAIMovementSpeedMod * StartingSpeedMod;
	}
	else
	{
		DifficultyInfo.GetAIHealthModifier(P, GameDifficulty, LivingPlayerCount, HealthMod, HeadHealthMod);
		DamageMod = DifficultyInfo.GetAIDamageModifier(P, GameDifficulty, bOnePlayerAtStart);

		// scale damage
		P.DifficultyDamageMod = DamageMod;

		StartingSpeedMod = DifficultyInfo.GetAISpeedMod(P, GameDifficulty);
		TotalSpeedMod = GameConductor.CurrentAIMovementSpeedMod * StartingSpeedMod;
	}

	//`log("Start P.GroundSpeed = "$P.GroundSpeed$" GroundSpeedMod = "$GroundSpeedMod$" percent of default = "$(P.default.GroundSpeed * GroundSpeedMod)/P.default.GroundSpeed$" RandomSpeedMod= "$RandomSpeedMod);

	// scale movement speed
	P.GroundSpeed = P.default.GroundSpeed * TotalSpeedMod;
	P.SprintSpeed = P.default.SprintSpeed * TotalSpeedMod;

	// Store the difficulty adjusted ground speed to restore if we change it elsewhere
	P.NormalGroundSpeed = P.GroundSpeed;
	P.NormalSprintSpeed = P.SprintSpeed;
	P.InitialGroundSpeedModifier = StartingSpeedMod;

	//`log(P$" GroundSpeed = "$P.GroundSpeed$" P.NormalGroundSpeed = "$P.NormalGroundSpeed);

	// Scale health by difficulty
	P.Health = P.default.Health * HealthMod;
	if( P.default.HealthMax == 0 )
	{
	   	P.HealthMax = P.default.Health * HealthMod;
	}
	else
	{
	   	P.HealthMax = P.default.HealthMax * HealthMod;
	}

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
	//`log("HiddenSpeedMod: " @HiddenSpeedMod @" Final Hidden Speed = " @P.HiddenGroundSpeed, bLogAIDefaults);
	`log("SprintSpeedMod: " @TotalSpeedMod @" Final Sprint Speed = " @P.SprintSpeed, bLogAIDefaults);
	`log("DamageMod: " @DamageMod @" Final Melee Damage = " @P.MeleeAttackHelper.BaseDamage * DamageMod, bLogAIDefaults);
	//`log("bCanSprint: " @P.bCanSprint @ " from SprintChance: " @SprintChance, bLogAIDefaults);
}

/* --------------------------------------------------------------------------------------------------------------------------------- */

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

/* --------------------------------------------------------------------------------------------------------------------------------- */

function bool AllowWaveCheats(){ return true; }

/* --------------------------------------------------------------------------------------------------------------------------------- */

function RestartPlayer(Controller P)
{
	local KFPawn Player;
	local CD_PlayerReplicationInfo CDPRI;
	local int i;

	super.RestartPlayer(P);

	if(P.PlayerReplicationInfo != none)
	{
		CDPRI = CD_PlayerReplicationInfo(P.PlayerReplicationinfo);

		if(CDPRI != none && !CDPRI.bAllReceived)
		{
			for(i=0; i<SpawnCycleCatalog.SpawnCyclePresetList.length; i++)
				CDPRI.ReceiveCycle(i, SpawnCycleCatalog.SpawnCyclePresetList[i].GetName());

			CDPRI.bAllReceived = true;
		}
	}

	Player = KFPawn(P.Pawn);
	
	if (bStartwithFullAmmo) CD_FillAmmo(Player);
	if (bStartwithFullGrenade) CD_FillGrenade(Player);
	if (bStartwithFullArmor) CD_FillArmor(Player);
	if (StartingWeaponTierInt > 1 || StartingWeaponTierInt <= 4)
		ModifyStartingWeapons(Player, StartingWeaponTierInt);
}

private function ModifyStartingWeapons(KFPawn Player, int Tier)
{
	local Inventory Inv;
	local int Idx;

	if(Tier <= 1 || Tier > 4) return;

	Idx = 6;
	for(Inv=Player.InvManager.InventoryChain;Inv!=None;Inv=Inv.Inventory)
	{
		switch(Inv.ItemName)
		{
			case class'KFGameContent.KFWeap_AssaultRifle_AR15'.default.ItemName:
				Idx = 0;
				break;
			case class'KFGameContent.KFWeap_Shotgun_MB500'.default.ItemName:
				Idx = 1;
				break;
			case class'KFGameContent.KFWeap_Pistol_Medic'.default.ItemName:
				Idx = 2;
				break;
			case class'KFGameContent.KFWeap_Revolver_DualRem1858'.default.ItemName:
				Idx = 3;
				break;
			case class'KFGameContent.KFWeap_Rifle_Winchester1894'.default.ItemName:
				Idx = 4;
				break;
			case class'KFGameContent.KFWeap_SMG_MP7'.default.ItemName:
				Idx = 5;
				break;
			case class'KFGameContent.KFWeap_Blunt_Crovel'.default.ItemName:
				Idx = 6;
				break;
			case class'KFGameContent.KFWeap_GrenadeLauncher_HX25'.default.ItemName:
				Idx = 7;
				break;
			case class'KFGameContent.KFWeap_Flame_CaulkBurn'.default.ItemName:
				Idx = 8;
				break;			
		}
		if(Inv != None)
		{
			if(Idx != 6) Player.InvManager.RemoveFromInventory(Inv);
			Player.CreateInventory(default.StartingItems[(Idx*3) + Tier - 2]);
		}
		break;
	}
}

function CD_FillAmmo(KFPawn Player)
{
	local KFWeapon KFW;

	foreach Player.InvManager.InventoryActors(class'KFWeapon', KFW)
	{
		KFW.AmmoCount[0] = KFW.MagazineCapacity[0];
        KFW.AddAmmo(KFW.GetMaxAmmoAmount(0));
        KFW.AddSecondaryAmmo(KFW.MagazineCapacity[1]);
	}
}

function CD_FillGrenade(KFPawn Player)
{
	KFInventoryManager(Player.InvManager).AddGrenades(100);
}

function CD_FillArmor(KFPawn Player)
{
	KFPawn_Human(Player).GiveMaxArmor();
}

/* --------------------------------------------------------------------------------------------------------------------------------- */

//DropAllWeapons
function bool PreventDeath(Pawn Killed, Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	local KFWeapon TempWeapon;
	local KFPawn_Human KFP;
	
	KFP = KFPawn_Human(Killed);
	if (Role >= ROLE_Authority && KFP != None && KFP.InvManager != none && bDropAllWeapons)
		foreach KFP.InvManager.InventoryActors(class'KFWeapon', TempWeapon)
			if (TempWeapon != none && TempWeapon.bDropOnDeath && TempWeapon.CanThrow())
				KFP.TossInventory(TempWeapon);

	return Super.PreventDeath(Killed, Killer, damageType, HitLocation);
}

/* --------------------------------------------------------------------------------------------------------------------------------- */

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

/* --------------------------------------------------------------------------------------------------------------------------------- */

function bool PickupQuery(Pawn Other, class<Inventory> ItemClass, Actor Pickup)
{
	local CD_PlayerController CDPC;
	local CD_DroppedPickup DPUM;
	local KFWeapon Weap;
	local class<KFWeaponDefinition> WeapDefClass;

	if(Pickup == none) return false;

	DPUM = CD_DroppedPickup(Pickup);
	CDPC = CD_PlayerController(Other.Controller);

	// only for dropped weapon
	if (!DisablePickupMod && DPUM != none && KFWeapon(DPUM.Inventory) != none && CDPC != none)
	{
		Weap = KFWeapon(DPUM.Inventory);
		WeapDefClass = class<KFDamageType>(Weap.class.default.InstantHitDamageTypes[3]).default.WeaponDef;

		if( (MyKFGRI.bTraderIsOpen && CDPC.bDisableDual && IsGonnaBeDual(Weap, KFPawn(Other))) ||
			(MyKFGRI.bWaveIsActive && IsDisableLowAmmo(Other.PlayerReplicationInfo) && IsLowAmmo(DPUM)) ||
			(DPUM.OriginalOwner != Other.PlayerReplicationInfo && IsUnobtainableOthers(DPUM, Other.PlayerReplicationInfo, WeapDefClass, Other.Controller)) )
			return false;
	}

	//	then check Mutators Query
	return super.PickupQuery(Other, ItemClass, Pickup);
}

static function bool IsLowAmmo(CD_DroppedPickup DP)
{
	local KFWeapon KFW;
	local int MaxAmmo, CurAmmo;

	KFW = KFWeapon(DP.Inventory);
	if(KFW != none)
	{
		//	Ignore secondory ammo
		MaxAmmo = KFW.MagazineCapacity[0] + KFW.SpareAmmoCapacity[0];
		CurAmmo = KFW.AmmoCount[0] + KFW.SpareAmmoCount[0];
		if(MaxAmmo > 4*CurAmmo) // less than 25%
			return true;
	}
	return false;
}

static function bool IsGonnaBeDual(KFWeapon Weap, KFPawn Player)
{
	local KFWeapon KFW;

	if(KFWeap_PistolBase(Weap)!=none)
	{
		foreach Player.InvManager.InventoryActors(class'KFWeapon', KFW)
		{
			if(KFW.Class == Weap.Class || KFW.DualClass == Weap.Class)
				return true;
		}
	}

	return false;
}

function bool IsDisableLowAmmo(PlayerReplicationInfo PRI)
{
	local int index;

	index = PickupSettings.Find('PRI', PRI);

	if(index != INDEX_NONE)
		return PickupSettings[index].DisableLowAmmo;
	
	return false;
}

function bool IsUnobtainableOthers(CD_DroppedPickup CDDP, PlayerReplicationinfo PRI, class<KFWeaponDefinition> WeapDefClass, Controller PC)
{
	local bool bLocked;
	local bool bDisableOthers;
	local bool bAuthorized;
	local int index;

	index = PickupTracker.WeaponPickupRegistry.Find('KFDP', CDDP);
	bLocked = (index != INDEX_NONE && PickupTracker.WeaponPickupRegistry[index].bLocked);

	index = PickupSettings.Find('PRI', PRI);
	bDisableOthers = (index != INDEX_NONE && PickupSettings[index].DisableOthers);
	
	bAuthorized = CD_PlayerController(PC).IsAllowedWeapon(WeapDefClass, true, false, false);

	return (bLocked || bDisableOthers || !bAuthorized);
}

/* --------------------------------------------------------------------------------------------------------------------------------- */

function Killed( Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> damageType )
{
	local CD_PlayerController CDPC;
	local KFPawn_Monster KFPM;

	CDPC = CD_PlayerController(Killer);
	KFPM = KFPawn_Monster(KilledPawn);

//	Large Kill Sound & Ticker
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

//	Player Death Sound
	CDPC = CD_PlayerController(KilledPlayer);

	if(CDPC != none && MyKFGRI.bWaveIsActive && !MyKFGRI.bMatchIsOver && !CDPC.PlayerReplicationinfo.bWaitingPlayer)
	{
		foreach WorldInfo.AllControllers(class'CD_PlayerController', CDPC)
			CDPC.PlayPlayerDeathSound();
	}

	super.Killed(Killer, KilledPlayer, KilledPawn, damageType);
}

/* --------------------------------------------------------------------------------------------------------------------------------- */

function SetPlayerDefaults(Pawn PlayerPawn)
{
//	TraderHelper.CheckTraderList();

	super.SetPlayerDefaults(PlayerPawn);
}

/* --------------------------------------------------------------------------------------------------------------------------------- */



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
		SetTimer(2.f, false, 'DisplayBriefWaveStatsInChat');
	}

	function EndState( Name NextStateName )
	{
		Ext_KillZeds();
		super.EndState( NextStateName );
		ClearTimer('DecideDash');
		ModTraderDash(false);
	}

	function CloseTraderTimer()
	{
		if(bDisableBoss && WaveNum == WaveMax-1) WinMatch();
		else super.CloseTraderTimer();
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
		if (bShouldRecord) CDRecord();
		if (bDisableBoss)
		{
			DramaticEvent( 1, 6.f );
			WinMatch();
		}
	}
	else if(WinCondition == WEC_TeamWipedOut)
	{
		SaveFinalSettings();
		if(WaveNum == WaveMax)
			xMut.bBossDefeat = true;
	}

	super.WaveEnded( WinCondition );

	if ( ApplyStagedConfig( CDSettingChangeMessage, "Staged settings applied:" ) )
	{
		BroadcastCDEcho( CDSettingChangeMessage );
		RefleshWebInfo();
	}
	
	// AutoPause if it's enabled and game isn't over
	if (bAutoPause && WinCondition != WEC_TeamWipedOut && WinCondition != WEC_GameWon && !bUsedWinMatch)
	{
		BroadcastCDEcho( PauseTraderTime() );
	}
	// Prep Ready System if it's enabled and game isn't over
	if (bEnableReadySystem && WinCondition != WEC_TeamWipedOut && WinCondition != WEC_GameWon && !bUsedWinMatch)
	{
		UnreadyAllPlayers();
	}
}

function StartWave()
{
	local string CDSettingChangeMessage;

	RefleshWebInfo();

	if ( ApplyStagedConfig( CDSettingChangeMessage, "Staged settings applied:" ) )
	{
		BroadcastCDEcho( CDSettingChangeMessage );
	}

	ProgramSettingsForNextWave();

	// Restart the SpawnManager's wakeup timer.
	// This synchronizing effect is virtually unnoticeable when SpawnPoll is
	// low (say 1s), but very noticable when it is long (say 30s)
	SetSpawnManagerTimer();
	SetGameSpeed( WorldInfo.TimeDilation );
	
	super.StartWave();

	// If this is the first wave, print CD's settings
	if ( 1 == WaveNum || WaveMax-4 == WaveNum)
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

	if(bAutoCycleAnalyze && SpawnCycle != "unmodded")
	{
		if(WaveNum == 1 || WaveMax-4 == WaveNum) SetTimer(8.f, false, 'BriefCycleAnalisis');
		else SetTimer(1.f, false, 'BriefCycleAnalisis');
	}

	DeactivateSpawners(bDisableSpawners);
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

private function DisplayBriefWaveStatsInChat()
{
	local string s;
	local CD_PlayerController CDPC;

	s = CD_SpawnManager( SpawnManager ).GetWaveAverageSpawnrate();

	if(bWaveEndSummaries)
	{
		BroadcastCDEcho( "[CD - Wave " $ WaveNum $ " Recap]\n"$ s );
	}

	foreach WorldInfo.AllControllers(class'CD_PlayerController', CDPC)
	{
		CDPC.ReceiveWaveEndStats(StatsSystem.GetIndividualPlayerStats(CDPC));
	}
}

private function string PauseTraderTime()
{
	local name GameStateName;

	// Only process these commands in trader time
	GameStateName = GetStateName();
	if ( GameStateName != 'TraderOpen' )
	{
		return "Trader not open";
	}

	if ( MyKFGRI.bStopCountDown )
	{
		return "Trader already paused";
	}

	if ( WorldInfo.NetMode != NM_StandAlone && MyKFGRI.RemainingTime <= 5 )
	{
		return "Pausing requires at least 5 seconds remaining";
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

	return "Paused Trader";
}

private function string UnpauseTraderTime()
{
	local name GameStateName;

	// Only process these commands in trader time
	GameStateName = GetStateName();
	if ( GameStateName != 'TraderOpen' )
	{
		return "Trader not open";
	}

	if ( !MyKFGRI.bStopCountDown )
	{
		return "Trader not paused";
	}

	MyKFGRI.bStopCountDown = !MyKFGRI.bStopCountDown;

	MyKFGRI.RemainingTime = PausedRemainingTime;
	MyKFGRI.RemainingMinute = PausedRemainingMinute;
	SetTimer( MyKFGRI.RemainingTime, False, 'CloseTraderTimer' );
	`cdlog("Installed CloseTraderTimer at "$ MyKFGRI.RemainingTime $" (non-recurring)", bLogControlledDifficulty);

	`cdlog("MyKFGRI.RemainingTime: "$ MyKFGRI.RemainingTime, bLogControlledDifficulty);
	`cdlog("MyKFGRI.RemainingMinute: "$ MyKFGRI.RemainingMinute, bLogControlledDifficulty);
	`cdlog("MyKFGRI.bStopCountDown: "$ MyKFGRI.bStopCountDown, bLogControlledDifficulty);

	return "Unpaused Trader";
}

private function ReadyUp(Actor Sender)
{
	local KFPlayerController KFPC;
	local CD_PlayerController CDPC;
	local CD_PlayerReplicationInfo CDPRI;
	local name GameStateName;
	GameStateName = GetStateName();
	
	KFPC = KFPlayerController(Sender);
	CDPC = CD_PlayerController(Sender);

	if (CDPC != none)
	{
		CDPRI = CD_PlayerReplicationInfo(CDPC.PlayerReplicationInfo);

		if (!bEnableReadySystem)
		{
			BroadcastPersonalEcho( "The Ready system is currently disabled.", 'CDEcho', CDPC );
		}
		else
		{
			if ( GameStateName != 'TraderOpen' )
			{
				BroadcastPersonalEcho( "That command can only be used during trader time.", 'CDEcho', CDPC );
			}
			else if ( !MyKFGRI.bStopCountDown )
			{
				BroadcastPersonalEcho( "Trader not paused, You can't ready up.", 'CDEcho', CDPC );
			}
			else if (KFPC.PlayerReplicationInfo.bOnlySpectator)
			{
				BroadcastPersonalEcho( "Command not available to spectators.", 'CDEcho', CDPC );
			}
			else if (CDPRI.bIsReadyForNextWave)
			{
				BroadcastPersonalEcho( "We get it, you're ready.", 'CDEcho', CDPC );
			}
			else
			{
				CDPRI.bIsReadyForNextWave = true;
				CDPC.NotifyClientReadyState(true);
				NotifyFHUDReadyState(CDPC);
				BroadCastCDEcho( KFPC.PlayerReplicationInfo.PlayerName $ " has readied up." );
				if( bAllPlayersAreReady() )
				{
					BroadCastCDEcho( "All Players are ready. Unpausing Trader." );
					UnpauseTraderTime();
				}
			}
		}
	}
}

private function Unready(Actor Sender)
{
	local KFPlayerController KFPC;
	local CD_PlayerController CDPC;
	local CD_PlayerReplicationInfo CDPRI;
	local name GameStateName;
	GameStateName = GetStateName();

	KFPC = KFPlayerController(Sender);
	CDPC = CD_PlayerController(Sender);
	
	if(KFPC.PlayerReplicationInfo.bReadyToPlay && WaveNum == 0){
		KFPC.PlayerReplicationInfo.bReadyToPlay = false;
		BroadcastPersonalEcho("You are unready.", 'CDEcho', KFPC);
		return;
	}

	if (CDPC != none)
	{
		CDPRI = CD_PlayerReplicationInfo(CDPC.PlayerReplicationInfo);

		if (!bEnableReadySystem)
		{
			BroadcastPersonalEcho( "The Ready system is currently disabled.", 'CDEcho', CDPC );
		}
		else
		{
		
			if ( GameStateName != 'TraderOpen' )
			{
				BroadcastPersonalEcho( "That command can only be used during trader time.", 'CDEcho', CDPC );
			}
			else if (KFPC.PlayerReplicationInfo.bOnlySpectator)
			{
				BroadcastPersonalEcho( "Command not available to spectators.", 'CDEcho', CDPC );
			}
			else if (!CDPRI.bIsReadyForNextWave)
			{
				BroadcastPersonalEcho( "You were not ready to begin with.", 'CDEcho', CDPC  );
			}
			else if (WorldInfo.NetMode != NM_StandAlone && MyKFGRI.RemainingTime <= 5)
			{
				BroadcastPersonalEcho( "Unready requires at least 5 seconds remaining.", 'CDEcho', CDPC  );
			}
			else
			{
				CDPRI.bIsReadyForNextWave = false;
				CDPC.NotifyClientReadyState(false);
				NotifyFHUDReadyState(CDPC);
				BroadCastCDEcho( KFPC.PlayerReplicationInfo.PlayerName $ " has unreadied." );
				if ( !MyKFGRI.bStopCountDown )
				{
					PauseTraderTime();
					BroadCastCDEcho("Countdown AutoPaused.");
				}
			}
		}
	}
}

private function bool bAllPlayersAreReady()
{
    local KFPlayerController KFPC;
	local CD_PlayerController CDPC;
	local CD_PlayerReplicationInfo CDPRI;
    local int TotalPlayerCount;
    local int SpectatorCount;
    local int ReadyCount;
	
	TotalPlayerCount = 0;
	SpectatorCount = 0;
	ReadyCount = 0;
	
    foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
	{
        CDPC = CD_PlayerController(KFPC);
		
		if (CDPC != none)
		{
			CDPRI = CD_PlayerReplicationInfo(CDPC.PlayerReplicationInfo);

			if ( !KFPC.bIsPlayer || KFPC.bDemoOwner )
			{
				continue;
			}
			else
			{
				TotalPlayerCount++;
			}		       
			if ( KFPC.PlayerReplicationInfo.bOnlySpectator )
			{
				SpectatorCount++;
			}
			else if ( CDPRI.bIsReadyForNextWave && !KFPC.PlayerReplicationInfo.bOnlySpectator)
			{
				ReadyCount++;
			}
		}
    }
	
    if (TotalPlayerCount == ReadyCount + SpectatorCount)
	{
		return true;
    }
	else
	{
		return false;
	}
}

private function UnreadyAllPlayers()
{
	local KFPlayerController KFPC;
	local CD_PlayerController CDPC;
	local CD_PlayerReplicationInfo CDPRI;
	
	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
	{
		if ( KFPC.bIsPlayer && !KFPC.PlayerReplicationInfo.bOnlySpectator && !KFPC.bDemoOwner )
		{
			CDPC = CD_PlayerController(KFPC);
			if (CDPC != none)
			{
				CDPRI = CD_PlayerReplicationInfo(CDPC.PlayerReplicationInfo);
				CDPRI.bIsReadyForNextWave = false;
				CDPC.NotifyClientReadyState(false);
				NotifyFHUDReadyState(CDPC);
			}
		}
	}
	
//	BroadcastCDEcho( "Type \"!cdready\" or \"!cdr\" to ready up for the next wave." );
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

	for ( i = 0; i < AllSettings.Length; i++ )
	{
		TempString = AllSettings[i].CommitStagedChanges( PendingWaveNum );

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
	if ( FakesModeEnum == FPM_ADD )
	{
		return WaveSizeFakesInt + HumanPlayers;
	}
	else
	{
		return 0 < WaveSizeFakesInt ? WaveSizeFakesInt : 1;
	}
}

final function int GetEffectivePlayerCountForZedType( KFPawn_Monster P, int HumanPlayers )
{
	local int FakeValue, EffectiveNumPlayers;
	local string Zed;
	Zed = string(P.LocalizationKey);
	if ( P != none )
	{
		switch (Zed)
		{	
			// ---------- Bosses ----------

			case "KFPawn_ZedFleshpoundKing":
				FakeValue = BossHPFakesInt;
				break;

			case "KFPawn_ZedBloatKing":
				FakeValue = BossHPFakesInt;
				break;

			case "KFPawn_ZedPatriarch":
				FakeValue = BossHPFakesInt;
				break;

			case "KFPawn_ZedHans":
				FakeValue = BossHPFakesInt;
				break;
				
			case "KFPawn_ZedMatriarch":
				FakeValue = BossHPFakesInt;
				break;

			// -------- Large Zeds --------

			case "KFPawn_ZedFleshpound":
				FakeValue = FleshpoundHPFakesInt;
				break;

			case "KFPawn_ZedScrake":
				FakeValue = ScrakeHPFakesInt;
				break;

			case "KFPawn_ZedFleshpoundMini":
				FakeValue = QuarterPoundHPFakesInt;
				break;

			// -------- Trash Zeds --------
			
			default:
				FakeValue = TrashHPFakesInt;
		}
	}
	else
	{
		`cdlog ("Warning - GetEffectivePlayerCountForZedType() was called for none.");
	}

	if ( FakesModeEnum == FPM_ADD )
	{
		EffectiveNumPlayers = HumanPlayers + FakeValue;
	}
	else
	{
		EffectiveNumPlayers = FakeValue;
		if ( 0 >= EffectiveNumPlayers )
		{
			`cdlog("GetEffectivePlayerCount: Floored EffectivePlayerCount=1 for "$ P, bLogControlledDifficulty);
			EffectiveNumPlayers = 1;
		}
	}

	return EffectiveNumPlayers;
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

	for ( i = 0; i < DynamicSettings.Length; i++ )
	{
		s = DynamicSettings[i].RegulateValue( NWN );
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

private function Mutator GetFHUDCompatController()
{
	local Mutator M;

	foreach WorldInfo.DynamicActors( class'Mutator', M )
	{
		if ( PathName( M.class ) ~= "FriendlyHUD.FriendlyHUDCDCompatController")
		{
			return M;
		}
	}

	return None;
}

private function NotifyFHUDReadyState( CD_PlayerController CDPC )
{
	local Mutator FHUDCompatController;
	local CD_PlayerReplicationInfo CDPRI;

	FHUDCompatController = GetFHUDCompatController();
	CDPRI = CD_PlayerReplicationInfo(CDPC.PlayerReplicationInfo);
	
	if ( FHUDCompatController == None ) return;

	FHUDCompatController.Mutate("FHUDSetCDStateReady" @ CDPRI.PlayerID @ CDPRI.bIsReadyForNextWave, None);
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
	local string MsgHead, MsgBody;
	local array<String> splitbuf;

	super.Broadcast(Sender, Msg, Type);

	if ( Type == 'Say')
	{
		// Crappy workaround for the inability to pass Actor Sender with the rest of the commands due to casting to string. (Substantial rewrite required for this)
		Msg = Locs(Msg);
		ParseStringIntoArray(Msg,splitbuf," ",true);
		if(splitbuf.length < 2) splitbuf.length = 2;
		MsgHead = splitbuf[0];
		MsgBody = splitbuf[1];

		if (Msg == "!cdready"||Msg == "!cdr")
			ReadyUp(Sender);

		else if ( Left( Msg, 8 ) == "!cdstats" || MsgHead == "!cds")
			BroadcastCDEcho(StatsSystem.CDStatsCommand(Msg));
		
		else if (Msg == "!cdunready" || Msg == "!cdur")
			Unready(Sender);
		
		else if (Msg == "!cdmystats" || Msg == "!cdms")
			CD_PlayerController(Sender).ReceiveStats(StatsSystem.GetIndividualPlayerStats(KFPlayerController(Sender)));
		
		else if ( Left( Msg, 13 ) == "!cdallhpfakes" || Left( Msg, 7 ) == "!cdahpf" )
			SetAllHPFakes(Sender, Msg);
		
		else if (Msg == "!ot" || Msg == "!cdot")
		{
			if(GetStateName() == 'TraderOpen') KFPlayerController(Sender).OpenTraderMenu();
		}
		
		else if (MsgHead == "!cdsz" || MsgHead == "!cdspawnzed")
		{
			if(GetStateName() == 'TraderOpen') CD_SpawnZed(MsgBody, KFPlayerController(Sender), 200.f);
			else BroadcastCDEcho("Available only during trader time");
		}

		else if (MsgHead == "!cdsa" || MsgHead == "!cdspawnai")
		{
			if(GetStateName() == 'TraderOpen') CD_SpawnAI(MsgBody, KFPlayerController(Sender), 500.f);
			else BroadcastCDEcho("Available only during trader time");
		}
		
		else if (MsgHead == "!rpwinfo")
			LogRPWInfo(MsgBody, CD_PlayerController(Sender));
				
		else if (Msg == "!cdkz" || Msg == "!cdkillzeds")
		{
			if(GetStateName() == 'TraderOpen') Ext_KillZeds();
			else HandleKillZeds(CD_PlayerController(Sender));
		}

		else if (MsgHead == "!cdsca" || MsgHead == "!cdspawncycleanalyze")
			SpawnCycleAnalyzer.TrySCA(Msg);

		else if (MsgHead == "!cdhelp" || MsgHead == "!cdh")
			DisplayCDHelp(MsgBody, CD_PlayerController(Sender));
		/*
		else if (Msg == "!cdsr" || Msg == "!cdswitchrole")
			CD_PlayerController(Sender).ToggleRole();
		*/
		else if (Msg == "!cdst" && IsAdmin(KFPlayerController(Sender)))
		{
			if(!MyKFGRI.bTraderIsOpen)
				BroadcastCDEcho("Only available during trader time!");
			else
			{
				SkipTrader(1);
				BroadcastCDEcho("Admin skips trader!");
			}
		}

		else if (MsgHead == "!cdfs" || MsgHead == "!cdfillspares")
			CD_BuyAmmo(MsgBody, KFPlayerController(Sender));

		else if (Msg == "!tdd" || Msg == "!toggledisabledual")
		{
			CD_PlayerController(Sender).bDisableDual = !CD_PlayerController(Sender).bDisableDual;
			BroadcastPersonalEcho("DisableDual=" $ string(CD_PlayerController(Sender).bDisableDual), 'CDEcho', KFPlayerController(Sender));
		}

		else if (MsgHead == "!cddpm" && IsAdmin(KFPlayerController(Sender)))
		{
			if(MsgBody != "")
			{
				DisablePickupMod = bool(MsgBody);
				SaveConfig();
			}
			BroadcastCDEcho("[Admin] DisablePickupMod=" $ string(DisablePickupMod));
		}

		else if (Msg == "!cddosh")
			GetDoshinegun(KFPlayerController(Sender));

		else if (Msg == "!cdm" || Msg == "!cdmenu")
			CD_PlayerController(Sender).OpenClientMenu();

		else if (Msg == "!cdmv")
			xMut.ShowMapVote(CD_PlayerController(Sender));

		else if ((Msg == "!cdmr" || Msg == "!mr" || Msg == "!matchresult") &&
				 MyKFGRI.bMatchIsOver)
			CD_PlayerController(Sender).ClientOpenResultMenu('TeamAward');

		else if (Msg == "!cdadminmenu" && KFPlayerController(Sender).PlayerReplicationinfo.bAdmin)
			CD_PlayerController(Sender).OpenAdminMenu();

		else if (MsgHead == "!cdmuc" || MsgHead == "!cdmaxupgradecount")
			HandleMaxUpgradeCount(CD_PlayerController(Sender), MsgBody);

		else if (Msg == "!cdpi")
			DisplayPlayerInfo();

		else if (Msg == "!cdrs")
			ResetSettings();

		//	O MA KE
		else if (Msg == "!ddzte") BroadcastCDEcho("Do not desturb Zedtime Extention!\nZedTime延長を邪魔しないでください！");
	//	else if (Msg == "!dhmu") BroadcastCDEcho("It is not allowed to hurry mates up\n急かす行為は許可されていません");
	//	else if (Msg == "!eianw") BroadcastCDEcho("Excessive instructions are never welcome.");
	
		else if (Msg == "!cdholick") BroadcastCDEcho( Rand(5) == 0 ? "KFして仕事サボります" : "Rhinoです" );
		else if (Msg == "!cdrice") BroadcastCDEcho( Rand(10) == 0 ? "タバコさんライス\nゆっくりしような。" : "tabako san rice");
		else if (Msg == "!cdhage") BroadcastCDEcho(Rand(2) == 0 ? "Hair=false" : "DisableHair=true");
		else if (Msg == "!cdmika") BroadcastCDEcho( Rand(10) != 0 ? "miruna" : "SONY CORPORATION");
		else if (Msg == "!cdsome") BroadcastCDEcho( Rand(2) == 0 ? "そうね。" : "そうよ。");
		else if (Msg == "!cdomakusa" || Msg == "!cdomaekusai") BroadcastCDEcho( Rand(10) == 0 ? "CompoundBow?めっちゃ倒せるじゃん" : "Zedtime中はご飯食べられるよ");
		else if (Msg == "!cdmia") PlayMeowSound();
		else if (Msg == "!cdasp" || Left(Msg, 8) == "!cdasapi") BroadcastCDEcho( Rand(100) == 0 ? "あさぴ鯖の運営に毎月3850円かかっています" : "KF2はおもちゃ" );
		else if (Msg == "!cdsu") BroadcastCDEcho( Rand(100) == 0 ? "suことsujigamiは管理者の一番古いフレンドです。" : "Poop shooter!" );
		else if (Msg == "!cdsuimuf") BroadcastCDEcho(Rand(5) == 0 ? "BFはKF" : "マグナムを信じるんだよ");
		else if (Msg == "!cdkabochan") BroadcastCDEcho(Rand(2) == 0 ? "たくちゃんです" : "だれかさんです");
		else if (Left(Msg, 8) == "!cdgraph") BroadcastCDEcho(Rand(5) != 0 ? "止まるんじゃねぇぞ" : "Game=CD_Zedternal");
		else if (Msg == "!cduoka") BroadcastCDEcho(Rand(50) == 0 ? "今回は延長成功です。" : "200%の確率で 延長失敗です。");
		else if (Msg == "!cdnam") BroadcastCDEcho("nam_pro_v5は神サイクル");
		else if (Msg == "!cdgom") BroadcastCDEcho("人間（くま）");
		else if (Msg == "!cdnight" || Msg == "!cdknight" || Msg == "!cdnaito") BroadcastCDEcho("ナイト内藤naitonightknight");
		else if (Msg == "!cdog-so" || Msg == "!cdogso") BroadcastCDEcho("このコマンドは内容募集中です");
		else if (Msg == "!cdshiva") BroadcastCDEcho("魅力的ですね");
		else if (Msg == "!cdfatcat") BroadcastCDEcho("美の骨頂");
		else if (Msg == "!cdpon") BroadcastCDEcho("このコマンドは内容募集中です");
		else if (Msg == "!cdnew") BroadcastCDEcho("このゲームにメディックは要らないよ。");
		else if (Msg == "!cdsoysoa") BroadcastCDEcho("Vinusnana");
		else if (Msg == "!cdvinusnana") BroadcastCDEcho("Soysoa");
		else if (Msg == "!cdmako") BroadcastCDEcho("イケメンですね～");
		else if (Msg == "!cdongsimi" || Msg == "!cdongshimi")
		{
			BroadcastCDEcho("뽀얗고 동그란 넌 나의 옹심이");
			if(Rand(10) == 0) CD_PlayerController(Sender).ClientOpenURL("https://youtu.be/Rlb_gYjSASY");
		}

		else if ( Left(Msg, 9) == "hagepippi" ) BroadcastHage();		
		else if (Msg == "!monyo") BroadcastCDEcho("もにょもにょもにょ～！");
		else if (Msg == "!mocho") BroadcastCDEcho("もちょもちょ");
		else if (Msg == "!cdmagnum") BroadcastCDEcho("マグナムを信じろ");
		else if (Msg == "!cdfal") BroadcastCDEcho("FALしか勝たん");
		else if (Msg == "!cdrhino")	BroadcastCDEcho("HoLickです");
		else if (Msg == "!cddeserteagle") BroadcastCDEcho("武器強化はチート");
		else if (Msg == "!cdtopokki") BroadcastCDEcho("나는 떡볶이를 좋아한다");
		else if (Msg == "!cdztmy") BroadcastCDEcho("永遠是深夜有多好");
		else if (Msg == "!cdtantan") BroadcastCDEcho("我要吃丹参面");
		else if (Msg == "!cdjpn") BroadcastCDEcho("I'm Japanese so can't understand English.");
		else if (Msg == "!cdnuked") BroadcastCDEcho("ここが実家。");
		else if (Msg == "!cdamb") BroadcastCDEcho("ALL MY BAD");
		else if (Msg == "!cdayg") BroadcastCDEcho("ALL YOUR GOOD");
		else if (Msg == "!cdsry") BroadcastCDEcho("Sony");
		else if (Msg == "!cdsony") BroadcastCDEcho("Sorry");
		else if (Msg == "!cdoc") BroadcastCDEcho("惜しい！");
		else if (Msg == "!cdikeru") BroadcastCDEcho("ikeru");
		else if (Msg == "!cddrunk") BroadcastCDEcho("下手なのではなく、酔ってるだけです。");
		else if (Msg == "!cdzt") BroadcastCDEcho("これは延びる");
		else if (Msg == "!cdrun") BroadcastCDEcho("RUNは負け");
		else if (Msg == "!cdha?") BroadcastCDEcho("は？");
		else if (Msg == "!cddebug") BroadcastCDEcho("Version:"$ReleaseVersion$"."$DebugVersion);

		else
		{
			ChatCommander.RunCDChatCommandIfAuthorized( Sender, Msg );
			RefleshWebInfo();
		}
	}
}

/* --------------------------------------------------------------------------------------------------------------------------------- */

function SetAllHPFakes(Actor Sender, string Msg)
{
	local array<string> params;
	local string CommandString;
	
	ParseStringIntoArray( Msg, params, " ", true );
	
	//CommandString = "!cdbhpf " $ params[1];
	//ChatCommander.RunCDChatCommandIfAuthorized( Sender, CommandString );
	CommandString = "!cdfphpf " $ params[1];
	ChatCommander.RunCDChatCommandIfAuthorized( Sender, CommandString );
	CommandString = "!cdqphpf " $ params[1];
	ChatCommander.RunCDChatCommandIfAuthorized( Sender, CommandString );
	CommandString = "!cdschpf " $ params[1];
	ChatCommander.RunCDChatCommandIfAuthorized( Sender, CommandString );
	CommandString = "!cdthpf " $ params[1];
	ChatCommander.RunCDChatCommandIfAuthorized( Sender, CommandString );
}

/* --------------------------------------------------------------------------------------------------------------------------------- */

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

function BroadcastHage()
{
	switch(Rand(3))
	{
		case 0:
			BroadcastCDEcho("ツルツルぴっぴ！");
			break;
		case 1:
			BroadcastCDEcho("テカテカぴっぴ！");
			break;
		case 2:
			BroadcastCDEcho("ツルテカぴっぴ！");
			break;
	}
}

function LogRPWInfo(string param, CD_PlayerController CDPC)
{
	local string Result;
	local int i;

	Result = "";

	if (param == "perk" || param == "")
	{
		Result $= "[Perk Restrictions]\n";
		for(i=0; i<AuthorityHandler.PerkRestrictions.length; i++)
		{
			if(AuthorityHandler.PerkRestrictions[i].RequiredLevel > 0)
				Result $= Mid(string(AuthorityHandler.PerkRestrictions[i].Perk), 7) $ ": only available for authorized users.\n";
		}
	}
	if (param == "skill" || param == "")
	{
		Result $= "[Banned Skills]\n";
		for(i=0; i<AuthorityHandler.SkillRestrictions.length; i++)
		{
			Result $= Mid(string(AuthorityHandler.SkillRestrictions[i].Perk), 7) $ ": ";
			Result $= CDPC.SkillBanMessage(AuthorityHandler.SkillRestrictions[i].Perk, AuthorityHandler.SkillRestrictions[i].Skill) $ "\n";
		}
	}
	if (param == "level" || param == "")
	{
		Result $= "[Level Restrictions]\n";
		Result $= (AuthorityHandler.bRequireLv25) ? "Level 25 is required" : "No restrictions";
	}
	if (param == "weapon" || param == "")
	{
		Result $= "\n[Weapon Restrictions]\nAll weapons seen in trader are available.\nMax Upgrade Count: " $ string(MaxUpgrade);
	}

	BroadcastRPWEcho(Result);
}


function DisplayCycleAnalisis()
{
	SpawnCycleAnalyzer.TrySCA("!cdsca wave" $ string(WaveNum), false);
}

function BriefCycleAnalisis()
{
	SpawnCycleAnalyzer.TrySCA("!cdsca wave" $ string(WaveNum), true);
}

function DisplayCDHelp(string param, CD_PlayerController CDPC)
{
	if(param == "ini")
	{
		BroadcastCDEcho("Fixing BugSplats in the CD game");
		BroadcastCDEcho("1. Go to the following directory in your documents:\n" $
						"  C:\Documents\My Games\KillingFloor2\KFGame\Config\n" $
						"2. Find the KFEngine file in the Config folder and open it using Notepad\n" $
						"3. Find the following lines in the KFEngine file:\n" $
						"  MaxObjectsNotConsideredByGC=179220\n" $
						"  SizeOfPermanentObjectPool=179220\n" $
						"4. Change the values of these parameters to:\n" $
						"  MaxObjectsNotConsideredByGC=33476\n" $
						"  SizeOfPermanentObjectPool=0\n" $
						"5. Save the KFEngine file and enjoy.");
	}
	else if (param == "cdr")
	{
		BroadcastCDEcho( "Type \"!cdr\" to ready up." );
	}
	else
		CDPC.ClientOpenURL(HelpURL);
}

private function string GetCDVersionChatString()
{
	return  "Build=Combined Edition\nBased=Blackout Edition\nAuthor=あさぴっぴ1020\nDate=";
}

function DisplayPlayerInfo()
{
	local array<PlayerInvInfo> PInfo;
	local KFPlayerController KFPC;
	local Inventory Inv;
	local int i, j, k;
	local bool bHide;
	local string Result;

	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
	{
		if(KFPC.PlayerReplicationInfo.bOnlySpectator)
			continue;

		PInfo.Add(1);
		i = PInfo.length - 1;
		PInfo[i].PRI = KFPC.PlayerReplicationInfo;
		PInfo[i].Perk = KFPC.GetPerk().GetPerkClass();
		PInfo[i].Skill = "";

		for(j=0; j<10; j+=2)
			PInfo[i].Skill $= (KFPC.GetPerk().PerkSkills[j].bActive) ? "L" : "R";
		
		for(Inv=KFPC.Pawn.InvManager.InventoryChain; Inv!=None; Inv=Inv.Inventory)
		{
			switch(Inv.ItemName)
			{
				case class'KFGameContent.KFWeap_Healer_Syringe'.default.ItemName:
				case class'KFGameContent.KFWeap_Knife_Berserker'.default.ItemName:
				case class'KFGameContent.KFWeap_Knife_Commando'.default.ItemName:
				case class'KFGameContent.KFWeap_Knife_Demolitionist'.default.ItemName:
				case class'KFGameContent.KFWeap_Knife_FieldMedic'.default.ItemName:
				case class'KFGameContent.KFWeap_Knife_Firebug'.default.ItemName:
				case class'KFGameContent.KFWeap_Knife_Gunslinger'.default.ItemName:
				case class'KFGameContent.KFWeap_Knife_Sharpshooter'.default.ItemName:
				case class'KFGameContent.KFWeap_Knife_Support'.default.ItemName:
				case class'KFGameContent.KFWeap_Knife_Survivalist'.default.ItemName:
				case class'KFGameContent.KFWeap_Knife_SWAT'.default.ItemName:
				case class'KFGameContent.KFWeap_Pistol_9mm'.default.ItemName:
				case class'KFGameContent.KFWeap_Welder'.default.ItemName:
					bHide = true;
			}

			if(!bHide)
			{
				if(Inv.ItemName != "")
				{
					PInfo[i].Inv.Add(1);
					j = PInfo[i].Inv.length - 1;
					PInfo[i].Inv[j].WeapName = Inv.ItemName;
					PInfo[i].Inv[j].UpgradeCount = KFWeapon(Inv).CurrentWeaponUpgradeIndex;
					PInfo[i].Inv[j].WeapCount = 1;
				}
			}
			else
				bHide = false;
		}
	}

	for(i=0; i<PickupTracker.WeaponPickupRegistry.length; i++)
	{
		j = PInfo.Find('PRI', PickupTracker.WeaponPickupRegistry[i].OrigOwnerPRI);

		if(j == INDEX_NONE)
			continue;

		k = PInfo[j].Inv.Find('WeapName', PickupTracker.WeaponPickupRegistry[i].KFWClass.default.ItemName);

		if(k == INDEX_NONE)
		{
			if(PickupTracker.WeaponPickupRegistry[i].KFWClass.default.ItemName == "")
				continue;

			PInfo[j].Inv.Add(1);
			k = PInfo[j].Inv.length - 1;
			PInfo[j].Inv[k].WeapName = PickupTracker.WeaponPickupRegistry[i].KFWClass.default.ItemName;
			PInfo[j].Inv[k].UpgradeCount = KFWeapon(PickupTracker.WeaponPickupRegistry[i].KFDP.Inventory).CurrentWeaponUpgradeIndex;
			PInfo[j].Inv[k].WeapCount = 1;
		}

		else
		{
			PInfo[j].Inv[k].UpgradeCount = Max(PInfo[j].Inv[k].UpgradeCount, KFWeapon(PickupTracker.WeaponPickupRegistry[i].KFDP.Inventory).CurrentWeaponUpgradeIndex);
			PInfo[j].Inv[k].WeapCount ++;
		}
	}

	

	for(i=0; i<PInfo.length; i++)
	{
		Result $= "\n\n" $ PInfo[i].PRI.PlayerName @ "|" @  Mid(string(PInfo[i].Perk), 7) @ "|" @ PInfo[i].Skill;

		for(j=0; j<PInfo[i].Inv.length; j++)
		{
			Result $= "\n" $ string(PInfo[i].Inv[j].WeapCount) @ PInfo[i].Inv[j].WeapName;

			if(PInfo[i].Inv[j].UpgradeCount > 0)
				Result $= " (+" $ string(PInfo[i].Inv[j].UpgradeCount) $ ")";
		}
	}

	BroadcastCDEcho("(See Console)");
	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
		CD_PlayerController(KFPC).PrintConsole(Result);
}

function ResetSettings()
{
	if(!AlbinoAlphasBool) ChatCommander.RunCDChatCommandIfAuthorized(none, "!cdaa 1");
	if(!AlbinoCrawlersBool) ChatCommander.RunCDChatCommandIfAuthorized(none, "!cdac 1");
	if(!AlbinoGorefastsBool) ChatCommander.RunCDChatCommandIfAuthorized(none, "!cdag 1");
	if(!bDisableRobots) ChatCommander.RunCDChatCommandIfAuthorized(none, "!cddr 1");
	if(!bDisableSpawners) ChatCommander.RunCDChatCommandIfAuthorized(none, "!cdds 1");
	if(FleshpoundRageSpawnsBool) ChatCommander.RunCDChatCommandIfAuthorized(none, "!cdfprs 0");
	if(StartingWeaponTierInt != 1) ChatCommander.RunCDChatCommandIfAuthorized(none, "!cdswt 1");
	if(!bStartwithFullAmmo) ChatCommander.RunCDChatCommandIfAuthorized(none, "!cdswfa 1");
	if(bStartwithFullArmor) ChatCommander.RunCDChatCommandIfAuthorized(none, "!cdswfar 0");
	if(!bStartwithFullGrenade) ChatCommander.RunCDChatCommandIfAuthorized(none, "!cdswfg 1");
	if(FleshpoundHPFakesInt != 6) ChatCommander.RunCDChatCommandIfAuthorized(none, "!cdfphpf 6");
	if(ScrakeHPFakesInt != 6) ChatCommander.RunCDChatCommandIfAuthorized(none, "!cdschpf 6");
	if(QuarterpoundHPFakesInt != 6) ChatCommander.RunCDChatCommandIfAuthorized(none, "!cdqphpf 6");
	if(TrashHPFakesInt != 6) ChatCommander.RunCDChatCommandIfAuthorized(none, "!cdthpf 6");
	if(!ZedsTeleportCloserBool) ChatCommander.RunCDChatCommandIfAuthorized(none, "!cdztc 1");
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

	wis = GetWaveInfosForConsoleCommand( CycleName, WaveInfosToSummarize );

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
			GameInfo_CDCP.Print( "Projecting wave summaries for "$AssumedPlayerCount$" player(s) in current game length...", false );
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

	class'CD_WaveInfoUtils'.static.PrintSpawnSummaries( WaveInfosToSummarize, AssumedPlayerCount,
		GameInfo_CDCP, GameLength, CDDI, DWS );

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

function DecideDash(){ ModTraderDash(GetStateName() == 'TraderOpen' && bTraderDash); }

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
	local bool albino, rage;

	albino = SpawnCycleAnalyzer.HandleZedMod(ZedName, "*");
	rage = (!albino && SpawnCycleAnalyzer.HandleZedMod(ZedName, "!"));
	SpawnClass = class'CD_ZedNameUtils'.static.GetZedClassFromName(ZedName, albino, rage);

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

	Result = WorldInfo.GetMapName( true ) $ "|" $
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
	local int i, value, multiplier;

	IDHexStr = class'OnlineSubsystem'.static.UniqueNetIdToString(ID);
	IDHexStr = Right(IDHexStr, 8);
	IDHexStr = Locs(IDHexStr);

	multiplier = 1;
	value = 0;

	for ( i = Len(IDHexStr) - 1 ; 0 <= i ; i-- )
	{
		switch (Mid(IDHexStr, i, 1))
		{
		case "0": break;
		case "1": value += multiplier; break;
		case "2": value += (multiplier * 2);  break;
		case "3": value += (multiplier * 3);  break;
		case "4": value += (multiplier * 4);  break;
		case "5": value += (multiplier * 5);  break;
		case "6": value += (multiplier * 6);  break;
		case "7": value += (multiplier * 7);  break;
		case "8": value += (multiplier * 8);  break;
		case "9": value += (multiplier * 9);  break;
		case "a": value += (multiplier * 10); break;
		case "b": value += (multiplier * 11); break;
		case "c": value += (multiplier * 12); break;
		case "d": value += (multiplier * 13); break;
		case "e": value += (multiplier * 14); break;
		case "f": value += (multiplier * 15); break;
		default: return "";
		}

		multiplier *= 16; 
	}

	return string(value);
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
	if(FakesModeEnum == FPM_ADD) Result $= "FakesMode=add_with_humans?";
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
		case class'KFPerk_Berserker':     return "Zerk";
		case class'KFPerk_Commando':      return "Com";
		case class'KFPerk_Support':       return "Sup";
		case class'KFPerk_FieldMedic':    return "Med";
		case class'KFPerk_Firebug':	   	  return "Bug";
		case class'KFPerk_Demolitionist': return "Demo";
		case class'KFPerk_Gunslinger':	  return "GS";
		case class'KFPerk_Sharpshooter':  return "SS";
		case class'KFPerk_Swat':		  return "Swat";
		case class'KFPerk_Survivalist':	  return "Surv";
		return "unknown";
	}
}

function SetShouldRecord()
{
	bShouldRecord = ShouldRecord();
}

function bool ShouldRecord()
{
	local int PlayerCount;

	if( ScrakeHPFakesInt < 6 ||	FleshpoundHPFakesInt < 6 ||	QuarterPoundHPFakesInt < 6 ||
		SpawnPollFloat > 1.f || SpawnModFloat > 0.f || (CohortSizeInt < 4 && CohortSizeInt > 0) )
		return false;

	PlayerCount = GetLivingPlayerCount();

	switch(PlayerCount)
	{
		case 1:
			return MaxMonstersInt >= 16 && WaveSizeFakesInt >= 2;

		case 2:
			return MaxMonstersInt >= 24 && WaveSizeFakesInt >= 3;

		case 3:
			return MaxMonstersInt >= 32 && WaveSizeFakesInt >= 5;

		case 4:
			return MaxMonstersInt >= 36 && WaveSizeFakesInt >= 6;

		case 5:
			return MaxMonstersInt >= 40 && WaveSizeFakesInt >= 8;

		case 6:
			return MaxMonstersInt >= 44 && WaveSizeFakesInt >= 9;

		default:
			return true;
	}
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
	local int i, failed, payment;

	if(!MyKFGRI.bTraderIsOpen)
	{
		BroadcastCDEcho("Trader is not open!");
		return;
	}

	if(PickupTracker != none)
	{
		//	for commando to fill fal
		if(Value == "fal")
		{
			//	only for commando
			if(KFPC.GetPerk().GetPerkClass() != class'KFPerk_Commando')
			{
				BroadcastUMEcho("ERROR: You are not Commando!");
				return;
			}

			//	Dropped Weapons
			for(i=0; i<PickupTracker.WeaponPickupRegistry.length; i++)
			{
				//	choose FAL
				if(PickupTracker.WeaponPickupRegistry[i].KFWClass == class'KFWeap_AssaultRifle_FNFal')
				{
					Pickup = PickupTracker.WeaponPickupRegistry[i].KFDP;
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

		if ( failed > 0 ) BroadcastPersonalEcho("Not enough dosh!\nFailed count:" @ string(failed), 'UMEcho', KFPC);
		else if ( payment == 0 ) CD_PlayerController(KFPC).ShowMessageBar('Game', "There is nothing to fill.");
		else if ( Value == "fal" ) BroadcastCDEcho("Commando bought ammo for all fal.");
		else CD_PlayerController(KFPC).ShowMessageBar('Game', "Successfully filled ammo.");
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

function DisableDispawnMine()
{
	local KFProj_Mine_Reconstructor Mine;

	foreach DynamicActors( class'KFProj_Mine_Reconstructor', Mine )
	{
		if(Mine.Lifespan != 2147483647)
			Mine.Lifespan = 2147483647;
	}
}

//	Reflesh → Refresh... :o
function RefleshWebInfo()
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
			KFPRI.Score += KFWeapon(Inv).Ammocount[0]*20;
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
			KFPC.ShowConnectionProgressPopup(PMT_AdminMessage,"Dosh shortage", "Required 400 Dosh");
		}
	}
	else
	{
		BroadcastCDEcho("This command is unavailable now!");
	}
}

function PlayMeowSound()
{
	local KFPlayerController KFPC;

	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
		KFPC.ClientPlaySound( SoundCue'CombinedSound.MeowSound' );

	if(Rand(100) == 0) BroadcastCDEcho("にゃ～ん♡");
}

function ShowResultMenu()
{
	local CD_PlayerController CDPC;

	foreach WorldInfo.AllControllers(class'CD_PlayerController', CDPC)
		CDPC.ClientOpenResultMenu('TeamAward');
}

function HandleMaxUpgradeCount(CD_PlayerController CDPC, string Msg)
{
	if(Msg == "")
		BroadcastCDEcho("MaxUpgradeCount = " $ string(CDGRI.MaxUpgrade));

	else if(CD_PlayerReplicationInfo(CDPC.PlayerReplicationInfo).AuthorityLevel < 4)
	{
		BroadcastUMEcho("You can't change max upgrade count.\n" $
						"MaxUpgradeCount = " $ string(CDGRI.MaxUpgrade));
	}
	else
	{
		SetMaxUpgrade(int(Msg));		
	}
}

function SetMaxUpgrade(int Count)
{
	CDGRI.MaxUpgrade = Max(0, Count);
	MaxUpgrade = CDGRI.MaxUpgrade;
	SaveConfig();
	BroadcastCDEcho("MaxUpgradeCount=" $ string(CDGRI.MaxUpgrade));
}

function HandleKillZeds(CD_PlayerController CDPC)
{
	if(CD_PlayerReplicationInfo(CDPC.PlayerReplicationInfo).AuthorityLevel < 2)
		BroadcastCDEcho("You are not authorized to kill zeds.");

	else if(MyKFGRI.AIRemaining <= 3)
	{
		if (MyKFGRI.bWaveIsActive)
			EndCurrentWave();
		else
			Ext_KillZeds();
	}

	else
	{
		BroadcastCDEcho("Not available now");
	}
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
		SynchSettings(CDPC);
		CDPC.ClientMessage("Saved.\n" $ ID, 'UMEcho');
	}

	else if(IsAdmin(CDPC))
	{
		CDPC.PlayerReplicationinfo.bAdmin = true;
		CDPC.ClientMessage("Yes, you are an admin.", 'UMEcho');
	}

	else
		CDPC.ClientMessage("No, you are not an admin.", 'UMEcho');
}

function ReceivePickupInfo(CD_PlayerController CDPC, bool bDisableOthers, bool bDropLocked, bool bDisableLow)
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
		PS.PRI = PRI;
		PickupSettings.AddItem(PS);
	}
	else
	{
		PickupSettings[index].DisableOthers = bDisableOthers;
		PickupSettings[index].DropLocked = bDropLocked;
		PickupSettings[index].DisableLowAmmo = bDisableLow;
	}
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

exec function ShowCycleOrder(string CycleName)
{
	GameInfo_CDCP.Print( SpawnCycleAnalyzer.SpawnOrderOverview(CycleName) );
}

defaultproperties
{	
	ReleaseVersion = "22"
	DebugVersion = "00"

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

//StartingWeapons
	StartingItems[0]=class'KFGameContent.KFWeap_AssaultRifle_Bullpup'
	StartingItems[1]=class'KFGameContent.KFWeap_AssaultRifle_AK12'
	StartingItems[2]=class'KFGameContent.KFWeap_AssaultRifle_Medic'

	StartingItems[3]=class'KFGameContent.KFWeap_Shotgun_HZ12'
	StartingItems[4]=class'KFGameContent.KFWeap_Shotgun_M4'
	StartingItems[5]=class'KFGameContent.KFWeap_Shotgun_AA12'

	StartingItems[6]=class'KFGameContent.KFWeap_SMG_Medic'
	StartingItems[7]=class'KFGameContent.KFWeap_Shotgun_Medic'
	StartingItems[8]=class'KFGameContent.KFWeap_AssaultRifle_Medic'

	StartingItems[9]=class'KFGameContent.KFWeap_Pistol_DualColt1911'
	StartingItems[10]=class'KFGameContent.KFWeap_Pistol_DualDeagle'
	StartingItems[11]=class'KFGameContent.KFWeap_Pistol_DualAF2011'

	StartingItems[12]=class'KFGameContent.KFWeap_Rifle_CenterfireMB464'
	StartingItems[13]=class'KFGameContent.KFWeap_Rifle_M14EBR'
	StartingItems[14]=class'KFGameContent.KFWeap_AssaultRifle_FNFal'

	StartingItems[15]=class'KFGameContent.KFWeap_SMG_MP5RAS'
	StartingItems[16]=class'KFGameContent.KFWeap_SMG_P90'
	StartingItems[17]=class'KFGameContent.KFWeap_SMG_Kriss'

	StartingItems[18]=class'KFGameContent.KFWeap_Edged_Katana'
	StartingItems[19]=class'KFGameContent.KFWeap_Blunt_Pulverizer'
	StartingItems[20]=class'KFGameContent.KFWeap_Eviscerator'

	StartingItems[21]=class'KFGameContent.KFWeap_GrenadeLauncher_M79'
	StartingItems[22]=class'KFGameContent.KFWeap_RocketLauncher_SealSqueal'
	StartingItems[23]=class'KFGameContent.KFWeap_RocketLauncher_RPG7'

	StartingItems[24]=class'KFGameContent.KFWeap_Shotgun_DragonsBreath'
	StartingItems[25]=class'KFGameContent.KFWeap_Flame_Flamethrower'
	StartingItems[26]=class'KFGameContent.KFWeap_AssaultRifle_Microwave'

//	
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

class CD_PlayerController extends KFPlayerController
	DependsOn(CD_Domain)
	config( CombinedCD_LocalData );

`include(CD_Log.uci)

struct InvSetCombo
{
	var Inventory Inv;
	var bool bSet;
};

struct WeaponUIState
{
	var class<KFPerk> Perk;
	var class<KFWeaponDefinition> WeapDef;
	var int PageNum;
};

struct PerkBoolCombo
{
	var KFPerk Perk;
	var bool bEnd;
};

var config array<LoadoutInfo> LoadoutList;

var config int IniVer;
var config string AlphaGlitter;
var config int ChatCharThreshold;
var config int ChatLineThreshold;
var config bool ClientLogging;

var config bool PlayerDeathSound;
var config bool LargeKillSound;
var config bool DisableMeowSound;
var config bool LargeKillTicker;

var config float PlayerDeathSoundVolumeMultiplier;
var config float LargeKillSoundVolumeMultiplier;
var config float MeowSoundVolumeMultiplier;

var config bool HideDualPistol;
var config bool DropItem;

var config bool DisablePickUpOthers;
var config bool DropLocked;
var config bool DisablePickUpLowAmmo;
var config bool ClientAntiOvercap;

var config bool WaveEndStats;
var config bool AlertUnusualSettings;
var config bool DisplayCDTips;
var config bool ShowPickupInfo;

var config bool UseVanillaScoreboard;

var string CDEchoMessageColor;
var string RPWEchoMessageColor;
var string UMEchoMessageColor;
var string SystemMessageColor;
var string MapVoteMessageColor;

var CD_ConsolePrinter Client_CDCP;
var CD_WeaponSkinList Client_CDWSL;
var CD_SpawnCycleCatalog SpawnCycleCatalog;
var private CD_RPCHandler RPCHandler;

var class<xUI_MenuBase>
	CycleMenuClass,
	AdminMenuClass,
	ClientMenuClass,
	PlayersMenuClass,
	AutoTraderMenuClass,
	MapVoteMenuClass,
	ConsoleMenuClass;

var WeaponUIState WeapUIInfo;
var bool AlphaGlitterBool;
var bool bDisableDual;
var bool bTestRestriction;
var bool bRestrict;
var bool bTestPickupMsg;
var bool bShowVolumes;
var bool bShowPathNodes;
var bool bSwitchedRole;
var float JudgeDelay;
var array<int> AnalysisCounts;
var array<UserInfo> AuthorityList;
var array<PerkBoolCombo> LoadoutNotes;
var array<CD_PerkInfo> PerkRestrictions;
var array<CD_SkillInfo> SkillRestrictions;
var array<CD_WeaponInfo> WeaponRestrictions;
var array<PlayerReplicationInfo> MuteChatTargets;
var bool bRequireLv25;
var bool bAntiOvercap;
var bool bAuthReceived;
var byte DownloadStage;
var int DownloadIndex;
var float TestScale;
var float SubTestScale;
var string PendingTitle, PendingBody;

var localized string HelpHintMsg;
var localized string UniqueSettingsNotify;
var localized string SeeConsoleString;
var localized string LevelRestrictionMsg;
var localized string LevelRequirementMsg;
var localized string PerkRestrictionMsg;
var localized string AuthorityErrorMsg;
var localized string SkillRestrictionMsg;
var localized string BannedString;
var localized string WeaponRestrictionMsg;
var localized string AutoSaleMsg;
var localized string SecondString;
var localized string NotAllowedString;
var localized string CapacityErrorMsg;
var localized string BeSpectatorString;
var localized string BePlayerString;
var localized string AdminMenuAccessErrorString;
var localized string SwitchSkillString;

replication
{
    if ( bNetOwner && Role == ROLE_Authority )
        RPCHandler;
}

/* ==============================================================================================================================
 *	Main functions
 * ============================================================================================================================== */

function CD_PlayerReplicationInfo GetCDPRI()
{
	return CD_PlayerReplicationInfo(PlayerReplicationInfo);
}

function CD_GameReplicationInfo GetCDGRI()
{
	return CD_GameReplicationInfo(WorldInfo.GRI);
}

function CD_Pawn_Human GetCDPawn()
{
	return CD_Pawn_Human(Pawn);
}

public function CD_RPCHandler GetRPCHandler()
{
	if (RPCHandler == None && Role < ROLE_Authority)
    {
        foreach DynamicActors(class'CD_RPCHandler', RPCHandler)
        {
            if (RPCHandler.Owner == self)
			{
				`cdlog("CD_RPCHandler.GetRPCHandler: Found existing RPCHandler for " $ self.name);
                break;
			}
        }
    }

	return RPCHandler;
}

public function KF2GUIController GetGUIController()
{
	return class'KF2GUIController'.static.GetGUIController(self);
}

public function bool hasAdminLevel()
{
	return WorldInfo.NetMode == NM_StandAlone || GetCDPRI().AuthorityLevel >= class'CD_AuthorityHandler'.const.ADMIN_LEVEL;
}

simulated event PostBeginPlay()
{
	SetTimer(JudgeDelay, false, 'StartJudge');
	SetTimer(JudgeDelay, false, 'StartRegister');

	super.PostBeginPlay();

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	Client_CDCP = new class'CD_ConsolePrinter';
	Client_CDWSL = Spawn(class'CD_WeaponSkinList', self);

	if ( 0 >= ChatLineThreshold )
	{
		ChatLineThreshold = 7;
	}

	if ( 0 >= ChatCharThreshold )
	{
		ChatCharThreshold = 340;
	}

	if ( "" == AlphaGlitter )
	{
		AlphaGlitter = "true";
	}

	AlphaGlitterBool = bool( AlphaGlitter );

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		class'CD_TraderItemsHelper'.static.CopyWeaponSkins();
	}

	if (WorldInfo.NetMode == NM_Client || WorldInfo.NetMode == NM_StandAlone)
	{
		SetTimer(0.5f, false, 'SetupConfig');
		SetTimer(1.0f, false, 'SendPickupInfo');
	}

	if (ROLE == ROLE_AUTHORITY)
	{
		RPCHandler = Spawn(class'CD_RPCHandler', self);
	}
}

reliable client simulated function SetupConfig()
{
	local bool bChanged;

	if(IniVer < 4)
	{
		LargeKillSound = false;
		LargeKillTicker = false;
		HideDualPistol = false;
		DisablePickUpOthers = false;
		DropLocked = false;
		DisablePickUpLowAmmo = false;
	}
	if(IniVer < 5)
	{
		DropItem = false;
	}
	if(IniVer < 6)
	{
		WaveEndStats = false;
	}
	if(IniVer < 8)
	{
		DisableMeowSound = false;
	}
	if(IniVer < 9)
	{
		AlertUnusualSettings = true;
		DisplayCDTips = true;
		ShowPickupInfo = true;
		bChanged = true;
	}
	if(bChanged)
	{
		IniVer = 9;
		SaveConfig();
//		SetTimer(1.f, false, 'ShowUpdateOverview');
	}
}

function DelayedInitialization()
{
	ShowHelpHint();
	SynchSettings();
	SetupAuthList();
	ClientSendLoadoutList();
	SetupCycleList();
	SynchServerIP();
}

reliable client function SynchServerIP(){
	ServerSynchServerIP(Worldinfo.GetAddressURL());
}

reliable server function ServerSynchServerIP(string ServerIP){
	CD_Survival(WorldInfo.Game).SynchServerIP(ServerIP);
}

reliable client function SetupCycleList()
{
	SpawnCycleCatalog = new class'CD_SpawnCycleCatalog';
	SpawnCycleCatalog.ClientSetup();
}

reliable client function ShowHelpHint()
{
	ClientMessage(HelpHintMsg, 'CDEcho');
}

reliable server function SynchSettings()
{
	CD_Survival(WorldInfo.Game).SynchSettings(self);
}

reliable client function SynchWeapDmgList(WeaponDamage WeapDmg)
{
	local int i;

	i = MatchStats.WeaponDamageList.Find('WeaponDef', WeapDmg.WeaponDef);
	if(i == INDEX_NONE)
	{
		`Log("SYNCH WEAP DMG LIST: SOMTHING WRONG");
		i = MatchStats.WeaponDamageList.length;
		MatchStats.WeaponDamageList.Add(1);
	}

	MatchStats.WeaponDamageList[i].DamageAmount = WeapDmg.DamageAmount;
	MatchStats.WeaponDamageList[i].HeadShots = WeapDmg.HeadShots;
	MatchStats.WeaponDamageList[i].LargeZedKills = WeapDmg.LargeZedKills;
}

reliable client function ResetSettings()
{
	PerkRestrictions.Remove(0, PerkRestrictions.length);
	SkillRestrictions.Remove(0, SkillRestrictions.length);
	WeaponRestrictions.Remove(0, WeaponRestrictions.length);
}

reliable client function ReceiveAuthority(int AuthLv)
{
	GetCDPRI().AuthorityLevel = AuthLv;
}

reliable client function ReceiveLevelRestriction(bool bLv)
{
	bRequireLv25 = bLv;
}

reliable client function ReceiveAntiOvercap(bool bEnable)
{
	bAntiOvercap = bEnable;
}

reliable client function ReceivePerkRestrictions(CD_PerkInfo PR)
{
	PerkRestrictions.AddItem(PR);
}

reliable client function ReceiveSkillRestrictions(CD_SkillInfo SR)
{
	SkillRestrictions.AddItem(SR);
}

reliable client function ReceiveWeaponRestrictions(CD_WeaponInfo WR)
{
	WeaponRestrictions.AddItem(WR);
}

reliable client function SynchFinished()
{
	if(!IsAllowedWeapon(class'KFGame.KFWeapDef_HRG_93R', GetCDGRI().BossWaveComes(), false))
	{
		SurvivalPerkSecondaryWeapIndex = 0;
		CurrentPerk.SetSecondaryWeaponSelectedIndex(SurvivalPerkSecondaryWeapIndex);
	}
}

function NotifyUniqueSettings()
{
	ClientNotifyUniqueSettings();
}

reliable client function ClientNotifyUniqueSettings()
{
	if(AlertUnusualSettings)
		ClientMessage(UniqueSettingsNotify, 'UMEcho');
}

reliable client function ClientSendLoadoutList()
{
	local int i, j;

	for(i=0; i<LoadoutList.length; i++)
	{
		for(j=0; j<LoadoutList[i].WeapDef.length; j++)
		{
			SendLoadoutList(LoadoutList[i].Perk, LoadoutList[i].WeapDef[j], i==0 && j==0, j, LoadoutList[i].WeapDef.length);
		}
	}
}

function SendLoadoutList(class<KFPerk> Perk, class<KFWeaponDefinition> WeapDef, bool bInit, int Priority, int DefLen)
{
	ServerReceiveLoadoutList(Perk, WeapDef, bInit, Priority, DefLen);
}

reliable server function ServerReceiveLoadoutList(class<KFPerk> Perk, class<KFWeaponDefinition> WeapDef, bool bInit, int Priority, int DefLen)
{
	local CD_AutoPurchaseHelper CDAPH;

	CDAPH = CD_AutoPurchaseHelper(GetPurchaseHelper());
	if(CDAPH == none)
	{
		`cdlog("CD_AutoPurchaseHelper is none!");
		return;
	}

	CDAPH.ServerReceiveLoadoutList(Perk, WeapDef, bInit, Priority, DefLen);
}

reliable server function ServerRemoveLoadoutList(int idx, class<KFPerk> Perk)
{
	local CD_AutoPurchaseHelper CDAPH;

	CDAPH = CD_AutoPurchaseHelper(GetPurchaseHelper());
	if(CDAPH == none)
	{
		`cdlog("CD_AutoPurchaseHelper is none!");
		return;
	}

	CDAPH.RemoveLoadoutList(idx, Perk);
}

reliable server function ServerSwitchLoadoutList(int i, int j, class<KFPerk> Perk)
{
	local CD_AutoPurchaseHelper CDAPH;

	CDAPH = CD_AutoPurchaseHelper(GetPurchaseHelper());
	if(CDAPH == none)
	{
		`cdlog("CD_AutoPurchaseHelper is none!");
		return;
	}

	CDAPH.SwitchLoadoutList(i, j, Perk);
}

//function ShowUpdateOverview(){ ShowConnectionProgressPopup(PMT_AdminMessage,"Update Overview", UpdateOverview); }

reliable client event TeamMessage( PlayerReplicationInfo PRI, coerce string S, name Type, optional float MsgLifeTime  )
{
	local bool b;
	local int MessageChars, MessageLines;
	local array<string> Tokens;

	// Messages from CD bypass the usual chat display code
	if ( S != "" && GetColorbyType(Type) != "" )
	{
		MessageChars = Len(s);

		ParseStringIntoArray( S, Tokens, "\n", false );
		MessageLines = Tokens.Length;

		if ( MessageLines > ChatLineThreshold || MessageChars > ChatCharThreshold || Type == 'Console')
		{
			LocalPlayer(Player).ViewportClient.ViewportConsole.OutputText("#{00ff00}[ControlledDifficulty]#{NOPARSE}\n  " $ Repl(S, "\n", "\n  "));
			S = SeeConsoleString;
		}

		// Attempt to append it to the PartyWidget or PostGameMenu (if active)
		if (MyGFxManager != none)
		{
			`cdlog( "chatdebug: PartyWidget instance is " $ MyGFxManager.PartyWidget, ClientLogging );

			if ( None != MyGFxManager.PartyWidget )
			{
				b = MyGFxManager.PartyWidget.ReceiveMessage( S, GetColorbyType(Type) );
				`cdlog( "chatdebug: PartyWidget.ReceiveMessage returned " $ b, ClientLogging );
			}

			`cdlog( "chatdebug: PostGameMenu is " $ MyGFxManager.PostGameMenu, ClientLogging );

			if( None != MyGFxManager.PostGameMenu )
			{
				MyGFxManager.PostGameMenu.ReceiveMessage( S, GetColorbyType(Type) );
			}
		}

		// Attempt to append it to GFxHUD.HudChatBox (this is at the lower-left 
		// of the player's screen after the game starts)
		if( None != MyGFxHUD && None != MyGFxHUD.HudChatBox )
		{
			MyGFxHUD.HudChatBox.AddChatMessage(S, GetColorbyType(Type));
		}
	}

	else if(HideMessage(S, PRI))
		return;

	else
	{
		// Everything else is processed as usual
		super.TeamMessage( PRI, S, Type, MsgLifeTime );
	}
}

function string GetColorbyType(name Type)
{
	if(Type == 'CDEcho' || Type == 'Console') return CDEchoMessageColor;
	else if(Type == 'RPWEcho') return RPWEchoMessageColor;
	else if(Type == 'UMEcho') return UMEchoMessageColor;
	else if(Type == 'System') return SystemMessageColor;
	else if(Type == 'MapVote') return MapVoteMessageColor;
	else return "";
}

// If hide message
function bool HideMessage(string S, PlayerReplicationinfo PRI)
{
	local array<String> splitbuf;
	ParseStringIntoArray(S,splitbuf," ",true);

	switch(S)
	{
		case "!ot":
		case "!cdot":
		case "!cdat":
		case "!cdautotrader":
		case "!cdwho":
		case "!cdr":
		case "!cdready":
		case "!cdur":
		case "!cdunready":
		case "!cdmystats":
		case "!cdms":
		case "!cdinfo":
		case "!tdd":
		case "!cdfs":
			return true;
	}

	return (DisableMeowSound && S ~= "!cdmia") ||
		   (PRI != PlayerReplicationInfo && S ~= "!cdal") ||
		   (MuteChatTargets.Find(PRI) != INDEX_NONE);
}

/* ==============================================================================================================================
 *	RPW
 * ============================================================================================================================== */

function StartJudge(){ SetTimer(0.1f, true, 'JudgePlayers'); }

function JudgePlayers()
{
	local Weapon CurWeapon;

	if( PlayerReplicationInfo != none &&
		(!PlayerReplicationInfo.bWaitingPlayer || PlayerReplicationInfo.bReadyToPlay) )
		RestrictPlayer();

	if(pawn != none)
	{
		CurWeapon = pawn.Weapon;
		
		if(CurWeapon != none)
			RestrictWeapon(CurWeapon);
	}
}

function StartRegister(){ SetTimer(2.f, true, 'RegisterStats'); }

function RegisterStats()
{
	if(KFGameReplicationInfo(WorldInfo.GRI).bTraderIsOpen)
	{
		GetCDPRI().DmgD = MatchStats.TotalDamageDealt;
	}
	else
	{
		GetCDPRI().DmgD = Max(MatchStats.TotalDamageDealt + PWRI.VectData1.Z, GetCDPRI().DmgD);
	}
}

function RestrictPlayer()
{
	local class<KFPerk> Perk;
	local int SkillIdx;
	local string RestrictMessage;

	Perk = GetPerk().GetPerkClass();

	//	LevelRestriction
	if(IsRestrictedLevel(GetPerk().GetLevel()))
	{
		if(!bRestrict)
			ShowConnectionProgressPopup(PMT_ConnectionFailure, LevelRestrictionMsg, LevelRequirementMsg);

		if(!TrySwitchPerk())
			TryExterminate();

		bRestrict = true;
	}

	//	PerkRestriction
	else if(IsRestrictedPerk(Perk))
	{
		if(!bRestrict)
			ShowConnectionProgressPopup(PMT_ConnectionFailure, PerkRestrictionMsg, AuthorityErrorMsg $ Mid(string(Perk), 7));
		
		if(!TrySwitchPerk())
			TryExterminate();

		bRestrict = true;
	}

	else bRestrict = false;

	//	SkillRestriction
	if(RestrictedSkillIsActive(Perk, SkillIdx))
	{	
		TrySwitchSkill(SkillIdx, Perk);
		RestrictMessage = SkillBanMessage(Perk, SkillIdx);
		RestrictMessage @= BannedString;
		ShowConnectionProgressPopup(PMT_AdminMessage, SkillRestrictionMsg, RestrictMessage);	
	}
}

function TryExterminate()
{
	if(Pawn == none || PlayerReplicationInfo.bWaitingPlayer)
		return;

	if(KFGameReplicationInfo(WorldInfo.GRI).bTraderIsOpen)
		Pawn.Health = max(Pawn.Health-10,1);
	
	else if (Pawn.Health>=0)
		Pawn.FellOutOfWorld(none);
}

/* --------------------------------------------------------------------------------------------------------------------------------- */

function bool TrySwitchPerk(optional out byte PerkIndex)
{
	for(PerkIndex=0; PerkIndex<PerkList.length; PerkIndex++)
	{
		if(!IsRestrictedLevel(PerkList[PerkIndex].PerkLevel) && !IsRestrictedPerk(PerkList[PerkIndex].PerkClass))
		{
			RequestPerkChange(PerkIndex);
			return true;
		}
	}

	return false;
}

function bool IsRestrictedLevel(byte PerkLevel)
{
	return bRequireLv25 && 25 > PerkLevel;
}

function bool IsRestrictedPerk(class<KFPerk> Perk)
{
	local int i;

	for(i=0; i<PerkRestrictions.length; i++)
	{
		if( Perk == PerkRestrictions[i].Perk &&
			( PerkRestrictions[i].RequiredLevel > GetCDPRI().AuthorityLevel) )
		{
			return true;
		}
	}

	return false;
}

/* --------------------------------------------------------------------------------------------------------------------------------- */

function bool RestrictedSkillIsActive(class<KFPerk> Perk, out int SkillIdx)
{
	local int i;

	for(i=0; i<SkillRestrictions.length; i++)
	{
		if(Perk == SkillRestrictions[i].Perk && GetSkillActivity(SkillRestrictions[i].Skill))
		{
			SkillIdx = SkillRestrictions[i].Skill;
			return true;
		}
	}
	
	return false;
}

function bool IsRestrictedSkill(class<KFPerk> Perk, int SkillIdx)
{
	local int i;

	for(i=0; i<SkillRestrictions.length; i++)
	{
		if(Perk == SkillRestrictions[i].Perk && SkillIdx == SkillRestrictions[i].Skill)
		{
			return true;
		}
	}
	
	return false;
}

function bool GetSkillActivity(int i){	return GetPerk().PerkSkills[i].bActive; }

static function string SkillBanMessage(class<KFPerk> Perk, int SkillIdx)
{
	local string s;

	s = GetLocalizedSkillName(Perk, SkillIdx);
	s @= "(Lv"$(5*((SkillIdx/2)+1));
	s $= ( SkillIdx%2 == 0 ) ? "L" : "R";
	s $= ")";
	return s;
}

static function string GetLocalizedSkillName(class<KFPerk> Perk, int SkillIdx)
{
	local array<string> splitbuf;

	if(Perk == none) return "";

	splitbuf.length=2;
	ParseStringIntoArray(PathName(Perk), splitbuf, ".", true);

	return Localize(splitbuf[1], Perk.default.PerkSkills[SkillIdx].Name, splitbuf[0]);
}

function TrySwitchSkill(int Idx, class<KFPerk> PerkClass)
{
	local int PerkBuild, Tier, Option, CurOption;
	local byte SelectedSkillsHolder[`MAX_PERK_SKILLS];

	PerkBuild = GetPerkBuildByPerkClass( PerkClass );

	//	Which is the targeted skill?
	Tier = Idx/2;
	Option = (Idx%2 == 0) ? 2 : 1;
	CurOption = PerkBuild/(4**Tier) % 4;
	PerkBuild += (Option - CurOption)*(4**Tier);

	GetPerk().GetUnpackedSkillsArray( PerkClass, PerkBuild,  SelectedSkillsHolder);
	CurrentPerk.UpdatePerkBuild(SelectedSkillsHolder, PerkClass);
}

/* --------------------------------------------------------------------------------------------------------------------------------- */
function RestrictWeapon(Weapon Weap)
{
	local int i;
	local class<KFWeaponDefinition> WeapDefClass;
	local CD_GameReplicationInfo CDGRI;	
	local bool bBossWave, bIsDoshinegun;
	local KFAutoPurchaseHelper KFAPH;
	local bool bWeapRest;

	CDGRI = GetCDGRI();
	WeapDefClass = class'CD_Object'.static.GetWeapDef(KFWeapon(Weap));
	bBossWave = CDGRI.BossWaveComes();
	bIsDoshinegun = CustomWeap_AssaultRifle_Doshinegun(Weap) != none;

	bWeapRest = !IsAllowedWeapon(WeapDefClass, bBossWave, bIsDoshinegun);

	if(bWeapRest && !bIsDoshinegun)
	{
		bWeapRest = MakeSureWeapDef(Weap, WeapDefClass);
	}

	if( bWeapRest )
	{
		KFAPH = GetPurchaseHelper();

		if (KFAPH.OwnedItemList.length == 0)
		{
			KFAPH.InitializeOwnedItemList();
		}

		for(i=0; i<KFAPH.OwnedItemList.length; ++i)
		{
			if(KFAPH.OwnedItemList[i].DefaultItem.ClassName == Weap.Class.name)
				break;
		}
		ForceToSellWeap(KFAPH.OwnedItemList[i].DefaultItem, Weap);
		ShowMessageBar('Priority', WeaponRestrictionMsg, Weap.ItemName $ AutoSaleMsg);
	}
}

function bool MakeSureWeapDef(Weapon Weap, class<KFWeaponDefinition> WeapDef)
{
	local KFGFxObject_TraderItems TraderItems;
	local int i;

	TraderItems = KFGameReplicationInfo(WorldInfo.GRI).TraderItems;
	i = TraderItems.SaleItems.Find('WeaponDef', WeapDef);

	if(i == INDEX_NONE)
		return true; // Unknown Weapon

	return TraderItems.SaleItems[i].WeaponDef.default.WeaponClassPath ~= PathName(Weap.Class);
}

function bool IsAllowedWeapon(class<KFWeaponDefinition> WeapDef, bool bBossWave, bool bIsDoshinegun)
{
	local int i;
	local KFGameReplicationInfo KFGRI;

	KFGRI = KFGameReplicationInfo(WorldInfo.GRI);

	if(bIsDoshinegun)
		return KFGRI.bTraderIsOpen || KFGRI.bMatchIsOver;

	if(!IsListedPerkWeap(WeapDef))
		return false;
	
	i = WeaponRestrictions.Find('WeapDef', WeapDef);

	if(i == INDEX_NONE)
		return true;
	
	if( (!WeaponRestrictions[i].bOnlyForBoss || bBossWave) &&
		WeaponRestrictions[i].RequiredLevel <= GetCDPRI().AuthorityLevel )
	{
		return true;
	}

	return false;
}

function bool IsListedPerkWeap(class<KFWeaponDefinition> WeapDef)
{
	local KFGFxObject_TraderItems TraderItems;
	local int i, j, k;

	TraderItems = KFGameReplicationInfo(WorldInfo.GRI).TraderItems;
	i = TraderItems.SaleItems.Find('WeaponDef', WeapDef);
	
	if(i == INDEX_NONE || TraderItems.SaleItems[i].AssociatedPerkClasses.length == 0 || TraderItems.SaleItems[i].AssociatedPerkClasses[0] == none)
		return true; // Unknown Weapon

	else
	{
		for(j=0; j<TraderItems.SaleItems[i].AssociatedPerkClasses.length; j++)
		{
			for(k=0; k<PerkList.length; k++)
			{
				if(PerkList[k].PerkClass == TraderItems.SaleItems[i].AssociatedPerkClasses[j])
					return true;
			}
		}
	}
	
	return false;
}

reliable server function ForceToSellWeap(STraderItem SoldItem, Weapon Weap)
{
	local KFInventoryManager KFIM;

	KFIM = KFInventoryManager(Pawn.InvManager);
	
	if(KFIM != none)
	{
		GetCDPRI().AddDosh(KFIM.GetAdjustedSellPriceFor(SoldItem));		
		KFIM.ServerRemoveFromInventory(Weap);
    	Weap.Destroy();
	}
}

/* ==============================================================================================================================
 *	Authority Handler
 * ============================================================================================================================== */

/*
 *	1. Initialization
 *		Setup > CleanUp > Request > CD.Send > Receive
 *	2. Register by Console Command
 *		exec > CD.Authorize + Client.Authorize
 *	3. Change by Admin Menu
 *		Clicled > CD.Authorize + Client.Authorize
 */

//	Initialize
function SetupAuthList()
{
	CleanUpAuthList();
	SetTimer(1.f, false, 'RequestAuthList');
}

unreliable client simulated function CleanUpAuthList()
{
	bAuthReceived = false;
	AuthorityList.Remove(0, AuthorityList.length);
	DownloadIndex = 0;
}

//	Receive
reliable server function RequestAuthList()
{
	local CD_Survival CD;

	CD = CD_Survival(WorldInfo.Game);
	CD.SendAuthList(self);
}

reliable client function ReceiveAuthList(UserInfo NewInfo)
{
	local int index;

	index = AuthorityList.Find('SteamID', NewInfo.SteamID);
	
	if(index == INDEX_NONE)
		AuthorityList.AddItem(NewInfo);
	
	else
		AuthorityList[index] = NewInfo;

}

unreliable client function CompleteAuthList()
{
	bAuthReceived = true;
}

//	Register
reliable server function ServerAddAuthorityInfo(string SteamID, int AuthorityLevel, optional string UserName)
{
	local CD_Survival CD;

	CD = CD_Survival(WorldInfo.Game);
	CD.AuthorityHandler.AuthorizeUser(SteamID, AuthorityLevel, UserName);
	ClientAuthorizeUser(SteamID, AuthorityLevel, UserName);
}

reliable client function ClientAuthorizeUser(string SteamID, int AuthorityLevel, optional string UserName)
{
	local UserInfo UInfo;

	if(UserName != "")
		UInfo.UserName = UserName;

	UInfo.SteamID = SteamID;
	UInfo.AuthorityLevel = AuthorityLevel;
	ReceiveAuthList(UInfo);
}


reliable server function ChangeUserAuthority(UserInfo ChangedUser)
{
	local CD_Survival CD;

	CD = CD_Survival(WorldInfo.Game);
	CD.AuthorityHandler.ChangeUserAuthority(ChangedUser);
	ReceiveAuthList(ChangedUser);
}

reliable server function RemoveAuthorityInfo(UserInfo RemovedUser)
{
	local CD_Survival CD;

	CD = CD_Survival(WorldInfo.Game);
	CD.AuthorityHandler.RemoveAuthorityInfo(RemovedUser);
	ClientRemoveAuthorityInfo(RemovedUser);
}

unreliable client function ClientRemoveAuthorityInfo(UserInfo User)
{
	AuthorityList.RemoveItem(User);
}

reliable server function ServerSetExtraCommand(string Key, string Response, CD_PlayerController CDPC)
{
	local CD_Survival CD;

	CD = CD_Survival(WorldInfo.Game);
	CD.SetExtraCommand(Key, Response, CDPC);
}

/* ==============================================================================================================================
 *	Overridden functions
 * ============================================================================================================================== */

function AddZedKill( class<KFPawn_Monster> MonsterClass, byte Difficulty, class<DamageType> DT, bool bKiller )
{
	MonsterClass = class'CD_ZedNameUtils'.static.CheckMonsterClassRemap( MonsterClass, "CD_PlayerController.AddZedKill", ClientLogging );

	super.AddZedKill( MonsterClass, Difficulty, DT, bKiller );
}

//	Unlimited Perk Switch
event SetHaveUpdatePerk(bool bUsedUpdate){ bPlayerUsedUpdatePerk = false; }

//	Chat Box Modification
function string GetChatChannel(name Type, PlayerReplicationInfo PRI)
{
	if(PRI.bOnlySpectator)
		return "<"$class'KFCommon_LocalizedStrings'.default.SpectatorString$">";

	else
		return "";
}

function RecieveChatMessage(PlayerReplicationInfo PRI, string ChatMessage, name Type, optional float MsgLifeTime)
{
	if( MyGFxHUD.HudChatBox != none )
	{
		MyGFxHUD.HudChatBox.AddChatMessage(ChatMessage, class 'KFLocalMessage'.default.SayColor);
	}
}

exec function RequestSkipTrader()
{
	if(CD_PlayerReplicationInfo(PlayerReplicationInfo).bIsReadyForNextWave)
		Say("!cdur");

	else
		Say("!cdr");
}

function DoAutoTrader()
{
	ServerSetEnablePurchases(true);
	GetPurchaseHelper().DoAutoPurchase();
	ServerSetEnablePurchases(false);
}

function AddShotsFired( int AddedShots )
{
	if(GetCDGRI().bWaveIsActive)
	{
		super.AddShotsFired(AddedShots);
	}
}

function AddShotsHit( int AddedHits )
{
	if(GetCDGRI().bWaveIsActive)
	{
		super.AddShotsHit(AddedHits);
	}
}

function AddHeadHit( int AddedHits )
{
	if(GetCDGRI().bWaveIsActive)
	{
		super.AddHeadHit(AddedHits);
	}
}

/* ==============================================================================================================================
 *	Server functions
 * ============================================================================================================================== */

reliable server simulated function CheckPlayerStartForCurMap()
{
	GetRPCHandler().CheckPlayerStartForCurMap();
}

reliable server simulated function GotoPathNode(int NodeIndex)
{
	GetRPCHandler().GotoPathNode(NodeIndex);
}

reliable server simulated function RequestEveryoneGotoPathNode(int NodeIndex)
{
	GetRPCHandler().RequestEveryoneGotoPathNode(NodeIndex);
}

reliable server simulated function GetDisableCustomStarts()
{
	GetRPCHandler().GetDisableCustomStarts();
}

reliable server simulated function SetDisableCustomStarts(bool bDisable)
{
	GetRPCHandler().SetDisableCustomStarts(bDisable);
}

reliable server function OpenMapVote()
{
	CD_Survival(WorldInfo.Game).xMut.ShowMapVote('MapVote', Self);
}

reliable server simulated function RequestPickupInfo()
{
	GetRPCHandler().RequestPickupInfo();
}

reliable server function ReceivePickup(CD_DroppedPickup Pickup, optional bool bFinishDownload = false)
{
	GetRPCHandler().ReceiveInfoFromPickup(Pickup, bFinishDownload);
}

reliable server simulated function SellSpareWeapon(int PickupIndex)
{
	GetRPCHandler().RequestSellSpareWeapon(PickupIndex);
}

reliable server simulated function SellAllSpareWeapons(string WeaponName)
{
	GetRPCHandler().RequestSellAllSpareWeapons(WeaponName);
}

reliable server simulated function RequestTeleportSpareWeapon(int PickupIndex)
{
	GetRPCHandler().RequestTeleportSpareWeapon(PickupIndex);
}

reliable server simulated function RequestTeleportAllSpareWeapons(string WeaponName)
{
	GetRPCHandler().RequestTeleportAllSpareWeapons(WeaponName);
}

unreliable server simulated function AssignAdmin()
{
	CD_Survival(WorldInfo.Game).ServerAssignAdmin(self);
}

reliable server simulated function ServerSendPickupInfo(bool bDisableOthers, bool bDropLocked, bool bDisableLow, bool bAOC)
{
	CD_Survival(WorldInfo.Game).ReceivePickupInfo(self, bDisableOthers, bDropLocked, bDisableLow, bAOC);
}

reliable server function SetSpawnCycle(string Cycle)
{
    local CD_Survival CD;

    CD = CD_Survival(WorldInfo.Game);
    CD.ChatCommander.RunCDChatCommandIfAuthorized(self, "!cdsc" @ Cycle);
    CD.CDGRI.CDInfoParams.SC = Cycle;
}

reliable server function RunCDChatCommand(string Command)
{
	local CD_Survival CD;

    CD = CD_Survival(WorldInfo.Game);
    CD.ChatCommander.RunCDChatCommandIfAuthorized(self, Command);
}

reliable server function ChangeLevelRestriction(bool bRequire)
{
	local CD_Survival CD;

    CD = CD_Survival(WorldInfo.Game);
    CD.AuthorityHandler.bRequireLv25 = bRequire;
    CD.AuthorityHandler.SaveConfig();
    CD.ResynchSettings();
}

reliable server function SaveSkillRestriction(class<KFPerk> Perk, int SkillIndex, bool bBan)
{
	local CD_Survival CD;
	local CD_SkillInfo TargetSkill, RefSkill;
	local int i;

	if(Perk == none)
		return;

	CD = CD_Survival(WorldInfo.Game);
	TargetSkill.Perk = Perk;
	TargetSkill.Skill = SkillIndex;

	for(i=0; i<CD.AuthorityHandler.SkillRestrictions.length; i++)
	{
		RefSkill = CD.AuthorityHandler.SkillRestrictions[i];

		if(RefSkill.Perk != Perk)
			continue;

		if( (bBan && RefSkill.Skill/2 == SkillIndex/2) ||
			(!bBan && RefSkill.Skill == SkillIndex) )
		{
			CD.AuthorityHandler.SkillRestrictions.Remove(i, 1);			
		}
	}

	if(bBan)
		CD.AuthorityHandler.SkillRestrictions.AddItem(TargetSkill);

	CD.AuthorityHandler.SaveConfig();
	CD.ResynchSettings();
}

reliable server function ChangeWeaponRestriction(CD_WeaponInfo CDWI)
{
	local CD_Survival CD;

	CD = CD_Survival(WorldInfo.Game);
	CD.AuthorityHandler.ChangeWeaponRestriction(CDWI);
	CD.ResynchSettings();
}

reliable server function ChangePerkRestriction(class<KFPerk> Perk, int Increament)
{
	local CD_Survival CD;

	CD = CD_Survival(WorldInfo.Game);
	CD.AuthorityHandler.ChangePerkRestriction(Perk, Increament);
	CD.ResynchSettings();
}

reliable server function ChangeMaxUpgradeCount(int change)
{
	local CD_Survival CD;

	CD = CD_Survival(WorldInfo.Game);
	CD.CDGRI.MaxUpgrade += change;
	CD.MaxUpgrade += change;
	CD.SaveConfig();
}

reliable server function ServerSetAntiOvercap(bool bEnable)
{
	local CD_Survival CD;

	CD = CD_Survival(WorldInfo.Game);
	CD.SetAntiOvercap(bEnable);
}

reliable server function AddPlayerStart(int index)
{
	local CD_Survival CD;
	CD = CD_Survival(WorldInfo.Game);
	CD.xMut.AddPlayerStart(index, self);
}

reliable server function RemovePlayerStart(int index)
{
	local CD_Survival CD;
	CD = CD_Survival(WorldInfo.Game);
	CD.xMut.RemovePlayerStart(index, self);
}

reliable server function ClearPlayerStart()
{
	local CD_Survival CD;
	CD = CD_Survival(WorldInfo.Game);
	CD.xMut.ClearPlayerStart(self);
}

reliable server function CheckPlayerStart()
{
	local CD_Survival CD;
	CD = CD_Survival(WorldInfo.Game);
	CD.xMut.CheckPlayerStart(self);
}

reliable server simulated function GetDisableCDRecordOnline()
{
	GetRPCHandler().GetDisableCDRecordOnline();
}

reliable server simulated function SetDisableCDRecordOnline(bool bDisable)
{
	GetRPCHandler().SetDisableCDRecordOnline(bDisable);
}

reliable server simulated function GetDisableCustomPostGameMenu()
{
	GetRPCHandler().GetDisableCustomPostGameMenu();
}

reliable server simulated function SetDisableCustomPostGameMenu(bool bDisable)
{
	GetRPCHandler().SetDisableCustomPostGameMenu(bDisable);
}

/* ==============================================================================================================================
 *	Client functions
 * ============================================================================================================================== */

unreliable client final simulated function ClientOpenURL(string URL){ OnlineSub.OpenURL(URL); }

reliable client simulated function OpenCustomMenu(class<KFGUI_Page> MenuClass)
{
	local KF2GUIController GUIController;

	GUIController = GetGUIController();
	GUIController.OpenMenu(MenuClass);

	if ( MenuClass == ConsoleMenuClass &&  GUIController.FindActiveMenu(ConsoleMenuClass.default.ID) != none)
	{
		GUIController.CloseMenu(ConsoleMenuClass);
	}
}

reliable client function RemoveSparePickup(int index)
{
	GetRPCHandler().RemoveSparePickup(index);
}

reliable client simulated function ShowReadyButton()
{
	MyGFxManager.PartyWidget.SetReadyButtonVisibility(true);
}

reliable client simulated function PrintConsole(string Msg)
{
	Client_CDCP.Print(Msg);
}

unreliable client simulated function PlayLargeKillSound()
{
	if(LargeKillSound)
		DynamicClientPlaySound( "CombinedSound.LargeKillSoundCue", LargeKillSoundVolumeMultiplier );
}

unreliable client simulated function PlayPlayerDeathSound()
{
	if(PlayerDeathSound)
		DynamicClientPlaySound( "CombinedSound.DeathSound", PlayerDeathSoundVolumeMultiplier );
}

unreliable client simulated function PlayMeowSound()
{
	if(!DisableMeowSound)
		DynamicClientPlaySound( "CombinedSound.MeowSound", MeowSoundVolumeMultiplier );
}

public unreliable client simulated function DynamicClientPlaySound(string SoundCuePath, optional float VolumeMultiplier)
{
	local SoundCue PlaySound;

	PlaySound = SoundCue( class'CD_Object'.static.SafeLoadObject(SoundCuePath, class'SoundCue') );
	
	if (PlaySound == none)
	{
		`cdlog("CD_PlayerController.DynamicClientPlaySound: Failed to load sound " $ SoundCuePath);
		return;
	}

	PlaySound.VolumeMultiplier = VolumeMultiplier > 0.f ? VolumeMultiplier : class'SoundCue'.default.VolumeMultiplier;
	ClientPlaySound(PlaySound);
}

unreliable client simulated function ReceiveLargeKillTicker(PlayerReplicationinfo Killer, KFPawn_Monster KFPM)
{
	if(LargeKillTicker)
		ReceiveLocalizedMessage(class'CD_LocalMessage', CDLMT_LargeKill, Killer, , KFPM.class);
}

unreliable client simulated function SyncStats(int Fired, int Hit, int HS)
{
	ShotsFired = Fired;
	ShotsHit = Hit;
	ShotsHitHeadshot = HS;
}

unreliable client simulated function ReceiveStats(string Msg)
{
    if(CD_GFxHudWrapper(myHUD) != none)
    {
    	CD_GFxHudWrapper(myHUD).MyStats = LocalizeSentence(Msg);
//    	CD_GFxHudWrapper(myHUD).ReceivedTime = WorldInfo.TimeSeconds;
    }
}

unreliable client simulated function RenderWaveEndSummary(string summary)
{
	local string title, body;

	title = Localize("CD_Survival", "WaveEndSummaryTitle", "CombinedCD2");
	body = LocalizeSentence(summary);

	RenderObjectiveContainer(title, body);
}

unreliable client simulated function RenderObjectiveContainer(string title, string body)
{
	local CD_GFxMoviePlayer_HUD GMPH;

	if(KFGFxHudWrapper(myHUD) != none)
	{
		GMPH = CD_GFxMoviePlayer_HUD(KFGFxHudWrapper(myHUD).HudMovie);
		if(GMPH != none)
		{
			if( GMPH.ShowObjectiveContainer(title, body) )
			{
				return;
			}
		}
	}

	PendingTitle = title;
	PendingBody = body;
	SetTimer(1.f, false, 'RetryRenderObjectiveContainer');
}

function RetryRenderObjectiveContainer()
{
	RenderObjectiveContainer(PendingTitle, PendingBody);
}

unreliable client simulated function ReceiveWaveEndStats(string Msg)
{
	if(WaveEndStats)
	{
		Msg = LocalizeSentence(Msg);
		ReceiveStats(Msg);
		Client_CDCP.Print("\n"$Msg);
	}
}

unreliable client simulated function ReceiveVoteLeftTime(int t)
{
	if(CD_GFxHudWrapper(myHUD) != none)
    {
    	CD_GFxHudWrapper(myHUD).VoteLeftTime = t;
    }
}

unreliable client simulated function NotifyClientReadyState(bool bReady)
{
	if(MyGFxManager.PartyWidget != none)
		MyGFxManager.PartyWidget.ReadyButton.SetBool("selected", bReady);
}

unreliable client simulated function RegisterLoadout(class<KFWeaponDefinition> WeapDef)
{
	local int idx;

	idx = LoadoutList.Find('Perk', WeapUIInfo.Perk);
	if(idx == INDEX_NONE)
	{
		LoadoutList.Add(1);
		idx = LoadoutList.length-1;
		LoadoutList[idx].Perk = WeapUIInfo.Perk;
	}
	if(LoadoutList[idx].WeapDef.Find(WeapDef) == INDEX_NONE)
	{
		LoadoutList[idx].WeapDef.AddItem(WeapDef);
		SaveConfig();
		SendLoadoutList(WeapUIInfo.Perk, WeapDef, false, LoadoutList[idx].WeapDef.length-1, LoadoutList[idx].WeapDef.length);
	}
	else
	{
		`cdlog(string(WeapDef) $ ": Already Registered!");
	}
}

unreliable client simulated function ModifyLoadout(int mod, int idx)
{
	switch(mod)
	{
		case 0:
			SwitchLoadoutOrder(idx-1, idx, WeapUIInfo.Perk);
			break;
		case 1:
			SwitchLoadoutOrder(idx, idx+1, WeapUIInfo.Perk);
			break;
		case 2:
			RemoveLoadout(idx, WeapUIInfo.Perk);
			break;
		default:
			`cdlog("ERROR: Failed to modify loadout.");
	}
}

function RemoveLoadout(int idx, class<KFPerk> Perk)
{
	local int i;

	i = LoadoutList.Find('Perk', Perk);
	if(i != INDEX_NONE && LoadoutList[i].WeapDef.length > idx)
	{
		LoadoutList[i].WeapDef.Remove(idx, 1);
		SaveConfig();
		ServerRemoveLoadoutList(idx, Perk);
	}
	else
	{
		`cdlog("ERROR: Failed to remove loadout");
	}
}

function SwitchLoadoutOrder(int i, int j, class<KFPerk> Perk)
{
	local int INDEX;
	local class<KFWeaponDefinition> TempWeapDef;

	INDEX = LoadoutList.Find('Perk', Perk);
	if(INDEX == INDEX_NONE || LoadoutList[INDEX].WeapDef.length <= max(i,j) || min(i,j) < 0)
	{
		`cdlog("ERROR: Failed to switch loadout order");
		return;
	}

	TempWeapDef = LoadoutList[INDEX].WeapDef[i];
	LoadoutList[INDEX].WeapDef[i] = LoadoutList[INDEX].WeapDef[j];
	LoadoutList[INDEX].WeapDef[j] = TempWeapDef;
	SaveConfig();

	ServerSwitchLoadoutList(i, j, Perk);
}

unreliable client simulated function ShowAuthorityLevel()
{
	TeamMessage(GetCDPRI(), "AuthorityLevel=" $ string(GetCDPRI().AuthorityLevel), 'CDEcho');
}

unreliable client simulated function ToggleMuteChat(PlayerReplicationinfo PRI)
{
	local int i;

	for(i=0; i<MuteChatTargets.length; i++)
	{
		if(MuteChatTargets[i] == PRI)
		{
			MuteChatTargets.RemoveItem(PRI);
			return;
		}
	}
	MuteChatTargets.AddItem(PRI);
}

unreliable client simulated function LocalizedClientMessage(string Msg, optional name Type='CDEcho')
{
	Msg = LocalizeSentence(Msg);
	ClientMessage(Msg, Type);
}

function string LocalizeSentence(string sentence)
{
	local array<string> splitbuf, p1, p2;
	local int i;

	ParseStringIntoArray(sentence, splitbuf, "<local>", false);

	for(i=splitbuf.length-1; i>=0; i--)
	{
		if(InStr(splitbuf[i], "</local>") > 0)
		{
			ParseStringIntoArray(splitbuf[i], p1, "</local>", false);
			ParseStringIntoArray(p1[0], p2, ".", false);
			splitbuf[i] = Localize(p2[0], p2[1], "CombinedCD2");
			splitbuf.InsertItem(i+1, p1[1]);
		}
	}
	JoinArray(splitbuf, sentence, "");
	return sentence;
}

reliable client simulated function UpdateSpectateURL(bool bSpectator)
{
	UpdateURL("SpectatorOnly", ((bSpectator) ? "1" : "0"), false);
}

reliable client simulated function SyncAnalysis(int index, int count)
{
	if(index == 0)
		AnalysisCounts.length = 0;

	AnalysisCounts.AddItem(count);
}

/* ==============================================================================================================================
 *	Other functions
 * ============================================================================================================================== */

unreliable client function ShowMessageBar(name Type, string Text1, optional string Text2, optional bool bLocalize)
{
	local KFGFxMoviePlayer_HUD GMPH;

	if(bLocalize)
	{
		Text1 = LocalizeSentence(Text1);
		Text2 = LocalizeSentence(Text2);
	}

	//	Under bar (usually seen when you pick up weapons)
	if (Type == 'Game'&& MyGFxHUD != none && Text1 != "")
		MyGFxHUD.ShowNonCriticalMessage(Text1);

	//	Upper bar (usually seen when waves start)
	else if (Type == 'Priority' && KFGFxHudWrapper(myHUD) != none && Text1 != "" && Text2 != "")
	{
		GMPH = KFGFxHudWrapper(myHUD).HudMovie;

		if(GMPH != none)
			GMPH.DisplayPriorityMessage(Text1, Text2, 6, GMT_Null);

		else if(MyGFxManager != none)
			MyGFxManager.QueueDelayedPriorityMessage(Text1, Text2, 6, GMT_Null);
	}
}

reliable client function ShowLevelUpNotify(string Title, string Main, string Secondary, string ImagePath, bool bShowSecondary, optional int NumericValue = -1)
{
	MyGFxHUD.LevelUpNotificationWidget.ShowAchievementNotification(Title, Main, Secondary, ImagePath, bShowSecondary, NumericValue);
}

reliable client function ShowLocalizedPopup(string title, string Msg, optional EProgressMessageType ProgressType=PMT_AdminMessage)
{
	ShowConnectionProgressPopup(ProgressType, LocalizeSentence(title), LocalizeSentence(Msg));
}

function SendPickupInfo()
{
	ServerSendPickupInfo(DisablePickUpOthers, DropLocked, DisablePickUpLowAmmo, ClientAntiOvercap);
}

function SavePerkUseNum(class<KFPerk> Perk)
{
	local int i;

	i = PerkList.Find('PerkClass', Perk);
	if(i == INDEX_NONE)
	{
		`cdlog("Not found the perk!");
		return;
	}

	// TODO: HTTP Post
}


/* ==============================================================================================================================
 *	Exec functions
 * ============================================================================================================================== */

exec function EnableCheats()
{
	super.EnableCheats();

	if( PlayerReplicationInfo.bAdmin || WorldInfo.NetMode == NM_Standalone )
	{
		RecordEnableCheats();
	}
}

reliable server private function RecordEnableCheats(){
	CD_Survival(WorldInfo.Game).RecordEnableCheats();
}

exec function ClientOption()
{
	SetTimer(0.25f, false, 'DelayedOpenClientMenu');
}

private function DelayedOpenClientMenu()
{
	OpenCustomMenu(ClientMenuClass);
}

exec function CycleOption()
{
	SetTimer(0.25f, false, 'DelayedOpenCycleMenu');
}

private function DelayedOpenCycleMenu()
{
	OpenCustomMenu(CycleMenuClass);
}

exec function OpenPlayersMenu()
{
	SetTimer(0.25f, false, 'DelayedOpenPlayersMenu');
}

private function DelayedOpenPlayersMenu()
{
	OpenCustomMenu(PlayersMenuClass);
}

exec function AdminMenu()
{ 
	if(hasAdminLevel())
	{
		SetTimer(0.25f, false, 'DelayedOpenAdminMenu');
	}
	else
	{
		ClientMessage(AdminMenuAccessErrorString, 'UMEcho');
	}
}

private function DelayedOpenAdminMenu()
{
	OpenCustomMenu(AdminMenuClass);
}

exec function ImAdmin(){ AssignAdmin(); }

exec function ForceSpawnAI(string ZedName)
{
	if(hasAdminLevel())
		CD_Survival(WorldInfo.Game).CD_SpawnZed(ZedName, self);
}

exec function AddAuthorityInfo(string SteamID, int AuthorityLevel, optional string UserName)
{
	if(hasAdminLevel())
	{
		ServerAddAuthorityInfo(SteamID, AuthorityLevel, UserName);
	}
}

exec function AddCustomStart(int index)
{
	if(hasAdminLevel())
		AddPlayerStart(index);
}

exec function RemoveCustomStart(int index)
{
	if(hasAdminLevel())
		RemovePlayerStart(index);
}

exec function ClearCustomStart()
{
	if(hasAdminLevel())
		ClearPlayerStart();
}

exec function CheckCustomStart()
{
	CheckPlayerStart();
}

exec function CheckAuthList()
{
	local string s;
	local int i;

	if(hasAdminLevel())
	{
		s = "\n";

		for(i=0; i<AuthorityList.length; i++)
			s $= AuthorityList[i].UserName $ "\n";

		PrintConsole(s);
	}
}

exec function ShowPathNodesNum()
{
	if(hasAdminLevel())
		bShowPathNodes = !bShowPathNodes;
}

exec function SetTestScale(float f, optional bool bSub)
{
	if(bSub)
	{
		SubTestScale = f;
	}
	else
	{
		TestScale = f;
	}	
}

exec function SwitchSkill(int i)
{
	local class<KFPerk> Perk;
	local string Msg;

	if(i < 0 || 4 < i)
	{
		PrintConsole("Index should be set between 0 and 4");
		return;
	}
	
	Perk = GetPerk().GetPerkClass();
	Msg = SwitchSkillString;
	if(GetSkillActivity(i*2))
	{
		TrySwitchSkill(i*2, Perk);
		ShowMessageBar('Game', Msg $ SkillBanMessage(Perk, i*2+1));
	}

	else
	{
		TrySwitchSkill(i*2+1, Perk);
		ShowMessageBar('Game', Msg $ SkillBanMessage(Perk, i*2));
	}
}

exec function SetExtraCommand(string Key, string Response)
{
	if(WorldInfo.NetMode == NM_StandAlone || GetCDPRI().AuthorityLevel > 3)
		ServerSetExtraCommand(Key, Response, self);
}

exec function testNotify()
{
	ShowLevelUpNotify("Title", "Main", "Secondary", "ImagePath", true, 10);
}

/**
 * Debug GUI function to set position and size of a GUI component.
 * This function is intended for debugging purposes and allows you to modify the position and size of a GUI component
 * The change does not persist and is only applied during the current session.
 * @param MenuID The ID of the menu containing the component.
 * @param ComponentID The ID of the component to modify.
 */
exec function DebugGUI(
	name MenuID,
	name ComponentID,
	float XPos,
	float YPos,
	float Width,
	float Height
){
	local KF2GUIController GUIController;
	local KFGUI_Page Page;
	local KFGUI_Base PageComponent;

	GUIController = class'KF2GUIController'.static.GetGUIController(self);
	Page = GUIController.FindActiveMenu(MenuID);

	if (Page == none)
	{
		`cdlog("DebugGUI: Page not found: " $ string(MenuID));
		return;
	}

	PageComponent = Page.FindComponentID(ComponentID);

	if (PageComponent != None)
	{
		PageComponent.SetPosition(XPos, YPos, Width, Height);
		return;
	}

	`cdlog("DebugGUI: Component not found: " $ string(ComponentID) $ " in " $ string(MenuID));
}

defaultproperties
{
	MatchStatsClass=class'CombinedCD2.CD_EphemeralMatchStats'
	PurchaseHelperClass=class'CD_AutoPurchaseHelper'

	ConsoleMenuClass=class'xUI_ConsoleMenu'
	CycleMenuClass=class'xUI_CycleMenu'
	AdminMenuClass=class'xUI_AdminMenu'
	ClientMenuClass=class'xUI_ClientMenu'
	PlayersMenuClass=class'xUI_PlayersMenu'
	AutoTraderMenuClass=class'xUI_AutoTrader'
	MapVoteMenuClass=class'xUI_MapVote'

	CDEchoMessageColor="00FF0A"
	RPWEchoMessageColor="FF20B7"
	UMEchoMessageColor="F8FF00"
	SystemMessageColor="0099FF"
	MapVoteMessageColor="00DCCE"
	JudgeDelay=5.f
	DownloadStage=255
	WeapUIInfo=(Perk=class'KFPerk_Commando', WeapDef=class'KFWeapDef_AR15', PageNum=0)
	TestScale=0.33

	PerkList.Remove((PerkClass=class'KFPerk_Berserker'))
	PerkList.Remove((PerkClass=class'KFPerk_Demolitionist'))
	PerkList.Remove((PerkClass=class'KFPerk_Firebug'))
	PerkList.Remove((PerkClass=class'KFPerk_Survivalist'))
}

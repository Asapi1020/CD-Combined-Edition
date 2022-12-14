class CD_PlayerController extends KFPlayerController
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

var config int IniVer;
var config string AlphaGlitter;
var config int ChatCharThreshold;
var config int ChatLineThreshold;
var config bool ClientLogging;

var config bool PlayerDeathSound;
var config bool LargeKillSound;
var config bool LargeKillTicker;

var config bool HideDualPistol;
var config bool DropItem;

var config bool DisablePickUpOthers;
var config bool DropLocked;
var config bool DisablePickUpLowAmmo;

var config bool WaveEndStats;

var string CDEchoMessageColor;
var string RPWEchoMessageColor;
var string UMEchoMessageColor;
var string SystemMessageColor;
var string MapVoteMessageColor;

var CD_ConsolePrinter Client_CDCP;
var CD_WeaponSkinList Client_CDWSL;
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
var array<UserInfo> AuthorityList;
var array<CD_PerkInfo> PerkRestrictions;
var array<CD_SkillInfo> SkillRestrictions;
var array<CD_WeaponInfo> WeaponRestrictions;
var bool bRequireLv25;
var bool bAuthReceived;
var byte DownloadStage;
var int DownloadIndex;

const UpdateOverview = "Now Preparing here...";

/* ==============================================================================================================================
 *	Main functions
 * ============================================================================================================================== */

function CD_PlayerReplicationInfo GetCDPRI()
{
	return CD_PlayerReplicationInfo(PlayerReplicationInfo);
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
		WorldInfo.ConsoleCommand("SUPPRESS Log");
        WorldInfo.ConsoleCommand("SUPPRESS ScriptLog");
        WorldInfo.ConsoleCommand("SUPPRESS Warning");
	}

	if (WorldInfo.NetMode == NM_Client || WorldInfo.NetMode == NM_StandAlone)
	{
		SetTimer(0.5f, false, 'SetupConfig');
		SetTimer(1.0f, false, 'SendPickupInfo');
	}
}

reliable client simulated function SetupConfig()
{
	local bool bChanged;

	if(IniVer < 4)
	{
		IniVer = 4;
		LargeKillSound = false;
		LargeKillTicker = false;
		HideDualPistol = false;
		DisablePickUpOthers = false;
		DropLocked = false;
		DisablePickUpLowAmmo = false;
		bChanged = true;
	}

	if(IniVer < 5)
	{
		IniVer = 5;
		DropItem = false;
		bChanged = true;
	}

	if(IniVer < 6)
	{
		IniVer = 6;
		WaveEndStats = false;
		bChanged = true;
	}

	if(IniVer < 7)
	{
		IniVer = 7;
		bChanged = true;
	}

	if(bChanged)
	{
		SaveConfig();
		SetTimer(1.f, false, 'ShowUpdateOverview');
		SetTimer(1.f, false, 'AnnounceCDNEW');
	}
}

function DelayedInitialization()
{
	ClientMessage("[CD] \"!cdh\"でHELPが開けます", 'CDEcho');
	SynchSettings();
	SetupAuthList();
}

reliable server function SynchSettings()
{
	CD_Survival(WorldInfo.Game).SynchSettings(self);
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

function NotifyUniqueSettings()
{
	ClientMessage("CAUTION! You should check settings.", 'UMEcho');
}

function ShowUpdateOverview(){ ShowConnectionProgressPopup(PMT_AdminMessage,"Update Overview", UpdateOverview); }
function AnnounceCDNEW(){ ClientMessage("[CD] \"!cdnew\" shows update overview.", 'CDEcho'); }

reliable client event TeamMessage( PlayerReplicationInfo PRI, coerce string S, name Type, optional float MsgLifeTime  )
{
	local bool b;
	local int MessageChars, MessageLines;
	local array<string> Tokens;

	if(Type == 'Console')
	{
		LocalPlayer(Player).ViewportClient.ViewportConsole.OutputText("[ControlledDifficulty Server Message]\n  " $ Repl(S, "\n", "\n  "));
		S = "[See Console]";
	}

	// Messages from CD bypass the usual chat display code
	if ( S != "" && GetColorbyType(Type) != "" )
	{

		LocalPlayer(Player).ViewportClient.ViewportConsole.OutputText("[ControlledDifficulty Server Message]\n  " $ Repl(S, "\n", "\n  "));

		MessageChars = Len(s);

		ParseStringIntoArray( S, Tokens, "\n", false );
		MessageLines = Tokens.Length;

		if ( MessageLines > ChatLineThreshold )
		{
			S = "[See Console]";
			`cdlog( "chatdebug: Squelching chat message with lines=" $ MessageLines, ClientLogging );
		} 
		else
		{
			`cdlog( "chatdebug: Displaying chat message with lines=" $ MessageLines, ClientLogging );
		}

		if ( MessageChars > ChatCharThreshold )
		{
			S = "[See Console]";
			`cdlog( "chatdebug: Squelching chat message with charlength=" $ MessageChars, ClientLogging );
		} 
		else
		{
			`cdlog( "chatdebug: Displaying chat message with charlength=" $ MessageChars, ClientLogging );
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

	else if(HideMessage(S))
		return;

	else if(PRI == PlayerReplicationInfo && S == "!cdfs")
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
function bool HideMessage(string S)
{
	local array<String> splitbuf;
	ParseStringIntoArray(S,splitbuf," ",true);

	switch(S)
	{
		case "!ot":
		case "!cdot":
		case "!cdr":
		case "!cdready":
		case "!cdur":
		case "!cdunready":
		case "!cdmystats":
		case "!cdms":
		case "!cdinfo":
		case "!xdl":
		case "!deleterecord":
		case "!tdd":
			return true;
	}
	switch(splitbuf[0])
	{	
		case "!cdstats":
		case "!xrid":
			return true;
	}
	return false;
}

/* ==============================================================================================================================
 *	RPW
 * ============================================================================================================================== */

function StartJudge(){ SetTimer(0.1f, true, 'JudgePlayers'); }

function JudgePlayers()
{
	local Weapon CurWeapon;

	if( PlayerReplicationinfo != none &&
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
	GetCDPRI().DmgD = Max(MatchStats.TotalDamageDealt + PWRI.VectData1.Z, GetCDPRI().DmgD);
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
			ShowConnectionProgressPopup(PMT_ConnectionFailure,"Level Restriction", "Required level 25");

		if(!TrySwitchPerk())
			TryExterminate();

		bRestrict = true;
	}

	//	PerkRestriction
	else if(IsRestrictedPerk(Perk))
	{
		if(!bRestrict)
			ShowConnectionProgressPopup(PMT_ConnectionFailure,"Perk Restriction", "You are not authorized to use " $ Mid(string(Perk), 7));
		
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
		RestrictMessage $= " is banned.";
		ShowConnectionProgressPopup(PMT_AdminMessage,"Skill Restriction", RestrictMessage);	
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
	s = Perk.default.PerkSkills[SkillIdx].Name;
	s $= "(Lv"$(5*((SkillIdx/2)+1));
	s $= ( SkillIdx%2 == 0 ) ? "L" : "R";
	s $= ")";
	return s;
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
	local bool bBossWave, bIsDoshinegun;
	local KFGameReplicationInfo KFGRI;
	local KFAutoPurchaseHelper KFAPH;

	KFGRI = KFGameReplicationInfo(WorldInfo.GRI);

	WeapDefClass = class'CD_Object'.static.GetWeapDef(KFWeapon(Weap));
	bBossWave = (KFGRI.WaveNum == KFGRI.WaveMax) || (KFGRI.WaveNum == KFGRI.WaveMax - 1 && KFGRI.bTraderIsOpen);
	bIsDoshinegun = CustomWeap_AssaultRifle_Doshinegun(Weap) != none;

	if( !IsAllowedWeapon(WeapDefClass, bBossWave, false, bIsDoshinegun) )
	{
		KFAPH = GetPurchaseHelper();

		for(i=0; i<KFAPH.OwnedItemList.length; ++i)
		{
			if(KFAPH.OwnedItemList[i].DefaultItem.ClassName == Weap.Class.name)
				break;
		}
		ForceToSellWeap(KFAPH.OwnedItemList[i].DefaultItem, Weap);
		ShowMessageBar('Priority', "Weapon Restriction", Weap.ItemName $ " is automatically sold!");
	}
}

function bool IsAllowedWeapon(class<KFWeaponDefinition> WeapDef, bool bBossWave, bool bForTrader, bool bIsDoshinegun)
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

/* ==============================================================================================================================
 *	Server functions
 * ============================================================================================================================== */

reliable server function ToggleRole()
{
	local CD_Survival CD;

	CD = CD_Survival(WorldInfo.Game);

	//	judge capacity
	if( WorldInfo.Game.AtCapacity(!PlayerReplicationInfo.bOnlySpectator, PlayerReplicationInfo.UniqueId) )
	{
		CD.BroadcastRPWEcho("ERROR: Server is at capacity");
		return;
	}

	//	for active players
	if(!PlayerReplicationInfo.bOnlySpectator)
	{
	  if(Pawn != none)
	  {
	      ServerSuicide();
	      Pawn.Destroy();
	  }
	}
   
   //	for everyone
	if(Role == ROLE_Authority)
	{
		//	spectators
		if(!PlayerReplicationInfo.bOnlySpectator)
		{
		   if(WorldInfo.Game.NumSpectators != WorldInfo.Game.MaxSpectators)
			{
			    GotoState('Spectating');
			    PlayerReplicationInfo.bOnlySpectator = true;
			    PlayerReplicationInfo.bIsSpectator = true;
			    PlayerReplicationInfo.bOutOfLives = true;
			    -- WorldInfo.Game.NumPlayers;
			    ++ WorldInfo.Game.NumSpectators;
			    CD.BroadcastCDEcho(PlayerReplicationInfo.GetHumanReadableName() @ "becomes a spectator");
			}
		}

		//	active players
		else
		{
		   PlayerReplicationInfo.bOnlySpectator = false;
		   PlayerReplicationInfo.bReadyToPlay = true;
		   GotoState('PlayerWaiting');
		   ServerRestartPlayer();
		   ServerChangeTeam(0);
		   ++ WorldInfo.Game.NumPlayers;
		   -- WorldInfo.Game.NumSpectators;
		   CD.BroadcastCDEcho(PlayerReplicationInfo.GetHumanReadableName() @ "becomes an active player");
		}

		//	Register change
	//	CD.SetupLoginInfo(int(CD.MatchCount), int(CD.MatchCount), PlayerReplicationInfo.UniqueId, PlayerReplicationInfo.bOnlySpectator);
	}    
}

reliable server function OpenMapVote()
{
	CD_Survival(WorldInfo.Game).xMut.ShowMapVote(Self);
}

unreliable server simulated function AssignAdmin()
{
	CD_Survival(WorldInfo.Game).ServerAssignAdmin(self);
}

reliable server simulated function ServerSendPickupInfo(bool bDisableOthers, bool bDropLocked, bool bDisableLow)
{
	CD_Survival(WorldInfo.Game).ReceivePickupInfo(self, bDisableOthers, bDropLocked, bDisableLow);
}

reliable server simulated function PrepareOpenMenu()
{
	CD_Survival(WorldInfo.Game).ServerPrepareOpenMenu(self);
}

reliable server function SetSpawnCycle(string Cycle)
{
    local CD_Survival CD;

    CD = CD_Survival(WorldInfo.Game);
    CD.ChatCommander.RunCDChatCommandIfAuthorized(self, "!cdsc" @ Cycle);
    CD.CDGRI.CDInfoParams.SC = Cycle;
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

/* ==============================================================================================================================
 *	Client functions
 * ============================================================================================================================== */

unreliable client final simulated function ClientOpenURL(string URL){ OnlineSub.OpenURL(URL); }

reliable client simulated function ClientOpenResultMenu(name InitState)
{
	local xUI_ResultMenu Menu;

	Menu = xUI_ResultMenu(Class'KF2GUIController'.Static.GetGUIController(self).OpenMenu(class'xUI_ResultMenu'));
	Menu.CurState = InitState;
}

reliable client simulated function OpenClientMenu()
{
	PrepareOpenMenu();
	SetTimer(0.25f, false, 'DelayedOpenClientMenu');
}

reliable client simulated function OpenCycleMenu()
{
	SetTimer(0.25f, false, 'DelayedOpenCycleMenu');
}

reliable client simulated function OpenAdminMenu()
{
	PrepareOpenMenu();
	SetTimer(0.25f, false, 'DelayedOpenAdminMenu');
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
		ClientPlaySound(SoundCue'CombinedSound.LargeKillSoundCue');
}

unreliable client simulated function PlayPlayerDeathSound()
{
	if(PlayerDeathSound)
		ClientPlaySound(SoundCue'CombinedSound.DeathSound');
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
    	CD_GFxHudWrapper(myHUD).MyStats = Msg;
    	CD_GFxHudWrapper(myHUD).ReceivedTime = WorldInfo.TimeSeconds;
    }
}

unreliable client simulated function ReceiveWaveEndStats(string Msg)
{
	if(WaveEndStats)
	{
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

/* ==============================================================================================================================
 *	Other functions
 * ============================================================================================================================== */

unreliable client function ShowMessageBar(name Type, string Text1, optional string Text2)
{
	local KFGFxMoviePlayer_HUD GMPH;

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

function ShowLevelUpNotify(string Title, string Main, string Secondary, string ImagePath, bool bShowSecondary, optional int NumericValue = -1)
{
	MyGFxHUD.LevelUpNotificationWidget.ShowAchievementNotification(Title, Main, Secondary, ImagePath, bShowSecondary, NumericValue);
}

simulated function DelayedOpenClientMenu()
{
	Class'KF2GUIController'.Static.GetGUIController(self).OpenMenu(class'xUI_ClientMenu');
}

simulated function DelayedOpenCycleMenu()
{
	Class'KF2GUIController'.Static.GetGUIController(self).OpenMenu(class'xUI_CycleMenu');
}

simulated function DelayedOpenAdminMenu()
{
	Class'KF2GUIController'.Static.GetGUIController(self).OpenMenu(class'xUI_AdminMenu');
}

function SendPickupInfo()
{
	ServerSendPickupInfo(DisablePickUpOthers, DropLocked, DisablePickUpLowAmmo);
}


/* ==============================================================================================================================
 *	Exec functions
 * ============================================================================================================================== */

exec function ClientOption(){ OpenClientMenu(); }

exec function CycleOption(){ OpenCycleMenu(); }

exec function AdminMenu()
{ 
	if(WorldInfo.NetMode == NM_StandAlone || GetCDPRI().AuthorityLevel > 3)
	{
		OpenAdminMenu();
	}
	else
	{
		ClientMessage("You are not authorized to open an admin menu.", 'UMEcho');
	}
}

exec function ImAdmin(){ AssignAdmin(); }

exec function ForceSpawnAI(string ZedName)
{
	if(WorldInfo.NetMode == NM_StandAlone || GetCDPRI().AuthorityLevel > 3)
		CD_Survival(WorldInfo.Game).CD_SpawnZed(ZedName, self);
}

exec function TestSwitchRole()
{
	if(WorldInfo.NetMode == NM_StandAlone || GetCDPRI().AuthorityLevel > 3)
	{
		bSwitchedRole = !bSwitchedRole;
		ToggleRole();
	}
}

exec function AddAuthorityInfo(string SteamID, int AuthorityLevel, optional string UserName)
{
	if(WorldInfo.NetMode == NM_StandAlone || GetCDPRI().AuthorityLevel > 3)
	{
		ServerAddAuthorityInfo(SteamID, AuthorityLevel, UserName);
	}
}

exec function AddCustomStart(int index)
{
	if(WorldInfo.NetMode == NM_StandAlone || GetCDPRI().AuthorityLevel > 3)
		AddPlayerStart(index);
}

exec function RemoveCustomStart(int index)
{
	if(WorldInfo.NetMode == NM_StandAlone || GetCDPRI().AuthorityLevel > 3)
		RemovePlayerStart(index);
}

exec function ClearCustomStart()
{
	if(WorldInfo.NetMode == NM_StandAlone || GetCDPRI().AuthorityLevel > 3)
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

	if(WorldInfo.NetMode == NM_StandAlone || GetCDPRI().AuthorityLevel > 3)
	{
		s = "\n";

		for(i=0; i<AuthorityList.length; i++)
			s $= AuthorityList[i].UserName $ "\n";

		PrintConsole(s);
	}
}

exec function ShowPathNodesNum()
{
	if(WorldInfo.NetMode == NM_StandAlone || GetCDPRI().AuthorityLevel > 3)
		bShowPathNodes = !bShowPathNodes;
}

defaultproperties
{
	MatchStatsClass=class'CombinedCD2.CD_EphemeralMatchStats'
	PurchaseHelperClass=class'CD_AutoPurchaseHelper'

	CDEchoMessageColor="00FF0A"
	RPWEchoMessageColor="FF20B7"
	UMEchoMessageColor="F8FF00"
	SystemMessageColor="0099FF"
	MapVoteMessageColor="00DCCE"
	JudgeDelay=5.f
	DownloadStage=255
	WeapUIInfo=(Perk=class'KFPerk_Commando', WeapDef=class'KFWeapDef_AR15', PageNum=0)

	PerkList.Remove((PerkClass=class'KFPerk_Berserker'))
	PerkList.Remove((PerkClass=class'KFPerk_Demolitionist'))
	PerkList.Remove((PerkClass=class'KFPerk_Firebug'))
	PerkList.Remove((PerkClass=class'KFPerk_Survivalist'))
}

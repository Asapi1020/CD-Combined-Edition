class CD_GameReplicationInfo extends KFGameReplicationInfo;

`include(CD_Log.uci)

var PlayerReplicationInfo FirstCommando;
var PlayerReplicationInfo FirstMedic;

var bool bEnableSolePerksSystem;
var int MaxUpgrade;

var array<string> DebugTexts;

var CDInfoForFrontend CDInfoParams;
var CDInfoForFrontend CDFinalParams;

struct AwardInfo
{
	var string PlayerName;
	var int Value;
};

var AwardInfo DamageDealer, Healer, Precision, Headpopper, ZedSlayer, LargeKiller, HuskKiller, Guardian;

replication
{
	if((Role == ROLE_Authority) && bNetDirty)
		FirstCommando, FirstMedic, bEnableSolePerksSystem, CDInfoParams, CDFinalParams,
		DamageDealer, Healer, Precision, Headpopper, ZedSlayer, LargeKiller, HuskKiller, Guardian,
		MaxUpgrade;
}

simulated function bool ShouldSetBossCamOnBossSpawn()
{
	return false;
}

simulated function bool ShouldSetBossCamOnBossDeath()
{
	return false;
}

simulated function LogoutCheck(PlayerController PC)
{
	if(PC.PlayerReplicationInfo == FirstCommando)
		FirstCommando = none;

	if(PC.PlayerReplicationInfo == FirstMedic)
		FirstMedic = none;
}

//	Return if Allowed
function bool ControlSolePerks(KFPlayerController KFPC, class<KFPerk> Perk)
{
	local PlayerReplicationInfo PRI;
	local PlayerReplicationInfo SolePRI;

	PRI = KFPC.PlayerReplicationInfo;

	if(Perk == class'KFPerk_Commando') SolePRI = FirstCommando;
	else if(Perk == class'KFPerk_FieldMedic') SolePRI = FirstMedic;
	else return true;

	if(SolePRI != none && SolePRI != PRI && IsValidPRI(SolePRI, Perk))
		return false;
		
	else
	{
		if(Perk == class'KFPerk_Commando') FirstCommando = PRI;
		else if(Perk == class'KFPerk_FieldMedic') FirstMedic = PRI;
	}

	return true;
}

function bool IsValidPRI(PlayerReplicationInfo SolePRI, class<KFPerk> Perk)
{
	local KFPlayerReplicationinfo KFPRI;
	local int i;

	for(i=0; i<PRIArray.Length; i++)
	{
		KFPRI = KFPlayerReplicationInfo(PRIArray[i]);
		if (KFPRI != none && !KFPRI.bOnlySpectator && KFPRI == SolePRI && KFPRI.CurrentPerkClass == Perk &&
			(bMatchHasBegun || KFPRI.bReadyToPlay))
			return true;
	}
	return false;
}

function bool BossWaveComes()
{
	return (WaveNum == WaveMax) || (WaveNum == WaveMax - 1 && bTraderIsOpen);
}

defaultproperties
{
	TraderDialogManagerClass=class'CD_TraderDialogManager'
}
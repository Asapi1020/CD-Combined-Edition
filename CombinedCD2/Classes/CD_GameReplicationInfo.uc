class CD_GameReplicationInfo extends KFGameReplicationInfo;

var PlayerReplicationInfo FirstCommando;
var PlayerReplicationInfo FirstMedic;

var bool bEnableSolePerksSystem;
var int MaxUpgrade;

struct CDInfo
{
	var string SC, MM, CS, SP, WSF, SM, THPF, QPHPF, FPHPF, SCHPF;
	var bool CHSPP;
};
var CDInfo CDInfoParams;
var CDInfo CDFinalParams;

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

defaultproperties
{
	TraderDialogManagerClass=class'CD_TraderDialogManager'
}
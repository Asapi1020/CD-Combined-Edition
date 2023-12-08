class CD_Recorder extends Info
	config( CombinedCD );

`include(CD_Log.uci)
/*
struct SimpleUserInfo
{
	var string ID3;
	var string PlayerName;
};

*/

struct MatchResult
{
	var string TimeStamp;
	var string MapName;
	var string SpawnCycle;
	var string MaxMonsters;
	var string UniqueSettings;
	var int Result;
//	var array<SimpleUserInfo> Team;
};

struct UserStat
{
//	var string PlayerName;
	var float PlayTimeSeconds;
	var int DamageDealt;
	var int DamageTaken;
	var int HeadShots;
	var int ShotsHit;
	var int ShotsFired;
	var int HealGiven;
	var int HealReceived;
	var int Deaths;
	var array<ZedKillType> ZedKillLogs;
	var array<WeaponDamage> WeaponDamageLogs;
	var array<PerkUseNum> PerkUseNumLogs;
	var MatchResult MatchLog;
};

struct StatIDCombo
{
	var string ID;
	var array<UserStat> Stats;
};

var config array<StatIDCombo> UserStats;
//var config array<MatchResult> MatchResults;

var config array<string> CDRecords;
var config int MaxStrage;
var config int IniVer;

var array<PlayerReplicationInfo> SavedPlayers;

public simulated function bool SafeDestroy()
{
	return (bPendingDelete || bDeleteMe || Destroy());
}

public event PreBeginPlay()
{
	if (WorldInfo.NetMode == NM_Client)
	{
		SafeDestroy();
		return;
	}

	super.PreBeginPlay();
}

function PostBeginPlay()
{
	local int i;

	if (bPendingDelete || bDeleteMe) return;

	super.PostBeginPlay();

	InitConfig();

	if(CDRecords.length == MaxStrage)
		CDRecords.RemoveItem(CDRecords[0]);

	else if(CDRecords.length > MaxStrage)
	{
		for(i=0; i<CDRecords.length-MaxStrage; i++)
			CDRecords.RemoveItem(CDRecords[0]);
	}

	SaveConfig();
}

function RegisterRecord(string Record)
{
	CDRecords.AddItem(Record);
	SaveConfig();
}

function InitConfig()
{
	if(IniVer < 1)
	{
		MaxStrage=30;
		IniVer=1;
	}
}
/*
function SaveUserStats(CD_PlayerController CDPC, CD_Survival CD, ResultState RS)
{
	local int i, j;
	local string S;
	local CD_PlayerReplicationInfo CDPRI;
	local CD_EphemeralMatchStats CD_MatchStats;
//	local CD_Survival CD;

	CDPRI = CDPC.GetCDPRI();
	CD_MatchStats = CD_EphemeralMatchStats(CDPC.MatchStats);
//	CD = CD_Survival(Owner);
	S = class'CD_Object'.static.GetSteamID(CDPRI.UniqueId);
	i = UserStats.Find('ID', S);

	if(i == INDEX_NONE)
	{
		UserStats.Add(1);
		i = UserStats.length-1;
		UserStats[i].ID = S;
	}
	else if(SavedPlayers.Find(CDPRI) == INDEX_NONE)
	{
		UserStats[i].Stats.Add(1);
	}
	
	j = UserStats[i].Stats.length-1;

//	UserStats[i].Stats[j].PlayerName = CDPRI.PlayerName;
	UserStats[i].Stats[j].PlayTimeSeconds = CDPRI.PlayTimeSeconds;
	UserStats[i].Stats[j].DamageDealt = CDPC.MatchStats.TotalDamageDealt + CDPC.MatchStats.GetDamageDealtInWave();
	UserStats[i].Stats[j].DamageTaken = CDPC.MatchStats.TotalDamageTaken + CDPC.MatchStats.GetDamageTakenInWave();
	UserStats[i].Stats[j].HeadShots = (CD != none && CD.bCountHeadshotsPerPellet) ? CDPC.ShotsHitHeadshot : ( CDPC.MatchStats.TotalHeadShots + CDPC.MatchStats.GetHeadShotsInWave() );
	UserStats[i].Stats[j].ShotsHit = CDPC.ShotsHit;
	UserStats[i].Stats[j].ShotsFired = CDPC.ShotsFired;
	UserStats[i].Stats[j].HealGiven = CDPC.MatchStats.TotalAmountHealGiven + CDPC.MatchStats.GetHealGivenInWave();
	UserStats[i].Stats[j].HealReceived = CDPC.MatchStats.TotalAmountHealReceived + CDPC.MatchStats.GetHealReceivedInWave();
	UserStats[i].Stats[j].Deaths = CDPRI.Deaths;
	UserStats[i].Stats[j].ZedKillLogs = CDPC.MatchStats.ZedKillsArray;
	UserStats[i].Stats[j].WeaponDamageLogs = CDPC.MatchStats.WeaponDamageList;
	
	if(CD_MatchStats == none)
	{
		`cdlog("CD_EphemeralMatchStats is not found!!! Failed to save Perk data!!!");
	}
	else
	{
		UserStats[i].Stats[j].PerkUseNumLogs = CD_MatchStats.PerkUseNums;
	}

	if(CD == none)
	{
		`cdlog("CD_Survival is not found!!! Failed to save match data!!!");
	}
	else
	{
		UserStats[i].Stats[i].MatchLog.MapName = CD.WorldInfo.GetMapName(true);
		UserStats[i].Stats[i].MatchLog.SpawnCycle = CD.SpawnCycle;
		UserStats[i].Stats[i].MatchLog.MaxMonsters = CD.MaxMonsters;
		UserStats[i].Stats[i].MatchLog.UniqueSettings = CD.SearchUniqueSettings();
		UserStats[i].Stats[i].MatchLog.Result = RS;
	}
	
	SaveConfig();
	SavedPlayers.AddItem(CDPRI);
}
*/
//	======================================================
//	 To share the same struct in multiple classes easily
//	======================================================

class xStructHolder extends Object;

struct FMapEntry
{
	var string MapName,MapTitle;
	var int UpVotes,DownVotes,Sequence,NumPlays,History;
};

struct FVotedMaps
{
	var int GameIndex,MapIndex,NumVotes;
};

struct UserInfo
{
	var string UserName;
	var string SteamID;
	var int AuthorityLevel;
};

struct CD_WeaponInfo
{
	var class<KFWeaponDefinition> WeapDef;
	var int RequiredLevel;
	var bool bOnlyForBoss;
	var bool bNotInTrader;
};

struct CD_SkillInfo
{
	var class<KFPerk> Perk;
	var int Skill;
};

struct CD_PerkInfo
{
	var class<KFPerk> Perk;
	var int RequiredLevel;
};


struct PerkUseNum
{
	var class<KFPerk> Perk;
	var int Num;
};

struct LoadoutInfo
{
	var class<KFPerk> Perk;
	var array< class<KFWeaponDefinition> > WeapDef;
};

struct CDInfo
{
	var string SC, ZTSM;
	var int MM, CS, WSF, THPF, QPHPF, FPHPF, SCHPF;
	var float SP, SM, ZTSSD;
	var bool AA, AC, AG, DR, DS, FPRS, SWFA, SWFAR, SWFG, ZTC;
};

struct CDInfoForFrontend
{
	var string SC, MM, CS, SP, WSF, SM, THPF, QPHPF, FPHPF, SCHPF;
	var string ZTSM, ZTSSD, AA, AC, AG, DR, DS, FPRS, SWFA, SWFAR, SWFG, ZTC;
	var bool CHSPP;
};

struct MatchInfo
{
	var string TimeStamp;
	var string MapName;
	var string ServerName, ServerIP;
	var CDInfo CI;
	var bool bVictory;
	var byte DefeatWave;
	var array<string> CheatMessages, Mutators;
	var bool bSolo;
};

struct UserStats
{
	var string PlayerName, ID, Perk;
	var float PlayTime;
	var int DamageDealt, DamageTaken, HealsGiven, HealsReceived, DoshEarned, ShotsFired, ShotsHit, HeadShots, Deaths, Kills, LargeKills;
	var array<WeaponDamage> WeaponDamageList;
	var array<ZedKillType> ZedKillsArray;
};

struct CDSettingCond
{
	var array<int> MinMM;
	var array<int> MinWSF;
	var int MinHPFakes;
	var float MaxSP;
	var float MaxSM;
	var int MinCS;

	structdefaultproperties
	{
		MinMM=(16,24,32,36,40,44)
		MinWSF=(2,3,5,6,8,9)
		MinHPFakes=6
		MaxSP=1.0
		MaxSM=0.0
		MinCS=4
	}
};
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
	var string SC, MM, CS, SP, WSF, SM, THPF, QPHPF, FPHPF, SCHPF;
	var bool CHSPP;
};
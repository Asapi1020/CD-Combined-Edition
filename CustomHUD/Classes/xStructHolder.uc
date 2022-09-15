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
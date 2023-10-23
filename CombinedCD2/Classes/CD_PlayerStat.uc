class CD_PlayerStat extends Object;

struct WeapDmgStruct
{
	var string WeapDefPath;
	var int Dmg;
	var int HS;
	var int LargeKills;
	var int Kills;
};

var int RecentSaveVer;
var array<int> CompletedAchievements;

var array<WeapDmgStruct> WeaponDamageList;
var array<ZedKillType> ZedKillsArray;

const StatFileDir = "../../KFGame/Script/CD_PlayerStat.usa";
const CurrentSaveVer = 0;

final function bool LoadStatFile()
{
	FlushData();
	return Class'Engine'.Static.BasicLoadObject(Self, StatFileDir, false, CurrentSaveVer);
}

final function SaveStatFile()
{
	Class'Engine'.Static.BasicSaveObject(Self, StatFileDir, false, CurrentSaveVer);
	RecentSaveVer = CurrentSaveVer;
}

function FlushData()
{
	RecentSaveVer = 0;
	CompletedAchievements.length = 0;
	WeaponDamageList.length = 0;
	ZedKillsArray.length = 0;
}

function SetWeapDmgData(WeaponDamage WeapDmg)
{
	local int i;

	i = WeaponDamageList.Find('WeapDefPath', PathName(WeapDmg.WeaponDef));

	if(i == INDEX_NONE)
	{
		i = WeaponDamageList.length;
		WeaponDamageList.Add(1);
		WeaponDamageList[i].WeapDefPath = PathName(WeapDmg.WeaponDef);
	}

	WeaponDamageList[i].Dmg			+= WeapDmg.DamageAmount;
	WeaponDamageList[i].HS			+= WeapDmg.HeadShots;
	WeaponDamageList[i].LargeKills	+= WeapDmg.LargeZedKills;
	WeaponDamageList[i].Kills		+= WeapDmg.Kills;
}
class CD_PlayerStat extends Object;

`include(CD_Log.uci);

struct WeapDmgStruct
{
	var array<byte> Key;
	var WeaponDamage WeapDmg;
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

function PackString(out string S, out array<byte> Bytes)
{
	local int i;

	Bytes.length = 0;
	
	for(i=0; i<Len(S); i++)
	{
		Bytes.AddItem(Asc(Mid(S, i, 1)));
	}
}

function UnpackString(out string S, out array<byte> Bytes)
{
	local int i;
	local array<string> splitbuf;

	for(i=0; i<Bytes.length; i++)
	{
		splitbuf.AddItem(Chr(Bytes[i]));
	}

	JoinArray(splitbuf, S, "");
}

function SetWeapDmgData(WeaponDamage WD)
{
	local int i;
	local array<byte> Bytes;
	local string s;

	for(i=WeaponDamageList.length-1; i>INDEX_NONE; i--)
	{
		if(WeaponDamageList[i].WeapDmg.WeaponDef == WD.WeaponDef)
			break;
	}

	if(i == INDEX_NONE)
	{
		i = WeaponDamageList.length;
		WeaponDamageList.Add(1);
		WeaponDamageList[i].WeapDmg.WeaponDef = WD.WeaponDef;
		s = PathName(WD.WeaponDef);
		PackString(s, Bytes);
		WeaponDamageList[i].Key = Bytes;
	}
	else
	{
		Bytes = WeaponDamageList[i].Key;
		UnpackString(s, Bytes);
		if(PathName(WD.WeaponDef) != s)
		{
			`cdlog("BROKEN DATA DETECTED");
			WeaponDamageList.length=0;
			SetWeapDmgData(WD);
			return;
		}
	}

	WeaponDamageList[i].WeapDmg.DamageAmount	+= WD.DamageAmount;
	WeaponDamageList[i].WeapDmg.HeadShots		+= WD.HeadShots;
	WeaponDamageList[i].WeapDmg.LargeZedKills	+= WD.LargeZedKills;
	WeaponDamageList[i].WeapDmg.Kills			+= WD.Kills;
}
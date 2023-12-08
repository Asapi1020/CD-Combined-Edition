class CD_PlayerStat extends Object;

`include(CD_Log.uci);
`include(CD_General.uci);
`include(CD_Secret.uci); // This file is hidden because of security

struct Data_A
{
	var string Data_0;
	var string Data_1;
};

struct Data_B
{
	var string Data_0;
	var string Data_1;
};

var int RecentSaveVer;
var private array<int>		Data_00;
var private array<Data_A>	Data_01;
var private array<Data_B>	Data_02;
var private string			Data_03;
var private array<string>	Data_04;
var private string			Data_05;

const StatFileDir = "../../KFGame/Script/CD_PlayerStat.usa";
const CurrentSaveVer = 0;

/** Data Handle Base **/

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
	Data_00.length = 0;
	Data_01.length = 0;
	Data_02.length = 0;
	Data_03 = "";
	Data_04.length = 0;
	Data_05 = "";
}

static function string Encode(string S)
{
	local int i, l, index;
	local byte b;
	local string Binary, result;
	local array<string> HexBit;

	Binary = "";
	result = "";

	for(i=0; i<Len(S); i++)
	{
		b = Asc(Mid(S, i, 1));
		Binary $= class'CD_Object'.static.ByteToBinary(b);
	}

	for(i=0; i<Len(Binary); i+=6)
	{
		HexBit.AddItem(Mid(Binary, i, 6));
	}

	l = Len(HexBit[HexBit.length-1]);
	for(i=0; i<(6-l); i++)
	{
		HexBit[HexBit.length-1] $= "0";
	}

	for(i=0; i<HexBit.length; i++)
	{
		index = class'CD_Object'.static.BinaryToInt(HexBit[i]);
		result $= Mid(`CODE_KEY, index, 1);
	}

	`cdlog("Encode=" $ result);
	return result;
}

static function string Decode(string s)
{
	local int i, index;
	local string HexBit, result;
	local array<string> Binary;

	HexBit = "";
	result = "";

	for(i=0; i<Len(s); i++)
	{
		index = InStr(`CODE_KEY, Mid(s, i, 1));
		HexBit $= class'CD_Object'.static.ByteToBinary(index, 6);
	}

	for(i=0; i<Len(HexBit)-7; i+=8)
	{
		Binary.AddItem(Mid(HexBit, i, 8));
	}

	for(i=0; i<Binary.length; i++)
	{
		result $= Chr(class'CD_Object'.static.BinaryToInt(Binary[i]));
	}

	return result;
}

static function string StringAdd(string s, int i)
{
	return string(i+int(s));
}

static function string StringAddFloat(string s, float f)
{
	return string(f + float(s));
}

/** Data Handle Contents **/

function SaveStats(CD_PlayerController CDPC, MatchInfo MI)
{
	local int i, index;
	local array<string> TempData;

	// Weapon Damage
	for(i=0; i<Data_01.length; i++)
	{
		TempData.AddItem(Decode(Data_01[i].Data_0));
	}
	for(i=0; i<CDPC.MatchStats.WeaponDamageList.length; i++)
	{
		index = TempData.Find(PathName(CDPC.MatchStats.WeaponDamageList[i].WeaponDef));
		SetWeapDmgData(CDPC.MatchStats.WeaponDamageList[i], index);
	}

	// Zed Kills
	TempData.length = 0;
	for(i=0; i<Data_02.length; i++)
	{
		TempData.AddItem(Decode(Data_02[i].Data_0));
	}
	for(i=0; i<CDPC.MatchStats.ZedKillsArray.length; i++)
	{
		index = TempData.Find(PathName(CDPC.MatchStats.ZedKillsArray[i].MonsterClass));
		SetZedKillsData(CDPC.MatchStats.ZedKillsArray[i], index);
	}

	// Match Record
	if(MI.ResultState > `RS_LEAVE)
		SetMatchRec(MI);

	// Ephemeral Stats
	SetEphStats(CDPC);
}

function SetWeapDmgData(WeaponDamage WD, int i)
{
	local string s;
	local array<string> values;

	s = PathName(WD.WeaponDef);

	if(i == INDEX_NONE)
	{
		i = Data_01.length;
		Data_01.Add(1);
		Data_01[i].Data_0 = Encode(s);
		s = "0,0,0,0";
	}
	else
	{
		s = Decode(Data_01[i].Data_1);
	}

	ParseStringIntoArray(s, values, ",", false);
	values[0] = StringAdd(values[0], WD.DamageAmount);
	values[1] = StringAdd(values[1], WD.HeadShots);
	values[2] = StringAdd(values[2], WD.LargeZedKills);
	values[3] = StringAdd(values[3], WD.Kills);
	JoinArray(values, s);
	Data_01[i].Data_1 = Encode(s);
}

function SetZedKillsData(ZedKillType ZKT, int i)
{
	local string s;

	s = PathName(ZKT.MonsterClass);

	if(i == INDEX_NONE)
	{
		i = Data_02.length;
		Data_02.Add(1);
		Data_02[i].Data_0 = Encode(s);
		s = "0";
	}
	else
	{
		s = Decode(Data_02[i].Data_1);
	}

	s = string(ZKT.KillCount + int(s));
	Data_02[i].Data_1 = Encode(s);
}

function SetPerkUseNum(int index)
{
	local int i, L;
	local string s;
	local array<string> values;

	L = class'CD_PlayerController'.default.PerkList.length;

	if(index >= L)
	{
		`cdlog("Failed to save perk use num because of invalid perk index!");
		return;
	}

	s = Decode(Data_03);
	ParseStringIntoArray(s, values, ",", false);

	for(i=values.length; i < L; i++)
	{
		values.AddItem("0");
	}

	values[index] = StringAdd(values[index], 1);
	JoinArray(values, s);
	Data_03 = Encode(s);
}

function SetMatchRec(MatchInfo MI)
{
	local string s;
	local array<string> TempData;

	TempData.AddItem(MI.TimeStamp);
	TempData.AddItem(string(MI.PlayerNum));
	TempData.AddItem(MI.CI.SC);
	TempData.AddItem(MI.CI.MM);
	TempData.AddItem(MI.CI.CS);
	TempData.AddItem(MI.CI.SP);
	TempData.AddItem(MI.CI.WSF);
	TempData.AddItem(MI.CI.SM);
	TempData.AddItem(MI.CI.THPF);
	TempData.AddItem(MI.CI.QPHPF);
	TempData.AddItem(MI.CI.FPHPF);
	TempData.AddItem(MI.CI.SCHPF);
	TempData.AddItem(MI.CI.ZTSM);
	TempData.AddItem(MI.CI.ZTSSD);
	TempData.AddItem(MI.CI.AA);
	TempData.AddItem(MI.CI.AC);
	TempData.AddItem(MI.CI.AG);
	TempData.AddItem(MI.CI.DR);
	TempData.AddItem(MI.CI.DS);
	TempData.AddItem(MI.CI.FPRS);
	TempData.AddItem(MI.CI.SWFA);
	TempData.AddItem(MI.CI.SWFAR);
	TempData.AddItem(MI.CI.SWFG);
	TempData.AddItem(MI.CI.ZTC);
	if(MI.ResultState == `RS_WIN) TempData.AddItem("0");
	else TempData.AddItem(string(MI.DefeatWave));
	JoinArray(TempData, s);

	Data_04.AddItem(Encode(s));
}

function SetEphStats(CD_PlayerController CDPC)
{
	local bool CHSPP;
	local CD_GameReplicationInfo CDGRI;
	local string s;
	local array<string> values;
	local int i;

	CDGRI = CDPC.GetCDGRI();
	CHSPP = CDGRI.bMatchIsOver ? CDGRI.CDFinalParams.CHSPP : CDGRI.CDInfoParams.CHSPP;

	s = Decode(Data_05);
	ParseStringIntoArray(s, values, ",", false);

	for(i=values.length; i < 12; i++)
	{
		values.AddItem("0");
	}

	values[0] = StringAdd(values[0], CDPC.ShotsFired);
	values[1] = StringAdd(values[1], CDPC.ShotsHit);
	values[2] = StringAdd(values[2], (CHSPP ? CDPC.ShotsHitHeadshot : (CDPC.MatchStats.TotalHeadShots + CDPC.MatchStats.GetHeadShotsInWave())));
	values[3] = StringAdd(values[3], CDPC.MatchStats.TotalDoshEarned + CDPC.MatchStats.GetDoshEarnedInWave());
	values[4] = StringAdd(values[4], CDPC.MatchStats.TotalDamageDealt + CDPC.MatchStats.GetDamageDealtInWave());
	values[5] = StringAdd(values[5], CDPC.MatchStats.TotalDamageTaken + CDPC.MatchStats.GetDamageTakenInWave());
	values[6] = StringAdd(values[6], CDPC.MatchStats.TotalAmountHealGiven + CDPC.MatchStats.GetHealGivenInWave());
	values[7] = StringAdd(values[7], CDPC.MatchStats.TotalAmountHealReceived + CDPC.MatchStats.GetHealReceivedInWave());
	values[8] = StringAdd(values[8], CDPC.GetCDPRI().Deaths);
	values[9] = StringAdd(values[9], CDPC.GetCDPRI().Kills);
	values[10]= StringAdd(values[10],CDPC.MatchStats.TotalLargeZedKills);
	values[11]= StringAddFloat(values[11], CDPC.WorldInfo.TimeSeconds);
	JoinArray(values, s);
	Data_05 = Encode(s);
}

function LogData()
{
	local int i;

	for(i=0; i<Data_01.length; i++)
	{
		`cdlog(Decode(Data_01[i].Data_0) $ ":" @ Decode(Data_01[i].Data_1));
	}

	for(i=0; i<Data_02.length; i++)
	{
		`cdlog(Decode(Data_02[i].Data_0) $ ":" @ Decode(Data_02[i].Data_1));
	}

	`cdlog(Decode(Data_03));

	for(i=0; i<Data_04.length; i++)
	{
		`cdlog(Decode(Data_04[i]));
	}
	`cdlog(Decode(Data_05));
}

defaultproperties
{

}
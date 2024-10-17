class CD_Object extends Object
	abstract;

static function class<KFWeaponDefinition> GetWeapDef(KFWeapon Weap)
{
	return class<KFDamageType>(Weap.class.default.InstantHitDamageTypes[3]).default.WeaponDef;
}

static function class<Weapon> GetWeapClass(class<KFWeaponDefinition> Def)
{
	return class<Weapon>(DynamicLoadObject(Def.default.WeaponClassPath, class'Class'));
}

static function string GetWeapName(class<KFWeaponDefinition> Def){
	if(ClassIsChildOf(Def, Class'KFGame.KFWeapDef_Knife_Base')){
		return class'KFGame.KFGFxPostGameContainer_PlayerStats'.default.KnifeString;
	}

	if(InStr(PathName(Def), "KFWeapDef_Grenade_") > 0){
		return ParseLocalizedPropertyPath(Def.default.WeaponClassPath $ ".ItemName");
	}

	return class'CD_Object'.static.GetWeapClass(Def).default.ItemName;
}

static final function Object SafeLoadObject(string S, Class ObjClass)
{
    local Object O;

    O = FindObject(S, ObjClass);
    return ((O != none) ? O : DynamicLoadObject(S, ObjClass));
}

static function string GetSteamID(UniqueNetId ID)
{
	local string SteamIdHexString;
	local int SteamIdAccountNumber;

	SteamIdHexString = class'OnlineSubsystem'.static.UniqueNetIdToString(ID);
	class'CD_StringUtils'.static.HexStringToInt( Right( SteamIdHexString, 8 ), SteamIdAccountNumber );

	if ( -1 == SteamIdAccountNumber )
		return "Unrecognized";

	return "STEAM_0:" $ string(SteamIdAccountNumber % 2) $ ":" $ string(SteamIdAccountNumber / 2);
}

static function string GetCustomMapName(string MapName)
{
	local string CustomName;

	if(Left(MapName, 3) ~= "KF-")
	{
		CustomName = Localize("CustomMapName", MapName, "CombinedCD2");
		if(Left(CustomName, 1) != "?")
		{
			return CustomName;
		}
		MapName = Mid(MapName, 3);
	}

	return MapName;
}

static function string GetFriendlyMapName(string MapName)
{
	MapName = class'KFCommon_LocalizedStrings'.static.GetFriendlyMapName(MapName);
	MapName = GetCustomMapName(MapName);
	return MapName;
}

static function string AddCommaToInt(int num)
{
	local int i, d;
	local array<string> splitbuf;
	local string s;

	if(num == 0)
	{
		return "0";
	}

	i = 1;
	d = num;
	splitbuf.length = 0;

	while(d>0)
	{
		if(splitbuf.length>0)
		{
			switch(Len(splitbuf[0]))
			{
				case 1:
					splitbuf[0] = "00" $ splitbuf[0];
					break;
				case 2:
					splitbuf[0] = "0" $ splitbuf[0];
					break;
			}
		}
		splitbuf.InsertItem(0, string(d%(1000*i)));
		d /= (1000*i);
		++i;
	}

	JoinArray(splitbuf, s);

	return s;
}

static function int HexToInt(string HexStr)
{
	local int i, multiplier, value;

	HexStr = Locs(HexStr);
	multiplier = 1;
	value = 0;

	for ( i = Len(HexStr)-1 ; 0 <= i ; i-- )
	{
		switch (Mid(HexStr, i, 1))
		{
			case "0": break;
			case "1": value += multiplier; break;
			case "2": value += (multiplier * 2);  break;
			case "3": value += (multiplier * 3);  break;
			case "4": value += (multiplier * 4);  break;
			case "5": value += (multiplier * 5);  break;
			case "6": value += (multiplier * 6);  break;
			case "7": value += (multiplier * 7);  break;
			case "8": value += (multiplier * 8);  break;
			case "9": value += (multiplier * 9);  break;
			case "a": value += (multiplier * 10); break;
			case "b": value += (multiplier * 11); break;
			case "c": value += (multiplier * 12); break;
			case "d": value += (multiplier * 13); break;
			case "e": value += (multiplier * 14); break;
			case "f": value += (multiplier * 15); break;
			default: return -1;
		}

		multiplier *= 16; 
	}

	return value;
}

static function string HexToBinary(string HexStr)
{
	HexStr = Locs(HexStr);
	
	switch(Left(HexStr,1))
	{
		case "0": return "0000";
		case "1": return "0001";
		case "2": return "0010";
		case "3": return "0011";
		case "4": return "0100";
		case "5": return "0101";
		case "6": return "0110";
		case "7": return "0111";
		case "8": return "1000";
		case "9": return "1001";
		case "a": return "1010";
		case "b": return "1011";
		case "c": return "1100";
		case "d": return "1101";
		case "e": return "1110";
		case "f": return "1111";
		default: return "";
	}
}

static function string ByteToBinary(byte b, optional int L=8)
{
	local int i, p, q;
	local string s;

	s = "";
	p = int(b);

	for(i=0; i<L; i++)
	{
		q = p % 2;
		p /= 2;
		s = string(q) $ s;
	}

	return s;
}

static function int BinaryToInt(string Binary)
{
	local int i, r;

	r = 0;

	for(i=0; i<Len(Binary); i++)
	{
		r += int(Mid(Binary, i, 1)) * (2**(Len(Binary)-1-i));
	}

	return r;
}

static function JsonObject GetJsonFromMatchInfo(MatchInfo MI){
	local JsonObject Json;

	Json = new class'JsonObject';
	Json.SetStringValue("timeStamp", MI.TimeStamp);
	Json.SetStringValue("mapName", MI.MapName);
	Json.SetStringValue("serverName", MI.ServerName);
	Json.SetStringValue("serverIP", MI.ServerIP);
	Json.SetBoolValue("isVictory", MI.bVictory);
	Json.SetIntValue("defeatWave", MI.DefeatWave);
	Json.SetStringValue("cheatMessages", ConvertJsonList(MI.CheatMessages));
	Json.SetStringValue("mutators", ConvertJsonList(MI.Mutators));
	Json.SetBoolValue("isSolo", MI.bSolo);
	Json.SetObject("CDInfo", GetJsonFromCDInfo(MI.CI));

	return Json;
}

static function JsonObject GetJsonFromCDInfo(CDInfo CI){
	local JsonObject Json;

	Json = new class'JsonObject';
	Json.SetStringValue("spawnCycle", CI.SC);
	Json.SetIntValue("maxMonsters", CI.MM);
	Json.SetIntValue("cohortSize", CI.CS);
	Json.SetFloatValue("spawnPoll", CI.SP);
	Json.SetFloatValue("waveSizeFakes", CI.WSF);
	Json.SetFloatValue("spawnMod", CI.SM);
	Json.SetIntValue("trashHPFakes", CI.THPF);
	Json.SetIntValue("QPHPFakes", CI.QPHPF);
	Json.SetIntValue("FPHPFakes", CI.FPHPF);
	Json.SetIntValue("SCHPFakes", CI.SCHPF);
	Json.SetStringValue("ZTSpawnMode", CI.ZTSM);
	Json.SetFloatValue("ZTSpawnSlowDown", CI.ZTSSD);
	Json.SetBoolValue("albinoAlphas", CI.AA);
	Json.SetBoolValue("albinoCrawlers", CI.AC);
	Json.SetBoolValue("albinoGorefasts", CI.AG);
	Json.SetBoolValue("disableRobots", CI.DR);
	Json.SetBoolValue("disableSpawners", CI.DS);
	Json.SetBoolValue("fleshpoundRageSpawns", CI.FPRS);
	Json.SetBoolValue("startWithFullAmmo", CI.SWFA);
	Json.SetBoolValue("startWithFullArmor", CI.SWFAR);
	Json.SetBoolValue("startWithFullGrenade", CI.SWFG);
	Json.SetBoolValue("zedsTeleportCloser", CI.ZTC);

	return Json;
}

static function JsonObject GetJsonFromUserStats(UserStats US){
	local JsonObject Json, WeaponDamageJson, ZedKillJson;
	local WeaponDamage WD;
	local ZedKillType ZKT;
	local string WeaponDamageJsonString, ZedKillJsonString;
	local array<string> WeaponDamageJsonStringArray, ZedKillJsonStringArray;

	Json = new class'JsonObject';

	Json.SetStringValue("playerName", US.PlayerName);
	Json.SetStringValue("steamID", US.ID);
	Json.SetStringValue("perkClass", US.Perk);
	Json.SetFloatValue("playTime", US.PlayTime);
	Json.SetIntValue("damageDealt", US.DamageDealt);
	Json.SetIntValue("damageTaken", US.DamageTaken);
	Json.SetIntValue("healsGiven", US.HealsGiven);
	Json.SetIntValue("healsReceived", US.HealsReceived);
	Json.SetIntValue("doshEarned", US.DoshEarned);
	Json.SetIntValue("shotsFired", US.ShotsFired);
	Json.SetIntValue("shotsHit", US.ShotsHit);
	Json.SetIntValue("headShots", US.HeadShots);
	Json.SetIntValue("deaths", US.Deaths);

	foreach US.WeaponDamageList(WD){
		WeaponDamageJson = GetJsonFromWeaponDamage(WD);
		WeaponDamageJsonString = EncodeJsonIncludingList(WeaponDamageJson);
		WeaponDamageJsonStringArray.AddItem(WeaponDamageJsonString);
	}
	Json.SetStringValue("weaponDamages", ConvertJsonList(WeaponDamageJsonStringArray));

	foreach US.ZedKillsArray(ZKT){
		ZedKillJson = GetJsonFromZedKillType(ZKT);
		ZedKillJsonString = EncodeJsonIncludingList(ZedKillJson);
		ZedKillJsonStringArray.AddItem(ZedKillJsonString);
	}
	Json.SetStringValue("zedKills", ConvertJsonList(ZedKillJsonStringArray));

	return Json;
}

static function JsonObject GetJsonFromWeaponDamage(WeaponDamage WD){
	local JsonObject Json;

	Json = new class'JsonObject';
	Json.SetStringValue("weaponDefClass", PathName(WD.WeaponDef));
	Json.SetIntValue("damageAmount", WD.DamageAmount);
	Json.SetIntValue("headShots", WD.Headshots);
	Json.SetIntValue("largeZedKills", WD.LargeZedKills);
	// TODO: ignore kills so far because kills is saved only on client side
	return Json;
}

static function JsonObject GetJsonFromZedKillType(ZedKillType ZKT){
	local JsonObject Json;

	Json = new class'JsonObject';
	Json.SetStringValue("zedClass", PathName(ZKT.MonsterClass));
	Json.SetIntValue("killCount", ZKT.KillCount);

	return Json;
}

static function JsonObject GetJsonForRecord(MatchInfo MI, array<UserStats> USArray){
	local JsonObject Json, MatchInfoJson, UserStatsJson;
	local UserStats US;
	local string UserStatsJsonString;
	local array<string> UserStatsJsonStringArray;

	Json = new class'JsonObject';
	
	MatchInfoJson = GetJsonFromMatchInfo(MI);
	Json.SetObject("matchInfo", MatchInfoJson);

	foreach USArray(US){
		UserStatsJson = GetJsonFromUserStats(US);
		UserStatsJsonString = EncodeJsonIncludingList(UserStatsJson);
		UserStatsJsonStringArray.AddItem(UserStatsJsonString);
	}
	Json.SetStringValue("userStats", ConvertJsonList(UserStatsJsonStringArray));

	return Json;
}

static function string ConvertJsonList(array<string> JsonStringArray){
	local string ListString;
	JoinArray(JsonStringArray, ListString);
	return "[" $ ListString $ "]";
}

static function string EncodeJsonIncludingList(JsonObject decoded){
	local string encoded;

	encoded = class'JsonObject'.static.EncodeJson(decoded);
	encoded = Repl(encoded, "\"[", "[");
	encoded = Repl(encoded, "]\"", "]");
	return encoded;
}
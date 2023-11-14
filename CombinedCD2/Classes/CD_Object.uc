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
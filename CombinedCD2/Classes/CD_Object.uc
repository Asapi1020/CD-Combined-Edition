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


class CD_BasicSetting_Boss extends CD_BasicSetting
	within CD_Survival;

protected function string ReadIndicator()
{
	return Outer.Boss; 
}

protected function WriteIndicator( const out string Val )
{
	Outer.Boss = Val; 

	if ( IsVolterBossString( Outer.Boss ) )
	{
		BossEnum = CDBOSS_VOLTER;
	}
	else if ( IsPatriarchBossString( Outer.Boss ) )
	{
		BossEnum = CDBOSS_PATRIARCH;
	}
	else if ( IsKingFleshpoundBossString( Outer.Boss ) )
	{
		BossEnum = CDBOSS_KINGFLESHPOUND;
	}
	else if ( IsKingBloatBossString( Outer.Boss ) )
	{
		BossEnum = CDBOSS_KINGBLOAT;
	}
	else if ( IsMatriarchBossString( Outer.Boss ) )
	{
		BossEnum = CDBOSS_MATRIARCH;
	}
	else if ( IsAllBossString( Outer.Boss ) )
	{
		BossEnum = CDBOSS_ALL;
	}
	else if ( IsCystBossString( Outer.Boss ) )
	{
		BossEnum = CDBOSS_CYST;
	}
	else
	{
		BossEnum = CDBOSS_RANDOM;
	}
}

protected function string SanitizeIndicator( const string Raw )
{
	if ( !IsValidBossString( Raw ) )
	{
		return DefaultSettingIndicator;
	}

	return Raw;
}

private static function bool IsValidBossString( const out string bs )
{
	return IsRandomBossString(bs) 	 || IsPatriarchBossString(bs) 	   ||
		   IsVolterBossString(bs)	 || IsKingFleshpoundBossString(bs) ||
		   IsKingBloatBossString(bs) || IsMatriarchBossString(bs)      ||
		   IsAllBossString(bs)  	 || IsCystBossString(bs);
}

private static function bool IsRandomBossString( const out string s )
{
	return s == "" || s ~= "random" || s ~= "unmodded";
}

private static function bool IsPatriarchBossString( const out string s )
{
	return s ~= "patriarch" || s~= "patty" || s ~= "pat";
}

private static function bool IsVolterBossString( const out string s )
{
	return s ~= "hans" || s ~= "volter" || s ~= "moregas";
}

private static function bool IsKingFleshpoundBossString( const out string s )
{
	return s ~= "kfp" || s ~= "kingfleshpound" || s ~= "kingfp";
}

private static function bool IsKingBloatBossString( const out string s )
{
	return s ~= "kb" || s ~= "kingbloat" || s ~= "abomination" || s ~= "abom";
}

private static function bool IsMatriarchBossString( const out string s )
{
	return s ~= "matriarch" || s ~= "mat" ;
}

private static function bool IsAllBossString( const out string s )
{
	return s ~= "all";
}

private static function bool IsCystBossString( const out string s )
{
	return s ~= "cyst" || s ~= "cy" ;
}

defaultproperties
{
	OptionName="Boss"
	DefaultSettingIndicator="all"

	ChatCommandNames=("!cdboss")
	ChatWriteParamHints=("volter|patriarch|kfp|abomination|matriarch|random|all")
}

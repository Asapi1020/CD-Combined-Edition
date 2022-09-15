class CD_BasicSetting_BossDifficulty extends CD_BasicSetting
	within CD_Survival;

protected function string ReadIndicator()
{
	return Outer.BossDifficulty;
}

protected function WriteIndicator( const out string Val )
{
	Outer.BossDifficulty = Val; 
	Outer.BossDifficultyInt = Clamp( int(Val), 0, 3 );
}

protected function string SanitizeIndicator( const string Raw )
{
	return string( Clamp(int(Raw), 0, 3) );
}

defaultproperties
{
	OptionName="BossDifficulty"
	DefaultSettingIndicator="0"

	ChatCommandNames=("!cdbossdifficulty","!cdbd")
	ChatWriteParamHints=("int index")
}


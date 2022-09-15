class CD_BasicSetting_DisableBossMinions extends CD_BasicSetting
	within CD_Survival;

protected function string ReadIndicator()
{
	return Outer.DisableBossMinions;
}

protected function WriteIndicator( const out string Val )
{
	Outer.DisableBossMinions = Val; 
	Outer.bDisableBossMinions = bool( Val );
}

protected function string SanitizeIndicator( const string Raw )
{
	return string( bool( Raw ) );
}

defaultproperties
{
	OptionName="DisableBossMinions"
	DefaultSettingIndicator="true"

	ChatCommandNames=("!cddisablebossminions","!cddbm")
	ChatWriteParamHints=("true|false")
}

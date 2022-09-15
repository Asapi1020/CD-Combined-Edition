class CD_BasicSetting_DisableBoss extends CD_BasicSetting
	within CD_Survival;

protected function string ReadIndicator()
{
	return Outer.DisableBoss;
}

protected function WriteIndicator( const out string Val )
{
	Outer.DisableBoss = Val; 
	Outer.bDisableBoss = bool( Val );
}

protected function string SanitizeIndicator( const string Raw )
{
	return string( bool( Raw ) );
}

defaultproperties
{
	OptionName="DisableBoss"
	DefaultSettingIndicator="true"

	ChatCommandNames=("!cddisableboss","!cddb")
	ChatWriteParamHints=("true|false")
}

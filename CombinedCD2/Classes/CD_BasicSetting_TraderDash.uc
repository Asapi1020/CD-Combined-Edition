class CD_BasicSetting_TraderDash extends CD_BasicSetting
	within CD_Survival;

protected function string ReadIndicator()
{
	return Outer.TraderDash;
}

protected function WriteIndicator( const out string Val )
{
	Outer.TraderDash = Val;
	Outer.bTraderDash = bool( Val );
}

protected function string SanitizeIndicator( const string Raw )
{
	return string( bool( Raw ) );
}

defaultproperties
{
	OptionName="TraderDash"
	DefaultSettingIndicator="true"

	ChatCommandNames=("!cdtraderdash", "!cdtd","!td")
	ChatWriteParamHints=("true|false")
}

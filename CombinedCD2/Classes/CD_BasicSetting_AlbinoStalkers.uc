class CD_BasicSetting_AlbinoStalkers extends CD_BasicSetting
	within CD_Survival;

protected function string ReadIndicator()
{
	return Outer.AlbinoStalkers;
}

protected function WriteIndicator( const out string Val )
{
	Outer.AlbinoStalkers = Val; 
	Outer.AlbinoStalkersBool = bool( Val );
}

protected function string SanitizeIndicator( const string Raw )
{
	return string( bool( Raw ) );
}

defaultproperties
{
	OptionName="AlbinoStalkers"
	DefaultSettingIndicator="true"

	ChatCommandNames=("!cdalbinostalkers","!cdas")
	ChatWriteParamHints=("true|false")
}

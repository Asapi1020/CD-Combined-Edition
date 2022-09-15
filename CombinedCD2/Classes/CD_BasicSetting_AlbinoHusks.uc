class CD_BasicSetting_AlbinoHusks extends CD_BasicSetting
	within CD_Survival;

protected function string ReadIndicator()
{
	return Outer.AlbinoHusks;
}

protected function WriteIndicator( const out string Val )
{
	Outer.AlbinoHusks = Val; 
	Outer.AlbinoHusksBool = bool( Val );
}

protected function string SanitizeIndicator( const string Raw )
{
	return string( bool( Raw ) );
}

defaultproperties
{
	OptionName="AlbinoHusks"
	DefaultSettingIndicator="true"

	ChatCommandNames=("!cdalbinohusks","!cdah")
	ChatWriteParamHints=("true|false")
}

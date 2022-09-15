class CD_BasicSetting_DisableSpawners extends CD_BasicSetting
	within CD_Survival;

protected function string ReadIndicator()
{
	return Outer.DisableSpawners;
}

protected function WriteIndicator( const out string Val )
{
	Outer.DisableSpawners = Val; 
	Outer.bDisableSpawners = bool( Val );
}

protected function string SanitizeIndicator( const string Raw )
{
	return string( bool( Raw ) );
}

defaultproperties
{
	OptionName="DisableSpawners"
	DefaultSettingIndicator="true"

	ChatCommandNames=("!cddisablespawners","!cdds")
	ChatWriteParamHints=("true|false")
}

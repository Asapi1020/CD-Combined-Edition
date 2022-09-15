class CD_BasicSetting_DropAllWeapons extends CD_BasicSetting
	within CD_Survival;

protected function string ReadIndicator()
{
	return Outer.DropAllWeapons;
}

protected function WriteIndicator( const out string Val )
{
	Outer.DropAllWeapons = Val; 
	Outer.bDropAllWeapons = bool( Val );
}

protected function string SanitizeIndicator( const string Raw )
{
	return string( bool(Raw) );
}

defaultproperties
{
	OptionName="DropAllWeapons"
	DefaultSettingIndicator="true"

	ChatCommandNames=("!cddropallweapons","!cddaw")
	ChatWriteParamHints=("true|false")
}


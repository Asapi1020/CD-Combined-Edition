class CD_BasicSetting_StartwithFullAmmo extends CD_BasicSetting
	within CD_Survival;

protected function string ReadIndicator()
{
	return Outer.StartwithFullAmmo;
}

protected function WriteIndicator( const out string Val )
{
	Outer.StartwithFullAmmo = Val;
	Outer.bStartwithFullAmmo = bool( Val );
}

protected function string SanitizeIndicator( const string Raw )
{
	return string( bool( Raw ) );
}

defaultproperties
{
	OptionName="StartwithFullAmmo"
	DefaultSettingIndicator="true"

	ChatCommandNames=("!cdstartwithfullammo", "!cdswfa")
	ChatWriteParamHints=("true|false")
}

class CD_BasicSetting_StartwithFullArmor extends CD_BasicSetting
	within CD_Survival;

protected function string ReadIndicator()
{
	return Outer.StartwithFullArmor;
}

protected function WriteIndicator( const out string Val )
{
	Outer.StartwithFullArmor = Val;
	Outer.bStartwithFullArmor = bool( Val );
}

protected function string SanitizeIndicator( const string Raw )
{
	return string( bool( Raw ) );
}

defaultproperties
{
	OptionName="StartwithFullArmor"
	DefaultSettingIndicator="false"

	ChatCommandNames=("!cdstartwithfullarmor", "!cdswfar")
	ChatWriteParamHints=("true|false")
}

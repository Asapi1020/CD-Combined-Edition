class CD_BasicSetting_StartwithFullGrenade extends CD_BasicSetting
	within CD_Survival;

protected function string ReadIndicator()
{
	return Outer.StartwithFullGrenade;
}

protected function WriteIndicator( const out string Val )
{
	Outer.StartwithFullGrenade = Val;
	Outer.bStartwithFullGrenade = bool( Val );
}

protected function string SanitizeIndicator( const string Raw )
{
	return string( bool( Raw ) );
}

defaultproperties
{
	OptionName="StartwithFullGrenade"
	DefaultSettingIndicator="true"

	ChatCommandNames=("!cdstartwithfullgrenade", "!cdswfg")
	ChatWriteParamHints=("true|false")
}

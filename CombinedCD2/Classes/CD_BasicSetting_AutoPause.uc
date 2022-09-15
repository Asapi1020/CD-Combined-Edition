class CD_BasicSetting_AutoPause extends CD_BasicSetting
	within CD_Survival;

protected function string ReadIndicator()
{
	return Outer.AutoPause;
}

protected function WriteIndicator( const out string Val )
{
	Outer.AutoPause = Val;
	Outer.bAutoPause = bool( Val );
}

protected function string SanitizeIndicator( const string Raw )
{
	return string( bool( Raw ) );
}

defaultproperties
{
	OptionName="AutoPause"
	DefaultSettingIndicator="true"

	ChatCommandNames=("!cdautopause", "!cdap")
	ChatWriteParamHints=("true|false")
}

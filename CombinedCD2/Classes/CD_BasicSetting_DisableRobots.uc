class CD_BasicSetting_DisableRobots extends CD_BasicSetting
	within CD_Survival;

protected function string ReadIndicator()
{
	return Outer.DisableRobots;
}

protected function WriteIndicator( const out string Val )
{
	Outer.DisableRobots = Val; 
	Outer.bDisableRobots = bool( Val );
}

protected function string SanitizeIndicator( const string Raw )
{
	return string( bool( Raw ) );
}

defaultproperties
{
	OptionName="DisableRobots"
	DefaultSettingIndicator="true"

	ChatCommandNames=("!cddisablerobots","!cddr")
	ChatWriteParamHints=("true|false")
}

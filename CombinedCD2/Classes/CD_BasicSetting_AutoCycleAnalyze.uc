class CD_BasicSetting_AutoCycleAnalyze extends CD_BasicSetting
	within CD_Survival;

protected function string ReadIndicator()
{
	return Outer.AutoCycleAnalyze;
}

protected function WriteIndicator( const out string Val )
{
	Outer.AutoCycleAnalyze = Val;
	Outer.bAutoCycleAnalyze = bool( Val );
}

protected function string SanitizeIndicator( const string Raw )
{
	return string( bool( Raw ) );
}

defaultproperties
{
	OptionName="AutoCycleAnalyze"
	DefaultSettingIndicator="true"

	ChatCommandNames=("!cdautocycleanalyze", "!cdaca")
	ChatWriteParamHints=("true|false")
}

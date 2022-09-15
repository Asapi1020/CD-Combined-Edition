class CD_BasicSetting_WaveEndSummaries extends CD_BasicSetting
	within CD_Survival;

protected function string ReadIndicator()
{
	return Outer.WaveEndSummaries;
}

protected function WriteIndicator( const out string Val )
{
	Outer.WaveEndSummaries = Val;
	Outer.bWaveEndSummaries = bool( Val );
}

protected function string SanitizeIndicator( const string Raw )
{
	return string( bool( Raw ) );
}

defaultproperties
{
	OptionName="WaveEndSummaries"
	DefaultSettingIndicator="false"

	ChatCommandNames=("!cdwaveendsummaries", "!cdwesu")
	ChatWriteParamHints=("true|false")
}
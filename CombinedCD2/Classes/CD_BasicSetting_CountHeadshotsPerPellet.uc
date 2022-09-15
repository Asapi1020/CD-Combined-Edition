class CD_BasicSetting_CountHeadshotsPerPellet extends CD_BasicSetting
	within CD_Survival;

protected function string ReadIndicator()
{
	return Outer.CountHeadshotsPerPellet;
}

protected function WriteIndicator( const out string Val )
{
	Outer.CountHeadshotsPerPellet = Val;
	Outer.bCountHeadshotsPerPellet = bool( Val );
}

protected function string SanitizeIndicator( const string Raw )
{
	return string( bool( Raw ) );
}

defaultproperties
{
	OptionName="CountHeadshotsPerPellet"
	DefaultSettingIndicator="false"

	ChatCommandNames=("!cdcountheadshotsperpellet", "!cdchspp")
	ChatWriteParamHints=("true|false")
}

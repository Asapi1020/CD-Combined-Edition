class CD_BasicSetting_StartingWeaponTier extends CD_BasicSetting
	within CD_Survival;

protected function string ReadIndicator()
{
	return Outer.StartingWeaponTier;
}

protected function WriteIndicator( const out string Val )
{
	Outer.StartingWeaponTier = Val; 
	Outer.StartingWeaponTierInt = Clamp(int( Val ), 1, 4);
}

protected function string SanitizeIndicator( const string Raw )
{
	return string( Clamp(int( Raw ),1 ,4) );
}

defaultproperties
{
	OptionName="StartingWeaponTier"
	DefaultSettingIndicator="1"

	ChatCommandNames=("!cdstartingweapontier","!cdswt")
	ChatWriteParamHints=("1~4")
}

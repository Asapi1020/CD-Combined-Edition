class CD_BasicSetting_EnableReadySystem extends CD_BasicSetting
	within CD_Survival;

protected function string ReadIndicator()
{
	return Outer.EnableReadySystem;
}

private function Mutator GetFHUDCompatController()
{
	local Mutator M;

	foreach WorldInfo.DynamicActors( class'Mutator', M )
	{
		if ( PathName( M.class ) ~= "FriendlyHUD.FriendlyHUDCDCompatController")
		{
			return M;
		}
	}

	return None;
}

protected function WriteIndicator( const out string Val )
{
	local Mutator FHUDCompatController;

	FHUDCompatController = GetFHUDCompatController();

	Outer.EnableReadySystem = Val;
	Outer.bEnableReadySystem = bool( Val );
	
	if ( FHUDCompatController != None )
	{
		FHUDCompatController.Mutate("FHUDSetCDReadyEnabled" @ bool(Val), None);
	}
	
}

protected function string SanitizeIndicator( const string Raw )
{
	return string( bool( Raw ) );
}

defaultproperties
{
	OptionName="EnableReadySystem"
	DefaultSettingIndicator="true"

	ChatCommandNames=("!cdEnableReadySystem", "!cders")
	ChatWriteParamHints=("true|false")
}

class xUI_MenuBase extends KFGUI_FloatingWindow
	abstract;

var localized string Title;
var localized string CloseButtonText;
var protected string Version;

function DrawMenu()
{
	Super.DrawMenu();
	WindowTitle = Title @ "v" $ Version;
}

function CD_PlayerController GetCDPC()
{
	return CD_PlayerController(GetPlayer());
}

function CD_PlayerReplicationInfo GetCDPRI()
{
	return CD_PlayerReplicationInfo(GetCDPC().PlayerReplicationInfo);
}

function CD_GameReplicationInfo GetCDGRI()
{
	return CD_GameReplicationInfo(GetCDPC().WorldInfo.GRI);
}

protected function ToggleComponentsVisibility(out array<KFGUI_Base> ComponentsToToggle, bool newVisibility)
{
	local int i;

	for (i=0; i<ComponentsToToggle.length; i++)
	{
		ComponentsToToggle[i].bVisible = newVisibility;
	}
}

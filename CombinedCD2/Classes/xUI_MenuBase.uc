class xUI_MenuBase extends KFGUI_FloatingWindow
	abstract;

var localized string Title;
var localized string CloseButtonText;
var protected string Version;
var protected bool bHideNavigation;

var protected xUI_Navigation Navigation;
var protected xUI_Navigation_Right RightNavigation;

function InitMenu()
{
	Super.InitMenu();

	if(!bHideNavigation)
	{
		Navigation = new(self) class'xUI_Navigation';
		RightNavigation = new(self) class'xUI_Navigation_Right';
		AddComponent(Navigation);
		AddComponent(RightNavigation);
	}
}

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

defaultproperties
{
	XPosition=0.18
	YPosition=0.05
	XSize=0.64
	YSize=0.9
}

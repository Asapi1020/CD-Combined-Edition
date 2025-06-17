class xUI_MenuBase extends KFGUI_FloatingWindow
	abstract;

var localized string Title;
var localized string CloseButtonText;
var protected string Version;
var protected bool bHideNavigation;

var private xUI_Navigation Navigation;

function InitMenu()
{
	Super.InitMenu();

	if(!bHideNavigation)
	{
		Navigation = new(self) class'xUI_Navigation';
		AddComponent(Navigation);
		Navigation.InitComponents();
	}
}

function DrawMenu()
{
	Super.DrawMenu();
	WindowTitle = Title @ "v" $ Version;
	
	if(!bHideNavigation)
	{
		Navigation.DrawComponents();
	}
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

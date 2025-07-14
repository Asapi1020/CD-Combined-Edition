class xUI_ClientMenu extends xUI_MenuBase;

`include(CD_Log.uci)

enum PageState
{
	PS_Spares,
	PS_Others
};

var protected PageState CurrentPageState;

var protected xUI_ClientMenu_Spares SparesComponent;
var protected xUI_ClientMenu_Others OtherSettingsComponent;

var KFGUI_Button SparesButton;
var KFGUI_Button OtherSettingsButton;

var localized string PickupOthersString;
var localized string DropLockedString;
var localized string PickupLowAmmoString;
var localized string AntiOvercapString;
var localized string PlayerDeathSoundString;
var localized string LargeKillSoundString;
var localized string DisableMeowSoundString;
var localized string LargeKillTickerString;
var localized string HideTraderPathString;
var localized string TraderHideDualString;
var localized string DropItemString;
var localized string WaveEndStatsString;
var localized string AlertUnusualSettingsString;
var localized string DisplayCDTipsString;
var localized string ShowPickupInfoString;
var localized string UseVanillaScoreboardString;

var localized string DisablePickupOthersToolTip;
var localized string DropLockedToolTip;
var localized string PickUpLowAmmoToolTip;
var localized string AntiOvercapToolTip;
var localized string PlayerDeathSoundToolTip;
var localized string LargeKillSoundToolTip;
var localized string DisableMeowSoundToolTip;
var localized string HideDualToolTip;
var localized string DropItemToolTip;
var localized string LargeKillTickerToolTip;
var localized string HideTraderPathsToolTip;
var localized string WaveEndStatsToolTip;
var localized string AlertUnusualSettingsToolTip;
var localized string DisplayCDTipsToolTip;
var localized string ShowPickupInfoToolTip;
var localized string UseVanillaScoreboardToolTip;

var localized string SparesButtonText;
var localized string OtherSettingsButtonText;

function SetWindowDrag(bool bDrag){ bDragWindow = false; }

function InitMenu()
{
	SparesComponent = new(self) class'xUI_ClientMenu_Spares';
	AddComponent(SparesComponent);

	OtherSettingsComponent = new(self) class'xUI_ClientMenu_Others';
	AddComponent(OtherSettingsComponent);

	Super.InitMenu();
}

function DrawMenu()
{
	Super.DrawMenu();

	SparesButton = KFGUI_Button(FindComponentID('SparesButton'));
	SparesButton.ButtonText = SparesButtonText;
	SparesButton.bDisabled = CurrentPageState == PS_Spares;

	OtherSettingsButton = KFGUI_Button(FindComponentID('OtherSettingsButton'));
	OtherSettingsButton.ButtonText = OtherSettingsButtonText;
	OtherSettingsButton.bDisabled = CurrentPageState == PS_Others;

	SparesComponent.bVisible = (CurrentPageState == PS_Spares);
	OtherSettingsComponent.bVisible = (CurrentPageState == PS_Others);
}

protected function ButtonClicked(KFGUI_Button Sender)
{
	switch(Sender.ID)
	{
		case 'SparesButton':
			CurrentPageState = PS_Spares;
			break;
		case 'OtherSettingsButton':
			CurrentPageState = PS_Others;
			break;
		default:
			`cdlog("xUI_ClientMenu.ButtonClicked: Unknown button ID: " $ Sender.ID);
			return;
	}
}

defaultproperties
{
	ID="ClientMenu"
	Version="2.0.0"

	Begin Object Class=KFGUI_Button Name=SparesButton
		XPosition=0.025
		YPosition=0.925
		XSize=0.14
		YSize=0.05
		ID="SparesButton"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(SparesButton)

	Begin Object Class=KFGUI_Button Name=OtherSettingsButton
		XPosition=0.190
		YPosition=0.925
		XSize=0.14
		YSize=0.05
		ID="OtherSettingsButton"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(OtherSettingsButton)
}

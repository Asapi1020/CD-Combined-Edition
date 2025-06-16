class xUI_ClientMenu extends xUI_MenuBase;

var KFGUI_CheckBox DisablePickUpOthersBox;
var KFGUI_CheckBox DropLockedBox;
var KFGUI_CheckBox DisablePickUpLowAmmoBox;
var KFGUI_CheckBox AntiOvercapBox;

var KFGUI_CheckBox PlayerDeathSoundBox;
var KFGUI_CheckBox LargeKillSoundBox;
var KFGUI_CheckBox DisableMeowSoundBox;

var KFGUI_CheckBox HideDualBox;
var KFGUI_CheckBox DropItemBox;

var KFGUI_CheckBox LargeKillTickerBox;
var KFGUI_CheckBox HideTraderPathsBox;
var KFGUI_CheckBox WaveEndStatsBox;
var KFGUI_CheckBox AlertUnusualSettingsBox;
var KFGUI_CheckBox DisplayCDTipsBox;
var KFGUI_CheckBox ShowPickupInfoBox;
var KFGUI_CheckBox UseVanillaScoreboardBox;

//var localized string Title;
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

function SetWindowDrag(bool bDrag){ bDragWindow = false; }

function DrawMenu()
{
//	Setup
	local float YL, XL, FontScalar;
	local CD_PlayerController CDPC;

	super.DrawMenu();

	Canvas.Font = Owner.CurrentStyle.PickFont(FontScalar);
	Canvas.TextSize("ABC", XL, YL, FontScalar, FontScalar);

	CDPC = GetCDPC();

//	Check boxes
	DisablePickUpOthersBox = KFGUI_CheckBox(FindComponentID('DisablePickUpOthers'));
	DisablePickUpOthersBox.bChecked = !CDPC.DisablePickUpOthers;
	DisablePickUpOthersBox.ToolTip=DisablePickupOthersToolTip;
	DrawBoxDescription(PickupOthersString, DisablePickUpOthersBox, 0.4);

	DropLockedBox = KFGUI_CheckBox(FindComponentID('DropLocked'));
	DropLockedBox.bChecked = CDPC.DropLocked;
	DropLockedBox.ToolTip=DropLockedToolTip;
	DrawBoxDescription(DropLockedString, DropLockedBox, 0.4);

	DisablePickUpLowAmmoBox = KFGUI_CheckBox(FindComponentID('DisablePickUpLowAmmo'));
	DisablePickUpLowAmmoBox.bChecked = !CDPC.DisablePickUpLowAmmo;
	DisablePickUpLowAmmoBox.ToolTip=PickUpLowAmmoToolTip;
	DrawBoxDescription(PickupLowAmmoString, DisablePickUpLowAmmoBox, 0.4);

	AntiOvercapBox = KFGUI_CheckBox(FindComponentID('AntiOvercap'));
	AntiOvercapBox.bChecked = CDPC.ClientAntiOvercap;
	AntiOvercapBox.ToolTip=AntiOvercapToolTip;
	DrawBoxDescription(AntiOvercapString, AntiOvercapBox, 0.4);

	PlayerDeathSoundBox = KFGUI_CheckBox(FindComponentID('PlayerDeathSound'));
	PlayerDeathSoundBox.bChecked = CDPC.PlayerDeathSound;
	PlayerDeathSoundBox.ToolTip=PlayerDeathSoundToolTip;
	DrawBoxDescription(PlayerDeathSoundString, PlayerDeathSoundBox, 0.4);

	LargeKillSoundBox = KFGUI_CheckBox(FindComponentID('LargeKillSound'));
	LargeKillSoundBox.bChecked = CDPC.LargeKillSound;
	LargeKillSoundBox.ToolTip=LargeKillSoundToolTip;
	DrawBoxDescription(LargeKillSoundString, LargeKillSoundBox, 0.4);

	DisableMeowSoundBox = KFGUI_CheckBox(FindComponentID('DisableMeowSound'));
	DisableMeowSoundBox.bChecked = CDPC.DisableMeowSound;
	DisableMeowSoundBox.ToolTip=DisableMeowSoundToolTip;
	DrawBoxDescription(DisableMeowSoundString, DisableMeowSoundBox, 0.4);

	LargeKillTickerBox = KFGUI_CheckBox(FindComponentID('LargeKillTicker'));
	LargeKillTickerBox.bChecked = CDPC.LargeKillTicker;
	LargeKillTickerBox.ToolTip=LargeKillTickerToolTip;
	DrawBoxDescription(LargeKillTickerString, LargeKillTickerBox, 0.9);

	HideTraderPathsBox = KFGUI_CheckBox(FindComponentID('HideTraderPaths'));
	HideTraderPathsBox.bChecked = CDPC.bHideTraderPaths;
	HideTraderPathsBox.ToolTip=HideTraderPathsToolTip;
	DrawBoxDescription(HideTraderPathString, HideTraderPathsBox, 0.9);

	HideDualBox = KFGUI_CheckBox(FindComponentID('HideDual'));
	HideDualBox.bChecked = CDPC.HideDualPistol;
	HideDualBox.ToolTip=HideDualToolTip;
	DrawBoxDescription(TraderHideDualString, HideDualBox, 0.9);
	
	DropItemBox = KFGUI_CheckBox(FindComponentID('DropItem'));
	DropItemBox.bChecked = CDPC.DropItem;
	DropItemBox.ToolTip=DropItemToolTip;
	DrawBoxDescription(DropItemString, DropItemBox, 0.9);

	WaveEndStatsBox = KFGUI_CheckBox(FindComponentID('WaveEndStats'));
	WaveEndStatsBox.bChecked = CDPC.WaveEndStats;
	WaveEndStatsBox.ToolTip=WaveEndStatsToolTip;
	DrawBoxDescription(WaveEndStatsString, WaveEndStatsBox, 0.9);

	AlertUnusualSettingsBox = KFGUI_CheckBox(FindComponentID('AlertUnusualSettings'));
	AlertUnusualSettingsBox.bChecked = CDPC.AlertUnusualSettings;
	AlertUnusualSettingsBox.ToolTip=AlertUnusualSettingsToolTip;
	DrawBoxDescription(AlertUnusualSettingsString, AlertUnusualSettingsBox, 0.9);

	DisplayCDTipsBox = KFGUI_CheckBox(FindComponentID('DisplayCDTips'));
	DisplayCDTipsBox.bChecked = CDPC.DisplayCDTips;
	DisplayCDTipsBox.ToolTip=DisplayCDTipsToolTip;
	DrawBoxDescription(DisplayCDTipsString, DisplayCDTipsBox, 0.9);

	ShowPickupInfoBox = KFGUI_CheckBox(FindComponentID('ShowPickupInfo'));
	ShowPickupInfoBox.bChecked = CDPC.ShowPickupInfo;
	ShowPickupInfoBox.ToolTip=ShowPickupInfoToolTip;
	DrawBoxDescription(ShowPickupInfoString, ShowPickupInfoBox, 0.9);

	UseVanillaScoreboardBox = KFGUI_CheckBox(FindComponentID('UseVanillaScoreboard'));
	UseVanillaScoreboardBox.bChecked = CDPC.UseVanillaScoreboard;
	UseVanillaScoreboardBox.ToolTip=UseVanillaScoreboardToolTip;
	DrawBoxDescription(UseVanillaScoreboardString, UseVanillaScoreboardBox, 0.9);
}

function ToggleCheckBox(KFGUI_CheckBox Sender)
{
	local CD_PlayerController CDPC;

	CDPC = GetCDPC();

	switch (Sender.ID)
	{
		case 'DisablePickUpOthers':
			CDPC.DisablePickUpOthers = !Sender.bChecked;
			CDPC.SendPickupInfo();
			break;
		case 'DropLocked':
			CDPC.DropLocked = Sender.bChecked;
			CDPC.SendPickupInfo();
			break;
		case 'DisablePickUpLowAmmo':
			CDPC.DisablePickUpLowAmmo = !Sender.bChecked;
			CDPC.SendPickupInfo();
			break;
		case 'AntiOvercap':
			CDPC.ClientAntiOvercap = Sender.bChecked;
			CDPC.SendPickupInfo();
			break;
		case 'PlayerDeathSound':
			CDPC.PlayerDeathSound = Sender.bChecked;
			break;
		case 'LargeKillSound':
			CDPC.LargeKillSound = Sender.bChecked;
			break;
		case 'DisableMeowSound':
			CDPC.DisableMeowSound = Sender.bChecked;
			break;
		case 'LargeKillTicker':
			CDPC.LargeKillTicker = Sender.bChecked;
			break;
		case 'HideTraderPaths':
			CDPC.bHideTraderPaths = Sender.bChecked;
			break;
		case 'HideDual':
			CDPC.HideDualPistol = Sender.bChecked;
			break;
		case 'DropItem':
			CDPC.DropItem = Sender.bChecked;
			break;
		case 'WaveEndStats':
			CDPC.WaveEndStats = Sender.bChecked;
			break;
		case 'AlertUnusualSettings':
			CDPC.AlertUnusualSettings = Sender.bChecked;
			break;
		case 'DisplayCDTips':
			CDPC.DisplayCDTips = Sender.bChecked;
			break;
		case 'ShowPickupInfo':
			CDPC.ShowPickupInfo = Sender.bChecked;
			break;
		case 'UseVanillaScoreboard':
			CDPC.UseVanillaScoreboard = Sender.bChecked;
	}

	CDPC.SaveConfig();
}

defaultproperties
{
	ID="ClientMenu"
	Version="1.9.1"

//	Pickup settings
	Begin Object Class=KFGUI_CheckBox Name=DisablePickUpOthers
		XPosition=0.05
		YPosition=0.08
		ID="DisablePickUpOthers"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=DropLocked
		XPosition=0.05
		YPosition=0.16
		ID="DropLocked"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=DisablePickUpLowAmmo
		XPosition=0.05
		YPosition=0.24
		ID="DisablePickUpLowAmmo"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=AntiOvercap
		XPosition=0.05
		YPosition=0.32
		ID="AntiOvercap"
		OnCheckChange=ToggleCheckBox
	End Object

//	Sound
	Begin Object Class=KFGUI_CheckBox Name=PlayerDeathSound
		XPosition=0.05
		YPosition=0.44
		ID="PlayerDeathSound"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=LargeKillSound
		XPosition=0.05
		YPosition=0.52
		ID="LargeKillSound"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=DisableMeowSound
		XPosition=0.05
		YPosition=0.60
		ID="DisableMeowSound"
		OnCheckChange=ToggleCheckBox
	End Object

//	Trader
	Begin Object Class=KFGUI_CheckBox Name=HideDual
		XPosition=0.55
		YPosition=0.08
		ID="HideDual"
		OnCheckChange=ToggleCheckBox
	End Object
	
	Begin Object Class=KFGUI_CheckBox Name=DropItem
		XPosition=0.55
		YPosition=0.16
		ID="DropItem"
		OnCheckChange=ToggleCheckBox
	End Object
	

//	Display
	Begin Object Class=KFGUI_CheckBox Name=LargeKillTicker
		XPosition=0.55
		YPosition=0.28
		ID="LargeKillTicker"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=HideTraderPaths
		XPosition=0.55
		YPosition=0.36
		ID="HideTraderPaths"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=WaveEndStats
		XPosition=0.55
		YPosition=0.44
		ID="WaveEndStats"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=AlertUnusualSettings
		XPosition=0.55
		YPosition=0.52
		ID="AlertUnusualSettings"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=DisplayCDTips
		XPosition=0.55
		YPosition=0.60
		ID="DisplayCDTips"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=ShowPickupInfo
		XPosition=0.55
		YPosition=0.68
		ID="ShowPickupInfo"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=UseVanillaScoreboard
		XPosition=0.55
		YPosition=0.76
		ID="UseVanillaScoreboard"
		OnCheckChange=ToggleCheckBox
	End Object

//	Components
	Components.Add(DisablePickUpOthers)
	Components.Add(DropLocked)
	Components.Add(DisablePickUpLowAmmo)
	Components.Add(AntiOvercap)
	Components.Add(PlayerDeathSound)
	Components.Add(LargeKillSound)
	Components.Add(DisableMeowSound)
	Components.Add(LargeKillTicker)
	Components.Add(HideTraderPaths)
	Components.Add(HideDual)
	Components.Add(DropItem)
	Components.Add(WaveEndStats)
	Components.Add(AlertUnusualSettings)
	Components.Add(DisplayCDTips)
	Components.Add(ShowPickupInfo)
	Components.Add(UseVanillaScoreboard)
}

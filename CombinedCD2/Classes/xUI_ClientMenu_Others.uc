class xUI_ClientMenu_Others extends KFGUI_MultiComponent
	within xUI_ClientMenu;

`include(CD_Log.uci)

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

function DrawMenu()
{
	local CD_PlayerController CDPC;
	local float YL, XL, FontScalar;

	super.DrawMenu();

	Canvas.Font = Owner.CurrentStyle.PickFont(FontScalar);
	Canvas.TextSize("ABC", XL, YL, FontScalar, FontScalar);

	CDPC = GetCDPC();

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
		default:
			`cdlog("xUI_ClientMenu_Others: ToggleCheckBox: Unknown Sender ID: " @ Sender.ID);
			return;
	}

	CDPC.SaveConfig();
}

defaultproperties
{
	ID="ClientMenu_Others"

	Begin Object Class=KFGUI_CheckBox Name=AntiOvercap
		XPosition=0.05
		YPosition=0.32
		ID="AntiOvercap"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(AntiOvercap)

//	Sound
	Begin Object Class=KFGUI_CheckBox Name=PlayerDeathSound
		XPosition=0.05
		YPosition=0.44
		ID="PlayerDeathSound"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(PlayerDeathSound)

	Begin Object Class=KFGUI_CheckBox Name=LargeKillSound
		XPosition=0.05
		YPosition=0.52
		ID="LargeKillSound"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(LargeKillSound)

	Begin Object Class=KFGUI_CheckBox Name=DisableMeowSound
		XPosition=0.05
		YPosition=0.60
		ID="DisableMeowSound"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(DisableMeowSound)

//	Trader
	Begin Object Class=KFGUI_CheckBox Name=HideDual
		XPosition=0.55
		YPosition=0.08
		ID="HideDual"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(HideDual)
	
	Begin Object Class=KFGUI_CheckBox Name=DropItem
		XPosition=0.55
		YPosition=0.16
		ID="DropItem"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(DropItem)	

//	Display
	Begin Object Class=KFGUI_CheckBox Name=LargeKillTicker
		XPosition=0.55
		YPosition=0.28
		ID="LargeKillTicker"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(LargeKillTicker)

	Begin Object Class=KFGUI_CheckBox Name=HideTraderPaths
		XPosition=0.55
		YPosition=0.36
		ID="HideTraderPaths"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(HideTraderPaths)

	Begin Object Class=KFGUI_CheckBox Name=WaveEndStats
		XPosition=0.55
		YPosition=0.44
		ID="WaveEndStats"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(WaveEndStats)

	Begin Object Class=KFGUI_CheckBox Name=AlertUnusualSettings
		XPosition=0.55
		YPosition=0.52
		ID="AlertUnusualSettings"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(AlertUnusualSettings)

	Begin Object Class=KFGUI_CheckBox Name=DisplayCDTips
		XPosition=0.55
		YPosition=0.60
		ID="DisplayCDTips"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(DisplayCDTips)

	Begin Object Class=KFGUI_CheckBox Name=ShowPickupInfo
		XPosition=0.55
		YPosition=0.68
		ID="ShowPickupInfo"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(ShowPickupInfo)

	Begin Object Class=KFGUI_CheckBox Name=UseVanillaScoreboard
		XPosition=0.55
		YPosition=0.76
		ID="UseVanillaScoreboard"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(UseVanillaScoreboard)
}

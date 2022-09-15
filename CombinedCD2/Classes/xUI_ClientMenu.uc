class xUI_ClientMenu extends xUI_MenuBase;

var KFGUI_CheckBox DisablePickUpOthersBox;
var KFGUI_CheckBox DropLockedBox;
var KFGUI_CheckBox DisablePickUpLowAmmoBox;

var KFGUI_CheckBox PlayerDeathSoundBox;
var KFGUI_CheckBox LargeKillSoundBox;

var KFGUI_CheckBox HideDualBox;
var KFGUI_CheckBox DropItemBox;

var KFGUI_CheckBox LargeKillTickerBox;
var KFGUI_CheckBox HideTraderPathsBox;
var KFGUI_CheckBox WaveEndStatsBox;

const DisablePickupOthersToolTip = "Pick up others' weapons.";
const DropLockedToolTip = "Drop your weapons locked.";
const PickUpLowAmmoToolTip = "Pick up weapons remaining low ammo during waves.";
const PlayerDeathSoundToolTip = "Play a sound when players die.";
const LargeKillSoundToolTip = "Play a sound for each your large kills.";
const HideDualToolTip = "Hide dual pistols in your trader.";
const DropItemToolTip = "Drop items during a match";
const LargeKillTickerToolTip = "Show kill tickers for each mates' large kills.";
const HideTraderPathsToolTip = "Hide trader paths.";
const WaveEndStatsToolTip = "Show your stats when a wave ends.";

function SetWindowDrag(bool bDrag){	bDragWindow = false; }

function DrawMenu()
{
//	Setup
	local float YL, XL, FontScalar;
	local CD_PlayerController CDPC;

	super.DrawMenu();

	WindowTitle="Client Option v1.4";
	Canvas.Font = Owner.CurrentStyle.PickFont(FontScalar);
	Canvas.TextSize("ABC", XL, YL, FontScalar, FontScalar);

	CDPC = GetCDPC();

//	Check boxes
	DisablePickUpOthersBox = KFGUI_CheckBox(FindComponentID('DisablePickUpOthers'));
	DisablePickUpOthersBox.bChecked = !CDPC.DisablePickUpOthers;
	DisablePickUpOthersBox.ToolTip=DisablePickupOthersToolTip;
	DrawBoxDescription("Pick Up Others", DisablePickUpOthersBox, 0.4);

	DropLockedBox = KFGUI_CheckBox(FindComponentID('DropLocked'));
	DropLockedBox.bChecked = CDPC.DropLocked;
	DropLockedBox.ToolTip=DropLockedToolTip;
	DrawBoxDescription("Drop Locked", DropLockedBox, 0.4);

	DisablePickUpLowAmmoBox = KFGUI_CheckBox(FindComponentID('DisablePickUpLowAmmo'));
	DisablePickUpLowAmmoBox.bChecked = !CDPC.DisablePickUpLowAmmo;
	DisablePickUpLowAmmoBox.ToolTip=PickUpLowAmmoToolTip;
	DrawBoxDescription("Pick Up Low Ammo", DisablePickUpLowAmmoBox, 0.4);

	PlayerDeathSoundBox = KFGUI_CheckBox(FindComponentID('PlayerDeathSound'));
	PlayerDeathSoundBox.bChecked = CDPC.PlayerDeathSound;
	PlayerDeathSoundBox.ToolTip=PlayerDeathSoundToolTip;
	DrawBoxDescription("Player Death Sound", PlayerDeathSoundBox, 0.4);

	LargeKillSoundBox = KFGUI_CheckBox(FindComponentID('LargeKillSound'));
	LargeKillSoundBox.bChecked = CDPC.LargeKillSound;
	LargeKillSoundBox.ToolTip=LargeKillSoundToolTip;
	DrawBoxDescription("Large Kill Sound", LargeKillSoundBox, 0.4);

	LargeKillTickerBox = KFGUI_CheckBox(FindComponentID('LargeKillTicker'));
	LargeKillTickerBox.bChecked = CDPC.LargeKillTicker;
	LargeKillTickerBox.ToolTip=LargeKillTickerToolTip;
	DrawBoxDescription("Large Kill Ticker", LargeKillTickerBox, 0.9);

	HideTraderPathsBox = KFGUI_CheckBox(FindComponentID('HideTraderPaths'));
	HideTraderPathsBox.bChecked = CDPC.bHideTraderPaths;
	HideTraderPathsBox.ToolTip=HideTraderPathsToolTip;
	DrawBoxDescription("Hide Trader Paths", HideTraderPathsBox, 0.9);

	HideDualBox = KFGUI_CheckBox(FindComponentID('HideDual'));
	HideDualBox.bChecked = CDPC.HideDualPistol;
	HideDualBox.ToolTip=HideDualToolTip;
	DrawBoxDescription("Trader Hide Dual", HideDualBox, 0.4);
	
	DropItemBox = KFGUI_CheckBox(FindComponentID('DropItem'));
	DropItemBox.bChecked = CDPC.DropItem;
	DropItemBox.ToolTip=DropItemToolTip;
	DrawBoxDescription("Drop Item", DropItemBox, 0.4);

	WaveEndStatsBox = KFGUI_CheckBox(FindComponentID('WaveEndStats'));
	WaveEndStatsBox.bChecked = CDPC.WaveEndStats;
	WaveEndStatsBox.ToolTip=WaveEndStatsToolTip;
	DrawBoxDescription("Wave End Stats", WaveEndStatsBox, 0.9);
	
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
		case 'PlayerDeathSound':
			CDPC.PlayerDeathSound = Sender.bChecked;
			break;
		case 'LargeKillSound':
			CDPC.LargeKillSound = Sender.bChecked;
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
	}

	CDPC.SaveConfig();
}

defaultproperties
{
	XPosition=0.30
	YPosition=0.30
	XSize=0.4
	YSize=0.4

//	Pickup settings
	Begin Object Class=KFGUI_CheckBox Name=DisablePickUpOthers
		XPosition=0.05
		YPosition=0.10
		ID="DisablePickUpOthers"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=DropLocked
		XPosition=0.05
		YPosition=0.20
		ID="DropLocked"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=DisablePickUpLowAmmo
		XPosition=0.05
		YPosition=0.30
		ID="DisablePickUpLowAmmo"
		OnCheckChange=ToggleCheckBox
	End Object

//	Sound
	Begin Object Class=KFGUI_CheckBox Name=PlayerDeathSound
		XPosition=0.05
		YPosition=0.45
		ID="PlayerDeathSound"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=LargeKillSound
		XPosition=0.05
		YPosition=0.55
		ID="LargeKillSound"
		OnCheckChange=ToggleCheckBox
	End Object

//	Trader
	Begin Object Class=KFGUI_CheckBox Name=HideDual
		XPosition=0.05
		YPosition=0.70
		ID="HideDual"
		OnCheckChange=ToggleCheckBox
	End Object
	
	Begin Object Class=KFGUI_CheckBox Name=DropItem
		XPosition=0.05
		YPosition=0.80
		ID="DropItem"
		OnCheckChange=ToggleCheckBox
	End Object
	

//	Display
	Begin Object Class=KFGUI_CheckBox Name=LargeKillTicker
		XPosition=0.55
		YPosition=0.10
		ID="LargeKillTicker"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=HideTraderPaths
		XPosition=0.55
		YPosition=0.20
		ID="HideTraderPaths"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=WaveEndStats
		XPosition=0.55
		YPosition=0.30
		ID="WaveEndStats"
		OnCheckChange=ToggleCheckBox
	End Object

//	Components
	Components.Add(DisablePickUpOthers)
	Components.Add(DropLocked)
	Components.Add(DisablePickUpLowAmmo)
	Components.Add(PlayerDeathSound)
	Components.Add(LargeKillSound)
	Components.Add(LargeKillTicker)
	Components.Add(HideTraderPaths)
	Components.Add(HideDual)
	Components.Add(DropItem)
	Components.Add(WaveEndStats)
}
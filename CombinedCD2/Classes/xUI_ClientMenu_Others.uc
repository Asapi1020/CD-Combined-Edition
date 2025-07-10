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

var KFGUI_Button PlayPlayerDeathSoundButton;
var KFGUI_Button PlayLargeKillSoundButton;
var KFGUI_Button PlayMeowSoundButton;

var KFGUI_EditBox PlayerDeathSoundVolumeEditBox;
var KFGUI_EditBox LargeKillSoundVolumeEditBox;
var KFGUI_EditBox MeowSoundVolumeEditBox;
var editinline export KFGUI_TextLabel VolumeTextLabel_0, VolumeTextLabel_1, VolumeTextLabel_2;

var KFGUI_ComboBox ScoreboardSortComboBox;

var localized string SamplePlayButtonText;
var localized string SamplePlayToolTip;
var localized string VolumeString;
var localized string VolumeToolTip;
var localized string ScoreboardSortLabelString;
var localized string ScoreboardSortToolTip;

function InitMenu()
{
	ScoreboardSortComboBox = KFGUI_ComboBox(FindComponentID('ScoreboardSort'));
	ScoreboardSortComboBox.LabelString = ScoreboardSortLabelString;
	ScoreboardSortComboBox.ToolTip = ScoreboardSortToolTip;

	Super.InitMenu();

	PlayerDeathSoundVolumeEditBox = KFGUI_EditBox(FindComponentID('PlayerDeathSoundVolume'));
	PlayerDeathSoundVolumeEditBox.SetText(string(GetCDPC().PlayerDeathSoundVolumeMultiplier));
	PlayerDeathSoundVolumeEditBox.ToolTip = VolumeToolTip;

	LargeKillSoundVolumeEditBox = KFGUI_EditBox(FindComponentID('LargeKillSoundVolume'));
	LargeKillSoundVolumeEditBox.SetText(string(GetCDPC().LargeKillSoundVolumeMultiplier));
	LargeKillSoundVolumeEditBox.ToolTip = VolumeToolTip;

	MeowSoundVolumeEditBox = KFGUI_EditBox(FindComponentID('MeowSoundVolume'));
	MeowSoundVolumeEditBox.SetText(string(GetCDPC().MeowSoundVolumeMultiplier));
	MeowSoundVolumeEditBox.ToolTip = VolumeToolTip;

	VolumeTextLabel_0.SetText(VolumeString);
	AddComponent(VolumeTextLabel_0);
	VolumeTextLabel_1.SetText(VolumeString);
	AddComponent(VolumeTextLabel_1);
	VolumeTextLabel_2.SetText(VolumeString);
	AddComponent(VolumeTextLabel_2);

	InitScoreboardComboBox();
}

protected function InitScoreboardComboBox()
{
	local class<KFScoreboard> ScoreboardClass;

	ScoreboardClass = CD_GFxHudWrapper(GetCDPC().myHUD).ScoreboardClass;
	if (ScoreboardClass == None)
	{
		ScoreboardClass = class'KFScoreboard';
	}

	if (ScoreboardSortComboBox.Values.length != 2)
	{
		ScoreboardSortComboBox.Values.length = 0;
		ScoreboardSortComboBox.Values.AddItem(ScoreboardClass.default.Kills);
		ScoreboardSortComboBox.Values.AddItem(ScoreboardClass.default.DamageDealt);
	}

	ScoreboardSortComboBox.SelectedIndex = ScoreboardClass.default.PlayerSortOrder;
}

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

	PlayPlayerDeathSoundButton = KFGUI_Button(FindComponentID('PlayPlayerDeathSound'));
	PlayPlayerDeathSoundButton.ButtonText = SamplePlayButtonText;
	PlayPlayerDeathSoundButton.ToolTip = SamplePlayToolTip;

	PlayLargeKillSoundButton = KFGUI_Button(FindComponentID('PlayLargeKillSound'));
	PlayLargeKillSoundButton.ButtonText = SamplePlayButtonText;
	PlayLargeKillSoundButton.ToolTip = SamplePlayToolTip;

	PlayMeowSoundButton = KFGUI_Button(FindComponentID('PlayMeowSound'));
	PlayMeowSoundButton.ButtonText = SamplePlayButtonText;
	PlayMeowSoundButton.ToolTip = SamplePlayToolTip;

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

protected function ButtonClicked(KFGUI_Button Sender)
{
	switch(Sender.ID)
	{
		case 'PlayPlayerDeathSound':
			GetCDPC().PlayPlayerDeathSound();
			break;
		case 'PlayLargeKillSound':
			GetCDPC().PlayLargeKillSound();
			break;
		case 'PlayMeowSound':
			GetCDPC().PlayMeowSound();
			break;
		default:
			`cdlog("xUI_ClientMenu_Others.ButtonClicked: Unknown button ID: " $ Sender.ID);
			return;
	}
}

protected function PlayerHitEnter(KFGUI_EditBox Sender, string inputString)
{
	local CD_PlayerController CDPC;

	CDPC = GetCDPC();

	switch(Sender.ID)
	{
		case 'PlayerDeathSoundVolume':
			CDPC.PlayerDeathSoundVolumeMultiplier = float(inputString);
			break;
		case 'LargeKillSoundVolume':
			CDPC.LargeKillSoundVolumeMultiplier = float(inputString);
			break;
		case 'MeowSoundVolume':
			CDPC.MeowSoundVolumeMultiplier = float(inputString);
			break;
		default:
			`cdlog("xUI_AdminMenu_PlayerStart: PlayerHitEnter: Unknown sender ID: " $ Sender.ID);
			return;
	}

	CDPC.SaveConfig();
}

protected function ComboChanged(KFGUI_ComboBox Sender)
{
	local KFScoreboard Scoreboard;

	switch(Sender.ID)
	{
		case'ScoreboardSort':
			Scoreboard = CD_GFxHudWrapper(GetCDPC().myHUD).Scoreboard;
			
			if (Scoreboard == None)
			{
				`cdlog("xUI_ClientMenu_Others.ComboChanged: Scoreboard is None!");
				return;
			}

			Scoreboard.PlayerSortOrder = Sender.SelectedIndex;
			Scoreboard.SaveConfig();
			break;
		default:
			`cdlog("xUI_ClientMenu_Others.ComboChanged: Unknown sender ID: " $ Sender.ID);
			return;
	}
}

defaultproperties
{
	ID="ClientMenu_Others"

	Begin Object Class=KFGUI_CheckBox Name=AntiOvercap
		XPosition=0.05
		YPosition=0.05
		ID="AntiOvercap"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(AntiOvercap)

//	Sound
	Begin Object Class=KFGUI_CheckBox Name=PlayerDeathSound
		XPosition=0.05
		YPosition=0.15
		ID="PlayerDeathSound"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(PlayerDeathSound)

	Begin Object Class=KFGUI_TextLabel Name=VolumeTextLabel_0
		AlignX=0
		AlignY=1
		TextFontInfo=(bClipText=true, bEnableShadow=true)
		XPosition=0.05
		YPosition=0.20
		XSize=0.075
		YSize=0.05
	End Object
	VolumeTextLabel_0=VolumeTextLabel_0

	Begin Object Class=KFGUI_EditBox Name=PlayerDeathSoundVolume
    	ID="PlayerDeathSoundVolume"
        bDrawBackground=true
		bFloatOnly=true
		bNoClearOnEnter=true
        FontColor=(R=195,G=195,B=195,A=255)
        BackgroundColor=(R=0, G=0, B=0, A=200)
        CursorColor=(R=195,G=195,B=195,A=255)
        MaxWidth=2048
        XPosition=0.125
        YPosition=0.20
        XSize=0.10
        YSize=0.05
        OnTextFinished=PlayerHitEnter
    End Object
    Components.Add(PlayerDeathSoundVolume)

	Begin Object Class=KFGUI_Button Name=PlayPlayerDeathSound
		XPosition=0.25
		YPosition=0.20
		XSize=0.14
		YSize=0.05
		ID="PlayPlayerDeathSound"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(PlayPlayerDeathSound)

	Begin Object Class=KFGUI_CheckBox Name=LargeKillSound
		XPosition=0.05
		YPosition=0.30
		ID="LargeKillSound"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(LargeKillSound)

	Begin Object Class=KFGUI_TextLabel Name=VolumeTextLabel_1
		AlignX=0
		AlignY=1
		TextFontInfo=(bClipText=true, bEnableShadow=true)
		XPosition=0.05
		YPosition=0.35
		XSize=0.075
		YSize=0.05
	End Object
	VolumeTextLabel_1=VolumeTextLabel_1

	Begin Object Class=KFGUI_EditBox Name=LargeKillSoundVolume
    	ID="LargeKillSoundVolume"
        bDrawBackground=true
		bFloatOnly=true
		bNoClearOnEnter=true
        FontColor=(R=195,G=195,B=195,A=255)
        BackgroundColor=(R=0, G=0, B=0, A=200)
        CursorColor=(R=195,G=195,B=195,A=255)
        MaxWidth=2048
        XPosition=0.125
        YPosition=0.35
        XSize=0.10
        YSize=0.05
        OnTextFinished=PlayerHitEnter
    End Object
    Components.Add(LargeKillSoundVolume)

	Begin Object Class=KFGUI_Button Name=PlayLargeKillSound
		XPosition=0.25
		YPosition=0.35
		XSize=0.14
		YSize=0.05
		ID="PlayLargeKillSound"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(PlayLargeKillSound)

	Begin Object Class=KFGUI_CheckBox Name=DisableMeowSound
		XPosition=0.05
		YPosition=0.45
		ID="DisableMeowSound"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(DisableMeowSound)

	Begin Object Class=KFGUI_TextLabel Name=VolumeTextLabel_2
		AlignX=0
		AlignY=1
		TextFontInfo=(bClipText=true, bEnableShadow=true)
		XPosition=0.05
		YPosition=0.50
		XSize=0.075
		YSize=0.05
	End Object
	VolumeTextLabel_2=VolumeTextLabel_2

	Begin Object Class=KFGUI_EditBox Name=MeowSoundVolume
    	ID="MeowSoundVolume"
        bDrawBackground=true
		bFloatOnly=true
		bNoClearOnEnter=true
        FontColor=(R=195,G=195,B=195,A=255)
        BackgroundColor=(R=0, G=0, B=0, A=200)
        CursorColor=(R=195,G=195,B=195,A=255)
        MaxWidth=2048
        XPosition=0.125
        YPosition=0.50
        XSize=0.10
        YSize=0.05
        OnTextFinished=PlayerHitEnter
    End Object
    Components.Add(MeowSoundVolume)

	Begin Object Class=KFGUI_Button Name=PlayMeowSound
		XPosition=0.25
		YPosition=0.50
		XSize=0.14
		YSize=0.05
		ID="PlayMeowSound"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(PlayMeowSound)

//	Trader
	Begin Object Class=KFGUI_CheckBox Name=HideDual
		XPosition=0.55
		YPosition=0.05
		ID="HideDual"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(HideDual)
	
	Begin Object Class=KFGUI_CheckBox Name=DropItem
		XPosition=0.55
		YPosition=0.10
		ID="DropItem"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(DropItem)	

//	Display
	Begin Object Class=KFGUI_CheckBox Name=LargeKillTicker
		XPosition=0.55
		YPosition=0.20
		ID="LargeKillTicker"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(LargeKillTicker)

	Begin Object Class=KFGUI_CheckBox Name=HideTraderPaths
		XPosition=0.55
		YPosition=0.25
		ID="HideTraderPaths"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(HideTraderPaths)

	Begin Object Class=KFGUI_CheckBox Name=WaveEndStats
		XPosition=0.55
		YPosition=0.30
		ID="WaveEndStats"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(WaveEndStats)

	Begin Object Class=KFGUI_CheckBox Name=AlertUnusualSettings
		XPosition=0.55
		YPosition=0.35
		ID="AlertUnusualSettings"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(AlertUnusualSettings)

	Begin Object Class=KFGUI_CheckBox Name=DisplayCDTips
		XPosition=0.55
		YPosition=0.40
		ID="DisplayCDTips"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(DisplayCDTips)

	Begin Object Class=KFGUI_CheckBox Name=ShowPickupInfo
		XPosition=0.55
		YPosition=0.45
		ID="ShowPickupInfo"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(ShowPickupInfo)

	Begin Object Class=KFGUI_CheckBox Name=UseVanillaScoreboard
		XPosition=0.55
		YPosition=0.55
		ID="UseVanillaScoreboard"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(UseVanillaScoreboard)

	Begin Object Class=KFGUI_ComboBox Name=ScoreboardSort
		XPosition=0.55
		YPosition=0.60
		XSize=0.350
		YSize=0.073
		OnComboChanged=ComboChanged
		ID="ScoreboardSort"
	End Object
	Components.Add(ScoreboardSort)
}

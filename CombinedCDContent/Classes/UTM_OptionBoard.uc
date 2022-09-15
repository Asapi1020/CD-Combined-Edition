/** =============================================================================
 *	 UTM_OptionBoard
 *  =============================================================================
 * 	 Main System
 * 	 Control test function
 *  ============================================================================= **/

class UTM_OptionBoard extends xUI_MenuBase
	dependson(Types)
	config(utm);

var KFGUI_Button CloseButton;
var KFGUI_Button MapVoteButton;
var KFGUI_Button WeapSkinButton;
var KFGUI_Button SubtractButton;
var KFGUI_Button AddButton;
var KFGUI_Button SpawnSCButton;
var KFGUI_Button SpawnFPButton;
var KFGUI_Button SpawnBothButton;
var KFGUI_Button SCSubButton;
var KFGUI_Button SCAddButton;
var KFGUI_Button FPSubButton;
var KFGUI_Button FPAddButton;
var KFGUI_Button DisSubButton;
var KFGUI_Button DisAddButton;
var KFGUI_Button ResetAccButton;
var KFGUI_Button KillZedButton;
var KFGUI_Button ZedtimeButton;
var KFGUI_Button StopSpawnButton;
var KFGUI_Button HitZoneButton;
var KFGUI_Button ZTSubButton;
var KFGUI_Button ZTAddButton;
var KFGUI_Button MedBuffButton;
var KFGUI_Button MBSubButton;
var KFGUI_Button MBAddButton;
var KFGUI_Button ClearCorpsesButton;
var KFGUI_Button EndWaveButton;
var KFGUI_Button SetWaveButton;
var KFGUI_Button NWSubButton;
var KFGUI_Button NWAddButton;
var KFGUI_Button HellishRageButton;
var KFGUI_Button TraderButton;
var KFGUI_Button SRSubButton;
var KFGUI_Button SRAddButton;
var KFGUI_Button MMSubButton;
var KFGUI_Button MMAddButton;
var KFGUI_Button MMDoubleSubButton;
var KFGUI_Button MMDoubleAddButton;
var KFGUI_Button CycleButton;
var KFGUI_Button WSFSubButton;
var KFGUI_Button WSFAddButton;
var KFGUI_Button CSSubButton;
var KFGUI_Button CSAddButton;
var KFGUI_Button SPSubButton;
var KFGUI_Button SPAddButton;
var KFGUI_Button LargeChallengeButton;
var KFGUI_Button TrashChallengeButton;

var KFGUI_CheckBox DamageMessageBox;
var KFGUI_CheckBox DamagePopupBox;
var KFGUI_CheckBox HealthBarBox;
var KFGUI_CheckBox AccBox;
var KFGUI_CheckBox HideTraderPathsBox;
var KFGUI_CheckBox AutoFillBox;
var KFGUI_CheckBox AutoNadeBox;
var KFGUI_CheckBox DemiGodBox;
var KFGUI_CheckBox GodBox;
var KFGUI_CheckBox SyringeBox;
var KFGUI_CheckBox ZedtimeBox;
var KFGUI_CheckBox RageSpawnBox;
var KFGUI_CheckBox AutoSpawnBox;
var KFGUI_CheckBox BrainDeadBox;
var KFGUI_CheckBox DisableRobotsBox;
var KFGUI_CheckBox LargeLessBox;
var KFGUI_CheckBox HSOnlyBox;

var KFGUI_ColumnList ZedList;

var UTM_PlayerController STMPC;
var UTM_GameReplicationInfo STMGRI;

var float TestF;
var config float ZTDilation;
var int MedBuffLevel;
var byte NewWaveNum;

struct ZedCombo
{
	var string FName;
	var string Code;
};

var array<ZedCombo> ZedsCombo;

function SetWindowDrag(bool bDrag)
{
	bDragWindow = false;
}

function UTM_PlayerController GetSTMPC()
{
	return UTM_PlayerController(GetPlayer());
}

function UTM_GameReplicationInfo GetSTMGRI()
{
	return UTM_GameReplicationInfo(GetSTMPC().WorldInfo.GRI);
}

function UTM_PlayerReplicationInfo GetUTMPRI()
{
	return UTM_PlayerReplicationInfo(GetSTMPC().PlayerReplicationInfo);
}

function InitMenu()
{
	super.InitMenu();

	ZedList = KFGUI_ColumnList(FindComponentID('Zeds'));
	ZedList.Columns.AddItem(newFColumnItem("Spawn Zed",1.f));
}

function DrawMenu()
{
	local float XPos, YPos, YL, XL, FontScalar, BoxW, BorderSize, Dist;
	local int Width, i;
	Super.DrawMenu();
	
//	Setup
	Canvas.Font = Owner.CurrentStyle.PickFont(FontScalar);
	Canvas.TextSize("ABC", XL, YL, FontScalar, FontScalar);
	BorderSize = Owner.HUDOwner.ScaledBorderSize;
	Width = Canvas.ClipX * 0.22;

// 	Display Settings
	XPos = YL;
	YPos = YL*2;
	BoxW = Width;
	DrawDisplaySettings(XPos, YPos, BoxW, YL, FontScalar, BorderSize);

//	Central Buttons
	DrawCentralButtons(YL, FontScalar, BorderSize);
	if(ZedList.ListCount != ZedsCombo.length)
	{
		ZedList.EmptyList();
		for(i=0; i<ZedsCombo.length; i++)
			ZedList.AddLine(ZedsCombo[i].FName);
	}

//	Player Settings
	Dist = SubtractButton.CompPos[0] - CompPos[0] - YL - Width;
	TestF = Dist/CompPos[2];
	XPos = AddButton.CompPos[0] - CompPos[0] + AddButton.CompPos[2] + Dist;
	YPos = YL*2;
	BoxW = Width;
	DrawPlayerSettings(XPos, YPos, BoxW, YL, FontScalar, BorderSize);

//	Wave Settings
	YPos = HellishRageButton.CompPos[1] - CompPos[1] + HellishRageButton.CompPos[3] + YL*2;
	DrawWaveSettings(XPos, YPos, BoxW, YL, FontScalar, BorderSize);	

//	Game Settings
	XPos = YL;
	YPos = HitZoneButton.CompPos[1] - CompPos[1] + HitZoneButton.CompPos[3] + YL*2;
	BoxW = Width;
	DrawGameSettings(XPos, YPos, BoxW, YL, FontScalar, BorderSize);

//	Close Button (bottom)
	CloseButton = KFGUI_Button(FindComponentID('Close'));
	CloseButton.ButtonText="Close";

	MapVoteButton = KFGUI_Button(FindComponentID('MapVote'));
	MapVoteButton.ButtonText="Map Vote";

	WeapSkinButton = KFGUI_Button(FindComponentID('WeapSkin'));
	WeapSkinButton.ButtonText="Weapon Skin";

	GetSTMPC().SaveSTMSettings();
	WindowTitle="Ultimate Test Mode for CD";
}

function DrawDisplaySettings(float XPos, float YPos, float BoxW, float YL, float FontScalar, float BorderSize)
{
	DrawCategolyZone("Display Settings", XPos, YPos, BoxW, YL*15, FontScalar, BorderSize, YL);

	DamageMessageBox = KFGUI_CheckBox(FindComponentID('DamageMessage'));
	DamageMessageBox.bChecked=GetSTMPC().bShowDamageMsg;
	DrawBoxDescription("Damage Message", DamageMessageBox, 0.25);

	DamagePopupBox = KFGUI_CheckBox(FindComponentID('DamagePopup'));
	DamagePopupBox.bChecked=GetSTMPC().bShowDamagePopup;
	DrawBoxDescription("Damage Popup", DamagePopupBox, 0.25);

	HealthBarBox = KFGUI_CheckBox(FindComponentID('HealthBar'));
	HealthBarBox.bChecked=GetSTMPC().bShowZedHealth;
	DrawBoxDescription("Zed Health Bar", HealthBarBox, 0.25);

	AccBox = KFGUI_CheckBox(FindComponentID('Acc'));
	AccBox.bChecked=GetSTMPC().bShowAcc;
	DrawBoxDescription("Accuracy", AccBox, 0.25);

	HideTraderPathsBox = KFGUI_CheckBox(FindComponentID('HideTraderPaths'));
	HideTraderPathsBox.bChecked = GetSTMPC().bHideTraderPaths;
	DrawBoxDescription("Hide Trader Paths", HideTraderPathsBox, 0.25);

	ResetAccButton = KFGUI_Button(FindComponentID('ResetAcc'));
	ResetAccButton.ButtonText="Reset Accuracy";

	HitZoneButton = KFGUI_Button(FindComponentID('HitZone'));
	HitZoneButton.ButtonText="Hit Zones";
	if(GetSTMPC().WorldInfo.NetMode != NM_StandAlone)
		HitZoneButton.bDisabled = true;

	ClearCorpsesButton = KFGUI_Button(FindComponentID('ClearCorpses'));
	ClearCorpsesButton.ButtonText = "Clear Corpses";
}

function DrawPlayerSettings(float XPos, float YPos, float BoxW, float YL, float FontScalar, float BorderSize)
{
	DrawCategolyZone("Player Settings", XPos, YPos, BoxW, YL*13, FontScalar, BorderSize, YL);

	AutoFillBox = KFGUI_CheckBox(FindComponentID('AutoFill'));
	AutoFillBox.bChecked=GetSTMPC().bAutoFillMag;
	DrawBoxDescription("Auto Fill Magazine", AutoFillBox, 0.95);

	AutoNadeBox = KFGUI_CheckBox(FindComponentID('AutoNade'));
	AutoNadeBox.bChecked=GetSTMPC().bAutoFillNade;
	DrawBoxDescription("Auto Fill Grenade", AutoNadeBox, 0.95);

	DemiGodBox = KFGUI_CheckBox(FindComponentID('DemiGod'));
	DemiGodBox.bChecked=GetSTMPC().bDemiGodMode;
	DrawBoxDescription("DemiGod", DemiGodBox, 0.95);

	GodBox = KFGUI_CheckBox(FindComponentID('God'));
	GodBox.bChecked=GetSTMPC().bGodMode;
	DrawBoxDescription("God", GodBox, 0.95);

	SyringeBox = KFGUI_CheckBox(FindComponentID('Syringe'));
	SyringeBox.bChecked=GetSTMPC().bUltraSyringe;
	DrawBoxDescription("Ultra Syringe", SyringeBox, 0.95);

	MBSubButton = KFGUI_Button(FindComponentID('MBSub'));
	MBSubButton.ButtonText="-";
	MBAddButton = KFGUI_Button(FindComponentID('MBAdd'));
	MBAddButton.ButtonText="+";
	DrawControllerInfo("Medic Buff", string(MedBuffLevel), MBSubButton, MBAddButton, YL, FontScalar, BorderSize, 10);

	HellishRageButton = KFGUI_Button(FindComponentID('HellishRage'));
	HellishRageButton.ButtonText = "Hellish Rage";
}

function DrawWaveSettings(float XPos, float YPos, float BoxW, float YL, float FontScalar, float BorderSize)
{
	DrawCategolyZone("Wave Settings", XPos, YPos, BoxW, YL*18, FontScalar, BorderSize, YL);

	DisableRobotsBox = KFGUI_CheckBox(FindComponentID('DisableRobots'));
	DisableRobotsBox.bChecked = GetSTMGRI().bDisableRobots;
	DrawBoxDescription("Disable Robots", DisableRobotsBox, 0.95);

	LargeLessBox = KFGUI_CheckBox(FindComponentID('LargeLess'));
	LargeLessBox.bChecked = GetSTMGRI().bLargeLess;
	DrawBoxDescription("Large Less", LargeLessBox, 0.95);

	EndWaveButton = KFGUI_Button(FindComponentID('EndWave'));
	EndWaveButton.ButtonText = "End Wave";

	SetWaveButton = KFGUI_Button(FindComponentID('SetWave'));
	SetWaveButton.ButtonText = "Set Wave";

	NWSubButton = KFGUI_Button(FindComponentID('NWSub'));
	NWSubButton.ButtonText = "-";
	NWAddButton = KFGUI_Button(FindComponentID('NWAdd'));
	NWAddButton.ButtonText = "+";
	DrawControllerInfo("New Wave", string(NewWaveNum), NWSubButton, NWAddButton, YL, FontScalar, BorderSize, 10);

	MMDoubleSubButton = KFGUI_Button(FindComponentID('MMDoubleSub'));
	MMDoubleSubButton.ButtonText = "-4";
	MMDoubleAddButton = KFGUI_Button(FindComponentID('MMDoubleAdd'));
	MMDoubleAddButton.ButtonText = "+4";
	MMSubButton = KFGUI_Button(FindComponentID('MMSub'));
	MMSubButton.ButtonText = "-2";
	MMAddButton = KFGUI_Button(FindComponentID('MMAdd'));
	MMAddButton.ButtonText = "+2";
	DrawMMInfo(YL, FontScalar, BorderSize);

	CycleButton = KFGUI_Button(FindComponentID('Cycle'));
	CycleButton.ButtonText = "Spawn Cycle";

	WSFSubButton = KFGUI_Button(FindComponentID('WSFSub'));
	WSFSubButton.ButtonText = "-";
	WSFAddButton = KFGUI_Button(FindComponentID('WSFAdd'));
	WSFAddButton.ButtonText = "+";
	DrawControllerInfo("WSF", GetSTMGRI().CDInfoParams.WSF, WSFSubButton, WSFAddButton, YL, FontScalar, BorderSize, 10);

	CSSubButton = KFGUI_Button(FindComponentID('CSSub'));
	CSSubButton.ButtonText = "-";
	CSAddButton = KFGUI_Button(FindComponentID('CSAdd'));
	CSAddButton.ButtonText = "+";
	DrawControllerInfo("CS", GetSTMGRI().CDInfoParams.CS, CSSubButton, CSAddButton, YL, FontScalar, BorderSize, 10);

	SPSubButton = KFGUI_Button(FindComponentID('SPSub'));
	SPSubButton.ButtonText = "-";
	SPAddButton = KFGUI_Button(FindComponentID('SPAdd'));
	SPAddButton.ButtonText = "+";
	DrawControllerInfo("SP", GetSTMGRI().CDInfoParams.SP, SPSubButton, SPAddButton, YL, FontScalar, BorderSize, 10);
}



function DrawMMInfo(float YL, float FontScalar, float BorderSize)
{
	local float XPos, YPos, BoxW;
	local KFGUI_Button LB, RB;

	//	Header
	LB = MMDoubleSubButton;
	RB = MMDoubleAddButton;
	XPos = LB.CompPos[0] - CompPos[0];
	YPos = LB.CompPos[1] - CompPos[1] - YL - BorderSize;
	BoxW = RB.CompPos[0] - LB.CompPos[0] + RB.CompPos[2];

	Canvas.SetDrawColor(0, 0, 0, 200);
	Owner.CurrentStyle.DrawRectBox(XPos, YPos, BoxW, YL + BorderSize, 8.f, 150);
	Canvas.SetDrawColor(250, 250, 250, 255);
	DrawTextShadowHVCenter("Max Monsters", XPos, YPos, BoxW, FontScalar);

	//	Value
	LB = MMSubButton;
	RB = MMAddButton;
	XPos = LB.CompPos[0] - CompPos[0] + LB.CompPos[2];
	YPos += YL + BorderSize;
	BoxW = RB.CompPos[0] - LB.CompPos[0] - LB.CompPos[2] + BorderSize;

	Canvas.SetDrawColor(10, 10, 10, 200);
	Owner.CurrentStyle.DrawRectBox(XPos, YPos, BoxW, RB.CompPos[3], 8.f, 121);
	Canvas.SetDrawColor(250, 250, 250, 255);
	DrawTextShadowHVCenter(GetSTMGRI().CDInfoParams.MM, XPos, YPos + (RB.CompPos[3]/6), BoxW, FontScalar);
}

function DrawCentralButtons(float YL, float FontScalar, float BorderSize)
{
	SubtractButton = KFGUI_Button(FindComponentID('Subtract'));
	SubtractButton.ButtonText="-";
	AddButton = KFGUI_Button(FindComponentID('Add'));
	AddButton.ButtonText="+";
	DrawControllerInfo("HP Control", GetSTMGRI().nFakedPlayers$"P HP", SubtractButton, AddButton, YL, FontScalar, BorderSize, 30, 1.5);

	SpawnSCButton = KFGUI_Button(FindComponentID('SC'));
	SpawnSCButton.ButtonText="Spawn SC";
	SpawnFPButton = KFGUI_Button(FindComponentID('FP'));
	SpawnFPButton.ButtonText="Spawn FP";
	SpawnBothButton = KFGUI_Button(FindComponentID('Both'));
	SpawnBothButton.ButtonText="Multi Spawn";

	SCSubButton = KFGUI_Button(FindComponentID('SCSub'));
	SCSubButton.ButtonText="-";
	SCAddButton = KFGUI_Button(FindComponentID('SCAdd'));
	SCAddButton.ButtonText="+";
	DrawControllerInfo("SC", string(GetSTMPC().SCNum), SCSubButton, SCAddButton, YL, FontScalar, BorderSize, 30);

	FPSubButton = KFGUI_Button(FindComponentID('FPSub'));
	FPSubButton.ButtonText="-";
	FPAddButton = KFGUI_Button(FindComponentID('FPAdd'));
	FPAddButton.ButtonText="+";
	DrawControllerInfo("FP", string(GetSTMPC().FPNum), FPSubButton, FPAddButton, YL, FontScalar, BorderSize, 30);

	DisSubButton = KFGUI_Button(FindComponentID('DisSub'));
	DisSubButton.ButtonText="-";
	DisAddButton = KFGUI_Button(FindComponentID('DisAdd'));
	DisAddButton.ButtonText="+";
	DrawControllerInfo("Distance", string(GetSTMPC().SpawnDistance) $ "m", DisSubButton, DisAddButton, YL, FontScalar, BorderSize, 30);

	KillZedButton = KFGUI_Button(FindComponentID('KillZed'));
	KillZedButton.ButtonText="Kill Zeds";

	TraderButton = KFGUI_Button(FindComponentID('Trader'));
	TraderButton.ButtonText = "Open Trader";

	LargeChallengeButton = KFGUI_Button(FindComponentID('LargeChallenge'));
	LargeChallengeButton.ButtonText = "Large Challenge";

	TrashChallengeButton = KFGUI_Button(FindComponentID('TrashChallenge'));
	TrashChallengeButton.ButtonText = "Trash Challenge";
	if(GetSTMPC().WorldInfo.NetMode != NM_StandAlone)
		TrashChallengeButton.bDisabled = true;
}

function DrawGameSettings(float XPos, float YPos, float BoxW, float YL, float FontScalar, float BorderSize)
{
	DrawCategolyZone("Game Settings", XPos, YPos, BoxW, YL*16, FontScalar, BorderSize, YL);

	ZedtimeBox = KFGUI_CheckBox(FindComponentID('DisableZedtime'));
	ZedtimeBox.bChecked=GetSTMGRI().bDisableZedTime;
	DrawBoxDescription("Disable Zedtime", ZedtimeBox, 0.25);

	RageSpawnBox = KFGUI_CheckBox(FindComponentID('RageSpawn'));
	RageSpawnBox.bChecked=GetSTMGRI().bSpawnRaged;
	DrawBoxDescription("Rage Spawn", RageSpawnBox, 0.25);

	AutoSpawnBox = KFGUI_CheckBox(FindComponentID('AutoSpawn'));
	AutoSpawnBox.bChecked=GetSTMPC().bAutoSpawn;
	DrawBoxDescription("Auto Spawn", AutoSpawnBox, 0.25);

	BrainDeadBox = KFGUI_CheckBox(FindComponentID('BrainDead'));
	BrainDeadBox.bChecked=GetSTMPC().bSpawnBrainDead;
	DrawBoxDescription("Spawn Brain Dead", BrainDeadBox, 0.25);

	HSOnlyBox = KFGUI_CheckBox(FindComponentID('HSOnly'));
	HSOnlyBox.bChecked=GetSTMGRI().bHSOnly;
	DrawBoxDescription("Headshots Only", HSOnlyBox, 0.25);

	if(ZTDilation < 1.f || 20.f < ZTDilation)
		ZTDilation = 3.f;
	ZedtimeButton = KFGUI_Button(FindComponentID('Zedtime'));
	ZedtimeButton.ButtonText="Zedtime";
	ZTSubButton = KFGUI_Button(FindComponentID('ZTSub'));
	ZTSubButton.ButtonText="-";
	ZTAddButton = KFGUI_Button(FindComponentID('ZTAdd'));
	ZTAddButton.ButtonText="+";
	DrawControllerInfo("Duration", string((round(ZTDilation)))$"sec", ZTSubButton, ZTAddButton, YL, FontScalar, BorderSize, 10);

	StopSpawnButton = KFGUI_Button(FindComponentID('StopSpawn'));
	StopSpawnButton.ButtonText="Stop Spawn";
	SRSubButton = KFGUI_Button(FindComponentID('SRSub'));
	SRSubButton.ButtonText="-";
	SRAddButton = KFGUI_Button(FindComponentID('SRAdd'));
	SRAddButton.ButtonText="+";
	DrawControllerInfo("Spawn Rate", string((round(GetSTMPC().ForceSpawnRate)))$"sec", SRSubButton, SRAddButton, YL, FontScalar, BorderSize, 10);
}

function DrawCategolyZone(string Title, float XPos, float YPos, float ZoneWidth, float ZoneHight, float FontScalar, float BorderSize, float YL)
{
	Canvas.SetDrawColor(75, 0, 0, 200);
	Owner.CurrentStyle.DrawRectBox(XPos, YPos, ZoneWidth, YL+BorderSize, 8.f, 0);
	Canvas.SetDrawColor(250, 250, 250, 255);
	DrawTextShadowHVCenter(Title, XPos, YPos, ZoneWidth, FontScalar);
	Canvas.SetDrawColor(30, 30, 30, 200);
	Owner.CurrentStyle.DrawRectBox(XPos, YPos+YL+BorderSize, ZoneWidth, ZoneHight+BorderSize, 8.f, 152);
}

function FColumnItem newFColumnItem(string Text, float Width)
{
	local FColumnItem newItem;
	newItem.Text=Text;
	newItem.Width=Width;
	return newItem;
}

function ButtonClicked(KFGUI_Button Sender)
{
	switch (Sender.ID)
	{
		case 'Close':
			DoClose();
			break;
		case 'MapVote':
			GetSTMPC().OpenMapVote();
			DoClose();
			break;
		case 'WeapSkin':
			GetSTMPC().OpenWeapSkinMenu();
			DoClose();
			break;
		case 'Subtract':
			GetSTMPC().RemoveFakedPlayer();
			break;
		case 'Add':
			GetSTMPC().AddFakedPlayer();
			break;
		case 'SC':
			GetSTMPC().SpawnSTMZed("SC", none, GetSTMPC().bSpawnBrainDead);
			DoClose();
			break;
		case 'FP':
			GetSTMPC().SpawnSTMZed("FP", none, GetSTMPC().bSpawnBrainDead);
			DoClose();
			break;
		case 'Both':
			GetSTMPC().SpawnSTMZed("Both", none, GetSTMPC().bSpawnBrainDead);
			DoClose();
			break;
		case 'ResetAcc':
			KFPlayerController(GetPlayer()).ShotsFired=0;
			KFPlayerController(GetPlayer()).ShotsHit=0;
			KFPlayerController(GetPlayer()).ShotsHitHeadshot=0;
			break;
		case 'KillZed':
			GetSTMPC().STMKillZeds();
			break;
		case 'Zedtime':
			GetSTMPC().STMDo("Zedtime" @ string(ZTDilation));
			break;
		case 'HitZone':
			GetSTMPC().ConsoleCommand("Show HitZones");
			break;
		case 'ZTSub':
			ZTDilation = Max(ZTDilation-1.f, 1.f);
			SaveConfig();
			break;
		case 'ZTAdd':
			ZTDilation = Min(ZTDilation+1.f, 20.f);
			SaveConfig();
			break;
		case 'MBSub':
			MedBuffLevel = Max(MedBuffLevel-1, 0);
			GetSTMPC().STMDo("Buff"@string(MedBuffLevel));
			break;
		case 'MBAdd':
			MedBuffLevel = Min(MedBuffLevel+1, 4);
			GetSTMPC().STMDo("Buff"@string(MedBuffLevel));
			break;
		case 'ClearCorpses':
			GetSTMPC().UTMClearCorpses();
			break;
		case 'EndWave':
			GetSTMPC().ServerEndWave();
			break;
		case 'SetWave':
			GetSTMPC().ServerSetWave(NewWaveNum);
			break;
		case 'NWSub':
			NewWaveNum = Max(NewWaveNum-1, 1);
			break;
		case 'NWAdd':
			NewWaveNum = Min(NewWaveNum+1, GetSTMGRI().WaveMax);
			break;
		case 'HellishRage':
			GetSTMPC().GetHellishRage();
			break;
		case 'Trader':
			GetSTMPC().OpenTraderMenuFromSTMOptions();
			DoClose();
			break;
		case 'StopSpawn':
			GetSTMPC().StopAutoSpawn();
			break;
		case 'SRSub':
			GetSTMPC().ForceSpawnRate = Max(1.f, GetSTMPC().ForceSpawnRate-1.f);
			GetSTMPC().SaveConfig();
			break;
		case 'SRAdd':
			GetSTMPC().ForceSpawnRate = Min(20.f, GetSTMPC().ForceSpawnRate+1.f);
			GetSTMPC().SaveConfig();
			break;
		case 'MMDoubleSub':
			GetSTMPC().SetMM(int(GetSTMGRI().CDInfoParams.MM)-4);
			break;
		case 'MMDoubleAdd':
			GetSTMPC().SetMM(int(GetSTMGRI().CDInfoParams.MM)+4);
			break;
		case 'MMSub':
			GetSTMPC().SetMM(int(GetSTMGRI().CDInfoParams.MM)-2);
			break;
		case 'MMAdd':
			GetSTMPC().SetMM(int(GetSTMGRI().CDInfoParams.MM)+2);
			break;
		case 'Cycle':
			GetSTMPC().OpenCycleMenu();
			break;
		case 'WSFSub':
			GetSTMPC().SetWSF(int(GetSTMGRI().CDInfoParams.WSF)-1);
			break;
		case 'WSFAdd':
			GetSTMPC().SetWSF(int(GetSTMGRI().CDInfoParams.WSF)+1);
			break;
		case 'CSSub':
			GetSTMPC().SetCS(int(GetSTMGRI().CDInfoParams.CS)-1);
			break;
		case 'CSAdd':
			GetSTMPC().SetCS(int(GetSTMGRI().CDInfoParams.CS)+1);
			break;
		case 'SPSub':
			GetSTMPC().SetSP(float(GetSTMGRI().CDInfoParams.SP)-0.1f);
			break;
		case 'SPAdd':
			GetSTMPC().SetSP(float(GetSTMGRI().CDInfoParams.SP)+0.1f);
			break;
		case 'LargeChallenge':
			GetSTMPC().SpawnSTMZed("Large", none, false);
    		GetSTMPC().ShowMessageBar('Priority', "Large Challenge", "50 larges are coming!");
			DoClose();
			break;
		case 'TrashChallenge':
			GetSTMPC().StartTrashChallenge();
			DoClose();
			break;
		case 'SCSub':
			GetSTMPC().SCNum = Max(GetSTMPC().SCNum-1, 0);
			GetSTMPC().SaveConfig();
			break;
		case 'SCAdd':
			GetSTMPC().SCNum = Min(GetSTMPC().SCNum+1, 6);
			if(GetSTMPC().SCNum+GetSTMPC().FPNum>6) --GetSTMPC().FPNum;
			GetSTMPC().SaveConfig();
			break;
		case 'FPSub':
			GetSTMPC().FPNum = Max(GetSTMPC().FPNum-1, 0);
			GetSTMPC().SaveConfig();
			break;
		case 'FPAdd':
			GetSTMPC().FPNum = Min(GetSTMPC().FPNum+1, 6);
			if(GetSTMPC().SCNum+GetSTMPC().FPNum>6) --GetSTMPC().SCNum;
			GetSTMPC().SaveConfig();
			break;
		case 'DisSub':
			GetSTMPC().SpawnDistance = Max(GetSTMPC().SpawnDistance-1, 2);
			GetSTMPC().SaveConfig();
			break;
		case 'DisAdd':
			GetSTMPC().SpawnDistance = Min(GetSTMPC().SpawnDistance+1, 30);
			GetSTMPC().SaveConfig();
			break;
	}
}

function ToggleCheckBox(KFGUI_CheckBox Sender)
{
	switch (Sender.ID)
	{
		case 'DamageMessage':
			GetSTMPC().bShowDamageMsg = Sender.bChecked;
			GetSTMPC().SaveSTMSettings();
			break;
		case 'DamagePopup':
			GetSTMPC().bShowDamagePopup = Sender.bChecked;
			GetSTMPC().SaveSTMSettings();
			break;
		case 'HealthBar':
			GetSTMPC().bShowZedHealth = Sender.bChecked;
			GetSTMPC().SaveSTMSettings();
			break;
		case 'Acc':
			GetSTMPC().bShowAcc = Sender.bChecked;
			GetSTMPC().SaveSTMSettings();
			break;
		case 'HideTraderPaths':
			GetSTMPC().bHideTraderPaths = Sender.bChecked;
			GetSTMPC().SaveConfig();
			break;
		case 'AutoFill':
			GetSTMPC().bAutoFillMag = Sender.bChecked;
			GetSTMPC().SaveSTMSettings();
			break;
		case 'AutoNade':
			GetSTMPC().bAutoFillNade = Sender.bChecked;
			GetSTMPC().SaveSTMSettings();
			break;
		case 'DemiGod':
			GetSTMPC().bDemiGodMode = Sender.bChecked;
			GetSTMPC().bImDemiGod = Sender.bChecked;
			GetSTMPC().SaveSTMSettings();
			break;
		case 'God':
			GetSTMPC().bGodMode = Sender.bChecked;
			GetSTMPC().bImGod = Sender.bChecked;
			GetSTMPC().SaveSTMSettings();
			break;
		case 'Syringe':
			GetSTMPC().bUltraSyringe = Sender.bChecked;
			GetSTMPC().SaveConfig();
			break;
		case 'DisableZedtime':
			GetSTMPC().SetDisableZedtime(Sender.bChecked);
			break;
		case 'RageSpawn':
			GetSTMPC().SetRageSpawn(Sender.bChecked);
			break;
		case 'AutoSpawn':
			GetSTMPC().bAutoSpawn = Sender.bChecked;
			GetSTMPC().SaveSTMSettings();
			break;
		case 'BrainDead':
			GetSTMPC().bSpawnBrainDead = Sender.bChecked;
			GetSTMPC().SaveSTMSettings();
			break;
		case 'DisableRobots':
			GetSTMPC().SetDisableRobots(Sender.bChecked);
			break;
		case 'LargeLess':
			GetSTMPC().SetLargeLess(Sender.bChecked);
			break;
		case 'HSOnly':
			GetSTMPC().SetHSOnly(Sender.bChecked);
			break;
	}
}

function SelectedListRow(KFGUI_ListItem Item, int Row, bool bRight, bool bDblClick)
{
	if(bDblClick)
	{
		GetSTMPC().SpawnSTMZed(ZedsCombo[Row].Code, none, GetSTMPC().bSpawnBrainDead);
		DoClose();
		return;
	}
}

defaultproperties
{
	XPosition=0.18
	YPosition=0.05
	XSize=0.64
	YSize=0.9
	NewWaveNum=1

//	General
	Begin Object Class=KFGUI_Button Name=CloseButton
		XPosition=0.45
		YPosition=0.94
		XSize=0.1
		YSize=0.05
		ID="Close"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=MapVote
		XPosition=0.39
		YPosition=0.87
		XSize=0.1
		YSize=0.05
		ID="MapVote"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=WeapSkin
		XPosition=0.51
		YPosition=0.87
		XSize=0.1
		YSize=0.05
		ID="WeapSkin"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Components.Add(CloseButton)
	Components.Add(MapVote)
	Components.Add(WeapSkin)

//	Display Settings
	Begin Object Class=KFGUI_CheckBox Name=DamageMessage
		XPosition=0.04
		YPosition=0.10
		ID="DamageMessage"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=DamagePopup
		XPosition=0.04
		YPosition=0.15
		ID="DamagePopup"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=HealthBar
		XPosition=0.04
		YPosition=0.20
		ID="HealthBar"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=Acc
		XPosition=0.04
		YPosition=0.25
		ID="Acc"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=HideTraderPaths
		XPosition=0.04
		YPosition=0.30
		ID="HideTraderPaths"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_Button Name=ResetAcc
		XPosition=0.05
		YPosition=0.35
		XSize=0.15
		YSize=0.05
		ID="ResetAcc"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=HitZone
		XPosition=0.05
		YPosition=0.4125
		XSize=0.1
		YSize=0.05
		ID="HitZone"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=ClearCorpses
		XPosition=0.175
		YPosition=0.4125
		XSize=0.1
		YSize=0.05
		ID="ClearCorpses"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Components.Add(DamageMessage)
	Components.Add(DamagePopup)
	Components.Add(HealthBar)
	Components.Add(Acc)
	Components.Add(HideTraderPaths)
	Components.Add(ResetAcc)
	Components.Add(HitZone)
	Components.Add(ClearCorpses)

//	HP Controller
	Begin Object Class=KFGUI_Button Name=SubtractButton
		XPosition=0.375
		YPosition=0.10
		XSize=0.05
		YSize=0.05
		FontScale=4
		ID="Subtract"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=AddButton
		XPosition=0.575
		YPosition=0.10
		XSize=0.05
		YSize=0.05
		FontScale=3
		ID="Add"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

//	Player Settings
	Begin Object Class=KFGUI_CheckBox Name=AutoFill
		XPosition=0.72
		YPosition=0.10
		ID="AutoFill"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=AutoNade
		XPosition=0.72
		YPosition=0.15
		ID="AutoNade"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=DemiGod
		XPosition=0.72
		YPosition=0.20
		ID="DemiGod"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=God
		XPosition=0.72
		YPosition=0.25
		ID="God"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=Syringe
		XPosition=0.72
		YPosition=0.30
		ID="Syringe"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_Button Name=HellishRage
		XPosition=0.73 //0.55
		YPosition=0.36 //0.50
		XSize=0.1
		YSize=0.05
		ID="HellishRage"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=MBSub
		XPosition=0.84 //0.66
		YPosition=0.375 //0.515
		XSize=0.025
		YSize=0.035
		ID="MBSub"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		FontScale=1.4
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=MBAdd
		XPosition=0.915 //0.735
		YPosition=0.375 //0.515
		XSize=0.025
		YSize=0.035
		ID="MBAdd"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Components.Add(AutoFill)
	Components.Add(AutoNade)
	Components.Add(DemiGod)
	Components.Add(God)
	Components.Add(Syringe)
	Components.Add(MBSub)
	Components.Add(MBAdd)
	Components.Add(HellishRage)

//	Wave Settings
	Begin Object Class=KFGUI_CheckBox Name=DisableRobots
		XPosition=0.72
		YPosition=0.5125
		ID="DisableRobots"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=LargeLess
		XPosition=0.72
		YPosition=0.5625
		ID="LargeLess"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_Button Name=EndWave
		XPosition=0.73 //0.55
		YPosition=0.6125 //0.575
		XSize=0.1
		YSize=0.05
		ID="EndWave"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=SetWave
		XPosition=0.73 //0.55
		YPosition=0.675 //0.65
		XSize=0.1
		YSize=0.05
		ID="SetWave"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=NWSub
		XPosition=0.84 //0.66
		YPosition=0.69 //0.665
		XSize=0.025
		YSize=0.035
		ID="NWSub"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		FontScale=1.4
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=NWAdd
		XPosition=0.915 //0.735
		YPosition=0.69 //0.665
		XSize=0.025
		YSize=0.035
		ID="NWAdd"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=MMSub
		XPosition=0.77
		YPosition=0.76
		XSize=0.04
		YSize=0.05
		ID="MMSub"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=MMAdd
		XPosition=0.87
		YPosition=0.76
		XSize=0.04
		YSize=0.05
		ID="MMAdd"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=MMDoubleSub
		XPosition=0.72
		YPosition=0.76
		XSize=0.05
		YSize=0.05
		ID="MMDoubleSub"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		ButtonStyle=151
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=MMDoubleAdd
		XPosition=0.91
		YPosition=0.76
		XSize=0.05
		YSize=0.05
		ID="MMDoubleAdd"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		ButtonStyle=153
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=Cycle
		XPosition=0.73
		YPosition=0.835
		XSize=0.1
		YSize=0.05
		ID="Cycle"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=WSFSub
		XPosition=0.84
		YPosition=0.85
		XSize=0.025
		YSize=0.035
		ID="WSFSub"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		FontScale=1.4
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=WSFAdd
		XPosition=0.915
		YPosition=0.85
		XSize=0.025
		YSize=0.035
		ID="WSFAdd"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=CSSub
		XPosition=0.73
		YPosition=0.92
		XSize=0.025
		YSize=0.035
		ID="CSSub"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		FontScale=1.4
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=CSAdd
		XPosition=0.805
		YPosition=0.92
		XSize=0.025
		YSize=0.035
		ID="CSAdd"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=SPSub
		XPosition=0.84
		YPosition=0.92
		XSize=0.025
		YSize=0.035
		ID="SPSub"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		FontScale=1.4
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=SPAdd
		XPosition=0.915
		YPosition=0.92
		XSize=0.025
		YSize=0.035
		ID="SPAdd"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Components.Add(DisableRobots)
	Components.Add(LargeLess)
	Components.Add(EndWave)
	Components.Add(SetWave)
	Components.Add(NWSub)
	Components.Add(NWAdd)
	Components.Add(MMDoubleSub)
	Components.Add(MMDoubleAdd)
	Components.Add(MMSub)
	Components.Add(MMAdd)
	Components.Add(Cycle)
	Components.Add(WSFSub)
	Components.Add(WSFAdd)
	Components.Add(CSSub)
	Components.Add(CSAdd)
	Components.Add(SPSub)
	Components.Add(SPAdd)

//	Central Buttons
	Begin Object Class=KFGUI_Button Name=SC
		XPosition=0.39
		YPosition=0.175
		XSize=0.1
		YSize=0.05
		ID="SC"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=FP
		XPosition=0.51
		YPosition=0.175
		XSize=0.1
		YSize=0.05
		ID="FP"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=Both
		XPosition=0.34
		YPosition=0.25
		XSize=0.12
		YSize=0.075
		ID="Both"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=SCSub
		XPosition=0.48
		YPosition=0.29
		XSize=0.025
		YSize=0.035
		ID="SCSub"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		FontScale=1.4
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=SCAdd
		XPosition=0.535
		YPosition=0.29
		XSize=0.025
		YSize=0.035
		ID="SCAdd"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=FPSub
		XPosition=0.565
		YPosition=0.29
		XSize=0.025
		YSize=0.035
		ID="FPSub"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		FontScale=1.4
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=FPAdd
		XPosition=0.62
		YPosition=0.29
		XSize=0.025
		YSize=0.035
		ID="FPAdd"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=DisSub
		XPosition=0.55
		YPosition=0.39
		XSize=0.025
		YSize=0.035
		ID="DisSub"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		FontScale=1.4
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=DisAdd
		XPosition=0.625
		YPosition=0.39
		XSize=0.025
		YSize=0.035
		ID="DisAdd"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=KillZed
		XPosition=0.55
		YPosition=0.45
		XSize=0.1
		YSize=0.05
		ID="KillZed"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=Trader
		XPosition=0.55
		YPosition=0.525
		XSize=0.1
		YSize=0.05
		ID="Trader"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=LargeChallenge
		XPosition=0.34
		YPosition=0.75
		XSize=0.15
		YSize=0.05
		ID="LargeChallenge"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=TrashChallenge
		XPosition=0.51
		YPosition=0.75
		XSize=0.15
		YSize=0.05
		ID="TrashChallenge"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Components.Add(SubtractButton)
	Components.Add(AddButton)
	Components.Add(SC)
	Components.Add(FP)
	Components.Add(Both)
	Components.Add(SCSub)
	Components.Add(SCAdd)
	Components.Add(FPSub)
	Components.Add(FPAdd)
	Components.Add(DisSub)
	Components.Add(DisAdd)
	Components.Add(KillZed)
	Components.Add(Trader)
	Components.Add(LargeChallenge)
	Components.Add(TrashChallenge)

//	Game Settings
	Begin Object Class=KFGUI_CheckBox Name=DisableZedtime
		XPosition=0.04
		YPosition=0.56
		ID="DisableZedtime"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=RageSpawn
		XPosition=0.04
		YPosition=0.61
		ID="RageSpawn"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=AutoSpawn
		XPosition=0.04
		YPosition=0.66
		ID="AutoSpawn"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=BrainDead
		XPosition=0.04
		YPosition=0.71
		ID="BrainDead"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=HSOnly
		XPosition=0.04
		YPosition=0.76
		ID="HSOnly"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_Button Name=Zedtime
		XPosition=0.05 //0.55
		YPosition=0.82 //0.425
		XSize=0.1
		YSize=0.05
		ID="Zedtime"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=ZTSub
		XPosition=0.16 //0.66
		YPosition=0.835 //0.44
		XSize=0.025
		YSize=0.035
		ID="ZTSub"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		FontScale=1.4
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=ZTAdd
		XPosition=0.235 //0.735
		YPosition=0.835 //0.44
		XSize=0.025
		YSize=0.035
		ID="ZTAdd"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=StopSpawn
		XPosition=0.05
		YPosition=0.905
		XSize=0.1
		YSize=0.05
		ID="StopSpawn"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=SRSub
		XPosition=0.16
		YPosition=0.92
		XSize=0.025
		YSize=0.035
		ID="SRSub"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		FontScale=1.4
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=SRAdd
		XPosition=0.235
		YPosition=0.92
		XSize=0.025
		YSize=0.035
		ID="SRAdd"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Components.Add(DisableZedtime)
	Components.Add(RageSpawn)
	Components.Add(AutoSpawn)
	Components.Add(BrainDead)
	Components.Add(HSOnly)
	Components.Add(Zedtime)
	Components.Add(ZTSub)
	Components.Add(ZTAdd)
	Components.Add(StopSpawn)
	Components.Add(SRSub)
	Components.Add(SRAdd)

//	List
	Begin Object Class=KFGUI_ColumnList Name=ZedList
		XPosition=0.33
		YPosition=0.36
		XSize=0.20
		YSize=0.35
		ID="Zeds"
		OnSelectedRow=SelectedListRow
		bCanSortColumn=false
	End Object

	Components.Add(ZedList)

//	ZedsCombo
	ZedsCombo.Add((FName="Cyst", Code="Cy"))
	ZedsCombo.Add((FName="Alpha Clot", Code="Al"))
	ZedsCombo.Add((FName="Slasher", Code="Sl"))
	ZedsCombo.Add((FName="Rioter", Code="Al*"))
	ZedsCombo.Add((FName="Gorefast", Code="Gf"))
	ZedsCombo.Add((FName="Gorefiend", Code="Gf*"))
	ZedsCombo.Add((FName="Crawler", Code="Cr"))
	ZedsCombo.Add((FName="Elite Crawler", Code="Cr*"))
	ZedsCombo.Add((FName="Stalker", Code="St"))
	ZedsCombo.Add((FName="Bloat", Code="Bl"))
	ZedsCombo.Add((FName="Siren", Code="Si"))
	ZedsCombo.Add((FName="Husk", Code="Hu"))
	ZedsCombo.Add((FName="EDAR Trapper", Code="DE"))
	ZedsCombo.Add((FName="EDAR Blaster", Code="DL"))
	ZedsCombo.Add((FName="EDAR Bomber", Code="DR"))
	ZedsCombo.Add((FName="Quarterpound", Code="QP"))
	ZedsCombo.Add((FName="Dr.Hans Volter", Code="Hans"))
	ZedsCombo.Add((FName="Patriarch", Code="Pat"))
	ZedsCombo.Add((FName="King Fleshpound", Code="KFP"))
	ZedsCombo.Add((FName="Abomination", Code="Abom"))
	ZedsCombo.Add((FName="Matriarch", Code="Mat"))
	ZedsCombo.Add((FName="Abomination Spawn", Code="As"))
}
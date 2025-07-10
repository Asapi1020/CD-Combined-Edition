class xUI_CycleMenu_Analyzer extends KFGUI_MultiComponent
	within xUI_CycleMenu
	DependsOn(CD_Domain);

`include(CD_Log.uci)

var KFGUI_ColumnList CategoryList;
var KFGUI_ColumnList GroupList;
var KFGUI_ColumnList TypeList;

var KFGUI_ComboBox SpawnCycleComboBox;
var KFGUI_EditBox WaveSizeFakesEditBox;
var editinline export KFGUI_TextLabel WaveSizeFakesLabel;

var KFGUI_Button AnalyzeButton;
var KFGUI_Button AllButton,
	Wave1Button, Wave2Button, Wave3Button, Wave4Button, Wave5Button,
	Wave6Button, Wave7Button, Wave8Button, Wave9Button, Wave10Button;

var transient string SpawnCycle;
var transient int WaveSizeFakes, WaveNum;

var localized string CountHeader;
var localized string AnalyzeButtonText;

function InitMenu()
{
	SpawnCycleComboBox = KFGUI_ComboBox(FindComponentID('SpawnCycleComboBox'));
	SpawnCycleComboBox.LabelString = "Spawn Cycle:";

	Super.InitMenu();

	if (SpawnCycle == "")
	{
		SpawnCycle = GetCDPC().GetCDGRI().CDInfoParams.SC;
	}

	if (WaveSizeFakes == 0)
	{
		WaveSizeFakes = int(GetCDPC().GetCDGRI().CDInfoParams.WSF);
	}

	CategoryList = KFGUI_ColumnList(FindComponentID('CategoryList'));
	CategoryList.Columns.AddItem(newFColumnItem(class'xUI_AdminMenu'.default.NameHeader, 0.4f));
	CategoryList.Columns.AddItem(newFColumnItem(CountHeader, 0.3f));
	CategoryList.Columns.AddItem(newFColumnItem("%", 0.3f));

	GroupList = KFGUI_ColumnList(FindComponentID('GroupList'));
	GroupList.Columns.AddItem(newFColumnItem(class'xUI_AdminMenu'.default.NameHeader, 0.4f));
	GroupList.Columns.AddItem(newFColumnItem(CountHeader, 0.3f));
	GroupList.Columns.AddItem(newFColumnItem("%", 0.3f));

	TypeList = KFGUI_ColumnList(FindComponentID('TypeList'));
	TypeList.Columns.AddItem(newFColumnItem(class'xUI_AdminMenu'.default.NameHeader, 0.4f));
	TypeList.Columns.AddItem(newFColumnItem(CountHeader, 0.3f));
	TypeList.Columns.AddItem(newFColumnItem("%", 0.3f));

	InitSpawnCycleComboBox();

	WaveSizeFakesEditBox = KFGUI_EditBox(FindComponentID('WaveSizeFakesEditBox'));
	WaveSizeFakesEditBox.SetText(string(WaveSizeFakes));
	WaveSizeFakesLabel.SetText("Wave Size Fakes:");
	AddComponent(WaveSizeFakesLabel);
}

protected function InitSpawnCycleComboBox()
{
	local CD_SpawnCycle_Preset SpawnCyclePreset;

	SpawnCycleComboBox.Values.length = 0;

	foreach GetCDPC().SpawnCycleCatalog.SpawnCyclePresetList(SpawnCyclePreset)
	{
		if (SpawnCyclePreset != None)
		{
			SpawnCycleComboBox.Values.AddItem(SpawnCyclePreset.GetName());
		}
	}
}

function DrawMenu()
{
	Super.DrawMenu();

	AnalyzeButton = KFGUI_Button(FindComponentID('AnalyzeButton'));
	AnalyzeButton.ButtonText = AnalyzeButtonText;

	AllButton = KFGUI_Button(FindComponentID('AllButton'));
	AllButton.ButtonText = "All";
	AllButton.bDisabled = (WaveNum == 0);

	Wave1Button = KFGUI_Button(FindComponentID('Wave1Button'));
	Wave1Button.ButtonText = "1";
	Wave1Button.bDisabled = (WaveNum == 1);

	Wave2Button = KFGUI_Button(FindComponentID('Wave2Button'));
	Wave2Button.ButtonText = "2";
	Wave2Button.bDisabled = (WaveNum == 2);

	Wave3Button = KFGUI_Button(FindComponentID('Wave3Button'));
	Wave3Button.ButtonText = "3";
	Wave3Button.bDisabled = (WaveNum == 3);

	Wave4Button = KFGUI_Button(FindComponentID('Wave4Button'));
	Wave4Button.ButtonText = "4";
	Wave4Button.bDisabled = (WaveNum == 4);

	Wave5Button = KFGUI_Button(FindComponentID('Wave5Button'));
	Wave5Button.ButtonText = "5";
	Wave5Button.bDisabled = (WaveNum == 5);

	Wave6Button = KFGUI_Button(FindComponentID('Wave6Button'));
	Wave6Button.ButtonText = "6";
	Wave6Button.bDisabled = (WaveNum == 6);

	Wave7Button = KFGUI_Button(FindComponentID('Wave7Button'));
	Wave7Button.ButtonText = "7";
	Wave7Button.bDisabled = (WaveNum == 7);

	Wave8Button = KFGUI_Button(FindComponentID('Wave8Button'));
	Wave8Button.ButtonText = "8";
	Wave8Button.bDisabled = (WaveNum == 8);

	Wave9Button = KFGUI_Button(FindComponentID('Wave9Button'));
	Wave9Button.ButtonText = "9";
	Wave9Button.bDisabled = (WaveNum == 9);

	Wave10Button = KFGUI_Button(FindComponentID('Wave10Button'));
	Wave10Button.ButtonText = "10";
	Wave10Button.bDisabled = (WaveNum == 10);
}

public function Analyze()
{
	local CD_SpawnCycleAnalyzer Analyzer;
	local SpawnCycleAnalysis Analysis;
	local string Line;

	CategoryList.EmptyList();
	GroupList.EmptyList();
	TypeList.EmptyList();

	Analyzer = new(GetCDPC()) class'CD_SpawnCycleAnalyzer';
	Analysis = Analyzer.Analyze(SpawnCycle, WaveNum, WaveSizeFakes, GetCDPC().GetCDGRI().GameLength, GetCDPC().GetCDGRI().GameDifficulty, false, true);
	
	foreach Analysis.Categories(Line)
	{
		CategoryList.AddLine(Line);
	}

	foreach Analysis.Groups(Line)
	{
		GroupList.AddLine(Line);
	}

	foreach Analysis.Types(Line)
	{
		TypeList.AddLine(Line);
	}
}

public function SetSpawnCycle(string CycleName)
{
	local int Index;

	SpawnCycle = CycleName;

	if (SpawnCycleComboBox != None)
	{
		Index = SpawnCycleComboBox.Values.Find(CycleName);
		if (Index != INDEX_NONE)
		{
			SpawnCycleComboBox.SelectedIndex = Index;
		}
		else
		{
			`cdlog("xUI_CycleMenu_Analyzer: SetSpawnCycle: Cycle not found in ComboBox: " $ CycleName);
		}
	}
	else
	{
		`cdlog("xUI_CycleMenu_Analyzer: SetSpawnCycle: SpawnCycleComboBox is None");
	}
}

public function SetWaveSizeFakes(int WSF)
{
	WaveSizeFakes = WSF;

	if (WaveSizeFakesEditBox != None)
	{
		WaveSizeFakesEditBox.SetText(string(WaveSizeFakes));
	}
	else
	{
		`cdlog("xUI_CycleMenu_Analyzer: SetWaveSizeFakes: WaveSizeFakesEditBox is None");
	}
}

protected function ComboChanged(KFGUI_ComboBox Sender)
{
	switch(Sender.ID)
	{
		case 'SpawnCycleComboBox':
			SpawnCycle = SpawnCycleComboBox.Values[Sender.SelectedIndex];
			break;
		default:
			`cdlog("xUI_CycleMenu_Analyzer: ComboChanged: Unknown ComboBox ID: " $ Sender.ID);
			return;
	}
}

protected function EditChanged(KFGUI_EditBox Sender)
{
	switch(Sender.ID)
	{
		case 'WaveSizeFakesEditBox':
			WaveSizeFakes = (Sender.GetText() != "") ? int(Sender.GetText()) : 0;
			break;
		default:
			`cdlog("xUI_CycleMenu_Analyzer: EditChanged: Unknown EditBox ID: " $ Sender.ID);
			return;
	}
}

protected function ButtonClicked(KFGUI_Button Sender)
{
	switch(Sender.ID)
	{
		case 'AnalyzeButton':
			Analyze();
			break;
		case 'AllButton':
			WaveNum = 0; // 0 means all waves
			Analyze();
			break;
		case 'Wave1Button':
			WaveNum = 1;
			Analyze();
			break;
		case 'Wave2Button':
			WaveNum = 2;
			Analyze();
			break;
		case 'Wave3Button':
			WaveNum = 3;
			Analyze();
			break;
		case 'Wave4Button':
			WaveNum = 4;
			Analyze();
			break;
		case 'Wave5Button':
			WaveNum = 5;
			Analyze();
			break;
		case 'Wave6Button':
			WaveNum = 6;
			Analyze();
			break;
		case 'Wave7Button':
			WaveNum = 7;
			Analyze();
			break;
		case 'Wave8Button':
			WaveNum = 8;
			Analyze();
			break;
		case 'Wave9Button':
			WaveNum = 9;
			Analyze();
			break;
		case 'Wave10Button':
			WaveNum = 10;
			Analyze();
			break;
		default:
			`cdlog("xUI_CycleMenu_Analyzer: ButtonClicked: Unknown button clicked: " $ Sender.ID);
			return;
	}
}

defaultproperties
{
	ID="CycleMenu_Analyzer"

	Begin Object Class=KFGUI_ComboBox Name=SpawnCycleComboBox
		XPosition=0.05
		YPosition=0.05
		XSize=0.300
		YSize=0.073
		LabelWidth=0.4
		OnComboChanged=ComboChanged
		ID="SpawnCycleComboBox"
	End Object
	Components.Add(SpawnCycleComboBox)

	Begin Object Class=KFGUI_TextLabel Name=WaveSizeFakesLabel
		AlignX=0
		AlignY=1
		TextFontInfo=(bClipText=true, bEnableShadow=true)
		XPosition=0.40
		YPosition=0.05
		XSize=0.125
		YSize=0.05
	End Object
	WaveSizeFakesLabel=WaveSizeFakesLabel

	Begin Object Class=KFGUI_EditBox Name=WaveSizeFakesEditBox
    	ID="WaveSizeFakesEditBox"
        bDrawBackground=true
		bFloatOnly=true
		bNoClearOnEnter=true
        FontColor=(R=195,G=195,B=195,A=255)
        BackgroundColor=(R=0, G=0, B=0, A=200)
        CursorColor=(R=195,G=195,B=195,A=255)
        MaxWidth=2048
        XPosition=0.55
        YPosition=0.05
        XSize=0.10
        YSize=0.05
        OnChange=EditChanged
    End Object
    Components.Add(WaveSizeFakesEditBox)

	Begin Object Class=KFGUI_Button Name=AnalyzeButton
		XPosition=0.70
		YPosition=0.05
		XSize=0.14
		YSize=0.05
		ID="AnalyzeButton"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(AnalyzeButton)

	Begin Object Class=KFGUI_Button Name=AllButton
		XPosition=0.05
		YPosition=0.125
		XSize=0.08
		YSize=0.05
		ID="AllButton"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(AllButton)

	Begin Object Class=KFGUI_Button Name=Wave1Button
		XPosition=0.1315
		YPosition=0.125
		XSize=0.08
		YSize=0.05
		ID="Wave1Button"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(Wave1Button)

	Begin Object Class=KFGUI_Button Name=Wave2Button
		XPosition=0.213
		YPosition=0.125
		XSize=0.08
		YSize=0.05
		ID="Wave2Button"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(Wave2Button)

	Begin Object Class=KFGUI_Button Name=Wave3Button
		XPosition=0.2945
		YPosition=0.125
		XSize=0.08
		YSize=0.05
		ID="Wave3Button"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(Wave3Button)

	Begin Object Class=KFGUI_Button Name=Wave4Button
		XPosition=0.376
		YPosition=0.125
		XSize=0.08
		YSize=0.05
		ID="Wave4Button"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(Wave4Button)

	Begin Object Class=KFGUI_Button Name=Wave5Button
		XPosition=0.4575
		YPosition=0.125
		XSize=0.08
		YSize=0.05
		ID="Wave5Button"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(Wave5Button)

	Begin Object Class=KFGUI_Button Name=Wave6Button
		XPosition=0.539
		YPosition=0.125
		XSize=0.08
		YSize=0.05
		ID="Wave6Button"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(Wave6Button)

	Begin Object Class=KFGUI_Button Name=Wave7Button
		XPosition=0.6205
		YPosition=0.125
		XSize=0.08
		YSize=0.05
		ID="Wave7Button"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(Wave7Button)

	Begin Object Class=KFGUI_Button Name=Wave8Button
		XPosition=0.702
		YPosition=0.125
		XSize=0.08
		YSize=0.05
		ID="Wave8Button"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(Wave8Button)

	Begin Object Class=KFGUI_Button Name=Wave9Button
		XPosition=0.7835
		YPosition=0.125
		XSize=0.08
		YSize=0.05
		ID="Wave9Button"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(Wave9Button)

	Begin Object Class=KFGUI_Button Name=Wave10Button
		XPosition=0.865
		YPosition=0.125
		XSize=0.08
		YSize=0.05
		ID="Wave10Button"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(Wave10Button)

	Begin Object Class=KFGUI_ColumnList Name=CategoryList
		XPosition=0.05
		YPosition=0.20
		XSize=0.425
		YSize=0.25
		ID="CategoryList"
		bCanSortColumn=true
		bOpaque=true
	End Object
	Components.Add(CategoryList)

	Begin Object Class=KFGUI_ColumnList Name=GroupList
		XPosition=0.05
		YPosition=0.475
		XSize=0.425
		YSize=0.425
		ID="GroupList"
		bCanSortColumn=true
		bOpaque=true
	End Object
	Components.Add(GroupList)

	Begin Object Class=KFGUI_ColumnList Name=TypeList
		XPosition=0.525
		YPosition=0.20
		XSize=0.425
		YSize=0.70
		ID="TypeList"
		bCanSortColumn=true
		bOpaque=true
	End Object
	Components.Add(TypeList)
}

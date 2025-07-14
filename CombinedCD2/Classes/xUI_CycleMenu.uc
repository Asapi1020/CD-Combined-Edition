class xUI_CycleMenu extends xUI_MenuBase
	config(CombinedCD_LocalData);

`include(CD_Log.uci)

enum CycleMenuState
{
	CMS_Preset,
	CMS_Analyzer
};

var CycleMenuState CurState;

var protected xUI_CycleMenu_Preset PresetPage;
var protected xUI_CycleMenu_Analyzer AnalyzerPage;

var KFGUI_Button PresetButton;
var KFGUI_Button AnalyzerButton;

var config array<string> FavoriteCycles;
var config bool bFiltered;

var localized string FavoriteFilterString;
var localized string FavoriteFilterToolTip;
var localized string AddToFavorites, RemoveFromFavorites;
var localized string AnalyzeWaveString, AnalyzeMatchString;
var localized string AuthorHeader, DateHeader;

var localized string PresetButtonText, AnalyzerButtonText;

function SetWindowDrag(bool bDrag)
{
	bDragWindow = false;
}

function InitMenu()
{
	super.InitMenu();

	PresetPage = new(self) class'xUI_CycleMenu_Preset';
	AddComponent(PresetPage);

	AnalyzerPage = new(self) class'xUI_CycleMenu_Analyzer';
	AddComponent(AnalyzerPage);
}

function DrawMenu()
{
	super.DrawMenu();

	PresetButton = KFGUI_Button(FindComponentID('CyclePreset'));
	PresetButton.ButtonText = PresetButtonText;
	PresetButton.bDisabled = CurState == CMS_Preset;

	AnalyzerButton = KFGUI_Button(FindComponentID('CycleAnalyzer'));
	AnalyzerButton.ButtonText = AnalyzerButtonText;
	AnalyzerButton.bDisabled = CurState == CMS_Analyzer;

	PresetPage.bVisible = CurState == CMS_Preset;
	AnalyzerPage.bVisible = CurState == CMS_Analyzer;
}

protected function ButtonClicked(KFGUI_Button Sender)
{
	switch(Sender.ID)
	{
		case 'CyclePreset':
			CurState = CMS_Preset;
			break;
		case 'CycleAnalyzer':
			CurState = CMS_Analyzer;
			break;
		default:
			`cdlog("xUI_CycleMenu: ButtonClicked: Unknown button clicked: " $ Sender.ID);
			return;
	}
}

public function SetAnalyzeOptions(string SpawnCycleName, int WaveNumInt, int WaveSizeFakesInt)
{
	AnalyzerPage.SetSpawnCycle(SpawnCycleName);
	AnalyzerPage.WaveNum = WaveNumInt;
	AnalyzerPage.SetWaveSizeFakes(WaveSizeFakesInt);
}

public function RunAnalyze()
{
	CurState = CMS_Analyzer;
	AnalyzerPage.Analyze();
}

defaultproperties
{
	ID="CycleMenu"
	Version="3.0.0"

	CurState=CMS_Preset;

	Begin Object Class=KFGUI_Button Name=CyclePreset
		XPosition=0.025
		YPosition=0.925
		XSize=0.14
		YSize=0.05
		ID="CyclePreset"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(CyclePreset)

	Begin Object Class=KFGUI_Button Name=CycleAnalyzer
		XPosition=0.190
		YPosition=0.925
		XSize=0.14
		YSize=0.05
		ID="CycleAnalyzer"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(CycleAnalyzer)
}

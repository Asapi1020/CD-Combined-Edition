class xUI_CycleMenu extends xUI_MenuBase
	config(CombinedCD_LocalData);

`include(CD_UTF16LE.uci)

var KFGUI_CheckBox FavoriteFilter;
var KFGUI_ColumnList CycleList;
var KFGUI_RightClickMenu CycleRClicker;
var editinline export KFGUI_RightClickMenu CycleRightClick;

var config array<string> FavoriteCycles;
var config bool bFiltered;

var int SelectedCycleIndex;

var localized string FavoriteFilterString;
var localized string FavoriteFilterToolTip;
var localized string AddToFavorites, RemoveFromFavorites;
var localized string AnalyzeWaveString, AnalyzeMatchString;
var localized string AuthorHeader, DateHeader;

function SetWindowDrag(bool bDrag)
{
	bDragWindow = false;
}

function InitMenu()
{
	local int i;

	super.InitMenu();

	CycleList = KFGUI_ColumnList(FindComponentID('Cycle'));
	CycleList.Columns.AddItem(newFColumnItem("", 0.025f));
	CycleList.Columns.AddItem(newFColumnItem(class'xUI_AdminMenu'.default.NameHeader, 0.475f));
	CycleList.Columns.AddItem(newFColumnItem(AuthorHeader, 0.30f));
	CycleList.Columns.AddItem(newFColumnItem(DateHeader, 0.20f));
	CycleRClicker = KFGUI_RightClickMenu(FindComponentID('CycleRClicker'));

	CycleRightClick.ItemRows.Add(12);
	CycleRightClick.ItemRows[0].Text = AddToFavorites;
	for(i=1; i<11; i++)
	{
		CycleRightClick.ItemRows[i].Text = Repl(AnalyzeWaveString, "%s", string(i));
	}
	CycleRightClick.ItemRows[11].Text = AnalyzeMatchString;
}

function DrawMenu()
{
	local int i, skipped;
	local string S;
	local bool bFavorite;
	local CD_SpawnCycle_Preset SpawnCyclePreset;

	super.DrawMenu();

	FavoriteFilter = KFGUI_CheckBox(FindComponentID('FavoriteFilter'));
	FavoriteFilter.ToolTip=FavoriteFilterToolTip;
	FavoriteFilter.bChecked = bFiltered;
	DrawBoxDescription(FavoriteFilterString, FavoriteFilter, 0.4);

	if(CycleList.ListCount != GetCDPC().SpawnCycleCatalog.SpawnCyclePresetList.length)
	{
		CycleList.EmptyList();
		for(i=0; i<GetCDPC().SpawnCycleCatalog.SpawnCyclePresetList.length; i++)
		{
			SpawnCyclePreset = GetCDPC().SpawnCycleCatalog.SpawnCyclePresetList[i];
			S = SpawnCyclePreset.GetName();
			bFavorite = (FavoriteCycles.Find(S) != INDEX_NONE);
			if(FavoriteFilter.bChecked && !bFavorite)
			{
				++skipped;
				continue;
			}
			S = (bFavorite ? `HEART_EMOJI : "") $ "\n" $ S;
			S $= "\n" $ SpawnCyclePreset.GetAuthor();
			S $= "\n" $ SpawnCyclePreset.GetDate();
			CycleList.AddLine(S);
		}
	}
	//CycleList.SelectedRowIndex = SelectedCycleIndex;
}

function SelectedCycleRow(KFGUI_ListItem Item, int Row, bool bRight, bool bDblClick)
{
	local string CycleName;

	if(Row < 0) return;

	SelectedCycleIndex = Row;
	CycleName = CycleList.GetFromIndex(Row).GetDisplayStr(1);

	if(bDblClick)
	{
		GetCDPC().SetSpawnCycle(CycleName);
	}
	else if(bRight)
	{
		CycleRightClick.ItemRows[0].Text = (FavoriteCycles.Find(CycleName) == INDEX_NONE) ? AddToFavorites : RemoveFromFavorites;
		CycleRightClick.OpenMenu(Self);
	}
}

function ClickedRow(int Row)
{
	local string CycleName;
	CycleName = CycleList.GetFromIndex(SelectedCycleIndex).GetDisplayStr(1);

	if(Row == 0)
	{
		ToggleFavorite(CycleName);
	}
	else if(Row < 11)
	{
		GetCDPC().RunCDChatCommand("!cdsca" @ CycleName @ "wave" $ string(Row) @ "wsf12");
	}
	else if(Row == 11)
	{
		GetCDPC().RunCDChatCommand("!cdsca" @ CycleName @ "wsf12");
	}
}

function ToggleFavorite(string CycleName)
{
	if(FavoriteCycles.Find(CycleName) != INDEX_NONE)
	{
		FavoriteCycles.RemoveItem(CycleName);
	}
	else if(CycleName != "")
	{
		FavoriteCycles.AddItem(CycleName);
	}
	SaveConfig();
	CycleList.EmptyList();
}

function ToggleCheckBox(KFGUI_CheckBox Sender)
{
	switch (Sender.ID)
	{
		case 'FavoriteFilter':
			CycleList.EmptyList();
			bFiltered = Sender.bChecked;
			SaveConfig();
			break;
	}
}

defaultproperties
{
	ID="CycleMenu"
	Version="2.0.1"

	Begin Object Class=KFGUI_CheckBox Name=FavoriteFilter
		XPosition=0.05
		YPosition=0.10
		ID="FavoriteFilter"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_ColumnList Name=Cycle
		XPosition=0.05
		YPosition=0.15
		XSize=0.90
		YSize=0.80
		ID="Cycle"
		OnSelectedRow=SelectedCycleRow
		bCanSortColumn=true
		bOpaque=true
	End Object

	Components.Add(Cycle)
	Components.Add(FavoriteFilter)

	Begin Object Class=KFGUI_RightClickMenu Name=CycleRClicker
		ID="RClick"
		OnSelectedItem=ClickedRow
	End Object
	CycleRightClick=CycleRClicker
}

Class xUI_MapVote extends xUI_MenuBase;

var xVotingReplication RepInfo;
var KFGUI_ColumnList CurrentVotes,MapList,GameModeList;
var KFGUI_RightClickMenu MapRClicker;
var KFGUI_Button CloseButton;
var KFGUI_Button ResultButton;
var int SelectedMapIndex, SelectedModeIndex;
var editinline export KFGUI_RightClickMenu MapRightClick;
var bool bFirstTime;

//var localized string Title;
var localized string CloseButtonToolTip;
var localized string ColumnMapName;
//var localized string ColumnSequence;
//var localized string ColumnPlayCount;
//var localized string ColumnRating;
var localized string ColumnGame;
var localized string ColumnNumVotes;
var localized string ColumnGameMode;
var localized string MatchResultButtonText;
var localized string ResultButtonToolTip;
var localized string VoteMapString;
var localized string AdminForceString;

function FRowItem newFRowItem(string Text, bool isDisabled)
{
	local FRowItem newItem;
	newItem.Text=Text;
	newItem.bDisabled=isDisabled;
	return newItem;
}

function InitMenu()
{
	Super.InitMenu();
	CurrentVotes = KFGUI_ColumnList(FindComponentID('Votes'));
	MapList = KFGUI_ColumnList(FindComponentID('Maps'));
	GameModeList = KFGUI_ColumnList(FindComponentID('Modes'));
	//	GameModeCombo = KFGUI_ComboBox(FindComponentID('Filter'));
	MapRClicker = KFGUI_RightClickMenu(FindComponentID('RClick'));
	CloseButton = KFGUI_Button(FindComponentID('Close'));
	
	// TODO: i18n this
	// I don't know why it's not working
	// MapRClicker.ItemRows.AddItem(newFRowItem("Vote this map", false));
	// MapRClicker.ItemRows.AddItem(newFRowItem("Admin force this map", true));
	
	// And this too:
	// GameModeCombo.LableString="Game mode:";
	// GameModeCombo.ToolTip="Select game mode to vote for.";
	
	CloseButton.ButtonText=CloseButtonText;
	CloseButton.ToolTip=CloseButtonToolTip;
	
	MapList.Columns.AddItem(newFColumnItem(ColumnMapName,1.f));

	GameModeList.Columns.AddItem(newFColumnItem(ColumnGameMode,1.f));
	
	CurrentVotes.Columns.AddItem(newFColumnItem(ColumnGame,0.2));
	CurrentVotes.Columns.AddItem(newFColumnItem(ColumnMapName,0.5));
	CurrentVotes.Columns.AddItem(newFColumnItem(ColumnNumVotes,0.3));

	ResultButton = KFGUI_Button(FindComponentID('Result'));
	ResultButton.ButtonText = MatchResultButtonText;
	ResultButton.ToolTip = ResultButtonToolTip;

	MapRightClick.ItemRows.Add(2);
	MapRightClick.ItemRows[0].Text=VoteMapString;
	MapRightClick.ItemRows[1].Text=AdminForceString;
	MapRightClick.ItemRows[1].bDisabled = true;
	
	WindowTitle = Title @ "v2.1";
}

function CloseMenu()
{
	Super.CloseMenu();
	RepInfo = None;
}

function InitMapvote(xVotingReplication R)
{
	RepInfo = R;
}

function DrawMenu()
{
	local float X, Y , XL, YL, FontScalar;

	Super.DrawMenu();
	
	if (RepInfo!=None && RepInfo.bListDirty)
	{
		RepInfo.bListDirty = false;
		UpdateList();
	}

	ResultButton.bDisabled = (KFGameReplicationInfo(KFPlayerController(GetPlayer()).WorldInfo.GRI).bMatchIsOver) ? false : true;

	Canvas.Font = Owner.CurrentStyle.PickFont(FontScalar);
	Canvas.TextSize("ABC", XL, YL, FontScalar, FontScalar);
	X = GameModeList.CompPos[0] - CompPos[0] + YL*1.5;
	Y = GameModeList.CompPos[1] - CompPos[1] + GameModeList.CompPos[3] + YL;

	Canvas.SetDrawColor(75, 0, 0, 250);
	Owner.CurrentStyle.DrawRectBox(X-XL/3,  Y,      XL/3, 3*YL, 8.f, 132);
	Owner.CurrentStyle.DrawRectBox(X-XL/3,  Y+3*YL, XL/3, 4*YL, 8.f, 133);
	Owner.CurrentStyle.DrawRectBox(X+YL*14, Y,      XL/3, 3*YL, 8.f, 131);
	Owner.CurrentStyle.DrawRectBox(X+YL*14, Y+3*YL, XL/3, 4*YL, 8.f, 130);

	Canvas.SetDrawColor(250, 250, 250, 255);
	if(MapList.SelectedRowIndex != INDEX_NONE)
		DrawMapPreview(GetMapPreviewPath(RepInfo.Maps[MapList.SelectedRowIndex].MapTitle), X, Y, YL);

	else
		DrawMapPreview("UI_MapPreview_TEX.UI_MapPreview_Placeholder", X, Y, YL);
}

final function DrawMapPreview(string IconPath, float X, float Y, float YL)
{
	Canvas.SetPos(X, Y);
	Canvas.DrawTile(Texture(class'CD_Object'.static.SafeLoadObject(IconPath, class'Texture')), 14*YL, 7*YL, 0, 0, 512, 256);
}

static function string GetMapPreviewPath(string MapName)
{
	local KFMapSummary MapData;

	MapData = class'KFUIDataStore_GameResource'.static.GetMapSummaryFromMapName(MapName);

	if ( MapData != none && MapData.ScreenshotPathName != "")
	{
		return MapData.ScreenshotPathName;
	}
	else
	{
     	return "UI_MapPreview_TEX.UI_MapPreview_Placeholder";
	}
}

final function UpdateList()
{
	local int i,g,m,Sel;
	local float V;
	local KFGUI_ListItem Item,SItem;

	if (GameModeList.Columns.Length!=RepInfo.GameModes.Length)
	{
		GameModeList.Columns.Length = RepInfo.GameModes.Length;
		for (i=0; i<GameModeList.Columns.Length; ++i)
		{
			GameModeList.AddLine(RepInfo.GameModes[i].GameName);
		}
		if (!bFirstTime)
		{
			bFirstTime = true;
			SelectedModeIndex = RepInfo.ClientCurrentGame;
		}
		ChangeToMaplist(SelectedModeIndex);
	}
	GameModeList.SelectedRowIndex = SelectedModeIndex;
	Item = CurrentVotes.GetFromIndex(CurrentVotes.SelectedRowIndex);
	Sel = (Item!=None ? Item.Value : -1);
	CurrentVotes.EmptyList();
	for (i=0; i<RepInfo.ActiveVotes.Length; ++i)
	{
		g = RepInfo.ActiveVotes[i].GameIndex;
		m = RepInfo.ActiveVotes[i].MapIndex;
		if (RepInfo.Maps[m].NumPlays==0)
			Item = CurrentVotes.AddLine(RepInfo.GameModes[g].GameName$"\n"$RepInfo.Maps[m].MapTitle$"\n"$RepInfo.ActiveVotes[i].NumVotes$"\n** NEW **",m,
										RepInfo.GameModes[g].GameName$"\n"$RepInfo.Maps[m].MapTitle$"\n"$MakeSortStr(RepInfo.ActiveVotes[i].NumVotes)$"\n"$MakeSortStr(0));
		else
		{
			V = (float(RepInfo.Maps[m].UpVotes) / float(RepInfo.Maps[m].UpVotes+RepInfo.Maps[m].DownVotes)) * 100.f;
			Item = CurrentVotes.AddLine(RepInfo.GameModes[g].GameName$"\n"$RepInfo.Maps[m].MapTitle$"\n"$RepInfo.ActiveVotes[i].NumVotes$"\n"$int(V)$"% ("$RepInfo.Maps[m].UpVotes$"/"$(RepInfo.Maps[m].UpVotes+RepInfo.Maps[m].DownVotes)$")",m,
										RepInfo.GameModes[g].GameName$"\n"$RepInfo.Maps[m].MapTitle$"\n"$MakeSortStr(RepInfo.ActiveVotes[i].NumVotes)$"\n"$MakeSortStr(int(V*100.f)));
		}
		if (Sel>=0 && Sel==m)
			SItem = Item;
	}

	// Keep same row selected if possible.
	CurrentVotes.SelectedRowIndex = (SItem!=None ? SItem.Index : -1);
}

function ChangeToMaplist(int Index)
{
	local int i,g;
	local float V;

	if (RepInfo!=None)
	{
		MapList.EmptyList();
		g = Index;
		for (i=0; i<RepInfo.Maps.Length; ++i)
		{
			if (!BelongsToPrefix(RepInfo.Maps[i].MapName,RepInfo.GameModes[g].Prefix))
				continue;
			if (RepInfo.Maps[i].NumPlays==0)
				MapList.AddLine(RepInfo.Maps[i].MapTitle$"\n"$RepInfo.Maps[i].Sequence$"\n"$RepInfo.Maps[i].NumPlays$"\n** NEW **",i,
								RepInfo.Maps[i].MapTitle$"\n"$MakeSortStr(RepInfo.Maps[i].Sequence)$"\n"$MakeSortStr(RepInfo.Maps[i].NumPlays)$"\n"$MakeSortStr(0));
			else
			{
				V = RepInfo.Maps[i].UpVotes+RepInfo.Maps[i].DownVotes;
				if (V==0)
					V = 100.f;
				else V = (float(RepInfo.Maps[i].UpVotes) / V) * 100.f;
				MapList.AddLine(RepInfo.Maps[i].MapTitle$"\n"$RepInfo.Maps[i].Sequence$"\n"$RepInfo.Maps[i].NumPlays$"\n"$int(V)$"% ("$RepInfo.Maps[i].UpVotes$"/"$(RepInfo.Maps[i].UpVotes+RepInfo.Maps[i].DownVotes)$")",i,
								RepInfo.Maps[i].MapTitle$"\n"$MakeSortStr(RepInfo.Maps[i].Sequence)$"\n"$MakeSortStr(RepInfo.Maps[i].NumPlays)$"\n"$MakeSortStr(int(V*100.f)));
			}
		}
	}
}

static final function bool BelongsToPrefix(string MN, string Prefix)
{
	return (Prefix=="" || Left(MN,Len(Prefix))~=Prefix);
}

function ButtonClicked(KFGUI_Button Sender)
{
	local xUI_ResultMenu Menu;

	switch (Sender.ID)
	{
		case 'Close':
			DoClose();
			break;
		case 'Result':
			Menu = xUI_ResultMenu(Class'KF2GUIController'.Static.GetGUIController(GetPlayer()).OpenMenu(class'xUI_ResultMenu'));
			Menu.CurState = 'TeamAward';
			DoClose();
			break;
	}
}

function ClickedRow(int RowNum)
{
	if (RowNum==0) // Vote this map.
	{
		RepInfo.ServerCastVote(SelectedModeIndex,SelectedMapIndex,false);
	}
	else // Admin force this map.
	{
		RepInfo.ServerCastVote(SelectedModeIndex,SelectedMapIndex,true);
	}
}

function SelectedVoteRow(KFGUI_ListItem Item, int Row, bool bRight, bool bDblClick)
{
	if (bRight)
	{
		SelectedMapIndex = Item.Value;
		MapRightClick.ItemRows[1].bDisabled = (!GetPlayer().PlayerReplicationInfo.bAdmin);
		MapRightClick.OpenMenu(Self);
	}
	else if (bDblClick)
		RepInfo.ServerCastVote(SelectedModeIndex,Item.Value,false);
}

function SelectedModeRow(KFGUI_ListItem Item, int Row, bool bRight, bool bDblClick)
{
	if(Row>=0)
	{
		SelectedModeIndex = Row;
		ChangeToMaplist(SelectedModeIndex);
	}
	GameModeList.SelectedRowIndex = SelectedModeIndex;
}

function SetWindowDrag(bool bDrag)
{
	bDragWindow = false;
}


defaultproperties
{
	XPosition=0.2
	YPosition=0.1
	XSize=0.6
	YSize=0.8
	
	Begin Object Class=KFGUI_ColumnList Name=CurrentVotesList
		XPosition=0.015
		YPosition=0.075
		XSize=0.98
		YSize=0.25
		ID="Votes"
		OnSelectedRow=SelectedVoteRow
		bShouldSortList=true
		bLastSortedReverse=true
		LastSortedColumn=2
	End Object
	Begin Object Class=KFGUI_ColumnList Name=MapList
		XPosition=0.015
		YPosition=0.375
		XSize=0.58
		YSize=0.56
		ID="Maps"
		OnSelectedRow=SelectedVoteRow
		bCanSortColumn=false
	End Object
	Begin Object Class=KFGUI_ColumnList Name=GameModeList
		XPosition=0.6
		YPosition=0.375
		XSize=0.39
		YSize=0.28 //0.56
		ID="Modes"
		OnSelectedRow=SelectedModeRow
		bCanSortColumn=false
	End Object
/*	Begin Object Class=KFGUI_ComboBox Name=GameModeFilter
		XPosition=0.1
		YPosition=0.325
		XSize=0.6
		YSize=0.05
		OnComboChanged=ChangeToMaplist
		ID="Filter"
		LableString="Game mode:"
		ToolTip="Select game mode to vote for."
	End Object
*/	Begin Object Class=KFGUI_Button Name=CloseButton
		XPosition=0.85
		YPosition=0.94
		XSize=0.1
		YSize=0.05
		ID="Close"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=ResultButton
		XPosition=0.05
		YPosition=0.94
		XSize=0.15
		YSize=0.05
		ID="Result"
		OnClickLeft=ButtonClicked
		OnClickRight=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	
	Components.Add(CurrentVotesList)
	Components.Add(MapList)
	Components.Add(GameModeList)
	Components.Add(CloseButton)
	Components.Add(ResultButton)
	
	Begin Object Class=KFGUI_RightClickMenu Name=MapRClicker
		ID="RClick"
		OnSelectedItem=ClickedRow
	End Object
	MapRightClick=MapRClicker
}
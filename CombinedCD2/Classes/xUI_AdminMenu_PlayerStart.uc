class xUI_AdminMenu_PlayerStart extends KFGUI_MultiComponent
	within xUI_AdminMenu;

`include(CD_Log.uci)

var KFGUI_Button TogglePathNodesIndexButton;
var KFGUI_Button ClearCustomPlayerStartsButton;

var KFGUI_ColumnList PlayerStartList;
var KFGUI_RightClickMenu PlayerStartRClicker;
var editinline export KFGUI_RightClickMenu PlayerStartRightClick;

var KFGUI_EditBox AddCustomStartEditBox;
var editinline export KFGUI_TextLabel AddCustomStartTextLabel;

var KFGUI_CheckBox DisableCustomStartsCheckBox;

var private int SelectedPathNodeIndex;

var public bool bServerDisableCustomStarts;

var localized string TogglePathNodesIndexButtonText;
var localized string ClearCustomPlayerStartsButtonText;
var localized string ClearCustomPlayerStartsToolTip;
var localized string PlayerStartListTitle;
var localized string RemovePlayerStartString;
var localized string GoToPlayerStartString;
var localized string EveryoneGoToPlayerStartString;
var localized string AddCustomStartString;
var localized string DisableCustomStartsString;

public function InitMenu()
{
	Super.InitMenu();

	InitPlayerStartList();

	AddCustomStartEditBox = KFGUI_EditBox(FindComponentID('AddCustomStartEditBox'));
	AddCustomStartTextLabel.SetText(AddCustomStartString);
	AddComponent(AddCustomStartTextLabel);

	GetCDPC().GetDisableCustomStarts();
}

public function DrawMenu()
{
	local float RightEnd;

	Super.DrawMenu();

	TogglePathNodesIndexButton = KFGUI_Button(FindComponentID('TogglePathNodesIndex'));
	TogglePathNodesIndexButton.ButtonText = TogglePathNodesIndexButtonText;

	ClearCustomPlayerStartsButton = KFGUI_Button(FindComponentID('ClearCustomPlayerStarts'));
	ClearCustomPlayerStartsButton.ButtonText = ClearCustomPlayerStartsButtonText;
	ClearCustomPlayerStartsButton.ToolTip = ClearCustomPlayerStartsToolTip;

	DisableCustomStartsCheckBox = KFGUI_CheckBox(FindComponentID('DisableCustomStarts'));
	DisableCustomStartsCheckBox.bChecked = bServerDisableCustomStarts;

	RightEnd = PlayerStartList.XPosition + PlayerStartList.XSize - ClearCustomPlayerStartsButton.XPosition;
	DrawBoxDescription(DisableCustomStartsString, DisableCustomStartsCheckBox, RightEnd, bVisible);
}

public simulated function OnUpdatePlayerStartList()
{
	PlayerStartList.EmptyList();
	GetCDPC().CheckPlayerStartForCurMap();
}

public final function UpdatePlayerStartList(array<string> PathNodesIndexString)
{
	local string IndexString, PathNodeName;

	foreach PathNodesIndexString(IndexString)
	{
		if(IndexString == "")
		{
			continue;
		}

		PathNodeName = "KFPathnode_" $ IndexString;
		PlayerStartList.AddLine(PathNodeName);
	}
}

private function InitPlayerStartList()
{
	PlayerStartList = KFGUI_ColumnList(FindComponentID('PlayerStartList'));
	PlayerStartList.Columns.AddItem(newFColumnItem(PlayerStartListTitle, 1.f));

	PlayerStartRClicker = KFGUI_RightClickMenu(FindComponentID('PlayerStartRClicker'));
	
	PlayerStartRightClick.ItemRows.Add(3);
	PlayerStartRightClick.ItemRows[0].Text = RemovePlayerStartString;
	PlayerStartRightClick.ItemRows[1].Text = GoToPlayerStartString;
	PlayerStartRightClick.ItemRows[2].Text = EveryoneGoToPlayerStartString;
}

private function ButtonClicked(KFGUI_Button Sender)
{
	switch(Sender.ID)
	{
		case 'TogglePathNodesIndex':
			GetCDPC().ShowPathNodesNum();
			break;
		case 'ClearCustomPlayerStarts':
			GetCDPC().ClearCustomStart();
			DelayedReload();
		default:
			`cdlog("xUI_AdminMenu_PlayerStart: ButtonClicked: Unknown button clicked: " $ Sender.ID);
			break;
	}
}

private function SelectedListRow(KFGUI_ListItem Item, int Row, bool bRight, bool bDblClick)
{
	local string SelectedPathNodeName, indexString;
	local string Lowercase;
	local int index;
	
	if(Row < 0)
		return;

	SelectedPathNodeName = Item.GetSortStr(0);
	Lowercase = Locs(SelectedPathNodeName);
	indexString = Repl(Lowercase, "kfpathnode_", "");
	index = int(indexString);

	if(index < 0)
	{
		`cdlog("xUI_AdminMenu_PlayerStart: SelectedListRow: Invalid index: " $ indexString);
	}
	SelectedPathNodeIndex = index;

	PlayerStartRightClick.OpenMenu(self);
}

private function PlayerStartClickedRow(int RowNum)
{
	switch(RowNum)
	{
		case 0:
			GetCDPC().RemoveCustomStart(SelectedPathNodeIndex);
			DelayedReload();
			break;
		case 1:
			GetCDPC().GotoPathNode(SelectedPathNodeIndex);
			break;
		case 2:
			GetCDPC().RequestEveryoneGotoPathNode(SelectedPathNodeIndex);
			break;
		default:
			`cdlog("xUI_AdminMenu_PlayerStart: PlayerStartClickedRow: Unknown row clicked: " $ RowNum);
			return;
	}
}

private function PlayerHitEnter(KFGUI_EditBox Sender, string inputString)
{
	switch(Sender.ID)
	{
		case 'AddCustomStartEditBox':
			AddCustomStart(inputString);
			DelayedReload();
			break;
		default:
			`cdlog("xUI_AdminMenu_PlayerStart: PlayerHitEnter: Unknown sender ID: " $ Sender.ID);
			return;
	}
}

private function AddCustomStart(string indexString)
{
	local int index;

	index = int(indexString);

	if(index < 0)
	{
		`cdlog("xUI_AdminMenu_PlayerStart: AddCustomStart: Invalid index: " $ indexString);
		return;
	}

	GetCDPC().AddCustomStart(index);
}

function ToggleCheckBox(KFGUI_CheckBox Sender)
{
	switch(Sender.ID)
	{
		case 'DisableCustomStarts':
			GetCDPC().SetDisableCustomStarts(Sender.bChecked);
			bServerDisableCustomStarts = Sender.bChecked;
			break;
		default:
			`cdlog("xUI_AdminMenu_PlayerStart: ToggleCheckBox: Unknown checkbox clicked: " $ Sender.ID);
			return;
	}
}

private function DelayedReload()
{
	SetTimer(0.5, false, 'OnUpdatePlayerStartList');
}

defaultproperties
{
	ID="AdminMenu_PlayerStart"

	Begin Object Class=KFGUI_Button Name=TogglePathNodesIndex
		XPosition=0.0550
		YPosition=0.05
		XSize=0.12
		YSize=0.05
		ID="TogglePathNodesIndex"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(TogglePathNodesIndex)

	Begin Object Class=KFGUI_ColumnList Name=PlayerStartList
		XPosition=0.05
		YPosition=0.15
		XSize=0.52
		YSize=0.55
		ID="PlayerStartList"
		OnSelectedRow=SelectedListRow
		bCanSortColumn=false
	End Object
	Components.Add(PlayerStartList)

	Begin Object Class=KFGUI_RightClickMenu Name=PlayerStartRClicker
		ID="PlayerStartRClick"
		OnSelectedItem=PlayerStartClickedRow
	End Object
	PlayerStartRightClick=PlayerStartRClicker

	Begin Object Class=KFGUI_EditBox Name=AddCustomStartEditBox
    	ID="AddCustomStartEditBox"
        bDrawBackground=true
		bIntOnly=true
        FontColor=(R=195,G=195,B=195,A=255)
        BackgroundColor=(R=0, G=0, B=0, A=200)
        CursorColor=(R=195,G=195,B=195,A=255)
        MaxWidth=2048
        XPosition=0.22
        YPosition=0.75
        XSize=0.15
        YSize=0.05
        OnTextFinished=PlayerHitEnter
    End Object

    Components.Add(AddCustomStartEditBox)

	Begin Object Class=KFGUI_TextLabel Name=AddCustomStartLabel
		AlignX=0
		AlignY=1
		TextFontInfo=(bClipText=true, bEnableShadow=true)
		XPosition=0.05
		YPosition=0.75
		XSize=0.15
		YSize=0.05
	End Object
	AddCustomStartTextLabel=AddCustomStartLabel

	Begin Object Class=KFGUI_Button Name=ClearCustomPlayerStartsButton
		XPosition=0.0550
		YPosition=0.85
		XSize=0.12
		YSize=0.05
		ID="ClearCustomPlayerStarts"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(ClearCustomPlayerStartsButton)

	Begin Object Class=KFGUI_CheckBox Name=DisableCustomStartsCheckBox
		XPosition=0.20
		YPosition=0.86
		ID="DisableCustomStarts"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(DisableCustomStartsCheckBox)
}

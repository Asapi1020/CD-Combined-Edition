class xUI_PlayersMenu extends xUI_MenuBase;

var KFGUI_Button RefreshB;
var KFGUI_ColumnList PlayersList;
var KFGUI_ColumnList SpectatorsList;
var KFGUI_RightClickMenu PlayersRClicker;
var editinline export KFGUI_RightClickMenu PlayersRightClick;

var array<KFPlayerReplicationInfo> PlayersInfo, SpectatorsInfo;
var KFPlayerReplicationInfo SelectedUser;
var bool bListUpdate;

//var localized string Title;
var localized string RefreshButtonText;
var localized string PlayersHeader;
var localized string SpectatorsHeader;
var localized string MutingPrefix;
var localized string ViewProfileString;
var localized string ChatMuteString;

function SetWindowDrag(bool bDrag)
{
	bDragWindow = false;
}

function DrawMenu()
{
	super.DrawMenu();

	if(!bListUpdate)
	{
		UpdateList();
	}

	RefreshB = KFGUI_Button(FindComponentID('Refresh'));
	RefreshB.ButtonText = RefreshButtonText;
}

function InitMenu()
{
	super.InitMenu();

	PlayersList = KFGUI_ColumnList(FindComponentID('Players'));
	PlayersList.Columns.AddItem(newFColumnItem(PlayersHeader, 1.f));

	SpectatorsList = KFGUI_ColumnList(FindComponentID('Spectators'));
	SpectatorsList.Columns.AddItem(newFColumnItem(SpectatorsHeader, 1.f));

	PlayersRightClick.ItemRows.Add(2);
	PlayersRightClick.ItemRows[0].Text = ViewProfileString;
	PlayersRightClick.ItemRows[1].Text = ChatMuteString;

}

final function UpdateList()
{
	local string S;
	local int i;
	local CD_GameReplicationInfo CDGRI;
	local KFPlayerReplicationInfo KFPRI;

	PlayersList.EmptyList();
	SpectatorsList.EmptyList();
	PlayersInfo.Remove(0, PlayersInfo.length);
	SpectatorsInfo.Remove(0, SpectatorsInfo.length);
	bListUpdate = true;

	CDGRI = GetCDGRI();
	if(CDGRI == none)
		return;

	for(i=CDGRI.PRIArray.length-1; i>=0; --i)
	{
		KFPRI = KFPlayerReplicationInfo(CDGRI.PRIArray[i]);
		if(KFPRI == none)
			continue;

		S = KFPRI.PlayerName $ "\n";

		if(GetCDPC().MuteChatTargets.Find(KFPRI) != INDEX_NONE)
			S = MutingPrefix @ S;

		if(!KFPRI.bOnlySpectator)
		{
			PlayersInfo.AddItem(KFPRI);
			PlayersList.AddLine(S);
		}
		else
		{
			SpectatorsInfo.AddItem(KFPRI);
			SpectatorsList.AddLine(S);
		}
	}
}

function ButtonClicked(KFGUI_Button Sender)
{
	switch(Sender.ID)
	{
		case 'Refresh':
			bListUpdate=false;
			break;
	}
}

function SelectedPlayersListRow(KFGUI_ListItem Item, int Row, bool bRight, bool bDblClick)
{
	if(Row < 0)
		return;

	SelectedUser = PlayersInfo[Row];
	PlayersRightClick.OpenMenu(self);
}

function SelectedSpectatorsListRow(KFGUI_ListItem Item, int Row, bool bRight, bool bDblClick)
{
	if(Row < 0)
		return;

	SelectedUser = SpectatorsInfo[Row];
	PlayersRightClick.OpenMenu(self);
}

function UserClickedRow(int i)
{
	switch(i)
	{
		case 0:
			OnlineSubsystemSteamworks(class'GameEngine'.static.GetOnlineSubsystem()).ShowProfileUI(0,,SelectedUser.UniqueId);
			break;
		case 1:
			GetCDPC().ToggleMuteChat(SelectedUser);
			bListUpdate = false;
			break;
	}
}

defaultproperties
{
	ID="PlayersMenu"
	Version="1.0.1"

	Begin Object Class=KFGUI_Button Name=Refresh
		XPosition=0.05
		YPosition=0.875
		XSize=0.10
		YSize=0.05
		ID="Refresh"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_ColumnList Name=PlayersList
		XPosition=0.05
		YPosition=0.10
		XSize=0.43
		YSize=0.75
		ID="Players"
		OnSelectedRow=SelectedPlayersListRow
		bCanSortColumn=false
	End Object

	Begin Object Class=KFGUI_ColumnList Name=SpectatorsList
		XPosition=0.52
		YPosition=0.10
		XSize=0.43
		YSize=0.75
		ID="Spectators"
		OnSelectedRow=SelectedSpectatorsListRow
		bCanSortColumn=false
	End Object

	Begin Object Class=KFGUI_RightClickMenu Name=PlayersRClicker
		ID="PlayersRClick"
		OnSelectedItem=UserClickedRow
	End Object

	Components.Add(Refresh)
	Components.Add(PlayersList)
	Components.Add(SpectatorsList)
	PlayersRightClick=PlayersRClicker
}

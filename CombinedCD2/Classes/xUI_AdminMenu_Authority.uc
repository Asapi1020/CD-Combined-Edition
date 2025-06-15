class xUI_AdminMenu_Authority extends KFGUI_MultiComponent
	within xUI_AdminMenu;

var KFGUI_ColumnList AuthList;
var KFGUI_RightClickMenu UserRClicker;
var editinline export KFGUI_RightClickMenu UserRightClick;

var UserInfo SelectedUser;
var array<UserInfo> CurUserInfo;
var array<string> ColumnText;

public function InitComponents()
{
	local int i, AdminLevel;
	local string s;

	AuthList = KFGUI_ColumnList(FindComponentID('AuthList'));
	AuthList.Columns.AddItem(newFColumnItem(NameHeader, 0.5f));
	AuthList.Columns.AddItem(newFColumnItem(IDHeader, 0.4f));
	AuthList.Columns.AddItem(newFColumnItem(LevelHeader, 0.1f));

	UserRClicker = KFGUI_RightClickMenu(FindComponentID('UserRClicker'));

	UserRightClick.ItemRows.Add(6);

	AdminLevel = class'CD_AuthorityHandler'.const.ADMIN_LEVEL;

	for(i=0; i<AdminLevel+1; i++)
	{
		s = LevelSetString $ "Lv." $ string(i);
		UserRightClick.ItemRows[i].Text = s;
	}
	
	UserRightClick.ItemRows[AdminLevel].Text @= class'KFGame.KFLocalMessage'.default.AdminString;
	UserRightClick.ItemRows[AdminLevel + 1].Text = RemoveString;
}

public function DrawComponents();

public function UpdateAuthorityList()
{
	local KFPlayerReplicationinfo KFPRI;
	local UserInfo NewUser;
	local int i;
	local string SteamID;

	AuthList.EmptyList();
	CurUserInfo.Remove(0, CurUserInfo.length);

	for(i=0; i<GetCDGRI().PRIArray.length; i++)
	{
		KFPRI = KFPlayerReplicationInfo(GetCDGRI().PRIArray[i]);
		SteamID = class'CD_Object'.static.GetSteamID(KFPRI.UniqueId);

		if(GetCDPC().AuthorityList.Find('SteamID', SteamID) == INDEX_NONE)
		{
			NewUser.UserName = KFPRI.PlayerName;
			NewUser.SteamID = SteamID;
			NewUser.AuthorityLevel = 0;
			AddLineOperation(NewUser);
		}
	}

	for(i=0; i<GetCDPC().AuthorityList.length; i++)
	{
		AddLineOperation(GetCDPC().AuthorityList[i]);
	}

	if(!GetCDPC().bAuthReceived)
	{
		SetTimer(1.f, false, 'DelayedUpdateList');
		AuthList.AddLine(LoadingMsg);
		return;
	}
}

private function AddLineOperation(UserInfo NewUser)
{
	CurUserInfo.AddItem(NewUser);
	AuthList.AddLine(NewUser.UserName $ "\n" $ NewUser.SteamID $ "\n" $ string(NewUser.AuthorityLevel));
}

private function SelectedListRow(KFGUI_ListItem Item, int Row, bool bRight, bool bDblClick)
{
	if(Row < 0)
	{
		return;
	}

	SelectedUser = CurUserInfo[Row];
	UserRightClick.OpenMenu(self);
}

private function UserClickedRow(int RowNum)
{
	local int AdminLevel;

	AdminLevel = class'CD_AuthorityHandler'.const.ADMIN_LEVEL;

	if(RowNum < AdminLevel + 1)
	{
		SelectedUser.AuthorityLevel = RowNum;
		GetCDPC().ChangeUserAuthority(SelectedUser);
	}
	else if(RowNum == AdminLevel + 1)
	{
		GetCDPC().RemoveAuthorityInfo(SelectedUser);
	}
	SetTimer(1.f, false, 'DelayedUpdateList');
}

private function DelayedUpdateList()
{
	Outer.bListUpdate = false;
}

defaultproperties
{
	ID="AdminMenu_Authority"

	Begin Object Class=KFGUI_ColumnList Name=AuthList
		XPosition=0.05
		YPosition=0.05
		XSize=0.52
		YSize=0.85
		ID="AuthList"
		OnSelectedRow=SelectedListRow
		bCanSortColumn=false
	End Object
	Components.Add(AuthList)

	Begin Object Class=KFGUI_RightClickMenu Name=UserRClicker
		ID="UserRClick"
		OnSelectedItem=UserClickedRow
	End Object
	UserRightClick=UserRClicker
}

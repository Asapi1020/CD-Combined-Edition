class xUI_AdminMenu extends xUI_MenuBase;

enum ListSwitch
{
	WeapList,
	UserList
};

var KFGUI_Button CommandoB;
var KFGUI_Button SupportB;
var KFGUI_Button FieldMedicB;
var KFGUI_Button GunslingerB;
var KFGUI_Button SharpshooterB;
var KFGUI_Button SwatB;
var KFGUI_Button OtherB;
var KFGUI_Button WeaponB;
var KFGUI_Button PlayerB;
var KFGUI_Button CloseB;
var KFGUI_Button ListToggleB;
var KFGUI_Button PerkSubB;
var KFGUI_Button PerkAddB;

var KFGUI_ColumnList AuthList;
var KFGUI_RightClickMenu WeapRClicker;
var KFGUI_RightClickMenu UserRClicker;
var editinline export KFGUI_RightClickMenu WeapRightClick;
var editinline export KFGUI_RightClickMenu UserRightClick;

var KFGUI_CheckBox LevelRestrictionBox;
var KFGUI_CheckBox SkillRestriction0;
var KFGUI_CheckBox SkillRestriction1;
var KFGUI_CheckBox SkillRestriction2;
var KFGUI_CheckBox SkillRestriction3;
var KFGUI_CheckBox SkillRestriction4;
var KFGUI_CheckBox SkillRestriction5;
var KFGUI_CheckBox SkillRestriction6;
var KFGUI_CheckBox SkillRestriction7;
var KFGUI_CheckBox SkillRestriction8;
var KFGUI_CheckBox SkillRestriction9;

var ListSwitch ListCategoly;
var bool bListUpdate;
var class<KFWeaponDefinition> SelectedWeap;
var UserInfo SelectedUser;
var array< class<KFWeaponDefinition> > CurWeapDef;
var array<UserInfo> CurUserInfo;
var array<string> ColumnText;

const LevelRestrictionToolTip = "Do you require players to reach Lv25?";
const SkillRestrictionToolTip = "Do you ban this skill?";
const ListToggleToolTip = "Toggle list contents between weapons and user authorities.";

function SetWindowDrag(bool bDrag)
{
	bDragWindow = false;
}

function DrawMenu()
{
//	Setup
	local float XL, YL, FontScalar;
	local int index;
	local string S;

	Super.DrawMenu();

	WindowTitle="Admin Menu v1.0";
	Canvas.Font = Owner.CurrentStyle.PickFont(FontScalar);
	Canvas.TextSize("ABC", XL, YL, FontScalar, FontScalar);

//	Perk Option Button

	CommandoB = KFGUI_Button(FindComponentID('Commando'));
	CommandoB.bDisabled = (GetCDPC().WeapUIInfo.Perk == class'KFPerk_Commando') ? true : false;
	CommandoB.OverlayTexture.Texture = class'KFPerk_Commando'.default.PerkIcon;
	CommandoB.OverlayTexture.UL = 256;
	CommandoB.OverlayTexture.VL = 256;

	SupportB = KFGUI_Button(FindComponentID('Support'));
	SupportB.bDisabled = (GetCDPC().WeapUIInfo.Perk == class'KFPerk_Support') ? true : false;
	SupportB.OverlayTexture.Texture = class'KFPerk_Support'.default.PerkIcon;
	SupportB.OverlayTexture.UL = 256;
	SupportB.OverlayTexture.VL = 256;

	FieldMedicB = KFGUI_Button(FindComponentID('FieldMedic'));
	FieldMedicB.bDisabled = (GetCDPC().WeapUIInfo.Perk == class'KFPerk_FieldMedic') ? true : false;
	FieldMedicB.OverlayTexture.Texture = class'KFPerk_FieldMedic'.default.PerkIcon;
	FieldMedicB.OverlayTexture.UL = 256;
	FieldMedicB.OverlayTexture.VL = 256;

	GunslingerB = KFGUI_Button(FindComponentID('Gunslinger'));
	GunslingerB.bDisabled = (GetCDPC().WeapUIInfo.Perk == class'KFPerk_Gunslinger') ? true : false;
	GunslingerB.OverlayTexture.Texture = class'KFPerk_Gunslinger'.default.PerkIcon;
	GunslingerB.OverlayTexture.UL = 256;
	GunslingerB.OverlayTexture.VL = 256;

	SharpshooterB = KFGUI_Button(FindComponentID('Sharpshooter'));
	SharpshooterB.bDisabled = (GetCDPC().WeapUIInfo.Perk == class'KFPerk_Sharpshooter') ? true : false;
	SharpshooterB.OverlayTexture.Texture = class'KFPerk_Sharpshooter'.default.PerkIcon;
	SharpshooterB.OverlayTexture.UL = 256;
	SharpshooterB.OverlayTexture.VL = 256;

	SwatB = KFGUI_Button(FindComponentID('Swat'));
	SwatB.bDisabled = (GetCDPC().WeapUIInfo.Perk == class'KFPerk_Swat') ? true : false;
	SwatB.OverlayTexture.Texture = class'KFPerk_Swat'.default.PerkIcon;
	SwatB.OverlayTexture.UL = 256;
	SwatB.OverlayTexture.VL = 256;

	OtherB = KFGUI_Button(FindComponentID('Other'));
	OtherB.bDisabled = (GetCDPC().WeapUIInfo.Perk == none) ? true : false;
	OtherB.OverlayTexture.Texture = Texture2D'UI_TraderMenu_TEX.UI_WeaponSelect_Trader_Perk';
	OtherB.OverlayTexture.UL = 256;
	OtherB.OverlayTexture.VL = 256;

	PerkSubB = KFGUI_Button(FindComponentID('PerkSub'));
	PerkSubB.ButtonText = "-";
	PerkAddB = KFGUI_Button(FindComponentID('PerkAdd'));
	PerkAddB.ButtonText = "+";

	index = GetCDPC().PerkRestrictions.Find('Perk', GetCDPC().WeapUIInfo.Perk);
	if(index == INDEX_NONE)
		S = "0";
	else
		S = string(GetCDPC().PerkRestrictions[index].RequiredLevel);

	DrawControllerInfo("Perk Authority Level", S, PerkSubB, PerkAddB, YL, FontScalar, Owner.HUDOwner.ScaledBorderSize, 30);

//	List
	if(!bListUpdate)
	{
		UpdateList();
	}

	ListToggleB = KFGUI_Button(FindComponentID('ListToggle'));
	ListToggleB.ButtonText = "Toggle List";
	ListToggleB.ToolTip=ListToggleToolTip;

//	Check Boxes (Level & Skills)
	LevelRestrictionBox = KFGUI_CheckBox(FindComponentID('LevelRestriction'));
	LevelRestrictionBox.bChecked = GetCDPC().bRequireLv25;
	LevelRestrictionBox.ToolTip=LevelRestrictionToolTip;
	DrawBoxDescription("Require Lv25", LevelRestrictionBox, 0.3);


	SkillRestriction0 = KFGUI_CheckBox(FindComponentID('SR0'));
	SkillRestriction0.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 0);
	SkillRestriction0.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescriptionReverse(GetCDPC().WeapUIInfo.Perk.default.PerkSkills[0].Name, SkillRestriction0, 0.05);

	SkillRestriction1 = KFGUI_CheckBox(FindComponentID('SR1'));
	SkillRestriction1.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 1);
	SkillRestriction1.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescription(GetCDPC().WeapUIInfo.Perk.default.PerkSkills[1].Name, SkillRestriction1, 0.425);

	SkillRestriction2 = KFGUI_CheckBox(FindComponentID('SR2'));
	SkillRestriction2.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 2);
	SkillRestriction2.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescriptionReverse(GetCDPC().WeapUIInfo.Perk.default.PerkSkills[2].Name, SkillRestriction2, 0.05);

	SkillRestriction3 = KFGUI_CheckBox(FindComponentID('SR3'));
	SkillRestriction3.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 3);
	SkillRestriction3.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescription(GetCDPC().WeapUIInfo.Perk.default.PerkSkills[3].Name, SkillRestriction3, 0.425);

	SkillRestriction4 = KFGUI_CheckBox(FindComponentID('SR4'));
	SkillRestriction4.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 4);
	SkillRestriction4.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescriptionReverse(GetCDPC().WeapUIInfo.Perk.default.PerkSkills[4].Name, SkillRestriction4, 0.05);

	SkillRestriction5 = KFGUI_CheckBox(FindComponentID('SR5'));
	SkillRestriction5.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 5);
	SkillRestriction5.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescription(GetCDPC().WeapUIInfo.Perk.default.PerkSkills[5].Name, SkillRestriction5, 0.425);

	SkillRestriction6 = KFGUI_CheckBox(FindComponentID('SR6'));
	SkillRestriction6.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 6);
	SkillRestriction6.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescriptionReverse(GetCDPC().WeapUIInfo.Perk.default.PerkSkills[6].Name, SkillRestriction6, 0.05);

	SkillRestriction7 = KFGUI_CheckBox(FindComponentID('SR7'));
	SkillRestriction7.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 7);
	SkillRestriction7.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescription(GetCDPC().WeapUIInfo.Perk.default.PerkSkills[7].Name, SkillRestriction7, 0.425);

	SkillRestriction8 = KFGUI_CheckBox(FindComponentID('SR8'));
	SkillRestriction8.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 8);
	SkillRestriction8.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescriptionReverse(GetCDPC().WeapUIInfo.Perk.default.PerkSkills[8].Name, SkillRestriction8, 0.05);

	SkillRestriction9 = KFGUI_CheckBox(FindComponentID('SR9'));
	SkillRestriction9.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 9);
	SkillRestriction9.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescription(GetCDPC().WeapUIInfo.Perk.default.PerkSkills[9].Name, SkillRestriction9, 0.425);

	CloseB = KFGUI_Button(FindComponentID('Close'));
	CloseB.ButtonText = "Close";
}

function InitMenu()
{
	super.InitMenu();

	AuthList = KFGUI_ColumnList(FindComponentID('AuthList'));
	AuthList.Columns.AddItem(newFColumnItem(ColumnText[0], 0.5f));
	AuthList.Columns.AddItem(newFColumnItem(ColumnText[1], 0.4f));
	AuthList.Columns.AddItem(newFColumnItem(ColumnText[2], 0.1f));

	WeapRClicker = KFGUI_RightClickMenu(FindComponentID('WeapRClicker'));
	UserRClicker = KFGUI_RightClickMenu(FindComponentID('UserRClicker'));
}

final function UpdateList()
{
	local KFGFxObject_TraderItems TraderItems;
	local KFPlayerReplicationinfo KFPRI;
	local UserInfo NewUser;
	local int i, j, index;
	local string S, SteamID;

	AuthList.EmptyList();

	if(ListCategoly == WeapList)
	{
		TraderItems = KFGameReplicationInfo(GetCDPC().WorldInfo.GRI).TraderItems;
		CurWeapDef.Remove(0, CurWeapDef.length);
		AuthList.Columns[0].Text = "Weapon";
		AuthList.Columns[1].Text = "Boss Only";

		for(i=0; i<TraderItems.SaleItems.length; i++)
		{
			if (TraderItems.SaleItems[i].AssociatedPerkClasses.Find(GetCDPC().WeapUIInfo.Perk) == INDEX_NONE)
				continue;

			S = class'CD_Object'.static.GetWeapClass(TraderItems.SaleItems[i].WeaponDef).default.ItemName;
			CurWeapDef.AddItem(TraderItems.SaleItems[i].WeaponDef);
			index = GetCDPC().WeaponRestrictions.Find('WeapDef', TraderItems.SaleItems[i].WeaponDef);

			if(index != INDEX_NONE)
			{
				S $= "\n";

				if(GetCDPC().WeaponRestrictions[index].bOnlyForBoss)
					S $= "TRUE";

				j = GetCDPC().WeaponRestrictions[index].RequiredLevel;
				if(j > 0)
					S $= "\n" $ string(j);
			}

			AuthList.AddLine(S);
		}
	}
	else
	{
		CurUserInfo.Remove(0, CurUserInfo.length);
		AuthList.Columns[0].Text = "Name";
		AuthList.Columns[1].Text = "ID";

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
			AuthList.AddLine("Now Loading...");
			return;
		}	
	}

	bListUpdate = true;
}

function AddLineOperation(UserInfo NewUser)
{
	CurUserInfo.AddItem(NewUser);
	AuthList.AddLine(NewUser.UserName $ "\n" $ NewUser.SteamID $ "\n" $ string(NewUser.AuthorityLevel));
}

function ButtonClicked(KFGUI_Button Sender)
{
	switch(Sender.ID)
	{
		case 'Commando':
			GetCDPC().WeapUIInfo.Perk = class'KFPerk_Commando';
			bListUpdate = false;
			break;
		case 'Support':
			GetCDPC().WeapUIInfo.Perk = class'KFPerk_Support';
			bListUpdate = false;
			break;
		case 'FieldMedic':
			GetCDPC().WeapUIInfo.Perk = class'KFPerk_FieldMedic';
			bListUpdate = false;
			break;
		case 'Gunslinger':
			GetCDPC().WeapUIInfo.Perk = class'KFPerk_Gunslinger';
			bListUpdate = false;
			break;
		case 'Sharpshooter':
			GetCDPC().WeapUIInfo.Perk = class'KFPerk_Sharpshooter';
			bListUpdate = false;
			break;
		case 'Swat':
			GetCDPC().WeapUIInfo.Perk = class'KFPerk_Swat';
			bListUpdate = false;
			break;
		case 'Other':
			GetCDPC().WeapUIInfo.Perk = none;
			bListUpdate = false;
			break;
		case 'Close':
			DoClose();
			break;
		case 'ListToggle':
			if(ListCategoly == WeapList)
				ListCategoly = UserList;
			else
				ListCategoly = WeapList;
			bListUpdate = false;
			break;
		case 'PerkSub':
			GetCDPC().ChangePerkRestriction(GetCDPC().WeapUIInfo.Perk, -1);
			break;
		case 'PerkAdd':
			GetCDPC().ChangePerkRestriction(GetCDPC().WeapUIInfo.Perk, 1);
			break;
	}
}

function SelectedListRow(KFGUI_ListItem Item, int Row, bool bRight, bool bDblClick)
{
	if(ListCategoly == WeapList)
	{
		SelectedWeap = CurWeapDef[Row];
		WeapRightClick.OpenMenu(self);
	}
	else
	{
		SelectedUser = CurUserInfo[Row];
		UserRightClick.OpenMenu(self);
	}
}

function WeapClickedRow(int RowNum)
{
	local int index, AuthLv;
	local bool bBossOnly;
	local CD_WeaponInfo CDWI;

	index = GetCDPC().WeaponRestrictions.Find('WeapDef', SelectedWeap);

	if(RowNum < 6)
	{
		AuthLv = RowNum;

		if(index == INDEX_NONE)
		{
			bBossOnly = false;
		}
		else
		{
			bBossOnly = GetCDPC().WeaponRestrictions[index].bOnlyForBoss;
		}
	}
	else if(RowNum == 6)
	{
		if(index == INDEX_NONE)
		{
			AuthLv = 0;
			bBossOnly = true;
		}
		else
		{
			AuthLv = GetCDPC().WeaponRestrictions[index].RequiredLevel;
			bBossOnly = !GetCDPC().WeaponRestrictions[index].bOnlyForBoss;
		} 
	}

	CDWI.WeapDef = SelectedWeap;
	CDWI.RequiredLevel = AuthLv;
	CDWI.bOnlyForBoss = bBossOnly;

	GetCDPC().ChangeWeaponRestriction(CDWI);
	SetTimer(1.f, false, 'DelayedUpdateList');
}

function UserClickedRow(int RowNum)
{
	if(RowNum < 5)
	{
		SelectedUser.AuthorityLevel = RowNum;
		GetCDPC().ChangeUserAuthority(SelectedUser);
	}
	SetTimer(1.f, false, 'DelayedUpdateList');
}

function DelayedUpdateList()
{
	bListUpdate = false;
}

function ToggleCheckBox(KFGUI_CheckBox Sender)
{
	local CD_PlayerController CDPC;

	CDPC = GetCDPC();

	switch (Sender.ID)
	{
		case 'LevelRestriction':
			CDPC.ChangeLevelRestriction(Sender.bChecked);
			break;
		case 'SR0':
			CDPC.SaveSkillRestriction(GetCDPC().WeapUIInfo.Perk, 0, Sender.bChecked);
			break;
		case 'SR1':
			CDPC.SaveSkillRestriction(GetCDPC().WeapUIInfo.Perk, 1, Sender.bChecked);
			break;
		case 'SR2':
			CDPC.SaveSkillRestriction(GetCDPC().WeapUIInfo.Perk, 2, Sender.bChecked);
			break;
		case 'SR3':
			CDPC.SaveSkillRestriction(GetCDPC().WeapUIInfo.Perk, 3, Sender.bChecked);
			break;
		case 'SR4':
			CDPC.SaveSkillRestriction(GetCDPC().WeapUIInfo.Perk, 4, Sender.bChecked);
			break;
		case 'SR5':
			CDPC.SaveSkillRestriction(GetCDPC().WeapUIInfo.Perk, 5, Sender.bChecked);
			break;
		case 'SR6':
			CDPC.SaveSkillRestriction(GetCDPC().WeapUIInfo.Perk, 6, Sender.bChecked);
			break;
		case 'SR7':
			CDPC.SaveSkillRestriction(GetCDPC().WeapUIInfo.Perk, 7, Sender.bChecked);
			break;
		case 'SR8':
			CDPC.SaveSkillRestriction(GetCDPC().WeapUIInfo.Perk, 8, Sender.bChecked);
			break;
		case 'SR9':
			CDPC.SaveSkillRestriction(GetCDPC().WeapUIInfo.Perk, 9, Sender.bChecked);
			break;
	}
}

defaultproperties
{
//	General
	XPosition=0.18
	YPosition=0.05
	XSize=0.64
	YSize=0.9
	ListCategoly=WeapList
	ColumnText(0)="Weapon"
	ColumnText(1)="Boss Only"
	ColumnText(2)="Lv."

//	Perk Option

	Begin Object Class=KFGUI_Button Name=Commando
		XPosition=0.055
		YPosition=0.05
		XSize=0.14
		YSize=0.05
		ID="Commando"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
		ButtonText=""
	End Object

	Begin Object Class=KFGUI_Button Name=Support
		XPosition=0.205
		YPosition=0.05
		XSize=0.14
		YSize=0.05
		ID="Support"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
		ButtonText=""
	End Object

	Begin Object Class=KFGUI_Button Name=FieldMedic
		XPosition=0.355
		YPosition=0.05
		XSize=0.14
		YSize=0.05
		ID="FieldMedic"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
		ButtonText=""
	End Object

	Begin Object Class=KFGUI_Button Name=Gunslinger
		XPosition=0.505
		YPosition=0.05
		XSize=0.14
		YSize=0.05
		ID="Gunslinger"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
		ButtonText=""
	End Object

	Begin Object Class=KFGUI_Button Name=Sharpshooter
		XPosition=0.655
		YPosition=0.05
		XSize=0.14
		YSize=0.05
		ID="Sharpshooter"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
		ButtonText=""
	End Object

	Begin Object Class=KFGUI_Button Name=Swat
		XPosition=0.805
		YPosition=0.05
		XSize=0.14
		YSize=0.05
		ID="Swat"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
		ButtonText=""
	End Object

	Begin Object Class=KFGUI_Button Name=Close
		XPosition=0.025
		YPosition=0.925
		XSize=0.10
		YSize=0.05
		ID="Close"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=Other
		XPosition=0.055
		YPosition=0.125
		XSize=0.14
		YSize=0.05
		ID="Other"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
		ButtonText=""
	End Object

	Begin Object Class=KFGUI_Button Name=PerkSub
		XPosition=0.055
		YPosition=0.300
		XSize=0.05
		YSize=0.05
		ID="PerkSub"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=PerkAdd
		XPosition=0.250
		YPosition=0.300
		XSize=0.05
		YSize=0.05
		ID="PerkAdd"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Components.Add(Commando)
	Components.Add(Support)
	Components.Add(FieldMedic)
	Components.Add(Gunslinger)
	Components.Add(Sharpshooter)
	Components.Add(Swat)
	Components.Add(Other)
	Components.Add(Close)
	Components.Add(PerkSub)
	Components.Add(PerkAdd)

//	List
	Begin Object Class=KFGUI_ColumnList Name=AuthList
		XPosition=0.45
		YPosition=0.20
		XSize=0.52
		YSize=0.775
		ID="AuthList"
		OnSelectedRow=SelectedListRow
		bCanSortColumn=false
	End Object

	Begin Object Class=KFGUI_Button Name=ListToggle
		XPosition=0.80
		YPosition=0.13
		XSize=0.14
		YSize=0.05
		ID="ListToggle"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_RightClickMenu Name=WeapRClicker
		ID="WeapRClick"
		ItemRows(0)=(Text="Set Lv.0")
		ItemRows(1)=(Text="Set Lv.1")
		ItemRows(2)=(Text="Set Lv.2")
		ItemRows(3)=(Text="Set Lv.3")
		ItemRows(4)=(Text="Set Lv.4")
		ItemRows(5)=(Text="Set Lv.5 (Ban)")
		ItemRows(6)=(Text="Toggle Boss Only")
		OnSelectedItem=WeapClickedRow
	End Object
	
	Begin Object Class=KFGUI_RightClickMenu Name=UserRClicker
		ID="UserRClick"
		ItemRows(0)=(Text="Set Lv.0")
		ItemRows(1)=(Text="Set Lv.1")
		ItemRows(2)=(Text="Set Lv.2")
		ItemRows(3)=(Text="Set Lv.3")
		ItemRows(4)=(Text="Set Lv.4 (Admin)")
		OnSelectedItem=UserClickedRow
	End Object

	Components.Add(AuthList)
	Components.Add(ListToggle)
	WeapRightClick=WeapRClicker
	UserRightClick=UserRClicker

//	Check Box
	Begin Object Class=KFGUI_CheckBox Name=LevelRestriction
		XPosition=0.055
		YPosition=0.200
		ID="LevelRestriction"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction0
		XPosition=0.20
		YPosition=0.40
		ID="SR0"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction1
		XPosition=0.24
		YPosition=0.40
		ID="SR1"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction2
		XPosition=0.20
		YPosition=0.45
		ID="SR2"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction3
		XPosition=0.24
		YPosition=0.45
		ID="SR3"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction4
		XPosition=0.20
		YPosition=0.50
		ID="SR4"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction5
		XPosition=0.24
		YPosition=0.50
		ID="SR5"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction6
		XPosition=0.20
		YPosition=0.55
		ID="SR6"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction7
		XPosition=0.24
		YPosition=0.55
		ID="SR7"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction8
		XPosition=0.20
		YPosition=0.60
		ID="SR8"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction9
		XPosition=0.24
		YPosition=0.60
		ID="SR9"
		OnCheckChange=ToggleCheckBox
	End Object

	Components.Add(LevelRestriction)
	Components.Add(SkillRestriction0)
	Components.Add(SkillRestriction1)
	Components.Add(SkillRestriction2)
	Components.Add(SkillRestriction3)
	Components.Add(SkillRestriction4)
	Components.Add(SkillRestriction5)
	Components.Add(SkillRestriction6)
	Components.Add(SkillRestriction7)
	Components.Add(SkillRestriction8)
	Components.Add(SkillRestriction9)
}
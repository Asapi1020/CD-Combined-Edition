class xUI_AdminMenu extends xUI_MenuBase;

`include(CD_Log.uci)

enum PageState
{
	RPW,
	Authority,
	CustomPlayerStart,
	Record
};

var KFGUI_Button CommandoB;
var KFGUI_Button SupportB;
var KFGUI_Button FieldMedicB;
var KFGUI_Button GunslingerB;
var KFGUI_Button SharpshooterB;
var KFGUI_Button SwatB;
var KFGUI_Button OtherB;
var KFGUI_Button CloseB;
var KFGUI_Button RPWB;
var KFGUI_Button AuthorityB;
var KFGUI_Button PlayerStartButton;
var KFGUI_Button PerkSubB;
var KFGUI_Button PerkAddB;
var KFGUI_Button UpgradeSubB;
var KFGUI_Button UpgradeAddB;

var KFGUI_ColumnList AuthList;
var KFGUI_RightClickMenu WeapRClicker;
var KFGUI_RightClickMenu UserRClicker;
var editinline export KFGUI_RightClickMenu WeapRightClick;
var editinline export KFGUI_RightClickMenu UserRightClick;

var KFGUI_CheckBox LevelRestrictionBox;
var KFGUI_CheckBox AntiOvercapBox;
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

var private xUI_AdminMenu_PlayerStart PlayerStartComponents;

var PageState CurState;
var bool bListUpdate;
var class<KFWeaponDefinition> SelectedWeap;
var UserInfo SelectedUser;
var array< class<KFWeaponDefinition> > CurWeapDef;
var array<UserInfo> CurUserInfo;
var array<string> ColumnText;

var localized string LevelRestrictionToolTip;
var localized string SkillRestrictionToolTip;
var localized string AntiOvercapToolTip;
var localized string PerkAuthorityString;
var localized string MaxUpgradeString;
var localized string RPWButtonText;
var localized string AuthorityButtonText;
var localized string PlayerStartButtonText;
var localized string LevelRequirementString;
var localized string AntiOvercapString;
var localized string WeaponHeader;
var localized string BossOnlyHeader;
var localized string NameHeader;
var localized string IDHeader;
var localized string LoadingMsg;
var localized string LevelHeader;
var localized string LevelSetString;
var localized string BanString;
var localized string ToggleBossOnlyString;
var localized string RemoveString;

function SetWindowDrag(bool bDrag)
{
	bDragWindow = false;
}

function InitMenu()
{
	super.InitMenu();

	PlayerStartComponents = new(self) class'xUI_AdminMenu_PlayerStart';
	AddComponent(PlayerStartComponents);
	PlayerStartComponents.InitComponents();

	InitAuthList();
}

function DrawMenu()
{
//	Setup
	local float XL, YL, FontScalar;

	Super.DrawMenu();

	Canvas.Font = Owner.CurrentStyle.PickFont(FontScalar);
	Canvas.TextSize("ABC", XL, YL, FontScalar, FontScalar);
	ToggleComponents();

	switch(CurState)
	{
		case RPW:
			DrawRPWMenu(XL, YL, FontScalar);
			break;
		case Authority:
			DrawRPWMenu(XL, YL, FontScalar);
			break;
		case CustomPlayerStart:
			PlayerStartComponents.DrawComponents();
			break;
		default:
			`cdlog("invalid cur state");
			CurState = RPW;
			break;
	}

	if(!bListUpdate)
	{
		UpdateList();
	}

	RPWB = KFGUI_Button(FindComponentID('RPW'));
	RPWB.ButtonText = RPWButtonText;

	AuthorityB = KFGUI_Button(FindComponentID('Authority'));
	AuthorityB.ButtonText = AuthorityButtonText;

	PlayerStartButton = KFGUI_Button(FindComponentID('CustomPlayerStart'));
	PlayerStartButton.ButtonText = PlayerStartButtonText;

	CloseB = KFGUI_Button(FindComponentID('Close'));
	CloseB.ButtonText = CloseButtonText;
}

private function DrawRPWMenu(float XL, float YL, float FontScalar)
{
	local int index;
	local string S;

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

	DrawControllerInfo(PerkAuthorityString, S, PerkSubB, PerkAddB, YL, FontScalar, Owner.HUDOwner.ScaledBorderSize, 30,,,CurState==RPW);

	UpgradeSubB = KFGUI_Button(FindComponentID('UpgradeSub'));
	UpgradeSubB.ButtonText = "-";
	UpgradeAddB = KFGUI_Button(FindComponentID('UpgradeAdd'));
	UpgradeAddB.ButtonText = "+";
	S = string(GetCDGRI().MaxUpgrade);
	DrawControllerInfo(MaxUpgradeString, S, UpgradeSubB, UpgradeAddB, YL, FontScalar, Owner.HUDOwner.ScaledBorderSize, 30,,,CurState==RPW);

	LevelRestrictionBox = KFGUI_CheckBox(FindComponentID('LevelRestriction'));
	LevelRestrictionBox.bChecked = GetCDPC().bRequireLv25;
	LevelRestrictionBox.ToolTip=LevelRestrictionToolTip;
	DrawBoxDescription(LevelRequirementString, LevelRestrictionBox, 0.3, CurState==RPW);

	AntiOvercapBox = KFGUI_CheckBox(FindComponentID('AntiOvercap'));
	AntiOvercapBox.bChecked = GetCDPC().bAntiOvercap;
	AntiOvercapBox.ToolTip=AntiOvercapToolTip;
	DrawBoxDescription(AntiOvercapString, AntiOvercapBox, 0.3, CurState==RPW);

	SkillRestriction0 = KFGUI_CheckBox(FindComponentID('SR0'));
	SkillRestriction0.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 0);
	SkillRestriction0.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescriptionReverse(GetCDPC().GetLocalizedSkillName(GetCDPC().WeapUIInfo.Perk, 0), SkillRestriction0, 0.05, CurState==RPW);

	SkillRestriction1 = KFGUI_CheckBox(FindComponentID('SR1'));
	SkillRestriction1.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 1);
	SkillRestriction1.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescription(GetCDPC().GetLocalizedSkillName(GetCDPC().WeapUIInfo.Perk, 1), SkillRestriction1, 0.425, CurState==RPW);

	SkillRestriction2 = KFGUI_CheckBox(FindComponentID('SR2'));
	SkillRestriction2.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 2);
	SkillRestriction2.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescriptionReverse(GetCDPC().GetLocalizedSkillName(GetCDPC().WeapUIInfo.Perk, 2), SkillRestriction2, 0.05, CurState==RPW);

	SkillRestriction3 = KFGUI_CheckBox(FindComponentID('SR3'));
	SkillRestriction3.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 3);
	SkillRestriction3.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescription(GetCDPC().GetLocalizedSkillName(GetCDPC().WeapUIInfo.Perk, 3), SkillRestriction3, 0.425, CurState==RPW);

	SkillRestriction4 = KFGUI_CheckBox(FindComponentID('SR4'));
	SkillRestriction4.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 4);
	SkillRestriction4.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescriptionReverse(GetCDPC().GetLocalizedSkillName(GetCDPC().WeapUIInfo.Perk, 4), SkillRestriction4, 0.05, CurState==RPW);

	SkillRestriction5 = KFGUI_CheckBox(FindComponentID('SR5'));
	SkillRestriction5.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 5);
	SkillRestriction5.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescription(GetCDPC().GetLocalizedSkillName(GetCDPC().WeapUIInfo.Perk, 5), SkillRestriction5, 0.425, CurState==RPW);

	SkillRestriction6 = KFGUI_CheckBox(FindComponentID('SR6'));
	SkillRestriction6.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 6);
	SkillRestriction6.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescriptionReverse(GetCDPC().GetLocalizedSkillName(GetCDPC().WeapUIInfo.Perk, 6), SkillRestriction6, 0.05, CurState==RPW);

	SkillRestriction7 = KFGUI_CheckBox(FindComponentID('SR7'));
	SkillRestriction7.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 7);
	SkillRestriction7.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescription(GetCDPC().GetLocalizedSkillName(GetCDPC().WeapUIInfo.Perk, 7), SkillRestriction7, 0.425, CurState==RPW);

	SkillRestriction8 = KFGUI_CheckBox(FindComponentID('SR8'));
	SkillRestriction8.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 8);
	SkillRestriction8.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescriptionReverse(GetCDPC().GetLocalizedSkillName(GetCDPC().WeapUIInfo.Perk, 8), SkillRestriction8, 0.05, CurState==RPW);

	SkillRestriction9 = KFGUI_CheckBox(FindComponentID('SR9'));
	SkillRestriction9.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 9);
	SkillRestriction9.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescription(GetCDPC().GetLocalizedSkillName(GetCDPC().WeapUIInfo.Perk, 9), SkillRestriction9, 0.425, CurState==RPW);
}

final function ToggleComponents()
{
	local array<KFGUI_Base> RPWComponents;

	RPWB.bDisabled			= CurState == RPW;
	AuthorityB.bDisabled	= CurState == Authority;
	PlayerStartButton.bDisabled = CurState == CustomPlayerStart;

	RPWComponents.AddItem(CommandoB);
	RPWComponents.AddItem(SupportB);
	RPWComponents.AddItem(FieldMedicB);
	RPWComponents.AddItem(GunslingerB);
	RPWComponents.AddItem(SharpshooterB);
	RPWComponents.AddItem(SwatB);
	RPWComponents.AddItem(OtherB);
	RPWComponents.AddItem(PerkSubB);
	RPWComponents.AddItem(PerkAddB);
	RPWComponents.AddItem(UpgradeSubB);
	RPWComponents.AddItem(UpgradeAddB);
	RPWComponents.AddItem(AntiOverCapBox);
	RPWComponents.AddItem(LevelRestrictionBox);
	RPWComponents.AddItem(SkillRestriction0);
	RPWComponents.AddItem(SkillRestriction1);
	RPWComponents.AddItem(SkillRestriction2);
	RPWComponents.AddItem(SkillRestriction3);
	RPWComponents.AddItem(SkillRestriction4);
	RPWComponents.AddItem(SkillRestriction5);
	RPWComponents.AddItem(SkillRestriction6);
	RPWComponents.AddItem(SkillRestriction7);
	RPWComponents.AddItem(SkillRestriction8);
	RPWComponents.AddItem(SkillRestriction9);
	
	ToggleComponentsVisibility(RPWComponents, CurState == RPW);

	AuthList.bVisible = CurState == RPW || CurState == Authority;
	PlayerStartComponents.bVisible = CurState == CustomPlayerStart;
}

private function InitAuthList()
{
	local int i;
	local string s;

	AuthList = KFGUI_ColumnList(FindComponentID('AuthList'));
	AuthList.Columns.AddItem(newFColumnItem(ColumnText[0], 0.5f));
	AuthList.Columns.AddItem(newFColumnItem(ColumnText[1], 0.4f));
	AuthList.Columns.AddItem(newFColumnItem(ColumnText[2], 0.1f));

	WeapRClicker = KFGUI_RightClickMenu(FindComponentID('WeapRClicker'));
	UserRClicker = KFGUI_RightClickMenu(FindComponentID('UserRClicker'));

	WeapRightClick.ItemRows.Add(7);
	UserRightClick.ItemRows.Add(6);

	for(i=0; i<5; i++)
	{
		s = LevelSetString $ "Lv." $ string(i);
		WeapRightClick.ItemRows[i].Text = s;
		UserRightClick.ItemRows[i].Text = s;
	}
	
	WeapRightClick.ItemRows[i].Text = LevelSetString $ "Lv." $ string(i) @ BanString;
	WeapRightClick.ItemRows[i+1].Text = ToggleBossOnlyString;

	UserRightClick.ItemRows[i-1].Text @= class'KFGame.KFLocalMessage'.default.AdminString;
	UserRightClick.ItemRows[i].Text = RemoveString;
}

final function UpdateList()
{
	switch(CurState)
	{
		case(RPW):
			UpdateRPWList();
			break;
		case(Authority):
			UpdateAuthorityList();
			break;
		case(CustomPlayerStart):
			PlayerStartComponents.OnUpdatePlayerStartList();
			break;
		default:
			`cdlog("invalid cur state");
			CurState = RPW;
			return;
	}

	bListUpdate = true;
}

private function UpdateRPWList()
{
	local KFGFxObject_TraderItems TraderItems;
	local int i, j, index;
	local string S;

	AuthList.EmptyList();

	TraderItems = KFGameReplicationInfo(GetCDPC().WorldInfo.GRI).TraderItems;
	CurWeapDef.Remove(0, CurWeapDef.length);
	AuthList.Columns[0].Text = WeaponHeader;
	AuthList.Columns[1].Text = BossOnlyHeader;
	AuthList.Columns[2].Text = LevelHeader;

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
				S $= Caps(string(true));

			j = GetCDPC().WeaponRestrictions[index].RequiredLevel;
			if(j > 0)
				S $= "\n" $ string(j);
		}

		AuthList.AddLine(S);
	}
}

private function UpdateAuthorityList()
{
	local KFPlayerReplicationinfo KFPRI;
	local UserInfo NewUser;
	local int i;
	local string SteamID;

	AuthList.EmptyList();

	CurUserInfo.Remove(0, CurUserInfo.length);
	AuthList.Columns[0].Text = NameHeader;
	AuthList.Columns[1].Text = IDHeader;
	AuthList.Columns[2].Text = LevelHeader;

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

public final function UpdatePlayerStartList(array<string> PathNodesIndexString)
{
	PlayerStartComponents.UpdatePlayerStartList(PathNodesIndexString);
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
		case 'RPW':
			CurState = RPW;
			bListUpdate = false;
			break;
		case 'Authority':
			CurState = Authority;
			bListUpdate = false;
			break;
		case 'CustomPlayerStart':
			CurState = CustomPlayerStart;
			bListUpdate = false;
			break;
		case 'PerkSub':
			GetCDPC().ChangePerkRestriction(GetCDPC().WeapUIInfo.Perk, -1);
			break;
		case 'PerkAdd':
			GetCDPC().ChangePerkRestriction(GetCDPC().WeapUIInfo.Perk, 1);
			break;
		case 'UpgradeSub':
			GetCDPC().ChangeMaxUpgradeCount(-1);
			break;
		case 'UpgradeAdd':
			GetCDPC().ChangeMaxUpgradeCount(1);
			break;
	}
}

function SelectedListRow(KFGUI_ListItem Item, int Row, bool bRight, bool bDblClick)
{
	if(Row < 0)
		return;

	switch(CurState)
	{
		case(RPW):
			SelectedWeap = CurWeapDef[Row];
			WeapRightClick.OpenMenu(self);
			break;
		case(Authority):
			SelectedUser = CurUserInfo[Row];
			UserRightClick.OpenMenu(self);
			break;
		case(CustomPlayerStart):
			break;
		default:
			`cdlog("invalid cur state");
			CurState = RPW;
			return;
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
	else if(RowNum == 5)
	{
		GetCDPC().RemoveAuthorityInfo(SelectedUser);
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
		case 'AntiOvercap':
			CDPC.ServerSetAntiOvercap(Sender.bChecked);
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
	ID="AdminMenu"
	Version="2.1.0"
	XPosition=0.18
	YPosition=0.05
	XSize=0.64
	YSize=0.9
	CurState=RPW
	ColumnText(0)=WeaponHeader
	ColumnText(1)=BossOnlyHeader
	ColumnText(2)=LevelHeader

//	Perk Option

	Begin Object Class=KFGUI_Button Name=Commando
		XPosition=0.0550
		YPosition=0.05
		XSize=0.1185
		YSize=0.05
		ID="Commando"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
		ButtonText=""
	End Object

	Begin Object Class=KFGUI_Button Name=Support
		XPosition=0.1835 //0.205
		YPosition=0.05
		XSize=0.1185
		YSize=0.05
		ID="Support"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
		ButtonText=""
	End Object

	Begin Object Class=KFGUI_Button Name=FieldMedic
		XPosition=0.3120 //0.355
		YPosition=0.05
		XSize=0.1185
		YSize=0.05
		ID="FieldMedic"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
		ButtonText=""
	End Object

	Begin Object Class=KFGUI_Button Name=Gunslinger
		XPosition=0.4405 //0.505
		YPosition=0.05
		XSize=0.1185
		YSize=0.05
		ID="Gunslinger"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
		ButtonText=""
	End Object

	Begin Object Class=KFGUI_Button Name=Sharpshooter
		XPosition=0.5690 //0.655
		YPosition=0.05
		XSize=0.1185
		YSize=0.05
		ID="Sharpshooter"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
		ButtonText=""
	End Object

	Begin Object Class=KFGUI_Button Name=Swat
		XPosition=0.6975 //0.805
		YPosition=0.05
		XSize=0.1185
		YSize=0.05
		ID="Swat"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
		ButtonText=""
	End Object

	Begin Object Class=KFGUI_Button Name=Other
		XPosition=0.8260 //0.055
		YPosition=0.05 //0.125
		XSize=0.1185 //0.14
		YSize=0.05
		ID="Other"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
		ButtonText=""
	End Object

	Begin Object Class=KFGUI_Button Name=Close
		XPosition=0.875 //0.025
		YPosition=0.925
		XSize=0.10
		YSize=0.05
		ID="Close"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=PerkSub
		XPosition=0.055
		YPosition=0.15 //0.300
		XSize=0.05
		YSize=0.05
		ID="PerkSub"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=PerkAdd
		XPosition=0.250
		YPosition=0.15 //0.300
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
		YPosition=0.125 //0.20
		XSize=0.52
		YSize=0.775
		ID="AuthList"
		OnSelectedRow=SelectedListRow
		bCanSortColumn=false
	End Object
	Components.Add(AuthList)

	Begin Object Class=KFGUI_Button Name=RPW
		XPosition=0.025 //-0.16//0.80
		YPosition=0.925 //0.46//0.13
		XSize=0.14
		YSize=0.05
		ID="RPW"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(RPW)

	Begin Object Class=KFGUI_Button Name=Authority
		XPosition=0.19 //-0.16//0.80
		YPosition=0.925 //0.52 //0.13
		XSize=0.14
		YSize=0.05
		ID="Authority"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(Authority)

	Begin Object Class=KFGUI_Button Name=CustomPlayerStart
		XPosition=0.355
		YPosition=0.925
		XSize=0.14
		YSize=0.05
		ID="CustomPlayerStart"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(CustomPlayerStart)

	Begin Object Class=KFGUI_RightClickMenu Name=WeapRClicker
		ID="WeapRClick"
		OnSelectedItem=WeapClickedRow
	End Object
	WeapRightClick=WeapRClicker
	
	Begin Object Class=KFGUI_RightClickMenu Name=UserRClicker
		ID="UserRClick"
		OnSelectedItem=UserClickedRow
	End Object
	UserRightClick=UserRClicker

//	Check Box
	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction0
		XPosition=0.20
		YPosition=0.25 //0.40
		ID="SR0"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction1
		XPosition=0.24
		YPosition=0.25 //0.40
		ID="SR1"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction2
		XPosition=0.20
		YPosition=0.30 //0.45
		ID="SR2"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction3
		XPosition=0.24
		YPosition=0.30 //0.45
		ID="SR3"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction4
		XPosition=0.20
		YPosition=0.35 //0.50
		ID="SR4"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction5
		XPosition=0.24
		YPosition=0.35 //0.50
		ID="SR5"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction6
		XPosition=0.20
		YPosition=0.40 //0.55
		ID="SR6"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction7
		XPosition=0.24
		YPosition=0.40 //0.55
		ID="SR7"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction8
		XPosition=0.20
		YPosition=0.45 //0.60
		ID="SR8"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction9
		XPosition=0.24
		YPosition=0.45 //0.60
		ID="SR9"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_Button Name=UpgradeSub
		XPosition=0.055
		YPosition=0.55 //0.700
		XSize=0.05
		YSize=0.05
		ID="UpgradeSub"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=UpgradeAdd
		XPosition=0.250
		YPosition=0.55 //0.700
		XSize=0.05
		YSize=0.05
		ID="UpgradeAdd"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_CheckBox Name=LevelRestriction
		XPosition=0.055
		YPosition=0.65 //0.200
		ID="LevelRestriction"
		OnCheckChange=ToggleCheckBox
	End Object

	Begin Object Class=KFGUI_CheckBox Name=AntiOvercap
		XPosition=0.055
		YPosition=0.700
		ID="AntiOvercap"
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
	Components.Add(UpgradeSub)
	Components.Add(UpgradeAdd)
	Components.Add(AntiOvercap)
}

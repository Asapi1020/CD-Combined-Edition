class xUI_AdminMenu_RPW extends KFGUI_MultiComponent
	within xUI_AdminMenu;

var KFGUI_Button CommandoB;
var KFGUI_Button SupportB;
var KFGUI_Button FieldMedicB;
var KFGUI_Button GunslingerB;
var KFGUI_Button SharpshooterB;
var KFGUI_Button SwatB;
var KFGUI_Button OtherB;

var KFGUI_Button PerkSubB;
var KFGUI_Button PerkAddB;
var KFGUI_Button UpgradeSubB;
var KFGUI_Button UpgradeAddB;

var KFGUI_ColumnList WeaponRestrictionsList;
var KFGUI_RightClickMenu WeapRClicker;
var editinline export KFGUI_RightClickMenu WeapRightClick;

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

var class<KFWeaponDefinition> SelectedWeap;
var array< class<KFWeaponDefinition> > CurWeapDef;

public function InitComponents()
{
	local int i, BanLevel;
	local string s;

	WeaponRestrictionsList = KFGUI_ColumnList(FindComponentID('WeaponRestrictionsList'));
	WeaponRestrictionsList.Columns.AddItem(newFColumnItem(WeaponHeader, 0.5f));
	WeaponRestrictionsList.Columns.AddItem(newFColumnItem(BossOnlyHeader, 0.4f));
	WeaponRestrictionsList.Columns.AddItem(newFColumnItem(LevelHeader, 0.1f));

	WeapRClicker = KFGUI_RightClickMenu(FindComponentID('WeapRClicker'));

	WeapRightClick.ItemRows.Add(7);

	BanLevel = class'CD_AuthorityHandler'.const.BAN_LEVEL;

	for(i=0; i<BanLevel+1; i++)
	{
		s = LevelSetString $ "Lv." $ string(i);
		WeapRightClick.ItemRows[i].Text = s;
	}

	WeapRightClick.ItemRows[BanLevel].Text @= BanString;
	WeapRightClick.ItemRows[BanLevel + 1].Text = ToggleBossOnlyString;
}

public function DrawComponents(float XL, float YL, float FontScalar)
{
	local int index, PerkAuthorityLevel;
	local string S;

	CommandoB = KFGUI_Button(FindComponentID('Commando'));
	CommandoB.bDisabled = GetCDPC().WeapUIInfo.Perk == class'KFPerk_Commando';
	CommandoB.OverlayTexture.Texture = class'KFPerk_Commando'.default.PerkIcon;
	CommandoB.OverlayTexture.UL = 256;
	CommandoB.OverlayTexture.VL = 256;

	SupportB = KFGUI_Button(FindComponentID('Support'));
	SupportB.bDisabled = GetCDPC().WeapUIInfo.Perk == class'KFPerk_Support';
	SupportB.OverlayTexture.Texture = class'KFPerk_Support'.default.PerkIcon;
	SupportB.OverlayTexture.UL = 256;
	SupportB.OverlayTexture.VL = 256;

	FieldMedicB = KFGUI_Button(FindComponentID('FieldMedic'));
	FieldMedicB.bDisabled = GetCDPC().WeapUIInfo.Perk == class'KFPerk_FieldMedic';
	FieldMedicB.OverlayTexture.Texture = class'KFPerk_FieldMedic'.default.PerkIcon;
	FieldMedicB.OverlayTexture.UL = 256;
	FieldMedicB.OverlayTexture.VL = 256;

	GunslingerB = KFGUI_Button(FindComponentID('Gunslinger'));
	GunslingerB.bDisabled = GetCDPC().WeapUIInfo.Perk == class'KFPerk_Gunslinger';
	GunslingerB.OverlayTexture.Texture = class'KFPerk_Gunslinger'.default.PerkIcon;
	GunslingerB.OverlayTexture.UL = 256;
	GunslingerB.OverlayTexture.VL = 256;

	SharpshooterB = KFGUI_Button(FindComponentID('Sharpshooter'));
	SharpshooterB.bDisabled = GetCDPC().WeapUIInfo.Perk == class'KFPerk_Sharpshooter';
	SharpshooterB.OverlayTexture.Texture = class'KFPerk_Sharpshooter'.default.PerkIcon;
	SharpshooterB.OverlayTexture.UL = 256;
	SharpshooterB.OverlayTexture.VL = 256;

	SwatB = KFGUI_Button(FindComponentID('Swat'));
	SwatB.bDisabled = GetCDPC().WeapUIInfo.Perk == class'KFPerk_Swat';
	SwatB.OverlayTexture.Texture = class'KFPerk_Swat'.default.PerkIcon;
	SwatB.OverlayTexture.UL = 256;
	SwatB.OverlayTexture.VL = 256;

	OtherB = KFGUI_Button(FindComponentID('Other'));
	OtherB.bDisabled = GetCDPC().WeapUIInfo.Perk == none;
	OtherB.OverlayTexture.Texture = Texture2D'UI_TraderMenu_TEX.UI_WeaponSelect_Trader_Perk';
	OtherB.OverlayTexture.UL = 256;
	OtherB.OverlayTexture.VL = 256;

	PerkSubB = KFGUI_Button(FindComponentID('PerkSub'));
	PerkSubB.ButtonText = "-";
	PerkAddB = KFGUI_Button(FindComponentID('PerkAdd'));
	PerkAddB.ButtonText = "+";

	index = GetCDPC().PerkRestrictions.Find('Perk', GetCDPC().WeapUIInfo.Perk);
	if(index == INDEX_NONE)
	{
		S = "0";
		PerkAddB.bDisabled = false;
		PerkSubB.bDisabled = true;
	}
	else
	{
		PerkAuthorityLevel = GetCDPC().PerkRestrictions[index].RequiredLevel;
		S = string(PerkAuthorityLevel);
		PerkAddB.bDisabled = PerkAuthorityLevel >= class'CD_AuthorityHandler'.const.BAN_LEVEL;
		PerkSubB.bDisabled = PerkAuthorityLevel <= 0;
	}

	DrawControllerInfo(PerkAuthorityString, S, PerkSubB, PerkAddB, YL, FontScalar, Owner.HUDOwner.ScaledBorderSize, 30,,,bVisible);

	UpgradeSubB = KFGUI_Button(FindComponentID('UpgradeSub'));
	UpgradeSubB.ButtonText = "-";
	UpgradeAddB = KFGUI_Button(FindComponentID('UpgradeAdd'));
	UpgradeAddB.ButtonText = "+";
	S = string(GetCDGRI().MaxUpgrade);
	DrawControllerInfo(MaxUpgradeString, S, UpgradeSubB, UpgradeAddB, YL, FontScalar, Owner.HUDOwner.ScaledBorderSize, 30,,,bVisible);
	UpgradeSubB.bDisabled = GetCDGRI().MaxUpgrade <= 0;

	LevelRestrictionBox = KFGUI_CheckBox(FindComponentID('LevelRestriction'));
	LevelRestrictionBox.bChecked = GetCDPC().bRequireLv25;
	LevelRestrictionBox.ToolTip=LevelRestrictionToolTip;
	DrawBoxDescription(LevelRequirementString, LevelRestrictionBox, 0.3, bVisible);

	AntiOvercapBox = KFGUI_CheckBox(FindComponentID('AntiOvercap'));
	AntiOvercapBox.bChecked = GetCDPC().bAntiOvercap;
	AntiOvercapBox.ToolTip=AntiOvercapToolTip;
	DrawBoxDescription(AntiOvercapString, AntiOvercapBox, 0.3, bVisible);

	SkillRestriction0 = KFGUI_CheckBox(FindComponentID('SR0'));
	SkillRestriction0.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 0);
	SkillRestriction0.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescriptionReverse(GetCDPC().GetLocalizedSkillName(GetCDPC().WeapUIInfo.Perk, 0), SkillRestriction0, 0.05, bVisible);

	SkillRestriction1 = KFGUI_CheckBox(FindComponentID('SR1'));
	SkillRestriction1.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 1);
	SkillRestriction1.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescription(GetCDPC().GetLocalizedSkillName(GetCDPC().WeapUIInfo.Perk, 1), SkillRestriction1, 0.425, bVisible);

	SkillRestriction2 = KFGUI_CheckBox(FindComponentID('SR2'));
	SkillRestriction2.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 2);
	SkillRestriction2.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescriptionReverse(GetCDPC().GetLocalizedSkillName(GetCDPC().WeapUIInfo.Perk, 2), SkillRestriction2, 0.05, bVisible);

	SkillRestriction3 = KFGUI_CheckBox(FindComponentID('SR3'));
	SkillRestriction3.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 3);
	SkillRestriction3.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescription(GetCDPC().GetLocalizedSkillName(GetCDPC().WeapUIInfo.Perk, 3), SkillRestriction3, 0.425, bVisible);

	SkillRestriction4 = KFGUI_CheckBox(FindComponentID('SR4'));
	SkillRestriction4.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 4);
	SkillRestriction4.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescriptionReverse(GetCDPC().GetLocalizedSkillName(GetCDPC().WeapUIInfo.Perk, 4), SkillRestriction4, 0.05, bVisible);

	SkillRestriction5 = KFGUI_CheckBox(FindComponentID('SR5'));
	SkillRestriction5.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 5);
	SkillRestriction5.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescription(GetCDPC().GetLocalizedSkillName(GetCDPC().WeapUIInfo.Perk, 5), SkillRestriction5, 0.425, bVisible);

	SkillRestriction6 = KFGUI_CheckBox(FindComponentID('SR6'));
	SkillRestriction6.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 6);
	SkillRestriction6.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescriptionReverse(GetCDPC().GetLocalizedSkillName(GetCDPC().WeapUIInfo.Perk, 6), SkillRestriction6, 0.05, bVisible);

	SkillRestriction7 = KFGUI_CheckBox(FindComponentID('SR7'));
	SkillRestriction7.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 7);
	SkillRestriction7.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescription(GetCDPC().GetLocalizedSkillName(GetCDPC().WeapUIInfo.Perk, 7), SkillRestriction7, 0.425, bVisible);

	SkillRestriction8 = KFGUI_CheckBox(FindComponentID('SR8'));
	SkillRestriction8.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 8);
	SkillRestriction8.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescriptionReverse(GetCDPC().GetLocalizedSkillName(GetCDPC().WeapUIInfo.Perk, 8), SkillRestriction8, 0.05, bVisible);

	SkillRestriction9 = KFGUI_CheckBox(FindComponentID('SR9'));
	SkillRestriction9.bChecked = GetCDPC().IsRestrictedSkill(GetCDPC().WeapUIInfo.Perk, 9);
	SkillRestriction9.ToolTip=SkillRestrictionToolTip;
	DrawBoxDescription(GetCDPC().GetLocalizedSkillName(GetCDPC().WeapUIInfo.Perk, 9), SkillRestriction9, 0.425, bVisible);
}

public function UpdateWeaponRestrictionsList()
{
	local KFGFxObject_TraderItems TraderItems;
	local int i, j, index;
	local string S;

	WeaponRestrictionsList.EmptyList();

	TraderItems = KFGameReplicationInfo(GetCDPC().WorldInfo.GRI).TraderItems;
	CurWeapDef.Remove(0, CurWeapDef.length);

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

		WeaponRestrictionsList.AddLine(S);
	}
}

private function ButtonClicked(KFGUI_Button Sender)
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

private function SelectedListRow(KFGUI_ListItem Item, int Row, bool bRight, bool bDblClick)
{
	if(Row < 0)
	{
		return;
	}

	SelectedWeap = CurWeapDef[Row];
	WeapRightClick.OpenMenu(self);
}

private function WeapClickedRow(int RowNum)
{
	local int index, AuthLv, BanLevel;
	local bool bBossOnly;
	local CD_WeaponInfo CDWI;

	index = GetCDPC().WeaponRestrictions.Find('WeapDef', SelectedWeap);
	BanLevel = class'CD_AuthorityHandler'.const.BAN_LEVEL;

	if(RowNum < BanLevel + 1)
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
	else if(RowNum == BanLevel + 1)
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

private function ToggleCheckBox(KFGUI_CheckBox Sender)
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
	ID="AdminMenu_RPW"

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
	Components.Add(Commando)

	Begin Object Class=KFGUI_Button Name=Support
		XPosition=0.1835
		YPosition=0.05
		XSize=0.1185
		YSize=0.05
		ID="Support"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
		ButtonText=""
	End Object
	Components.Add(Support)

	Begin Object Class=KFGUI_Button Name=FieldMedic
		XPosition=0.3120
		YPosition=0.05
		XSize=0.1185
		YSize=0.05
		ID="FieldMedic"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
		ButtonText=""
	End Object
	Components.Add(FieldMedic)

	Begin Object Class=KFGUI_Button Name=Gunslinger
		XPosition=0.4405
		YPosition=0.05
		XSize=0.1185
		YSize=0.05
		ID="Gunslinger"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
		ButtonText=""
	End Object
	Components.Add(Gunslinger)

	Begin Object Class=KFGUI_Button Name=Sharpshooter
		XPosition=0.5690
		YPosition=0.05
		XSize=0.1185
		YSize=0.05
		ID="Sharpshooter"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
		ButtonText=""
	End Object
	Components.Add(Sharpshooter)

	Begin Object Class=KFGUI_Button Name=Swat
		XPosition=0.6975
		YPosition=0.05
		XSize=0.1185
		YSize=0.05
		ID="Swat"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
		ButtonText=""
	End Object
	Components.Add(Swat)

	Begin Object Class=KFGUI_Button Name=Other
		XPosition=0.8260
		YPosition=0.05
		XSize=0.1185
		YSize=0.05
		ID="Other"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
		ButtonText=""
	End Object
	Components.Add(Other)

	Begin Object Class=KFGUI_Button Name=PerkSub
		XPosition=0.055
		YPosition=0.15
		XSize=0.05
		YSize=0.05
		ID="PerkSub"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(PerkSub)

	Begin Object Class=KFGUI_Button Name=PerkAdd
		XPosition=0.250
		YPosition=0.15
		XSize=0.05
		YSize=0.05
		ID="PerkAdd"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(PerkAdd)

	Begin Object Class=KFGUI_ColumnList Name=WeaponRestrictionsList
		XPosition=0.45
		YPosition=0.125
		XSize=0.52
		YSize=0.775
		ID="WeaponRestrictionsList"
		OnSelectedRow=SelectedListRow
		bCanSortColumn=false
	End Object
	Components.Add(WeaponRestrictionsList)

	Begin Object Class=KFGUI_RightClickMenu Name=WeapRClicker
		ID="WeapRClick"
		OnSelectedItem=WeapClickedRow
	End Object
	WeapRightClick=WeapRClicker

	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction0
		XPosition=0.20
		YPosition=0.25
		ID="SR0"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(SkillRestriction0)

	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction1
		XPosition=0.24
		YPosition=0.25
		ID="SR1"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(SkillRestriction1)

	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction2
		XPosition=0.20
		YPosition=0.30
		ID="SR2"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(SkillRestriction2)

	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction3
		XPosition=0.24
		YPosition=0.30
		ID="SR3"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(SkillRestriction3)

	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction4
		XPosition=0.20
		YPosition=0.35
		ID="SR4"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(SkillRestriction4)

	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction5
		XPosition=0.24
		YPosition=0.35
		ID="SR5"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(SkillRestriction5)

	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction6
		XPosition=0.20
		YPosition=0.40
		ID="SR6"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(SkillRestriction6)

	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction7
		XPosition=0.24
		YPosition=0.40
		ID="SR7"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(SkillRestriction7)

	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction8
		XPosition=0.20
		YPosition=0.45
		ID="SR8"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(SkillRestriction8)

	Begin Object Class=KFGUI_CheckBox Name=SkillRestriction9
		XPosition=0.24
		YPosition=0.45
		ID="SR9"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(SkillRestriction9)

	Begin Object Class=KFGUI_Button Name=UpgradeSub
		XPosition=0.055
		YPosition=0.55
		XSize=0.05
		YSize=0.05
		ID="UpgradeSub"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(UpgradeSub)

	Begin Object Class=KFGUI_Button Name=UpgradeAdd
		XPosition=0.250
		YPosition=0.55
		XSize=0.05
		YSize=0.05
		ID="UpgradeAdd"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(UpgradeAdd)

	Begin Object Class=KFGUI_CheckBox Name=LevelRestriction
		XPosition=0.055
		YPosition=0.65
		ID="LevelRestriction"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(LevelRestriction)

	Begin Object Class=KFGUI_CheckBox Name=AntiOvercap
		XPosition=0.055
		YPosition=0.700
		ID="AntiOvercap"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(AntiOvercap)
}

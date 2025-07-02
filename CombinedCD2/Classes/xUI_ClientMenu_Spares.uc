class xUI_ClientMenu_Spares extends KFGUI_MultiComponent
	within xUI_ClientMenu
	DependsOn(CD_Domain);

`include(CD_Log.uci)

struct SpareWeaponsKind
{
	var class<KFWeapon> KFWClass;
	var array<CDPickupInfo> SparePickups;
};

var KFGUI_CheckBox DisablePickUpOthersBox;
var KFGUI_CheckBox DropLockedBox;
var KFGUI_CheckBox DisablePickUpLowAmmoBox;

var KFGUI_ColumnList SpareWeaponsKindList;
var KFGUI_RightClickMenu SpareWeaponsKindRClicker;
var editinline export KFGUI_RightClickMenu SpareWeaponsKindRightClick;

var KFGUI_ColumnList SparesList;
var KFGUI_RightClickMenu SparesRClicker;
var editinline export KFGUI_RightClickMenu SparesRightClick;

var protected string SelectedWeaponName;
var protected int SelectedPickupIndex;

var localized string WeaponNameHeader;
var localized string PossessionsNumHeader;
var localized string SellAll;
var localized string AllTeleportHere;
var localized string MagazineAmmoCountString;
var localized string SpareAmmoCountString;
var localized string TeleportHere;

function InitMenu()
{
	Super.InitMenu();

	SpareWeaponsKindList = KFGUI_ColumnList(FindComponentID('SpareWeaponsKindList'));
	SpareWeaponsKindList.Columns.AddItem(newFColumnItem(WeaponNameHeader, 0.8f));
	SpareWeaponsKindList.Columns.AddItem(newFColumnItem(PossessionsNumHeader, 0.2f));
	
	SpareWeaponsKindRClicker = KFGUI_RightClickMenu(FindComponentID('SpareWeaponsKindRClicker'));

	SpareWeaponsKindRightClick.ItemRows.Add(2);
	SpareWeaponsKindRightClick.ItemRows[0].Text = SellAll;
	SpareWeaponsKindRightClick.ItemRows[1].Text = AllTeleportHere;

	SparesList = KFGUI_ColumnList(FindComponentID('SparesList'));
	SparesList.Columns.AddItem(newFColumnItem("ID", 0.2f));
	SparesList.Columns.AddItem(newFColumnItem(MagazineAmmoCountString, 0.4f));
	SparesList.Columns.AddItem(newFColumnItem(SpareAmmoCountString, 0.4f));

	SparesRClicker = KFGUI_RightClickMenu(FindComponentID('SparesRClicker'));

	SparesRightClick.ItemRows.Add(2);
	SparesRightClick.ItemRows[0].Text = class'KFGFxTraderContainer_ItemDetails'.default.SellString;
	SparesRightClick.ItemRows[1].Text = TeleportHere;
}

function DrawMenu()
{
	local CD_PlayerController CDPC;
	local float YL, XL, FontScalar;

	super.DrawMenu();

	Canvas.Font = Owner.CurrentStyle.PickFont(FontScalar);
	Canvas.TextSize("ABC", XL, YL, FontScalar, FontScalar);

	CDPC = GetCDPC();

	DisablePickUpOthersBox = KFGUI_CheckBox(FindComponentID('DisablePickUpOthers'));
	DisablePickUpOthersBox.bChecked = !CDPC.DisablePickUpOthers;
	DisablePickUpOthersBox.ToolTip=DisablePickupOthersToolTip;
	DrawBoxDescription(PickupOthersString, DisablePickUpOthersBox, 0.4);

	DropLockedBox = KFGUI_CheckBox(FindComponentID('DropLocked'));
	DropLockedBox.bChecked = CDPC.DropLocked;
	DropLockedBox.ToolTip=DropLockedToolTip;
	DrawBoxDescription(DropLockedString, DropLockedBox, 0.4);

	DisablePickUpLowAmmoBox = KFGUI_CheckBox(FindComponentID('DisablePickUpLowAmmo'));
	DisablePickUpLowAmmoBox.bChecked = !CDPC.DisablePickUpLowAmmo;
	DisablePickUpLowAmmoBox.ToolTip=PickUpLowAmmoToolTip;
	DrawBoxDescription(PickupLowAmmoString, DisablePickUpLowAmmoBox, 0.4);

	if (GetCDPC().GetRPCHandler().SpareWeaponsDownloadStage == DS_None)
	{
		GetCDPC().GetRPCHandler().SpareWeaponsDownloadStage = DS_Starting;
		GetCDPC().RequestPickupInfo();
	}
	else if (GetCDPC().GetRPCHandler().SpareWeaponsDownloadStage == DS_Downloaded)
	{
		GetCDPC().GetRPCHandler().SpareWeaponsDownloadStage = DS_Completed;
		UpdateSpareWeaponsKindList();
	}

	DrawSelectedPickupInfo();
}

protected function DrawSelectedPickupInfo()
{
	local CDPickupInfo Pickup;
	local Texture2D WeaponIcon;
	local float X, Y, IconSize;

	foreach GetCDPC().GetRPCHandler().SparePickups(Pickup)
	{
		if (Pickup.ID == SelectedPickupIndex)
		{
			IconSize = SparesList.XSize * 0.5;
			X = SparesList.XPosition + SparesList.XSize * 0.5 - IconSize * 0.5;
			Y = 0.05;

			WeaponIcon = Texture2D(class'CD_Object'.static.SafeLoadObject(Pickup.IconPath, class'Texture2D'));

			Canvas.SetDrawColor(192, 192, 192, 192);
			DrawTexture(WeaponIcon, X, Y, IconSize);
		}
	}
}

function ToggleCheckBox(KFGUI_CheckBox Sender)
{
	local CD_PlayerController CDPC;

	CDPC = GetCDPC();

	switch(Sender.ID)
	{
		case 'DisablePickUpOthers':
			CDPC.DisablePickUpOthers = !Sender.bChecked;
			CDPC.SendPickupInfo();
			break;
		case 'DropLocked':
			CDPC.DropLocked = Sender.bChecked;
			CDPC.SendPickupInfo();
			break;
		case 'DisablePickUpLowAmmo':
			CDPC.DisablePickUpLowAmmo = !Sender.bChecked;
			CDPC.SendPickupInfo();
			break;
		default:
			`cdlog("invalid checkbox id: " $ Sender.ID);
			break;
	}
}

protected function UpdateSpareWeaponsKindList()
{
	local array<SpareWeaponsKind> SpareWeaponsKinds;
	local SpareWeaponsKind Kind;
	local string WeaponName;
	local int PossessionNum;

	SpareWeaponsKindList.EmptyList();

	SpareWeaponsKinds = toSpareWeaponsKinds(GetCDPC().GetRPCHandler().SparePickups);

	foreach SpareWeaponsKinds(Kind)
	{
		WeaponName = Kind.KFWClass.default.ItemName;
		PossessionNum = Kind.SparePickups.length;
		SpareWeaponsKindList.AddLine(WeaponName $ "\n" $ string(PossessionNum));
	}

	UpdateSparesList();
}

protected function array<SpareWeaponsKind> toSpareWeaponsKinds(array<CDPickupInfo> SpareWeapons)
{
	local CDPickupInfo SparePickup;
	local int index;
	local SpareWeaponsKind Kind;
	local array<SpareWeaponsKind> SpareWeaponsKinds;

	foreach GetCDPC().GetRPCHandler().SparePickups(SparePickup)
	{		
		if (SparePickup.KFWClass == None)
		{
			continue;
		}

		index = SpareWeaponsKinds.Find('KFWClass', SparePickup.KFWClass);

		if (index == INDEX_NONE)
		{
			Kind.KFWClass = SparePickup.KFWClass;
			Kind.SparePickups.length = 0;
			Kind.SparePickups.AddItem(SparePickup);
			SpareWeaponsKinds.AddItem(Kind);
		}
		else
		{
			SpareWeaponsKinds[index].SparePickups.AddItem(SparePickup);
		}
	}

	return SpareWeaponsKinds;
}

protected function UpdateSparesList()
{
	local CDPickupInfo SparePickup;

	SparesList.EmptyList();

	foreach GetCDPC().GetRPCHandler().SparePickups(SparePickup)
	{
		if (SparePickup.KFWClass.default.ItemName != SelectedWeaponName)
		{
			continue;
		}

		SparesList.AddLine(string(SparePickup.ID) $ "\n" $ SparePickup.MagazineAmmoText $ "\n" $ SparePickup.SpareAmmoText);
	}
}

protected function SelectedSpareWeaponsKindRow(KFGUI_ListItem Item, int Row, bool bRight, bool bDblClick)
{
	local string ExSelectedWeaponName;

	if (Row < 0)
	{
		return;
	}

	ExSelectedWeaponName = SelectedWeaponName;
	SelectedWeaponName = SpareWeaponsKindList.GetFromIndex(Row).GetDisplayStr(0);
	UpdateSparesList();

	if (ExSelectedWeaponName != SelectedWeaponName)
	{
		SelectedPickupIndex = int(SparesList.GetFromIndex(0).GetDisplayStr(0));
	}

	if (bRight)
	{
		SpareWeaponsKindRightClick.OpenMenu(Self);
	}
}

protected function SpareWeaponsKindClickedItem(int Row)
{
	switch(Row)
	{
		case 0:
			GetCDPC().SellAllSpareWeapons(SelectedWeaponName);
			break;
		case 1:
			GetCDPC().RequestTeleportAllSpareWeapons(SelectedWeaponName);
			break;
		default:
			`cdlog("invalid spare weapons kind row: " $ Row);
			break;
	}
}

protected function SelectedSparesRow(KFGUI_ListItem Item, int Row, bool bRight, bool bDblClick)
{
	if (Row < 0)
	{
		return;
	}

	SelectedPickupIndex = int(SparesList.GetFromIndex(Row).GetDisplayStr(0));

	if (bRight)
	{
		SparesRightClick.OpenMenu(Self);
	}
}

protected function SparesClickedItem(int Row)
{
	if (Row < 0)
	{
		return;
	}

	switch(Row)
	{
		case 0:
			GetCDPC().SellSpareWeapon(SelectedPickupIndex);
			break;
		case 1:
			GetCDPC().RequestTeleportSpareWeapon(SelectedPickupIndex);
			break;
		default:
			`cdlog("invalid spare row: " $ Row);
			break;
	}
}

defaultproperties
{
	ID="ClientMenu_Spares"

	Begin Object Class=KFGUI_CheckBox Name=DisablePickUpOthers
		XPosition=0.05
		YPosition=0.05
		ID="DisablePickUpOthers"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(DisablePickUpOthers)

	Begin Object Class=KFGUI_CheckBox Name=DropLocked
		XPosition=0.05
		YPosition=0.10
		ID="DropLocked"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(DropLocked)

	Begin Object Class=KFGUI_CheckBox Name=DisablePickUpLowAmmo
		XPosition=0.05
		YPosition=0.15
		ID="DisablePickUpLowAmmo"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(DisablePickUpLowAmmo)

	Begin Object Class=KFGUI_ColumnList Name=SpareWeaponsKindList
		XPosition=0.05
		YPosition=0.25
		XSize=0.40
		YSize=0.65
		ID="SpareWeaponsKindList"
		OnSelectedRow=SelectedSpareWeaponsKindRow
		bCanSortColumn=true
		bOpaque=true
	End Object
	Components.Add(SpareWeaponsKindList)

	Begin Object Class=KFGUI_RightClickMenu Name=SpareWeaponsKindRClicker
		ID="SpareWeaponsKindRClick"
		OnSelectedItem=SpareWeaponsKindClickedItem
	End Object
	SpareWeaponsKindRightClick=SpareWeaponsKindRClicker

	Begin Object Class=KFGUI_ColumnList Name=SparesList
		XPosition=0.55
		YPosition=0.40
		XSize=0.40
		YSize=0.50
		ID="SparesList"
		OnSelectedRow=SelectedSparesRow
		bCanSortColumn=true
		bOpaque=true
	End Object
	Components.Add(SparesList)

	Begin Object Class=KFGUI_RightClickMenu Name=SparesRClicker
		ID="SparesRClick"
		OnSelectedItem=SparesClickedItem
	End Object
	SparesRightClick=SparesRClicker
}

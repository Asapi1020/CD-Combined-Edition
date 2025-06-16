class xUI_AutoTrader extends xUI_MenuBase;

var KFGUI_Button CommandoB;
var KFGUI_Button SupportB;
var KFGUI_Button FieldMedicB;
var KFGUI_Button GunslingerB;
var KFGUI_Button SharpshooterB;
var KFGUI_Button SwatB;
var KFGUI_Button CloseB;

var KFGUI_ColumnList TraderList;
var KFGUI_ColumnList AutoBuyList;
var KFGUI_RightClickMenu AutoBuyRClicker;
var editinline export KFGUI_RightClickMenu AutoBuyRightClick;

var int CurIndex;
var bool bListUpdate;
var array< class<KFWeaponDefinition> > CurWeapDef;

//var localized string Title;
var localized string TraderHeader;
var localized string LoadoutHeader;
var localized string MoveUpString;
var localized string MoveDownString;
var localized string RemoveString;

function SetWindowDrag(bool bDrag)
{
	bDragWindow = false;
}

function DrawMenu()
{
//	Setup
	local float XL, YL, FontScalar;

	Super.DrawMenu();

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

//	List
	if(!bListUpdate)
	{
		UpdateList();
		bListUpdate = true;
	}

	CloseB = KFGUI_Button(FindComponentID('Close'));
	CloseB.ButtonText = CloseButtonText;
}

function InitMenu()
{
	super.InitMenu();

	TraderList = KFGUI_ColumnList(FindComponentID('TraderList'));
	TraderList.Columns.AddItem(newFColumnItem(TraderHeader, 1.f));
	AutoBuyList = KFGUI_ColumnList(FindComponentID('AutoBuyList'));
	AutoBuyList.Columns.AddItem(newFColumnItem(LoadoutHeader, 1.f));
	AutoBuyRClicker = KFGUI_RightClickMenu(FindComponentID('AutoBuyRClicker'));

	AutoBuyRightClick.ItemRows.Add(3);
	AutoBuyRightClick.ItemRows[0].Text = MoveUpString;
	AutoBuyRightClick.ItemRows[1].Text = MoveDownString;
	AutoBuyRightClick.ItemRows[2].Text = RemoveString;
}

final function UpdateList()
{
	local KFGFxObject_TraderItems TraderItems;
	local int i, LoadoutIndex;
	local string S;

	TraderList.EmptyList();
	TraderItems = KFGameReplicationInfo(GetCDPC().WorldInfo.GRI).TraderItems;
	CurWeapDef.Remove(0, CurWeapDef.length);

	for(i=0; i<TraderItems.SaleItems.length; i++)
	{
		if (TraderItems.SaleItems[i].AssociatedPerkClasses.Find(GetCDPC().WeapUIInfo.Perk) == INDEX_NONE)
			continue;

		S = class'CD_Object'.static.GetWeapClass(TraderItems.SaleItems[i].WeaponDef).default.ItemName;
		TraderList.AddLine(S);
		CurWeapDef.AddItem(TraderItems.SaleItems[i].WeaponDef);
	}

	AutoBuyList.EmptyList();
	LoadoutIndex = GetCDPC().LoadoutList.Find('Perk', GetCDPC().WeapUIInfo.Perk);
	if(LoadoutIndex == INDEX_NONE)
		return;

	for(i=0; i<GetCDPC().LoadoutList[LoadoutIndex].WeapDef.length; i++)
	{
		S = class'CD_Object'.static.GetWeapClass(GetCDPC().LoadoutList[LoadoutIndex].WeapDef[i]).default.ItemName;
		AutoBuyList.AddLine(S);
	}
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
		case 'Close':
			DoClose();
			break;
	}
}

function SelectedTraderList(KFGUI_ListItem Item, int Row, bool bRight, bool bDblClick)
{
	if(bDblClick && Row>=0)
	{
		GetCDPC().RegisterLoadout(CurWeapDef[Row]);
		bListUpdate = false;
	}
}

function SelectedAutoBuyList(KFGUI_ListItem Item, int Row, bool bRight, bool bDblClick)
{
	CurIndex = Row;
	if(Row>=0)
		AutoBuyRightClick.OpenMenu(self);
}

function AutoBuyClickedRow(int RowNum)
{
	GetCDPC().ModifyLoadout(RowNum, CurIndex);
	bListUpdate = false;
}

defaultproperties
{
	ID="AutoTraderMenu"
	Version="1.0.1"

//	Perk
	Begin Object Class=KFGUI_Button Name=Commando
		XPosition=0.055
		YPosition=0.055
		XSize=0.14
		YSize=0.05
		ID="Commando"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
		ButtonText=""
	End Object

	Begin Object Class=KFGUI_Button Name=Support
		XPosition=0.205
		YPosition=0.055
		XSize=0.14
		YSize=0.05
		ID="Support"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
		ButtonText=""
	End Object

	Begin Object Class=KFGUI_Button Name=FieldMedic
		XPosition=0.355
		YPosition=0.055
		XSize=0.14
		YSize=0.05
		ID="FieldMedic"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
		ButtonText=""
	End Object

	Begin Object Class=KFGUI_Button Name=Gunslinger
		XPosition=0.505
		YPosition=0.055
		XSize=0.14
		YSize=0.05
		ID="Gunslinger"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
		ButtonText=""
	End Object

	Begin Object Class=KFGUI_Button Name=Sharpshooter
		XPosition=0.655
		YPosition=0.055
		XSize=0.14
		YSize=0.05
		ID="Sharpshooter"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
		ButtonText=""
	End Object

	Begin Object Class=KFGUI_Button Name=Swat
		XPosition=0.805
		YPosition=0.055
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

	Components.Add(Commando)
	Components.Add(Support)
	Components.Add(FieldMedic)
	Components.Add(Gunslinger)
	Components.Add(Sharpshooter)
	Components.Add(Swat)
	Components.Add(Close)

//	List
	Begin Object Class=KFGUI_ColumnList Name=TraderList
		XPosition=0.05
		YPosition=0.15
		XSize=0.4
		YSize=0.75
		ID="TraderList"
		OnSelectedRow=SelectedTraderList
		bCanSortColumn=false
	End Object

	Begin Object Class=KFGUI_ColumnList Name=AutoBuyList
		XPosition=0.55
		YPosition=0.15
		XSize=0.4
		YSize=0.75
		ID="AutoBuyList"
		OnSelectedRow=SelectedAutoBuyList
		bCanSortColumn=false
	End Object

	Begin Object Class=KFGUI_RightClickMenu Name=AutoBuyRClicker
		ID="AutoBuyRClick"
		OnSelectedItem=AutoBuyClickedRow
	End Object

	Components.Add(TraderList)
	Components.Add(AutoBuyList)
	AutoBuyRightClick=AutoBuyRClicker
}

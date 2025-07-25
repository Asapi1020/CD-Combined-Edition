class UTM_UI_WeaponSkin extends xUI_MenuBase;

var KFGUI_Button CommandoB;
var KFGUI_Button SupportB;
var KFGUI_Button FieldMedicB;
var KFGUI_Button GunslingerB;
var KFGUI_Button SharpshooterB;
var KFGUI_Button SwatB;
var KFGUI_Button BerserkerB;
var KFGUI_Button DemolitionistB;
var KFGUI_Button FirebugB;
var KFGUI_Button SurvivalistB;
var KFGUI_Button UTMB;

var KFGUI_ColumnList WeaponList;
var KFGUI_ColumnList SkinList;

var KFGUI_CheckBox OverrideSkinBox;

var bool bListUpdate;
var bool bPageUpdate;
var array< class<KFWeaponDefinition> > CurWeapDef;
var array<Texture> CurSkinTex;
var Texture SelectedTex;
var array<int> CurSkinId;

var localized string PageBackString;
var localized string SkinHeader;

function SetWindowDrag(bool bDrag)
{
	bDragWindow = false;
}

function UTM_PlayerController GetUTMPC()
{
	return UTM_PlayerController(GetPlayer());
}

function DrawMenu()
{
//	Setup
	local float XL, YL, FontScalar;

	Super.DrawMenu();

	WindowTitle = Title @ "v1.1";
	Canvas.Font = Owner.CurrentStyle.PickFont(FontScalar);
	Canvas.TextSize("ABC", XL, YL, FontScalar, FontScalar);

//	Perk Option Button

	CommandoB = KFGUI_Button(FindComponentID('Commando'));
	CommandoB.bDisabled = (GetUTMPC().WeapUIInfo.Perk == class'KFPerk_Commando') ? true : false;
	CommandoB.OverlayTexture.Texture = class'KFPerk_Commando'.default.PerkIcon;
	CommandoB.OverlayTexture.UL = 256;
	CommandoB.OverlayTexture.VL = 256;

	SupportB = KFGUI_Button(FindComponentID('Support'));
	SupportB.bDisabled = (GetUTMPC().WeapUIInfo.Perk == class'KFPerk_Support') ? true : false;
	SupportB.OverlayTexture.Texture = class'KFPerk_Support'.default.PerkIcon;
	SupportB.OverlayTexture.UL = 256;
	SupportB.OverlayTexture.VL = 256;

	FieldMedicB = KFGUI_Button(FindComponentID('FieldMedic'));
	FieldMedicB.bDisabled = (GetUTMPC().WeapUIInfo.Perk == class'KFPerk_FieldMedic') ? true : false;
	FieldMedicB.OverlayTexture.Texture = class'KFPerk_FieldMedic'.default.PerkIcon;
	FieldMedicB.OverlayTexture.UL = 256;
	FieldMedicB.OverlayTexture.VL = 256;

	GunslingerB = KFGUI_Button(FindComponentID('Gunslinger'));
	GunslingerB.bDisabled = (GetUTMPC().WeapUIInfo.Perk == class'KFPerk_Gunslinger') ? true : false;
	GunslingerB.OverlayTexture.Texture = class'KFPerk_Gunslinger'.default.PerkIcon;
	GunslingerB.OverlayTexture.UL = 256;
	GunslingerB.OverlayTexture.VL = 256;

	SharpshooterB = KFGUI_Button(FindComponentID('Sharpshooter'));
	SharpshooterB.bDisabled = (GetUTMPC().WeapUIInfo.Perk == class'KFPerk_Sharpshooter') ? true : false;
	SharpshooterB.OverlayTexture.Texture = class'KFPerk_Sharpshooter'.default.PerkIcon;
	SharpshooterB.OverlayTexture.UL = 256;
	SharpshooterB.OverlayTexture.VL = 256;

	SwatB = KFGUI_Button(FindComponentID('Swat'));
	SwatB.bDisabled = (GetUTMPC().WeapUIInfo.Perk == class'KFPerk_Swat') ? true : false;
	SwatB.OverlayTexture.Texture = class'KFPerk_Swat'.default.PerkIcon;
	SwatB.OverlayTexture.UL = 256;
	SwatB.OverlayTexture.VL = 256;

	BerserkerB = KFGUI_Button(FindComponentID('Berserker'));
	BerserkerB.bDisabled = (GetUTMPC().WeapUIInfo.Perk == class'KFPerk_Berserker') ? true : false;
	BerserkerB.OverlayTexture.Texture = class'KFPerk_Berserker'.default.PerkIcon;
	BerserkerB.OverlayTexture.UL = 256;
	BerserkerB.OverlayTexture.VL = 256;

	DemolitionistB = KFGUI_Button(FindComponentID('Demolitionist'));
	DemolitionistB.bDisabled = (GetUTMPC().WeapUIInfo.Perk == class'KFPerk_Demolitionist') ? true : false;
	DemolitionistB.OverlayTexture.Texture = class'KFPerk_Demolitionist'.default.PerkIcon;
	DemolitionistB.OverlayTexture.UL = 256;
	DemolitionistB.OverlayTexture.VL = 256;

	FirebugB = KFGUI_Button(FindComponentID('Firebug'));
	FirebugB.bDisabled = (GetUTMPC().WeapUIInfo.Perk == class'KFPerk_Firebug') ? true : false;
	FirebugB.OverlayTexture.Texture = class'KFPerk_Firebug'.default.PerkIcon;
	FirebugB.OverlayTexture.UL = 256;
	FirebugB.OverlayTexture.VL = 256;

	SurvivalistB = KFGUI_Button(FindComponentID('Survivalist'));
	SurvivalistB.bDisabled = (GetUTMPC().WeapUIInfo.Perk == class'KFPerk_Survivalist') ? true : false;
	SurvivalistB.OverlayTexture.Texture = class'KFPerk_Survivalist'.default.PerkIcon;
	SurvivalistB.OverlayTexture.UL = 256;
	SurvivalistB.OverlayTexture.VL = 256;

//	Weapon Option List
	if(!bListUpdate)
	{
		UpdateList();
		bListUpdate = true;
	}
	
//	Skin Option Buttons;
	if(!bPageUpdate)
	{
		bPageUpdate = true;
		UpdatePage();
	}

	UTMB = KFGUI_Button(FindComponentID('UTMB'));
	UTMB.ButtonText = "<" @ PageBackString;
}

function InitMenu()
{
	super.InitMenu();

	WeaponList = KFGUI_ColumnList(FindComponentID('Weap'));
	WeaponList.Columns.AddItem(newFColumnItem(class'CombinedCD2.xUI_AdminMenu'.default.WeaponHeader, 1.f));
	SkinList = KFGUI_ColumnList(FindComponentID('Skin'));
	SkinList.Columns.AddItem(newFColumnItem(SkinHeader, 1.f));
}

final function UpdateList()
{
	local KFGFxObject_TraderItems TraderItems;
//	local CD_GFxTraderContainer_Store Store;
	local int i;
	local string S;

	WeaponList.EmptyList();
	TraderItems = KFGameReplicationInfo(GetUTMPC().WorldInfo.GRI).TraderItems;
//	Store = CD_GFxTraderContainer_Store(DynamicLoadObject("CombinedCD2.CD_GFxTraderContainer_Store", class'CD_GFxTraderContainer_Store'));
	CurWeapDef.Remove(0, CurWeapDef.length);

	for(i=0; i<TraderItems.SaleItems.length; i++)
	{
		if (TraderItems.SaleItems[i].AssociatedPerkClasses.Find(GetUTMPC().WeapUIInfo.Perk) == INDEX_NONE ||
			TraderItems.SaleItems[i].ClassName == TraderItems.SaleItems[i].DualClassName) /*Store.IsItemFiltered(TraderItems.SaleItems[i])*/
			continue;

		S = class'CD_Object'.static.GetWeapClass(TraderItems.SaleItems[i].WeaponDef).default.ItemName;
		WeaponList.AddLine(S);
		CurWeapDef.AddItem(TraderItems.SaleItems[i].WeaponDef);
	}

	switch(GetUTMPC().WeapUIInfo.Perk)
	{
		case class'KFPerk_Berserker':
			WeaponList.AddLine(class'KFGameContent.KFWeap_Knife_Berserker'.default.ItemName);
			CurWeapDef.AddItem(class'KFGame.KFWeapDef_Knife_Berserker');
			break;
		case class'KFPerk_Commando':
			WeaponList.AddLine(class'KFGameContent.KFWeap_Knife_Commando'.default.ItemName);
			CurWeapDef.AddItem(class'KFGame.KFWeapDef_Knife_Commando');
			break;
		case class'KFPerk_Support':
			WeaponList.AddLine(class'KFGameContent.KFWeap_Knife_Support'.default.ItemName);
			CurWeapDef.AddItem(class'KFGame.KFWeapDef_Knife_Support');
			break;
		case class'KFPerk_FieldMedic':
			WeaponList.AddLine(class'KFGameContent.KFWeap_Knife_FieldMedic'.default.ItemName);
			CurWeapDef.AddItem(class'KFGame.KFWeapDef_Knife_Medic');
			break;
		case class'KFPerk_Demolitionist':
			WeaponList.AddLine(class'KFGameContent.KFWeap_Knife_Demolitionist'.default.ItemName);
			CurWeapDef.AddItem(class'KFGame.KFWeapDef_Knife_Demo');
			break;
		case class'KFPerk_Firebug':
			WeaponList.AddLine(class'KFGameContent.KFWeap_Knife_Firebug'.default.ItemName);
			CurWeapDef.AddItem(class'KFGame.KFWeapDef_Knife_Firebug');
			break;
		case class'KFPerk_Gunslinger':
			WeaponList.AddLine(class'KFGameContent.KFWeap_Knife_Gunslinger'.default.ItemName);
			CurWeapDef.AddItem(class'KFGame.KFWeapDef_Knife_Gunslinger');
			break;
		case class'KFPerk_Sharpshooter':
			WeaponList.AddLine(class'KFGameContent.KFWeap_Knife_Sharpshooter'.default.ItemName);
			CurWeapDef.AddItem(class'KFGame.KFWeapDef_Knife_Sharpshooter');
			break;
		case class'KFPerk_SWAT':
			WeaponList.AddLine(class'KFGameContent.KFWeap_Knife_SWAT'.default.ItemName);
			CurWeapDef.AddItem(class'KFGame.KFWeapDef_Knife_SWAT');
			break;
		case class'KFPerk_Survivalist':
			WeaponList.AddLine(class'KFGameContent.KFWeap_Knife_Survivalist'.default.ItemName);
			CurWeapDef.AddItem(class'KFGame.KFWeapDef_Knife_Survivalist');
			WeaponList.AddLine(class'KFGameContent.KFWeap_Pistol_9mm'.default.ItemName);
			CurWeapDef.AddItem(class'KFGame.KFWeapDef_9mm');
			WeaponList.AddLine(class'KFGameContent.KFWeap_HRG_93R'.default.ItemName);
			CurWeapDef.AddItem(class'KFGame.KFWeapDef_HRG_93R');
			WeaponList.AddLine(class'KFGameContent.KFWeap_Healer_Syringe'.default.ItemName);
			CurWeapDef.AddItem(class'KFGame.KFWeapDef_Healer');
			WeaponList.AddLine(class'KFGameContent.KFWeap_Welder'.default.ItemName);
			CurWeapDef.AddItem(class'KFGame.KFWeapDef_Welder');
			break;
	}
}

final function UpdatePage()
{
	local int i, SkinID, ItemIndex;
	local string IconPath;
	local class<KFWeaponDefinition> TargetWeapDef;
	local array<ItemProperties> Properties;

	SkinList.EmptyList();
	CurSkinTex.Remove(0, CurSkinTex.length);
	CurSkinId.Remove(0, CurSkinId.length);
	TargetWeapDef = GetUTMPC().WeapUIInfo.WeapDef;
	Properties = GetUTMPC().OnlineSub.ItemPropertiesList;

	for(i=0; i<class'KFWeaponSkinList'.default.Skins.length; i++)
	{
		if(class'KFWeaponSkinList'.default.Skins[i].WeaponDef == TargetWeapDef)
		{				
			SkinID = class'KFWeaponSkinList'.default.Skins[i].Id;
			ItemIndex = Properties.Find('Definition', SkinID);

			if(ItemIndex != INDEX_NONE)
			{
				IconPath = Properties[ItemIndex].IconURL;
				SkinList.AddLine(Properties[ItemIndex].Name);
				CurSkinTex.AddItem( Texture(class'CD_Object'.static.SafeLoadObject(IconPath, class'Texture')) );
				CurSkinId.AddItem(SkinID);
			}
		}
	}
}

function ButtonClicked(KFGUI_Button Sender)
{
	switch(Sender.ID)
	{
		case 'Commando':
			GetUTMPC().WeapUIInfo.Perk = class'KFPerk_Commando';
			bListUpdate = false;
			break;
		case 'Support':
			GetUTMPC().WeapUIInfo.Perk = class'KFPerk_Support';
			bListUpdate = false;
			break;
		case 'FieldMedic':
			GetUTMPC().WeapUIInfo.Perk = class'KFPerk_FieldMedic';
			bListUpdate = false;
			break;
		case 'Gunslinger':
			GetUTMPC().WeapUIInfo.Perk = class'KFPerk_Gunslinger';
			bListUpdate = false;
			break;
		case 'Sharpshooter':
			GetUTMPC().WeapUIInfo.Perk = class'KFPerk_Sharpshooter';
			bListUpdate = false;
			break;
		case 'Swat':
			GetUTMPC().WeapUIInfo.Perk = class'KFPerk_Swat';
			bListUpdate = false;
			break;
		case 'Berserker':
			GetUTMPC().WeapUIInfo.Perk = class'KFPerk_Berserker';
			bListUpdate = false;
			break;
		case 'Demolitionist':
			GetUTMPC().WeapUIInfo.Perk = class'KFPerk_Demolitionist';
			bListUpdate = false;
			break;
		case 'Firebug':
			GetUTMPC().WeapUIInfo.Perk = class'KFPerk_Firebug';
			bListUpdate = false;
			break;
		case 'Survivalist':
			GetUTMPC().WeapUIInfo.Perk = class'KFPerk_Survivalist';
			bListUpdate = false;
			break;
		case 'UTMB':
			GetUTMPC().bCheckingWeapSkin = false;
			Class'KF2GUIController'.Static.GetGUIController(GetUTMPC()).OpenMenu(class'UTM_OptionBoard');
			DoClose();
			break;
	}
}

function SelectedWeapListRow(KFGUI_ListItem Item, int Row, bool bRight, bool bDblClick)
{
	GetUTMPC().WeapUIInfo.WeapDef = CurWeapDef[Row];
	bPageUpdate = false;
	return;
}

function SelectedSkinListRow(KFGUI_ListItem Item, int Row, bool bRight, bool bDblClick)
{
	if(bDblClick)
	{
		GetUTMPC().SetSkinMat(CurSkinId[Row]);
		GetUTMPC().bCheckingWeapSkin = true;
		DoClose();
		return;
	}
}

function ToggleCheckBox(KFGUI_CheckBox Sender)
{
//	local CD_PlayerController CDPC;

//	CDPC = GetCDPC();

	switch (Sender.ID)
	{
		
	}
}

defaultproperties
{
//	General
	XPosition=0.18
	YPosition=0.05
	XSize=0.64
	YSize=0.9

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

	Begin Object Class=KFGUI_Button Name=Berserker
		XPosition=0.055
		YPosition=0.125
		XSize=0.14
		YSize=0.05
		ID="Berserker"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
		ButtonText=""
	End Object

	Begin Object Class=KFGUI_Button Name=Demolitionist
		XPosition=0.205
		YPosition=0.125
		XSize=0.14
		YSize=0.05
		ID="Demolitionist"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
		ButtonText=""
	End Object

	Begin Object Class=KFGUI_Button Name=Firebug
		XPosition=0.355
		YPosition=0.125
		XSize=0.14
		YSize=0.05
		ID="Firebug"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
		ButtonText=""
	End Object

	Begin Object Class=KFGUI_Button Name=Survivalist
		XPosition=0.505
		YPosition=0.125
		XSize=0.14
		YSize=0.05
		ID="Survivalist"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
		ButtonText=""
	End Object

	Begin Object Class=KFGUI_Button Name=UTMB
		XPosition=0.025
		YPosition=0.925
		XSize=0.10
		YSize=0.05
		ID="UTMB"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Components.Add(Commando)
	Components.Add(Support)
	Components.Add(FieldMedic)
	Components.Add(Gunslinger)
	Components.Add(Sharpshooter)
	Components.Add(Swat)
	Components.Add(Berserker)
	Components.Add(Demolitionist)
	Components.Add(Firebug)
	Components.Add(Survivalist)
	Components.Add(UTMB)

//	Weapon List
	Begin Object Class=KFGUI_ColumnList Name=Weap
		XPosition=0.02
		YPosition=0.25
		XSize=0.30
		YSize=0.65
		ID="Weap"
		OnSelectedRow=SelectedWeapListRow
		bCanSortColumn=false
	End Object

	Components.Add(Weap)

//	Skin Option
	Begin Object Class=KFGUI_ColumnList Name=Skin
		XPosition=0.35
		YPosition=0.25
		XSize=0.60
		YSize=0.65
		ID="Skin"
		OnSelectedRow=SelectedSkinListRow
		bCanSortColumn=false
	End Object

	Components.Add(Skin)
}

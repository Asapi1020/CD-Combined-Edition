/**
 * @file CD_RPCHandler.uc
 * @brief Handles remote procedure call functionality for CD_PlayerController.
 */
class CD_RPCHandler extends ReplicationInfo
	DependsOn(CD_Domain);

`include(CD_Log.uci)

var private CD_PlayerController CDPC;

var transient array<CDPickupInfo> SparePickups;
var transient DownloadStage SpareWeaponsDownloadStage;

public function PostBeginPlay()
{
	CDPC = CD_PlayerController(Owner);
}

public function Tick(float Delta)
{
	if(CDPC == None || CDPC.Player == None)
	{
		`cdlog("CD_RPCHandler.Tick: CDPC or Player is None, destroying CD_RPCHandler.");
		Destroy();
		return;
	}
}

private simulated function CD_PlayerController GetCDPC()
{
	if( CDPC == None )
	{
		CDPC = CD_PlayerController(GetALocalPlayerController());
	}
	
	return CDPC;
}

private reliable server simulated function CD_Survival GetCD()
{
	local CD_Survival CD;
	
	CD = CD_Survival(GetCDPC().WorldInfo.Game);
	
	if (CD == None)
	{
		`cdlog("CD_RPCHandler.GetCD: CD_Survival is None, returning None.");
		return None;
	}

	return CD;
}

public reliable server simulated function CheckPlayerStartForCurMap()
{
	local string JoinedPathNodesIndexString;
	
	JoinedPathNodesIndexString = GetCD().xMut.GetPlayerStartForCurMap();
	ReceivePathNodesIndex(JoinedPathNodesIndexString);
}

private reliable client simulated function ReceivePathNodesIndex(string JoinedPathNodesIndexString)
{
	local array<string> PathNodesIndexString;
	local KF2GUIController GUIController;
	local KFGUI_Page FoundMenu;
	local xUI_AdminMenu AdminMenu;

	PathNodesIndexString = SplitString(JoinedPathNodesIndexString);
	GUIController = GetCDPC().GetGUIController();
	FoundMenu = GUIController.FindActiveMenu('AdminMenu');
	AdminMenu = xUI_AdminMenu(FoundMenu);

	if ( AdminMenu != None )
	{
		AdminMenu.UpdatePlayerStartList(PathNodesIndexString);
		return;
	}

	`cdlog("Admin Menu is not active");
}

public reliable server simulated function GotoPathNode(int NodeIndex)
{
	local KFPathnode PathNode;

	PathNode = FindPathNodeByIndex(NodeIndex);

	if (PathNode != None)
	{
		GetCDPC().Pawn.SetLocation(PathNode.Location);
	}
}

public reliable server simulated function RequestEveryoneGotoPathNode(int NodeIndex)
{
	local KFPathnode PathNode;
	local CD_PlayerController Player;

	PathNode = FindPathNodeByIndex(NodeIndex);

	if (PathNode == None)
	{
		return;
	}

	forEach GetCDPC().WorldInfo.AllControllers(class'CD_PlayerController', Player)
	{
		Player.Pawn.SetLocation(PathNode.Location);
	}
}

private reliable server simulated function KFPathnode FindPathNodeByIndex(int NodeIndex)
{
	local KFPathnode PathNode;
	local array<string> splitNodeName;

	forEach AllActors(class'KFPathnode', PathNode)
	{
		ParseStringIntoArray(string(PathNode), splitNodeName, "_", true);

		if (splitNodeName.length > 1 &&  splitNodeName[1] == string(NodeIndex))
		{
			return PathNode;
		}
	}

	`cdlog("CD_RPCHandler.FindPathNodeByIndex: No PathNode found with index " $ NodeIndex);
	return None;
}

public reliable server simulated function GetDisableCustomStarts()
{
	local bool bDisableCustomStarts;

	bDisableCustomStarts = GetCD().xMut.DisableCustomStarts;

	ReceiveDisableCustomStarts(bDisableCustomStarts);
}

private reliable client simulated function ReceiveDisableCustomStarts(bool bDisable)
{
	local KFGUI_Page FoundMenu;
	local xUI_AdminMenu AdminMenu;

	FoundMenu = GetCDPC().GetGUIController().FindActiveMenu('AdminMenu');
	AdminMenu = xUI_AdminMenu(FoundMenu);

	if ( AdminMenu != None )
	{
		AdminMenu.ReceiveDisableCustomStarts(bDisable);
		return;
	}

	`cdlog("Admin Menu is not active");
}

public reliable server simulated function SetDisableCustomStarts(bool bDisable)
{
	GetCD().xMut.DisableCustomStarts = bDisable;
	GetCD().xMut.SaveConfig();
}

public reliable server simulated function RequestPickupInfo()
{
	local WeaponPickupRegistryInfo Registry;

	ClearSpareWeapons();

	foreach GetCD().PickupTracker.WeaponPickupRegistry(Registry)
	{
		if (Registry.OrigOwnerPRI != GetCDPC().PlayerReplicationInfo)
		{
			continue;
		}

		ReceiveInfoFromPickup(Registry.KFDP);
	}

	FlagAllPickupsReceived();
}

public reliable server simulated function ReceiveInfoFromPickup(CD_DroppedPickup Pickup, optional bool bFinishDownload = false)
{
	local CDPickupInfo Info;
	
	Info.ID = class'CD_ClassNameUtils'.static.ExtractIndexFromInstance(Pickup, "CD_DroppedPickup");
	Info.IconPath = Pickup.IconPath;
	Info.KFWClass = class<KFWeapon>(Pickup.InventoryClass);
	Info.MagazineAmmoText = Pickup.GetMagazineAmmoText();
	Info.SpareAmmoText = Pickup.GetSpareAmmoText();
	ReceivePickupInfo(Info);

	if (bFinishDownload)
	{
		FlagAllPickupsReceived();
	}
}

private reliable client simulated function ClearSpareWeapons()
{
	SparePickups.Length = 0;
	SpareWeaponsDownloadStage = DS_Starting;
}

private reliable client simulated function ReceivePickupInfo(CDPickupInfo Info)
{
	SpareWeaponsDownloadStage = DS_Downloading;
	SparePickups.AddItem(Info);
}

private reliable client simulated function FlagAllPickupsReceived()
{
	SpareWeaponsDownloadStage = DS_Downloaded;
}

public reliable client simulated function RemoveSparePickup(int PickupIndex)
{
	local int ArrayIndex;

	ArrayIndex = SparePickups.Find('ID', PickupIndex);
	
	if (ArrayIndex != INDEX_NONE)
	{
		SparePickups.Remove(ArrayIndex, 1);
	}

	FlagAllPickupsReceived();
}

public reliable server simulated function RequestSellSpareWeapon(int PickupIndex)
{
	local WeaponPickupRegistryInfo Registry;
	local CD_DroppedPickup Pickup;

	foreach GetCD().PickupTracker.WeaponPickupRegistry(Registry)
	{
		if (class'CD_ClassNameUtils'.static.ExtractIndexFromInstance(Registry.KFDP, "CD_DroppedPickup") == PickupIndex)
		{
			Pickup = Registry.KFDP;
			break;
		}

		Pickup = None;
	}

	if (Pickup == None)
	{
		`cdlog("CD_RPCHandler.RequestSellSpareWeapon: Pickup not found for index " $ PickupIndex);
		return;
	}

	SellSpareWeapon(Pickup);
}

public reliable server simulated function RequestSellAllSpareWeapons(string WeaponName)
{
	local array<WeaponPickupRegistryInfo> Registries;
	local int i;

	Registries = GetCD().PickupTracker.WeaponPickupRegistry;

	for(i = Registries.length - 1; i >= 0; i--)
	{
		if( Registries[i].OrigOwnerPRI == GetCDPC().PlayerReplicationInfo &&
			Registries[i].KFWClass.default.ItemName == WeaponName)
		{
			SellSpareWeapon(Registries[i].KFDP);
		}
	}
}

protected reliable server simulated function SellSpareWeapon(CD_DroppedPickup Pickup)
{
	local STraderItem SaleItem;

	foreach GetCDPC().GetCDGRI().TraderItems.SaleItems(SaleItem)
	{
		if (SaleItem.ClassName == Pickup.InventoryClass.name)
		{
			GetCDPC().ForceToSellWeap(SaleItem, Weapon(Pickup.Inventory));
			Pickup.Destroy();
			return;
		}
	}

	`cdlog("CD_RPCHandler.SellSpareWeapon: Item not found in owned items list for " $ Pickup.InventoryClass.name);
}

public reliable server simulated function RequestTeleportSpareWeapon(int PickupIndex)
{
	local WeaponPickupRegistryInfo Registry;
	local CD_DroppedPickup Pickup;
	local Pawn P;
	local vector Destination;

	foreach GetCD().PickupTracker.WeaponPickupRegistry(Registry)
	{
		if (class'CD_ClassNameUtils'.static.ExtractIndexFromInstance(Registry.KFDP, "CD_DroppedPickup") == PickupIndex)
		{
			Pickup = Registry.KFDP;
			break;
		}

		Pickup = None;
	}

	if (Pickup == None)
	{
		`cdlog("CD_RPCHandler.RequestSellSpareWeapon: Pickup not found for index " $ PickupIndex);
		return;
	}

	P = GetCDPC().Pawn;

	Destination = P.Location - P.GetCollisionHeight() * vect(0,0,1);
	Pickup.SetLocation(Destination);

	if (Pickup.Location != Destination)
	{
		Pickup.SetLocation(Destination); // Retry once.
	}
}

public reliable server simulated function RequestTeleportAllSpareWeapons(string WeaponName)
{
	local array<WeaponPickupRegistryInfo> Registries;
	local int i;
	local Pawn P;

	Registries = GetCD().PickupTracker.WeaponPickupRegistry;
	P = GetCDPC().Pawn;

	for(i = Registries.length - 1; i >= 0; i--)
	{
		if( Registries[i].OrigOwnerPRI == GetCDPC().PlayerReplicationInfo &&
			Registries[i].KFWClass.default.ItemName == WeaponName)
		{
			Registries[i].KFDP.SetLocation(P.Location - P.GetCollisionHeight() * vect(0,0,1));
		}
	}
}

public reliable server simulated function GetDisableCDRecordOnline()
{
	ReceiveDisableCDRecordOnline(GetCD().bDisableCDRecordOnline);
}

protected reliable client simulated function ReceiveDisableCDRecordOnline(bool bDisable)
{
	local KFGUI_Page FoundMenu;
	local xUI_AdminMenu AdminMenu;

	FoundMenu = GetCDPC().GetGUIController().FindActiveMenu('AdminMenu');
	AdminMenu = xUI_AdminMenu(FoundMenu);

	if ( AdminMenu != None )
	{
		AdminMenu.ReceiveDisableCDRecordOnline(bDisable);
		return;
	}

	`cdlog("Admin Menu Others is not active");
}

public reliable server simulated function SetDisableCDRecordOnline(bool bDisable)
{
	GetCD().bDisableCDRecordOnline = bDisable;
	GetCD().SaveConfig();
}

public reliable server simulated function GetDisableCustomPostGameMenu()
{
	ReceiveDisableCustomPostGameMenu(GetCD().bDisableCustomPostGameMenu);
}

protected reliable client simulated function ReceiveDisableCustomPostGameMenu(bool bDisable)
{
	local KFGUI_Page FoundMenu;
	local xUI_AdminMenu AdminMenu;

	FoundMenu = GetCDPC().GetGUIController().FindActiveMenu('AdminMenu');
	AdminMenu = xUI_AdminMenu(FoundMenu);

	if ( AdminMenu != None )
	{
		AdminMenu.ReceiveDisableCustomPostGameMenu(bDisable);
		return;
	}

	`cdlog("Admin Menu Others is not active");
}

public reliable server simulated function SetDisableCustomPostGameMenu(bool bDisable)
{
	GetCD().bDisableCustomPostGameMenu = bDisable;
	GetCD().SaveConfig();
}

defaultproperties
{
	bAlwaysRelevant=false
	bOnlyRelevantToOwner = true
}

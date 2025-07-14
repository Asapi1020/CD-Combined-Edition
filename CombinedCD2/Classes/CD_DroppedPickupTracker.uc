class CD_DroppedPickupTracker extends Info
	DependsOn(CD_Domain);

`include(CD_Log.uci)

var array<WeaponPickupRegistryInfo> WeaponPickupRegistry;

function PostBeginPlay()
{
	super.PostBeginPlay();
	
	SetTimer(1.0, true, nameof(PurgePickupList));
}

/** Register weapon pickup for system (or check if this was previously owned by someone else) */
function PlayerReplicationInfo RegisterDroppedPickup(CD_DroppedPickup KFDP, PlayerController DroppedBy)
{
	local int i;
	local class<KFWeapon> KFWC;

	// We check for class here because
	// dual weapons set single class
	// after this is called
	KFWC = class<KFWeapon>(KFDP.InventoryClass);
	if (class<KFWeap_DualBase>(KFWC) != None)
		KFWC = class<KFWeap_DualBase>(KFWC).default.SingleClass;

	// First check registry
	for (i = 0;i < WeaponPickupRegistry.Length;i++)
	{
		if (WeaponPickupRegistry[i].KFWClass == KFWC && WeaponPickupRegistry[i].CurrCarrier == DroppedBy)
		{
			WeaponPickupRegistry[i].KFDP = KFDP;
			WeaponPickupRegistry[i].CurrCarrier = None;
			WeaponPickupRegistry[i].bLocked = GetLockInfo(WeaponPickupRegistry[i].OrigOwnerPRI);
			// TODO?: System message
			return WeaponPickupRegistry[i].OrigOwnerPRI;
		}
	}
	
	// Add entry if none was found
	i = WeaponPickupRegistry.Length;
	WeaponPickupRegistry.Add(1);
	WeaponPickupRegistry[i].OrigOwnerPRI = DroppedBy.PlayerReplicationInfo;
	WeaponPickupRegistry[i].KFDP = KFDP;
	WeaponPickupRegistry[i].KFWClass = KFWC;
	WeaponPickupRegistry[i].bLocked = GetLockInfo(WeaponPickupRegistry[i].OrigOwnerPRI);

	CD_PlayerController(DroppedBy).ReceivePickup(KFDP, true);

	return DroppedBy.PlayerReplicationInfo;
}

function bool GetLockInfo(PlayerReplicationInfo PRI)
{
	local int index;

	index = CD_Survival(Owner).PickupSettings.Find('PRI', PRI);

	return (index != INDEX_NONE && CD_Survival(Owner).PickupSettings[index].DropLocked);
}

/** When weapon pickup is destroyed, check if this is the original owner */
function OnDroppedPickupDestroyed(CD_DroppedPickup KFDP, optional PlayerController PickedUpBy)
{
	local int Index, PickupIndex;
	local string s;

	Index = WeaponPickupRegistry.Find('KFDP', KFDP);
	
	// Shouldn't happen, but exit if so
	if (Index == INDEX_NONE)
		return;
	
	PickupIndex = class'CD_ClassNameUtils'.static.ExtractIndexFromInstance(KFDP, "CD_DroppedPickup");
	CD_PlayerController(WeaponPickupRegistry[Index].OrigOwnerPRI.Owner).RemoveSparePickup(PickupIndex);
		
	// None means that this pickup faded out
	if (PickedUpBy == None || PickedUpBy.PlayerReplicationInfo == WeaponPickupRegistry[Index].OrigOwnerPRI)
		WeaponPickupRegistry.Remove(Index, 1);
	else
	{
		WeaponPickupRegistry[Index].KFDP = None;
		WeaponPickupRegistry[Index].CurrCarrier = PickedUpBy;
		s = "["$PickedUpBy.PlayerReplicationInfo.PlayerName$"]" @ WeaponPickupRegistry[Index].OrigOwnerPRI.PlayerName$"'s" @ WeaponPickupRegistry[Index].KFWClass.default.ItemName;
		CD_Survival(Owner).BroadcastSystem(s);
	}
}

function OnUpdatePickup(CD_DroppedPickup Pickup)
{
	local int RegistryIndex, PickupID;
	local CD_PlayerController CDPC;

	RegistryIndex = WeaponPickupRegistry.Find('KFDP', Pickup);

	if (RegistryIndex == INDEX_NONE)
	{
		`cdlog("CD_DroppedPickupTracker.OnUpdatePickup: Pickup not found in registry");
		return;
	}

	CDPC = CD_PlayerController(WeaponPickupRegistry[RegistryIndex].OrigOwnerPRI.Owner);
	PickupID = class'CD_ClassNameUtils'.static.ExtractIndexFromInstance(Pickup, "CD_DroppedPickup");
	CDPC.RemoveSparePickup(PickupID);
	CDPC.ReceivePickup(Pickup, true);
}

/** Purges entries that are no longer relevant */
function PurgePickupList()
{
	local int i;
	local PlayerController PC;
	local bool bFound;

	// Iterate backwards as we might remove entries
	for (i = WeaponPickupRegistry.Length - 1;i >= 0;i--)
	{
		// Check if pickup is active
		if (WeaponPickupRegistry[i].KFDP != None || WeaponPickupRegistry[i].CurrCarrier == None)
			continue;
			
		PC = WeaponPickupRegistry[i].CurrCarrier;
		if (PC.Pawn == None || PC.Pawn.InvManager == None)
			// Player died and didn't drop this
			// weapon, so remove from registry
			WeaponPickupRegistry.Remove(i, 1);
		else
		{
			// Check current inventory as player
			// might have sold this weapon
			bFound = (PC.Pawn.InvManager.FindInventoryType(WeaponPickupRegistry[i].KFWClass) != None);
			
			// Check for dual class
			if (!bFound && WeaponPickupRegistry[i].KFWClass.default.DualClass != None)
				bFound = (PC.Pawn.InvManager.FindInventoryType(WeaponPickupRegistry[i].KFWClass.default.DualClass) != None);

			if (!bFound)
				WeaponPickupRegistry.Remove(i, 1);
		}
	}
}

/** Get dosh value for passed pickup */
function int GetSellValueFor(CD_DroppedPickup KFDP, PlayerController PC)
{
	local KFGameReplicationInfo KFGRI;
	local KFInventoryManager KFIM;
	local byte ItemIndex;
	local KFGFxObject_TraderItems.STraderItem TraderItem;
	
	// Shouldn't happen, but check anyways
	if (KFGameReplicationInfo(WorldInfo.GRI) == None || PC.Pawn == None || KFInventoryManager(PC.Pawn.InvManager) == None)
		return 0;
		
	KFGRI = KFGameReplicationInfo(WorldInfo.GRI);
	KFIM = KFInventoryManager(PC.Pawn.InvManager);

	if (!KFGRI.TraderItems.GetItemIndicesFromArche(ItemIndex, KFDP.InventoryClass.name))
		return 0;
		
	TraderItem = KFGRI.TraderItems.SaleItems[ItemIndex];
	return KFIM.GetAdjustedSellPriceFor(TraderItem);
}

function LogoutCheck(PlayerReplicationInfo PRI)
{
	local int i;

	for(i=WeaponPickupRegistry.length-1; i>=0; i--)
	{
		if(WeaponPickupRegistry[i].OrigOwnerPRI == PRI)
			WeaponPickupRegistry.Remove(i, 1);
	}
}

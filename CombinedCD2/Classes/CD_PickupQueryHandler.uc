class CD_PickupQueryHandler extends Object
	within CD_Survival;

var private CD_DroppedPickup CDDP;
var private KFWeapon Weap;
var private CD_PlayerController CDPC;
var private CD_Pawn_Human Player;
var private class<KFWeaponDefinition> WeapDefClass;

public function Initialize(Pawn OwnerPawn, Actor Pickup)
{
	CDDP = CD_DroppedPickup(Pickup);
	Weap = KFWeapon(CDDP.Inventory);
	WeapDefClass = class<KFDamageType>(Weap.class.default.InstantHitDamageTypes[3]).default.WeaponDef;

	CDPC = CD_PlayerController(OwnerPawn.Controller);
	Player = CD_Pawn_Human(OwnerPawn);
}

public function bool PickupQuery(optional bool bIgnoreDualQuery)
{
	if(CDDP == none || Weap == none || CDPC == none || Player == none || WeapDefClass == none)
	{
		return true;
	}

	return ( bIgnoreDualQuery || DualQuery() ) && LowAmmoQuery() && OthersQuery();
}

private function bool DualQuery()
{
	return !( Outer.MyKFGRI.bTraderIsOpen && CDPC.bDisableDual && Player.IsGonnaBeDual(Weap) );
}

private function bool LowAmmoQuery()
{
	return !( Outer.MyKFGRI.bWaveIsActive && IsDisableLowAmmo() && CDDP.IsLowAmmo() );
}

private function bool OthersQuery()
{
	return !( CDDP.OriginalOwner != Player.PlayerReplicationInfo && IsUnobtainableOthers() );
}

private function bool IsDisableLowAmmo()
{
	local int index;
	local PlayerReplicationInfo PRI;
	PRI = Player.PlayerReplicationinfo;

	index = Outer.PickupSettings.Find('PRI', PRI);

	if(index != INDEX_NONE)
	{
		return Outer.PickupSettings[index].DisableLowAmmo;
	}
	
	return false;
}

private function bool IsUnobtainableOthers()
{
	local bool bLocked;
	local bool bDisableOthers;
	local bool bAuthorized;
	local int registryIndex, settingIndex;
	local PlayerReplicationinfo PRI;
	PRI = Player.PlayerReplicationinfo;

	registryIndex = Outer.PickupTracker.WeaponPickupRegistry.Find('KFDP', CDDP);
	bLocked = (registryIndex != INDEX_NONE && Outer.PickupTracker.WeaponPickupRegistry[registryIndex].bLocked);

	settingIndex = Outer.PickupSettings.Find('PRI', PRI);
	bDisableOthers = (settingIndex != INDEX_NONE && Outer.PickupSettings[settingIndex].DisableOthers);

	bAuthorized = CDPC.IsAllowedWeapon(WeapDefClass, true, false);

	return (bLocked || bDisableOthers || !bAuthorized);
}
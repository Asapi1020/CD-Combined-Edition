class CD_DroppedPickup extends KFDroppedPickup;

/** Magazine and spare ammo */
var int MagazineAmmo[2];
var int SpareAmmo[2];

/** Upgrade level (also used to calculate weight) */
var byte UpgradeLevel;

/** Cached text so we don't have to re-make it every frame */
var string AmmoText, WeightText;

/** Original owner of this weapon */
var PlayerReplicationInfo OriginalOwner;

/** Cached name (used for pickup HUD) */
var string OriginalOwnerPlayerName;

/** Pickup tracker reference (used for pickup registry) */
var CD_DroppedPickupTracker PickupTracker;

replication
{
	if (bNetDirty)
		MagazineAmmo,SpareAmmo,UpgradeLevel,OriginalOwnerPlayerName;
}

/** Overridden to update weapon information */
simulated function SetPickupMesh(PrimitiveComponent NewPickupMesh)
{
	super.SetPickupMesh(NewPickupMesh);

	if (Role == ROLE_Authority)
	{
		// We wait for a little bit because dual
		// weapons call this before updating their
		// ammo counts for the dropped single
		SetTimer(0.2, false, nameof(UpdateInformation));
		
		OriginalOwner = PickupTracker.RegisterDroppedPickup(Self, PlayerController(Instigator.Controller));

		// Not in solo unless debug is enabled
		if (WorldInfo.NetMode != NM_Standalone || (CD_Survival(PickupTracker.Owner) != None))
			OriginalOwnerPlayerName = OriginalOwner.GetHumanReadableName();
	}
}

/** Override to check dropped pickup registry on destroy */
function GiveTo(Pawn P)
{
	super.GiveTo(P);
	
	// This is true if pickup was given to this player
	if (bDeleteMe)
		PickupTracker.OnDroppedPickupDestroyed(Self, PlayerController(P.Controller));
}

/** Override to remove this from dropped pickup registry */
state FadeOut
{
	simulated event BeginState(name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
		
		if (Role == ROLE_Authority)
			PickupTracker.OnDroppedPickupDestroyed(Self);
	}
}

/** Updates weapon information */
function UpdateInformation()
{
	local KFWeapon KFW;

	KFW = KFWeapon(Inventory);
	if (KFW != None)
	{
		UpgradeLevel = byte(KFW.CurrentWeaponUpgradeIndex);

		if (KFW.UsesAmmo())
		{
			MagazineAmmo[0] = KFW.AmmoCount[0];
			SpareAmmo[0] = KFW.SpareAmmoCount[0];
		}
		
		// The second check ignores all Medic weapons with recharging darts
		if (KFW.UsesSecondaryAmmo() && KFW.bCanRefillSecondaryAmmo)
		{
			// We check these because some weapons that use
			// secondary ammo don't use both (e.g. Eviscerator)
			if (KFW.MagazineCapacity[1] > 0)
				MagazineAmmo[1] = KFW.AmmoCount[1];
			
			if (KFW.SpareAmmoCapacity[1] > 0)
				SpareAmmo[1] = KFW.SpareAmmoCount[1];
		}

		CustomUpdateInfo(KFW);
	}
}

/** Custom information for weapons that need it */
function CustomUpdateInfo(KFWeapon KFW);

/** Get ammo text for this weapon */
simulated function string GetAmmoText()
{
	if (AmmoText == "")
	{
		if (MagazineAmmo[0] >= 0)
		{
			AmmoText = MagazineAmmo[0] $ "/" $ SpareAmmo[0];
			// We check all of these separately because
			// different weapons do this differently
			if (MagazineAmmo[1] >= 0 && SpareAmmo[1] >= 0)
				AmmoText @= "(" $ MagazineAmmo[1] $ "/" $ SpareAmmo[1] $ ")";
			else if (MagazineAmmo[1] >= 0)
				AmmoText @= "(" $ MagazineAmmo[1] $ ")";
			else if (SpareAmmo[1] >= 0)
				AmmoText @= "(" $ SpareAmmo[1] $ ")";
		}
		else
			AmmoText = "---"; // Same as the Flash HUD for weapons without ammo
	}
	
	return AmmoText;
}

/** Get weight text for this weapon */
simulated function string GetWeightText(Pawn P)
{
	local class<KFWeapon> KFWC;
	local Inventory Inv;
	local bool bHasSingleForDual;
	local int Weight;
	local string TempText;
	
	if (WeightText == "")
	{
		KFWC = class<KFWeapon>(InventoryClass);
		
		if (KFWC.default.DualClass != None && P != None && P.InvManager != None)
		{
			Inv = P.InvManager.FindInventoryType(KFWC);
			if (KFWeapon(Inv) != None)
				bHasSingleForDual = true;
		}
	
		if (bHasSingleForDual)
		{
			Weight = KFWC.default.DualClass.default.InventorySize +
				KFWC.default.DualClass.static.GetUpgradeWeight(Max(UpgradeLevel, KFWeapon(Inv).CurrentWeaponUpgradeIndex)) -
				KFWeapon(Inv).GetModifiedWeightValue();
		}
		else
			Weight = KFWC.default.InventorySize + KFWC.static.GetUpgradeWeight(UpgradeLevel);
	
		TempText = string(Weight);
		if (UpgradeLevel > 0)
			TempText @= "(+" $ UpgradeLevel $ ")";
		
		// We don't cache this if it has a dual class,
		// As the text will depend on what the player's
		// inventory is when looking at the weapon
		if (KFWC.default.DualClass != None)
			return TempText;
		else
			WeightText = TempText;
	}

	return WeightText;
}

simulated function SetEmptyMaterial()
{
	return;
}


defaultproperties
{
	// These defaults are used as flags for
	// rendering pickup info without ammo
	MagazineAmmo(0)=-1
	MagazineAmmo(1)=-1
	SpareAmmo(0)=-1
	SpareAmmo(1)=-1

	EmptyPickupColor=(R=0, G=0, B=1)
}
class CD_DroppedPickup extends KFDroppedPickup;

var int MagazineAmmo[2];
var int SpareAmmo[2];
var byte UpgradeLevel;
var string AmmoText, WeightText;
var PlayerReplicationInfo OriginalOwner;
var string OriginalOwnerPlayerName;
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

function RefreshGlowState()
{
	CD_Survival(WorldInfo.Game).CheckUnglowPickup(self);
}

unreliable client simulated function SwitchMaterialGlow(bool bGlow)
{
	local MaterialInstanceConstant MeshMIC;
	local LinearColor UpdateColor;

    if (MyMeshComp != None)
    {
        MeshMIC = MyMeshComp.CreateAndSetMaterialInstanceConstant(0);
        if (MeshMIC != None)
        {
            if(bGlow)
            {
				UpdateColor.G=1;
	        }
	        else
	        {
				UpdateColor.A=0;
	        }
			MeshMIC.SetVectorParameterValue('GlowColor', UpdateColor);
        }
    }
}

unreliable client simulated function SetGlowMaterial()
{
	SetPickupSkin(SkinItemId);
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

function bool IsLowAmmo()
{
	local KFWeapon KFW;
	local int MaxAmmo, CurAmmo;

	KFW = KFWeapon(Inventory);
	if(KFW != none)
	{
		//	Ignore secondory ammo
		MaxAmmo = KFW.MagazineCapacity[0] + KFW.SpareAmmoCapacity[0];
		CurAmmo = KFW.AmmoCount[0] + KFW.SpareAmmoCount[0];
		if(MaxAmmo > 4*CurAmmo) // less than 25%
			return true;
	}
	return false;
}

defaultproperties
{
	// These defaults are used as flags for
	// rendering pickup info without ammo
	MagazineAmmo(0)=-1
	MagazineAmmo(1)=-1
	SpareAmmo(0)=-1
	SpareAmmo(1)=-1
}
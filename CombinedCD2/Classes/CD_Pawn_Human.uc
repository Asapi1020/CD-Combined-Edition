class CD_Pawn_Human extends KFPawn_Human;

var array< class<Inventory> > StartingItems;

/* ==============================================================================================================================
 *  Overridden
 * ============================================================================================================================== */

simulated event PostBeginPlay()
{
    super(KFPawn).PostBeginPlay();
    SetTimer(1.0, true, 'UpdateBatteryDrainRate');
}

//	Infinite Flashlight
simulated function UpdateBatteryDrainRate(){ BatteryDrainRate = 0.f; }

/* ==============================================================================================================================
 *  Others
 * ============================================================================================================================== */

function CD_PlayerController GetCDPC()
{
    return CD_PlayerController(Controller);
}

function ModifyInventory(bool bAmmo, bool bNade, bool bArmor, int WeapTier)
{
    local KFWeapon KFW;
    local Inventory Inv;
    local int i;

    if(bAmmo)
    {
        foreach InvManager.InventoryActors(class'KFWeapon', KFW)
        {
            KFW.AmmoCount[0] = KFW.MagazineCapacity[0];
            KFW.AddAmmo(KFW.GetMaxAmmoAmount(0));
            KFW.AddSecondaryAmmo(KFW.MagazineCapacity[1]);
        }
    }

    if(bNade)
    {
        KFInventoryManager(InvManager).AddGrenades(100);
    }

    if(bArmor)
    {
        GiveMaxArmor();
    }

    if(1 < WeapTier && WeapTier <= 4)
    {
        for(Inv=InvManager.InventoryChain; Inv!=None; Inv=Inv.Inventory)
        {
            i = default.StartingItems.Find(Inv.Class);

            if(i != INDEX_NONE)
            {
                InvManager.RemoveFromInventory(Inv);
                CreateInventory(default.StartingItems[i + WeapTier-1]);
                return;
            }
        }
    }
}

function bool IsGonnaBeDual(KFWeapon Weap)
{
    local KFWeapon KFW;

    if(KFWeap_PistolBase(Weap)!=none)
    {
        foreach InvManager.InventoryActors(class'KFWeapon', KFW)
        {
            if(KFW.Class == Weap.Class || KFW.DualClass == Weap.Class)
                return true;
        }
    }

    return false;
}

unreliable client simulated function SwitchMaterialGlow(bool PickupQuery, CD_DroppedPickup CDDP)
{
    CDDP.SwitchMaterialGlow(PickupQuery);
}

defaultproperties
{
    //  Berserker
    StartingItems(0)=class'KFGameContent.KFWeap_Blunt_Crovel'
    StartingItems(1)=class'KFGameContent.KFWeap_Edged_Katana'
    StartingItems(2)=class'KFGameContent.KFWeap_Blunt_Pulverizer'
    StartingItems(3)=class'KFGameContent.KFWeap_Eviscerator'
    //  Commando
    StartingItems(4)=class'KFGameContent.KFWeap_AssaultRifle_AR15'
    StartingItems(5)=class'KFGameContent.KFWeap_AssaultRifle_Bullpup'
    StartingItems(6)=class'KFGameContent.KFWeap_AssaultRifle_AK12'
    StartingItems(7)=class'KFGameContent.KFWeap_AssaultRifle_Medic'
    //  Support
    StartingItems(8)=class'KFGameContent.KFWeap_Shotgun_MB500'
    StartingItems(9)=class'KFGameContent.KFWeap_Shotgun_HZ12'
    StartingItems(10)=class'KFGameContent.KFWeap_Shotgun_M4'
    StartingItems(11)=class'KFGameContent.KFWeap_Shotgun_AA12'
    //  Medic
    StartingItems(12)=class'KFGameContent.KFWeap_Pistol_Medic'
    StartingItems(13)=class'KFGameContent.KFWeap_SMG_Medic'
    StartingItems(14)=class'KFGameContent.KFWeap_Shotgun_Medic'
    StartingItems(15)=class'KFGameContent.KFWeap_AssaultRifle_Medic'
    //  Demo
    StartingItems(16)=class'KFGameContent.KFWeap_GrenadeLauncher_HX25'
    StartingItems(17)=class'KFGameContent.KFWeap_GrenadeLauncher_M79'
    StartingItems(18)=class'KFGameContent.KFWeap_RocketLauncher_SealSqueal'
    StartingItems(19)=class'KFGameContent.KFWeap_RocketLauncher_RPG7'
    //  Firebug
    StartingItems(20)=class'KFGameContent.KFWeap_Flame_CaulkBurn'
    StartingItems(21)=class'KFGameContent.KFWeap_Shotgun_DragonsBreath'
    StartingItems(22)=class'KFGameContent.KFWeap_Flame_Flamethrower'
    StartingItems(23)=class'KFGameContent.KFWeap_AssaultRifle_Microwave'
    //  Gunslinger
    StartingItems(24)=class'KFGameContent.KFWeap_Revolver_DualRem1858'
    StartingItems(25)=class'KFGameContent.KFWeap_Pistol_DualColt1911'
    StartingItems(26)=class'KFGameContent.KFWeap_Pistol_DualDeagle'
    StartingItems(27)=class'KFGameContent.KFWeap_Pistol_DualAF2011'
    //  Sharpshooter
    StartingItems(28)=class'KFGameContent.KFWeap_Rifle_Winchester1894'
    StartingItems(29)=class'KFGameContent.KFWeap_Rifle_CenterfireMB464'
    StartingItems(30)=class'KFGameContent.KFWeap_Rifle_M14EBR'
    StartingItems(31)=class'KFGameContent.KFWeap_AssaultRifle_FNFal'
    //  Swat
    StartingItems(32)=class'KFGameContent.KFWeap_SMG_MP7'
    StartingItems(33)=class'KFGameContent.KFWeap_SMG_MP5RAS'
    StartingItems(34)=class'KFGameContent.KFWeap_SMG_P90'
    StartingItems(35)=class'KFGameContent.KFWeap_SMG_Kriss'    
}
class UTM_Pawn_Human extends CD_Pawn_Human
    config(Game)
    hidecategories(Navigation);

var bool bConstBuff;
var int BuffLevel;

reliable server function ServerGiveMaxHealth(){ GiveMaxHealth(); }

function GiveMaxHealth()
{
    Health = HealthMax;
}

function DrawPerkHUD(Canvas C){ return; }

function AdjustDamage(out int InDamage, out Vector Momentum, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, TraceHitInfo HitInfo, Actor DamageCauser)
{
    local KFPerk MyKFPerk;
    local float TempDamage;
    local bool bHasSacrificeSkill;

    // Log
    if(bLogTakeDamage)
    {
        LogInternal(((string(self) @ string(GetFuncName())) @ "Adjusted Damage BEFORE =") @ string(InDamage));
    }
    super(KFPawn).AdjustDamage(InDamage, Momentum, InstigatedBy, HitLocation, DamageType, HitInfo, DamageCauser);
    
    /* Deleted nullifying damage during trader time here*/

    //  as same as super class
    MyKFPerk = GetPerk();
    if(MyKFPerk != none)
    {
        MyKFPerk.ModifyDamageTaken(InDamage, DamageType, InstigatedBy);
        bHasSacrificeSkill = MyKFPerk.ShouldSacrifice();
    }

    TempDamage = float(InDamage);
    
    if(((TempDamage > float(0)) && class'KFPerk_Demolitionist'.static.IsDmgTypeExplosiveResistable(DamageType)) && HasExplosiveResistance())
    {
        class'KFPerk_Demolitionist'.static.ModifyExplosiveDamage(TempDamage);
        TempDamage = ((TempDamage < 1.0) ? 1.0 : TempDamage);
    }

    TempDamage *= (GetHealingShieldModifier());
    InDamage = Round(TempDamage);
    
    if(((InDamage > 0) && Armor > 0) && DamageType.default.bArmorStops)
    {
        ShieldAbsorb(InDamage);
        // End:0x2CC
        if(InDamage <= 0)
        {
            AddHitFX(InDamage, InstigatedBy, GetHitZoneIndex(HitInfo.BoneName), HitLocation, Momentum, class<KFDamageType>(DamageType));
        }
    }
    
    if((bHasSacrificeSkill && Health >= 5) && (Health - InDamage) < 5)
    {
        Health = InDamage + 5;
        SacrificeExplode();
    }
    
    if(InstigatedBy != none)
    {
        AddTakenDamage(InstigatedBy, int(FMin(float(Health), float(InDamage))), DamageCauser, class<KFDamageType>(DamageType));
    }
    
    if(bLogTakeDamage)
    {
        LogInternal(((string(self) @ string(GetFuncName())) @ "Adjusted Damage AFTER =") @ string(InDamage));
    }
    
    if(((Controller != none) && Controller.bDemiGodMode) && InDamage >= Health)
    {
        // End:0x442
        if(Health == 1)
        {
            Health = int(float(HealthMax) * 0.250);
        }
        // End:0x46F
        if(InDamage >= Health)
        {
            InDamage = Health - 1;
        }
    }
}

function Buff(int N)
{
    ResetBuffs();
    BuffLevel = Min(4, N);
    SetTimer(0.10, true, 'GetBuffs');
}

function GetBuffs()
{

    J0x00:    // End:0x55 [Loop If]
    if(BuffLevel > 0)
    {
        bConstBuff = true;
        UpdateHealingSpeedBoost();
        UpdateHealingDamageBoost();
        UpdateHealingShield();
        bConstBuff = false;
        -- BuffLevel;
        return;
        // [Loop Continue]
        goto J0x00;
    }
    // End:0x80
    if(IsTimerActive('GetBuffs'))
    {
        ClearTimer('GetBuffs');
    }
    //return;    
}

function ResetBuffs()
{
    BuffLevel = 0;
    ResetHealingSpeedBoost();
    ResetHealingDamageBoost();
    ResetHealingShield();
    //return;    
}

simulated function UpdateHealingSpeedBoost()
{
    super.UpdateHealingSpeedBoost();
    // End:0x42
    if(bConstBuff)
    {
        // End:0x42
        if(IsTimerActive('ResetHealingSpeedBoost'))
        {
            ClearTimer('ResetHealingSpeedBoost');
        }
    }
    //return;    
}

simulated function UpdateHealingDamageBoost()
{
    super.UpdateHealingDamageBoost();
    // End:0x42
    if(bConstBuff)
    {
        // End:0x42
        if(IsTimerActive('ResetHealingDamageBoost'))
        {
            ClearTimer('ResetHealingDamageBoost');
        }
    }
    //return;    
}

simulated function UpdateHealingShield()
{
    super.UpdateHealingShield();
    
    if(bConstBuff)
    {
        // End:0x42
        if(IsTimerActive('ResetHealingShield'))
        {
            ClearTimer('ResetHealingShield');
        }
    }
}

function JudgePlayer(UTM_PlayerController OwnerPC)
{
    local KFWeapon Weap;

    if(OwnerPC.bAutoFillMag)
    {
        if(Weapon != none)
        {
            Weap = KFWeapon(Weapon);
            if(Weap != none)
                FillMag(Weap);
        }
    }

    if(OwnerPC.bAutoFillNade)
        KFInventoryManager(InvManager).AddGrenades(100);

    //  Trader Dash 
    if(Weapon != none)
    { 
        if(KFWeap_Welder(Weapon) != none)
            GroundSpeed = 364364.0f;
        else
            UpdateGroundSpeed();
    }
}

function FillMag(KFWeapon Weap)
{
    Weap.SpareAmmoCount[0] = Weap.SpareAmmoCapacity[0];
    Weap.SpareAmmoCount[1] = Weap.SpareAmmoCapacity[1];
}

defaultproperties
{
    InventoryManagerClass=class'UTM_InventoryManager'
}
class CD_Pawn_DoshDrone extends KFPawn_HRG_Warthog
	notplaceable;

var transient KFPawn_Human MateTarget;
var transient CustomWeap_DoshDrone DroneWeapon;
var Pawn OwnerPawn;

replication
{
    if( bNetDirty )
    	MateTarget;
}

simulated event PreBeginPlay()
{
	local class<KFWeapon> WeaponClass;
    local rotator ZeroRotator;

    super(KFPawn).PreBeginPlay();

    WeaponClass = class<CustomWeap_DoshDrone> (DynamicLoadObject("CombinedCD2.CustomWeap_DoshDrone", class'Class'));
    WeaponClassForAttachmentTemplate = WeaponClass;

	SetMeshVisibility(false);

    if (Role == ROLE_Authority)
    {
        Weapon = Spawn(WeaponClass, self);
        DroneWeapon = CustomWeap_DoshDrone(Weapon);
        MyKFWeapon = DroneWeapon;

        if (Weapon != none)
        {
            Weapon.bReplicateInstigator=true;
            Weapon.bReplicateMovement=true;
            Weapon.Instigator = Instigator;
            DroneWeapon.InstigatorDrone = self;
            Weapon.SetCollision(false, false);
            Weapon.SetBase(self,, TurretMesh, WeaponSocketName);
            TurretMesh.AttachComponentToSocket(Weapon.Mesh, WeaponSocketName);

            Weapon.SetRelativeLocation(vect(0,0,0));
            Weapon.SetRelativeRotation(ZeroRotator);
            Weapon.Mesh.SetOnlyOwnerSee(true);
            MyKFWeapon.Mesh.SetHidden(true);
        }
    }

	if (WorldInfo.NetMode == NM_Client || WorldInfo.NetMode == NM_Standalone)
    {
        if (WeaponClass.default.AttachmentArchetype != none)
		{
            SetTurretWeaponAttachment(WeaponClass);
        }
    }
}

simulated function UpdateWeaponUpgrade(int UpgradeIndex)
{
	return;
}

function UpdateReadyToUse(bool bReady)
{
	return;
}

simulated state Combat
{
	simulated event Tick( float DeltaTime )
    {
        local vector MuzzleLoc;
        local rotator MuzzleRot;
        local rotator DesiredRotationRot;
        local rotator NewRotationRate;

        local vector HitLocation, HitNormal;
        local TraceHitInfo HitInfo;
        local Actor HitActor;

        local float NewAmmoPercentage;

        if (Role == ROLE_Authority)
        {
            DroneWeapon.GetMuzzleLocAndRot(MuzzleLoc, MuzzleRot);
            NewAmmoPercentage = float(DroneWeapon.AmmoCount[0]) / DroneWeapon.MagazineCapacity[0];
            
            if (NewAmmoPercentage != CurrentAmmoPercentage)
            {
                CurrentAmmoPercentage = NewAmmoPercentage;

                if (WorldInfo.NetMode == NM_Standalone)
                {   
                    UpdateTurretMeshMaterialColor(CurrentAmmoPercentage);
                }
                else
                {
                    bNetDirty = true;
                }
            }
        }
        else
        {
            WeaponAttachment.WeapMesh.GetSocketWorldLocationAndRotation('MuzzleFlash', MuzzleLoc, MuzzleRot);
        }

        if (MateTarget != none)
        {
            if (Role == ROLE_Authority)
            {
                HitActor = Trace(HitLocation, HitNormal, MateTarget.Mesh.GetBoneLocation('Spine1'), MuzzleLoc,,,,TRACEFLAG_Bullet);
                
                if (!MateTarget.IsAliveAndWell()
                    || VSizeSq(MateTarget.Location - Location) > EffectiveRadius * EffectiveRadius
                    || (HitActor != none && HitActor.bWorldGeometry && KFFracturedMeshGlass(HitActor) == None))
                {
                    MateTarget = none;
                    CheckForTargets();

                    if (MateTarget == none)
                    {
                        SetTurretState(ETS_TargetSearch);
                        return;
                    }
                }
            }

            DesiredRotationRot = rotator(Normal(MateTarget.Mesh.GetBoneLocation('Spine1') - MuzzleLoc));
            DesiredRotationRot.Roll  = 0;

            RotateBySpeed(DesiredRotationRot);

            if (Role == ROLE_Authority && ReachedRotation())
            {
                HitActor = Trace(HitLocation, HitNormal, MuzzleLoc + vector(Rotation) * EffectiveRadius, MuzzleLoc, , , HitInfo, TRACEFLAG_Bullet);

                if (DroneWeapon != none && HitActor != none && HitActor.bWorldGeometry == false)
                {
                    DroneWeapon.MateTarget = MateTarget;
                    DroneWeapon.Fire();
                    
                    if (!DroneWeapon.HasAmmo(0))
                    {
                        SetTurretState(ETS_Empty);
                    }
                }
            }
        }

        RotationRate = NewRotationRate;
        if(bRotating)
        {
            UpdateRotation(DeltaTime);
        }

        super(KFPawn).Tick(DeltaTime);
    }
}

simulated state Detonate
{
	function TriggerExplosion()
    {
        
        local KFExplosionActorReplicated ExploActor;
        local int i, RandomNumber;
	    local vector StartTrace, AimDir, X, Y, Z;
	    local rotator StartAimRot;
        local Quat R;
        local float Angle, FuseTime;
        local Custom_Proj_Dosh Projectile;
        local array<float> FuseTimes;
        local GameExplosion ExplosionToUse;
        local KFPawn PawnInstigator;
        local KFPerk Perk;
        local float OriginalDamageRadiusDroneExplosion;

        // Shoot dosh around
        if( Role == ROLE_Authority || (Instigator != none && Instigator.IsLocallyControlled()) )
        {
            DroneWeapon.MateTarget = none;
            DroneWeapon.GetMuzzleLocAndRot(StartTrace, StartAimRot);
            StartAimRot.Pitch = 0.f;
            StartAimRot.Roll = 0.f;
            GetAxes(StartAimRot, X, Y, Z);
            DetonateNumberOfProjectiles += DroneWeapon.AmmoCount[0];
            Angle = 360.f / DetonateNumberOfProjectiles;
            FuseTimes = GenerateFuseTimes();

            for (i = 0; i < DetonateNumberOfProjectiles; ++i)
            {
                R = QuatFromAxisAndAngle(Z, Angle * DegToRad * i);
                AimDir = QuatRotateVector(R, vector(StartAimRot));
                AimDir.Z = 0.f;
                DroneWeapon.CurrentDistanceProjectile = DetonateMinimumDistance + Rand(DetonateMaximumDistance - DetonateMinimumDistance);
                Projectile = Custom_Proj_Dosh(DroneWeapon.SpawnProjectile(class'Custom_Proj_Dosh', StartTrace, AimDir));                
                Projectile.Instigator = Instigator;
                FuseTime = DetonateMinTime;

                if (FuseTimes.Length == 0)
                {
                    FuseTimes = GenerateFuseTimes();
                }

                if (FuseTimes.Length != 0)
                {
                    RandomNumber = Rand(FuseTimes.Length);
                    FuseTime = FuseTimes[RandomNumber];
                    FuseTimes.Remove(RandomNumber, 1);
                }

                Projectile.SetupDetonationTimer(FuseTime);
            }

            DroneWeapon.CurrentDistanceProjectile = -1.f;
        }

        // explode using the given template
        ExploActor = Spawn(class'KFExplosionActorReplicated', DroneWeapon,, Location, Rotation,, true);
        if (ExploActor != None)
        {
            ExploActor.InstigatorController = Instigator.Controller;
            ExploActor.Instigator = Instigator;
            ExploActor.bIgnoreInstigator = true;

            ExplosionToUse = PrepareExplosionTemplate();

            OriginalDamageRadiusDroneExplosion = ExplosionToUse.DamageRadius;

            PawnInstigator = KFPawn(Instigator);
            if (PawnInstigator != None)
            {
                Perk = PawnInstigator.GetPerk();
                if (Perk != None)
                {
                    ExplosionToUse.DamageRadius = OriginalDamageRadiusDroneExplosion * Perk.GetAoERadiusModifier();
                }
            }

            ExploActor.Explode(ExplosionToUse);

            // Revert to original
            ExplosionToUse.DamageRadius = OriginalDamageRadiusDroneExplosion;
        }

        //  spawn dosh effect
        if(WorldInfo.NetMode != NM_DedicatedServer)
        {
            WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'FX_Headshot_Alt_EMIT.FX_Headshot_Alt_Dosh_01', Location);
            class'KFPawn_Monster'.default.HeadShotAkComponent.PlayEvent(AkEvent'WW_Headshot_Packs.Play_WEP_Dosh_Headshot', true, true);
        }
		
        Destroy();
    }
}

function CheckForTargets()
{
    local KFPawn_Human Target;
    local TraceHitInfo HitInfo;    

    local float CurrentDistance;
    local float Distance;

    local vector MuzzleLoc;
    local rotator MuzzleRot;

	local vector HitLocation, HitNormal;
    local Actor HitActor;

    if (MateTarget != none)
    {
        CurrentDistance = VSizeSq(Location - MateTarget.Location);
    }
    else
    {
        CurrentDistance = 9999.f;
    }

    DroneWeapon.GetMuzzleLocAndRot(MuzzleLoc, MuzzleRot);
    
    foreach CollidingActors(class'KFPawn_Human', Target, EffectiveRadius, Location, true,, HitInfo)
    {
        if (!Target.IsAliveAndWell())
        {
            continue;
        }

        HitActor = Trace(HitLocation, HitNormal, Target.Mesh.GetBoneLocation('Spine1'), MuzzleLoc,,,,TRACEFLAG_Bullet);

        if (HitActor == none || (HitActor.bWorldGeometry && KFFracturedMeshGlass(HitActor) == None))
        {
            continue;
        }

        Distance = VSizeSq(Location - Target.Location);

        if (MateTarget == none)
        {
            MateTarget = Target;
            CurrentDistance = Distance;
        }
        else if (CurrentDistance > Distance)
        {
            MateTarget = Target;
            CurrentDistance = Distance;
        }
    }

    if (MateTarget != none)
    {
        SetTurretState(ETS_Combat);
    }
}

simulated event Destroyed()
{
    StopIdleSound();
    ClearTimer(nameof(CheckEnemiesWithinExplosionRadius));

    if (NoAmmoFX != none)
    {
        NoAmmoFX.KillParticlesForced();
        WorldInfo.MyEmitterPool.OnParticleSystemFinished(NoAmmoFX);
		NoAmmoFX = none;
    }

    super.Destroyed();
}

simulated function CheckEnemiesWithinExplosionRadius()
{
    local KFPawn_Human KFPH;
    local Vector CheckExplosionLocation;

    CheckExplosionLocation = Location;
    CheckExplosionLocation.z -= DeployHeight * 0.5f;

    if (CheckExplosionLocation.z < GroundLocation.z)
    {
        CheckExplosionLocation.z = GroundLocation.z;
    }

    foreach CollidingActors(class'KFPawn_Human', KFPH, ExplosiveRadius, CheckExplosionLocation, true,,)
    {
        if(KFPH != none && KFPH.IsAliveAndWell())
        {
            SetTurretState(ETS_Detonate);
            return;
        }
    }
}

defaultproperties
{
    EffectiveRadius=3000.0f
    ExplosiveRadius=1500.0f
}
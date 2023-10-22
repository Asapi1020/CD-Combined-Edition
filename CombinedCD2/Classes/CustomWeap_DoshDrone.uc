class CustomWeap_DoshDrone extends KFWeap_HRG_WarthogWeapon;

var CD_Pawn_DoshDrone InstigatorDoshDrone;
var KFPawn_Human MateTarget;

simulated state WeaponFiring
{
	simulated function EndState(Name NextStateName)
	{
		local Pawn OriginalInstigator;

		OriginalInstigator = Instigator;
		Instigator = InstigatorDoshDrone;

		super(KFWeap_GrenadeLauncher_Base).EndState(NextStateName);

		Instigator = OriginalInstigator;
	}
}

simulated function Projectile ProjectileFire()
{
	local vector RealStartLoc, AimDir, TargetLocation;
	local rotator AimRot;
	local class<KFProjectile> MyProjectileClass;

	if ( ShouldIncrementFlashCountOnFire() )
	{
		IncrementFlashCount();
	}

    MyProjectileClass = GetKFProjectileClass();

	if( Role == ROLE_Authority || (MyProjectileClass.default.bUseClientSideHitDetection
        && MyProjectileClass.default.bNoReplicationToInstigator && Instigator != none
        && Instigator.IsLocallyControlled()) )
	{
		GetMuzzleLocAndRot(RealStartLoc, AimRot);

		if (MateTarget != none)
		{
			TargetLocation = MateTarget.Location;
			TargetLocation.Z += MateTarget.GetCollisionHeight() * 0.5f;
			AimDir = Normal(TargetLocation - RealStartLoc);
		}
		else
		{
			AimDir = Vector(Owner.Rotation);
		}

		return SpawnAllProjectiles(MyProjectileClass, RealStartLoc, AimDir);
	}

	return None;
}

simulated function KFProjectile SpawnProjectile( class<KFProjectile> KFProjClass, vector RealStartLoc, vector AimDir )
{
	local KFProjectile SpawnedProjectile;
	local int ProjDamage;
	local Pawn OriginalInstigator;
	local vector TargetLocation, Distance;
	local float HorizontalDistance, TermA, TermB, TermC, InitialSpeed;

	OriginalInstigator = Instigator;
	Instigator = InstigatorDrone;
	SpawnedProjectile = Spawn( KFProjClass, self,, RealStartLoc);

	if( SpawnedProjectile != none && !SpawnedProjectile.bDeleteMe )
	{
		if (MateTarget != none)
		{
			TargetLocation = MateTarget.Location;
			TargetLocation.Z += MateTarget.GetCollisionHeight() * 0.5f;
			TargetLocation += MateTarget.Velocity * FireLookAheadSeconds;
		}
		else if (CurrentDistanceProjectile > 0.f)
		{
			TargetLocation = RealStartLoc + AimDir * CurrentDistanceProjectile;
			TargetLocation.Z -= InstigatorDrone.DeployHeight;
		}

		Distance = TargetLocation - RealStartLoc;
		Distance.Z = 0.f;
		HorizontalDistance = VSize(Distance); // 2D

		if (HorizontalDistance > DistanceParabolicLaunch
			&& RealStartLoc.Z > TargetLocation.Z)
		{
			TermA = (TargetLocation.Z - RealStartLoc.Z) / (-11.5f * 0.5f * 100.f);
			TermB = HorizontalDistance * HorizontalDistance;
			TermC = TermB / TermA;
			InitialSpeed = Sqrt(TermC);
			AimDir = Normal(Distance);
			AimDir.Z = 0.f;
		}
		else
		{
			if (RealStartLoc.Z < TargetLocation.Z)
			{
				InitialSpeed = 3000.f;
			}
			else
			{
				InitialSpeed = 1000.f;
			}
		}

		SpawnedProjectile.Speed = InitialSpeed;
		SpawnedProjectile.MaxSpeed = 0;
		SpawnedProjectile.TerminalVelocity = InitialSpeed * 2.f;
		SpawnedProjectile.TossZ = 0.f;

		if ( InstantHitDamage.Length > CurrentFireMode && InstantHitDamageTypes.Length > CurrentFireMode )
		{
            ProjDamage = GetModifiedDamage(CurrentFireMode);
            SpawnedProjectile.Damage = ProjDamage;
            SpawnedProjectile.MyDamageType = InstantHitDamageTypes[CurrentFireMode];
		}

		SpawnedProjectile.UpgradeDamageMod = GetUpgradeDamageMod();

		SpawnedProjectile.Init( AimDir );
	}

	Instigator = OriginalInstigator;

	return SpawnedProjectile;
}

defaultproperties
{
	InventorySize=0
	PackageKey="DoshDrone"
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Dosh'
	WeaponFireLoopEndSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_Doshinegun.Play_WEP_Doshinegun_Shoot_Fire_3P_EndLoop', FirstPersonCue=AkEvent'WW_WEP_Doshinegun.Play_WEP_Doshinegun_Shoot_Fire_1P_EndLoop')
	AssociatedPerkClasses(0)=none
	MateTarget=none

	FireInterval(DEFAULT_FIREMODE)=+0.2
	DistanceParabolicLaunch=300.f
}
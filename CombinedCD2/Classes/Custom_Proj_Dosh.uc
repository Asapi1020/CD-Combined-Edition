class Custom_Proj_Dosh extends KFProj_Dosh
	hidedropdown;

simulated function SetupDetonationTimer(float FuseTime)
{
	if (FuseTime > 0)
	{
		SetTimer(FuseTime, false, 'ExplodeTimer');
	}
}

function ExplodeTimer()
{
    local Actor HitActor;
    local vector HitLocation, HitNormal;

	GetExplodeEffectLocation(HitLocation, HitNormal, HitActor);
    TriggerExplosion(HitLocation, HitNormal, HitActor);
}

simulated function GetExplodeEffectLocation(out vector HitLocation, out vector HitRotation, out Actor HitActor)
{
    local vector EffectStartTrace, EffectEndTrace;
	local TraceHitInfo HitInfo;

	EffectStartTrace = Location + vect(0,0,1) * 4.f;
	EffectEndTrace = EffectStartTrace - vect(0,0,1) * 32.f;
	HitActor = Trace(HitLocation, HitRotation, EffectEndTrace, EffectStartTrace, false,, HitInfo, TRACEFLAG_Bullet);

    if( IsZero(HitLocation) )
    {
        HitLocation = Location;
    }

	if( IsZero(HitRotation) )
    {
        HitRotation = vect(0,0,1);
    }
}

function SpawnDosh(Actor BouncedOff)
{
	super.SpawnDosh(BouncedOff);

	if(WorldInfo.NetMode != NM_DedicatedServer)
	{
		WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'FX_Headshot_Alt_EMIT.FX_Headshot_Alt_Dosh_01', Location);
        class'KFPawn_Monster'.default.HeadShotAkComponent.PlayEvent(AkEvent'WW_Headshot_Packs.Play_WEP_Dosh_Headshot', true, true);
	}
}
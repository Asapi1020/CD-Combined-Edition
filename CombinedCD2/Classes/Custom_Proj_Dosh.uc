class Custom_Proj_Dosh extends KFProj_Dosh
	hidedropdown;

var transient AkEvent DoshShotEvent;
var transient string DoshShotEventPath;
var transient ParticleSystem DoshShotFX;
var transient string DoshShotFXPath;

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
		WorldInfo.MyEmitterPool.SpawnEmitter(GetDoshShotFX(), Location);
		class'KFPawn_Monster'.default.HeadShotAkComponent.PlayEvent(GetDoshShotEvent(), true, true);
	}
}

protected function ParticleSystem GetDoshShotFX()
{
    if (DoshShotFX != none)
    {
        return DoshShotFX;
    }

    DoshShotFX = ParticleSystem( class'CD_Object'.static.SafeLoadObject(DoshShotFXPath, class'ParticleSystem') );

    if (DoshShotFX == none)
    {
        `Log("CD_Pawn_DoshDrone::GetDoshShotFX: Failed to load DoshShotFX from path: " $ DoshShotFXPath);
    }

    return DoshShotFX;
}

protected function AkEvent GetDoshShotEvent()
{
    if (DoshShotEvent != none)
    {
        return DoshShotEvent;
    }

    DoshShotEvent = AkEvent( class'CD_Object'.static.SafeLoadObject(DoshShotEventPath, class'AkEvent') );

    if (DoshShotEvent == none)
    {
        `Log("CD_Pawn_DoshDrone::GetDoshShotEvent: Failed to load DoshShotEvent from path: " $ DoshShotEventPath);
    }

    return DoshShotEvent;
}

defaultproperties
{
	DoshShotEventPath="WW_Headshot_Packs.Play_WEP_Dosh_Headshot"
    DoshShotFXPath="FX_Headshot_Alt_EMIT.FX_Headshot_Alt_Dosh_01"
}

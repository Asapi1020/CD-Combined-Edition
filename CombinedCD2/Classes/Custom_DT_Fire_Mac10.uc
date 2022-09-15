class Custom_DT_Fire_Mac10 extends KFDT_Fire_Mac10
	abstract
	hidedropdown;

static function PlayImpactHitEffects(KFPawn P, vector HitLocation, vector HitDirection, byte HitZoneIndex, optional Pawn HitInstigator)
{
	super(KFDT_Ballistic_Submachinegun).PlayImpactHitEffects(P, HitLocation, HitDirection, HitZoneIndex, HitInstigator);
}

static function ApplySecondaryDamage(KFPawn Victim, int DamageTaken, optional Controller InstigatedBy)
{
	return;
}

defaultproperties
{
	BurnPower=0

	CameraLensEffectTemplate=None
	EffectGroup=FXG_Ballistic
}
class Custom_DT_Ballistic_Hemogoblin extends KFDT_Ballistic_Hemogoblin
	abstract
	hidedropdown;

static function PlayImpactHitEffects(KFPawn P, vector HitLocation, vector HitDirection, byte HitZoneIndex, optional Pawn HitInstigator)
{
	Super(KFDT_Ballistic_Rifle).PlayImpactHitEffects(P, HitLocation, HitDirection, HitZoneIndex, HitInstigator);
}

static function ApplySecondaryDamage( KFPawn Victim, int DamageTaken, optional Controller InstigatedBy )
{
	return;
}

defaultproperties
{
	BleedDamageType=none

	WeaponDef=class'CustomWeapDef_Hemogoblin'
}
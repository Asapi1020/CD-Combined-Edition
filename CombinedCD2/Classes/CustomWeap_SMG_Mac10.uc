class CustomWeap_SMG_Mac10 extends KFWeap_SMG_Mac10;

defaultproperties
{
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'Custom_DT_Fire_Mac10'
	InstantHitDamageTypes(ALTFIRE_FIREMODE)=class'Custom_DT_Fire_Mac10'

	AssociatedPerkClasses(0)=class'KFPerk_SWAT'
	AssociatedPerkClasses(1)=none
}
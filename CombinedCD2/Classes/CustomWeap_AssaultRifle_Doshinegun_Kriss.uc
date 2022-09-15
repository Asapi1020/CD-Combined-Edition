class CustomWeap_AssaultRifle_Doshinegun_Kriss extends CustomWeap_AssaultRifle_Doshinegun;

defaultproperties
{
	MagazineCapacity[0]=10000

	maxRecoilPitch=50
	minRecoilPitch=40
	maxRecoilYaw=80
	minRecoilYaw=-80
	RecoilRate=0.045
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=900
	RecoilMinPitchLimit=65035
	RecoilISMaxYawLimit=100
	RecoilISMinYawLimit=65435
	RecoilISMaxPitchLimit=375
	RecoilISMinPitchLimit=65460
	IronSightMeshFOVCompensationScale=1.85

	FireInterval(DEFAULT_FIREMODE)=+.05
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponFiring
	FireInterval(ALTFIRE_FIREMODE)=+0.2
}
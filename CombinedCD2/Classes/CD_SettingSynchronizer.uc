class CD_SettingSynchronizer extends Object
	within CD_Survival;

// Perk, skill, weapon, auth level
public function SynchSettings(CD_PlayerController CDPC)
{
	local CD_PerkInfo PerkRestriction;
	local CD_SkillInfo SkillRestriction;
	local CD_WeaponInfo WeaponRestriction;

	CDPC.ResetSettings();
	CDPC.ReceiveAuthority(Outer.AuthorityHandler.GetAuthorityLevel(CDPC));
	CDPC.GetCDPRI().AuthorityLevel = Outer.AuthorityHandler.GetAuthorityLevel(CDPC);
	CDPC.ReceiveLevelRestriction(Outer.AuthorityHandler.bRequireLv25);
	CDPC.ReceiveAntiOvercap(Outer.AuthorityHandler.bAntiOvercap);

	foreach Outer.AuthorityHandler.PerkRestrictions(PerkRestriction)
	{
		CDPC.ReceivePerkRestrictions(PerkRestriction);
	}

	foreach Outer.AuthorityHandler.SkillRestrictions(SkillRestriction)
	{
		CDPC.ReceiveSkillRestrictions(SkillRestriction);
	}

	foreach Outer.AuthorityHandler.WeaponRestrictions(WeaponRestriction)
	{
		CDPC.ReceiveWeaponRestrictions(WeaponRestriction);
	}

	CDPC.SynchFinished();
}

public function ResynchSettings()
{
	local CD_PlayerController CDPC;

    foreach Outer.WorldInfo.AllControllers(class'CD_PlayerController', CDPC)
    {
    	SynchSettings(CDPC);
    }
}

public function SendAuthList(CD_PlayerController CDPC)
{
	local int i;

	for(i=0; i<AuthorityHandler.AuthorityInfo.length; i++)
	{
		CDPC.ReceiveAuthList(AuthorityHandler.AuthorityInfo[i]);
	}
	CDPC.CompleteAuthList();
}
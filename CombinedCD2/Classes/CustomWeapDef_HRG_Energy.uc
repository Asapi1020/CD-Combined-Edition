class CustomWeapDef_HRG_Energy extends KFWeapDef_HRG_Energy
	abstract;

static function string GetItemLocalization(string KeyName)
{
	return class'CD_TraderItemsHelper'.static.GetWeaponLocalization(KeyName, default.class, class'KFGame.KFWeapDef_HRG_Energy');
}

defaultproperties
{
	WeaponClassPath="CombinedCD2.CustomWeap_HRG_Energy"
}
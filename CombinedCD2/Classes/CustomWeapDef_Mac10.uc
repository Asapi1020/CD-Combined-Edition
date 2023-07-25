class CustomWeapDef_Mac10 extends KFWeapDef_Mac10
	abstract;

static function string GetItemLocalization(string KeyName)
{
	return class'CD_TraderItemsHelper'.static.GetWeaponLocalization(KeyName, default.class, class'KFGame.KFWeapDef_Mac10');
}

defaultproperties
{
	WeaponClassPath="CombinedCD2.CustomWeap_SMG_Mac10"
}
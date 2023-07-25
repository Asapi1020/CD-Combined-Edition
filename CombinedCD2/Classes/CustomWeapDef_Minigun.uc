class CustomWeapDef_Minigun extends KFWeapDef_Minigun
	abstract;

static function string GetItemLocalization(string KeyName)
{
	return class'CD_TraderItemsHelper'.static.GetWeaponLocalization(KeyName, default.class, class'KFGame.KFWeapDef_Minigun');
}

defaultproperties
{
	WeaponClassPath="CombinedCD2.CustomWeap_Minigun"
}
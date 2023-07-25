class CustomWeapDef_Hemogoblin extends KFWeapDef_Hemogoblin
	abstract;

static function string GetItemLocalization(string KeyName)
{
	return class'CD_TraderItemsHelper'.static.GetWeaponLocalization(KeyName, default.class, class'KFGame.KFWeapDef_Hemogoblin');
}

defaultproperties
{
	WeaponClassPath="CombinedCD2.CustomWeap_Rifle_Hemogoblin"
}
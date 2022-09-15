class CustomWeapDef_ChiappaRhino extends KFWeapDef_ChiappaRhino
	abstract;

static function string GetItemLocalization(string KeyName)
{
	return class'CD_TraderItemsHelper'.static.GetWeaponLocalization(KeyName, default.class, class'KFGame.KFWeapDef_ChiappaRhino');
}
defaultproperties
{
	WeaponClassPath="CombinedCD2.CustomWeap_Pistol_ChiappaRhino"
}
class CustomWeapDef_ChiappaRhinoDual extends KFWeapDef_ChiappaRhinoDual
	abstract;

static function string GetItemLocalization(string KeyName)
{
	return class'CD_TraderItemsHelper'.static.GetWeaponLocalization(KeyName, default.class, class'KFGame.KFWeapDef_ChiappaRhinoDual');
}
defaultproperties
{
	WeaponClassPath="CombinedCD2.CustomWeap_Pistol_ChiappaRhinoDual"
}